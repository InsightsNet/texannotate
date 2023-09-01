import tarfile
from pathlib import Path
from sys import platform

import docker

from pdfextract.export_annotation import export_annotation
from pdfextract.pdf_extract import pdf_extract
from texannotate.annotate_file import annotate_file
from texannotate.color_annotation import ColorAnnotation
from utils.utils import (find_free_port, find_latex_file,
                              postprocess_latex, preprocess_latex, tup2str)
from texcompile.client import compile_pdf_return_bytes, CompilationException
import shutil

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
        print(filename)
        try:
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
                color_dict = ColorAnnotation()
                for rect in shapes:
                    color_dict.add_existing_color(tup2str(rect['stroking_color']))
                for token in tokens:
                    color_dict.add_existing_color(token['color'])

            with tempfile.TemporaryDirectory() as td:
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
                tex_file = find_latex_file(Path(basename).stem, basepath=td)
                annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
                postprocess_latex(tex_file)
                shutil.make_archive(p/'outputs'/filename.stem, 'zip', td)
                basename, pdf_bytes = compile_pdf_return_bytes(
                    sources_dir=td
                ) # compile the modified latex
                shapes, tokens = pdf_extract(pdf_bytes)
            df_toc, df_data = export_annotation(shapes, tokens, color_dict)
            Path("outputs").mkdir(exist_ok=True)
            df_toc.to_csv('outputs/'+str(filename.stem)+'_toc.csv', sep='\t')
            df_data.to_csv('outputs/'+str(filename.stem)+'_data.csv', sep='\t')
        except CompilationException:
            print('LaTeX code compilation error.')
        except KeyboardInterrupt as e:
            container.stop()
        except Exception as e:
            print(e)
            #container.stop()
            #raise e
    container.stop()

if __name__ == "__main__":
    main("downloaded")