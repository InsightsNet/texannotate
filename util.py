import os
import socket
from contextlib import closing
import re
from pathlib import Path

def find_free_port() -> int:  #https://stackoverflow.com/questions/1365265/on-localhost-how-do-i-pick-a-free-port-number
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]    

def find_latex_file(filename, basepath) -> str:
    fullpath = os.path.join(basepath, filename)
    if not os.path.exists(fullpath) and os.path.exists(fullpath + '.tex'):
        fullpath = fullpath + '.tex'
    if not os.path.exists(fullpath) and os.path.exists(fullpath + '.latex'):
        fullpath = fullpath + '.latex'
    if not os.path.isfile(fullpath):
        #logger.warning("Error, file doesn't exist: '%s'", fn)
        return ''

    #logger.debug("Reading input file %r", fnfull)
    return fullpath


BLOCK_1 = r"""\pdfoutput=1
\interactionmode=1
"""
BLOCK_2 = r"""
\usepackage{xcolor}
\usepackage{tcolorbox}
\setlength { \fboxsep }{ 0pt } 
\setlength { \fboxrule }{ 0pt }
"""
regex = r"^\\usepackage(\[\w+\])?\{\w+\}$"
def postprocess_latex(filename):
    with open(filename) as f:
        file_string = f.read()
    for match in re.finditer(regex, file_string, re.DOTALL | re.MULTILINE):
        end = match.end()
    file_string = BLOCK_1 + file_string[:end] + BLOCK_2 + file_string[end:]
    with open(filename, 'w') as f:
        f.write(file_string)

def preprocess_latex(path):
    p = Path(path)
    for tex in list(p.glob(r'*.tex')) + list(list(p.glob(r'*.latex'))):
        with tex.open() as f:
            file_string = f.read()
        file_string = BLOCK_1 + file_string
        with tex.open('w') as f:
            f.write(file_string)