\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SciPost} % SciPost Latex Template (2021-08)


\LoadClass[11pt,a4paper]{article}


% Layout
\RequirePackage[top=12mm,bottom=12mm,left=30mm,right=30mm,head=12mm,includeheadfoot]{geometry}
\bigskipamount 6mm

% For table of contents: remove trailing dots
\RequirePackage{tocloft}
\renewcommand{\cftdot}{}
% Add References to TOC
\RequirePackage[nottoc,notlot,notlof]{tocbibind}


% Spacings between (sub)sections:
\RequirePackage{titlesec}
\titlespacing*{\section}{0pt}{1.8\baselineskip}{\baselineskip}


% Unicode characters
\RequirePackage[utf8]{inputenc}

% doi links in references
\RequirePackage{doi}

% Math formulas and symbols
%\RequirePackage{amsmath,amssymb} % Redundant (clashes with mathdesign)
\RequirePackage{amsmath}

% Hyperrefs
\RequirePackage{hyperref}

% Include line numbers in submissions
\RequirePackage{lineno}

% SciPost BiBTeX style
\bibliographystyle{SciPost_bibstyle}

% SciPost header and footer
\RequirePackage{fancyhdr}
\pagestyle{fancy}

\makeatletter
  \let\ps@plain\ps@fancy
\makeatother

\RequirePackage{xcolor}
\definecolor{scipostdeepblue}{HTML}{002B49}
\definecolor{scipostphys}{HTML}{0019A2}
\definecolor{scipostastro}{HTML}{946E13}
\definecolor{scipostbio}{HTML}{2B7E13}
\definecolor{scipostchem}{HTML}{605AAF}
\definecolor{scipostcompsci}{HTML}{0AADAB}
\definecolor{scipostmath}{HTML}{A10800}

\RequirePackage{graphicx}

\RequirePackage{cite}

\RequirePackage[width=.90\textwidth]{caption}


%% Patch lineno when used with amsmath
\newcommand*\patchAmsMathEnvironmentForLineno[1]{%
\expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
\expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
\renewenvironment{#1}%
{\linenomath\csname old#1\endcsname}%
{\csname oldend#1\endcsname\endlinenomath}}%
\newcommand*\patchBothAmsMathEnvironmentsForLineno[1]{%
\patchAmsMathEnvironmentForLineno{#1}%
\patchAmsMathEnvironmentForLineno{#1*}}%
\AtBeginDocument{%
\patchBothAmsMathEnvironmentsForLineno{equation}%
\patchBothAmsMathEnvironmentsForLineno{align}%
\patchBothAmsMathEnvironmentsForLineno{flalign}%
\patchBothAmsMathEnvironmentsForLineno{alignat}%
\patchBothAmsMathEnvironmentsForLineno{gather}%
\patchBothAmsMathEnvironmentsForLineno{multline}%
}
%% End patch lineno


\DeclareOption{submission}{
  \rhead{
    {\bf \color{scipostdeepblue} ~Submission }
  }
 }


%%%%%%%%%% Physics
\DeclareOption{Phys}{
\lhead{
  \colorbox{scipostphys}{\bf \color{white} ~SciPost Physics }
}
}

\DeclareOption{PhysCore}{
\lhead{
  \colorbox{scipostphys}{\bf \color{white} ~SciPost Physics Core}
}
}

\DeclareOption{PhysLectNotes}{
  \lhead{
    \colorbox{scipostphys}{\strut \bf \color{white} ~SciPost Physics Lecture Notes }
  }
}

\DeclareOption{PhysProc}{
\lhead{
  \colorbox{scipostphys}{\strut \bf \color{white} ~SciPost Physics Proceedings }
}
}

\DeclareOption{PhysCodeb}{
\lhead{
  \colorbox{scipostphys}{\strut \bf \color{white} ~SciPost Physics Codebases }
}
}

%%%%%%%%%%% Astronomy
\DeclareOption{Astro}{
\lhead{
  \colorbox{scipostastro}{\strut \bf \color{white} ~SciPost Astronomy }
}
}


%%%%%%%%%%% Biology
\DeclareOption{Bio}{
\lhead{
  \colorbox{scipostbio}{\strut \bf \color{white} ~SciPost Biology }
}
}


%%%%%%%%%%% Chemistry
\DeclareOption{Chem}{
\lhead{
  \colorbox{scipostchem}{\strut \bf \color{white} ~SciPost Chemistry }
}
}


%%%%%%%%%%% Computer Science
\DeclareOption{CompSci}{
\lhead{
  \colorbox{scipostcompsci}{\strut \bf \color{white} ~SciPost Computer Science }
}
}


%%%%%%%%%%% Mathematics
\DeclareOption{Math}{
\lhead{
  \colorbox{scipostmath}{\strut \bf \color{white} ~SciPost Mathematics }
}
}


\ProcessOptions\relax
