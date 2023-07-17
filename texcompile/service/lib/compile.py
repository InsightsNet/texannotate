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

PDF_MESSAGE_PREFIX = b"Generated PDF: "
PDF_MESSAGE_SUFFIX = b"<end of PDF name>"
POSTSCRIPT_MESSAGE_PREFIX = b"Generated PostScript: "
POSTSCRIPT_MESSAGE_SUFFIX = b"<end of PostScript name>"


Path = str


@dataclass
class OutputFile:
    output_type: str
    " Type of file output by running TeX (e.g., 'ps', 'pdf')"

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


def compile_tex(
    compressed_sources_file: str,
    texlive_path: Path,
    system_path: Path,
    perl_binary: Path,
) -> Dict[str, Any]:
    if os.path.exists('/tmpfs'):
        tmp_path = '/tmpfs/'
    else:
        tmp_path = None
    with tempfile.TemporaryDirectory(dir=tmp_path) as temp_directory:
        sources_dir = os.path.join(temp_directory, "sources")
        unpack_archive(compressed_sources_file, sources_dir)
        before_compile_pdfs = set(glob.glob(sources_dir+"/*.pdf"))
        compilation_result = run_compilation(
            sources_dir, texlive_path, system_path, perl_binary
        )

        json_result: Dict[str, Any] = {}
        json_result["success"] = compilation_result.success
        if json_result["success"] is True:
            json_result["has_output"] = True
            file_diff = {}
        else:
            after_compile_pdfs = set(glob.glob(sources_dir+"/*.pdf"))
            file_diff = after_compile_pdfs - before_compile_pdfs
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
                output_file = OutputFile("pdf", output_file)
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
    sources_dir: str, texlive_path: Path, system_path: Path, perl_binary: Path
) -> CompilationResult:
    """
    Compile TeX sources into PDFs and PostScript files. Requires running an external
    script to attempt to compile the TeX. See README.md for dependencies.
    """
    logging.debug("Compiling sources in %s.", sources_dir)
    tex_files = [f for f in os.listdir(sources_dir) if f.endswith(".tex")]
    if not tex_files:
        logging.warning("No .tex files found in %s.", sources_dir)

    _set_sources_dir_permissions(sources_dir)

    result = subprocess.run(
        [perl_binary, "run_autotex.pl", sources_dir, texlive_path, system_path,],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )

    compiled_tex_files: List[CompiledTexFile] = []
    output_files: List[OutputFile] = []
    success = False
    if result.returncode == 0:
        for pdf_filename in _get_generated_pdfs(result.stdout):
            output_files.append(OutputFile("pdf", pdf_filename))
        for postscript_filename in _get_generated_postscript_filenames(result.stdout):
            output_files.append(OutputFile("ps", postscript_filename))
        compiled_tex_files = get_compiled_tex_files_from_autotex_output(result.stdout)
        success = True

    logging.debug(
        "Finished compilation attempt for sources in %s. Success? %s.",
        sources_dir,
        success,
    )

    return CompilationResult(
        success, compiled_tex_files, output_files, result.stdout, result.stderr
    )


def _get_generated_pdfs(stdout: bytes) -> List[str]:
    pdfs = re.findall(
        PDF_MESSAGE_PREFIX + b"(.*)" + PDF_MESSAGE_SUFFIX, stdout, flags=re.MULTILINE
    )
    return [pdf_name_bytes.decode("utf-8") for pdf_name_bytes in pdfs]


def _get_generated_postscript_filenames(stdout: bytes) -> List[str]:
    postscript_filenames = re.findall(
        POSTSCRIPT_MESSAGE_PREFIX + b"(.*)" + POSTSCRIPT_MESSAGE_SUFFIX,
        stdout,
        flags=re.MULTILINE,
    )
    return [
        postscript_name_bytes.decode("utf-8")
        for postscript_name_bytes in postscript_filenames
    ]


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


def get_compiled_tex_files_from_autotex_output(
    tex_engine_output: bytes,
) -> List[CompiledTexFile]:
    processed_tex_files = re.findall(
        rb"\[verbose\]:  ~~~~~~~~~~~ Processing file '(.*?)'", tex_engine_output
    )
    failed_tex_files = re.findall(
        rb"<(.*?)> appears to be tex-type, but was neither included nor processable:",
        tex_engine_output,
    )
    return [
        CompiledTexFile(filename.decode("utf-8"))
        for filename in processed_tex_files
        if filename not in failed_tex_files and not filename.endswith(b".dvi")
    ]


def get_errors(tex_engine_output: bytes, context: int = 5) -> Iterator[bytes]:
    """
    Extract a list of TeX errors from the TeX compiler's output. 'context' is the number of
    lines to extract after each error symbol ('!'). The list of errors produced by this method may
    be inaccurate and incomplete.
    """
    lines = tex_engine_output.splitlines()
    for i, line in enumerate(lines):
        if line.startswith(b"!"):
            yield b"\n".join(lines[i : i + context])


COMPILER_RUNNING_PATTERN = re.compile(r"[~]+ Running (.*?) for the first time [~]+")


def get_last_autotex_compiler(autotex_log: str) -> Optional[str]:
    compiler_names = COMPILER_RUNNING_PATTERN.findall(autotex_log)
    if compiler_names and isinstance(compiler_names[-1], str):
        return compiler_names[-1]
    return None


def get_compilation_logs(autotex_log: str, compiler_name: str) -> List[str]:
    """
    Get AutoTeX logs for a specific TeX compiler that was attempted.
    May return multiple logs, one for each pass of that compiler. There may be multiple
    passes of a compiler as AutoTeX may run a compiler multiple times to resolve citations
    and other references in the document.
    """

    current_compiler = None
    log_start = None
    logs: List[str] = []

    for match in COMPILER_RUNNING_PATTERN.finditer(autotex_log):
        if log_start is not None and current_compiler == compiler_name:
            logs.append(autotex_log[log_start : match.start()])

        log_start = match.end()
        current_compiler = match.group(1)

    if current_compiler == compiler_name:
        logs.append(autotex_log[log_start : len(autotex_log)])

    return logs


def did_compilation_fail(autotex_log: str, compiler_name: str) -> bool:
    EMERGENCY_STOP_PATTERN = re.compile(r"^! Emergency stop.", flags=re.MULTILINE)
    for log in get_compilation_logs(autotex_log, compiler_name):
        if EMERGENCY_STOP_PATTERN.search(log) is not None:
            return True
    return False


if __name__ == "__main__":
    parser = ArgumentParser(description="Compile TeX project.")
    parser.add_argument(
        "--sources",
        required=True,
        help=(
            "Path to gzipped tar file that contains LaTeX sources. This is the format "
            + "that the sources for arXiv will be automatically downloaded in."
        ),
    )
    parser.add_argument(
        "--texlive-path",
        required=True,
        help=(
            "Path to TeXLive distribution. Examples: "
            + "/usr/local/texlive/2017, /opt/texlive/2009/. "
            + "There should be a texmf.cnf file in this directory."
        ),
    )
    parser.add_argument(
        "--system-path",
        required=True,
        help=(
            "System path. Should include the directories that contain "
            + "TeX/LaTeX binaries (e.g., pdflatex, latex, etc.) as well as common command "
            "line utilities (e.g., mkdir)."
        ),
    )
    parser.add_argument(
        "--perl",
        required=True,
        help="Path to Perl binary that can be used to run the AutoTeX scripts. Note that "
        + "the Perl binary should be one that has access to the AuToTeX library.",
    )
    args = parser.parse_args()

    result = compile_tex(args.sources, args.texlive_path, args.system_path, args.perl)
    print(json.dumps(result, indent=2))
