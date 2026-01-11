#!/usr/bin/env python3
"""
fix_crosspage_mcid.py - Post-process PDF to inject missing cross-page BDC markers

This script reads the .aux file to find cross-page continuation records,
then modifies the PDF content stream to insert proper BDC markers.

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
    """Inject BDC marker into content stream before first untagged text.
    
    Enhanced strategy:
    1. Track BDC/EMC nesting level
    2. Track which tag types we're inside (to detect floats)
    3. Skip over complete float blocks (Figure/Table BDC...EMC)
    4. Find first TEXT that is:
       a) At nesting level 0 (truly untagged), AND
       b) NOT inside a float block
    5. Insert BDC before that text command
    
    Args:
        content_stream: Raw content stream bytes
        mcid: MCID number to inject
        tag_type: Tag type for the BDC (e.g., 'P', 'H1')
        skip_float_types: Set of tag types to skip over (floats at page top)
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
    tag_stack = []  # Stack of (tag_type, start_pos) for nested elements
    inside_float = False  # Currently inside a float block
    float_depth = 0  # How deep in float nesting (floats can contain captions etc)
    
    insertion_pos = None
    
    for pos, marker_type, content, marker_tag_type in markers:
        if marker_type == 'BDC' or marker_type == 'BMC':
            level += 1
            tag_stack.append(marker_tag_type)
            
            # Check if entering a float
            if marker_tag_type in skip_float_types:
                inside_float = True
                float_depth = level
                
        elif marker_type == 'EMC':
            if tag_stack:
                exited_tag = tag_stack.pop()
                # Check if exiting a float
                if level == float_depth and exited_tag in skip_float_types:
                    inside_float = False
                    float_depth = 0
            level = max(0, level - 1)
            
        elif marker_type == 'TEXT':
            # Found text - check if it's our target
            if level == 0 and not inside_float:
                # This is untagged text that's not inside a float
                insertion_pos = pos
                break
    
    if insertion_pos is not None:
        # Insert BDC right before the text
        bdc = f' /{tag_type} << /MCID {mcid} >> BDC \n'
        new_text = text[:insertion_pos] + bdc + text[insertion_pos:]
        return new_text.encode('latin-1'), True
    
    return content_stream, False


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
                            tag_type = last_type
                            mcid = last_mcid
                            if verbose:
                                print(f"  Page {page_num}: orphan text, using prev page's /{tag_type} MCID {mcid}")
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
        if floats_on_page and verbose:
            float_types = [f['type'] for f in floats_on_page]
            print(f"  Page {page_num}: has floats at top: {float_types}")
        
        # Note: We don't override MCID here anymore - the previous page's last MCID
        # maintains correct reading order. The inject_bdc_into_stream function
        # will skip over float blocks to find the correct injection point.
        
        # Try to inject BDC, skipping over floats
        new_stream, success = inject_bdc_into_stream(
            content_stream,
            mcid,
            tag_type,
            skip_float_types=FLOAT_TAG_TYPES
        )
        
        if success:
            # Update content stream in PDF
            doc.update_stream(contents_xref, new_stream)
            if verbose:
                print(f"  Page {page_num}: injected /{tag_type} << /MCID {mcid} >> BDC")
            fixed_count += 1
        else:
            if verbose:
                print(f"  Page {page_num}: could not find injection point")
    
    # Save modified PDF
    doc.save(output_path)
    doc.close()
    
    if verbose:
        print(f"\nFixed {fixed_count} pages, saved to: {output_path}")
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


if __name__ == '__main__':
    exit(main())
