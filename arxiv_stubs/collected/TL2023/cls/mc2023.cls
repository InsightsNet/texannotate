\LoadClass[twoside,fleqn,letterpaper]{article}
\typeout{Loading M\&C 2023 document class: includes [twoside,fleqn,letterpaper]{article}}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\RequirePackage{citesort}
%
% rename reference section
\renewcommand{\refname}{REFERENCES}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page layout stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\RequirePackage{setspace}
\RequirePackage{indentfirst}
\RequirePackage{fancyhdr}
\RequirePackage{afterpage}
\RequirePackage{times}
\RequirePackage{graphicx,ifthen,amsmath,rotating,url}
\RequirePackage{ifpdf}
\urlstyle{rm}
\raggedright
%
% pdflatex compatibility
\ifpdf
  \RequirePackage{epstopdf}
  \pdfadjustspacing=1
\fi
%
% vertical spacing
\setlength{\voffset}{-0.250in}
\ifpdf
  \setlength{\topmargin}{-0.625in}
\else
  \setlength{\topmargin}{0.0in}
\fi
\setlength{\headheight}{0.5in}
\setlength{\headsep}{0.1in}
\setlength{\textheight}{9.0in}
\setlength{\footskip}{0.5in}
%
% horizontal spacing
\setlength{\hoffset}{0in}
\setlength{\oddsidemargin}{0in}
\setlength{\evensidemargin}{0in}
\setlength{\textwidth}{6.5in}
\setlength{\marginparsep}{0in}
\setlength{\marginparwidth}{0in}
%
\setlength{\parindent}{0in}
\addtolength{\parskip}{\baselineskip}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Headers and such (fancyhdr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% first page header and footer
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\chead{
  \footnotesize{\emph{M\&C 2023 - The International Conference on Mathematics and Computational Methods Applied 
\\to Nuclear Science and Engineering $\cdot$ Niagara Falls, Ontario, Canada $\cdot$ August 13 -- 17, 2023}}
  }
\lfoot{}
%\rfoot{\thepage/\totalpages{}}%
\pagestyle{fancy}
%
% subsequent pages header and footer (must be placed after \begin{document})
\AtBeginDocument{
  \afterpage{%
    \fancyhf{}%
    \fancyhead[CE]{{\scriptsize \authorHead}}
    \fancyhead[CO]{{\scriptsize \shortTitle}}
    %\rfoot{\normalsize{\textit{Proceedings of M\&C 2023, Niagara Falls, Ontario}}}
    %\rfoot{\thepage/\totalpages{}}%
    \pagestyle{fancy}
  }
  \normalsize
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section title definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\section}{
  \renewcommand{\@seccntformat}[1]{\csname the##1\endcsname.\hspace{0.5em}}
  \@startsection{section}{1}{\z@}
                {1.0ex plus 1.0ex minus 0.2ex}{0.2ex plus 0.2ex}{\normalsize\bf\center}}
\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}
  {1.0ex plus 1.0ex minus 0.2ex}{0.2ex plus 0.2ex}{\normalsize\bf}}
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}
  {1.0ex plus 1.0ex minus 0.2ex}{0.2ex plus 0.2ex}{\normalsize\bf}}
%
\renewcommand{\thesection}{\@arabic\c@section}
\renewcommand{\thesubsection}{\thesection.\@arabic\c@subsection}
\renewcommand{\thesubsubsection}{\thesubsection.\@arabic\c@subsubsection}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Type size definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\scriptsize}{\fontsize{8}{8.5pt}\selectfont}
\renewcommand{\footnotesize}{\fontsize{9}{9pt}\selectfont}
\renewcommand{\small}{\fontsize{10}{11pt}\selectfont}
\renewcommand{\normalsize}{\fontsize{12}{14pt}\selectfont}
\renewcommand{\large}{\fontsize{14}{14.5pt}\selectfont}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\thefootnote}{\vspace{2.0cm} \fnsymbol{footnote}}
\renewcommand{\thetable}{\@Roman\c@table}
\setlength{\skip\footins}{1.0cm}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% borrowed from pagecounting.sty 
% http://www-users.york.ac.uk/~zrs1/Software/pagecounting.sty)
%
% History:
%  Created 2000/04/07
% -------- Identification
%
%\NeedsTeXFormat{LaTeX2e}
%\ProvidesPackage{pagecounting}[2000/04/07 <Zoe Stephenson>]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newcounter{l@stpage}
\newcommand{\storel@st}{\immediate\write\@mainaux{%
    \setcounter{l@stpage}{\thepage}%
    % also could use: \setcounter{l@stpage}{\arabic{page}}%
    % also could use: \setcounter{l@stpage}{\number{page}}%
    \addtocounter{l@stpage}{0}}%  Adjust due to page counter post-advance
}
\renewcommand{\thel@stpage}{\arabic{l@stpage}}
\AtEndDocument{\storel@st}
\newcommand{\totalpages}{\thel@stpage}
\newcommand{\lastpage}{\value{l@stpage}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define 'abstract' environment and 'keywords' command
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewenvironment{abstract}{
  \centering\vskip 1em\textbf{ABSTRACT}
  \begin{list}{}{\setlength{\leftmargin}{0.3in}\setlength{\rightmargin}{0.3in}\setlength{\topsep}{0in}\normalsize}
  \item
}{
  \end{list}
}
%
\newcommand{\keywords}[1]{
  \vspace{-1em}
  \begin{raggedright}
    \begin{list}{}{\setlength{\leftmargin}{0.0in}\setlength{\rightmargin}{0.5in}\small}
    \item[] \ignorespaces KEYWORDS: \upshape #1
    \end{list}
  \end{raggedright}
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine 'figure' and 'figure*' environments for spacing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewenvironment{figure}[1][tbp]{
  \@float{figure}[#1]
  \vspace{1em}
}{
  \vspace{1em}
  \end@float
}
%
\renewenvironment{figure*}[1][tbp]{
  \@dblfloat{figure}[#1]
  \vspace{1em}
}{
  \vspace{1em}
  \end@dblfloat
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine 'table' and 'table*' environments for spacing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewenvironment{table}[1][tbp]{
  \setlength{\belowcaptionskip}{1em}
  \@float{table}[#1]
  \vspace{1em}
}{
  \vspace{1em}
  \end@float
}
%
\renewenvironment{table*}[1][tbp]{
  \setlength{\belowcaptionskip}{1em}
  \@dblfloat{table}[#1]
  \vspace{1em}
}{
  \vspace{1em}
  \end@dblfloat
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine 'maketitle' command (borrowed from PHYSOR-2006 LaTeX template)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewcommand\maketitle{
  \begingroup
  \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
  \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
  \long\def\@makefntext##1{\parindent 1em\noindent
    \hb@xt@1.8em{%
      \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
  \if@twocolumn
  \ifnum \col@number=\@ne
  \@maketitlex
  \else
  \twocolumn[\@maketitlex]%
  \fi
  \else
  \newpage
  \global\@topnum\z@  % Prevents figures from going at top of page.
  \@maketitlex
  \fi
  \thispagestyle{fancy}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
%
\def\@maketitlex{%
  \newpage
  \null
  \thispagestyle{fancy}
  \begin{center}%
    \let\footnote\thanks
    {\normalfont\large\bfseries
      \vskip -1em%
      \begin{tabular}[t]{c}\@title\end{tabular}\par}%
    {\normalsize
      \lineskip 1ex%
      \begin{tabular}[t]{c}\@author\end{tabular}\par}%
  \end{center}%
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Borrowed from caption.sty in the standard LaTeX2e distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This is file `caption.sty',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% caption.dtx  (with options: `package')
%% 
%% Copyright (C) 1994-95 Harald Axel Sommerfeldt
%% 
%\NeedsTeXFormat{LaTeX2e}[1994/06/01]
%\ProvidesPackage{caption}[1995/04/05 v1.4b caption package (HS)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\typeout{Package: caption v1.4b <1995/04/05> (Harald Sommerfeldt)}
\newcommand{\captionsize}{}
\newcommand{\captionfont}{\captionsize}
\newcommand{\captionlabelfont}{}
\newlength{\captionmargin}
\newcommand{\as@normalcaption}[2]{%
  #1 #2\par}
\newcommand{\as@isucaption}[2]{%
  \sbox{\as@captionbox}{#1\space}%
  \addtolength{\as@captionwidth}{-\wd\as@captionbox}%
  \usebox{\as@captionbox}\parbox[t]{\as@captionwidth}{\leavevmode#2}}
\newcommand{\as@centercaption}[2]{%
  \parbox[t]{\as@captionwidth}{{\centering#1 #2\par}}}
\newcommand{\as@annecaption}[2]{%
  \addtolength{\leftskip}{0pt plus 1fil}%
  \addtolength{\rightskip}{0pt plus -1fil}%
  \setlength{\parfillskip}{0pt plus 2fil}%
  #1 #2\par}
\let\as@shortcaption\as@centercaption
\ifx\thesubfigure\undefined
  \newcommand{\as@subcapsize}[1]{}
\else%
  \typeout{\space\space\space\space\space\space\space\space\space
           `subfigure' package detected}
  \let\as@subcapsize\subcapsize
  \renewcommand{\@thesubfigure}{{\captionlabelfont\thesubfigure}\space}
  \renewcommand{\@thesubtable}{{\captionlabelfont\thesubtable}\space}
\fi
\let\as@caption\as@normalcaption
\newsavebox{\as@captionbox}
\newlength{\as@captionwidth}
\newcommand{\as@makecaption}[2]{%
  \setlength{\leftskip}{\captionmargin}%
  \setlength{\rightskip}{\captionmargin}%
  \addtolength{\as@captionwidth}{-2\captionmargin}%
  \captionfont%
  \sbox{\as@captionbox}{{\captionlabelfont \textbf{#1.}} #2}%
  \ifdim \wd\as@captionbox >\as@captionwidth
    \as@caption{{\captionlabelfont \textbf{#1.}}}{#2}%
  \else%
    \as@shortcaption{{\captionlabelfont \textbf{#1.}}}{#2}%
  \fi}
\renewcommand{\@makecaption}[2]{%
  \vskip\abovecaptionskip%
  \setlength{\as@captionwidth}{\linewidth}%
  \as@makecaption{#1}{#2}%
  \vskip\belowcaptionskip}
\ifx\@makerotcaption\undefined
\else
  \typeout{\space\space\space\space\space\space\space\space\space
           `rotating' package detected}
  \renewcommand{\@makerotcaption}[2]{%
    \captionfont%
    \sbox{\as@captionbox}{{\captionlabelfont \textbf{#1.}} #2}%
    \ifdim \wd\as@captionbox > .8\vsize
      \rotatebox{90}{%
        \setlength{\as@captionwidth}{.8\textheight}%
        \begin{minipage}{\as@captionwidth}%
          \as@caption{{\captionlabelfont \textbf{#1.}}}{#2}%
        \end{minipage}}\par
    \else%
      \rotatebox{90}{\usebox{\as@captionbox}}%
    \fi
    \hspace{12pt}}
\fi
\ifx\floatc@plain\undefined
\else
  \typeout{\space\space\space\space\space\space\space\space\space
           `float' package detected}
  \renewcommand\floatc@plain[2]{%
    \setlength{\as@captionwidth}{\linewidth}%
    \as@makecaption{#1}{#2}}
  \ifx\as@ruled\undefined
  \else
    \renewcommand\floatc@ruled[2]{%
      \setlength{\as@captionwidth}{\linewidth}%
      \captionfont%
      \as@caption{{\captionlabelfont \textbf{#1.}}}{#2}}
  \fi
\fi
\endinput
%%
%% End of file `caption.sty'.
