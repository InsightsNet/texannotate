% This is a LaTeX 2e Class file for creating ArXiv preprint
\pdfoutput=1

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{arxiv-icarus}[2020/01/08 Icarus class for arXiv]

% Inherit elsarticle with default options
\LoadClass[preprint,twocolumn,5p,authoryear]{elsarticle}

% Default journal preprint submission
\journal{Icarus}

% ArXiv author (year) BibTeX style
\bibliographystyle{arxiv-ay}

% Import packages
\RequirePackage{lineno}
\RequirePackage{siunitx}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{pdflscape}
\RequirePackage{subcaption}
\RequirePackage[version=4]{mhchem}
\RequirePackage[
    labelfont=bf,
    justification=justified,
    singlelinecheck=false
]{caption}
\RequirePackage[
    colorlinks=true,
    urlcolor=blue,
    citecolor=black,
    linkcolor=black
]{hyperref}
\RequirePackage{cleveref}

% Configuration line modulo
\modulolinenumbers[1]

% Caption configuration
\captionsetup[figure]{name=Fig. ,labelsep=period,aboveskip=5pt,belowskip=-5pt, textfont=it}
\captionsetup[sub]{position=top,justification=centering}
\captionsetup[table]{name=Tab. ,labelsep=period,aboveskip=10pt,belowskip=-5pt, textfont=it}

% SIunitx configuration
\sisetup{group-separator = {,}}
\sisetup{range-phrase=--}

% Autoref configuration
\def\figureautorefname{Fig.}
\def\equationautorefname~#1\null{Eq.~(#1)\null}

% Center figures and tables
\makeatletter
\g@addto@macro\@floatboxreset\centering
\makeatother

% SI unitx setup
\sisetup{
 detect-all,
 exponent-product=\cdot,
 separate-uncertainty=true,
 multi-part-units=single,
 bracket-numbers=false,
 inter-unit-product=.,
 range-units=single,
 arc-separator=\,
}

% Shortcuts
\newcommand{\DOI}[1]{\newline\noindent\small\textit{\small{doi:}}\href{https://doi.org/#1}{#1}}
\newcommand{\figref}[1]{\autoref{fig:#1}}
\newcommand{\tabref}[1]{\autoref{tab:#1}}
\renewcommand{\eqref}[1]{\autoref{eq:#1}}
\newcommand{\sref}[1]{\cref{sec:#1}}

\newcommand{\eg}{\emph{e.g.,}~}
\newcommand{\ie}{\emph{i.e.,}~}
\newcommand{\etc}{\emph{etc.}~}

% Corresponding author
\newcommand{\contact}[1]{%
\corref{correspondingauthor}%
\cortext[correspondingauthor]{Corresponding author: \href{mailto:#1}{#1}}
}
