from utils.utils import find_latex_file
from pylatexenc.latexnodes.nodes import LatexMacroNode
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
from texannotate.de_macro import de_macro
import chardet
import os


def remove_mismatched_braces(latex_content):
    stack = []  # Stack to keep track of open braces and their indices
    remove_indices = []  # Indices of braces to remove
    
    i = 0  # Manual index control to allow for skipping characters

    while i < len(latex_content):
        char = latex_content[i]

        # Handle escaped braces
        if char == '\\' and i + 1 < len(latex_content) and latex_content[i + 1] in "{}":
            i += 2  # Skip the next character since it's escaped
            continue

        if char == '{':
            stack.append(('open', i))  # Push the index and type of the brace
        elif char == '}':
            if stack and stack[-1][0] == 'open':
                stack.pop()  # Pop the last open brace as it's now closed
            else:
                remove_indices.append(i)  # Mark unmatched closing brace for removal

        i += 1

    # Add indices of unclosed opening braces to the removal list
    remove_indices.extend([index for brace_type, index in stack if brace_type == 'open'])

    # Remove the mismatched braces by building a new string without them
    new_content = ''.join(char for i, char in enumerate(latex_content) if i not in remove_indices)

    return new_content


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
    tex_string = remove_mismatched_braces(tex_string)
    tex_string = de_macro(tex_string)
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    parsing_state.enable_environments = False
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    for node in nodelist:
        if node.isNodeType(LatexMacroNode): # remove these macro form annotation
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

def read_preamble(filename, basepath):
    fullpath = find_latex_file(filename, basepath)
    files = os.listdir(basepath)  # Get all the files in that directory
    print("Files in %s" % (files))
    preamble = ""
    try:
        with open(fullpath, 'rb') as f:
            encodingInfo = chardet.detect(f.read()) # detect charset
            if encodingInfo['encoding'] == 'HZ-GB-2312':
                encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
        with open(fullpath, encoding=encodingInfo['encoding']) as f:
            for line in f:
                # Check if the line contains the start of the document
                if '\\begin{document}' in line:
                    break
                preamble += line
    except IOError as e:
        raise f"File cannot read: {fullpath}"
    except Exception as e:
        raise f"An error occurred: {e}"
    return preamble + "\\begin{document}\n"

if __name__ == "__main__":
    # test case
    latex_content = "This is a test \\{with }}}}{{{{some {nested} and some unclosed groups }{like this and an extra closing brace} {"
    cleaned_content = remove_mismatched_braces(latex_content)
    print(cleaned_content)