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
cd service
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

Then, unpack the sources into a directory:

```bash
tar xzvf 1601.00978 -C example-sources
```

Queries to the service can be made through a dedicated client library, which you 
can install as follows:

```bash
pip install git+https://github.com/andrewhead/texcompile
```

Once the client library is installed, you can make a request like so:

```python
from texcompile import compile

result = compile(
  sources_dir='example-sources',
  output_dir='outputs',
)
```

Inspect whether the request succeeded:

```python
# Did the query succeed?
print(result.success)  # Output: True

# What are the main TeX files that were compiled to produce the outputs? Note 
# that this only contains the names of main files that the TeX/LaTeX binaries
# were called on, and not those that were 'input' or 'included'.
print(result.main_tex_files)  # Output: ['craternn.tex']

# Inspect compilation logs.
print(result.logs)  # Output: <Long string of logs from compiling the TeX>

# Manifest of generated files.
print(result.output_files)  # Output: [{ 'type': 'pdf', 'name': 'craternn.pdf' }]
```

Each of the files listed in `result.output_files` will have been written into 
the `output_dir` supplied as an argument to `compile`. At this point, you should 
be able to open `outputs/craternn.pdf` to see the compiled PDF. Generated files 
may be either PDFs (type: `pdf`) or PostScript files (type: `ps`).

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
