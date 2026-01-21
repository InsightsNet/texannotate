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
    """Compute elem_id -> order_index using SyncTeX source line numbers.
    
    This mode uses SyncTeX data to determine reading order:
    1. For each element, find its primary MCID's position in the PDF
    2. Query SyncTeX to get source file:line for that position
    3. Sort elements by (page, column, source_line) to get reading order
    
    The column ordering ensures left-column-first for two-column layouts.
    """
    # Auto-detect synctex path if not provided
    if synctex_path is None:
        synctex_path = aux_path.with_suffix('.synctex.gz')
        if not synctex_path.exists():
            synctex_path = aux_path.with_name('main.synctex.gz')
    
    if not synctex_path.exists():
        if verbose:
            print(f"[order-map/synctex] SyncTeX file not found: {synctex_path}, falling back to latex mode")
        return compute_order_map_latex(aux_path, pdf_path, verbose=verbose)
    
    # Parse SyncTeX data
    synctex_data = parse_synctex(synctex_path)
    if verbose:
        print(f"[order-map/synctex] Parsed {len(synctex_data.files)} files, {len(synctex_data.records)} records")
    
    # Parse aux to get elements
    elements, _summary = parse_aux_file(aux_path)
    
    # Extract MCID bboxes from PDF
    mcid_bboxes = _extract_mcid_bboxes(pdf_path)
    
    # Get layout info for column detection
    layout = _get_layout_from_aux(aux_path)
    doc = fitz.open(str(pdf_path))
    
    # Cache column boundary per page
    boundary_cache: Dict[int, Optional[float]] = {}
    
    def get_boundary(page_num: int) -> Optional[float]:
        if page_num not in boundary_cache:
            page_mode = _page_layout(page_num, layout)
            if page_mode == "twocolumn":
                boundary_cache[page_num] = _detect_column_boundary(doc, page_num - 1)
            else:
                boundary_cache[page_num] = None
        return boundary_cache[page_num]
    
    # Cache page heights for Y-coordinate conversion
    # SyncTeX uses bottom-origin (Y=0 at bottom), pdfplumber uses top-origin (Y=0 at top)
    page_heights: Dict[int, float] = {}
    for page_idx in range(len(doc)):
        page_heights[page_idx + 1] = float(doc[page_idx].rect.height)
    
    # Build mapping: position -> source line (for faster lookup)
    # Group SyncTeX records by (page, x-region, y-region) for efficient querying
    # IMPORTANT: Convert Y from bottom-origin to top-origin
    page_line_map: Dict[int, List[Tuple[float, float, int, int]]] = {}  # page -> [(x, y_top, file_id, line)]
    for rec in synctex_data.records:
        if rec.page not in page_line_map:
            page_line_map[rec.page] = []
        x_pdf = sp_to_pdf_points(rec.x)
        y_pdf_bottom = sp_to_pdf_points(rec.y)
        # Convert to top-origin Y
        page_h = page_heights.get(rec.page, 792.0)
        y_pdf_top = page_h - y_pdf_bottom
        page_line_map[rec.page].append((x_pdf, y_pdf_top, rec.file_id, rec.line))
    
    # For each element, find its source line via MCID position
    keyed: List[Tuple[Tuple, int]] = []
    
    for e in elements:
        if getattr(e, "is_atom", False):
            continue
        
        start_page = int(getattr(e, "start_page", 0) or 0)
        if start_page == 0:
            continue
        
        # Get primary MCID bbox
        mcids = list(getattr(e, "mcids", []) or [])
        bbox = None
        if mcids:
            m0 = mcids[0]
            bbox = mcid_bboxes.get(int(m0.mcid), {}).get(start_page)
        
        if bbox is None:
            # No bbox - use a large order to sort last
            keyed.append(((start_page, 0, 999999, 999999, int(e.elem_id)), int(e.elem_id)))
            continue
        
        x0, y0, x1, y1 = bbox
        cx = (x0 + x1) / 2
        cy = (y0 + y1) / 2
        elem_width = x1 - x0
        
        # Determine column
        boundary = get_boundary(start_page)
        col = 0
        if boundary is not None:
            # Check if element spans both columns (wide element like title)
            # If width > 60% of page width, treat as spanning (column 0)
            page_width = page_heights.get(start_page, 612.0)  # Use page height dict as proxy
            try:
                page_width = float(doc[start_page - 1].rect.width)
            except Exception:
                pass
            
            if elem_width > 0.6 * page_width:
                # Spanning element - treat as column 0 (first in reading order)
                col = 0
            elif cx < boundary:
                col = 0
            else:
                col = 1
        
        # Find nearest SyncTeX record to get source file and line
        # Priority: Y-coordinate proximity (same line band), then X-proximity
        source_file_id = 0
        source_line = 999999
        y_tolerance = 15.0  # PDF points - records within this Y are considered same line
        
        if start_page in page_line_map:
            # First pass: find records within Y tolerance
            candidates = []
            for sx, sy, file_id, line in page_line_map[start_page]:
                # Skip package files
                filename = synctex_data.files.get(file_id, "")
                if '/texmf-dist/' in filename or '/texlive/' in filename:
                    continue
                
                y_dist = abs(sy - cy)
                if y_dist <= y_tolerance:
                    x_dist = abs(sx - cx)
                    candidates.append((y_dist, x_dist, file_id, line))
            
            if candidates:
                # Sort by Y first, then X
                candidates.sort(key=lambda c: (c[0], c[1]))
                best = candidates[0]
                source_file_id = best[2]
                source_line = best[3]
            else:
                # Fallback: find nearest by Y distance only
                min_y_dist = float('inf')
                for sx, sy, file_id, line in page_line_map[start_page]:
                    filename = synctex_data.files.get(file_id, "")
                    if '/texmf-dist/' in filename or '/texlive/' in filename:
                        continue
                    
                    y_dist = abs(sy - cy)
                    if y_dist < min_y_dist:
                        min_y_dist = y_dist
                        source_file_id = file_id
                        source_line = line
        
        # Sort key: (page, column, y, source_line, x, elem_id)
        # Within each column, Y-coordinate gives visual reading order (top to bottom)
        # source_line is used as tiebreaker for elements at same Y
        key = (start_page, col, y0, source_line, x0, int(e.elem_id))
        keyed.append((key, int(e.elem_id)))
    
    doc.close()
    
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
