from texannotate.color_annotation import ColorAnnotation
from texannotate.util import find_latex_file
from pylatexenc.latexnodes.nodes import (
    LatexNode,
    LatexCharsNode,
    LatexGroupNode,
    LatexCommentNode,
    LatexMacroNode,
    LatexEnvironmentNode,
    LatexSpecialsNode,
    LatexMathNode,
    LatexNodeList
)
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
from pylatexenc.macrospec import LatexContextDb

from pylatexenc import macrospec
from texannotate.latex2text_spec import specs
latex2text_context = macrospec.LatexContextDb()
for cat, catspecs in specs:
    latex2text_context.add_context_category(
        cat,
        macros=catspecs['macros'],
        environments=catspecs['environments'],
        specials=catspecs['specials']
    )

def macro_should_be_colored(macroname):
    spec = latex2text_context.get_macro_spec(macroname)
    if spec is None:
        return False
    elif spec.discard is True:
        return False
    elif type(spec.simplify_repl) == str and spec.simplify_repl.isspace():
        return False
    else:
        return True

def resolve_node_list(file_string:str, nodelist: LatexNodeList, color_dict: ColorAnnotation, environment, basepath):
    if len(nodelist) > 0:
        s = nodelist[0].latex_walker.s
    else:
        return False
    if not environment is None:
        if 'title' in environment:
            annotate = 'Title'
        elif 'author' in environment or 'address' in environment:
            annotate = 'Author'
        elif 'abstract' in environment:
            annotate = 'Abstract'
        elif 'section' in environment:
            annotate = 'Section'
        elif 'footnote' in environment:
            annotate = 'Footer'
        elif 'caption' in environment:
            annotate = 'Caption'
        elif 'enumerate' in environment or 'list' in environment or 'itemize' in environment:
            annotate = 'List'
        else:
            annotate = 'Paragraph'

    unfinished_macro = False
    for node in nodelist:
        if unfinished_macro is True: 
            # unknown macro
            # we try to catch the arguments as much as possible
            if node.isNodeType(LatexGroupNode) or node.isNodeType(LatexCommentNode) or \
               (node.isNodeType(LatexCharsNode) and node.chars.strip().startswith('[')): # and node.chars.strip().endswith(']')
                # this is an argument of previous macro
                end_pos = node.pos_end
                continue
            else:
                file_string += s[start_pos:end_pos]
                unfinished_macro = False

        if node.isNodeType(LatexMacroNode):
            if latex2text_context.get_environment_spec(node.macroname) is None and node.spec.macroname == '':
                # here is an unknown macro node entry
                unfinished_macro = True
                start_pos = node.pos
                end_pos = node.pos_end
                continue
            elif node.macroname in {'input', 'include'}:
                #step into a inputfile
                file_string += s[node.pos:node.pos_end]
                filename = node.nodeargs[0].nodelist[0].chars
                annotate_file(filename, color_dict, node.parsing_state.latex_context, environment, basepath)
            elif node.macroname in {'maketitle', '\\', 'item', 'label', 'linewidth'}:
                file_string += s[node.pos:node.pos_end]
            elif node.macroname == 'includegraphics':
                file_string += color_dict.add_annotation_rgb(s[node.pos:node.pos_end], annotate='Figure')

            else: # TODO: try only annotate the last group
                macro_environment = ''
                if 'title' in node.macroname:
                    macro_environment = 'title'
                elif 'author' in node.macroname or 'address' in node.macroname:
                    macro_environment = 'author'
                elif 'abstract' in node.macroname or 'keyword' in node.macroname:
                    macro_environment = 'abstract'
                elif 'footnote' in node.macroname:
                    macro_environment = 'footnote'
                elif 'caption' in node.macroname:
                    macro_environment = 'caption'
                elif 'section' in node.macroname or node.macroname in {'chapter', 'part'}:
                    macro_environment = 'section'
                elif node.macroname in {'scalebox', 'resizebox'}:
                    macro_environment = annotate

                if macro_environment in {'title', 'section'} and node.macroname != 'titlearea':
                    color_dict.toc.add_node(node.macroname)

                if node.macroname == 'titlearea': 
                    color_dict.toc.add_node('title')
                    file_string += s[node.pos:node.nodeargd.argnlist[0].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[0].nodelist, color_dict, 'title', basepath)
                    file_string += s[node.nodeargd.argnlist[0].nodelist[-1].pos_end:node.nodeargd.argnlist[1].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[1].nodelist, color_dict, 'author', basepath)
                    file_string += s[node.nodeargd.argnlist[1].nodelist[-1].pos_end:node.pos_end]
                elif node.macroname == 'twocolumn':
                    file_string += s[node.pos:node.nodeargd.argnlist[-1].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[-1].nodelist.nodelist, color_dict, macro_environment, basepath)
                    file_string += s[node.nodeargd.argnlist[-1].nodelist[-1].pos_end:node.pos_end]
                elif 'bibliography' in node.macroname:
                    color_dict.toc.add_node('section')
                    file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Reference')
                elif macro_environment:
                    file_string += s[node.pos:node.nodeargs[-1].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargs[-1].nodelist, color_dict, macro_environment, basepath)
                    file_string += s[node.nodeargs[-1].nodelist[-1].pos_end:node.pos_end]
                else:
                    if not environment is None and macro_should_be_colored(node.macroname):
                        file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate=annotate)
                    elif node.macroname == 'lstinputlisting':
                        file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
                    else:
                        file_string += s[node.pos:node.pos_end]

        elif node.isNodeType(LatexEnvironmentNode):

            if node.spec.is_math_mode is True:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
            elif 'bibliography' in node.environmentname:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Reference')
            elif 'tikzpicture' in node.environmentname:
                file_string += color_dict.add_annotation_rgb(s[node.pos:node.pos_end], annotate='Figure')
            elif 'tabular' in node.environmentname:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Table')
            elif node.environmentname == 'multicols':
                file_string += s[node.pos:node.nodeargd.argnlist[-1].nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[-1].nodelist, color_dict, node.environmentname, basepath)
                file_string += s[node.nodeargd.argnlist[-1].nodelist[-1].pos_end:node.nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, node.environmentname, basepath)
                file_string += s[node.nodelist[-1].pos_end:node.pos_end]
            else:
                file_string += s[node.pos:node.nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, node.environmentname, basepath)
                file_string += s[node.nodelist[-1].pos_end:node.pos_end]

        elif node.isNodeType(LatexCharsNode):
            if (environment is None) or (node.chars.isspace()):
                file_string += s[node.pos:node.pos_end]
            else:
                for token in color_dict.tokenizer(node.chars):
                    if token.text.isspace():
                        file_string += token.text
                    else:
                        file_string += color_dict.add_annotation_RGB(token.text, annotate=annotate)
                        if token.whitespace_:
                            file_string += token.whitespace_

        elif node.isNodeType(LatexGroupNode):
            # TODO: should we break it up?
            if not environment is None:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate=annotate)
            else:
                file_string += s[node.pos:node.pos_end]

        elif node.isNodeType(LatexMathNode):
            if not environment is None:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
            else:
                file_string += s[node.pos:node.pos_end]

        # don't add color
        elif node.isNodeType(LatexCommentNode): 
            file_string += s[node.pos:node.pos_end]

        elif node.isNodeType(LatexSpecialsNode):
            file_string += s[node.pos:node.pos_end]

        elif node.isNodeType(LatexNode):
            # unknown node, do nothing
            file_string += s[node.pos:node.pos_end]

        else:
            raise 'not a latex node.'


    return file_string, color_dict


def annotate_file(filename: str, color_dict: ColorAnnotation, latex_context: LatexContextDb, environment=None, basepath=None):  
    print('start annotating:', filename)
    file_string = ''
    fullpath = find_latex_file(filename, basepath)
    try:
        with open(fullpath) as f:
            tex_string = f.read()
    except IOError as e:
        print(e)
        return False
    
    if latex_context is None:
        latex_context = macrospec.LatexContextDb()
        from texannotate.latexwalk_spec import specs
        for cat, catspecs in specs:
            latex_context.add_context_category(
                cat,
                macros=catspecs['macros'],
                environments=catspecs['environments'],
                specials=catspecs['specials']
            )
        latex_context.set_unknown_macro_spec(macrospec.MacroSpec(''))
        latex_context.set_unknown_environment_spec(macrospec.EnvironmentSpec(''))
        
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    # TODO: first walk to load \newcommand and \def
    file_string, color_dict = resolve_node_list(file_string, nodelist, color_dict, environment, basepath)
    with open(fullpath, 'w') as f:
        f.write(file_string)
    print('finish annotating:', filename)
    return True