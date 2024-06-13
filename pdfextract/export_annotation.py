import pandas as pd
from texannotate.color_annotation import ColorAnnotation
from dataclasses import make_dataclass
from utils.utils import tup2str


Data = make_dataclass("Data", [
    ("reading_order", int), 
    ("label", str),
    ("block_id", int),
    ("section_id", int),
    ("text", str),
    ("page_no", int),
    ("x0", float),
    ("y0", float),
    ("x1", float),
    ("y1", float),
    ("font", str),
    ("font_size", float),
    ("flags", list),
    ("tex", str),
    ("page_size", list),
    ("line_no", int)
])

TOC = make_dataclass("TOC", [
    ("section_id", int),
    ("nested_to", int)
])
#COLUMNS = ['reading_order', 'label', 'block_id', 'section_id', 'token', 'page', 'x0', 'y0', 'x1', 'y1', 'font', 'size', 'flags', 'tex']
def export_annotation(shapes, tokens, color_dict: ColorAnnotation) -> pd.DataFrame:
    data = []
    for token in tokens:
        x0, y0, x1, y1 = token["bbox"]
        color = token['color'] # "#%06x" % token["color"]
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(
                annotate['reading'], 
                annotate['label'], 
                annotate['block'], 
                annotate['section'],
                token['text'], 
                token['page_no'], 
                x0, y0, x1, y1,
                token['font'], 
                token['font_size'], 
                token['flags'], 
                annotate['tex'],
                token['page_size'],
                token['line_no']
            ))
            if len(data)>1 and data[-1].reading_order==data[-2].reading_order:
                data[-1].tex = '' # eliminate duplicate tex code cell for e.g. table, math equation
        else:
            data.append(Data(
                -1, 
                None, 
                -1, 
                -1,
                token['text'], 
                token['page_no'], 
                x0, y0, x1, y1,
                token['font'], 
                token['font_size'], 
                token['flags'],
                '',
                token['page_size'],
                token['line_no']
            ))

    # line based label diffusion
    offset = 0
    for i, d in enumerate(data):
        if not d.label is None: 
            d.reading_order += offset
        else:
            window_left = i-20 if i>20 else 0
            left_neighbour = []
            for neighbour in data[window_left:i]:
                if neighbour.line_no == d.line_no and not neighbour.label is None:
                    left_neighbour.append(neighbour)

            window_right = i+20 # if i+20<len(data) else len(data)
            right_neighbour = []
            for neighbour in data[i+1:window_right]: # out-of-range list slicing returns []
                if neighbour.line_no == d.line_no and not neighbour.label is None:
                    right_neighbour.append(neighbour)

            if not left_neighbour+right_neighbour: # independent token e.g. page number
                continue
            elif not left_neighbour: # leftmost token of the line
                for neighbour in right_neighbour:
                    if not neighbour.label is None:
                        d.reading_order = neighbour.reading_order+offset
                        d.label = neighbour.label
                        d.block_id = neighbour.block_id
                        d.section_id = neighbour.section_id
                        offset += 1
                        break
            elif not right_neighbour: # rightmost
                for neighbour in left_neighbour[::-1]:
                    if not neighbour.label is None:
                        d.reading_order = neighbour.reading_order+1
                        d.label = neighbour.label
                        d.block_id = neighbour.block_id
                        d.section_id = neighbour.section_id
                        offset += 1
                        break
            else: # middle
                vote = {}
                for neighbour in left_neighbour+right_neighbour:
                    if neighbour.label in vote:
                        vote[neighbour.label] += 1
                    else:
                        vote[neighbour.label] = 1
                if vote:
                    neighbour = left_neighbour[-1]
                    d.reading_order = neighbour.reading_order+1
                    d.block_id = neighbour.block_id
                    d.section_id = neighbour.section_id
                    d.label = max(vote, key=vote.get)
                    offset += 1
                else:
                    pass

    for rect in shapes:
        color = tup2str(rect['stroking_color'])
        if color in color_dict.color_dict and not color_dict[color] is None:
            annotate = color_dict[color]
            data.append(Data(
                annotate['reading']+offset, 
                annotate['label'], 
                annotate['block'], 
                annotate['section'],
                None, 
                rect['page_number'], 
                rect['x0'], rect['y0'], rect['x1'], rect['y1'], 
                None, 
                None, 
                None, 
                annotate['tex'],
                rect['page_size'],
                -1
            ))
    # TODO: filter out in-figure tokens

    toc = []
    # add toc root node
    toc.append(TOC(0, -1))
    for section_id, head in color_dict.toc.export_toc():
        toc.append(TOC(section_id, head))

    return pd.DataFrame(toc), pd.DataFrame(data)