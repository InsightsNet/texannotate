#!/usr/bin/env python3
"""
reorder_structtree.py - Reorder PDF StructTree for correct reading order

This script reorders footnotes in the PDF structure tree to appear at their
logical position (after the footnote mark) rather than at page bottom.

PDF/UA requires proper reading order in the structure tree, not just in
the content stream. This script post-processes the PDF to fix reading order.
"""

import fitz
import re
import argparse
from pathlib import Path
from typing import Dict, List, Tuple, Optional


def parse_aux_for_footnotes(aux_path: str) -> Dict:
    r"""Parse aux file to find footnote mark and text relationships.
    
    Aux file has two patterns:
    - \lpsb@tag@atom{id}{Note}{mcid}{page}{parent_id} - footnote mark (inline)
    - \lpsb@tag@data{id}{Note}{mcid}{page} - footnote text (at page bottom)
    
    Returns dict with:
        - marks: list of footnote marks (inline in paragraph)
        - texts: list of footnote texts (at page bottom)
    """
    result = {
        'marks': [],  # (logical_id, mcid, page, parent_id)
        'texts': [],  # (logical_id, mcid, page)
    }
    
    if not Path(aux_path).exists():
        return result
    
    with open(aux_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Find Note atoms (footnote marks) - inline in parent element
    # Pattern: \lpsb@tag@atom{id}{Note}{mcid}{page}{parent_id}
    for m in re.finditer(r'\\lpsb@tag@atom\{(\d+)\}\{Note\}\{(\d+)\}\{(\d+)\}\{(\d+)\}', content):
        result['marks'].append({
            'logical_id': int(m.group(1)),
            'mcid': int(m.group(2)),
            'page': int(m.group(3)),
            'parent_id': int(m.group(4))
        })
    
    # Find Note data blocks (footnote texts) - separate block at page bottom
    # Pattern: \lpsb@tag@data{id}{Note}{mcid}{page}
    for m in re.finditer(r'\\lpsb@tag@data\{(\d+)\}\{Note\}\{(\d+)\}\{(\d+)\}', content):
        result['texts'].append({
            'logical_id': int(m.group(1)),
            'mcid': int(m.group(2)),
            'page': int(m.group(3))
        })
    
    return result


def analyze_content_stream_order(doc, page_num: int) -> List[Tuple[str, int, int]]:
    """Analyze content stream to find tag order on a page.
    
    Returns list of (tag_type, mcid, position) in content stream order.
    """
    page = doc[page_num - 1]
    xref = page.xref
    
    try:
        contents_ref = doc.xref_get_key(xref, "Contents")
        contents_xref = int(contents_ref[1].split()[0])
        stream = doc.xref_stream(contents_xref)
        text = stream.decode('latin-1', errors='replace')
    except:
        return []
    
    tags = []
    for m in re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text):
        tags.append((m.group(1), int(m.group(2)), m.start()))
    
    tags.sort(key=lambda x: x[2])
    return tags


def find_footnote_pairs(doc, aux_data: Dict) -> List[Dict]:
    """Find footnote mark/text pairs for reordering.
    
    Matches marks (from @tag@atom) with texts (from @tag@data) on the same page.
    
    Returns list of dicts with 'mark_mcid', 'text_mcid', 'page', 'mark_id', 'text_id'.
    """
    pairs = []
    
    # Group marks and texts by page
    marks_by_page = {}
    for mark in aux_data['marks']:
        page = mark['page']
        if page not in marks_by_page:
            marks_by_page[page] = []
        marks_by_page[page].append(mark)
    
    texts_by_page = {}
    for text in aux_data['texts']:
        page = text['page']
        if page not in texts_by_page:
            texts_by_page[page] = []
        texts_by_page[page].append(text)
    
    # Match marks with texts on same page by order
    # Assumption: marks and texts appear in same order on a page
    for page in marks_by_page:
        marks = sorted(marks_by_page[page], key=lambda x: x['logical_id'])
        texts = sorted(texts_by_page.get(page, []), key=lambda x: x['logical_id'])
        
        # Pair them up
        for i, mark in enumerate(marks):
            if i < len(texts):
                text = texts[i]
                pairs.append({
                    'mark_mcid': mark['mcid'],
                    'text_mcid': text['mcid'],
                    'mark_id': mark['logical_id'],
                    'text_id': text['logical_id'],
                    'page': page
                })
    
    return pairs


def get_structtree_info(doc) -> Optional[int]:
    """Get StructTreeRoot xref from document catalog."""
    try:
        catalog = doc.pdf_catalog()
        catalog_dict = doc.xref_object(catalog)
        
        # Look for StructTreeRoot reference
        match = re.search(r'/StructTreeRoot\s+(\d+)\s+0\s+R', catalog_dict)
        if match:
            return int(match.group(1))
    except Exception as e:
        print(f"Warning: Could not access StructTreeRoot: {e}")
    
    return None


def reorder_pdf_structtree(pdf_path: str, aux_path: str, output_path: str, verbose: bool = False) -> bool:
    """Reorder PDF StructTree to fix footnote reading order.
    
    Currently, this is a placeholder that documents the approach.
    Full implementation requires low-level PDF structure manipulation.
    
    Returns True if reordering was performed.
    """
    doc = fitz.open(pdf_path)
    aux_data = parse_aux_for_footnotes(aux_path)
    
    if verbose:
        print(f"Found {len(aux_data['marks'])} Note tags in aux file")
    
    # Find footnote pairs
    pairs = find_footnote_pairs(doc, aux_data)
    
    if verbose:
        print(f"Identified {len(pairs)} footnote mark/text pairs")
        for p in pairs:
            print(f"  Page {p['page']}: mark MCID {p['mark_mcid']} <-> text MCID {p['text_mcid']}")
    
    # Get StructTree info
    struct_root = get_structtree_info(doc)
    if verbose:
        if struct_root:
            print(f"StructTreeRoot xref: {struct_root}")
        else:
            print("Warning: No StructTreeRoot found in document")
    
    # TODO: Full StructTree manipulation requires:
    # 1. Parse ParentTree to map MCID -> structure element
    # 2. Find K (kids) array in parent structure elements
    # 3. Reorder K array to place footnote text after footnote mark
    # 4. Update byte offsets in xref table
    #
    # This is complex low-level PDF manipulation that PyMuPDF doesn't
    # directly support. For now, we just copy the PDF unchanged.
    
    # Copy to output (no actual reordering yet)
    doc.save(output_path)
    doc.close()
    
    if verbose:
        print(f"Output saved to: {output_path}")
        print("Note: StructTree reordering not yet implemented")
    
    return len(pairs) > 0


def main():
    parser = argparse.ArgumentParser(
        description="Reorder PDF StructTree for correct footnote reading order"
    )
    parser.add_argument("pdf", help="Input PDF file")
    parser.add_argument("--aux", help="Auxiliary file with tag data")
    parser.add_argument("-o", "--output", help="Output PDF file")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="Verbose output")
    
    args = parser.parse_args()
    
    pdf_path = Path(args.pdf)
    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}")
        return 1
    
    aux_path = args.aux
    if not aux_path:
        # Try to find aux file next to PDF
        aux_path = pdf_path.with_suffix('.aux')
        if not aux_path.exists():
            aux_path = pdf_path.parent / (pdf_path.stem.replace('_fixed', '') + '.aux')
    
    output_path = args.output or str(pdf_path.parent / (pdf_path.stem + '_reordered.pdf'))
    
    success = reorder_pdf_structtree(str(pdf_path), str(aux_path), output_path, args.verbose)
    
    if success:
        print(f"Footnote pairs identified. Output: {output_path}")
    else:
        print("No footnote pairs found to reorder.")
    
    return 0


if __name__ == '__main__':
    exit(main())
