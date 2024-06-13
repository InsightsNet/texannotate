import os
import re
import socket
from contextlib import closing
from pathlib import Path
import chardet
import time
import docker


def find_free_port() -> int:  
    # https://stackoverflow.com/questions/1365265/on-localhost-how-do-i-pick-a-free-port-number
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]
    

def check_container_ready(container):
    for _ in range(120): # timeout
        container.reload()
        if container.status == 'running':
            return
        time.sleep(1)
    raise TimeoutError('Container init error.')
    

def start_container(name: str):
    client = docker.from_env()
    try: # reuse existing contianer
        container = client.containers.get(name)
        port = int(container.ports['80/tcp'][0]['HostPort'])
        check_container_ready(container)
        return container, port
    except docker.errors.NotFound:
        for _ in range(10):
            try:
                port = find_free_port()
                container = client.containers.run(
                    image='tex-compilation-service',
                    detach=True,
                    ports={'80/tcp':port},
                    #tmpfs={'/tmpfs':''},
                    remove=True,
                    name=name
                )
                time.sleep(3)
                check_container_ready(container)
                return container, port
            except:
                time.sleep(1)
        raise TimeoutError('Create container failed.')
    except docker.errors.APIError as e:
        raise e
 

def find_latex_file(filename, basepath) -> str:
    fullpath = os.path.join(basepath, filename)
    if not os.path.exists(fullpath) and os.path.exists(fullpath + '.tex'):
        fullpath = fullpath + '.tex'
    if not os.path.exists(fullpath) and os.path.exists(fullpath + '.latex'):
        fullpath = fullpath + '.latex'
    if not os.path.isfile(fullpath):
        print(fullpath, 'not exist.')
        # logger.warning("Error, file doesn't exist: '%s'", fn)
        return ''

    #logger.debug("Reading input file %r", fnfull)
    return fullpath


def check_specs():
    if os.path.exists('data/README.md'):
        pass #TODO: check update with github api
    else:
        from utils.pkgcommand import run
        run()


BLOCK_1 = r"""\pdfoutput=1
\interactionmode=1
"""
BLOCK_2 = r"""
\usepackage{xcolor}
\usepackage{tcolorbox}
\setlength { \fboxsep }{ 0pt } 
\setlength { \fboxrule }{ 0pt }
"""
regex = r"^\\usepackage(\[\w+\])?\{\w+\}$" #find the latest usepackage
def postprocess_latex(filename):
    try:
        with open(filename, 'rb') as f:
            encodingInfo = chardet.detect(f.read()) # detect charset
            if encodingInfo['encoding'] == 'HZ-GB-2312':
                encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
        with open(filename, encoding=encodingInfo['encoding']) as f:
            file_string = f.read()
    except IOError as e:
        print(e)
        return 
    if file_string:
        end = 0
        for match in re.finditer(regex, file_string, re.DOTALL | re.MULTILINE):
            end = match.end()
        file_string = BLOCK_1 + file_string[:end] + BLOCK_2 + file_string[end:]
    with open(filename, 'w') as f:
        f.write(file_string)

def preprocess_latex(path):
    p = Path(path)
    for tex in list(p.glob(r'*.tex')) + list(list(p.glob(r'*.latex'))):
        try:
            with tex.open('rb') as f:
                encodingInfo = chardet.detect(f.read()) # detect charset
                if encodingInfo['encoding'] == 'HZ-GB-2312':
                    encodingInfo['encoding'] = 'utf-8' # sometime the chardet detect 'hz' incorrectly
            with tex.open('r', encoding=encodingInfo['encoding']) as f:
                file_string = f.read()
        except IOError as e:
            print('preprocess_latex: read {} error.'.format(str(tex)))
            return
        file_string = BLOCK_1 + file_string
        with tex.open('w') as f:
            f.write(file_string)

def tup2str(tup):
    if type(tup) != tuple or len(tup) != 3:
        return None
    rgb_string = []
    for rgb in tup:
        if rgb < 1:
            rgb_string.append("0.%d" % (int(rgb*10)))
        elif rgb > 1:
            raise "color error"
        else:
            rgb_string.append('1.0')
    return ",".join(rgb_string)