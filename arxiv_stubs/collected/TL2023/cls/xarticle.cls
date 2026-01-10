


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xarticle}[Class file]
\newbox\qqboxa
\newbox\qqboxb
\def\fnskip{1.2em}
\PassOptionsToClass{10pt}{article}
\def\setpagestyle{}
\def\benonote{}
\PassOptionsToClass{twocolumn}{article}
\ExecuteOptions{twocolumn}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage{amsfonts,amssymb,amsmath}
\RequirePackage[amsmath,thmmarks]{ntheorem}
\RequirePackage[margin=10pt,skip=7pt]{caption}
\RequirePackage[numbers,sort]{natbib}
\RequirePackage[rgb]{xcolor}

\twocolumn
\sloppy
\flushbottom
\setlength{\columnsep}{5mm}
\newcommand{\setlrmargins}[2]{\hoffset -1in\textwidth\paperwidth\advance\textwidth-#1\advance\textwidth-#2\oddsidemargin#1\evensidemargin#2}
\newcommand{\settbmargins}[5]{\topmargin0in\voffset-1in\textheight\paperheight\advance\textheight-#1\advance\textheight-#3\advance\textheight-#4\advance\textheight-#5\advance\textheight-#2\advance\topmargin#1\headheight#3\headsep#4\footskip#5}
\setlrmargins{19mm}{19mm}
\settbmargins{9mm}{10mm}{5mm}{4mm}{10mm}
\renewcommand{\thesection}{\Roman{section}}
\renewcommand{\thesubsection}{\Roman{section}.\Alph{subsection}}
\renewcommand{\section}{\@startsection{section}{1}{\z@}{-3.5ex\@plus-1ex\@minus-.2ex}{2.3ex\@plus.2ex}{\color{darkgblue}\sffamily\large\bfseries\raggedright}}
\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}{-3.25ex\@plus-1ex\@minus-.2ex}{1.5ex\@plus.1ex}{\color{darkgblue}\sffamily\normalsize\bfseries\raggedright}}
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}{-3.25ex\@plus-1ex\@minus-.2ex}{1.5ex\@plus.2ex}{\normalfont\normalsize\bfseries}}
\renewcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}{3.25ex\@plus1ex\@minus.2ex}{-1em}{\color{darkgblue}\sffamily\normalsize\bfseries}}
\def\note#1{\gdef\@note{#1}}
\renewcommand\maketitle{\par\begingroup\twocolumn[\@maketitle]\setpagestyle\@thanks\endgroup\setcounter{footnote}{0}}
\def\@thetitle{\parskip0pt\begin{center}{\LARGE\sffamily\textbf{\@title}\par}\vskip15pt{\large\sffamily\begin{tabular}[t]{c}\@author\end{tabular}\par}\end{center}}

\def\@maketitle{\newpage\setbox\qqboxa\hbox{\vbox{\@thetitle}}\setbox\qqboxb\hbox{\vbox{\begin{center}\@note\end{center}}}\parskip0pt\vbox to 0pt{\null\vskip 3mm\copy\qqboxa\vskip 0pt plus 2fil minus 1fil}\vskip 3mm\vskip\ht\qqboxa\vskip\ht\qqboxb}
\newcommand{\makefootnote}[2]{{\def\@thefnmark{#1}\@footnotetext{#2}}}
\renewcommand{\@makefntext}[1]{\leftskip\fnskip\noindent\hbox to 0em{\hss\@makefnmark}#1}
\def\footnotesymbol#1{\rlap{\@textsuperscript{\normalfont\relax #1}}}

\renewenvironment{thebibliography}[1]{\section*{\refname
    \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}\list{\@biblabel{\@arabic\c@enumiv}}{\settowidth\labelwidth{\@biblabel{#1}}\leftmargin\labelwidth 
         \itemsep 4pt plus 1pt \parsep 0pt
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}\let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}\sloppy
       \clubpenalty4000\@clubpenalty\clubpenalty\widowpenalty4000\sfcode`\.\@m}
                 {\def\@noitemerr
                   {\@latex@warning{Empty `thebibliography' environment}}%
                   \endlist}

     
                 
\renewcommand\normalsize{\@setfontsize\normalsize\@xpt\@xiipt
  \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
  \abovedisplayshortskip \z@ \@plus3\p@
  \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI}

\setlength\parskip{2pt \@plus \p@ minus 1pt}



\theoremstyle{plain}
\theoremheaderfont{\color{darkgblue}\normalfont\sffamily}
\theoremseparator{.}
\newtheorem{thm}{Theorem}
\newtheorem{theorem}[thm]{Theorem}
\newtheorem{defn}{Definition}
\newtheorem{prop}{Proposition}
\newtheorem{proposition}[prop]{Proposition}
\newtheorem{ex}{Example}
\newtheorem{example}[ex]{Example}
\newtheorem{lem}{Lemma}
\newtheorem{lemma}[lem]{Lemma}
\theoremstyle{nonumberplain}
\theoremsymbol{\rule{1ex}{1ex}}
\newtheorem{proof}{Proof}

\def\bibfont{\normalsize}
\setlength{\bibsep}{2pt plus 1pt}
\definecolor{darkgblue}{HTML}{185abc}


\def\ps@allheadings{\def\@oddfoot{\reset@font\hfil\thepage\hfil}\let\@evenfoot\@oddfoot\def\@evenhead{\hfill}\def\@oddhead{\hfill}\let\@mkboth\@gobbletwo\let\sectionmark\@gobble\let\subsectionmark\@gobble}
\setpagestyle
\normalsize



