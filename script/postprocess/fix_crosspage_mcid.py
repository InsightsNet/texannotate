#!/usr/bin/env python3
"""
fix_crosspage_mcid.py - SyncTeX-based cross-page/cross-column MCID fixing

This script uses SyncTeX data to precisely identify where content spans pages
or columns, then injects appropriate BDC markers with dynamically allocated MCIDs.

Key improvements over heuristic approach:
1. SyncTeX knows exactly which source lines appear on multiple pages/columns
2. No guessing based on PDF content stream scanning
3. Dynamic MCID allocation - no dependency on LaTeX pre-allocation
"""

import fitz
import re
import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Tuple, Optional, Set

from ..parsing.parse_synctex import (
    parse_synctex,
    find_crosspage_lines,
    find_crosscolumn_lines,
    sp_to_pdf_points,
    SyncTeXData,
)
from ..parsing.parse_lpsb_mcid import parse_aux_file

# Tag types that represent floats (should not receive cross-page continuation)
FLOAT_TAG_TYPES = {'Figure', 'Table', 'Algorithm'}


# =============================================================================
# MCID Allocator
# =============================================================================

class MCIDAllocator:
    """Dynamically allocate MCIDs for injected tags.

    Strategy: Start from a high base (e.g., 10000) to avoid collision
    with LaTeX-assigned MCIDs (which typically start from 0).
    """

    def __init__(self, base: int = 10000):
        self._next = base
        self._used: Set[int] = set()

    def set_used(self, mcids: Set[int]):
        """Mark MCIDs as already used (from PDF scan)."""
        self._used = mcids
        # Ensure our base doesn't collide
        if mcids:
            self._next = max(max(mcids) + 1, self._next)

    def allocate(self) -> int:
        """Allocate next available MCID."""
        while self._next in self._used:
            self._next += 1
        mcid = self._next
        self._used.add(mcid)
        self._next += 1
        return mcid


# =============================================================================
# SyncTeX Discontinuity Detection
# =============================================================================

def get_synctex_discontinuities(synctex_path: Path) -> Dict[str, Dict]:
    """Analyze SyncTeX data for cross-page and cross-column discontinuities.

    Returns:
        Dict with:
        - 'crosspage': {(filename, line): [page1, page2, ...]}
        - 'crosscolumn': {(filename, line, page): [(x1,y1), (x2,y2), ...]}
        - 'crosspage_pages': set of pages where cross-page content continues
        - 'crosscolumn_pages': set of pages with cross-column content
    """
    data = parse_synctex(synctex_path)
    crosspage = find_crosspage_lines(data)
    crosscolumn = find_crosscolumn_lines(data)

    # Pages where cross-page content continues (all pages except first for each line)
    crosspage_pages = set()
    for pages in crosspage.values():
        for pg in pages[1:]:
            crosspage_pages.add(pg)

    # Pages with cross-column content
    crosscolumn_pages = set()
    for (fname, line, page), positions in crosscolumn.items():
        if len(positions) > 1:
            crosscolumn_pages.add(page)

    return {
        'crosspage': crosspage,
        'crosscolumn': crosscolumn,
        'crosspage_pages': crosspage_pages,
        'crosscolumn_pages': crosscolumn_pages,
        'synctex_data': data,
    }


def get_target_lines_for_page(
    discontinuities: Dict,
    page: int
) -> Set[Tuple[str, int]]:
    """Get (filename, line) pairs that have discontinuities on this page."""
    targets = set()

    # Cross-page: lines that continue onto this page
    for (fname, line), pages in discontinuities['crosspage'].items():
        if page in pages[1:]:  # Skip first page (where element starts)
            targets.add((fname, line))

    # Cross-column: lines that span columns on this page
    for (fname, line, pg), positions in discontinuities['crosscolumn'].items():
        if pg == page and len(positions) > 1:
            targets.add((fname, line))

    return targets


# =============================================================================
# PDF Content Stream Analysis
# =============================================================================

def extract_used_mcids(content_stream: bytes) -> Set[int]:
    """Extract all MCID values already present in a content stream."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    mcids = set()
    for m in re.finditer(r'/MCID\s*(\d+)', text):
        mcids.add(int(m.group(1)))
    return mcids


def parse_stream_markers(text: str) -> List[Tuple[int, int, str, Optional[str], Optional[int]]]:
    """Parse content stream markers.

    Returns list of (start, end, type, tag_type, mcid) tuples.
    """
    markers = []

    # BDC (Robust: matches both dict properties `<<...>>` and simple name/int properties `2` or `/Name`)
    # Note: `[^>]+` assumes no nested dicts, which covers standard MCID/LPSB usage.
    bdc_pattern = re.compile(r'/(\w+)\s+(?:<<[^>]+>>|[\w\d]+)\s*BDC')
    for m in bdc_pattern.finditer(text):
        tag = m.group(1)
        # Try to find MCID in the match
        mcid = None
        mcid_match = re.search(r'/MCID\s*(\d+)', m.group(0))
        if mcid_match:
            mcid = int(mcid_match.group(1))
        markers.append((m.start(), m.end(), 'BDC', tag, mcid))

    # Artifact BMC
    for m in re.finditer(r'/Artifact\s+BMC', text):
        markers.append((m.start(), m.end(), 'BMC', 'Artifact', None))

    # EMC
    for m in re.finditer(r'\bEMC\b', text):
        markers.append((m.start(), m.end(), 'EMC', None, None))

    # Text operations
    for m in re.finditer(r'\[[^\]]+\]TJ|\([^)]+\)Tj', text):
        markers.append((m.start(), m.end(), 'TEXT', None, None))

    markers.sort(key=lambda x: x[0])
    return markers


def find_untagged_text_regions(text: str) -> List[Tuple[int, int]]:
    """Find regions of untagged text (TEXT at nesting level 0).

    Returns list of (start_pos, end_pos) for each untagged run.
    """
    markers = parse_stream_markers(text)

    level = 0
    untagged_regions = []
    current_run_start = None
    current_run_end = None

    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
            # End current untagged run
            if current_run_start is not None:
                untagged_regions.append((current_run_start, current_run_end))
                current_run_start = None
            level += 1
        elif mtype == 'EMC':
            if current_run_start is not None:
                untagged_regions.append((current_run_start, current_run_end))
                current_run_start = None
            level = max(0, level - 1)
        elif mtype == 'TEXT':
            if level == 0:
                # Untagged text
                if current_run_start is None:
                    current_run_start = start
                current_run_end = end

    # Handle run at end of stream
    if current_run_start is not None:
        untagged_regions.append((current_run_start, current_run_end))

    return untagged_regions


def generate_text_positions(text: str) -> List[Tuple[int, float, float, str]]:
    """Scan stream sequentially to track text matrix and return list of (start_pos, x, y, op_text) for all text ops.
    
    This replaces context-window regex which is fragile for long streams.
    """
    # Simple state machine for PDF text operators
    # We track CTM and Text Matrix (Tm)
    # Td/TD update Tm.
    # BT resets Tm.
    # cm updates CTM.
    # For SyncTeX matching, we mostly care about Tm * CTM (approximate).
    # Since we only need "approximate" line matching, tracking efficient Tm x,y is enough.
    
    ops = [] # (pos, x, y, op_text)
    
    # Regex for tokens - Robust for escaped chars
    token_pattern = re.compile(
        r'('
        r'BT|ET|'
        r'(?:[\d.\-]+\s+){6}Tm|'
        r'(?:[\d.\-]+\s+){2}T[dD]|'
        r'(?:[\d.\-]+\s+){6}cm|'
        r'\((?:[^)\\]|\\.)*\)Tj|'
        r'\[(?:[^\]\\]|\\.)*\]TJ'
        r')'
    )
    
    # Current State
    tm = [1, 0, 0, 1, 0, 0] # Text Matrix: a b c d e f
    tlm = [1, 0, 0, 1, 0, 0] # Text Line Matrix (captured at start of line)
    
    # We iterate tokens
    # No try-except: let it crash if regex fails so we know about it
    for m in token_pattern.finditer(text):
        token = m.group(0)
        pos = m.start()
        
        if token == 'BT':
            tm = [1, 0, 0, 1, 0, 0]
            tlm = list(tm)
        elif token.endswith('Tm'):
            # 1 0 0 1 x y Tm
            try:
                parts = [float(x) for x in token.split()[:-1]]
                if len(parts) == 6:
                    tm = parts
                    tlm = list(tm)
            except: pass
        elif token.endswith('Td') or token.endswith('TD'):
            # tx ty Td
            try:
                parts = [float(x) for x in token.split()[:-1]]
                if len(parts) == 2:
                    tx, ty = parts
                    # Approx update (assuming horizontal)
                    tlm[4] += tx * tlm[0] + ty * tlm[2]
                    tlm[5] += tx * tlm[1] + ty * tlm[3]
                    tm = list(tlm)
            except: pass
        elif token.endswith('Tj') or token.endswith('TJ'):
            # Text op
            # Save absolute position of 'e' and 'f' from Tm (x, y)
            x, y = tm[4], tm[5]
            ops.append((pos, x, y, token))
        
    return ops


def get_text_position_from_context(text: str, pos: int, context_window: int = 20000) -> Tuple[float, float]:
    """Extract text matrix position (x, y) from content stream context before pos.
    
    Legacy helper for inject_bdc logic.
    """
    context = text[max(0, pos - context_window):pos]

    x, y = 0.0, 0.0

    # Try Tm (text matrix)
    for m in re.finditer(r'([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+([\d.\-]+)\s+Tm', context):
        try:
            x = float(m.group(5))
            y = float(m.group(6))
        except:
            pass

    # Fallback: Td/TD
    if x == 0.0 and y == 0.0:
        for m in re.finditer(r'([\d.\-]+)\s+([\d.\-]+)\s+T[dD]', context):
            try:
                x = float(m.group(1))
                y = float(m.group(2))
            except:
                pass

    return x, y



# =============================================================================
# SyncTeX Position Matching
# =============================================================================

def match_position_to_source(
    synctex_data: SyncTeXData,
    page: int,
    x_pdf: float,
    y_pdf: float,
    page_height: float,
    tolerance: float = 25.0
) -> Optional[Tuple[str, int]]:
    """Match PDF position to source (filename, line) via SyncTeX.

    Tries both y and flipped-y for coordinate convention resilience.
    """
    # Build lookup for this page
    candidates = []
    for rec in synctex_data.records:
        if rec.page != page:
            continue
        filename = synctex_data.files.get(rec.file_id, '')
        if '/texmf-dist/' in filename or '/texlive/' in filename:
            continue

        sx = sp_to_pdf_points(rec.x)
        sy_bottom = sp_to_pdf_points(rec.y)
        sy_top = page_height - sy_bottom

        # Try both Y conventions
        for sy in [sy_top, sy_bottom]:
            dist = ((sx - x_pdf)**2 + (sy - y_pdf)**2)**0.5
            if dist <= tolerance:
                candidates.append((dist, filename, rec.line))

    if candidates:
        candidates.sort(key=lambda x: x[0])
        return (candidates[0][1], candidates[0][2])

    return None


# =============================================================================
# BDC Injection
# =============================================================================

def inject_bdc_for_untagged_regions(
    content_stream: bytes,
    page_num: int,
    page_height: float,
    synctex_data: SyncTeXData,
    target_lines: Set[Tuple[str, int]],
    allocator: MCIDAllocator,
    tag_type: str = 'P',
    line_to_tag_type: Optional[Dict[int, str]] = None,
    verbose: bool = False
) -> Tuple[bytes, int, List[Dict]]:
    """Inject BDC/EMC pairs for untagged text regions that match SyncTeX targets.

    Returns (new_stream, injection_count)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    # Find untagged regions
    untagged = find_untagged_text_regions(text)
    if not untagged:
        return content_stream, 0, []

    # For each untagged region, check if it matches a target source line
    injections = []  # (bdc_pos, emc_pos, source)

    for start_pos, end_pos in untagged:
        # Get text position from content stream
        x_pdf, y_pdf = get_text_position_from_context(text, start_pos)

        # Match to source line
        source = match_position_to_source(
            synctex_data, page_num, x_pdf, y_pdf, page_height
        )

        if source is None:
            continue

        # Check if this source line is in our targets
        # Normalize filename for comparison
        fname = Path(source[0]).name if source[0] else ''
        for target_fname, target_line in target_lines:
            target_base = Path(target_fname).name if target_fname else ''
            if target_base == fname and target_line == source[1]:
                injections.append((start_pos, end_pos, source))
                if verbose:
                    print(f"    Page {page_num}: matched untagged text at ({x_pdf:.0f}, {y_pdf:.0f}) to {fname}:{source[1]}")
                break

    if not injections:
        # No reliable SyncTeX match: skip injection to avoid corrupting text layer.
        return content_stream, 0, []

    insert_ops = []  # (pos, priority, text) - higher priority applied first at same pos

    # Helper to find preceding tag type
    def get_preceding_tag_type(text: str, pos: int) -> str:
        """Find the tag type of the immediately preceding closed tag (before pos).
        
        If no preceding BDC exists (e.g., at page start), look forward to infer
        from the dominant tag type on the page.
        """
        bdc_pattern = re.compile(r'/(\w+)\s*<<\s*/MCID\s*\d+\s*>>\s*BDC')
        
        # Look for preceding BDC
        search_region = text[:pos]
        last_bdc = None
        for m in bdc_pattern.finditer(search_region):
            last_bdc = m
        
        if last_bdc:
            preceding_tag = last_bdc.group(1)
            # If the preceding tag is a bibliography type, use it
            if preceding_tag in ('BibEntry', 'BibList', 'Reference'):
                return preceding_tag
            return tag_type  # Default for non-bib tags
        
        # No preceding BDC - this is likely a page-start cross-page situation
        # Look at subsequent tags on this page to infer the dominant type
        remaining = text[pos:]
        bib_count = 0
        other_count = 0
        
        for m in bdc_pattern.finditer(remaining):
            tag = m.group(1)
            if tag in ('BibEntry', 'BibList', 'Reference'):
                bib_count += 1
            elif tag == 'P':
                other_count += 1
            # Stop after checking first 10 tags
            if bib_count + other_count >= 10:
                break
        
        # If the page is dominated by bibliography tags, use BibEntry
        if bib_count > other_count and bib_count >= 3:
            return 'BibEntry'
        
        return tag_type  # Default to the provided tag_type

    injected_info: List[Dict] = []
    for bdc_pos, emc_pos, source in injections:
        mcid = allocator.allocate()

        # Infer tag type from source (SyncTeX-based) if available
        inferred_tag = tag_type  # Default
        if source:
            src_filename, src_line = source
            # Direct detection: .bbl files are bibliography, use BibEntry
            if src_filename and src_filename.endswith('.bbl'):
                inferred_tag = 'BibEntry'
            # Otherwise try line-based lookup from aux
            elif line_to_tag_type and src_line in line_to_tag_type:
                inferred_tag = line_to_tag_type[src_line]
        
        # Fallback: infer from page context if source lookup failed
        if inferred_tag == tag_type:
            inferred_tag = get_preceding_tag_type(text, bdc_pos)

        # Close tag right after the last TEXT op in this untagged run
        insert_ops.append((bdc_pos, 1, f'/{inferred_tag} << /MCID {mcid} >> BDC\n'))
        insert_ops.append((emc_pos, 0, ' EMC\n'))
        injected_info.append(
            {
                "mcid": mcid,
                "page": page_num,
                "source": source,  # (filename, line) or None
            }
        )

    # Apply insertions from end to start
    insert_ops.sort(key=lambda x: (x[0], x[1]), reverse=True)
    for pos, _, ins_text in insert_ops:
        text = text[:pos] + ins_text + text[pos:]

    return text.encode('latin-1'), len(injections), injected_info


def fix_orphan_emcs(content_stream: bytes, verbose: bool = False, preserve_leading: bool = True) -> Tuple[bytes, int]:
    """Remove orphan EMC markers that have no matching BDC.

    Args:
        content_stream: PDF content stream bytes
        verbose: Print debug info
        preserve_leading: If True, preserve EMC markers at the very beginning of the stream
                         (these may be closing cross-page tags from previous page)
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    markers = parse_stream_markers(text)

    level = 0
    orphans = []
    first_bdc_pos = None  # Track position of first BDC/BMC

    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
            if first_bdc_pos is None:
                first_bdc_pos = start
            level += 1
        elif mtype == 'EMC':
            if level > 0:
                level -= 1
            else:
                orphans.append((start, end))

    if not orphans:
        return content_stream, 0

    # Filter out leading EMCs if preserve_leading is True
    # "Leading" now means: Appears before the first "Content" BDC.
    # We ignore Artifacts/Headers etc when determining the "First Content BDC".
    # This prevents Header Artifacts from masking the valid closing EMC of a cross-page tag.
    
    first_content_pos = None
    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
             is_artifact = (tag == 'Artifact' or tag == 'Header' or tag == 'Footer')
             if not is_artifact:
                 if first_content_pos is None:
                     first_content_pos = start
                     break # Found first content tag
    
    if preserve_leading:
        if first_content_pos is not None:
             # Preserve orphans before the first content tag
             orphans = [(s, e) for s, e in orphans if s > first_content_pos]
        else:
             # No content tags on page? Preserve ALL orphans if they might be closing prev page tags?
             # Or remove if truly empty page? 
             # Safer: If no content BDC, these might be trailing EMCs from specific layout.
             # If we have orphans but no content BDC, likely result of blank page or full-page artifact.
             # Let's preserve them to be safe against breaking cross-page flows.
             orphans = [] 

    if not orphans:
        return content_stream, 0

    # Remove from end to start
    orphans.sort(reverse=True)
    for start, end in orphans:
        text = text[:start] + ' ' * (end - start) + text[end:]

    if verbose:
        print(f"  Removed {len(orphans)} orphan EMC markers")

    return text.encode('latin-1'), len(orphans)


def inject_balance_at_end(content_stream: bytes, verbose: bool = False) -> Tuple[bytes, int]:
    """Inject missing EMCs at the end of the stream to ensure BDC/EMC balance.
    
    If a page ends with more BDCs than EMCs, it means tags are left open (e.g., cross-page).
    To ensure the page is valid and text is selectable, we explicitly close them.
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
        
    bdc_count = len(re.findall(r'BDC\b', text))
    bmc_count = len(re.findall(r'BMC\b', text))
    emc_count = len(re.findall(r'EMC\b', text))
    
    balance = (bdc_count + bmc_count) - emc_count
    
    if balance > 0:
        # Need to inject EMCs
        injection = '\n' + ('EMC\n' * balance)
        if verbose:
            print(f"  Injecting {balance} EMCs at end of stream to balance page")
        text += injection
        return text.encode('latin-1'), balance
        
    return content_stream, 0


def fix_empty_artifact_nesting(content_stream: bytes, verbose: bool = False) -> Tuple[bytes, int]:
    """Remove empty /Artifact BMC ... EMC pairs that break pdfplumber MCID tracking.

    Problem pattern:
        /P << /MCID 69>> BDC
        0 g 0 G
         /Artifact BMC    <- Empty nested Artifact
         EMC              <- This EMC confuses pdfplumber's MCID context
        0 g 0 G
        BT
        [(text)...]TJ     <- Text loses MCID association

    Solution: Remove empty /Artifact BMC ... EMC pairs (those with no text content between them).
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    # Pattern: /Artifact BMC followed by EMC with only whitespace/graphics state between
    # Graphics state commands: g, G, rg, RG, k, K, etc. (color/state)
    empty_artifact_pattern = re.compile(
        r'(/Artifact\s+BMC\s*\n?'           # /Artifact BMC
        r'(?:\s*[\d.]+\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+[kK]\s*\n?)*'  # Optional CMYK color
        r'(?:\s*[\d.]+\s+[\d.]+\s+[\d.]+\s+(?:rg|RG)\s*\n?)*'      # Optional RGB color
        r'(?:\s*[\d.]+\s+[gG]\s*\n?)*'      # Optional gray color
        r'\s*EMC\s*\n?)',                   # EMC with only whitespace
        re.MULTILINE
    )

    removed = 0
    new_text = text

    for match in reversed(list(empty_artifact_pattern.finditer(text))):
        # Replace with equivalent whitespace to preserve stream offsets
        start, end = match.start(), match.end()
        replacement = ' ' * (end - start)
        new_text = new_text[:start] + replacement + new_text[end:]
        removed += 1

    if removed > 0 and verbose:
        print(f"  Removed {removed} empty /Artifact BMC...EMC pairs")

    return new_text.encode('latin-1'), removed


def fix_empty_p_tags(content_stream: bytes, verbose: bool = False) -> Tuple[bytes, int]:
    """Fix empty P tags where BDC is immediately followed by EMC(s), but text content follows outside.

    Problem pattern (needs fix):
        /P << /MCID 366>> BDC
         EMC                      <- First premature EMC
        0 g 0 G
         EMC                      <- Second EMC (sometimes multiple)
        [(not)-194(break)...]TJ   <- Text falls outside tag

    Solution: Remove ALL premature EMCs between BDC and actual text content.
    """
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    # Pattern: /P << /MCID xxx>> BDC followed by one or more EMCs with only whitespace/graphics state
    # This handles both single EMC and multiple consecutive EMCs
    empty_p_pattern = re.compile(
        r'(/P\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC\s*\n?)'   # Group 1: /P << /MCID xxx>> BDC, Group 2: MCID number
        r'('                                             # Group 3: all the junk to remove
        r'(?:\s*EMC\s*\n?)*'                            # Zero or more EMCs
        r'(?:\s*\d+\s+g\s+\d+\s+G\s*\n?)?'              # Optional graphics state
        r'(?:\s*EMC\s*\n?)*'                            # Zero or more EMCs after graphics
        r'\s*)',                                        # Trailing whitespace
        re.MULTILINE
    )

    # Pattern to find next BDC (any tag type)
    next_bdc_pattern = re.compile(
        r'/(?:P|Figure|Table|Caption|H1|H2|Formula|Strong|InlineMath|L|LI|BibEntry|BibList|TitleArea|Title|Author|Artifact)\s*(?:<<\s*/MCID|BMC|BDC)',
        re.MULTILINE
    )

    fixed = 0
    new_text = text

    # Find all empty P tags and process in reverse
    matches = list(empty_p_pattern.finditer(text))

    for match in reversed(matches):
        bdc_part = match.group(1)     # /P << /MCID xxx>> BDC
        mcid = match.group(2)         # MCID number
        junk_part = match.group(3)    # EMCs + graphics state to potentially remove

        # Check if junk_part contains at least one EMC
        if not re.search(r'EMC\b', junk_part):
            continue

        match_start = match.start()
        match_end = match.end()

        # Look at content between this empty tag and next BDC
        remaining = new_text[match_end:]
        next_bdc_match = next_bdc_pattern.search(remaining)

        if next_bdc_match:
            between_content = remaining[:next_bdc_match.start()]
            next_bdc_pos = match_end + next_bdc_match.start()
        else:
            between_content = remaining
            next_bdc_pos = None

        # Check if there's actual text content (TJ/Tj operators) in between
        has_text_content = bool(re.search(r'\]TJ\b|\)Tj\b', between_content))

        if not has_text_content:
            # Truly empty tag - no text content after EMC before next BDC
            continue

        # There's text content after the premature EMC(s) - we need to fix this
        # Count EMCs in junk_part to know how many we're removing
        emc_count_removed = len(re.findall(r'EMC\b', junk_part))

        # Check if there's an EMC after the text content (before next BDC)
        emc_count_after = len(re.findall(r'EMC\b', between_content))

        if emc_count_after >= 1:
            # There's at least one closing EMC after text - remove all premature EMCs
            # Keep only the BDC and minimal whitespace
            replacement = bdc_part + '\n'
            new_text = new_text[:match_start] + replacement + new_text[match_end:]
            fixed += 1
        elif next_bdc_pos is not None:
            # No closing EMC exists - remove premature EMCs AND insert one before next BDC
            replacement = bdc_part + '\n'
            # Adjust next_bdc_pos for the change in length
            len_diff = len(match.group(0)) - len(replacement)
            adjusted_next_bdc_pos = next_bdc_pos - len_diff
            new_text = new_text[:match_start] + replacement + new_text[match_end:]
            new_text = new_text[:adjusted_next_bdc_pos] + 'EMC\n' + new_text[adjusted_next_bdc_pos:]
            fixed += 1

    if fixed > 0 and verbose:
        print(f"  Fixed {fixed} empty P tags (removed premature EMCs)")

    return new_text.encode('latin-1'), fixed

    for match in reversed(matches):
        bdc_part = match.group(1)     # /P << /MCID xxx>> BDC
        mcid = match.group(2)         # MCID number
        gs_part = match.group(3)      # graphics state + whitespace
        emc_part = match.group(4)     # EMC to potentially remove

        match_start = match.start()
        match_end = match.end()

        # Look at content between this premature EMC and next BDC
        remaining = new_text[match_end:]
        next_bdc_match = next_bdc_pattern.search(remaining)

        if next_bdc_match:
            between_content = remaining[:next_bdc_match.start()]
            next_bdc_pos = match_end + next_bdc_match.start()
        else:
            between_content = remaining
            next_bdc_pos = None

        # Check if there's actual text content (TJ/Tj operators) in between
        has_text_content = bool(re.search(r'\]TJ\b|\)Tj\b', between_content))

        if not has_text_content:
            # Truly empty tag - no text content after EMC before next BDC
            # Leave it alone
            continue

        # There's text content after the premature EMC - we need to fix this
        # Check if there's an EMC after the text content (before next BDC)
        has_closing_emc = bool(re.search(r'EMC\s*(?:\n\s*)?(?=/|$)', between_content))

        if has_closing_emc:
            # There's already a closing EMC after text - just remove the premature one
            replacement = bdc_part + gs_part
            padding = ' ' * len(emc_part)
            new_text = new_text[:match_start] + replacement + padding + new_text[match_end:]
            fixed += 1
        elif next_bdc_pos is not None:
            # No closing EMC exists - need to remove premature EMC AND insert one before next BDC
            # Step 1: Remove the premature EMC
            replacement = bdc_part + gs_part
            padding = ' ' * len(emc_part)
            new_text = new_text[:match_start] + replacement + padding + new_text[match_end:]
            # Step 2: Insert EMC before next BDC (position doesn't change since we used padding)
            new_text = new_text[:next_bdc_pos] + 'EMC\n' + new_text[next_bdc_pos:]
            fixed += 1

    if fixed > 0 and verbose:
        print(f"  Fixed {fixed} empty P tags (removed premature EMC, inserted closing EMC where needed)")

    return new_text.encode('latin-1'), fixed


def split_cross_column_tags(
    content_stream: bytes,
    boundary_x: float,
    allocator: MCIDAllocator,
    verbose: bool = False
) -> Tuple[bytes, int, List[Tuple[int, int]]]:
    """Split tags that span both columns at the column boundary."""
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')

    bdc_pattern = re.compile(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC')
    emc_pattern = re.compile(r'\bEMC\b')
    tm_pattern = re.compile(r'([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+Tm')

    bdc_matches = list(bdc_pattern.finditer(text))
    emc_matches = list(emc_pattern.finditer(text))

    if not bdc_matches:
        return content_stream, 0, []

    # Match BDCs with EMCs
    tag_regions = []
    for bdc in bdc_matches:
        tag_type = bdc.group(1)
        mcid = int(bdc.group(2))
        bdc_end = bdc.end()

        matching_emc = None
        for emc in emc_matches:
            if emc.start() > bdc_end:
                matching_emc = emc
                break

        if matching_emc:
            tag_regions.append({
                'type': tag_type,
                'mcid': mcid,
                'bdc_end': bdc_end,
                'emc_start': matching_emc.start(),
            })

    # Find tags that span both columns
    splits_needed = []
    for region in tag_regions:
        if region['type'] not in ('P', 'LI', 'L'):
            continue

        content = text[region['bdc_end']:region['emc_start']]
        tms = tm_pattern.findall(content)
        if not tms:
            continue

        x_positions = [float(tm[4]) for tm in tms]
        min_x, max_x = min(x_positions), max(x_positions)

        if min_x < boundary_x and max_x > boundary_x:
            # Find split position
            for tm in tm_pattern.finditer(content):
                x = float(tm.group(5))
                if x > boundary_x:
                    split_pos = region['bdc_end'] + tm.start()
                    splits_needed.append({
                        'region': region,
                        'split_pos': split_pos,
                    })
                    break

    if not splits_needed:
        return content_stream, 0, []

    # Apply splits from end to start
    splits_needed.sort(key=lambda x: x['split_pos'], reverse=True)

    split_info: List[Tuple[int, int]] = []
    for split in splits_needed:
        pos = split['split_pos']
        tag_type = split['region']['type']
        orig_mcid = int(split['region']['mcid'])
        new_mcid = allocator.allocate()
        injection = f'EMC\n/{tag_type} << /MCID {new_mcid} >> BDC\n'
        text = text[:pos] + injection + text[pos:]
        split_info.append((orig_mcid, new_mcid))

    if verbose:
        print(f"  Split {len(splits_needed)} cross-column tags")

    return text.encode('latin-1'), len(splits_needed), split_info


def split_tags_at_synctex_boundaries(
    content_stream: bytes,
    page_num: int,
    page_height: float,
    synctex_data: SyncTeXData,
    allocator: MCIDAllocator,
    line_threshold: int = 5,
    verbose: bool = False
) -> Tuple[bytes, int, List[Tuple[int, int]]]:
    """Split tags where SyncTeX source line jumps significantly (indicating leaked tag).
    
    Example: A Caption tag (line 332) leaks into Body text (line 388).
    We detect the jump and split: Close Caption -> Open P.
    """
    if verbose:
        print(f"  [SplitLogic] Checking Page {page_num} for leaked tags...")
    try:
        text = content_stream.decode('latin-1')
    except:
        text = content_stream.decode('utf-8', errors='replace')
        
    markers = parse_stream_markers(text)
    
    # Track tag regions: (start, end, type, tag_name, mcid)
    # We focus on Top-Level tags (Level 1), because leaked tags like Caption/Formula are usually top-level.
    level = 0
    current_tag_start = None
    current_tag_info = None # (name, mcid)
    
    regions_to_check = []
    
    for start, end, mtype, tag, mcid in markers:
        if mtype in ('BDC', 'BMC'):
            level += 1
            if level == 1:
                current_tag_start = end # content starts after BDC
                current_tag_info = (tag, mcid)
                
        elif mtype == 'EMC':
            if level == 1 and current_tag_start is not None:
                # Found a complete top-level tag region
                regions_to_check.append({
                    'start': current_tag_start,
                    'end': start,
                    'tag': current_tag_info[0],
                    'mcid': current_tag_info[1]
                })
                current_tag_start = None
                current_tag_info = None
            level = max(0, level - 1)
            
    if not regions_to_check:
        return content_stream, 0, []
        
    splits_needed = [] # (pos, old_mcid, new_mcid)
    
    # Pre-calculate all text positions statefully
    text_ops = generate_text_positions(text)
    
    # Map ops to regions
    # Optimize: Sort ops by pos (already sorted)
    # Sort regions by start (already sorted)
    
    current_region_idx = 0
    splits_needed = [] # (pos, old_mcid, new_mcid)
    
    # Flatten regions for matching
    # Helper to check if op is in region
    
    for op_pos, x, y, op_text in text_ops:
        # Find which region this op belongs to
        # Advance regions if needed
        while current_region_idx < len(regions_to_check):
            reg = regions_to_check[current_region_idx]
            if op_pos >= reg['end']:
                current_region_idx += 1
                continue
            break
            
        if current_region_idx >= len(regions_to_check):
            break
            
        region = regions_to_check[current_region_idx]
        if op_pos < region['start']:
            # Op is before current region (e.g. untagged text or ignored tag)
            continue
            
        # Op is inside region!
        tag_name = region['tag']
        # Skip tag types that shouldn't be split:
        # - P/L/LI: Normal content that's already flexible
        # - Artifact/Header/Footer: Decorative/structural content
        # - BibEntry/BibList/Reference: Bibliography entries often span multiple source lines
        if tag_name in ('P', 'L', 'LI', 'Artifact', 'Header', 'Footer', 'BibEntry', 'BibList', 'Reference'):
            continue
            
        # Check source
        source = match_position_to_source(synctex_data, page_num, x, y, page_height)
        
        if source:
            current_line = source[1]
            
            # Use 'first_line' from the region dict (store it there)
            if 'first_line' not in region:
                region['first_line'] = current_line
                if verbose and page_num == 6:
                     print(f"    [P6-Debug] Region {tag_name} starts at L{current_line} (Op: {op_text[:20]})")
            else:
                first_line = region['first_line']
                diff = abs(current_line - first_line)
                
                if verbose and page_num == 6 and diff > 0:
                     print(f"    [P6-Debug] Op '{op_text[:15]}' L{current_line} (Diff={diff})")

                if diff > line_threshold:
                    # LEAK DETECTED!
                    split_pos = op_pos
                    # Avoid splitting right at start
                    if split_pos - region['start'] < 10:
                        continue
                        
                    # Check if we already split this region? 
                    # If we split, we effectively close the old tag.
                    # We should prevent multiple splits for the same region close together.
                    # For simplicity, take the FIRST split and stop processing this region?
                    # Or continue? If we split, the rest is in New Tag.
                    # We should stop processing this region to avoid double splitting at every line.
                    splits_needed.append((split_pos, region['mcid'], tag_name))
                    if verbose:
                        print(f"    Page {page_num}: Detected leak in {tag_name} (L{first_line} -> L{current_line}). Split at {split_pos}")
                    
                    # Mark region as split so we don't split again
                    # Move to next region
                    current_region_idx += 1
                    
    if not splits_needed:
        return content_stream, 0, []
        
    # Apply splits (reverse order)
    splits_needed.sort(key=lambda x: x[0], reverse=True)
    
    split_info = []
    for pos, old_mcid, tag_type in splits_needed:
        new_mcid = allocator.allocate()
        # Preserve original tag type instead of defaulting to P
        injection = f' EMC\n/{tag_type} << /MCID {new_mcid} >> BDC\n'
        text = text[:pos] + injection + text[pos:]
        split_info.append((old_mcid, new_mcid))

    return text.encode('latin-1'), len(splits_needed), split_info


def detect_two_column_layout(doc, page_idx: int) -> bool:
    """Detect if a page uses two-column layout."""
    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2
    margin = width * 0.1

    blocks = page.get_text('dict')['blocks']
    text_x_positions = []

    for b in blocks:
        if 'lines' in b:
            text_x_positions.append(b['bbox'][0])

    if len(text_x_positions) < 4:
        return False

    left_count = sum(1 for x in text_x_positions if x < mid_x - margin)
    right_count = sum(1 for x in text_x_positions if x > mid_x + margin)

    return left_count >= 2 and right_count >= 2


def find_column_boundary(doc, page_idx: int) -> Optional[float]:
    """Find X coordinate dividing left and right columns."""
    if not detect_two_column_layout(doc, page_idx):
        return None

    page = doc[page_idx]
    width = page.rect.width
    mid_x = width / 2

    # Simple approach: use page center
    return mid_x


# =============================================================================
# Main Processing
# =============================================================================

def process_pdf_synctex(
    pdf_path: str,
    aux_path: str,
    synctex_path: str,
    output_path: Optional[str] = None,
    verbose: bool = True
) -> str:
    """Process PDF using SyncTeX for precise cross-page/cross-column fixing.

    Args:
        pdf_path: Input PDF path
        aux_path: AUX file path (updated with injected/split MCID continuations)
        synctex_path: SyncTeX file path
        output_path: Output PDF path (default: input_fixed.pdf)
        verbose: Print progress

    Returns:
        Output PDF path
    """
    pdf_p = Path(pdf_path)
    syn_p = Path(synctex_path)

    if output_path is None:
        output_path = str(pdf_p.with_name(pdf_p.stem + '_fixed.pdf'))

    if not pdf_p.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_p}")
    if not syn_p.exists():
        raise FileNotFoundError(f"SyncTeX not found: {syn_p}")

    # Analyze SyncTeX discontinuities
    disc = get_synctex_discontinuities(syn_p)
    synctex_data = disc['synctex_data']

    # Process all pages to ensure we catch leaked tags (intra-page) and balance issues
    # pages_to_process = disc['crosspage_pages'] | disc['crosscolumn_pages'] (OLD)
    
    doc = fitz.open(str(pdf_p))
    allocator = MCIDAllocator(base=10000)

    total_injections = 0
    total_splits = 0
    total_orphans = 0
    injected_records: List[Dict] = []
    split_records: List[Tuple[int, int, int]] = []  # (orig_mcid, new_mcid, page)

    # Build line_to_tag_type mapping from aux file for source-based tag type inference
    line_to_tag_type: Dict[int, str] = {}
    aux_elements, _ = parse_aux_file(Path(aux_path))
    for e in aux_elements:
        src_line = int(getattr(e, "source_line", 0) or 0)
        tag_type_val = getattr(e, "tag_type", "")
        if src_line > 0 and tag_type_val:
            # Prefer more specific types (e.g., BibEntry over P)
            if src_line not in line_to_tag_type or tag_type_val in ('BibEntry', 'BibList', 'Reference'):
                line_to_tag_type[src_line] = tag_type_val

    for page_num in range(1, len(doc) + 1):
        # Skip pages if we want optimization? 
        # But split logic and balance logic need to run everywhere.
        if page_num < 1 or page_num > len(doc):
             continue
             
        page = doc[page_num - 1]
        page_height = float(page.rect.height)

        # Get content stream
        xref = page.xref
        contents_ref = doc.xref_get_key(xref, "Contents")
        if contents_ref[0] != 'xref':
            continue
        contents_xref = int(contents_ref[1].split()[0])
        stream = doc.xref_stream(contents_xref)
        if not stream:
            continue

        # Update allocator with existing MCIDs
        allocator.set_used(extract_used_mcids(stream))

        # Phase 0a: Remove empty /Artifact BMC...EMC pairs that break pdfplumber MCID tracking
        stream, n_empty_artifacts = fix_empty_artifact_nesting(stream, verbose=verbose)

        # Phase 0b: Fix empty P tags where BDC is immediately followed by EMC
        stream, n_empty_p = fix_empty_p_tags(stream, verbose=verbose)

        # Phase 1: Fix orphan EMCs
        stream, n_orphans = fix_orphan_emcs(stream, verbose=False)
        total_orphans += n_orphans

        # Phase 1.5: Split tags that leak into subsequent text (SyncTeX detection)
        stream, n_splits_sync, split_sync_info = split_tags_at_synctex_boundaries(
            stream, page_num, page_height, synctex_data, allocator, verbose=verbose
        )
        if split_sync_info:
            split_records.extend([(old, new, page_num) for old, new in split_sync_info])
            
        # Phase 2: Get target lines for this page
        target_lines = get_target_lines_for_page(disc, page_num)

        # Phase 3: Inject BDC for untagged regions
        stream, n_inject, injected_info = inject_bdc_for_untagged_regions(
            stream, page_num, page_height,
            synctex_data, target_lines, allocator,
            tag_type='P', line_to_tag_type=line_to_tag_type, verbose=verbose
        )
        total_injections += n_inject
        if injected_info:
            injected_records.extend(injected_info)

        # Phase 4: Split cross-column tags
        if page_num in disc['crosscolumn_pages']:
            boundary = find_column_boundary(doc, page_num - 1)
            if boundary:
                stream, n_split, split_info = split_cross_column_tags(
                    stream, boundary, allocator, verbose=verbose
                )
                total_splits += n_split
                for orig_mcid, new_mcid in split_info:
                    split_records.append((orig_mcid, new_mcid, page_num))

        # Phase 5: Ensure page balance (inject closing EMCs if needed)
        # This fixes issues where cross-page tags leave open BDCs at end of page,
        # which can break text selection in some viewers.
        stream, n_balance = inject_balance_at_end(stream, verbose=verbose)

        # Update stream
        doc.update_stream(contents_xref, stream)

    doc.save(str(output_path))
    doc.close()

    # Update aux with injected/split MCIDs so StructTree can map them.
    try:
        elements, _summary = parse_aux_file(Path(aux_path))
        mcid_to_elem: Dict[int, int] = {}
        line_to_elem: Dict[int, List[int]] = {}
        elem_meta: Dict[int, Dict] = {}

        for e in elements:
            elem_id = int(e.elem_id)
            elem_meta[elem_id] = {
                "tag": getattr(e, "tag_type", ""),
                "start_page": int(getattr(e, "start_page", 0) or 0),
                "end_page": int(getattr(e, "end_page", 0) or 0),
                "is_atom": bool(getattr(e, "is_atom", False)),
                "source_line": int(getattr(e, "source_line", 0) or 0),
                "pages": {int(m.page) for m in getattr(e, "mcids", [])},
                "mcids": [(int(m.mcid), int(m.page)) for m in getattr(e, "mcids", [])],
            }
            for m in getattr(e, "mcids", []):
                mcid_to_elem[int(m.mcid)] = elem_id
            src_line = elem_meta[elem_id]["source_line"]
            if src_line > 0:
                line_to_elem.setdefault(src_line, []).append(elem_id)

        # Also parse existing @mcid@cont records to include continuation MCIDs
        import re
        aux_content = Path(aux_path).read_text(errors="replace")
        for match in re.finditer(r'lpsb@mcid@cont\{(\d+)\}\{(\d+)\}\{(\d+)\}', aux_content):
            eid, mcid, pg = int(match.group(1)), int(match.group(2)), int(match.group(3))
            mcid_to_elem[mcid] = eid
            if eid in elem_meta:
                elem_meta[eid]["pages"].add(pg)
                elem_meta[eid]["mcids"].append((mcid, pg))

        def pick_elem_for_line(line: int, page: int) -> Optional[int]:
            cands = line_to_elem.get(line, [])
            if not cands:
                return None
            # Prefer non-atom, non-float, and elements that started earlier.
            for eid in cands:
                meta = elem_meta.get(eid, {})
                if meta.get("is_atom"):
                    continue
                if meta.get("tag") in FLOAT_TAG_TYPES:
                    continue
                start_page = int(meta.get("start_page") or 0)
                if start_page > 0 and start_page <= page:
                    return eid
            # Fallback: first candidate
            return cands[0]

        aux_lines = Path(aux_path).read_text(errors="replace").splitlines(keepends=True)
        appended = 0
        existing = set()
        for e in elements:
            for m in getattr(e, "mcids", []):
                existing.add((int(e.elem_id), int(m.mcid), int(m.page)))

        for rec in injected_records:
            src = rec.get("source")
            if not src:
                continue
            _fname, line = src
            page = int(rec.get("page") or 0)
            mcid = int(rec.get("mcid"))
            eid = pick_elem_for_line(int(line), page)

            # Check if matched element is a P type (paragraph); if not, we need fallback
            matched_is_p = eid is not None and elem_meta.get(eid, {}).get("tag") == "P"

            # Fallback: if no P element found by line match and this is a cross-page continuation,
            # link to the last P element on the previous page
            if not matched_is_p and page > 1:
                prev_page = page - 1
                candidates = []
                for e_id, meta in elem_meta.items():
                    if meta.get("tag") != "P":
                        continue
                    if meta.get("is_atom"):
                        continue
                    mcids_on_page = [m for m, p in meta.get("mcids", []) if p == prev_page]
                    if mcids_on_page:
                        max_mcid = max(mcids_on_page)
                        candidates.append((e_id, max_mcid))
                if candidates:
                    candidates.sort(key=lambda x: x[1], reverse=True)
                    eid = candidates[0][0]

            if eid is None:
                if verbose:
                    print(f"[DEBUG] injected_records: mcid={mcid}, page={page}, eid=None, skipping")
                continue
            if (eid, mcid, page) in existing:
                if verbose:
                    print(f"[DEBUG] injected_records: ({eid}, {mcid}, {page}) already in existing")
                continue
            aux_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{mcid}}}{{{page}}}\n")
            existing.add((eid, mcid, page))
            appended += 1
            if verbose:
                print(f"[DEBUG] injected_records: Added ({eid}, {mcid}, {page}) to aux_lines")

        for orig_mcid, new_mcid, page in split_records:
            eid = mcid_to_elem.get(int(orig_mcid))
            if eid is None:
                continue
            if (eid, int(new_mcid), int(page)) in existing:
                continue
            aux_lines.append(f"\\lpsb@mcid@cont{{{eid}}}{{{int(new_mcid)}}}{{{int(page)}}}\n")
            existing.add((eid, int(new_mcid), int(page)))
            appended += 1

        # === NEW: Merge cross-page split paragraphs using SyncTeX ===
        # Instead of using unreliable lowercase detection, we use SyncTeX data
        # to identify source lines that span multiple pages.
        #
        # Strategy: Use synctex records to find source lines appearing on multiple pages.
        # MCIDs at the same source line should belong to the same logical element.
        merged = 0

        # Build page -> elements mapping
        page_to_elems: Dict[int, List[Tuple[int, Dict]]] = {}
        for eid, meta in elem_meta.items():
            for pg in meta.get("pages", set()):
                page_to_elems.setdefault(pg, []).append((eid, meta))

        # Use synctex to find cross-page lines
        crosspage_lines = find_crosspage_lines(synctex_data)

        # Build a mapping: (page, y_position) -> source line
        # This allows us to match PDF content positions to source lines
        page_line_records: Dict[int, List[Tuple[int, int, str, int]]] = {}  # page -> [(y, line, filename, file_id)]
        for rec in synctex_data.records:
            filename = synctex_data.files.get(rec.file_id, "")
            if '/texmf-dist/' in filename or '/texlive/' in filename:
                continue
            page_line_records.setdefault(rec.page, []).append((rec.y, rec.line, filename, rec.file_id))

        # For each page that has cross-page content, check MCIDs
        # Use output_path (fixed PDF) to see injected MCIDs
        doc_for_scan = fitz.open(str(output_path))
        crosspage_pages = disc.get('crosspage_pages', set())

        for page_num in sorted(crosspage_pages):
            if page_num < 2 or page_num > len(doc_for_scan):
                continue

            page = doc_for_scan[page_num - 1]
            xref = page.xref
            contents_ref = doc_for_scan.xref_get_key(xref, "Contents")
            if contents_ref[0] != 'xref':
                continue
            contents_xref = int(contents_ref[1].split()[0])
            stream = doc_for_scan.xref_stream(contents_xref)
            if not stream:
                continue
            try:
                text = stream.decode('latin-1')
            except:
                text = stream.decode('utf-8', errors='replace')

            # Find first P BDC and extract its MCID
            first_p_match = re.search(r'/P\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', text)
            if not first_p_match:
                continue
            first_mcid = int(first_p_match.group(1))

            # Check if this MCID is an injected one (>= 10000)
            is_injected_mcid = first_mcid >= 10000

            # Check if this page has synctex records matching cross-page lines
            page_records = page_line_records.get(page_num, [])
            is_crosspage = False
            matching_line = None

            for y, line, filename, file_id in page_records:
                key = (filename, line)
                if key in crosspage_lines:
                    pages_for_line = crosspage_lines[key]
                    # This line appears on multiple pages including current page
                    if page_num in pages_for_line and (page_num - 1) in pages_for_line:
                        is_crosspage = True
                        matching_line = (filename, line)
                        break

            # Fallback to lowercase detection if synctex doesn't have data
            if not is_crosspage:
                # Find the text content after this BDC (before next EMC or BDC)
                bdc_end = first_p_match.end()
                text_match = re.search(r'\[([^\]]+)\]TJ|\(([^)]+)\)Tj', text[bdc_end:bdc_end+500])
                if text_match:
                    text_content = text_match.group(1) or text_match.group(2)
                    char_match = re.search(r'\(([^)]+)\)', text_content)
                    if char_match:
                        first_text = char_match.group(1)
                        if first_text:
                            for ch in first_text:
                                if ch.isalpha():
                                    if ch.islower():
                                        is_crosspage = True
                                    break

            if not is_crosspage and not is_injected_mcid:
                continue

            # For injected MCIDs, always treat as crosspage continuation
            if is_injected_mcid:
                is_crosspage = True
                if verbose:
                    print(f"[DEBUG] Page {page_num}: Found injected MCID {first_mcid}, treating as crosspage")

            # This is a continuation! Find the owner element and the last P on prev page
            owner_eid = mcid_to_elem.get(first_mcid)
            # Note: owner_eid may be None if first_mcid was injected (not in aux file)
            # In that case, we still need to link it to the previous page's element
            if verbose:
                print(f"[DEBUG] Page {page_num}: owner_eid={owner_eid}, is_crosspage={is_crosspage}")

            prev_page = page_num - 1
            # Find the LAST P element on previous page
            # Use elem_meta.items() directly instead of page_to_elems to ensure we find all elements
            candidates = []
            for eid, meta in elem_meta.items():
                if meta.get("tag") != "P":
                    continue
                if meta.get("is_atom"):
                    continue
                # Get the highest MCID this element has on prev_page
                mcids_on_page = [m for m, p in meta.get("mcids", []) if p == prev_page]
                if mcids_on_page:
                    max_mcid = max(mcids_on_page)
                    candidates.append((eid, meta, max_mcid))

            if verbose:
                print(f"[DEBUG] Page {page_num}: Found {len(candidates)} candidates on prev_page {prev_page}")

            if not candidates:
                continue

            # Pick the element with the highest MCID on prev_page (last in document)
            candidates.sort(key=lambda x: x[2], reverse=True)
            primary_eid, primary_meta, max_mcid_val = candidates[0]
            if verbose:
                print(f"[DEBUG] Page {page_num}: Selected elem {primary_eid} (max_mcid={max_mcid_val})")

            # Skip if already linked (only when owner_eid is known)
            if owner_eid is not None and owner_eid == primary_eid:
                if verbose:
                    print(f"[DEBUG] Page {page_num}: Skipping - already linked")
                continue

            # Add continuation record - link injected/orphan MCID to previous page's element
            tuple_key = (primary_eid, first_mcid, page_num)
            if tuple_key not in existing:
                aux_lines.append(f"\\lpsb@mcid@cont{{{primary_eid}}}{{{first_mcid}}}{{{page_num}}}\n")
                existing.add(tuple_key)
                merged += 1
                if verbose:
                    print(f"[DEBUG] Page {page_num}: Added link MCID {first_mcid} -> elem {primary_eid}")
            else:
                if verbose:
                    print(f"[DEBUG] Page {page_num}: Tuple {tuple_key} already in existing, skipping")

        doc_for_scan.close()

        appended += merged
        if verbose:
            print(f"[DEBUG] Before write: appended={appended}, merged={merged}, aux_lines count={len(aux_lines)}")

            # Debug: Check if 10008 is in aux_lines
            lines_with_10008 = [l for l in aux_lines if '10008' in l]
            print(f"[DEBUG] Lines with 10008 in aux_lines: {len(lines_with_10008)}")
            for l in lines_with_10008:
                print(f"[DEBUG]   {l.strip()}")

        if appended:
            Path(aux_path).write_text("".join(aux_lines))
            if verbose:
                print(f"[DEBUG] Aux file written to: {aux_path}")

                # Verify immediately after write
                written_content = Path(aux_path).read_text()
                if '10008' in written_content:
                    print(f"[DEBUG] ✓ 10008 found in written file")
                else:
                    print(f"[DEBUG] ✗ 10008 NOT found in written file")
                print(f"[synctex-fix] Aux updated: +{appended} continuations ({merged} cross-page merges)")
    except Exception as e:
        # Don't silently fail - re-raise the exception
        print(f"[synctex-fix] ERROR: failed to update aux: {e}")
        import traceback
        traceback.print_exc()
        raise

    if verbose:
        print(f"[synctex-fix] Injections: {total_injections}, Splits: {total_splits}, Orphans removed: {total_orphans}")
        print(f"[synctex-fix] Saved: {output_path}")

    return str(output_path)


def main():
    """CLI entry point."""
    parser = argparse.ArgumentParser(
        description='Fix cross-page/cross-column MCID issues using SyncTeX'
    )
    parser.add_argument('pdf', help='Input PDF file')
    parser.add_argument('--aux', required=True, help='AUX file')
    parser.add_argument('--synctex', required=True, help='SyncTeX file (.synctex.gz)')
    parser.add_argument('-o', '--output', help='Output PDF (default: input_fixed.pdf)')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')

    args = parser.parse_args()

    args = parser.parse_args()

    # No try-except: let it crash with full traceback
    output = process_pdf_synctex(
        args.pdf, args.aux, args.synctex,
        output_path=args.output,
        verbose=args.verbose
    )
    print(f"Success: {output}")
    return 0


if __name__ == '__main__':
    exit(main())
