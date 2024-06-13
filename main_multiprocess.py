from pebble import ProcessPool
from concurrent.futures import TimeoutError, as_completed
from multiprocessing import set_start_method
import gzip
import tarfile
from pathlib import Path
from sys import platform
from pdfextract.export_annotation import export_annotation
from pdfextract.pdf_extract import pdf_extract
from texannotate.annotate_file import annotate_file
from texannotate.color_annotation import ColorAnnotation
from utils.utils import find_latex_file, postprocess_latex, preprocess_latex, tup2str
from texcompile.client import compile_pdf_return_bytes, CompilationException
import shutil
import fitz
from collections import OrderedDict

if platform == "linux" or platform == "linux2":
    from memory_tempfile import MemoryTempfile
    tempfile = MemoryTempfile()
else:
    import tempfile

import docker
client = docker.from_env()
try:
    client.images.get('tex-compilation-service:latest')
except docker.errors.ImageNotFound:
    print('Docker image not found, compiling... \n It takes ~10 min.')
    client.images.build(path='texcompile/service', tag='tex-compilation-service')
from utils.utils import start_container

import logging
logger = logging.getLogger(name=None)
logger.setLevel(logging.ERROR)
logging.basicConfig(filename='error.log', encoding='utf-8', level=logging.ERROR)

TIMEOUT_SECONDS = 60 * 60

def annotate(filename: Path, output: Path):
    try:
        container, port = start_container(filename.stem)
        print('Start:' ,filename, 'On port:', port) # os.getpid(),

        with tempfile.TemporaryDirectory() as td:
            try:
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
            except tarfile.ReadError:
                with gzip.open(filename, 'rb') as gz:
                    bytes_ = gz.read()
                    with open(td + '/main.tex', 'wb') as file:
                        file.write(bytes_)

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
            try:
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
            except tarfile.ReadError:
                with gzip.open(filename, 'rb') as gz:
                    bytes_ = gz.read()
                    with open(td + '/main.tex', 'wb') as file:
                        file.write(bytes_)
            tex_file = find_latex_file(Path(basename).stem, basepath=td)
            color_dict.extract_defs(tex_file, td, port)
            annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
            postprocess_latex(tex_file)
            shutil.make_archive(output/filename.stem, 'zip', td) # save annotated files for debugging
            basename, pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td,
                port=port
            ) # compile the modified latex
            shapes, tokens = pdf_extract(pdf_bytes)
            color_dict.run_standardize_tex()
        df_toc, df_data = export_annotation(shapes, tokens, color_dict)
        df_toc.to_csv(output/(str(filename.stem)+'_toc.csv'), sep='\t')
        df_data.to_csv(output/(str(filename.stem)+'_data.csv'), sep='\t')
        with tempfile.TemporaryDirectory() as td:
            color_dict = ColorAnnotation()
            color_dict.black = True
            try:
                with tarfile.open(filename ,'r:gz') as tar:
                    tar.extractall(td)
            except tarfile.ReadError:
                with gzip.open(filename, 'rb') as gz:
                    bytes_ = gz.read()
                    with open(td + '/main.tex', 'wb') as file:
                        file.write(bytes_)
            tex_file = find_latex_file(Path(basename).stem, basepath=td)
            # color_dict.extract_defs(tex_file, td, port)
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
        container.stop()
        return filename, 'LaTeX code compilation error.'
    except Exception as e:
        container.stop()
        return filename, str(e)
    

if __name__ == "__main__":
    import time
    set_start_method("spawn")
    print("Starting...")
    p = Path("/nfs/home/duan/texcompile")
    input_path = p/'downloaded'
    output_path = p/'outputs'
    output_path.mkdir(exist_ok=True)
    args = []
    for filename in input_path.glob('*.gz'):
        if not Path(output_path/(str(filename.stem)+'.pdf')).exists():
            args.append((filename, output_path))
    print('Find %d source files, starting annotate.' %len(args))
    with ProcessPool(max_workers=96) as pool:
        try:
            tasks = OrderedDict()
            for arg in args:
                future = pool.schedule(annotate, args=arg, timeout=TIMEOUT_SECONDS)
                tasks[future] = arg
            
            finished = 0
            num_tasks = len(tasks)
            for future in as_completed(tasks):
                finished += 1
                try:
                    r = future.result()  # blocks until results are ready
                except TimeoutError as error:
                    r = (tasks[future][0], 'Timeout.') 
                if r[1]:
                    logger.error(r[0].name + '\t' + r[1] + '\n')
                print("Finished task:{0}/{1}".format(finished, num_tasks))
        except KeyboardInterrupt:
            pool.terminate()
            pool.join()
            pool.close()