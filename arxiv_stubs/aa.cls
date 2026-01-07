\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aa}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for Astronomy & Astrophysics class aa.cls.
% Loads standard article and provides minimal hooks.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\titlerunning}[1]{}
\newcommand{\authorrunning}[1]{}
\newcommand{\institute}[1]{\par\small #1\par\normalsize}
\newcommand{\offprints}[1]{}
\newcommand{\mail}[1]{}
\newcommand{\datecitation}[1]{}
\newcommand{\abstract}[2][]{\begin{abstract}#2\end{abstract}}
\endinput


