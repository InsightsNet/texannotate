#!/usr/bin/env python3
"""
LaTeXML → LPSB bridge

Converts LaTeXML-generated XHTML (+ MathML) into LPSB-sidecar JSON files that can be
merged into the pdflatex "gold" structure stream via `script/merge_lpsb.py`.

Alignment strategy (best-effort):
  - Math: pair LaTeXML MathML <math> nodes in document order with pdflatex-emitted
    math events in document order (Formula start + InlineMath atom).
  - Tables: pair LaTeXML <table> nodes in document order with pdflatex-emitted
    Table start events in document order.

This intentionally does NOT emit coordinates; pdflatex aux/PDF remain the gold standard.
"""

from __future__ import annotations

import argparse
import copy
import json
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional, Sequence, Tuple


MATHML_NS = "http://www.w3.org/1998/Math/MathML"
LPSB_MARK_PREFIX = "LPSBMARK:"
_LPSB_MARK_RE = re.compile(r"LPSBMARK:([A-Za-z0-9._:-]+)")
_LPSB_MARK_TEX_RE = re.compile(r"\\lpsbMark\{[^}]*\}")


def _strip_ns(tag: str) -> str:
    if tag.startswith("{"):
        return tag.split("}", 1)[1]
    return tag


def _collapse_ws(s: str) -> str:
    return re.sub(r"\s+", " ", (s or "").strip())


def load_json_array(filepath: Path) -> List[dict]:
    """Load JSON array from file with minor fault tolerance (copied from merge_lpsb.py style)."""
    def _fix_latex_escapes(s: str) -> str:
        # LPSB's TeX-side JSON emitter may include raw TeX in string fields
        # (e.g. titles like "\hskip -1em.~Introduction"), which is not valid JSON
        # because "\h" is an invalid JSON escape sequence.
        #
        # We repair this by escaping backslashes that do not start a valid JSON escape.
        valid_escapes = set(['"', "\\", "/", "b", "f", "n", "r", "t"])
        out: List[str] = []
        i = 0
        while i < len(s):
            ch = s[i]
            if ch == "\\" and i + 1 < len(s):
                nxt = s[i + 1]
                if nxt in valid_escapes:
                    out.append(s[i:i + 2])
                    i += 2
                    continue
                if nxt == "u" and i + 5 < len(s):
                    hex4 = s[i + 2:i + 6]
                    if all(c in "0123456789abcdefABCDEF" for c in hex4):
                        out.append(s[i:i + 6])
                        i += 6
                        continue
                # Not a valid JSON escape -> escape the backslash itself.
                out.append("\\\\")
                i += 1
                continue
            out.append(ch)
            i += 1
        return "".join(out)

    try:
        content = filepath.read_text(encoding="utf-8").strip()
        if content.startswith("[") and not content.rstrip().endswith("]"):
            content = content.rstrip().rstrip(",") + "\n]"
        try:
            data = json.loads(content)
        except json.JSONDecodeError:
            data = json.loads(_fix_latex_escapes(content))
        if not isinstance(data, list):
            raise ValueError("not a JSON array")
        return data
    except FileNotFoundError:
        raise
    except Exception as e:
        raise RuntimeError(f"failed to load JSON array from {filepath}: {e}") from e


@dataclass(frozen=True)
class MathItem:
    mathml: str
    display: bool
    lpsb_id: Optional[str]


@dataclass(frozen=True)
class TableCell:
    row: int
    col: int
    text: str
    colspan: int
    rowspan: int


@dataclass(frozen=True)
class TableItem:
    rows: List[List[TableCell]]
    lpsb_id: Optional[str]


def _parse_xhtml(xhtml_path: Path) -> ET.Element:
    try:
        tree = ET.parse(xhtml_path)
        return tree.getroot()
    except Exception as e:
        raise RuntimeError(f"failed to parse XHTML {xhtml_path}: {e}") from e


def _find_marker_id(elem: ET.Element) -> Optional[str]:
    # We support two marker encodings:
    # 1) Element attribute: <... data-lpsb-id="Sec-..."/>
    # 2) Text marker: either "LPSBMARK:<id>" in a single text node, OR
    #    LaTeXML's common split form:
    #      <mtext>LPSBMARK:</mtext><mtext>Sec-0-IMath-1</mtext>
    nodes = list(elem.iter())
    for i, node in enumerate(nodes):
        marker = node.attrib.get("data-lpsb-id")
        if marker:
            return marker

        for txt in (node.text, node.tail):
            if not txt:
                continue
            m = _LPSB_MARK_RE.search(txt)
            if m:
                return m.group(1)

        # Split form: prefix and id in consecutive text nodes.
        if (node.text or "").strip() == LPSB_MARK_PREFIX:
            for j in range(i + 1, len(nodes)):
                nxt_txt = (nodes[j].text or "").strip()
                if not nxt_txt:
                    continue
                if re.fullmatch(r"[A-Za-z0-9._:-]+", nxt_txt):
                    return nxt_txt
                break
    return None


def _is_marker_element(elem: ET.Element) -> bool:
    if "data-lpsb-id" in elem.attrib:
        return True
    # Textual marker used in math mode.
    if len(list(elem)) == 0:
        txt = (elem.text or "").strip()
        if txt.startswith(LPSB_MARK_PREFIX):
            return True
    return False


def _strip_markers(elem: ET.Element) -> None:
    children = list(elem)
    i = 0
    while i < len(children):
        child = children[i]
        if _is_marker_element(child):
            # Remove the marker element itself.
            try:
                elem.remove(child)
            except ValueError:
                pass

            # Also remove the following sibling when LaTeXML split the marker as:
            #   <mtext>LPSBMARK:</mtext><mtext>Sec-...</mtext>
            if i + 1 < len(children):
                nxt = children[i + 1]
                if len(list(nxt)) == 0:
                    nxt_txt = (nxt.text or "").strip()
                    if nxt_txt and re.fullmatch(r"[A-Za-z0-9._:-]+", nxt_txt):
                        try:
                            elem.remove(nxt)
                        except ValueError:
                            pass
            i += 1
            continue

        _strip_markers(child)
        i += 1


def _clone_without_markers(elem: ET.Element) -> ET.Element:
    clone = copy.deepcopy(elem)
    _strip_markers(clone)
    if "data-lpsb-id" in clone.attrib:
        del clone.attrib["data-lpsb-id"]
    # Also strip TeX-side markers that LaTeXML may preserve in attributes like
    # alttext="\lpsbMark{...}...". These markers are only for alignment and
    # should not leak into the exported MathML payload.
    for node in clone.iter():
        if not node.attrib:
            continue
        for k, v in list(node.attrib.items()):
            if not isinstance(v, str) or "\\lpsbMark" not in v:
                continue
            vv = _LPSB_MARK_TEX_RE.sub("", v)
            # Normalize whitespace after removal; keep it simple and safe.
            vv = re.sub(r"\s+", " ", vv).strip()
            node.attrib[k] = vv
    return clone


def extract_math_items(xhtml_path: Path) -> List[MathItem]:
    root = _parse_xhtml(xhtml_path)
    items: List[MathItem] = []
    for el in root.iter():
        if el.tag == f"{{{MATHML_NS}}}math" or _strip_ns(el.tag) == "math":
            # Be conservative: only accept MathML namespace when available.
            if el.tag != f"{{{MATHML_NS}}}math" and el.attrib.get("xmlns") != MATHML_NS:
                continue
            display = (el.attrib.get("display") or "").lower() == "block"
            lpsb_id = _find_marker_id(el)
            clone = _clone_without_markers(el)
            mathml = ET.tostring(clone, encoding="unicode", method="xml")
            items.append(MathItem(mathml=mathml, display=display, lpsb_id=lpsb_id))
    return items


def _table_candidates(root: ET.Element) -> List[ET.Element]:
    tables = [el for el in root.iter() if _strip_ns(el.tag) == "table"]
    if not tables:
        return []
    primary: List[ET.Element] = []
    for t in tables:
        cls = (t.attrib.get("class") or "").lower()
        if "ltx_tabular" in cls or "ltx_table" in cls:
            primary.append(t)
    return primary or tables


def extract_table_items(xhtml_path: Path) -> List[TableItem]:
    root = _parse_xhtml(xhtml_path)
    tables = _table_candidates(root)
    out: List[TableItem] = []
    for t in tables:
        lpsb_id = _find_marker_id(t)
        t_clone = _clone_without_markers(t)
        rows: List[List[TableCell]] = []
        for tr in t_clone.iter():
            if _strip_ns(tr.tag) != "tr":
                continue
            row_idx = len(rows) + 1
            row_cells: List[TableCell] = []
            col_cursor = 0
            for cell in tr:
                if _strip_ns(cell.tag) not in ("td", "th"):
                    continue
                col_cursor += 1
                colspan = 1
                rowspan = 1
                try:
                    if cell.attrib.get("colspan"):
                        colspan = max(1, int(cell.attrib["colspan"]))
                except Exception:
                    colspan = 1
                try:
                    if cell.attrib.get("rowspan"):
                        rowspan = max(1, int(cell.attrib["rowspan"]))
                except Exception:
                    rowspan = 1
                text = _collapse_ws("".join(cell.itertext()))
                row_cells.append(
                    TableCell(
                        row=row_idx,
                        col=col_cursor,
                        text=text,
                        colspan=colspan,
                        rowspan=rowspan,
                    )
                )
                col_cursor += (colspan - 1)
            if row_cells:
                rows.append(row_cells)
        if rows:
            out.append(TableItem(rows=rows, lpsb_id=lpsb_id))
    return out


def _structure_math_targets(structure_events: Sequence[dict]) -> List[Tuple[str, str]]:
    targets: List[Tuple[str, str]] = []
    for ev in structure_events:
        role = ev.get("role")
        event = ev.get("event")
        eid = ev.get("id")
        if not eid or not isinstance(eid, str):
            continue
        # Display math containers
        if role == "Formula" and event == "start":
            targets.append((eid, "display"))
            continue
        # Inline math: one per math run (covers $...$ and \( ... \) via \everymath)
        # Backward compat: older runs used event=atom; newer runs use start/end.
        if role == "InlineMath" and event in ("atom", "start"):
            targets.append((eid, "inline"))
            continue
    return targets


def _structure_table_ids(structure_events: Sequence[dict]) -> List[str]:
    ids: List[str] = []
    for ev in structure_events:
        if ev.get("role") == "Table" and ev.get("event") == "start":
            eid = ev.get("id")
            if eid and isinstance(eid, str):
                ids.append(eid)
    return ids


def _write_json_array(path: Path, data: Sequence[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(list(data), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def build_math_events(structure_events: Sequence[dict], math_items: Sequence[MathItem]) -> Tuple[List[dict], dict]:
    targets = _structure_math_targets(structure_events)
    target_ids = {eid for eid, _ in targets}
    explicit = {mi.lpsb_id: mi for mi in math_items if mi.lpsb_id}

    matched_ids = set()
    out: List[dict] = []

    # 1) Explicit ID matches, in structure order
    for eid, _kind in targets:
        mi = explicit.get(eid)
        if not mi:
            continue
        matched_ids.add(eid)
        out.append(
            {
                "id": eid,
                "role": "Math",
                "event": "start",
                "display": bool(mi.display),
                "mathml": mi.mathml,
                "source": "latexml",
            }
        )
        out.append({"id": eid, "role": "Math", "event": "end", "source": "latexml"})

    # 2) Fallback: pair remaining items by order (prefer display/inline)
    remaining_targets = [(eid, kind) for eid, kind in targets if eid not in matched_ids]
    remaining_items = [mi for mi in math_items if not mi.lpsb_id]
    paired_fallback: List[Tuple[str, MathItem]] = []
    pool = list(remaining_items)
    for eid, kind in remaining_targets:
        if not pool:
            break
        pick_idx = None
        if kind == "display":
            for i, mi in enumerate(pool):
                if mi.display:
                    pick_idx = i
                    break
        else:
            for i, mi in enumerate(pool):
                if not mi.display:
                    pick_idx = i
                    break
        if pick_idx is None:
            pick_idx = 0
        mi = pool.pop(pick_idx)
        paired_fallback.append((eid, mi))

    for eid, mi in paired_fallback:
        out.append(
            {
                "id": eid,
                "role": "Math",
                "event": "start",
                "display": bool(mi.display),
                "mathml": mi.mathml,
                "source": "latexml",
            }
        )
        out.append({"id": eid, "role": "Math", "event": "end", "source": "latexml"})

    paired_count = len(matched_ids) + len(paired_fallback)
    stats = {
        "structure_math_targets": len(targets),
        "latexml_math_nodes": len(math_items),
        "paired": paired_count,
        "explicit": len(matched_ids),
    }
    return out, stats


def build_table_events(structure_events: Sequence[dict], table_items: Sequence[TableItem]) -> Tuple[List[dict], dict]:
    ids = _structure_table_ids(structure_events)
    explicit = {ti.lpsb_id: ti for ti in table_items if ti.lpsb_id}
    matched_ids = set()
    stats = {
        "structure_table_targets": len(ids),
        "latexml_tables": len(table_items),
        "paired": 0,
        "explicit": 0,
    }
    out: List[dict] = []

    # 1) Explicit ID matches in structure order
    for tid in ids:
        table = explicit.get(tid)
        if not table:
            continue
        matched_ids.add(tid)
        stats["explicit"] += 1
        out.append({"id": tid, "role": "Table", "event": "start", "container": tid, "source": "latexml"})
        max_cols = 0
        for row_cells in table.rows:
            if row_cells:
                max_cols = max(max_cols, max(c.col + c.colspan - 1 for c in row_cells))
        if max_cols > 0:
            out.append(
                {
                    "id": tid,
                    "role": "TableMeta",
                    "event": "cols",
                    "cols": max_cols,
                    "container": tid,
                    "source": "latexml",
                }
            )
        for r, row_cells in enumerate(table.rows, start=1):
            tr_id = f"{tid}-TR{r}"
            out.append({"id": tr_id, "role": "TR", "event": "start", "row": r, "container": tid, "source": "latexml"})
            for cell in row_cells:
                td_id = f"{tr_id}-TD{cell.col}"
                ev = {
                    "id": td_id,
                    "role": "TD",
                    "event": "start",
                    "row": cell.row,
                    "col": cell.col,
                    "colspan": cell.colspan,
                    "rowspan": cell.rowspan,
                    "text": cell.text,
                    "container": tid,
                    "unit": "none",
                    "source": "latexml",
                }
                out.append(ev)
                out.append({"id": td_id, "role": "TD", "event": "end", "container": tid, "source": "latexml"})
            out.append({"id": tr_id, "role": "TR", "event": "end", "row": r, "container": tid, "source": "latexml"})
        out.append({"id": tid, "role": "Table", "event": "end", "container": tid, "source": "latexml"})

    # 2) Fallback: order pairing for tables without explicit IDs
    remaining_ids = [tid for tid in ids if tid not in matched_ids]
    remaining_items = [ti for ti in table_items if not ti.lpsb_id]
    n = min(len(remaining_ids), len(remaining_items))
    for i in range(n):
        tid = remaining_ids[i]
        table = remaining_items[i]
        out.append({"id": tid, "role": "Table", "event": "start", "container": tid, "source": "latexml"})
        max_cols = 0
        for row_cells in table.rows:
            if row_cells:
                max_cols = max(max_cols, max(c.col + c.colspan - 1 for c in row_cells))
        if max_cols > 0:
            out.append(
                {
                    "id": tid,
                    "role": "TableMeta",
                    "event": "cols",
                    "cols": max_cols,
                    "container": tid,
                    "source": "latexml",
                }
            )
        for r, row_cells in enumerate(table.rows, start=1):
            tr_id = f"{tid}-TR{r}"
            out.append({"id": tr_id, "role": "TR", "event": "start", "row": r, "container": tid, "source": "latexml"})
            for cell in row_cells:
                td_id = f"{tr_id}-TD{cell.col}"
                ev = {
                    "id": td_id,
                    "role": "TD",
                    "event": "start",
                    "row": cell.row,
                    "col": cell.col,
                    "colspan": cell.colspan,
                    "rowspan": cell.rowspan,
                    "text": cell.text,
                    "container": tid,
                    "unit": "none",
                    "source": "latexml",
                }
                out.append(ev)
                out.append({"id": td_id, "role": "TD", "event": "end", "container": tid, "source": "latexml"})
            out.append({"id": tr_id, "role": "TR", "event": "end", "row": r, "container": tid, "source": "latexml"})
        out.append({"id": tid, "role": "Table", "event": "end", "container": tid, "source": "latexml"})
    stats["paired"] = len(matched_ids) + n
    return out, stats


def main(argv: Optional[Sequence[str]] = None) -> int:
    p = argparse.ArgumentParser(description="Convert LaTeXML XHTML to LPSB math/table JSON sidecars")
    p.add_argument("--structure", required=True, help="Path to pdflatex-produced *.lpsb.json")
    p.add_argument("--xhtml", required=True, help="Path to LaTeXML-produced XHTML (with MathML)")
    p.add_argument("--out-math", default="", help="Write *.lpsb-math.json to this path (optional)")
    p.add_argument("--out-table", default="", help="Write *.lpsb-table.json to this path (optional)")
    args = p.parse_args(argv)

    structure_path = Path(args.structure)
    xhtml_path = Path(args.xhtml)
    out_math = Path(args.out_math) if args.out_math else None
    out_table = Path(args.out_table) if args.out_table else None

    structure_events = load_json_array(structure_path)
    math_items = extract_math_items(xhtml_path)
    table_items = extract_table_items(xhtml_path)

    math_events, math_stats = build_math_events(structure_events, math_items)
    table_events, table_stats = build_table_events(structure_events, table_items)

    print("LaTeXML→LPSB stats:", file=sys.stderr)
    math_explicit = math_stats.get("explicit", 0)
    table_explicit = table_stats.get("explicit", 0)
    print(
        f"  math:  targets={math_stats['structure_math_targets']} latexml={math_stats['latexml_math_nodes']} paired={math_stats['paired']} explicit={math_explicit}",
        file=sys.stderr,
    )
    print(
        f"  table: targets={table_stats['structure_table_targets']} latexml={table_stats['latexml_tables']} paired={table_stats['paired']} explicit={table_explicit}",
        file=sys.stderr,
    )

    if out_math:
        _write_json_array(out_math, math_events)
    if out_table:
        _write_json_array(out_table, table_events)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
