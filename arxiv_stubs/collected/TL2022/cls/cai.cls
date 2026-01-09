%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Canadian AI Latex Class       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cai}
\LoadClass[10pt, hidelinks, oneside, reqno]{amsart}
\numberwithin{equation}{section}
\linespread{1.0}

% Packages

\usepackage{todonotes}
\usepackage{indentfirst}
\usepackage{setspace}
\usepackage{soul}
\usepackage[letterpaper, margin=1.5in,includehead=false,top=1in]{geometry}
\usepackage{float}
\usepackage[colorlinks=true, linkcolor=black, urlcolor=blue, citecolor=blue, anchorcolor=blue]{hyperref}
\usepackage{wrapfig}
\usepackage{comment}
\usepackage{textgreek}
\usepackage{url}
\usepackage[font=footnotesize,labelfont=it]{caption}

% modify the abstract section
\usepackage{abstract}
\renewenvironment{abstract}
  {\footnotesize\quotation
  {\bfseries\noindent{%\scshape{
  \abstractname}%}
  \par\nobreak\smallskip}}
  {\endquotation}
%%%%%%%%%%%%
\usepackage{enumitem, comment, xifthen}
\usepackage{amsmath,amssymb,amsthm, amsfonts}
\usepackage[T1]{fontenc}
\usepackage{makecell}
\usepackage{booktabs}
\usepackage[style=numeric, citestyle=numeric-comp,maxnames=15, giveninits, sorting=none, natbib]{biblatex}
\renewcommand*{\bibfont}{\small}

% \usepackage{subcaption}
\DeclareMathOperator*{\E}{\bf E}
\addbibresource{references.bib}

\usepackage{booktabs}
\usepackage{hhline}
\usepackage{array,multirow}
\usepackage{lipsum}
\usepackage{siunitx,etoolbox}

\interfootnotelinepenalty=1000
\usepackage{graphicx}

\usepackage{tikz}
\usepackage{lipsum}


%%%%%%%%%%%%%%%%%%%%%
% Custom commands   %
%%%%%%%%%%%%%%%%%%%%%

% Title Formatting

\makeatletter
\renewcommand*\maketitle{%
    \begingroup
    \centering
    \fontsize{15}{20}
    \fontseries{b}
    \selectfont
    \@title
    \par
    \vskip 0.5cm
    \endgroup
}
\makeatother

% Affiliation markers
\newcommand{\upstairs}[1]{\textsuperscript{#1}}
\newcommand{\affilone}{\dag}
\newcommand{\affiltwo}{\ddag}
\newcommand{\affilthree}{$\diamond$}

% Header with the logo, to appear in upper left hand corner
\newcommand{\volumeheader}[2]{%
\begin{tikzpicture}[remember picture,overlay]
    \node[inner sep=0] (image) at (12,1.75){\includegraphics[scale=.3]{logo}};
        \node at (3.9,2) {The #1th Canadian Conference on Artificial Intelligence};
        \node at (.2,1.5) {DOI: #2}; 
        \node at (6.6, 1.2) {\noindent\makebox[\textwidth]{\rule{\textwidth}{0.3pt}}};
        
  \end{tikzpicture}
}


% Author emails, to appear directly above copyright notice
\newcommand{\emails}[1]
{
\begin{tikzpicture}[remember picture,overlay]
  \node[anchor=south,xshift=0pt, yshift=65pt] at (current page.south) {
  \setlength{\fboxrule}{0pt}
  \fbox{\parbox{\dimexpr\textwidth-\fboxsep-\fboxrule\relax}{ 
    \footnotesize #1}
    }
  };
\end{tikzpicture}%

}

% Copyright notice, to appear at bottom of first page
\newcommand{\copyrightnotice}[1]{%
\begin{tikzpicture}[remember picture,overlay]
  \node[anchor=south, xshift=0pt, yshift=5pt] at (current page.south) {\fbox{\parbox{\dimexpr\textwidth-\fboxsep-\fboxrule\relax}{\footnotesize This article is \copyright{} \the\year{} by author(s) as listed above. The article is licensed under a Creative Commons Attribution (CC BY 4.0) International license (https://creativecommons.org/licenses/by/4.0/legalcode), except where otherwise indicated with respect to particular material included in the article. The article should be attributed to the author(s) identified above.}}};
\end{tikzpicture}%
}

\makeatletter
\renewcommand\section{\@startsection {section}{1}{
\z@}%
                               {-3ex \@plus -1ex \@minus -.2ex}%
                               {2ex \@plus.2ex}%
                               {\bfseries{
\raggedright
                               }}%\reset@font\ss@font
}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                 {-3.25ex\@plus -1ex \@minus -.2ex}%
                                 {1.5ex \@plus .2ex}%
                                 {\small\bfseries\raggedright}%\reset@font\ss@font}
}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}
{-3.25ex\@plus -1ex \@minus -.2ex}%
                                 {1.5ex \@plus .2ex}%
{-1em}
{\small\bfseries\raggedright}%\reset@font\ss@font
}
\makeatother

\let\oldtabular\tabular
\renewcommand{\tabular}{\footnotesize\oldtabular}

\makeatletter
\newcommand\ackname{keywords}
\renewenvironment{keywords}[1]
  {\footnotesize\quotation
  {\bfseries\noindent{#1}
  \nobreak\smallskip}}
  {\endquotation}
\makeatother


