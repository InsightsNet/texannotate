import pandas as pd
from texannotate.color_annotation import ColorAnnotation
from dataclasses import make_dataclass
from util import tup2str


Data = make_dataclass("Data", [
    ("reading_order", int), 
    ("label", str),
    ("section", int),
    ("head", int),
    ("token", str),
    ("page", int),
    ("x0", float),
    ("y0", float),
    ("x1", float),
    ("y1", float),
    ("font", str),
    ("size", float),
    ("flags", list),
])
COLUMNS = ['reading_order', 'label', 'section', 'head', 'token', 'page', 'x0', 'y0', 'x1', 'y1', 'font', 'size', 'flags']
def export_annotation(shapes, tokens, color_dict: ColorAnnotation) -> pd.DataFrame:
    data = []

    # add toc root node
    data.append(Data(-1, 'TOCNode', 0, -1, None, 0, 0, 0, 0, 0, None, 0, None))
    toc_head = {}
    for section_id, head in color_dict.toc.export_toc():
        data.append(Data(-1, 'TOCNode', head, section_id, None, 0, 0, 0, 0, 0, None, 0, None))
        toc_head[section_id] = head 

    for rect in shapes:
        color = tup2str(rect['stroking_color'])
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], annotate['section'], toc_head[annotate['section']],
                             None, rect['page_number'], rect['x0'], rect['y0'], 
                             rect['x1'], rect['y1'], None, None, None))
    
    for token in tokens:
        x0, y0, x1, y1 = token["bbox"]
        color = token['color'] # "#%06x" % token["color"]
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], annotate['section'], toc_head[annotate['section']],
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags']))
        else:
            data.append(Data(-1, None, -1, -1,
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags']))
            
    return pd.DataFrame(data)