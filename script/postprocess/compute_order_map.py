#!/usr/bin/env python3
"""
compute_order_map.py - Compute a stable reading-order map for LPSB elements.

Unified Approach (SyncTeX-primary):
  The reading order is computed using SyncTeX source line numbers as the PRIMARY
  sorting key, with column position detection as a SECONDARY key for two-column
  layouts. This ensures:
  
  1. Elements are ordered by their source code line numbers (author's writing order)
  2. Within the same source line, left column content comes before right column
  3. Fallback to geometric heuristics only when SyncTeX data is unavailable

Algorithm:
  - Sort by: (file_id, source_line, page, column, y, x)
  - SyncTeX provides file:line mapping for each PDF position
  - Column detection uses page width center or detected gutter
"""


import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import pdfplumber
import fitz  # PyMuPDF

# Import aux parser:
# - Prefer package import (`script.parsing...`) to avoid third-party name collisions.
# - When executed as a file (not `python -m`), ensure repo root is on sys.path.
try:
    from script.parsing.parse_lpsb_mcid import parse_aux_file  # type: ignore
    from script.parsing.parse_synctex import parse_synctex, sp_to_pdf_points, SyncTeXData  # type: ignore
except Exception:
    import sys

    # .../LPSB/script/postprocess/compute_order_map.py -> repo root is parents[2]
    repo_root = Path(__file__).resolve().parents[2]
    sys.path.insert(0, str(repo_root))
    from script.parsing.parse_lpsb_mcid import parse_aux_file  # type: ignore
    from script.parsing.parse_synctex import parse_synctex, sp_to_pdf_points, SyncTeXData  # type: ignore


@dataclass
class LayoutInfo:
    base: Optional[str]
    switches: Dict[int, str]  # page -> mode


def _get_layout_from_aux(aux_path: Path) -> LayoutInfo:
    base = None
    switches: Dict[int, str] = {}
    try:
        content = aux_path.read_text(errors="replace")
    except Exception:
        return LayoutInfo(base=None, switches={})

    m = re.search(r"\\lpsb@layout\{(\w+)\}", content)
    if m:
        base = m.group(1)

    for mm in re.finditer(r"\\lpsb@layout@switch\{(\w+)\}\{(\d+)\}", content):
        try:
            mode = mm.group(1)
            page = int(mm.group(2))
        except Exception:
            continue
        switches[page] = mode

    return LayoutInfo(base=base, switches=switches)


def _page_layout(page_num: int, layout: LayoutInfo) -> str:
    # Default to onecolumn if unknown; we only need this for ordering heuristics.
    mode = layout.base or "onecolumn"
    for p in sorted(layout.switches.keys()):
        if p <= page_num:
            mode = layout.switches[p]
        else:
            break
    return mode


def _detect_column_boundary(doc: fitz.Document, page_idx0: int) -> Optional[float]:
    """Return a boundary X between left/right columns, or None if not confidently two-column."""
    try:
        page = doc[page_idx0]
    except Exception:
        return None

    w = float(page.rect.width)
    if w <= 0:
        return None
    mid_x = 0.5 * w

    try:
        blocks = page.get_text("dict").get("blocks", [])
    except Exception:
        blocks = []

    # Collect candidate blocks (skip very wide blocks).
    max_col_w = 0.45 * w
    left_rights: List[float] = []
    right_lefts: List[float] = []
    for b in blocks:
        bbox = b.get("bbox")
        if not bbox or len(bbox) != 4:
            continue
        x0, y0, x1, y1 = map(float, bbox)
        bw = x1 - x0
        if bw <= 0 or bw > max_col_w:
            continue
        if x0 < mid_x and x1 < mid_x + 0.10 * w:
            left_rights.append(x1)
        elif x0 > mid_x - 0.10 * w:
            right_lefts.append(x0)

    if len(left_rights) < 2 or len(right_lefts) < 2:
        return None

    left_rights.sort()
    right_lefts.sort()
    typ_left_right = left_rights[len(left_rights) // 2]
    typ_right_left = right_lefts[len(right_lefts) // 2]
    if typ_right_left <= typ_left_right:
        return mid_x
    return 0.5 * (typ_left_right + typ_right_left)


def _extract_mcid_bboxes(pdf_path: Path) -> Dict[int, Dict[int, Tuple[float, float, float, float]]]:
    """Return {mcid: {page: (x0,y0,x1,y1)}} using pdfplumber chars."""
    out: Dict[int, Dict[int, Tuple[float, float, float, float]]] = {}
    with pdfplumber.open(str(pdf_path)) as pdf:
        for page_idx0, page in enumerate(pdf.pages):
            page_num = page_idx0 + 1
            mcid_chars: Dict[int, List[dict]] = {}
            try:
                chars = page.chars or []
            except Exception:
                chars = []
            for ch in chars:
                mcid = ch.get("mcid")
                if mcid is None:
                    continue
                try:
                    mcid = int(mcid)
                except Exception:
                    continue
                mcid_chars.setdefault(mcid, []).append(ch)

            for mcid, cl in mcid_chars.items():
                try:
                    x0 = min(float(c["x0"]) for c in cl)
                    y0 = min(float(c["top"]) for c in cl)
                    x1 = max(float(c["x1"]) for c in cl)
                    y1 = max(float(c["bottom"]) for c in cl)
                except Exception:
                    continue
                out.setdefault(mcid, {})[page_num] = (x0, y0, x1, y1)
    return out


def _union_bbox(bbs: List[Tuple[float, float, float, float]]) -> Optional[Tuple[float, float, float, float]]:
    if not bbs:
        return None
    x0 = min(b[0] for b in bbs)
    y0 = min(b[1] for b in bbs)
    x1 = max(b[2] for b in bbs)
    y1 = max(b[3] for b in bbs)
    return (x0, y0, x1, y1)


def _is_core_block(tag_type: str) -> bool:
    return tag_type in ("H", "H1", "H2", "H3", "P", "L", "LI")


_TAG_DATA_RE = re.compile(r"\\lpsb@tag@data\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}")
_TAG_ATOM_RE = re.compile(r"\\lpsb@tag@atom\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}\{([^}]*)\}")


def _primary_mcid_char_stats(pdf_path: Path) -> Dict[Tuple[int, int], Tuple[int, str]]:
    """Return {(page, mcid): (char_count, preview)} using pdfplumber chars."""
    out: Dict[Tuple[int, int], Tuple[int, str]] = {}
    with pdfplumber.open(str(pdf_path)) as pdf:
        for page_idx0, page in enumerate(pdf.pages):
            page_num = page_idx0 + 1
            by: Dict[int, List[dict]] = {}
            try:
                chars = page.chars or []
            except Exception:
                chars = []
            for ch in chars:
                mcid = ch.get("mcid")
                if mcid is None:
                    continue
                try:
                    mcid = int(mcid)
                except Exception:
                    continue
                by.setdefault(mcid, []).append(ch)
            for mcid, cl in by.items():
                cl.sort(key=lambda c: (c.get("top", 0.0), c.get("x0", 0.0)))
                txt = "".join(c.get("text", "") for c in cl)
                out[(page_num, mcid)] = (len(cl), txt.strip()[:40])
    return out


def compute_order_map_latex(aux_path: Path, pdf_path: Path, verbose: bool = False) -> Dict[int, int]:
    """Compute elem_id -> order_index by aux event sequence (LaTeX writing order)."""
    aux_txt = aux_path.read_text(errors="replace")
    stats = _primary_mcid_char_stats(pdf_path)

    order_map: Dict[int, int] = {}
    cur = 0

    def is_marker(tag: str, preview: str, n: int) -> bool:
        if tag != "P":
            return False
        if n <= 2 and preview:
            # e.g. "*1", "1" used as footnote markers in title area
            if re.fullmatch(r"[*\d]+", preview):
                return True
        return False

    for ln in aux_txt.splitlines():
        m = _TAG_DATA_RE.search(ln)
        kind = "data"
        if not m:
            m = _TAG_ATOM_RE.search(ln)
            kind = "atom"
        if not m:
            continue
        try:
            eid = int(m.group(1))
            tag = m.group(2)
            mcid = int(m.group(3))
            page = int(m.group(4))
        except Exception:
            continue

        if eid in order_map:
            continue

        n, prev = stats.get((page, mcid), (0, ""))
        if n == 0:
            # Empty internal node: do not assign an order (and don't advance).
            continue

        if is_marker(tag, prev, n):
            # Marker-only: inherit previous order (do not advance).
            if cur > 0:
                order_map[eid] = cur
            else:
                # If this is the first thing, still give it 1.
                cur = 1
                order_map[eid] = cur
            continue

        cur += 1
        order_map[eid] = cur

    if verbose:
        print(f"[order-map/latex] ordered={len(order_map)} last={cur}")
    return order_map


def compute_order_map_layout(aux_path: Path, pdf_path: Path, verbose: bool = False) -> Dict[int, int]:
    elements, _summary = parse_aux_file(aux_path)
    layout = _get_layout_from_aux(aux_path)

    # Extract bboxes for MCIDs.
    mcid_bboxes = _extract_mcid_bboxes(pdf_path)

    # PDF doc for column boundary inference.
    doc = fitz.open(str(pdf_path))

    # Cache boundary per page (1-based).
    boundary_cache: Dict[int, Optional[float]] = {}

    def get_boundary(page_num: int) -> Optional[float]:
        if page_num not in boundary_cache:
            boundary_cache[page_num] = _detect_column_boundary(doc, page_num - 1)
        return boundary_cache[page_num]

    keyed: List[Tuple[Tuple, int]] = []
    missing_bbox = 0

    for e in elements:
        if getattr(e, "is_atom", False):
            # Atoms are ordered under explicit parent; leave as-is.
            continue
        tag = (e.tag_type or "").strip()
        start_page = int(getattr(e, "start_page", 0) or 0)

        # Anchor bbox:
        # Use the PRIMARY MCID bbox (from \lpsb@tag@data) to avoid being skewed by
        # same-page continuations into the right column (which would pull y0 to top).
        bbox = None
        mcids = list(getattr(e, "mcids", []) or [])
        if mcids:
            m0 = mcids[0]
            if int(m0.page) == start_page:
                bbox = mcid_bboxes.get(int(m0.mcid), {}).get(start_page)

        # Fallback: if primary bbox missing (e.g. image-only content), use union.
        if bbox is None:
            page_bbs: List[Tuple[float, float, float, float]] = []
            for m in mcids:
                if int(m.page) != start_page:
                    continue
                bb = mcid_bboxes.get(int(m.mcid), {}).get(start_page)
                if bb is not None:
                    page_bbs.append(bb)
            bbox = _union_bbox(page_bbs)
        if bbox is None:
            missing_bbox += 1

        # Grouping: prioritize core blocks first; defer "weird" blocks for now.
        grp = 0 if _is_core_block(tag) else 1

        # Column ordering only when page is known twocolumn and boundary detected.
        col = 0
        y0 = 1e9
        x0 = 1e9
        if bbox is not None:
            x0, y0, x1, y1 = bbox
            page_mode = _page_layout(start_page, layout)
            boundary = get_boundary(start_page) if page_mode == "twocolumn" else None
            if boundary is not None:
                # Treat "span across columns" only if it overlaps the boundary by a
                # meaningful margin. Tiny overlaps are common near the gutter and
                # should still be treated as left/right column text.
                span_margin = 8.0
                if x0 < boundary - span_margin and x1 > boundary + span_margin:
                    # Spanning content is in the main flow; treat as left for ordering.
                    col = 0
                else:
                    cx = 0.5 * (x0 + x1)
                    col = 0 if cx < boundary else 1

        # Stable key: page, group, column, y, x, elem_id
        key = (start_page, grp, col, y0, x0, int(e.elem_id))
        keyed.append((key, int(e.elem_id)))

    doc.close()

    keyed.sort(key=lambda t: t[0])

    order_map: Dict[int, int] = {}
    cur = 0
    for _key, eid in keyed:
        cur += 1
        order_map[eid] = cur

    if verbose:
        print(f"[order-map] elements={len(order_map)} missing_bbox={missing_bbox} base_layout={layout.base!r}")

    return order_map


def compute_order_map_synctex(
    aux_path: Path,
    pdf_path: Path,
    synctex_path: Optional[Path] = None,
    verbose: bool = False
) -> Dict[int, int]:
    """Compute elem_id -> order_index using SyncTeX source code mapping.

    Strategy:
    1. For each element, use the FIRST MCID's FIRST CHARACTER position
    2. Reverse-lookup this PDF position to get (file_id, source_line) via SyncTeX
    3. Sort by (file_id, source_line) to get reading order

    This correctly handles:
    - Cross-page P elements: all MCIDs trace back to same source line
    - Cross-column P elements: all MCIDs trace back to same source line
    - Floats: Figure/Table content has its own source line
    - Multiple \\input files: each file has unique file_id
    """
    # Parse aux to get elements
    elements, _summary = parse_aux_file(aux_path)

    # Find synctex file
    if synctex_path is None:
        # Try multiple possible locations
        candidates = [
            pdf_path.with_suffix('.synctex.gz'),
            pdf_path.with_suffix('.synctex'),
            pdf_path.parent / 'main.synctex.gz',  # Common case: main.synctex.gz
            pdf_path.parent / 'main.synctex',
        ]
        # If pdf is main_fixed.pdf, also try main.synctex.gz
        if 'fixed' in pdf_path.stem:
            base_name = pdf_path.stem.replace('_fixed', '')
            candidates.insert(0, pdf_path.parent / f'{base_name}.synctex.gz')
            candidates.insert(1, pdf_path.parent / f'{base_name}.synctex')

        synctex_path = None
        for candidate in candidates:
            if candidate.exists():
                synctex_path = candidate
                break

    if not synctex_path.exists():
        raise FileNotFoundError(f"SyncTeX file not found: {synctex_path}")

    # Parse SyncTeX
    synctex_data = parse_synctex(synctex_path)
    if verbose:
        print(f"[order-map/synctex] Parsed {len(synctex_data.files)} files, {len(synctex_data.records)} records")

    # Get page heights for Y coordinate conversion
    doc = fitz.open(str(pdf_path))
    page_heights = {i+1: float(doc[i].rect.height) for i in range(len(doc))}
    doc.close()

    # Build SyncTeX lookup index: group by page, convert to PDF coordinates
    page_synctex: Dict[int, List[Tuple[float, float, int, int]]] = {}
    for rec in synctex_data.records:
        filename = synctex_data.files.get(rec.file_id, '')
        # Skip TeX system files
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue
        if rec.page not in page_synctex:
            page_synctex[rec.page] = []
        page_h = page_heights.get(rec.page, 792.0)
        x_pdf = sp_to_pdf_points(rec.x)
        y_pdf = page_h - sp_to_pdf_points(rec.y)  # Convert to top-origin
        page_synctex[rec.page].append((x_pdf, y_pdf, rec.file_id, rec.line))

    # Extract MCID character positions from PDF
    mcid_first_char: Dict[Tuple[int, int], Tuple[float, float]] = {}  # (page, mcid) -> (x, y)
    with pdfplumber.open(str(pdf_path)) as pdf:
        for page_idx, page in enumerate(pdf.pages):
            page_num = page_idx + 1
            mcid_chars: Dict[int, List] = {}
            for ch in (page.chars or []):
                mcid = ch.get('mcid')
                if mcid is not None:
                    mcid_chars.setdefault(int(mcid), []).append(ch)

            for mcid, chars in mcid_chars.items():
                # Get first character position (reading order: top-left)
                first = sorted(chars, key=lambda c: (c['top'], c['x0']))[0]
                mcid_first_char[(page_num, mcid)] = (float(first['x0']), float(first['top']))

    def find_source_location(page: int, x: float, y: float, tolerance: float = 25.0) -> Tuple[int, int]:
        """Reverse-lookup PDF position to (file_id, source_line) via SyncTeX."""
        if page not in page_synctex:
            return None  # No match

        best = None
        best_dist = float('inf')
        for sx, sy, file_id, line in page_synctex[page]:
            dist = ((sx - x)**2 + (sy - y)**2)**0.5
            if dist < best_dist:
                best_dist = dist
                best = (file_id, line)

        if best and best_dist <= tolerance:
            return best
        # If no match within tolerance, still use best match
        if best:
            return best
        return None

    # Find main.tex file_id for template elements
    main_file_id = 1  # Default
    for fid, fpath in synctex_data.files.items():
        if fpath.endswith('main.tex') or fpath.endswith('/main.tex'):
            main_file_id = fid
            break

    # Template-generated tags that should use main.tex ordering
    TEMPLATE_TAGS = {'Title', 'Author', 'Note', 'Affil'}

    # Build sorted list by (file_id, source_line, elem_id)
    keyed: List[Tuple[Tuple, int]] = []

    for e in elements:
        if getattr(e, "is_atom", False):
            continue

        start_page = int(getattr(e, "start_page", 0) or 0)
        if start_page == 0:
            continue

        tag_type = getattr(e, "tag_type", "")

        # For template-generated elements, use main.tex with elem_id ordering
        # This ensures Title, Author, Note etc. are sorted by their LaTeX processing order
        if tag_type in TEMPLATE_TAGS:
            # Use (main_file_id, elem_id) - elem_id reflects LaTeX processing order
            key = (main_file_id, int(e.elem_id), int(e.elem_id))
            keyed.append((key, int(e.elem_id)))
            continue

        # Get first MCID's first character position
        mcids = list(getattr(e, "mcids", []) or [])
        source_loc = None

        if mcids:
            # Use FIRST MCID to determine source location
            first_mcid = mcids[0]
            pos = mcid_first_char.get((first_mcid.page, int(first_mcid.mcid)))
            if pos:
                source_loc = find_source_location(first_mcid.page, pos[0], pos[1])

        if source_loc:
            file_id, source_line = source_loc
            # Sort key: (file_id, source_line, elem_id as tiebreaker)
            # This is the TRUE reading order from source code
            key = (file_id, source_line, int(e.elem_id))
        else:
            # No SyncTeX match: use elem_id only (LaTeX processing order)
            # Put at end with max file_id
            key = (999999, 999999, int(e.elem_id))

        keyed.append((key, int(e.elem_id)))

    # Sort by key
    keyed.sort(key=lambda t: t[0])

    # Assign order
    order_map: Dict[int, int] = {}
    for idx, (_key, eid) in enumerate(keyed, 1):
        order_map[eid] = idx

    if verbose:
        print(f"[order-map/synctex] Ordered {len(order_map)} elements")

    return order_map


def compute_order_map(
    aux_path: Path, 
    pdf_path: Path, 
    mode: str = "synctex",  # Changed default to synctex
    synctex_path: Optional[Path] = None,
    verbose: bool = False
) -> Dict[int, int]:
    mode = (mode or "synctex").strip().lower()
    if mode == "layout":
        return compute_order_map_layout(aux_path, pdf_path, verbose=verbose)
    if mode == "latex":
        return compute_order_map_latex(aux_path, pdf_path, verbose=verbose)
    # Default: synctex
    return compute_order_map_synctex(aux_path, pdf_path, synctex_path=synctex_path, verbose=verbose)



def main() -> int:
    ap = argparse.ArgumentParser(description="Compute reading-order map for LPSB elements")
    ap.add_argument("pdf", help="Tagged PDF (with MCIDs) to extract geometry from")
    ap.add_argument("--aux", required=True, help="Aux file with LPSB element/MCID data")
    ap.add_argument("-o", "--output", required=True, help="Output JSON path")
    ap.add_argument("--mode", choices=["latex", "layout"], default="latex", help="Ordering mode (default: latex)")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    pdf_path = Path(args.pdf)
    aux_path = Path(args.aux)
    out_path = Path(args.output)

    if not pdf_path.exists():
        raise SystemExit(f"pdf not found: {pdf_path}")
    if not aux_path.exists():
        raise SystemExit(f"aux not found: {aux_path}")

    order_map = compute_order_map(aux_path, pdf_path, mode=str(args.mode), verbose=bool(args.verbose))

    payload = {
        "version": 1,
        "order_by_elem_id": {str(k): int(v) for k, v in order_map.items()},
    }
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(payload, indent=2))
    if args.verbose:
        print(f"[order-map] wrote: {out_path}")
    return 0
