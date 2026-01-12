#!/usr/bin/env python3
"""
Build a simple document tree from lpsb-mcid aux structure.

Goal: provide a coarse hierarchy:
  Title(H) -> H1/H2/H3 -> block elements (P, Figure, Table, ...) -> inline atoms
  (Reference/Em/Strong/InlineMath/...) including parent_id + ref_key.

This is NOT a full PDF structure tree: we only have explicit parent_id for atoms.
For block nesting we use a pragmatic heuristic based on heading order.

Usage:
  python3 build_doc_tree.py input.aux -o tree.json
  python3 build_doc_tree.py input.aux input.pdf -o tree.json   # optional pdf ignored (reserved)
"""

import argparse
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from parse_lpsb_mcid import parse_aux_file, TaggedElement


@dataclass
class Node:
    id: int
    type: str
    is_atom: bool
    parent_id: Optional[int] = None
    ref_key: Optional[str] = None
    mcids: list = field(default_factory=list)
    start_page: int = 0
    end_page: int = 0
    children: List[int] = field(default_factory=list)


def _heading_level(tag_type: str) -> Optional[int]:
    t = (tag_type or "").strip()
    if t == "H":
        return 0
    if t == "H1":
        return 1
    if t == "H2":
        return 2
    if t == "H3":
        return 3
    return None


def _primary_mcid(e: TaggedElement) -> int:
    if not getattr(e, "mcids", None):
        return 0
    return int(e.mcids[0].mcid)


def _primary_page(e: TaggedElement) -> int:
    return int(getattr(e, "start_page", 0) or 0)


def _merge_split_headings(elements: List[TaggedElement]) -> List[TaggedElement]:
    """
    Merge the classic "split starred heading" pattern:
      Hn (MCID N) + P (MCID N+1, often empty) + P (MCID N+2, title text)

    We do NOT have access to actual text here, so we use a conservative,
    pattern-based heuristic to avoid eating normal paragraphs:
      - require both N+1 and (N+2 or N+3) P elements on the same page.

    Result:
      - move the later P's MCIDs into the heading element (as additional mcids)
      - drop that P element from the element list
    """
    by_id = {e.elem_id: e for e in elements}
    ordered = sorted([e for e in elements if not e.is_atom], key=lambda x: x.elem_id)

    drop_ids = set()
    promote: Dict[int, str] = {}  # pid -> Hn type

    for idx, h in enumerate(ordered):
        if h.tag_type not in ("H1", "H2", "H3"):
            continue
        h_mcid = _primary_mcid(h)
        if h_mcid <= 0:
            continue
        h_page = _primary_page(h)

        p_plus1 = None
        p_late = None
        p_bib = None
        saw_bib = False

        for j in range(idx + 1, min(idx + 7, len(ordered))):
            e = ordered[j]
            if _primary_page(e) != h_page:
                break

            if e.tag_type in ("BibList", "BibEntry"):
                saw_bib = True
                if p_bib is not None:
                    break
                continue

            if e.tag_type != "P":
                continue
            d = _primary_mcid(e) - h_mcid
            if d == 1 and p_plus1 is None:
                p_plus1 = e
            elif d in (2, 3):
                p_late = e
                if d == 2:
                    break
            if 0 < d <= 3 and p_bib is None:
                p_bib = e

        # Case A: classic staged-heading split (requires both +1 and +2/+3)
        if p_plus1 is not None and p_late is not None:
            promote[p_late.elem_id] = h.tag_type
            drop_ids.add(h.elem_id)
            continue

        # Case B: bibliography heading split (H? + P + BibList/BibEntry)
        if saw_bib and p_bib is not None:
            promote[p_bib.elem_id] = h.tag_type
            drop_ids.add(h.elem_id)
            continue

    if not drop_ids:
        return elements

    out: List[TaggedElement] = []
    for e in elements:
        if e.elem_id in drop_ids:
            continue
        if e.elem_id in promote:
            e.tag_type = promote[e.elem_id]
        out.append(e)
    return out


def build_tree(elements: List[TaggedElement]) -> Dict:
    elements = _merge_split_headings(elements)
    # Build node map.
    nodes: Dict[int, Node] = {}
    for e in elements:
        nodes[e.elem_id] = Node(
            id=e.elem_id,
            type=e.tag_type,
            is_atom=bool(e.is_atom),
            parent_id=e.parent_id,
            ref_key=getattr(e, "ref_key", None),
            mcids=[{"mcid": m.mcid, "page": m.page} for m in e.mcids],
            start_page=e.start_page,
            end_page=e.end_page,
        )

    # Root is synthetic.
    ROOT_ID = 0
    root = Node(id=ROOT_ID, type="Document", is_atom=False)

    # Attach block elements using heading stack heuristic.
    heading_stack: List[int] = []  # node ids (H/H1/H2/H3)

    def current_container() -> Node:
        if heading_stack:
            return nodes[heading_stack[-1]]
        return root

    # First pass: attach non-atom blocks.
    for e in sorted(elements, key=lambda x: x.elem_id):
        if e.is_atom:
            continue
        lvl = _heading_level(e.tag_type)
        if lvl is not None:
            # Maintain stack by heading level.
            while heading_stack:
                top_lvl = _heading_level(nodes[heading_stack[-1]].type)
                if top_lvl is None:
                    heading_stack.pop()
                    continue
                if top_lvl >= lvl:
                    heading_stack.pop()
                else:
                    break

            container = current_container()
            container.children.append(e.elem_id)
            nodes[e.elem_id].parent_id = container.id if container.id != ROOT_ID else None
            heading_stack.append(e.elem_id)
        else:
            container = current_container()
            container.children.append(e.elem_id)
            nodes[e.elem_id].parent_id = container.id if container.id != ROOT_ID else None

    # Second pass: attach atoms to their explicit parent_id.
    for e in sorted(elements, key=lambda x: x.elem_id):
        if not e.is_atom:
            continue
        pid = e.parent_id
        if pid is not None and pid in nodes:
            nodes[pid].children.append(e.elem_id)
        else:
            root.children.append(e.elem_id)

    def to_dict(n: Node) -> Dict:
        return {
            "id": n.id,
            "type": n.type,
            "is_atom": n.is_atom,
            "parent_id": n.parent_id,
            "ref_key": n.ref_key,
            "start_page": n.start_page,
            "end_page": n.end_page,
            "mcids": n.mcids,
            "children": [to_dict(nodes[c]) if c in nodes else {"id": c} for c in n.children],
        }

    return {
        "root": to_dict(root),
        "nodes": {str(k): {"id": v.id, "type": v.type, "is_atom": v.is_atom, "parent_id": v.parent_id, "ref_key": v.ref_key, "children": v.children} for k, v in nodes.items()},
    }


def main() -> int:
    ap = argparse.ArgumentParser(description="Build document tree from lpsb-mcid aux")
    ap.add_argument("aux", help="Path to .aux file")
    ap.add_argument("pdf", nargs="?", help="Optional PDF path (reserved)")
    ap.add_argument("-o", "--output", required=True, help="Output JSON path")
    args = ap.parse_args()

    aux_path = Path(args.aux)
    if not aux_path.exists():
        raise SystemExit(f"aux not found: {aux_path}")

    elements, summary = parse_aux_file(aux_path)
    tree = build_tree(elements)
    tree["summary"] = summary

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(tree, indent=2))
    print(f"✓ Wrote tree: {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

