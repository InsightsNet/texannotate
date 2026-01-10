%% LaTeX2e Class File for IEICE Transactions by ULS and Company (1999-2016).
%%  E-mail: ieice-div@uls.co.jp or teppei@uls.co.jp, http://www.uls.co.jp/
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ieice}
%%[1999/04/28 v1.0 for Transactions of IEICE]
%%[1999/11/25 v1.1 for Transactions of IEICE]
%%[2001/01/11 v1.2 for Transactions of IEICE]
%%[2002/05/20 v1.3 for Transactions of IEICE]
%%[2002/11/27 v1.4 for Transactions of IEICE]
%%[2003/06/23 v1.5prerelease for Transactions of IEICE]
%%[2003/10/29 v1.5 for Transactions of IEICE]
%%[2008/12/16 v1.6 for Transactions of IEICE]
%%[2010/02/16 v1.7 for Transactions of IEICE]
%%[2011/12/16 v1.8 for Transactions of IEICE]
%%[2013/01/31 v2.0-RC1 for Transactions of IEICE]
%%[2015/10/08 v2.0 for Transactions of IEICE]
%%[2015/10/31 v2.1 for Transactions of IEICE]
  [2016/03/25 v2.2 for Transactions of IEICE]

\newif\if@Proof \@Prooffalse
\DeclareOption{Proof}{\@Prooftrue}
\newif\if@cameraready \@camerareadyfalse
\DeclareOption{cameraready}{\@camerareadytrue}
\def\ieice@warning{\ClassWarningNoLine{ieice}}
\newif\if@referee \@refereefalse
\DeclareOption{referee}{\@refereetrue\@twocolumnfalse}
\DeclareOption{paper}{\gdef\@type{PAPER}}
\DeclareOption{invited}{\gdef\@type{INVITED PAPER}}
\DeclareOption{position}{\gdef\@type{POSITION PAPER}}
\DeclareOption{survey}{\gdef\@type{SURVEY PAPER}}
\DeclareOption{invitedreview}{\gdef\@type{INVITED REVIEW PAPER}}
\DeclareOption{invitedsurvey}{\gdef\@type{INVITED SURVEY PAPER}}
\DeclareOption{review}{\gdef\@type{REVIEW PAPER}}
\DeclareOption{tutorial}{\gdef\@type{TUTORIAL PAPER}}
\newif\if@letter\@letterfalse
\DeclareOption{letter}{\gdef\@type{LETTER}\@lettertrue}
\newif\if@brief\@brieffalse
\DeclareOption{brief}{\gdef\@type{BRIEF PAPER}\@lettertrue\@brieftrue}
\def\@type{PAPER}

\newcounter{@paper}
\newcommand{\@ptsize}{}
\newif\if@restonecol
%%\newif\if@titlepage
%%\@titlepagefalse

%% for 2.1.4 and non pLaTeX2e compatibility
\@ifundefined{hour}{}{%
 \hour\time \divide\hour by 60\relax
 \@tempcnta\hour \multiply\@tempcnta 60\relax
 \minute\time \advance\minute-\@tempcnta
}

\newif\if@enablejfam \@enablejfamtrue
\newif\if@mathrmmc \@mathrmmcfalse
\DeclareOption{a4paper}{\setcounter{@paper}{1}%
  \setlength\paperheight {280mm}%
  \setlength\paperwidth  {210mm}}
\DeclareOption{10pt}{\renewcommand{\@ptsize}{0}}
\DeclareOption{11pt}{\renewcommand{\@ptsize}{1}}
\DeclareOption{12pt}{\renewcommand{\@ptsize}{2}}
\@ifundefined{@needsPformat}{%
 \newif\iftombow\tombowfalse
}{%
 \DeclareOption{tombow}{%
  \tombowtrue \tombowdatetrue
  \setlength{\@tombowwidth}{.1mm}%
  \@bannertoken{%
     \jobname\space:\space\number\year/\number\month/\number\day
      (\number\hour:\number\minute)}%
  \maketombowbox}%
 \DeclareOption{tombo}{%
  \tombowtrue \tombowdatefalse
  \setlength{\@tombowwidth}{.1mm}%
  \maketombowbox}%
 \DeclareOption{mentuke}{%
  \tombowtrue \tombowdatefalse
  \setlength{\@tombowwidth}{\z@}%
  \maketombowbox}%
 \DeclareOption{tate}{\AtBeginDocument{\tate\message{pLaTeX tate mode}}}%
}
%\DeclareOption{oneside}{\@twosidefalse}
\DeclareOption{twoside}{\@twosidetrue}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
%%\DeclareOption{titlepage}{\@titlepagetrue}
%%\DeclareOption{notitlepage}{\@titlepagefalse}
%%\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{% \input{fleqn.clo}
 \ieice@warning{fleqn is loaded by this class file}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}}
\DeclareOption{disablejfam}{\@enablejfamfalse}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\ExecuteOptions{a4paper,10pt,twoside,twocolumn,final}
\ProcessOptions\relax

\newif\if@enable@uptex \@enable@uptexfalse
\ifx\ucs\@undefined\else
 \ifnum\ucs"3000="3000
  \@enable@uptextrue
 \fi
\fi

\def\kenc@JYn{\if@enable@uptex JY2\else JY1\fi}
\def\kenc@JTn{\if@enable@uptex JT2\else JT1\fi}

%\if@enable@uptex
\@ifundefined{kanjiskip}{}{%
 \DeclareFontShape{\kenc@JYn}{mc}{m}{it}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JYn}{mc}{bx}{it}{<->ssub*gt/m/n}{}
 \DeclareFontShape{\kenc@JYn}{mc}{m}{sc}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JYn}{mc}{m}{sl}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JYn}{gt}{m}{it}{<->ssub*gt/m/n}{}
 \DeclareFontShape{\kenc@JYn}{gt}{bx}{it}{<->ssub*gt/m/n}{}
 %% JT
 \DeclareFontShape{\kenc@JTn}{mc}{m}{it}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JTn}{mc}{bx}{it}{<->ssub*gt/m/n}{}
 \DeclareFontShape{\kenc@JTn}{mc}{m}{sc}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JTn}{mc}{m}{sl}{<->ssub*mc/m/n}{}
 \DeclareFontShape{\kenc@JTn}{gt}{m}{it}{<->ssub*gt/m/n}{}
 \DeclareFontShape{\kenc@JTn}{gt}{bx}{it}{<->ssub*gt/m/n}{}
}
%\fi

%% normalsize 10pt=14Q 16.5H
\renewcommand{\normalsize}{%
    \@setfontsize\normalsize\@xpt{4.125mm}%
  \abovedisplayskip 9\p@ \@plus2\p@ \@minus4\p@
  \abovedisplayshortskip \z@ \@plus2.5\p@
  \belowdisplayshortskip 5\p@ \@plus2\p@ \@minus2\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize

%% \setbox0\hbox{\char\euc"A1A1}
%% \setlength\Cht{\ht0}
%% \setlength\Cdp{\dp0}
%% \setlength\Cwd{\wd0}
%% \setlength\Cvs{\baselineskip}
%% \setlength\Chs{\wd0}

%% small 9pt 13Q 14H
\newcommand{\small}{%
  \@setfontsize\small\@ixpt{3.5mm}%
  \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
  \abovedisplayshortskip \z@ \@plus2\p@
  \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
  \def\@listi{\leftmargin\leftmargini
              \topsep 4\p@ \@plus2\p@ \@minus2\p@
              \parsep 2\p@ \@plus\p@ \@minus\p@
              \itemsep \parsep}%
  \belowdisplayskip \abovedisplayskip}

%% footnotesize 8pt 12Q 13.5H
\newcommand{\footnotesize}{%
  \@setfontsize\footnotesize\@viiipt{3.375mm}%
  \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
  \abovedisplayshortskip \z@ \@plus\p@
  \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
  \def\@listi{\leftmargin\leftmargini
              \topsep 3\p@ \@plus\p@ \@minus\p@
              \parsep 2\p@ \@plus\p@ \@minus\p@
              \itemsep \parsep}%
  \belowdisplayskip \abovedisplayskip}

\newcommand{\scriptsize}{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand{\tiny}{\@setfontsize\tiny\@vpt\@vipt}
\newcommand{\large}{\@setfontsize\large\@xiipt{14}}
\newcommand{\Large}{\@setfontsize\Large\@xivpt{18}}
\newcommand{\LARGE}{\@setfontsize\LARGE\@xviipt{22}}
\newcommand{\huge}{\@setfontsize\huge\@xxpt{22}}% 25
\newcommand{\Huge}{\@setfontsize\Huge\@xxvpt{30}}

\setlength\headheight{3mm}
\setlength\headsep   {9.5mm}
\setlength\topskip   {10\p@}%% 1\Cht
\setlength\footskip{\z@}
\setlength\maxdepth{.5\topskip}

\setlength\textwidth{176mm}
\@settopoint\textwidth
\setlength\textheight{56\baselineskip}%% 57 lines
 \advance \textheight \topskip
 \advance \textheight .3mm %% limit .275mm
\@settopoint\textheight

\setlength\marginparsep{10\p@}
\setlength\marginparpush{5\p@}

%\iftombow
 \topmargin\paperheight
 \advance \topmargin -\textheight
 \advance \topmargin -\headheight
 \advance \topmargin -\headsep
 \advance \topmargin -\footskip
 \divide \topmargin \tw@
 \advance \topmargin -1mm %% adjustment
 \advance \topmargin -1in
 \@settopoint\topmargin
 \oddsidemargin\paperwidth
 \advance \oddsidemargin -\textwidth
 \divide \oddsidemargin \tw@
 \advance \oddsidemargin -1in
 %\@settopoint\oddsidemargin
 \evensidemargin\oddsidemargin
 %\@settopoint\evensidemargin
%\fi

\marginparwidth 2in
\@settopoint\marginparwidth

\setlength\footnotesep{2.45mm}
\setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep    {7mm plus 4mm minus 3mm}
\setlength\textfloatsep{7mm plus 4mm minus 3mm}
\setlength\intextsep   {7mm plus 4mm minus 3mm}
\setlength\dblfloatsep    {7mm plus 4mm minus 3mm}
\setlength\dbltextfloatsep{7mm plus 4mm minus 3mm}

\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}

\def\@listi{\leftmargin\leftmargini
  \parsep  4\p@ \@plus2\p@ \@minus\p@
  \topsep  8\p@ \@plus2\p@ \@minus4\p@
  \itemsep 4\p@ \@plus2\p@ \@minus\p@}
\let\@listI\@listi
\@listi
\def\@listii{\leftmargin\leftmarginii
   \labelwidth\leftmarginii \advance\labelwidth-\labelsep
   \topsep 4\p@ \@plus2\p@ \@minus\p@
   \parsep 2\p@ \@plus\p@  \@minus\p@
   \itemsep\parsep}
\def\@listiii{\leftmargin\leftmarginiii
   \labelwidth\leftmarginiii \advance\labelwidth-\labelsep
   \topsep    2\p@  \@plus\p@\@minus\p@
   \parsep    \z@
   \partopsep \p@ \@plus\z@ \@minus\p@
   \itemsep\topsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}

\setlength\columnsep{8mm}
\setlength\columnseprule{0\p@}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand{\baselinestretch}{}
\setlength\parskip{\z@}
\setlength\parindent{7mm}

\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{6}
\setcounter{bottomnumber}{4}
\setcounter{totalnumber}{10}
\setcounter{dbltopnumber}{4}
\renewcommand{\topfraction}{.95}
\renewcommand{\bottomfraction}{.95}
\renewcommand{\textfraction}{.05}
\renewcommand{\floatpagefraction}{.05}
\renewcommand{\dbltopfraction}{.95}
\renewcommand{\dblfloatpagefraction}{.05}

\if@Proof
 \def\@Rtop{\rlap{\smash{\rule[-\headsep]{0.05mm}{10mm}%
  \rule[-\headsep]{10mm}{0.05mm}}}}
 \def\@Ltop{\llap{\smash{\rule[-\headsep]{10mm}{0.05mm}%
  \rule[-\headsep]{0.05mm}{10mm}}}}
 \def\@Rbot{\rlap{\smash{\raisebox{1\footskip}
  {\rule[-10mm]{0.05mm}{10mm}\rule{10mm}{0.05mm}}}}}
 \def\@Lbot{\llap{\smash{\raisebox{1\footskip}
  {\rule{10mm}{0.05mm}\rule[-10mm]{0.05mm}{10mm}}}}}
 \def\pot@jobname{\smash{\raise7mm\rlap{\LARGE\texttt{\jobname}}}}
\else
 \let\@Rtop\relax\let\@Ltop\relax\let\@Rbot\relax\let\@Lbot\relax
 \let\pot@jobname\relax
\fi

\def\ps@IEICE{%
 \let\@mkboth\@gobbletwo
 \def\@oddhead{\@Ltop
  {\def\\{\ \ignorespaces}%
   \scriptsize \r@head}\hfil
  \smash{\lower3mm\hbox to \z@{\hss\footnotesize \thepage}}%
  \@Rtop}%
 \def\@evenhead{\@Ltop
  \smash{\lower3mm\hbox{\footnotesize \thepage}}\hfil
  {\scriptsize IEICE TRANS.\ \@field, VOL.\@vol, NO.\@no\ \month@year}%
  \@Rtop}%
 \def\@evenfoot{\@Lbot\hfil\@Rbot}%
 \let\@oddfoot\@evenfoot
}

\def\ps@ieice{%
 \let\@mkboth\@gobbletwo
 \def\@oddhead{\@Ltop\pot@jobname
  \scriptsize IEICE TRANS.\ \@field, VOL.\@vol, NO.\@no\ \month@year\hfil
  \smash{\lower3mm\hbox{\footnotesize \thepage}}%
  \@Rtop}%
 \def\@evenhead{\@Ltop\pot@jobname
  \smash{\lower3mm\hbox{\footnotesize \thepage}}\hfil
  {\scriptsize IEICE TRANS.\ \@field, VOL.\@vol, NO.\@no\ \month@year}%
  \@Rtop}%
 \def\@evenfoot{\@Lbot\hfil\ieice@copyright\hfil\@Rbot}%
 \let\@oddfoot\@evenfoot
}

\def\ieice@copyright{%
 \smash{\lower7mm\hbox{Copyright\ \copyright\ 
  \ft@year\ 
  The Institute of Electronics, Information and Communication Engineers}}}

\def\ft@year{%
 \@tempcnta \hold@vol\relax
 \advance \@tempcnta 1917\relax
 \ifnum \@tempcnta=1917\relax
  200x%
 \else
  \the\@tempcnta
 \fi
}

\def\field#1{%
 \if#1A\gdef\@field{FUNDAMENTALS}\gdef\hold@field{A}\else
  \if#1B\gdef\@field{COMMUN.}\gdef\hold@field{B}\else
   \if#1C\gdef\@field{ELECTRON.}\gdef\hold@field{C}\else
    \if#1D\gdef\@field{INF.\ \& SYST.}\gdef\hold@field{D}\else
     \gdef\@field{??}\gdef\hold@field{??}%
 \fi\fi\fi\fi
}
\def\@field{??}
\def\hold@field{??}

\def\vol#1{%
 \def\hold@vol{#1}%
 \ifx\hold@vol\empty
  \gdef\hold@vol{0}%
  \gdef\@vol{Exx--\hold@field}%
 \else
  \edef\@tempx{\zap@space#1 \@empty}%
  \afterassignment\remove@to@nnil
   \count@ 0\@tempx\relax\@nnil
  \ifnum\count@=\z@
   \gdef\hold@vol{0}%
   \gdef\@vol{Exx--\hold@field}%
  \else
   \gdef\hold@vol{\zap@space#1 \@empty}%
   \gdef\@vol{E\zap@space#1 \@empty--\hold@field}%
  \fi
 \fi
}
\def\hold@vol{0}
\def\@vol{Exx--??}

\def\no#1{%
 \def\@no{#1}%
 \ifx\@no\empty
  \gdef\@no{xx}%
  \gdef\hold@no{0}%
 \else
  \edef\@tempx{\zap@space#1 \@empty}%
  \afterassignment\remove@to@nnil
   \count@ 0\@tempx\relax\@nnil
  \ifnum\count@=\z@
   \gdef\@no{xx}%
   \gdef\hold@no{0}%
  \else
   \gdef\@no{\zap@space#1 \@empty}%
   \gdef\hold@no{\zap@space#1 \@empty}%
  \fi
 \fi
}
\def\@no{xx}
\def\hold@no{0}

\long\def\title{\@ifnextchar[%% ]
 {\d@title}{\s@title}}
\def\d@title[#1]#2{%
 \gdef\rh@title{\uppercase{#1}}\gdef\@title{#2\@titlenotemark}}
\def\s@title#1{\gdef\rh@title{\uppercase{#1}}\gdef\@title{#1\@titlenotemark}}
\def\@title{}\def\rh@title{}

\def\titlenote#1{\gdef\@titlenote{#1}}
\def\@titlenote{}

\newcount\tn@cnt
\def\title@notation{%
 \ifx\@titlenote\empty\else
  %\let\@fnsymbol\ieice@fnsymbol
  \let\@fnsymbol\ieice@fn@fnsymbol
  \footnotetext[\the\tn@cnt]{\@titlenote}%
 \fi
}

\def\@titlenotemark{%
 \ifx\@titlenote\empty\else
  \unskip\nolinebreak\footnotemark[\the\tn@cnt]%
 \fi
}

\def\@outputrunninghead{%
 \if@letter
  \if@brief
   \gdef\r@head{BRIEF PAPER}%
  \else
   \gdef\r@head{LETTER}%
  \fi
 \else
  \ifnum\total@mbr=\z@
   \gdef\r@head{\rh@title}%
  \else
   \ifnum\total@mbr=\@ne
    \setbox\@tempboxa\hbox{\spaceskip=100mm \csname @Rauthorname1\endcsname}%
    \ifdim \wd\@tempboxa < 100mm
     \xdef\r@head{\csname @Rauthorname1\endcsname\unskip:\ \rh@title}%
    \else
     \def\@rhead##1 ##2\@nd{\gdef\r@head{\uppercase{##2}\unskip:\ \rh@title}}%
     \edef\@tempname{\csname @Rauthorname1\endcsname}%
     \expandafter\@rhead\@tempname\@nd\relax
    \fi
   \else
    \ifnum\total@mbr=\tw@
     \setbox\@tempboxa\hbox{\spaceskip=100mm
      \csname @Rauthorname1\endcsname\csname @Rauthorname2\endcsname}%
     \ifdim \wd\@tempboxa < 200mm
      \xdef\r@head{\csname @Rauthorname1\endcsname\ 
        and \csname @Rauthorname2\endcsname\unskip:\ \rh@title}%
     \else
      \def\@rhead##1 ##2 ##3 ##4\@nd{\gdef\r@head{\uppercase{##2}\ 
        and \uppercase{##4}\unskip:\ \rh@title}}%
      \edef\@tempname{\csname @Rauthorname1\endcsname\space
                      \csname @Rauthorname2\endcsname}%
      \expandafter\@rhead\@tempname\@nd\relax
     \fi
    \else
     \setbox\@tempboxa\hbox{\spaceskip=100mm \csname @Rauthorname1\endcsname}%
     \ifdim \wd\@tempboxa < 100mm
      \xdef\r@head{\csname @Rauthorname1\endcsname\unskip\ et al.:\ \rh@title}%
     \else
      \def\@rhead##1 ##2\@nd{%
       \gdef\r@head{\uppercase{##2}\unskip\ et al.:\ \rh@title}}%
      \edef\@tempname{\csname @Rauthorname1\endcsname}%
      \expandafter\@rhead\@tempname\@nd\relax
     \fi
    \fi
   \fi
  \fi
  \chk@rhead
 \fi
}
\def\r@head{}

\def\chk@rhead{%
 \setbox\@tempboxa\hbox{\scriptsize \r@head}%%
 \ifdim \wd\@tempboxa > 182mm %% \textwidth176mm
   \ieice@warning{Title of header is too wide. make it shorter}%
 \fi
}

\newcommand{\maketitle}{\par %}{
 \ifnum\chk@al@cnt<\@alcnt
  \ieice@warning{Information of \string\affiliate\space is not specified}%
 \fi
 \ifnum\chk@p@al@cnt<\p@alcnt
  \ieice@warning{Information of \string\paffiliate\space is not specified}%
 \fi
 \ifx\@titlenote\empty\else
  \tn@cnt\p@alcnt \advance \tn@cnt \@ne
 \fi
 \begingroup
  \global\@topnum\z@
  \if@referee
   \@maketitle
  \else
   \twocolumn[\@maketitle]
  \fi
   \@outputrunninghead
   \thispagestyle{ieice}%
   \@received
   \@revised
   \@finalreceived
   \@onlinefirst
   \@affiliate
   \p@affiliate
   \title@notation
   \@mailaddress
   \@DOI
 \endgroup
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@received\relax
  \global\let\@revised\relax
  \global\let\@finalreceived\relax
  \global\let\@onlinefirst\relax
  \global\let\@affiliate\relax
  \global\let\p@affiliate\relax
  \global\let\@mailaddress\relax
  \global\let\@titlenote\relax
  \global\let\@titlenotemark\relax
  \ifnum\tn@cnt=\z@
   \setcounter{footnote}{\the\p@alcnt}%
  \else
   \setcounter{footnote}{\the\p@alcnt}%
   \addtocounter{footnote}{1}%
  \fi
   \@authorcnt\z@
   \loop\ifnum\@authorcnt<\total@mbr
    \advance \@authorcnt \@ne
     \global\expandafter\let
      \csname @authorname\number\@authorcnt\endcsname\relax
     \global\expandafter\let
      \csname @authormembership\number\@authorcnt\endcsname\relax
     \global\expandafter\let
      \csname @Rauthorname\number\@authorcnt\endcsname\relax
   \repeat
}

\def\@maketitle{\newpage\null
 \parindent\z@
 \linethickness{0.15mm}%
 \unitlength 1mm
 \setbox\@tempboxa\hbox{%
  \parbox[t]{\textwidth}{\LARGE\bfseries\mathversion{bold}\raggedright
   \@title}}%
 \@tempdima\ht\@tempboxa
 \advance \@tempdima \dp\@tempboxa
 \ifdim\@tempdima>25mm \@tempdimb=37mm\else
  \ifdim\@tempdima>19mm \@tempdimb=31mm\else \@tempdimb=25mm
 \fi\fi
  \setbox\@tempboxa\vbox{%
   \vbox to \@tempdimb{%
    \framebox(175.7,3.8)[l]{%
     \raise-0.38ex\hbox{{\large\sffamily\,\@type}}\quad
      {\small\sffamily\slshape \@theme\rule[-1mm]{0mm}{4mm}}\hfill}%
    \vskip-2mm
    {\LARGE\bfseries\mathversion{bold}\raggedright \@title\par}
    \vss
    \hrule height .15mm
   }\par
   \vskip-3mm
   {\normalsize\bfseries \@outputauthorlist}%
  }%
  \@tempdima\ht\@tempboxa
  \advance \@tempdima \dp\@tempboxa
  \divide \@tempdima \baselineskip
  \@tempcnta=\@tempdima
  \ifdim\@tempdimb=25mm
   \advance \@tempcnta \thr@@
  \else
   \advance \@tempcnta 4\relax
  \fi
   \boxmaxdepth\z@
   \lineskiplimit\z@
   \lineskip\z@
   \vbox to \@tempcnta\baselineskip{%
    \if@referee\vskip-1em\fi
     \box\@tempboxa
    \vss
   }\par
 \vskip\@titleadj
}

\def\jalcdoi#1{\gdef\@jalcdoi{#1}}
\def\@jalcdoi{}
\def\eicid@A{fun}
\def\eicid@B{com}
\def\eicid@C{ele}
\def\eicid@D{inf}
\def\@DOI{%
 \ifx\@jalcdoi\@empty
  \edef\tmp@doi{E\hold@vol.\hold@field}%
  \footnotetext[0]{%
   DOI: 10.1587/trans\csname eicid@\hold@field\endcsname.%
  \tmp@doi.\thepage}%
 \else
  \footnotetext[0]{\@jalcdoi}%
 \fi
}

\newtoks\@authorlist
\newcount\@authorcnt
\newcount\total@mbr
\newcount\@alcnt
\newcount\p@alcnt
 \p@alcnt 6\relax

\def\authorlist#1{%
 \@authorlist={#1}%
 \@chkauthormembership
}

\def\authorentry{\@ifnextchar[%% ]
 {\E@ae}{\NE@ae}}
\def\NE@ae#1#2#3{\@ifnextchar[%% ]
  {\NE@aeP{#1}{#2}{#3}}%   no Email with present aff.
  {\NE@aeNP{#1}{#2}{#3}}}% no Email without present aff.
\def\E@ae[#1]#2#3#4{\@ifnextchar[%% ]
  {\E@aeP[#1]{#2}{#3}{#4}}%    Email with present aff.
  {\E@aeNP[#1]{#2}{#3}{#4}}}%  Email without present aff.

\def\NE@aeNP#1#2#3{% no Email without present aff.
 \@tempcnta\z@
 \advance \@authorcnt \@ne
  \get@al{#3}%
  \def\al@none{0}%
  \fmt@an{#1}%
  \expandafter\xdef\csname @authorname\number\@authorcnt\endcsname{%
   \@authorname\unskip\plural@affi}% %% {#3}
  \fmt@Ran{#1}%
  \chk@membership{#2}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt\endcsname{%
    \csname #2member\endcsname}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt*\endcsname{%
    \csname #2members\endcsname}%
  \global\total@mbr=\@authorcnt
 \gdef\plural@affi{}%
}

\def\E@aeNP[#1]#2#3#4{% Email without present aff.
 \@tempcnta\z@
 \advance \@authorcnt \@ne
  \get@al{#4}%
  \def\al@none{0}%
  \fmt@an{#2}%
  \stepcounter{enumii}%
  \expandafter\xdef\csname @authorname\number\@authorcnt\endcsname{%
   \@authorname\unskip\plural@affi %% {#4}
    \noexpand\@textsuperscript{% (
     \noexpand\normalfont\theenumii)}%
  }%
  \ft@mailaddress{\llap{%% (
   \theenumii)\,}E-mail: #1}%
  \fmt@Ran{#2}%
  \chk@membership{#3}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt\endcsname{%
    \csname #3member\endcsname}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt*\endcsname{%
    \csname #3members\endcsname}%
  \global\total@mbr=\@authorcnt
 \gdef\plural@affi{}%
}

\def\NE@aeP#1#2#3[#4]{% no Email with present aff.
 \@tempcnta\z@
 \advance \@authorcnt \@ne
  \get@al{#3}%
  \def\al@none{0}%
  \@tempcnta\z@
  \get@p@al{#4}%
  %\@ifundefined{p@al@#4}%
  % {\global\advance \p@alcnt \@ne
  %  \expandafter\xdef\csname p@al@#4\endcsname{\the\p@alcnt}}
  % {\relax}%
  \fmt@an{#1}%
  \expandafter\xdef\csname @authorname\number\@authorcnt\endcsname{%
   \@authorname\unskip\plural@affi\plural@p@affi}% %%{#3}{#4}
  \fmt@Ran{#1}%
  \chk@membership{#2}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt\endcsname{%
    \csname #2member\endcsname}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt*\endcsname{%
    \csname #2members\endcsname}%
  \global\total@mbr=\@authorcnt
 \gdef\plural@affi{}%
 \gdef\plural@p@affi{}%
}

\def\E@aeP[#1]#2#3#4[#5]{% Email with present aff.
 \@tempcnta\z@
 \advance \@authorcnt \@ne
  \get@al{#4}%
  \def\al@none{0}%
  \@tempcnta\z@
  \get@p@al{#5}%
  %\@ifundefined{p@al@#5}%
  % {\global\advance \p@alcnt \@ne
  %  \expandafter\xdef\csname p@al@#5\endcsname{\the\p@alcnt}}
  % {\relax}%
  \fmt@an{#2}%
  \stepcounter{enumii}%
  \expandafter\xdef\csname @authorname\number\@authorcnt\endcsname{%
   \@authorname\unskip\plural@affi\plural@p@affi % %%{#4}{#5}%
    \noexpand\@textsuperscript{% (
     \noexpand\normalfont\theenumii)}%
  }%
  \ft@mailaddress{\llap{%% (
   \theenumii)\,}E-mail: #1}%
  \fmt@Ran{#2}%
  \chk@membership{#3}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt\endcsname{%
    \csname #3member\endcsname}%
  \expandafter\xdef
   \csname @authormembership\number\@authorcnt*\endcsname{%
    \csname #3members\endcsname}%
  \global\total@mbr=\@authorcnt
 \gdef\plural@affi{}%
 \gdef\plural@p@affi{}%
}

%\def\get@al#1{%
% \@for\get@label:=#1\do{%
%  \@ifundefined{al@\get@label}%
%   {\def\@noaffi{none}\def\@tempaffi{#1}%
%    \ifx\@noaffi\@tempaffi\else
%     \global\advance \@alcnt \@ne\fi
%    \expandafter\xdef\csname al@\get@label\endcsname{\the\@alcnt}%
%    \advance \@tempcnta \@ne
%    \expandafter\xdef\csname al@\romannumeral\@tempcnta\endcsname{%
%     \get@label}%
%   }%
%   {\advance \@tempcnta \@ne
%    \expandafter\xdef\csname al@\romannumeral\@tempcnta\endcsname{%
%     \get@label}%
%   }%
% }%
%}

%%\newif\if@affinone \@affinonefalse
\def\get@al#1{%
 \def\@noaffi{none}\def\@tempaffi{#1}%
 \ifx\@noaffi\@tempaffi
  %% \global\@affinonetrue
 \else
  \@for\get@label:=#1\do{%
   \@ifundefined{al@\get@label}%
    {%
     \global\advance \@alcnt \@ne
     \expandafter\xdef\csname al@\get@label\endcsname{\the\@alcnt}%
     \global\advance \@tempcnta \@ne
     \protected@xdef\plural@affi{\plural@affi
      \ifnum\@tempcnta=\@ne
       $^{\ieice@fnsymbol{\csname al@\get@label\endcsname}}$%
      \else
       $^{,\ieice@fnsymbol{\csname al@\get@label\endcsname}}$%
      \fi
     }%
    }%
    {%
     \global\advance \@tempcnta \@ne
     \protected@xdef\plural@affi{\plural@affi
      \ifnum\@tempcnta=\@ne
       $^{\ieice@fnsymbol{\csname al@\get@label\endcsname}}$%
      \else
       $^{,\ieice@fnsymbol{\csname al@\get@label\endcsname}}$%
      \fi
     }%
    }%
  }%
 \fi
}
\def\plural@affi{}

\def\get@p@al#1{%
 \@for\get@label:=#1\do{%
  \@ifundefined{p@al@\get@label}%
   {%
    \global\advance \p@alcnt \@ne
    \expandafter\xdef\csname p@al@\get@label\endcsname{\the\p@alcnt}%
    \global\advance \@tempcnta \@ne
    \protected@xdef\plural@p@affi{\plural@p@affi
     \ifnum\@tempcnta=\@ne
      $^{\ieice@fnsymbol{\csname p@al@\get@label\endcsname}}$%
     \else
      $^{,\ieice@fnsymbol{\csname p@al@\get@label\endcsname}}$%
     \fi
    }%
   }%
   {%
    \global\advance \@tempcnta \@ne
    \protected@xdef\plural@p@affi{\plural@p@affi
     \ifnum\@tempcnta=\@ne
      $^{\ieice@fnsymbol{\csname p@al@\get@label\endcsname}}$%
     \else
      $^{,\ieice@fnsymbol{\csname p@al@\get@label\endcsname}}$%
     \fi
    }%
   }%
 }%
}
\def\plural@p@affi{}

\def\fmt@an#1{%
 \expandafter\def\csname EICMN@name\number\@authorcnt\endcsname{#1}%
 \@temptokena{#1}%
 \setbox\@tempboxa\hbox{\spaceskip=100mm #1}%
 \ifdim \wd\@tempboxa < 100mm
  \ieice@warning{a space should be added between 1st and 2nd name: "#1"}%
 \else
  \def\name@form##1 ##2\@nil{\gdef\@tempan{##1 \uppercase{##2}}}%
  \expandafter\name@form\the\@temptokena\@nil
  \expandafter\@temptokena\expandafter{\@tempan}%
 \fi
 \def\@authorname{\the\@temptokena}%
}

\def\fmt@Ran#1{%
 \ifnum\@authorcnt<\thr@@
  \def\tmp@Ran{#1}%
  \ifx\tmp@Ran\empty
   \expandafter\xdef\csname @Rauthorname\number\@authorcnt\endcsname{{} {}}%
  \else
   \expandafter\newtoks\csname @toks\romannumeral\@authorcnt\endcsname
   \csname @toks\romannumeral\@authorcnt\endcsname{#1}%
   \expandafter\xdef\csname @Rauthorname\number\@authorcnt\endcsname{%
    \noexpand\the\csname @toks\romannumeral\@authorcnt\endcsname}%
  \fi
 \fi
}

\def\chk@membership#1{%
 \@ifundefined{#1member}{%
  \expandafter\gdef\csname #1member\endcsname{??}%
  \ieice@warning{membership "#1" is wrong}%
 }{}%
}

%\def\plural@affi#1{%
% \@ifundefined{al@#1}
%  {\expandafter\ifnum\expandafter\csname al@\al@i\endcsname\expandafter
%     >\csname al@\al@ii\endcsname
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@ii\endcsname},}$%
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@i\endcsname}}$%
%   \else
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@i\endcsname},}$%
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@ii\endcsname}}$%
%   \fi
%  }%
%   {\expandafter\ifnum\csname al@#1\endcsname=\z@\else
%    $^{\noexpand\ieice@fnsymbol{\csname al@#1\endcsname}}$\fi}%
%}

%\def\plural@p@affi#1#2{%
% \@ifundefined{al@#1}
%  {\expandafter\ifnum\expandafter\csname al@\al@i\endcsname\expandafter
%     >\csname al@\al@ii\endcsname
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@ii\endcsname},}$%
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@i\endcsname}}$%
%   \else
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@i\endcsname},}$%
%    $^{\noexpand\ieice@fnsymbol{\csname al@\al@ii\endcsname}}$%
%   \fi
%   $^{\noexpand\ieice@fnsymbol{\csname p@al@#2\endcsname}}$%
%  }%
%  {$^{\noexpand\ieice@fnsymbol{\csname al@#1\endcsname}}$%
%   $^{\noexpand\ieice@fnsymbol{\csname p@al@#2\endcsname}}$}% 
%}

\def\MembershipNumber#1{%
 \def\tmpchk@MN{#1}%
 \ifx\tmpchk@MN\@empty\else
  \expandafter\def\csname EICMN@\number\@authorcnt\endcsname{#1}%
 \fi
}
\def\@Membership@Number{%
 \@authorcnt\z@
 \loop
  \ifnum \@authorcnt < \total@mbr
   \advance \@authorcnt \@ne
   \chk@MN{EICMN@\number\@authorcnt}%
   \noindent
   \csname EICMN@name\number\@authorcnt\endcsname\hskip2em
   \texttt{\csname EICMN@\number\@authorcnt\endcsname}\par
 \repeat
}

\def\chk@MN#1{%
 \@ifundefined{#1}{}{%
  \expandafter\@tempcnta \csname #1\endcsname\relax
  \ifnum \@tempcnta > 9999999\relax
   \ieice@warning{Membership Number "\the\@tempcnta" might be wrong}%
  \else
   \ifnum \@tempcnta < 1000000\relax
    \ieice@warning{Membership Number "\the\@tempcnta" might be wrong}%
   \fi
  \fi
 }%
}

\def\EICdepartment#1{\ignorespaces #1\unskip, \ignorespaces}%
\def\EICorganization#1{\ignorespaces #1\unskip, \ignorespaces}%
\def\EICaddress#1{\ignorespaces #1\unskip.\ignorespaces}%

\newcount\chk@al@cnt
\newcount\chk@p@al@cnt
 \chk@p@al@cnt 6\relax

\def\affiliate[#1]#2{%
 \advance \chk@al@cnt \@ne
 \@ifundefined{al@#1}{%
  \expandafter\def\csname al@#1\endcsname{1}%
  \ieice@warning{Check the "#1" label, it does not correspond to
    ^^J\space\space any labels in \string\authorentry\space command}%
 }{}%
 \let\@fnsymbol\ieice@fn@fnsymbol
 \protected@xdef\@affiliate{\@affiliate
  \protect\footnotetext[\csname al@#1\endcsname]{#2}}%
}
\def\@affiliate{}

\def\ft@mailaddress#1{%
 \let\@fnsymbol\ieice@fn@fnsymbol
 \protected@xdef\@mailaddress{%
 \@mailaddress
 \protect\footnotetext[0]{#1}}%
}
\def\@mailaddress{}

\def\paffiliate[#1]#2{%
 \advance \chk@p@al@cnt \@ne
 \@ifundefined{p@al@#1}%
  {\expandafter\def\csname p@al@#1\endcsname{1}%
   \ieice@warning{Check the "#1" label, it does not correspond
    ^^J\space\space to any labels in \string\authorentry\space command}%
  }{\let\@fnsymbol\ieice@fn@fnsymbol
    \protected@xdef\p@affiliate{\p@affiliate
     \protect\footnotetext[\csname p@al@#1\endcsname]{#2}}%
  }%
}
\def\p@affiliate{}

\def\mmember{Member}
\def\mmembers{Members}
\def\nmember{Nonmember}
\def\nmembers{Nonmembers}
\def\smember{Student Member}
\def\smembers{Student Members}
\def\amember{Affiliate Member}
\def\amembers{Affiliate Members}
\def\hmember{Fellow, Honorary Member}
\def\hmembers{Fellows, Honorary Members}
\def\fmember{Fellow}
\def\fmembers{Fellows}
\def\rmember{Member}% Regular 
\def\rmembers{Members}% Regular 
\def\emember{Senior Member}
\def\emembers{Senior Members}
\def\Smember{Senior Member}
\def\Smembers{Senior Members}

\newcount\@authorcnt@p@ne
\newif\if@plural
\def\@chkauthormembership{\the\@authorlist
 \@authorcnt\z@
 \@pluralfalse
 \loop\ifnum\@authorcnt<\total@mbr
  \advance \@authorcnt \@ne
  \@authorcnt@p@ne=\@authorcnt \advance \@authorcnt@p@ne \@ne
  \if@plural
    \edef\@nextmembership{%
     \csname @authormembership\number\@authorcnt@p@ne*\endcsname}
  \else
    \edef\@nextmembership{%
     \csname @authormembership\number\@authorcnt@p@ne\endcsname}
  \fi
  \expandafter\ifx\csname @authormembership\number\@authorcnt\endcsname
   \@nextmembership
    \expandafter\gdef\csname @authormembership\number\@authorcnt\endcsname{%
     \relax}
    \edef\tempauthormembership{%
     \csname @authormembership\number\@authorcnt@p@ne*\endcsname}
    \expandafter\let
     \csname @authormembership\number\@authorcnt@p@ne\endcsname 
       \tempauthormembership \@pluraltrue
  \else
   \@pluralfalse
  \fi
 \repeat
}

\newcount\totalnumberm@ne
\newdimen\authorlistlength
\authorlistlength=170mm

\def\breakauthorline#1{%
 \@for\@breakauthor:=#1\do{%
  \expandafter\gdef\csname @breakauthorline\@breakauthor\endcsname{\\}%
 }%
  \@authorcnt=\z@
  \loop\ifnum\@authorcnt<\total@mbr % >
   \advance \@authorcnt \@ne
    \@ifundefined{@breakauthorline\number\@authorcnt}%
     {\expandafter\gdef\csname @breakauthorline\number\@authorcnt\endcsname{%
      \relax}}
     {\relax}%
  \repeat
}

\def\@outputauthorlist{%
 \hfill
 \vbox{\hsize=\authorlistlength
  \baselineskip 3.75mm
  \flushright
  \def\no@authormembership{\relax}%
  \@authorcnt\z@
  \totalnumberm@ne\total@mbr \advance \totalnumberm@ne -\@ne
  \loop\ifnum\@authorcnt<\total@mbr
   \advance \@authorcnt \@ne 
    \ifnum\@authorcnt < \totalnumberm@ne
     \mbox{\csname @authorname\number\@authorcnt\endcsname
      \expandafter\ifx \csname @authormembership\number\@authorcnt\endcsname
       \no@authormembership
      \else
       \nobreak, 
      \fi
     \nobreak{\bfseries\itshape
      \csname @authormembership\number\@authorcnt\endcsname}}\nobreak,
      \csname @breakauthorline\number\@authorcnt\endcsname
    \else
     \ifnum\@authorcnt=\total@mbr
      \mbox{\csname @authorname\number\@authorcnt\endcsname
       \expandafter\ifx \csname @authormembership\number\@authorcnt\endcsname
        \no@authormembership
       \else
        \nobreak, 
       \fi
      \nobreak{\bfseries\itshape
       \csname @authormembership\number\@authorcnt\endcsname}}
        \csname @breakauthorline\number\@authorcnt\endcsname
     \else
      \ifnum\total@mbr=\tw@
       \mbox{\csname @authorname\number\@authorcnt\endcsname
        \expandafter\ifx \csname @authormembership\number\@authorcnt\endcsname
         \no@authormembership
        \else
         \nobreak, 
        \fi
       \nobreak{\bfseries\itshape
        \csname @authormembership\number\@authorcnt\endcsname}}%
         \csname @breakauthorline\number\@authorcnt\endcsname
       \allowbreak\mbox{\bfseries\itshape \ and\/\ }\nobreak 
      \else
       \mbox{\csname @authorname\number\@authorcnt\endcsname%
        \expandafter\ifx \csname @authormembership\number\@authorcnt\endcsname
         \no@authormembership
        \else
         \nobreak, 
        \fi
       \nobreak{\bfseries\itshape
        \csname @authormembership\number\@authorcnt\endcsname},}%
         \csname @breakauthorline\number\@authorcnt\endcsname
       \allowbreak\mbox{\bfseries\itshape \ and\/\ }\nobreak 
      \fi
     \fi
    \fi
  \repeat
 }%
}

\def\titleadj#1{\gdef\@titleadj{#1}}
\def\@titleadj{}
\titleadj{0mm}

\def\theme#1{\gdef\@theme{#1}}
\def\@theme{}
\def\SpecialIssue#1{\gdef\@theme{Special Issue on #1}}
\def\SpecialSection#1{\gdef\@theme{Special Section on #1}}

\def\mm@yy#1#2{%
 \ifcase #2\or 
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\else
   xxx\protect\ieice@warning{check \string#1 command}\fi
}%

\def\received#1#2#3{\begingroup
 \protected@xdef\@received{\protect\footnotetext[0]{%
  Manuscript received \mm@yy{\received}{#2} #3, #1.}}\endgroup}
\def\@received{}

\def\revised#1#2#3{\begingroup
 \protected@xdef\@revised{\protect\footnotetext[0]{%
  Manuscript revised \mm@yy{\revised}{#2} #3, #1.}}\endgroup}
\def\@revised{}

\def\finalreceived#1#2#3{\begingroup
 \protected@xdef\@finalreceived{\protect\footnotetext[0]{%
  Final manuscript received \mm@yy{\finalreceived}{#2} #3, #1.}}\endgroup}
\def\@finalreceived{}

\def\onlinefirst#1#2#3{\begingroup
 \protected@xdef\@onlinefirst{\protect\footnotetext[0]{%
  Manuscript publicized \mm@yy{\onlinefirst}{#2} #3, #1.}}\endgroup}
\def\@onlinefirst{}

\newenvironment{summary}{%
 \noindent\footnotesize
 \if@referee
  \baselineskip1.2\baselineskip
 \fi
 {\bfseries SUMMARY}\hskip1pc\ignorespaces}%
 {\par
  \if@referee
   \vskip.2\baselineskip
  \fi
 }
\newenvironment{keywords}{%
 \noindent\footnotesize\itshape
 {\bfseries key words:\ \ignorespaces}}{\par}

\setcounter{secnumdepth}{5}
\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\renewcommand{\thesection}{\@arabic\c@section}
\renewcommand{\thesubsection}{\thesection.\@arabic\c@subsection}
\renewcommand{\thesubsubsection}{%
   \thesubsection.\@arabic\c@subsubsection}
\renewcommand{\theparagraph}{(\@arabic\c@paragraph)}
\renewcommand{\thesubparagraph}{(\theparagraph.\@arabic\c@subparagraph)}

\def\@afterheading{%
 \global\@nobreaktrue
 \everypar{%
  \if@nobreak
   \global\@nobreakfalse
   \clubpenalty\z@
    \if@afterindent
    \else
     {\setbox\z@=\lastbox}%
    \fi
  \else
   \clubpenalty\@clubpenalty
   \everypar{}%
  \fi}%
}

\def\@startsection#1#2#3#4#5#6{\if@noskipsec \leavevmode \fi
   \par \@tempskipa #4\relax
   \@afterindenttrue
   \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
   \if@nobreak
    \everypar{}%
   \else
    %\addpenalty\@secpenalty
    \vskip-\prevdepth \prevdepth\z@ \vskip\baselineskip
    \advance\@tempskipa-\baselineskip\vspace*{\@tempskipa}%
   \fi
 \@ifstar{\@ssect{#3}{#4}{#5}{#6}}{\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}

%% \@sect{NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE}[ARG1]{ARG2}
\def\@sect#1#2#3#4#5#6[#7]#8{%
 \ifnum #2>\c@secnumdepth
  \let\@svsec\@empty
 \else
  \refstepcounter{#1}%
  \gdef\@appbox{#8}%
  \protected@edef\@svsec{\@seccntformat{#1}{#2}\relax}%
 \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
   \begingroup
    #6{%
      \@hangfrom{\hskip #3\relax\@svsec}%
       \interlinepenalty \@M #8\@@par}%
   \endgroup
  \else
   \def\@svsechd{%
     #6{\hskip #3\relax
     \@svsec #8}}%
  \fi
  \@xsect{#5}}

\def\@seccntformat#1#2{\csname the#1\endcsname
 \ifnum #2=\@ne
  \if@appendix
   \ifx\@appbox\empty\else{:}\fi
  \else{.}\fi
 \fi
\quad}

\newcommand{\section}{\@startsection{section}{1}{\z@}%
   {-1\baselineskip \@plus-1mm \@minus-.5mm}%
   {1\baselineskip \@plus1mm \@minus.5mm}%
   {\reset@font\normalsize\bfseries\mathversion{bold}}}
\newcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
   {-1\baselineskip \@plus-1mm \@minus-.5mm}%
   {1\baselineskip \@plus1mm \@minus.5mm}%
   {\reset@font\normalsize}}
\newcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
   {-1\baselineskip \@plus-1mm \@minus-.5mm}%
   {1\baselineskip \@plus1mm \@minus.5mm}%
   {\reset@font\normalsize}}
\newcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}%
   {-.5\baselineskip \@plus-.5mm \@minus-.25mm}%
   {.5\baselineskip \@plus.5mm \@minus.25mm}%
   {\reset@font\normalsize}}
\newcommand{\subparagraph}{\@startsection{subparagraph}{5}{\parindent}%
   {-.5\baselineskip \@plus-.5mm \@minus-.25mm}%
   {.5\baselineskip \@plus .5mm \@minus.25mm}%
   {\reset@font\normalsize}}

\newif\if@appendix\@appendixfalse
\def\appendix{\@ifstar{\ncnt@appendix}{\cnt@appendix}}
\def\ncnt@appendix{\par
 \@appendixtrue
 \setcounter{section}{0}%
 \def\thesection{\appendixname}%
 \def\thesubsection{A.\@arabic\c@subsection}%% added v1.5-p.01
  \setcounter{equation}{0}%
  \def\theequation{\@Alph\c@section$\cdot$\,\@arabic\c@equation}%
  \setcounter{figure}{0}
  \setcounter{table}{0}
  \def\thefigure{A$\cdot$\,\@arabic\c@figure}
  \def\thetable{A$\cdot$\,\@arabic\c@table}
}
\def\cnt@appendix{\par
 \@appendixtrue
 \setcounter{section}{0}%
 \setcounter{subsection}{0}%
 \def\thesection{\appendixname\ \@Alph\c@section}%
 \def\thesubsection{\@Alph\c@section.\@arabic\c@subsection}%
  \setcounter{equation}{0}%
  \def\theequation{A$\cdot$\,\@arabic\c@equation}%
  \setcounter{figure}{0}%
  \setcounter{table}{0}%
  \def\thefigure{A$\cdot$\,\@arabic\c@figure}%
  \def\thetable{A$\cdot$\,\@arabic\c@table}%
}

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
\@beginparpenalty\z@ % -\@lowpenalty
\@endparpenalty\z@ %   -\@lowpenalty
\@itempenalty\z@ %     -\@lowpenalty

\renewcommand{\theenumi}{\@arabic\c@enumi}
\renewcommand{\theenumii}{\@alph\c@enumii}
\renewcommand{\theenumiii}{\@roman\c@enumiii}
\renewcommand{\theenumiv}{\@Alph\c@enumiv}
\newcommand{\labelenumi}{\theenumi.}
\newcommand{\labelenumii}{\theenumii.}
\newcommand{\labelenumiii}{\theenumiii.}
\newcommand{\labelenumiv}{\theenumiv.}
\renewcommand{\p@enumii}{\theenumi}
\renewcommand{\p@enumiii}{\theenumi(\theenumii)}
\renewcommand{\p@enumiv}{\p@enumiii\theenumiii}

\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}

\newskip\@hlskip
 \@hlskip=.5\baselineskip \@plus 3\p@ \@minus 2\p@

\def\enumerate{%
  \ifnum \@enumdepth >\thr@@\@toodeep\else
    \advance\@enumdepth\@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
      \expandafter
      \list
        \csname label\@enumctr\endcsname
        {\usecounter\@enumctr
         \leftmargin=7mm
         \topsep\@hlskip\parsep\z@\partopsep\z@\itemsep\z@
         \clubpenalty\z@
         \def\makelabel##1{\hss\llap{##1}}}%
  \fi}
\let\endenumerate =\endlist

\def\itemize{%
  \ifnum \@itemdepth >\thr@@\@toodeep\else
    \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \expandafter
    \list
      \csname\@itemitem\endcsname
      {\leftmargin=7mm
       \topsep\@hlskip\parsep\z@\partopsep\z@\itemsep\z@
       \clubpenalty\z@
       \def\makelabel##1{\hss\llap{##1}}}%
  \fi}
\let\enditemize =\endlist

\newenvironment{description}
               {\list{}{
                 \labelwidth\z@ \itemindent-\leftmargin
                 \topsep\@hlskip\parsep\z@\partopsep\z@\itemsep\z@
                 \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em
                        \topsep\@hlskip\parsep\z@\partopsep\z@
                       }%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \topsep\@hlskip\parsep\z@\partopsep\z@\itemsep\z@
                       }%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin
                        \topsep\@hlskip\parsep\z@\partopsep\z@\itemsep\z@
                       }%
                \item\relax}
               {\endlist}

\newdimen\verbatimleftmargin
  \verbatimleftmargin\z@
\newdimen\verbatimbaselineskip
  \verbatimbaselineskip\baselineskip
\def\verbatimsize{\normalsize}

\def\@verbatim{%
 \topsep\@hlskip
 \partopsep\z@\parsep\z@\itemsep\z@
 \trivlist \item\relax
  \if@minipage\else
   \vskip\baselineskip
   \vskip-\verbatimbaselineskip
%  \vskip\parskip
  \fi
  \leftskip\@totalleftmargin
  \if@minipage\else
   \advance \leftskip by \verbatimleftmargin
  \fi
  \rightskip\z@skip
  \parindent\z@\parfillskip\@flushglue\parskip\z@skip
  \@@par
  \@tempswafalse
  \def\par{%
    \if@tempswa
      \leavevmode \null \@@par\penalty\interlinepenalty
    \else
      \@tempswatrue
      \ifhmode\@@par\penalty\interlinepenalty\fi
    \fi}%
  \let\do\@makeother \dospecials
  \obeylines 
   \verbatimsize \baselineskip\verbatimbaselineskip
   \verbatim@font \@noligs
  \everypar \expandafter{\the\everypar \unpenalty}%
}

%% \def\verbatim@font{\normalfont\ttfamily}

%% from latex.ltx
\def\@item[#1]{%
  \if@noparitem
    \@donoparitem
  \else
    \if@inlabel
      \indent \par
    \fi
    \ifhmode
      \unskip\unskip \par
    \fi
    \if@newlist
      \if@nobreak
        \@nbitem
      \else
        \addpenalty\@beginparpenalty
        \addvspace\@topsep
        \addvspace{-\parskip}%
      \fi
    \else
      \addpenalty\@itempenalty
      \addvspace\itemsep
    \fi
    \global\@inlabeltrue
  \fi
  \everypar{%
    \@minipagefalse
    \global\@newlistfalse
    \if@inlabel
      \global\@inlabelfalse
      {\setbox\z@\lastbox
       \ifvoid\z@
         \kern-\itemindent
       \fi}%
      \box\@labels
      \penalty\z@
    \fi
    \if@nobreak
      \@nobreakfalse
      \clubpenalty\z@ %% \@M --> \z@
    \else
      \clubpenalty \@clubpenalty
      \everypar{}%
    \fi}%
  \if@noitemarg
    \@noitemargfalse
    \if@nmbrlist
      \refstepcounter\@listctr
    \fi
  \fi
  \sbox\@tempboxa{\makelabel{#1}}%
  \global\setbox\@labels\hbox{%
    \unhbox\@labels
    \hskip \itemindent
    \hskip -\labelwidth
    \hskip -\labelsep
    \ifdim \wd\@tempboxa >\labelwidth
      \box\@tempboxa
    \else
      \hbox to\labelwidth {\unhbox\@tempboxa}%
    \fi
    \hskip \labelsep}%
  \ignorespaces
}

\newcounter{figure}
\renewcommand{\thefigure}{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\,\thefigure}
\newenvironment{figure}
               {\floatenv
                \if@referee\capwidth.66\textwidth\else\capwidth\hsize\fi
                \abovecaptionskip4\p@\belowcaptionskip\z@\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\floatenv\capwidth.66\textwidth
                \abovecaptionskip4\p@\belowcaptionskip\z@\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand{\thetable}{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename~\thetable}
\newenvironment{table}
               {\floatenv
                \if@referee\capwidth.66\textwidth\else\capwidth\hsize\fi
                \abovecaptionskip\z@\belowcaptionskip3\p@\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\floatenv\capwidth.66\textwidth
                \abovecaptionskip\z@\belowcaptionskip3\p@\@dblfloat{table}}
               {\end@dblfloat}

\def\@floatboxreset {%
        \reset@font
        \footnotesize
        \@setminipage
}

\def\floatenv{\footnotesize\let\center\Center}

\def\Center{\topsep\z@\parsep\z@\partopsep\z@\itemsep\z@
 \trivlist \centering\item\relax}
\def\endCenter{\endtrivlist}

\long\def\@caption#1[#2]#3{\par
 \begingroup
  \@parboxrestore
  \if@minipage
   \@setminipage
  \fi
   \footnotesize
   \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
 \endgroup}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\newdimen\capwidth

\long\def\@makecaption#1#2{%
 \vskip\abovecaptionskip
 \setbox\@tempboxa\hbox{\shortstack[l]{{\bfseries #1}\hskip4mm #2}}%
 \@tempdima=\ht\@tempboxa \advance \@tempdima \dp\@tempboxa
 \ifdim \@tempdima > \baselineskip
  \ifdim \wd\@tempboxa >\capwidth
   \hfil\parbox[t]{\capwidth}{{\bfseries #1}\hskip4mm #2}%
  \else
   \hfil\parbox[t]{\wd\@tempboxa}{{\bfseries #1}\hskip4mm #2}%
  \fi
 \else
  \ifdim \wd\@tempboxa > \capwidth
   \hfil\parbox[t]{\capwidth}{{\bfseries #1}\hskip4mm #2}%
  \else
   \hbox to\hsize{\hss\box\@tempboxa\hss}%
  \fi
 \fi
 \vspace{\belowcaptionskip}%
}

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}

\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.1mm}
\renewcommand{\theequation}{\@arabic\c@equation}

%% for 2.1.4 compatibility
\@ifundefined{reDeclareMathAlphabet}{%
 \def\reDeclareMathAlphabet#1#2#3{%
  \DeclareRobustCommand{#1}[1]{%
    \ifmmode
      \ifx\math@bgroup\@empty % 2.09 compatibility
        #2\relax#3\relax##1\relax
      \else % native mode
        \ifx\math@bgroup\relax % oldstyle
          #2\relax\@fontswitch\relax{#3}##1\relax
        \else
          #2{#3{##1}}%
        \fi
      \fi
    \else
      #2{##1}%
    \fi
  }%
 }%
 \@onlypreamble\reDeclareMathAlphabet
 }{}

\@ifundefined{mathmc}{}{%
 \if@enablejfam
  \if@compatibility\else
    \DeclareSymbolFont{mincho}{\kenc@JYn}{mc}{m}{n}
    \DeclareSymbolFontAlphabet{\mathmc}{mincho}
    \SetSymbolFont{mincho}{bold}{\kenc@JYn}{gt}{m}{n}
    \jfam\symmincho
    \DeclareMathAlphabet{\mathgt}{\kenc@JYn}{gt}{m}{n}
  \fi
  \if@mathrmmc
    \AtBeginDocument{%
    \reDeclareMathAlphabet{\mathrm}{\mathrm}{\mathmc}
    \reDeclareMathAlphabet{\mathbf}{\mathbf}{\mathgt}
  }%
  \fi
 \else
  \DeclareRobustCommand{\mathmc}{%
    \@latex@error{Command \noexpand\mathmc invalid with\space
       `disablejfam' class option.}\@eha
  }
  \DeclareRobustCommand{\mathgt}{%
    \@latex@error{Command \noexpand\mathgt invalid with\space
       `disablejfam' class option.}\@eha
  }
 \fi
}

\@ifundefined{mathmc}{\relax}{%
 \DeclareOldFontCommand{\mc}{\normalfont\mcfamily}{\mathmc}%
 \DeclareOldFontCommand{\gt}{\normalfont\gtfamily}{\mathgt}%
}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*{\cal}{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*{\mit}{\@fontswitch\relax\mathnormal}

\newdimen\bibindent
\setlength\bibindent{1.5em}
\newcommand{\newblock}{\hskip .11em\@plus.33em\@minus.07em}

\newenvironment{thebibliography}[1]
 {\section*{\footnotesize\bfseries\refname}%
   \list{\@biblabel{\@arabic\c@enumiv}}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}%
         \parskip\z@
	 \topsep\z@\parsep\z@\partopsep\z@
         \itemsep\z@
         \footnotesize\baselineskip3.5mm
         \if@referee
          \baselineskip1.2\baselineskip
         \fi
   \sloppy
   \clubpenalty\z@
   \@clubpenalty\clubpenalty
   \widowpenalty\z@
   \sfcode`\.\@m}
  {\def\@noitemerr
    {\@latex@warning{Empty `thebibliography' environment}}%
   \endlist}
\def\@biblabel#1{[#1]}
\let\@openbib@code\@empty

\newcounter{profile}
\def\profile{\@ifstar{\np@profile}{\@ifnextchar[%% ]
 {\sp@profile}{\nsp@profile}}}

\def\np@profile#1#2{%
 \raggedbottom
 \refstepcounter{profile}%
 \ifnum\c@profile >\@ne
 \else
  \vspace{21mm}\par
 \fi
  \footnotesize\baselineskip3.5mm
  \noindent
  {\bfseries #1}\hskip6mm \@plus 1.5mm \@minus 1.5mm
   \ignorespaces #2\par
  \vspace{10mm}%
}

\long\def\nsp@profile#1#2{%
 \raggedbottom
 \refstepcounter{profile}%
 \ifnum\c@profile >\@ne
 \else
  \vspace{21mm}\par
 \fi
  \parindent\z@
   \setbox\@tempboxa\hbox{%
    \begin{minipage}[t]{\columnwidth}
     \footnotesize\baselineskip3.5mm \hbadness8000\relax
     \leavevmode\rlap{\smash{\unitlength 1mm\begin{picture}(25,33)
      \put(-30,-31){\framebox(25,33){\null}}\end{picture}}}%
     \hangindent30mm\hangafter-11\relax
      {\bfseries #1}%
        \hskip6mm \@plus 1.5mm \@minus 1.5mm\ignorespaces #2%
    \end{minipage}%
   }%
    \@tempdima\ht\@tempboxa
    \advance \@tempdima \dp\@tempboxa
    \ifdim\@tempdima<34.5mm
      \vtop to 32mm{%
       \IfFileExists{a\the\c@profile.\ieice@in@ext}
        {\leavevmode\smash{\llap{\lower31.5mm\hbox to 30mm{%
          \resizebox{25mm}{!}{%
           \includegraphics{a\the\c@profile.\ieice@in@ext}}%
         \hss}}}%
        }%
        {\leavevmode\smash{\rlap{\unitlength 1mm
          \begin{picture}(25,33)
           \put(-30,-31){\framebox(25,33){\null}}%
          \end{picture}%
         }}%
        }%
       \footnotesize\baselineskip3.5mm\hbadness8000\relax
       \hangindent30mm\hangafter-11\relax
        {\bfseries #1}\hskip6mm \@plus 1.5mm \@minus 1.5mm
          \ignorespaces #2%
       \vss
      }%
    \else
      \IfFileExists{a\the\c@profile.\ieice@in@ext}
       {\leavevmode\smash{\llap{\lower31.5mm\hbox to 30mm{%
         \resizebox{25mm}{!}{\includegraphics{a\the\c@profile.\ieice@in@ext}}%
        \hss}}}%
       }%
       {\leavevmode\smash{\rlap{\unitlength 1mm
         \begin{picture}(25,33)
          \put(-30,-31){\framebox(25,33){\null}}%
         \end{picture}%
        }}%
       }%
      \footnotesize\baselineskip3.5mm\hbadness8000\relax
      \hangindent30mm\hangafter-11\relax
       {\bfseries #1}\hskip6mm \@plus 1.5mm \@minus 1.5mm
         \ignorespaces #2%
    \fi
  \par
 \vspace{10mm}%
}

\long\def\sp@profile[#1]#2#3{%
 \raggedbottom
 \refstepcounter{profile}%
 \ifnum\c@profile >\@ne
 \else
  \vspace{21mm}\par
 \fi
  \parindent\z@
   \setbox\@tempboxa\hbox{%
    \begin{minipage}[t]{\columnwidth}
     \footnotesize\baselineskip3.5mm \hbadness 8000\relax
     \leavevmode\rlap{\smash{\unitlength 1mm\begin{picture}(25,33)
      \put(-30,-31){\framebox(25,33){\null}}\end{picture}}}%
     \hangindent30mm\hangafter-11\relax
      {\bfseries #2}%
        \hskip6mm \@plus 1.5mm \@minus 1.5mm\ignorespaces #3\end{minipage}%
   }%
    \@tempdima\ht\@tempboxa
    \advance \@tempdima \dp\@tempboxa
    \ifdim\@tempdima<34.5mm
     \vtop to 32mm{%
      \leavevmode\smash{\llap{\lower31.5mm\hbox to 30mm{%
       \resizebox{25mm}{!}{\includegraphics{#1}}%
        \hss}}}%
      \footnotesize\baselineskip3.5mm\hbadness8000\relax
      \hangindent30mm\hangafter-11\relax
      {\bfseries #2}\hskip6mm \@plus 1.5mm \@minus 1.5mm
        \ignorespaces #3%
      \vss
     }%
    \else
     \leavevmode\smash{\llap{\lower31.5mm\hbox to 30mm{%
      \resizebox{25mm}{!}{\includegraphics{#1}}%
       \hss}}}%
     \footnotesize\baselineskip3.5mm\hbadness8000\relax
     \hangindent30mm\hangafter-11\relax
     {\bfseries #2}\hskip6mm \@plus 1.5mm \@minus 1.5mm
       \ignorespaces #3%
    \fi
  \par
 \vspace{10mm}%
}

\if@letter
 \let\np@profile\@gobbletwo
 \let\nsp@profile\@gobbletwo
 \long\def\sp@profile[#1]#2#3{}
\fi

\renewcommand{\footnoterule}{%
  \kern-3\p@
  \hrule width \columnwidth
  \kern 2.6\p@}
%\@addtoreset{footnote}{page}
\IfFileExists{pfnote.sty}{\RequirePackage{pfnote}}{}

%%\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}
\newcommand\@makefntext[1]{\small
 \parindent 2em
 \noindent\hb@xt@2em{\hss \@makefnmark}#1}

%\def\thefootnote{\fnsymbol{footnote}}
\renewcommand\thefootnote{\@fnsymbol\c@footnote}%

\def\@fnsymbol#1{\ensuremath{%
 \ifcase#1\or
  {\dagger}\or
  {\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}{\dagger}{\dagger}\or 
  {*}\or {*}{*}\or {*}{*}{*}\or 
  {*}{*}{*}{*}\or {*}{*}{*}{*}{*}\or {*}{*}{*}{*}{*}{*}\else
   \@ctrerr\fi}%
}
%% mathTimePlus redefines \@fnsymbol. 
\let\ieice@fn@fnsymbol\@fnsymbol

\def\ieice@fnsymbol#1{%
 \ifcase#1\or
  {\dagger}\or
  {\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}{\dagger}\or
  {\dagger}{\dagger}{\dagger}{\dagger}{\dagger}{\dagger}\or 
  {*}\or {*}{*}\or {*}{*}{*}\or 
  {*}{*}{*}{*}\or {*}{*}{*}{*}{*}\or {*}{*}{*}{*}{*}{*}\else
   \@ctrerr\fi
}

\def\@begintheorem#1#2{%
 \topsep\@hlskip
 \parsep\z@\partopsep\z@\itemsep\z@
  \trivlist
   \item[\hskip \labelsep{\bfseries #1\ #2:\ }]}
\def\@opargbegintheorem#1#2#3{%
 \topsep\@hlskip
 \parsep\z@\partopsep\z@\itemsep\z@
  \trivlist
      \item[\hskip \labelsep{\bfseries #1\ #2}\ (#3):\ ]}
\def\@endtheorem{\endtrivlist}

%% from citesort.sty, a little customized
\newcount\@minsofar
\newcount\@min
\newcount\@cite@temp
\def\@citex[#1]#2{%
\if@filesw \immediate \write \@auxout {\string \citation {#2}}\fi
\@tempcntb\m@ne \let\@h@ld\relax \def\@citea{}%
\@min\m@ne%
\@cite{%
  \@for \@citeb:=#2\do {\@ifundefined {b@\@citeb}%
    {\@h@ld\@citea\@tempcntb\m@ne\textbf{?}%% {\bf ?}
    \@warning {Citation `\@citeb ' on page \thepage \space undefined}}%
{\@minsofar\z@ \@for \@scan@cites:=#2\do {%
  \@ifundefined{b@\@scan@cites}%
    {\@cite@temp\m@ne}
    {\@cite@temp\number\csname b@\@scan@cites \endcsname \relax}%
 \ifnum\@cite@temp > \@min% select the next one to list
    \ifnum\@minsofar = \z@
      \@minsofar\number\@cite@temp
      \edef\@scan@copy{\@scan@cites}\else
    \ifnum\@cite@temp < \@minsofar
      \@minsofar\number\@cite@temp
      \edef\@scan@copy{\@scan@cites}\fi\fi\fi}\@tempcnta\@min
  \ifnum\@minsofar > \z@ % some more
    \advance\@tempcnta\@ne
    \@min\@minsofar
    \ifnum\@tempcnta=\@minsofar %   Number follows previous--hold on to it
      \ifx\@h@ld\relax
        \edef \@h@ld{\@citea\csname b@\@scan@copy\endcsname}%
      \else %% [
       \edef\@h@ld{\ifmmode{]\mbox{--}\allowbreak [}%
        \else ]--\allowbreak[\fi %% ]
         \csname b@\@scan@copy\endcsname}%
      \fi
    \else \@h@ld\@citea\csname b@\@scan@copy\endcsname
          \let\@h@ld\relax
  \fi % no more
 \fi}%
  \def\@citea{%% [
   ],\,\allowbreak[}}\@h@ld}{#1}% ]
}

%% from fleqn.clo
%%\ProvidesFile{fleqn.clo}
%%        [1996/07/26 v1.1b Standard LaTeX option
%%                                 (flush left equations)]
\newdimen\mathindent
\AtEndOfClass{\mathindent7mm}
\renewcommand\[{\relax
                \ifmmode\@badmath
                \else
                 \partopsep 2\p@ \@plus 1\p@ \@minus 1\p@
                 \parsep  4\p@ \@plus2\p@ \@minus\p@
                 \topsep  8\p@ \@plus2\p@ \@minus4\p@
                 \itemsep 4\p@ \@plus2\p@ \@minus\p@
                  \begin{trivlist}%
                    \@beginparpenalty\predisplaypenalty
                    \@endparpenalty\postdisplaypenalty
                    \item[]\leavevmode
                    \hb@xt@\linewidth\bgroup $\m@th\displaystyle %$
                      \hskip\mathindent\bgroup
                \fi}
\renewcommand\]{\relax
                \ifmmode
                      \egroup $\hfil% $
                    \egroup
                  \end{trivlist}%
                \else \@badmath
                \fi}
\renewenvironment{equation}%
    {\@beginparpenalty\predisplaypenalty
     \@endparpenalty\postdisplaypenalty
     \refstepcounter{equation}%
     \partopsep 2\p@ \@plus 1\p@ \@minus 1\p@
     \parsep  4\p@ \@plus2\p@ \@minus\p@
     \topsep  8\p@ \@plus2\p@ \@minus4\p@
     \itemsep 4\p@ \@plus2\p@ \@minus\p@
     \trivlist \item[]\leavevmode
       \hb@xt@\linewidth\bgroup $\m@th% $
         \displaystyle
         \hskip\mathindent}%
        {$\hfil % $
         \displaywidth\linewidth\hbox{\@eqnnum}%
       \egroup
     \endtrivlist}
\renewenvironment{eqnarray}{%
    \stepcounter{equation}%
    \def\@currentlabel{\p@equation\theequation}%
    \global\@eqnswtrue\m@th
    \global\@eqcnt\z@
    \tabskip\mathindent
    \let\\=\@eqncr
    \partopsep 2\p@ \@plus 1\p@ \@minus 1\p@
    \topsep  8\p@ \@plus2\p@ \@minus4\p@
    \setlength\abovedisplayskip{\topsep}%
    \ifvmode
      \addtolength\abovedisplayskip{\partopsep}%
    \fi
    \addtolength\abovedisplayskip{\parskip}%
    \setlength\belowdisplayskip{\abovedisplayskip}%
    \setlength\belowdisplayshortskip{\abovedisplayskip}%
    \setlength\abovedisplayshortskip{\abovedisplayskip}%
    $$\everycr{}\halign to\linewidth% $$
    \bgroup
      \hskip\@centering
      $\displaystyle\tabskip\z@skip{##}$\@eqnsel&%
      \global\@eqcnt\@ne \hskip.8\arraycolsep \hfil${##}$\hfil&%
      \global\@eqcnt\tw@ \hskip.8\arraycolsep
        $\displaystyle{##}$\hfil \tabskip\@centering&%
      \global\@eqcnt\thr@@
        \hb@xt@\z@\bgroup\hss##\egroup\tabskip\z@skip\cr}%
      {\@@eqncr
    \egroup
    \global\advance\c@equation\m@ne$$% $$
    \@ignoretrue
    }
%%
%% End of file `fleqn.clo'.

%%\newcommand\contentsname{Contents}
%%\newcommand\listfigurename{List of Figures}
%%\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
%%\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
%%\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
%%\newcommand\abstractname{Abstract}

\def\onelineskip{\par\vspace{1\baselineskip}\par}
\def\halflineskip{\par\vspace{.5\baselineskip}\par}

\def\FRAC#1#2{\leavevmode\kern-.1em
  \raise.5ex\hbox{\the\scriptfont0 #1}\kern-.1em
  /\kern-.15em\lower.25ex\hbox{\the\scriptfont0 #2}}
\def\RN#1{\uppercase\expandafter{\romannumeral#1}}
\def\ddash{\leavevmode\hbox to 1.95em{\hfil ---\hss ---\hfil}}

\def\QED{{\unskip\nobreak\hfil\penalty50
 \hskip1em\hbox{}\nobreak\hfil $\Box$\parfillskip\z@
 \finalhyphendemerits\z@\par}}

\@ifundefined{kanjiskip}{}{%
 \postbreakpenalty"5C=10000 %%"
}
\def\sloppy{\tolerance9999\hbadness4000\hfuzz1\p@ \vfuzz1\p@}
\hbadness4000
\vbadness10001
\clubpenalty\z@
\widowpenalty\z@

\AtBeginDocument{%
 \@tempcnta \hold@vol\relax
 \advance \@tempcnta 1917\relax
 \xdef\month@year{\ifcase\hold@no\relax XXXX\or 
  JANUARY\or FEBRUARY\or MARCH\or APRIL\or MAY\or JUNE\or
  JULY\or AUGUST\or SEPTEMBER\or OCTOBER\or NOVEMBER\or DECEMBER\fi
  \ 
  \ifnum \@tempcnta=1917\relax
   200x%
  \else
   \the\@tempcnta
  \fi
 }%
 \if@referee
  \baselineskip1.2\baselineskip
 \fi
 %% amsmath
 \displaywidowpenalty\z@
 \interdisplaylinepenalty\z@
 \predisplaypenalty\z@
 \postdisplaypenalty\z@
 %% no use of cmex7,8,9
 \@ifundefined{cmex@opt}{%
  \DeclareFontFamily{OMX}{cmex}{}{}%
  \DeclareFontShape{OMX}{cmex}{m}{n}{%
   <->    cmex10
  }{}%
 }{%
  \ifnum\cmex@opt=7\relax
   \DeclareFontFamily{OMX}{cmex}{}{}%
   \DeclareFontShape{OMX}{cmex}{m}{n}{%
    <->    cmex10
   }{}%
  \fi
 }%
 %%
 \@ifundefined{maketag@@@}{}
  {%
   \multlinegap7mm
   \@mathmargin7mm \@plus\z@ \@minus\z@
  }%
 %% nidanfloat
 \@ifundefined{dblbotfraction}{}{%
  \renewcommand\dblbotfraction{0.9}% 0.5
  \setcounter{dblbotnumber}{4}% 2
 }%
 %% here.sty
 \@ifundefined{@HHfloat}{}{%
  \def\@HHfloat#1[H]{%
   \expandafter\let\csname end#1\endcsname\end@Hfloat
   \vskip\intextsep
   \vbox\bgroup\def\@captype{#1}\parindent\z@
   \@floatboxreset %% added
   \ignorespaces}%
  \def\end@Hfloat{\egroup\vskip-1em %% added
   \vskip \intextsep}%
 }%
 %% eps/pdf
 \@ifundefined{ver@dvips.def}{\def\ieice@in@ext{pdf}}{\def\ieice@in@ext{eps}}%
 %% newtxtext, nfssext-cfr and superiors redefine \@makefnmark.
 \@ifundefined{sustyle}{}{%
  \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}%
 }%
}

%\AtEndDocument{%
% \if@cameraready
% \else
%  \@ifundefined{EICMN@1}{}{%
%   \onecolumn
%   \thispagestyle{empty}
%   \@Membership@Number
%  }%
% \fi
%}

\iftombow\else
\AtBeginDvi{\special{papersize=210mm,280mm}}
\fi

\pagestyle{IEICE}
\pagenumbering{arabic}
\if@referee\else
 \twocolumn
 \sloppy
 \flushbottom
\fi
\@mparswitchtrue

\if@cameraready
 \RequirePackage{ieice-macros}
 \input{ieice-hyphen.tex}
\fi

\endinput
