import pandas as pd
from texannotate.color_annotation import ColorAnnotation
from dataclasses import make_dataclass
from utils.utils import tup2str


Data = make_dataclass("Data", [
    ("reading_order", int), 
    ("label", str),
    ("block_id", int),
    ("section_id", int),
    ("token", str),
    ("page", int),
    ("x0", float),
    ("y0", float),
    ("x1", float),
    ("y1", float),
    ("font", str),
    ("size", float),
    ("flags", list),
    ("tex", str)
])

TOC = make_dataclass("TOC", [
    ("section_id", int),
    ("nested_to", int)
])
#COLUMNS = ['reading_order', 'label', 'block_id', 'section_id', 'token', 'page', 'x0', 'y0', 'x1', 'y1', 'font', 'size', 'flags', 'tex']
def export_annotation(shapes, tokens, color_dict: ColorAnnotation) -> pd.DataFrame:
    data = []
    for rect in shapes:
        color = tup2str(rect['stroking_color'])
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], annotate['block'], annotate['section'],
                             None, rect['page_number'], rect['x0'], rect['y0'], 
                             rect['x1'], rect['y1'], None, None, rect['flags'], annotate['tex']))
    
    for token in tokens:
        x0, y0, x1, y1 = token["bbox"]
        color = token['color'] # "#%06x" % token["color"]
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], annotate['block'], annotate['section'],
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags'], annotate['tex']))
        else:
            data.append(Data(-1, None, -1, -1,
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags'], ''))
    
    toc = []
    # add toc root node
    toc.append(TOC(0, -1))
    for section_id, head in color_dict.toc.export_toc():
        toc.append(TOC(section_id, head))

    return pd.DataFrame(toc), pd.DataFrame(data)