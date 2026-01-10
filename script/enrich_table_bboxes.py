#!/usr/bin/env python3
"""
Enrich table JSON (from latexml_to_lpsb.py) with cell bounding boxes from PDF.

Uses pdfplumber to extract cell coordinates from the gold PDF and aligns them
with table events by row/column index.
"""

import json
import sys
from pathlib import Path
from typing import Optional

try:
    import pdfplumber
    HAS_PDFPLUMBER = True
except ImportError:
    HAS_PDFPLUMBER = False


def extract_pdf_table_cells(pdf_path: Path) -> list[dict]:
    """
    Extract table cells from PDF using pdfplumber with text-based strategy.
    
    Supports:
    - Regular tables
    - Longtable (multi-page): merges consecutive tables at page boundaries
    - Sidewaystable (rotated): detects and transforms rotated bboxes
    
    Returns list of tables, each containing rows with cell bboxes.
    """
    if not HAS_PDFPLUMBER:
        return []
    
    raw_tables = []
    
    # Text-based strategy works better for LaTeX tables
    table_settings = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "snap_tolerance": 5,
        "join_tolerance": 5,
        "min_words_vertical": 1,
        "min_words_horizontal": 1,
    }
    
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page_num, page in enumerate(pdf.pages, start=1):
                page_height = page.height
                page_width = page.width
                page_rotation = page.rotation or 0
                
                page_tables = page.find_tables(table_settings=table_settings)
                
                for table in page_tables:
                    bbox = list(table.bbox)  # (x0, top, x1, bottom)
                    
                    # Detect if table is near page edges (for longtable detection)
                    near_top = bbox[1] < 100  # within 100pt of top
                    near_bottom = bbox[3] > (page_height - 100)  # within 100pt of bottom
                    
                    # Detect rotated page (sidewaystable typically uses landscape)
                    is_rotated = page_rotation in (90, 270) or page_width > page_height * 1.2
                    
                    table_data = {
                        'page': page_num,
                        'pages': [page_num],
                        'bbox': bbox,
                        'page_height': page_height,
                        'page_width': page_width,
                        'near_top': near_top,
                        'near_bottom': near_bottom,
                        'rotated': is_rotated,
                        'rotation': page_rotation,
                        'rows': []
                    }
                    
                    extracted = table.extract()
                    
                    for row_idx, row in enumerate(table.rows):
                        row_data = {
                            'cells': [],
                            'page': page_num  # Track which page this row is on
                        }
                        
                        for cell_idx, cell in enumerate(row.cells):
                            if cell is None:
                                cell_data = {'col': cell_idx + 1, 'bbox': None}
                            else:
                                cell_bbox = list(cell)
                                
                                # Transform rotated bbox if needed
                                if is_rotated and page_rotation == 90:
                                    # Rotate 90° clockwise transform
                                    x0, y0, x1, y1 = cell_bbox
                                    cell_bbox = [y0, page_width - x1, y1, page_width - x0]
                                elif is_rotated and page_rotation == 270:
                                    # Rotate 90° counter-clockwise transform
                                    x0, y0, x1, y1 = cell_bbox
                                    cell_bbox = [page_height - y1, x0, page_height - y0, x1]
                                
                                cell_data = {'col': cell_idx + 1, 'bbox': cell_bbox}
                                
                            if row_idx < len(extracted) and cell_idx < len(extracted[row_idx]):
                                cell_data['text'] = (extracted[row_idx][cell_idx] or "").strip()
                            
                            row_data['cells'].append(cell_data)
                        
                        if row_data['cells']:
                            table_data['rows'].append(row_data)
                    
                    raw_tables.append(table_data)
                    
    except Exception as e:
        print(f"Warning: Failed to extract PDF tables: {e}", file=sys.stderr)
    
    # Merge longtable parts (tables spanning multiple pages)
    tables = merge_longtable_parts(raw_tables)
    
    return tables


def merge_longtable_parts(raw_tables: list[dict]) -> list[dict]:
    """
    Merge consecutive tables that are likely parts of a longtable.
    
    Heuristic: If a table starts near the top of a page and the previous
    table (on the previous page) ends near the bottom, merge them.
    """
    if not raw_tables:
        return []
    
    merged: list[dict] = []
    
    for table in raw_tables:
        should_merge = False
        
        if merged:
            prev = merged[-1]
            # Use last page in the merged table's pages list
            prev_last_page = prev.get('pages', [prev.get('page', 0)])[-1]
            
            # Check if this looks like a longtable continuation
            if (prev_last_page == table['page'] - 1 and  # consecutive pages
                prev.get('near_bottom', False) and       # prev ends at bottom
                table.get('near_top', False) and         # this starts at top
                len(prev.get('rows', [])) > 0 and        # prev has rows
                len(table.get('rows', [])) > 0):         # this has rows
                
                # Check column count matches
                prev_rows = prev.get('rows', [])
                curr_rows = table.get('rows', [])
                prev_cols = len(prev_rows[0].get('cells', [])) if prev_rows else 0
                curr_cols = len(curr_rows[0].get('cells', [])) if curr_rows else 0
                
                if prev_cols == curr_cols:
                    should_merge = True
        
        if should_merge:
            # Merge this table into previous
            prev_rows = merged[-1].get('rows', [])
            prev_rows.extend(table.get('rows', []))
            merged[-1]['rows'] = prev_rows
            
            prev_pages = merged[-1].get('pages', [])
            prev_pages.append(table['page'])
            merged[-1]['pages'] = prev_pages
            
            merged[-1]['near_bottom'] = table.get('near_bottom', False)
        else:
            merged.append(table)
    
    return merged





def enrich_table_events(table_events: list[dict], pdf_tables: list[dict]) -> list[dict]:
    """
    Enrich table events with cell bboxes from PDF extraction.
    
    Matches by table index and row/col position.
    """
    enriched = []
    
    # Group events by table container ID
    current_table_idx = -1
    current_row_in_table = 0
    
    for ev in table_events:
        ev = dict(ev)  # Copy to avoid mutating input
        role = ev.get('role')
        event = ev.get('event')
        
        if role == 'Table' and event == 'start':
            current_table_idx += 1
            current_row_in_table = 0
            
            # Add table bbox and metadata if available
            if current_table_idx < len(pdf_tables):
                pdf_table = pdf_tables[current_table_idx]
                ev['page'] = pdf_table.get('page')
                ev['bbox'] = pdf_table.get('bbox')
                # Multi-page (longtable) support
                pages = pdf_table.get('pages', [])
                if len(pages) > 1:
                    ev['pages'] = pages
                    ev['multipage'] = True
                # Rotation (sidewaystable) support
                if pdf_table.get('rotated'):
                    ev['rotated'] = True
        
        elif role == 'TR' and event == 'start':
            current_row_in_table += 1
        
        elif role == 'TD' and event == 'start':
            col = ev.get('col', 1)
            row = ev.get('row', current_row_in_table)
            
            # Find matching cell bbox from PDF
            if current_table_idx < len(pdf_tables):
                pdf_table = pdf_tables[current_table_idx]
                pdf_rows = pdf_table.get('rows', [])
                
                # Adjust for 1-indexed row/col in events
                row_idx = row - 1
                col_idx = col - 1
                
                if row_idx < len(pdf_rows):
                    pdf_cells = pdf_rows[row_idx].get('cells', [])
                    if col_idx < len(pdf_cells):
                        pdf_cell = pdf_cells[col_idx]
                        bbox = pdf_cell.get('bbox')
                        if bbox:
                            ev['bbox'] = bbox
        
        enriched.append(ev)
    
    return enriched


def main() -> int:
    import argparse
    
    parser = argparse.ArgumentParser(description='Enrich table JSON with PDF cell bboxes')
    parser.add_argument('table_json', help='Path to table JSON from latexml_to_lpsb.py')
    parser.add_argument('pdf_file', help='Path to gold PDF file')
    parser.add_argument('--output', '-o', help='Output JSON file (default: stdout)')
    
    args = parser.parse_args()
    
    if not HAS_PDFPLUMBER:
        print("Warning: pdfplumber not installed, skipping bbox enrichment", file=sys.stderr)
        # Just copy input to output
        content = Path(args.table_json).read_text()
        if args.output:
            Path(args.output).write_text(content)
        else:
            print(content)
        return 0
    
    # Load table events
    table_events = json.loads(Path(args.table_json).read_text())
    
    # Extract PDF cell bboxes
    pdf_tables = extract_pdf_table_cells(Path(args.pdf_file))
    
    # Enrich events with bboxes
    enriched = enrich_table_events(table_events, pdf_tables)
    
    # Write output
    output_text = json.dumps(enriched, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        Path(args.output).write_text(output_text, encoding='utf-8')
    else:
        print(output_text)
    
    print(f"Enriched {len(pdf_tables)} PDF tables, {sum(len(t.get('rows', [])) for t in pdf_tables)} rows", file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())
