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
      "bboxes": [
        {"page": 6, "x0": ..., "y0": ..., "x1": ..., "y1": ...},
        ...
      ]  # may contain multiple boxes per page for inline/atom tags
    },
    ...
  ]
}
"""

import pdfplumber
import re
import argparse
import json
from pathlib import Path
from collections import defaultdict
from statistics import median


def parse_aux_file(aux_path):
    """Parse all MCID records from aux file."""
    
    with open(aux_path, 'r') as f:
        content = f.read()
    
    elements = defaultdict(lambda: {
        'tag_type': None,
        'mcids': [],  # list of (mcid, page)
        'pages': set(),
        'is_atom': False,
        'parent_id': None,
    })
    
    # Primary records: \lpsb@tag@data{logical_id}{type}{mcid}{page}
    for match in re.finditer(r'\\lpsb@tag@data\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}', content):
        logical_id = int(match.group(1))
        tag_type = match.group(2)
        mcid = int(match.group(3))
        page = int(match.group(4))
        
        elements[logical_id]['tag_type'] = tag_type
        elements[logical_id]['mcids'].append((mcid, page))
        elements[logical_id]['pages'].add(page)

    # Atom records (inline): \lpsb@tag@atom{logical_id}{type}{mcid}{page}{parent_id?}
    for match in re.finditer(r'\\lpsb@tag@atom\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}\{([^}]*)\}', content):
        logical_id = int(match.group(1))
        tag_type = match.group(2)
        mcid = int(match.group(3))
        page = int(match.group(4))
        parent_raw = (match.group(5) or "").strip()
        parent_id = int(parent_raw) if parent_raw.isdigit() else None

        elements[logical_id]['tag_type'] = tag_type
        elements[logical_id]['is_atom'] = True
        elements[logical_id]['parent_id'] = parent_id
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


def get_mcid_bbox_from_pdf(pdf_path, mcids_by_page, split_lines=False):
    """Get bounding boxes for MCIDs using pdfplumber.

    If split_lines is True, split one MCID into multiple per-line boxes using
    simple y-clustering of chars. This is the hook for "方案 B".
    """
    
    pdf = pdfplumber.open(pdf_path)
    results = {}  # mcid -> list[bbox]
    
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
                if not split_lines:
                    x0 = min(c['x0'] for c in chars)
                    y0 = min(c['top'] for c in chars)
                    x1 = max(c['x1'] for c in chars)
                    y1 = max(c['bottom'] for c in chars)
                    results[mcid] = [{'x0': x0, 'y0': y0, 'x1': x1, 'y1': y1, 'page': page_num}]
                    continue

                # Split into lines by y-center clustering.
                chars = sorted(chars, key=lambda c: (c.get('top', 0.0), c.get('x0', 0.0)))
                heights = []
                for c in chars:
                    try:
                        h = float(c.get('bottom', 0.0)) - float(c.get('top', 0.0))
                        if h > 0:
                            heights.append(h)
                    except Exception:
                        pass
                med_h = median(heights) if heights else 10.0
                y_tol = max(1.0, min(6.0, 0.50 * med_h))

                lines = []
                cur = []
                cur_cy = None
                for c in chars:
                    cy = 0.5 * (float(c.get('top', 0.0)) + float(c.get('bottom', 0.0)))
                    if cur and cur_cy is not None and abs(cy - cur_cy) > y_tol:
                        lines.append(cur)
                        cur = [c]
                        cur_cy = cy
                    else:
                        cur.append(c)
                        # update running center (robust to a few outliers)
                        if cur_cy is None:
                            cur_cy = cy
                        else:
                            cur_cy = 0.7 * cur_cy + 0.3 * cy
                if cur:
                    lines.append(cur)

                out = []
                for ln in lines:
                    x0 = min(c['x0'] for c in ln)
                    y0 = min(c['top'] for c in ln)
                    x1 = max(c['x1'] for c in ln)
                    y1 = max(c['bottom'] for c in ln)
                    out.append({'x0': x0, 'y0': y0, 'x1': x1, 'y1': y1, 'page': page_num})
                results[mcid] = out
    
    pdf.close()
    return results


def _overlap_1d(a0, a1, b0, b1):
    return max(0.0, min(a1, b1) - max(a0, b0))


def _merge_bbox_list(page, bboxes):
    x0 = min(b['x0'] for b in bboxes)
    y0 = min(b['y0'] for b in bboxes)
    x1 = max(b['x1'] for b in bboxes)
    y1 = max(b['y1'] for b in bboxes)
    return {
        'page': page,
        'x0': round(x0, 2),
        'y0': round(y0, 2),
        'x1': round(x1, 2),
        'y1': round(y1, 2),
    }


def merge_bboxes(bboxes, mode='line'):
    """Merge bboxes for an element.

    mode:
      - 'page': one bbox per page (old behavior; can over-merge inline wraps)
      - 'line': multiple bboxes per page, clustered by line + proximity
      - 'mcid': keep each MCID bbox as-is
    """
    if not bboxes:
        return []

    by_page = defaultdict(list)
    for bbox in bboxes:
        if bbox:
            by_page[bbox['page']].append(bbox)

    merged = []
    for page, page_bboxes in sorted(by_page.items()):
        if mode == 'mcid':
            for b in page_bboxes:
                merged.append({
                    'page': page,
                    'x0': round(b['x0'], 2),
                    'y0': round(b['y0'], 2),
                    'x1': round(b['x1'], 2),
                    'y1': round(b['y1'], 2),
                })
            continue

        if mode == 'page':
            merged.append(_merge_bbox_list(page, page_bboxes))
            continue

        # mode == 'line'
        heights = [(b['y1'] - b['y0']) for b in page_bboxes if (b['y1'] - b['y0']) > 0]
        med_h = median(heights) if heights else 10.0
        y_tol = max(1.0, min(12.0, 0.60 * med_h))
        x_tol = max(2.0, 3.00 * med_h)

        # Stable order: top-to-bottom, left-to-right.
        page_bboxes = sorted(page_bboxes, key=lambda b: (b['y0'], b['x0']))

        clusters = []
        for b in page_bboxes:
            bx0, by0, bx1, by1 = b['x0'], b['y0'], b['x1'], b['y1']
            bcy = 0.5 * (by0 + by1)

            best_i = None
            best_score = None
            for i, c in enumerate(clusters):
                cy0, cy1 = c['y0'], c['y1']
                cc_y = c['cy']
                ch = max(0.1, cy1 - cy0)

                y_overlap = _overlap_1d(by0, by1, cy0, cy1)
                same_line = (y_overlap >= 0.20 * min(by1 - by0, ch)) or (abs(bcy - cc_y) <= y_tol)
                if not same_line:
                    continue

                # Prevent "bridging" across large horizontal gaps (columns / unrelated spans).
                if bx1 < c['x0']:
                    x_gap = c['x0'] - bx1
                elif c['x1'] < bx0:
                    x_gap = bx0 - c['x1']
                else:
                    x_gap = 0.0
                if x_gap > x_tol:
                    continue

                score = (y_overlap, -abs(bcy - cc_y), -x_gap)
                if best_score is None or score > best_score:
                    best_score = score
                    best_i = i

            if best_i is None:
                clusters.append({
                    'bboxes': [b],
                    'x0': bx0, 'y0': by0, 'x1': bx1, 'y1': by1,
                    'cy': bcy,
                })
                continue

            c = clusters[best_i]
            c['bboxes'].append(b)
            c['x0'] = min(c['x0'], bx0)
            c['y0'] = min(c['y0'], by0)
            c['x1'] = max(c['x1'], bx1)
            c['y1'] = max(c['y1'], by1)
            c['cy'] = 0.5 * (c['y0'] + c['y1'])

        for c in clusters:
            merged.append(_merge_bbox_list(page, c['bboxes']))

    return merged


_INLINE_TAGS = {
    # Explicit atom-y tags used by lpsb-mcid.sty
    "Reference",
    "Em",
    "Strong",
    "Link",
    "Span",
    "InlineMath",
}


def _auto_merge_mode(tag_type: str, is_atom: bool) -> str:
    if is_atom:
        return 'line'
    if (tag_type or "") in _INLINE_TAGS:
        return 'line'
    # Block-ish default: old behavior is usually fine.
    return 'page'


def process_elements(aux_path, pdf_path, tag_types=None, merge_mode='auto', split_mcid_lines=False):
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
    mcid_bboxes = get_mcid_bbox_from_pdf(pdf_path, mcids_by_page, split_lines=split_mcid_lines)
    print(f"Got bboxes for {len(mcid_bboxes)} MCIDs (split_lines={bool(split_mcid_lines)})")
    
    # Merge and build output
    output = []
    for logical_id, info in sorted(elements.items()):
        if not info['tag_type']:
            continue

        this_mode = merge_mode
        if merge_mode == 'auto':
            this_mode = _auto_merge_mode(info.get('tag_type'), bool(info.get('is_atom')))
        
        # Get all bboxes for this element's MCIDs
        element_bboxes = []
        for mcid, page in info['mcids']:
            for bb in mcid_bboxes.get(mcid, []):
                # Defensive: honor aux page even if caller mixed sources.
                if int(bb.get('page', page)) == int(page):
                    element_bboxes.append(bb)
        
        merged = merge_bboxes(element_bboxes, mode=this_mode)
        
        output.append({
            'logical_id': logical_id,
            'tag_type': info['tag_type'],
            'is_atom': bool(info.get('is_atom')),
            'parent_id': info.get('parent_id'),
            'bbox_mode': this_mode,
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
    parser.add_argument('--merge-mode', choices=['auto', 'line', 'page', 'mcid'], default='auto',
                        help="How to merge bboxes on the same page. "
                             "'auto' uses line-mode for atoms/inline tags and page-mode for blocks; "
                             "'line' avoids over-merging wrapped inline elements; "
                             "'page' restores old behavior; 'mcid' emits per-MCID boxes.")
    parser.add_argument('--split-mcid-lines', action='store_true',
                        help="Split a single MCID into multiple per-line bboxes (hook for '方案 B').")
    
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
    
    result = process_elements(
        aux_path,
        pdf_path,
        args.types,
        merge_mode=args.merge_mode,
        split_mcid_lines=bool(args.split_mcid_lines),
    )
    
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
