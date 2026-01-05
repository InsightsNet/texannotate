#!/usr/bin/env python3
"""
TD Cell Extractor for LPSB - Extract table cells from PDF using pdfplumber
"""

import pdfplumber
from typing import List, Dict, Tuple


def extract_table_cells_from_pdf(pdf_path: str, events: List[Dict]) -> List[Dict]:
    """
    Extract TD cell events from PDF based on TR row events.
    
    Args:
        pdf_path: Path to PDF file
        events: List of LPSB events (with TR events)
    
    Returns:
        New events list with TD events inserted
    """
    enriched_events = []
    
    with pdfplumber.open(pdf_path) as pdf:
        for event in events:
            enriched_events.append(event)
            
            # Process TR start events
            if event.get('role') == 'TR' and event.get('event') == 'start':
                tr_id = event.get('id', '')
                page_num = event.get('page', 1) - 1  # pdfplumber uses 0-indexed
                
                if page_num < 0 or page_num >= len(pdf.pages):
                    continue
                
                page = pdf.pages[page_num]
                
                # Extract cells for this row
                cells = extract_cells_from_row(page, event, events)
                
                # Insert TD events after TR start
                for i, cell in enumerate(cells, 1):
                    td_start = {
                        "id": f"{tr_id}-TD{i}",
                        "role": "TD",
                        "event": "start",
                        "row": extract_row_number(tr_id),
                        "col": i,
                        "page": page_num + 1,
                        "bbox": cell['bbox'],
                        "text": cell['text']
                    }
                    td_end = {
                        "id": f"{tr_id}-TD{i}",
                        "role": "TD",
                        "event": "end",
                        "page": page_num + 1
                    }
                    enriched_events.append(td_start)
                    enriched_events.append(td_end)
    
    return enriched_events


def extract_cells_from_row(page, tr_event: Dict, all_events: List[Dict]) -> List[Dict]:
    """
    Extract individual cells from a table row using text positioning.
    
    Args:
        page: pdfplumber page object
        tr_event: TR start event
        all_events: All LPSB events (to find row boundaries)
    
    Returns:
        List of cell dicts with bbox and text
    """
    # Find the corresponding TR end event
    tr_id = tr_event.get('id', '')
    tr_end = None
    for event in all_events:
        if event.get('role') == 'TR' and event.get('event') == 'end' and event.get('id') == tr_id:
            tr_end = event
            break
    
    if not tr_end:
        return []
    
    # Get y-coordinate range for this row from TR events
    y_start = tr_event.get('y', 0)
    y_end = tr_end.get('y', 0)
    
    # Convert from TeX sp units to PDF points (65536 sp = 1 pt)
    # PDF uses bottom-left origin, TeX uses top-left
    page_height_pt = page.height
    
    # If coordinates are 0, it means first compile - use fallback
    if y_start == 0 and y_end == 0:
        # Fallback: use all words on page and cluster
        words = page.extract_words()
    else:
        # Convert TeX y-coordinates to PDF coordinates
        # Note: This is a rough conversion, may need calibration
        y_start_pdf = page_height_pt - (y_start / 65536.0)
        y_end_pdf = page_height_pt - (y_end / 65536.0)
        
        # Ensure y_start < y_end (PDF coordinates)
        if y_start_pdf > y_end_pdf:
            y_start_pdf, y_end_pdf = y_end_pdf, y_start_pdf
        
        # Add margin for tolerance
        margin = 10  # points
        y_start_pdf -= margin
        y_end_pdf += margin
        
        # Filter words within this y-range
        all_words = page.extract_words()
        words = [w for w in all_words 
                if y_start_pdf <= w['top'] <= y_end_pdf or 
                   y_start_pdf <= w['bottom'] <= y_end_pdf]
    
    if not words:
        return []
    
    # Cluster words into cells by x-coordinate
    cells = cluster_words_into_cells(words)
    
    return cells


def cluster_words_into_cells(words: List[Dict]) -> List[Dict]:
    """
    Cluster words into table cells based on x-coordinates using simple gap detection.
    
    Args:
        words: List of word dicts from pdfplumber
    
    Returns:
        List of cell dicts
    """
    if not words:
        return []
    
    # Sort words by x-coordinate (left edge)
    sorted_words = sorted(words, key=lambda w: w['x0'])
    
    # Group words into cells by detecting gaps
    cells = []
    current_cell = [sorted_words[0]]
    gap_threshold = 20  # pixels - adjust based on typical cell spacing
    
    for i in range(1, len(sorted_words)):
        prev_word = sorted_words[i-1]
        curr_word = sorted_words[i]
        
        # If gap is large, start a new cell
        gap = curr_word['x0'] - prev_word['x1']
        if gap > gap_threshold:
            # Finalize current cell
            if current_cell:
                cells.append(create_cell_from_words(current_cell))
            current_cell = [curr_word]
        else:
            current_cell.append(curr_word)
    
    # Don't forget the last cell
    if current_cell:
        cells.append(create_cell_from_words(current_cell))
    
    return cells


def create_cell_from_words(words: List[Dict]) -> Dict:
    """Create a cell dict from a list of words."""
    if not words:
        return {'bbox': [0, 0, 0, 0], 'text': ''}
    
    # Calculate bounding box
    x0 = min(w['x0'] for w in words)
    y0 = min(w['top'] for w in words)
    x1 = max(w['x1'] for w in words)
    y1 = max(w['bottom'] for w in words)
    
    # Extract text in left-to-right order
    text = ' '.join(w['text'] for w in sorted(words, key=lambda w: w['x0']))
    
    return {
        'bbox': [x0, y0, x1, y1],
        'text': text
    }


def extract_row_number(tr_id: str) -> int:
    """Extract row number from TR id like 'TR-1' -> 1"""
    try:
        return int(tr_id.split('-')[-1])
    except:
        return 0
