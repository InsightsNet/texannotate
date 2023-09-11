import json
import os
import re

import chardet
from pylatexenc.latexnodes.nodes import LatexMacroNode
from pylatexenc.latexnodes.parsers import LatexGeneralNodesParser
from pylatexenc.latexwalker import LatexWalker
from pylatexenc.macrospec import (EnvironmentSpec, LatexContextDb,
                                  LstListingArgsParser, MacroSpec,
                                  MacroStandardArgsParser, VerbatimArgsParser,
                                  std_environment, std_macro, std_specials)

from texannotate.latexwalk_spec import specs
from texannotate.newcommand import (MySimpleNewcommandArgsParser,
                                    MySimpleNewenvironmentArgsParser)
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


def parse_userdefined_package(filename, basepath, latex_context):
    append = []
    fullpath = os.path.join(basepath, filename)
    try:
        with open(fullpath, 'rb') as f:
            encodingInfo = chardet.detect(f.read()) # detect charset
            if encodingInfo['encoding'] == 'HZ-GB-2312':
                encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
        with open(fullpath, encoding=encodingInfo['encoding']) as f:
            tex_string = f.read()
    except IOError as e:
        print('read {} error.'.format(filename))
        return append, latex_context

    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    parsing_state.enable_environments = False
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    if nodelist:
        new_context = nodelist[-1].parsing_state.latex_context.filtered_context()
    else:
        new_context = latex_context
    if nodelist:
        for node in nodelist:
            if node.isNodeType(LatexMacroNode):
                if node.macroname == "RequirePackage":
                    package = node.nodeargd.argnlist[1].nodelist.nodelist[0].chars
                    append += import_package(package, latex_context)
    return append, new_context


def import_package(package_name, latex_context, is_class=False, added = set()):
    if is_class:
        class_name = package_name
        package_name = 'class-' + class_name
    ret = []
    if not os.path.isfile('data/packages/'+package_name+'.json'):
        return ret
    else:
        with open('data/packages/'+package_name+'.json') as f:
            d = json.load(f)
        added.add(package_name) # Solve the infinite recursion
        for dependency in d['includes']:
            if not dependency in added:
                ret += import_package(dependency, latex_context, added = added)
        
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
    if not filename.endswith(('.tex', '.latex', '.cls', '.sty')):
        return [], latex_context
    try:
        with open(fullpath, 'rb') as f:
            encodingInfo = chardet.detect(f.read()) # detect charset
            if encodingInfo['encoding'] == 'HZ-GB-2312':
                encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
        with open(fullpath, encoding=encodingInfo['encoding']) as f:
            
            tex_string = f.read()
    except IOError as e:
        print('read {} error.'.format(filename))
        return [], latex_context
        
    w = LatexWalker(tex_string, latex_context=latex_context)
    parsing_state = w.make_parsing_state()
    parsing_state.enable_environments = False
    nodelist, parsing_state_delta = w.parse_content(
        LatexGeneralNodesParser(),
        parsing_state=parsing_state
    )
    if nodelist:
        new_context = nodelist[-1].parsing_state.latex_context.filtered_context()
    else:
        new_context = latex_context
    pkg_new_context = []
    for node in nodelist:
        if node.isNodeType(LatexMacroNode):
            if node.macroname in {'input', 'include'}:
                filename = node.nodeargs[0].nodelist[0].chars
                append_, new_context_ = find_package(filename, basepath, latex_context)
                append += append_
            if node.macroname == 'usepackage':
                packages = node.nodeargs[0].nodelist[0].chars
                for package in packages.split(','):
                    if os.path.isfile(os.path.join(basepath, package+'.sty')): # import user package
                        pkg_def, pkg_context = parse_userdefined_package(package+'.sty', basepath, latex_context)
                        append += pkg_def
                        pkg_new_context.append(pkg_context)
                    else:
                        append += import_package(package, latex_context)
            if node.macroname == 'documentclass':
                class_s = node.nodeargs[0].nodelist[0].chars
                for class_ in class_s.split(','):
                    if os.path.isfile(os.path.join(basepath, class_+'.cls')): # import user defined documentclass
                        pkg_def, pkg_context = parse_userdefined_package(class_+'.cls', basepath, latex_context)
                        append += pkg_def
                        pkg_new_context.append(pkg_context)
                    else:
                        append += import_package(class_, latex_context, is_class=True)
    for context in pkg_new_context:
        for cat in context.category_list:
            if not cat in new_context.d:
                new_context.add_context_category(
                    cat,
                    macros=list(context.d[cat]['macros'].values()),
                    environments=list(context.d[cat]['environments'].values()),
                    specials=list(context.d[cat]['specials'].values())
                )

    return append, new_context


def init_db(filename, basepath):
    check_specs()
    latex_context = LatexContextDb()
    latex_context.add_context_category('latex-newcommand', prepend=True, macros=[
        MacroSpec('newcommand', args_parser=MySimpleNewcommandArgsParser()),
        #MacroSpec('renewcommand', args_parser=MySimpleNewcommandArgsParser()),
        MacroSpec('newenvironment', args_parser=MySimpleNewenvironmentArgsParser()),
        #MacroSpec('renewenvironment', args_parser=MySimpleNewenvironmentArgsParser()),
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
    package_defs, latex_context = find_package(filename, basepath, latex_context)

    for cat, catspecs in package_defs:
        if not cat in latex_context.categories():
            latex_context.add_context_category(
                cat,
                macros=catspecs['macros'],
                environments=catspecs['environments'],
                specials=catspecs['specials']
            )
    return latex_context