#!/usr/bin/env python3
"""
extract_mcid_positions.py - Extract MCID marker positions from PDF content streams

PDF tagged content uses BDC/EMC operators:
  /P << /MCID 5 >> BDC   (begin marked content)
  ... text content ...
  EMC                    (end marked content)

This module extracts the position of each MCID marker by parsing the content stream
and tracking the current transformation matrix (CTM).
"""

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import fitz  # PyMuPDF


@dataclass
class MCIDPosition:
    """Position of an MCID marker in the PDF."""
    mcid: int
    tag_type: str  # e.g., 'P', 'H1', 'Span'
    page: int  # 1-indexed
    x: float  # PDF points
    y: float  # PDF points
    bbox: Optional[Tuple[float, float, float, float]] = None  # x0, y0, x1, y1


def extract_mcid_positions_pymupdf(pdf_path: Path) -> Dict[int, List[MCIDPosition]]:
    """
    Extract MCID positions using PyMuPDF.
    
    Uses the StructuredText API to get content regions by MCID.
    
    Args:
        pdf_path: Path to PDF file
        
    Returns:
        Dict mapping MCID to list of positions (may appear multiple times due to continuations)
    """
    result: Dict[int, List[MCIDPosition]] = {}
    
    doc = fitz.open(pdf_path)
    
    for page_num, page in enumerate(doc, start=1):
        # Get the page's structured text with details
        # Use dict mode to get detailed info including MCIDs
        text_dict = page.get_text("dict", flags=fitz.TEXT_PRESERVE_WHITESPACE)
        
        for block in text_dict.get("blocks", []):
            # Check if block has MCID info
            if block["type"] != 0:  # text block
                continue
            
            # Try to extract MCID from spans
            for line in block.get("lines", []):
                for span in line.get("spans", []):
                    # PyMuPDF may include MCID in span properties
                    # This depends on the PDF structure
                    bbox = span.get("bbox", (0, 0, 0, 0))
                    
                    # Note: PyMuPDF's dict mode doesn't directly expose MCIDs
                    # We need to use a different approach - parse content stream
    
    doc.close()
    
    # Fallback to content stream parsing
    return extract_mcid_from_content_stream(pdf_path)


def extract_mcid_from_content_stream(pdf_path: Path) -> Dict[int, List[MCIDPosition]]:
    """
    Extract MCID positions by parsing PDF content streams directly.
    
    This parses the raw content stream to find BDC operators with MCID.
    """  
    result: Dict[int, List[MCIDPosition]] = {}
    
    # Pattern to match BDC with MCID: /TagName << /MCID N >> BDC
    bdc_pattern = re.compile(
        r'/(\w+)\s*<<\s*/MCID\s+(\d+)\s*>>\s*BDC',
        re.IGNORECASE
    )
    
    doc = fitz.open(pdf_path)
    
    for page_num, page in enumerate(doc, start=1):
        # Get raw content stream
        try:
            # Get page contents
            xref = page.xref
            content_stream = ""
            
            # Try to get the content stream
            # This is a simplified approach - real PDFs may have multiple content streams
            for item in page.get_contents():
                content_bytes = doc.xref_stream(item)
                if content_bytes:
                    content_stream += content_bytes.decode('latin-1', errors='replace')
        except Exception as e:
            # Fallback: use get_text with rawdict
            continue
        
        # Find all BDC with MCID
        for match in bdc_pattern.finditer(content_stream):
            tag_type = match.group(1)
            mcid = int(match.group(2))
            
            # Get position context - look for Tm or Td operators before this BDC
            # This is a simplified approach
            pos_before = match.start()
            context = content_stream[max(0, pos_before - 500):pos_before]
            
            # Try to find the last position-setting operator
            x, y = estimate_position_from_context(context, page)
            
            pos = MCIDPosition(
                mcid=mcid,
                tag_type=tag_type,
                page=page_num,
                x=x,
                y=y
            )
            
            if mcid not in result:
                result[mcid] = []
            result[mcid].append(pos)
    
    doc.close()
    return result


def estimate_position_from_context(context: str, page) -> Tuple[float, float]:
    """
    Estimate the position from content stream context.
    
    Look for text matrix (Tm) or text positioning (Td) operators.
    """
    # Pattern for Tm: a b c d x y Tm
    tm_pattern = re.compile(
        r'([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+([\d.-]+)\s+Tm'
    )
    # Pattern for Td: x y Td
    td_pattern = re.compile(r'([\d.-]+)\s+([\d.-]+)\s+Td')
    
    x, y = 0.0, 0.0
    
    # Find last Tm
    for match in tm_pattern.finditer(context):
        x = float(match.group(5))
        y = float(match.group(6))
    
    # Find last Td (may be relative)
    for match in td_pattern.finditer(context):
        x = float(match.group(1))
        y = float(match.group(2))
    
    return x, y


def extract_mcid_text_blocks(pdf_path: Path) -> Dict[int, List[dict]]:
    """
    Extract text blocks with their MCIDs using PyMuPDF's structured extraction.
    
    This uses a different approach - iterate through the document's structure tree.
    """   
    doc = fitz.open(pdf_path)
    result: Dict[int, List[dict]] = {}
    
    for page_num, page in enumerate(doc, start=1):
        # Get text blocks with positions
        blocks = page.get_text("dict", flags=fitz.TEXT_PRESERVE_WHITESPACE)
        
        for block in blocks.get("blocks", []):
            if block["type"] != 0:  # text block only
                continue
            
            block_bbox = block.get("bbox", (0, 0, 0, 0))
            
            for line in block.get("lines", []):
                line_bbox = line.get("bbox", (0, 0, 0, 0))
                
                for span in line.get("spans", []):
                    span_bbox = span.get("bbox", (0, 0, 0, 0))
                    text = span.get("text", "")
                    
                    # Store for later correlation with SyncTeX
                    # Note: we'll match by position with SyncTeX data
    
    doc.close()
    return result


def get_text_positions_by_page(pdf_path: Path) -> Dict[int, List[dict]]:
    """
    Get all text positions organized by page.
    
    Returns:
        Dict mapping page number (1-indexed) to list of text spans with bbox
    """   
    doc = fitz.open(pdf_path)
    result: Dict[int, List[dict]] = {}
    
    for page_num, page in enumerate(doc, start=1):
        page_texts = []
        
        # Get detailed text extraction
        text_dict = page.get_text("dict", flags=fitz.TEXT_PRESERVE_WHITESPACE)
        
        for block in text_dict.get("blocks", []):
            if block["type"] != 0:
                continue
            
            for line in block.get("lines", []):
                for span in line.get("spans", []):
                    page_texts.append({
                        'text': span.get('text', ''),
                        'bbox': span.get('bbox', (0, 0, 0, 0)),
                        'font': span.get('font', ''),
                        'size': span.get('size', 0),
                    })
        
        result[page_num] = page_texts
    
    doc.close()
    return result


def main():
    """CLI for testing."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract MCID positions from PDF')
    parser.add_argument('pdf', type=Path, help='Path to PDF file')
    parser.add_argument('-v', '--verbose', action='store_true')
    
    args = parser.parse_args()
    
    if not args.pdf.exists():
        print(f"Error: {args.pdf} not found")
        return 1
    
    result = extract_mcid_from_content_stream(args.pdf)
    
    print(f"Found {len(result)} unique MCIDs")
    
    if args.verbose:
        for mcid, positions in sorted(result.items())[:20]:
            print(f"  MCID {mcid}:")
            for pos in positions:
                print(f"    Page {pos.page}: ({pos.x:.1f}, {pos.y:.1f}) [{pos.tag_type}]")
    
    return 0


if __name__ == '__main__':
    exit(main() or 0)
