#!/usr/bin/env python3
"""
fix_split_headings.py - Post-processing to merge split section headings

PROBLEM:
LaTeX's @ssect internal formatting outputs content in stages. For starred
sections like section*{References}, the title text may be output AFTER
@ssect returns. This causes the H1 MCID to contain only spurious content
(like "6*" from section counter formatting), while the actual title text
("References") goes into a following P tag.

SOLUTION:
This script detects the pattern of split headings in the aux/JSON output:
1. H1 with only short/number content
2. Immediately followed by an empty or short P  
3. Then another P with the actual title text

It merges these into a single H1 element.

Usage:
    python fix_split_headings.py input.aux -o output.aux
    python fix_split_headings.py input.mcid.json -o output.mcid.json
"""

import argparse
import json
import re
from pathlib import Path
from typing import Dict, List, Tuple


_TAG_DATA_RE = re.compile(r'\\lpsb@tag@data\{(\d+)\}\{([^}]+)\}\{(\d+)\}\{(\d+)\}')
_MCID_CONT_RE = re.compile(r'\\lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}')
_TAG_END_RE = re.compile(r'\\lpsb@tag@end\{(\d+)\}\{(\d+)\}')


def _parse_aux_records(aux_path: Path) -> Tuple[List[Tuple[int, str, int, int]], Dict[int, List[Tuple[int, int]]]]:
    """
    Parse aux into:
      - ordered tag_data records: [(elem_id, tag_type, mcid, page), ...] in file order
      - continuation map: elem_id -> [(mcid, page), ...]
    """
    ordered: List[Tuple[int, str, int, int]] = []
    cont: Dict[int, List[Tuple[int, int]]] = {}
    content = aux_path.read_text(errors="replace")

    for m in _TAG_DATA_RE.finditer(content):
        elem_id = int(m.group(1))
        tag_type = m.group(2)
        mcid = int(m.group(3))
        page = int(m.group(4))
        ordered.append((elem_id, tag_type, mcid, page))

    for m in _MCID_CONT_RE.finditer(content):
        elem_id = int(m.group(1))
        mcid = int(m.group(2))
        page = int(m.group(3))
        cont.setdefault(elem_id, []).append((mcid, page))

    return ordered, cont


def _detect_split_headings_aux(ordered: List[Tuple[int, str, int, int]]) -> List[Tuple[int, int]]:
    """
    Detect split heading patterns in aux ordering.

    Conservative heuristic (avoids eating normal paragraphs):
      - heading element is H1/H2/H3 with primary MCID = N
      - within the next few tag_data records on the SAME page we see:
          P with MCID N+1  (often empty P from our section hook)
          P with MCID N+2 or N+3 (title text emitted late)
      - merge the later P into the heading
    """
    splits = []

    for i, (hid, htype, hmcid, hpage) in enumerate(ordered):
        if htype not in ("H1", "H2", "H3"):
            continue
        # Look ahead a small window.
        p1 = None  # (elem_id, mcid)
        p2 = None
        p_bib = None
        saw_bib = False
        for j in range(i + 1, min(i + 7, len(ordered))):
            eid, etype, emcid, epage = ordered[j]
            if epage != hpage:
                break
            # Hard stop: another heading starts. A split heading cannot jump across
            # a new heading, and treating later P as the title will corrupt structure.
            if etype in ("H1", "H2", "H3"):
                break
            if etype in ("BibList", "BibEntry"):
                saw_bib = True
                # If we already saw a close P, this is the bibliography heading split.
                if p_bib is not None:
                    break
                continue
            if etype != "P":
                continue
            d = emcid - hmcid
            if d == 1 and p1 is None:
                p1 = (eid, emcid)
            elif d in (2, 3):
                # Prefer the first match at +2, otherwise allow +3.
                p2 = (eid, emcid)
                if d == 2:
                    break
            # Bibliography special-case: H? followed by a single P, then BibList.
            if 0 < d <= 3 and p_bib is None:
                p_bib = (eid, emcid)

        # Case A: classic staged-heading split (requires both +1 and +2/+3)
        if p1 is not None and p2 is not None:
            splits.append((hid, p2[0]))
            continue

        # Case B: bibliography heading split: H? + P + BibList/BibEntry on same page.
        if saw_bib and p_bib is not None:
            splits.append((hid, p_bib[0]))
            continue
        
        # Case C (DISABLED):
        # A direct H1 + P merge when MCID diff=1 is too risky in real papers.
        # It can incorrectly promote the *first content paragraph* after a heading
        # into the heading itself (common in ICML/NeurIPS style files).
        #
        # Keep the aux-level fixer conservative: only merge when we see the
        # classic staged-heading pattern (requires both +1 and +2/+3), or the
        # bibliography-specific split.

    return splits


def merge_split_headings_json(json_path: Path, output_path: Path) -> int:
    """
    Merge split headings in the JSON output.
    
    Returns number of merges performed.
    """
    with open(json_path, 'r') as f:
        data = json.load(f)
    
    elements = {e['id']: e for e in data['elements']}
    splits = detect_split_headings(elements)
    
    merged_count = 0
    elements_to_remove = set()
    
    for h1_id, title_p_id in splits:
        h1 = elements[h1_id]
        title_p = elements[title_p_id]
        
        # Merge MCIDs from title_p into h1
        h1['mcids'].extend(title_p['mcids'])
        h1['end_page'] = max(h1.get('end_page', h1['start_page']), 
                            title_p.get('end_page', title_p['start_page']))
        
        # Mark for removal
        elements_to_remove.add(title_p_id)
        
        merged_count += 1
        print(f"  Merged: {h1['type']} elem {h1_id} (MCID {h1['mcids'][0]['mcid']}) + P elem {title_p_id} (MCID {title_p['mcids'][0]['mcid']})")
    
    # Remove merged elements
    data['elements'] = [e for e in data['elements'] if e['id'] not in elements_to_remove]
    
    # Update summary
    data['summary']['merged_headings'] = merged_count
    
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2)
    
    return merged_count


def merge_split_headings_aux(aux_path: Path, output_path: Path) -> int:
    r"""
    Merge split headings directly in the aux file by:
      - moving the title P's MCIDs into the heading via \lpsb@mcid@cont
      - removing the title P element records (\lpsb@tag@data/\lpsb@mcid@cont/\lpsb@tag@end)

    This is used by downstream StructTree building (which consumes aux).
    """
    ordered, cont = _parse_aux_records(aux_path)
    splits = _detect_split_headings_aux(ordered)
    if not splits:
        output_path.write_text(aux_path.read_text(errors="replace"))
        return 0

    # Build a quick lookup for primary mcid/page per elem_id.
    primary: Dict[int, Tuple[str, int, int]] = {}  # id -> (type, mcid, page)
    for eid, etype, emcid, epage in ordered:
        # keep first occurrence (should be unique)
        primary.setdefault(eid, (etype, emcid, epage))

    # We want to REMOVE the stub heading element (often "6*") from semantics.
    # Strategy:
    #   - drop the original heading element records (H1/H2/H3)
    #   - "promote" the title P element into that heading type by rewriting its tag_type
    # This removes the spurious stub from the logical structure without trying to
    # guess/modify the PDF content stream.
    promote: Dict[int, str] = {}  # pid -> heading type (H1/H2/H3)
    remove_ids = set()            # element IDs to delete entirely (stub headings)

    for hid, pid in splits:
        hinfo = primary.get(hid)
        if not hinfo:
            continue
        htype = hinfo[0]
        if htype not in ("H1", "H2", "H3"):
            continue
        promote[pid] = htype
        remove_ids.add(hid)

    # Rewrite aux: filter out removed heading elements; rewrite promoted P -> Hn.
    lines = aux_path.read_text(errors="replace").splitlines(keepends=True)
    out_lines: List[str] = []
    for ln in lines:
        m = _TAG_DATA_RE.search(ln)
        if m:
            eid = int(m.group(1))
            if eid in remove_ids:
                continue
            if eid in promote:
                # Rewrite tag type in-place.
                # \lpsb@tag@data{eid}{TYPE}{mcid}{page}
                new_type = promote[eid]
                ln = re.sub(r'(\\lpsb@tag@data\{\d+\}\{)([^}]+)(\}\{\d+\}\{\d+\})',
                            r'\g<1>' + new_type + r'\g<3>', ln, count=1)
        m = _MCID_CONT_RE.search(ln)
        if m and int(m.group(1)) in remove_ids:
            continue
        m = _TAG_END_RE.search(ln)
        if m and int(m.group(1)) in remove_ids:
            continue
        out_lines.append(ln)

    out_lines.append("\n% --- LPSB: merged split headings ---\n")
    out_lines.append(f"% Promoted {len(promote)} title P elements into headings; dropped {len(remove_ids)} stub headings.\n")

    output_path.write_text("".join(out_lines))
    return len(splits)


def main():
    parser = argparse.ArgumentParser(
        description='Merge split section headings in LPSB output')
    parser.add_argument('input', type=Path, help='Input file (aux or json)')
    parser.add_argument('-o', '--output', type=Path, help='Output file')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    
    args = parser.parse_args()
    
    if not args.input.exists():
        print(f"Error: {args.input} not found")
        return 1
    
    output = args.output or args.input.with_suffix(args.input.suffix + '.fixed')

    if args.input.suffix == '.json':
        if args.verbose:
            print(f"Processing JSON: {args.input}")
        count = merge_split_headings_json(args.input, output)
        if args.verbose:
            print(f"✓ Merged {count} split headings -> {output}")
        return 0

    in_name = args.input.name
    is_aux_like = (args.input.suffix == '.aux') or in_name.endswith('.aux.fixed') or ('.aux.' in in_name)
    if is_aux_like:
        if args.verbose:
            print(f"Processing AUX: {args.input}")
        count = merge_split_headings_aux(args.input, output)
        if args.verbose:
            print(f"✓ Merged {count} split headings -> {output}")
        return 0

    print("Error: Unsupported file type. Use .aux or .json")
    return 1
    

# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py fix-split-headings ...
