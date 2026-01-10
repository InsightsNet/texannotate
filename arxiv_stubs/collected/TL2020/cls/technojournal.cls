%%%
%%% This is a LaTeX Class file(technojournal.cls) for Techno-Press Journals.
%%% Editing version
%%%
%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{technojournal}
              [2016/01/12 v1 Techno-Press LaTeX document class]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\newif\if@referee

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
\DeclareOption{referee}{\@refereetrue}
\DeclareOption{editor}{\@refereefalse}
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
\ExecuteOptions{a4paper,11pt,twoside,onecolumn,final,referee}
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
\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\thepage\hfil\slshape\leftmark}%
      \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
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
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \thesection\quad
        \fi
        ##1}}}}
\fi
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }

\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thesection {\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
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
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\Large\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\large\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}
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
      \begin{center}%
        \bfseries \abstractname
        \@endparpenalty\@M
      \end{center}}%
     {\par\vfil\null\endtitlepage}
\else
  \newenvironment{abstract}{%
      \if@twocolumn
        \section*{\abstractname}%
      \else
        \small
        \begin{center}%
          {\bfseries \abstractname\vspace{-.5em}\vspace{\z@}}%
        \end{center}%
        \quotation
      \fi}
      {\if@twocolumn\else\endquotation\fi}
\fi
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
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@Alph\c@section}}
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
\def\fnum@figure{\figurename\nobreakspace\thefigure}
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
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{4\p@}
\setlength\belowcaptionskip{4\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
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
     {\section*{\refname}%
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
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
 \def\footnoterule{\kern-3\p@
     \nobreak \vfill
     \hrule \@width 2in \kern 2.6\p@} % the \hrule is .4pt high
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%code revision
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% pagestyle %%%%%%%%%%%%%%%%%%%%%
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\makeatletter
\newcommand{\@copyrightaddress}{}
\newcommand{\@copyrightprint}{}
\newcommand{\@copyrightonline}{}

\newcommand{\technocopyright}[3]{\def\@copyrightaddress{#1}%
\def\@copyrightprint{#2}
\def\@copyrightonline{#3}}


\fancypagestyle{frontpage}{
\fancyhf{} %
%\fancyhead[LO]{\journalinfo \newline {\showdoi}}
%\fancyhead[RO]{\small\thepage}
%\fancyfoot[LO]{\sffamily\fontsize{9pt}{9pt}\selectfont\textbf{Copyright \textcopyright{}  \@journalyear{} Techno-Press. Ltd.}\newline\urlstyle{sf}
%\url{\@copyrightaddress}\urlstyle{rm}\hfill \sffamily\fontsize{9pt}{9pt}\selectfont ISSN: \@copyrightprint (Print), \@copyrightonline (Online)}
\renewcommand{\headrulewidth}{0pt}
\fancyheadoffset{1pt}
}

\fancypagestyle{journalstyle}{
\fancyhf{}
\fancyhead[LE]{\small\thepage}
\fancyhead[CE]{\small\itshape\leftmark}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[RO]{\small\thepage}
\fancyhead[CO]{\small\itshape\rightmark}
\fancyheadoffset{1pt}
}
\makeatother

\makeatletter
\def\@mymakefnmark{\hbox{\textsuperscript{\@thefnmark}\m@th}}
\renewcommand\@makefntext[1]{%
  \noindent\@mymakefnmark #1}
%  \noindent\makebox[0.5em][r]{\@mymakefnmark}\small#1}
\makeatother

%superiors

\RequirePackage{geometry} 
\geometry{%
a4paper,
left=28mm,
right=28mm,
top=50mm,
bottom=40mm,
headheight=30pt,
%headheight=30pt,
headsep = 20pt,
%footskip = 0mm,
footnotesep = 7mm,
} 
\RequirePackage{indentfirst}
\RequirePackage{natbib}
\setcitestyle{citesep={,},aysep={},yysep={, }}
\RequirePackage{url}
\urlstyle{rm}

\def\bibfont{\small}
\setlength{\bibsep}{3pt}

%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{amsmath}
\allowdisplaybreaks
\raggedbottom



%%%% Section %%%%

\RequirePackage[explicit]{titlesec}

\titleclass{\subsubsubsection}{straight}[\subsection]
\newcounter{subsubsubsection}[subsubsection]

\renewcommand\thesubsubsubsection{\thesubsubsection.\arabic{subsubsubsection}}
\renewcommand\theparagraph{\thesubsubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph{\theparagraph.\arabic{subparagraph}}

\makeatletter
\renewcommand\paragraph{\@startsection{paragraph}{5}{\z@}%
  {3.25ex \@plus1ex \@minus.2ex}%
  {-1em}%
  {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{6}{\parindent}
  {3.25ex \@plus1ex \@minus .2ex}%
  {-1em}%
  {\normalfont\normalsize\bfseries}}
\def\toclevel@subsubsubsection{4}
\def\toclevel@paragraph{5}
\def\toclevel@paragraph{6}
\def\l@subsubsubsection{\@dottedtocline{4}{7em}{4em}}
\def\l@paragraph{\@dottedtocline{5}{10em}{5em}}
\def\l@subparagraph{\@dottedtocline{6}{14em}{6em}}
\@addtoreset{subsubsubsection}{section}
\@addtoreset{subsubsubsection}{subsection}
\@addtoreset{paragraph}{subsubsubsection}
\makeatother


\setcounter{secnumdepth}{6}
\setcounter{tocdepth}{6}

%%%%%%%%%%%%%%%%%%%%%%%%%%% font design %%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}
\ifXeTeX
\RequirePackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial} 
\else
\ifLuaTeX
\RequirePackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial} 
\else
\fi
\fi

\titleformat{\section}[hang]{\sffamily\normalsize\bfseries}{}{0em}{\thesection. #1}
\titleformat{\subsection}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt}\thesubsection\enspace #1}
\titleformat{\subsubsection}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt}\thesubsubsection\enspace #1}
\titleformat{\subsubsubsection}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt}{\thesubsubsubsection\enspace #1}}


\titleformat{name=\section,numberless}[hang]{\sffamily\normalsize\bfseries}{}{0em}{#1}
\titleformat{name=\subsection,numberless}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt} #1}
\titleformat{name=\subsubsection,numberless}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt} #1}
\titleformat{name=\subsubsubsection,numberless}[hang]{\sffamily\normalsize\itshape}{}{0em}{\hspace{15pt}#1}

\ifXeTeX
\titlespacing*{\section} {0em}{16pt}{8pt}
\titlespacing*{\subsection} {0em}{8pt}{8pt}
\titlespacing*{\subsubsection} {0em}{8pt}{0ex}
\titlespacing*{\subsubsubsection} {0em}{8pt}{0ex}
\setlength{\parindent}{1.4em}
\else
\ifLuaTeX
\titlespacing*{\section} {0em}{16pt}{8pt}
\titlespacing*{\subsection} {0em}{8pt}{8pt}
\titlespacing*{\subsubsection} {0em}{8pt}{0ex}
\titlespacing*{\subsubsubsection} {0em}{8pt}{0ex}
\setlength{\parindent}{0em}
\else
\titlespacing*{\section} {0em}{16pt}{8pt}
\titlespacing*{\subsection} {0em}{8pt}{8pt}
\titlespacing*{\subsubsection} {0em}{8pt}{0ex}
\titlespacing*{\subsubsubsection} {0em}{8pt}{0ex}
\fi
\fi


\let\tempone\itemize
\let\temptwo\enditemize
\let\tempthree\enumerate
\let\tempfour\endenumerate

\renewenvironment{itemize}{\tempone\setlength{\itemsep}{1pt}}{\temptwo} 
\renewenvironment{enumerate}{\tempthree\setlength{\itemsep}{1pt}}{\tempfour} 
\RequirePackage{float}
\floatstyle{plaintop}
\restylefloat{table}

\RequirePackage{caption}
\captionsetup[figure]{labelsep=space,font=small}%,format=hang
\captionsetup[table]{position=top,singlelinecheck=false,labelsep=space,font=small,aboveskip=0pt}%format=hang,

\newcommand{\received}[1]{\global\def\@received{#1}}
\newcommand{\revised}[1]{\global\def\@revised{#1}}
\newcommand{\accepted}[1]{\global\def\@accepted{#1}}

\def\@maketitle{%
 \newpage
  \vspace*{20pt}
  {  \begin{center}
  \ifx\@corresp\empty
  \blfootnote{Corresponding author, E-mail: \email{\@correspemail}}
  \else
  \blfootnote{Corresponding author, \@corresp, E-mail: \email{\@correspemail}}
  \fi
   {\fontsize{16pt}{16pt}\selectfont\sffamily  \@title \par}%
    \vskip 1em
    {\centering
    {\fontsize{12pt}{12pt}\selectfont
      \lineskip .5em%
        \sffamily\printauthor
        \endgraf}}%
    \vskip 12pt%
  {\centering\itshape\sffamily\fontsize{9.5pt}{10.5pt}\selectfont \affilinfo}

  \vskip 10pt
  
    {\small \itshape(Received \@received,  Revised \@revised, Accepted \@accepted)  \par}%  
  \end{center}\vskip 10pt
  }
}

\newcommand{\maketitle}{%
\def\@makefnmark{\raise0.7ex\hbox{\small\sffamily{\@thefnmark}\m@th}}
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
  \if@referee
  \thispagestyle{frontpage} 
  \else
  \thispagestyle{empty} 
  \fi
\setcounter{footnote}{0}
\def\@makefnmark{\hbox{$^{\@thefnmark}\m@th$}}
}
  
  
  
  
\makeatother


%%%%%%%%%%%%%%%%%%%%%%%% frontmatter commands


\makeatletter
\newcommand{\keywords}[1]{\def\@keywords{#1}}
\renewenvironment{abstract}{%
      \if@twocolumn
        \section*{\abstractname}%
      \else
       \fontsize{10.5pt}{12pt}\selectfont
          {\noindent\bfseries\sffamily {\fontsize{9pt}{10pt}\selectfont\abstractname.}}
      \fi}
      {\vskip 6pt plus 0pt minus 0pt {\fontsize{9.5pt}{10.5pt}\selectfont\noindent\textbf{\sffamily\fontsize{9pt}{10pt}\selectfont Keywords:}\enspace\enspace\fontsize{10.5pt}{12pt}\selectfont \@keywords}\par%
      \if@twocolumn
      \noindent\rule[10pt]{\columnwidth}{0.5pt}%
      \else
      \noindent\rule[10pt]{\textwidth}{0.5pt}
      \fi}
\makeatother

\newcounter{affil}
\makeatletter
\newcommand{\affilinfo}{}


%%%%%%%%%%%%%%%%%%%%%% Title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\protected\def\setaffilfont{\sffamily\itshape\fontsize{7pt}{7pt}\selectfont}
\newcommand{\affiliation}[2][\empty]{\refstepcounter{affil}%
  \ifx#1\empty
    \xdef\affilinfo{\affilinfo #2\noexpand\par}%
  \else
    \label{author:#1}%
    \xdef\affilinfo{\affilinfo
      \mbox{\setaffilfont\raise1ex\hbox{\theaffil}}#2\noexpand\par}%
  \fi
}

%%%% authors %%%%%
\RequirePackage[breaklinks=true]{hyperref}
\hypersetup{colorlinks=true,allcolors=black}
\RequirePackage{refcount}


\newcommand{\@authors}{}
\newcommand{\@headauthor}{}
\newcommand{\@shorttitle}{}

\RequirePackage{ifthen}

\newcounter{authors} 

\newcounter{maximumauthor}
\makeatletter
\renewcommand{\title}[2][\empty]{%\
\ifx#1\empty
\def\@title{#2}
\def\@shorttitle{#2}
\else
\def\@shorttitle{#1}
\def\@title{#2}
\fi
}

\newcommand{\setrefauthor}[1]{\getrefnumber{author:#1}}

\newcommand\printauthornumber[1]{%
  \let\@tempb\z@
  \@for\@tempa:=#1\do{%
    \ifx\@tempb\@ne,\fi
    \setrefauthor\@tempa
    \let\@tempb\@ne
  }%
}




\renewcommand\author[3][\empty]{%
  \ifx#1\empty%
  \g@addto@macro\@authors{{#2#3}}%
  \else 
  \g@addto@macro\@authors{{#2\textsuperscript{\printauthornumber{#1}}#3}}%
  \fi
}
\newcommand\printauthor{%
  \let\next\relax
  \expandafter\print@author\@authors\@nil\relax\relax
}
\newcommand\print@author[3]{%
  \ifx\@nil#1%
    \let\next\relax
  \else
    \ifx\@nil#2%
      #1%
      \let\next\relax
    \else
      \ifx\@nil#3%
        #1\ifx\next\relax\else\fi\ and #2%
        \let\next\relax
      \else
        #1, %
        \def\next{\print@author{#2}{#3}}%
      \fi
    \fi
  \fi
  \next
}

 

\newcommand{\shortauthor}[1]{\def\@headauthor{#1}}

\renewcommand{\rightmark}{\@shorttitle}
\renewcommand{\leftmark}{\@headauthor}
 
\newcommand\blfootnote[1]{%
  \begingroup
  \renewcommand\thefootnote{}\footnote{\hspace{-1pt}{\raise-0.1ex\hbox{*}}#1}%
  \addtocounter{footnote}{-1}%
  \endgroup
}
 

\newcommand{\email}[1]{\url{#1}}
\newcommand{\@corresp}{\empty}
\newcommand{\@correspemail}{\empty}
 
\newcommand{\correspinfo}[2][\empty]{\ifx#1\def\@correspemail{#2}\else%
\def\@corresp{#1}%
\def\@correspemail{#2}\fi}

\newcommand{\corresp}{\raise0.14ex\hbox{\rmfamily\fontsize{13pt}{13pt}\selectfont*}}
\renewcommand{\thanks}[1]{{\renewcommand{\thefootnote}{\alph{footnote}}\footnote{#1}}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%journal info %%%%%%%%%%%%%%%%%%%%%%

%\newcommand{\doi}[1]{\def\@doi{#1}}
%\newcommand{\journalname}[1]{\def\@journalname{#1}}
%\newcommand{\showdoi}{{\sffamily\urlstyle{sf} DOI: \url{http://dx.doi.org/\@doi}}\urlstyle{rm}}

%\newcommand{\journalvol}[1]{\def\@journalvol{#1}}
%\newcommand{\journalnumber}[1]{\def\@journalnumber{#1}}
%\newcommand{\journalyear}[1]{\def\@journalyear{#1}}

%\newcommand{\journalinfo}{\small{\bfseries\@journalname}, {\itshape Vol. \@journalvol, No. \@journalnumber{} (\@journalyear) \thepage{}--\pageref{LastPage}}}


%%%%%%%%%%%%%%%%%%%%%%%%% refereee %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@referee
\RequirePackage{changes}
%\setremarkmarkup{(#2)}
\pagestyle{journalstyle}
\else
\RequirePackage[final]{changes}
\setremarkmarkup{(#2)}
\pagestyle{empty}
\fi
\makeatother

\received{keep as black}
\revised{keep as black}
\accepted{keep as black}

\endinput
%%
%% End of file `article.cls'.
