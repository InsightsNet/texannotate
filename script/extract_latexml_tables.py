#!/usr/bin/env python3
"""
Extract table structure from LaTeXML HTML output.

Parses LaTeXML-generated HTML to extract semantic table structure including:
- thead/tbody separation
- th/td cell types with scope (col/row)
- Cell content text
- Row/column indices for alignment with PDF coordinates
"""

import re
import json
from pathlib import Path
from html.parser import HTMLParser
from typing import Optional


class TableCell:
    """Represents a table cell (th or td)."""
    
    def __init__(self, tag: str, attrs: dict):
        self.tag = tag  # 'th' or 'td'
        self.attrs = attrs
        self.text = ""
        self.colspan = int(attrs.get('colspan', 1))
        self.rowspan = int(attrs.get('rowspan', 1))
        
        # Determine scope from LaTeXML classes
        classes = attrs.get('class', '')
        if 'ltx_th_column' in classes:
            self.scope = 'col'
        elif 'ltx_th_row' in classes:
            self.scope = 'row'
        else:
            self.scope = None
    
    def to_dict(self) -> dict:
        result = {
            'type': self.tag,
            'text': self.text.strip(),
        }
        if self.scope:
            result['scope'] = self.scope
        if self.colspan > 1:
            result['colspan'] = self.colspan
        if self.rowspan > 1:
            result['rowspan'] = self.rowspan
        return result


class TableRow:
    """Represents a table row."""
    
    def __init__(self):
        self.cells: list[TableCell] = []
    
    def to_dict(self) -> dict:
        return {
            'cells': [c.to_dict() for c in self.cells]
        }


class TableSection:
    """Represents thead or tbody."""
    
    def __init__(self, section_type: str):
        self.section_type = section_type  # 'thead' or 'tbody'
        self.rows: list[TableRow] = []
    
    def to_dict(self) -> dict:
        return {
            'rows': [r.to_dict() for r in self.rows]
        }


class Table:
    """Represents a complete table."""
    
    def __init__(self, table_id: str = None):
        self.table_id = table_id
        self.thead: Optional[TableSection] = None
        self.tbody: Optional[TableSection] = None
        self.caption: str = ""
    
    def to_dict(self) -> dict:
        result = {}
        if self.table_id:
            result['id'] = self.table_id
        if self.caption:
            result['caption'] = self.caption
        if self.thead and self.thead.rows:
            result['thead'] = self.thead.to_dict()
        if self.tbody and self.tbody.rows:
            result['tbody'] = self.tbody.to_dict()
        return result


class LaTeXMLTableParser(HTMLParser):
    """Parser for LaTeXML HTML table output."""
    
    def __init__(self):
        super().__init__()
        self.tables: list[Table] = []
        self.current_table: Optional[Table] = None
        self.current_section: Optional[TableSection] = None
        self.current_row: Optional[TableRow] = None
        self.current_cell: Optional[TableCell] = None
        self.in_caption = False
        self.table_counter = 0
        
        # Track element stack for nested handling
        self.element_stack: list[str] = []
    
    def handle_starttag(self, tag: str, attrs: list):
        attrs_dict = dict(attrs)
        self.element_stack.append(tag)
        
        if tag == 'table':
            self.table_counter += 1
            table_id = attrs_dict.get('id', f'Table-{self.table_counter}')
            self.current_table = Table(table_id)
            
        elif tag == 'thead' and self.current_table:
            self.current_section = TableSection('thead')
            self.current_table.thead = self.current_section
            
        elif tag == 'tbody' and self.current_table:
            self.current_section = TableSection('tbody')
            self.current_table.tbody = self.current_section
            
        elif tag == 'tr' and self.current_section:
            self.current_row = TableRow()
            
        elif tag in ('th', 'td') and self.current_row:
            self.current_cell = TableCell(tag, attrs_dict)
            
        elif tag == 'figcaption' or (tag == 'span' and 'ltx_caption' in attrs_dict.get('class', '')):
            self.in_caption = True
    
    def handle_endtag(self, tag: str):
        if self.element_stack and self.element_stack[-1] == tag:
            self.element_stack.pop()
        
        if tag == 'table' and self.current_table:
            # If no explicit thead/tbody, treat all rows as tbody
            if not self.current_table.thead and not self.current_table.tbody:
                pass  # Table might be empty or malformed
            self.tables.append(self.current_table)
            self.current_table = None
            self.current_section = None
            
        elif tag in ('thead', 'tbody'):
            self.current_section = None
            
        elif tag == 'tr' and self.current_row and self.current_section:
            self.current_section.rows.append(self.current_row)
            self.current_row = None
            
        elif tag in ('th', 'td') and self.current_cell and self.current_row:
            self.current_row.cells.append(self.current_cell)
            self.current_cell = None
            
        elif tag in ('figcaption', 'span') and self.in_caption:
            self.in_caption = False
    
    def handle_data(self, data: str):
        if self.current_cell:
            self.current_cell.text += data
        elif self.in_caption and self.current_table:
            self.current_table.caption += data


def extract_tables_from_html(html_content: str) -> list[dict]:
    """
    Extract table structures from LaTeXML HTML.
    
    Args:
        html_content: HTML string from LaTeXML output
        
    Returns:
        List of table dictionaries with structure info
    """
    parser = LaTeXMLTableParser()
    parser.feed(html_content)
    return [t.to_dict() for t in parser.tables]


def extract_tables_from_file(html_path: Path) -> list[dict]:
    """
    Extract table structures from a LaTeXML HTML file.
    
    Args:
        html_path: Path to LaTeXML HTML file
        
    Returns:
        List of table dictionaries with structure info
    """
    html_content = Path(html_path).read_text(encoding='utf-8', errors='replace')
    return extract_tables_from_html(html_content)


def main():
    """CLI entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract table structure from LaTeXML HTML')
    parser.add_argument('html_file', help='Path to LaTeXML HTML file')
    parser.add_argument('--output', '-o', help='Output JSON file (default: stdout)')
    parser.add_argument('--pretty', '-p', action='store_true', help='Pretty-print JSON')
    
    args = parser.parse_args()
    
    tables = extract_tables_from_file(args.html_file)
    
    indent = 2 if args.pretty else None
    output = json.dumps(tables, indent=indent, ensure_ascii=False)
    
    if args.output:
        Path(args.output).write_text(output + '\n', encoding='utf-8')
    else:
        print(output)


if __name__ == '__main__':
    main()
