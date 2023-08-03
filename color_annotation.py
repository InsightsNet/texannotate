from spacy.tokenizer import Tokenizer
from spacy.lang.en import English


class Color_Annotation:
    def __init__(self) -> None:
        self.color_dict = {}
        self.current_RGB = 0
        self.current_rgb = 0
        self.current_token_number = 0
        self.current_section_id = []
        
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
        assert self.current_RGB < 16777216, "RGB reach upper limit"
        hex_string = self.int_to_hex_string(self.current_RGB)
        RGB_tuple = self.hex_to_RGB(hex_string)
        self.current_RGB += 1
        return str(RGB_tuple)[1:-1], hex_string

    def int_to_hex_string(self, num: int):
        return "#%06x" % (num)

    def hex_to_RGB(self, value: str):
        value = value.lstrip('#')
        lv = len(value)
        return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))
    
    def add_existing_color(self, color_str):
        self.color_dict[color_str] = None

    def add_annotation_RGB(self, tex_string, annotate):
        RGB_tuple, hex_string = self._get_next_RGB()
        while hex_string in self.color_dict:
            RGB_tuple, hex_string = self._get_next_RGB()
        self.color_dict[hex_string] = {
            "label": annotate,
            "reading": self.current_token_number,
            #"section": self.current_section_id[-1],
        }
        return "{\\color[RGB]{" + RGB_tuple + "}" + tex_string + "}"

    def add_annotation_rgb(self, tex_string, annotate):
        rgb_tuple = self._get_next_rgb()
        while rgb_tuple in self.color_dict:
            rgb_tuple = self._get_next_rgb()
        self.color_dict[rgb_tuple] = {
            "label": annotate,
            "reading": self.current_token_number,
            #"section": self.current_section_id[-1],
        }
        return "\\colorbox[rgb]{" + rgb_tuple + "}{" + tex_string + "}"
