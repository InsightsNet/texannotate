#!/usr/bin/env python3
"""
merge_split_paragraphs.py - Merge cross-column split paragraphs in aux.

Problem:
  In two-column layouts, TeX's output routine may split a single logical paragraph
  into multiple marked-content blocks (separate elem_id's) across columns.
  This breaks logical reading order (the right-column continuation is treated as
  a new P element).

Goal (phase 1):
  Merge the obvious "left-column paragraph continues in right column (same page)"
  cases by rewriting the aux:
    - move right-paragraph MCIDs into left paragraph via \\lpsb@mcid@cont
    - rewrite atom parent_ids from right elem_id -> left elem_id
    - drop the right paragraph's \\lpsb@tag@data/\\lpsb@mcid@cont/\\lpsb@tag@end records

This does NOT modify the PDF content stream. It only fixes the logical structure
used by StructTree injection and visualization ordering.
"""

import argparse
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import pdfplumber
import fitz  # PyMuPDF


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
    cont_mcids: List[int]


def _is_likely_continuation(left_text: str, right_text: str) -> bool:
    """
    Heuristic: merge only when the left fragment clearly continues into the right.

    We intentionally keep this conservative to avoid catastrophic over-merging.
    """
    lt = (left_text or "").strip()
    rt = (right_text or "").strip()
    if not lt or not rt:
        return False

    # Tail/head char checks.
    tail = lt[-1]
    head = rt[0]

    # If left ends a sentence/paragraph strongly, do not merge.
    if tail in ".?!":
        return False

    # If right starts with an uppercase letter, it's more likely a new sentence.
    # (We still allow digits and lowercase for continuations like "learning ..." or "(1) ...")
    if "A" <= head <= "Z":
        return False

    return True


def _extract_text_for_mcids(page, mcids: List[int]) -> str:
    """Extract text for a set of MCIDs from a pdfplumber page."""
    chars = []
    mcid_set = set(int(m) for m in mcids)
    for ch in page.chars:
        m = ch.get("mcid")
        if m is None:
            continue
        try:
            m = int(m)
        except Exception:
            continue
        if m in mcid_set:
            chars.append(ch)
    chars.sort(key=lambda c: (c.get("top", 0.0), c.get("x0", 0.0)))
    return "".join(c.get("text", "") for c in chars)


def _detect_column_boundary(pdf_path: Path, page_idx0: int) -> Optional[float]:
    doc = fitz.open(str(pdf_path))
    try:
        page = doc[page_idx0]
        w = float(page.rect.width)
        if w <= 0:
            return None
        mid = 0.5 * w
        blocks = page.get_text("dict").get("blocks", [])
        maxw = 0.45 * w
        lr: List[float] = []
        rl: List[float] = []
        for b in blocks:
            bb = b.get("bbox")
            if not bb or len(bb) != 4:
                continue
            x0, y0, x1, y1 = map(float, bb)
            bw = x1 - x0
            if bw <= 0 or bw > maxw:
                continue
            if x0 < mid and x1 < mid + 0.10 * w:
                lr.append(x1)
            elif x0 > mid - 0.10 * w:
                rl.append(x0)
        if len(lr) < 2 or len(rl) < 2:
            return None
        lr.sort()
        rl.sort()
        return 0.5 * (lr[len(lr) // 2] + rl[len(rl) // 2])
    finally:
        doc.close()


def _extract_mcid_bboxes(pdf_path: Path, page_num: int) -> Dict[int, Tuple[float, float, float, float]]:
    """Return {mcid: (x0,y0,x1,y1)} for one page using pdfplumber chars."""
    out: Dict[int, Tuple[float, float, float, float]] = {}
    with pdfplumber.open(str(pdf_path)) as pdf:
        page = pdf.pages[page_num - 1]
        mcid_chars: Dict[int, List[dict]] = {}
        for ch in page.chars:
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
            out[mcid] = (x0, y0, x1, y1)
    return out


def _merge_bbox(a: Tuple[float, float, float, float], b: Tuple[float, float, float, float]) -> Tuple[float, float, float, float]:
    return (min(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), max(a[3], b[3]))


def _elem_bbox_on_page(e: Elem, mcid_bbox: Dict[int, Tuple[float, float, float, float]]) -> Optional[Tuple[float, float, float, float]]:
    b = mcid_bbox.get(e.primary_mcid)
    if b is None:
        return None
    bb = b
    for mcid in e.cont_mcids:
        b2 = mcid_bbox.get(mcid)
        if b2 is not None:
            bb = _merge_bbox(bb, b2)
    return bb


def _parse_aux_elements(aux_text: str) -> Tuple[List[Tuple[int, str, int, int]], Dict[int, List[Tuple[int, int]]]]:
    """Return ordered tag_data records and cont map."""
    ordered: List[Tuple[int, str, int, int]] = []
    cont: Dict[int, List[Tuple[int, int]]] = {}
    for m in _TAG_DATA_RE.finditer(aux_text):
        ordered.append((int(m.group(1)), m.group(2), int(m.group(3)), int(m.group(4))))
    for m in _MCID_CONT_RE.finditer(aux_text):
        cont.setdefault(int(m.group(1)), []).append((int(m.group(2)), int(m.group(3))))
    return ordered, cont


def _find_merges_for_page(
    elems: List[Elem],
    boundary: float,
    page_h: float,
    mcid_bbox: Dict[int, Tuple[float, float, float, float]],
    pdf_path: Path,
) -> List[Tuple[int, int]]:
    """
    Return list of (keep_left_eid, drop_right_eid) merges.

    Important invariants:
      - Do NOT over-merge. Prefer missing a merge over merging unrelated paragraphs.
      - Only merge across columns on the SAME page.
      - At most one left->right chain per page.
    """
    def _anchor_bbox(e: Elem) -> Optional[Tuple[float, float, float, float]]:
        """
        Pick a stable 'anchor' bbox for the element on this page.

        Primary MCID is often tiny (footnote markers), so we choose the top-most
        *meaningful* MCID bbox instead.
        """
        best = None
        for mcid in [e.primary_mcid] + list(e.cont_mcids):
            bb = mcid_bbox.get(int(mcid))
            if bb is None:
                continue
            x0, y0, x1, y1 = bb
            w = float(x1 - x0)
            h = float(y1 - y0)
            # Skip tiny markers.
            if w < 40.0 or h < 10.0:
                continue
            if best is None or float(y0) < float(best[1]):
                best = (x0, y0, x1, y1)
        return best

    # Classify into left / right based on anchor bbox center.
    left: List[Tuple[Elem, Tuple[float, float, float, float], Tuple[float, float, float, float]]] = []
    right: List[Tuple[Elem, Tuple[float, float, float, float], Tuple[float, float, float, float]]] = []
    for e in elems:
        full_bb = _elem_bbox_on_page(e, mcid_bbox)
        if full_bb is None:
            continue
        ab = _anchor_bbox(e) or full_bb
        x0, y0, x1, y1 = ab
        cx = 0.5 * (float(x0) + float(x1))
        if cx < boundary:
            left.append((e, ab, full_bb))
        else:
            right.append((e, ab, full_bb))

    if not left or not right:
        return []

    # Heuristic thresholds: make them strict to avoid false merges.
    y_top = 0.35 * page_h
    y_deep = 0.70 * page_h

    # Load the page once for text-based continuation checks and text-length filtering.
    with pdfplumber.open(str(pdf_path)) as pdf:
        p = pdf.pages[elems[0].page - 1]

        def norm_len(s: str) -> int:
            return sum(1 for ch in (s or "") if ch.isalnum())

        # Pick the deepest-left paragraph as the one most likely split by the column break,
        # but require it to be a real paragraph (not tiny artifacts).
        # left candidates: prefer those that *physically reach* deep in the left column,
        # so sort by full bbox bottom.
        left_sorted = sorted(left, key=lambda t: float(t[2][3]), reverse=True)
        le = None
        left_text = ""
        for cand, ab, full_bb in left_sorted[:10]:
            if float(full_bb[3]) < y_deep:
                break
            lt = _extract_text_for_mcids(p, [cand.primary_mcid] + list(cand.cont_mcids))
            if norm_len(lt) >= 80:
                le, left_text = cand, lt
                break
        if le is None:
            return []

        # Consider only right paragraphs that start near the top and are non-trivial in size.
        right_sorted = sorted(right, key=lambda t: float(t[1][1]))
        right_top: List[Tuple[Elem, Tuple[float, float, float, float], str]] = []
        for cand, ab, full_bb in right_sorted:
            if float(ab[1]) > y_top:
                break
            if float(ab[3] - ab[1]) < 10.0:
                continue
            rt = _extract_text_for_mcids(p, [cand.primary_mcid] + list(cand.cont_mcids))
            if norm_len(rt) < 40:
                continue
            right_top.append((cand, ab, rt))
        if not right_top:
            return []

    merges: List[Tuple[int, int]] = []
    # Merge a chain of consecutive top-right paragraphs as long as they look like continuations
    # AND are vertically adjacent (to avoid merging unrelated right-column blocks).
    prev_bottom: Optional[float] = None
    for re, rbb, right_text in right_top:
        if float(rbb[1]) > 0.55 * page_h:
            break
        if prev_bottom is not None and float(rbb[1]) - prev_bottom > 42.0:
            break

        if not _is_likely_continuation(left_text, right_text):
            if not merges:
                return []
            break

        merges.append((le.eid, re.eid))
        left_text = (left_text + " " + right_text).strip()
        prev_bottom = float(rbb[3])

    return merges


def merge_split_paragraphs(aux_in: Path, pdf_for_geom: Path, aux_out: Path, verbose: bool = False) -> int:
    aux_txt = aux_in.read_text(errors="replace")
    ordered, cont = _parse_aux_elements(aux_txt)
    tag_page: Dict[int, int] = {}
    for eid, typ, mcid, page in ordered:
        if typ == "P":
            tag_page[eid] = page

    # Build P elements per page.
    elems_by_page: Dict[int, List[Elem]] = {}
    for eid, typ, mcid, page in ordered:
        if typ != "P":
            continue
        cm = [m for (m, p) in cont.get(eid, []) if p == page]
        elems_by_page.setdefault(page, []).append(Elem(eid=eid, typ=typ, primary_mcid=mcid, page=page, cont_mcids=cm))

    doc = fitz.open(str(pdf_for_geom))
    merges: List[Tuple[int, int]] = []
    try:
        for page_num, elems in sorted(elems_by_page.items()):
            if page_num < 1 or page_num > len(doc):
                continue
            boundary = _detect_column_boundary(pdf_for_geom, page_num - 1)
            if boundary is None:
                continue
            page_h = float(doc[page_num - 1].rect.height)
            mcid_bbox = _extract_mcid_bboxes(pdf_for_geom, page_num)
            merges.extend(_find_merges_for_page(elems, boundary, page_h, mcid_bbox, pdf_for_geom))
    finally:
        doc.close()

    if not merges:
        aux_out.write_text(aux_txt)
        return 0

    # Decide rewrites: right_eid -> left_eid.
    rewrite_parent: Dict[int, int] = {right: left for (left, right) in merges}
    drop_ids = set(rewrite_parent.keys())

    # For each right_eid, collect its MCIDs (primary + cont on same page) to move into left as cont.
    right_to_mcids: Dict[int, List[Tuple[int, int]]] = {}
    for eid, typ, mcid, page in ordered:
        if eid in drop_ids and typ == "P":
            right_to_mcids.setdefault(eid, []).append((mcid, page))
    for rid in drop_ids:
        # IMPORTANT: only move MCIDs on the same page as the merged paragraph.
        # This script is for *cross-column on the same page* merges. Cross-page
        # paragraph stitching is a different, harder problem.
        rp = tag_page.get(rid)
        for mcid, page in cont.get(rid, []):
            if rp is not None and page != rp:
                continue
            right_to_mcids.setdefault(rid, []).append((mcid, page))

    # Rewrite aux line-by-line.
    out_lines: List[str] = []
    for ln in aux_txt.splitlines(keepends=True):
        m = _TAG_DATA_RE.search(ln)
        if m:
            eid = int(m.group(1))
            typ = m.group(2)
            if eid in drop_ids and typ == "P":
                # drop the right paragraph tag_data
                continue

        m = _MCID_CONT_RE.search(ln)
        if m:
            eid = int(m.group(1))
            if eid in drop_ids:
                continue

        m = _TAG_END_RE.search(ln)
        if m:
            eid = int(m.group(1))
            if eid in drop_ids:
                continue

        m = _TAG_ATOM_RE.search(ln)
        if m:
            parent_raw = (m.group(5) or "").strip()
            if parent_raw.isdigit():
                pid = int(parent_raw)
                if pid in rewrite_parent:
                    new_pid = rewrite_parent[pid]
                    ln = re.sub(r"(\\lpsb@tag@atom\{\d+\}\{[^}]+\}\{\d+\}\{\d+\}\{)(\d+)(\})",
                                r"\g<1>" + str(new_pid) + r"\g<3>", ln, count=1)

        out_lines.append(ln)

        # After we see the left paragraph's tag_data line, inject moved mcids as cont.
        m = _TAG_DATA_RE.search(ln)
        if m:
            eid = int(m.group(1))
            typ = m.group(2)
            if typ == "P":
                # inject any right paragraph mcids that should now belong to this eid.
                moved = []
                for rid, lid in rewrite_parent.items():
                    if lid != eid:
                        continue
                    for mcid, page in right_to_mcids.get(rid, []):
                        moved.append((mcid, page))
                if moved:
                    for mcid, page in sorted(set(moved)):
                        out_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{mcid}}}{{{page}}}% merged-crosscol\n")

    out_lines.append("\n% --- LPSB: merged cross-column split paragraphs ---\n")
    for l, r in merges:
        out_lines.append(f"% Merged right P elem {r} into left P elem {l}\n")

    aux_out.write_text("".join(out_lines))
    if verbose:
        print(f"merged_pairs={len(merges)} -> {aux_out}")
    return len(merges)


def main() -> int:
    ap = argparse.ArgumentParser(description="Merge cross-column split paragraphs in aux (two-column layout)")
    ap.add_argument("aux", type=Path, help="Input aux file")
    ap.add_argument("pdf", type=Path, help="PDF to extract geometry from (tagged or fixed)")
    ap.add_argument("-o", "--output", type=Path, required=True, help="Output aux path")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    if not args.aux.exists():
        raise SystemExit(f"aux not found: {args.aux}")
    if not args.pdf.exists():
        raise SystemExit(f"pdf not found: {args.pdf}")

    n = merge_split_paragraphs(args.aux, args.pdf, args.output, verbose=bool(args.verbose))
    if args.verbose:
        print(f"done merges={n}")
    return 0


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py merge-split-paragraphs ...

