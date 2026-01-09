#!/usr/bin/env python3
"""
LPSB Position Enricher

Post-processes LPSB JSON output to fill in coordinates from:
1. .aux file (zref positions) - for headings, figures, tables, etc.
2. PDF extraction (pdfplumber) - for complex elements

Usage:
    python enrich_positions.py document.aux document.pdf document.lpsb.json -o enriched.json
"""

import argparse
import json
import re
import sys
from pathlib import Path

# PDF libraries - prefer PyMuPDF (much faster), fallback to pdfplumber
try:
    import fitz  # PyMuPDF
    HAS_PYMUPDF = True
except ImportError:
    HAS_PYMUPDF = False

try:
    import pdfplumber
    HAS_PDFPLUMBER = True
except ImportError:
    HAS_PDFPLUMBER = False



def parse_aux_positions(aux_path: str) -> dict:
    """
    Parse zref positions from .aux file.
    
    Returns dict mapping label -> {'x': sp, 'y': sp}
    """
    positions = {}
    
    with open(aux_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Pattern: \zref@newlabel{label}{\posx{X}\posy{Y}}
    pattern = r'\\zref@newlabel\{([^}]+)\}\{\\posx\{(\d+)\}\\posy\{(\d+)\}\}'
    
    for match in re.finditer(pattern, content):
        label = match.group(1)
        x_sp = int(match.group(2))
        y_sp = int(match.group(3))
        positions[label] = {'x_sp': x_sp, 'y_sp': y_sp}
    
    return positions


def sp_to_bp(sp: int) -> float:
    """Convert scaled points to PDF points (bp)."""
    return sp / 65536 / 72.27 * 72


def sp_to_pt(sp: int) -> float:
    """Convert scaled points to TeX points (pt)."""
    return sp / 65536


def enrich_from_aux(entries: list, positions: dict, page_height_pt: float = 794.97) -> int:
    """
    Enrich LPSB entries with positions from .aux file.
    
    Returns count of enriched entries.
    """
    enriched_count = 0
    
    for entry in entries:
        # Enriched start events OR single-point events (like Reference, InlineMath atom)
        event = entry.get('event', '')
        if event not in ('start', 'atom') and 'event' in entry:
            if entry.get('role') != 'Reference':
                continue
        
        entry_id = entry.get('id', '')
        role = entry.get('role', '')
        
        # Determine zref label
        if role == 'Document':
            start_label = "lpsb-Document-start"
            end_label = "lpsb-Document-end"
        elif role == 'InlineMath' and event == 'atom':
            # InlineMath uses single-point label without -start/-end suffix
            start_label = f"lpsb-{entry_id}"
            end_label = None  # No end label for atoms
        else:
            start_label = f"lpsb-{entry_id}-start"
            end_label = f"lpsb-{entry_id}-end"
            
        # Debug helper
        # print(f"Checking {start_label} for {entry_id}")
        
        if start_label in positions:
            start_pos = positions[start_label]
            # Convert from TeX coords (origin bottom-left, in sp) to PDF coords
            x_pt = sp_to_pt(start_pos['x_sp'])
            y_pt = sp_to_pt(start_pos['y_sp'])
            
            # TeX y is from bottom, PDF is from top
            # Approximate page height for A4: ~845pt
            y_pdf = page_height_pt - y_pt
            
            entry['x'] = round(x_pt, 2)
            entry['y'] = round(y_pdf, 2)
            entry['coord_source'] = 'aux'
            enriched_count += 1
            
            # If we have end position, calculate width/height
            if end_label and end_label in positions:
                end_pos = positions[end_label]
                end_x_pt = sp_to_pt(end_pos['x_sp'])
                end_y_pt = sp_to_pt(end_pos['y_sp'])
                end_y_pdf = page_height_pt - end_y_pt
                
                # Width: difference in x (for same-line elements)
                # Height: difference in y (for block elements)
                width = abs(end_x_pt - x_pt)
                height = abs(y_pt - end_y_pt)
                
                if width > 0.1:  # Only record if meaningful
                    entry['width'] = round(width, 2)
                if height > 0.1:  # Only record if meaningful
                    entry['height'] = round(height, 2)
                
                # Store end coordinates for reference
                entry['x_end'] = round(end_x_pt, 2)
                entry['y_end'] = round(end_y_pdf, 2)
    
    # Second pass: Enrich end events with their coordinates
    for entry in entries:
        if entry.get('event') != 'end':
            continue
        
        entry_id = entry.get('id', '')
        role = entry.get('role', '')
        
        if role == 'Document':
            end_label = "lpsb-Document-end"
        else:
            end_label = f"lpsb-{entry_id}-end"
        
        if end_label in positions:
            end_pos = positions[end_label]
            end_x_pt = sp_to_pt(end_pos['x_sp'])
            end_y_pt = sp_to_pt(end_pos['y_sp'])
            end_y_pdf = page_height_pt - end_y_pt
            
            entry['x'] = round(end_x_pt, 2)
            entry['y'] = round(end_y_pdf, 2)
    
    return enriched_count


def extract_elements_from_pdf(pdf_path: str) -> dict:
    """
    Extract element bounding boxes from PDF.
    
    Returns dict mapping page_number -> {
        'tables': [bbox_dict],
        'graphics': [bbox_dict] # All visual elements (images, rects, lines, curves)
    }
    """
    if not HAS_PDFPLUMBER:
        return {}
    
    elements_by_page = {}
    
    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages, start=1):
            page_data = {
                'tables': [],
                'graphics': []
            }
            
            # Extract tables (higher semantic level)
            tables = page.find_tables()
            for table in tables:
                bbox = table.bbox
                page_data['tables'].append({
                    'x0': bbox[0],
                    'y0': bbox[1],
                    'x1': bbox[2],
                    'y1': bbox[3],
                    'width': bbox[2] - bbox[0],
                    'height': bbox[3] - bbox[1]
                })
            
            # Extract all graphical primitives for general figure shape detection
            # Includes: images, rects, lines, curves
            graphics = []
            
            # Helper to normalize bbox
            def add_graphic(item):
                # Ensure we have valid coordinates
                try:
                    g = {
                        'x0': float(item.get('x0', 0)),
                        'y0': float(item.get('top', 0)),
                        'x1': float(item.get('x1', 0)),
                        'y1': float(item.get('bottom', 0))
                    }
                    g['width'] = g['x1'] - g['x0']
                    g['height'] = g['y1'] - g['y0']
                    
                    # Filter out tiny artifacts (e.g. invisible lines)
                    if g['width'] > 0.1 or g['height'] > 0.1:
                        graphics.append(g)
                except:
                    pass

            for img in page.images: add_graphic(img)
            for rect in page.rects: add_graphic(rect)
            for line in page.lines: add_graphic(line)
            for curve in page.curves: add_graphic(curve)
            
            page_data['graphics'] = graphics
            elements_by_page[page_num] = page_data
    
    return elements_by_page


def enrich_from_pdf(entries: list, pdf_data: dict) -> int:
    """
    Enrich LPSB entries with positions from PDF extraction.
    Uses Vertical ROI Scanning for Figures to handle arbitrary shapes.
    """
    enriched_count = 0
    used_tables = set() # (page, index)
    
    for entry in entries:
        if entry.get('event') != 'start':
            continue
        
        role = entry.get('role', '')
        page = entry.get('page')
        if isinstance(page, str):
            try:
                page = int(page)
            except:
                continue
        
        if page not in pdf_data:
            continue
            
        page_elements = pdf_data[page]
        
        # Current coords from aux (start point)
        aux_x = entry.get('x', 0)
        aux_y = entry.get('y', 0)
        aux_h = entry.get('height', 0)
        
        # --- TABLE MATCHING ---
        if role == 'Table':
            # Prefer explicit aux match if available, else first unused
            best_match = None
            min_dist = float('inf')
            
            candidates = []
            for i, tbl in enumerate(page_elements['tables']):
                if (page, i) not in used_tables:
                    candidates.append((i, tbl))
            
            if aux_x > 0 and candidates:
                # Find nearest table
                for i, tbl in candidates:
                    dist = ((tbl['x0'] - aux_x)**2 + (tbl['y0'] - aux_y)**2)**0.5
                    if dist < min_dist:
                        min_dist = dist
                        best_match = (i, tbl)
                
                # Loose threshold for tables as caption position varies
                if min_dist > 500: 
                    best_match = None
            
            elif candidates:
                # Fallback to first available
                best_match = candidates[0]
                
            if best_match:
                idx, tbl = best_match
                used_tables.add((page, idx))
                entry['x'] = round(tbl['x0'], 2)
                entry['y'] = round(tbl['y0'], 2)
                entry['width'] = round(tbl['width'], 2)
                entry['height'] = round(tbl['height'], 2)
                entry['coord_source'] = 'pdf'
                enriched_count += 1

        # --- FIGURE MATCHING (Vertical Scan) ---
        elif role == 'Figure' and aux_h > 0:
            # We have the vertical band [y, y+h] from zsavepos
            # Scan ALL graphics that fall within this band
            
            roi_y0 = aux_y
            roi_y1 = aux_y + aux_h
            
            # Allow small tolerance
            tolerance = 2.0
            roi_y0 -= tolerance
            roi_y1 += tolerance
            
            matching_graphics = []
            for g in page_elements['graphics']:
                # Check vertical intersection/containment
                # We want elements that are mostly inside the float region
                g_y0 = g['y0']
                g_y1 = g['y1']
                
                # Check if element is strictly inside or significantly overlaps
                # Simple check: center of element is inside ROI
                g_cy = (g_y0 + g_y1) / 2
                if roi_y0 <= g_cy <= roi_y1:
                    matching_graphics.append(g)
            
            if matching_graphics:
                # Compute union bbox
                min_x = min(g['x0'] for g in matching_graphics)
                min_y = min(g['y0'] for g in matching_graphics)
                max_x = max(g['x1'] for g in matching_graphics)
                max_y = max(g['y1'] for g in matching_graphics)
                
                w = max_x - min_x
                h = max_y - min_y
                
                # Update entry
                # We keep the zsavepos Y if it covers the container, but PDF might be tighter
                # Actually zref height is reliable for the container. 
                # Width is what we desperately need.
                
                entry['width'] = round(w, 2)
                # If detected graphic is flat (e.g. valid line but not full shape) or missing height,
                # fallback to the reliable aux environment height.
                entry['height'] = round(h if h > 5.0 else aux_h, 2)
                entry['x'] = round(min_x, 2)
                entry['y'] = round(min_y, 2)
                entry['coord_source'] = 'pdf_scan'
                enriched_count += 1
                
                # Debug info
                # print(f"DEBUG: {role} {entry.get('id')} matched {len(matching_graphics)} items. W={w:.2f} H={h:.2f}")
                # for g in matching_graphics:
                #    # print(f"  Item: {g}")
            else:
                # No graphics found, maybe text only? Keep aux coords
                pass

    return enriched_count


def extract_words_from_pdf(pdf_path: str, max_size_mb: float = 5.0, max_time_per_page: float = 5.0) -> dict:
    """
    Extract word-level bboxes from PDF using pdfplumber.
    
    Args:
        pdf_path: Path to PDF file
        max_size_mb: Skip word extraction for PDFs larger than this (default 5MB)
        max_time_per_page: Abort if first pages take longer than this (seconds)
    
    Returns dict mapping page_number -> list of word dicts:
        {'text': str, 'x0': float, 'y0': float, 'x1': float, 'y1': float, 'fontname': str}
    """
    import os
    import time
    
    file_size_mb = os.path.getsize(pdf_path) / (1024 * 1024) if os.path.exists(pdf_path) else 0
    words_by_page = {}
    
    # Try PyMuPDF first (much faster)
    if HAS_PYMUPDF:
        try:
            doc = fitz.open(pdf_path)
            for page_num, page in enumerate(doc, start=1):
                page_start = time.time()
                
                # Use dict mode to get font information
                data = page.get_text('dict')
                words = []
                
                for block in data.get('blocks', []):
                    if 'lines' not in block:
                        continue
                    for line in block['lines']:
                        for span in line['spans']:
                            bbox = span.get('bbox', (0, 0, 0, 0))
                            words.append({
                                'text': span.get('text', ''),
                                'x0': bbox[0],
                                'y0': bbox[1],
                                'x1': bbox[2],
                                'y1': bbox[3],
                                'fontname': span.get('font', ''),
                                'size': span.get('size', 0)
                            })
                
                # Check if first pages are too slow
                page_time = time.time() - page_start
                if page_num <= 3 and page_time > max_time_per_page:
                    break
                
                words_by_page[page_num] = words
            doc.close()
            return words_by_page
        except Exception as e:
            pass  # Fall through to pdfplumber
    
    # Fallback to pdfplumber
    if HAS_PDFPLUMBER:
        # Skip large PDFs with pdfplumber (too slow)
        if file_size_mb > max_size_mb:
            return {}
        
        try:
            with pdfplumber.open(pdf_path) as pdf:
                for page_num, page in enumerate(pdf.pages, start=1):
                    page_start = time.time()
                    
                    words = page.extract_words(
                        keep_blank_chars=False,
                        x_tolerance=3,
                        y_tolerance=3,
                        extra_attrs=['fontname', 'size']
                    )
                    
                    page_time = time.time() - page_start
                    if page_num <= 3 and page_time > max_time_per_page:
                        break
                    
                    words_by_page[page_num] = [{
                        'text': w.get('text', ''),
                        'x0': w.get('x0', 0),
                        'y0': w.get('top', 0),
                        'x1': w.get('x1', 0),
                        'y1': w.get('bottom', 0),
                        'fontname': w.get('fontname', ''),
                        'size': w.get('size', 0)
                    } for w in words]
        except Exception as e:
            print(f"Warning: Failed to extract words from PDF: {e}")
    
    return words_by_page


def refine_inline_bboxes(entries: list, words_by_page: dict, tolerance: float = 5.0) -> int:
    """
    Refine inline element (Strong, Em, Link) bboxes using PDF word data.
    
    For each inline element:
    1. Find words that overlap with the start/end coordinates
    2. Group overlapping words by line (same y-range)
    3. If element spans multiple lines, add 'fragments' array with per-line bboxes
    
    Returns count of refined entries.
    """
    refined_count = 0
    
    inline_roles = {'Strong', 'Em', 'Link'}
    
    for entry in entries:
        if entry.get('event') != 'start':
            continue
        
        role = entry.get('role', '')
        if role not in inline_roles:
            continue
        
        page = entry.get('page')
        if isinstance(page, str):
            try:
                page = int(page)
            except:
                continue
        
        if page not in words_by_page:
            continue
        
        # Get the start and end coordinates from aux
        start_x = entry.get('x', 0)
        start_y = entry.get('y', 0)
        end_x = entry.get('x_end', start_x)
        end_y = entry.get('y_end', start_y)
        
        if start_x == 0 and start_y == 0:
            continue
        
        page_words = words_by_page[page]
        
        # Find words that overlap with the inline element range
        # Strategy: words whose y-center is between start_y and end_y,
        # and x overlaps with the span
        
        # If start_y ≈ end_y (same line), use simple x-range
        # If start_y != end_y (multi-line), need to find all words in that y-range
        
        same_line = abs(start_y - end_y) < tolerance * 2
        
        matching_words = []
        
        for w in page_words:
            w_x0, w_y0, w_x1, w_y1 = w['x0'], w['y0'], w['x1'], w['y1']
            w_cy = (w_y0 + w_y1) / 2
            
            if same_line:
                # Single line: check if word is on the same line and between start_x and end_x
                if abs(w_cy - start_y) < tolerance:
                    if w_x0 >= start_x - tolerance and w_x1 <= end_x + tolerance:
                        matching_words.append(w)
            else:
                # Multi-line: check if word is within the y-range
                # First line: from start_x to end of line
                # Middle lines: full width
                # Last line: from start of line to end_x
                
                y_min = min(start_y, end_y) - tolerance
                y_max = max(start_y, end_y) + tolerance
                
                if y_min <= w_cy <= y_max:
                    matching_words.append(w)
        
        if not matching_words:
            continue
        
        # Group words by line (similar y values)
        lines = []
        current_line = []
        last_y = None
        
        # Sort by y, then x
        matching_words.sort(key=lambda w: (w['y0'], w['x0']))
        
        for w in matching_words:
            w_cy = (w['y0'] + w['y1']) / 2
            if last_y is None or abs(w_cy - last_y) < tolerance:
                current_line.append(w)
            else:
                if current_line:
                    lines.append(current_line)
                current_line = [w]
            last_y = w_cy
        
        if current_line:
            lines.append(current_line)
        
        # Generate fragments for each line
        fragments = []
        for line_words in lines:
            if not line_words:
                continue
            
            frag = {
                'x0': min(w['x0'] for w in line_words),
                'y0': min(w['y0'] for w in line_words),
                'x1': max(w['x1'] for w in line_words),
                'y1': max(w['y1'] for w in line_words),
            }
            frag['width'] = round(frag['x1'] - frag['x0'], 2)
            frag['height'] = round(frag['y1'] - frag['y0'], 2)
            frag['x0'] = round(frag['x0'], 2)
            frag['y0'] = round(frag['y0'], 2)
            frag['x1'] = round(frag['x1'], 2)
            frag['y1'] = round(frag['y1'], 2)
            fragments.append(frag)
        
        if len(fragments) == 1:
            # Single line: update main bbox
            frag = fragments[0]
            entry['x'] = frag['x0']
            entry['y'] = frag['y0']
            entry['width'] = frag['width']
            entry['height'] = frag['height']
            entry['x_end'] = frag['x1']
            entry['y_end'] = frag['y1']
            entry['coord_source'] = 'pdf_words'
            refined_count += 1
        elif len(fragments) > 1:
            # Multi-line: add fragments array, keep first fragment as main bbox
            entry['x'] = fragments[0]['x0']
            entry['y'] = fragments[0]['y0']
            entry['width'] = fragments[0]['width']
            entry['height'] = fragments[0]['height']
            entry['fragments'] = fragments
            entry['lines'] = len(fragments)
            entry['coord_source'] = 'pdf_words_multiline'
            refined_count += 1
    
    return refined_count


# Common math fonts in TeX
MATH_FONTS = {
    'cmmi', 'cmsy', 'cmex',  # Computer Modern
    'cmmib', 'cmbsy',  # Computer Modern Bold
    'lmmi', 'lmsy', 'lmex',  # Latin Modern
    'txmi', 'txsy', 'txex',  # TX fonts
    'ntxmi', 'ntxsy',  # newtx fonts
    'stix', 'stixmath',  # STIX
    'xits', 'xitsmath',  # XITS
    'cambria', 'cambriamath',  # Cambria Math
    'libertinusmath',  # Libertinus
    'firamath',  # Fira Math
    'euler', 'eulervm',  # Euler
    'mathpazo', 'pplr',  # Palatino
    'fourier',  # Fourier
}


def is_math_font(fontname: str) -> bool:
    """Check if fontname is a math font."""
    if not fontname:
        return False
    fname_lower = fontname.lower()
    # Check if any math font substring is in the fontname
    for mf in MATH_FONTS:
        if mf in fname_lower:
            return True
    # Also check for common math font patterns
    if 'math' in fname_lower or 'symbol' in fname_lower:
        return True
    return False


def refine_inline_math_bboxes(entries: list, words_by_page: dict, tolerance: float = 5.0) -> int:
    """
    Refine InlineMath element bboxes using font detection from PDF.
    
    For each InlineMath element with a start position:
    1. Find consecutive characters with math fonts starting from that position
    2. Compute full bbox including subscripts and superscripts
    
    Returns count of refined entries.
    """
    refined_count = 0
    
    for entry in entries:
        if entry.get('event') != 'atom':
            continue
        
        role = entry.get('role', '')
        if role != 'InlineMath':
            continue
        
        page = entry.get('page')
        if isinstance(page, str):
            try:
                page = int(page)
            except:
                continue
        
        if page not in words_by_page:
            continue
        
        # Get start position from aux
        start_x = entry.get('x', 0)
        start_y = entry.get('y', 0)
        
        if start_x == 0 and start_y == 0:
            continue
        
        page_words = words_by_page[page]
        
        # Find characters with math fonts starting near the start position
        # Allow for slight variations in y (for subscripts/superscripts)
        math_chars = []
        
        for w in page_words:
            if not is_math_font(w.get('fontname', '')):
                continue
            
            # Check if this is near the start position and to the right
            w_x0 = w['x0']
            w_cy = (w['y0'] + w['y1']) / 2
            
            # Must be to the right of start (or at start)
            if w_x0 < start_x - tolerance:
                continue
            
            # Must be on roughly the same line (allowing for super/subscripts)
            if abs(w_cy - start_y) > tolerance * 3:
                continue
            
            math_chars.append(w)
        
        if not math_chars:
            continue
        
        # Sort by x position
        math_chars.sort(key=lambda w: w['x0'])
        
        # Find contiguous group starting from start position
        # Stop when there's a gap or when we hit non-math character
        contiguous = []
        last_x1 = start_x
        
        for w in math_chars:
            # Check for gap
            if w['x0'] > last_x1 + tolerance * 2:
                break
            contiguous.append(w)
            last_x1 = w['x1']
        
        if not contiguous:
            continue
        
        # Compute bbox
        x0 = min(w['x0'] for w in contiguous)
        y0 = min(w['y0'] for w in contiguous)
        x1 = max(w['x1'] for w in contiguous)
        y1 = max(w['y1'] for w in contiguous)
        
        entry['x'] = round(x0, 2)
        entry['y'] = round(y0, 2)
        entry['x_end'] = round(x1, 2)
        entry['y_end'] = round(y1, 2)
        entry['width'] = round(x1 - x0, 2)
        entry['height'] = round(y1 - y0, 2)
        entry['coord_source'] = 'pdf_math_font'
        refined_count += 1
    
    return refined_count


# Math environments supported for source extraction
MATH_ENVS = [
    'equation', 'equation*',
    'align', 'align*',
    'gather', 'gather*',
    'multline', 'multline*',
    'eqnarray', 'eqnarray*',
    'displaymath',
    'flalign', 'flalign*',
    'alignat', 'alignat*',
    'split',
]


def extract_math_from_tex(tex_path: str) -> dict:
    """
    Extract all math environment content from a .tex file.
    
    Returns: {env_index: {'env': 'equation', 'latex': 'E=mc^2'}, ...}
    where env_index is the 1-based occurrence order.
    """
    try:
        with open(tex_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return {}
    
    # Remove comments (lines starting with %)
    lines = content.split('\n')
    cleaned_lines = []
    for line in lines:
        # Remove % comments (but not \%)
        idx = 0
        while idx < len(line):
            if line[idx] == '%' and (idx == 0 or line[idx-1] != '\\'):
                line = line[:idx]
                break
            idx += 1
        cleaned_lines.append(line)
    content = '\n'.join(cleaned_lines)
    
    math_sources = {}
    global_index = 0  # 1-based index across all math environments
    
    for env in MATH_ENVS:
        # Pattern: \begin{env}...\end{env}
        # Handle nested braces in alignat{n}
        if env.startswith('alignat'):
            pattern = rf'\\begin\{{{env}\}}\{{[^}}]*\}}(.*?)\\end\{{{env}\}}'
        else:
            pattern = rf'\\begin\{{{env}\}}(.*?)\\end\{{{env}\}}'
        
        matches = list(re.finditer(pattern, content, re.DOTALL))
        
        for match in matches:
            global_index += 1
            latex_content = match.group(1).strip()
            math_sources[global_index] = {
                'env': env,
                'latex': latex_content,
                'start_pos': match.start(),
            }
    
    # Re-sort by position in document
    sorted_by_pos = sorted(math_sources.items(), key=lambda x: x[1]['start_pos'])
    
    # Reassign indices based on document order
    result = {}
    for new_idx, (_, data) in enumerate(sorted_by_pos, 1):
        result[new_idx] = {'env': data['env'], 'latex': data['latex']}
    
    return result


def extract_inline_math_from_tex(tex_path: str) -> list:
    """
    Extract all inline math ($...$) from a .tex file.
    
    Returns: list of latex strings in document order.
    """
    try:
        with open(tex_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return []
    
    # Remove comments
    lines = content.split('\n')
    cleaned = []
    for line in lines:
        idx = 0
        while idx < len(line):
            if line[idx] == '%' and (idx == 0 or line[idx-1] != '\\'):
                line = line[:idx]
                break
            idx += 1
        cleaned.append(line)
    content = '\n'.join(cleaned)
    
    # Find $...$ but not $$
    # Pattern: single $ not preceded or followed by $
    inline_math = []
    i = 0
    while i < len(content):
        if content[i] == '$':
            # Check if it's $$ (display math)
            if i + 1 < len(content) and content[i+1] == '$':
                # Skip $$ ... $$
                end = content.find('$$', i + 2)
                if end != -1:
                    i = end + 2
                else:
                    i += 2
                continue
            
            # Find closing $
            start = i + 1
            end = start
            while end < len(content):
                if content[end] == '$' and content[end-1] != '\\':
                    break
                end += 1
            
            if end < len(content):
                latex = content[start:end]
                if latex.strip():  # Non-empty
                    inline_math.append(latex)
                i = end + 1
            else:
                i += 1
        else:
            i += 1
    
    return inline_math


def enrich_math_source(entries: list, tex_path: str) -> int:
    """
    Enrich Formula entries with LaTeX source code from .tex file.
    
    Returns count of enriched entries.
    """
    if not Path(tex_path).exists():
        return 0
    
    display_sources = extract_math_from_tex(tex_path)
    inline_sources = extract_inline_math_from_tex(tex_path)
    
    if not display_sources and not inline_sources:
        return 0
    
    enriched = 0
    
    # Track display math by context
    display_counter = {}  # {context_num: count}
    inline_counter = {}
    
    for entry in entries:
        if entry.get('event') not in ('start', 'atom'):
            continue
        
        role = entry.get('role', '')
        entry_id = entry.get('id', '')
        
        if role == 'Formula':
            # Parse ID: Sec-N-Math-M
            match = re.match(r'Sec-(\d+)-Math-(\d+)', entry_id)
            if match:
                ctx = int(match.group(1))
                math_num = int(match.group(2))
                
                # Use global index
                if ctx not in display_counter:
                    display_counter[ctx] = 0
                display_counter[ctx] += 1
                
                global_idx = sum(display_counter.values())
                
                if global_idx in display_sources:
                    entry['latex'] = display_sources[global_idx]['latex']
                    enriched += 1
        
        elif role == 'InlineMath':
            # Parse ID: Sec-N-InlineMath-M
            match = re.match(r'Sec-(\d+)-InlineMath-(\d+)', entry_id)
            if match:
                ctx = int(match.group(1))
                math_num = int(match.group(2))
                
                if ctx not in inline_counter:
                    inline_counter[ctx] = 0
                inline_counter[ctx] += 1
                
                global_idx = sum(inline_counter.values()) - 1  # 0-indexed for list
                
                if global_idx < len(inline_sources):
                    entry['latex'] = inline_sources[global_idx]
                    enriched += 1
    
    return enriched


def main():
    parser = argparse.ArgumentParser(description='Enrich LPSB JSON with coordinates')
    parser.add_argument('aux', help='Path to .aux file')
    parser.add_argument('pdf', help='Path to PDF file')
    parser.add_argument('json', help='Path to LPSB JSON file')
    parser.add_argument('-o', '--output', help='Output JSON path (default: overwrite input)')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    parser.add_argument('-t', '--tex', help='Path to .tex file for LaTeX source extraction')
    
    args = parser.parse_args()
    
    # Parse aux file
    # Parse aux file
    if args.verbose:
        print(f"Parsing positions from {args.aux}...")
    
    positions = {}
    if Path(args.aux).exists():
        positions = parse_aux_positions(args.aux)
        if args.verbose:
            print(f"  Found {len(positions)} position labels")
    
    
    # Load JSON with fault tolerance for LaTeX escape issues
    def _fix_latex_escapes(content: str) -> str:
        """Fix invalid escape sequences from LaTeX detokenize output.
        
        LaTeX's \\detokenize{} outputs backslashes as-is, but JSON requires
        \\ to be escaped as \\\\. Common problematic sequences include:
        \\chi, \\Delta, \\doibase, etc.
        """
        import re
        # Find backslash followed by a letter (LaTeX command), not already escaped
        # and not a valid JSON escape (n, r, t, b, f, u, \\, /, ")
        valid_escapes = set('nrtbfu\\"/')
        result = []
        i = 0
        while i < len(content):
            if content[i] == '\\' and i + 1 < len(content):
                next_char = content[i + 1]
                # If next char is backslash, it's already escaped
                if next_char == '\\':
                    result.append('\\\\')
                    i += 2
                # If it's a valid JSON escape, keep as-is
                elif next_char in valid_escapes:
                    result.append(content[i:i+2])
                    i += 2
                # Otherwise, escape the backslash
                else:
                    result.append('\\\\')
                    i += 1
            else:
                result.append(content[i])
                i += 1
        return ''.join(result)
    
    try:
        with open(args.json, 'r') as f:
            content = f.read()
        
        # Try direct parse first
        try:
            entries = json.loads(content)
        except json.JSONDecodeError as e:
            # Fix LaTeX escapes and retry
            if args.verbose:
                print(f"Warning: JSON parse error ({e}), fixing LaTeX escapes...")
            fixed_content = _fix_latex_escapes(content)
            entries = json.loads(fixed_content)
    except Exception as e:
        print(f"Error: Failed to load JSON file {args.json}: {e}")
        sys.exit(1)
    
    # Get PDF page height for correct Y-coordinate conversion
    page_height_pt = 794.97  # Default A4 height
    if Path(args.pdf).exists():
        if HAS_PYMUPDF:
            try:
                doc = fitz.open(args.pdf)
                if len(doc) > 0:
                    page_height_pt = doc[0].rect.height
                doc.close()
            except:
                pass
        elif HAS_PDFPLUMBER:
            try:
                with pdfplumber.open(args.pdf) as pdf:
                    if pdf.pages:
                        page_height_pt = pdf.pages[0].height
            except:
                pass
    
    # Enrich from aux
    aux_count = enrich_from_aux(entries, positions, page_height_pt)
    if args.verbose:
        print(f"Enriched {aux_count} entries from .aux (page height: {page_height_pt:.2f}pt)")
    
    # Enrich from PDF
    pdf_count = 0
    inline_count = 0
    if Path(args.pdf).exists() and HAS_PDFPLUMBER:
        if args.verbose:
            print(f"Extracting elements from {args.pdf}...")
        pdf_elements = extract_elements_from_pdf(args.pdf)
        pdf_count = enrich_from_pdf(entries, pdf_elements)
        if args.verbose:
            print(f"Enriched {pdf_count} entries from PDF")
        
        # Refine inline elements (Strong, Em, Link) using word-level bboxes
        if args.verbose:
            print(f"Extracting words for inline refinement...")
        words_by_page = extract_words_from_pdf(args.pdf)
        inline_count = refine_inline_bboxes(entries, words_by_page)
        if args.verbose:
            print(f"Refined {inline_count} inline element bboxes")
        
        # Refine InlineMath bboxes using font detection
        math_count = refine_inline_math_bboxes(entries, words_by_page)
        if args.verbose:
            print(f"Refined {math_count} inline math bboxes via font detection")
    
    # Enrich math source from .tex file
    if args.tex:
        math_src_count = enrich_math_source(entries, args.tex)
        if args.verbose:
            print(f"Enriched {math_src_count} math entries with LaTeX source from .tex")
    
    # Count coverage
    total_starts = sum(1 for e in entries if e.get('event') == 'start')
    with_coords = sum(1 for e in entries 
                      if e.get('event') == 'start' 
                      and e.get('x', 0) != 0)
    
    # print(f"Coverage: {with_coords}/{total_starts} ({100*with_coords/total_starts:.0f}%) entries have coordinates")
    
    # Write output
    output_path = args.output or args.json
    with open(output_path, 'w') as f:
        json.dump(entries, f, indent=2)
    
    # print(f"Output written to {output_path}")


if __name__ == '__main__':
    main()
