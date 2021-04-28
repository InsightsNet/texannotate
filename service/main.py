import os.path
import tempfile
from configparser import ConfigParser

import aiofiles
import uvicorn
from fastapi import FastAPI, File, UploadFile

from lib.compile import compile_tex

app = FastAPI()


@app.post("/")
async def detect_upload_file(sources: UploadFile = File(...)):

    config = ConfigParser()
    config.read("service_config.ini")
    texlive_path = config["tex"]["texlive_path"]
    system_path = config["tex"]["system_path"]
    perl_binary = config["perl"]["binary"]

    with tempfile.TemporaryDirectory() as tempdir:
        sources_filename = os.path.join(tempdir, "sources")
        async with aiofiles.open(sources_filename, "wb") as sources_file:
            content = await sources.read()  # async read
            await sources_file.write(content)  # async write

        json_result = compile_tex(
            sources_filename, texlive_path, system_path, perl_binary
        )
        return json_result


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
