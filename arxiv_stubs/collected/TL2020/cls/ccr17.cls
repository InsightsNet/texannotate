%%
%% This is file `ccr17.cls'
%% CCR Summer Papers Macros.  For use with siamltex
%%
%% By Chris Siefert
%% (Modified by Mike Parks)
%% (Modified by Denis Ridzal)
%% (Modified by Eric Cyr)
%% (Modified by Siva Rajamanickam)
%% (Modified by Drew Kouri)
%% (Modified by Andrew Bradley)
%% (Modified by Jimmy Carleton)
%% (Modified by Andrew Baczewski)
%% Sandia National Labs
%%
%% April 23, 2017
%%
%% Version 1.1
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ccr17}[2017/04/23 CCR 2017 Summer Report Class]

% Options for siamltex
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{siamltex}}

% Process Options
\ProcessOptions

% Load siamltex
\LoadClass{siamltex}

% Table of contents
\renewcommand\contentsname{Table of Contents}
\setcounter{tocdepth}{0}
\newcommand\tableofcontents{%
\noindent{\bf\contentsname}
%    \section*{\contentsname
%        \@mkboth{%
%           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
%           ~%
           \bigskip%
    \@starttoc{toc}%
    }
\newcommand*\l@chapter{\@dottedtocline{0}{1.5em}{2.3em}}
\newcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand*\l@subsection{\@dottedtocline{2}{3.8em}{3.2em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{7.0em}{4.1em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{10em}{5em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{12em}{6em}}

% CCR Title Page: modified from siamltex.cls
\def\ps@ccrheadings{%
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@defaulthead{ 
    \rlap{\footnotesize CCR Summer Proceedings 2017}\hfil\llap{\thepage}
  }% end default headings   
  \def\@oddhead{\@defaulthead}
  \def\@evenhead{\@defaulthead} 
  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}

% New \maketitle.  Horked + slightly modified from siamltex.cls
\renewcommand\maketitle{\par
  \begingroup
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
  \def\@makefnmark{\hbox to\z@{$\m@th^{\@thefnmark}$\hss}}%
  \long\def\@makefntext##1{\parindent 1em\noindent
    \hbox to1.8em{\hss$\m@th^{\@thefnmark}$}##1}%
  \if@twocolumn
  \ifnum \col@number=\@ne
  \@maketitle
  \else
  \twocolumn[\@maketitle]%
  \fi
  \else
  \global\@topnum\z@   % Prevents figures from going at top of page.
  \@maketitle
  \fi
  \thispagestyle{ccrheadings}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  %\let\maketitle\relax\let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}
  %\let\thanks\relax
}

\endinput
