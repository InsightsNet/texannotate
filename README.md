# TeX Compilation Service

This service compiles TeX/LaTeX projects. It provides many conveniences, such as 
automatically detecting the main TeX file, compiling multiple files, and 
combining the output into a single file.

The compilation service is a lightweight wrapper around the 
[AutoTeX](https://metacpan.org/pod/TeX::AutoTeX) library used by arXiv to 
automatically compile submissions to arXiv.

## Setup

Build the Docker container for the service. This will take a long time, as the 
build requires an installation of the large TeX Live package and building a 
custom version of Perl.

```bash
docker build -t tex-compilation-service .
```

## Start the service

```bash
docker run -p 80:80 -it tex-compilation-service
```

## Query the service

The service takes as input a TeX/LaTeX project. The project should be gzipped 
tarball (i.e., `.tgz` or `.tar.gz` file) containing the TeX/LaTeX project.  The 
output is a JSON response, where all compiled output files (PDFs, PostScript 
files) are written in Base64.

Say, for example, you wish to compile the LaTeX project for arXiv paper 
1601.00978. First, fetch the sources for the project:

```bash
wget https://arxiv.org/e-print/1601.00978 --user-agent "Name <email>"
```

Then, submit the sources to the service (using the `requests` library (`pip 
install requests`)):

```python
# Read the gzipped tarball file containing the sources.
sources = open('1601.00978', 'rb')

# Prepare query parameters
files = {'compressed_sources': ('1601.00978', sources, 'multipart/form-data')}

# Make request to service. The port (80) should match the port passed as an
# argument in the "Start the service" section.
import requests
response = requests.post('http://127.0.0.1:80/', files=files)
```

Check for success of the job:
```python
# Get result
data = response.json()

# Check success.
print data['success']

# Check which files were determined to be the main TeX files (these were the TeX 
# files that were compiled).
print data['main_tex_files']
```

Then save the outputs (assuming the request was successful).

```python
import os
import base64

for i, output in enumerate(data['output']):
  ext = output['type']  # compiled files may be 'pdf' or 'ps'
  base64_contents = output['contents']
  contents = base64.b64decode(base64_contents)
  with open(f"compiled-file-{i}.{ext}", "wb") as file_:
    file_.write(contents)
```

In this case, open `compiled-file-0.pdf` and see the result of compiling the 
sources for arXiv paper 1601.00978.

## Caveats

This service will not compile all TeX/LaTeX projects. It is designed to compile 
those that are hosted on arXiv. In fact, its backend uses tools that arXiv uses 
to compile papers.

The service also has a low success rate compiling _recent_ arXiv papers written 
in the last few years, because the version of AutoTeX used to compile the papers 
is outdated. It is hoped that the AutoTeX dependency for this project will be 
upgraded soon.

## License

Apache 2.0.
