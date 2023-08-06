# TeX Annotate

This service transform LaTeX codes into PDFs and extract detailed layout and reading information. 
Designed specifically for the academic publications.
This tool not only compiles LaTeX but also annotates each token and figures, 
retrieves their positions in the PDF, identifies corresponding semantic structure labels, and mark the correct reading order. 


## Main Purpose:

1. **LaTeX Compilation**: Transform LaTeX into PDF using a dockerized environment, leveraging TexLive2023.
2. **LaTeX Annotation**: Add color labels to each token and figure in LaTeX code to facilitate automatic extraction of document layout.
3. **Data Extraction**: Extract fine information about every token and figure, such as its type, position, and corresponding section in the compiled PDF document, and output this as a pandas DataFrame.

## Prerequisites:

- Docker
- Python3.8+

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

## Output Format

The tool outputs a pandas DataFrame for each input LaTeX source package, which has a total of 13 columns.

| reading_order | label | head | section | token | page | x0    | y0    | x1    | y1    | font | size  | flags |
|---------------|-------|------|---------|-------|------|-------|-------|-------|-------|------|-------|-------|
| int           | str   | int  | int     | str   | int  | float | float | float | float | str  | float | list  |

The DataFrame has two parts: 
1. The first n rows are the Toble of Contents nodes, whose *reading_order* column is -1 and *label* is *TOCNode*, *section* is the id of this node and *head* is the id of its parent node;
2. Each subsequent line is an figure or token being extracted from the PDF, the integer *reading_order* starting from 0 is the author's writing order. If it is -1, the token is not content written by the author (e.g., watermarks and headers).


*label* are semantic structure labels, which includes: Abstract, Author, Caption, Equation, Figure, Footer, List, Paragraph, Reference, Section, Table, Title.
 
## Acknowledgments

- The compilation service is a dockerized wrapper around the [AutoTeX](https://metacpan.org/pod/TeX::AutoTeX) library used by arXiv to automatically compile submissions to arXiv. We [modified](https://github.com/Fireblossom/TeX-AutoTeX-Mod.git) part of it.
- The code for the compilation service is essentially inherited from [texcompile](https://github.com/andrewhead/texcompile.git), and this repository was formerly a fork of it.
- [pylatexenc](https://github.com/phfaist/pylatexenc.git) 3.0alpha is used to identify and traverse the latex code.
- [pdfplumber](https://github.com/jsvine/pdfplumber.git) is used to extract shapes and texts from PDF files.

## License

Apache 2.0.
