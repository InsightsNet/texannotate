#!/usr/bin/env python3
"""
enrich_mcid.py - MCID-based enrichment for LPSB

Replaces the zsavepos-based enrich_positions.py with MCID-based structure detection.

Pipeline:
    1. Parse .aux file for MCID structure (element ID -> MCID mapping)
    2. Parse PDF for MCID bounding boxes
    3. Merge and generate final JSON output

Usage:
    python3 enrich_mcid.py input.aux input.pdf -o output.json
"""

import argparse
import json
import sys
from pathlib import Path

# Import the MCID parser
from parse_lpsb_mcid import parse_aux_file, extract_mcid_bboxes, TaggedElement, MCIDEntry


def merge_elements_with_bboxes(elements: list, bboxes: dict) -> list:
    """Merge element structure with MCID bounding boxes.
    
    For each element, find the bboxes for all its MCIDs and create
    a unified bbox per page.
    """
    enriched = []
    
    for elem in elements:
        entry = {
            "id": f"{elem.tag_type}-{elem.elem_id}",
            "role": elem.tag_type,
            "page": elem.start_page,
            "is_atom": elem.is_atom,
        }
        
        # Add parent info for nested elements
        if elem.parent_id is not None:
            entry["parent_id"] = elem.parent_id
        
        # Aggregate bboxes from all MCIDs
        page_bboxes = {}
        for mcid_entry in elem.mcids:
            mcid = mcid_entry.mcid
            page = mcid_entry.page
            
            if mcid in bboxes and page in bboxes[mcid]:
                bbox = bboxes[mcid][page]
                if page not in page_bboxes:
                    page_bboxes[page] = bbox
                else:
                    # Merge bboxes: expand to encompass both
                    existing = page_bboxes[page]
                    page_bboxes[page] = [
                        min(existing[0], bbox[0]),  # x0
                        min(existing[1], bbox[1]),  # y0
                        max(existing[2], bbox[2]),  # x1
                        max(existing[3], bbox[3]),  # y1
                    ]
        
        # Add bbox info to entry
        if page_bboxes:
            if len(page_bboxes) == 1:
                # Single page
                page = list(page_bboxes.keys())[0]
                bbox = page_bboxes[page]
                entry["x"] = bbox[0]
                entry["y"] = bbox[1]
                entry["width"] = bbox[2] - bbox[0]
                entry["height"] = bbox[3] - bbox[1]
            else:
                # Multi-page: store per-page bboxes
                entry["page_bboxes"] = page_bboxes
        
        # Track if element is cross-page
        if len(set(m.page for m in elem.mcids)) > 1:
            entry["cross_page"] = True
            entry["end_page"] = elem.end_page
        
        enriched.append(entry)
    
    return enriched


def main():
    parser = argparse.ArgumentParser(
        description="MCID-based enrichment for LPSB"
    )
    parser.add_argument("aux", help="Path to .aux file")
    parser.add_argument("pdf", help="Path to PDF file")
    parser.add_argument("-o", "--output", required=True, help="Output JSON path")
    parser.add_argument("-v", "--verbose", action="store_true")
    
    args = parser.parse_args()
    
    aux_path = Path(args.aux)
    pdf_path = Path(args.pdf)
    output_path = Path(args.output)
    
    if not aux_path.exists():
        print(f"Error: aux file not found: {aux_path}", file=sys.stderr)
        sys.exit(1)
    
    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}", file=sys.stderr)
        sys.exit(1)
    
    # Step 1: Parse aux file
    elements, summary = parse_aux_file(aux_path)
    if args.verbose:
        print(f"Parsed {len(elements)} elements from aux file")
    
    # Step 2: Extract MCID bboxes from PDF
    bboxes = extract_mcid_bboxes(pdf_path)
    if args.verbose:
        print(f"Extracted {len(bboxes)} MCID bboxes from PDF")
    
    # Step 3: Merge elements with bboxes
    enriched = merge_elements_with_bboxes(elements, bboxes)
    
    # NOTE: Header/footer filtering is done on LaTeX side via fancyhfinit
    # No Python-side filtering - all elements pass through
    
    # Generate output JSON (compatible with LPSB format)
    output = enriched
    
    # Write output
    with open(output_path, "w") as f:
        json.dump(output, f, indent=2)
    
    print(f"✓ Written {len(enriched)} elements to {output_path}")
    
    # Stats
    roles = {}
    for e in enriched:
        role = e.get("role", "Unknown")
        roles[role] = roles.get(role, 0) + 1
    
    if args.verbose:
        print("\nElement counts by role:")
        for role, count in sorted(roles.items()):
            print(f"  {role}: {count}")


if __name__ == "__main__":
    main()
