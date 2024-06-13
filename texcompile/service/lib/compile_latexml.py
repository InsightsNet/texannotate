import base64
import json
import logging
import os
import os.path
import re
import subprocess
import tempfile
from argparse import ArgumentParser
from dataclasses import dataclass
from typing import Any, Dict, Iterator, List, Optional
import glob

from lib.unpack_tex import unpack_archive

Path = str


@dataclass
class OutputFile:
    output_type: str
    " Type of file output by running LaTeXML (e.g., 'xml', 'html')"

    path: Path
    """
    Path to file relative to the compilation directory.
    """


@dataclass
class CompiledTexFile:
    """
    A TeX file successfully compiled by AutoTeX.
    """

    path: Path
    """
    Path to file relative to the compilation directory.
    """


@dataclass(frozen=True)
class CompilationResult:
    success: bool
    compiled_tex_files: List[CompiledTexFile]
    output_files: List[OutputFile]
    stdout: bytes
    stderr: bytes


def compile_latexml(
    compressed_sources_file: str,
    main_tex_file: str
) -> Dict[str, Any]:
    if os.path.exists('/tmpfs'):
        tmp_path = '/tmpfs/'
    else:
        tmp_path = None
    with tempfile.TemporaryDirectory(dir=tmp_path) as temp_directory:
        sources_dir = os.path.join(temp_directory, "sources")
        unpack_archive(compressed_sources_file, sources_dir)
        before_compile_htmls = set(glob.glob(sources_dir+"/*.html"))
        compilation_result = run_compilation(
            sources_dir, main_tex_file
        )

        json_result: Dict[str, Any] = {}
        json_result["success"] = compilation_result.success
        if json_result["success"] is True:
            json_result["has_output"] = True
            file_diff = {}
        else:
            after_compile_htmls = set(glob.glob(sources_dir+"/*.html"))
            file_diff = after_compile_htmls - before_compile_htmls
            json_result["has_output"] = len(file_diff)!=0
        json_result["log"] = compilation_result.stdout.decode(
            "utf-8", errors="backslashreplace"
        )
        json_result["main_tex_files"] = [
            f.path for f in compilation_result.compiled_tex_files
        ]
        json_result["output"] = []
        for output_file in compilation_result.output_files + list(file_diff):
            if not isinstance(output_file, OutputFile):
                assert isinstance(output_file, str)
                output_file = OutputFile("html", output_file)
            with open(os.path.join(sources_dir, output_file.path), mode="rb") as file_:
                contents = file_.read()

            output = {
                "type": output_file.output_type,
                "path": output_file.path,
                "contents": base64.b64encode(contents).decode(),
            }
            json_result["output"].append(output)

    return json_result


def run_compilation(
    source_path: str, 
    main_file: str
) -> CompilationResult:
    """
    Compile TeX sources into HTML files. Requires running an external
    script to attempt to compile the TeX. See README.md for dependencies.
    """
    main_path = os.path.join(source_path, main_file)
    logging.debug("Compiling source %s.", main_path)
    if not os.path.exists(main_path):
        logging.warning("No .tex files found in %s.", source_path)

    _set_sources_dir_permissions(source_path)

    result = subprocess.run(
        ["latexmlc", main_path, "--post", "--dest="+main_path+".html", "--timeout=2400"], # expl3 needs 10+min to load https://github.com/brucemiller/LaTeXML/issues/2268
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )

    compiled_tex_files: List[CompiledTexFile] = []
    output_files: List[OutputFile] = []
    success = False
    if result.returncode == 0:
        compiled_tex_files.append(CompiledTexFile(main_path))
        output_files.append(OutputFile("html", main_file+".html"))
        success = True

    logging.debug(
        "Finished compilation attempt for source %s. Success? %s.",
        main_path,
        success,
    )

    return CompilationResult(
        success, compiled_tex_files, output_files, result.stdout, result.stderr
    )


def _set_sources_dir_permissions(sources_dir: str) -> None:
    """
    AutoTeX requires permissions to be 0777 or 0775 before attempting compilation.
    """
    COMPILATION_PERMISSIONS = 0o775
    os.chmod(sources_dir, COMPILATION_PERMISSIONS)
    for (dirpath, dirnames, filenames) in os.walk(sources_dir):
        for filename in filenames:
            os.chmod(os.path.join(dirpath, filename), COMPILATION_PERMISSIONS)
        for dirname in dirnames:
            os.chmod(os.path.join(dirpath, dirname), COMPILATION_PERMISSIONS)
