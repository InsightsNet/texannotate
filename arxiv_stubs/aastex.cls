\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aastex}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for old AASTeX sources on arXiv.
% Loads standard article and defines common AASTeX macros as no-ops.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\shorttitle}[1]{}
\newcommand{\shortauthors}[1]{}
\newcommand{\affil}[1]{\par\small #1\par\normalsize}
\newcommand{\email}[1]{}
\newcommand{\altaffilmark}[1]{}
\newcommand{\altaffiltext}[2]{}
\newcommand{\submitted}[1]{}
\newcommand{\accepted}[1]{}
\newcommand{\journalid}[2]{}
\newcommand{\articleid}[2]{}
\newcommand{\doi}[1]{}
\newcommand{\epsscale}[1]{}
\newcommand{\plotone}[1]{\includegraphics{#1}}
\newcommand{\plottwo}[2]{\includegraphics{#1}\includegraphics{#2}}
\newcommand{\plotfiddle}[7]{\includegraphics{#1}}
\newenvironment{deluxetable}[1][]{\begin{table}}{\end{table}}
\newcommand{\tablecaption}[1]{\caption{#1}}
\newcommand{\tablehead}[1]{}
\newcommand{\startdata}{}
\newcommand{\enddata}{}
\newcommand{\tablenotetext}[2]{}
\endinput


