#!/usr/bin/env python3
"""
LPSB JSON Merger
Merges .lpsb.json (structure from PDFLaTeX/LuaLaTeX) with .lpsb-math.json (math from LuaLaTeX)
Optionally merges .lpsb-table.json (tables from LuaLaTeX table pass)
Uses context-aware IDs (e.g., Sec-N-Math-M) to align math content across compilations.
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Optional

def load_json(filepath: Path) -> List[dict]:
    """Load JSON array from file with fault tolerance."""
    # Note: Previously attempted to use solver.StructureTreeBuilder but it has issues
    # with certain JSON escape sequences. Using our own robust parser instead.
    
    # Try standard JSON load with auto-fix for missing closing bracket and escape sequences
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read().strip()
        
        # Auto-fix: if starts with [ but doesn't end with ], append it
        if content.startswith('[') and not content.rstrip().endswith(']'):
            content = content.rstrip().rstrip(',') + '\n]'
        
        # Fix LaTeX escape sequences before parsing
        content = _fix_latex_escapes(content)
        
        data = json.loads(content)
        if not isinstance(data, list):
            print(f"Warning: {filepath} is not a JSON array")
            return []
        return data
    except FileNotFoundError:
        print(f"Warning: {filepath} not found")
        return []
    except json.JSONDecodeError as e:
        print(f"Warning: JSON parse error in {filepath}: {e}, using line-by-line fallback")
        return _parse_json_lines(filepath)


def _fix_latex_escapes(content: str) -> str:
    """Fix invalid escape sequences from LaTeX detokenize output.
    
    LaTeX's \\detokenize{} outputs backslashes as-is, but JSON requires
    \\ to be escaped as \\\\. Common problematic sequences include:
    \\chi, \\Delta, \\alpha, etc.
    """
    import re
    # Find backslash followed by a letter (LaTeX command), not already escaped
    # and not a valid JSON escape (n, r, t, b, f, u, \\, /, ")
    valid_escapes = set('nrtbfu\\"/')
    result = []
    i = 0
    while i < len(content):
        if content[i] == '\\' and i + 1 < len(content):
            next_char = content[i + 1]
            # If next char is backslash, it's already escaped
            if next_char == '\\':
                result.append('\\\\')
                i += 2
            # If it's a valid JSON escape, keep as-is
            elif next_char in valid_escapes:
                result.append(content[i:i+2])
                i += 2
            # Otherwise, escape the backslash
            else:
                result.append('\\\\')
                i += 1
        else:
            result.append(content[i])
            i += 1
    return ''.join(result)


def _parse_json_lines(filepath: Path) -> List[dict]:
    """Parse JSON file line-by-line for maximum fault tolerance."""
    events = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line or line in ('[', ']'):
                    continue
                # Remove leading comma
                if line.startswith(','):
                    line = line[1:]
                # Remove trailing comma
                if line.endswith(','):
                    line = line[:-1]
                try:
                    event = json.loads(line)
                    if isinstance(event, dict):
                        events.append(event)
                except json.JSONDecodeError:
                    continue
    except Exception as e:
        print(f"Error in line-by-line parsing: {e}")
    return events


def build_math_index(math_events: List[dict]) -> Dict[str, dict]:
    """
    Build index of math events by ID.
    Returns: {id: {mathml: ..., display: ..., x: ..., y: ..., page: ..., width: ..., height: ..., depth: ...}}
    """
    index = {}
    for event in math_events:
        if event.get('role') != 'Math' or event.get('event') != 'start':
            continue
        
        event_id = event.get('id')
        if not event_id:
            continue
        
        # Copy all relevant fields including coordinates
        data = {
            'mathml': event.get('mathml', ''),
            'display': event.get('display', False)
        }
        # Add coordinate fields if present
        for key in ('x', 'y', 'page', 'width', 'height', 'depth'):
            if key in event:
                data[key] = event[key]
        
        index[event_id] = data
    
    return index


def build_table_index(table_events: List[dict]) -> Dict[str, List[dict]]:
    """
    Build index of table detail events by Table id.
    Returns: {Table-<n>: [events...]} where events are TR/TD starts/ends.
    If the table-pass emits a "container" field, we index by that container id.
    """
    idx: Dict[str, List[dict]] = {}
    current_table: Optional[str] = None
    depth = 0

    for ev in table_events:
        if ev.get("role") == "Table" and ev.get("event") == "start":
            if depth == 0:
                current_table = ev.get("container") or ev.get("id")
                if current_table:
                    idx.setdefault(current_table, [])
            depth += 1
            continue
        if ev.get("role") == "Table" and ev.get("event") == "end":
            depth -= 1
            if depth == 0:
                current_table = None
            continue
        if current_table:
            idx[current_table].append(ev)

    return idx


def merge_table_events(structure_events: List[dict], table_index: Dict[str, List[dict]]) -> List[dict]:
    """
    Inject TR/TD events under matching Table containers in the structure event stream.
    Strategy: when we see Table start with id=Table-N, insert corresponding table events right after it.
    """
    out: List[dict] = []
    for ev in structure_events:
        out.append(ev)
        if ev.get("role") == "Table" and ev.get("event") == "start":
            tid = ev.get("id")
            if tid and tid in table_index:
                for tev in table_index[tid]:
                    out.append(tev)
    return out

def merge_events(structure_events: List[dict], math_index: Dict[str, dict]) -> List[dict]:
    """
    Merge structure events with math data.
    For Math/InlineMath events with matching IDs, add mathml and coordinate fields.
    """
    merged = []
    
    for event in structure_events:
        merged_event = event.copy()
        
        # Check if this is a math event with a matchable ID
        role = event.get('role')
        event_id = event.get('id')
        
        if role in ['Math', 'InlineMath', 'Formula'] and event_id:
            # Try to find matching math data
            if event_id in math_index:
                math_data = math_index[event_id]
                merged_event['math_match'] = True
                merged_event['mathml'] = math_data['mathml']
                if 'display' in math_data:
                    merged_event['display'] = math_data['display']
                # Copy coordinate fields from lualatex math pass
                for key in ('x', 'y', 'page', 'width', 'height', 'depth'):
                    if key in math_data and key not in merged_event:
                        merged_event[key] = math_data[key]
        
        merged.append(merged_event)
    
    return merged

def merge_lpsb_files(structure_file: Path, math_file: Optional[Path] = None, output_file: Optional[Path] = None, table_file: Optional[Path] = None):
    """
    Merge LPSB structure and math JSON files.
    
    Args:
        structure_file: Path to .lpsb.json
        math_file: Path to .lpsb-math.json (optional, auto-detected if None)
        output_file: Output path (defaults to .lpsb.merged.json)
    """
    # Auto-detect math file if not provided
    if math_file is None:
        math_file = structure_file.with_suffix('.lpsb-math.json')
    
    # Auto-detect output file if not provided
    if output_file is None:
        output_file = structure_file.with_suffix('.lpsb.merged.json')

    # Auto-detect table file if not provided
    if table_file is None:
        table_file = structure_file.with_suffix('.lpsb-table.json')
    
    print(f"Merging:")
    print(f"  Structure: {structure_file}")
    print(f"  Math:      {math_file}")
    print(f"  Output:    {output_file}")
    
    # Load files
    structure_events = load_json(structure_file)
    math_events = load_json(math_file)
    table_events = load_json(table_file) if table_file else []
    
    print(f"\nLoaded {len(structure_events)} structure events")
    print(f"Loaded {len(math_events)} math events")
    
    # Build math index
    math_index = build_math_index(math_events)
    print(f"Indexed {len(math_index)} unique math formulas")

    table_index = build_table_index(table_events)
    if table_events:
        print(f"Loaded {len(table_events)} table events, indexed {len(table_index)} tables")

    # Report match stats independent of MathML availability
    matchable_roles = {'Math', 'InlineMath', 'Formula'}
    matched_events = 0
    matched_ids = set()
    for e in structure_events:
        eid = e.get('id')
        if eid and e.get('role') in matchable_roles and eid in math_index:
            matched_events += 1
            matched_ids.add(eid)
    print(f"Matched {matched_events} structure events ({len(matched_ids)} unique IDs)")
    
    # Merge
    merged_events = merge_events(structure_events, math_index)
    if table_index:
        merged_events = merge_table_events(merged_events, table_index)
    
    # Count enriched events
    matched_count = sum(1 for e in merged_events if e.get('math_match'))
    mathml_count = sum(1 for e in merged_events if e.get('math_match') and e.get('mathml'))
    print(f"Enriched {matched_count} events (MathML present in {mathml_count})")
    
    # Write output
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(merged_events, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Merged file written to {output_file}")
    print(f"  Total events: {len(merged_events)}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 merge_lpsb.py <structure.lpsb.json> [math.lpsb-math.json] [output.json] [table.lpsb-table.json]")
        print("\nExample:")
        print("  python3 merge_lpsb.py main.lpsb.json")
        print("  python3 merge_lpsb.py main.lpsb.json main.lpsb-math.json main.merged.json main.lpsb-table.json")
        sys.exit(1)
    
    structure_file = Path(sys.argv[1])
    math_file = Path(sys.argv[2]) if len(sys.argv) > 2 else None
    output_file = Path(sys.argv[3]) if len(sys.argv) > 3 else None
    table_file = Path(sys.argv[4]) if len(sys.argv) > 4 else None
    
    merge_lpsb_files(structure_file, math_file, output_file, table_file)

if __name__ == '__main__':
    main()
