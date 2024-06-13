import fitz
import pdfplumber
from matplotlib.colors import to_hex
import numpy as np


def extract_shapes(pdf_bytes: bytes):
    ret = []
    with pdfplumber.open(pdf_bytes) as doc:
        rects = doc.rects
        for rect in rects:
            page = doc.pages[rect['page_number']-1]
            r = rect
            r['y0'] = page.height - rect['y1']
            r['y1'] = r['y0'] + rect['height']
            r['page_size'] = [page.height, page.width]
            ret.append(r)
    return ret


def flags_decomposer(flags):
    """Make font flags human readable."""
    l = []
    if flags & 2 ** 0:
        l.append("superscript")
    if flags & 2 ** 1:
        l.append("italic")
    if flags & 2 ** 2:
        l.append("serifed")
    else:
        l.append("sans")
    if flags & 2 ** 3:
        l.append("monospaced")
    else:
        l.append("proportional")
    if flags & 2 ** 4:
        l.append("bold")
    return l


def token_in_bbox(token, bbox) -> bool:
    """From https://github.com/jsvine/pdfplumber/blob/stable/pdfplumber/table.py#L404"""
    v_mid = (token["top"] + token["bottom"]) / 2
    h_mid = (token["x0"] + token["x1"]) / 2
    x0, top, x1, bottom = bbox
    return bool(
        (h_mid >= x0) and (h_mid < x1) and (v_mid >= top) and (v_mid < bottom)
    )


def convert_color(non_stroking_color):
    if non_stroking_color is None:
        return '#000000'
    assert type(non_stroking_color) == tuple
    if len(non_stroking_color) < 3:
        return '#000000'
    elif max(non_stroking_color) > 1 or min(non_stroking_color) < 0:
        return '#000000' # invalid color, may due to pdfblumber's bug
    else:
        return to_hex(non_stroking_color)


def select_token(page_dic: dict, rect: fitz.Rect) -> dict:
    blocks = []
    for block in page_dic["blocks"]:
        blocks.append(fitz.Rect(block['bbox']).intersect(rect).get_area())
    block = page_dic["blocks"][np.argmax(blocks)]
    lines = []
    for line in block["lines"]:
        lines.append(fitz.Rect(line['bbox']).intersect(rect).get_area())
    line = block["lines"][np.argmax(lines)]
    spans = []
    for span in line["spans"]:
        spans.append(fitz.Rect(span['bbox']).intersect(rect).get_area())
    span = line["spans"][np.argmax(spans)]
    return span


def extract_tokens(pdf_bytes: bytes):
    tokens = []
    with pdfplumber.open(pdf_bytes) as doc:
        with fitz.open("pdf", pdf_bytes) as fitz_doc:
            for page in doc.pages:
                lines_bbox = []
                fitz_page = fitz_doc[page.page_number-1]
                blocks = fitz_page.get_text("dict", flags=11)["blocks"]
                for b in blocks:  # iterate through the text blocks
                    for l in b["lines"]:  # iterate through the text lines
                        lines_bbox.append(l["bbox"])

                texts = page.extract_words(x_tolerance=3, y_tolerance=3, keep_blank_chars=False, use_text_flow=True, horizontal_ltr=True, vertical_ttb=True, extra_attrs=["fontname", "size", "non_stroking_color", "y0", "y1"], split_at_punctuation=False, expand_ligatures=True)
                for token in texts:
                    bbox = (token["x0"], token["top"], token["x1"], token["bottom"])
                    rect_from_pdfplumber = fitz.Rect(bbox)
                    page_dic = fitz_page.get_text("dict", clip=fitz.Rect(bbox), flags=fitz.TEXT_PRESERVE_LIGATURES|fitz.TEXT_PRESERVE_WHITESPACE) # ["blocks"][0]["lines"][0]["spans"][0]
                    if page_dic["blocks"]:
                        s = select_token(page_dic, rect_from_pdfplumber)
                    else:
                        continue

                    line_no = None
                    for i, line_bbox in enumerate(lines_bbox):
                        if token_in_bbox(token, line_bbox):
                            line_no = i
                    if not line_no is None:
                        tokens.append({
                            "page_no": page.page_number,
                            "text": token["text"],
                            "font": s["font"],
                            "font_size": s["size"],
                            "color": convert_color(token["non_stroking_color"]),
                            "bbox": bbox,
                            "page_size": [page.height, page.width],
                            "flags": flags_decomposer(s["flags"]),
                            "line_no": line_no
                        })
                    else:
                        raise "token does not belong to any line, please check cropbox."
    return tokens


def pdf_extract(pdf_bytes: bytes):
    return extract_shapes(pdf_bytes), extract_tokens(pdf_bytes)