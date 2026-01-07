\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aastex6}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for AASTeX v6 sources that expect aastex6.cls.
% Loads standard article and provides common interface macros as no-ops.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\shorttitle}[1]{}
\newcommand{\shortauthors}[1]{}
\newcommand{\correspondingauthor}[1]{}
\newcommand{\email}[1]{}
\newcommand{\affiliation}[1]{\par\small #1\par\normalsize}
\newcommand{\altaffiliation}[1]{}
\newcommand{\submitjournal}[1]{}
\newcommand{\journalinfo}[1]{}
\newcommand{\received}[1]{}
\newcommand{\revised}[1]{}
\newcommand{\accepted}[1]{}
\newcommand{\publishaccepted}[1]{}
\newcommand{\keywords}[1]{}
\newenvironment{deluxetable*}[1][]{\begin{table*}}{\end{table*}}
\newenvironment{deluxetable}[1][]{\begin{table}}{\end{table}}
\newcommand{\tablecaption}[1]{\caption{#1}}
\newcommand{\tablehead}[1]{}
\newcommand{\startdata}{}
\newcommand{\enddata}{}
\newcommand{\tablenotemark}[1]{}
\newcommand{\tablenotetext}[2]{}
\endinput


