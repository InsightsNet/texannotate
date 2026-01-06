#!/usr/bin/env python3
"""
TD Cell Extractor for LPSB - Extract table cells from PDF using pdfplumber
with Global Grid Analysis for colspan detection
"""

import pdfplumber
from typing import List, Dict, Tuple, Optional, Any


def extract_table_cells_from_pdf(pdf_path: str, events: List[Dict]) -> List[Dict]:
    """
    Extract TD cell events from PDF based on TR row events using Global Grid Analysis.
    
    Args:
        pdf_path: Path to PDF file
        events: List of LPSB events (with TR events)
    
    Returns:
        New events list with TD events inserted
    """
    # Fallback mode: if there are no TR anchors in the event stream, derive TR/TD directly
    # from PDF tables and inject them under each Table container (matched by page+order).
    if not any(ev.get("role") == "TR" for ev in events):
        return _extract_tr_td_from_pdf_tables(pdf_path, events)

    events_by_table = group_table_instances(events)
    enriched_events = []
    
    with pdfplumber.open(pdf_path) as pdf:
        # 1. Pre-calculate grid for each table instance
        table_grids = {}  # table_inst_id -> {tr_id: [cells]}
        
        for table_id, table_events in events_by_table.items():
            if not table_events:
                continue
            
            # Extract raw cells for all rows in this table
            rows_data = []
            valid_table = True
            
            for ev in table_events:
                if ev.get('role') == 'TR' and ev.get('event') == 'start':
                    page_num = ev.get('page', 1) - 1
                    if page_num < 0 or page_num >= len(pdf.pages):
                        valid_table = False
                        break
                    
                    page = pdf.pages[page_num]
                    raw_cells = extract_cells_from_row(page, ev, table_events)
                    rows_data.append({'tr_event': ev, 'raw_cells': raw_cells})
            
            if valid_table and rows_data:
                # Analyze grid to get colspan
                grid_cells = analyze_table_grid(rows_data)
                table_grids[table_id] = grid_cells
        
        # 2. Re-emit events with TD injection
        current_inst_id = None
        inst_count = 0
        depth = 0
        
        for event in events:
            enriched_events.append(event)
            
            # Track table instances
            if event.get('role') == 'Table' and event.get('event') == 'start':
                if depth == 0:
                    current_inst_id = f"table_inst_{inst_count}"
                    inst_count += 1
                depth += 1
            elif event.get('role') == 'Table' and event.get('event') == 'end':
                depth -= 1
                if depth == 0:
                    current_inst_id = None
            
            # Inject TD events after TR start
            if event.get('role') == 'TR' and event.get('event') == 'start':
                tr_id = event.get('id', '')
                
                # Look up in current table grid
                found_cells = None
                if current_inst_id and current_inst_id in table_grids:
                    grid = table_grids[current_inst_id]
                    if tr_id in grid:
                        found_cells = grid[tr_id]
                
                if found_cells:
                    for i, cell in enumerate(found_cells, 1):
                        td_start = {
                            "id": f"{tr_id}-TD{i}",
                            "role": "TD",
                            "event": "start",
                            "row": extract_row_number(tr_id),
                            "col": cell.get('col', i),
                            "colspan": cell.get('colspan', 1),
                            "page": event.get('page', 1),
                            "bbox": cell['bbox'],
                            "text": cell['text']
                        }
                        td_end = {
                            "id": f"{tr_id}-TD{i}",
                            "role": "TD",
                            "event": "end",
                            "page": event.get('page', 1)
                        }
                        enriched_events.append(td_start)
                        enriched_events.append(td_end)
    
    return enriched_events


def group_table_instances(events):
    """Group events by table instance (handling duplicate IDs across multiple tables)."""
    tables = {}
    current_id = None
    inst_count = 0
    depth = 0
    
    for event in events:
        if event.get('role') == 'Table' and event.get('event') == 'start':
            if depth == 0:
                current_id = f"table_inst_{inst_count}"
                inst_count += 1
                tables[current_id] = []
            depth += 1
        elif event.get('role') == 'Table' and event.get('event') == 'end':
            depth -= 1
            if depth == 0:
                current_id = None
        elif current_id is not None:
            tables[current_id].append(event)
            
    return tables


def analyze_table_grid(rows_data):
    """
    Analyze table grid to detect columns and calculate colspan.
    
    1. Collect all cell x-intervals from all rows
    2. Cluster left edges to find atomic columns  
    3. Map each cell to columns it spans
    """
    if not rows_data:
        return {}
    
    # 1. Collect all x-intervals
    all_intervals = []
    for row in rows_data:
        for cell in row['raw_cells']:
            bbox = cell['bbox']
            all_intervals.append((bbox[0], bbox[2]))  # x0, x1
            
    if not all_intervals:
        return {}
    
    # 2. Cluster left edges to find columns
    left_edges = sorted([x[0] for x in all_intervals])
    
    columns_starts = []
    if left_edges:
        curr_cluster = [left_edges[0]]
        for x in left_edges[1:]:
            if x - curr_cluster[-1] > 10:  # 10pt tolerance
                columns_starts.append(sum(curr_cluster) / len(curr_cluster))
                curr_cluster = [x]
            else:
                curr_cluster.append(x)
        columns_starts.append(sum(curr_cluster) / len(curr_cluster))
    
    # 3. Define column intervals
    right_edge = max(x[1] for x in all_intervals)
    columns_starts.sort()
    
    cols_intervals = []
    for i in range(len(columns_starts)):
        c_start = columns_starts[i]
        c_end = columns_starts[i+1] if i+1 < len(columns_starts) else right_edge
        cols_intervals.append((c_start, c_end))
    
    # 4. Map cells to grid
    processed_grid = {}
    
    for row in rows_data:
        tr_id = row['tr_event']['id']
        final_cells = []
        
        for cell in row['raw_cells']:
            x0 = cell['bbox'][0]
            x1 = cell['bbox'][2]
            
            # Find which columns this cell overlaps
            start_col = -1
            end_col = -1
            
            for i, (cs, ce) in enumerate(cols_intervals):
                overlap_start = max(x0, cs)
                overlap_end = min(x1, ce)
                overlap_len = overlap_end - overlap_start
                
                col_width = ce - cs
                if overlap_len > 0 and (overlap_len > 5 or overlap_len > col_width * 0.5):
                    if start_col == -1:
                        start_col = i
                    end_col = i
            
            if start_col == -1:
                # Fallback: assign to closest column
                min_dist = float('inf')
                best_i = 0
                for i, cs in enumerate(columns_starts):
                    if abs(x0 - cs) < min_dist:
                        min_dist = abs(x0 - cs)
                        best_i = i
                start_col = best_i
                end_col = best_i
            
            cell['col'] = start_col + 1
            cell['colspan'] = end_col - start_col + 1
            
            final_cells.append(cell)
            
        processed_grid[tr_id] = final_cells
        
    return processed_grid


def extract_cells_from_row(page, tr_event: Dict, all_events: List[Dict]) -> List[Dict]:
    """
    Extract individual cells from a table row using Y-coordinate filtering.
    
    Args:
        page: pdfplumber page object
        tr_event: TR start event with x/y coordinates
        all_events: All events in this table (for finding TR end)
    
    Returns:
        List of cell dicts with bbox and text
    """
    tr_id = tr_event.get('id', '')
    
    # Find corresponding TR end event
    tr_end = None
    for event in all_events:
        if event.get('role') == 'TR' and event.get('event') == 'end' and event.get('id') == tr_id:
            tr_end = event
            break
    
    if not tr_end:
        return []
    
    # Get Y-coordinate range
    y_start = tr_event.get('y', 0)
    y_end = tr_end.get('y', 0)
    
    if y_start == 0 and y_end == 0:
        return []  # No coordinates available
    
    # Convert TeX sp units to PDF points
    page_height_pt = page.height
    
    # TeX: (0,0) top-left, Y grows down
    # PDF: (0,0) bottom-left, Y grows up
    # Conversion: y_pdf = page_height - (y_tex / 65536.0)
    
    y_top_pdf = page_height_pt - (y_start / 65536.0)
    y_bottom_pdf = page_height_pt - (y_end / 65536.0)
    
    # Ensure correct order (top should be > bottom in PDF coords)
    if y_top_pdf < y_bottom_pdf:
        y_top_pdf, y_bottom_pdf = y_bottom_pdf, y_top_pdf
    
    # ADAPTIVE FIX: TR coordinates may include extra content (e.g., \hline, Caption)
    # Strategy: Do preliminary wide filtering, then use actual word positions
    
    # Step 1: Wide preliminary filter (generous margins)
    all_words = page.extract_words()
    prelim_margin = 15
    prelim_y_max = y_top_pdf + prelim_margin
    prelim_y_min = y_bottom_pdf - prelim_margin
    
    prelim_words = [w for w in all_words 
                   if (prelim_y_min < w['top'] <= prelim_y_max) or 
                      (prelim_y_min < w['bottom'] <= prelim_y_max) or
                      (w['top'] < prelim_y_max and w['bottom'] > prelim_y_min)]
    
    if not prelim_words:
        return []
    
    # Step 2: Find actual content bounds using MEDIAN (not percentiles)
    # This avoids including outliers like Caption text
    word_tops = sorted([w['top'] for w in prelim_words])
    word_bottoms = sorted([w['bottom'] for w in prelim_words])
    
    # Use median to find the main cluster
    n = len(word_tops)
    median_top = word_tops[n // 2]
    median_bottom = word_bottoms[n // 2]
    
    # The actual row range should EXCLUDE words that are only partially overlapping
    # Find the tightest range that captures the median cluster
    # Strategy: Use the maximum of all word 'top' values as the actual top
    # (this excludes words that start above the row like Caption)
    actual_y_top = max(w['top'] for w in prelim_words if abs(w['top'] - median_top) < 5)
    actual_y_bottom = min(w['bottom'] for w in prelim_words if abs(w['bottom'] - median_bottom) < 5)
    
    # Step 3: Final tight filter - only words FULLY within the content range
    final_margin = 2
    final_y_max = actual_y_top + final_margin  
    final_y_min = actual_y_bottom - final_margin
    
    # STRICT: Only include words whose TOP is at or below actual_y_top
    # This excludes Caption words that extend above the row
    words = [w for w in prelim_words 
            if w['top'] >= (actual_y_top - 1) and w['bottom'] <= (actual_y_bottom + 1)]
    
    # Debug: show filtered words for TR-1
    if tr_id == 'TR-1':
        print(f'\n=== DEBUG {tr_id} ===')
        print(f'TeX Y: start={y_start} end={y_end}')
        print(f'PDF Y: top={y_top_pdf:.2f} bottom={y_bottom_pdf:.2f}')
        print(f'Prelim filter: {prelim_y_min:.2f} - {prelim_y_max:.2f} ({len(prelim_words)} words)')
        print(f'Actual content: {actual_y_bottom:.2f} - {actual_y_top:.2f}')
        print(f'Final filter: {final_y_min:.2f} - {final_y_max:.2f} ({len(words)} words)')
        for w in words[:10]:
            print(f'  "{w["text"]}" at Y {w["top"]:.2f}-{w["bottom"]:.2f}')

    
    if not words:
        return []
    
    # Cluster words into cells by X-coordinate gaps
    cells = cluster_words_into_cells(words)
    
    return cells


def cluster_words_into_cells(words: List[Dict]) -> List[Dict]:
    """Cluster words into cells based on X-coordinate gaps."""
    if not words:
        return []
    
    sorted_words = sorted(words, key=lambda w: w['x0'])
    
    cells = []
    current_cell = [sorted_words[0]]
    gap_threshold = 10  # 10pt gap starts new cell
    
    for i in range(1, len(sorted_words)):
        prev_word = sorted_words[i-1]
        curr_word = sorted_words[i]
        
        gap = curr_word['x0'] - prev_word['x1']
        if gap > gap_threshold:
            if current_cell:
                cells.append(create_cell_from_words(current_cell))
            current_cell = [curr_word]
        else:
            current_cell.append(curr_word)
    
    # Don't forget last cell
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


def _find_pdf_tables_for_page(page, table_settings: Optional[Dict[str, Any]] = None):
    """Return pdfplumber tables sorted top-to-bottom on the page."""
    try:
        tables = page.find_tables(table_settings=table_settings) if table_settings else page.find_tables()
    except TypeError:
        # Older pdfplumber versions may not accept table_settings kwarg.
        tables = page.find_tables()
    return sorted(tables, key=lambda t: getattr(t, "bbox", (0, 0, 0, 0))[1])


def _cell_text(page, bbox: Tuple[float, float, float, float]) -> str:
    """Extract text within bbox (best-effort)."""
    try:
        crop = page.crop(bbox)
        words = crop.extract_words() or []
        # Stable reading order: top-to-bottom, then left-to-right.
        words.sort(key=lambda w: (w.get("top", 0), w.get("x0", 0)))
        txt = " ".join(w.get("text", "") for w in words if w.get("text"))
        return " ".join(txt.split())
    except Exception:
        return ""


def _extract_tr_td_from_pdf_tables(pdf_path: str, events: List[Dict]) -> List[Dict]:
    """
    Fallback extraction mode:
    - Detect tables directly from PDF using pdfplumber
    - Match them to LPSB Table events by (page, encounter order)
    - Inject TR/TD events with bbox/text/colspan
    """
    enriched: List[Dict] = []

    # Default settings favor ruled tables.
    table_settings = {
        "vertical_strategy": "lines",
        "horizontal_strategy": "lines",
    }

    with pdfplumber.open(pdf_path) as pdf:
        tables_by_page: Dict[int, List[Any]] = {}
        for i, page in enumerate(pdf.pages):
            tables_by_page[i] = _find_pdf_tables_for_page(page, table_settings=table_settings)

        # per-page index of which detected pdf table to attach next
        table_idx_by_page: Dict[int, int] = {}

        for ev in events:
            enriched.append(ev)

            if ev.get("role") != "Table" or ev.get("event") != "start":
                continue

            page_num = (ev.get("page", 1) or 1) - 1
            if page_num < 0 or page_num >= len(pdf.pages):
                continue

            idx = table_idx_by_page.get(page_num, 0)
            table_idx_by_page[page_num] = idx + 1

            tables = tables_by_page.get(page_num, [])
            if idx >= len(tables):
                continue

            table = tables[idx]
            page = pdf.pages[page_num]

            table_id = ev.get("id", f"Table-p{page_num+1}-{idx+1}")

            # Use pdfplumber's own extracted grid text if available; it's usually more stable
            # than per-cell text extraction (especially near captions).
            try:
                grid_text = table.extract() or []
            except Exception:
                grid_text = []

            rows = getattr(table, "rows", None) or []
            for r_i, row in enumerate(rows, 1):
                tr_id = f"{table_id}-TR{r_i}"
                tr_bbox = getattr(row, "bbox", None)
                tr_start: Dict[str, Any] = {
                    "id": tr_id,
                    "role": "TR",
                    "event": "start",
                    "page": page_num + 1,
                }
                if tr_bbox:
                    tr_start["bbox"] = tr_bbox
                enriched.append(tr_start)

                cells = getattr(row, "cells", None) or []
                ncols = len(cells)
                c_i = 0
                while c_i < ncols:
                    cell_bbox = cells[c_i]
                    if cell_bbox is None:
                        c_i += 1
                        continue

                    colspan = 1
                    while c_i + colspan < ncols and cells[c_i + colspan] is None:
                        colspan += 1

                    col = c_i + 1
                    td_id = f"{tr_id}-TD{col}"
                    text = ""
                    if r_i - 1 < len(grid_text) and c_i < len(grid_text[r_i - 1]):
                        text = grid_text[r_i - 1][c_i] or ""
                    if not text:
                        text = _cell_text(page, cell_bbox)

                    td_start: Dict[str, Any] = {
                        "id": td_id,
                        "role": "TD",
                        "event": "start",
                        "row": r_i,
                        "col": col,
                        "colspan": colspan,
                        "page": page_num + 1,
                        "bbox": cell_bbox,
                        "text": text,
                    }
                    td_end = {
                        "id": td_id,
                        "role": "TD",
                        "event": "end",
                        "page": page_num + 1,
                    }
                    enriched.append(td_start)
                    enriched.append(td_end)

                    c_i += colspan

                tr_end = {
                    "id": tr_id,
                    "role": "TR",
                    "event": "end",
                    "page": page_num + 1,
                }
                enriched.append(tr_end)

    return enriched
