import fitz
import pdfplumber


def extract_shapes(pdf_bytes: bytes):
    with pdfplumber.open(pdf_bytes) as doc:
        return [rect['stroking_color'] for rect in doc.rects]


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


def extract_tokens(pdf_bytes: bytes):
    with fitz.open(pdf_bytes) as doc:
        tokens = []
        for page in doc:
            # read page text as a dictionary, suppressing extra spaces in CJK fonts
            blocks = page.get_text("dict", flags=11)["blocks"]
            for b in blocks:  # iterate through the text blocks
                for l in b["lines"]:  # iterate through the text lines
                    for s in l["spans"]:  # iterate through the text spans
                        font_properties = {
                            "text": s["text"],
                            "font": s["font"],  # font name
                            "flags": flags_decomposer(s["flags"]),  # readable font flags
                            "size": s["size"],  # font size
                            "color": s["color"],  # font color
                        }
                        tokens.append(font_properties)
    return tokens


def extract_pdf(pdf_bytes: bytes):
    return extract_shapes(pdf_bytes), extract_tokens(pdf_bytes)