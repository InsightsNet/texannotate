\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{svmult}[2026/01/07 Minimal stub for offline compilation]
%
% Compatibility stub for Springer svmult.cls.
% Loads standard article and defines common metadata macros.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\newcommand{\subtitle}[1]{}
\newcommand{\titlerunning}[1]{}
\newcommand{\authorrunning}[1]{}
\newcommand{\institute}[1]{\par\small #1\par\normalsize}
\newcommand{\email}[1]{}
\newcommand{\thanks}[1]{}
\endinput


