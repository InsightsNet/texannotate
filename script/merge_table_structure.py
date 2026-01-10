#!/usr/bin/env python3
"""
Merge table structure from LaTeXML with cell coordinates from PDF.

This is the main entry point for table cell-level alignment.
Combines:
- Semantic structure (thead/tbody/th/td) from LaTeXML HTML
- Cell bounding boxes from PDF (via pdfplumber)
"""

import json
from pathlib import Path
from typing import Optional

from extract_latexml_tables import extract_tables_from_file as extract_latexml
from extract_pdf_tables import extract_tables_from_pdf, match_tables_by_page_position


def merge_table_structure(
    html_path: Path,
    pdf_path: Path,
    lpsb_json_path: Path = None,
    output_path: Path = None
) -> list[dict]:
    """
    Merge LaTeXML table structure with PDF cell coordinates.
    
    Args:
        html_path: Path to LaTeXML HTML file
        pdf_path: Path to gold PDF file
        lpsb_json_path: Optional path to lpsb.json for Table IDs
        output_path: Optional path to write merged output
    
    Returns:
        List of merged table dicts with structure and bboxes
    """
    # Phase 1: Extract LaTeXML structure
    latexml_tables = extract_latexml(html_path)
    
    # Phase 2: Extract PDF cell bboxes
    pdf_tables = extract_tables_from_pdf(pdf_path)
    
    # Load lpsb.json for Table IDs if available
    lpsb_tables = None
    if lpsb_json_path and Path(lpsb_json_path).exists():
        try:
            lpsb_data = json.loads(Path(lpsb_json_path).read_text())
            lpsb_tables = [e for e in lpsb_data if e.get('role') == 'Table']
        except Exception:
            pass
    
    # Phase 3: Merge by position
    merged = match_tables_by_page_position(latexml_tables, pdf_tables, lpsb_tables)
    
    # Write output if requested
    if output_path:
        Path(output_path).write_text(
            json.dumps(merged, indent=2, ensure_ascii=False) + '\n',
            encoding='utf-8'
        )
    
    return merged


def main():
    """CLI entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Merge LaTeXML table structure with PDF cell coordinates'
    )
    parser.add_argument('html_file', help='Path to LaTeXML HTML file')
    parser.add_argument('pdf_file', help='Path to gold PDF file')
    parser.add_argument('--lpsb', help='Path to lpsb.json for Table IDs')
    parser.add_argument('--output', '-o', help='Output JSON file (default: stdout)')
    parser.add_argument('--pretty', '-p', action='store_true', help='Pretty-print JSON')
    
    args = parser.parse_args()
    
    merged = merge_table_structure(
        html_path=args.html_file,
        pdf_path=args.pdf_file,
        lpsb_json_path=args.lpsb,
    )
    
    indent = 2 if args.pretty else None
    output = json.dumps(merged, indent=indent, ensure_ascii=False)
    
    if args.output:
        Path(args.output).write_text(output + '\n', encoding='utf-8')
    else:
        print(output)


if __name__ == '__main__':
    main()
