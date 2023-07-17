import base64
import logging
import os
import os.path
import posixpath
import tarfile
import tempfile
from dataclasses import dataclass
from typing import Dict, List

import requests
from typing_extensions import Literal

logger = logging.getLogger("texcompile-client")


Path = str


class ServerConnectionException(Exception):
    pass


class CompilationException(Exception):
    pass


@dataclass
class OutputFile:
    type_: Literal["pdf", "ps"]
    name: str


@dataclass
class Result:
    success: bool
    main_tex_files: List[str]
    log: str
    output_files: List[OutputFile]

    def __repr__(self) -> str:
        return (
            f"Result: {'success' if self.success else 'failure'}. "
            + f"Compiled TeX [{', '.join(self.main_tex_files)}] "
            + f"into [{', '.join([f.name for f in self.output_files])}]. "
            + "Log: "
            + self.log[:100]
            + ("..." if len(self.log) > 100 else "")
        )


def compile(
    sources_dir: Path,
    output_dir: Path,
    host: str = "http://127.0.0.1",
    port: int = 8000,
) -> Result:

    with tempfile.TemporaryDirectory() as temp_dir:
        # Prepare a gzipped tarball file containing the sources.
        archive_filename = os.path.join(temp_dir, "archive.tgz")
        with tarfile.open(archive_filename, "w:gz") as archive:
            archive.add(sources_dir, arcname=os.path.sep)

        # Prepare query parameters.
        with open(archive_filename, "rb") as archive_file:
            files = {"sources": ("archive.tgz", archive_file, "multipart/form-data")}

            # Make request to service.
            endpoint = f"{host}:{port}/"
            try:
                response = requests.post(endpoint, files=files)
            except requests.exceptions.RequestException as e:
                raise ServerConnectionException(
                    f"Request to server {endpoint} failed.", e
                )

    # Get result
    data = response.json()

    # Check success.
    if not (data["success"] or data["has_output"]):
        raise CompilationException(data["log"])

    output_files: List[OutputFile] = []
    result = Result(
        success=data["success"],
        main_tex_files=data["main_tex_files"],
        log=data["log"],
        output_files=output_files,
    )

    # Save outputs to output directory, and create manifest of output files.
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for i, output in enumerate(data["output"]):
        type_ = output["type"]
        # Use posixpath to get the base name, with the assumption that the TeX server will be
        # returning paths to compiled files in POSIX style (rather than, say, Windows).
        basename = posixpath.basename(output["path"])
        output_files.append(OutputFile(type_, basename))

        # Save output file to the filesystem.
        save_path = os.path.join(output_dir, basename)
        if os.path.exists(save_path):
            logger.warning(
                "File already exists at %s. The old file will be overwritten.",
                save_path,
            )
        base64_contents = output["contents"]
        contents = base64.b64decode(base64_contents)
        with open(save_path, "wb") as file_:
            file_.write(contents)

    return result
