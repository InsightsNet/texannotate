#!/usr/bin/env python3
"""
fix_split_headings.py - Post-processing to merge split section headings

PROBLEM:
LaTeX's @ssect internal formatting outputs content in stages. For starred
sections like section*{References}, the title text may be output AFTER
@ssect returns. This causes the H1 MCID to contain only spurious content
(like "6*" from section counter formatting), while the actual title text
("References") goes into a following P tag.

SOLUTION:
This script detects the pattern of split headings in the aux/JSON output:
1. H1 with only short/number content
2. Immediately followed by an empty or short P  
3. Then another P with the actual title text

It merges these into a single H1 element.

Usage:
    python fix_split_headings.py input.aux -o output.aux
    python fix_split_headings.py input.mcid.json -o output.mcid.json
"""

import argparse
import json
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple


def parse_aux_file(aux_path: Path) -> Dict:
    """Parse aux file and extract LPSB tag data."""
    elements = {}
    
    with open(aux_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Parse tag data: \lpsb@tag@data{elem_id}{type}{mcid}{page}
    for m in re.finditer(r'\\lpsb@tag@data\{(\d+)\}\{(\w+)\}\{(\d+)\}\{(\d+)\}', content):
        elem_id = int(m.group(1))
        tag_type = m.group(2)
        mcid = int(m.group(3))
        page = int(m.group(4))
        elements[elem_id] = {
            'id': elem_id,
            'type': tag_type,
            'mcid': mcid,
            'page': page,
            'mcids': [{'mcid': mcid, 'page': page}]
        }
    
    # Parse continuations
    for m in re.finditer(r'\\lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}', content):
        elem_id = int(m.group(1))
        mcid = int(m.group(2))
        page = int(m.group(3))
        if elem_id in elements:
            elements[elem_id]['mcids'].append({'mcid': mcid, 'page': page})
    
    return elements


def detect_split_headings(elements: Dict) -> List[Tuple[int, int]]:
    """
    Detect split heading patterns.
    
    Returns list of tuples: (h1_elem_id, title_p_elem_id)
    where the title_p should be merged into h1.
    
    Pattern detected: H1/H2 with MCID N, immediately followed by P with MCID N+2
    (N+1 is typically an empty P from everypar)
    """
    splits = []
    elem_ids = sorted(elements.keys())
    
    for i, elem_id in enumerate(elem_ids):
        elem = elements[elem_id]
        
        # Look for H1 or H2
        if elem['type'] not in ('H1', 'H2'):
            continue
        
        h1_mcid = elem['mcids'][0]['mcid'] if elem.get('mcids') else 0
        if h1_mcid == 0:
            continue
        
        # Look for P within next 3 elements that has MCID close to H1's
        for j in range(i+1, min(i+4, len(elem_ids))):
            next_id = elem_ids[j]
            next_elem = elements[next_id]
            
            # Different page? Stop looking
            if next_elem.get('start_page') != elem.get('start_page'):
                break
            
            if next_elem['type'] == 'P':
                next_mcid = next_elem['mcids'][0]['mcid'] if next_elem.get('mcids') else 0
                
                # Check if this P is close to the H1 (within 3 MCIDs)
                # Pattern: H1 MCID=272, P MCID=274 (diff=2) - this is the split title
                if 0 < (next_mcid - h1_mcid) <= 3:
                    splits.append((elem_id, next_id))
                    break
    
    return splits


def merge_split_headings_json(json_path: Path, output_path: Path) -> int:
    """
    Merge split headings in the JSON output.
    
    Returns number of merges performed.
    """
    with open(json_path, 'r') as f:
        data = json.load(f)
    
    elements = {e['id']: e for e in data['elements']}
    splits = detect_split_headings(elements)
    
    merged_count = 0
    elements_to_remove = set()
    
    for h1_id, title_p_id in splits:
        h1 = elements[h1_id]
        title_p = elements[title_p_id]
        
        # Merge MCIDs from title_p into h1
        h1['mcids'].extend(title_p['mcids'])
        h1['end_page'] = max(h1.get('end_page', h1['start_page']), 
                            title_p.get('end_page', title_p['start_page']))
        
        # Mark for removal
        elements_to_remove.add(title_p_id)
        
        merged_count += 1
        print(f"  Merged: {h1['type']} elem {h1_id} (MCID {h1['mcids'][0]['mcid']}) + P elem {title_p_id} (MCID {title_p['mcids'][0]['mcid']})")
    
    # Remove merged elements
    data['elements'] = [e for e in data['elements'] if e['id'] not in elements_to_remove]
    
    # Update summary
    data['summary']['merged_headings'] = merged_count
    
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2)
    
    return merged_count


def main():
    parser = argparse.ArgumentParser(
        description='Merge split section headings in LPSB output')
    parser.add_argument('input', type=Path, help='Input file (aux or json)')
    parser.add_argument('-o', '--output', type=Path, help='Output file')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    
    args = parser.parse_args()
    
    if not args.input.exists():
        print(f"Error: {args.input} not found")
        return 1
    
    output = args.output or args.input.with_suffix(args.input.suffix + '.fixed')
    
    if args.input.suffix == '.json':
        print(f"Processing JSON: {args.input}")
        count = merge_split_headings_json(args.input, output)
        print(f"✓ Merged {count} split headings -> {output}")
    else:
        print(f"Error: Unsupported file type. Use .json")
        return 1
    
    return 0


if __name__ == '__main__':
    exit(main())
