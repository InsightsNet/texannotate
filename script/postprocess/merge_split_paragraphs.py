#!/usr/bin/env python3
"""
merge_split_paragraphs.py - SyncTeX-based cross-column paragraph merging

Problem:
  In two-column layouts, TeX's output routine may split a single logical paragraph
  into multiple marked-content blocks (separate elem_id's) across columns.
  This breaks logical reading order.

Solution (SyncTeX-based):
  Use SyncTeX to identify which source lines span multiple columns on the same page.
  Elements that map to the same source line should be merged.

This does NOT modify the PDF content stream. It only fixes the logical structure
used by StructTree injection and visualization ordering.
"""

import argparse
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple

import pdfplumber
import fitz  # PyMuPDF

from ..parsing.parse_synctex import (
    parse_synctex,
    find_crosscolumn_lines,
    sp_to_pdf_points,
    SyncTeXData,
)


_TAG_DATA_RE = re.compile(r"\\lpsb@tag@data\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}")
_MCID_CONT_RE = re.compile(r"\\lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}")
_TAG_END_RE = re.compile(r"\\lpsb@tag@end\{(\d+)\}\{(\d+)\}")
_TAG_ATOM_RE = re.compile(r"\\lpsb@tag@atom\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}\{([^}]*)\}")


@dataclass
class Elem:
    eid: int
    typ: str
    primary_mcid: int
    page: int
    cont_mcids: List[int] = field(default_factory=list)
    source_file: str = ""
    source_line: int = 0


# =============================================================================
# SyncTeX-based Cross-Column Detection
# =============================================================================

def get_crosscolumn_source_lines(synctex_path: Path) -> Dict[int, Set[Tuple[str, int]]]:
    """Get source lines that span multiple columns, grouped by page.

    Returns:
        {page: set of (filename, line) that span columns on that page}
    """
    data = parse_synctex(synctex_path)
    crosscolumn = find_crosscolumn_lines(data)

    result: Dict[int, Set[Tuple[str, int]]] = {}
    for (fname, line, page), positions in crosscolumn.items():
        if len(positions) > 1:  # Multiple column positions = cross-column
            result.setdefault(page, set()).add((fname, line))

    return result, data


def match_mcid_to_source(
    synctex_data: SyncTeXData,
    page: int,
    x_pdf: float,
    y_pdf: float,
    page_height: float,
    tolerance: float = 25.0
) -> Optional[Tuple[str, int]]:
    """Match PDF position to source (filename, line) via SyncTeX."""
    candidates = []

    for rec in synctex_data.records:
        if rec.page != page:
            continue
        filename = synctex_data.files.get(rec.file_id, '')
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue

        sx = sp_to_pdf_points(rec.x)
        sy_top = page_height - sp_to_pdf_points(rec.y)

        dist = ((sx - x_pdf)**2 + (sy_top - y_pdf)**2)**0.5
        if dist <= tolerance:
            candidates.append((dist, filename, rec.line))

    if candidates:
        candidates.sort(key=lambda x: x[0])
        return (candidates[0][1], candidates[0][2])

    return None


def get_mcid_first_char_position(
    pdf_path: Path,
    page_num: int,
    mcid: int
) -> Optional[Tuple[float, float]]:
    """Get first character position for an MCID."""
    with pdfplumber.open(str(pdf_path)) as pdf:
        if page_num < 1 or page_num > len(pdf.pages):
            return None
        page = pdf.pages[page_num - 1]
        chars = [c for c in page.chars if c.get('mcid') == mcid]
        if not chars:
            return None
        first = sorted(chars, key=lambda c: (c['top'], c['x0']))[0]
        return (float(first['x0']), float(first['top']))


# =============================================================================
# Aux Parsing
# =============================================================================

def _parse_aux_elements(aux_text: str) -> Tuple[List[Tuple[int, str, int, int]], Dict[int, List[Tuple[int, int]]]]:
    """Return ordered tag_data records and cont map."""
    ordered: List[Tuple[int, str, int, int]] = []
    cont: Dict[int, List[Tuple[int, int]]] = {}
    for m in _TAG_DATA_RE.finditer(aux_text):
        ordered.append((int(m.group(1)), m.group(2), int(m.group(3)), int(m.group(4))))
    for m in _MCID_CONT_RE.finditer(aux_text):
        cont.setdefault(int(m.group(1)), []).append((int(m.group(2)), int(m.group(3))))
    return ordered, cont


# =============================================================================
# SyncTeX-based Merge Detection
# =============================================================================

def find_merges_synctex(
    elems: List[Elem],
    page: int,
    crosscolumn_lines: Set[Tuple[str, int]],
    synctex_data: SyncTeXData,
    pdf_path: Path,
    page_height: float,
    verbose: bool = False
) -> List[Tuple[int, int]]:
    """Find elements to merge based on SyncTeX source line matching.

    Elements that map to the same cross-column source line should be merged.

    Returns:
        List of (keep_eid, drop_eid) pairs
    """
    if not crosscolumn_lines:
        return []

    # Match each element to its source line
    elem_source: Dict[int, Tuple[str, int]] = {}

    for e in elems:
        pos = get_mcid_first_char_position(pdf_path, page, e.primary_mcid)
        if pos is None:
            continue

        source = match_mcid_to_source(
            synctex_data, page, pos[0], pos[1], page_height
        )
        if source is None:
            continue

        # Normalize filename
        fname = Path(source[0]).name if source[0] else ''
        line = source[1]

        # Check if this source line is cross-column
        for cc_fname, cc_line in crosscolumn_lines:
            cc_base = Path(cc_fname).name if cc_fname else ''
            if cc_base == fname and cc_line == line:
                elem_source[e.eid] = (fname, line)
                if verbose:
                    print(f"    elem {e.eid} -> {fname}:{line} (cross-column)")
                break

    if not elem_source:
        return []

    # Group elements by source line
    source_to_elems: Dict[Tuple[str, int], List[int]] = {}
    for eid, source in elem_source.items():
        source_to_elems.setdefault(source, []).append(eid)

    # For each group with multiple elements, merge them
    merges = []
    for source, eids in source_to_elems.items():
        if len(eids) < 2:
            continue
        # Keep the first (lowest eid), drop the rest
        eids_sorted = sorted(eids)
        keep = eids_sorted[0]
        for drop in eids_sorted[1:]:
            merges.append((keep, drop))
            if verbose:
                print(f"    Merge: keep elem {keep}, drop elem {drop} (same source {source})")

    return merges


# =============================================================================
# Main Processing
# =============================================================================

def merge_split_paragraphs(
    aux_in: Path,
    pdf_path: Path,
    synctex_path: Path,
    aux_out: Path,
    verbose: bool = False
) -> int:
    """Merge cross-column split paragraphs using SyncTeX.

    Args:
        aux_in: Input aux file
        pdf_path: PDF for geometry extraction
        synctex_path: SyncTeX file
        aux_out: Output aux file
        verbose: Print progress

    Returns:
        Number of merges performed
    """
    if not synctex_path.exists():
        if verbose:
            print(f"[merge-split] SyncTeX not found: {synctex_path}, skipping")
        aux_out.write_text(aux_in.read_text(errors="replace"))
        return 0

    # Parse SyncTeX for cross-column lines
    crosscolumn_by_page, synctex_data = get_crosscolumn_source_lines(synctex_path)

    if not crosscolumn_by_page:
        if verbose:
            print("[merge-split] No cross-column content detected")
        aux_out.write_text(aux_in.read_text(errors="replace"))
        return 0

    if verbose:
        print(f"[merge-split] Cross-column pages: {sorted(crosscolumn_by_page.keys())}")

    # Parse aux
    aux_txt = aux_in.read_text(errors="replace")
    ordered, cont = _parse_aux_elements(aux_txt)

    # Build P elements per page
    elems_by_page: Dict[int, List[Elem]] = {}
    for eid, typ, mcid, page in ordered:
        if typ != "P":
            continue
        cm = [m for (m, p) in cont.get(eid, []) if p == page]
        elems_by_page.setdefault(page, []).append(
            Elem(eid=eid, typ=typ, primary_mcid=mcid, page=page, cont_mcids=cm)
        )

    # Get page heights
    doc = fitz.open(str(pdf_path))
    page_heights = {i+1: float(doc[i].rect.height) for i in range(len(doc))}
    doc.close()

    # Find merges for each cross-column page
    all_merges: List[Tuple[int, int]] = []

    for page_num in sorted(crosscolumn_by_page.keys()):
        elems = elems_by_page.get(page_num, [])
        if not elems:
            continue

        crosscolumn_lines = crosscolumn_by_page.get(page_num, set())
        page_height = page_heights.get(page_num, 792.0)

        merges = find_merges_synctex(
            elems, page_num, crosscolumn_lines,
            synctex_data, pdf_path, page_height,
            verbose=verbose
        )
        all_merges.extend(merges)

    if not all_merges:
        aux_out.write_text(aux_txt)
        if verbose:
            print("[merge-split] No merges needed")
        return 0

    # Apply merges to aux
    rewrite_parent: Dict[int, int] = {drop: keep for (keep, drop) in all_merges}
    drop_ids = set(rewrite_parent.keys())

    # Collect MCIDs from dropped elements to move to kept elements
    tag_page: Dict[int, int] = {}
    for eid, typ, mcid, page in ordered:
        if typ == "P":
            tag_page[eid] = page

    right_to_mcids: Dict[int, List[Tuple[int, int]]] = {}
    for eid, typ, mcid, page in ordered:
        if eid in drop_ids and typ == "P":
            right_to_mcids.setdefault(eid, []).append((mcid, page))
    for rid in drop_ids:
        rp = tag_page.get(rid)
        for mcid, page in cont.get(rid, []):
            if rp is not None and page != rp:
                continue
            right_to_mcids.setdefault(rid, []).append((mcid, page))

    # Rewrite aux
    out_lines: List[str] = []
    for ln in aux_txt.splitlines(keepends=True):
        # Drop tag_data for merged elements
        m = _TAG_DATA_RE.search(ln)
        if m:
            eid = int(m.group(1))
            typ = m.group(2)
            if eid in drop_ids and typ == "P":
                continue

        # Drop mcid_cont for merged elements
        m = _MCID_CONT_RE.search(ln)
        if m:
            eid = int(m.group(1))
            if eid in drop_ids:
                continue

        # Drop tag_end for merged elements
        m = _TAG_END_RE.search(ln)
        if m:
            eid = int(m.group(1))
            if eid in drop_ids:
                continue

        # Rewrite atom parent_id
        m = _TAG_ATOM_RE.search(ln)
        if m:
            parent_raw = (m.group(5) or "").strip()
            if parent_raw.isdigit():
                pid = int(parent_raw)
                if pid in rewrite_parent:
                    new_pid = rewrite_parent[pid]
                    ln = re.sub(
                        r"(\\lpsb@tag@atom\{\d+\}\{[^}]+\}\{\d+\}\{\d+\}\{)(\d+)(\})",
                        r"\g<1>" + str(new_pid) + r"\g<3>",
                        ln, count=1
                    )

        out_lines.append(ln)

        # After kept element's tag_data, inject moved MCIDs
        m = _TAG_DATA_RE.search(ln)
        if m:
            eid = int(m.group(1))
            typ = m.group(2)
            if typ == "P":
                moved = []
                for rid, lid in rewrite_parent.items():
                    if lid != eid:
                        continue
                    for mcid, page in right_to_mcids.get(rid, []):
                        moved.append((mcid, page))
                if moved:
                    for mcid, page in sorted(set(moved)):
                        out_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{mcid}}}{{{page}}}% merged-synctex\n")

    out_lines.append("\n% --- LPSB: merged cross-column split paragraphs (SyncTeX-based) ---\n")
    for keep, drop in all_merges:
        out_lines.append(f"% Merged P elem {drop} into P elem {keep}\n")

    aux_out.write_text("".join(out_lines))

    if verbose:
        print(f"[merge-split] Merged {len(all_merges)} paragraph pairs -> {aux_out}")

    return len(all_merges)


def main() -> int:
    """CLI entry point."""
    ap = argparse.ArgumentParser(
        description="Merge cross-column split paragraphs using SyncTeX"
    )
    ap.add_argument("aux", type=Path, help="Input aux file")
    ap.add_argument("pdf", type=Path, help="PDF for geometry extraction")
    ap.add_argument("--synctex", type=Path, help="SyncTeX file (default: aux with .synctex.gz)")
    ap.add_argument("-o", "--output", type=Path, required=True, help="Output aux path")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    if not args.aux.exists():
        raise SystemExit(f"aux not found: {args.aux}")
    if not args.pdf.exists():
        raise SystemExit(f"pdf not found: {args.pdf}")

    # Auto-detect synctex path
    synctex_path = args.synctex
    if synctex_path is None:
        synctex_path = args.aux.with_suffix('.synctex.gz')
        if not synctex_path.exists():
            synctex_path = args.aux.parent / 'main.synctex.gz'

    n = merge_split_paragraphs(
        args.aux, args.pdf, synctex_path, args.output,
        verbose=bool(args.verbose)
    )
    if args.verbose:
        print(f"done merges={n}")
    return 0


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py merge-split-paragraphs ...
