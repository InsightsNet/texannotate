#!/usr/bin/env python3
"""
fix_crosspage_mcid.py - SyncTeX-based cross-page/cross-column MCID fixing

This script uses SyncTeX data to precisely identify where content spans pages
or columns, then injects appropriate BDC markers with dynamically allocated MCIDs.

Key improvements over heuristic approach:
1. SyncTeX knows exactly which source lines appear on multiple pages/columns
2. No guessing based on PDF content stream scanning
3. Dynamic MCID allocation - no dependency on LaTeX pre-allocation
"""

import fitz
import re
import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Tuple, Optional, Set

from ..parsing.parse_synctex import (
    parse_synctex,
    find_crosspage_lines,
    find_crosscolumn_lines,
    sp_to_pdf_points,
    SyncTeXData,
)
from ..parsing.parse_lpsb_mcid import parse_aux_file

# Tag types that represent floats (should not receive cross-page continuation)
FLOAT_TAG_TYPES = {'Figure', 'Table', 'Algorithm'}


# =============================================================================
# MCID Allocator
# =============================================================================

class MCIDAllocator:
    """Dynamically allocate MCIDs for injected tags.

    Strategy: Start from a high base (e.g., 10000) to avoid collision
    with LaTeX-assigned MCIDs (which typically start from 0).
    """

    def __init__(self, base: int = 10000):
        self._next = base
        self._used: Set[int] = set()

    def set_used(self, mcids: Set[int]):
        """Mark MCIDs as already used (from PDF scan)."""
        self._used = mcids
        # Ensure our base doesn't collide
        if mcids:
            self._next = max(max(mcids) + 1, self._next)

    def allocate(self) -> int:
        """Allocate next available MCID."""
        while self._next in self._used:
            self._next += 1
        mcid = self._next
        self._used.add(mcid)
        self._next += 1
        return mcid


# =============================================================================
# SyncTeX Discontinuity Detection
# =============================================================================

def get_synctex_discontinuities(synctex_path: Path) -> Dict[str, Dict]:
    """Analyze SyncTeX data for cross-page and cross-column discontinuities.

    Returns:
        Dict with:
        - 'crosspage': {(filename, line): [page1, page2, ...]}
        - 'crosscolumn': {(filename, line, page): [(x1,y1), (x2,y2), ...]}
        - 'crosspage_pages': set of pages where cross-page content continues
        - 'crosscolumn_pages': set of pages with cross-column content
    """
    data = parse_synctex(synctex_path)
    crosspage = find_crosspage_lines(data)
    crosscolumn = find_crosscolumn_lines(data)

    # Pages where cross-page content continues (all pages except first for each line)
    crosspage_pages = set()
    for pages in crosspage.values():
        for pg in pages[1:]:
            crosspage_pages.add(pg)

    # Pages with cross-column content
    crosscolumn_pages = set()
    for (fname, line, page), positions in crosscolumn.items():
        if len(positions) > 1:
            crosscolumn_pages.add(page)

    return {
        'crosspage': crosspage,
        'crosscolumn': crosscolumn,
        'crosspage_pages': crosspage_pages,
        'crosscolumn_pages': crosscolumn_pages,
        'synctex_data': data,
    }


def get_target_lines_for_page(
    discontinuities: Dict,
    page: int
) -> Set[Tuple[str, int]]:
    """Get (filename, line) pairs that have discontinuities on this page."""
    targets = set()

    # Cross-page: lines that continue onto this page
    for (fname, line), pages in discontinuities['crosspage'].items():
        if page in pages[1:]:  # Skip first page (where element starts)
            targets.add((fname, line))

    # Cross-column: lines that span columns on this page
    for (fname, line, pg), positions in discontinuities['crosscolumn'].items():
        if pg == page and len(positions) > 1:
            targets.add((fname, line))

    return targets


# =============================================================================
# PDF Content Stream Analysis
# =============================================================================

def extract_used_mcids(content_stream: bytes) -> Set[int]:
    """Extract all MCID values already present in a content stream."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    mcids = set()
    for m in re.finditer(r'/MCID\s*(\d+)', text):
        mcids.add(int(m.group(1)))
    return mcids


def parse_stream_markers(text: str) -> List[Tuple[int, int, str, Optional[str], Optional[int]]]:
    """Parse content stream markers.

    Returns list of (start, end, type, tag_type, mcid) tuples.
    """
    markers = []

    # BDC with MCID
    for m in re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text):
        markers.append((m.start(), m.end(), 'BDC', m.group(1), int(m.group(2))))

    # Artifact BMC
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), m.end(), 'BMC', 'Artifact', None))

    # EMC
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), m.end(), 'EMC', None, None))

    # Text operations
    for m in re.finditer(r'\[[^\]]+\]TJ|\([^)]+\)Tj', text):
        markers.append((m.start(), m.end(), 'TEXT', None, None))

    markers.sort(key=lambda x: x[0])
    return markers


def find_untagged_text_regions(text: str) -> List[Tuple[int, int]]:
    """Find regions of untagged text (TEXT at nesting level 0).

    Returns list of (start_pos, end_pos) for each untagged run.
    """
    markers = parse_stream_markers(text)

    level = 0
    untagged_regions = []
    current_run_start = None
    current_run_end = None

    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
            # End current untagged run
            if current_run_start is not None:
                untagged_regions.append((current_run_start, current_run_end))
                current_run_start = None
            level += 1
        elif mtype == 'EMC':
            if current_run_start is not None:
                untagged_regions.append((current_run_start, current_run_end))
                current_run_start = None
            level = max(0, level - 1)
        elif mtype == 'TEXT':
            if level == 0:
                # Untagged text
                if current_run_start is None:
                    current_run_start = start
                current_run_end = end

    # Handle run at end of stream
    if current_run_start is not None:
        untagged_regions.append((current_run_start, current_run_end))

    return untagged_regions


def get_text_position_from_context(text: str, pos: int, context_window: int = 2000) -> Tuple[float, float]:
    """Extract text matrix position (x, y) from content stream context before pos."""
    context = text[max(0, pos - context_window):pos]

    x, y = 0.0, 0.0

    # Try Tm (text matrix)
    for m in re.finditer(r'([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+Tm', context):
        try:
            x = float(m.group(5))
            y = float(m.group(6))
        except:
            pass

    # Fallback: Td/TD
    if x == 0.0 and y == 0.0:
        for m in re.finditer(r'([\d.\-]+)\s+([\d.\-]+)\s+T[dD]', context):
            try:
                x = float(m.group(1))
                y = float(m.group(2))
            except:
                pass

    return x, y


# =============================================================================
# SyncTeX Position Matching
# =============================================================================

def match_position_to_source(
    synctex_data: SyncTeXData,
    page: int,
    x_pdf: float,
    y_pdf: float,
    page_height: float,
    tolerance: float = 25.0
) -> Optional[Tuple[str, int]]:
    """Match PDF position to source (filename, line) via SyncTeX.

    Tries both y and flipped-y for coordinate convention resilience.
    """
    # Build lookup for this page
    candidates = []
    for rec in synctex_data.records:
        if rec.page != page:
            continue
        filename = synctex_data.files.get(rec.file_id, '')
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue

        sx = sp_to_pdf_points(rec.x)
        sy_bottom = sp_to_pdf_points(rec.y)
        sy_top = page_height - sy_bottom

        # Try both Y conventions
        for sy in [sy_top, sy_bottom]:
            dist = ((sx - x_pdf)**2 + (sy - y_pdf)**2)**0.5
            if dist <= tolerance:
                candidates.append((dist, filename, rec.line))

    if candidates:
        candidates.sort(key=lambda x: x[0])
        return (candidates[0][1], candidates[0][2])

    return None


# =============================================================================
# BDC Injection
# =============================================================================

def inject_bdc_for_untagged_regions(
    content_stream: bytes,
    page_num: int,
    page_height: float,
    synctex_data: SyncTeXData,
    target_lines: Set[Tuple[str, int]],
    allocator: MCIDAllocator,
    tag_type: str = 'P',
    verbose: bool = False
) -> Tuple[bytes, int, List[Dict]]:
    """Inject BDC/EMC pairs for untagged text regions that match SyncTeX targets.

    Returns (new_stream, injection_count)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    # Find untagged regions
    untagged = find_untagged_text_regions(text)
    if not untagged:
        return content_stream, 0, []

    # For each untagged region, check if it matches a target source line
    injections = []  # (bdc_pos, emc_pos, source)

    for start_pos, end_pos in untagged:
        # Get text position from content stream
        x_pdf, y_pdf = get_text_position_from_context(text, start_pos)

        # Match to source line
        source = match_position_to_source(
            synctex_data, page_num, x_pdf, y_pdf, page_height
        )

        if source is None:
            continue

        # Check if this source line is in our targets
        # Normalize filename for comparison
        fname = Path(source[0]).name if source[0] else ''
        for target_fname, target_line in target_lines:
            target_base = Path(target_fname).name if target_fname else ''
            if target_base == fname and target_line == source[1]:
                injections.append((start_pos, end_pos, source))
                if verbose:
                    print(f"    Page {page_num}: matched untagged text at ({x_pdf:.0f}, {y_pdf:.0f}) to {fname}:{source[1]}")
                break

    if not injections:
        # Fallback: if we have target lines but no matches, inject anyway for safety
        # This handles cases where SyncTeX coordinate matching isn't precise
        if target_lines and untagged:
            start_pos, end_pos = untagged[0]
            injections.append((start_pos, end_pos, None))
            if verbose:
                print(f"    Page {page_num}: fallback injection for first untagged region")

    if not injections:
        return content_stream, 0

    # Find EMC positions (before next BDC/BMC or end of stream)
    markers = parse_stream_markers(text)

    insert_ops = []  # (pos, priority, text) - higher priority applied first at same pos

    injected_info: List[Dict] = []
    for bdc_pos, _, source in injections:
        mcid = allocator.allocate()

        # Find where to insert EMC
        emc_pos = len(text)
        for m_start, m_end, m_type, _, _ in markers:
            if m_start > bdc_pos and m_type in ('BDC', 'BMC'):
                emc_pos = m_start
                break

        insert_ops.append((bdc_pos, 1, f'/{tag_type} << /MCID {mcid} >> BDC\n'))
        insert_ops.append((emc_pos, 0, ' EMC\n'))
        injected_info.append(
            {
                "mcid": mcid,
                "page": page_num,
                "source": source,  # (filename, line) or None
            }
        )

    # Apply insertions from end to start
    insert_ops.sort(key=lambda x: (x[0], x[1]), reverse=True)
    for pos, _, ins_text in insert_ops:
        text = text[:pos] + ins_text + text[pos:]

    return text.encode('latin-1'), len(injections), injected_info


def fix_orphan_emcs(content_stream: bytes, verbose: bool = False) -> Tuple[bytes, int]:
    """Remove orphan EMC markers that have no matching BDC."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    markers = parse_stream_markers(text)

    level = 0
    orphans = []

    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
            level += 1
        elif mtype == 'EMC':
            if level > 0:
                level -= 1
            else:
                orphans.append((start, end))

    if not orphans:
        return content_stream, 0

    # Remove from end to start
    orphans.sort(reverse=True)
    for start, end in orphans:
        text = text[:start] + ' ' * (end - start) + text[end:]

    if verbose:
        print(f"  Removed {len(orphans)} orphan EMC markers")

    return text.encode('latin-1'), len(orphans)


def split_cross_column_tags(
    content_stream: bytes,
    boundary_x: float,
    allocator: MCIDAllocator,
    verbose: bool = False
) -> Tuple[bytes, int, List[Tuple[int, int]]]:
    """Split tags that span both columns at the column boundary."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    bdc_pattern = re.compile(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC')
    emc_pattern = re.compile(r'\bEMC\b')
    tm_pattern = re.compile(r'([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+Tm')

    bdc_matches = list(bdc_pattern.finditer(text))
    emc_matches = list(emc_pattern.finditer(text))

    if not bdc_matches:
        return content_stream, 0, []

    # Match BDCs with EMCs
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

        if matching_emc:
            tag_regions.append({
                'type': tag_type,
                'mcid': mcid,
                'bdc_end': bdc_end,
                'emc_start': matching_emc.start(),
            })

    # Find tags that span both columns
    splits_needed = []
    for region in tag_regions:
        if region['type'] not in ('P', 'LI', 'L'):
            continue

        content = text[region['bdc_end']:region['emc_start']]
        tms = tm_pattern.findall(content)
        if not tms:
            continue

        x_positions = [float(tm[4]) for tm in tms]
        min_x, max_x = min(x_positions), max(x_positions)

        if min_x < boundary_x and max_x > boundary_x:
            # Find split position
            for tm in tm_pattern.finditer(content):
                x = float(tm.group(5))
                if x > boundary_x:
                    split_pos = region['bdc_end'] + tm.start()
                    splits_needed.append({
                        'region': region,
                        'split_pos': split_pos,
                    })
                    break

    if not splits_needed:
        return content_stream, 0, []

    # Apply splits from end to start
    splits_needed.sort(key=lambda x: x['split_pos'], reverse=True)

    split_info: List[Tuple[int, int]] = []
    for split in splits_needed:
        pos = split['split_pos']
        tag_type = split['region']['type']
        orig_mcid = int(split['region']['mcid'])
        new_mcid = allocator.allocate()
        injection = f'EMC\n/{tag_type} << /MCID {new_mcid} >> BDC\n'
        text = text[:pos] + injection + text[pos:]
        split_info.append((orig_mcid, new_mcid))

    if verbose:
        print(f"  Split {len(splits_needed)} cross-column tags")

    return text.encode('latin-1'), len(splits_needed), split_info


# =============================================================================
# Layout Detection
# =============================================================================

def detect_two_column_layout(doc, page_idx: int) -> bool:
    """Detect if a page uses two-column layout."""
    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2
    margin = width * 0.1

    blocks = page.get_text('dict')['blocks']
    text_x_positions = []

    for b in blocks:
        if 'lines' in b:
            text_x_positions.append(b['bbox'][0])

    if len(text_x_positions) < 4:
        return False

    left_count = sum(1 for x in text_x_positions if x < mid_x - margin)
    right_count = sum(1 for x in text_x_positions if x > mid_x + margin)

    return left_count >= 2 and right_count >= 2


def find_column_boundary(doc, page_idx: int) -> Optional[float]:
    """Find X coordinate dividing left and right columns."""
    if not detect_two_column_layout(doc, page_idx):
        return None

    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2

    # Simple approach: use page center
    return mid_x


# =============================================================================
# Main Processing
# =============================================================================

def process_pdf_synctex(
    pdf_path: str,
    aux_path: str,
    synctex_path: str,
    output_path: Optional[str] = None,
    verbose: bool = True
) -> str:
    """Process PDF using SyncTeX for precise cross-page/cross-column fixing.

    Args:
        pdf_path: Input PDF path
        aux_path: AUX file path (updated with injected/split MCID continuations)
        synctex_path: SyncTeX file path
        output_path: Output PDF path (default: input_fixed.pdf)
        verbose: Print progress

    Returns:
        Output PDF path
    """
    pdf_p = Path(pdf_path)
    syn_p = Path(synctex_path)

    if output_path is None:
        output_path = str(pdf_p.with_name(pdf_p.stem + '_fixed.pdf'))

    if not pdf_p.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_p}")
    if not syn_p.exists():
        raise FileNotFoundError(f"SyncTeX not found: {syn_p}")

    # Analyze SyncTeX discontinuities
    disc = get_synctex_discontinuities(syn_p)
    synctex_data = disc['synctex_data']

    pages_to_process = disc['crosspage_pages'] | disc['crosscolumn_pages']

    if verbose:
        print(f"[synctex-fix] Cross-page pages: {sorted(disc['crosspage_pages'])}")
        print(f"[synctex-fix] Cross-column pages: {sorted(disc['crosscolumn_pages'])}")

    doc = fitz.open(str(pdf_p))
    allocator = MCIDAllocator(base=10000)

    total_injections = 0
    total_splits = 0
    total_orphans = 0
    injected_records: List[Dict] = []
    split_records: List[Tuple[int, int, int]] = []  # (orig_mcid, new_mcid, page)

    for page_num in sorted(pages_to_process):
        if page_num < 1 or page_num > len(doc):
            continue

        page = doc[page_num - 1]
        page_height = float(page.rect.height)

        # Get content stream
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        if contents_ref[0] != 'xref':
            continue
        contents_xref = int(contents_ref[1].split()[0])
        stream = doc.xref_stream(contents_xref)
        if not stream:
            continue

        # Update allocator with existing MCIDs
        allocator.set_used(extract_used_mcids(stream))

        # Phase 1: Fix orphan EMCs
        stream, n_orphans = fix_orphan_emcs(stream, verbose=False)
        total_orphans += n_orphans

        # Phase 2: Get target lines for this page
        target_lines = get_target_lines_for_page(disc, page_num)

        # Phase 3: Inject BDC for untagged regions
        stream, n_inject, injected_info = inject_bdc_for_untagged_regions(
            stream, page_num, page_height,
            synctex_data, target_lines, allocator,
            tag_type='P', verbose=verbose
        )
        total_injections += n_inject
        if injected_info:
            injected_records.extend(injected_info)

        # Phase 4: Split cross-column tags
        if page_num in disc['crosscolumn_pages']:
            boundary = find_column_boundary(doc, page_num - 1)
            if boundary:
                stream, n_split, split_info = split_cross_column_tags(
                    stream, boundary, allocator, verbose=verbose
                )
                total_splits += n_split
                for orig_mcid, new_mcid in split_info:
                    split_records.append((orig_mcid, new_mcid, page_num))

        # Update stream
        doc.update_stream(contents_xref, stream)

    doc.save(str(output_path))
    doc.close()

    # Update aux with injected/split MCIDs so StructTree can map them.
    try:
        elements, _summary = parse_aux_file(Path(aux_path))
        mcid_to_elem: Dict[int, int] = {}
        line_to_elem: Dict[int, List[int]] = {}
        elem_meta: Dict[int, Dict] = {}

        for e in elements:
            elem_id = int(e.elem_id)
            elem_meta[elem_id] = {
                "tag": getattr(e, "tag_type", ""),
                "start_page": int(getattr(e, "start_page", 0) or 0),
                "is_atom": bool(getattr(e, "is_atom", False)),
                "source_line": int(getattr(e, "source_line", 0) or 0),
                "pages": {int(m.page) for m in getattr(e, "mcids", [])},
            }
            for m in getattr(e, "mcids", []):
                mcid_to_elem[int(m.mcid)] = elem_id
            src_line = elem_meta[elem_id]["source_line"]
            if src_line > 0:
                line_to_elem.setdefault(src_line, []).append(elem_id)

        def pick_elem_for_line(line: int, page: int) -> Optional[int]:
            cands = line_to_elem.get(line, [])
            if not cands:
                return None
            # Prefer non-atom, non-float, and elements that started earlier.
            for eid in cands:
                meta = elem_meta.get(eid, {})
                if meta.get("is_atom"):
                    continue
                if meta.get("tag") in FLOAT_TAG_TYPES:
                    continue
                start_page = int(meta.get("start_page") or 0)
                if start_page > 0 and start_page <= page:
                    return eid
            # Fallback: first candidate
            return cands[0]

        aux_lines = Path(aux_path).read_text(errors="replace").splitlines(keepends=True)
        appended = 0
        existing = set()
        for e in elements:
            for m in getattr(e, "mcids", []):
                existing.add((int(e.elem_id), int(m.mcid), int(m.page)))

        for rec in injected_records:
            src = rec.get("source")
            if not src:
                continue
            _fname, line = src
            page = int(rec.get("page") or 0)
            mcid = int(rec.get("mcid"))
            eid = pick_elem_for_line(int(line), page)
            if eid is None:
                continue
            if (eid, mcid, page) in existing:
                continue
            aux_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{mcid}}}{{{page}}}\n")
            existing.add((eid, mcid, page))
            appended += 1

        for orig_mcid, new_mcid, page in split_records:
            eid = mcid_to_elem.get(int(orig_mcid))
            if eid is None:
                continue
            if (eid, int(new_mcid), int(page)) in existing:
                continue
            aux_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{int(new_mcid)}}}{{{int(page)}}}\n")
            existing.add((eid, int(new_mcid), int(page)))
            appended += 1

        if appended:
            Path(aux_path).write_text("".join(aux_lines))
            if verbose:
                print(f"[synctex-fix] Aux updated: +{appended} continuations")
    except Exception as e:
        if verbose:
            print(f"[synctex-fix] WARN: failed to update aux: {e}")

    if verbose:
        print(f"[synctex-fix] Injections: {total_injections}, Splits: {total_splits}, Orphans removed: {total_orphans}")
        print(f"[synctex-fix] Saved: {output_path}")

    return str(output_path)


def main():
    """CLI entry point."""
    parser = argparse.ArgumentParser(
        description='Fix cross-page/cross-column MCID issues using SyncTeX'
    )
    parser.add_argument('pdf', help='Input PDF file')
    parser.add_argument('--aux', required=True, help='AUX file')
    parser.add_argument('--synctex', required=True, help='SyncTeX file (.synctex.gz)')
    parser.add_argument('-o', '--output', help='Output PDF (default: input_fixed.pdf)')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')

    args = parser.parse_args()

    try:
        output = process_pdf_synctex(
            args.pdf, args.aux, args.synctex,
            output_path=args.output,
            verbose=args.verbose
        )
        print(f"Success: {output}")
        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1


if __name__ == '__main__':
    exit(main())
