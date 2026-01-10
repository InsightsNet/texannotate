%%
%% This is file `lhep.cls',
%%Developed by Shashi Kumar (shashikr08@gmail.com) for LHEP journals
%%
%%based on elsevier; lhepd.cls
%%
 \def\RCSfile{andromeda}%
 \def\RCSversion{1.0}%
 \def\RCSdate{2017/11/29}%
 \def\@shortjnl{\relax}
 \def\@journal{Andromeda Proceedings} \def\@company{Shashi}
 \def\@issn{000-0000}
 \def\@shortjid{lhep}
\NeedsTeXFormat{LaTeX2e}[2006/06/12]
\ProvidesClass{\@shortjid}[\RCSdate, \RCSversion: \@journal]
\def\ABD{\AtBeginDocument}
\newif\ifpreprint \preprintfalse
\newif\iflongmktitle \longmktitlefalse

\def\@blstr{1}
\newdimen\@bls
\@bls=\baselineskip

\def\@finalWarning{%
  *****************************************************\MessageBreak
   This document is typeset in the CRC style which\MessageBreak
   is not suitable for submission.\MessageBreak
   \MessageBreak
   Please typeset again using 'preprint' option\MessageBreak
   for creating PDF suitable for submission.\MessageBreak
  ******************************************************\MessageBreak
}

\DeclareOption{preprint}{\global\preprinttrue
  \gdef\@blstr{1}\xdef\jtype{0}%
   \AtBeginDocument{\@twosidefalse\@mparswitchfalse}}
\DeclareOption{final}{\gdef\@blstr{1}\global\preprintfalse}
\DeclareOption{review}{\global\preprinttrue\gdef\@blstr{1.5}}
\DeclareOption{authoryear}{\xdef\@biboptions{round,authoryear}}
\DeclareOption{number}{\xdef\@biboptions{numbers}}
\DeclareOption{numbers}{\xdef\@biboptions{numbers}}
\DeclareOption{longtitle}{\global\longmktitletrue}
\DeclareOption{fleqn}{\input{fleqn.clo}\AtBeginDocument{\mathindent\z@}%
\AtBeginDocument{\@ifpackageloaded{amsmath}{\@mathmargin\z@}{}}%
\PassOptionsToPackage{fleqn}{amsmath}}
\DeclareOption{5p}{\xdef\jtype{5}\global\preprintfalse
  \ExecuteOptions{twocolumn,fleqn}}
  \def\jtype{0}
\DeclareOption{3p}{\xdef\jtype{3}\global\preprintfalse}
\DeclareOption{1p}{\xdef\jtype{1}\global\preprintfalse
  \AtBeginDocument{\@twocolumnfalse}}
%%\DeclareOption{times}{\IfFileExists{txfonts.sty}%
%%  {\AtEndOfClass{\RequirePackage{txfonts}%
%%  \gdef\ttdefault{cmtt}%
%%   \let\iint\relax
%%  \let\iiint\relax
%%  \let\iiiint\relax
%%  \let\idotsint\relax
%%  \let\openbox\relax}}{\RequirePackage{times}}}

%%\ExecuteOptions{letter,twoside,5p,final,number,preprint}

%%%\ExecuteOptions{letter,twoside,number,5p,final}%%For two column
\ExecuteOptions{letter,twoside,number,3p,final}


\DeclareOption{singlecolor}{\@singlecolortrue}
\newif\if@singlecolor\@singlecolortrue
\global\@singlecolorfalse


\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\RequirePackage{graphicx}
\let\comma\@empty
\let\tnotesep\@empty
\def\title#1{\gdef\@title{#1}}
\let\@title\@empty

\usepackage{xcolor}
\definecolor{titlebarcol}{cmyk}{1.0, 0, 0, 0}

\if@singlecolor
\def\barcolor{\special{color cmyk 0 0 0 1.0}}
\def\cyanten{\special{color cmyk 0 0 0 0.10}}
\definecolor{cyanten}{cmyk}{0 0 0 0.15}
\definecolor{shadecolor}{cmyk}{0 0 0 0.15}
\else
\def\cyanfifty{\special{color cmyk 0.5 0.0 0.0 0.0}}
\def\barcolor{\special{color cmyk 0 0 0 0.7}}
\def\cyanten{\special{color cmyk 0.10 0 0 0}}
\definecolor{cyanten}{cmyk}{0.15 0 0 0}
\definecolor{cyanfifty}{cmyk}{0 0 0 0.5}
\definecolor{shadecolor}{cmyk}{0 0 0 0.15}
\fi
\def\blackink{\special{color cmyk 0 0 0 1.0}} %
\def\whiteink{\special{color cmyk 0 0 0 0}} %
\definecolor{grayten}{cmyk}{0.15 0 0 0}
\def\graytwnty{\special{color cmyk 0 0 0 0.20}}
\def\blue{\special{color rgb 0 0 1.0}}
\def\red{\special{color rgb 1.0 0 0}}


\def\titlefont{\fontsize{16}{26}\bfseries\sffamily\boldmath\selectfont}
\def\aufont{\fontsize{10}{12}\sffamily\bfseries\selectfont}
\def\adfont{\fontsize{9}{11}\itshape\selectfont}
\def\absfont{\fontsize{12}{14}\sffamily\bfseries\selectfont}
\def\sectionfont{\fontsize{12}{14}\bfseries\boldmath\selectfont}
\def\subsectionfont{\fontsize{10}{12}\itshape\selectfont}
\def\subsubsectionfont{\fontsize{9}{11}\itshape\selectfont}
\def\fignofont{\fontsize{9}{11}\sffamily\bfseries\selectfont}
\def\figcapfont{\fontsize{9}{11}\raggedright\selectfont}
\def\figcapnorfont{\fontsize{9}{11}\selectfont}
\def\tablenofont{\fontsize{9}{11}\sffamily\bfseries\selectfont}%
\def\tablecaptionfont{\fontsize{9}{11}\selectfont}%
\def\tablesubtitlefont{\fontsize{7}{8}\sffamily\bfseries\selectfont}%
\def\tabnotefont{\reset@font\fontsize{8}{10}\selectfont}%
\def\tablefont{\fontsize{9}{11}\selectfont}%
\def\tchfont{\bfseries\boldmath}%

\def\tch#1{{\tchfont#1}}


\RequirePackage{framed}


\renewcommand\theequation{\@arabic\c@equation}%\thesection.
\@addtoreset{equation}{section}%


\def\elsLabel#1{\@bsphack\protected@write\@auxout{}%
         {\string\Newlabel{#1}{\@currentlabel}}\@esphack}
\def\Newlabel#1#2{\expandafter\xdef\csname X@#1\endcsname{#2}}

\def\elsRef#1{\@ifundefined{X@#1}{0}{\csname X@#1\endcsname}%
}

\def\tnotemark[#1]{\textsuperscript{\@for\@@tmark:=#1\do{%
      \edef\tnotenum{\@ifundefined{X@\@@tmark}{1}{\elsRef{\@@tmark}}}%
      \ifcase\tnotenum\or\ding{73}\or,\ding{73}\ding{73}\fi}}%
}
\let\@tnotemark\@empty

\let\@tnotes\@empty
\RequirePackage{pifont}
\newcounter{tnote}
\def\tnotetext[#1]#2{\g@addto@macro\@tnotes{%
  \refstepcounter{tnote}\elsLabel{#1}%
   \def\thefootnote{\ifcase\c@tnote\or\ding{73}\or\ding{73}\ding{73}\fi}%
    \footnotetext{#2}}}

\let\@nonumnotes\@empty
\def\nonumnote#1{\g@addto@macro\@nonumnotes{%
     \let\thefootnote\relax\footnotetext{#1}}}

\newcounter{fnote}
\def\fnmark[#1]{\let\comma\@empty
    \def\@fnmark{\@for\@@fnmark:=#1\do{%
    \edef\fnotenum{\@ifundefined{X@\@@fnmark}{1}{\elsRef{\@@fnmark}}}%
  \unskip\comma\fnotenum\let\comma,}}%
}

\let\@fnotes\@empty\let\@fnmark\@empty
\def\fntext[#1]#2{\g@addto@macro\@fnotes{%
     \refstepcounter{fnote}\elsLabel{#1}%
   \def\thefootnote{\thefnote}%
   \global\setcounter{footnote}{\thefnote}%
   \footnotetext{#2}}}

\def\cormark[#1]{\edef\cnotenum{\elsRef{#1}}%
    \unskip\textsuperscript{\sep\ifcase\cnotenum\or
       $\ast$\or$\ast\ast$\fi\hspace{-1pt}}\let\sep=,}

\let\@cormark\@empty
\let\@cornotes\@empty
\newcounter{cnote}
\def\cortext[#1]#2{\g@addto@macro\@cornotes{%
    \refstepcounter{cnote}\elsLabel{#1}%
    \def\thefootnote{\ifcase\thecnote\or$\ast$\or
    $\ast\ast$\fi}%
    \footnotetext{#2}}}

\let\@corref\@empty
\def\corref#1{\edef\cnotenum{\elsRef{#1}}%
    \edef\@corref{\ifcase\cnotenum\or
         $\ast$\or$\ast\ast$\fi\hskip-1pt}}

\def\fnref#1{\fnmark[#1]}
\def\tnoteref#1{\tnotemark[#1]}

\def\resetTitleCounters{\c@cnote=0
   \c@fnote=0 \c@tnote=0 \c@footnote=0}

\let\eadsep\@empty
\let\@elseads\@empty
\let\@elsuads\@empty
\let\@cormark\@empty
\def\hashchar{\expandafter\@gobble\string\~}
\def\underscorechar{\expandafter\@gobble\string\_}
\def\lbracechar{\expandafter\@gobble\string\{}
\def\rbracechar{\expandafter\@gobble\string\}}

\def\eadd{\@ifnextchar[{\@uad}{\@ead}}
\gdef\@ead#1{\bgroup\def\_{\string\underscorechar\space}%
  \def\{{\string\lbracechar\space}%
   \def~{\hashchar\space}%
   \def\}{\string\rbracechar\space}%
   \edef\tmp{\the\@eadauthor}
   \immediate\write\@auxout{\string\emailauthor
     {#1}{\expandafter\strip@prefix\meaning\tmp}}%
  \egroup
}
\newcounter{ead}
\gdef\emailauthor#1#2{\stepcounter{ead}%
     \g@addto@macro\@elseads{\raggedright%
      \let\corref\@gobble
      \eadsep\texttt{#1} (#2)\def\eadsep{\unskip,\space}}%
}
\gdef\@uad[#1]#2{\bgroup
  \def~{\string\hashchar\space}%
  \def\_{\string\underscorechar\space}%
   \edef\tmp{\the\@eadauthor}
   \immediate\write\@auxout{\string\urlauthor
     {#2}{\expandafter\strip@prefix\meaning\tmp}}%
  \egroup
}
\def\urlauthor#1#2{\g@addto@macro\@elsuads{\let\corref\@gobble%
     \raggedright\eadsep\texttt{#1}\space(#2)%
     \def\eadsep{\unskip,\space}}%
}

\def\elsauthors{}
\def\pprinttitle{}
\let\authorsep\@empty
\let\sep\@empty
\newcounter{author}
\def\author{\@ifnextchar[{\@@author}{\@author}}

\newtoks\@eadauthor
\def\@@author[#1]#2{\g@addto@macro\elsauthors{%
    \def\baselinestretch{1}%
    \authorsep#2\unskip\textsuperscript{%#1%
      \@for\@@affmark:=#1\do{%
       \edef\affnum{\@ifundefined{X@\@@affmark}{1}{\elsRef{\@@affmark}}}%
     \unskip\sep\affnum\let\sep=,}%
      \ifx\@fnmark\@empty\else\unskip\sep\@fnmark\let\sep=,\fi
      \ifx\@corref\@empty\else\unskip\sep\@corref\let\sep=,\fi
      }%
    \def\authorsep{\unskip,\space}%
    \global\let\sep\@empty\global\let\@corref\@empty
    \global\let\@fnmark\@empty}%
    \@eadauthor={#2}
}

\def\@author#1{\g@addto@macro\elsauthors{\normalsize%
    \def\baselinestretch{1}%
    {\aufont\authorsep#1}\unskip\textsuperscript{%
      \ifx\@fnmark\@empty\else\unskip\sep\@fnmark\let\sep=,\fi
      \ifx\@corref\@empty\else\unskip\sep\@corref\let\sep=,\fi
      }%
    \def\authorsep{\unskip,\space}%
    \global\let\@fnmark\@empty
    \global\let\@corref\@empty
    \global\let\sep\@empty}%
    \@eadauthor={#1}
}

\def\elsaddress{}
\def\addsep{\par\vspace*{2pt}}
\def\address{\@ifnextchar[{\@@address}{\@address}}

\def\@alph#1{%
  \ifcase#1\or a\or b\or c\or d\or e\or f\or g\or h\or i\or j\or k\or
  l\or m\or n\or o\or p\or q\or r\or s\or t\or u\or v\or w\or x\or
  y\or z%
  \or aa\or ab\or ac\or ad\or ae\or af\or ag\or ah\or ai\or aj\or
  ak\or al\or am\or an\or ao\or ap\or aq\or ar\or as\or at\or au\or
  av\or aw\or ax\or ay\or az%
  \or ba\or bb\or bc\or bd\or be\or bf\or bg\or bh\or bi\or bj\or
  bk\or bl\or bm\or bn\or bo\or bp\or bq\or br\or bs\or bt\or bu\or
  bv\or bw\or bx\or by\or bz%
  \or ca\or cb\or cc\or cd\or ce\or cf\or cg\or ch\or ci\or cj\or
  ck\or cl\or cm\or cn\or co\or cp\or cq\or cr\or cs\or ct\or cu\or
  cv\or cw\or cx\or cy\or cz%
  \or da\or db\or dc\or dd\or de\or df\or dg\or dh\or di\or dj\or
  dk\or dl\or dm\or dn\or do\or dp\or dq\or dr\or ds\or dt\or du\or
  dv\or dw\or dx\or dy\or dz%
  \or ea\or eb\or ec\or ed\or ee\or ef\or eg\or eh\or ei\or ej\or
  ek\or el\or em\or en\or eo\or ep\or eq\or er\or es\or et\or eu\or
  ev\or ew\or ex\or ey\or ez%
  \or fa\or fb\or fc\or fd\or fe\or ff\or fg\or fh\or fi\or fj\or
  fk\or fl\or fm\or fn\or fo\or fp\or fq\or fr\or fs\or ft\or fu\or
  fv\or fw\or fx\or fy\or fz%
  \or ga\or gb\or gc\or gd\or ge\or gf\or gg\or gh\or gi\or gj\or
  gk\or gl\or gm\or gn\or go\or gp\or gq\or gr\or gs\or gt\or gu\or
  gv\or gw\or gx\or gy\or gz%
  \else\@ctrerr\fi}

\newcounter{affn}
\renewcommand\theaffn{\alph{affn}}

\long\def\@@address[#1]#2{\g@addto@macro\elsaddress{%
    \def\baselinestretch{1}%
     \refstepcounter{affn}
     \xdef\@currentlabel{\theaffn}
     \elsLabel{#1}%
    \textsuperscript{\theaffn}#2\par}}

\long\def\@address#1{\g@addto@macro\elsauthors{%
    \def\baselinestretch{1}%
    \addsep\vbox{\adfont#1}%\def\addsep{\par\vspace*{-2pt}}%
    \def\authorsep{\par\vspace*{9pt}}}}

\newbox\absbox


%%Shaded background
%%\renewenvironment{abstract}{\global\setbox\absbox=\vbox\bgroup%\leftskip4pc
%%  \hsize=\textwidth\def\baselinestretch{1}%
%%  \noindent{\vrule height2pt width15pc}\par\vspace*{0pt}
%%  \noindent\unskip{\absfont Abstract}\par\vspace*{-9pt}\begin{shaded*}\hsize36pc\noindent\unskip\ignorespaces}
%% {\end{shaded*}\par\vspace*{-12pt}\hfill\noindent{\vrule height2pt width15pc}\par\egroup}

\renewenvironment{abstract}{\global\setbox\absbox=\vbox\bgroup
  \hsize=\textwidth\def\baselinestretch{1}%
  \noindent{\vrule height2pt width16pc}\par\vspace*{0pt}
  \noindent\unskip{\absfont Abstract}\par\leftskip4pc\rightskip4pc\noindent\unskip\ignorespaces}
 {\par\vspace*{-6pt}\rightskip0pt\hfill\noindent{\vrule height2pt width16pc}\par\egroup}


\newbox\keybox
\def\keyword{%
  \def\sep{\unskip, }%
 \def\MSC{\@ifnextchar[{\@MSC}{\@MSC[2000]}}
  \def\@MSC[##1]{\par\leavevmode\hbox {\it ##1~MSC:\space}}%
  \def\doi{\par\leavevmode\hbox {\it DOI:\space}}%
  \def\JEL{\par\leavevmode\hbox {\it JEL:\space}}%
%  \global\setbox\keybox=\vbox\bgroup\hsize=\textwidth%% commented to make it appear outside \maketitle
  \normalsize\normalfont\def\baselinestretch{1}
  \parskip\z@
  \noindent\textit{Keywords: }
  \raggedright                         % Keywords are not justified.
  \ignorespaces}
\def\endkeyword{\par}% \egroup}

\newdimen\Columnwidth
\Columnwidth=\columnwidth

\def\printFirstPageNotes{%
  \iflongmktitle
   \let\columnwidth=\textwidth\fi
  \ifx\@tnotes\@empty\else\@tnotes\fi
  \ifx\@nonumnotes\@empty\else\@nonumnotes\fi
  \ifx\@cornotes\@empty\else\@cornotes\fi
  \ifx\@elseads\@empty\relax\else
   \let\thefootnote\relax
   \footnotetext{\ifnum\theead=1\relax
      \textit{Email address:\space}\else
      \textit{Email addresses:\space}\fi
     \@elseads}\fi
  \ifx\@elsuads\@empty\relax\else
   \let\thefootnote\relax
   \footnotetext{\textit{URL:\space}%
     \@elsuads}\fi
  \ifx\@fnotes\@empty\else\@fnotes\fi
  \iflongmktitle\if@twocolumn
   \let\columnwidth=\Columnwidth\fi\fi
}

\long\def\pprintMaketitle{\clearpage
  \iflongmktitle\if@twocolumn\let\columnwidth=\textwidth\fi\fi
  \resetTitleCounters
  \def\baselinestretch{1}%
  \printFirstPageNotes
  \begin{center}%
 \thispagestyle{pprintTitle}%
   \def\baselinestretch{1}%
%%    \Large\@title\par\vskip18pt
\MaketitleBox
    \normalsize\elsauthors\par\vskip10pt
    \footnotesize\itshape\elsaddress\par\vskip36pt
    \hrule\vskip12pt
    \ifvoid\absbox\else\unvbox\absbox\par\vskip10pt\fi
    \ifvoid\keybox\else\unvbox\keybox\par\vskip10pt\fi
    \hrule\vskip12pt
    \end{center}%
  \gdef\thefootnote{\arabic{footnote}}%
  }

\def\printWarning{%
     \mbox{}\par\vfill\par\bgroup
     \fboxsep12pt\fboxrule1pt
     \hspace*{.18\textwidth}
     \fcolorbox{gray50}{gray10}{\box\warnbox}
     \egroup\par\vfill\thispagestyle{empty}
     \setcounter{page}{0}
     \clearpage}

\long\def\finalMaketitle{%
  \resetTitleCounters
  \def\baselinestretch{1}%
   \MaketitleBox
   %   \thispagestyle{pprintTitle}%
\thispagestyle{folio}
  \gdef\thefootnote{\arabic{footnote}}%
  }

\def\auno#1{\textsuperscript{#1}}

\def\titlerunning#1{\gdef\@titlerunning{#1}}
\let\@title\titlerunning       


\long\def\MaketitleBox{%
  \resetTitleCounters
  \let\@titlerunning\@title\ifpublished
  \else
  \vskip-18pt
  \hbox to \textwidth{Andromeda Proceedings\hfill\@journal\enspace\@vol,\ \@pages,\ \@jyear}\par\vspace*{-8pt}\rlap{\rule{\textwidth}{1pt}}\vspace*{16pt}\fi
    \vbox{\centering{\titlefont\@title}}\vskip10pt
    {\centering\elsauthors}\par\vskip10pt
    {\adfont\elsaddress}\par
    \ifpublished\vskip-8pt Received:~\@received,\ Published:~\@published\par\vskip14pt\else \vspace*{-0pt}\fi
    \ifvoid\absbox\else\unvbox\absbox\par\vskip10pt\fi
    \ifvoid\keybox\else\unvbox\keybox\par\vskip10pt\fi
    \date{}
  }

\def\FNtext#1{\par\bgroup\footnotesize#1\egroup}
\newdimen\space@left
\def\alarm#1{\typeout{******************************}%
             \typeout{#1}%
             \typeout{******************************}%
}
\long\def\getSpaceLeft{%\global\@twocolumnfalse%
   \global\setbox0=\vbox{\hsize=\textwidth\MaketitleBox}%
   \global\setbox1=\vbox{\hsize=\textwidth
    \let\footnotetext\FNtext
    \printFirstPageNotes}%
    \xdef\noteheight{\the\ht1}%
    \xdef\titleheight{\the\ht0}%
    \@tempdima=\vsize
    \advance\@tempdima-\noteheight
    \advance\@tempdima-1\baselineskip
}

  \skip\footins=24pt

\newbox\els@boxa
\newbox\els@boxb

\ifpreprint
  \def\maketitle{\pprintMaketitle}
  \else
   \ifnum\jtype=1
    \def\maketitle{%
      \iflongmktitle\getSpaceLeft
       \global\setbox\els@boxa=\vsplit0 to \@tempdima
       \box\els@boxa\par\resetTitleCounters
       \thispagestyle{pprintTitle}%
       \printFirstPageNotes
       \box0%
      \else
       \finalMaketitle\printFirstPageNotes
      \fi
    \gdef\thefootnote{\arabic{footnote}}}%
  \else
 \ifnum\jtype=5
    \def\maketitle{%
      \iflongmktitle\getSpaceLeft
       \global\setbox\els@boxa=\vsplit0 to \@tempdima
       \box\els@boxa\par\resetTitleCounters
       \thispagestyle{pprintTitle}%
       \printFirstPageNotes
       \twocolumn[\box0]%\printFirstPageNotes
      \else
       \twocolumn[\finalMaketitle]\printFirstPageNotes
     \fi
     \gdef\thefootnote{\arabic{footnote}}}
  \else
  \if@twocolumn
    \def\maketitle{%
      \iflongmktitle\getSpaceLeft
       \global\setbox\els@boxa=\vsplit0 to \@tempdima
       \box\els@boxa\par\resetTitleCounters
       \thispagestyle{pprintTitle}%
       \printFirstPageNotes
       \twocolumn[\box0]%
      \else
       \twocolumn[\finalMaketitle]\printFirstPageNotes
      \fi
     \gdef\thefootnote{\arabic{footnote}}}%
   \else
    \def\maketitle{%
      \iflongmktitle\getSpaceLeft
       \global\setbox\els@boxa=\vsplit0 to \@tempdima
       \box\els@boxa\par\resetTitleCounters
       \thispagestyle{pprintTitle}%
       \printFirstPageNotes
       \box0%
     \else
       \finalMaketitle\printFirstPageNotes%Shashi3p
      \fi
    \gdef\thefootnote{\arabic{footnote}}}%
   \fi
  \fi
 \fi
\fi
\def\ps@pprintTitle{%
     \let\@oddhead\@empty
     \let\@evenhead\@empty
     \def\@oddfoot{\footnotesize\itshape
       Preprint submitted to \ifx\@journal\@empty LHEP
       \else\@journal\fi\hfill\today}%
     \let\@evenfoot\@oddfoot}
\def\@seccntDot{.}


\newif\ifpublished
\global\publishedfalse


\def\ps@headings{%
    \def\@oddfoot{\hfil\thepage\hfil}
    \def\@evenfoot{\hfil\thepage\hfil}
    \def\@evenhead{\ifpublished \else {Andromeda Proceedings\hfil \@journal\enspace\@vol,\ \@pages,\ \@jyear}\par\llap{\rule[-4pt]{\textwidth}{1pt}}\fi}%\hfil\leftmark\unskip}%
    \def\@oddhead{\ifpublished \else Andromeda Proceedings\hfil \@journal\enspace\@vol,\ \@pages,\ \@jyear\par\llap{\rule[-4pt]{\textwidth}{1pt}}\fi}
    \let\@mkboth\@gobbletwo
%    \let\sectionmark\@gobble
%    \let\subsectionmark\@gobble
    }

%%  \def\ps@headings{%
%%    \let\@oddfoot\@empty
%%    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
%%    \let\@mkboth\markboth
%%    \def\sectionmark##1{%
%%      \markright {{%
%%        \ifnum \c@secnumdepth >\m@ne
%%          \thesection\quad
%%        \fi
%%        \@titlerunning}}}}

%
\def\ps@folio{\let\@mkboth\@gobbletwo
     \let\@oddhead\@empty
     \def\@oddfoot{\hbox to \textwidth{\hfil\bf\thepage\hfil}}%
     \let\@evenhead\@empty
     \def\@evenfoot{\hbox to \textwidth{\hss\hbox to \textwidth{{\bf\thepage}\hfill}}}}
%
    
%\def\@seccntformat#1{\csname the#1\endcsname\@seccntDot\hskip 0.5em}

\newcommand\crcrule{\hbox to\textwidth{\cyanten\rlap{\rule[-3.5\p@]{84\p@}{4\p@}}}\blackink}
\newcommand\sec@rule{\crcrule}

%%\def\@seccntformat#1{\csname the#1\endcsname\enspace$\RHD$\enspace}
\def\@seccntformat#1{\csname the#1\endcsname.\enspace}

\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
    {\@ssect{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}
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
%    \ifnum #2=1
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M #8\@@par}%
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
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
  
\renewcommand\section{%
  \@ifstar{\@ssection}{\@dblarg{\@section}}}

\def\@section[#1]#2{\@startsection {section}{1}{\z@}%
           {-18\p@ \@plus 3\p@ \@minus 3\p@}%
           {6\p@ \@plus 2\p@ \@minus 2\p@}%
           {\sectionfont\boldmath}[#2]{\uppercase{#1}}}
\def\@ssection#1{\@startsection {section}{1}{\z@}%
           {-18\p@ \@plus 3\p@ \@minus 3\p@}%
           {6\p@ \@plus 2\p@ \@minus 2\p@}%
           {\sectionfont\boldmath}*{\uppercase{#1}}}

\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
           {-12\p@ \@plus 6\p@ \@minus 3\p@}%
           {3\p@ \@plus 6\p@ \@minus 3\p@}%
           {\subsectionfont}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
           {-12\p@ \@plus 6\p@ \@minus 3\p@}%
           {\p@}%
           {\subsubsectionfont\itshape}}

\def\paragraph{\secdef{\els@aparagraph}{\els@bparagraph}}
\def\els@aparagraph[#1]#2{\elsparagraph[#1]{#2.}}
\def\els@bparagraph#1{\elsparagraph*{#1.}}

\newcommand\elsparagraph{\@startsection{paragraph}{4}{0\z@}%
           {10\p@ \@plus 6\p@ \@minus 3\p@}%
           {-6\p@}%
           {\normalfont\itshape}}
\newdimen\leftMargin
\leftMargin=2em
\newtoks\@enLab  %\newtoks\@enfont
\def\@enQmark{?}
\def\@enLabel#1#2{%
  \edef\@enThe{\noexpand#1{\@enumctr}}%
  \@enLab\expandafter{\the\@enLab\csname the\@enumctr\endcsname}%
  \@enloop}
\def\@enSpace{\afterassignment\@enSp@ce\let\@tempa= }
\def\@enSp@ce{\@enLab\expandafter{\the\@enLab\space}\@enloop}
\def\@enGroup#1{\@enLab\expandafter{\the\@enLab{#1}}\@enloop}
\def\@enOther#1{\@enLab\expandafter{\the\@enLab#1}\@enloop}
\def\@enloop{\futurelet\@entemp\@enloop@}
\def\@enloop@{%
  \ifx A\@entemp         \def\@tempa{\@enLabel\Alph  }\else
  \ifx a\@entemp         \def\@tempa{\@enLabel\alph  }\else
  \ifx i\@entemp         \def\@tempa{\@enLabel\roman }\else
  \ifx I\@entemp         \def\@tempa{\@enLabel\Roman }\else
  \ifx 1\@entemp         \def\@tempa{\@enLabel\arabic}\else
  \ifx \@sptoken\@entemp \let\@tempa\@enSpace         \else
  \ifx \bgroup\@entemp   \let\@tempa\@enGroup         \else
  \ifx \@enum@\@entemp   \let\@tempa\@gobble          \else
                         \let\@tempa\@enOther
             \fi\fi\fi\fi\fi\fi\fi\fi
  \@tempa}
\newlength{\@sep} \newlength{\@@sep}
\setlength{\@sep}{.5\baselineskip plus.2\baselineskip
            minus.2\baselineskip}
\setlength{\@@sep}{.1\baselineskip plus.01\baselineskip
            minus.05\baselineskip}
\providecommand{\sfbc}{\rmfamily\upshape}
\providecommand{\sfn}{\rmfamily\upshape}
\def\@enfont{\ifnum \@enumdepth >1\let\@nxt\sfn \else\let\@nxt\sfbc \fi\@nxt}
\def\enumerate{%
   \ifnum \@enumdepth >3 \@toodeep\else
      \advance\@enumdepth \@ne
      \edef\@enumctr{enum\romannumeral\the\@enumdepth}\fi
   \@ifnextchar[{\@@enum@}{\@enum@}}
\def\@@enum@[#1]{%
  \@enLab{}\let\@enThe\@enQmark
  \@enloop#1\@enum@
  \ifx\@enThe\@enQmark\@warning{The counter will not be printed.%
   ^^J\space\@spaces\@spaces\@spaces The label is: \the\@enLab}\fi
  \expandafter\edef\csname label\@enumctr\endcsname{\the\@enLab}%
  \expandafter\let\csname the\@enumctr\endcsname\@enThe
  \csname c@\@enumctr\endcsname7
  \expandafter\settowidth
            \csname leftmargin\romannumeral\@enumdepth\endcsname
            {\the\@enLab\hskip\labelsep}%
  \@enum@}
\def\@enum@{\list{{\@enfont\csname label\@enumctr\endcsname}}%
           {\usecounter{\@enumctr}\def\makelabel##1{\hss\llap{##1}}%
     \ifnum \@enumdepth>1\setlength{\topsep}{\@@sep}\else
           \setlength{\topsep}{\@sep}\fi
     \ifnum \@enumdepth>1\setlength{\itemsep}{0pt plus1pt minus1pt}%
      \else \setlength{\itemsep}{\@@sep}\fi
     %\setlength\leftmargin{\leftMargin}%%%{1.8em}
     \setlength{\parsep}{0pt plus1pt minus1pt}%
     \setlength{\parskip}{0pt plus1pt minus1pt}
                   }}

\def\endenumerate{\par\ifnum \@enumdepth >1\addvspace{\@@sep}\else
           \addvspace{\@sep}\fi \endlist}

\def\sitem{\@noitemargtrue\@item[\@itemlabel *]}

\def\itemize{\@ifnextchar[{\@Itemize}{\@Itemize[]}}

\def\@Itemize[#1]{\def\next{#1}%
  \ifnum \@itemdepth >\thr@@\@toodeep\else
   \advance\@itemdepth\@ne
  \ifx\next\@empty\else\expandafter\def\csname
   labelitem\romannumeral\the\@itemdepth\endcsname{#1}\fi%
  \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
  \expandafter\list\csname\@itemitem\endcsname
  {\def\makelabel##1{\hss\llap{##1}}}%
 \fi}
\def\newdefinition#1{%
  \@ifnextchar[{\@odfn{#1}}{\@ndfn{#1}}}%]
\def\@ndfn#1#2{%
  \@ifnextchar[{\@xndfn{#1}{#2}}{\@yndfn{#1}{#2}}}
\def\@xndfn#1#2[#3]{%
  \expandafter\@ifdefinable\csname #1\endcsname
    {\@definecounter{#1}\@newctr{#1}[#3]%
     \expandafter\xdef\csname the#1\endcsname{%
       \expandafter\noexpand\csname the#3\endcsname \@dfncountersep
          \@dfncounter{#1}}%
     \global\@namedef{#1}{\@dfn{#1}{#2}}%
     \global\@namedef{end#1}{\@enddefinition}}}
\def\@yndfn#1#2{%
  \expandafter\@ifdefinable\csname #1\endcsname
    {\@definecounter{#1}%
     \expandafter\xdef\csname the#1\endcsname{\@dfncounter{#1}}%
     \global\@namedef{#1}{\@dfn{#1}{#2}}%
     \global\@namedef{end#1}{\@enddefinition}}}
\def\@odfn#1[#2]#3{%
  \@ifundefined{c@#2}{\@nocounterr{#2}}%
    {\expandafter\@ifdefinable\csname #1\endcsname
    {\global\@namedef{the#1}{\@nameuse{the#2}}
  \global\@namedef{#1}{\@dfn{#2}{#3}}%
  \global\@namedef{end#1}{\@enddefinition}}}}
\def\@dfn#1#2{%
  \refstepcounter{#1}%
  \@ifnextchar[{\@ydfn{#1}{#2}}{\@xdfn{#1}{#2}}}
\def\@xdfn#1#2{%
  \@begindefinition{#2}{\csname the#1\endcsname}\ignorespaces}
\def\@ydfn#1#2[#3]{%
  \@opargbegindefinition{#2}{\csname the#1\endcsname}{#3}\ignorespaces}
\def\@dfncounter#1{\noexpand\arabic{#1}}
\def\@dfncountersep{.}
\def\@begindefinition#1#2{\trivlist
   \item[\hskip\labelsep{\bfseries #1\ #2.}]\upshape}
\def\@opargbegindefinition#1#2#3{\trivlist
      \item[\hskip\labelsep{\bfseries #1\ #2\ (#3).}]\upshape}
\def\@enddefinition{\endtrivlist}

\def\@begintheorem#1#2{\trivlist
  \let\baselinestretch\@blstr
   \item[\hskip \labelsep{\bfseries #1\ #2.}]\itshape}
\def\@opargbegintheorem#1#2#3{\trivlist
  \let\baselinestretch\@blstr
      \item[\hskip \labelsep{\bfseries #1\ #2\ (#3).}]\itshape}

\def\newproof#1{%
  \@ifnextchar[{\@oprf{#1}}{\@nprf{#1}}}
\def\@nprf#1#2{%
  \@ifnextchar[{\@xnprf{#1}{#2}}{\@ynprf{#1}{#2}}}
\def\@xnprf#1#2[#3]{%
  \expandafter\@ifdefinable\csname #1\endcsname
    {\@definecounter{#1}\@newctr{#1}[#3]%
     \expandafter\xdef\csname the#1\endcsname{%
       \expandafter\noexpand\csname the#3\endcsname \@prfcountersep
          \@prfcounter{#1}}%
     \global\@namedef{#1}{\@prf{#1}{#2}}%
     \global\@namedef{end#1}{\@endproof}}}
\def\@ynprf#1#2{%
  \expandafter\@ifdefinable\csname #1\endcsname
    {\@definecounter{#1}%
     \expandafter\xdef\csname the#1\endcsname{\@prfcounter{#1}}%
     \global\@namedef{#1}{\@prf{#1}{#2}}%
     \global\@namedef{end#1}{\@endproof}}}
\def\@oprf#1[#2]#3{%
  \@ifundefined{c@#2}{\@nocounterr{#2}}%
    {\expandafter\@ifdefinable\csname #1\endcsname
    {\global\@namedef{the#1}{\@nameuse{the#2}}%
  \global\@namedef{#1}{\@prf{#2}{#3}}%
  \global\@namedef{end#1}{\@endproof}}}}
\def\@prf#1#2{%
  \refstepcounter{#1}%
  \@ifnextchar[{\@yprf{#1}{#2}}{\@xprf{#1}{#2}}}
\def\@xprf#1#2{%
  \@beginproof{#2}{\csname the#1\endcsname}\ignorespaces}
\def\@yprf#1#2[#3]{%
  \@opargbeginproof{#2}{\csname the#1\endcsname}{#3}\ignorespaces}
\def\@prfcounter#1{\noexpand\arabic{#1}}
\def\@prfcountersep{.}
\def\@beginproof#1#2{\trivlist\let\baselinestretch\@blstr
   \item[\hskip \labelsep{\scshape #1.}]\rmfamily}
\def\@opargbeginproof#1#2#3{\trivlist\let\baselinestretch\@blstr
      \item[\hskip \labelsep{\scshape #1\ (#3).}]\rmfamily}
\def\@endproof{\endtrivlist}
\newcommand*{\qed}{\hbox{}\hfill$\Box$}

\@ifundefined{@biboptions}{\xdef\@biboptions{numbers}}{}
\InputIfFileExists{\jobname.spl}{}{}
\RequirePackage[\@biboptions]{natbib}

\newwrite\splwrite
\immediate\openout\splwrite=\jobname.spl
\def\biboptions#1{\def\next{#1}\immediate\write\splwrite{%
   \string\g@addto@macro\string\@biboptions{%
    ,\expandafter\strip@prefix\meaning\next}}}

\let\baselinestretch=\@blstr

\ifnum\jtype=1
 \RequirePackage{geometry}
 \geometry{twoside,
  paperwidth=210mm,
  paperheight=297mm,
  textheight=562pt,
  textwidth=384pt,
  centering,
  headheight=50pt,
  headsep=12pt,
  footskip=12pt,
  footnotesep=24pt plus 2pt minus 12pt,
 }
 \global\let\bibfont=\footnotesize
 \global\bibsep=0pt
 \if@twocolumn\global\@twocolumnfalse\fi
\else\ifnum\jtype=3
 \RequirePackage{geometry}
 \geometry{twoside,
  paperwidth=8.5in,%210mm,
  paperheight=11in,%297mm,
  textheight=684pt,
  textwidth=516pt,
  centering,
  headheight=50pt,
  headsep=12pt,
  footskip=18pt,
  footnotesep=24pt plus 2pt minus 12pt,
  columnsep=2pc
 }
 \global\let\bibfont=\footnotesize
 \global\bibsep=0pt
 \if@twocolumn\input{fleqn.clo}\fi
\else\ifnum\jtype=5
 \RequirePackage{geometry}
 \geometry{twoside,
  paperwidth=8.5in,%210mm,
  paperheight=11in,%297mm,
  textheight=684pt,
  textwidth=516pt,
  centering,
 headheight=50pt,
  headsep=12pt,
  footskip=18pt,
  footnotesep=24pt plus 2pt minus 12pt,
  columnsep=18pt
 }%
 \global\let\bibfont=\small%\footnotesize
 \global\bibsep=0pt
%% \input{fleqn.clo}
 \global\@twocolumntrue
%%
%% End of option '5p'
%%
\fi\fi\fi
\def\journal#1{\gdef\@journal{#1}}
 \let\@journal\@empty
 
\def\preprint#1{\gdef\@preprint{#1}}
%%\def\journalname#1{\gdef\@journalname{#1}}
\def\vol#1{\gdef\@vol{#1}}\let\@vol\@empty
\def\jyear#1{\gdef\@jyear{#1}}\let\@jyear\@empty
 \def\pages#1{\gdef\@pages{#1}}\let\@pages\@empty
 \def\received#1{\gdef\@received{#1}}\let\@received\@empty
 \def\accepted#1{\gdef\@accepted{#1}}\let\@accepted\@empty
 \def\published#1{\gdef\@published{#1}}\let\@published\@empty
\newenvironment{frontmatter}{}{\maketitle}

\def\fig@type{figure}

\long\def\@makecaption#1#2{%
 \ifx\@captype\fig@type
\@figurecaption{#1}{#2}
\else   
\@tablecaption{#1}{#2}
\fi
}


%%%%%%%%%%%%%%%%%%%% Table
\def\toprule{\\[-11.2pt]\Hline\\[-6pt]}
\def\colrule{\\[-9.2pt]\Hline\\[-6.3pt]}
\def\botrule{\\[-5.2pt]\HHline}

\def\Hline{\noalign{\ifnum0=`}\fi\whiteink\hrule \@height.5pt depth0pt\blackink\futurelet
   \@tempa\@xhline}

\def\HHline{\noalign{\ifnum0=`}\fi\hrule \@height1pt depth0pt\futurelet
   \@tempa\@xhline}

\newdimen\tblwidth

\newbox\tempbox

\newbox\captempbox
\newdimen\tblcapwidth

\def\@tablecaption#1#2{%
\ifdim\wd\tempbox<\textwidth
  \hfil  \vbox{\hsize\tblwidth%\rule{\tblwidth}{1pt}\par\vspace*{-1pt}
  \tablecaptionfont{\tablenofont#1:}\ #2\par}%\cyan\blackink
\else
 \vbox{\hsize\tblwidth\tablecaptionfont{\tablenofont#1:}\ #2\par}%\cyan\blackink\rule{\tblwidth}{1pt}\par\vspace*{-1pt}
\else
\fi
}



\def\tbl#1#2{%
\setbox\captempbox=\hbox{\tablecaptionfont #1}%
\tblcapwidth\wd\captempbox
\setbox\tempbox=\hbox{\tablefont #2}%
\ifdim\wd\tempbox<\textwidth
\tblwidth\wd\tempbox
%%\caption{#1}
\centering{\tablefont  #2}\par\vspace*{3pt}
%\hspace*{2.2pt}\noindent{\vrule height1pt width\tblwidth}%cyan\blackink
\ifdim\wd\captempbox<\tblwidth\vspace*{-1.5pt}\else\vspace*{4.1pt}\fi
\else
\tblwidth\hsize
\advance\tblwidth-\wd\tempbox
   \rightskip\tblwidth plus1fill
\fi
\caption{#1}
}%



%%%%%%%Figure
\newdimen\marginvskip
\newdimen\figvskip
%
\newbox\capheighttempbox
\newdimen\capheight
%
\newdimen\tempdim
\newdimen\figtempdim

\newif\ifsidecap
\global\sidecapfalse

\newif\ifoutside
\global\outsidefalse


\newif\iffigurecaptionlong
\global\figurecaptionlongfalse

\def\figrule{\vbox to 0pt{\vrule height2pc width1pt}}

\long\def\@figurecaption#1#2{%
%%%  \ifdim\figwidth<3pc%192pt
%%%\figtempdim\figheight
%%%\advance\figtempdim-4.5pc
%%%     \tempdim\hsize
%%%     \advance\tempdim-1pc
%%%     \advance\tempdim-\figwidth
%%%     \hskip7.5pc\hbox{\figbox\unskip\hskip1pc}
%%%\vskip-\figheight
%%%\vspace*{\figvskip}
%%%     \noindent\vbox{\hsize6pc%\tempdim
%%%\noindent{\vrule height1pt width\hsize}\par\vspace*{-1.9pt}
%%%     \figcapfont{\fignofont #1}\unskip\hskip7.8pt#2\par}%\vskip\figtempdim%
%%%
%%%\else
\ifsidecap
\figtempdim\figheight
\advance\figtempdim-4.5pc
     \tempdim\hsize
     \advance\tempdim-1pc
     \advance\tempdim-\figwidth
     \hskip7.5pc\hbox{\figbox\unskip\hskip1pc}
\vskip-\figheight
\vspace*{\figvskip}
     \noindent\vbox{\hsize6pc%\tempdim
\noindent{\vrule height1pt width\hsize}\par\vspace*{-1.9pt}
     \figcapfont{\fignofont#1}\unskip\hskip7.8pt#2\par}%\vskip\figtempdim%


\else
%\hbox{\figbox\unskip\hskip1pc}
%%\noindent{\vrule height1pt width\hsize}\par\vspace*{-1.9pt}
{\fignofont#1:}\ \figcapnorfont#2
%\fi
\fi
}
%%
%
\newdimen\figwidth
\newdimen\figheight
%
\input epsf.def  
%\def\ArtDir{Art/}%
%

\newbox\figtempbox
\def\@thirdarg{}
%
\def\figurebox#1#2{%
\@ifnextchar[{\@figurebox{#1}{#2}}{\@figurebox{#1}{#2}[]}
}
%
\def\@figurebox#1#2[#3]{%
   \gdef\@thirdarg{#3}
    \ifx\@thirdarg\empty  
        \global\figheight=#1
        \global\figwidth=#2
     \else   
        \setbox\figtempbox=\hbox{\includegraphics{\@thirdarg}}
        \global\figwidth=\wd\figtempbox
        \setbox\figtempbox=\vbox{\includegraphics{\@thirdarg}}
        \global\figheight=\ht\figtempbox
     \fi}
%
\def\figbox{%
   \ifx\@thirdarg\empty%
%%       \vbox{\hsize\figwidth%
%%	      \hrule\hbox to\figwidth{\vrule\hfill\vbox to\figheight{\hsize\figwidth\vfill}\vrule}\hrule}%
   \else%
       \vbox{\hsize\figwidth%
	      \hbox to\figwidth{\vbox to\figheight{\hsize\figwidth\includegraphics{\@thirdarg}}}}%
   \fi}
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
%%\newif\ifsidecap
%%\global\sidecapfalse
%%
%%\newdimen\tempdim
%%\newdimen\figtempdim
%%
%%\newdimen\figvskip
%%
%%\long\def\@figurecaption#1#2{%
%%  \ifdim\figwidth<13pc%192pt
%%\figtempdim\figheight
%%\advance\figtempdim-4.5pc
%%     \tempdim\hsize
%%     \advance\tempdim-1pc
%%     \advance\tempdim-\figwidth
%%     \hskip7.5pc\hbox{\figbox\unskip\hskip1pc}
%%\vskip-\figheight
%%\vspace*{\figvskip}
%%     \noindent\vbox{\hsize6pc%\tempdim
%%\noindent{\vrule height1pt width\hsize}\par\vspace*{-1.9pt}
%%     {\fignofont #1}\unskip\hskip7.8pt\figcapfont#2\par}%\vskip\figtempdim%
%%
%%\else
%%\ifsidecap
%%
%%\figtempdim\figheight
%%\advance\figtempdim-4.5pc
%%     \tempdim\hsize
%%     \advance\tempdim-1pc
%%     \advance\tempdim-\figwidth
%%     \hskip7.5pc\hbox{\figbox\unskip\hskip1pc}
%%\vskip-\figheight
%%\vspace*{\figvskip}
%%     \noindent\vbox{\hsize6pc%\tempdim
%%\noindent{\vrule height1pt width\hsize}\par\vspace*{-1.9pt}
%%          {\fignofont #1}\unskip\hskip7.8pt\figcapfont#2\par}%\vskip\figtempdim%
%%
%%
%%\else
%%%\hbox{\figbox\unskip\hskip1pc}
%%%%{\bf #1} #2
%%     \hbox{\figbox\unskip\hskip1pc
%%     \noindent\vbox{\hsize10pc%\tempdim
%%     \figcapfont
%%     {\fignofont #1}\unskip\hskip7.8pt\figcapfont#2\par}}
%%\fi
%%\fi
%%}
%%%%
%%%
%%\newdimen\figwidth
%%\newdimen\figheight
%%%
%%\input epsf.def  
%%%\def\ArtDir{Art/}%
%%%
%%
%%\newbox\figtempbox
%%\def\@thirdarg{}
%%%
%%\def\figurebox#1#2{%
%%\@ifnextchar[{\@figurebox{#1}{#2}}{\@figurebox{#1}{#2}[]}
%%}
%%%
%%\def\@figurebox#1#2[#3]{%
%%   \gdef\@thirdarg{#3}
%%    \ifx\@thirdarg\empty  
%%        \global\figheight=#1
%%        \global\figwidth=#2
%%     \else   
%%        \setbox\figtempbox=\hbox{\includegraphics{\@thirdarg}}
%%        \global\figwidth=\wd\figtempbox
%%        \setbox\figtempbox=\vbox{\includegraphics{\@thirdarg}}
%%        \global\figheight=\ht\figtempbox
%%     \fi}
%%%
%%\def\figbox{%
%%   \ifx\@thirdarg\empty%
%%%%       \vbox{\hsize\figwidth%
%%%%	      \hrule\hbox to\figwidth{\vrule\hfill\vbox to\figheight{\hsize\figwidth\vfill}\vrule}\hrule}%
%%   \else%
%%       \vbox{\hsize\figwidth%
%%	      \hbox to\figwidth{\vbox to\figheight{\hsize\figwidth\includegraphics{\@thirdarg}}}}%
%%   \fi}
%%%


\AtBeginDocument{\@ifpackageloaded{hyperref}
  {\def\@linkcolor{blue}
   \def\@anchorcolor{blue}
   \def\@citecolor{blue}
   \def\@filecolor{blue}
   \def\@urlcolor{blue}
   \def\@menucolor{blue}
   \def\@pagecolor{blue}
\begingroup
  \@makeother\`%
  \@makeother\=%
  \edef\x{%
    \edef\noexpand\x{%
      \endgroup
      \noexpand\toks@{%
        \catcode 96=\noexpand\the\catcode`\noexpand\`\relax
        \catcode 61=\noexpand\the\catcode`\noexpand\=\relax
      }%
    }%
    \noexpand\x
  }%
\x
\@makeother\`
\@makeother\=
}{}}
%%
\def\appendixname{Appendix }
\renewcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \setcounter{equation}{0}
  \gdef\thefigure{\@Alph\c@section.\arabic{figure}}%
  \gdef\thetable{\@Alph\c@section.\arabic{table}}%
  \gdef\thesection{\appendixname~\@Alph\c@section}%
  \@addtoreset{equation}{section}%
  \gdef\theequation{\@Alph\c@section.\arabic{equation}}%
  \addtocontents{toc}{\string\let\string\numberline\string\tmptocnumberline}{}{}
}

%%%% \numberline width calculation for appendix.
\newdimen\appnamewidth
\def\tmptocnumberline#1{%
   \setbox0=\hbox{\appendixname}
   \appnamewidth=\wd0
   \addtolength\appnamewidth{2.5pc}
   \hb@xt@\appnamewidth{#1\hfill}
}

%% Added for work with amsrefs.sty

\@ifpackageloaded{amsrefs}%
  {}
  {%\let\bibsection\relax%
  \AtBeginDocument{\def\cites@b#1#2,#3{%
    \begingroup[%
        \toks@{\InnerCite{#2}#1}%
        \ifx\@empty#3\@xp\@gobble\fi
        \cites@c#3%
}}}

%%%Redefine font size for the document

\renewcommand\normalsize{%
   \@setfontsize\normalsize\@ixpt{11}
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\renewcommand\small{%
   \@setfontsize\small\@viiipt{10}%
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
   \@setfontsize\footnotesize\@viipt{9}%
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

\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
    {\@ssect{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}
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
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M #8\@@par}%
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
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
  \def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #4{%
        \@hangfrom{\hskip #1}%
          \interlinepenalty \@M {#5}\@@par}%
    \endgroup
  \else
    \def\@svsechd{#4{\hskip #1\relax #5}}%
  \fi
  \@xsect{#3}}

\renewcommand\bibname{REFERENCES}
\renewcommand\indexname{Index}
\renewcommand\figurename{FIGURE}
\renewcommand\tablename{TABLE}

\frenchspacing\tolerance=5000\raggedbottom
%%
%% Added for avoiding clash with cleveref.sty

\@ifpackageloaded{cleveref}%
 {}
 {\def\tnotetext[#1]#2{\g@addto@macro\@tnotes{%
    \refstepcounter{tnote}%
    \immediate\write\@auxout{\string\Newlabel{#1}{\thetnote}}
    \def\thefootnote{\ifcase\c@tnote\or\ding{73}\or\ding{73}\ding{73}\fi}%
    \footnotetext{#2}}}
%%%
  \def\fntext[#1]#2{\g@addto@macro\@fnotes{%
    \refstepcounter{fnote}%
    \immediate\write\@auxout{\string\Newlabel{#1}{\thefnote}}
    \def\thefootnote{\thefnote}%
    \global\setcounter{footnote}{\thefnote}%
    \footnotetext{#2}}}
%%%
  \def\cortext[#1]#2{\g@addto@macro\@cornotes{%
    \refstepcounter{cnote}%
    \immediate\write\@auxout{\string\Newlabel{#1}{\thecnote}}
    \def\thefootnote{\ifcase\thecnote\or$\ast$\or
    $\ast\ast$\fi}%
    \footnotetext{#2}}}
}

\usepackage{graphicx}
\usepackage{fix-cm}

\usepackage{mathpazo}
\usepackage{avant}
\DeclareMathAlphabet{\mathbfsfit}{\encodingdefault}{\sfdefault}{bx}{sl}


\frenchspacing
\clubpenalty=10000
\widowpenalty=10000
\tolerance=5000\raggedbottom
\def\thisbottomragged{\def\@textbottom{\vskip\z@ plus.0001fil
\global\let\@textbottom\relax}}
\pagestyle{headings}
\pagenumbering{arabic}

\endinput
%%
%% End of file `lhep.cls'.
