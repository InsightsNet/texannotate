import colorsys
import os
import pickle

from spacy.lang.en import English
from spacy.tokenizer import Tokenizer


class TOCNode:
    def __init__(self, section_id, level=-1):
        self.section_id = section_id
        self.level = level
        self.children = []

    def add_child(self, child):
        self.children.append(child)
    
    def export(self):
        if self.section_id > 0:
            ret = str(self.section_id) + "\n"
        else:
            ret = ''
        for child in self.children:
            ret +=  str(self.section_id) + '\t' + child.export()
        return ret
    

class TableOfContents:
    level2macro = ['title', 'part', 'chapter', 'section', 'subsection', 'subsubsection', 'paragraph', 'subparagraph']
    macro2level = {v:k for k, v in enumerate(level2macro)}
    def __init__(self):
        self.root = TOCNode(0)
        self.current_node = self.root
        self.current_section_id = 0

    def add_node(self, macro):
        if macro not in self.macro2level:
            print(f"Invalid grading: {macro}. Please use one of {', '.join(self.level2macro)}")
            return

        # Determine the depth where the new node should be inserted
        depth = self.macro2level[macro]

        # Navigate back to the correct parent for this grading
        while self.current_node.level >= depth:
            self.current_node = self._find_parent(self.current_node)

        # Create the new node and make it a child of the current node
        new_node = TOCNode(self.current_section_id+1, depth)
        self.current_node.add_child(new_node)

        # Set the current node to the newly added node
        self.current_node = new_node
        self.current_section_id += 1

    def _find_parent(self, node):
        """Find parent of a node in the tree starting from root. Return None if parent is not found."""
        nodes_to_check = [self.root]
        while nodes_to_check:
            current_node = nodes_to_check.pop()
            if node in current_node.children:
                return current_node
            nodes_to_check.extend(current_node.children)
        return None
    
    def get_current_section_id(self):
        assert self.current_node.section_id == self.current_section_id
        return self.current_node.section_id

    def export_toc(self):
        s = self.root.export()
        ret = []
        for line in s[:-1].split('\n'):
            if line:
                head, section_id = line.split('\t')
                ret.append((int(section_id), int(head)))
        return ret


def generate_rainbow_colors():  # number of color in one color
    if os.path.isfile('data/rainbow_colors_list.pkl'):
        return pickle.load(open('data/rainbow_colors_list.pkl', 'rb'))
    
    all_colors = []
    all_colors_set = set()

    # Define steps for hue, saturation, and value
    hue_list = []
    for i in range(0, 359):
        hue_list.append(i/359)

    splited_hue_list = [hue_list[i::5] for i in range(5)]

    s_v_list = []
    for s in [i for i in range(256, 50, -1)]: 
        for v in [i for i in range(256, 50, -1)]:
            s_v_list.append([s/256, v/256])
    #print("num of s_v set: ", len(s_v_list))

    hue_list = []
    for s_v in s_v_list:
        for sub_hue_list in splited_hue_list:
            for hue in sub_hue_list:
                h = hue; s = s_v[0]; v = s_v[1]
                r, g, b = [int(x * 255) for x in colorsys.hsv_to_rgb(h, s, v)]
                #print((hue/10, s/100, v/100), "\t", (r, g, b))
                if (r, g, b) not in all_colors_set:
                    all_colors_set.add((r, g, b))
                    all_colors.append((r, g, b))
    #print("num of color: ", len(all_colors))
    pickle.dump(all_colors, open('data/rainbow_colors_list.pkl', 'wb'))
    return all_colors


class ColorAnnotation:
    def __init__(self) -> None:
        self.color_dict = {}
        self.current_RGB = 0
        self.current_rgb = 0
        self.current_token_number = 0
        self.toc = TableOfContents()
        self.block_num = 0
        self.current_section_id = []
        self.all_color = generate_rainbow_colors()
        self.black = False

        nlp = English()
        self.tokenizer = Tokenizer(nlp.vocab)

    def _get_next_rgb(self):
        assert self.current_rgb < 1331, "rgb reach upper limit"
        rgb_tuple = (self.current_rgb//121, self.current_rgb%121//11, self.current_rgb%121%11)
        self.current_rgb += 1
        rgb_string = []
        for rgb in rgb_tuple:
            if rgb > 10:
                raise "color error"
            elif rgb == 10:
                rgb_string.append("1")
            else:
                rgb_string.append("0.%d" % (rgb))
        return ",".join(rgb_string)
    
    def _get_next_RGB(self):
        assert self.current_RGB < len(self.all_color), "RGB reach upper limit"
        #hex_string = self.int_to_hex_string(self.current_RGB)
        #RGB_tuple = self.hex_to_RGB(hex_string)
        RGB_tuple = self.all_color[self.current_RGB]
        hex_string = self.tuple_to_hex_string(RGB_tuple)
        self.current_RGB += 1
        return str(RGB_tuple)[1:-1], hex_string

    def __getitem__(self, key):
        return self.color_dict[key]
    
    def tuple_to_hex_string(self, tup):
        return '#%02x%02x%02x' % tup

    def int_to_hex_string(self, num: int):
        return "#%06x" % (num)

    def hex_to_RGB(self, value: str):
        value = value.lstrip('#')
        lv = len(value)
        return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))
    
    def add_existing_color(self, color_str):
        self.color_dict[color_str] = None

    def add_annotation_RGB(self, tex_string, annotate):
        if self.black:
            RGB_tuple = '0, 0, 0'
        else:
            RGB_tuple, hex_string = self._get_next_RGB()
            while hex_string in self.color_dict:
                RGB_tuple, hex_string = self._get_next_RGB()
            self.color_dict[hex_string] = {
                "label": annotate,
                "reading": self.current_token_number,
                "section": self.toc.get_current_section_id(),
                "block": self.block_num,
                "tex": tex_string
            }
        self.current_token_number += 1
        return "{\\color[RGB]{" + RGB_tuple + "}" + tex_string + "}"

    def add_annotation_rgb(self, tex_string, annotate):
        if self.black:
            rgb_tuple = '1, 1, 1'
        else:
            rgb_tuple = self._get_next_rgb()
            while rgb_tuple in self.color_dict:
                rgb_tuple = self._get_next_rgb()
            self.color_dict[rgb_tuple] = {
                "label": annotate,
                "reading": self.current_token_number,
                "section": self.toc.get_current_section_id(),
                "block": self.block_num,
                "tex": tex_string
            }
        self.current_token_number += 1
        return "\\colorbox[rgb]{" + rgb_tuple + "}{" + tex_string + "}"
