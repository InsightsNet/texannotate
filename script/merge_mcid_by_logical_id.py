#!/usr/bin/env python3
"""
merge_mcid_by_logical_id.py - Merge MCIDs belonging to the same logical element

This script reads the .aux file to find all MCID records (tag_data, mcid_cont, tag_atom),
groups them by logical element ID, and outputs a JSON with merged bounding boxes.

Output format:
{
  "elements": [
    {
      "logical_id": 143,
      "tag_type": "Table",
      "mcids": [145, 147, 149, ...],  
      "pages": [6],
      "bbox": {"x0": ..., "y0": ..., "x1": ..., "y1": ...}  # merged from all MCIDs
    },
    ...
  ]
}
"""

import fitz
import pdfplumber
import re
import argparse
import json
from pathlib import Path
from collections import defaultdict


def parse_aux_file(aux_path):
    """Parse all MCID records from aux file."""
    
    with open(aux_path, 'r') as f:
        content = f.read()
    
    elements = defaultdict(lambda: {
        'tag_type': None,
        'mcids': [],  # list of (mcid, page)
        'pages': set()
    })
    
    # Primary records: \lpsb@tag@data{logical_id}{type}{mcid}{page}
    for match in re.finditer(r'\\lpsb@tag@data\{(\d+)\}\{(\w+)\}\{(\d+)\}\{(\d+)\}', content):
        logical_id = int(match.group(1))
        tag_type = match.group(2)
        mcid = int(match.group(3))
        page = int(match.group(4))
        
        elements[logical_id]['tag_type'] = tag_type
        elements[logical_id]['mcids'].append((mcid, page))
        elements[logical_id]['pages'].add(page)
    
    # Continuation records: \lpsb@mcid@cont{logical_id}{mcid}{page}
    for match in re.finditer(r'\\lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}', content):
        logical_id = int(match.group(1))
        mcid = int(match.group(2))
        page = int(match.group(3))
        
        elements[logical_id]['mcids'].append((mcid, page))
        elements[logical_id]['pages'].add(page)
    
    # End records (for reference): \lpsb@tag@end{logical_id}{page}
    for match in re.finditer(r'\\lpsb@tag@end\{(\d+)\}\{(\d+)\}', content):
        logical_id = int(match.group(1))
        page = int(match.group(2))
        elements[logical_id]['pages'].add(page)
    
    return elements


def get_mcid_bbox_from_pdf(pdf_path, mcids_by_page):
    """Get bounding boxes for MCIDs using pdfplumber."""
    
    pdf = pdfplumber.open(pdf_path)
    results = {}  # mcid -> bbox
    
    for page_num, mcids in mcids_by_page.items():
        if page_num > len(pdf.pages):
            continue
        
        page = pdf.pages[page_num - 1]  # 0-indexed
        
        # Group characters by MCID
        mcid_chars = defaultdict(list)
        for char in page.chars:
            mcid = char.get('mcid')
            if mcid is not None and mcid in mcids:
                mcid_chars[mcid].append(char)
        
        # Calculate bbox for each MCID
        for mcid, chars in mcid_chars.items():
            if chars:
                x0 = min(c['x0'] for c in chars)
                y0 = min(c['top'] for c in chars)
                x1 = max(c['x1'] for c in chars)
                y1 = max(c['bottom'] for c in chars)
                results[mcid] = {'x0': x0, 'y0': y0, 'x1': x1, 'y1': y1, 'page': page_num}
    
    pdf.close()
    return results


def merge_bboxes(bboxes):
    """Merge multiple bboxes into one encompassing box."""
    if not bboxes:
        return None
    
    # Group by page
    by_page = defaultdict(list)
    for bbox in bboxes:
        if bbox:
            by_page[bbox['page']].append(bbox)
    
    merged = []
    for page, page_bboxes in sorted(by_page.items()):
        x0 = min(b['x0'] for b in page_bboxes)
        y0 = min(b['y0'] for b in page_bboxes)
        x1 = max(b['x1'] for b in page_bboxes)
        y1 = max(b['y1'] for b in page_bboxes)
        merged.append({
            'page': page,
            'x0': round(x0, 2),
            'y0': round(y0, 2),
            'x1': round(x1, 2),
            'y1': round(y1, 2)
        })
    
    return merged


def process_elements(aux_path, pdf_path, tag_types=None):
    """Process elements and merge MCIDs by logical ID."""
    
    # Parse aux file
    elements = parse_aux_file(aux_path)
    
    # Filter by tag type if specified
    if tag_types:
        elements = {k: v for k, v in elements.items() 
                   if v['tag_type'] in tag_types}
    
    print(f"Found {len(elements)} elements to process")
    
    # Collect all MCIDs by page
    mcids_by_page = defaultdict(set)
    for logical_id, info in elements.items():
        for mcid, page in info['mcids']:
            mcids_by_page[page].add(mcid)
    
    # Get bboxes from PDF
    mcid_bboxes = get_mcid_bbox_from_pdf(pdf_path, mcids_by_page)
    print(f"Got bboxes for {len(mcid_bboxes)} MCIDs")
    
    # Merge and build output
    output = []
    for logical_id, info in sorted(elements.items()):
        if not info['tag_type']:
            continue
        
        # Get all bboxes for this element's MCIDs
        element_bboxes = []
        for mcid, page in info['mcids']:
            if mcid in mcid_bboxes:
                element_bboxes.append(mcid_bboxes[mcid])
        
        merged = merge_bboxes(element_bboxes)
        
        output.append({
            'logical_id': logical_id,
            'tag_type': info['tag_type'],
            'mcid_count': len(info['mcids']),
            'mcids': [m for m, p in info['mcids']],
            'pages': sorted(info['pages']),
            'bboxes': merged or []
        })
    
    return output


def main():
    parser = argparse.ArgumentParser(description='Merge MCIDs by logical element ID')
    parser.add_argument('pdf', help='Input PDF file')
    parser.add_argument('--aux', help='Aux file (default: same name as PDF with .aux)')
    parser.add_argument('--output', '-o', help='Output JSON file')
    parser.add_argument('--types', '-t', nargs='+', 
                       help='Filter by tag types (e.g., Table Figure)')
    
    args = parser.parse_args()
    
    pdf_path = args.pdf
    aux_path = args.aux or pdf_path.replace('.pdf', '.aux')
    output_path = args.output or pdf_path.replace('.pdf', '_merged_mcids.json')
    
    if not Path(pdf_path).exists():
        print(f"Error: PDF not found: {pdf_path}")
        return 1
    
    if not Path(aux_path).exists():
        print(f"Error: Aux file not found: {aux_path}")
        return 1
    
    result = process_elements(aux_path, pdf_path, args.types)
    
    # Summary
    type_counts = defaultdict(int)
    for elem in result:
        type_counts[elem['tag_type']] += 1
    
    print(f"\nElement counts by type:")
    for tag_type, count in sorted(type_counts.items()):
        print(f"  {tag_type}: {count}")
    
    # Save output
    with open(output_path, 'w') as f:
        json.dump({'elements': result}, f, indent=2)
    
    print(f"\nSaved to: {output_path}")
    return 0


if __name__ == '__main__':
    exit(main())
