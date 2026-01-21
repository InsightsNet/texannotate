#!/usr/bin/env python3
"""
parse_synctex.py - Parse SyncTeX files for source ↔ PDF position mapping

SyncTeX file format (simplified):
- Input:N:path  → file_id N maps to path
- {N            → start page N
- }N            → end page N
- [file,line:x,y:w,h,d  → vbox record
- (file,line:x,y:w,h,d  → hbox record
- x,file,line:x,y        → current position record

Coordinates are in scaled points (sp), 65536 sp = 1 pt = 1/72.27 inch
"""

import gzip
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple


@dataclass
class SyncTeXRecord:
    """A single SyncTeX record linking source to PDF position."""
    file_id: int
    line: int
    page: int
    x: int  # in scaled points
    y: int  # in scaled points
    width: int = 0
    height: int = 0
    depth: int = 0
    box_type: str = 'x'  # 'h' (hbox), 'v' (vbox), 'x' (current)


@dataclass
class SyncTeXData:
    """Parsed SyncTeX data."""
    files: Dict[int, str] = field(default_factory=dict)  # file_id → path
    records: List[SyncTeXRecord] = field(default_factory=list)
    magnification: int = 1000
    unit: int = 1
    x_offset: int = 0
    y_offset: int = 0


# Conversion: scaled points to PDF points (1/72 inch)
# 65536 sp = 1 pt (TeX point = 1/72.27 inch)
# PDF point = 1/72 inch
# So PDF_pt = sp / 65536 * (72/72.27) ≈ sp / 65781
SP_TO_PDF_PT = 65781


def parse_synctex(synctex_path: Path) -> SyncTeXData:
    """
    Parse a .synctex.gz file.
    
    Args:
        synctex_path: Path to .synctex.gz file
        
    Returns:
        SyncTeXData with files mapping and position records
    """
    data = SyncTeXData()
    
    # Read and decompress
    if synctex_path.suffix == '.gz':
        with gzip.open(synctex_path, 'rt', errors='replace') as f:
            content = f.read()
    else:
        content = synctex_path.read_text(errors='replace')
    
    current_page = 0
    
    # Patterns
    input_pattern = re.compile(r'^Input:(\d+):(.+)$')
    page_start_pattern = re.compile(r'^\{(\d+)$')
    page_end_pattern = re.compile(r'^\}(\d+)$')
    # vbox: [file,line:x,y:w,h,d
    vbox_pattern = re.compile(r'^\[(\d+),(\d+):(-?\d+),(-?\d+):(-?\d+),(-?\d+),(-?\d+)')
    # hbox: (file,line:x,y:w,h,d
    hbox_pattern = re.compile(r'^\((\d+),(\d+):(-?\d+),(-?\d+):(-?\d+),(-?\d+),(-?\d+)')
    # current: xfile,line:x,y  (note: no comma between x and file_id)
    current_pattern = re.compile(r'^x(\d+),(\d+):(-?\d+),(-?\d+)')
    # Also handle: h/v/g/k records with simpler format
    simple_hv_pattern = re.compile(r'^([hvgk])(\d+),(\d+):(-?\d+),(-?\d+)')
    
    for line in content.splitlines():
        line = line.strip()
        if not line:
            continue
            
        # Input file mapping
        m = input_pattern.match(line)
        if m:
            file_id = int(m.group(1))
            file_path = m.group(2)
            data.files[file_id] = file_path
            continue
        
        # Page markers
        m = page_start_pattern.match(line)
        if m:
            current_page = int(m.group(1))
            continue
            
        m = page_end_pattern.match(line)
        if m:
            continue
        
        # Magnification, Unit, Offset
        if line.startswith('Magnification:'):
            data.magnification = int(line.split(':')[1])
            continue
        if line.startswith('Unit:'):
            data.unit = int(line.split(':')[1])
            continue
        if line.startswith('X Offset:'):
            data.x_offset = int(line.split(':')[1])
            continue
        if line.startswith('Y Offset:'):
            data.y_offset = int(line.split(':')[1])
            continue
        
        # Box records
        m = vbox_pattern.match(line)
        if m:
            data.records.append(SyncTeXRecord(
                file_id=int(m.group(1)),
                line=int(m.group(2)),
                page=current_page,
                x=int(m.group(3)),
                y=int(m.group(4)),
                width=int(m.group(5)),
                height=int(m.group(6)),
                depth=int(m.group(7)),
                box_type='v'
            ))
            continue
            
        m = hbox_pattern.match(line)
        if m:
            data.records.append(SyncTeXRecord(
                file_id=int(m.group(1)),
                line=int(m.group(2)),
                page=current_page,
                x=int(m.group(3)),
                y=int(m.group(4)),
                width=int(m.group(5)),
                height=int(m.group(6)),
                depth=int(m.group(7)),
                box_type='h'
            ))
            continue
        
        # Current position records
        m = current_pattern.match(line)
        if m:
            data.records.append(SyncTeXRecord(
                file_id=int(m.group(1)),
                line=int(m.group(2)),
                page=current_page,
                x=int(m.group(3)),
                y=int(m.group(4)),
                box_type='x'
            ))
            continue
        
        # Simple h/v/g/k records
        m = simple_hv_pattern.match(line)
        if m:
            data.records.append(SyncTeXRecord(
                file_id=int(m.group(2)),
                line=int(m.group(3)),
                page=current_page,
                x=int(m.group(4)),
                y=int(m.group(5)),
                box_type=m.group(1)
            ))
            continue
    
    return data


def sp_to_pdf_points(sp: int) -> float:
    """Convert scaled points to PDF points."""
    return sp / SP_TO_PDF_PT


def query_by_position(
    data: SyncTeXData,
    page: int,
    x_pdf: float,
    y_pdf: float,
    tolerance: float = 10.0
) -> List[Tuple[str, int]]:
    """
    Find source locations (file, line) near a PDF position.
    
    Args:
        data: Parsed SyncTeX data
        page: PDF page number (1-indexed)
        x_pdf: X coordinate in PDF points
        y_pdf: Y coordinate in PDF points
        tolerance: Distance tolerance in PDF points
        
    Returns:
        List of (filename, line_number) tuples within tolerance
    """
    results = []
    x_sp = int(x_pdf * SP_TO_PDF_PT)
    y_sp = int(y_pdf * SP_TO_PDF_PT)
    tol_sp = int(tolerance * SP_TO_PDF_PT)
    
    for rec in data.records:
        if rec.page != page:
            continue
        
        # Check if within tolerance
        dx = abs(rec.x - x_sp)
        dy = abs(rec.y - y_sp)
        
        if dx <= tol_sp and dy <= tol_sp:
            filename = data.files.get(rec.file_id, f"file_{rec.file_id}")
            results.append((filename, rec.line))
    
    return list(set(results))  # Deduplicate


def get_source_lines_on_page(
    data: SyncTeXData,
    page: int,
    main_file_only: bool = True
) -> Dict[Tuple[str, int], List[SyncTeXRecord]]:
    """
    Get all source lines that appear on a given page.
    
    Args:
        data: Parsed SyncTeX data
        page: PDF page number (1-indexed)
        main_file_only: If True, only include records from main.tex or similar
        
    Returns:
        Dict mapping (filename, line) to list of position records
    """
    result: Dict[Tuple[str, int], List[SyncTeXRecord]] = {}
    
    for rec in data.records:
        if rec.page != page:
            continue
        
        filename = data.files.get(rec.file_id, "")
        
        # Filter to main source files (not packages)
        if main_file_only:
            if '/texmf-dist/' in filename or '/texlive/' in filename:
                continue
        
        key = (filename, rec.line)
        if key not in result:
            result[key] = []
        result[key].append(rec)
    
    return result


def find_crosspage_lines(data: SyncTeXData) -> Dict[Tuple[str, int], List[int]]:
    """
    Find source lines that appear on multiple pages (cross-page content).
    
    Returns:
        Dict mapping (filename, line) to list of page numbers
    """
    line_pages: Dict[Tuple[str, int], set] = {}
    
    for rec in data.records:
        filename = data.files.get(rec.file_id, "")
        # Skip package files
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue
            
        key = (filename, rec.line)
        if key not in line_pages:
            line_pages[key] = set()
        line_pages[key].add(rec.page)
    
    # Return only lines on multiple pages
    return {
        key: sorted(pages)
        for key, pages in line_pages.items()
        if len(pages) > 1
    }


def find_crosscolumn_lines(
    data: SyncTeXData,
    column_threshold: float = 100.0  # PDF points between columns
) -> Dict[Tuple[str, int, int], List[Tuple[float, float]]]:
    """
    Find source lines that appear in multiple columns on the SAME page.
    
    Cross-column content is detected when the same source line has records
    at significantly different X positions on the same page.
    
    Args:
        data: Parsed SyncTeX data
        column_threshold: Minimum X distance (PDF points) to consider as different column
        
    Returns:
        Dict mapping (filename, line, page) to list of (x, y) positions in different columns
    """
    # Group records by (file, line, page)
    line_positions: Dict[Tuple[str, int, int], List[Tuple[int, int]]] = {}
    
    for rec in data.records:
        filename = data.files.get(rec.file_id, "")
        # Skip package files
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue
        
        key = (filename, rec.line, rec.page)
        if key not in line_positions:
            line_positions[key] = []
        line_positions[key].append((rec.x, rec.y))
    
    # Find lines with multiple distinct X regions (columns)
    threshold_sp = int(column_threshold * SP_TO_PDF_PT)
    result: Dict[Tuple[str, int, int], List[Tuple[float, float]]] = {}
    
    for key, positions in line_positions.items():
        if len(positions) < 2:
            continue
        
        # Sort by X coordinate
        sorted_pos = sorted(positions, key=lambda p: p[0])
        
        # Find distinct X clusters (columns)
        columns: List[List[Tuple[int, int]]] = []
        current_column: List[Tuple[int, int]] = [sorted_pos[0]]
        
        for pos in sorted_pos[1:]:
            # If X difference exceeds threshold, it's a new column
            if pos[0] - current_column[-1][0] > threshold_sp:
                columns.append(current_column)
                current_column = [pos]
            else:
                current_column.append(pos)
        columns.append(current_column)
        
        # If multiple columns found, this is cross-column content
        if len(columns) > 1:
            # Return representative positions from each column
            result[key] = [
                (sp_to_pdf_points(col[0][0]), sp_to_pdf_points(col[0][1]))
                for col in columns
            ]
    
    return result


def find_all_discontinuities(data: SyncTeXData) -> Dict[str, dict]:
    """
    Find all source lines with discontinuous layout (cross-page OR cross-column).
    
    Returns:
        Dict with 'crosspage' and 'crosscolumn' keys containing the respective results
    """
    return {
        'crosspage': find_crosspage_lines(data),
        'crosscolumn': find_crosscolumn_lines(data),
    }



def main():
    """CLI for testing the parser."""
    import argparse
    import json
    
    parser = argparse.ArgumentParser(description='Parse SyncTeX file')
    parser.add_argument('synctex', type=Path, help='Path to .synctex.gz file')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    parser.add_argument('--crosspage', action='store_true', help='Show cross-page lines')
    
    args = parser.parse_args()
    
    if not args.synctex.exists():
        print(f"Error: {args.synctex} not found")
        return 1
    
    data = parse_synctex(args.synctex)
    
    print(f"Parsed {len(data.files)} input files, {len(data.records)} records")
    
    if args.verbose:
        print("\nInput files:")
        for fid, path in sorted(data.files.items()):
            if '/texmf-dist/' not in path:
                print(f"  {fid}: {path}")
    
    if args.crosspage:
        crosspage = find_crosspage_lines(data)
        print(f"\nCross-page lines ({len(crosspage)}):")
        for (fname, line), pages in sorted(crosspage.items()):
            basename = Path(fname).name
            print(f"  {basename}:{line} → pages {pages}")
    
    return 0
