# TeX Annotate

This service transform LaTeX codes into PDFs and extract detailed layout and reading information. 
Designed specifically for the academic and research community, 
this tool not only compiles LaTeX but also annotates each token and image, 
retrieves their positions in the PDF, identifies corresponding layout labels, and mark the correct reading order. 


## Main Purpose:

1. **LaTeX Compilation**: Transform LaTeX into PDF using a dockerized environment, leveraging TexLive2023.
2. **Code Annotation**: Add color labels to each token and figure in LaTeX code to facilitate automatic extraction of document layout.
3. **Data Extraction**: Extract fine information about every token and figure, such as its type, position, and corresponding section in the compiled PDF document, and output this as a pandas DataFrame.

## Prerequisites:

- Docker
- Python3

## Usage:

```bash
git clone https://github.com/InsightsNet/texannotate.git
cd texannotate
pip install -r requirements.txt
```

For example, you wish to compile the LaTeX project for arXiv paper 
1601.00978. First, fetch the sources for the project:

```bash
mkdir downloaded
wget -O downloaded/1601.00978.tar.gz https://arxiv.org/e-print/1601.00978 --user-agent "Name <email>"
python main.py
```

## Acknowledgments
The compilation service is a lightweight wrapper around the 
[AutoTeX](https://metacpan.org/pod/TeX::AutoTeX) library used by arXiv to 
automatically compile submissions to arXiv.

## License

Apache 2.0.
