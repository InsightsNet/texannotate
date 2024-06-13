from pylatexenc.latexnodes.nodes import (LatexCharsNode, LatexCommentNode,
                                         LatexEnvironmentNode, LatexGroupNode,
                                         LatexMacroNode, LatexMathNode,
                                         LatexNode, LatexNodeList,
                                         LatexSpecialsNode)
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
from pylatexenc.macrospec import LatexContextDb

from texannotate.build_spec import init_db
from texannotate.color_annotation import ColorAnnotation
from texannotate.latex2text_spec import specs
from utils.utils import find_latex_file
from texannotate.clean_latex import clean_latex, post_cleaned
from difflib import SequenceMatcher

latex2text_context = LatexContextDb()
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


def find_env_caption(nodelist, color_dict, basepath):
    """
    Search caption in the environment and return the body of the environment with caption annotated.
    """
    s = nodelist[0].latex_walker.s
    file_string = ''
    for node in nodelist:
        if node.isNodeType(LatexMacroNode) and node.macroname=='caption':
            file_string += s[node.pos:node.nodeargd.argnlist[-1].nodelist[0].pos]
            file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[-1].nodelist, color_dict, 'caption', basepath)
            file_string += s[node.nodeargd.argnlist[-1].nodelist[-1].pos_end:node.pos_end]
        else:
            file_string += s[node.pos:node.pos_end]
    return file_string, color_dict


def resolve_node_list(file_string:str, nodelist: LatexNodeList, color_dict: ColorAnnotation, environment, basepath):
    if nodelist and len(nodelist) > 0:
        s = nodelist[0].latex_walker.s
    else:
        return file_string, color_dict
    if not environment is None:
        environment = environment.lower()
        if 'title' in environment:
            annotate = 'Title'
        elif any(x in environment for x in ['author', 'address']):
            annotate = 'Author'
        elif any(x in environment for x in ['abstract', 'keyword']):
            annotate = 'Abstract'
        elif 'section' in environment:
            annotate = 'Section'
        elif 'footnote' in environment:
            annotate = 'Footer'
        elif 'caption' in environment:
            annotate = 'Caption'
        elif any(x in environment for x in ['enum', 'list', 'itemize', 'desc']):
            annotate = 'List'
        else:
            annotate = 'Paragraph'
    else:
        annotate = None

    unfinished_macro = False
    unfinished_vskip = False
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
            elif node.macroname in {'maketitle', '\\', 'item', 'label', 'linewidth', 'begin', 'end'}:
                file_string += s[node.pos:node.pos_end]
            elif 'vskip' == node.macroname:
                unfinished_vskip = True
                file_string += s[node.pos:node.pos_end]
            elif 'includegraphics' in node.macroname:
                file_string += color_dict.add_annotation_rgb(s[node.pos:node.pos_end], annotate='Figure')
            else:
                macro_environment = ''
                macroname = node.macroname.lower()
                if 'title' in macroname and not 'short' in macroname:
                    macro_environment = 'title'
                elif any(x in macroname for x in ['author', 'address', 'institut', 'affiliat']) \
                        and not 'short' in macroname:
                    macro_environment = 'author'
                elif any(x in macroname for x in ['abstract', 'keyword']):
                    macro_environment = 'abstract'
                elif any(x in macroname for x in ['footnote', 'thanks']):
                    macro_environment = 'footnote'
                elif 'caption' == macroname:
                    macro_environment = 'caption'
                elif 'section' in macroname or macroname in {'chapter', 'part'}:
                    macro_environment = 'section'
                elif macroname in {'scalebox', 'resizebox'}:
                    macro_environment = annotate
                elif macroname in {'textbf', 'textit', 'texttt', 'textsc', 'text', 'underline', 'emph'}:
                    macro_environment = annotate
                elif macroname == 'par':
                    file_string += '\\par'
                    color_dict.block_num += 1
                    unfinished_macro = False
                    continue

                if macro_environment in {'title', 'section'} and macroname != 'titlearea':
                    color_dict.toc.add_node(macroname)

                if macroname == 'titlearea': 
                    color_dict.toc.add_node('title')
                    file_string += s[node.pos:node.nodeargd.argnlist[0].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[0].nodelist, color_dict, 'title', basepath)
                    file_string += s[node.nodeargd.argnlist[0].nodelist[-1].pos_end:node.nodeargd.argnlist[1].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[1].nodelist, color_dict, 'author', basepath)
                    file_string += s[node.nodeargd.argnlist[1].nodelist[-1].pos_end:node.pos_end]
                    if not environment is None:
                        color_dict.block_num += 1
                elif macroname == 'twocolumn':
                    file_string += s[node.pos:node.nodeargd.argnlist[-1].nodelist[0].pos]
                    file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[-1].nodelist.nodelist, color_dict, macro_environment, basepath)
                    file_string += s[node.nodeargd.argnlist[-1].nodelist[-1].pos_end:node.pos_end]
                elif 'bibliography' in macroname:
                    color_dict.toc.add_node('section')
                    file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Reference')
                    if not environment is None:
                        color_dict.block_num += 1

                # skip cases
                elif macroname == 'affiliation' and color_dict.documentclass in ['revtex4-2', 'elsarticle', 'cas-dc']:
                    file_string += s[node.pos:node.pos_end]
                elif macroname == 'author' and color_dict.documentclass in 'WileyNJD':
                    file_string += s[node.pos:node.pos_end]

                elif macro_environment:
                    added = False
                    for i in range(node.spec.arguments_spec_list.count('{')):
                        if node.nodeargs[-i-1] and node.nodeargs[-i-1].isNodeType(LatexGroupNode):
                            added = True
                            if node.nodeargs[-i-1].nodelist:
                                file_string += s[node.pos:node.nodeargs[-i-1].nodelist[0].pos]
                                file_string, color_dict = resolve_node_list(file_string, node.nodeargs[-i-1].nodelist, color_dict, macro_environment, basepath)
                                file_string += s[node.nodeargs[-i-1].nodelist[-1].pos_end:node.pos_end]
                            else:
                                file_string += s[node.pos:node.pos_end]
                            break
                    if not added:
                        file_string += s[node.pos:node.pos_end]
                    if not environment is None and macro_environment in ["title", "author", "abstract"]:
                        color_dict.block_num += 1
                else:
                    if not environment is None and macro_should_be_colored(node.macroname):
                        file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate=annotate)
                    elif macroname == 'lstinputlisting':
                        file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
                        if not environment is None:
                            color_dict.block_num += 1
                    elif macroname == 'ce':
                        file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
                    else:
                        file_string += s[node.pos:node.pos_end]
                        if node.macroname == 'documentclass':
                            color_dict.documentclass = node.nodeargs[-1].nodelist[0].chars

        elif node.isNodeType(LatexEnvironmentNode):
            if not environment is None:
                color_dict.block_num += 1
            if node.spec.is_math_mode is True:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Equation')
            elif 'bibliography' in node.environmentname:
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Reference')
            elif any(x in node.environmentname for x in ['tikz', 'forest']):
                file_string += color_dict.add_annotation_rgb(s[node.pos:node.pos_end], annotate='Figure')
            elif any(x in node.environmentname for x in ['tabular', 'tabbing']):
                file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Table')
            elif node.environmentname == 'longtable':
                if len(node.nodelist) > 0:
                    environment_string = color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Table')
                    match_ = SequenceMatcher(a=s[node.pos:node.pos_end], b=environment_string).find_longest_match()
                    RGB_string = environment_string[:match_.b]
                    file_string += RGB_string
                    file_string += s[node.pos:node.nodelist[0].pos]
                    env_with_colored_caption, color_dict = find_env_caption(node.nodelist, color_dict, basepath) 
                    file_string += env_with_colored_caption
                    file_string += s[node.nodelist[-1].pos_end:node.pos_end]
                    file_string += '}'
            elif node.environmentname == 'multicols':
                file_string += s[node.pos:node.nodeargd.argnlist[-1].nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodeargd.argnlist[-1].nodelist, color_dict, node.environmentname, basepath)
                file_string += s[node.nodeargd.argnlist[-1].nodelist[-1].pos_end:node.nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, node.environmentname, basepath)
                file_string += s[node.nodelist[-1].pos_end:node.pos_end]
            elif node.environmentname.startswith('algorithm'): # algorithm and algorithmic
                # \If \Else cannot be annotate separately
                # Annotating the whole environment doesn't work, we have to put the annotation inside the environment
                if len(node.nodelist) > 0:
                    environment_string = color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate='Paragraph')
                    match_ = SequenceMatcher(a=s[node.pos:node.pos_end], b=environment_string).find_longest_match()
                    RGB_string = environment_string[:match_.b]
                    file_string += s[node.pos:node.nodelist[0].pos]
                    file_string += RGB_string
                    env_with_colored_caption, color_dict = find_env_caption(node.nodelist, color_dict, basepath) 
                    file_string += env_with_colored_caption
                    file_string += '}'
                    file_string += s[node.nodelist[-1].pos_end:node.pos_end]
            elif node.environmentname in ['CCSXML']: # skip env
                file_string += s[node.pos:node.pos_end]
            else:
                if len(node.nodelist) > 0:
                    file_string += s[node.pos:node.nodelist[0].pos]
                    if any(x in node.environmentname for x in ['abstract', 'keyword']):
                        file_string += '\n\\thinspace ' # solve IEEE template error: missing \endcsname inserted.
                    if environment is None or annotate == 'Paragraph': # for the case of \begin{center} within \begin{figure}
                        file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, node.environmentname, basepath)
                    else:
                        file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, annotate, basepath)
                    file_string += s[node.nodelist[-1].pos_end:node.pos_end]
                else:
                    file_string += s[node.pos:node.pos_end]
            if not environment is None:
                color_dict.block_num += 1

        elif node.isNodeType(LatexCharsNode):
            if (environment is None) or (node.chars.isspace()):
                file_string += s[node.pos:node.pos_end]
            else:
                for token in color_dict.tokenizer(node.chars):
                    if token.text.isspace():
                        file_string += token.text
                    else:
                        if unfinished_vskip:
                            file_string += s[node.pos:node.pos_end]
                            unfinished_vskip = False
                            continue
                        file_string += color_dict.add_annotation_RGB(token.text, annotate=annotate)
                        if token.whitespace_:
                            file_string += token.whitespace_

        elif node.isNodeType(LatexGroupNode):
            if not environment is None and node.pos_end-node.pos>=20 and len(node.nodelist) > 0:
                file_string += s[node.pos:node.nodelist[0].pos]
                file_string, color_dict = resolve_node_list(file_string, node.nodelist, color_dict, environment, basepath)
                file_string += s[node.nodelist[-1].pos_end:node.pos_end]
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
            if node.specials_chars == '\n\n':
                if not environment is None:
                    color_dict.block_num += 1
            spec = latex2text_context.get_specials_spec(node.specials_chars)
            if spec is None or spec.simplify_repl.isspace():
                file_string += s[node.pos:node.pos_end]
            else:
                file_string += s[node.pos:node.pos_end]

        elif node.isNodeType(LatexNode):
            # unknown node, do nothing
            file_string += color_dict.add_annotation_RGB(s[node.pos:node.pos_end], annotate=annotate)

        else:
            raise 'not a latex node.'


    return file_string, color_dict


def annotate_file(filename: str, color_dict: ColorAnnotation, latex_context: LatexContextDb, environment=None, basepath=None):  
    print('start annotating:', filename)  
    if not filename:
        raise 'tex file not found, please check AutoTeX output.'
    if not filename.endswith(('.tex', '.latex', '.cls', '.sty')): # for the case of \input{blah.pspdftex}
        return False
    if latex_context is None: # load package definitions
        latex_context = init_db(filename, basepath)
    tex_string, removed = clean_latex(filename, basepath, latex_context)

    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    file_string = ''
    file_string, color_dict = resolve_node_list(file_string, nodelist, color_dict, environment, basepath)
    file_string = post_cleaned(file_string, removed, latex_context)
    fullpath = find_latex_file(filename, basepath)
    with open(fullpath, 'w') as f:
        f.write(file_string)
    print('finish annotating:', filename)
    return True