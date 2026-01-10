\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{vki}[1]
\typeout{(c) 2003 Luca Formaggia, MOX, Italy; Original layout Raimondo Giammanco, VKI, Belgium}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,twoside]{article}
\RequirePackage{a4}
\RequirePackage{flafter}
\RequirePackage{layout}
\RequirePackage{fancyhdr}
%\RequirePackage{natlib}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{graphicx}


%


%\RequirePackage{subfigure}
%\RequirePackage{subcaption}
%\RequirePackage{caption2}
\RequirePackage{placeins}
\RequirePackage{footmisc}
\RequirePackage{natbib}     % Test concerning the bibtex
%\usepackage[style=apa]{biblatex}

%\RequirePackage{pslatex}
\RequirePackage[T1]{fontenc}
\RequirePackage{ae,aecompl}
\RequirePackage{threeparttable}
\PassOptionsToPackage{section}{pcaseins}
\PassOptionsToPackage{perpage,symbol}{footmisc}
\setlength{\headheight}{14.5pt}
\setlength{\textheight}{235mm}
\setlength{\topmargin}{0mm}
\setlength{\textwidth}{160mm}
\setlength{\oddsidemargin}{0mm}
\setlength{\evensidemargin}{0mm}
\setlength{\baselineskip}{5.5mm}
\setlength{\voffset}{0.1811024in}
\setlength{\voffset}{-0.015748in}
\setlength{\marginparwidth}{1cm}
% set margins to be consistent with vki format

%renewcommand{\thesubfigure}{\thefigure.\arabic{subfigure}}
%\makeatletter
%        \renewcommand{\@thesubfigure}{\thesubfigure:\space}
%        \renewcommand{\p@subfigure}{}
%\makeatother
% in the subfigure, insetad of having 1(a) and 1(b), we use  1.1 and 1.2

\makeatletter
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
        \hbox{}
        \vspace*{\fill}
        \begin{center}
        \end{center}
        \vspace{\fill}
        \thispagestyle{empty}
        \newpage
        \if@twocolumn\hbox{}\newpage\fi\fi\fi}
\makeatother
% redefine cleardoublepage to have a new section open always on new page; 
%  it is equivalent of openright option for the report and book class

% V.1.1 Edited Out
%\newsavebox{\mygraphics}
%\sbox{\mygraphics}{
%       \includegraphics[keepaspectratio,height=2cm,width=2cm]{./eps/vki-ls_logo.eps}
%                }
% we define the vki-ls_logo.eps 
% V.1.1 Edited Out

\pagestyle{fancy}
% we use fancyhdr
\fancyfoot{}
\fancyfoot[L]{\emph{VKI}}

% V.1.1 Edited Out
% USER ENTRY ON
%\fancyfoot[R]{\emph{07-2003}}
% Put the LS number and the year, in the example  LS N.3 of 2003.
% USER ENTRY OFF 
% V.1.1 Edited Out

\fancyfoot[C]{\bfseries -\;\thepage\;-}

% V.1.1 Edited Out
%\fancyhead[C]{
%\setlength{\unitlength}{1cm}
%        \begin{picture}(0,0)
%        \put(-1,0){\usebox{\mygraphics}}
%        \end{picture}
%        }
% V.1.1 Edited Out

\fancyhead[RE,LO]{\rightmark}
\fancyhead[LE,RO]{\leftmark}


\renewcommand{\footrulewidth}{\iffloatpage{0.5pt}{0.5pt}}
\renewcommand{\headrulewidth}{\iffloatpage{0.5pt}{0.5pt}}
% put rulers on top and bottom of page


\fancypagestyle{plain}{%
\fancyhf{}
\fancyfoot[L]{\emph{VKI}}
% V.1.1 Edited Out
% USER ENTRY ON
%\fancyfoot[R]{\emph{07-2003}}
% Put the LS number and the year, in the example  LS N.3 of 2003.
% USER ENTRY OFF 
% V.1.1 Edited Out

\fancyfoot[C]{\bfseries -\;\thepage\;-}
\renewcommand{\footrulewidth}{0.0pt}
\renewcommand{\headrulewidth}{0.0pt}
}
% this is to have a consitent footheaders in the opening page of the article

