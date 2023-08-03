import tarfile
from pathlib import Path
from sys import platform

import docker

from annotate_file import annotate_file
from color_annotation import Color_Annotation
from texcompile.client import compile_pdf_return_bytes
from util import find_free_port, find_latex_file, postprocess_latex, preprocess_latex
from pdf_extract import pdf_extract

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
    try:
        p = Path('.')
        for filename in p.glob(basepath + '/*.tar.gz'):
            with tempfile.TemporaryDirectory() as td:
                #print('temp dir', td)
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
                    preprocess_latex(td)

                basename, pdf_bytes = compile_pdf_return_bytes(
                    sources_dir=td
                ) # compile the unmodified latex firstly
                shapes, tokens = pdf_extract(pdf_bytes)
                ## get colors
                color_dict = Color_Annotation()
                for rect in shapes:
                    color_dict.add_existing_color(rect['stroking_color'])
                for token in tokens:
                    color_dict.add_existing_color(token['color'])

            with tempfile.TemporaryDirectory() as td:
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
                tex_file = find_latex_file(Path(basename).stem, basepath=td)
                annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
                postprocess_latex(tex_file)
                #print(p/'outputs'/filename.stem)
                #shutil.make_archive(p/'outputs'/filename.stem, 'zip', td)
                basename, pdf_bytes = compile_pdf_return_bytes(
                    sources_dir=td
                ) # compile the unmodified latex firstly
                shapes, tokens = pdf_extract(pdf_bytes)
    except Exception as e:
        container.stop()
        raise e


if __name__ == "__main__":
    main("downloaded")