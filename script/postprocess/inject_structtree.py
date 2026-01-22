#!/usr/bin/env python3
"""
inject_structtree.py - Inject StructTree into PDF using pikepdf

This script builds and injects a complete PDF StructTree using the document
hierarchy parsed from the aux file. Uses pikepdf for proper PDF object manipulation.

Usage:
  python3 inject_structtree.py input.pdf --aux input.aux -o output.pdf
"""

import argparse
import json
from pathlib import Path
from typing import Dict, List, Optional, Any

from pikepdf import Pdf, Name, Array, Dictionary

from ..parsing.parse_lpsb_mcid import parse_aux_file, reconcile_element_pages
from ..parsing.build_doc_tree import build_tree


def _read_order_map_json(path: Path) -> Optional[Dict[int, int]]:
    """Read {"order_by_elem_id": {"27": 1, ...}} style JSON into {27: 1, ...}."""
    try:
        raw = json.loads(path.read_text(errors="replace"))
    except Exception as e:
        raise RuntimeError(f"[structtree] failed to read/parse order-map JSON: {path} ({e})") from e

    d = raw.get("order_by_elem_id", raw) if isinstance(raw, dict) else None
    if not isinstance(d, dict):
        raise RuntimeError(f"[structtree] invalid order-map JSON schema (expected dict): {path}")

    out: Dict[int, int] = {}
    for k, v in d.items():
        try:
            out[int(k)] = int(v)
        except Exception:
            continue
    if not out:
        raise RuntimeError(f"[structtree] order-map JSON contained no usable entries: {path}")
    return out


def _guess_order_map_paths(pdf_path: Path, aux_path: Path) -> List[Path]:
    # Mirror lpsb_compiler / visualize_mcid conventions.
    cands: List[Path] = []
    try:
        cands.append(aux_path.with_name("main.order.json"))
        cands.append(aux_path.with_suffix(".order.json"))
    except Exception:
        pass
    try:
        cands.append(pdf_path.with_name("main.order.json"))
        cands.append(pdf_path.with_suffix(".order.json"))
    except Exception:
        pass
    # De-dup while preserving order.
    out: List[Path] = []
    seen = set()
    for p in cands:
        s = str(p)
        if s in seen:
            continue
        seen.add(s)
        out.append(p)
    return out


def _default_order_map_output(aux_path: Path, pdf_path: Path) -> Path:
    # Prefer stable "main.order.json" when we're operating on main.aux*.
    n = aux_path.name
    if n.startswith("main.aux"):
        return aux_path.with_name("main.order.json")
    # Otherwise keep it adjacent to aux, derived from aux basename.
    try:
        return aux_path.with_suffix(".order.json")
    except Exception:
        return pdf_path.with_suffix(".order.json")


def _get_order_map(pdf_path: Path, aux_path: Path, verbose: bool = False) -> Optional[Dict[int, int]]:
    """
    Resolve reading-order map in this priority:
    1) Explicit --order-map (stashed in inject_structtree._order_map_path)
    2) Auto-detect adjacent *.order.json
    3) Compute on the fly (latex-mode) and write to disk for reuse
    """
    # 1) Explicit order-map JSON.
    p0 = getattr(inject_structtree, "_order_map_path", None)
    if p0:
        p = Path(str(p0))
        if not p.exists():
            raise RuntimeError(f"[structtree] --order-map not found: {p}")
        m = _read_order_map_json(p)
        if verbose:
            print(f"[structtree] order-map: {p}")
        return m

    # 2) Auto-detect near aux/pdf.
    for p in _guess_order_map_paths(pdf_path, aux_path):
        if not p.exists():
            continue
        m = _read_order_map_json(p)
        if verbose:
            print(f"[structtree] order-map(auto): {p}")
        return m

    # 3) Compute on demand.
    # Local import: keep start-up cost low.
    try:
        from script.postprocess.compute_order_map import compute_order_map
    except ImportError:
        from compute_order_map import compute_order_map  # type: ignore

    m = compute_order_map(aux_path, pdf_path, mode="mixed", verbose=bool(verbose))
    if not m:
        raise RuntimeError("[structtree] computed order-map is empty (unexpected)")

    outp = _default_order_map_output(aux_path, pdf_path)
    payload = {"version": 1, "order_by_elem_id": {str(k): int(v) for k, v in m.items()}}
    outp.write_text(json.dumps(payload, indent=2))
    if verbose:
        print(f"[structtree] order-map(computed): wrote {outp}")
    return m


def load_doc_tree(aux_path: str) -> Dict:
    """Load or build document tree from aux file."""
    elements, summary = parse_aux_file(Path(aux_path))
    tree = build_tree(elements)
    tree["summary"] = summary
    return tree


def map_tag_to_pdf(lpsb_type: str) -> str:
    """Map LPSB tag type to standard PDF structure type."""
    mapping = {
        "Document": "Document",
        "H": "H",
        "H1": "H1",
        "H2": "H2",
        "H3": "H3",
        "P": "P",
        "L": "L",
        "LI": "LI",
        "Figure": "Figure",
        "Table": "Table",
        "Note": "Note",
        "Link": "Link",
        "Reference": "Reference",
        "BibList": "L",
        "BibEntry": "LI",
        "Em": "Span",
        "Strong": "Span",
        "InlineMath": "Span",
        "DisplayMath": "Formula",
        "Span": "Span",
    }
    return mapping.get(lpsb_type, "Span")


def create_struct_elem(pdf: Pdf, node: Dict, parent_obj, page_objs: List) -> Any:
    """Create a structure element for a node.
    
    Args:
        pdf: pikepdf Pdf object
        node: Node dict from build_doc_tree
        parent_obj: Parent structure element object
        page_objs: List of page objects indexed by page number (1-based)
    
    Returns:
        pikepdf structure element object (indirect reference)
    """
    tag_type = node.get("type", "Span")
    pdf_type = map_tag_to_pdf(tag_type)
    
    # Ensure pdf_type is not empty
    if not pdf_type:
        pdf_type = "Span"
    
    # Get the Name object - pikepdf requires Name.X syntax, not Name("X")
    # Use getattr to dynamically access Name attributes
    try:
        name_obj = getattr(Name, pdf_type)
    except AttributeError:
        # Fallback: some names may not be predefined in pikepdf
        # In this case, use the string directly
        name_obj = "/" + pdf_type
    
    # Create structure element dictionary using string keys
    struct_elem = Dictionary({
        "/Type": Name.StructElem,
        "/S": name_obj,
        "/P": parent_obj,
    })
    
    # Build K (kids) array
    kids = []
    
    # Add MCIDs as marked content references
    mcids = node.get("mcids", [])
    for m in mcids:
        page_num = m["page"]
        mcid = m["mcid"]
        
        if 1 <= page_num <= len(page_objs):
            # Create MCR (Marked Content Reference) using string keys
            # Note: page_objs are Page helpers, need .obj to get underlying object
            page_ref = page_objs[page_num - 1].obj
            mcr = Dictionary({
                "/Type": Name.MCR,
                "/Pg": page_ref,
                "/MCID": mcid,
            })
            kids.append(mcr)
    
    # Make this element indirect so children can reference it
    struct_elem_ref = pdf.make_indirect(struct_elem)
    
    # Recursively create child structure elements
    for child in node.get("children", []):
        if isinstance(child, dict) and "id" in child:
            child_elem = create_struct_elem(pdf, child, struct_elem_ref, page_objs)
            kids.append(child_elem)
    
    if kids:
        if len(kids) == 1:
            struct_elem_ref["/K"] = kids[0]
        else:
            struct_elem_ref["/K"] = Array(kids)
    
    return struct_elem_ref


def inject_structtree(pdf_path: str, aux_path: str, output_path: str, verbose: bool = False) -> bool:
    """Inject StructTree into PDF using pikepdf.
    
    Returns True if successful.
    """
    # Load elements first; build tree with optional external ordering.
    elements, summary = parse_aux_file(Path(aux_path))
    
    # Reconcile element pages with PDF (fixes "Phantom Figure" float issues)
    reconcile_element_pages(elements, Path(pdf_path), verbose=bool(verbose))
    
    order_map = _get_order_map(Path(pdf_path), Path(aux_path), verbose=bool(verbose))

    tree = build_tree(elements, order_map=order_map)
    tree["summary"] = summary
    
    if verbose:
        print(f"Document tree loaded")
        root = tree["root"]
        print(f"  Root children: {len(root.get('children', []))}")
    
    # Open PDF with pikepdf
    pdf = Pdf.open(pdf_path, allow_overwriting_input=True)
    
    # Get page objects
    page_objs = list(pdf.pages)
    
    if verbose:
        print(f"PDF opened: {len(page_objs)} pages")
    
    # Create StructTreeRoot using string keys
    struct_tree_root = Dictionary({
        "/Type": Name.StructTreeRoot,
    })
    struct_tree_root_ref = pdf.make_indirect(struct_tree_root)
    
    # Create root Document element
    root_node = tree["root"]
    doc_elem = Dictionary({
        "/Type": Name.StructElem,
        "/S": Name.Document,
        "/P": struct_tree_root_ref,
    })
    doc_elem_ref = pdf.make_indirect(doc_elem)
    
    # Build children recursively
    kids = []
    for child in root_node.get("children", []):
        if isinstance(child, dict) and "id" in child:
            child_elem = create_struct_elem(pdf, child, doc_elem_ref, page_objs)
            kids.append(child_elem)
    
    if kids:
        doc_elem_ref["/K"] = Array(kids)
    
    # Set StructTreeRoot K to document element
    struct_tree_root_ref["/K"] = doc_elem_ref
    
    # Add StructTreeRoot to catalog
    pdf.Root["/StructTreeRoot"] = struct_tree_root_ref
    
    # Mark as tagged PDF
    if "/MarkInfo" not in pdf.Root:
        pdf.Root["/MarkInfo"] = Dictionary()
    pdf.Root["/MarkInfo"]["/Marked"] = True
    
    if verbose:
        print(f"StructTree created with {len(kids)} top-level children")
    
    # Save
    pdf.save(output_path)
    pdf.close()
    
    if verbose:
        print(f"Saved to: {output_path}")
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Inject StructTree into PDF using document tree from aux file"
    )
    parser.add_argument("pdf", help="Input PDF file")
    parser.add_argument("--aux", required=True, help="Auxiliary file with tag data")
    parser.add_argument("--order-map", help="Optional JSON mapping elem_id->order for reading order")
    parser.add_argument("-o", "--output", help="Output PDF file")
    parser.add_argument("-v", "--verbose", action="store_true", help="Verbose output")
    
    args = parser.parse_args()
    
    pdf_path = Path(args.pdf)
    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}")
        return 1
    
    aux_path = Path(args.aux)
    if not aux_path.exists():
        print(f"Error: Aux file not found: {aux_path}")
        return 1
    
    output_path = args.output or str(pdf_path.parent / (pdf_path.stem + "_tagged.pdf"))
    
    try:
        # Stash order-map path for inject_structtree() without changing its signature.
        if args.order_map:
            inject_structtree._order_map_path = args.order_map  # type: ignore[attr-defined]
        success = inject_structtree(str(pdf_path), str(aux_path), output_path, args.verbose)
        
        if success:
            print(f"✓ StructTree injected: {output_path}")
        else:
            print("✗ StructTree injection failed")
            return 1
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py inject-structtree ...
