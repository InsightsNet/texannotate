\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{PoS}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for Proceedings of Science class PoS.cls.
% Loads standard article and defines expected macros as no-ops.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\Title}[1]{\title{#1}}
\newcommand{\Author}[2][]{\author{#2}}
\newcommand{\Affiliation}[1]{\par\small #1\par\normalsize}
\newcommand{\Email}[1]{}
\newcommand{\Abstract}[1]{\begin{abstract}#1\end{abstract}}
\newcommand{\FullConference}[1]{}
\newcommand{\ShortTitle}[1]{}
\newcommand{\ShortAuthor}[1]{}
\endinput


