%%
%% This is file `bms.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% classes.dtx  
%% 
%% This is a generated file.
%% 
%% Copyright 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009
%% The LaTeX3 Project and any individual authors listed elsewhere
%% in this file.
%% 
%% This file was generated from file(s) of the LaTeX base system.
%% --------------------------------------------------------------
%% 
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
%% This file has the LPPL maintenance status "maintained".
%% 
%% This file may only be distributed together with a copy of the LaTeX
%% base system. You may however distribute the LaTeX base system without
%% such generated files.
%% 
%% The list of all files belonging to the LaTeX base distribution is
%% given in the file `manifest.txt'. See also `legal.txt' for additional
%% information.
%% 
%% The list of derived (unpacked) files belonging to the distribution
%% and covered by LPPL is defined by the unpacking scripts (with
%% extension .ins) which are part of the distribution.
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{bms}
              [2016/01/20 v1.0h
 Standard LaTeX document class]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\DeclareOption{titlepage}{\@titlepagetrue}
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}
\ExecuteOptions{letterpaper,11pt,oneside,onecolumn,final}
\ProcessOptions
\input{size1\@ptsize.clo}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
%%IAS
\newtoks\runauthor
\newtoks\runtitle
\newtoks\affilOne
\newtoks\affilTwo
\newtoks\affilThree
\newtoks\affilFour
\newtoks\affilFive
%%IAS

\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\thepage\hfil\the\runauthor\hfil}%
      \def\@oddhead{\hfil{\the\runtitle}\hfil\thepage}%
      \let\@mkboth\markboth
    \def\sectionmark##1{%
      \markboth {\MakeUppercase{%
        \ifnum \c@secnumdepth >\z@
          \thesection\quad 
        \fi
        ##1}}{}}%
    \def\subsectionmark##1{%
      \markright {%
        \ifnum \c@secnumdepth >\@ne
          \thesubsection\quad
        \fi
        ##1}}}
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
    \def\@evenhead{\thepage\hfil\textit{\the\runauthor}\hfil}
    \def\@oddhead{\hfil\textit{\the\runtitle}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \thesection\quad
        \fi
        ##1}}}}
\fi

\newtoks\fp
\newtoks\lp

\def\ps@myheadings{%
    \def\@evenhead{\normalsize\thepage\hfil\the\runauthor\hfil} 
    \def\@oddhead{\hfil\textit{\the\runtitle}\hfil\thepage}% 
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
\renewcommand\footnoterule{\rule{1in}{.5pt}}%%
    }




%%IAS
\newtoks\volnum
\newtoks\issuenum
\newtoks\pgrange
\newtoks\doinum
\newtoks\monthname
\newtoks\year





\def\ps@firstpage{
%\def\@oddfoot{\hfil\thepage}
\let\@evenhead\@empty
\def\@oddhead{\noindent\hskip-6pt\begin{tabular}[t]{l}
\\[-48pt]\fontsize{9}{11}\selectfont Bull. Mater. Sci., Vol. \the\volnum, No. \the\issuenum, \the\monthname\ \the\year, pp. \the\pgrange \ \copyright\  Indian Academy of Sciences\\
\fontsize{9}{11}\selectfont DOI \the\doinum\end{tabular}}
}



  \if@titlepage
  \newcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\LARGE \@title \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{l}%
        \makeUpperCase{\@author}
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent 
            \hb@xt@4pt{%1.8em
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}% IAS
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{firstpage}\@thanks %%IAS
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
\def\@maketitle{%
\begin{@twocolumnfalse}
  \newpage\parindent0pt
  \null
  \vskip1em%3
  %\begin{center}%
 % \let \footnote \thanks
    {\noindent \fontsize{16}{18}\selectfont\bfseries \@title \par}% IAS 
    \vskip 24pt%18
    {\noindent\fontsize{10}{12}\selectfont
      %\lineskip .5em%
      \noindent\hspace{15mm}\begin{minipage}{16cm} %%%% IAS      
      \MakeUppercase{\bfseries\@author}\\
      \fontsize{9}{11}\selectfont \the\affilOne
      \the\affilTwo
      \the\affilThree
      \the\affilFour
      \the\affilFive
      \end{minipage}%\corres
}%
   % \vskip 1em%
    %{\large \@date}%  IAS
  %\end{center}%
\end{@twocolumnfalse}
  \par
  %\vskip 1.5em
  }
\fi

\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thesection {{\@arabic\c@section.}}
\renewcommand\thesubsection   {{\rm \thesection\@arabic\c@subsection}}%%IAS
\renewcommand\thesubsubsection{{\rm\thesubsection.\@arabic\c@subsubsection}}
\renewcommand\theparagraph {{\thesubsubsection\@arabic\c@paragraph}}
\renewcommand\thesubparagraph {{\theparagraph\@arabic\c@subparagraph}}
\newcommand\part{%
   \if@noskipsec \leavevmode \fi
   \par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >\m@ne
       \Large\bfseries \partname\nobreakspace\thepart
       \par\nobreak
     \fi
     \huge \bfseries #2%
     \markboth{}{}\par}%
    \nobreak
    \vskip 3ex
    \@afterheading}
\def\@spart#1{%
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \huge \bfseries #1\par}%
     \nobreak
     \vskip 3ex
     \@afterheading}
\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {-25pt \@plus -1ex \@minus -.5ex}% IAS
                                   {12.5pt}% \@plus.2ex}%IAS
                                   {\normalsize\selectfont\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-12.5pt \@plus 6pt \@minus 6pt}%
                                     {6.5pt }%\@plus .2ex}%
                                     {\normalsize\selectfont\itshape}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {12.5pt\@plus -1ex \@minus -.5ex}%
                                     {-1em}%\@plus .2ex}%
                                     {\normalfont\normalsize\itshape}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {0pt}%
                                    {-1em}%
                                    {\normalfont\normalsize}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {12.5pt  \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\if@titlepage
  \newenvironment{abstract}{%
      \titlepage
      \null\vfil
      \@beginparpenalty\@lowpenalty
      \begin{center}
        \bfseries  \abstractname
        \@endparpenalty\@M
      \end{center} 
}%
     {\par\vfil\null\endtitlepage}
\else                             
  \newenvironment{abstract}{%  IAS 
     %\if@twocolumn
       % \section*{\abstractname}%
      %\else
\begin{@twocolumnfalse}
        \noindent\hskip15mm\begin{minipage}{16cm}\fontsize{9}{11}\selectfont\bfseries
       \textbf{\abstractname.} \fi}
{\end{minipage}\par\end{@twocolumnfalse}} %%IAS
    %  {\if@twocolumn\else\endquotation\fi}
%\fi
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
\if@compatibility
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi
%%%Appendix IAS
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\setcounter{equation}{0}Appendix \@Alph\c@section.}
\setcounter{equation}{0}
\renewcommand \theequation {\@Alph\c@section.\@arabic\c@equation} %%IAS
}

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand \theequation {\@arabic\c@equation}
\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\textbf{\fontsize{9}{11}\selectfont\figurename\nobreakspace\thefigure}}%%IAS
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\textbf{\fontsize{9}{11}\selectfont\tablename\nobreakspace\thetable}\fontsize{9}{11}\selectfont}%%IAS
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\fontsize{9}{11}\selectfont #1\textbf{\bfseries .}\ #2}% IAS figure
  \ifdim \wd\@tempboxa <\hsize
   \centering\fontsize{9}{11}\selectfont #1\textbf{\bfseries .}\ #2 %%IAS table
  \else
    \global \@minipagefalse
     \fontsize{9}{11}\selectfont #1.\ #2% IAS
 % \ifdim \wd\@tempboxa==\hsize
 %  \global \@minipagefalse
  %  \hb@xt@\hsize{\box\@tempboxa\hfil\\[6pt]}% IAS
  \fi
  \vskip\belowcaptionskip}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    }
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}
\newcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\newcommand\listoffigures{%
    \section*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
     {\section*{\fontsize{9}{11}\selectfont\bfseries\refname\vspace*{4pt}}%
      %\@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
    \fontsize{9}{11}\selectfont
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
           % \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      %\sloppy
      \parskip -4pt
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{% not this IAS
  \kern-3\p@ %-3
  \hrule\@width.4\columnwidth%.4
  \kern2.6\p@}
\newcommand\@makefntext[1]{%
    \parindent 1em
    \noindent
    \hb@xt@4pt{\hss\@makefnmark}#1}% IAS
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{headings}%%%IAS 
\pagenumbering{arabic}
\if@twoside
\else
  \raggedbottom
\fi
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi

 %%%%%%%%%%%
\usepackage{textcase,float}
\usepackage[fleqn]{amsmath}
\mathindent=0pt
\renewcommand*{\@seccntformat}[1]{%
  \csname the#1\endcsname\hskip6pt} %% IAS

\headsep=0pt
\setlength{\columnsep}{0.5cm}



\usepackage{geometry}
 \geometry{
 a4paper,
twoside,
 total={21cm,27.9cm},
 left=17.5mm,
 top=15mm, 
inner=17.5mm,
textwidth=17.5cm,
textheight=24cm,
tmargin=26pt, %%
voffset=.85in,%%.5in
headsep=12pt,
footskip=18pt,
%showframe,
showcrop
 }
%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{nomenclature}{\vskip 12.5pt\noindent{\textbf{Nomenclature}}\\[6pt] \begin{tabular}{@{}ll}}{\end{tabular}\vskip 12.5pt}



%%%%%%%%%%%%%%%%%%%%%

 \DeclareRobustCommand\and{{{  and  }}}
%\pagestyle{myheadings}


\let\@authortofile\@empty
\def\@separator{\def\@separator{, }}% Delay comma once
\def\addauthor#1#2{%
  \g@addto@macro\@author{\@separator#1\textsuperscript{#2}}
  \g@addto@macro\@authortofile{\@separator#1}
}

  \renewcommand\footnoterule{\hskip-15pt\rule{1in}{.5pt}\vskip 2pt}%%IAS

%%%%%%%%%%%%%
\bibliographystyle{unsrt}
%%%%%%%%%%

%\input{fleqn.clo}
%\mathmargin=0pt
\addtolength{\skip\footins}{12pt}
%\usepackage{newtxtext,newtxmath,balance}
\usepackage{txfonts,balance}

\let\iint\undefined
\let\iiint\undefined
\let\iiiint\undefined
\let\idotsint\undefined

\abovedisplayskip=12.5pt plus 3.0pt minus 6.0pt
\belowdisplayskip=12.5pt plus 3.0pt minus 6.0pt

\providecommand{\keywords}[1]{\vskip 12.5pt\noindent\hspace{15mm}\begin{minipage}{16cm}\fontsize{9}{11}\selectfont\textbf{Keywords.}\hskip10pt \textbf{#1}
\end{minipage} 
}


\providecommand{\msinfo}[2]{\vskip 12.5pt\noindent\hspace{15mm}\begin{minipage}{16cm}{\fontsize{9}{11}\selectfont MS received #1;  accepted #2}\end{minipage}\vskip 12.5pt}


\providecommand{\corres}[1]{\noindent\begingroup\renewcommand\thefootnote{}\noindent\footnote{\hskip-3pt$^*$ Author for correspondence (#1)}\addtocounter{footnote}{-1}\endgroup}
%%IAS
%{
%\vskip 0pt\noindent\hspace{15mm}\begin{minipage}{16cm}%%{\fontsize{10}{12.5}\selectfont \textsuperscript{*}Corresponding author. E-mail: #1}\end{minipage}
%  } 

\renewcommand{\normalsize}{\fontsize{10pt}{12pt}\selectfont}


\providecommand{\tablenotes}[1]{\par\vskip6pt\fontsize{9}{11}\selectfont #1\vskip6pt}

\providecommand{\tabularfont}{\fontsize{9}{11}\selectfont }
\twocolumn
%%
\endinput


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% End of file `bms.cls'.
