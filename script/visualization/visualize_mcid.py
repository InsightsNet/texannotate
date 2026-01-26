#!/usr/bin/env python3
"""
Visualize MCID tags on PDF with colored boxes, labels, and reading order.
Uses PyMuPDF (fitz) to draw annotations on the PDF.
"""

import fitz
import pdfplumber
from pathlib import Path
import colorsys
import argparse
import json
import re
from typing import Dict, List, Tuple, Optional, Set

# pdfplumber/pdfminer can choke on malformed font dicts (e.g. missing Length1).
# Relax strictness to keep bbox extraction working on real-world PDFs.
import pdfminer.settings  # type: ignore
pdfminer.settings.STRICT = False
import sys

from ..parsing.parse_lpsb_mcid import parse_aux_file  # type: ignore


def generate_color(mcid: int, total_mcids: int = 100) -> tuple:
    """Generate a distinct color for each MCID using HSV color space."""
    hue = (mcid * 0.618033988749895) % 1.0  # Golden ratio for good distribution
    saturation = 0.7
    value = 0.9
    r, g, b = colorsys.hsv_to_rgb(hue, saturation, value)
    return (r, g, b)


def _get_page_content_text(doc: fitz.Document, page_num: int) -> str:
    """Concatenate all content streams for a page into text."""
    page = doc[page_num]
    parts: List[str] = []
    try:
        xrefs = page.get_contents() or []
    except Exception:
        xrefs = []
    for xref in xrefs:
        try:
            s = doc.xref_stream(int(xref))
        except Exception:
            continue
        if not s:
            continue
        parts.append(s.decode("latin-1", errors="replace"))
    return "\n".join(parts)


def get_mcid_tag_types(doc: fitz.Document, page_num: int) -> dict:
    """Extract MCID -> tag type mapping from PDF content stream."""
    import re
    
    mcid_tags = {}
    
    try:
        content_text = _get_page_content_text(doc, page_num)
        if content_text:
            # Parse BDC tags: /TagType << /MCID N >> BDC
            bdc_pattern = re.findall(r'/(\w+)\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC', content_text)
            for tag_type, mcid_str in bdc_pattern:
                mcid = int(mcid_str)
                mcid_tags[mcid] = tag_type
    except Exception:
        pass
    
    return mcid_tags


def get_mcid_bboxes(pdf_path: str, line_based: bool = True) -> dict:
    """Extract bounding boxes for each MCID on each page.
    
    Args:
        pdf_path: Path to PDF file
        line_based: If True, group chars by line to avoid cross-column merged boxes.
                   Each MCID will have a list of line bboxes instead of one merged bbox.
    """
    pdf = pdfplumber.open(pdf_path)
    page_data = {}
    
    for page_idx, page in enumerate(pdf.pages):
        page_num = page_idx + 1  # Use 1-based indexing to match aux files and cache
        try:
            mcid_chars = {}
            for char in page.chars:
                mcid = char.get('mcid')
                if mcid is not None:
                    if mcid not in mcid_chars:
                        mcid_chars[mcid] = []
                    mcid_chars[mcid].append(char)
            
            # Calculate bounding box(es) for each MCID
            mcid_bboxes = {}
            for mcid, chars in mcid_chars.items():
                if line_based:
                    # Group chars by line (y-coordinate with tolerance)
                    y_tolerance = 3.0  # chars within 3pt are on same line
                    lines = []
                    sorted_chars = sorted(chars, key=lambda c: (c['top'], c['x0']))
                    current_line = []
                    current_y = None
                    
                    for c in sorted_chars:
                        if current_y is None or abs(c['top'] - current_y) <= y_tolerance:
                            current_line.append(c)
                            if current_y is None:
                                current_y = c['top']
                        else:
                            if current_line:
                                lines.append(current_line)
                            current_line = [c]
                            current_y = c['top']
                    if current_line:
                        lines.append(current_line)
                    
                    # Create bbox for each line
                    line_bboxes = []
                    for line_chars in lines:
                        lx0 = min(c['x0'] for c in line_chars)
                        ly0 = min(c['top'] for c in line_chars)
                        lx1 = max(c['x1'] for c in line_chars)
                        ly1 = max(c['bottom'] for c in line_chars)
                        line_bboxes.append((lx0, ly0, lx1, ly1))
                    
                    # Overall bbox is union of all lines (for sorting/labeling)
                    x0 = min(bb[0] for bb in line_bboxes) if line_bboxes else 0
                    y0 = min(bb[1] for bb in line_bboxes) if line_bboxes else 0
                    x1 = max(bb[2] for bb in line_bboxes) if line_bboxes else 0
                    y1 = max(bb[3] for bb in line_bboxes) if line_bboxes else 0
                else:
                    x0 = min(c['x0'] for c in chars)
                    y0 = min(c['top'] for c in chars)
                    x1 = max(c['x1'] for c in chars)
                    y1 = max(c['bottom'] for c in chars)
                    line_bboxes = [(x0, y0, x1, y1)]
                
                # Get sample text
                text = ''.join(c['text'] for c in sorted(chars, key=lambda c: (c['top'], c['x0']))[:20])
                
                mcid_bboxes[mcid] = {
                    'bbox': (x0, y0, x1, y1),
                    'line_bboxes': line_bboxes,
                    'text_preview': text[:30],
                    'char_count': len(chars)
                }
            
            page_data[page_num] = mcid_bboxes
        except Exception:
            # pdfminer/pdfplumber can choke on some embedded fonts. Keep going.
            page_data[page_num] = {}
    
    pdf.close()
    return page_data


def _merge_bbox(a: Tuple[float, float, float, float], b: Tuple[float, float, float, float]) -> Tuple[float, float, float, float]:
    return (min(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), max(a[3], b[3]))


def _bbox_area(bb: Tuple[float, float, float, float]) -> float:
    try:
        return max(0.0, float(bb[2]) - float(bb[0])) * max(0.0, float(bb[3]) - float(bb[1]))
    except Exception:
        return 0.0


def _bbox_valid(bb: Optional[Tuple[float, float, float, float]]) -> bool:
    if not bb:
        return False
    try:
        x0, y0, x1, y1 = map(float, bb)
    except Exception:
        return False
    if x1 <= x0 or y1 <= y0:
        return False
    # Avoid microscopic / degenerate boxes.
    return _bbox_area((x0, y0, x1, y1)) >= 4.0


def _page_image_block_bboxes(page: fitz.Page) -> List[Tuple[float, float, float, float]]:
    """Get image block bboxes on a page.

    PyMuPDF's text dict includes blocks of type=1 for images, with accurate bboxes.
    This is a visualization fallback only (no MCID association available here).
    """
    out: List[Tuple[float, float, float, float]] = []
    try:
        d = page.get_text("dict")
    except Exception:
        return out
    for b in d.get("blocks", []) or []:
        try:
            if int(b.get("type", -1)) != 1:
                continue
            bb = b.get("bbox")
            if not bb or len(bb) != 4:
                continue
            x0, y0, x1, y1 = map(float, bb)
            out.append((x0, y0, x1, y1))
        except Exception:
            continue
    return out


def _safe_union_bbox(
    base: Tuple[float, float, float, float],
    extra: Tuple[float, float, float, float],
    *,
    max_area_ratio: float = 6.0,
    min_iou: float = 0.05,
) -> Tuple[float, float, float, float]:
    """Union bboxes, but reject wild extras.

    When figures are embedded as PDF/Form XObjects, some bbox sources can be
    overly conservative and cover a large portion of the page. For visualization
    we prefer stable boxes: only merge if the extra overlaps meaningfully or is
    not much larger than the base.
    """
    try:
        base_a = _bbox_area(base)
        extra_a = _bbox_area(extra)
        if base_a <= 0.0 or extra_a <= 0.0:
            return _merge_bbox(base, extra)
        ratio = extra_a / max(base_a, 1e-6)
        # If the extra is huge AND barely overlaps, ignore it.
        if ratio > max_area_ratio:
            try:
                if _iou(base, extra) < min_iou:
                    return base
            except Exception:
                return base
        return _merge_bbox(base, extra)
    except Exception:
        return _merge_bbox(base, extra)


def _estimate_mcid_anchor_bboxes(
    doc: fitz.Document,
    page_num: int,
    mcid_tags: Dict[int, str],
    mcids: List[int],
) -> Dict[int, Tuple[float, float, float, float]]:
    """Estimate a tiny bbox for MCIDs that have no extracted chars.

    This is a visualization-only fallback for cases where:
    - MCID exists in content stream (we can label it), but
    - pdfplumber fails to extract chars for that MCID (font/path issues).

    We approximate anchor position by finding the nearest BT block and the first
    Td/Tm inside that block before the MCID's BDC.
    """
    if not mcids:
        return {}

    page = doc[page_num]
    page_h = float(page.rect.height)
    text = _get_page_content_text(doc, page_num)
    if not text:
        return {}

    out: Dict[int, Tuple[float, float, float, float]] = {}

    # Patterns for text positioning operators.
    tm_re = re.compile(r"([\\d.-]+)\\s+([\\d.-]+)\\s+([\\d.-]+)\\s+([\\d.-]+)\\s+([\\d.-]+)\\s+([\\d.-]+)\\s+Tm")
    td_re = re.compile(r"([\\d.-]+)\\s+([\\d.-]+)\\s+Td")

    for mcid in mcids:
        tag = mcid_tags.get(mcid)
        if not tag:
            continue
        # Locate the BDC for this MCID.
        m = re.search(rf"/{re.escape(tag)}\\s*<<\\s*/MCID\\s*{mcid}\\s*>>\\s*BDC", text)
        if not m:
            continue

        # Find a nearby BT block start.
        bt = text.rfind("BT", 0, m.start())
        if bt < 0:
            continue
        seg = text[bt:m.start()]

        x = None
        y = None
        # Prefer the first Td in this BT block (absolute-ish position).
        td = td_re.search(seg)
        if td:
            try:
                x = float(td.group(1))
                y = float(td.group(2))
            except Exception:
                x = None
                y = None
        if x is None or y is None:
            # Fallback to first Tm.
            tm = tm_re.search(seg)
            if tm:
                try:
                    x = float(tm.group(5))
                    y = float(tm.group(6))
                except Exception:
                    x = None
                    y = None
        if x is None or y is None:
            continue

        # Convert PDF user-space (origin bottom-left) to fitz/page space (origin top-left).
        y_top = page_h - y
        # Tiny anchor box.
        bb = (x, max(0.0, y_top - 8.0), x + 8.0, y_top)
        out[mcid] = bb

    return out


def get_figure_mcid_image_bboxes(doc: fitz.Document, page_num: int) -> Dict[int, Tuple[float, float, float, float]]:
    """Infer Figure MCID bboxes from XObject draws inside Figure marked-content.

    pdfplumber's MCID extraction is text-based (chars), so Figure content that is
    *not text* can look "missing". In practice, figures are commonly injected as
    XObjects:
    - raster images: `/Im0 Do` (Subtype /Image)
    - vector/PDF graphics: `/Fm0 Do` (Subtype /Form)

    Here we parse the page content streams to associate `Do` draws with the
    currently-open `/Figure ... BDC` MCID and compute a bbox from PyMuPDF's
    resource rects (images + form XObjects).
    """
    page = doc[page_num]

    # Map XObject resource name -> bbox (union of all occurrences).
    name_to_bbox: Dict[str, Tuple[float, float, float, float]] = {}

    # 1) Images: resource name -> union rects (can appear multiple times).
    try:
        imgs = page.get_images(full=True) or []
    except Exception:
        imgs = []
    for t in imgs:
        try:
            xref = int(t[0])
            name = str(t[7])
        except Exception:
            continue
        if not name:
            continue
        try:
            rects = page.get_image_rects(xref) or []
        except Exception:
            rects = []
        for r in rects:
            bb = (float(r.x0), float(r.y0), float(r.x1), float(r.y1))
            if name in name_to_bbox:
                name_to_bbox[name] = _merge_bbox(name_to_bbox[name], bb)
            else:
                name_to_bbox[name] = bb

    # 2) Form XObjects: Try to get page-space bbox.
    # CAUTION: get_xobjects() returns the XObject's INTERNAL definition bbox,
    # NOT the transformed position on the page. Bboxes starting at (0,0) are
    # almost certainly in object-space and will create incorrect huge figure boxes.
    # We only use XObject bboxes if they look like valid page positions.
    try:
        xobjs = page.get_xobjects() or []
    except Exception:
        xobjs = []
    page_w = float(page.rect.width)
    page_h = float(page.rect.height)
    for xo in xobjs:
        try:
            # (xref, name, inv, bbox)
            name = str(xo[1])
            bb = xo[3]
        except Exception:
            continue
        if not name or not bb or len(bb) != 4:
            continue
        try:
            x0, y0, x1, y1 = map(float, bb)
        except Exception:
            continue
        # Skip bboxes that are clearly object-space (start at origin or exceed page bounds)
        if x0 <= 1.0 and y0 <= 1.0:
            # Likely an untransformed XObject definition bbox, not page position
            continue
        if x1 > page_w * 1.1 or y1 > page_h * 1.1:
            # Exceeds page bounds - likely object-space dimensions
            continue
        bb2 = (x0, y0, x1, y1)
        if name in name_to_bbox:
            name_to_bbox[name] = _merge_bbox(name_to_bbox[name], bb2)
        else:
            name_to_bbox[name] = bb2

    if not name_to_bbox:
        return {}

    text = _get_page_content_text(doc, page_num)
    if not text:
        return {}

    token_re = re.compile(
        r"/(?P<tag>\w+)\s*<<\s*/MCID\s*(?P<mcid>\d+)\s*>>\s*BDC"
        r"|(?P<emc>\bEMC\b)"
        r"|/(?P<do_name>\w+)\s+Do"
    )

    stack: List[Tuple[str, int]] = []
    fig_mcid_to_bbox: Dict[int, Tuple[float, float, float, float]] = {}

    for m in token_re.finditer(text):
        tag = m.group("tag")
        if tag:
            try:
                stack.append((tag, int(m.group("mcid"))))
            except Exception:
                continue
            continue

        if m.group("emc"):
            if stack:
                stack.pop()
            continue

        do_name = m.group("do_name")
        if not do_name:
            continue
        bb = name_to_bbox.get(do_name)
        if bb is None:
            continue

        fig_mcid = None
        for ttag, tmcid in reversed(stack):
            if ttag == "Figure":
                fig_mcid = tmcid
                break
        if fig_mcid is None:
            continue

        if fig_mcid in fig_mcid_to_bbox:
            fig_mcid_to_bbox[fig_mcid] = _merge_bbox(fig_mcid_to_bbox[fig_mcid], bb)
        else:
            fig_mcid_to_bbox[fig_mcid] = bb

    # CRITICAL FIX: Expand Figure bboxes to include all XObjects in the same area.
    # Embedded PDFs (Form XObjects) contain multiple sub-images that are not directly
    # referenced in the main content stream's Figure BDC. We expand the Figure bbox
    # to include all images whose centers are near the initial Figure bbox.
    if fig_mcid_to_bbox and name_to_bbox:
        for fig_mcid, fig_bb in list(fig_mcid_to_bbox.items()):
            # Find all XObject bboxes that overlap significantly with the Figure bbox
            # or are in the same vertical region (figures often span horizontal area)
            fig_cx = (fig_bb[0] + fig_bb[2]) / 2
            fig_cy = (fig_bb[1] + fig_bb[3]) / 2
            fig_h = fig_bb[3] - fig_bb[1]
            
            expanded_bb = fig_bb
            for name, xbb in name_to_bbox.items():
                xbb_cx = (xbb[0] + xbb[2]) / 2
                xbb_cy = (xbb[1] + xbb[3]) / 2
                
                # Check if XObject is in the figure area (within ~200pt vertical range)
                # and horizontally overlaps with the figure
                vertical_dist = abs(xbb_cy - fig_cy)
                horizontal_overlap = not (xbb[2] < fig_bb[0] - 50 or xbb[0] > fig_bb[2] + 50)
                
                if vertical_dist < 200 and horizontal_overlap:
                    expanded_bb = _merge_bbox(expanded_bb, xbb)
            
            fig_mcid_to_bbox[fig_mcid] = expanded_bb

    return fig_mcid_to_bbox


def get_lpsbimg_bboxes(doc: fitz.Document, page_num: int) -> Dict[int, Tuple[float, float, float, float]]:
    r"""Extract image bboxes from /LPSBImg markers in the PDF content stream.
    
    LPSB injects /LPSBImg N BDC ... EMC markers around \includegraphics content.
    By parsing the CTM (current transformation matrix) before each /ImX Do command
    inside these markers, we can compute accurate image bounding boxes even for
    embedded PDF Form XObjects where standard extraction fails.
    
    Returns:
        Dict mapping LPSBImg ID -> (x0, y0, x1, y1) in page coordinates (top-left origin)
    """
    page = doc[page_num]
    page_h = float(page.rect.height)
    
    # Get content stream
    content = _get_page_content_text(doc, page_num)
    if not content:
        return {}
    
    # Get Form XObject BBox sizes from resources
    form_bbox: Dict[str, Tuple[float, float, float, float]] = {}
    try:
        xobjs = page.get_xobjects() or []
        for xo in xobjs:
            try:
                name = str(xo[1])
                bb = xo[3]
                if name and bb and len(bb) == 4:
                    form_bbox[name] = tuple(float(x) for x in bb)
            except Exception:
                continue
    except Exception:
        pass
    
    # Parse: /LPSBImg N BDC ... translation_cm ... scale_cm ... /ImX Do
    # The structure is:
    #   /LPSBImg N BDC
    #   a b c d tx ty cm      <- translation matrix
    #   q
    #   sx 0 0 sy 0 0 cm      <- scale matrix
    #   q
    #   1 0 0 1 0 0 cm
    #   /ImX Do
    #   Q Q EMC
    #
    # Variant 2 (subfigures with ET before BDC):
    #   ET
    #   /LPSBImg N BDC
    #   1 0 0 1 tx ty cm       <- translation (note: first 4 values may vary)
    #   q
    #   sx 0 0 sy 0 0 cm       <- scale
    #   ...
    #   /ImX Do
    
    # Flexible pattern that captures any cm before the scale cm and Do
    pattern = re.compile(
        r'/LPSBImg\s+(\d+)\s+BDC\s*'       # LPSBImg marker
        r'(?:ET\s*)?'                        # Optional ET
        r'([0-9.-]+)\s+([0-9.-]+)\s+([0-9.-]+)\s+([0-9.-]+)\s+([0-9.-]+)\s+([0-9.-]+)\s+cm\s*'  # translation cm
        r'q\s*'
        r'([0-9.-]+)\s+[0-9.-]+\s+[0-9.-]+\s+([0-9.-]+)\s+[0-9.-]+\s+[0-9.-]+\s+cm\s*'  # scale cm (capture sx and sy)
        r'[^/]*?/(Im\d+)\s+Do',              # /ImX Do
        re.DOTALL
    )
    
    lpsbimg_to_bbox: Dict[int, Tuple[float, float, float, float]] = {}
    
    for m in pattern.finditer(content):
        try:
            imgid = int(m.group(1))
            # Translation matrix: last two values are tx, ty
            tx, ty = float(m.group(6)), float(m.group(7))
            # Scale matrix: first and fourth values are sx, sy
            sx, sy = float(m.group(8)), float(m.group(9))
            im_name = m.group(10)
            
            # Get form bbox (internal dimensions)
            fb = form_bbox.get(im_name, (0, 0, 100, 100))
            fw, fh = fb[2] - fb[0], fb[3] - fb[1]
            
            # Compute actual rendered size
            actual_w = fw * abs(sx)
            actual_h = fh * abs(sy)
            
            # Position in PDF coords (origin bottom-left)
            x0_pdf = tx
            y0_pdf = ty
            x1_pdf = tx + actual_w
            y1_pdf = ty + actual_h
            
            # Convert to page coords (origin top-left)
            x0 = x0_pdf
            y0 = page_h - y1_pdf
            x1 = x1_pdf
            y1 = page_h - y0_pdf
            
            lpsbimg_to_bbox[imgid] = (x0, y0, x1, y1)
        except Exception:
            continue
    
    return lpsbimg_to_bbox



def get_elements_from_aux(aux_path: str, pdf_path: Optional[str] = None) -> List[Dict]:
    """Parse aux and return element dicts with role + mcids (no geometry).
    
    If pdf_path is provided, reconcile element pages with actual PDF MCID locations
    to fix float/async page mismatches.
    
    Returns a list of element dicts. Image data is also returned if include_images=True.
    """
    from ..parsing.parse_lpsb_mcid import reconcile_element_pages
    
    auxp = Path(aux_path)
    if not auxp.exists():
        return []

    elements, summary = parse_aux_file(auxp)
    
    # Extract image data from summary (added by parse_aux_file)
    images = summary.get("images", {})
    
    # Reconcile pages if PDF is provided (fixes float/async page mismatches)
    if pdf_path:
        pdfp = Path(pdf_path)
        if pdfp.exists():
            reconcile_element_pages(elements, pdfp, verbose=False)
    
    out = []
    for e in elements:
        elem_dict = {
            "elem_id": e.elem_id,
            "role": e.tag_type,
            "is_atom": bool(getattr(e, "is_atom", False)),
            "parent_id": getattr(e, "parent_id", None),
            "mcids": [{"mcid": int(m.mcid), "page": int(m.page)} for m in getattr(e, "mcids", [])],
        }
        out.append(elem_dict)
    
    # Store image data in a module-level variable for access by visualization
    # Note: images from summary is already a dict of dicts (converted in parse_aux_file)
    global _aux_image_data
    _aux_image_data = {
        img_id: {
            "width_pt": img_data["width_pt"],
            "height_pt": img_data["height_pt"],
            "depth_pt": img_data["depth_pt"],
            "page": img_data["page"]
        }
        for img_id, img_data in images.items()
    }
    
    return out

# Module-level storage for image data
_aux_image_data: Dict[int, Dict] = {}

def get_aux_image_data() -> Dict[int, Dict]:
    """Get image dimension data parsed from aux file."""
    return _aux_image_data


def _extract_stroke_bboxes(page: fitz.Page) -> List[Tuple[float, float, float, float]]:
    """Extract candidate stroke bboxes (lines/rects) from page drawings."""
    out: List[Tuple[float, float, float, float]] = []
    try:
        drawings = page.get_drawings()
    except Exception:
        return out

    page_h = float(page.rect.height)
    for d in drawings:
        w = float(d.get("width") or 0.0)
        if w <= 0.0:
            continue
        if w > 3.0:
            continue  # thick graphics, not table rules

        for it in d.get("items", []):
            try:
                typ = it[0]
            except Exception:
                continue
            # line segment
            if typ == "l" and len(it) >= 3:
                p1 = it[1]
                p2 = it[2]
                x0 = min(p1.x, p2.x)
                y0 = min(p1.y, p2.y)
                x1 = max(p1.x, p2.x)
                y1 = max(p1.y, p2.y)
                if (x1 - x0) < 20 and (y1 - y0) < 20:
                    continue
                # Ignore typical header/footer rules.
                y_mid = (y0 + y1) / 2.0
                if y_mid < 55 or y_mid > (page_h - 55):
                    continue
                out.append((x0, y0, x1, y1))
            # rect
            elif typ == "re" and len(it) >= 2:
                r = it[1]
                out.append((r.x0, r.y0, r.x1, r.y1))
    return out


def _cluster_bboxes(bboxes: List[Tuple[float, float, float, float]], margin: float = 8.0) -> List[Tuple[float, float, float, float]]:
    """Greedy clustering by bbox overlap / proximity."""
    if not bboxes:
        return []
    bboxes = sorted(bboxes, key=lambda b: (b[1], b[0]))
    clusters: List[Tuple[float, float, float, float]] = []

    def _expand(b):
        return (b[0] - margin, b[1] - margin, b[2] + margin, b[3] + margin)

    def _intersects(a, b):
        return not (a[2] < b[0] or b[2] < a[0] or a[3] < b[1] or b[3] < a[1])

    for bb in bboxes:
        placed = False
        for i, cb in enumerate(clusters):
            if _intersects(_expand(cb), bb):
                clusters[i] = _merge_bbox(cb, bb)
                placed = True
                break
        if not placed:
            clusters.append(bb)
    return clusters


def _overlap_ratio_1d(a0: float, a1: float, b0: float, b1: float) -> float:
    left = max(a0, b0)
    right = min(a1, b1)
    if right <= left:
        return 0.0
    inter = right - left
    denom = max(a1 - a0, b1 - b0, 1e-6)
    return inter / denom


def _area(bb: Tuple[float, float, float, float]) -> float:
    return max(0.0, bb[2] - bb[0]) * max(0.0, bb[3] - bb[1])


def _intersect(bb1: Tuple[float, float, float, float], bb2: Tuple[float, float, float, float]) -> Optional[Tuple[float, float, float, float]]:
    x0 = max(bb1[0], bb2[0])
    y0 = max(bb1[1], bb2[1])
    x1 = min(bb1[2], bb2[2])
    y1 = min(bb1[3], bb2[3])
    if x1 <= x0 or y1 <= y0:
        return None
    return (x0, y0, x1, y1)


def _iou(bb1: Tuple[float, float, float, float], bb2: Tuple[float, float, float, float]) -> float:
    inter = _intersect(bb1, bb2)
    if not inter:
        return 0.0
    ia = _area(inter)
    ua = _area(bb1) + _area(bb2) - ia
    if ua <= 0:
        return 0.0
    return ia / ua


def _group_table_mcids_auto(
    table_mcids: List[int],
    mcid_bboxes: Dict[int, Dict],
) -> List[Dict]:
    """Group Table MCIDs into table instances by bbox overlap.

    This is used when no aux is available (no logical-id mapping). It relies on
    text bboxes from pdfplumber when present, and falls back to treating each MCID
    as its own table when bboxes are missing.
    """
    items = []
    for mcid in table_mcids:
        bb = mcid_bboxes.get(mcid, {}).get("bbox")
        if bb:
            items.append((mcid, tuple(bb)))
        else:
            items.append((mcid, None))

    # Sort by y, then x (top-left).
    items.sort(key=lambda t: (t[1][1], t[1][0]) if t[1] else (1e9, 1e9))

    groups: List[Dict] = []
    for mcid, bb in items:
        placed = False
        if bb:
            for g in groups:
                hb = g.get("hint_bbox")
                if hb and _iou(hb, bb) >= 0.10:
                    g["mcids"].append(mcid)
                    g["hint_bbox"] = _merge_bbox(hb, bb)
                    placed = True
                    break
        if not placed:
            groups.append({"mcids": [mcid], "hint_bbox": bb})

    # Final pass: merge adjacent groups if their hints overlap a lot (robust to split columns).
    merged: List[Dict] = []
    for g in groups:
        hb = g.get("hint_bbox")
        if hb is None:
            merged.append(g)
            continue
        did = False
        for m in merged:
            mb = m.get("hint_bbox")
            if mb and _iou(mb, hb) >= 0.05:
                m["mcids"].extend(g["mcids"])
                m["hint_bbox"] = _merge_bbox(mb, hb)
                did = True
                break
        if not did:
            merged.append(g)

    return merged


def _detect_table_bbox_near_hint(page: fitz.Page, hint: Tuple[float, float, float, float]) -> Optional[Tuple[float, float, float, float]]:
    """Tight table bbox using nearby rules constrained by text hint.

    The hint comes from MCID text bboxes; this respects \\scalebox and avoids
    accidentally absorbing page-level rules.
    """
    try:
        hx0, hy0, hx1, hy1 = hint
    except Exception:
        return None

    strokes = _extract_stroke_bboxes(page)
    if not strokes:
        return None

    # Expand hint a bit: borders typically extend beyond text.
    pad = 18.0
    cx0, cy0, cx1, cy1 = (hx0 - pad, hy0 - pad, hx1 + pad, hy1 + pad)

    horiz = []
    vert = []
    for (x0, y0, x1, y1) in strokes:
        dx = abs(x1 - x0)
        dy = abs(y1 - y0)
        # must intersect expanded hint region in y/x
        if y1 < cy0 or y0 > cy1 or x1 < cx0 or x0 > cx1:
            continue

        if dx >= 60 and dy <= 2.5:
            # require substantial x overlap with hint span
            if _overlap_ratio_1d(hx0, hx1, x0, x1) < 0.50:
                continue
            horiz.append((x0, (y0 + y1) / 2.0, x1))
        elif dy >= 40 and dx <= 2.5:
            if _overlap_ratio_1d(hy0, hy1, y0, y1) < 0.30:
                continue
            vert.append(((x0 + x1) / 2.0, y0, y1))

    if len(horiz) < 2 and len(vert) < 2:
        return None

    # Use rules to bound, fallback to hint bounds.
    x0 = min((h[0] for h in horiz), default=hx0)
    x1 = max((h[2] for h in horiz), default=hx1)
    y0 = min((h[1] for h in horiz), default=hy0)
    y1 = max((h[1] for h in horiz), default=hy1)

    if vert:
        x0 = min(x0, min(v[0] for v in vert))
        x1 = max(x1, max(v[0] for v in vert))
        y0 = min(y0, min(v[1] for v in vert))
        y1 = max(y1, max(v[2] for v in vert))

    # Tight padding.
    bb = (x0 - 3.0, y0 - 3.0, x1 + 3.0, y1 + 3.0)

    # Sanity: don't let bbox explode beyond hint by too much.
    bw = bb[2] - bb[0]
    bh = bb[3] - bb[1]
    hw = (hx1 - hx0) + 1e-6
    hh = (hy1 - hy0) + 1e-6
    if bw > hw * 2.2 or bh > hh * 2.2:
        return None
    return bb


def _detect_table_border_bboxes_by_rules(page: fitz.Page) -> List[Tuple[float, float, float, float]]:
    """Detect table bboxes by grouping horizontal/vertical rules.

    Works better for booktabs-style tables (mostly horizontal rules) than generic
    bbox clustering, and respects \\scalebox because it uses actual drawn rules.
    """
    strokes = _extract_stroke_bboxes(page)
    if not strokes:
        return []

    # Separate near-horizontal and near-vertical segments.
    horiz = []
    vert = []
    for (x0, y0, x1, y1) in strokes:
        dx = abs(x1 - x0)
        dy = abs(y1 - y0)
        if dx >= 60 and dy <= 2.5:
            horiz.append((x0, y0, x1, y1))
        elif dy >= 40 and dx <= 2.5:
            vert.append((x0, y0, x1, y1))

    # Group horizontal rules by shared x-span and proximity in y.
    horiz.sort(key=lambda b: (b[1], b[0]))
    groups: List[List[Tuple[float, float, float, float]]] = []
    for b in horiz:
        placed = False
        for g in groups:
            gx0 = min(x[0] for x in g)
            gx1 = max(x[2] for x in g)
            gy_last = g[-1][1]
            # same table: similar x-span and close-ish y
            if _overlap_ratio_1d(gx0, gx1, b[0], b[2]) >= 0.85 and abs(b[1] - gy_last) <= 60:
                g.append(b)
                placed = True
                break
        if not placed:
            groups.append([b])

    # Build candidate boxes from groups (prefer groups with multiple rules).
    cand: List[Tuple[int, float, Tuple[float, float, float, float]]] = []
    for g in groups:
        if len(g) < 2:
            continue
        x0 = min(b[0] for b in g)
        x1 = max(b[2] for b in g)
        y0 = min(b[1] for b in g)
        y1 = max(b[1] for b in g)
        # Height from rules only; add padding.
        pad = 3.0
        bb = (x0 - pad, y0 - pad, x1 + pad, y1 + pad)
        cand.append((len(g), (bb[2] - bb[0]) * (bb[3] - bb[1]), bb))

    # Fallback: if we have vertical rules, cluster them by proximity and use that bbox.
    if not cand and vert:
        v = sorted(vert, key=lambda b: (b[0], b[1]))
        clusters = _cluster_bboxes(v, margin=8.0)
        for bb in clusters:
            cand.append((2, (bb[2] - bb[0]) * (bb[3] - bb[1]), bb))

    if not cand:
        return []

    # Filter out boxes that are obviously too big for a scaled table.
    w = float(page.rect.width)
    h = float(page.rect.height)
    filtered = []
    for count, area, bb in cand:
        bw = bb[2] - bb[0]
        bh = bb[3] - bb[1]
        if bw < 120 or bh < 25:
            continue
        if (bw * bh) / max(w * h, 1.0) > 0.40:
            continue
        # Drop header-ish boxes near the top margin.
        if bb[1] < 70 and bh < 120:
            continue
        filtered.append((count, area, bb))

    # Prefer more rules, then smaller area (tight), and keep non-overlapping.
    filtered.sort(key=lambda t: (-t[0], t[1], t[2][1], t[2][0]))

    out: List[Tuple[float, float, float, float]] = []
    for _count, _area, bb in filtered:
        # avoid duplicates/overlaps
        if any(_overlap_ratio_1d(b[0], b[2], bb[0], bb[2]) > 0.9 and _overlap_ratio_1d(b[1], b[3], bb[1], bb[3]) > 0.6 for b in out):
            continue
        out.append(bb)
    out.sort(key=lambda b: (b[1], b[0]))
    return out


def _detect_table_border_bboxes(page: fitz.Page, expected: int) -> List[Tuple[float, float, float, float]]:
    """Detect table-like bboxes using strokes only (rules-based)."""
    filtered = _detect_table_border_bboxes_by_rules(page)
    if expected > 0:
        return filtered[:expected]
    return filtered



_MATH_FONT_RE = re.compile(
    r"(?:\b|_)(?:CM|CMSY|CMMI|CMTI|CMEX|MSAM|MSBM|EUSM|EURM|RSFS|MATH)(?:\b|_)",
    re.IGNORECASE,
)


def _extract_math_spans(page, y_tol: float = 2.0, x_gap: float = 2.0) -> List[Dict]:
    """Heuristically extract inline-math spans by fontname.

    This is a fallback for PDFs where inline math isn't tagged as a separate MCID.
    It will inevitably be imperfect; the goal is to make missing inline-math
    annotations visible in the debug visualization.
    """
    chars = []
    for c in getattr(page, "chars", []):
        fn = str(c.get("fontname", "") or "")
        if _MATH_FONT_RE.search(fn):
            chars.append(c)

    if not chars:
        return []

    # Stable reading order grouping.
    chars.sort(key=lambda c: (c.get("top", 0.0), c.get("x0", 0.0)))

    spans: List[List[dict]] = []
    cur: List[dict] = []

    def _flush():
        nonlocal cur
        if cur:
            spans.append(cur)
            cur = []

    for c in chars:
        if not cur:
            cur = [c]
            continue
        same_line = abs(float(c.get("top", 0.0)) - float(cur[-1].get("top", 0.0))) <= y_tol
        close_enough = float(c.get("x0", 0.0)) - float(cur[-1].get("x1", 0.0)) <= x_gap
        if same_line and close_enough:
            cur.append(c)
        else:
            _flush()
            cur = [c]
    _flush()

    out: List[Dict] = []
    for s in spans:
        try:
            x0 = min(c["x0"] for c in s)
            y0 = min(c["top"] for c in s)
            x1 = max(c["x1"] for c in s)
            y1 = max(c["bottom"] for c in s)
            preview = "".join(c.get("text", "") for c in s[:30]).strip()
            out.append(
                {
                    "bbox": (x0, y0, x1, y1),
                    "text_preview": preview[:30],
                    "char_count": len(s),
                }
            )
        except Exception:
            continue
    return out


def visualize_mcid(
    pdf_path: str,
    output_path: str,
):
    """Create a visualization of MCID boxes on the PDF."""

    def _guess_aux_path(pdfp: Path) -> Optional[Path]:
        # Mirror lpsb_compiler.py behavior.
        cands: List[Path] = []
        cands.extend(
            [
                pdfp.with_name("main.aux.merged"),
                pdfp.with_name("main.aux.fixed"),
                pdfp.with_name("main.aux"),
                pdfp.with_suffix(".aux"),
            ]
        )

        stem = pdfp.stem
        stems = [stem]
        for suf in ("_fixed_tagged", "_tagged", "_fixed"):
            if stem.endswith(suf):
                stems.append(stem[: -len(suf)])
        # Try aux files that match the PDF stem (including common suffix-stripped stems).
        for s in stems:
            cands.extend(
                [
                    pdfp.with_name(f"{s}.aux.merged"),
                    pdfp.with_name(f"{s}.aux.fixed"),
                    pdfp.with_name(f"{s}.aux"),
                ]
            )

        # If still missing, fall back to any single aux-like file in the same dir.
        if not any(p.exists() for p in cands):
            try:
                aux_cands = list(pdfp.parent.glob("*.aux.*")) + list(pdfp.parent.glob("*.aux"))
            except Exception:
                aux_cands = []
            if len(aux_cands) == 1:
                return aux_cands[0]
            if stems:
                for s in stems:
                    for p in aux_cands:
                        if p.name.startswith(f"{s}.aux"):
                            return p
        for p in cands:
            try:
                if p.exists():
                    return p
            except Exception:
                continue
        return None

    def _guess_order_map_path(pdfp: Path, auxp: Optional[Path]) -> Optional[Path]:
        cands: List[Path] = []
        if auxp:
            cands.append(auxp.with_name("main.order.json"))
            cands.append(auxp.with_suffix(".order.json"))
        cands.append(pdfp.with_name("main.order.json"))
        cands.append(pdfp.with_suffix(".order.json"))
        for p in cands:
            try:
                if p.exists():
                    return p
            except Exception:
                continue
        return None

    pdfp = Path(pdf_path)

    # Get MCID data from pdfplumber
    page_data = get_mcid_bboxes(pdf_path)

    aux_elements = []
    # Parse aux; required for visualization.
    aux_path = _guess_aux_path(pdfp)
    if not aux_path:
        raise SystemExit(f"[viz] ERROR: aux not found for PDF: {pdfp}")
    aux_elements = get_elements_from_aux(str(aux_path), pdf_path=pdf_path)
    if not aux_elements:
        raise SystemExit(f"[viz] ERROR: aux parsed but produced no elements: {aux_path}")

    # Optional: external element order map (elem_id -> order index).
    order_map: Dict[int, int] = {}
    order_map_path = _guess_order_map_path(pdfp, aux_path)
    if order_map_path:
        raw = json.loads(Path(order_map_path).read_text(errors="replace"))
        d = raw.get("order_by_elem_id", raw) if isinstance(raw, dict) else None
        if not isinstance(d, dict):
            raise SystemExit(f"[viz] ERROR: invalid order-map JSON schema: {order_map_path}")
        for k, v in d.items():
            try:
                order_map[int(k)] = int(v)
            except Exception as e:
                raise SystemExit(f"[viz] ERROR: invalid order-map entry {k!r}:{v!r} in {order_map_path}: {e}") from e
    table_mcid_to_elem: Dict[int, int] = {}
    if aux_elements:
        for e in aux_elements:
            if e.get("role") != "Table":
                continue
            try:
                eid = int(e.get("elem_id", 0))
            except Exception:
                continue
            for m in e.get("mcids", []):
                try:
                    mcid = int(m.get("mcid", -1))
                except Exception:
                    continue
                if mcid >= 0:
                    table_mcid_to_elem[mcid] = eid

    # Build MCID -> tag_type mapping from aux_elements
    # This includes continuation MCIDs which inherit their parent element's type
    aux_mcid_to_type: Dict[int, str] = {}
    if aux_elements:
        for e in aux_elements:
            role = e.get("role", "")
            if not role:
                continue
            for m in e.get("mcids", []):
                try:
                    mcid = int(m.get("mcid", -1))
                except Exception:
                    continue
                if mcid >= 0:
                    aux_mcid_to_type[mcid] = role

    # Open PDF with fitz for drawing
    doc = fitz.open(pdf_path)
    
    # Open with pdfplumber too (for math span fallback)
    plumber = pdfplumber.open(pdf_path)

    # Process each page
    for page_num in range(len(doc)):
        page = doc[page_num]
        # Copy: we'll augment with image-derived bboxes below.
        # Use page_num + 1 because page_data uses 1-based indexing (matching aux files and cache)
        mcid_bboxes = dict(page_data.get(page_num + 1, {}) or {})
        
        math_spans = []
        try:
            math_spans = _extract_math_spans(plumber.pages[page_num])
        except Exception as e:
            raise SystemExit(f"[viz] ERROR: failed to extract math spans on page={page_num}: {e}") from e
        
        # Get tag types from aux file (authoritative source including continuation MCIDs).
        mcid_tags = dict(aux_mcid_to_type)
        
        # CRITICAL FIX: Also get tags from content stream for this page.
        # This fixes Figure/Table page mismatches where reconciliation moved elements
        # to different pages based on pdfplumber char extraction, but the actual
        # BDC markers are on the original page.
        content_stream_tags = get_mcid_tag_types(doc, page_num)
        aux_mcid_set = set(aux_mcid_to_type.keys())
        for mcid, tag in content_stream_tags.items():
            # Only override known MCIDs, or floats prone to page mismatch.
            if (mcid in aux_mcid_set) or (tag in ('Figure', 'Table', 'Caption')):
                mcid_tags[mcid] = tag
        
        table_mcids_on_page = [mcid for mcid, t in mcid_tags.items() if t == "Table"]

        # Augment Figure MCID bboxes with image rects (so figures don't look "missing").
        fig_img_bboxes = get_figure_mcid_image_bboxes(doc, page_num)
        if fig_img_bboxes:
            for mcid, bb in fig_img_bboxes.items():
                cur = mcid_bboxes.get(mcid, {}) or {}
                cur_bb = cur.get("bbox")
                if _bbox_valid(cur_bb):
                    try:
                        mcid_bboxes[mcid]["bbox"] = _safe_union_bbox(tuple(cur_bb), bb)
                    except Exception:
                        mcid_bboxes[mcid]["bbox"] = bb
                else:
                    mcid_bboxes[mcid] = {"bbox": bb, "line_bboxes": [bb], "text_preview": "", "char_count": 0}
        
        # CRITICAL FIX: Filter out non-Figure MCIDs whose bboxes are inside Figure bboxes.
        # pdfplumber incorrectly parses MCIDs from embedded PDF XObjects (e.g., vector figures),
        # causing text labels inside figures to be attributed to unrelated MCIDs from the main doc.
        # Collect Figure MCIDs using content stream tags (mcid_tags) to find which MCIDs are Figures
        fig_mcids_on_this_page = [mcid for mcid, tag in content_stream_tags.items() if tag == "Figure"]
        if fig_mcids_on_this_page:
            # Collect all Figure bboxes on this page from mcid_bboxes (already expanded)
            fig_bboxes_list = []
            for fig_mcid in fig_mcids_on_this_page:
                fig_data = mcid_bboxes.get(fig_mcid, {})
                fig_bb = fig_data.get("bbox")
                if _bbox_valid(fig_bb):
                    fig_bboxes_list.append((fig_mcid, tuple(fig_bb)))
            
            def _is_inside_figure(bb):
                """Check if bbox is mostly inside any Figure bbox."""
                if not _bbox_valid(bb):
                    return False
                for fig_mcid, fig_bb in fig_bboxes_list:
                    # Check if bb center is inside fig_bb
                    cx = (bb[0] + bb[2]) / 2
                    cy = (bb[1] + bb[3]) / 2
                    if fig_bb[0] <= cx <= fig_bb[2] and fig_bb[1] <= cy <= fig_bb[3]:
                        return True
                    # Also check for high overlap
                    inter = _intersect(bb, fig_bb)
                    if inter:
                        inter_area = _area(inter)
                        bb_area = _area(bb)
                        if bb_area > 0 and inter_area / bb_area > 0.5:
                            return True
                return False
            
            # Remove non-Figure MCIDs that are inside Figure bboxes
            mcids_to_remove = []
            for mcid, data in mcid_bboxes.items():
                tag = mcid_tags.get(mcid, '?')
                if tag in ('Figure', 'Caption'):
                    continue  # Keep Figure and Caption MCIDs
                bb = data.get("bbox")
                if bb and _is_inside_figure(bb):
                    # Drop stray MCIDs from embedded XObjects (not present in aux).
                    if mcid not in aux_mcid_set:
                        mcids_to_remove.append(mcid)
                        continue
                    mcids_to_remove.append(mcid)
            
            for mcid in mcids_to_remove:
                del mcid_bboxes[mcid]

        # Also use LPSBImg markers for more accurate image positions.
        # LPSBImg markers are injected by LPSB around \includegraphics content
        # and contain precise CTM-based bounding boxes.
        lpsbimg_bboxes = get_lpsbimg_bboxes(doc, page_num)
        if lpsbimg_bboxes:
            # Map LPSBImg IDs to their containing Figure MCIDs by parsing content stream
            content = _get_page_content_text(doc, page_num)
            if content:
                # Parse content stream using proper BDC/EMC stack tracking
                fig_lpsbimg_map: Dict[int, List[int]] = {}
                stack: List[Tuple[str, Optional[int]]] = []  # (tag_type, mcid_or_imgid)
                
                # Match BDC markers and EMC
                token_re = re.compile(
                    r'/Figure\s*<<\s*/MCID\s*(\d+)\s*>>\s*BDC'
                    r'|/LPSBImg\s+(\d+)\s+BDC'
                    r'|/\w+\s*<<[^>]*>>\s*BDC'  # Other BDC markers
                    r'|/\w+\s+\d+\s+BDC'         # Simple BDC markers (like /LPSBImg N BDC)
                    r'|\bEMC\b'
                )
                
                for m in token_re.finditer(content):
                    matched = m.group(0)
                    if m.group(1):  # Figure MCID
                        mcid = int(m.group(1))
                        stack.append(('Figure', mcid))
                        if mcid not in fig_lpsbimg_map:
                            fig_lpsbimg_map[mcid] = []
                    elif m.group(2):  # LPSBImg
                        imgid = int(m.group(2))
                        stack.append(('LPSBImg', imgid))
                        # Find containing Figure MCID in stack
                        for tag, val in reversed(stack[:-1]):
                            if tag == 'Figure':
                                fig_lpsbimg_map[val].append(imgid)
                                break
                    elif 'BDC' in matched:  # Other BDC
                        stack.append(('Other', None))
                    elif 'EMC' in matched:  # EMC - pop stack
                        if stack:
                            stack.pop()
                
                # Now assign LPSBImg bboxes to their Figure MCIDs
                for fig_mcid, imgids in fig_lpsbimg_map.items():
                    if not imgids:
                        continue
                    # Compute union of all LPSBImg bboxes for this Figure
                    fig_bb = None
                    for imgid in imgids:
                        img_bb = lpsbimg_bboxes.get(imgid)
                        if img_bb:
                            if fig_bb is None:
                                fig_bb = img_bb
                            else:
                                fig_bb = _merge_bbox(fig_bb, img_bb)
                    
                    if fig_bb:
                        # LPSBImg bboxes are more accurate than other sources
                        mcid_bboxes[fig_mcid] = {"bbox": fig_bb, "line_bboxes": [fig_bb], "text_preview": "", "char_count": 0}


        # Final fallback: if an MCID exists in the content stream but has no text
        # bbox (pdfplumber couldn't extract chars), draw a tiny anchor box so the
        # label doesn't look like the structure "breaks" after atoms like Reference.
        missing_any = [mc for mc in mcid_tags.keys() if mc not in mcid_bboxes]
        if missing_any:
            anchors = _estimate_mcid_anchor_bboxes(doc, page_num, mcid_tags, missing_any)
            for mcid, bb in anchors.items():
                if mcid not in mcid_bboxes:
                    mcid_bboxes[mcid] = {"bbox": bb, "line_bboxes": [bb], "text_preview": "", "char_count": 0}

        if not mcid_bboxes and not math_spans:
            continue

        # Get total MCIDs for color generation
        total_mcids = len(mcid_bboxes)

        # Build MCID -> logical element ID mapping from aux_elements
        # This allows us to show reading order based on logical elements, not MCID numbers
        mcid_to_elem_id: Dict[int, int] = {}
        elem_id_to_info: Dict[int, Dict] = {}
        elem_id_to_parent: Dict[int, int] = {}  # For atoms: elem_id -> parent_id
        if aux_elements:
            for elem in aux_elements:
                elem_id = elem.get("elem_id")
                role = elem.get("role", "?")
                parent_id = elem.get("parent_id")
                if parent_id is not None:
                    elem_id_to_parent[elem_id] = parent_id
                for m in elem.get("mcids", []):
                    mcid_val = m.get("mcid")
                    page_val = m.get("page")
                    if mcid_val is not None and page_val == page_num + 1:  # aux uses 1-based pages
                        mcid_to_elem_id[mcid_val] = elem_id
                        if elem_id not in elem_id_to_info:
                            elem_id_to_info[elem_id] = {"role": role, "mcids": [], "first_mcid": mcid_val}
                        elem_id_to_info[elem_id]["mcids"].append(mcid_val)

        # Compute a simple layout order for the page (left column top-down, then right).
        def _page_layout_order():
            local_order: Dict[int, int] = {}
            items: List[Tuple[int, float, float, int]] = []
            boundary = 0.5 * float(page.rect.width)
            for mcid, data in mcid_bboxes.items():
                bb = data.get("bbox")
                if not bb:
                    continue
                try:
                    x0, y0, x1, y1 = map(float, bb)
                except Exception:
                    continue
                col = 0 if (x0 + x1) * 0.5 < boundary else 1
                items.append((col, y0, x0, mcid))
            items.sort()
            for idx, (_c, _y, _x, mcid) in enumerate(items, 1):
                local_order[mcid] = idx
            return local_order

        # If aux/MCID coverage is poor (e.g., postprocess-injected MCIDs),
        # use layout order for labels to avoid misleading order numbers.
        mapped_count = sum(1 for mc in mcid_bboxes.keys() if mc in mcid_to_elem_id)
        coverage = mapped_count / max(1, len(mcid_bboxes))
        use_layout_order = coverage < 0.80

        local_order_by_mcid: Dict[int, int] = {}
        elem_layout_order: Dict[int, int] = {}
        if use_layout_order:
            local_order_by_mcid = _page_layout_order()
            for mcid, elem_id in mcid_to_elem_id.items():
                o = local_order_by_mcid.get(mcid)
                if o is None:
                    continue
                if elem_id not in elem_layout_order:
                    elem_layout_order[elem_id] = o
                else:
                    elem_layout_order[elem_id] = min(elem_layout_order[elem_id], o)

        # Sort MCIDs by logical element order (prefer external order_map when provided),
        # and within the same element, follow two-column reading order (left column before right).
        # NOTE: MCID numeric order is NOT reliable inside an element due to LaTeX's async output routine.
        def get_sort_key(mcid):
            elem_id = mcid_to_elem_id.get(mcid)
            if elem_id is not None:
                try:
                    eid_int = int(elem_id)
                except Exception:
                    eid_int = None
                elem_rank = order_map.get(eid_int, eid_int if eid_int is not None else 999999)

                bb = mcid_bboxes.get(mcid, {}).get("bbox")
                if bb:
                    try:
                        x0, y0, x1, y1 = map(float, bb)
                        cx = 0.5 * (x0 + x1)
                        boundary = 0.5 * float(page.rect.width)
                        col = 0 if cx < boundary else 1
                        return (elem_rank, col, y0, x0, mcid)
                    except Exception:
                        pass
                return (elem_rank, 2, 1e9, 1e9, mcid)
            else:
                # Fallback: use a large elem_id so unmapped MCIDs come last, sorted by mcid
                return (999999, 2, 1e9, 1e9, mcid)

        sorted_mcids = sorted(mcid_bboxes.keys(), key=get_sort_key)

        # Assign order numbers based on logical elements (same elem = same order)
        elem_order_map: Dict[int, int] = {}
        current_order = 0
        if not use_layout_order:
            for mcid in sorted_mcids:
                elem_id = mcid_to_elem_id.get(mcid)
                if elem_id is not None:
                    if elem_id not in elem_order_map:
                        try:
                            eid_int = int(elem_id)
                        except Exception:
                            eid_int = None
                        if eid_int is not None and eid_int in order_map:
                            elem_order_map[elem_id] = int(order_map[eid_int])
                        else:
                            current_order += 1
                            elem_order_map[elem_id] = current_order
                else:
                    # No elem_id mapping - assign unique order
                    current_order += 1
                    elem_order_map[mcid] = current_order  # Use mcid as key for unmapped

        # Pre-merge Caption MCIDs by elem_id to avoid duplicate boxes per line
        caption_line_bboxes: Dict[int, List[Tuple[float, float, float, float]]] = {}
        caption_bbox_union: Dict[int, Tuple[float, float, float, float]] = {}
        caption_drawn: Set[int] = set()
        y_tol = 3.0
        for mcid, data in mcid_bboxes.items():
            if mcid_tags.get(mcid) != "Caption":
                continue
            elem_id = mcid_to_elem_id.get(mcid)
            if elem_id is None:
                continue
            # Aggregate line bboxes across all MCIDs for the same Caption element
            caption_line_bboxes.setdefault(elem_id, [])
            caption_line_bboxes[elem_id].extend(data.get("line_bboxes", [data["bbox"]]))

        for elem_id, bbs in caption_line_bboxes.items():
            # Merge boxes per line (y proximity) to avoid stacked duplicates
            merged_lines: List[Tuple[float, float, float, float]] = []
            for bb in sorted(bbs, key=lambda b: (b[1], b[0])):
                if not merged_lines:
                    merged_lines.append(bb)
                    continue
                last = merged_lines[-1]
                if abs(bb[1] - last[1]) <= y_tol:
                    merged_lines[-1] = _merge_bbox(last, bb)
                else:
                    merged_lines.append(bb)
            caption_line_bboxes[elem_id] = merged_lines
            # Union bbox for label positioning
            overall = merged_lines[0]
            for bb in merged_lines[1:]:
                overall = _merge_bbox(overall, bb)
            caption_bbox_union[elem_id] = overall

        # Draw boxes for each MCID
        for mcid in sorted_mcids:
            data = mcid_bboxes[mcid]
            bbox = data['bbox']  # Overall bbox for label positioning
            line_bboxes = data.get('line_bboxes', [bbox])  # Per-line boxes for drawing

            # Get tag type
            tag_type = mcid_tags.get(mcid, '?')
            if tag_type == "Table":
                # We'll draw a merged Table bbox using aux structure.
                continue

            # Collapse Caption MCIDs that belong to the same elem_id
            if tag_type == "Caption":
                elem_id = mcid_to_elem_id.get(mcid)
                if elem_id is not None:
                    if elem_id in caption_drawn:
                        continue
                    caption_drawn.add(elem_id)
                    line_bboxes = caption_line_bboxes.get(elem_id, line_bboxes)
                    bbox = caption_bbox_union.get(elem_id, bbox)

            # Get logical order
            elem_id = mcid_to_elem_id.get(mcid)
            if use_layout_order:
                if elem_id is not None and elem_id in elem_layout_order:
                    order = elem_layout_order[elem_id]
                else:
                    order = local_order_by_mcid.get(mcid, mcid)
            else:
                if elem_id is not None:
                    order = elem_order_map.get(elem_id, mcid)
                else:
                    order = elem_order_map.get(mcid, mcid)

            # Generate color based on tag type for consistency
            tag_colors = {
                'P': (0.2, 0.6, 0.2),      # Green for paragraphs
                'H1': (0.8, 0.2, 0.2),     # Red for H1
                'H2': (0.7, 0.3, 0.3),     # Lighter red for H2
                'H3': (0.6, 0.4, 0.4),     # Even lighter for H3
                'LI': (0.2, 0.4, 0.8),     # Blue for list items
                'L': (0.3, 0.5, 0.7),      # Lighter blue for list
                'Strong': (0.6, 0.3, 0.6), # Purple for strong
                'Em': (0.5, 0.4, 0.7),     # Light purple for emphasis
                'Figure': (0.8, 0.6, 0.2), # Orange for figures
                'Table': (0.7, 0.5, 0.3),  # Brown for tables
            }
            color = tag_colors.get(tag_type, generate_color(mcid, total_mcids))

            # Float tags (Figure/Table/Formula) use merged bbox; Caption should be line-based
            float_tags = {'Figure', 'Table', 'Formula'}
            if tag_type in float_tags:
                draw_bboxes = [bbox]
            else:
                draw_bboxes = line_bboxes

            # Draw semi-transparent filled rectangle for each bbox
            for line_bb in draw_bboxes:
                rect = fitz.Rect(line_bb[0], line_bb[1], line_bb[2], line_bb[3])
                shape = page.new_shape()
                shape.draw_rect(rect)
                shape.finish(color=color, fill=color, fill_opacity=0.15, width=1.5)
                shape.commit()

            # Label: TagType#Order (e.g., P#1, H1#2) - placed at top-left of first line
            label = f"{tag_type}#{order}"

            # Position label at top-left of first line bbox
            first_bb = line_bboxes[0] if line_bboxes else bbox
            label_x = first_bb[0]
            label_y = first_bb[1] - 3

            # Draw label background (filled rectangle)
            text_width = len(label) * 6 + 6
            label_rect = fitz.Rect(label_x - 1, label_y - 12, label_x + text_width, label_y + 2)
            page.draw_rect(label_rect, color=color, fill=color)
            
            # Draw label text (white on colored background)
            page.insert_text(fitz.Point(label_x + 2, label_y), label, fontsize=9, color=(1, 1, 1))

        # Draw merged table boxes (one per logical Table element), using stroke-only border detection.
        if table_mcids_on_page:
            # Detect tables from content stream BDC markers.
            tables: List[Dict] = []
            if aux_elements and table_mcid_to_elem:
                # Preferred: map MCID -> logical Table elem_id using aux.
                by_elem: Dict[int, Dict] = {}
                for mcid in table_mcids_on_page:
                    elem_id = table_mcid_to_elem.get(mcid, mcid)  # fallback to mcid if unmapped
                    by_elem.setdefault(elem_id, {"elem_id": elem_id, "mcids": [], "hint_bbox": None})
                    by_elem[elem_id]["mcids"].append(mcid)
                tables = [by_elem[k] for k in sorted(by_elem.keys())]
            else:
                # No aux: auto-group MCIDs into table instances by hint overlap.
                auto = _group_table_mcids_auto(table_mcids_on_page, mcid_bboxes)
                for idx, g in enumerate(auto, 1):
                    tables.append({"elem_id": f"mcidgrp{idx}", "mcids": g["mcids"], "hint_bbox": g.get("hint_bbox")})

            if tables:
                bbs = _detect_table_border_bboxes(page, expected=0)
                unused = list(bbs)
                table_color = (0.0, 0.0, 0.0)
                for i, t in enumerate(tables):
                    # Hint bbox from MCID text (if available): tends to respect scalebox.
                    hint = t.get("hint_bbox")
                    if hint is None:
                        for mcid in t.get("mcids", []):
                            b = mcid_bboxes.get(mcid, {}).get("bbox")
                            if not b:
                                continue
                            b = tuple(b)
                            hint = _merge_bbox(hint, b) if hint else b

                    bbox = None
                    # Best case: tight border from rules near hint.
                    if hint:
                        bbox = _detect_table_bbox_near_hint(page, hint)

                    # Only use rule-based candidates if _detect_table_bbox_near_hint returned None.
                    # This prevents incorrect rule-boxes (which may group multiple tables together)
                    # from overwriting the accurate hint-based detection.
                    if bbox is None and hint and unused:
                        # Pick the rule-box that overlaps the table text bbox best.
                        best = None
                        best_iou = 0.0
                        for cand in unused:
                            sc = _iou(hint, cand)
                            if sc > best_iou:
                                best_iou = sc
                                best = cand
                        # Require significant overlap; otherwise the rule box is likely wrong.
                        if best is not None and best_iou >= 0.20:
                            bbox = best
                            try:
                                unused.remove(best)
                            except ValueError:
                                pass

                    if bbox is None and unused:
                        # No hint or no good overlap: take the top-most remaining candidate.
                        bbox = unused.pop(0)

                    if bbox is None:
                        # Final fallback: use hint itself.
                        bbox = hint

                    # If the detected bbox is suspiciously small vs hint, use hint.
                    if hint and bbox:
                        try:
                            if _bbox_area(bbox) < 0.4 * _bbox_area(hint) or _iou(bbox, hint) < 0.10:
                                bbox = hint
                        except Exception:
                            bbox = hint

                    if not bbox:
                        continue
                    rect = fitz.Rect(bbox[0], bbox[1], bbox[2], bbox[3])
                    shape = page.new_shape()
                    shape.draw_rect(rect)
                    shape.finish(color=table_color, fill=None, width=2.0)
                    shape.commit()

                    label = f"Table@{t['elem_id']}"
                    label_x = bbox[0]
                    label_y = bbox[1] - 3
                    text_width = len(label) * 6 + 6
                    label_rect = fitz.Rect(label_x - 1, label_y - 12, label_x + text_width, label_y + 2)
                    page.draw_rect(label_rect, color=table_color, fill=table_color)
                    page.insert_text(fitz.Point(label_x + 2, label_y), label, fontsize=8, color=(1, 1, 1))

        # Draw math spans (heuristic fallback, not MCID-based)
        if math_spans:
            math_color = (0.85, 0.0, 0.85)  # magenta
            for i, s in enumerate(math_spans, 1):
                bbox = s["bbox"]
                rect = fitz.Rect(bbox[0], bbox[1], bbox[2], bbox[3])
                shape = page.new_shape()
                shape.draw_rect(rect)
                shape.finish(color=math_color, fill=math_color, fill_opacity=0.0, width=1.0)
                shape.commit()

                label = f"MATH#{i}"
                label_x = bbox[0]
                label_y = bbox[1] - 3
                text_width = len(label) * 6 + 6
                label_rect = fitz.Rect(label_x - 1, label_y - 12, label_x + text_width, label_y + 2)
                page.draw_rect(label_rect, color=math_color, fill=math_color)
                page.insert_text(fitz.Point(label_x + 2, label_y), label, fontsize=8, color=(1, 1, 1))
        
        # Add legend at top of page
        legend_y = 20
        legend_text = f"Page {page_num + 1}: {len(mcid_bboxes)} MCIDs"
        legend_text += f" | {len(math_spans)} math spans"
        legend_text += " | merged tables"
        legend_text += " | Format: TagType#ReadingOrder"
        if use_layout_order:
            legend_text += " (layout)"
        page.insert_text(fitz.Point(10, legend_y), legend_text, fontsize=10, color=(0, 0, 0))
    
    # Save
    doc.save(output_path)
    doc.close()
    plumber.close()
    
    print(f"Visualization saved to: {output_path}")
    return output_path


def main():
    parser = argparse.ArgumentParser(description='Visualize MCID tags on PDF')
    parser.add_argument('input_pdf', help='Input PDF file path')
    parser.add_argument('-o', '--output', help='Output PDF path (default: input_mcid_viz.pdf)')
    
    args = parser.parse_args()
    
    input_path = Path(args.input_pdf)
    if not input_path.exists():
        print(f"Error: {input_path} not found")
        return 1
    
    output_path = args.output or str(input_path.with_suffix('.mcid_viz.pdf'))
    
    visualize_mcid(
        str(input_path),
        output_path,
    )
    return 0


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py visualize-mcid ...
