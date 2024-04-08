import multiprocessing
from multiprocessing import set_start_method
import os

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
import fitz
if platform == "linux" or platform == "linux2":
    from memory_tempfile import MemoryTempfile
    tempfile = MemoryTempfile()
else:
    import tempfile
client = docker.from_env()
try:
    client.images.get('tex-compilation-service:latest')
except docker.errors.ImageNotFound:
    client.images.build(path='texcompile/service', tag='tex-compilation-service')
import time

def annotate(filename: Path, output: Path):
    if Path(output/(str(filename.stem)+'_data.csv')).exists():
        return filename, False
    port = find_free_port()
    print(filename, os.getpid(), port)
    container = client.containers.run(
        image='tex-compilation-service',
        detach=True,
        ports={'80/tcp':port},
        #tmpfs={'/tmpfs':''},
        remove=True,
    )
    time.sleep(5) # ensure contianer inited TODO: smarter check   
    try:
        with tempfile.TemporaryDirectory() as td:
            #print('temp dir', td)
            with tarfile.open(filename ,'r:gz') as tar:
                tar.extractall(td)
                preprocess_latex(td)

            basename, pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td,
                port=port
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
            color_dict.extract_defs(tex_file, td, port)
            annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
            postprocess_latex(tex_file)
            shutil.make_archive(output/filename.stem, 'zip', td)
            basename, pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td,
                port=port
            ) # compile the modified latex
            shapes, tokens = pdf_extract(pdf_bytes)
        df_toc, df_data = export_annotation(shapes, tokens, color_dict)
        df_toc.to_csv(output/(str(filename.stem)+'_toc.csv'), sep='\t')
        df_data.to_csv(output/(str(filename.stem)+'_data.csv'), sep='\t')
        with tempfile.TemporaryDirectory() as td:
            color_dict = ColorAnnotation()
            color_dict.black = True
            with tarfile.open(filename ,'r:gz') as tar:
                tar.extractall(td)
            tex_file = find_latex_file(Path(basename).stem, basepath=td)
            color_dict.extract_defs(tex_file, td, port)
            annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
            postprocess_latex(tex_file)
            basename, pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td,
                port=port
            ) # compile the modified latex
            with fitz.open("pdf", pdf_bytes) as doc:
                doc.save(output/(str(filename.stem)+'.pdf'))

        container.stop()
        return filename, False
    except CompilationException:
        #print('LaTeX code compilation error.')
        container.stop()
        return filename, 'LaTeX code compilation error.'
    except Exception as e:
        #print(e)
        container.stop()
        return filename, str(e)
    

if __name__ == "__main__":
    set_start_method("spawn")
    print("Starting...")
    p = Path(".")
    output_path = p/'outputs'
    output_path.mkdir(exist_ok=True)
    args = []
    for filename in p.glob("downloaded" + '/*.gz'):
        args.append((filename, output_path))
    print('Find %d source files, starting annotate.' %len(args))
    pool = multiprocessing.Pool(processes=63)
    try:
        pool_outputs = pool.starmap(annotate, args)
        errors = {i[0].name:i[1] for i in pool_outputs if i[1]}
        import json
        json.dump(errors, open('errors.json', 'w'), indent=2)
    except KeyboardInterrupt:
        pool.terminate()
        pool.join()
        pool.close()