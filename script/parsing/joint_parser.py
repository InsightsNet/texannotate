#!/usr/bin/env python3
"""
joint_parser.py - Correlate AUX, SyncTeX, and PDF data for alignment

This module combines:
1. AUX data: elem_id, tag_type, mcids, parent structure
2. SyncTeX data: source line → PDF positions
3. PDF data: MCID positions, text content

The goal is to identify and fix cross-page/cross-column discontinuities.
"""

from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Set

from .parse_lpsb_mcid import parse_aux_file, TaggedElement
from .parse_synctex import (
    parse_synctex, 
    SyncTeXData, 
    find_crosspage_lines, 
    find_crosscolumn_lines,
    sp_to_pdf_points
)


@dataclass
class AlignedElement:
    """An element with full alignment information."""
    elem_id: int
    tag_type: str
    mcids: List[int]
    parent_id: Optional[int]
    
    # Filled by SyncTeX correlation
    source_file: Optional[str] = None
    source_line: Optional[int] = None
    
    # PDF regions (may span multiple pages/columns)
    regions: List['PDFRegion'] = field(default_factory=list)
    
    # Flags
    is_crosspage: bool = False
    is_crosscolumn: bool = False


@dataclass
class PDFRegion:
    """A region in the PDF where content appears."""
    page: int
    x: float
    y: float
    width: float = 0
    height: float = 0
    column: int = 0  # 0=left/single, 1=right


def joint_parse(
    aux_path: Path,
    synctex_path: Path,
    pdf_path: Optional[Path] = None
) -> List[AlignedElement]:
    """
    Parse and correlate AUX, SyncTeX, and PDF data.
    
    Args:
        aux_path: Path to .aux file
        synctex_path: Path to .synctex.gz file
        pdf_path: Optional path to PDF (for additional MCID extraction)
        
    Returns:
        List of AlignedElements with full alignment info
    """
    # 1. Parse AUX → semantic structure
    elements, summary = parse_aux_file(aux_path)
    
    # 2. Parse SyncTeX → position data
    synctex_data = parse_synctex(synctex_path)
    
    # 3. Find discontinuities
    crosspage_lines = find_crosspage_lines(synctex_data)
    crosscolumn_lines = find_crosscolumn_lines(synctex_data)
    
    # 4. Build normalized path lookup for easier matching
    # Key: (basename, line) → list of full paths
    crosspage_by_basename: Dict[Tuple[str, int], List[int]] = {}
    for (fname, line), pages in crosspage_lines.items():
        basename = Path(fname).name
        key = (basename, line)
        crosspage_by_basename[key] = pages
    
    crosscolumn_by_basename: Dict[Tuple[str, int], List[Tuple[int, List[Tuple[float, float]]]]] = {}
    for (fname, line, pg), positions in crosscolumn_lines.items():
        basename = Path(fname).name
        key = (basename, line)
        if key not in crosscolumn_by_basename:
            crosscolumn_by_basename[key] = []
        crosscolumn_by_basename[key].append((pg, positions))
    
    # 5. Build source line index from SyncTeX
    position_to_source = build_position_to_source_index(synctex_data)
    
    # 6. Correlate elements with SyncTeX data
    aligned_elements = []
    
    for elem in elements:
        aligned = AlignedElement(
            elem_id=elem.elem_id,
            tag_type=elem.tag_type,
            mcids=[m.mcid for m in elem.mcids],
            parent_id=elem.parent_id,
        )
        
        # Try to find source location from first MCID position
        if elem.mcids:
            first_mcid = elem.mcids[0]
            page = first_mcid.page
            
            # Find matching SyncTeX records for this page
            matching_sources = find_source_for_element(
                elem, synctex_data, crosspage_lines, crosscolumn_lines
            )
            
            if matching_sources:
                aligned.source_file, aligned.source_line = matching_sources[0]
                basename = Path(aligned.source_file).name
                
                # Check if this source line is cross-page (using basename matching)
                key = (basename, aligned.source_line)
                if key in crosspage_by_basename:
                    aligned.is_crosspage = True
                    # Add regions for each page
                    for pg in crosspage_by_basename[key]:
                        aligned.regions.append(PDFRegion(page=pg, x=0, y=0))
                
                # Check if cross-column (using basename matching)
                if key in crosscolumn_by_basename:
                    aligned.is_crosscolumn = True
                    for pg, positions in crosscolumn_by_basename[key]:
                        for i, (x, y) in enumerate(positions):
                            aligned.regions.append(PDFRegion(
                                page=pg, x=x, y=y, column=i
                            ))
        
        aligned_elements.append(aligned)
    
    return aligned_elements



def build_position_to_source_index(
    data: SyncTeXData
) -> Dict[Tuple[int, int, int], Tuple[str, int]]:
    """
    Build index mapping (page, x_bucket, y_bucket) to (filename, line).
    
    Uses bucketed coordinates for fuzzy matching.
    """
    BUCKET_SIZE = 50  # PDF points
    
    index: Dict[Tuple[int, int, int], List[Tuple[str, int]]] = {}
    
    for rec in data.records:
        filename = data.files.get(rec.file_id, "")
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue
        
        x_pdf = sp_to_pdf_points(rec.x)
        y_pdf = sp_to_pdf_points(rec.y)
        
        key = (rec.page, int(x_pdf // BUCKET_SIZE), int(y_pdf // BUCKET_SIZE))
        if key not in index:
            index[key] = []
        index[key].append((filename, rec.line))
    
    # Return most common source for each bucket
    result = {}
    for key, sources in index.items():
        # Most frequent source
        from collections import Counter
        most_common = Counter(sources).most_common(1)
        if most_common:
            result[key] = most_common[0][0]
    
    return result


def find_source_for_element(
    elem: TaggedElement,
    synctex_data: SyncTeXData,
    crosspage_lines: Dict,
    crosscolumn_lines: Dict
) -> List[Tuple[str, int]]:
    """
    Find likely source file and line for an element.
    
    Strategy: Look at page numbers of MCIDs and find SyncTeX records
    for user source files on those pages.
    """
    results = []
    
    if not elem.mcids:
        return results
    
    # Get pages where this element appears
    pages = set(m.page for m in elem.mcids)
    
    # Find all source files/lines on those pages
    for rec in synctex_data.records:
        if rec.page not in pages:
            continue
        
        filename = synctex_data.files.get(rec.file_id, "")
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue
        if '.sty' in filename or '.cls' in filename:
            continue
        
        results.append((filename, rec.line))
    
    # Deduplicate and sort by frequency
    from collections import Counter
    counter = Counter(results)
    return [item for item, count in counter.most_common(10)]


def get_discontinuous_elements(aligned: List[AlignedElement]) -> Dict[str, List[AlignedElement]]:
    """
    Get elements that have layout discontinuities.
    
    Returns:
        Dict with 'crosspage' and 'crosscolumn' keys
    """
    return {
        'crosspage': [e for e in aligned if e.is_crosspage],
        'crosscolumn': [e for e in aligned if e.is_crosscolumn],
    }


def get_all_discontinuity_regions(synctex_path: Path) -> Dict[str, dict]:
    """
    Get all discontinuity regions directly from SyncTeX without element correlation.
    
    This is useful when precise element→source mapping is not available.
    Returns the raw SyncTeX discontinuity data.
    
    Args:
        synctex_path: Path to .synctex.gz file
        
    Returns:
        Dict with:
        - 'crosspage': dict mapping (file, line) → list of pages
        - 'crosscolumn': dict mapping (file, line, page) → list of column positions
        - 'summary': summary statistics
    """
    synctex_data = parse_synctex(synctex_path)
    crosspage = find_crosspage_lines(synctex_data)
    crosscolumn = find_crosscolumn_lines(synctex_data)
    
    # Simplify keys to basenames for easier use
    crosspage_simple = {}
    for (fname, line), pages in crosspage.items():
        key = (Path(fname).name, line)
        crosspage_simple[key] = pages
    
    crosscolumn_simple = {}
    for (fname, line, page), positions in crosscolumn.items():
        key = (Path(fname).name, line, page)
        crosscolumn_simple[key] = positions
    
    return {
        'crosspage': crosspage_simple,
        'crosscolumn': crosscolumn_simple,
        'summary': {
            'crosspage_lines': len(crosspage),
            'crosscolumn_lines': len(crosscolumn),
            'total_discontinuities': len(crosspage) + len(crosscolumn),
        }
    }


def main():
    """CLI for testing."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Joint AUX + SyncTeX parser')
    parser.add_argument('aux', type=Path, help='Path to .aux file')
    parser.add_argument('synctex', type=Path, help='Path to .synctex.gz file')
    parser.add_argument('-v', '--verbose', action='store_true')
    
    args = parser.parse_args()
    
    aligned = joint_parse(args.aux, args.synctex)
    
    disc = get_discontinuous_elements(aligned)
    
    print(f"Total elements: {len(aligned)}")
    print(f"Cross-page elements: {len(disc['crosspage'])}")
    print(f"Cross-column elements: {len(disc['crosscolumn'])}")
    
    if args.verbose:
        print("\nCross-page elements:")
        for elem in disc['crosspage'][:10]:
            print(f"  elem_id={elem.elem_id} [{elem.tag_type}] "
                  f"source={Path(elem.source_file or '').name}:{elem.source_line}")
    
    return 0


if __name__ == '__main__':
    exit(main() or 0)
