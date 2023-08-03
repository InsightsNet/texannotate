import os
import shutil
import tarfile
from pathlib import Path
from sys import platform

import docker

from annotate_file import annotate_file
from color_annotation import Color_Annotation
from texcompile.client import compile_pdf_return_bytes
from util import find_free_port
from extract_pdf import extract_pdf

def main(basepath:str):
    #check docker image
    client = docker.from_env()
    try:
        client.images.get('tex-compilation-service:latest')
    except docker.errors.ImageNotFound:
        client.images.build(path='texcompile/service', tag='tex-compilation-service')

    port = find_free_port()
    if platform == "linux" or platform == "linux2":
        from memory_tempfile import MemoryTempfile
        tempfile = MemoryTempfile()
        container = client.containers.run(
            image='tex-compilation-service',
            detach=True,
            ports={'80/tcp':port},
            tmpfs={'/tmpfs':''},
            remove=True,
        )
    else:
        import tempfile
        container = client.containers.run(
            image='tex-compilation-service',
            detach=True,
            ports={'80/tcp':port},
            #tmpfs={'/tmpfs':''},
            remove=True,
        )

    p = Path('.')
    for filename in p.glob(basepath + '/*.tar.gz'):
        with tempfile.TemporaryDirectory() as td:
            print('temp dir', td)
            with tarfile.open(filename ,'r:gz') as tar:
                tar.extractall(td)
        
            pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td
            ) # compile the unmodified latex firstly
            shapes, tokens = extract_pdf(pdf_bytes)
            ## get colors
            color_dict = Color_Annotation()
            color_dict.add_existing_color('#000000')
            print(os.listdir(td))

            tex_file = input()#'main.tex'
            annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
            print(p/'output'/filename.stem)
            shutil.make_archive(p/'output'/filename.stem, 'zip', td)

    container.stop()


if __name__ == "__main__":
    main("sources")