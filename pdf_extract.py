#import fitz
import pdfplumber
from matplotlib.colors import to_hex

def extract_shapes(pdf_bytes: bytes):
    with pdfplumber.open(pdf_bytes) as doc:
        return doc.rects


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


def convert_color(non_stroking_color):
    assert type(non_stroking_color) == tuple
    if len(non_stroking_color) < 3:
        return '#000000'
    else:
        return to_hex(non_stroking_color)


def extract_tokens(pdf_bytes: bytes):
    tokens = []
    with pdfplumber.open(pdf_bytes) as doc:
        for page in doc.pages:
            texts = page.extract_words(x_tolerance=3, y_tolerance=3, keep_blank_chars=False, use_text_flow=True, horizontal_ltr=True, vertical_ttb=True, extra_attrs=["fontname", "size", "non_stroking_color", "y0", "y1"], split_at_punctuation=False, expand_ligatures=True)
            for token in texts:
                tokens.append({
                    "page": page.page_number,
                    "text": token["text"],
                    "font": token["fontname"],
                    "size": token["size"],
                    "color": convert_color(token["non_stroking_color"]),
                    "bbox": (token["x0"], token["y0"], token["x1"], token["y1"]),
                    "flags":None
                })
    return tokens
    """with fitz.open("pdf", pdf_bytes) as doc:
        tokens = []
        for page in doc:
            # read page text as a dictionary, suppressing extra spaces in CJK fonts
            blocks = page.get_text("dict", flags=fitz.TEXT_PRESERVE_LIGATURES|fitz.TEXT_PRESERVE_WHITESPACE)["blocks"]
            for b in blocks:  # iterate through the text blocks
                for l in b["lines"]:  # iterate through the text lines
                    for s in l["spans"]:  # iterate through the text spans
                        font_properties = {
                            "page": page.number,
                            "text": s["text"],
                            "font": s["font"],  # font name
                            "flags": flags_decomposer(s["flags"]),  # readable font flags
                            "size": s["size"],  # font size
                            "color": s["color"],  # font color
                            "bbox": s["bbox"]
                        }
                        tokens.append(font_properties)
    return tokens"""


def pdf_extract(pdf_bytes: bytes):
    return extract_shapes(pdf_bytes), extract_tokens(pdf_bytes)