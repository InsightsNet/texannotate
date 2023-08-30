import json
import os
import re

from pylatexenc.latexnodes.nodes import LatexMacroNode
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
from pylatexenc.macrospec import (EnvironmentSpec, LatexContextDb,
                                  LstListingArgsParser, MacroSpec,
                                  MacroStandardArgsParser, VerbatimArgsParser,
                                  std_environment, std_macro, std_specials)
from texannotate.newcommand import MySimpleNewcommandArgsParser, MySimpleNewenvironmentArgsParser

from texannotate.latexwalk_spec import specs
from utils.utils import check_specs, find_latex_file

prog = re.compile(r"[\w\_:]+")

def parse_snippet(d, spec, latex_context:LatexContextDb):
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
            if spec == 'cmds' and latex_context.get_macro_spec(k) == latex_context.unknown_macro_spec:
                ret.append(std_macro(k ,v))
            elif spec == 'envs' and latex_context.get_environment_spec(k) == latex_context.unknown_environment_spec:
                ret.append(std_environment(k, v))
    return ret


def import_package(package_name, latex_context, is_class=False):
    if is_class:
        class_name = package_name
        package_name = 'class-' + class_name
    ret = []
    if not os.path.isfile('data/packages/'+package_name+'.json'):
        return ret
    else:
        with open('data/packages/'+package_name+'.json') as f:
            d = json.load(f)
        for dependency in d['includes']:
            ret += import_package(dependency, latex_context)
        
        ret.append((
            'package_'+package_name, {
                'macros': parse_snippet(d, 'cmds', latex_context),
                'environments': parse_snippet(d, 'envs', latex_context),
                'specials': []
            }
        ))
        return ret
    

def find_package(filename, basepath, latex_context):
    append = []
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
                append += find_package(filename, basepath, latex_context)
            if node.macroname == 'usepackage':
                package = node.nodeargs[0].nodelist[0].chars
                append += import_package(package, latex_context)
            if node.macroname == 'documentclass':
                class_ = node.nodeargs[0].nodelist[0].chars
                append += import_package(class_, latex_context, is_class=True)
    return append


def init_db(filename, basepath):
    check_specs()
    latex_context = LatexContextDb()
    latex_context.add_context_category('newcommand-category', prepend=True, macros=[
        MacroSpec('newcommand', args_parser=MySimpleNewcommandArgsParser()),
        MacroSpec('renewcommand', args_parser=MySimpleNewcommandArgsParser()),
        MacroSpec('newenvironment', args_parser=MySimpleNewenvironmentArgsParser()),
        MacroSpec('renewenvironment', args_parser=MySimpleNewenvironmentArgsParser()),
    ])
    for cat, catspecs in specs:
        latex_context.add_context_category(
            cat,
            macros=catspecs['macros'],
            environments=catspecs['environments'],
            specials=catspecs['specials']
        )
    latex_context.set_unknown_macro_spec(MacroSpec(''))
    latex_context.set_unknown_environment_spec(EnvironmentSpec(''))
    package_defs = find_package(filename, basepath, latex_context)

    for cat, catspecs in package_defs:
        if not cat in latex_context.categories():
            latex_context.extended_with(
                cat,
                macros=catspecs['macros'],
                environments=catspecs['environments'],
                specials=catspecs['specials']
            )
    return latex_context
