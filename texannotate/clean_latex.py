from utils.utils import find_latex_file
from pylatexenc.latexnodes.nodes import LatexMacroNode
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
import chardet
import os

def clean_latex(filename, basepath, latex_context):
    cleaned = ''
    removed = {}
    fullpath = find_latex_file(filename, basepath)
    files = os.listdir(basepath)  # Get all the files in that directory
    print("Files in %s" % (files))
    try:
        with open(fullpath, 'rb') as f:
            encodingInfo = chardet.detect(f.read()) # detect charset
            if encodingInfo['encoding'] == 'HZ-GB-2312':
                encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
        with open(fullpath, encoding=encodingInfo['encoding']) as f:
            tex_string = f.read()
    except IOError as e:
        print(e)
        return False, False
        
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    parsing_state.enable_environments = False
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    for node in nodelist:
        if node.isNodeType(LatexMacroNode):
            if node.macroname in {'newcommand', 'renewcommand', 'newenvironment', 'renewenvironment', 'providecommand', 'CheckCommand'}:
                key = str(id(node))
                removed[key] = tex_string[node.pos:node.pos_end]
                cleaned += r'\LaTeXRainbowSpecial{' + str(id(node)) + '}\n'
                continue
        cleaned += tex_string[node.pos:node.pos_end]
    return cleaned, removed


def post_cleaned(tex_string, removed, latex_context):
    restored = ''
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    parsing_state.enable_environments = False
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    for node in nodelist:
        if node.isNodeType(LatexMacroNode) and node.macroname == "LaTeXRainbowSpecial":
            key = node.nodeargs[0].nodelist[0].chars
            restored += removed[key]
        else:
            restored += tex_string[node.pos:node.pos_end]

    return restored