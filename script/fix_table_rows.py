#!/usr/bin/env python3
"""
fix_table_rows.py - Post-process lpsb-table.json with row markers from log file.

The lpsb-luatable Lua module captures cells via hpack_filter but cannot detect
row boundaries (carriage returns). Row boundaries are tracked by LaTeX hooks
that write markers to the log file.

This script:
1. Parses LPSB-TABLE-BEGIN and LPSB-ROW-END markers from the .log file
2. Reads the .lpsb-table.json file (which has all cells in one row)
3. Rebuilds correct row structure based on row count from log markers
4. Outputs corrected JSON

Usage:
    python fix_table_rows.py <jobname>
    python fix_table_rows.py main.lpsb-table.json

Input files (auto-detected from jobname):
    - <jobname>.log
    - <jobname>.lpsb-table.json

Output:
    Prints corrected JSON to stdout, or writes to <jobname>.lpsb-table.fixed.json
"""

import json
import re
import sys
from pathlib import Path


def parse_log_markers(log_path: Path) -> dict:
    """Parse LPSB markers from log file.
    
    Returns:
        dict: {table_id: {"begin_page": int, "rows": [(row_num, page), ...]}}
    """
    tables = {}
    
    # Patterns
    begin_pattern = re.compile(r'LPSB-TABLE-BEGIN:\s*table=([^,]+),\s*page=(\d+)')
    row_pattern = re.compile(r'LPSB-ROW-END:\s*table=([^,]+),\s*row=(\d+),\s*page=(\d+)')
    
    with open(log_path, 'r', encoding='utf-8', errors='replace') as f:
        for line in f:
            # Check for table begin
            m = begin_pattern.search(line)
            if m:
                table_id = m.group(1)
                page = int(m.group(2))
                tables[table_id] = {"begin_page": page, "rows": []}
                continue
            
            # Check for row end
            m = row_pattern.search(line)
            if m:
                table_id = m.group(1)
                row_num = int(m.group(2))
                page = int(m.group(3))
                if table_id in tables:
                    tables[table_id]["rows"].append((row_num, page))
    
    return tables


def fix_table_json(json_path: Path, log_markers: dict) -> list:
    """Fix table JSON by assigning cells to correct rows based on log markers.
    
    Strategy:
    - Each table has N rows according to log markers
    - JSON has all cells in row 1
    - We need to redistribute cells to rows
    - Simple heuristic: divide cells evenly based on expected row count
    - Better heuristic: use first row as template (column count), then split by that count
    """
    with open(json_path, 'r', encoding='utf-8') as f:
        events = json.load(f)
    
    result = []
    current_table_id = None
    current_table_cells = []
    other_events = []  # Non-TD events for current table
    
    for event in events:
        role = event.get("role", "")
        event_type = event.get("event", "")
        
        if role == "Table" and event_type == "start":
            current_table_id = event.get("id")
            current_table_cells = []
            other_events = [event]
            
        elif role == "Table" and event_type == "end":
            # Process collected cells for this table
            if current_table_id and current_table_cells:
                fixed_events = redistribute_cells(
                    current_table_id,
                    current_table_cells,
                    log_markers.get(current_table_id, {})
                )
                result.extend(other_events[:1])  # Table start
                result.extend(fixed_events)
                result.append(event)  # Table end
            else:
                result.extend(other_events)
                result.append(event)
            
            current_table_id = None
            current_table_cells = []
            other_events = []
            
        elif role == "TD":
            current_table_cells.append(event)
            
        elif role == "TR":
            # Skip original TR events, we'll regenerate them
            pass
            
        elif current_table_id:
            other_events.append(event)
            
        else:
            result.append(event)
    
    return result


def redistribute_cells(table_id: str, cells: list, markers: dict) -> list:
    """Redistribute cells into correct rows based on log markers and width patterns.
    
    Args:
        table_id: Table identifier
        cells: List of TD events (start and end pairs)
        markers: {"begin_page": int, "rows": [(row_num, page), ...]}
    
    Returns:
        List of TR and TD events with corrected row assignments
    """
    # Separate start and end events
    starts = [c for c in cells if c.get("event") == "start"]
    ends = [c for c in cells if c.get("event") == "end"]
    
    if not starts:
        return []
    
    # Determine number of rows from log markers
    rows_info = markers.get("rows", [])
    num_rows = len(rows_info) if rows_info else 1
    
    # If no row markers, return cells as-is in single row
    if num_rows <= 1:
        return generate_row_events(table_id, 1, starts, ends, markers.get("begin_page", 0))
    
    # Width-based row detection:
    # Assumption: all rows have similar total width (table width)
    # Strategy: 
    # 1. Calculate total width of all cells
    # 2. Estimate per-row width = total / num_rows
    # 3. Accumulate cells until we reach ~row_width, then start new row
    
    total_width = sum(c.get('w', 0) for c in starts)
    avg_row_width = total_width / num_rows if num_rows > 0 else total_width
    
    # Also try: use first row pattern if it looks like a header
    # For now, use greedy width accumulation
    
    result = []
    row_num = 1
    row_starts = []
    row_ends = []
    current_width = 0
    width_threshold = avg_row_width * 0.9  # Allow 10% tolerance
    
    for i, (start, end) in enumerate(zip(starts, ends)):
        cell_width = start.get('w', 0)
        
        # Check if adding this cell would exceed threshold
        # Only start new row if we have cells and would exceed
        if row_starts and current_width + cell_width > avg_row_width * 1.3:
            # Emit current row
            row_page = rows_info[row_num - 1][1] if row_num <= len(rows_info) else 0
            result.extend(generate_row_events(table_id, row_num, row_starts, row_ends, row_page))
            
            # Start new row
            row_num += 1
            row_starts = []
            row_ends = []
            current_width = 0
        
        row_starts.append(start)
        row_ends.append(end)
        current_width += cell_width
        
        # Also check if we've reached expected row count and current row is full
        if row_num < num_rows and current_width >= width_threshold:
            # Emit current row
            row_page = rows_info[row_num - 1][1] if row_num <= len(rows_info) else 0
            result.extend(generate_row_events(table_id, row_num, row_starts, row_ends, row_page))
            
            # Start new row
            row_num += 1
            row_starts = []
            row_ends = []
            current_width = 0
    
    # Emit final row
    if row_starts:
        row_page = rows_info[row_num - 1][1] if row_num <= len(rows_info) else 0
        result.extend(generate_row_events(table_id, row_num, row_starts, row_ends, row_page))
    
    return result


def generate_row_events(table_id: str, row_num: int, starts: list, ends: list, page: int) -> list:
    """Generate TR and TD events for a single row."""
    result = []
    tr_id = f"{table_id}-TR{row_num}"
    
    # TR start
    result.append({
        "id": tr_id,
        "role": "TR",
        "event": "start",
        "row": row_num,
        "page": page
    })
    
    # TD events with updated row numbers
    for i, (start, end) in enumerate(zip(starts, ends), 1):
        td_id = f"{tr_id}-TD{i}"
        
        # Update TD start
        new_start = start.copy()
        new_start["id"] = td_id
        new_start["row"] = row_num
        new_start["col"] = i
        result.append(new_start)
        
        # Update TD end
        new_end = end.copy()
        new_end["id"] = td_id
        result.append(new_end)
    
    # TR end
    result.append({
        "id": tr_id,
        "role": "TR",
        "event": "end",
        "row": row_num,
        "page": page
    })
    
    return result


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    
    arg = sys.argv[1]
    
    # Determine paths
    if arg.endswith('.lpsb-table.json'):
        json_path = Path(arg)
        base = arg[:-len('.lpsb-table.json')]
        log_path = Path(base + '.log')
    else:
        # Assume it's a jobname
        json_path = Path(arg + '.lpsb-table.json')
        log_path = Path(arg + '.log')
    
    if not json_path.exists():
        print(f"Error: {json_path} not found", file=sys.stderr)
        sys.exit(1)
    
    if not log_path.exists():
        print(f"Warning: {log_path} not found, cannot fix row structure", file=sys.stderr)
        # Just copy input to output
        with open(json_path) as f:
            print(f.read())
        sys.exit(0)
    
    # Parse and fix
    markers = parse_log_markers(log_path)
    fixed = fix_table_json(json_path, markers)
    
    # Output
    output = json.dumps(fixed, indent=2)
    
    if len(sys.argv) > 2 and sys.argv[2] == '--inplace':
        with open(json_path, 'w') as f:
            f.write(output)
        print(f"Fixed {json_path}", file=sys.stderr)
    else:
        print(output)


if __name__ == "__main__":
    main()
