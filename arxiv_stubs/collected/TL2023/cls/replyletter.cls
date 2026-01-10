\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{replyletter}[2020/12/09 Reply letter to a review]

%% Article options
\DeclareOption{10pt}{
  \PassOptionsToClass{\CurrentOption}{article}
}

%% Custom package options
\DeclareOption{sans}{
  \PassOptionsToPackage{\CurrentOption}{custom}
}
\DeclareOption{neverindent}{
  \PassOptionsToPackage{\CurrentOption}{custom}
}

%% Fallback
\DeclareOption*{
  \ClassWarning{replyletter}{Unknown option '\CurrentOption'}
}

%% Execute default options
\ExecuteOptions{10pt}

%% Process given options
\ProcessOptions\relax

%% Load base
\LoadClass[a4paper]{article}

%% Load additional packages and commands.
%\RequirePackage{geometry}

%% Additional TeX/LaTeX code...
\RequirePackage[left=2.5cm,top=2.5cm,right=2.5cm,bottom=2.5cm,bindingoffset=0.5cm]{geometry}

\RequirePackage[pdftex]{graphicx}
\RequirePackage{caption}
\RequirePackage{subcaption}

\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{bm}
\RequirePackage{url}
\RequirePackage{xcolor}

\definecolor{mygray}{gray}{0.6}
\definecolor{darkgreen}{rgb}{0.0, 0.5, 0.0}
\definecolor{darkorchid}{rgb}{0.6, 0.18, 0.8}

\colorlet{c0}{darkorchid}
\colorlet{c1}{darkgreen}
\colorlet{c2}{red}
\colorlet{c3}{blue}

\newenvironment{myindent}
{\par\leftskip1cm\relax\rightskip1cm\relax}
{\par\leftskip0cm\relax\rightskip0cm\relax}

\newcommand{\doQuote}[1]{\begin{myindent}\textit{``#1''}\end{myindent}}

\setlength\parindent{0pt}

%% Define  Environments
\newenvironment*{reviewer}{
    \medskip  \itshape
}
{
}


\newenvironment{reply}
{   
    \medskip \noindent \color{black}
}
{ 
}
