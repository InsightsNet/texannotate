#!/usr/bin/env python3
"""
extract_cells.py - PDF-side table cell extraction using pdfplumber.

This is the most reliable approach for table extraction as it works directly
with the rendered PDF, avoiding all LaTeX hook complexity.

Features:
- Extracts all tables from a PDF
- Detects colspan (merged columns) via None cells
- Detects rowspan (merged rows) via None cells
- Outputs structured JSON with TR/TD hierarchy

Usage:
    python extract_cells.py <pdf_file> [--output <json_file>]
    python extract_cells.py main.pdf --output main.lpsb-table.json

Output format (compatible with LPSB table JSON):
[
  {"id": "Table-1", "role": "Table", "event": "start", "page": 1, ...},
  {"id": "Table-1-TR1", "role": "TR", "event": "start", "row": 1, ...},
  {"id": "Table-1-TR1-TD1", "role": "TD", "event": "start", "row": 1, "col": 1, "text": "...", ...},
  ...
]
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List, Dict, Any, Optional

try:
    import pdfplumber
except ImportError:
    print("Error: pdfplumber not installed. Run: pip install pdfplumber", file=sys.stderr)
    sys.exit(1)


def analyze_spans(table: List[List[str]]) -> List[List[Dict[str, Any]]]:
    """Analyze a table to detect colspan and rowspan.
    
    pdfplumber returns None for cells that are part of a span.
    We need to:
    1. Detect colspan by looking at consecutive None cells in a row
    2. Detect rowspan by looking at None cells in a column that follow a non-None cell
    
    Returns:
        List of rows, each containing cell dicts with colspan/rowspan info
    """
    if not table:
        return []
    
    num_rows = len(table)
    num_cols = max(len(row) for row in table) if table else 0
    
    # Normalize table to have consistent column count
    normalized = []
    for row in table:
        normalized_row = list(row) + [None] * (num_cols - len(row))
        normalized.append(normalized_row)
    
    # Track which cells are "owned" by a span
    ownership = [[None for _ in range(num_cols)] for _ in range(num_rows)]
    
    # First pass: identify span origins
    for r in range(num_rows):
        for c in range(num_cols):
            if normalized[r][c] is not None:
                # This is a potential span origin
                ownership[r][c] = (r, c)
                
                # Count colspan (consecutive Nones to the right)
                colspan = 1
                cc = c + 1
                while cc < num_cols and normalized[r][cc] is None:
                    # Check if this None is part of this colspan
                    # (not a rowspan from above)
                    if r == 0 or normalized[r-1][cc] is None or ownership[r-1][cc] != (r-1, cc):
                        ownership[r][cc] = (r, c)
                        colspan += 1
                        cc += 1
                    else:
                        break
                
                # Store colspan temporarily
                normalized[r][c] = {'text': normalized[r][c], 'colspan': colspan, 'rowspan': 1}
    
    # Second pass: detect rowspan
    for c in range(num_cols):
        for r in range(num_rows):
            cell = normalized[r][c]
            if isinstance(cell, dict):
                # Check how many rows below are None in this column
                rowspan = 1
                rr = r + 1
                while rr < num_rows:
                    below = normalized[rr][c]
                    if below is None:
                        # Check if it's truly part of this rowspan
                        # (not already claimed by a colspan)
                        if ownership[rr][c] is None:
                            ownership[rr][c] = (r, c)
                            rowspan += 1
                            rr += 1
                        else:
                            break
                    else:
                        break
                cell['rowspan'] = rowspan
    
    # Build result
    result = []
    for r in range(num_rows):
        row_cells = []
        for c in range(num_cols):
            cell = normalized[r][c]
            if isinstance(cell, dict):
                row_cells.append({
                    'text': cell['text'] or '',
                    'col': c + 1,  # 1-indexed
                    'colspan': cell['colspan'],
                    'rowspan': cell['rowspan']
                })
        result.append(row_cells)
    
    return result


def parse_log_markers(log_path: Path) -> Dict[str, Any]:
    """Parse LPSB table markers from LaTeX log file.
    
    Markers:
    - LPSB-TABLE-BEGIN: table=<id>, page=<n>
    - LPSB-ROW-END: table=<id>, row=<n>, page=<n>
    
    Returns:
        dict: {
            "tables": [{"id": str, "page": int, "row_count": int}, ...],
            "by_page": {page_num: [table_info, ...], ...}
        }
    """
    import re
    
    tables = []
    current_table = None
    
    begin_pattern = re.compile(r'LPSB-TABLE-BEGIN:\s*table=([^,]+),\s*page=(\d+)')
    row_pattern = re.compile(r'LPSB-ROW-END:\s*table=([^,]+),\s*row=(\d+),\s*page=(\d+)')
    
    try:
        with open(log_path, 'r', encoding='utf-8', errors='replace') as f:
            for line in f:
                # Check for table begin
                m = begin_pattern.search(line)
                if m:
                    if current_table:
                        tables.append(current_table)
                    current_table = {
                        "id": m.group(1),
                        "page": int(m.group(2)),
                        "row_count": 0
                    }
                    continue
                
                # Check for row end
                m = row_pattern.search(line)
                if m:
                    if current_table and current_table["id"] == m.group(1):
                        current_table["row_count"] = int(m.group(2))
        
        if current_table:
            tables.append(current_table)
    except Exception as e:
        print(f"Warning: Could not parse log file: {e}", file=sys.stderr)
        return {"tables": [], "by_page": {}}
    
    # Index by page
    by_page = {}
    for t in tables:
        page = t["page"]
        if page not in by_page:
            by_page[page] = []
        by_page[page].append(t)
    
    return {"tables": tables, "by_page": by_page}


def extract_table_json(pdf_path: Path, log_path: Optional[Path] = None) -> List[Dict[str, Any]]:
    """Extract tables from PDF and generate LPSB-compatible JSON.
    
    If log_path is provided, use LaTeX log markers to:
    1. Match PDF tables to LaTeX table IDs
    2. Validate row counts
    3. Add container metadata
    """
    events = []
    
    # Parse log markers if available
    log_info = None
    if log_path and log_path.exists():
        log_info = parse_log_markers(log_path)
        if log_info["tables"]:
            print(f"Found {len(log_info['tables'])} table(s) in log", file=sys.stderr)
    
    with pdfplumber.open(pdf_path) as pdf:
        global_table_num = 0
        
        for page_idx, page in enumerate(pdf.pages):
            page_num = page_idx + 1
            tables = page.find_tables()
            
            # Get log tables for this page
            page_log_tables = []
            if log_info:
                page_log_tables = log_info.get("by_page", {}).get(page_num, [])
            
            for table_idx, table in enumerate(tables):
                global_table_num += 1
                
                # Try to match with log table
                table_id = f"Table-{global_table_num}"
                log_row_count = None
                
                if table_idx < len(page_log_tables):
                    log_table = page_log_tables[table_idx]
                    table_id = log_table["id"]  # Use LaTeX table ID
                    log_row_count = log_table.get("row_count")
                
                # Extract table data
                data = table.extract()
                if not data:
                    continue
                
                # Get table bounding box
                bbox = table.bbox  # (x0, top, x1, bottom)
                
                # Analyze spans
                analyzed = analyze_spans(data)
                num_cols = max(len(row) for row in data) if data else 0
                pdf_row_count = len(analyzed)
                
                # Validate row count if log available
                if log_row_count and log_row_count != pdf_row_count:
                    print(f"Warning: {table_id} row count mismatch: PDF={pdf_row_count}, log={log_row_count}", 
                          file=sys.stderr)
                
                # Emit Table start
                table_event = {
                    "id": table_id,
                    "role": "Table",
                    "event": "start",
                    "page": page_num,
                    "cols": num_cols,
                    "rows": pdf_row_count,
                    "x0": bbox[0],
                    "y0": bbox[1],
                    "x1": bbox[2],
                    "y1": bbox[3],
                    "unit": "pt"
                }
                if log_row_count:
                    table_event["log_rows"] = log_row_count
                events.append(table_event)
                
                # Emit rows and cells
                for row_idx, row_cells in enumerate(analyzed):
                    row_num = row_idx + 1
                    tr_id = f"{table_id}-TR{row_num}"
                    
                    events.append({
                        "id": tr_id,
                        "role": "TR",
                        "event": "start",
                        "row": row_num,
                        "page": page_num
                    })
                    
                    for cell in row_cells:
                        td_id = f"{tr_id}-TD{cell['col']}"
                        
                        events.append({
                            "id": td_id,
                            "role": "TD",
                            "event": "start",
                            "row": row_num,
                            "col": cell['col'],
                            "colspan": cell['colspan'],
                            "rowspan": cell['rowspan'],
                            "text": cell['text'],
                            "page": page_num
                        })
                        events.append({
                            "id": td_id,
                            "role": "TD",
                            "event": "end"
                        })
                    
                    events.append({
                        "id": tr_id,
                        "role": "TR",
                        "event": "end",
                        "row": row_num,
                        "page": page_num
                    })
                
                # Emit Table end
                events.append({
                    "id": table_id,
                    "role": "Table",
                    "event": "end",
                    "page": page_num
                })
    
    return events


def main():
    parser = argparse.ArgumentParser(description="Extract table cells from PDF using pdfplumber")
    parser.add_argument("pdf", help="PDF file to extract tables from")
    parser.add_argument("--output", "-o", help="Output JSON file (default: stdout)")
    parser.add_argument("--log", "-l", help="LaTeX log file for table ID matching")
    
    args = parser.parse_args()
    
    pdf_path = Path(args.pdf)
    if not pdf_path.exists():
        print(f"Error: {pdf_path} not found", file=sys.stderr)
        sys.exit(1)
    
    # Auto-detect log file if not specified
    log_path = None
    if args.log:
        log_path = Path(args.log)
    else:
        # Try jobname.log
        auto_log = pdf_path.with_suffix('.log')
        if auto_log.exists():
            log_path = auto_log
            print(f"Using log file: {log_path}", file=sys.stderr)
    
    events = extract_table_json(pdf_path, log_path)
    
    output = json.dumps(events, indent=2, ensure_ascii=False)
    
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(output)
        print(f"Wrote {len(events)} events to {args.output}", file=sys.stderr)
    else:
        print(output)


if __name__ == "__main__":
    main()

