#!/usr/bin/env python3
"""
LPSB Annotation Visualizer

Draws colored bounding boxes on PDF to visualize LPSB annotations.
Each element type has a different color, and reading order numbers are shown.

Usage:
    python visualize_annotations.py input.pdf annotations.json output.pdf
"""

import argparse
import json
import fitz  # PyMuPDF
from pathlib import Path

# Color scheme for different roles (RGB 0-1 scale)
ROLE_COLORS = {
    'InlineMath': (1, 0, 0),           # Red
    'DisplayMath': (0.8, 0, 0.2),      # Dark red
    'Section': (0, 0.2, 0.8),          # Dark blue
    'P': (0.1, 0.6, 0.1),              # Green
    'Strong': (1, 0.5, 0),             # Orange
    'Em': (0.9, 0.6, 0),               # Yellow-orange
    'Link': (0.5, 0, 0.8),             # Purple
    'Reference': (0.8, 0.6, 0),        # Gold
    'Figure': (0, 0.7, 0.7),           # Cyan
    'Table': (0.6, 0.4, 0),            # Brown
    'TitleBlock': (0.9, 0, 0.9),       # Magenta
    'BlockQuote': (0.2, 0.2, 0.8),     # Blue
    'Code': (0.4, 0.4, 0.4),           # Gray
    'Calibration': (0.8, 0.8, 0.8),    # Light gray
}


def load_json_with_fix(path: str) -> list:
    """Load JSON with fault tolerance for LaTeX escape issues."""
    with open(path, 'r') as f:
        content = f.read()
    
    try:
        return json.loads(content)
    except json.JSONDecodeError:
        # Fix invalid escape sequences
        valid_escapes = set('nrtbfu\\"/')
        result = []
        i = 0
        while i < len(content):
            if content[i] == '\\' and i + 1 < len(content):
                next_char = content[i + 1]
                if next_char == '\\':
                    result.append('\\\\')
                    i += 2
                elif next_char in valid_escapes:
                    result.append(content[i:i+2])
                    i += 2
                else:
                    result.append('\\\\')
                    i += 1
            else:
                result.append(content[i])
                i += 1
        return json.loads(''.join(result))


def visualize_annotations(pdf_path: str, json_path: str, output_path: str,
                         max_pages: int = None, show_legend: bool = True,
                         show_numbers: bool = True):
    """
    Draw annotations on PDF with colors and reading order.
    
    Args:
        pdf_path: Path to input PDF
        json_path: Path to LPSB JSON annotations
        output_path: Path to output PDF with visualizations
        max_pages: Maximum pages to process (None = all)
        show_legend: Whether to show color legend on each page
        show_numbers: Whether to show reading order numbers
    """
    entries = load_json_with_fix(json_path)
    doc = fitz.open(pdf_path)
    
    # Group entries by page
    by_page = {}
    for e in entries:
        if e.get('event') != 'start':
            continue
        if not e.get('x') or not e.get('y'):
            continue
        
        try:
            page = int(e.get('page', '1'))
        except (ValueError, TypeError):
            page = 1
            
        if page not in by_page:
            by_page[page] = []
        by_page[page].append(e)
    
    num_pages = len(doc) if max_pages is None else min(len(doc), max_pages)
    print(f"Processing {num_pages} pages...")
    
    for page_num in range(num_pages):
        page = doc[page_num]
        entries_on_page = by_page.get(page_num + 1, [])
        
        # Sort by y then x for reading order
        entries_on_page.sort(key=lambda e: (e.get('y', 0), e.get('x', 0)))
        
        # Draw legend
        if show_legend:
            y_legend = 20
            for role, color in list(ROLE_COLORS.items())[:8]:
                page.draw_rect(fitz.Rect(500, y_legend, 515, y_legend + 10), 
                             color=color, fill=color)
                page.insert_text(fitz.Point(518, y_legend + 9), role, 
                               fontsize=7, color=(0,0,0))
                y_legend += 12
        
        # Draw boxes and numbers
        for idx, entry in enumerate(entries_on_page):
            x = entry.get('x', 0)
            y = entry.get('y', 0)
            w = entry.get('width', 15)
            h = entry.get('height', 10)
            role = entry.get('role', 'P')
            
            color = ROLE_COLORS.get(role, (0.5, 0.5, 0.5))
            
            # Skip calibration markers (visual clutter)
            if role == 'Calibration':
                continue
            
            # Draw rectangle
            rect = fitz.Rect(x, y, x + max(w, 8), y + max(h, 8))
            page.draw_rect(rect, color=color, width=1.5)
            
            # Draw sequence number for key elements
            if show_numbers and role in ('InlineMath', 'DisplayMath', 'Section'):
                center = fitz.Point(x - 6, y + 4)
                page.draw_circle(center, 5, color=(1,1,1), fill=(1,1,1))
                page.draw_circle(center, 5, color=color, width=0.5)
                page.insert_text(fitz.Point(x - 9, y + 7), str(idx + 1), 
                               fontsize=6, color=color)
    
    doc.save(output_path)
    print(f"Saved annotated PDF to: {output_path}")
    
    # Statistics
    total_entries = sum(len(v) for v in by_page.values())
    roles_count = {}
    for entries_list in by_page.values():
        for e in entries_list:
            role = e.get('role', 'unknown')
            roles_count[role] = roles_count.get(role, 0) + 1
    
    print(f"\nAnnotation statistics:")
    print(f"  Total entries with coordinates: {total_entries}")
    for role, count in sorted(roles_count.items(), key=lambda x: -x[1])[:10]:
        print(f"  {role}: {count}")
    
    return output_path


def main():
    parser = argparse.ArgumentParser(description='Visualize LPSB annotations on PDF')
    parser.add_argument('pdf', help='Input PDF file')
    parser.add_argument('json', help='LPSB JSON annotations file')
    parser.add_argument('output', help='Output annotated PDF file')
    parser.add_argument('--max-pages', type=int, default=None,
                       help='Maximum pages to process')
    parser.add_argument('--no-legend', action='store_true',
                       help='Hide color legend')
    parser.add_argument('--no-numbers', action='store_true',
                       help='Hide reading order numbers')
    parser.add_argument('--to-png', action='store_true',
                       help='Also export pages as PNG images')
    
    args = parser.parse_args()
    
    output_pdf = visualize_annotations(
        args.pdf, args.json, args.output,
        max_pages=args.max_pages,
        show_legend=not args.no_legend,
        show_numbers=not args.no_numbers
    )
    
    if args.to_png:
        doc = fitz.open(output_pdf)
        output_dir = Path(output_pdf).parent
        for i in range(len(doc)):
            page = doc[i]
            mat = fitz.Matrix(2, 2)  # 2x zoom for clarity
            pix = page.get_pixmap(matrix=mat)
            png_path = output_dir / f"{Path(output_pdf).stem}_page{i+1}.png"
            pix.save(str(png_path))
            print(f"Exported: {png_path}")


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py visualize-annotations ...
