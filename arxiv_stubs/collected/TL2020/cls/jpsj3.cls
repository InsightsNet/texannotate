%========================== jpsj3.cls =============================
%
%-for Journal of the Physical Society of Japan %
% Based on jpsj.sty ver. 1.1
% Version 2.1.1
%-Released on August 2009
%-Revised on May 2010
%-Revised on April 2011
%-Revised on September 2011
%=================================================================

\typeout{***** Document Class =<<<jpsj3.cls>>>= ver. 2.1.1 ******}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{jpsj3}[2011/09/09 v.2.1.1 JPSJ document class]

\RequirePackage{amsmath}[1997/03/20]
\RequirePackage{amssymb}
\RequirePackage{graphicx}
\RequirePackage{overcite}
\renewcommand\citeright{)}
\def\@citess#1{\textsuperscript{#1\citeright}}

\def\jpsj@warning{\ClassWarningNoLine{jpsj3}}
\def\jpsjversion{2.1.1}

\newif\if@ip
\DeclareOption{ip}{\@iptrue}
\newif\if@st
\DeclareOption{st}{\@sttrue}
\newif\if@l
\DeclareOption{letter}{\@ltrue}
\newif\if@fp
\DeclareOption{fp}{\@fptrue}
\newif\if@sn
\DeclareOption{shortnote}{\@sntrue}
\newif\if@comment
\DeclareOption{comment}{\@commenttrue}
\newif\if@addenda
\DeclareOption{addenda}{\@addendatrue}
\newif\if@errata
\DeclareOption{errata}{\@erratatrue}

\newif\if@ack

\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}

\newif\if@lp
\DeclareOption{letterpaper}
   {\@lptrue%
    \setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}

\newif\if@seceq
\DeclareOption{seceq}{%
\@seceqtrue
}

\DeclareOption{twocolumn}{\@twocolumntrue
% To balance the final page,
% following code is borrowed from nicetwocolumn style
\newdimen\dimen@@

\def\balancecolumns{\setbox0\vbox{\unvbox\@outputbox} \dimen@@=\ht0
   \advance\dimen@@ by\topskip \advance\dimen@@ by-\baselineskip
   \divide\dimen@@ by2 \splittopskip=\topskip
   {\vbadness=10000 \loop \global\setbox3=\copy0
     \global\setbox1=\vsplit3 to\dimen@@
     \ifdim\ht3>\dimen@@ \global\advance\dimen@@ by1pt\repeat}
   \ifdim\dimen@@>\textheight \dimen@@=\textheight\fi
   \setbox0=\vbox to \dimen@@{\unvbox1} \setbox2=\vbox to \dimen@@{\unvbox3}
   \if\ht0>\ht2 \setbox2=\vbox to\ht0{\unvbox2}\dimen@@=\ht0\else
   \if\ht2>\ht0 \setbox0=\vbox to\ht2{\unvbox0}\dimen@@=\ht2\fi\fi
  \wd0=\hsize \wd2=\hsize
%\message{in balancecolumns dimen@@=\the\dimen@@, dp0=\the\dp0, dp2=\the\dp2}
\ifdim\dp0>\dp2\advance\dimen@@ by\dp0\else\advance\dimen@@ by\dp2\fi
\setbox\@outputbox\vbox to\dimen@@{\hbox to\textwidth{\box0\hfil\box2}\vfill}}

% you can refrain from balancing by falsifying following switch!
\newif\if@lastpagebalancing \@lastpagebalancingtrue % default is to balance

% incorporate balanced output to \enddocument
\def\enddocument{\if@lastpagebalancing \global\let\@outputdblcol=\balancing@outputdblcol\fi%
\@checkend{document}\clearpage
\begingroup  
\if@filesw \immediate\closeout\@mainaux 
\def\global\@namedef##1##2{}\def\newlabel{\@testdef r}%
\def\bibcite{\@testdef b}\@tempswafalse \makeatletter\input \jobname.aux
\if@tempswa \@warning{Label(s) may have changed.  Rerun to get
cross-references right}\fi\fi\endgroup
\deadcycles\z@\@@end}

\newlength{\@interlinegap}

% to change \interlinegap appropriately at appropriate time
\def\@outputdblcol{\if@firstcolumn \global\@firstcolumnfalse
    \global\setbox\@leftcolumn\box\@outputbox
% Following interlinegap value may be wrong!!
% It is set to gap+depth for normalsize, and depth(2.031999Q) for footnotesize.
% This setting is inconsistent, but seems to work properly now.
%\ifx \@currsize\normalsize \global\@interlinegap 8.54815pt\else% setup
% reset to 10Q after final page footnote hack!
\ifx \@currsize\normalsize \global\@interlinegap \z@\else %%%12\p@\else% setup
 \ifx \@currsize\footnotesize \global\@interlinegap 3\p@\else% appropriate
  \ifx \@currsize\small \global\@interlinegap 3.08713pt\fi\fi\fi% gap here!
  \else \global\@firstcolumntrue
\if@leftfootnoteexist\setbox\@leftcolumn\vbox to\@colht{\boxmaxdepth\maxdepth
\@texttop\dimen128=\dp\@leftcolumn
\unvbox\@leftcolumn\vskip\skip\footins\footnoterule%
%\message{in outputdblcol leftcolumnfootnote=ht:\the\ht\@leftcolumnfootnote, dp:\the\dp\@leftcolumnfootnote, wd:\the\wd\@leftcolumnfootnote}
\unvbox\@leftcolumnfootnote
\vskip-\dimen128\@textbottom}
\global\maxdepth\@maxdepth\else
\setbox\@leftcolumn\vbox to\@colht{\boxmaxdepth\maxdepth
\@texttop\dimen128=\dp\@leftcolumn
\unvbox\@leftcolumn\vfill%
\vskip-\dimen128\@textbottom}
\global\maxdepth\@maxdepth\fi
\if@rightfootnoteexist\setbox\@outputbox\vbox to\@colht{\boxmaxdepth\maxdepth
\@texttop\dimen128=\dp\@outputbox
\unvbox\@outputbox\vskip\skip\footins\footnoterule%
%\message{in outputdblcol rightcolumnfootnote=ht:\the\ht\@rightcolumnfootnote, dp:\the\dp\@rightcolumnfootnote, wd:\the\wd\@rightcolumnfootnote}
\unvbox\@rightcolumnfootnote
\vskip-\dimen128\@textbottom}
\global\maxdepth\@maxdepth\else
\setbox\@outputbox\vbox to\@colht{\boxmaxdepth\maxdepth
\@texttop\dimen128=\dp\@outputbox
\unvbox\@outputbox\vfill%
\vskip-\dimen128\@textbottom}
\global\maxdepth\@maxdepth\fi
   \setbox\@outputbox\vbox{\hbox to\textwidth{\hbox to\columnwidth
     {\box\@leftcolumn \hss}\hfil \vrule width\columnseprule\hfil
      \hbox to\columnwidth{\box\@outputbox \hss}}}\@combinedblfloats
      \@outputpage \begingroup \@dblfloatplacement \@startdblcolumn
      \@whilesw\if@fcolmade \fi{\@outputpage\@startdblcolumn}\endgroup
   \fi}

\def\balancing@outputdblcol{\if@firstcolumn %\global\@firstcolumnfalse
 \else \global\@firstcolumntrue
  \setbox\@outputbox\vbox{\unvbox\@leftcolumn\vskip\@interlinegap%
   \penalty\interlinepenalty\unvbox\@outputbox}
 \fi
 \balancecolumns \@combinedblfloats
\if@leftfootnoteexist\setbox\@outputbox\vbox to\@colht{\boxmaxdepth\maxdepth
\@texttop\dimen128=\dp\@outputbox
\unvbox\@outputbox\vfill\vskip\skip\footins\footnoterule%
%\message{in balancing@outputdblcol leftcolumnfootnote=ht:\the\ht\@leftcolumnfootnote, dp:\the\dp\@leftcolumnfootnote, wd:\the\wd\@leftcolumnfootnote}
\unvbox\@leftcolumnfootnote
\if@rightfootnoteexist
%\message{in balancing@outputdblcol rightcolumnfootnote=ht:\the\ht\@rightcolumnfootnote, dp:\the\dp\@rightcolumnfootnote, wd:\the\wd\@rightcolumnfootnote}
\unvbox\@rightcolumnfootnote\fi
\vskip-\dimen128
\@textbottom}
\global\maxdepth\@maxdepth\fi
 \@outputpage \begingroup \@dblfloatplacement \@startdblcolumn
 \@whilesw\if@fcolmade \fi{\@outputpage\@startdblcolumn}\endgroup}

\newbox\@leftcolumnfootnote \newbox\@rightcolumnfootnote
\newif\if@leftfootnoteexist \newif\if@rightfootnoteexist

% Extra \@texttop somehow found its way into \@makecol.  Deleted
% 1 Dec 86.  (Found by Mike Harrison)

\def\@makecol{\if@firstcolumn
\ifvoid\footins \setbox\@outputbox\box\@cclv
%\message{in makecol @outputbox=(\the\ht\@outputbox, \the\dp\@outputbox, \the\wd\@outputbox)}
\global\@leftfootnoteexistfalse
   \else\global\@leftfootnoteexisttrue
\setbox\@outputbox\box\@cclv
%\message{in makecol with foot @outputbox=(\the\ht\@outputbox, \the\dp\@outputbox, \the\wd\@outputbox)}
\global\setbox\@leftcolumnfootnote\box\footins
%\message{in makecol leftcolumnfootnote=ht:\the\ht\@leftcolumnfootnote, dp:\the\dp\@leftcolumnfootnote, wd:\the\wd\@leftcolumnfootnote}
\fi
     \xdef\@freelist{\@freelist\@midlist}\gdef\@midlist{}\@combinefloats
\else
\ifvoid\footins \setbox\@outputbox\box\@cclv
%\message{in makecol right @outputbox=(\the\ht\@outputbox, \the\dp\@outputbox, \the\wd\@outputbox)}
\global\@rightfootnoteexistfalse
   \else\global\@rightfootnoteexisttrue
\setbox\@outputbox\box\@cclv
%\message{in makecol right with foot @outputbox=(\the\ht\@outputbox, \the\dp\@outputbox, \the\wd\@outputbox)}
\global\setbox\@rightcolumnfootnote\box\footins
%\message{in makecol rightcolumnfootnote=ht:\the\ht\@rightcolumnfootnote, dp:\the\dp\@rightcolumnfootnote, wd:\the\wd\@rightcolumnfootnote}
\fi
     \xdef\@freelist{\@freelist\@midlist}\gdef\@midlist{}\@combinefloats
\fi
	}
}

\ExecuteOptions{a4paper}
\ProcessOptions\relax

\allowdisplaybreaks[4]

\frenchspacing
\@twosidetrue
\AtBeginDocument\sloppy
\AtEndDocument{\label{lastpage}}

\def\@typeset{\sffamily Typeset with jpsj3.cls $<$ver.{\space}\jpsjversion$>$}
\def\@jpsjmark{J.{\space}Phys.{\space}Soc.{\space}Jpn.}
\def\@JPSJmark{Journal of the Physical Society of Japan}
\def\@fpmark{\textbf{FULL PAPERS}}
\def\@ipmark{\textbf{INVITED REVIEW PAPERS}}
\def\@stmark{\textbf{SPECIAL TOPICS}}
\def\@lmark{\textbf{LETTERS}}
\def\@snmark{\textbf{SHORT NOTES}}
\def\@cmmark{\textbf{COMMENTS}}
\def\@admark{\textbf{ADDENDA}}
\def\@ermark{\textbf{ERRATA}}
\def\@draftmark{\textbf{DRAFT}}
\@ifundefined{jpage}{\def\jpage{Vol.\ No.\ pp.}}{}
\@ifundefined{runtitle}{\def\runtitle{Title of the Article}}{}
\@ifundefined{runauthor}{\relax}{}
%\def\runauthor{Author Name}}{}
\@ifundefined{pvol}{\def\pvol{\null}}{}
\@ifundefined{pyear}{\def\pyear{\null}}{}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

\let\makefigurecaptions\relax

\newcommand{\degC}{\mbox{$^{\circ}$C}}
\newcommand\mbi[1]{\boldsymbol{#1}}
\newcommand\mib[1]{\boldsymbol{#1}}
\newcommand{\address}{\relax}
\newcommand{\name}{\relax}
\newcommand{\surname}[1]{\textsc{#1}}
\newcommand{\note}{\relax}
\newcommand{\mathendash}{\mbox{--}}

\DeclareMathOperator{\textIm}{Im}
\DeclareMathOperator{\textRe}{Re}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\Tr}{Tr}

\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{1}
\setlength\parskip{\z@}

\if@twocolumn
\setlength{\textwidth}{504\p@}
\setlength{\textheight}{720\p@}
\setlength{\columnsep}{14\p@}
\hoffset-23.5\p@
%\setlength\oddsidemargin{-1cm}
%\setlength\evensidemargin{-1cm}
\setlength\topmargin{-1.2cm}
\setlength\headheight{8\p@}
\setlength\headsep{10\p@} 
\setlength\topskip{24\p@}
\setlength\parindent{10\p@}
\setlength\footskip{20\p@}
\else
\setlength{\textwidth}{444\p@}
\setlength{\textheight}{660\p@}
\hoffset5\p@
\if@lp
\voffset-1.2cm
\else
\voffset-.5cm
\fi
\setlength\headheight{10\p@}
\setlength\headsep{12\p@} 
\setlength\topskip{24\p@}
\setlength\parindent{18\p@}
\setlength\footskip{36\p@}
\fi
\addtolength\textheight{\topskip}

\setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep    {24\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\textfloatsep{24\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\intextsep   {24\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\dblfloatsep    {24\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\dbltextfloatsep{24\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{\z@}

\setlength\arraycolsep {6\p@} 
\setlength\tabcolsep {6\p@}
\setlength\arrayrulewidth {.25\p@}
\setlength\doublerulesep {2\p@}
\setlength\tabbingsep {\labelsep}
\setlength\fboxsep{3\p@} 
\setlength\fboxrule {.2\p@}
\setlength\marginparwidth {.75\p@} 
\setlength\marginparsep {12\p@}

\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301

\setcounter{topnumber}{5}
\renewcommand\topfraction{.9}
\setcounter{bottomnumber}{5}
\renewcommand\bottomfraction{.9}
\setcounter{totalnumber}{10}
\renewcommand\textfraction{.1}
\renewcommand\floatpagefraction{.9}
\setcounter{dbltopnumber}{3}
\renewcommand\dbltopfraction{.9}
\renewcommand\dblfloatpagefraction{.1}

\newcommand\abstsize{%
   \@setfontsize\abstsize\@xpt{14}%
}

\renewcommand\normalsize{%
   \if@twocolumn
   \@setfontsize\normalsize\@xpt{12}
   \else
   \@setfontsize\normalsize\@xiipt{20}
   \fi
   \abovedisplayskip 6\p@
   \abovedisplayshortskip 6\p@
   \belowdisplayshortskip 6\p@
   \belowdisplayskip \abovedisplayskip
   \setlength\jot{6\p@}
   \let\@listi\@listI}
\normalsize
\newcommand\small{%
   \if@twocolumn
   \@setfontsize\small\@ixpt{11}
   \else
   \@setfontsize\small\@xpt{16}%
   \fi
   \abovedisplayskip 6\p@
   \abovedisplayshortskip \abovedisplayskip
   \belowdisplayshortskip \abovedisplayskip
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@ %%%%% 4\p@ \@plus2\p@ \@minus2\p@
               \parsep \z@ %%%%% 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\footnotesize{%
   \if@twocolumn
   \@setfontsize\footnotesize\@viiipt{10}
   \else
   \@setfontsize\footnotesize\@xpt{14}%
   \fi
   \abovedisplayskip 5\p@
   \abovedisplayshortskip \abovedisplayskip
   \belowdisplayshortskip \abovedisplayskip
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@ %%%%% 3\p@ \@plus\p@ \@minus\p@
               \parsep \z@ %%%%% 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\scriptsize{%
    \if@twocolumn
    \@setfontsize\scriptsize\@viipt\@ixpt
      \else
    \@setfontsize\scriptsize\@viiipt\@ixpt
    \fi
}
\newcommand\tiny{%
    \if@twocolumn
     \@setfontsize\tiny\@vipt\@viiipt
       \else
     \@setfontsize\tiny\@viipt\@viiipt
     \fi
}
\newcommand\large{%
    \if@twocolumn
      \@setfontsize\large\@xiipt{16}
        \else
      \@setfontsize\large\@xivpt{20}
      \fi
}
\newcommand\Large{\@setfontsize\Large\@xviipt{22}}
\newcommand\LARGE{\@setfontsize\LARGE\@xxpt{25}}
\newcommand\huge{\@setfontsize\huge\@xxvpt{30}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
\newcommand\titlesize{\@setfontsize\titlesize\@xivpt{16}}

%%\@mparswitchfalse
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]

\renewcommand\thesection {\@arabic\c@section}
\renewcommand\thesubsection {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection {\thesubsection.\@arabic\c@subsubsection}
\renewcommand\theparagraph {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}

\if@seceq
\@addtoreset{equation}{section}
\renewcommand{\theequation}{%
 \ifnum\c@section>\z@\thesection.\fi \@arabic\c@equation}
\fi

\newcommand\@secapp{}

\newcommand\section{\@startsection{section}{1}{\z@}%
                   {\if@twocolumn 8\p@ \@plus\p@ \@minus\p@ \else .5\baselineskip \fi}%
                   {\if@twocolumn 4\p@ \@plus\p@ \@minus\p@ \else \p@ \fi}%
                   {\normalfont\normalsize\bfseries\boldmath}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                   {12\p@ \@plus \p@ \@minus \p@}{\p@}%
                   {\normalfont\normalsize\itshape}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                   {12\p@ \@plus \p@ \@minus \p@}{\p@}%
                   {\normalfont\normalsize\itshape}} 
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                   {\z@}{-10\p@}%
                   {\normalfont\if@ack\footnotesize\else\normalsize\fi\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{4}{\parindent}%
                   {\z@}{-10\p@}%
                   {\normalfont\normalsize\itshape}}

\def\@nullstring{}
\def\@appendixstring{Appendix}

\def\@sect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \def\@svsec{}\else
       \ifnum #2=1		% TRUE if \section{}
         \refstepcounter{#1}
         \def\@appendixtitle{#8}
         \ifx\@secapp\@appendixstring
         \ifx\@appendixtitle\@nullstring
             \edef\@svsec{\@secapp \csname the#1\endcsname\hskip10\p@}
         \else
             \edef\@svsec{\@secapp \csname the#1\endcsname:\hskip10\p@}
         \fi
         \else
           \ifx\thesection\@nullstring
             \edef\@svsec{\@secapp \csname the#1\endcsname\hskip10\p@}
           \else
             \edef\@svsec{\@secapp \csname the#1\endcsname.\hskip10\p@}
           \fi
         \fi
       \else
         \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname\hskip10\p@}
       \fi
     \fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
        \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M #8\par}%
        \endgroup
       \csname #1mark\endcsname{#7}
      \else
        \def\@svsechd{#6\hskip #3\@svsec #8\csname #1mark\endcsname{#7}}
      \fi
     \@xsect{#5}}

\setcounter{secnumdepth}{3}

\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{(\theenumi)}
\newcommand\labelenumii{\theenumii.}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}

\setlength\leftmargini {20\p@}
\setlength\leftmarginii {10\p@} 
\setlength\leftmarginiii {10\p@} 
\setlength\leftmarginiv {10\p@} 
\setlength\leftmarginv {10\p@}
\setlength\leftmarginvi {10\p@}
\setlength\leftmargin{\leftmargini}
\setlength\labelwidth{\leftmargini\advance\labelwidth-\labelsep}
\setlength\labelsep {5\p@} 
\setlength\parsep {\z@}
 
\def\@listi{\leftmargin\leftmargini
            \parsep 4\p@ \@plus2\p@ \@minus2\p@
            \topsep 4\p@ \@plus2\p@ \@minus2\p@
            \itemsep \z@ \@plus2\p@ \@minus2\p@}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    \z@ \@plus2\p@ \@minus\p@
              \parsep    \z@ \@plus2\p@ \@minus\p@
              \itemsep   \parsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    \z@ \@plus2\p@ \@minus\p@
              \parsep    \z@
              \partopsep \z@ \@plus2\p@ \@minus\p@
              \itemsep   \topsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}
 
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -15\p@%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 15\p@}%
                \item\relax}
               {\endlist}

\newenvironment{quotation}
               {\list{}{\listparindent 15\p@%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}

\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}

\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}

%%%% bibliography %%%%
\def\thebibliography#1{%
\if@twocolumn
\vskip2\baselineskip
\footnotesize
\hbox to\columnwidth{\hrulefill}\par
\else
\clearpage
\normalsize
\par\noindent\textbf{\refname}\par\vskip4\p@
\fi
\list{\arabic{enumi})}{\settowidth\labelwidth{[#1]}
 \leftmargin\labelwidth
 \advance\leftmargin\labelsep
 \usecounter{enumi}}
 \sloppy
 \sfcode`\.=500\relax}
\let\endthebibliography=\endlist

%%% profile %%%
\newcommand{\profile}[2]{%
		\if@twocolumn\vskip.5\baselineskip\footnotesize
		\else
		\clearpage
		\fi
		\noindent\textbf{#1}\quad{#2}
		\par\vskip1\baselineskip
}
%%%%%%%%%%%%%%%

\renewcommand\footnoterule{%
 \noindent\vskip1\baselineskip \kern-3\p@
 \hrule\@width\columnwidth
 \kern 2.6\p@}

\newcommand\refname{References}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\appendixname{Appendix}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{1em}
\setlength\belowcaptionskip{\z@} %{1em}

\newcount\halfflag
\halfflag=0

%%%%%%%%%% caption %%%%%%%%%%%
\long\def\@makecaption#1#2{%
\if@twocolumn
  \footnotesize
  \vskip\abovecaptionskip
  \setbox\@tempboxa\hbox{#1\hspace{8\p@}#2}
  \ifdim \wd\@tempboxa >\hsize
     \par\noindent
     	#1\hspace{8\p@}#2\par 
  \else 
  	\small
	\hbox to \hsize{\hfil\box\@tempboxa\hfil}
 \fi
\else
  \small
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1\hskip1em#2}%
  \ifdim \wd\@tempboxa > \hsize
  \par\noindent
    #1\hskip1em#2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip
\fi
}

\long\def\@caption#1[#2]#3{\par
     \begingroup
     \@parboxrestore
     \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}
     \par
     \endgroup
}

\newcounter{figure}
\def\thecaption{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\fnum@figure{{\bfseries\figurename\hskip.5em\thefigure.}}
\newcounter{table}
\def\thetable{\@Roman\c@table}
\def\fps@table{tbp}
\def\ftype@table{2} 
\def\fnum@table{{\bfseries\tablename\hskip.5em\thetable.}}

\newenvironment{figure}
               {\halfflag=1\@float{figure}}
               {\end@float}
               
\newenvironment{figure*}
               {\halfflag=0\@dblfloat{figure}}
               {\end@dblfloat}

\newenvironment{table}
               {\halfflag=1\@float{table}}
               {\end@float}
               
\newenvironment{table*}
               {\halfflag=0\@dblfloat{table}}
               {\end@dblfloat}

\newenvironment{halffigure}
               {\halfflag=1\@float{figure}}
               {\end@float}
               
\newenvironment{fullfigure}
               {\halfflag=0\@dblfloat{figure}}
               {\end@dblfloat}

\newenvironment{halftable}
               {\halfflag=1\@float{table}}
               {\end@float}
               
\newenvironment{fulltable}
               {\halfflag=0\@dblfloat{table}}
               {\end@dblfloat}

\def\tabular{%
  \if@twocolumn
  \vskip4\p@
  \else
  \vskip8\p@
  \fi
  \begin{center}
  \let\@halignto\@empty%
  \if@twocolumn\footnotesize\else\small\fi\@tabular
 }
\def\endtabular{\crcr\egroup\egroup $\egroup\end{center}}

\let\halftabular\tabular\relax
\let\fulltabular\tabular\relax
\let\endhalftabular\endtabular\relax
\let\endfulltabular\endtabular\relax

%%%%%%%%%%%%%
% maketitle %
%%%%%%%%%%%%%

\def\maketitle{\par
\begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\hskip1\p@%\rlap{
	\@textsuperscript{\normalfont\@thefnmark}} %}%
    \long\def\@makefntext##1{%\vskip2\p@ 
	        \hangindent8\p@ \hangafter1 \noindent
            \hb@xt@1em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
\if@twocolumn
   \if@sn
   		\global\@topnum\z@
   	\@maketitle 
   \else
   \if@comment
   		\global\@topnum\z@
   	\@maketitle 
   \else
   \if@addenda
   		\global\@topnum\z@
   	\@maketitle 
   \else
   		\twocolumn[\@maketitle]
   \fi
     \fi
	   \fi
\else
   \global\@topnum\z@
 \@maketitle 
\fi
\thispagestyle{jpsj}\@thanks
\endgroup
 \setcounter{footnote}{0}
 \global\let\thanks\relax
 \global\let\maketitle\relax
 \global\let\@maketitle\relax
 \global\let\@thanks\@empty
 \global\let\@author\@empty
 \global\let\@title\@empty
 \global\let\title\relax
 \global\let\author\relax
}

\def\@maketitle{%
\null
\centering
%\if@twocolumn
%  \if@sn
%  	\relax
%  		\else
%  \if@comment
%  	\relax
%  		\else
%  \if@addenda
%  	\relax
%  		\else
%    \vskip12\p@
%  \fi
%  	\fi
%  		\fi
%\else
%	\relax
%\fi
{\if@twocolumn
	\if@sn
		\large\bfseries\boldmath\@title
	\else
	\if@comment
		\large\bfseries\boldmath\@title
	\else
	\if@addenda
			\large\bfseries\boldmath\@title
	\else
	\vskip36\p@
	\parbox{430pt}{\centering\large\bfseries\boldmath\@title}
	\fi \fi \fi
	\else
	\large\bfseries\boldmath\@title
	\fi 
	\par}

\vskip10\p@
{\if@twocolumn
	\if@sn
		\normalsize\@author
	\else
	\if@comment
		\normalsize\@author
	\else
	\if@addenda
		\normalsize\@author
	\else
	\parbox{430pt}{\centering\normalsize\@author}
	\fi \fi \fi
	\else
	\normalsize\@author
	\fi
	\par}

\vskip10\p@
{\if@twocolumn
	\if@sn
		\normalsize\itshape\@inst
	\else
	\if@comment
		\normalsize\itshape\@inst
	\else
	\if@addenda
		\normalsize\itshape\@inst
	\else
	\parbox{430pt}{\centering\small\itshape\@inst}
	\fi \fi \fi
	\else
	\normalsize\itshape\@inst
	\fi
	\par}

\vskip4\p@
  \@ifundefined{@recdate}{\if@twocolumn\vskip8\p@\else\relax\fi}{%
  \footnotesize (Received\space\@recdate)
  \par}

\gdef\@recdate{}

\if@errata
  \vskip4\p@
  \@ifundefined{@origin}{}{%
  \footnotesize (J. Phys. Soc. Jpn. \@origin)
  \par}
\else
  \relax
\fi

\gdef\@origin{}

\if@sn
  \@ifundefined{@abst}{}{}
  \else
\if@comment
  \@ifundefined{@abst}{}{}
  \else
\if@addenda
  \@ifundefined{@abst}{}{}
  \else
\if@errata
  \@ifundefined{@abst}{}{}
  \else
\if@twocolumn
  \vskip4\p@
  \@ifundefined{@abst}{}{%
  \noindent\small\parbox[t]{430\p@}{\parindent9\p@\@abst}
  \par}
\else
  \vskip12\p@
  \@ifundefined{@abst}{}{%
  \parbox{\textwidth}{\normalsize\@abst}\par
  }
\fi
  \fi
    \fi
	  \fi
        \fi

\if@twocolumn
  \if@sn
  \vskip2\p@
  \@ifundefined{@kword}{}{%
  \noindent\small\sffamily KEYWORDS:\hskip.5em\parbox[t]{182\p@}{\@kword}
  \par}
  \else
  \if@comment
  \vskip2\p@
  \@ifundefined{@kword}{}{%
  \noindent\small\sffamily KEYWORDS:\hskip.5em\parbox[t]{182\p@}{\@kword}
  \par}
  \else
  \if@addenda
  \vskip2\p@
  \@ifundefined{@kword}{}{%
  \noindent\small\sffamily KEYWORDS:\hskip.5em\parbox[t]{182\p@}{\@kword}
  \par}
  \else
  \if@errata
  \@ifundefined{@kword}{}{}
  \else
  \vskip6\p@
  \@ifundefined{@kword}{}{%
  \noindent\small\sffamily KEYWORDS:\hskip.5em\parbox[t]{370\p@}{\@kword}
  \par}
  \fi
    \fi
	  \fi
	    \fi
\else
  \vskip12\p@
  \@ifundefined{@kword}{}{%
  \noindent\small\sffamily KEYWORDS:\hskip.5em\parbox[t]{380\p@}{\@kword}
  \par}
\fi

\if@sn
  \vskip1\baselineskip
  \else
\if@comment
  \vskip1\baselineskip
  \else
\if@addenda
  \vskip1\baselineskip
  \else
\if@errata
  \vskip1\baselineskip
  \else
  \vskip2\baselineskip
\fi
  \fi
    \fi
	  \fi
}

\long\def\abst#1{\long\gdef\@abst{#1}}
\long\def\inst#1{\long\gdef\@inst{#1}}
\long\def\kword#1{\long\gdef\@kword{#1}}
%
%%%\def\recdate#1#2#3{\gdef\@recdate{\month{#2}\space#3,\space#1}}
\def\recdate#1{\gdef\@recdate{#1}}
\def\origin#1{\gdef\@origin{#1}}

%%%%%%Definition of headings%%%%%%
\mark{{}{}}

\def\ps@headings{\let\@mkboth\markboth
\if@twocolumn
\def\@oddfoot{\hfill{\footnotesize\thepage}\hfill}
\let\@evenfoot\@oddfoot
	\else
\def\@oddfoot{\hfill{\footnotesize\thepage/\pageref{lastpage}}\hfill}
\let\@evenfoot\@oddfoot
	\fi
\def\@evenhead{\footnotesize%
\underline{%
	\hbox to \textwidth{\@jpsjmark\hfill%
	\if@ip\@ipmark
		\else
	\if@st\hfill\@stmark
		\else
	\if@l\@lmark
		\else
	\if@fp\@fpmark
		\else
	\if@sn\@snmark
		\else
	\if@comment\@cmmark
		\else
	\if@addenda\@admark
		\else
	\if@errata\@ermark
		\else
	\@draftmark
	\fi
		\fi
			\fi
				\fi
					\fi
						\fi
							\fi
								\fi
	}
		}
			}
\let\@oddhead\@evenhead
}

\def\ps@jpsj{%
  \let\@mkboth\@gobbletwo%
  \def\@evenfoot{%
  \if@twocolumn
  \hfill{\footnotesize\thepage}\hfill
  	\else
  \hfill{\footnotesize\thepage/\pageref{lastpage}}\hfill
  \fi
  }
  \let\@oddfoot\@evenfoot
  \def\@evenhead{\footnotesize%
	\underline{%
	\hbox to \textwidth{\@JPSJmark\hfill%
	\if@ip\@ipmark
		\else
	\if@st\hfill\@stmark
		\else
	\if@l\@lmark
		\else
	\if@fp\@fpmark
		\else
	\if@sn\@snmark
		\else
	\if@comment\@cmmark
		\else
	\if@addenda\@admark
		\else
	\if@errata\@ermark
		\else
	\@draftmark
	\fi
		\fi
			\fi
				\fi
					\fi
						\fi
							\fi
								\fi
	}
		}
			}
  \let\@oddhead\@evenhead
}

%\renewcommand{\month}[1]{\ifcase#1\relax ???\or
% January\or February\or March\or April\or May\or June\or
% July\or August\or September\or October\or November\or December
% \else ???\fi}

\def\today{\ifcase\month\or
 January\or February\or March\or April\or May\or June\or
 July\or August\or September\or October\or November\or December\fi
 \space\number\day, \number\year}

\pagestyle{headings}
\pagenumbering{arabic}

%
% Acknowledgements
%

\newenvironment{acknowledgment}{\@acktrue\par%
	\if@twocolumn
		\if@l\footnotesize\paragraph{Acknowledgment}
			\else
		\if@sn\footnotesize\paragraph{Acknowledgment}
			\else
		\if@comment\footnotesize\paragraph{Acknowledgment}
 			\else
		\if@addenda\footnotesize\paragraph{Acknowledgment}
			\fi	\fi	\fi	\fi
    \else
	\section*{Acknowledgment}
	\fi}
{\relax}
\newenvironment{acknowledgments}{\@acktrue\par%
	\if@twocolumn
		\if@l\footnotesize\paragraph{\footnotesize Acknowledgments}
			\else
		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgments}
			\else
		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgments}
			\else
		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgments}
			\fi	\fi	\fi	\fi
	\else
	\section*{Acknowledgments}
	\fi}
{\relax}
\newenvironment{acknowledgement}\@acktrue{\par%
	\if@twocolumn
		\if@l\footnotesize\paragraph{\footnotesize Acknowledgement}
			\else
		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgment}
			\else
		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgement}
			\else
		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgmeent}
			\fi	\fi	\fi	\fi
	\else
	\section*{Acknowledgement}
	\fi}
{\relax}
\newenvironment{acknowledgements}{\@acktrue\par%
	\if@twocolumn
		\if@l\footnotesize\paragraph{\footnotesize Acknowledgements}
			\else
		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgements}
			\else
		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgements}
			\else
		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgements}
			\fi	\fi	\fi	\fi
	\else
	\section*{Acknowledgements}
	\fi}
{\relax}

%\newcommand{\acknowledgment}{\par%
%	\if@twocolumn
%		\if@l\footnotesize\paragraph{Acknowledgment}
%			\else
%		\if@sn\footnotesize\paragraph{Acknowledgment}
%			\else
%		\if@comment\footnotesize\paragraph{Acknowledgment}
% 			\else
%		\if@addenda\footnotesize\paragraph{Acknowledgment}
%			\fi	\fi	\fi	\fi
%    \else
%    \section*{Acknowledgement}
%    \fi}
%\newcommand{\acknowledgments}{\par%
%	\if@twocolumn
%		\if@l\footnotesize\paragraph{\footnotesize Acknowledgments}
%			\else
%		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgments}
%			\else
%		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgments}
%			\else
%		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgments}
%			\fi	\fi	\fi	\fi
%	\else
%	\section*{Acknowledgments}
%	\fi}
%\newcommand{\acknowledgement}{\par%
%	\if@twocolumn
%		\if@l\footnotesize\paragraph{\footnotesize Acknowledgement}
%			\else
%		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgment}
%			\else
%		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgement}
%			\else
%		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgmeent}
%			\fi	\fi	\fi	\fi
%	\else
%	\section*{Acknowledgement}
%	\fi}
%\newcommand{\acknowledgements}{\par%
%	\if@twocolumn
%		\if@l\footnotesize\paragraph{\footnotesize Acknowledgements}
%			\else
%		\if@sn\footnotesize\paragraph{\footnotesize Acknowledgements}
%			\else
%		\if@comment\footnotesize\paragraph{\footnotesize Acknowledgements}
%			\else
%		\if@addenda\footnotesize\paragraph{\footnotesize Acknowledgements}
%			\fi	\fi	\fi	\fi
%	\else
%	\section*{Acknowledgements}
%	\fi}

%%%%%%%%% Appendix %%%%%%%%%%%
\newcount\@appendixflag
\@appendixflag=0
\newcount\@appendixindex
\@appendixindex=0

\def\getappendix#1{\global\@namedef{appnedix@#1}{1}}
\def\appendix{\par
\renewcommand{\section}[1]{\sectiona{##1}}
}

\def\sectiona{%
 \c@table=0
 \c@figure=0
 \c@equation=0
% \setcounter{equation}{0}
 \ifnum \@appendixflag=0
   \setcounter{section}{0} \@appendixflag=1
   \def\@secapp{Appendix}
   \def\thetable{\Alph{section}\textperiodcentered\@arabic\c@table}%
   \def\thefigure{\Alph{section}\textperiodcentered\@arabic\c@figure}
   \def\theequation{\Alph{section}\textperiodcentered\arabic{equation}}
 \fi

 \@ifundefined {appnedix@1}{\def\thesection{}}
   {\def\thesection{\ \Alph{section}}}

 \def\thesubsection {\Alph{section}.\arabic{subsection}}
 \if@filesw \immediate\write\@auxout
       {\string\getappendix{\the\@appendixindex}}
 \advance \@appendixindex by 1 \fi
\@startsection{section}{1}{\z@}%
  {\if@twocolumn 8\p@ \@plus\p@ \@minus\p@ \else .5\baselineskip \fi}%
  {\if@twocolumn 4\p@ \@plus\p@ \@minus\p@ \else \p@ \fi}%
  {\normalfont\normalsize\bfseries\boldmath}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\endinput
%% End of file `jpsj3.cls'.
