\NeedsTeXFormat{LaTeX2e}[1996/12/01]\relax
\ProvidesClass{nst}[2013/09/23 v1.0 Nuclear Science and Techniques magazine class]\relax

\newif\if@unpublished@
\DeclareOption
  {submitting}%
  {\@unpublished@true}
\DeclareOption
  {published}%
  {\@unpublished@false
  \PassOptionsToClass{showpacs}{revtex4-1}%
  }
\DeclareOption
  {10pt}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {11pt}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {12pt}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {aps}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {prc}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {notitlepage}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {onecolumn}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {twocolumn}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {twoside}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {superscriptaddress}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {groupedaddress}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {nofootinbib}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {showkeys}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {showpacs}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {amsfonts}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {amssymb}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption
  {amsmath}%
  {\PassOptionsToClass{\CurrentOption}{revtex4-1}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{revtex4-1}}
%% Execute default options
\ExecuteOptions
  {aps%
  ,prc%
  ,10pt%
  ,notitlepage%
  ,twocolumn%
  ,twoside%
  ,superscriptaddress%
  ,nofootinbib%
  ,showkeys%
  ,amsfonts%
  ,amssymb%
  ,amsmath%
  }

%% Process given options
\ProcessOptions\relax

%% Load base



\LoadClass{revtex4-1}

\RequirePackage[displaymath, mathlines]{lineno}
\RequirePackage{times} % load Times-series fonts
\RequirePackage{siunitx} % SI unit's macros
\RequirePackage{color}

\RequirePackage{booktabs}
\heavyrulewidth=1.2pt
\lightrulewidth=.6pt
\cmidrulewidth=.6pt

\RequirePackage{graphicx}
\RequirePackage[utf8]{inputenc}
\RequirePackage[colorlinks=true,linkcolor=blue,urlcolor=blue,citecolor=blue]{hyperref}
\RequirePackage{CJKutf8}

%\textheight = 22.7 cm
%\textwidth = 17.2 cm
%\addtolength\textheight {9mm}%
%\addtolength\textwidth  {5mm}

\usepackage[a4paper,text={178mm,236mm},centering]{geometry}

\newcount\authors@nums
\def\first@author{}
\def\second@author{}
\def\third@author{}
\def\nst@authors{}
\def\author
{%
  \@ifnextchar[{\chinese@author}{\english@author}%
}
\def\chinese@author[#1]#2%
{%
  \@author@def{}{\mbox{#2~(\begin{CJK}{UTF8}{gbsn}#1\end{CJK})}}%
  \add@author@list{#2}%
  \renew@author@list
}
\def\english@author#1%
{%
  \@author@def{}{#1}%
  \add@author@list{#1}%
  \renew@author@list
}
\def\add@author@list#1%
{%
  \ifcase\authors@nums\relax
    \gdef\first@author{#1}%
  \or
    \gdef\second@author{#1}%
  \or
    \gdef\third@author{#1}%
  \fi
}
\def\renew@author@list
{%
  \ifcase\authors@nums\relax
    \gdef\nst@authors{\first@author}%
  \or
    \gdef\nst@authors{\first@author\space and~\second@author}%
  \or
    \gdef\nst@authors{\first@author, \second@author\space and~\third@author}%
  \else
    \gdef\nst@authors{\first@author\space{\it et al.}}%
  \fi
  \global\advance\authors@nums\@ne
}


\def\nst{Nuclear Science and Techniques}
\def\nst@shortform{Nucl. Sci. Tech.}
\def\NST#1#2#3#4#5%
{%
  \gdef\nst@volume{#1}%
  \gdef\nst@number{#2}%
  \gdef\nst@column{#3}%
  \gdef\nst@article{#4}%
  \gdef\nst@year{#5}%
}
\def\nst@volume{}
\def\nst@number{}
\def\nst@column{}
\def\nst@article{}
\def\nst@year{}
\def\nst@authors{}

\def\doi#1{%
  \aftermaketitle@chk{\doi}%
  \gdef\@doi{#1}%
}%
\def\@doi{}
\def\@pacs@name{DOI:~\href{http://dx.doi.org/\@doi}{\@doi}}%

\def\nst@magic@number{\nst@number\nst@column\nst@article} %
\def\nst@header{\nst@shortform~{\bfseries\nst@volume}, \nst@magic@number~(\nst@year)} %
\def\nst@plain@header{\MakeUppercase{\nst}~{\bfseries\nst@volume}, \nst@magic@number~(\nst@year)} %

\def\titleblock@produce{%
 \begingroup
  \let\footnote\footnote@latex
  \let\@makefnmark\@makefnmark@latex
  \let\@footnotemark\@footnotemark@latex
  \let\thefootnote\frontmatter@thefootnote
  \global\c@footnote\z@
  \let\@makefnmark\frontmatter@makefnmark
  \frontmatter@setup
  \thispagestyle{titlepage}\label{FirstPage}%
  \frontmatter@title@produce
  \groupauthors@sw{%
   \frontmatter@author@produce@group
  }{%
   \frontmatter@author@produce@script
  }%
\if@unpublished@
\else
  \frontmatter@RRAPformat{%
   \expandafter\produce@RRAP\expandafter{\@date}%
   \expandafter\produce@RRAP\expandafter{\@received}%
   \expandafter\produce@RRAP\expandafter{\@revised}%
   \expandafter\produce@RRAP\expandafter{\@accepted}%
   \expandafter\produce@RRAP\expandafter{\@published}%
  }%
\fi
  \frontmatter@abstract@produce
  \@keywords@produce\@keywords
  \@pacs@produce\@pacs
  \par
  \frontmatter@finalspace
 \endgroup
}%
\if@unpublished@
  \let\@tmp@mktitle\maketitle
  \def\maketitle
    {\@tmp@mktitle
    \linenumbersep4pt\relax
    }
\fi

\newbox\title@box
\newbox\title@line
\renewcommand\title[2][]{%
  \def\@title{#2}%
  \def\@shorttitle{#1}%
  \let\@AF@join\@title@join
  \@ifx{\@shorttitle\@empty}%
  {\trim@title{\MakeUppercase{\@title}}}%
  {\trim@title{\MakeUppercase{\@shorttitle}}}%
}%
\fboxsep=0pt
\fboxrule=1pt
%\tracingmacros=2
%\tracingonline=1
\showboxbreadth=\maxdimen
\showboxdepth=\maxdimen
\def\trim@title#1%
{%
  \setbox\title@box=\hbox{#1}%
  \ifdim\wd\title@box>0.5\textwidth\relax
    \setbox\title@box=\vbox
      {\hsize=0.4\textwidth\noindent\raggedright#1}%\hyphenpenalty=10000
    \setbox\title@line \vsplit\title@box to\baselineskip%
    \setbox\title@line=\vbox{\unvbox\title@line\eatlines}%
    \xdef\trimmed@title{\mbox{\copy\title@line}$\ldots$}%
  \else
    \xdef\trimmed@title{\mbox{\copy\title@box}}%
  \fi
}

\newbox\linebox \newbox\snapbox
\def\eatlines{
\setbox\linebox\lastbox % check the last line
\ifvoid\linebox
\else % if it’s not empty
\unskip\unpenalty % take whatever is
{\eatlines} % above it;
% collapse the line
\setbox\snapbox\hbox{\unhcopy\linebox}
% depending on the difference
\ifdim\wd\snapbox<.98\wd\linebox
\box\snapbox % take the one or the other,
\else \box\linebox \fi
\fi}

%% Fancy Header and Footer
\RequirePackage{fancyhdr}
\pagestyle{fancy} %
\fancyhead{} %
\fancyfoot{} %
\if@unpublished@
  \fancyhead[R]{\thepage}
\else
  \fancyhead[R]{\nst@header} %
  \fancyhead[LE]{\nst@authors} %
  \fancyhead[LO]{\trimmed@title} %
  \fancyfoot[C]{\nst@magic@number-\thepage} %
\fi


\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\fancypagestyle{titlepage}{%
  \fancyhf{} % clear all header and footer fields
  \if@unpublished@
  \else
    \fancyhead[C]{\nst@plain@header} %
    \fancyfoot[C]{\nst@magic@number-\thepage} %
  \fi
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}}

%% Figure name
\appdef\class@documenthook{%
 \def\figurename{Fig.}
}%


%% Table numbering
\renewcommand\thetable{\@arabic\c@table}

\endinput
