import pandas as pd
from color_annotation import Color_Annotation
from dataclasses import make_dataclass
from util import tup2str


Data = make_dataclass("Data", [
    ("reading_order", int), 
    ("label", str),
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
COLUMNS = ['reading_order', 'label', 'head', 'token', 'page', 'x0', 'y0', 'x1', 'y1', 'font', 'size', 'flags']
def export_annotation(shapes, tokens, color_dict: Color_Annotation) -> pd.DataFrame:
    data = []
    for rect in shapes:
        color = tup2str(rect['stroking_color'])
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], None, # placeholder for section nr.
                             None, rect['page_number'], rect['x0'], rect['y0'], 
                             rect['x1'], rect['y1'], None, None, None))
    
    for token in tokens:
        x0, y0, x1, y1 = token["bbox"]
        color = token['color'] # "#%06x" % token["color"]
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(annotate['reading'], annotate['label'], None, # placeholder for section nr.
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags']))
        else:
            data.append(Data(None, None, None,
                            token['text'], token['page'], x0, y0, x1, y1,
                            token['font'], token['size'], token['flags']))
            
    return pd.DataFrame(data)