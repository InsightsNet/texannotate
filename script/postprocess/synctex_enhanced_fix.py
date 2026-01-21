#!/usr/bin/env python3
"""
synctex_enhanced_fix.py - Enhance cross-page/cross-column MCID fixing with SyncTeX data

Integrates SyncTeX discontinuity detection with existing PDF fixing logic.

Key insight:
- SyncTeX knows which source lines appear on multiple pages/columns
- We can use this to predict where gaps in tagging will occur
- This is more accurate than purely heuristic PDF content stream analysis
"""

from pathlib import Path
from typing import Callable, Dict, List, Set, Tuple, Optional

import re

import fitz  # PyMuPDF

from ..parsing.parse_synctex import (
    parse_synctex,
    find_crosspage_lines,
    find_crosscolumn_lines,
    sp_to_pdf_points,
    SyncTeXData,
    query_by_position,
)
from .fix_crosspage_mcid import (
    parse_aux_file,
    inject_bdc_into_stream,
    detect_pages_with_untagged_text,
    FLOAT_TAG_TYPES,
    fix_orphan_emcs,
    get_layout_from_aux,
    get_page_layout,
    find_column_boundary,
    split_cross_column_tags,
    find_open_element_at_page_start,
    get_floats_starting_on_page,
)


def get_synctex_discontinuity_pages(synctex_path: Path) -> Dict[str, Set[int]]:
    """
    Get pages where discontinuities occur from SyncTeX.
    
    Returns:
        Dict with:
        - 'crosspage': set of pages where cross-page content continues
        - 'crosscolumn': set of pages with cross-column content
    """
    data = parse_synctex(synctex_path)
    crosspage = find_crosspage_lines(data)
    crosscolumn = find_crosscolumn_lines(data)
    
    # Pages where cross-page content continues (all pages except first)
    crosspage_pages = set()
    for pages in crosspage.values():
        for pg in pages[1:]:  # Skip first page (where element starts)
            crosspage_pages.add(pg)
    
    # Pages with cross-column content
    crosscolumn_pages = set()
    for (fname, line, page), positions in crosscolumn.items():
        if len(positions) > 1:  # Multiple column positions
            crosscolumn_pages.add(page)
    
    return {
        'crosspage': crosspage_pages,
        'crosscolumn': crosscolumn_pages,
    }


def get_synctex_gap_regions(
    synctex_path: Path,
    page: int
) -> List[Dict]:
    """
    Get specific regions on a page where gaps might occur due to cross-column content.
    
    Uses SyncTeX column position data to identify where text continues in a different column.
    
    Args:
        synctex_path: Path to .synctex.gz file
        page: 1-indexed page number
        
    Returns:
        List of dicts with:
        - 'source_line': source line number
        - 'column_positions': list of (x, y) positions for each column
    """
    data = parse_synctex(synctex_path)
    crosscolumn = find_crosscolumn_lines(data)
    
    regions = []
    for (fname, line, pg), positions in crosscolumn.items():
        if pg == page and len(positions) > 1:
            regions.append({
                'source_file': Path(fname).name,
                'source_line': line,
                'column_positions': positions,
            })
    
    return regions


def enhance_page_detection_with_synctex(
    aux_path: Path,
    synctex_path: Path,
    pdf_detected_pages: List[int]
) -> Dict[int, Dict]:
    """
    Enhance PDF-detected pages with SyncTeX information.
    
    For each page that has untagged text:
    1. Check if SyncTeX indicates it's a cross-page continuation
    2. Check if SyncTeX indicates cross-column content
    3. Return enhanced info for injection decisions
    
    Args:
        aux_path: Path to .aux file
        synctex_path: Path to .synctex.gz file
        pdf_detected_pages: Pages detected by PDF scan as having untagged text
        
    Returns:
        Dict mapping page -> enhancement info
    """
    synctex_disc = get_synctex_discontinuity_pages(synctex_path)
    aux_data = parse_aux_file(str(aux_path))
    
    enhanced = {}
    
    for page in pdf_detected_pages:
        info = {
            'is_crosspage': page in synctex_disc['crosspage'],
            'is_crosscolumn': page in synctex_disc['crosscolumn'],
            'column_regions': [],
        }
        
        # Get specific column regions if cross-column
        if info['is_crosscolumn']:
            info['column_regions'] = get_synctex_gap_regions(synctex_path, page)
        
        # Determine suggested tag type
        # If SyncTeX says it's cross-page, it's likely a continuation of P
        # If it's cross-column, might need multiple injections
        if info['is_crosspage']:
            info['suggested_tag'] = 'P'  # Cross-page is almost always P
            info['reason'] = 'synctex_crosspage'
        elif info['is_crosscolumn']:
            info['suggested_tag'] = 'P'
            info['reason'] = 'synctex_crosscolumn'
        else:
            info['suggested_tag'] = 'P'
            info['reason'] = 'pdf_scan'
        
        enhanced[page] = info
    
    return enhanced


def get_all_pages_needing_fix(
    aux_path: Path,
    synctex_path: Path,
    doc
) -> Dict[int, Dict]:
    """
    Get all pages that need MCID fixing, combining three detection methods:
    
    1. AUX-based: Pages with lpsb@mcid@cont records
    2. PDF-based: Pages with untagged text (content stream analysis)
    3. SyncTeX-based: Pages with known cross-page/cross-column content
    
    Args:
        aux_path: Path to .aux file
        synctex_path: Path to .synctex.gz file
        doc: PyMuPDF document
        
    Returns:
        Dict mapping page -> fix info with detection source and recommendations
    """
    # Method 1: AUX-based detection
    aux_data = parse_aux_file(str(aux_path))
    aux_pages = set()
    for cont in aux_data['continuations']:
        aux_pages.add(cont['page'])
    
    # Method 2: PDF-based detection
    pdf_pages = set(detect_pages_with_untagged_text(doc))
    
    # Method 3: SyncTeX-based detection
    synctex_disc = get_synctex_discontinuity_pages(synctex_path)
    synctex_pages = synctex_disc['crosspage'] | synctex_disc['crosscolumn']
    
    # Combine all pages
    all_pages = aux_pages | pdf_pages | synctex_pages
    
    result = {}
    for page in sorted(all_pages):
        detection_sources = []
        if page in aux_pages:
            detection_sources.append('aux')
        if page in pdf_pages:
            detection_sources.append('pdf')
        if page in synctex_disc['crosspage']:
            detection_sources.append('synctex_crosspage')
        if page in synctex_disc['crosscolumn']:
            detection_sources.append('synctex_crosscolumn')
        
        # Priority: if PDF detected untagged text, we definitely need to fix
        # SyncTeX adds confidence about what type of discontinuity it is
        needs_fix = 'pdf' in detection_sources
        
        # SyncTeX-only detection means we know there's a discontinuity,
        # but it might already be handled by LaTeX continuation records
        if not needs_fix and 'aux' not in detection_sources:
            # SyncTeX detected but not in aux and not visible in PDF
            # This might be handled correctly, or might need checking
            needs_fix = False  # Conservative: don't fix if PDF looks OK
        
        result[page] = {
            'detection_sources': detection_sources,
            'needs_fix': needs_fix,
            'is_crosspage': page in synctex_disc['crosspage'],
            'is_crosscolumn': page in synctex_disc['crosscolumn'],
        }
    
    return result


def summarize_discontinuities(
    aux_path: Path,
    synctex_path: Path,
    doc
) -> Dict:
    """
    Generate a summary of all detected discontinuities for debugging/logging.
    """
    pages_info = get_all_pages_needing_fix(aux_path, synctex_path, doc)
    synctex_disc = get_synctex_discontinuity_pages(synctex_path)
    
    return {
        'total_pages': len(doc),
        'pages_with_issues': len(pages_info),
        'crosspage_pages': sorted(synctex_disc['crosspage']),
        'crosscolumn_pages': sorted(synctex_disc['crosscolumn']),
        'pages_needing_fix': [p for p, info in pages_info.items() if info['needs_fix']],
        'detection_breakdown': {
            'aux_only': len([p for p, i in pages_info.items() if i['detection_sources'] == ['aux']]),
            'pdf_only': len([p for p, i in pages_info.items() if i['detection_sources'] == ['pdf']]),
            'synctex_only': len([p for p, i in pages_info.items() 
                               if 'synctex' in ''.join(i['detection_sources']) 
                               and 'aux' not in i['detection_sources']
                               and 'pdf' not in i['detection_sources']]),
            'multiple_sources': len([p for p, i in pages_info.items() if len(i['detection_sources']) > 1]),
        }
    }


_TM_RE = re.compile(
    r'([\d\.\-]+)\s+([\d\.\-]+)\s+([\d\.\-]+)\s+([\d\.\-]+)\s+([\d\.\-]+)\s+([\d\.\-]+)\s+Tm'
)
_TD_RE = re.compile(r'([\d\.\-]+)\s+([\d\.\-]+)\s+T[dD]')


def _extract_used_mcids_from_stream(content_stream: bytes) -> Set[int]:
    """Return the set of MCID integers already present in this content stream."""
    try:
        text = content_stream.decode("latin-1")
    except Exception:
        text = content_stream.decode("utf-8", errors="replace")
    used: Set[int] = set()
    for m in re.finditer(r"/MCID\s*(\d+)", text):
        try:
            used.add(int(m.group(1)))
        except Exception:
            continue
    return used


class _MiddleMcidAllocator:
    """
    Allocate MCIDs by picking values from the *middle* of a sorted pool.

    This is intentionally not sequential, to avoid huge out-of-range IDs and to keep
    values within the continuation MCID "band".
    """

    def __init__(self, pool_sorted: List[int], used: Set[int]):
        self._pool = pool_sorted
        self._used = used
        mid = len(pool_sorted) // 2
        self._l = mid
        self._r = mid + 1
        self._toggle = True

    def next(self) -> int:
        n = len(self._pool)
        while True:
            cand: Optional[int] = None
            if self._toggle and self._l >= 0:
                cand = self._pool[self._l]
                self._l -= 1
                self._toggle = False
            elif self._r < n:
                cand = self._pool[self._r]
                self._r += 1
                self._toggle = True
            elif self._l >= 0:
                # Exhausted right side; drain left.
                cand = self._pool[self._l]
                self._l -= 1
            elif self._r < n:
                cand = self._pool[self._r]
                self._r += 1
            else:
                break

            if cand is None:
                continue
            if cand in self._used:
                continue
            self._used.add(cand)
            return cand

        raise RuntimeError("[synctex-fix] no available MCID in continuation pool for this page")


def _split_cross_column_tags_with_allocator(
    content_stream: bytes,
    boundary_x: float,
    *,
    alloc_mcid: Callable[[], int],
    verbose: bool = False,
) -> Tuple[bytes, int]:
    """
    Variant of fix_crosspage_mcid.split_cross_column_tags() that allocates new MCIDs
    using a caller-provided allocator (instead of sequential counter).
    """
    try:
        text = content_stream.decode("latin-1")
    except Exception:
        text = content_stream.decode("utf-8", errors="replace")

    bdc_pattern = re.compile(r"/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC")
    emc_pattern = re.compile(r"\bEMC\b")
    tm_pattern = re.compile(r"([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+Tm")

    bdc_matches = list(bdc_pattern.finditer(text))
    emc_matches = list(emc_pattern.finditer(text))
    if not bdc_matches:
        return content_stream, 0

    # Pair each BDC with the next EMC (same simplistic strategy as legacy code).
    tag_regions = []
    for bdc in bdc_matches:
        tag_type = bdc.group(1)
        mcid = int(bdc.group(2))
        bdc_end = bdc.end()

        matching_emc = None
        for emc in emc_matches:
            if emc.start() > bdc_end:
                matching_emc = emc
                break
        if not matching_emc:
            continue
        tag_regions.append(
            {
                "type": tag_type,
                "mcid": mcid,
                "bdc_start": bdc.start(),
                "bdc_end": bdc_end,
                "emc_start": matching_emc.start(),
                "emc_end": matching_emc.end(),
            }
        )

    splits_needed = []
    for region in tag_regions:
        if region["type"] not in ("P", "LI", "L"):
            continue

        content = text[region["bdc_end"] : region["emc_start"]]
        tms = tm_pattern.findall(content)
        if not tms:
            continue

        x_positions = []
        for tm in tms:
            try:
                x_positions.append(float(tm[4]))
            except Exception:
                continue
        if not x_positions:
            continue

        min_x = min(x_positions)
        max_x = max(x_positions)
        if min_x < boundary_x and max_x > boundary_x:
            split_pos = None
            for tm in tm_pattern.finditer(content):
                try:
                    x = float(tm.group(5))
                except Exception:
                    continue
                if x > boundary_x:
                    split_pos = region["bdc_end"] + tm.start()
                    break
            if split_pos:
                splits_needed.append({"region": region, "split_pos": split_pos})
                if verbose:
                    print(
                        f"    Will split {region['type']} MCID {region['mcid']}: X range [{min_x:.0f}, {max_x:.0f}]"
                    )

    if not splits_needed:
        return content_stream, 0

    splits_needed.sort(key=lambda x: x["split_pos"], reverse=True)
    for split in splits_needed:
        pos = split["split_pos"]
        region = split["region"]
        tag_type = region["type"]
        new_mcid = int(alloc_mcid())
        injection = f"EMC\n/{tag_type} << /MCID {new_mcid} >> BDC\n"
        text = text[:pos] + injection + text[pos:]

    if verbose:
        print(f"    Split {len(splits_needed)} cross-column tags")
    return text.encode("latin-1"), len(splits_needed)


def _estimate_xy_from_context(context: str) -> Tuple[float, float]:
    """
    Best-effort extraction of the most recent text position (x, y) before a TEXT op.
    We prefer the last Tm, then fall back to the last Td/TD.
    """
    x, y = 0.0, 0.0
    for m in _TM_RE.finditer(context):
        try:
            x = float(m.group(5))
            y = float(m.group(6))
        except Exception:
            pass
    if x == 0.0 and y == 0.0:
        for m in _TD_RE.finditer(context):
            try:
                x = float(m.group(1))
                y = float(m.group(2))
            except Exception:
                pass
    return x, y


def _pick_synctex_source_line(
    data: SyncTeXData,
    page: int,
    x_pdf: float,
    y_pdf: float,
    page_height_pdf: float,
    target_lines: Set[Tuple[str, int]],
    tolerance: float = 20.0,
) -> Optional[Tuple[str, int]]:
    """
    Map a (page, x, y) PDF position to a (filename, line) via SyncTeX.
    Tries both y and flipped-y to be resilient across coordinate conventions.
    """
    y_candidates = [y_pdf, page_height_pdf - y_pdf]
    for tol in (tolerance, tolerance * 3.0):
        for yy in y_candidates:
            hits = query_by_position(data, page=page, x_pdf=x_pdf, y_pdf=yy, tolerance=tol)
            if not hits:
                continue
            # Prefer hits that are in our target discontinuity set for this page.
            for h in hits:
                if h in target_lines:
                    return h
            return hits[0]
    return None


def _inject_bdc_into_stream_synctex(
    content_stream: bytes,
    *,
    page_num: int,
    page_height_pdf: float,
    synctex_data: SyncTeXData,
    target_lines: Set[Tuple[str, int]],
    alloc_mcid: Callable[[], int],
    tag_type: str = "P",
    context_window: int = 2500,
) -> Tuple[bytes, bool, int]:
    """
    SyncTeX-driven injection: only inject around untagged TEXT runs that map (via SyncTeX)
    to a source line we know is cross-page/cross-column on this page.
    """
    try:
        text = content_stream.decode("latin-1")
    except Exception:
        text = content_stream.decode("utf-8", errors="replace")

    # Marker scanning (compatible with fix_crosspage_mcid).
    markers: List[Tuple[int, str, str]] = []
    for m in re.finditer(r"/(\w+)\s*<<[^>]*>>\s*BDC", text):
        markers.append((m.start(), "BDC", m.group(0)))
    for m in re.finditer(r"/Artifact\s+BMC", text):
        markers.append((m.start(), "BMC", m.group(0)))
    for m in re.finditer(r"\bEMC\b", text):
        markers.append((m.start(), "EMC", "EMC"))
    for m in re.finditer(r"\[[^\]]+\]TJ|\([^\)]+\)Tj", text):
        markers.append((m.start(), "TEXT", m.group(0)[:32]))
    markers.sort(key=lambda x: x[0])

    if not markers:
        return content_stream, False, 0

    injection_points: List[int] = []
    in_untagged_run = False
    injected_this_run = False
    run_start_pos: Optional[int] = None
    # If SyncTeX mapping fails for a run but the page is a known discontinuity page,
    # we still want to avoid leaving untagged text behind. We therefore fall back
    # to injecting at the start of that untagged run (page-scoped, not whole-doc).
    allow_page_scoped_fallback = bool(target_lines)

    level = 0
    for pos, mtype, _content in markers:
        if mtype in ("BDC", "BMC"):
            # End any pending untagged run before entering a new tag.
            if in_untagged_run and (not injected_this_run) and run_start_pos is not None and allow_page_scoped_fallback:
                injection_points.append(run_start_pos)
            level += 1
            in_untagged_run = False
            injected_this_run = False
            run_start_pos = None
            continue
        if mtype == "EMC":
            # End any pending untagged run before closing a tag.
            if in_untagged_run and (not injected_this_run) and run_start_pos is not None and allow_page_scoped_fallback:
                injection_points.append(run_start_pos)
            level = max(0, level - 1)
            in_untagged_run = False
            injected_this_run = False
            run_start_pos = None
            continue
        if mtype != "TEXT":
            continue

        if level != 0:
            continue

        # Ungtagged TEXT (nesting level 0).
        if not in_untagged_run:
            in_untagged_run = True
            injected_this_run = False
            run_start_pos = pos

        if injected_this_run:
            continue

        # Try to resolve this TEXT's source line via SyncTeX.
        ctx = text[max(0, pos - context_window) : pos]
        x_pdf, y_pdf = _estimate_xy_from_context(ctx)
        src = _pick_synctex_source_line(
            synctex_data,
            page=page_num,
            x_pdf=x_pdf,
            y_pdf=y_pdf,
            page_height_pdf=page_height_pdf,
            target_lines=target_lines,
            tolerance=20.0,
        )
        if src is None:
            continue
        if src not in target_lines:
            continue

        if run_start_pos is not None:
            injection_points.append(run_start_pos)
            injected_this_run = True

    # Stream ended while still in an untagged run: apply page-scoped fallback.
    if in_untagged_run and (not injected_this_run) and run_start_pos is not None and allow_page_scoped_fallback:
        injection_points.append(run_start_pos)

    if not injection_points:
        return content_stream, False, 0

    # For each injection point, place EMC before the next BDC/BMC (or stream end).
    injections_with_emc: List[Tuple[int, int]] = []
    for inj_pos in injection_points:
        emc_pos = None
        for p2, t2, c2 in markers:
            if p2 > inj_pos and t2 in ("BDC", "BMC"):
                emc_pos = p2
                break
        if emc_pos is None:
            emc_pos = len(text)
        injections_with_emc.append((inj_pos, emc_pos))

    # Apply all insertions from end to start to keep offsets stable, even when
    # one injection's EMC position lies after another injection.
    inserts: List[Tuple[int, int, str]] = []
    # tuple: (pos, priority, text_to_insert). Higher pos applied first.
    # priority breaks ties at same pos (larger first).
    for inj_pos, emc_pos in injections_with_emc:
        mcid = int(alloc_mcid())
        bdc = f" /{tag_type} << /MCID {mcid} >> BDC\n"
        inserts.append((inj_pos, 1, bdc))
        inserts.append((emc_pos, 0, " EMC\n"))

    for pos, _prio, ins in sorted(inserts, key=lambda x: (x[0], x[1]), reverse=True):
        text = text[:pos] + ins + text[pos:]

    return text.encode("latin-1"), True, len(injections_with_emc)


def _inject_single_bdc_into_stream_synctex(
    content_stream: bytes,
    *,
    page_num: int,
    page_height_pdf: float,
    synctex_data: SyncTeXData,
    target_lines: Set[Tuple[str, int]],
    mcid: int,
    tag_type: str = "P",
    context_window: int = 2500,
) -> Tuple[bytes, bool]:
    """
    Inject exactly ONE BDC/EMC pair using a fixed MCID.

    This is used for AUX-driven cross-page continuation: the MCID is predetermined
    by \\lpsb@mcid@cont{logical_id}{mcid}{page} and must NOT be auto-allocated.
    """
    try:
        text = content_stream.decode("latin-1")
    except Exception:
        text = content_stream.decode("utf-8", errors="replace")

    markers: List[Tuple[int, str, str]] = []
    for m in re.finditer(r"/(\w+)\s*<<[^>]*>>\s*BDC", text):
        markers.append((m.start(), "BDC", m.group(0)))
    for m in re.finditer(r"/Artifact\s+BMC", text):
        markers.append((m.start(), "BMC", m.group(0)))
    for m in re.finditer(r"\bEMC\b", text):
        markers.append((m.start(), "EMC", "EMC"))
    for m in re.finditer(r"\[[^\]]+\]TJ|\([^\)]+\)Tj", text):
        markers.append((m.start(), "TEXT", m.group(0)[:32]))
    markers.sort(key=lambda x: x[0])

    level = 0
    in_untagged_run = False
    run_start_pos: Optional[int] = None

    for pos, mtype, _content in markers:
        if mtype in ("BDC", "BMC"):
            level += 1
            in_untagged_run = False
            run_start_pos = None
            continue
        if mtype == "EMC":
            level = max(0, level - 1)
            in_untagged_run = False
            run_start_pos = None
            continue
        if mtype != "TEXT":
            continue

        if level != 0:
            continue

        if not in_untagged_run:
            in_untagged_run = True
            run_start_pos = pos

        if run_start_pos is None:
            continue

        # Map this run to a SyncTeX source line; inject only if it matches targets.
        ctx = text[max(0, pos - context_window) : pos]
        x_pdf, y_pdf = _estimate_xy_from_context(ctx)
        src = _pick_synctex_source_line(
            synctex_data,
            page=page_num,
            x_pdf=x_pdf,
            y_pdf=y_pdf,
            page_height_pdf=page_height_pdf,
            target_lines=target_lines,
            tolerance=20.0,
        )
        if src is None or src not in target_lines:
            continue

        # Find EMC insertion point: before next BDC/BMC or end of stream.
        emc_pos = None
        for p2, t2, _c2 in markers:
            if p2 > run_start_pos and t2 in ("BDC", "BMC"):
                emc_pos = p2
                break
        if emc_pos is None:
            emc_pos = len(text)

        inserts = [
            (emc_pos, 0, " EMC\n"),
            (run_start_pos, 1, f" /{tag_type} << /MCID {int(mcid)} >> BDC\n"),
        ]
        for p_ins, _prio, s_ins in sorted(inserts, key=lambda x: (x[0], x[1]), reverse=True):
            text = text[:p_ins] + s_ins + text[p_ins:]
        return text.encode("latin-1"), True

    return content_stream, False


def process_pdf_synctex(
    pdf_path: str,
    aux_path: str,
    synctex_path: str,
    output_path: Optional[str] = None,
    verbose: bool = True,
) -> str:
    """
    SyncTeX-first MCID fixer.

    This uses SyncTeX line-discontinuity detection (cross-page / cross-column on same source line)
    to decide *where* to inject tags. It does not rely on full-page heuristic injection.
    """
    pdf_p = Path(pdf_path)
    aux_p = Path(aux_path)
    syn_p = Path(synctex_path)
    if output_path is None:
        output_path = str(pdf_p.with_name(pdf_p.stem + "_fixed.pdf"))
    if not pdf_p.exists():
        raise FileNotFoundError(f"[synctex-fix] pdf not found: {pdf_p}")
    if not aux_p.exists():
        raise FileNotFoundError(f"[synctex-fix] aux not found: {aux_p}")
    if not syn_p.exists():
        raise FileNotFoundError(f"[synctex-fix] synctex not found: {syn_p}")

    syn_data = parse_synctex(syn_p)
    crosspage = find_crosspage_lines(syn_data)  # (fname,line) -> pages
    crosscolumn = find_crosscolumn_lines(syn_data)  # (fname,line,page) -> [(x,y)...]

    # Build per-page target line sets.
    crosspage_targets_by_page: Dict[int, Set[Tuple[str, int]]] = {}
    targets_by_page: Dict[int, Set[Tuple[str, int]]] = {}
    for (fname, line), pages in crosspage.items():
        if not pages:
            continue
        for pg in pages[1:]:
            crosspage_targets_by_page.setdefault(int(pg), set()).add((fname, int(line)))
            targets_by_page.setdefault(int(pg), set()).add((fname, int(line)))
    for (fname, line, pg), _pos in crosscolumn.items():
        targets_by_page.setdefault(int(pg), set()).add((fname, int(line)))

    pages_to_check = sorted(targets_by_page.keys())
    if verbose:
        print(f"[synctex-fix] target pages (from synctex): {pages_to_check}")

    doc = fitz.open(str(pdf_p))

    # Phase 0: fix orphan EMCs globally (same as legacy fixer).
    orphan_fix_count = 0
    for page_idx in range(len(doc)):
        page = doc[page_idx]
        try:
            xref = page.xref
            contents_ref = doc.xref_get_key(xref, "Contents")
            if contents_ref[0] != "xref":
                continue
            contents_xref = int(contents_ref[1].split()[0])
            stream = doc.xref_stream(contents_xref)
            if not stream:
                continue
            new_stream, removed = fix_orphan_emcs(stream, verbose=False)
            if removed > 0:
                doc.update_stream(contents_xref, new_stream)
                orphan_fix_count += removed
        except Exception:
            continue
    if verbose and orphan_fix_count:
        print(f"[synctex-fix] orphan EMCs removed: {orphan_fix_count}")

    # Phase 1: targeted injections based on synctex line mapping.
    aux_data = parse_aux_file(str(aux_p))
    injected_total = 0
    # Pool of "reasonable" MCIDs: take from AUX continuation list.
    cont_pool = sorted({int(c.get("mcid")) for c in aux_data.get("continuations", []) if "mcid" in c})
    if not cont_pool:
        raise RuntimeError("[synctex-fix] aux contains no continuation MCIDs; cannot allocate MCIDs from continuation pool")

    for page_num in pages_to_check:
        if page_num < 1 or page_num > len(doc):
            continue
        page = doc[page_num - 1]
        page_height = float(page.rect.height)

        # Content stream xref.
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        if contents_ref[0] != "xref":
            continue
        contents_xref = int(contents_ref[1].split()[0])
        stream = doc.xref_stream(contents_xref)
        if not stream:
            continue
        used_mcids = _extract_used_mcids_from_stream(stream)
        allocator = _MiddleMcidAllocator(cont_pool, used_mcids)

        # 1) Cross-page continuation (AUX MCID must be reused).
        if page_num in crosspage_targets_by_page:
            open_elem = find_open_element_at_page_start(aux_data, page_num)
            if open_elem:
                cont_tag_type = open_elem.get("type", "P")
                cont_mcid = int(open_elem.get("mcid"))
                # If floats start on this page, continuation after floats is almost always a paragraph.
                floats_here = get_floats_starting_on_page(aux_data, page_num)
                if floats_here and cont_tag_type in ("H1", "H2", "H3", "H4", "H5", "H6", "Reference", "LI", "BibEntry"):
                    cont_tag_type = "P"

                new_stream, ok = _inject_single_bdc_into_stream_synctex(
                    stream,
                    page_num=page_num,
                    page_height_pdf=page_height,
                    synctex_data=syn_data,
                    target_lines=crosspage_targets_by_page.get(page_num, set()),
                    mcid=cont_mcid,
                    tag_type=cont_tag_type,
                )
                if ok:
                    doc.update_stream(contents_xref, new_stream)
                    injected_total += 1
                    if verbose:
                        print(f"[synctex-fix] page {page_num}: injected continuation /{cont_tag_type} MCID {cont_mcid}")
                    continue

        # 2) Other discontinuity-driven untagged text (use unique MCIDs).
        tag_type = "P"
        new_stream, ok, n = _inject_bdc_into_stream_synctex(
            stream,
            page_num=page_num,
            page_height_pdf=page_height,
            synctex_data=syn_data,
            target_lines=targets_by_page.get(page_num, set()),
            alloc_mcid=allocator.next,
            tag_type=tag_type,
        )
        if ok:
            doc.update_stream(contents_xref, new_stream)
            injected_total += n
            if verbose:
                print(f"[synctex-fix] page {page_num}: injected {n} tags (mcid from continuation pool)")

    # Phase 2: two-column splitting (only on pages SyncTeX says have cross-column lines).
    base_layout, layout_switches = get_layout_from_aux(str(aux_p))
    split_total = 0
    crosscolumn_pages = sorted({int(pg) for (_f, _l, pg) in crosscolumn.keys()})
    for page_num in crosscolumn_pages:
        if page_num < 1 or page_num > len(doc):
            continue
        if base_layout:
            if get_page_layout(page_num, base_layout, layout_switches) != "twocolumn":
                continue

        page_idx = page_num - 1
        boundary_x = find_column_boundary(doc, page_idx)
        if boundary_x is None:
            boundary_x = doc[page_idx].rect.width / 2.0

        page = doc[page_idx]
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        if contents_ref[0] != "xref":
            continue
        contents_xref = int(contents_ref[1].split()[0])
        stream = doc.xref_stream(contents_xref)
        if not stream:
            continue

        used_mcids = _extract_used_mcids_from_stream(stream)
        allocator = _MiddleMcidAllocator(cont_pool, used_mcids)
        new_stream, nsplit = _split_cross_column_tags_with_allocator(
            stream, boundary_x, alloc_mcid=allocator.next, verbose=bool(verbose)
        )
        if nsplit > 0:
            doc.update_stream(contents_xref, new_stream)
            split_total += nsplit

    doc.save(str(output_path))
    doc.close()

    if verbose:
        print(f"[synctex-fix] injected {injected_total}, split {split_total}, saved: {output_path}")
    return str(output_path)
