\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{iopart}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for IOP sources that expect iopart.cls (often provided by arXiv).
% Loads standard article and defines common macros as no-ops.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\address}[1]{\par\small #1\par\normalsize}
\newcommand{\ead}[1]{}
\newcommand{\ioptwocol}[1]{#1}
\newcommand{\sectionmark}[1]{}
\newcommand{\subsectionmark}[1]{}
\newenvironment{abstract}{\begin{quotation}\small}{\end{quotation}}
\endinput


