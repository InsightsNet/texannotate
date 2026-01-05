#!/usr/bin/env python3
"""
LPSB JSON Merger
Merges .lpsb.json (structure from PDFLaTeX/LuaLaTeX) with .lpsb-math.json (math from LuaLaTeX)
Uses context-aware IDs (e.g., Sec-N-Math-M) to align math content across compilations.
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Optional

def load_json(filepath: Path) -> List[dict]:
    """Load JSON array from file with fault tolerance."""
    try:
        # Try importing solver's fault-tolerant loader
        import sys
        sys.path.insert(0, str(filepath.parent.parent if filepath.parent.name.startswith('arXiv') else filepath.parent))
        from solver import StructureTreeBuilder
        
        builder = StructureTreeBuilder(str(filepath))
        builder.load_events()
        return builder.events
    except ImportError:
        # Fallback to standard JSON load
        pass
    except Exception as e:
        print(f"Warning: Fault-tolerant load failed ({e}), trying standard JSON")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            if not isinstance(data, list):
                print(f"Warning: {filepath} is not a JSON array")
                return []
            return data
    except FileNotFoundError:
        print(f"Warning: {filepath} not found")
        return []
    except json.JSONDecodeError as e:
        print(f"Error parsing {filepath}: {e}")
        return []

def build_math_index(math_events: List[dict]) -> Dict[str, dict]:
    """
    Build index of math events by ID.
    Returns: {id: {mathml: ..., display: ...}}
    """
    index = {}
    for event in math_events:
        if event.get('role') != 'Math' or event.get('event') != 'start':
            continue
        
        event_id = event.get('id')
        if not event_id:
            continue
        
        index[event_id] = {
            'mathml': event.get('mathml', ''),
            'display': event.get('display', False)
        }
    
    return index

def merge_events(structure_events: List[dict], math_index: Dict[str, dict]) -> List[dict]:
    """
    Merge structure events with math data.
    For Math/InlineMath events with matching IDs, add mathml field.
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
        
        merged.append(merged_event)
    
    return merged

def merge_lpsb_files(structure_file: Path, math_file: Optional[Path] = None, output_file: Optional[Path] = None):
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
    
    print(f"Merging:")
    print(f"  Structure: {structure_file}")
    print(f"  Math:      {math_file}")
    print(f"  Output:    {output_file}")
    
    # Load files
    structure_events = load_json(structure_file)
    math_events = load_json(math_file)
    
    print(f"\nLoaded {len(structure_events)} structure events")
    print(f"Loaded {len(math_events)} math events")
    
    # Build math index
    math_index = build_math_index(math_events)
    print(f"Indexed {len(math_index)} unique math formulas")

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
        print("Usage: python3 merge_lpsb.py <structure.lpsb.json> [math.lpsb-math.json] [output.json]")
        print("\nExample:")
        print("  python3 merge_lpsb.py main.lpsb.json")
        print("  python3 merge_lpsb.py main.lpsb.json main.lpsb-math.json main.merged.json")
        sys.exit(1)
    
    structure_file = Path(sys.argv[1])
    math_file = Path(sys.argv[2]) if len(sys.argv) > 2 else None
    output_file = Path(sys.argv[3]) if len(sys.argv) > 3 else None
    
    merge_lpsb_files(structure_file, math_file, output_file)

if __name__ == '__main__':
    main()
