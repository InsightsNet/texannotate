%%% LaTeX class for manuscripts submitted to the
%%% The Institution of Engineering and Technology
%%%
%%% version: 1.0 (29 July 2011)
%%%
%%% This document class is based on the "article" class file.
%%% Following additional packages are required:
%%% amsmath amssymb amsfonts amsthm graphicx endfloat natbib setspace
%%% verbatim geometry bm url babel dcolumn stfloats balance lastpage
%%% xspace amscd rotating latexsym multicol array algorithm subfigure

\NeedsTeXFormat{LaTeX2e}[2011/7/29]

\ProvidesClass{IEE}[2000/05/19 v1.4b Standard LaTeX document class]

\newif\if@doublespace\@doublespacefalse
\newif\if@usetimes\@usetimesfalse
\newif\if@usemathtime\@usemathtimefalse

\DeclareOption{usetimes}{\@usetimestrue}
\DeclareOption{usemathtime}{\@usemathtimetrue}
\DeclareOption{doublespace}{\@doublespacetrue}
\DeclareOption{nospace}{\@doublespacefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption,11pt,a4paper,twoside,onecolumn}{article}}
\DeclareOption{a4paper}{\PassOptionsToPackage{a4}{crop}}
\DeclareOption{centre}{\PassOptionsToPackage{center}{crop}}
\DeclareOption{crop}{\PassOptionsToPackage{cam}{crop}}
\DeclareOption{nocrop}{\PassOptionsToPackage{off}{crop}}


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

\ExecuteOptions{a4paper,centre,twoside,twocolumn,openbib}

\ProcessOptions

\LoadClass{article}

\if@doublespace
  \RequirePackage[doublespacing]{setspace}
\fi

\RequirePackage{amssymb,amsfonts,amsthm,verbatim,graphicx}
\RequirePackage{xspace,amscd,rotating,latexsym,multicol,array,algorithm,subfigure,stfloats,balance,lastpage}
\RequirePackage[hyphens,obeyspaces]{url}
\RequirePackage[english]{babel}
\RequirePackage{times}

\RequirePackage{dcolumn}
\newcolumntype{d}[1]{D{.}{.}{#1}}

\usepackage{soul}
\sodef\runtrack{}{0.05em}{0.25em}{0pt}


\renewcommand\normalsize{%
   \@setfontsize\normalsize{9}{10.5}
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus0\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\renewcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize\@ixpt{11}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\renewcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\renewcommand\large{\@setfontsize\large\@xiipt{14}}
\renewcommand\Large{\@setfontsize\Large\@xivpt{18}}
\renewcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\renewcommand\huge{\@setfontsize\huge\@xxpt{25}}
\renewcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

\setlength{\paperheight}{297truemm}%
\setlength{\paperwidth}{210truemm}%

\setlength\headheight{7\p@}%
\setlength\topmargin{32pt}%
\addtolength\topmargin{0\p@}         %
\addtolength\topmargin{-1in}         %

\setlength\topskip{8\p@}            %
\setlength\headsep{26\p@}          %
\addtolength\headsep{-\topskip}      %

\setlength\footskip{20\p@}           %
\setlength\maxdepth{.5\topskip}      %

\setlength\textwidth{178mm}           %

\setlength\textheight{67\baselineskip}       %
\addtolength\textheight{\topskip}    %

\setlength\marginparsep{6\p@}
\setlength\marginparpush{8\p@}
\setlength\marginparwidth{4.2pc}

\setlength\oddsidemargin{17mm}
\addtolength\oddsidemargin{-1in}    %
\setlength\@tempdima{\paperwidth}
\addtolength\@tempdima{-\textwidth}
\addtolength\@tempdima{-17mm}
\setlength\evensidemargin{\@tempdima}
\addtolength\evensidemargin{-1in}

\setlength\columnsep{24\p@}          %
\setlength\columnseprule{0\p@}      %

\if@doublespace
\setlength\textheight{32\baselineskip}
\fi

\usepackage[T1]{fontenc}

\if@usetimes
  \RequirePackage{times}
\fi
\if@usemathtime
  \RequirePackage{mathtime}
\fi

\RequirePackage{bm}
\RequirePackage[tbtags]{amsmath}

\@lowpenalty   51%
\@medpenalty  151%
\@highpenalty 301%

\clubpenalty 10000%
\widowpenalty 10000%

\displaywidowpenalty 100%
\predisplaypenalty   10000%
\postdisplaypenalty  2500%

\interlinepenalty 0%

\brokenpenalty 10000%

\hyphenpenalty=10000

\AtBeginDocument{%
\@ifpackageloaded{amsthm}{%
\def\@thm#1#2#3{%
  \ifhmode\unskip\unskip\par\fi
  \normalfont
  \trivlist
  \let\thmheadnl\relax
  \let\thm@swap\@gobble
  \thm@headpunct{:}% add period after heading
  \thm@headsep 5\p@ plus\p@ minus\p@\relax
  \thm@space@setup
  #1% style overrides
  \@topsep \thm@preskip               % used by thm head
  \@topsepadd \thm@postskip           % used by \@endparenv
  \def\@tempa{#2}\ifx\@empty\@tempa
    \def\@tempa{\@oparg{\@begintheorem{#3}{}}[]}%
  \else
    \refstepcounter{#2}%
    \def\@tempa{\@oparg{\@begintheorem{#3}{\it\csname the#2\endcsname}}[]}%
  \fi
  \@tempa
}
\def\thm@indent{}%
\thm@headfont{\it}
\providecommand{\qedsymbol}{\openbox}%
\renewenvironment{proof}[1][\proofname]{\par
  \pushQED{\hfill$\blacksquare$}%
  \normalfont \topsep6\p@\@plus6\p@\relax
  \trivlist
  \item[\hskip\labelsep
        \itshape
    #1\@addpunct{:}]\ignorespaces
}{%
  \popQED\endtrivlist\@endpefalse
}
\providecommand{\proofname}{Proof}}{}%
\newtheorem{theorem}{Theorem}
\newtheorem{proposition}{Proposition}
\newtheorem{definition}{Definition}
\newtheorem{lemma}{Lemma}

\theoremstyle{remark}
\newtheorem{remark}{Remark}
}

\gdef\doi@string{0000000000}

\def\@doi@fixed@field{}
\def\@doi@variable@field{00000000000000000000}


\def\jname#1{\gdef\@jname{#1}}
\def\vol#1{\gdef\@vol{#1}}
\def\issue#1{\gdef\@issue{#1}}
\def\date#1{\gdef\@date{#1}}
\newcommand\DOI[2][\@doi@fixed@field]{%
  \gdef\@doi@variable@field{#1}%
  \setDOI{#1}{#2}}
\newcommand{\setDOI}[2]{%
  \gdef\doi@string{#1#2}}

\def\@jname{\runtrack{\sf\itshape Healthcare Technology Letters}}%
\def\@vol{00}
\def\@issue{00}
\def\@date{00}
\def\@jpages{\thepage--\pageref{LastPage}}%
\def\@artnum{00000000}%
\def\artnum#1{\def\@artnum{#1}}%


\def\labelenumi{{\rm \arabic{enumi}}}
\def\theenumi{\arabic{enumi}}
\def\labelenumii{{\rm(\alph{enumii})}}
\def\theenumii{\alph{enumii}}
\def\p@enumii{\theenumi}
\def\labelenumiii{{\rm(\arabic{enumiii})}}
\def\theenumiii{\roman{enumiii}}
\def\p@enumiii{\theenumi(\theenumii)}
\def\labelenumiv{{\rm(\arabic{enumiv})}}
\def\theenumiv{\Alph{enumiv}}
\def\p@enumiv{\p@enumiii\theenumiii}
\def\labelitemi{$\bullet$}
\def\labelitemii{$\bullet$}
\def\labelitemiii{$\bullet$}
\def\labelitemiv{$\bullet$}

\setlength{\leftmargini}{0pt}
\setlength{\leftmarginii}{\z@}
\setlength{\leftmarginiii}{\z@}
\setlength{\leftmarginiv}{\z@}

\def\enumargs{%
   \partopsep     \z@
   \itemsep       \z@
   \parsep        \z@
   \rightmargin   \z@
   \labelsep      0.5em
   \listparindent \parindent
   \itemindent    \z@}

\def\enumerate{%
    \@ifnextchar[{\@numerate}{\@numerate[3.]}}

\def\@numerate[#1]{%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{\csname label\@enumctr\endcsname}{%
       \enumargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@listdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }
\def\endenumerate{\endlist\advance \@listdepth -1}

\def\itemargs{%
   \partopsep     \z@
   \itemsep       \z@
   \parsep        \z@
   \rightmargin   \z@
   \labelsep      0.5em
   \listparindent \parindent
   \itemindent    \z@}

\def\itemize{%
    \@ifnextchar[{\@itemize}{\@itemize[$\bullet$]}}

\def\@itemize[#1]{%
     \ifnum \@itemdepth >3 \@toodeep\else
     \advance\@itemdepth \@ne
     \edef\@itemctr{item\romannumeral\the\@itemdepth}
     \list{\csname label\@itemctr\endcsname}{%
       \itemargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@listdepth\endcsname}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }
\let\enditemize\endlist

\renewcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont #1}


\def\titlepagefooter{{%
\fontsize{9}{11}\selectfont\sf \@jname, pp.~\@jpages}}

\def\ps@plain{\let\@mkboth\@gobbletwo
     \let\@oddhead\@empty
     \def\@oddfoot{\vbox{\vskip1.6pc\hbox to \textwidth{\reset@font\titlepagefooter\hfill{\sf \thepage}\\[-7pt]}
     \hbox to \textwidth{{\sf }\hfill{\sf $\copyright$ The Institution of Engineering and Technology 2024}}}}
     \let\@evenhead\@empty
     \def\@evenfoot{\reset@font\vbox{\vskip1.6pc\hbox to \textwidth{{\sf \thepage}\hfill\titlepagefooter\\[-7pt]}
     \hbox to \textwidth{{\sf $\copyright$ The Institution of Engineering and Technology 2024}\hfill{}}}}}

\def\ps@headings{%
     \def\@oddfoot{\reset@font\vbox{\vskip1.6pc\hbox to \textwidth{\titlepagefooter\hfill{\sf \thepage}\\[-7pt]}
     \hbox to \textwidth{{}\hfill{\sf $\copyright$ The Institution
     of Engineering and Technology 2024}}}}
     \def\@evenfoot{\reset@font\vbox{\vskip1.6pc\hbox to \textwidth{{\sf \thepage}\hfill\titlepagefooter\\[-7pt]}
     \hbox to \textwidth{{\sf $\copyright$ The Institution of Engineering and
     Technology 2024}\hfill{}}}}
    \let\@evenhead\@empty%
    \let\@oddhead\@empty%
    \let\@mkboth\markboth
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \thesection\quad
        \fi
        ##1}}}}

\def\ps@myheadings{%
     \def\@oddfoot{\reset@font\vbox{\vskip1.6pc\hbox to \textwidth{\titlepagefooter\hfill{\sf \thepage}\\[-7pt]}
     \hbox to \textwidth{{}\hfill{\sf $\copyright$ The Institution
     of Engineering and Technology 2024}}}}
     \def\@evenfoot{\reset@font\vbox{\vskip1.6pc\hbox to \textwidth{{\sf \thepage}\hfill\titlepagefooter\\[-7pt]}
     \hbox to \textwidth{{\sf $\copyright$ The Institution of Engineering and
     Technology 2024}\hfill{}}}}
    \let\@evenhead\@empty%
    \let\@oddhead\@empty%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }

\renewcommand\maketitle{\par%
\@afterindentfalse%
  \begingroup
    \renewcommand\thefootnote{}%
    \def\@makefnmark{{{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\noindent{{\normalfont\@thefnmark}}##1}%
    \@afterindentfalse%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
%    \if@twocolumn
%      \ifnum \col@number=\@ne
%        \twocolumn[\@maketitle]
%      \else
%        \@maketitle%
%      \fi
    \else
      \newpage
      \global\@topnum\z@
      \@maketitle%
    \fi%
    \thispagestyle{plain}%
    \@thanks%
  \endgroup%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax%
\@afterheading}

\def\abstractfont{\fontfamily{\rmdefault}\fontseries{m}\fontshape{n}\fontsize{9}{10.5}\selectfont\parindent1em}

\def\@maketitle{%
  \newpage
  \noindent%
  \let\footnote\thanks%
  \parindent=0pt%
\vskip1.5mm
      {\fontfamily{\rmdefault}\fontseries{b}\fontshape{n}\fontsize{14}{18}\selectfont\mathversion{bold}\raggedright\@title \par}%
    \vskip12.5pt%
    {\fontfamily{\rmdefault}\fontseries{m}\fontshape{it}\fontsize{12}{14}\selectfont\@author\vphantom{$^1$}\par}
    \ifx\@address\empty\else
        \vskip7.5pt%
        {\fontfamily{\rmdefault}\fontseries{m}\fontshape{it}\fontsize{10}{12}\selectfont\leavevmode\vphantom{$^1$}\@address\par}
    \fi
   \ifx\@historydate\empty\else
        \vskip13pt
        {\fontfamily{\rmdefault}\fontseries{m}\fontshape{n}\fontsize{9}{10}\selectfont\mathversion{bold}\@historydate\par}
    \fi
\ifx\@abstract\empty\else%
        \vskip24.5pt
       {\abstractfont\@abstract\par}
        \vskip3pt%
   \fi
   \ifx\@keywords\empty\else
        \vskip8pt
        {\fontfamily{\rmdefault}\fontseries{b}\fontshape{n}\fontsize{9}{10}\selectfont\mathversion{bold}\@keywords\par}
    \fi
    \ifx\@classification\empty\else
\vskip4pt
      {\fontsize{8}{9}\selectfont\@classification\par}%
    \fi%
  \par
  \vskip2pc
  }

\def\title{\@ifnextchar[{\@title@wst@}{\@title@nst@}}
\def\@title@wst@[#1]{\shorttitle{#1}\@title@assign@}
\def\@title@nst@#1{\shorttitle{#1}\@title@assign@{#1}}
\def\@title@assign@#1{\def\@title{#1}}

\def\shorttitle#1{\gdef\@shorttitle{#1}}

\def\author{\@ifnextchar[{\@author@wst@}{\@author@nst@}}
\def\@author@wst@[#1]{\shortauthor{#1}\@author@assign@}
\def\@author@nst@#1{\shortauthor{#1}\@author@assign@{#1}}
\def\@author@assign@#1{\gdef\@author{#1}}

\def\shortauthor#1{\gdef\@shortauthor{#1}}\shortauthor{}

\def\date#1{\def\@date{#1}}\date{}

\long\gdef\abstract#1{\global\gdef\@abstract{\noindent#1\par}}\gdef\@abstract{}
\long\gdef\address#1{\global\gdef\@address{#1}}\gdef\@address{}%
\long\gdef\corres#1{\global\gdef\@corres{\vskip-\baselineskip\vskip2pt#1}}\gdef\@address{}%

\def\keywordsname{Key words}%
\long\gdef\keywords#1{\global\gdef\@keywords{\textit{\keywordsname}:\ #1.}}\gdef\@keywords{}%

\long\gdef\historydate#1{\global\gdef\@historydate{#1.}}\gdef\@historydate{}%

\def\@classification{}
\newcommand\classification[2]{%
     \gdef\@classification{{\noindent\textit{#1}:\enskip #2\par}}}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{secnumdepth}{3}

\def\sectionfont{\fontfamily{\rmdefault}\fontseries{b}\fontshape{n}\fontsize{9}{10}\selectfont}
\def\subsectionfont{\fontfamily{\rmdefault}\fontseries{m}\fontshape{n}\fontsize{9}{10}\selectfont}
\def\subsubsectionfont{\fontfamily{\rmdefault}\fontseries{m}\fontshape{n}\fontsize{9}{10}\selectfont}


\renewcommand\section{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection {section}{1}{\z@}%
                                   {-10pt \@plus -.2ex \@minus -.2ex}%
                                   {-0.001pt}%
                                   {\sectionfont}}

\newcommand\runsection{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection {section}{1}{\z@}%
                                   {-10pt \@plus -.2ex \@minus -.2ex}%
                                   {1pt}%
                                   {\sectionfont}}

\renewcommand\subsection{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection{subsection}{2}{\z@}%
                                     {12pt \@plus 1ex \@minus .2ex}%
                                     {-0.001pt}%
                                     {\subsectionfont}}

\newcommand\runsubsection{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection{subsection}{2}{\z@}%
                                     {12pt \@plus 1ex \@minus .2ex}%
                                     {1pt}%
                                     {\subsectionfont}}

\renewcommand\subsubsection{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection{subsubsection}{3}{\z@}%
                                     {12pt \@plus 1ex \@minus .2ex}%
                                     {-0.001pt}%
                                     {\subsubsectionfont}}
\newcommand\runsubsubsection{\def\@seccntformat##1{\csname the##1\endcsname.\hskip.5em}\@startsection{subsubsection}{3}{\z@}%
                                     {12pt \@plus 1ex \@minus .2ex}%
                                     {1pt}%
                                     {\subsubsectionfont}}

\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}

\def\@seccntformati#1{\csname the#1\endcsname.\hskip6pt}
\def\@seccntformatii#1{\csname the#1\endcsname.\hskip6pt}
\def\@seccntformatiii#1{\csname the#1\endcsname.\hskip5pt}
\def\@seccntformativ#1{\csname the#1\endcsname.\quad}
\def\@seccntformatv#1{\csname the#1\endcsname.\quad}

\newdimen\AtoBskip\AtoBskip=-0.5pt
\newdimen\BtoCskip\BtoCskip=1pt
\newdimen\CtoDskip\CtoDskip=1.5pt
\newdimen\DtoEskip\DtoEskip=0pt
\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \ifnum#2 = 2%%% Space between A & B Head
    \vskip\AtoBskip
    \fi
    \ifnum#2 = 3%%% Space between B & C Head
    \vskip\BtoCskip
    \fi
    \ifnum#2 = 4%%% Space between C & D Head
    \vskip\CtoDskip
    \fi
    \ifnum#2 = 5%%% Space between D & E Head
    \vskip\DtoEskip
    \fi
    \everypar{}%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
    {\@ssect{#2}{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svseci\@empty%
    \let\@svsecii\@empty%
    \let\@svseciii\@empty%
    \let\@svseciv\@empty%
    \let\@svsecv\@empty%
  \else
    \refstepcounter{#1}%
    \protected@edef\@svseci{\@seccntformati{#1}\relax}%
    \protected@edef\@svsecii{\@seccntformatii{#1}\relax}%
    \protected@edef\@svseciii{\@seccntformatiii{#1}\relax}%
    \protected@edef\@svseciv{\@seccntformativ{#1}\relax}%
    \protected@edef\@svsecv{\@seccntformatv{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
    \ifcase#2%%% Checking Levels
    \or%
      #6{%
        \@hangfrom{\hskip #3\relax\@svseci}%
          \interlinepenalty \@M {#8}\@@par
          }%
    \or%
      #6{%
        \@hangfrom{\hskip #3\relax\@svsecii}%
          \interlinepenalty \@M #8\@@par}%
    \else%
      #6{%
        \@hangfrom{\hskip #3\relax\@svseciii}%
          \interlinepenalty \@M #8\@@par}%
    \fi
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
    \ifcase#2%
    \or%
      #6{\hskip #3\relax
      \@svseci {#8:\space}
    \ifnum#2 = 2\vspace*{-10pt}\fi}
    \or%
      #6{\hskip #3\relax
      \@svsecii #8:\space}%
    \else%
      #6{\hskip #3\relax
      \@svseciii #8:\space}%
    \fi%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

\def\@ssect#1#2#3#4#5#6{%
  \@tempskipa #4\relax
  \ifdim \@tempskipa>\z@
    \begingroup
    \ifcase#1%
    \or%
      #5{%
        \@hangfrom{\hskip #2}%
          \interlinepenalty \@M {#6}\@@par
          \vskip-8.5pt%
%          \rlap{\rule{\textwidth}{.5pt}}%
          }%
    \or%
      #5{%
        \@hangfrom{\hskip #2}%
          \interlinepenalty \@M {#6}\@@par}%
    \else%
      #5{%
        \@hangfrom{\hskip #2}%
          \interlinepenalty \@M {#6}\@@par}%
    \fi
    \endgroup
  \else
    \ifcase#1%
    \or%
        \def\@svsechd{#5{\hskip #2\relax #6}}%
    \or%
        \def\@svsechd{#5{\hskip #2\relax #6}}%
    \else
        \def\@svsechd{#5{\hskip #2\relax #6}}%
    \fi%
  \fi%
  \@xsect{#4}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\source#1{\par\vspace*{2.5pt}{\rm #1}}

\setlength\abovecaptionskip{7.5\p@}
\setlength\belowcaptionskip{0\p@}

\def\fnum@figure{Figure~\thefigure}

\long\def\@makecaption#1#2{\fontsize{8}{9}\selectfont%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1. #2}%
  \ifdim \wd\@tempboxa >\hsize
    {\bf #1} \textit{#2}\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\begingroup
\catcode`\Q=3
\long\gdef\@ifmtarg#1{\@xifmtarg#1QQ\@secondoftwo\@firstoftwo\@nil}
\long\gdef\@xifmtarg#1#2Q#3#4#5\@nil{#4}
\long\gdef\@ifnotmtarg#1{\@xifmtarg#1QQ\@firstofone\@gobble\@nil}
\endgroup

\newbox\tablecaptionbox
\long\def\@tablecaption#1#2{\par%
  \setbox\tablecaptionbox=\vbox{\hsize\textwidth%
    {{\fontsize{9}{10}\selectfont\bfseries #1}\ #2}\strut}%
    \unvbox\tablecaptionbox\par%
  \vspace{\belowcaptionskip}
  }%


\def\tablesource#1{\@hangfrom{\textit{Source:\hskip6pt}}#1\par}
\def\tablenote#1{\@hangfrom{\textit{Note:\hskip6pt}}#1\par}
\def\tablefoot#1{%
\def\tfmark##1{\@hangfrom{\textsuperscript{##1}\hskip5pt}}%
#1\par}

\def\ttext#1#2{{#1\enspace}{#2\par}\par}
\def\tabletext#1#2{\@hangfrom{#1\enspace}{#2}\par}

\def\hrulefill{\leavevmode\leaders\hrule height 0.5pt\hfill\kern\z@}

\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\@hangfrom{Table\ \thetable}}
\def\table{\let\@makecaption\@tablecaption\@float{table}}
\let\endtable\end@float
\@namedef{table*}{\let\@makecaption\@tablecaption\@dblfloat{table}}
\@namedef{endtable*}{\end@dblfloat}

%%% TABLES

\newcommand{\tabhead}[2][c]{{\begin{tabular}[t]{@{}#1@{}} #2 \end{tabular}}}

\newcolumntype{P}[1]{>{\raggedright\let\\\@arraycr\hangindent1em}p{#1}}

\newif\if@rotate \@rotatefalse
\newif\if@rotatecenter \@rotatecenterfalse
\def\rotatecenter{\global\@rotatecentertrue}
\def\rotateendcenter{\global\@rotatecenterfalse}
\def\rotate{\global\@rotatetrue}
\def\endrotate{\global\@rotatefalse}
\newdimen\rotdimen
\def\rotstart#1{\special{ps: gsave currentpoint currentpoint translate
    #1 neg exch neg exch translate}}
\def\rotfinish{\special{ps: currentpoint grestore moveto}}
\def\rotl#1{\rotdimen=\ht#1\advance\rotdimen by \dp#1
    \hbox to \rotdimen{\vbox to\wd#1{\vskip \wd#1
    \rotstart{270 rotate}\box #1\vss}\hss}\rotfinish}
\def\rotr#1{\rotdimen=\ht #1\advance\rotdimen by \dp#1
    \hbox to \rotdimen{\vbox to \wd#1{\vskip \wd#1
    \rotstart{90 rotate}\box #1\vss}\hss}\rotfinish}

\newdimen\tempdime
\newbox\temptbox

\newenvironment{processtable}[3]{\setbox\temptbox=\hbox{{\fontsize{8}{9}\selectfont #2}}%
\tempdime\wd\temptbox\@processtable{#1}{#2}{#3}{\tempdime}}
{\relax}

\newcommand{\@processtable}[4]{%
\if@rotate
\setbox4=\vbox to \hsize{\vss\hbox to \textheight{%
\begin{minipage}{#4}%
\@ifmtarg{#1}{}{\caption{#1}}{\fontsize{8}{9}\selectfont #2}%
\vskip7\p@\noindent
\parbox{#4}{\fontsize{8}{9}\selectfont #3\par}%
\end{minipage}}\vss}%
\rotr{4}
\else
\hbox to \hsize{\hfil\begin{minipage}[t]{#4}%
%\vskip2.9pt
\@ifmtarg{#1}{}{\caption{#1}}{\fontsize{8}{9}\selectfont #2}%
\vskip.5\p@\noindent
\parbox{#4}{\fontsize{8}{9}\selectfont #3\par}%
\end{minipage}\hfil}\fi}%

\def\ptvhrule{\hrule height0.25pt}
\def\toprule{\noalign{\vskip5pt}\noalign{\ptvhrule}\noalign{\vskip3pt}}%
\def\midrule{\noalign{\vskip3pt}\noalign{\ptvhrule}\noalign{\vskip8pt}}%%
\def\botrule{\noalign{\vskip3pt}\noalign{\ptvhrule}\noalign{\vskip4pt}}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{appendix}
\renewcommand\appendix{\par
  \setcounter{secnumdepth}{0}
  \setcounter{equation}{0}%
  \setcounter{table}{0}%
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \refstepcounter{appendix}
  \renewcommand\theequation{\@Alph\c@appendix.\@arabic\c@equation}
  \renewcommand\thetable{\@Alph\c@appendix.\arabic{table}}
  \renewcommand\thefigure{\@Alph\c@appendix.\arabic{figure}}
  }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\footnoterule{\vskip-3\p@ plus2pt minus2pt
\hrule \@width 2pc \kern 9.5\p@}
\renewcommand\@makefntext[1]{\hskip1em{\smash{\@makefnmark}}\hskip.4em#1}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setlength{\jot}{7\p@}
\medmuskip=4mu%
\thickmuskip=3.5mu%

\DeclareSymbolFont{EulerExtension}{U}{euex}{m}{n}
\DeclareMathSymbol{\intop}{\mathop}{EulerExtension}{"52}
\DeclareMathSymbol{\ointop}{\mathop}{EulerExtension}{"48}

\vbadness=9999
\tolerance=9999
\clubpenalty=10000
\widowpenalty=10000
\setlength{\emergencystretch}{3em}

\setlength\parskip{0\p@ \@plus 0\p@}

\setlength\parindent{9\p@}

\@ifpackageloaded{setspace}{
\long\def\@footnotetext#1{%
  \insert\footins{%
    \def\baselinestretch {\setspace@singlespace}%
    \setstretch {2}
    \reset@font\footnotesize
    \interlinepenalty\interfootnotelinepenalty
    \splittopskip\footnotesep
    \splitmaxdepth \dp\strutbox \floatingpenalty \@MM
    \hsize\columnwidth
    \@parboxrestore
    \protected@edef\@currentlabel{%
      \csname p@footnote\endcsname\@thefnmark
    }%
    \color@begingroup
      \@makefntext{%
        \rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}%
    \color@endgroup}}
\skip\footins 20pt plus4pt minus4pt
\setlength\footnotesep{.75\baselineskip}
%
\long\def\@makecaption#1#2{%
  \setstretch {1.5}
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{#1}. #2}%
  \ifdim \wd\@tempboxa >\hsize
    {{#1}. #2\par}
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\box\@tempboxa}%
  \fi
  \vskip\belowcaptionskip}
\def\@setsize#1#2#3#4{%
    \setstretch {2}
  \@nomath#1%
  \let\@currsize#1%
  \baselineskip #2%
  \baselineskip \baselinestretch\baselineskip
  \parskip \baselinestretch\parskip
  \setbox\strutbox \hbox{%
    \vrule height.7\baselineskip
           depth.3\baselineskip
           width\z@}%
  \skip\footins \baselinestretch\skip\footins
  \normalbaselineskip\baselineskip#3#4}
\def\arraystretch{1.5}
}{}


\def\fps@eqnfloat{!tp}
\def\ftype@eqnfloat{4}
\newenvironment{eqnfloat}
               {\@float{eqnfloat}}
               {\end@float}
\newenvironment{eqnfloat*}
               {\@dblfloat{eqnfloat}}
               {\end@dblfloat}


\pagestyle{myheadings}
\pagenumbering{arabic}
\if@twoside
\else
  \raggedbottom
\fi
\if@twocolumn
  \twocolumn
  \sloppy
\else
  \onecolumn
\fi

\frenchspacing

\newdimen\bibindent
\setlength\bibindent{0em}
\renewenvironment{thebibliography}[1]
     {\def\@seccntformati##1{\csname the##1\endcsname\quad\enskip}
     \newcommand\bibsection{\def\@seccntformat#1{\csname the#1\endcsname\qquad}\@startsection {section}{1}{\z@}%
                                   {-10pt \@plus -1ex \@minus -.2ex}%
                                   {10pt}%
                                   {\sectionfont}}
     \fontsize{9}{11}\selectfont\bibsection{\bf\refname}%
      \list{[\@arabic\c@enumiv]}%
           {\settowidth\labelwidth{\@biblabel{[#1]}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
\itemsep0pt
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\renewcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty

\def\ack#1{{\vskip5.5pt\noindent \fontsize{9}{11}\selectfont\section{Acknowledgment}#1}}

\def\fundingandinterests#1{{\vskip5.5pt\noindent \fontsize{9}{11}\selectfont\section{Funding and Declaration of Interests}#1}}

\def\etal{{\fontsize{6.5}{8}\selectfont\it ET~AL.}}

\endinput
