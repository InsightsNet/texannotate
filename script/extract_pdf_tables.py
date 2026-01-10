#!/usr/bin/env python3
"""
Extract table cell bounding boxes from PDF using pdfplumber.

This module extracts cell coordinates from PDF tables to enable
alignment with LaTeXML semantic structure.
"""

import json
from pathlib import Path
from typing import Optional

try:
    import pdfplumber
    HAS_PDFPLUMBER = True
except ImportError:
    HAS_PDFPLUMBER = False


def extract_tables_from_pdf(pdf_path: Path, table_bboxes: list[dict] = None) -> list[dict]:
    """
    Extract table cell bboxes from a PDF.
    
    Args:
        pdf_path: Path to PDF file
        table_bboxes: Optional list of known table bboxes from lpsb.json
                     Each dict should have 'page', 'bbox' (x1,y1,x2,y2)
    
    Returns:
        List of table dicts with rows and cell bboxes
    """
    if not HAS_PDFPLUMBER:
        raise ImportError("pdfplumber is required: pip install pdfplumber")
    
    tables = []
    
    # Table settings for better extraction
    # Use text strategy which is more robust for LaTeX tables
    table_settings = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "snap_tolerance": 5,
        "join_tolerance": 5,
        "min_words_vertical": 1,
        "min_words_horizontal": 1,
    }
    
    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages, start=1):
            # Find tables on this page with text-based strategy
            page_tables = page.find_tables(table_settings=table_settings)
            
            for table_idx, table in enumerate(page_tables):
                table_data = {
                    'page': page_num,
                    'table_index': table_idx,
                    'bbox': list(table.bbox),  # (x0, top, x1, bottom)
                    'rows': []
                }
                
                # Use extract() to get text grid, then map to bboxes
                extracted = table.extract()
                
                # Get cell positions from rows
                for row_idx, row in enumerate(table.rows):
                    row_data = {
                        'row_index': row_idx,
                        'cells': []
                    }
                    
                    for cell_idx, cell in enumerate(row.cells):
                        if cell is None:
                            # Empty cell (part of merged cell or missing)
                            # Still add placeholder to maintain column alignment
                            cell_data = {
                                'col_index': cell_idx,
                                'bbox': None,
                                'text': extracted[row_idx][cell_idx] if row_idx < len(extracted) and cell_idx < len(extracted[row_idx]) else ""
                            }
                        else:
                            # cell is (x0, top, x1, bottom)
                            cell_data = {
                                'col_index': cell_idx,
                                'bbox': list(cell),  # Convert tuple to list
                            }
                            
                            # Get text from extracted grid (more reliable)
                            if row_idx < len(extracted) and cell_idx < len(extracted[row_idx]):
                                cell_data['text'] = (extracted[row_idx][cell_idx] or "").strip()
                            else:
                                # Fallback: extract text from cell region
                                try:
                                    cell_crop = page.within_bbox(cell)
                                    cell_text = cell_crop.extract_text() or ""
                                    cell_data['text'] = cell_text.strip()
                                except Exception:
                                    cell_data['text'] = ""
                        
                        row_data['cells'].append(cell_data)
                    
                    if row_data['cells']:
                        table_data['rows'].append(row_data)
                
                tables.append(table_data)
    
    return tables



def match_tables_by_page_position(
    latexml_tables: list[dict],
    pdf_tables: list[dict],
    lpsb_tables: list[dict] = None
) -> list[dict]:
    """
    Match LaTeXML tables with PDF tables by position.
    
    Simple approach: match by order on each page.
    
    Args:
        latexml_tables: Tables from LaTeXML HTML
        pdf_tables: Tables from pdfplumber
        lpsb_tables: Optional Table events from lpsb.json (for Table-N IDs)
    
    Returns:
        Merged tables with semantic info + bboxes
    """
    merged = []
    
    # Group PDF tables by page
    pdf_by_page = {}
    for pt in pdf_tables:
        page = pt['page']
        if page not in pdf_by_page:
            pdf_by_page[page] = []
        pdf_by_page[page].append(pt)
    
    # Match LaTeXML tables to PDF tables
    for i, lt in enumerate(latexml_tables):
        merged_table = {
            'id': lt.get('id', f'Table-{i+1}'),
            'caption': lt.get('caption', ''),
        }
        
        # Find corresponding PDF table
        # For now, use simple index matching
        # TODO: improve matching using table bbox from lpsb.json
        pdf_table = pdf_tables[i] if i < len(pdf_tables) else None
        
        if pdf_table:
            merged_table['page'] = pdf_table['page']
            merged_table['bbox'] = pdf_table['bbox']
        
        # Merge structure with cell bboxes
        structure = {}
        
        for section_name in ('thead', 'tbody'):
            section = lt.get(section_name)
            if not section:
                continue
            
            merged_section = {'rows': []}
            
            for row_idx, row in enumerate(section.get('rows', [])):
                merged_row = {'cells': []}
                
                for cell_idx, cell in enumerate(row.get('cells', [])):
                    merged_cell = cell.copy()
                    
                    # Try to find matching PDF cell bbox
                    if pdf_table:
                        # Calculate absolute row index (thead rows + tbody rows)
                        abs_row_idx = row_idx
                        if section_name == 'tbody' and 'thead' in lt:
                            abs_row_idx += len(lt['thead'].get('rows', []))
                        
                        # Find cell in PDF table
                        if abs_row_idx < len(pdf_table['rows']):
                            pdf_row = pdf_table['rows'][abs_row_idx]
                            if cell_idx < len(pdf_row['cells']):
                                pdf_cell = pdf_row['cells'][cell_idx]
                                merged_cell['bbox'] = pdf_cell['bbox']
                    
                    merged_row['cells'].append(merged_cell)
                
                merged_section['rows'].append(merged_row)
            
            structure[section_name] = merged_section
        
        if structure:
            merged_table['structure'] = structure
        
        merged.append(merged_table)
    
    return merged


def main():
    """CLI entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract table cells from PDF')
    parser.add_argument('pdf_file', help='Path to PDF file')
    parser.add_argument('--output', '-o', help='Output JSON file (default: stdout)')
    parser.add_argument('--pretty', '-p', action='store_true', help='Pretty-print JSON')
    
    args = parser.parse_args()
    
    tables = extract_tables_from_pdf(args.pdf_file)
    
    indent = 2 if args.pretty else None
    output = json.dumps(tables, indent=indent, ensure_ascii=False)
    
    if args.output:
        Path(args.output).write_text(output + '\n', encoding='utf-8')
    else:
        print(output)


if __name__ == '__main__':
    main()
