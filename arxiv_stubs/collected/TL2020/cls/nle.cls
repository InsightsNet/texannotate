%% This is file `nle.cls'
%% Version 1.0 released 20th May 2004
%%
%% CUP Journal - Natural Language Engineering (NLE) document class
%% Copyright 2004 Cambridge University Press
%%
%% By TechBooks
%%	  based on nle.sty v1.23, released 24th September 1998.
%%
%% Bugs (in the case of unchanged files) should be reported to
%% texline@cambridge.org
%%
%% This software may only be used in the preparation of journal articles
%% or books or parts of books to be published by Cambridge University Press.
%% Any other use constitutes an infringement of copyright.
%%
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
%%
\NeedsTeXFormat{LaTeX2e}[1996/06/01]
\ProvidesClass{nle}[2004/05/20 v1.0 Natural Language Engineering (NLE) document class]
%
%  Journals use two-sided printing.
%

\newif\ifprodtf
\newif\ifbookr@v

\DeclareOption{oneside}{\relax}
\DeclareOption{twoside}{\@twosidetrue \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5\p@}}
\DeclareOption{final}{\setlength\overfullrule{\z@}}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\relax}
\DeclareOption{titlepage}{\relax}
\DeclareOption{notitlepage}{\relax}
\DeclareOption{leqno}{\relax}
\DeclareOption{fleqn}{\relax}
\DeclareOption{prodtf}{\prodtftrue}
\DeclareOption{nlebkrev}{\bookr@vtrue}

\ExecuteOptions{twoside,final,onecolumn}
\ProcessOptions\relax

\AtBeginDocument{% overriding \@ifstar defn. of amsgen
	\@ifpackageloaded{amsgen}
		{\def\@ifstar#1{\@ifnextchar *{\@firstoftwo{#1}}}}
		{}
}
%  ****************************************
%  *               FONTS                  *
%  ****************************************

\newif\ifCUPmtlplainloaded
\ifprodtf 
	\CUPmtlplainloadedtrue
	\RequirePackage{CUPTimes,nle2esym}
\fi

\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{1}

\def\@xiiipt{13}
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiiipt
   \abovedisplayskip 6.5\p@ \@plus 1\p@ \@minus 1\p@
   \abovedisplayshortskip 3\p@ \@plus 1\p@
   \belowdisplayshortskip \abovedisplayshortskip
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI
}

\normalsize

\newcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 6\p@ \@plus 1\p@ \@minus 1\p@
   \abovedisplayshortskip 3\p@ \@plus 1\p@
   \belowdisplayshortskip \abovedisplayshortskip%
   \belowdisplayskip \abovedisplayskip
   \def\@listi{\leftmargin\leftmargini
   \topsep 6\p@ \@plus 1\p@ \@minus 1\p@
   \parsep \z@
   \itemsep \parsep}
}

\newcommand\footnotesize{%
   \@setfontsize\footnotesize\@ixpt{9}%
   \abovedisplayskip 5\p@ \@plus 1\p@ \@minus 1\p@
   \abovedisplayshortskip \z@ \@plus 1\p@
   \belowdisplayshortskip \abovedisplayshortskip%
   \belowdisplayskip \abovedisplayskip
   \def\@listi{\leftmargin\leftmargini
   \topsep 4.5\p@ \@plus 1\p@ \@minus 1\p@
   \parsep \z@
   \itemsep \parsep}
}

\newcommand\affilsize{\@setfontsize\affilsize\@viiipt\@xpt}
\newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\newcommand\authorsize{\@setfontsize\authorsize\@xipt\@xiiipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}
\newcommand\Large{\@setfontsize\Large\@xivpt{18}}
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{21}}
\newcommand\huge{\@setfontsize\huge\@xxpt{25}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

%  ****************************************
%  *            PAGE LAYOUT               *
%  ****************************************
%
% SIDE MARGINS:
\setlength\oddsidemargin  {2pc}
\setlength\evensidemargin {2pc}
\setlength\marginparwidth {2.0cm}
\setlength\marginparsep   {10\p@}

% VERTICAL SPACING:
\setlength\topmargin {2.5pc}
\setlength\headheight{13\p@}
\setlength\headsep   {11\p@}
\setlength\topskip	 {13\p@}
\setlength\footskip  {26\p@}

% DIMENSION OF TEXT:
\setlength\textheight   {44\baselineskip}
\addtolength\textheight {\topskip}
\setlength\textwidth    {30pc}
\setlength\columnsep    {10\p@}
\setlength\columnseprule{\z@}

% FOOTNOTES:
\setlength\footnotesep   {\z@}
\setlength{\skip\footins}{19.5\p@ \@plus 12\p@ \@minus1\p@}

% FLOATS:
\setlength\floatsep    {13\p@ \@plus 6.5\p@ \@minus 1\p@}
\setlength\textfloatsep{15\p@ \@plus 4.5\p@ \@minus 3\p@}
\setlength\intextsep   {13\p@ \@plus 6.5\p@ \@minus 2\p@}
\setlength\dblfloatsep    {13\p@ \@plus 6.5\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{15\p@ \@plus 4.5\p@ \@minus 3\p@}
\setlength\@fptop{\z@ \@plus 0fil}
\setlength\@fpsep{13\p@ \@plus 0fil}
\setlength\@fpbot{\z@ \@plus 3fil}
\setlength\@dblfptop{\z@ \@plus 0fil}
\setlength\@dblfpsep{13\p@ \@plus 0fil}
\setlength\@dblfpbot{\z@ \@plus 3fil}
\setlength\marginparpush{5\p@}

%  ****************************************
%  *           PARAGRAPHING               *
%  ****************************************
%

\setlength\parskip{\z@ \@plus .3\p@}
\setlength\parindent{1em}
\setlength\partopsep{\z@ \@plus 1\p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\clubpenalty\z@
\widowpenalty\@M

%  ****************************************
%  *                 PARTS                *
%  ****************************************
%
\newcommand\partname{Part}
\def\part{\par \addvspace{4ex}\@afterindentfalse
 \secdef\@part\@spart}
\def\@part[#1]#2{\ifnum \c@secnumdepth >\m@ne
  \refstepcounter{part}
  \addcontentsline{toc}{part}{\partname \thepart: #1}
 \else \addcontentsline{toc}{part}{#1}
 \fi
 {\parindent\z@ \centering
  \ifnum \c@secnumdepth >\m@ne
   \large\rmfamily \MakeUppercase{\partname}\ %
   \ifcase\thepart \or ONE \or TWO \or THREE \or FOUR \or FIVE
    \or SIX \or SEVEN \or EIGHT \or NINE \or TEN \else \fi
   \par \nobreak
  \fi
  \LARGE \rmfamily #2 \markboth{}{}\par}%
 \nobreak \vskip 3ex \@afterheading
}
\def\@spart#1{{\parindent\z@ \centering
  \LARGE \rmfamily #1\par}
 \nobreak \vskip 3ex \@afterheading
}

%  ****************************************
%  *               SECTIONS               *
%  ****************************************
%
\newcommand\section{%
  \@startsection{section}{1}{\z@}
	{-19.5\p@ \@plus -6.5\p@ \@minus -3.25\p@}
	{6.5\p@ \@plus\z@ \@minus1\p@}
	{\centering\normalsize\bfseries}
}
\newcommand\subsection{%
  \@startsection{subsection}{2}{\z@}
	{-19.5\p@ \@plus -3.25\p@ \@minus -3.25\p@}
	{6.5\p@ \@plus\z@ \@minus1\p@}
	{\centering\normalsize\bfseries\itshape}
}
\newcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}
	{-19.5\p@ \@plus -3.25\p@ \@minus -3.25\p@}
	{6.5\p@ \@plus\z@ \@minus1\p@}
	{\centering\normalsize\itshape}
}
\newcommand\paragraph{%
  \@startsection{paragraph}{4}{\z@}
	{-13\p@ \@plus -1.5\p@ \@minus -1.5\p@}
	{-0.5em}
	{\raggedright\normalsize\itshape}
}
\newcommand\subparagraph{%
  \@startsection{subparagraph}{4}{\parindent}
	{-13\p@ \@plus -3.25\p@ \@minus -3.25\p@}
	{-0.5em}
	{\raggedright\normalsize\rmfamily}
}

\setcounter{secnumdepth}{3}

\def\@seccntformat#1{\csname the#1\endcsname\enskip}

\newcommand\appendix{\par
 \setcounter{section}{0}
 \setcounter{subsection}{0}
 \renewcommand\thesection{\@Alph\c@section}
}

\setcounter{secnumdepth}{3}

%  ****************************************
%  *       PARTS & SECTIONS NUMBERS       *
%  ****************************************
%
\newcounter{part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thepart          {\@arabic\c@part}
\renewcommand\thesection       {\@arabic\c@section}
\renewcommand\thesubsection    {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection {\thesubsection.\@arabic\c@subsubsection}
\renewcommand\theparagraph     {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph  {\theparagraph.\@arabic\c@subparagraph}

%  ****************************************
%  *               SKIPS                  *
%  ****************************************
%
\newskip\@indentskip
\newskip\smallindent
\newskip\@footindent
\newskip\@leftskip
\setlength\@indentskip {2.5em}
\setlength\smallindent {1em}
\setlength\@footindent {\smallindent}
\setlength\@leftskip   {\z@}
\newcommand\ls{\kern.15em}
\newcommand\ns{\kern.4em}

%  ****************************************
%  *                LISTS                 *
%  ****************************************
%
\setlength\leftmargini  {\@indentskip}
\setlength\leftmarginii {1.5em}
\setlength\leftmarginiii{1.5em}
\setlength\leftmarginiv {1.5em}
\setlength\leftmarginv  {1em}
\setlength\leftmarginvi {1em}
\setlength\leftmargin	{\leftmargini}
\setlength\labelsep		{5\p@}
\setlength\labelwidth	{\leftmargini}
\addtolength\labelwidth	{-\labelsep}
%
% label macros for Range-Left and Range-Right labels
\def\makeRLlabel#1{\rlap{#1}\hss}
\def\makeRRlabel#1{\hss\llap{#1}}
%
\def\@listI{\leftmargin\leftmargini
	\parsep \z@
	\topsep 6.5\p@ \@plus 3\p@ \@minus 3\p@%
	\itemsep \z@ \@plus 1\p@ \@minus 1\p@
	\let\makelabel\makeRLlabel}
	\let\@listi\@listI
	\@listi
\def\@listii{\leftmargin\leftmarginii
	 \labelwidth\leftmarginii\advance\labelwidth-\labelsep
	 \topsep 3\p@ \@plus 1\p@ \@minus 1\p@
	 \parsep \z@
	 \itemsep \parsep
	 \let\makelabel\makeRLlabel}
\def\@listiii{\leftmargin\leftmarginiii
	 \labelwidth\leftmarginiii\advance\labelwidth-\labelsep
	 \topsep 3\p@ \@plus 1\p@ \@minus 1\p@
	 \parsep \z@
	 \partopsep \z@
	 \itemsep \topsep
	 \let\makelabel\makeRLlabel}
\def\@listiv{\leftmargin\leftmarginiv
	 \labelwidth\leftmarginiv\advance\labelwidth-\labelsep
	 \let\makelabel\makeRLlabel}
\def\@listv{\leftmargin\leftmarginv
	 \labelwidth\leftmarginv\advance\labelwidth-\labelsep
	 \let\makelabel\makeRLlabel}
\def\@listvi{\leftmargin\leftmarginvi
	 \labelwidth\leftmarginvi\advance\labelwidth-\labelsep
	 \let\makelabel\makeRLlabel}
%
% ITEMIZE
\def\itemize{%
	\ifnum \@itemdepth >3 \@toodeep
	\else 
	  \advance\@itemdepth \@ne
	  \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
	  \list{\csname\@itemitem\endcsname}%
		{\let\makelabel\makeRRlabel}%
	\fi
}

\newcommand\labelitemi{\m@th\ensuremath{\bullet}}
\newcommand\labelitemii{---}
\newcommand\labelitemiii{--}
\newcommand\labelitemiv{\m@th\ensuremath{\cdot}}

% ENUMERATE

\def\enumerate{\ifnum \@enumdepth >3 \@toodeep \else
  \advance\@enumdepth \@ne
  \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
 \fi
 \@ifnextchar [{\@enumeratetwo}{\@enumerateone}%
}
\def\@enumeratetwo[#1]{%
 \list{\csname label\@enumctr\endcsname}%
  {\settowidth\labelwidth{[#1]}
   \leftmargin\labelwidth \advance\leftmargin\labelsep
   \usecounter{\@enumctr}
   \let\makelabel\makeRRlabel}
}
\def\@enumerateone{%
 \list{\csname label\@enumctr\endcsname}%
  {\usecounter{\@enumctr}
   \let\makelabel\makeRRlabel}}
%
\newcommand\labelenumi{\theenumi}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii}
\newcommand\labelenumiv{\theenumiv}

\renewcommand\theenumi{\arabic{enumi}.}
\renewcommand\theenumii{\alph{enumii}}
\renewcommand\theenumiii{\roman{enumiii}}
\renewcommand\theenumiv{\Alph{enumiv}}

\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}


%
% DESCRIPTION
\newcommand\descriptionlabel[1]{\hspace\labelsep \bfseries #1}
\newenvironment{description}
	{\list{}{\labelwidth\z@ \itemindent-\leftmargin
	 \let\makelabel\descriptionlabel}}
	{\endlist}

%  ****************************************
%  *            DISPLAYED TEXT            *
%  ****************************************
%
% VERSE
\newenvironment{verse}
 {\let\\=\@centercr
  \list{}{\itemsep\z@
  \itemindent -\@indentskip
  \listparindent \itemindent
  \rightmargin\leftmargin
  \advance\leftmargin \@indentskip}\item[]}
 {\endlist}
%
% QUOTATION
\newenvironment{quotation}
 {\list{}{\listparindent \smallindent
  \itemindent\listparindent
  \leftmargin\z@\rightmargin\leftmargin
  \parsep \z@ \@plus 1\p@}\item[]\small}
 {\endlist}
%
% QUOTE
\newenvironment{quote}
	{\list{}{\leftmargin\z@\rightmargin\leftmargin\itemindent\parindent}\item[]\small}
	{\endlist}

%  ****************************************
%  *         OTHER ENVIRONMENTS           *
%  ****************************************
%
% THEOREM
\def\@begintheorem#1#2{\rmfamily \trivlist
  \item[\hskip \labelsep{\itshape #1\ #2}]\item[]}
\def\@opargbegintheorem#1#2#3{\rmfamily \trivlist
  \item[\hskip \labelsep{\itshape #1\ #2\ (#3)}]\item[]}
\def\@endtheorem{\endtrivlist}
%
% PROOF
\newsavebox{\proofbox}
\sbox{\proofbox}{\unitlength 1\p@\begin{picture}(7,7)%
  \put(0,0){\framebox(7,7){}}\end{picture}}
\def\proof{\rmfamily \trivlist
  \item[\hskip \labelsep {\itshape Proof\ }]\item[]}
\def\endproof{\hspace*{1em}\usebox{\proofbox}\endtrivlist}
\@namedef{proof*}{\rmfamily \trivlist
  \item[\hskip \labelsep{\hspace*{1em}\itshape Proof\ }]\item[]}
\@namedef{endproof*}{\endtrivlist}

% EQUATION and EQNARRAY

\def\@eqnnum{\hbox to .01\p@{}\rlap{\reset@font\rmfamily
        \hskip -\displaywidth(\theequation)}}

% TITLEPAGE
\newenvironment{titlepage}
	{\@restonecolfalse%
	 \if@twocolumn\@restonecoltrue%
		\onecolumn%
	 \else%
		\newpage% 
	 \fi%
	 \thispagestyle{empty}\c@page\z@}
	{\if@restonecol\twocolumn \else \newpage \fi}

\setlength\arraycolsep    {5\p@}
\setlength\tabcolsep      {3\p@}
\setlength\arrayrulewidth {.5\p@}
\setlength\doublerulesep  {1.5\p@}
\setlength\tabbingsep     {\labelsep}
\setlength{\skip\@mpfootins}{\skip\footins}
\setlength\fboxsep       {3\p@}
\setlength\fboxrule      {.5\p@}

%  ****************************************
%  *         TITLE AND ABSTRACT           *
%  ****************************************
%

% thanks to be a dagger, the rest of the footnotes to be numbered
\def\myfnsymbol#1{\@myfnsymbol{\@nameuse{c@#1}}}

\def\@myfnsymbol#1{\ifcase#1\or \dagger\or \ddagger\or
 \S \or \P \or \|\or **\or \dagger\dagger \or
 \ddagger\ddagger\or \S\S\or \P\P\or \|\|\else ***\fi\relax}

\newcommand\maketitle{\par
 \begingroup
  \def\thefootnote{\myfnsymbol{footnote}}
  \def\@makefnmark{\hbox to 0\p@{${\myfnsymbol{footnote}}$\hss}}%
  \newpage \global\@topnum\z@
  \@maketitle \thispagestyle{titlepage}\@thanks
 \endgroup
 \setcounter{footnote}{0}
 \let\maketitle\relax \let\@maketitle\relax
 \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax}

\renewcommand\and{\end{author@tabular}\vskip 6\p@\par
 \begin{author@tabular}[t]{@{}c@{}}}

\def\@maketitle{%
  \newpage
  \vspace*{-15\p@}%
  {\centering \sloppy
    \vspace*{32\p@}%
    {\LARGE \itshape \@title \par}
    \vskip 16\p@%
    {\normalsize
      \begin{author@tabular}[t]{@{}c@{}}\@author
      \end{author@tabular}\par
    }%
    \vskip 10\p@%
    {({\small\itshape Received \@received\/ })}\par
  }
  \vskip 18\p@%
}

% \abstractheader makes the heading for the abstract, including the
% horizontal rule if necessary
\def \abstractheader#1{\vbox{\hrule width \hsize
	\vskip 8\p@ \@plus 3\p@ \@minus 1\p@
	\centerline{\normalsize\bfseries  #1}}}

% now we define \abstract, using the abstractheader stuff.
% \endabstract redefines \abstractheader, this time without the
% horizontal rule -- so we avoid duplication of horizontal rules.
\newenvironment{abstract}
	{\abstractheader {Abstract}%
	 \list{}{\leftmargin\z@\rightmargin\z@ \listparindent 1em
	 \parsep \z@ \@plus 1\p@ \topsep 6.5\p@ \@plus 3\p@ \@minus 1\p@}
	 \item[]\small}
	{\endlist\vbox{\hrule width \hsize}
                 \gdef \abstractheader ##1{\vskip 2\p@
                          \centerline{\normalsize\bfseries  ##1}}}

% the definition of capsule review is exactly the same as abstract ...

\newenvironment{capsule}
	{\abstractheader {Capsule Review}
	 \list{}{\leftmargin\z@\rightmargin\z@ \listparindent 1em
	 \parsep \z@ \@plus 1\p@ \topsep 6.5\p@ \@plus 3\p@ \@minus 1\p@}
	 \item[]\small}
	{\endlist\vbox{\hrule width \hsize}
                 \gdef \abstractheader ##1{\vskip 2\p@
                          \centerline{\normalsize\bfseries  ##1}}}

\def\author@tabular{\authorsize\def\@halignto{}\@authortable}
\let\endauthor@tabular=\endtabular
\def\author@tabcrone{{\ifnum0=`}\fi\@xtabularcr\affilsize\itshape
 \let\\=\author@tabcrtwo\ignorespaces}
\def\author@tabcrtwo{{\ifnum0=`}\fi\@xtabularcr[-3\p@]\affilsize\itshape
 \let\\=\author@tabcrtwo\ignorespaces}
\def\@authortable{\leavevmode \hbox \bgroup $\let\@acol\@tabacol
 \let\@classz\@tabclassz \let\@classiv\@tabclassiv
 \let\\=\author@tabcrone \ignorespaces \@tabarray}

%  ****************************************
%  *            PAGE STYLES               *
%  ****************************************
%
\mark{{}{}}
\gdef\@author{\mbox{}}
\renewcommand\author{\@ifnextchar [{\@authortwo}{\@authorone}}
\def\@authortwo[#1]#2{\gdef\@author{#2}\gdef\@shortauthor{#1}}
\def\@authorone#1{\gdef\@author{#1}\gdef\@shortauthor{#1}}
\newcommand\shortauthor[1]{\gdef\@shortauthor{#1}}
\gdef\@shortauthor{}
\gdef\@title{\mbox{}}
\renewcommand\title{\@ifnextchar [{\@titletwo}{\@titleone}}
\def\@titletwo[#1]#2{\gdef\@title{#2}\gdef\@shorttitle{#1}}
\def\@titleone#1{\gdef\@title{#1}\gdef\@shorttitle{#1}}
\newcommand\shorttitle[1]{\gdef\@shorttitle{#1}}
\gdef\@shorttitle{}

\newcommand\volume[1]{\gdef\@volume{#1}}
  \gdef\@volume{{\bf 1} (1):}
\newcommand\pagerange[1]{\gdef\@pagerange{#1}}
  \gdef\@pagerange{000--000}
\newcommand\pubyear[1]{\gdef\@pubyear{#1}}
  \gdef\@pubyear{1998}
\newcommand\journal[1]{\gdef\@journal{#1}}
  \gdef\@journal{{\it Natural Language Engineering\/}}
\newcommand\received[1]{\gdef\@received{#1}}
  \gdef\@received{\today}
%
% \ps@empty and \ps@plain defined in LATEX.TEX
%
\def\ps@headings{\let\@mkboth\markboth
	 \let\@oddfoot\@empty
	 \let\@evenfoot\@oddfoot
	 \def\@oddhead{\hfil\itshape\@shorttitle\hfil\llap{\rm\thepage}}%
	 \def\@evenhead{\rlap{\rm\thepage}\hfil\itshape\@shortauthor\hfil}%
	 \def\sectionmark##1{\markboth{##1}{}}%
	 \def\subsectionmark##1{\markright{##1}}%
}

\def\ps@myheadings{\let\@mkboth\@gobbletwo
	 \let\@oddfoot\@empty
	 \let\@evenfoot\@oddfoot
	 \def\@oddhead{\hfil\itshape\rightmark\hfil\llap{\rmfamily\thepage}}%
	 \def\@evenhead{\rlap{\rmfamily\thepage}\hfil\itshape\leftmark\hfil}%
	 \let\sectionmark\@gobble
	 \let\subsectionmark\@gobble
}

\def\@j@urnal{%
  \vbox to 5.6pt{\noindent\parbox[t]{4.5in}{\affilsize\@journal\ \@volume\ %
  \@pagerange.\quad Printed in the United Kingdom\\[2.5\p@]
    \copyright\ \@pubyear\ Cambridge University Press}%
  \vss}%
}

\def\ps@titlepage{\let\@mkboth\@gobbletwo
	 \def\@oddhead{\@j@urnal \hfill \normalsize\llap{\thepage}}%
	 \let\@evenhead\@oddhead
	 \let\@oddfoot\@empty
	 \let\@evenfoot\@empty
	 \let\sectionmark\@gobble
	 \let\subsectionmark\@gobble
}

%  ****************************************
%  *         TABLE OF CONTENTS, ETC.      *
%  ****************************************
%
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg {2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{2}

\def\@undottedtocline#1#2#3#4#5{\ifnum #1>\c@tocdepth
 \else
  \vskip \z@ \@plus .2\p@
  {\hangindent #2\relax
   \rightskip \@tocrmarg \parfillskip -\rightskip
   \parindent #2\relax \@afterindenttrue
   \interlinepenalty\@M \leavevmode
   \@tempdima #3\relax #4\nobreak \hfill \nobreak
   \hbox to\@pnumwidth{\hfil\rm #5}\par}\fi}

\newcommand\contentsname{Contents}
\newcommand\tableofcontents{%
	 \section*{\contentsname}
	 \@starttoc{toc}
	 \par\vspace{13\p@}}

\newcommand*\l@part[2]{\addpenalty{-\@highpenalty}
 \addvspace{2.25em \@plus 1\p@}
 \begingroup
  \parindent \z@ \rightskip \@pnumwidth
  \parfillskip -\@pnumwidth
  {\normalsize\rmfamily
   \leavevmode \hspace*{3pc}
   #1\hfil \hbox to\@pnumwidth{\hss \ }}\par
   \nobreak \global\@nobreaktrue
   \everypar{\global\@nobreakfalse\everypar{}}\endgroup}

\newcommand*\l@section[2]{\addpenalty{\@secpenalty}
 \@tempdima 1.5em
 \begingroup
  \parindent \z@ \rightskip \@pnumwidth
  \parfillskip -\@pnumwidth \rmfamily \leavevmode
  \advance\leftskip\@tempdima \hskip -\leftskip
  {\bfseries #1}\nobreak\hfil \nobreak\hbox to\@pnumwidth{\hss #2}\par
 \endgroup}

\newcommand*\l@subsection{\@undottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@undottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@undottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@undottedtocline{5}{10em}{5em}}

\newcommand\listoffigures{\@restonecolfalse
 \if@twocolumn\@restonecoltrue\onecolumn\fi
 \section*{List of Figures}%
 \@starttoc{lof} \if@restonecol\twocolumn\fi}

\newcommand*\l@figure{\@undottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{\@restonecolfalse
 \if@twocolumn\@restonecoltrue\onecolumn\fi
\section*{List of Tables}%
\@starttoc{lot} \if@restonecol\twocolumn\fi}
\let\l@table\l@figure

%  ****************************************
%  *             FOOTNOTES                *
%  ****************************************
%
\renewcommand\footnoterule{\kern-3\p@
 \hrule width .4\columnwidth height \z@ \kern 3\p@}

\long\def\@makefntext#1{\@setpar{\@@par\@tempdima \hsize
 \advance\@tempdima-\@footindent
 \parshape \@ne \@footindent \@tempdima}\par
 \noindent \hbox to \z@{\hss${\@thefnmark}$\ }#1}

\def\@fnsymbol#1{%
  {^{\@arabic{#1}}\relax}
}

\def\@makefnmark{\hbox{$\@thefnmark$}}
\def\thempfootnote{^\alph{mpfootnote}}

%  ****************************************
%  *         FIGURES AND TABLES           *
%  ****************************************
%
\setcounter{topnumber}{2}
\renewcommand\topfraction{.9}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.9}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.1}
\renewcommand\floatpagefraction{.95}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.9}
\renewcommand\dblfloatpagefraction{.5}

\long\def\@makecaption#1#2{\vskip 6.5\p@%
  \begingroup
  \ifintable \baselineskip 13\p@\fi
  \setbox\@tempboxa\hbox{#1.\ #2}%
  \ifdim \wd\@tempboxa >2\hsize
    \unhbox\@tempboxa\par
  \else
    {\centering\unhbox\@tempboxa\par}%
  \fi
  \endgroup
  \global\intablefalse
}

\newif\ifintable
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{1}
\def\ext@table{lot}
\def\fnum@table{Table \thetable}
\newenvironment{table}
	{\global\intabletrue\@float{table}}
	{\end@float}
\newenvironment{table*}
	{\@dblfloat{table}}
	{\end@dblfloat}

\def\fstyle@table{\footnotesize\rmfamily}
\def\fjust@table{\centering}
\def\fcapjust@table{\centering}
\def\fcapsize@table{\normalsize\rmfamily}
\def\fcapstyle@table{\normalsize\itshape}

\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{2}
\def\ext@figure{lof}
\def\fnum@figure{Fig.\ \thefigure}
\newenvironment{figure}
	{\@float{figure}}
	{\end@float}
\newenvironment{figure*}
	{\@dblfloat{figure}}
	{\end@dblfloat}

\def\fstyle@figure{\small\rmfamily}
\def\fjust@figure{\centering}
\def\fcapjust@figure{\centering}
\def\fcapsize@figure{\small\rmfamily}
\def\fcapstyle@figure{\small\rmfamily}
\newif\ifwide@float
\wide@floatfalse

\long\def\@caption#1[#2]#3{%
 \addcontentsline{\csname ext@#1\endcsname}{#1}%
 {\protect\numberline{\csname the#1\endcsname}%
  {\ignorespaces #2}}\par
 \begingroup
  \ifwide@float\@parboxrestore\else\@myparboxrestore\fi
  \@makecaption{\csname fcapjust@#1\endcsname
   \csname fcapsize@#1\endcsname
   \csname fnum@#1\endcsname}%
   {\csname fcapstyle@#1\endcsname \ignorespaces #3}\par
 \endgroup}
\def\@xfloat #1[#2]{%
  \@nodocument
  \def \@captype {#1}%
   \def \@fps {#2}%
   \@onelevel@sanitize \@fps
   \def \reserved@b {!}%
   \ifx \reserved@b \@fps
     \@fpsadddefault
   \else
     \ifx \@fps \@empty
       \@fpsadddefault
     \fi
   \fi
   \ifhmode
     \@bsphack
     \@floatpenalty -\@Mii
   \else
     \@floatpenalty-\@Miii
   \fi
  \ifinner
     \@parmoderr\@floatpenalty\z@
  \else
    \@next\@currbox\@freelist
      {%
       \@tempcnta \sixt@@n
       \expandafter \@tfor \expandafter \reserved@a
         \expandafter :\expandafter =\@fps
         \do
          {%
           \if \reserved@a h%
             \ifodd \@tempcnta
             \else
               \advance \@tempcnta \@ne
             \fi
           \fi
           \if \reserved@a t%
             \@setfpsbit \tw@
           \fi
           \if \reserved@a b%
             \@setfpsbit 4%
           \fi
           \if \reserved@a p%
             \@setfpsbit 8%
           \fi
           \if \reserved@a !%
             \ifnum \@tempcnta>15
               \advance\@tempcnta -\sixt@@n\relax
             \fi
           \fi
           }%
       \@tempcntb \csname ftype@\@captype \endcsname
       \multiply \@tempcntb \@xxxii
       \advance \@tempcnta \@tempcntb
       \global \count\@currbox \@tempcnta
       }%
    \@fltovf
  \fi
  \global \setbox\@currbox
    \color@vbox
      \normalcolor
      \vbox \bgroup
	    \csname fstyle@#1\endcsname
        \hsize\columnwidth
		\ifwide@float \hsize\textwidth \linewidth\textwidth \@parboxrestore
		\else \hsize\columnwidth \addtolength{\hsize}{\z@} \@rightskip \z@\@myparboxrestore
		\fi \csname fjust@#1\endcsname
        \@floatboxreset
}
\def\@myparboxrestore{\@myarrayparboxrestore\let\\\@normalcr}

\def\@myarrayparboxrestore{%
  \let\if@nobreak\iffalse
  \let\if@noskipsec\iffalse
  \let\par\@@par
  \let\-\@dischyph
  \let\'\@acci\let\`\@accii\let\=\@acciii
  \parindent\z@ \parskip\z@skip
  \everypar{}%
  \linewidth\hsize
  \@totalleftmargin\z@
  \leftskip\z@skip \rightskip\z@skip \@rightskip\z@skip
  \parfillskip\@flushglue \lineskip\normallineskip
  \baselineskip\normalbaselineskip
  \sloppy}

\def\@dblfloat{\wide@floattrue%
  \if@twocolumn\let\reserved@a\@dbflt\else\let\reserved@a\@float\fi
  \reserved@a}
\def\end@dblfloat{%
\if@twocolumn
  \@endfloatbox
  \ifnum\@floatpenalty <\z@
    \@largefloatcheck
    \@cons\@dbldeferlist\@currbox
  \fi
    \ifnum \@floatpenalty =-\@Mii \@Esphack\fi
\else
  \end@float
\fi\wide@floatfalse
}

%this is to preserve the old tabular environment in case it is needed
\let \oldtabular \tabular
\let \endoldtabular \endtabular

\def\tabular{\def\@halignto{to \textwidth}\tabskip=\tabcolsep \@plus 1fil\@tabular}
% this fixes tabular things so that they are full out l and r;
% the \tabskip setting is to put tabskip before the first column.

% the following is to adjust the intercolumn spacing to put in
% enough stretch.
\def\@tabarray{\@ifnextchar[{\@tarray}{\@ttarray}}
\def\@tarray[#1]#2{\t@barray[#1]{@{\tabskip=2\tabcolsep \@plus 3\p@}
                                #2}}
\def\@ttarray#1{\t@barray[c]{@{\tabskip=2\tabcolsep \@plus 3\p@}
                                #1 }}

\def\t@barray[#1]#2{\setbox\@arstrutbox=\hbox{\vrule
     height\arraystretch \ht\strutbox
     depth\arraystretch \dp\strutbox
     width\z@}\@mkpream{#2}\edef\@preamble{\halign \noexpand\@halignto
\bgroup \tabskip\z@ \@arstrut \@preamble \tabskip=\tabcolsep \@plus 1fil \cr}%
\let\@startpbox\@@startpbox \let\@endpbox\@@endpbox
  \if #1t\vtop \else \if#1b\vbox \else \vcenter \fi\fi
  \bgroup \let\par\relax
  \let\@sharp##\let\protect\relax \lineskip\z@\baselineskip\z@\@preamble}

%  ****************************************
%  *           CUP specials               *
%  ****************************************
%
\newcommand\today{}
\edef\today{\number\day\ \ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December
 \fi\space \number\year}

\renewcommand{\thefootnote}{\mbox{$\fnsymbol{footnote}$}}
\def\hline{\noalign{\ifnum0=`}\fi \vskip 6\p@
 \hrule \@height \arrayrulewidth \vskip 6\p@
 \futurelet \@tempa\@xhline}
\def\@xhline{\ifx\@tempa\hline \vskip -12\p@
 \vskip \doublerulesep \fi \ifnum0=`{\fi}}

\newcommand\hpt{\hbox{$\cdot$}}

%  ****************************************
%  *             SPREADOUT                *
%  ****************************************
%
\def\spreadoutfactor{1.5}
\def\endmark{}
\newcommand\spreadoutnum[1]{%
	\edef\temp{#1}\dimen0 = \spreadoutfactor pt
	\expandafter\dospreadout\temp\endmark}
\newcommand\spreadout[1]{%
	\gdef\temp{#1}\dimen0 = \spreadoutfactor pt
	\expandafter\dospreadout\temp\endmark\kern-\dimen0}
\def\dospreadout{%
	\afterassignment\findospreadout
	\let\next= }
%
\def\findospreadout{%
	\ifx\next\endmark
		\let\nextaction = \relax
	\else
		\let\nextaction = \dospreadout
		\next
		\kern\dimen0
	\fi
	\nextaction}

%  ****************************************
%  *           BIBLIOGRAPHY               *
%  ****************************************

\renewcommand\@biblabel[1]{#1}
\newenvironment{thebibliography}[1]{%
	\section*{References}%
	\addcontentsline{toc}{section}{References}
	\list{}{\labelwidth\z@ \leftmargin 1em \itemindent -1em}
	\small \parindent\z@
	\parskip\z@ \@plus .1\p@\relax
	\def\newblock{\hskip .11em \@plus .33em \@minus .07em}
	\sloppy\clubpenalty\z@ \widowpenalty\@M
	\sfcode`\.\@m\relax}
	{\endlist}

%  The following code is taken from authordate.sty, by  David Rhead, of
%  the Cripps Computing Centre (February 1990), with some modifications.
%  It is intended for documents
%  that use the author-date citation system.  When used in conjunction with
%  authordate1.bst, ... , authordate4.bst, it allows citations of the
%  form \shortcite{bloggs-60} as well as the usual \cite{bloggs-60}.
%  When
%       ... \cite{bloggs-60} ... \shortcite{bloggs-60} ...
%  appears in the input file,
%       ... (Bloggs, 1960) ... (1960) ...
%  appears in the final document.
%
%  Code taken from apalike.sty.
%
\newif\if@altcite
\def\@cite#1#2{\if@altcite #2\else (#1)\fi\global\@altcitefalse}
\def\@biblabel#1{}

% Set length of hanging indentation for bibliography entries
%
\newlength{\bibhang}
\setlength{\bibhang}{2em}

%  Define default title and page-head text.
%
\def\bibtitle{References}
\def\bibheadtitle{REFERENCES}

%  Code taken from aaai.sty.
%
% don't box citations, add space between multiple citations, separate with ;
\def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
  \def\@citea{}\@cite{\@for\@citeb:=#2\do
    {\@citea\def\@citea{; }\@ifundefined
       {b@\@citeb}{{\bf ?}\@warning
       {Citation `\@citeb' on page \thepage \space undefined}}%
{\csname b@\@citeb\endcsname}}}{#1}}

\def\cite{\@ifnextchar [{\@tempswatrue\global\@altcitetrue\@citex}
  {\@tempswafalse\global\@altcitefalse\@citex[]}%
}
% Allow short (name-less) citations, when used in
% conjunction with a bibliography style that creates labels like
%       \citename{<names>, }<year>
\let\@internalcite\cite
\def\cite{\def\citename##1{##1}\@internalcite}
\def\shortcite{\def\citename##1{}\@internalcite}

%  ****************************************
%  *           INITIALIZATION             *
%  ****************************************
%
\pagestyle{headings}
\pagenumbering{arabic}
\onecolumn \let\onecolumn=\relax
\flushbottom
\frenchspacing

\ifbookr@v
  \input nlebkrev.sty
\fi
\sloppy
\endinput

% End of nle.cls
