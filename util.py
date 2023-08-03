import os
import socket
from contextlib import closing


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