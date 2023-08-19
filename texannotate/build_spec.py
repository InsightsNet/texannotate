from pylatexenc import macrospec
from pylatexenc.latexwalker import LatexWalker
from texannotate.latexwalk_spec import specs
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexnodes.nodes import LatexMacroNode
from texannotate.util import find_latex_file
import os
import json
from pylatexenc.macrospec import (
    std_macro,
    std_environment,
    std_specials,
    MacroSpec, EnvironmentSpec, MacroStandardArgsParser,
    VerbatimArgsParser, LstListingArgsParser,
)
import re
prog = re.compile(r"[\w\_:]+")

latex_context = macrospec.LatexContextDb()
for cat, catspecs in specs:
    latex_context.add_context_category(
        cat,
        macros=catspecs['macros'],
        environments=catspecs['environments'],
        specials=catspecs['specials']
    )


def parse_snippet(d, spec):
    ret = []
    macro_dict = {}
    for k in d[spec]:
        if k.endswith('(') or k.endswith('[') or k.endswith('{') or k == '<' or k == '>': 
            macro_dict[k] = ''
            continue
        macro = prog.match(k)

        assert macro.span()[0] == 0, k
        match_str = k[:macro.span()[1]]
        arguments = k[macro.span()[1]:].replace('}', '').replace(']', '').replace('>', '')
        if match_str in macro_dict:
            if len(arguments) > len(macro_dict[match_str]):
                macro_dict[match_str] = arguments
        else:
            macro_dict[match_str] = arguments

    accept = {'{', '[', '*'}
    for k,v in macro_dict.items():
        if (set(v).issubset(accept)) and not k.endswith('_'):
            if spec == 'cmds' and latex_context.get_macro_spec(k) is None:
                ret.append(std_macro(k ,v))
            elif spec == 'envs' and latex_context.get_environment_spec(k) is None:
                ret.append(std_environment(k, v))
    return ret


def import_package(package_name):
    ret = []
    if not os.path.isfile('data/packages/'+package_name+'.json'):
        print('Cannot find the definition of imported package: '+package_name)
        return ret
    else:
        with open('data/packages/'+package_name+'.json') as f:
            d = json.load(f)
        for dependency in d['includes']:
            ret += import_package(dependency)
        
        ret.append((
            'package_'+package_name, {
                'macros': parse_snippet(d, 'cmds'),
                'environments': parse_snippet(d, 'envs'),
                'specials': []
            }
        ))
        return ret
    

def find_import_and_new(filename, basepath):
    fullpath = find_latex_file(filename, basepath)
    with open(fullpath) as f:
        tex_string = f.read()
        
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    for node in nodelist:
        if node.isNodeType(LatexMacroNode):
            if node.macroname in {'input', 'include'}:
                filename = node.nodeargs[0].nodelist[0].chars
                ret = find_import_and_new(filename, basepath)
            if node.macroname == 'usepackage':
                package = nodelist[0].nodeargs[0].nodelist[0].chars
                ret = import_package(package)


if __name__ == "__main__":
    print(import_package('acro'))