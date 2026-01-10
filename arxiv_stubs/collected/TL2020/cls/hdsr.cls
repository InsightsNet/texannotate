%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Harvard Data Science Review Latex Class       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hdsr}

\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[11pt, hidelinks]{amsart}

% Packages
\usepackage[colorlinks=true, linkcolor=black, urlcolor=blue, citecolor=blue, anchorcolor=blue]{hyperref}
\usepackage{wrapfig}
\usepackage{comment}
\usepackage{textgreek}
\usepackage{url}
\usepackage{fullpage}
\usepackage[titletoc,title]{appendix}
\usepackage{enumitem, comment, xifthen}

\usepackage{amsmath,amssymb,amsthm, amsfonts}
\usepackage[T1]{fontenc}
\usepackage{makecell}
\usepackage{booktabs}

\usepackage[natbibapa]{apacite}
\usepackage{natbib}

\usepackage{subcaption}
\usepackage[dvipsnames]{xcolor}
\DeclareMathOperator*{\E}{\bf E}

\makeatletter
\long\def\@makecaption#1#2{
        \vskip 0.8ex
        \setbox\@tempboxa\hbox{\small {\bf #1.} #2}
        \parindent 1.5em 
        \dimen0=\hsize
        \advance\dimen0 by -3em
        \ifdim \wd\@tempboxa >\dimen0
                \hbox to \hsize{
                        \parindent 0em
                        \hfil 
                        \parbox{\dimen0}{\def\baselinestretch{0.96}\small
                                {\bf #1.} #2
                                } 
                        \hfil}
        \else \hbox to \hsize{\hfil \box\@tempboxa \hfil}
        \fi
        }
\makeatother
\usepackage{booktabs}
\usepackage{hhline}
\usepackage{array,multirow}
\usepackage{lipsum}
\usepackage{siunitx,etoolbox}

\interfootnotelinepenalty=1000
\usepackage{graphicx}

\usepackage{tikz}
\usepackage{lipsum}



% Custom commands

% Affiliation markers
\newcommand{\upstairs}[1]{\textsuperscript{#1}}
\newcommand{\affilone}{\dag}
\newcommand{\affiltwo}{\ddag}
\newcommand{\affilthree}{$\diamond$}

\newcommand \volumeheader{%
\begin{tikzpicture}[remember picture,overlay]
\setlength{\fboxrule}{0pt}%
  \node[anchor=north, yshift=-10pt, line width=0pt] at (current page.north) {\fbox{\parbox{\dimexpr\textwidth-\fboxsep-\fboxrule\relax}{  
  
        \includegraphics[scale=0.1]{logo} \\
        Volume 0 Issue 0 \\
        DOI: 00.000 \\ 
        ISBN: 0000000}}};
  \end{tikzpicture}% 
  \\
  \\

  }

\newcommand \copyrighttext{%
    %\footnotesize \copyright{} \the\year{ } Harvard Data Science Review
}%
  
\newcommand \copyrightnotice{%
\begin{tikzpicture}[remember picture,overlay]
  \node[anchor=south,yshift=10pt] at (current page.south) {\fbox{\parbox{\dimexpr\textwidth-\fboxsep-\fboxrule\relax}{\copyrighttext}}};
\end{tikzpicture}%
}

