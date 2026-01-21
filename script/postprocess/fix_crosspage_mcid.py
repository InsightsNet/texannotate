#!/usr/bin/env python3
"""
fix_crosspage_mcid.py - Post-process PDF to inject missing cross-page BDC markers

This script reads the .aux file to find cross-page continuation records,
then modifies the PDF content stream to insert proper BDC markers.

NOTE: Even with LPSB_TWO_PASS=1 (two-pass compilation), this post-processing
script is still needed to handle edge cases that LaTeX cannot address natively.
Two-pass provides better LaTeX-level tagging, but this script handles the
final cleanup to ensure 0 untagged TEXT.

Enhanced with float-aware injection: skips over Figure/Table blocks at page top
to correctly identify where continuation content actually begins.
"""

import fitz
import re
import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Tuple, Optional, Set

# Tag types that represent floats (should not receive cross-page continuation)
FLOAT_TAG_TYPES = {'Figure', 'Table'}
# 还有算法，prompt等


def get_layout_from_aux(aux_path: str) -> Tuple[Optional[str], Dict[int, str]]:
    r"""Get layout mode from aux file if available.
    
    Looks for \lpsb@layout{twocolumn} or \lpsb@layout{onecolumn} 
    written by lpsb-mcid.sty at document begin.
    
    Also looks for \lpsb@layout@switch{mode}{page} for mid-document changes.
    
    Returns:
        Tuple of (base_layout, switches_dict)
        - base_layout: 'twocolumn', 'onecolumn', or None if not found
        - switches_dict: {page_num: 'twocolumn'/'onecolumn'} for mid-doc switches
    """
    base_layout = None
    switches = {}
    
    try:
        with open(aux_path, 'r', errors='replace') as f:
            content = f.read()
        
        # Base layout at document start
        match = re.search(r'\\lpsb@layout\{(\w+)\}', content)
        if match:
            base_layout = match.group(1)
        
        # Mid-document layout switches
        for m in re.finditer(r'\\lpsb@layout@switch\{(\w+)\}\{(\d+)\}', content):
            mode = m.group(1)
            page = int(m.group(2))
            switches[page] = mode
            
    except:
        pass
    
    return base_layout, switches


def get_page_layout(page_num: int, base_layout: Optional[str], 
                    switches: Dict[int, str]) -> str:
    """Determine the layout for a specific page.
    
    Args:
        page_num: 1-indexed page number
        base_layout: Document's default layout ('twocolumn' or 'onecolumn')
        switches: Dict mapping page numbers to layout switches
        
    Returns:
        'twocolumn' or 'onecolumn'
    """
    if base_layout is None:
        return 'onecolumn'  # Default assumption
    
    current_layout = base_layout
    
    # Apply switches in order
    for switch_page in sorted(switches.keys()):
        if switch_page <= page_num:
            current_layout = switches[switch_page]
        else:
            break
    
    return current_layout


def detect_two_column_layout(doc, page_idx: int) -> bool:
    """Detect if a page uses two-column layout by analyzing text block positions.
    
    Strategy: 
    1. Extract all text blocks with their X positions
    2. If there's a clear gap in the middle of the page with text on both sides, it's two-column
    
    Args:
        doc: PyMuPDF document
        page_idx: 0-indexed page number
        
    Returns:
        True if page appears to be two-column layout
    """
    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2
    margin = width * 0.1  # 10% margin around center for gap detection
    
    blocks = page.get_text('dict')['blocks']
    text_x_positions = []
    
    for b in blocks:
        if 'lines' in b:
            # Use the left edge of text block
            x = b['bbox'][0]
            text_x_positions.append(x)
    
    if len(text_x_positions) < 4:
        return False  # Not enough text blocks to determine
    
    # Count blocks in left column (x < mid - margin) and right column (x > mid + margin)
    left_count = sum(1 for x in text_x_positions if x < mid_x - margin)
    right_count = sum(1 for x in text_x_positions if x > mid_x + margin)
    
    # Two-column if both sides have significant content
    return left_count >= 2 and right_count >= 2


def find_column_boundary(doc, page_idx: int) -> Optional[float]:
    """Find the X coordinate that divides left and right columns.
    
    Args:
        doc: PyMuPDF document  
        page_idx: 0-indexed page number
        
    Returns:
        X coordinate of column boundary, or None if not two-column
    """
    if not detect_two_column_layout(doc, page_idx):
        return None
    
    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2
    max_col_width = width * 0.45  # Single column should be < 45% of page width
    
    blocks = page.get_text('dict')['blocks']
    
    # Find the gap between columns
    # Filter out blocks that are too wide (likely spanning both columns)
    left_column_rights = []
    right_column_lefts = []
    
    for b in blocks:
        if 'lines' in b:
            bbox = b['bbox']
            block_width = bbox[2] - bbox[0]
            left = bbox[0]
            right = bbox[2]
            
            # Skip blocks that span more than 45% of page width
            if block_width > max_col_width:
                continue
            
            if left < mid_x and right < mid_x + width * 0.1:  # Left column ends before midpoint + 10%
                left_column_rights.append(right)
            elif left > mid_x - width * 0.1:  # Right column starts near or after midpoint
                right_column_lefts.append(left)
    
    if not left_column_rights or not right_column_lefts:
        return mid_x  # Fallback to page center
    
    # Use median instead of max for robustness
    left_column_rights.sort()
    right_column_lefts.sort()
    
    # Boundary is between typical right edge of left column and typical left edge of right column
    typical_left_right = left_column_rights[len(left_column_rights) // 2]  # median
    typical_right_left = right_column_lefts[len(right_column_lefts) // 2]  # median
    
    # Return the midpoint of the gap
    return (typical_left_right + typical_right_left) / 2


def split_cross_column_tags(content_stream: bytes, boundary_x: float, 
                            doc, page_idx: int, mcid_counter: int,
                            verbose: bool = False) -> Tuple[bytes, int, int]:
    """Split tags that span both columns at the column boundary.
    
    Strategy:
    1. Parse BDC markers with their MCIDs
    2. For each P/H1/etc tag, find the text operations (Tm matrices) within it
    3. If text spans both sides of boundary_x, split by:
       - Insert EMC before first text in right column
       - Insert new BDC with new MCID for right column content
    
    Args:
        content_stream: Raw PDF content stream bytes
        boundary_x: X coordinate dividing columns
        doc: PyMuPDF document
        page_idx: 0-indexed page number
        mcid_counter: Starting MCID for new tags
        verbose: Print debug info
        
    Returns:
        (new_stream, num_splits, new_mcid_counter)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    # Parse all BDC markers with positions
    bdc_pattern = re.compile(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC')
    emc_pattern = re.compile(r'\bEMC\b')
    tm_pattern = re.compile(r'([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+Tm')
    
    # Find all BDC regions
    bdc_matches = list(bdc_pattern.finditer(text))
    emc_matches = list(emc_pattern.finditer(text))
    
    if not bdc_matches:
        return content_stream, 0, mcid_counter
    
    # Match BDCs with their EMCs
    tag_regions = []
    for bdc in bdc_matches:
        tag_type = bdc.group(1)
        mcid = int(bdc.group(2))
        bdc_end = bdc.end()
        
        # Find matching EMC (next EMC after this BDC that's not inside another BDC)
        # Simple approach: find next EMC
        matching_emc = None
        for emc in emc_matches:
            if emc.start() > bdc_end:
                matching_emc = emc
                break
        
        if matching_emc:
            tag_regions.append({
                'type': tag_type,
                'mcid': mcid,
                'bdc_start': bdc.start(),
                'bdc_end': bdc_end,
                'emc_start': matching_emc.start(),
                'emc_end': matching_emc.end(),
            })
    
    # Find tags that span both columns
    splits_needed = []
    for region in tag_regions:
        if region['type'] not in ('P', 'LI', 'L'):  # Only split these types
            continue
        
        content = text[region['bdc_end']:region['emc_start']]
        
        # Extract all Tm X positions within this tag
        tms = tm_pattern.findall(content)
        if not tms:
            continue
        
        x_positions = [float(tm[4]) for tm in tms]
        min_x = min(x_positions)
        max_x = max(x_positions)
        
        # Check if it spans both columns
        if min_x < boundary_x and max_x > boundary_x:
            # Find position to split (first Tm with x > boundary_x)
            split_pos = None
            for tm in tm_pattern.finditer(content):
                x = float(tm.group(5))
                if x > boundary_x:
                    split_pos = region['bdc_end'] + tm.start()
                    break
            
            if split_pos:
                splits_needed.append({
                    'region': region,
                    'split_pos': split_pos,
                })
                if verbose:
                    print(f"    Will split {region['type']} MCID {region['mcid']}: X range [{min_x:.0f}, {max_x:.0f}]")
    
    if not splits_needed:
        return content_stream, 0, mcid_counter
    
    # Apply splits from end to start to preserve positions
    splits_needed.sort(key=lambda x: x['split_pos'], reverse=True)
    
    current_mcid = mcid_counter
    for split in splits_needed:
        pos = split['split_pos']
        region = split['region']
        tag_type = region['type']
        
        # Insert: EMC <newline> /P << /MCID N >> BDC
        injection = f'EMC\n/{tag_type} << /MCID {current_mcid} >> BDC\n'
        text = text[:pos] + injection + text[pos:]
        current_mcid += 1
    
    if verbose:
        print(f"    Split {len(splits_needed)} cross-column tags")
    
    return text.encode('latin-1'), len(splits_needed), current_mcid



def parse_aux_file(aux_path: str) -> Dict:
    """Parse aux file and extract all LPSB tag information.
    
    Returns a dict with:
        - 'elements': dict mapping logical_id -> {type, start_mcid, start_page, end_page}
        - 'continuations': list of {logical_id, mcid, page}
        - 'page_elements': dict mapping page_num -> list of element info starting on that page
        - 'page_floats': dict mapping page_num -> list of float element IDs starting on that page
    """
    with open(aux_path, 'r', errors='replace') as f:
        content = f.read()
    
    result = {
        'elements': {},
        'continuations': [],
        'page_elements': defaultdict(list),
        'page_floats': defaultdict(list),
    }
    
    # Pattern: \lpsb@tag@data{logical_id}{type}{mcid}{page}
    tag_data_pattern = r'\\lpsb@tag@data\{(\d+)\}\{(\w+)\}\{(\d+)\}\{(\d+)\}'
    for match in re.finditer(tag_data_pattern, content):
        logical_id = int(match.group(1))
        tag_type = match.group(2)
        mcid = int(match.group(3))
        page = int(match.group(4))
        
        result['elements'][logical_id] = {
            'type': tag_type,
            'start_mcid': mcid,
            'start_page': page,
            'end_page': None,  # Will be filled by tag_end
        }
        result['page_elements'][page].append({
            'id': logical_id,
            'type': tag_type,
            'mcid': mcid,
        })
        if tag_type in FLOAT_TAG_TYPES:
            result['page_floats'][page].append(logical_id)
    
    # Pattern: \lpsb@tag@end{logical_id}{page}
    tag_end_pattern = r'\\lpsb@tag@end\{(\d+)\}\{(\d+)\}'
    for match in re.finditer(tag_end_pattern, content):
        logical_id = int(match.group(1))
        page = int(match.group(2))
        if logical_id in result['elements']:
            result['elements'][logical_id]['end_page'] = page
    
    # Pattern: \lpsb@mcid@cont{logical_id}{mcid}{page}
    cont_pattern = r'\\lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}'
    for match in re.finditer(cont_pattern, content):
        logical_id = int(match.group(1))
        mcid = int(match.group(2))
        page = int(match.group(3))
        result['continuations'].append({
            'logical_id': logical_id,
            'mcid': mcid,
            'page': page,
        })
    
    return result


def parse_aux_continuations(aux_path):
    """Parse aux file for lpsb@mcid@cont records (backward compatible)."""
    return parse_aux_file(aux_path)['continuations']


def get_tag_type_for_id(aux_path, logical_id):
    """Get tag type for a logical element ID from aux file."""
    aux_data = parse_aux_file(aux_path)
    if logical_id in aux_data['elements']:
        return aux_data['elements'][logical_id]['type']
    return 'P'  # Default to P


def get_floats_starting_on_page(aux_data: Dict, page: int) -> List[Dict]:
    """Get information about float elements that start on a given page."""
    floats = []
    for elem_id in aux_data.get('page_floats', {}).get(page, []):
        elem = aux_data['elements'].get(elem_id)
        if elem:
            floats.append({
                'id': elem_id,
                'type': elem['type'],
                'mcid': elem['start_mcid'],
            })
    return floats


def find_open_element_at_page_start(aux_data: Dict, page: int) -> Optional[Dict]:
    """Find the element that spans from the previous page into this page.
    
    An element 'spans' into page N if:
    - It started on a page BEFORE N (start_page < N)
    - It ends on page N or later (end_page >= N)
    - It is NOT a float type (Figure/Table are self-contained)
    
    Returns the element with the highest start_page (most recent) that satisfies
    these conditions, along with the correct continuation MCID for this page.
    """
    candidates = []
    
    for elem_id, elem in aux_data['elements'].items():
        if elem['type'] in FLOAT_TAG_TYPES:
            continue
        start_page = elem['start_page']
        end_page = elem.get('end_page')
        
        # Element must have started before this page
        if start_page >= page:
            continue
        # Element must end on this page or later (or still open)
        if end_page is not None and end_page < page:
            continue
        
        candidates.append({
            'id': elem_id,
            'type': elem['type'],
            'start_page': start_page,
        })
    
    if not candidates:
        return None
    
    # Pick the one with highest start_page (most recently opened)
    candidates.sort(key=lambda x: x['start_page'], reverse=True)
    best = candidates[0]
    
    # Find the MCID continuation for this page
    # Look for \lpsb@mcid@cont{elem_id}{mcid}{page}
    cont_mcid = None
    for cont in aux_data['continuations']:
        if cont['logical_id'] == best['id'] and cont['page'] == page:
            cont_mcid = cont['mcid']
            break
    
    if cont_mcid is None:
        # No continuation record for this specific page - shouldn't inject
        return None
    
    return {
        'id': best['id'],
        'type': best['type'],
        'mcid': cont_mcid,
    }


def fix_empty_p_tags(content_stream, verbose=False):
    """Fix empty P tags that have untagged text after them.
    
    This handles a common issue with floats: when a float is placed asynchronously,
    the P tag opened after it may be empty (BDC immediately followed by EMC),
    while the actual text content appears after the EMC.
    
    Fix: Remove the EMC so that the text becomes part of the P tag.
    
    Returns: (new_stream, fix_count)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    # Parse all markers with positions
    markers = []
    for m in re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text):
        markers.append((m.start(), m.end(), 'BDC', m.group(1), int(m.group(2))))
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), m.end(), 'BMC', 'Artifact', None))
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), m.end(), 'EMC', None, None))
    for m in re.finditer(r'\[[^\]]+\]TJ|\([^)]+\)Tj', text):
        markers.append((m.start(), m.end(), 'TEXT', None, None))
    
    markers.sort(key=lambda x: x[0])
    
    
    # Find empty tag chains: sequences of BDC/EMC before untagged TEXT
    # Pattern: BDC1 EMC1 [BDC2 EMC2 ...] TEXT
    # Fix: Remove all EMCs and intermediate BDCs so first BDC covers the TEXT
    
    removals = []  # List of (start_pos, end_pos) to remove
    
    i = 0
    while i < len(markers) - 1:
        start, end, mtype, tag, mcid = markers[i]
        
        if mtype == 'BDC':
            # Check if this starts an empty tag chain
            chain_start = i
            chain_elements = [(i, markers[i])]
            j = i + 1
            
            # Walk through potential chain: EMC, BDC, EMC, BDC, ... until TEXT or non-pattern
            while j < len(markers):
                jstart, jend, jmtype, jtag, jmcid = markers[j]
                
                if jmtype == 'EMC':
                    chain_elements.append((j, markers[j]))
                    j += 1
                elif jmtype == 'BDC':
                    # Another BDC after EMC - could be chained
                    if len(chain_elements) >= 2 and chain_elements[-1][1][2] == 'EMC':
                        chain_elements.append((j, markers[j]))
                        j += 1
                    else:
                        break
                elif jmtype == 'TEXT':
                    # Found text after chain - check if chain is "empty"
                    # Chain is empty if: BDC1 EMC1 [BDC2 EMC2]* TEXT
                    # Need at least BDC EMC TEXT pattern (2 elements before TEXT)
                    if len(chain_elements) >= 2:
                        last_elem = chain_elements[-1]
                        if last_elem[1][2] == 'EMC':
                            # This is an empty chain! Remove all EMCs and intermediate BDCs
                            # Keep only the first BDC
                            first_bdc_tag = chain_elements[0][1][3]
                            if first_bdc_tag in ('P', 'Table', 'Figure'):  # Only for these types
                                for idx, (cidx, cmarker) in enumerate(chain_elements[1:], 1):
                                    cstart, cend, cmtype, ctag, cmcid = cmarker
                                    removals.append((cstart, cend, cmtype, ctag, cmcid if cmtype == 'BDC' else chain_elements[0][1][4]))
                                if verbose:
                                    print(f"  Detected empty chain: {len(chain_elements)} elements, first={first_bdc_tag} MCID {chain_elements[0][1][4]}")
                    break
                else:
                    break
            
            i = j if j > i + 1 else i + 1
        else:
            i += 1
    
    # Remove from back to front
    removals.sort(key=lambda x: x[0], reverse=True)
    for rstart, rend, rmtype, rtag, rmcid in removals:
        # Just replace the marker with a space (safer than deleting)
        text = text[:rstart] + ' ' + text[rend:]
        if verbose:
            print(f"  Removed {rmtype} at {rstart}")
    
    return text.encode('latin-1'), len(removals)


def fix_orphan_emcs(content_stream, verbose=False):
    """Remove orphan EMC markers that have no matching BDC.
    
    This fixes a structural issue where cross-page or cross-column handling
    produces EMC markers without corresponding BDC markers, causing PDF
    structure imbalance.
    
    Strategy:
    1. Parse all BDC/BMC/EMC markers
    2. Track nesting level
    3. Identify EMCs that would make level go negative (orphans)
    4. Remove those orphan EMCs
    
    Returns: (new_stream, removed_count)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    # Parse all markers with their positions
    markers = []
    for m in re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text):
        markers.append((m.start(), m.end(), 'BDC', m.group(1), int(m.group(2))))
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), m.end(), 'BMC', 'Artifact', None))
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), m.end(), 'EMC', None, None))
    
    markers.sort(key=lambda x: x[0])
    
    # Track nesting and find orphan EMCs
    level = 0
    orphan_emcs = []  # List of (start_pos, end_pos) for orphan EMCs
    
    for start, end, mtype, tag, mcid in markers:
        if mtype == 'BDC' or mtype == 'BMC':
            level += 1
        elif mtype == 'EMC':
            if level > 0:
                level -= 1
            else:
                # This EMC is orphan - no matching BDC
                orphan_emcs.append((start, end))
                if verbose:
                    print(f"  Found orphan EMC at position {start}")
    
    if not orphan_emcs:
        return content_stream, 0
    
    # Remove orphans from end to start to preserve positions
    orphan_emcs.sort(key=lambda x: x[0], reverse=True)
    for start, end in orphan_emcs:
        # Replace with whitespace to maintain stream positions for other fixes
        text = text[:start] + ' ' * (end - start) + text[end:]
    
    if verbose:
        print(f"  Removed {len(orphan_emcs)} orphan EMC markers")
    
    return text.encode('latin-1'), len(orphan_emcs)


def fix_untagged_page_start(content_stream, page_mcid_base=1000, verbose=False):
    """Fix pages that start with untagged text (cross-page continuation issue).
    
    Detects pattern: Artifact BMC ... EMC ... EMC ... TEXT (before any BDC)
    Injects: /P << /MCID N >> BDC before the untagged TEXT
    
    Returns: (new_stream, fix_count, new_mcid)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    # Parse markers
    markers = []
    for m in re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text):
        markers.append((m.start(), m.end(), 'BDC', m.group(1), int(m.group(2))))
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), m.end(), 'BMC', 'Artifact', None))
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), m.end(), 'EMC', None, None))
    for m in re.finditer(r'\[[^\]]+\]TJ|\([^)]+\)Tj', text):
        markers.append((m.start(), m.end(), 'TEXT', None, None))
    
    markers.sort(key=lambda x: x[0])
    
    # Check if page starts with: Artifact BMC...EMC...EMC...TEXT (no BDC before first TEXT)
    first_bdc_pos = None
    first_text_pos = None
    last_emc_before_text = None
    
    for i, (pos, end, mtype, tag, mcid) in enumerate(markers):
        if mtype == 'BDC':
            first_bdc_pos = pos
            break
        elif mtype == 'TEXT' and first_text_pos is None:
            first_text_pos = pos
            # Find the EMC just before this text
            for j in range(i - 1, -1, -1):
                if markers[j][2] == 'EMC':
                    last_emc_before_text = markers[j]
                    break
            break
    
    # If there's TEXT before any BDC, we need to inject a P BDC
    if first_text_pos is not None and (first_bdc_pos is None or first_text_pos < first_bdc_pos):
        if last_emc_before_text:
            # Inject after the last EMC before the text
            inject_pos = last_emc_before_text[1]
            # Skip whitespace
            while inject_pos < len(text) and text[inject_pos] in ' \n\r\t':
                inject_pos += 1
            
            bdc_marker = f'/P << /MCID {page_mcid_base} >> BDC \n'
            text = text[:inject_pos] + bdc_marker + text[inject_pos:]
            
            if verbose:
                print(f"  Injected /P MCID {page_mcid_base} at position {inject_pos}")
            
            return text.encode('latin-1'), 1, page_mcid_base
    
    return content_stream, 0, page_mcid_base


def parse_content_stream_markers(text: str) -> List[Tuple[int, str, str, Optional[str]]]:
    """Parse content stream and extract all relevant markers.
    
    Returns list of (position, marker_type, content, tag_type) tuples.
    marker_type: 'BDC', 'BMC', 'EMC', 'TEXT'
    tag_type: extracted tag type for BDC markers (e.g., 'Figure', 'P'), None otherwise
    """
    markers = []
    
    # BDC markers with tag type extraction
    # Pattern: /TagType << /MCID N >> BDC
    for m in re.finditer(r'/(\w+)\s*<<[^>]*>>\s*BDC', text):
        tag_type = m.group(1)
        markers.append((m.start(), 'BDC', m.group(), tag_type))
    
    # BMC markers (Artifact)
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), 'BMC', m.group(), 'Artifact'))
    
    # EMC markers (end tag)
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), 'EMC', m.group(), None))
    
    # TJ/Tj text commands
    for m in re.finditer(r'\[[^\]]+\]TJ|\([^\)]+\)Tj', text):
        markers.append((m.start(), 'TEXT', m.group()[:30], None))
    
    # Sort by position
    markers.sort(key=lambda x: x[0])
    return markers


def inject_bdc_into_stream(content_stream, mcid, tag_type='P', skip_float_types: Set[str] = None):
    """Inject BDC markers into content stream before ALL untagged text segments.
    
    Enhanced strategy:
    1. Track BDC/EMC nesting level
    2. Track which tag types we're inside (to detect floats)
    3. Find ALL TEXT segments that are:
       a) At nesting level 0 (truly untagged), AND
       b) NOT inside a float block
    4. Insert BDC before each untagged text segment, EMC after
    
    This handles pages with multiple gaps between floats (like appendices with
    many small tables interspersed with text).
    
    Args:
        content_stream: Raw content stream bytes
        mcid: Starting MCID number to inject (incremented for each injection)
        tag_type: Tag type for the BDC (e.g., 'P', 'H1')
        skip_float_types: Set of tag types to skip over (floats at page top)
    
    Returns:
        (new_stream, success, injections_count)
    """
    if skip_float_types is None:
        skip_float_types = FLOAT_TAG_TYPES
    
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    markers = parse_content_stream_markers(text)
    
    # Track state while scanning
    level = 0  # Nesting depth
    tag_stack = []  # Stack of tag_types for nested elements
    
    # Find injection points: each position where untagged TEXT starts
    # An injection point is needed when:
    # 1. We're at level 0 (not inside any tag)
    # 2. We encounter TEXT
    # 3. There was no previous untagged TEXT (or we just exited a tag)
    injection_points = []  # List of (position, prev_marker_end_pos) tuples
    
    in_untagged_run = False  # Track if we're currently in a run of untagged text
    last_marker_end = 0  # End position of last BDC/EMC marker
    
    for i, (pos, marker_type, content, marker_tag_type) in enumerate(markers):
        if marker_type == 'BDC' or marker_type == 'BMC':
            in_untagged_run = False  # Entering a tag ends any untagged run
            level += 1
            tag_stack.append(marker_tag_type)
            last_marker_end = pos + len(content) if content else pos + 20
                
        elif marker_type == 'EMC':
            in_untagged_run = False  # Just exited a tag
            if tag_stack:
                tag_stack.pop()
            level = max(0, level - 1)
            last_marker_end = pos + 3  # "EMC" is 3 chars
            
        elif marker_type == 'TEXT':
            # Check if this is untagged text
            if level == 0:
                if not in_untagged_run:
                    # Start of a new untagged text run - need to inject P here
                    injection_points.append(pos)
                    in_untagged_run = True
                # If already in untagged run, continue (don't inject again)
    
    if not injection_points:
        return content_stream, False, 0
    
    # Inject BDC at each injection point (from end to start to preserve positions)
    # We inject just BDC without EMC - the next real tag will naturally close/interrupt
    # Or we could inject BDC...EMC pairs around each text run
    
    # Actually, for PDF structure correctness, each BDC needs a matching EMC
    # Strategy: For each injection point, find where to put the EMC (before next BDC/BMC)
    
    current_mcid = mcid
    
    # Build list of (inject_pos, emc_pos) for each gap
    injections_with_emc = []
    for inj_pos in injection_points:
        # Find where EMC should go: before the next BDC/BMC
        emc_pos = None
        for pos, mtype, content, mtag in markers:
            if pos > inj_pos and mtype in ('BDC', 'BMC'):
                emc_pos = pos
                break
        if emc_pos is None:
            emc_pos = len(text)  # End of stream
        injections_with_emc.append((inj_pos, emc_pos))
    
    # Inject from end to start
    for inj_pos, emc_pos in reversed(injections_with_emc):
        # Insert EMC first (at higher position)
        text = text[:emc_pos] + ' EMC\n' + text[emc_pos:]
        # Insert BDC (at lower position)
        bdc = f' /{tag_type} << /MCID {current_mcid} >> BDC\n'
        text = text[:inj_pos] + bdc + text[inj_pos:]
        current_mcid += 1
    
    return text.encode('latin-1'), True, len(injections_with_emc)


def find_first_text_position(content_stream):
    """Find position of first text content after Artifact markers (legacy)."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
    
    emc_positions = [m.end() for m in re.finditer(r'\bEMC\s*\n', text)]
    bt_match = re.search(r'\bBT\s*\n', text)
    if bt_match:
        bt_pos = bt_match.start()
        artifact_end = 0
        for pos in emc_positions:
            if pos < bt_pos:
                artifact_end = pos
        pre_bt = text[artifact_end:bt_pos]
        last_emc = None
        for m in re.finditer(r'\bEMC\s*\n', pre_bt):
            last_emc = artifact_end + m.end()
        if last_emc:
            return last_emc
        return bt_pos
    return None


def detect_pages_with_untagged_text(doc) -> List[int]:
    """Detect pages that have untagged text (text at nesting level 0).
    
    This directly analyzes the PDF content stream rather than relying on
    aux records, which may not capture all cross-page situations.
    
    Returns: List of 1-indexed page numbers with untagged text
    """
    pages_with_untagged = []
    
    for page_idx in range(len(doc)):
        page = doc[page_idx]
        try:
            xref = page.xref
            contents_ref = doc.xref_get_key(xref, "Contents")
            if contents_ref[0] != 'xref':
                continue
            contents_xref = int(contents_ref[1].split()[0])
            content_stream = doc.xref_stream(contents_xref)
            if not content_stream:
                continue
        except:
            continue
        
        try:
            text = content_stream.decode('latin-1')
        except:
            text = content_stream.decode('utf-8', errors='replace')
        
        markers = parse_content_stream_markers(text)
        
        # Track nesting level
        level = 0
        has_untagged = False
        
        for pos, mtype, content, tag_type in markers:
            if mtype == 'BDC' or mtype == 'BMC':
                level += 1
            elif mtype == 'EMC':
                level = max(0, level - 1)
            elif mtype == 'TEXT':
                if level == 0:
                    has_untagged = True
                    break
        
        if has_untagged:
            pages_with_untagged.append(page_idx + 1)  # 1-indexed
    
    return pages_with_untagged


def process_pdf(pdf_path, aux_path, output_path=None, verbose=True):
    """Process PDF to inject missing cross-page BDC markers.
    
    Enhanced to handle floats at page top correctly.
    Detection now uses BOTH:
    1. Aux-based cross-page element detection
    2. Direct PDF content stream analysis for untagged text
    """
    if output_path is None:
        output_path = pdf_path.replace('.pdf', '_fixed.pdf')
    
    # Parse full aux data
    aux_data = parse_aux_file(aux_path)
    continuations = aux_data['continuations']
    
    if verbose:
        print(f"Found {len(continuations)} cross-page continuations")
    
    # Open PDF
    doc = fitz.open(pdf_path)
    
    # Use unique MCID counter starting at 10000 to avoid collision with LaTeX MCIDs
    # LaTeX typically uses MCIDs 1-999 for normal documents
    unique_mcid_counter = 10000
    
    # Method 1: Find pages from aux-based cross-page element detection
    pages_from_aux = {}
    all_pages = set(cont['page'] for cont in continuations)
    
    for page_num in sorted(all_pages):
        open_elem = find_open_element_at_page_start(aux_data, page_num)
        if open_elem:
            pages_from_aux[page_num] = open_elem
    
    # Method 2: Find pages with untagged text directly from PDF
    pages_with_untagged = detect_pages_with_untagged_text(doc)
    
    # Combine both detection methods
    all_pages_to_check = sorted(set(pages_from_aux.keys()) | set(pages_with_untagged))
    
    if verbose:
        print(f"Pages from aux cross-page: {sorted(pages_from_aux.keys())}")
        print(f"Pages with untagged text: {pages_with_untagged}")
        print(f"Combined pages to fix: {all_pages_to_check}")
    
    # === Phase 0: Fix orphan EMCs on ALL pages ===
    if verbose:
        print("\n--- Phase 0: Fixing orphan EMC markers ---")
    
    orphan_fix_count = 0
    for page_idx in range(len(doc)):
        page = doc[page_idx]
        try:
            xref = page.xref
            contents_ref = doc.xref_get_key(xref, "Contents")
            if contents_ref[0] != 'xref':
                continue
            contents_xref = int(contents_ref[1].split()[0])
            content_stream = doc.xref_stream(contents_xref)
            if not content_stream:
                continue
            
            new_stream, removed = fix_orphan_emcs(content_stream, verbose=False)
            if removed > 0:
                doc.update_stream(contents_xref, new_stream)
                orphan_fix_count += removed
                if verbose:
                    print(f"  Page {page_idx + 1}: removed {removed} orphan EMC(s)")
        except Exception as e:
            if verbose:
                print(f"  Page {page_idx + 1}: error - {e}")
    
    if verbose:
        print(f"  Total orphan EMCs removed: {orphan_fix_count}")
    
    # === Phase 1: Inject missing BDC markers ===
    fixed_count = 0
    for page_num in all_pages_to_check:
        if page_num > len(doc):
            if verbose:
                print(f"  Page {page_num}: out of range, skipping")
            continue
        
        page = doc[page_num - 1]  # 0-indexed
        
        # Get content stream
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        
        if contents_ref[0] != 'xref':
            if verbose:
                print(f"  Page {page_num}: no xref content, skipping")
            continue
        
        contents_xref = int(contents_ref[1].split()[0])
        content_stream = doc.xref_stream(contents_xref)
        
        if not content_stream:
            if verbose:
                print(f"  Page {page_num}: empty content stream, skipping")
            continue
        
        # Get element info from aux if available, otherwise use defaults
        elem_info = pages_from_aux.get(page_num)
        if elem_info:
            tag_type = elem_info['type']
            mcid = elem_info['mcid']
        else:
            # Page detected from PDF scan, no aux info
            # Find the last MCID from the previous page for continuation
            prev_page_idx = page_num - 2  # 0-indexed, previous page
            if prev_page_idx >= 0:
                try:
                    prev_page = doc[prev_page_idx]
                    prev_xref = prev_page.xref
                    prev_contents_ref = doc.xref_get_key(prev_xref, "Contents")
                    if prev_contents_ref[0] == 'xref':
                        prev_contents_xref = int(prev_contents_ref[1].split()[0])
                        prev_stream = doc.xref_stream(prev_contents_xref)
                        prev_text = prev_stream.decode('latin-1', errors='replace')
                        # Find all BDC MCIDs on previous page
                        prev_bdcs = list(re.finditer(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', prev_text))
                        # Find last non-float, non-artifact BDC
                        last_mcid = None
                        last_type = 'P'
                        for m in prev_bdcs:
                            t = m.group(1)
                            if t not in ('Artifact', 'Figure', 'Table', 'Caption'):
                                last_type = t
                                last_mcid = int(m.group(2))
                        if last_mcid is not None:
                            # Use P as tag type - orphan text is almost always a new paragraph
                            # Keep the MCID from previous page for reading order consistency
                            tag_type = 'P'
                            mcid = last_mcid
                            if verbose:
                                print(f"  Page {page_num}: orphan text, using /P MCID {mcid} (prev was {last_type})")
                        else:
                            tag_type = 'P'
                            mcid = 1  # Fallback
                    else:
                        tag_type = 'P'
                        mcid = 1
                except Exception as e:
                    tag_type = 'P'
                    mcid = 1
            else:
                tag_type = 'P'
                mcid = 1
        
        # Check if this page has floats at top that we need to skip
        floats_on_page = get_floats_starting_on_page(aux_data, page_num)
        if floats_on_page:
            float_types = [f['type'] for f in floats_on_page]
            if verbose:
                print(f"  Page {page_num}: has floats at top: {float_types}")
            # When page has floats, content after them is usually a new paragraph,
            # not a continuation of whatever element (H1, Reference, etc) was before.
            # Override to P unless the aux specifically indicates otherwise.
            if tag_type in ('H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'Reference', 'LI', 'BibEntry'):
                # These are unlikely to truly continue after floats
                tag_type = 'P'
                if verbose:
                    print(f"  Page {page_num}: overriding to P (content after floats)")
        
        # Use unique MCID to avoid collision with LaTeX-generated MCIDs
        injection_mcid = unique_mcid_counter
        
        # Try to inject BDC, skipping over floats (now handles multiple gaps)
        new_stream, success, num_injections = inject_bdc_into_stream(
            content_stream,
            injection_mcid,
            tag_type,
            skip_float_types=FLOAT_TAG_TYPES
        )
        
        if success:
            # Update content stream in PDF
            doc.update_stream(contents_xref, new_stream)
            unique_mcid_counter += num_injections  # Increment by number of injections
            if verbose:
                if num_injections > 1:
                    print(f"  Page {page_num}: injected {num_injections} /{tag_type} tags (MCIDs {injection_mcid}-{injection_mcid + num_injections - 1})")
                else:
                    print(f"  Page {page_num}: injected /{tag_type} << /MCID {injection_mcid} >> BDC")
            fixed_count += num_injections
        else:
            if verbose:
                print(f"  Page {page_num}: could not find injection point")
    
    # === Phase 2: Split cross-column tags for two-column layouts ===
    if verbose:
        print("\n--- Phase 2: Two-column layout processing ---")
    
    # Get layout info from aux file (more reliable than PDF heuristics)
    base_layout, layout_switches = get_layout_from_aux(aux_path)
    if verbose and base_layout:
        print(f"  Base layout: {base_layout}, switches: {layout_switches}")
    
    column_split_count = 0
    for page_idx in range(len(doc)):
        page_num = page_idx + 1  # 1-indexed for display
        
        # Use aux-based layout detection if available, otherwise fall back to PDF heuristic
        if base_layout:
            page_layout = get_page_layout(page_num, base_layout, layout_switches)
            if page_layout != 'twocolumn':
                continue  # Skip single-column pages
        
        # Get column boundary (still needed even with aux-based detection)
        boundary_x = find_column_boundary(doc, page_idx)
        if boundary_x is None:
            # aux says two-column but PDF analysis can't find boundary
            # Use page center as fallback
            boundary_x = doc[page_idx].rect.width / 2
        
        if verbose:
            print(f"  Page {page_num}: two-column (boundary at x={boundary_x:.0f})")
        
        # Get content stream
        page = doc[page_idx]
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        
        if contents_ref[0] != 'xref':
            continue
        
        contents_xref = int(contents_ref[1].split()[0])
        content_stream = doc.xref_stream(contents_xref)
        
        if not content_stream:
            continue
        
        # Split cross-column tags
        new_stream, num_splits, unique_mcid_counter = split_cross_column_tags(
            content_stream, boundary_x, doc, page_idx, 
            unique_mcid_counter, verbose=verbose
        )
        
        if num_splits > 0:
            doc.update_stream(contents_xref, new_stream)
            column_split_count += num_splits
    
    if verbose and column_split_count > 0:
        print(f"  Split {column_split_count} cross-column tags total")
    
    # Save modified PDF
    doc.save(output_path)
    doc.close()
    
    if verbose:
        print(f"\nFixed {fixed_count} cross-page + {column_split_count} cross-column, saved to: {output_path}")
    return output_path


def main():
    parser = argparse.ArgumentParser(
        description='Fix cross-page MCID tags in PDF (float-aware)',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s document.pdf
  %(prog)s document.pdf --aux document.aux -o document_fixed.pdf
  %(prog)s document.pdf --verbose
        """)
    parser.add_argument('pdf', help='Input PDF file')
    parser.add_argument('--aux', help='Aux file (default: same name as PDF with .aux)')
    parser.add_argument('--output', '-o', help='Output PDF file')
    parser.add_argument('--verbose', '-v', action='store_true', default=True,
                       help='Verbose output (default: True)')
    parser.add_argument('--quiet', '-q', action='store_true',
                       help='Suppress output')
    
    args = parser.parse_args()
    
    pdf_path = args.pdf
    aux_path = args.aux or pdf_path.replace('.pdf', '.aux')
    output_path = args.output
    verbose = args.verbose and not args.quiet
    
    if not Path(pdf_path).exists():
        print(f"Error: PDF not found: {pdf_path}")
        return 1
    
    if not Path(aux_path).exists():
        print(f"Error: Aux file not found: {aux_path}")
        return 1
    
    process_pdf(pdf_path, aux_path, output_path, verbose=verbose)
    return 0


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py fix-crosspage-mcid ...
