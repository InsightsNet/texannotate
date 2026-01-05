#!/usr/bin/env python3
"""
LPSB Structure Tree Builder v3.0
Converts LPSB JSON events into PDF/UA-compatible structure tree
"""

import json
import argparse
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, field


@dataclass
class StructNode:
    """Represents a node in the PDF structure tree"""
    role: str
    id: str = ""
    event_type: str = "container"  # start|end|single|container
    page: int = 0
    attributes: Dict[str, Any] = field(default_factory=dict)
    children: List['StructNode'] = field(default_factory=list)
    
    def to_dict(self) -> Dict:
        """Convert to dictionary for JSON export"""
        result = {
            "role": self.role,
        }
        if self.id:
            result["id"] = self.id
        if self.page:
            result["page"] = self.page
        if self.attributes:
            result["attributes"] = self.attributes
        if self.children:
            result["children"] = [child.to_dict() for child in self.children]
        return result


class StructureTreeBuilder:
    """Builds PDF/UA structure tree from LPSB JSON events"""
    
    def __init__(self, json_path: Path):
        self.json_path = json_path
        self.events: List[Dict] = []
        self.root: Optional[StructNode] = None
        
    def load_events(self):
        """Load JSON events from file with fault-tolerant parsing"""
        with open(self.json_path, 'r', encoding='utf-8') as f:
            raw_content = f.read()
        
        # Preprocess to fix common escape issues from \detokenize
        # The problem: \detokenize converts \cmd to literal backslash+cmd
        # In JSON, this needs to be \\cmd (double backslash)
        
        # Strategy: Replace single backslashes with double backslashes in JSON strings
        # but be careful not to break already-valid escapes like \n, \t, \"
        
        import re
        
        def fix_escapes_in_string(match):
            """Fix backslashes inside a JSON string"""
            content = match.group(1)
            
            # First, protect already-valid JSON escapes with a placeholder
            valid_escapes = {
                r'\\': '\x00',  # \\
                r'\"': '\x01',  # \"
                r'\/': '\x02',  # \/
                r'\b': '\x03',  # \b
                r'\f': '\x04',  # \f
                r'\n': '\x05',  # \n
                r'\r': '\x06',  # \r
                r'\t': '\x07',  # \t
            }
            
            for escape, placeholder in valid_escapes.items():
                content = content.replace(escape, placeholder)
            
            # Now replace remaining single backslashes with double
            content = content.replace('\\', '\\\\')
            
            # Restore the protected escapes
            for escape, placeholder in valid_escapes.items():
                content = content.replace(placeholder, escape)
            
            return f'"{content}"'
        
        # Apply to all JSON string values (between quotes, preceded by : or [)
        # Pattern: finds "..." that is a value (after : or [, or at start of object)
        fixed_content = re.sub(r'(?<=: )"([^"]*)"(?=[,}\]])', fix_escapes_in_string, raw_content)
        fixed_content = re.sub(r'(?<=\[)"([^"]*)"', fix_escapes_in_string, fixed_content)
        
        try:
            self.events = json.loads(fixed_content)
            print(f"Loaded {len(self.events)} events from {self.json_path}")
        except json.JSONDecodeError as e:
            print(f"Warning: JSON decode error even after preprocessing: {e}")
            print(f"Attempting line-by-line parsing...")
            # Fallback: try to parse line by line, skipping bad lines
            self.events = []
            for i, line in enumerate(fixed_content.split('\n'), 1):
                line = line.strip().rstrip(',')
                if line in ['[', ']', '']:
                    continue
                try:
                    obj = json.loads(line)
                    self.events.append(obj)
                except:
                    print(f"  Skipped line {i}: {line[:50]}...")
            print(f"Recovered {len(self.events)} events from partial parsing")
        
    def build_tree(self) -> StructNode:
        """Build structure tree from events"""
        root = StructNode(role="StructTreeRoot", id="root")
        stack = [root]
        
        for event in self.events:
            role = event.get('role')
            event_type = event.get('event', 'single')
            
            # Skip calibration and footer
            if role in ['Calibration', 'Footer']:
                continue
                
            if event_type == 'start':
                # Create new node and push to stack
                node = StructNode(
                    role=role,
                    id=event.get('id', ''),
                    page=event.get('page', 0),
                    event_type='container',
                    attributes={k: v for k, v in event.items() 
                               if k not in ['role', 'id', 'page', 'event', 'depth']}
                )
                stack[-1].children.append(node)
                stack.append(node)
                
            elif event_type == 'end':
                # Pop from stack
                if len(stack) > 1:
                    closed_node = stack.pop()
                    # Optionally validate that role matches
                    if closed_node.role != role:
                        print(f"Warning: Mismatched close - expected {closed_node.role}, got {role}")
                        
            else:
                # Single event (e.g., Reference, Lbl)
                node = StructNode(
                    role=role,
                    id=event.get('id', ''),
                    page=event.get('page', 0),
                    event_type='single',
                    attributes={k: v for k, v in event.items() 
                               if k not in ['role', 'id', 'page', 'event', 'depth']}
                )
                stack[-1].children.append(node)
        
        self.root = root
        return root
    
    def print_tree(self, node: Optional[StructNode] = None, indent: int = 0):
        """Print tree in human-readable format"""
        if node is None:
            node = self.root
            
        prefix = "  " * indent
        attrs_str = ""
        if node.attributes:
            # Show only key attributes
            key_attrs = {}
            if 'title' in node.attributes:
                key_attrs['title'] = node.attributes['title'][:40]
            if 'target' in node.attributes:
                key_attrs['target'] = node.attributes['target']
            if 'uri' in node.attributes:
                key_attrs['uri'] = node.attributes['uri'][:30]
            if key_attrs:
                attrs_str = f" {key_attrs}"
                
        print(f"{prefix}{node.role}{attrs_str}")
        for child in node.children:
            self.print_tree(child, indent + 1)
    
    def validate_roles(self) -> Dict[str, int]:
        """Count occurrences of each role"""
        role_counts = {}
        
        def count_roles(node: StructNode):
            role_counts[node.role] = role_counts.get(node.role, 0) + 1
            for child in node.children:
                count_roles(child)
        
        if self.root:
            count_roles(self.root)
        return role_counts
    
    def export_json(self, output_path: Path):
        """Export structure tree as JSON"""
        if not self.root:
            raise ValueError("Tree not built yet")
            
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.root.to_dict(), f, indent=2, ensure_ascii=False)
        print(f"Exported structure tree to {output_path}")
    
    def check_pdf_ua_compliance(self) -> List[str]:
        """Check for common PDF/UA issues"""
        issues = []
        role_counts = self.validate_roles()
        
        # Check for required roles
        required_roles = ['Document']
        for role in required_roles:
            if role not in role_counts:
                issues.append(f"Missing required role: {role}")
        
        # Check for headings without document
        if role_counts.get('H', 0) + role_counts.get('H2', 0) > 0:
            if 'Document' not in role_counts and 'Sect' not in role_counts:
                issues.append("Headings found but no Document or Sect container")
        
        # Check for list items outside lists
        # (This would require more complex tree traversal)
        
        return issues


def main():
    parser = argparse.ArgumentParser(
        description='LPSB Structure Tree Builder - Convert JSON events to PDF/UA structure tree'
    )
    parser.add_argument(
        'input',
        type=Path,
        help='Input LPSB JSON file (e.g., document.lpsb.json)'
    )
    parser.add_argument(
        '--output', '-o',
        type=Path,
        help='Output structure tree JSON file (default: input.structure.json)'
    )
    parser.add_argument(
        '--validate',
        action='store_true',
        help='Validate PDF/UA compliance'
    )
    parser.add_argument(
        '--print-tree',
        action='store_true',
        help='Print structure tree to console'
    )
    parser.add_argument(
        '--pdf',
        type=Path,
        help='PDF file for TD cell extraction (optional)'
    )
    parser.add_argument(
        '--extract-cells',
        action='store_true',
        help='Extract TD cells from PDF (requires --pdf)'
    )
    
    args = parser.parse_args()
    
    # Determine output path
    if args.output:
        output_path = args.output
    else:
        output_path = args.input.with_suffix('.structure.json')
    
    # Build tree
    builder = StructureTreeBuilder(args.input)
    builder.load_events()
    
    # Extract cells from PDF if requested
    if args.extract_cells:
        if not args.pdf:
            print("Error: --extract-cells requires --pdf argument")
            return
        try:
            from extract_cells import extract_table_cells_from_pdf
            print(f"\n=== Extracting TD cells from {args.pdf} ===")
            builder.events = extract_table_cells_from_pdf(str(args.pdf), builder.events)
            print(f"TD extraction complete")
        except ImportError:
            print("Error: pdfplumber not installed. Run: pip install -r requirements.txt")
            return
        except Exception as e:
            print(f"Warning: TD extraction failed: {e}")
    
    builder.build_tree()
    
    # Print statistics
    role_counts = builder.validate_roles()
    print(f"\n=== Structure Tree Statistics ===")
    print(f"Total nodes: {sum(role_counts.values())}")
    print(f"Unique roles: {len(role_counts)}")
    print(f"\n=== Role Distribution ===")
    for role in sorted(role_counts.keys()):
        print(f"{role:20} : {role_counts[role]}")
    
    # Validate if requested
    if args.validate:
        print(f"\n=== PDF/UA Compliance Check ===")
        issues = builder.check_pdf_ua_compliance()
        if issues:
            print("Issues found:")
            for issue in issues:
                print(f"  ⚠ {issue}")
        else:
            print("✓ No obvious compliance issues detected")
    
    # Print tree if requested
    if args.print_tree:
        print(f"\n=== Structure Tree ===")
        builder.print_tree()
    
    # Export
    builder.export_json(output_path)
    print(f"\n✓ Structure tree successfully built")


if __name__ == "__main__":
    main()
