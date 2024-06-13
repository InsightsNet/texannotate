import os.path
import tempfile
from configparser import ConfigParser

import aiofiles
import uvicorn
from fastapi import FastAPI, File, UploadFile, Form

from lib.compile_autotex import compile_autotex
from lib.compile_latexml import compile_latexml

app = FastAPI()


@app.post("/")
async def detect_upload_file(
        sources: UploadFile = File(...), 
        autotex_or_latexml: str = Form(...),
        main_tex_file: str = Form(...)
    ):

    config = ConfigParser()
    config.read("service_config.ini")
    texlive_path = config["tex"]["texlive_path"]
    system_path = config["tex"]["system_path"]
    perl_binary = config["perl"]["binary"]

    with tempfile.TemporaryDirectory() as tempdir:
        print("executing", autotex_or_latexml)
        sources_filename = os.path.join(tempdir, "sources")
        async with aiofiles.open(sources_filename, "wb") as sources_file:
            content = await sources.read()  # async read
            await sources_file.write(content)  # async write
        if autotex_or_latexml == "autotex":
            json_result = compile_autotex(
                sources_filename, texlive_path, system_path, perl_binary
            )
            return json_result
        elif autotex_or_latexml == "latexml":
            json_result = compile_latexml(
                sources_filename, main_tex_file
            )
            return json_result
        else:
            pass


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
