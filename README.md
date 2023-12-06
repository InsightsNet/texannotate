# LaTeX Rainbow

This service compiles LaTeX codes into PDFs and extract detailed layout and reading information. 
Designed specifically for the academic publications.
This tool not only compiles LaTeX but also annotates each token and figures, 
retrieves their positions in the PDF, identifies corresponding semantic structure labels, and mark the correct reading order. 


## Main Purpose:

1. **LaTeX Compilation**: Compile LaTeX into PDF using a dockerized environment, leveraging TexLive2023.
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

For example, you wish to annotate the LaTeX project for arXiv paper 
[1601.00978](https://arxiv.org/pdf/1601.00978). First, fetch the sources for the project:

```bash
mkdir downloaded
wget -O downloaded/1601.00978.tar.gz https://arxiv.org/e-print/1601.00978 --user-agent "Name <email>"
python main.py
```

## Output Format

The tool outputs two pandas DataFrame for each input LaTeX source package, which has a total of 13 columns.

### Table of Contents
| section_id | nested_to |
|---------------|-------|
| int           | int   |

The first row is the Table of Contents root node,  whose *section_id* is the 0 and *nested_to* is -1;


### Figures and Tokens
| reading_order | label | block_id | section_id | token | page | x0    | y0    | x1    | y1    | font | size  | flags |
|---------------|-------|------|---------|-------|------|-------|-------|-------|-------|------|-------|-------|
| int           | str   | int  | int     | str   | int  | float | float | float | float | str  | float | list  |

Each row is an figure or token being extracted from the PDF, the integer *reading_order* starting from 0 is the author's writing order. 
If it is -1, the token is not content written by the author (e.g., watermarks and headers).
*label* are semantic structure labels, which includes: Abstract, Author, Caption, Equation, Figure, Footer, List, Paragraph, Reference, Section, Table, Title.

See [example](doc/example.ipynb) about the annotation of one paper.

Here's another [example](doc/tree_summarize.ipynb) summarizing the details of the paper with an LLM.

## Publication
This work was presented at The 2nd Workshop on Information Extraction from Scientific Publications (WIESP) @ IJCNLP-AACL 2023. 
Proceedings can be found [here](https://ui.adsabs.harvard.edu/WIESP/2023/book.pdf), and will appear in ACL Anthology shortly.

This work was also presented in non-archived form at 3rd Workshop for Natural Language Processing Open Source Software (NLP-OSS) @ EMNLP 2023, you can read our poster [here](https://github.com/nlposs/NLP-OSS/blob/master/nlposs-2023/23-LaTeX-Rainbow-Poster.pdf).

## Acknowledgments

- The compilation service is a dockerized wrapper around the [AutoTeX](https://metacpan.org/pod/TeX::AutoTeX) library used by arXiv to automatically compile submissions to arXiv. We [modified](https://github.com/) part of it.
- The code for the compilation service is essentially inherited from [texcompile](https://github.com/andrewhead/texcompile.git), and this repository was formerly a fork of it.
- [pylatexenc](https://github.com/phfaist/pylatexenc.git) 3.0alpha is used to identify and traverse the latex code.
- [pdfplumber](https://github.com/jsvine/pdfplumber.git) is used to extract shapes and texts from PDF files.

# TODO:
- [x] A prettier frontend (like streamlit) to interact with papers and(or) to bundle with LLMs.
- [x] Parse `.cls` and `.sty` file.
  - [ ] Cannot parse some environment, we need update `pylatexenc`.
- [ ] Make our own LaTeX package inheriting from [xcolor](https://github.com/latex3/xcolor) in CTAN to avoid conflict.
  - [ ] Investigate Underlying logic of the coloring order.
  - [ ] Explore the method of SyncTex.
  - [ ] Line based label correction.
- [x] Rainbow colors [#1](https://github.com/InsightsNet/texannotate/pull/1) 
- [x] Improve Parsing rules (from Overleaf and TeX-Workshop):
   - [x] Package command definitions from [TeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop/tree/master/data) ~~and [Overleaf](https://github.com/overleaf/overleaf/tree/main/services/web/frontend/js/features/source-editor/languages/latex/completions/data)~~.
      - [ ] Adapt `pylatexenc` for such the case of `\pagebreak<blah>` and `\verb|blah|`
      - [ ] Refine the parsing function for such the case of `\newcommand{\be}{\begin{equation}}`, consider replace the commands?
      - [ ] Combine `pylatexenc` with `latex-utensils` and `unified-latex`.
   - [x] `\newcommand` parsing strategy from ~~[Tex-Workshop (using unified-latex)](https://github.com/James-Yu/LaTeX-Workshop/blob/856eaeebd66e16b9f8d500793f307aa02d4295eb/src/providers/completer/command.ts#L208) and [Overleaf (using Lezer)](https://github.com/overleaf/overleaf/blob/main/services/web/frontend/js/features/source-editor/lezer-latex/README.md)~~ `pylatexenc`.
- [x] Imporve document structure extraction rule from [TeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop/blob/6ee7aca5dfe057642fec1781b6810796d745862e/src/providers/structurelib/latex.ts#L114C25-L114C25) 
- [x] Parallelization
  - [ ] Take advantage of container reusability
- [x] Evlauate annotation

## License

Apache 2.0.
