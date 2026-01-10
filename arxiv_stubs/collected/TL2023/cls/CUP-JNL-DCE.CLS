%%
%% This is file `CUP-JNL-DCE.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% classes.dtx  (with options: `CUP-JNL-DCE')
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
\ProvidesClass{CUP-JNL-DCE}
              [2019/10/08 v0.1: An authoring template for CUP DCE articles]

\newif\if@restonecol
\newif\if@titlepage   \@titlepagefalse
\newif\if@cropmarkson \@cropmarksonfalse

%% Template Options
\DeclareOption{a4paper}{\PassOptionsToPackage{a4}{crop}}
\DeclareOption{a3paper}{\PassOptionsToClass{a3paper}{article}\PassOptionsToPackage{a3}{crop}}
\DeclareOption{centre}{\PassOptionsToPackage{center}{crop}}
\DeclareOption{crop}{\PassOptionsToPackage{frame}{crop}\global\@cropmarksontrue}
\DeclareOption{nocrop}{\PassOptionsToPackage{off}{crop}\global\@cropmarksontrue}
\DeclareOption{info}{\PassOptionsToPackage{info}{crop}}
\DeclareOption{noinfo}{\PassOptionsToPackage{noinfo}{crop}}

%% Classfile Options
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{titlepage}{\@titlepagetrue}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{openbib}{\let\if@openbib\iftrue}

\ExecuteOptions{twosidecrop,crop,centre,info,croppage}
\ProcessOptions
\LoadClass[twoside,fleqn]{article}

%% General Packages Used
\RequirePackage{url}
\RequirePackage{soul}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Color Defs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% rgb colors
\AtBeginDocument{%
\@ifpackageloaded{xcolor}{%
\definecolor{gray}{cmyk}{0,0,0,0.2}%
\definecolor{teal}{cmyk}{1,0,0,0.498}%
\definecolor{shadecolor}{gray}{.90}
}{}
}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fonts & Sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

\renewcommand\normalsize{%
   \@setfontsize\normalsize{10pt}{12pt}%
   \abovedisplayskip 12\p@ \@plus2\p@ \@minus0\p@
   \abovedisplayshortskip \z@ \@plus3\p@%
   \belowdisplayshortskip 3\p@ \@plus3\p@ \@minus3\p@%
   \belowdisplayskip \abovedisplayskip%
   \let\@listi\@listI}%
\normalsize
\newcommand\medsize{%
   \@setfontsize\small\@xipt{13}%
   \abovedisplayskip 5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 3\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip}
\renewcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 3\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip}
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize{7}{8}%
   \abovedisplayskip 5\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip}
%
\renewcommand\scriptsize{\@setfontsize\scriptsize\@ixpt\@ixpt}
\newcommand\scrisize{\@setfontsize\scrisize{9.3}{9}}
\renewcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\renewcommand\large{\@setfontsize\large{12}{14}}
\newcommand\larg{\@setfontsize\larg{11}{13}}
\renewcommand\Large{\@setfontsize\Large{16}{18}}
\renewcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\renewcommand\huge{\@setfontsize\huge\@xxpt{25}}
\renewcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
%
\DeclareMathSizes{\@ixpt}{\@ixpt}{7}{5}
\DeclareMathSizes{\@xpt}{\@xpt}{7}{5}
\DeclareMathSizes{\@xipt}{\@xipt}{7}{5}

\DeclareRobustCommand*\textsubscript[1]{%
  \@textsubscript{\selectfont#1}}%
\def\@textsubscript#1{%
  {\m@th\ensuremath{_{\mbox{\fontsize\sf@size\z@#1}}}}}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Layout Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\RequirePackage{geometry}

%% Regular Pages (for Opening page - redefined)
\geometry{%
    paperwidth=174mm,
    paperheight=247mm,
    top={57pt},
    headheight={7pt},
    headsep={19.5pt},
    textwidth={144mm},
    textheight={612.5pt},
    marginparsep=3mm,
    marginparwidth=10mm,
    bindingoffset=6mm,
    footskip=0mm}
%

\setlength{\marginparsep}{3mm}%
\setlength{\marginparwidth}{10mm}%

\setlength\footskip{0\p@}
\setlength\maxdepth{0pt}

\setlength\footnotesep{5.75\p@}
\setlength{\skip\footins}{8\p@ \@plus 4\p@ \@minus 0\p@}

\setlength\parindent{12pt}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pagination Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Line spacing
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\parskip=0pt

% Page break penalties
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301

% Disallow widows and orphans
\clubpenalty 10000
\widowpenalty 10000

% Disable page breaks before equations, allow pagebreaks after
% equations and discourage widow lines before equations.
\displaywidowpenalty 100
\predisplaypenalty   10000
\postdisplaypenalty  0

% Set these global demerits
\doublehyphendemerits 1000000   % corresponds to badness 800
\finalhyphendemerits  1000000  % corresponds to badness 1000

% Allow loose lines rather than overfull lines
\vbadness=9999
\tolerance=9999

% Allow breaking the page in the middle of a paragraph
\interlinepenalty 0

% Disallow breaking the page after a hyphenated line
\brokenpenalty 10000

% Hyphenation; don't split words into less than three characters
\lefthyphenmin=3
\righthyphenmin=3

% Float placement parameters

% The total number of floats that can be allowed on a page.
\setcounter{totalnumber}{10}

% The maximum number of floats at the top and bottom of a page.
\setcounter{topnumber}{5}
\setcounter{bottomnumber}{5}

% The maximum part of the top or bottom of a text page that can be
% occupied by floats. This is set so that at least four lines of text
% fit on the page.
\renewcommand\topfraction{.921}
\renewcommand\bottomfraction{.921}

% The minimum amount of a text page that must be occupied by text.
% This should accomodate four lines of text.
\renewcommand\textfraction{.13}

% The minimum amount of a float page that must be occupied by floats.
\renewcommand\floatpagefraction{.887}

% The same parameters repeated for double column output
\renewcommand\dbltopfraction{.88}
\renewcommand\dblfloatpagefraction{.88}

% Space between floats
\setlength\floatsep    {18\p@ \@plus 2\p@ \@minus 2\p@}

% Space between floats and text
\setlength\textfloatsep{19\p@ \@plus 2\p@ \@minus 4\p@}

% Space above and below an inline figure
\setlength\intextsep   {18\p@ \@plus 2\p@ \@minus 2\p@}

% For double column floats
\setlength\dblfloatsep    {20\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{18\p@ \@plus 2\p@ \@minus 4\p@}

\hyphenation{Figure Figures Table Tables Equation Equations Section Sections Appendix Theorem Lemma}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Math Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% For above/below spacing
\def\eqnarray{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne\hskip \tw@\arraycolsep \hfil${##}$\hfil
      &\global\@eqcnt\tw@ \hskip \tw@\arraycolsep
         $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
         \tabskip\z@skip
      \cr
}
\def\endeqnarray{%
      \@@eqncr
      \egroup
      \global\advance\c@equation\m@ne
   $$\@ignoretrue
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Titles %%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\renewcommand\contentsname{Contents}
\renewcommand\listfigurename{List of Figures}
\renewcommand\listtablename{List of Tables}
\renewcommand\refname{References}
\renewcommand\indexname{Index}
\renewcommand\figurename{Figure}
\renewcommand\tablename{Table}
\renewcommand\partname{Part}
\renewcommand\appendixname{Appendix}
\renewcommand\abstractname{Abstract}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Article Front Matter %%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%% Article Type
\sodef\letterspacetwty{}{.1em}{.4em plus1em}{.5em plus 1em minus1em }
\def\articletype#1{\gdef\ArtType{\letterspacetwty{#1}}\gdef\@ArtType{#1}}%
\articletype{RESEARCH ARTICLE}%

%% Meta Info
\def\@artid{xx}
\def\@jname{xxx xxx}
\def\@jvol{xx}
\def\@jissue{xx}
\def\@jyear{{0000}}
\def\@jmonth{xx}
\def\@DOI{}
%
\def\artid#1{\gdef\@artid{#1}}
\def\jname#1{\markboth{\textit{#1}}{\textit{#1}}\gdef\@jname{#1}}
\def\jvol#1{\gdef\@jvol{#1}}
\def\jissue#1{\gdef\@jissue{#1}}
\def\jyear#1{\gdef\@jyear{#1}}
\def\jmonth#1{\gdef\@jmonth{#1}}
%\def\doi#1{\gdef\@DOI{doi:10.1017/xxxx}}
\def\jdoi#1{\gdef\@DOI{doi:#1}\gdef\@logourl{#1}}
\jdoi{10.1017/xxxx}
%

%%% Font Def
\def\Titlefont{\fontsize{16}{18}\fontseries{b}\selectfont}
\def\Artcatfont{\fontsize{8.5}{10.5}\fontseries{b}\selectfont}
\def\Authorfont{\fontsize{10}{12}\selectfont}
\def\addressfont{\fontsize{8}{10}\selectfont}
\def\abstractheadfont{\fontsize{9}{11}\fontseries{b}\selectfont}%
\def\abstractsubheadfont{\fontsize{9}{11}\fontseries{b}\selectfont}%
\def\abstractfont{\fontsize{9}{11}\selectfont}%
\def\keywordfont{\fontsize{8}{10}\selectfont}%
\def\historyfont{\fontsize{8}{10}\selectfont\raggedright}

%% Article Title
%\def\title#1{\gdef\@title{#1}}

\renewcommand{\title}[2][]{%
\gdef\@checktitle{#1}\ifx\@checktitle\empty\gdef\@title{#2}
\gdef\s@title{#2}\else\gdef\@title{#2}\gdef\s@title{#1}\fi}

%% Cross Link for Author & Address
\def\jmkLabel#1{\@bsphack\protected@write\@auxout{}{\string\Newlabel{#1}{\@currentlabel}}\@esphack}
\def\Newlabel#1#2{\expandafter\xdef\csname X@#1\endcsname{#2}}
\def\jmkRef#1{\@ifundefined{X@#1}{0}{\csname X@#1\endcsname}}

%% Article Author(s)
\let\sep\@empty%
\let\authorsep\@empty%
\newcount\aucount%
\newcount\punctcount%
\def\author{\advance\aucount by 1\@ifstar\@@corrauthor\@@author}%
\def\au@and{\ifnum\punctcount=2\ and\else\unskip,\advance\punctcount by -1 \fi}%
\def\artauthors{}
\newif\if@auemail%
\newcommand{\@@author}[2][]{\g@addto@macro\artauthors{%
    \ifnum\aucount=1%
    \global\@auemailtrue%
    \else%
    \global\@auemailfalse%
    \fi%
    \Authorfont%
    \def\baselinestretch{1}%
    \authorsep{#2}\unskip\ifx#1\empty\else\textsuperscript{\smash{{%
      \@for\@@affmark:=#1\do{\edef\affnum{\@ifundefined{X@\@@affmark}{1}{\jmkRef{\@@affmark}}}%
     \unskip\sep\affnum\let\sep=,}}}}\fi%
    \def\authorsep{\au@and~}%%%
    \global\let\sep\@empty\global\let\@corref\@empty%
}}%

\newcommand{\@@corrauthor}[2][]{\g@addto@macro\artauthors{%
    \global\@auemailtrue%
    \Authorfont%
    \def\baselinestretch{1}%
    \authorsep{#2}\unskip\ifx#1\empty\else\textsuperscript{\smash{{%
      \@for\@@affmark:=#1\do{\edef\affnum{\@ifundefined{X@\@@affmark}{1}{\jmkRef{\@@affmark}}}%
     \unskip\sep\affnum\let\sep=,}}}}\fi%
    \def\authorsep{\au@and~}%%%
    \global\let\sep\@empty\global\let\@corref\@empty%
}}%
%
\RequirePackage{ltxcmds}%
\def\authororcid#1{%
\ltx@ifpackageloaded{hyperref}{\href{https://orcid.org/#1}{\includegraphics{orcid_logo}}}{{\includegraphics{orcid_logo}}}%
}
\newcommand{\orcid}[1]{\protect\g@addto@macro\artauthors{%
\authororcid{#1}%
}}
%% Author Email
\newif\ifcorrauth
\def\addressrule{\kern-10\p@ \hrule \@height.15pt \@width\marginparwidth \kern 1.6\p@}%
\def\@email{}
\DeclareUrlCommand\myemail{}%
\def\email#1{\global\corrauthtrue\g@addto@macro\artauthors{\setcounter{footnote}{0}\if@auemail\ifnum\aucount>1\textsuperscript{*}\fi\protected@xdef\@email{\@email\ifx\@email\empty {\ifnum\aucount>1*\fi Corresponding author. E-mail: }\else; \fi \textcolor{teal}{\protect\myemail{#1}}}\fi}}%
\def\corremail{\protected@xdef\@corremail{%
      {{\@email\par}}%
        \par%
}%
\@corremail}

\let\nomail\relax


%% Corrseponding Address
\def\@copycorthanks{}
\def\auaddress{}
\def\@auaddress{}
\newcounter{affn}
\renewcommand\theaffn{\arabic{affn}}
\def\address{\@ifstar\@@coraddress\@@address}
\newcount\addcount% To check the count of address
\newcommand{\@@coraddress}[2][]{%\advance\addcount by 1
\g@addto@macro\auaddress{%
     \stepcounter{affn}%
     \xdef\@currentlabel{\theaffn}%
     \jmkLabel{\theaffn}%
     {\textsuperscript{#1}#2}\par}
}

%% Author Address
\def\addsep{\par\vskip0pt}
\newcount\addcount% To check the count of address
\newcommand{\@@address}[2][]{\advance\addcount by 1\g@addto@macro\auaddress{%
     \stepcounter{affn}%
     \xdef\@currentlabel{\theaffn}%
     \jmkLabel{\theaffn}%
     {\textsuperscript{#1}#2}\par}%\theaffn
}


%% Address tagging
\newcommand{\orgdiv}[1]{#1}%
\newcommand{\orgname}[1]{#1}%
\newcommand{\orgaddress}[1]{#1}%
\newcommand{\street}[1]{#1}
\newcommand{\postcode}[1]{#1}
\newcommand{\city}[1]{#1}
\newcommand{\state}[1]{#1}
\newcommand{\country}[1]{#1}

%% Author name in Running Head
\def\@authormark{}%
\def\authormark#1{\markright{{\textit{#1}}}\gdef\@authormark{\def\etal{{et al.}}#1}\gdef\@authormarkforcite{\def\etal{\textit{et al.}}#1}}%
\def\etal{\textit{et al.}}

%% Optional Text
\def\artnotefont{\reset@font\fontfamily{\sfdefault}\fontsize{8.6}{13}\selectfont\raggedright}
\def\artnote#1{\gdef\@Artnote{#1}}\artnote{}%

%% Article Abstract
\newcommand\abstracthead{\@startsection {section}{1}{\z@}{-22pt \@plus0ex \@minus0ex}{0.0001pt}{\abstractheadfont}}
\newcommand\subabstracthead{\@startsection{subsection}{2}{\z@}{3pt \@plus0ex \@minus0ex}{-.5em}{\abstractsubheadfont}}

\def\@abstract{}%
\long\def\abstract#1{\def\@abstract{%
\let\paragraph\subabstracthead%
\abstractfont%
\abstracthead*{\textcolor{teal}{\abstractname}}%
#1\par}}%

\def\printabstract{\ifx\@abstract\empty\else\@abstract\fi\par}%

\def\printkeywords{\ifx\@keywords\empty\else\@keywords\fi\par}%

%
%% Keywords
\def\keywordname{Keywords}
\def\keywords#1{\ifx#1\empty\else\def\@keywords{\par\addvspace{10pt}{\keywordfont\textbf{\keywordname:} #1\par}\fi}}
\def\@keywords{}


%% Article History

\def\received#1{\g@addto@macro\@history{{\textbf{Received:} #1}}}%
\def\revised#1{\g@addto@macro\@history{{; \textbf{Revised:} #1}}}%
\def\accepted#1{\g@addto@macro\@history{{; \textbf{Accepted:} #1}}}%

%% Policy Statement

\RequirePackage{framed}
\newbox\policybox
\def\policyfont{\fontsize{9}{11}\selectfont}
\newenvironment{policy}[1][Policy Significance Statement]{\global\setbox\policybox\vbox\bgroup\par\addvspace{26pt}\FrameSep=8pt\begin{shaded*}%
\policyfont\ifx#1\empty\else\vspace*{-2\baselineskip}\abstracthead*{\fontsize{9}{11}\selectfont#1}\vskip2pt\fi%
}{\end{shaded*}\par\addvspace{0pt}\egroup}

\def\printpolcy{\ifvoid\policybox\else\box\policybox\fi\par}%


%% Article Header Definition
\renewcommand{\@maketitle}
{\noindent{\vbox{%
    \hsize\textwidth\parindent0pt%
    \vskip7pt%
    %% Aritle Type
    {\hbox to \textwidth{{\Artcatfont\textcolor{teal}{\ArtType}\hfill}\par}}
    %% Aritle Title
    \ifx\@title\empty\else%
        \vskip37pt%
        {\Titlefont\textcolor{teal}{\@title}\par}
        %\addcontentsline{toc}{chapter}{\@title}% for bookmarks
    \fi%
    %% Aritle Authors, Address and Correspondings
    \ifnum\aucount>0
        \global\punctcount\aucount%
        \vskip10pt%
        \artauthors\par%%     authors and emails
        {\vskip7pt\addressfont\auaddress\par%%      corresponding adress
        \corremail\par}
     \fi%
     {\printhistory\par}%
     {\printkeywords\par}%
     {\printabstract\par}%
     {\printpolcy\par}%
    }}\par\addvspace{23pt plus0pt minus0pt}}

%% Printing Article Header
\renewcommand\maketitle{\par
  \@afterindentfalse%
  \begingroup
    \gdef\UrlFont{\rmfamily}%
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\smash{\@thefnmark}}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent\small\selectfont
            \hbox{\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne%
        \twocolumn[\@maketitle]%
      \else
        \twocolumn[\@maketitle]%
      \fi%
    \else%
      \newpage%
      \global\@topnum\z@% Prevents figures from going at top of page.
      \@maketitle%
    \fi%
    \thispagestyle{titlepage}%
  \endgroup%
  \global\advance\opshortpage23pt%
  \enlargethispage{-30pt}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax%
  \global\let\maketitle\relax%
  \global\let\@maketitle\relax%
  %\global\let\@thanks\@empty%
  \global\let\@author\@empty%
  \global\let\@date\@empty%
  %\global\let\@title\@empty%
  \global\let\title\relax%
  \global\let\author\relax%
  \global\let\date\relax%
  \global\let\and\relax
  %%%print continuous abstract on next page
  \@afterheading}%


\newenvironment{Frontmatter}{\par}{\maketitle\par}

\newenvironment{Backmatter}{\par\fontsize{8}{10}\selectfont
\def\sectionfont{\fontsize{10}{12}\fontseries{b}\selectfont\raggedright}
\def\paragraphfont{\fontsize{8}{10}\fontseries{b}\selectfont\raggedright\boldmath}
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-12pt \@plus 0ex \@minus 0ex}%
                                   {3pt}%
                                   {\sectionfont}}%
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {2.25ex \@plus1ex \@minus.2ex}%
                                    {-.5em}%
                                    {\paragraphfont}}
\def\bibfont{\fontsize{8}{10}\selectfont}%
}{\par}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Page Styles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\opheaderfont{\fontsize{7}{9}\selectfont}
\def\headerfont{\fontsize{10}{12}\selectfont}
\def\footerfont{\fontsize{7}{8}\selectfont}


%% Regular Page Style
\def\ps@headings{%
    \def\@oddfoot{\hfill}
    \let\@evenfoot\@oddfoot
      \def\@evenhead{{\headerfont \thepage\qquad\rightmark\hfill}}%
      \def\@oddhead{{\headerfont \hfill\leftmark\qquad\thepage}}%
      \let\@mkboth\markboth%
      }

\newdimen\opshortpage%

\def\printcopyright#1{#1}%%

\def\copytext#1{\def\@copyrighttext{\begin{minipage}[t]{\textwidth}\footerfont #1\end{minipage}}}
\copytext{\textcopyright\ The Authors(s), 2024. This is an Open Access article, distributed under the terms of the Creative Commons Attribution licence (\url{http://
creativecommons.org/licenses/by/4.0/}), which permits unrestricted re-use, distribution, and reproduction in any medium, provided the original work is
properly cited.
}%

\AtEndDocument{\label{LastPage}}
\def\@opjournalheader{\leftmark\space{{(\@jyear),}} {\thepage{--}\pageref*{LastPage}}\\
{\@DOI}}%

%% Opening Page Style
\def\ps@titlepage{%
     \def\@oddhead{{\hbox to \textwidth{%
      \vbox to 0pt{\vskip-5pt\rlap{\hbox to \textwidth{\hfill\includegraphics{DCE_logo_RGB}\quad\raisebox{3pt}{\includegraphics[scale=.75]{CUP_Logo}}\hspace*{-1pt}}}}%
      \vbox to 0pt{\vskip-7pt\rlap{\parbox{\textwidth}{\opheaderfont\begin{tabular*}{\textwidth}[b]{@{\extracolsep{\fill}}@{}l@{}}%
      \@opjournalheader%
      \end{tabular*}}}}%
      }}}%
     \let\@evenhead\@oddhead%
     \def\@oddfoot{\vbox to 0pt{\vskip-\opshortpage{\printcopyright{\@copyrighttext}}}}%%
     \let\@evenfoot\@oddfoot}%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sections %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\numbered{\setcounter{secnumdepth}{3}}
\def\unnumbered{\setcounter{secnumdepth}{0}}
\numbered%% default is unnumbered Sections

\newcounter {chapter}[part]% for bookmarks
\renewcommand\thepart         {\@Roman\c@part}
\renewcommand\thesection      {\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
%%
\renewcommand\part{\par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}
%%
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
       \Large\bfseries \partname~\thepart
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

\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #6{%
        \@hangfrom{\hskip #3\relax\textcolor{teal}{\@svsec}}%
          \interlinepenalty \@M \textcolor{teal}{#8}\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \textcolor{teal}{\@svsec #8.}}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
%
\def\sectionfont{\fontfamily{\rmdefault}\fontsize{10}{12}\fontseries{b}\selectfont\raggedright}
\def\subsectionfont{\fontfamily{\rmdefault}\fontsize{10}{12}\fontseries{b}\fontshape{it}\selectfont\raggedright}
\def\subsubsectionfont{\fontfamily{\sfdefault}\fontsize{9.5}{11.5}\fontseries{sb}\selectfont\raggedright}
\def\paragraphfont{\fontfamily{\sfdefault}\fontsize{9.5}{11.5}\fontshape{it}\selectfont\raggedright\boldmath}
\def\subparagraphfont{\fontfamily{\rmdefault}\fontsize{10}{12}\fontseries{b}\fontshape{it}\selectfont\raggedright}

\def\@seccntformat#1{{\csname the#1\endcsname.}\hskip.5em}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-27pt \@plus 0ex \@minus 0ex}%
                                   {3pt}%
                                   {\sectionfont}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-24pt \@plus 0ex \@minus 0ex}%
                                     {0.0001pt}%
                                     {\subsectionfont}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-12.5pt \@plus 0ex \@minus 0ex}%
                                     {0.001pt}%
                                     {\subsubsectionfont}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {12.5pt \@plus1ex \@minus.2ex}%
                                    {0.0001pt}%
                                    {\paragraphfont}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\z@}%
                                       {-6pt \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                     {\subparagraphfont}}
%
\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}\ifnum#2=2\vskip0pt\else\ifnum#2=3\vskip1pt\else\ifnum#2=4\vskip1pt\fi\fi\fi%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
    {\@ssect{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lists %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\newdimen\labelwidthi
\newdimen\labelwidthii
\newdimen\labelwidthiii
\newdimen\labelwidthiv
\def\normal@labelsep{0.5em}
\labelsep\normal@labelsep
\settowidth{\labelwidthi}{(iii)}
\settowidth{\labelwidthii}{(d)}
\settowidth{\labelwidthiii}{(iii)}
\settowidth{\labelwidthiv}{(M)}
\leftmargini\labelwidthi    \advance\leftmargini\labelsep
\leftmarginii\labelwidthii  \advance\leftmarginii\labelsep
\leftmarginiii\labelwidthiii \advance\leftmarginiii\labelsep
\leftmarginiv\labelwidthiv  \advance\leftmarginiv\labelsep
\def\setleftmargin#1#2{\settowidth{\@tempdima}{#2}\labelsep\normal@labelsep
  \csname labelwidth#1\endcsname\@tempdima
  \@tempdimb\@tempdima \advance\@tempdimb\labelsep
  \csname leftmargin#1\endcsname\@tempdimb}
\def\@listI{\leftmargin\leftmargini
  \labelwidth\labelwidthi \labelsep\normal@labelsep
  \topsep \z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\labelwidthii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\labelwidthiii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiv{\leftmargin\leftmarginiv
  \labelwidth\labelwidthiv \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\let\@listi\@listI
\@listi
%
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\def\labelitemi{$\bullet$}          \def\labelitemii{$\cdot$}
\def\labelenumi{\theenumi.}        \def\theenumi{\arabic{enumi}}
\def\labelenumii{(\alph{enumii})}   \def\theenumii{\theenumi\alph{enumii}}
\def\labelenumiii{(\roman{enumiii})}\def\theenumiii{\theenumii.\roman{enumiii}}
\def\labelenumiv{(\Alph{enumiv})}   \def\theenumiv{\theenumiii.\Alph{enumiv}}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Ordered & Unordered List  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\def\listfont{\selectfont}%

\def\enumargs{%
   \listfont%
   \leftmargini0pt%
   \topsep 6pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      1em%
   \rightmargin   \z@%
   \raggedright%
   \listparindent \parindent%
   \itemindent    \z@}%

\def\enumerate{%
    \@ifnextchar[{\@numerate}{\@numerate[0.]}}

\def\@numerate[#1]{\par%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{\csname label\@enumctr\endcsname}{%
       \enumargs%
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@enumdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss\llap{##1}}}%
     \fi
   }
\let\endenumerate\endlist

%%Unnumbered list%%
\def\unenumargs{%
   \listfont%
   \leftmargini\parindent%
   \topsep6pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      0\p@%
   \rightmargin   \z@%
   \raggedright%
   \listparindent \parindent%
   \itemindent    -10pt}%

\def\unenumerate{%
    \@ifnextchar[{\@unenumerate}{\@unenumerate[0.]}}

\def\@unenumerate[#1]{\par%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{\csname label\@enumctr\endcsname}{%
       \unenumargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@enumdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss\llap{##1}}}%
     \fi
   }
\let\endunenumerate\endlist%

\def\itemargs{%
   \listfont%
   \leftmargini0pt%
   \topsep6pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      .7em%
   \rightmargin   \z@%
   \raggedright%
   \listparindent \parindent%
   \itemindent    \z@}%

\renewcommand\labelitemi{\raise1pt\hbox{\textbullet}}
\renewcommand\labelitemii{\textendash}

\def\itemize{%
   \@ifnextchar[{\@itemize}{\@itemize[$\bullet$]}}

\def\@itemize[#1]{\par%
     \ifnum \@itemdepth >3 \@toodeep\else
     \advance\@itemdepth \@ne
     \edef\@itemctr{item\romannumeral\the\@itemdepth}
     \list{\csname label\@itemctr\endcsname}{%
       \itemargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@itemdepth\endcsname}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }
\let\enditemize\endlist
%
\def\verse{\let\\=\@centercr
  \list{}{\itemsep\z@
  \itemindent \z@
  \listparindent\z@
  \rightmargin 1em
  \leftmargin \rightmargin}\item[]}
\let\endverse\endlist
\def\quotation{\list{}{\vskip 8pt\itemindent\z@
 \leftmargin 1em \rightmargin \z@
  \parsep \z@ \@plus 1pt}\item[]}
\newcommand\e{\endlist\vskip 8pt}
\let\endquotation\e
\def\quote{\list{}{\itemindent\z@
   \leftmargin 1em \rightmargin \z@}%
\item[]}
\let\endquote\endlist
\def\descriptionlabel#1{\hspace\labelsep \itshape #1}
\def\description{\list{}{\labelwidth\z@
  \leftmargin \z@ \topsep6pt\itemindent \z@ %-\leftmargin
  \let\makelabel\descriptionlabel}}
\let\enddescription\endlist

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Float %%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{caption}
\setlength\abovecaptionskip{12.25\p@}
\setlength\belowcaptionskip{3\p@}

\setlength\arraycolsep{2\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}

\def\fnum@figure{{\figurename}\space\relax{\thefigure}}
\def\fnum@table{{\tablename}\space\relax{\thetable}}

\def\FigName{figure}

\long\def\@makecaption#1#2{%
    \ifx\FigName\@captype
      \vskip\abovecaptionskip
        \@figurecaption{#1}{#2}
    \else
        \@tablecaption{#1}{#2}
      \vskip\belowcaptionskip
    \fi%
}


%% Figure

\def\figurenumfont{\fontfamily{\rmdefault}\fontsize{10}{12}\fontshape{it}\fontseries{b}\selectfont}
\def\figurecaptionfont{\fontfamily{\rmdefault}\fontsize{10}{12}\fontshape{it}\selectfont}

\newdimen\figwidth%
\newdimen\figheight%
\newdimen\sidecapwidth
\newdimen\wrapcapline%
\newdimen\totalwrapline%
\newdimen\wraptotline%

%% Figures macro
\newbox\figurebox%
\newbox\wrapfigcapbox
\def\FIG#1#2{%
\setbox\figurebox\hbox{#1}%
%% Figure dimensions
\figwidth\wd\figurebox%
\figheight\ht\figurebox%
{\parbox{\textwidth}{%
%% Figure width checking
\ifdim\figwidth>170pt%
    %% Normal figures
    \centerline{\box\figurebox}%
    %% Caption
    #2%
\else%
    \global\sidecapwidth\textwidth%
    \global\advance\sidecapwidth-\figwidth%
    \global\advance\sidecapwidth-10pt%
    %% Small figures
    \rightline{\box\figurebox}%
    %% Side Caption
    #2%
\fi%
}}}


%% Figures caption
\newbox\figcapbox
\newbox\capbox
\long\def\@figurecaption#1#2{%
{\setbox\capbox\hbox{#2}%
\setbox\figcapbox\hbox{\figurecaptionfont{\figurenumfont #1}\hskip.4em#2.\vphantom{y}\par}
%% Caption printing depending on figure width
\ifdim\wd\figcapbox>\textwidth
{\figurecaptionfont{\figurenumfont #1.}\hskip.4em {#2}.\par}%
\else%
{\figurecaptionfont\centering{\figurenumfont #1.}\hskip.4em {#2}.\par}%
\fi%
}}%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\RequirePackage{booktabs}
\cmidrulewidth=.15pt%
%
\def\tablenumfont{\fontsize{10}{12}\fontseries{b}\fontshape{it}\selectfont}
\def\tablecaptionfont{\fontsize{10}{12}\fontshape{it}\selectfont\raggedright}
\def\tablebodyfont{\fontsize{10}{12}\selectfont}
\def\tablecolheadfont{\fontsize{10}{12}\selectfont}
\def\tablefootnotefont{\fontsize{7}{9}\selectfont\raggedright}

%% Table Macro
\newbox\tablebox
%\newdimen\tabbodywidth
\long\def\TBL#1#2{%
\renewcommand\arraystretch{1}%
%\setbox\tablebox\hbox{\tablebodyfont #2\par}
%\tabbodywidth\wd\tablebox%
#1\vskip 0pt%
{\tablebodyfont #2\par}%
}

%% Table Caption
\newbox\tabcapbox
\newdimen\tabcapwidth
\long\def\@tablecaption#1#2{%
{\setbox\tabcapbox\hbox{\tablecaptionfont{\tablenumfont #1.}\hskip.4em#2\vphantom{y}\endgraf}%
\tabcapwidth\wd\tabcapbox%
\ifdim\tabcapwidth<\hsize%
    {\tablecaptionfont\centering{\tablenumfont #1.}\hskip.4em#2\vphantom{y}\par}%
\else
    {\tablecaptionfont{\tablenumfont #1.}\hskip.4em#2\vphantom{y}\par}%
\fi}}%

%% Table Column Heads
\def\TCH#1{{\tablecolheadfont #1}}

%% Table Footnotes
\newenvironment{fntable}[1][\columnwidth]{%
\def\@makefnmark{\hbox{\@textsuperscript{\fontsize{5}{5}\selectfont\@thefnmark}}}%
\begin{minipage}{#1}%
\def\thempfootnote{{\@arabic\c@mpfootnote}}
%%%%%%%%%%
\def\@xfootnotemark[##1]{%
   \begingroup
      %\c@footnote #1\relax
      \unrestored@protected@xdef\@thefnmark{##1}%
   \endgroup
   \@footnotemark}
%%%%%%%%%
\def\@xfootnotenext[##1]{%
  \begingroup
     %\csname c@\@mpfn\endcsname ##1\relax
     \unrestored@protected@xdef\@thefnmark{##1}%
  \endgroup
  \@footnotetext}
\renewcommand\@makefntext[1]{{%
\tablefootnotefont%
\hskip0pt{\vrule height6.5pt width0pt\smash{\@makefnmark}}##1\par}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{7}{8.5}}%
}%
{\vspace{-0.95\skip\footins}%
\renewcommand{\footnoterule}{}%
\end{minipage}}%

%% Table Rules
\def\toprule{%\noalign{\vskip3pt}
\noalign{\ifnum0=`}\fi
  \hrule \@height 0\p@ \@width 0pt
  \hrule \@height .25\p@ % <- rule height
  \hrule \@height 5.5pt \@width 0pt
  \futurelet\@tempa\@xhline}
% Middle rule
\def\midrule{\noalign{\ifnum0=`}\fi%
  \hrule \@height 3pt \@width 0pt
  \hrule \@height .25pt % <- rule height
  \hrule \@height 5.5pt \@width 0pt
  \futurelet \@tempa\@xhline}
% Bottom rule
\def\botrule{\noalign{\ifnum0=`}\fi
  \hrule \@height 3pt \@width 0pt
  \hrule \@height .25\p@ % <- rule height
  \futurelet\@tempa\@xhline}
%
\def\@@@cmidrule[#1-#2]#3#4{\global\@cmidla#1\relax
    \global\advance\@cmidla\m@ne
    \ifnum\@cmidla>0\global\let\@gtempa\@cmidrulea\else
    \global\let\@gtempa\@cmidruleb\fi
    \global\@cmidlb#2\relax
    \global\advance\@cmidlb-\@cmidla
    \global\@thisrulewidth=#3
    \@setrulekerning{#4}
    \ifnum\@lastruleclass=\z@\vskip 3\p@\fi
    \ifnum0=`{\fi}\@gtempa
    \noalign{\ifnum0=`}\fi\futurenonspacelet\@tempa\@xcmidrule}
\def\@xcmidrule{%
   \ifx\@tempa\cmidrule
       \vskip-\@thisrulewidth
       \global\@lastruleclass=\@ne
   \else \ifx\@tempa\morecmidrules
       \vskip \cmidrulesep
       \global\@lastruleclass=\@ne\else
       \vskip 5.5\p@
       \global\@lastruleclass=\z@
   \fi\fi
   \ifnum0=`{\fi}}
\let\cline\cmidrule

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%

\renewcommand\@pnumwidth{1.55em}
\renewcommand\@tocrmarg{2.55em}
\renewcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\renewcommand\tableofcontents{%
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    }
\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \setlength\@tempdima{3em}%
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
\renewcommand*\l@section[2]{%
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
\renewcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\renewcommand\listoffigures{%
    \section*{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \@starttoc{lof}%
    }
\renewcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\renewcommand\listoftables{%
    \section*{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other Env. %%%%%%%%%%%%%%%%%%%%%%%%%
%

\renewenvironment{quote}
               {\list{}{\topsep=0pt\topsep6pt\leftmargin=1em\raggedright}%
                \item\relax}
               {\endlist}


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Appendix %%%%%%%%%%%%%%%%%%%%%%%%%
%

\newif\ifbackmatter%
\newcommand{\backmatter}{\par\global\backmattertrue}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Appendix %%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% BackMatters %%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Doi-Links %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% From doi.sty %%

\DeclareRobustCommand{\doitext}{{doi}:}%

%% the meat of the code
%% the first command opens a group, and changes a few catcodes.
\newcommand*{\DOI}{%
  \begingroup
  \lccode`\~=`\#\relax
  \lowercase{\def~{\#}}%
  \lccode`\~=`\_\relax
  \lowercase{\def~{\_}}%
  \lccode`\~=`\<\relax
  \lowercase{\def~{\textless}}%
  \lccode`\~=`\>\relax
  \lowercase{\def~{\textgreater}}%
  \lccode`\~=0\relax
  \catcode`\#=\active
  \catcode`\_=\active
  \catcode`\<=\active
  \catcode`\>=\active
  \doitext\@mydoi
}

%% this is the actual command which processes the argument, with the catcodes
%% set in the previous command
%% it closes the group, and spits out the url.
\def\@mydoi#1{%
  \let\#\relax
  \let\_\relax
  \let\textless\relax
  \let\textgreater\relax
  \edef\x{\toks0={{#1}}}%
  \x
  \edef\#{\@percentchar23}%
  \edef\_{_}%
  \edef\textless{\@percentchar3C}% instead of {\string<} for Apple
  \edef\textgreater{\@percentchar3E}% instead of {\sting>} for Apple
  \edef\x{\toks1={\noexpand\href{http://dx.doi.org/#1}}}%
  \x
  \edef\x{\endgroup\the\toks1 \the\toks0}%
  \x
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Article History  %%%%%%%%%%%%%%%%%%%%
%
\def\@history{}
\def\printhistory{{\par\addvspace{8pt}%
\historyfont\noindent%
\ifx\@history\empty\gdef\@history{Received xx xxx xxxx}\fi\@history\par}
}%

%
\renewenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \columnseprule \z@
                \columnsep 35\p@
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\renewcommand\@idxitem{\par\hangindent 40\p@}
\renewcommand\subitem{\@idxitem \hspace*{20\p@}}
\renewcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\renewcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}

%
%%%%%%%%%%%%%%%%%%%%%%% Footnotes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\renewcommand\footnoterule{%
  \kern2\p@%
  \hrule \@height.15pt \@width5pc%
  \kern4.5\p@}%
%

\def\@makefnmark{{\textsuperscript{\@thefnmark}}}

\renewcommand\@makefntext[1]{%
    \hskip8pt{\smash{\@makefnmark}}#1}

%
\AtBeginDocument{%
\@ifpackageloaded{hyperref}{%
\RequirePackage{hypcap}%
\renewcommand\UrlFont{\rmfamily}%
\hypersetup{%
        colorlinks=true,
        breaklinks=true,
        plainpages=false,%
        citecolor=teal,
        linkcolor=teal,
        urlcolor=teal,
        filecolor=teal,
        %%hyperfootnotes=true,
        bookmarksopen=true,%
        bookmarksnumbered=false,%
        bookmarksdepth=3%
}}{}
}%
%
\AtBeginDocument{%
\@ifpackageloaded{natbib}{%
  \renewcommand\bibsection{%
   \section*{\textcolor{teal}{\refname}}%
  }%
}{}%
}%
%
\def\citethisart#1{\def\thefootnote{}\footnote{\hskip-8.5pt\fontsize{8}{10}\selectfont \textbf{Cite this article:} #1\par}}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\pagestyle{headings}
\pagenumbering{arabic}
\sloppy
\frenchspacing
\flushbottom

%%% special parameters for TeX
\linepenalty=100


\endinput
