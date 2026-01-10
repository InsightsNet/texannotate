%========================== jps-cp.cls =============================
%
%-for JPS Conference Proceedings %
% Based on jpsj.sty ver. 1.1
% Version 0.1
%-Released on October 5, 2016 
%=================================================================

\typeout{***** Document Class =<<<jps-cp.cls>>>= ver. 0.1 ******}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{jps-cp}[2016/10/05 ver. 0.1 JPS Conf. Proc. document class]

\RequirePackage{amsmath}[1997/03/20]
\RequirePackage{amssymb}
\RequirePackage[dvipdfmx]{graphicx}
\RequirePackage{cite}
%\RequirePackage{overcite}
%\renewcommand\citeright{)}
%\def\@citess#1{\textsuperscript{#1\citeright}}

\def\jpsj@warning{\ClassWarningNoLine{jps-cp}}
\def\jpsjversion{0.1}

%\newif\if@ip
%\DeclareOption{ip}{\@iptrue}
%\newif\if@st
%\DeclareOption{st}{\@sttrue}
%\newif\if@l
%\DeclareOption{letter}{\@ltrue}
%\newif\if@sn
%\DeclareOption{shortnote}{\@sntrue}
%\newif\if@comment
%\DeclareOption{comment}{\@commenttrue}
%\newif\if@addenda
%\DeclareOption{addenda}{\@addendatrue}
%\newif\if@errata
%\DeclareOption{errata}{\@erratatrue}

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

\newif\if@header
\DeclareOption{header}{%
	\@headertrue
}

\ExecuteOptions{a4paper}
\ProcessOptions\relax

\allowdisplaybreaks[4]

\frenchspacing
%\@twosidetrue
%\AtBeginDocument\sloppy
%\AtEndDocument{\label{lastpage}}

%\def\@typeset{\sffamily Typeset with jpsj3.cls $<$ver.{\space}\jpsjversion$>$}
%\def\@jpsjmark{J.{\space}Phys.{\space}Soc.{\space}Jpn.}
%\def\@JPSJmark{Journal of the Physical Society of Japan}
%\def\@fpmark{\textbf{FULL PAPERS}}
%\def\@ipmark{\textbf{INVITED REVIEW PAPERS}}
%\def\@stmark{\textbf{SPECIAL TOPICS}}
%\def\@lmark{\textbf{LETTERS}}
%\def\@snmark{\textbf{SHORT NOTES}}
%\def\@cmmark{\textbf{COMMENTS}}
%\def\@admark{\textbf{ADDENDA}}
%\def\@ermark{\textbf{ERRATA}}
%\@ifundefined{jpage}{\def\jpage{Vol.\ No.\ pp.}}{}
%\@ifundefined{runtitle}{\def\runtitle{Title of the Article}}{}
%\@ifundefined{runauthor}{\relax}{}
%\def\runauthor{Author Name}}{}
%\@ifundefined{pvol}{\def\pvol{\null}}{}
%\@ifundefined{pyear}{\def\pyear{\null}}{}

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

\def\doi{10.1143/JPSJ.\pvol.S\supplno\artno}

\DeclareMathOperator{\textIm}{Im}
\DeclareMathOperator{\textRe}{Re}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\Tr}{Tr}

\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{1}
\setlength\parskip{\z@}

\setlength{\textwidth}{440\p@}
\setlength{\textheight}{637\p@}
\hoffset5\p@
\if@lp
\voffset-1.2cm
\else
\voffset-.5cm
\fi
\setlength\topmargin{26\p@}
\setlength\headheight{10\p@}
\setlength\headsep{26\p@} 
\setlength\topskip{13\p@}
\setlength\parindent{18\p@}
\setlength\footskip{26\p@}
\addtolength\textheight{\topskip}
\setlength{\columnsep}{13\p@}

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

\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xipt{13}%
   \abovedisplayskip 11\p@ \@plus3\p@ \@minus6\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\newcommand\small{%
   \@setfontsize\small\@xpt{12}
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 6\p@ \@plus2\p@ \@minus2\p@
               \parsep \z@ \@plus2\p@ \@minus\p@
               \itemsep \z@ %\parsep
               }%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\footnotesize{%
   \@setfontsize\footnotesize\@ixpt{11}%
   \abovedisplayskip 8\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\scriptsize{\@setfontsize\scriptsize\@viiipt{9.5}}
\newcommand\tiny{\@setfontsize\tiny\@vipt\@viipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}
\newcommand\Large{\@setfontsize\Large\@xivpt{18}}
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\newcommand\huge{\@setfontsize\huge\@xxpt{25}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

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

\newcount\@appendixflag
\newcount\@appendixindex

\if@seceq
\@addtoreset{equation}{section}
\renewcommand{\theequation}{%
 \ifnum\c@section>\z@\thesection.\fi \@arabic\c@equation}
\fi

\newcommand\@secapp{}

\newcommand\section{\@startsection{section}{1}{\z@}%
                   {1\baselineskip}%
                   {1\baselineskip}%
                   {\raggedright\normalfont\large\bfseries\boldmath}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                   {1\baselineskip}%
                   {\p@}%
                   {\raggedright\normalfont\normalsize\itshape}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                   {1\baselineskip}%
                   {\p@}%
                   {\raggedright\normalfont\normalsize\itshape}} 
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                   {\z@}{-1em}%
                   {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{4}{\parindent}%
                   {\z@}{-1em}%
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
             \edef\@svsec{\@secapp \csname the#1\endcsname\hskip1em}
         \else
             \edef\@svsec{\@secapp \csname the#1\endcsname:\hskip1em}
         \fi
         \else
           \ifx\thesection\@nullstring
             \edef\@svsec{\@secapp \csname the#1\endcsname\hskip1em}
           \else
             \edef\@svsec{\@secapp \csname the#1\endcsname.\hskip1em}
           \fi
         \fi
       \else
         \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname\hskip1em}
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

\setlength\leftmargini {2em}
\setlength\leftmarginii {1em} 
\setlength\leftmarginiii {1em} 
\setlength\leftmarginiv {1em} 
\setlength\leftmarginv {1em}
\setlength\leftmarginvi {1em}
\setlength\leftmargin{\leftmargini}
\setlength\labelwidth{\leftmargini\advance\labelwidth-\labelsep}
\setlength\labelsep {.5em} 
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
              \itemsep \z@  %\parsep
              }
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

\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}

%%%% bibliography %%%%
\def\thebibliography#1{%
	\par
	\vskip1\baselineskip
	\noindent
	\textbf{\refname}
		\small
		\list{[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}
		\leftmargin\labelwidth
		\advance\leftmargin\labelsep
		\usecounter{enumi}}
		\sloppy
		\sfcode`\.=500\relax
	}
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
 \kern 4\p@ %2.6\p@
 }

\newcommand\refname{References}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\appendixname{Appendix}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{4\p@}
\setlength\belowcaptionskip{4\p@}

%\newcount\halfflag
%\halfflag=0

%%%%%%%%%% caption %%%%%%%%%%%
\long\def\@makecaption#1#2{%
  \small
  \vskip\abovecaptionskip
%  \sbox\@tempboxa{#1\hskip1em#2}%
%  \ifdim \wd\@tempboxa > \hsize
  \par\noindent
    #1\hskip1em#2\par
%  \else
%    \global \@minipagefalse
%    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
%  \fi
  \vskip\belowcaptionskip
}

\long\def\@caption#1[#2]#3{%
	\par
	\begingroup
	\@parboxrestore
	\@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}
	\par
	\endgroup
}

\newcounter{figure}
\def\thecaption{\@arabic\c@figure}
\def\fps@figure{tbph}
\def\ftype@figure{1}
\def\fnum@figure{{\bfseries\figurename\hskip.5em\thefigure.}}
\newcounter{table}
\def\thetable{\@Roman\c@table}
\def\fps@table{tbp}
\def\ftype@table{2} 
\def\fnum@table{{\bfseries\tablename\hskip.5em\thetable.}}

\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
               
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}

\newenvironment{table}
               {\@float{table}}
               {\end@float}
               
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}

%\newenvironment{halffigure}
%               {\halfflag=1\@float{figure}}
%               {\end@float}
%               
%\newenvironment{fullfigure}
%               {\halfflag=0\@dblfloat{figure}}
%               {\end@dblfloat}
%
%\newenvironment{halftable}
%               {\halfflag=1\@float{table}}
%               {\end@float}
%               
%\newenvironment{fulltable}
%               {\halfflag=0\@dblfloat{table}}
%               {\end@dblfloat}

\def\tabular{%
  \vskip.5em
%  \begin{center}
  \let\@halignto\@empty%
  \small\@tabular
}
\def\endtabular{%
	\crcr\egroup\egroup $\egroup %\end{center}
	}

%%%%%%%%%%%%%
% maketitle %
%%%%%%%%%%%%%

\def\maketitle{%
\par
\begingroup
	\renewcommand\thefootnote{\@fnsymbol\c@footnote}
	\def\@makefnmark{\hskip1\p@\@textsuperscript{\normalfont\@thefnmark}}
    \long\def\@makefntext##1{%
	        \hangindent8\p@ \hangafter1 \noindent
            \hb@xt@1em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
\global\@topnum\z@
\@maketitle 
%%\thispagestyle{jpsj}
\@thanks
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
\raggedright
\null
\vskip1\baselineskip
	{%
	\parbox{440\p@}{\raggedright\LARGE\bfseries\boldmath\@title}\par
	}

\vskip1\baselineskip
	{%
	\parbox{400\p@}{\raggedright\normalsize\@author}\par
	}

\vskip.5\baselineskip
	{%
	\parbox{400\p@}{\raggedright\small\itshape\@inst}\par
	}

\vskip.5\baselineskip
\@ifundefined{@email}{}{%
	\parbox{400\p@}{\small\itshape E-mail:{\space}\@email}\par
	}

\vskip.5\baselineskip
	\@ifundefined{@recdate}{}{\small%
	(Received\space\@recdate)\par
	}

\gdef\@recdate{}

\vskip1\baselineskip
	\@ifundefined{@abst}{}{%
	\parbox{400\p@}{\small\@abst}\par
	}

\vskip.5\baselineskip
	\@ifundefined{@kword}{}{%
	\parbox{400pt}{\raggedright\small\sffamily{\bfseries KEYWORDS:}\hskip.5em\@kword}\par
	}

\thispagestyle{firstpage}
\vskip3\baselineskip
}

\long\def\abst#1{\long\gdef\@abst{#1}}
\long\def\inst#1{\long\gdef\@inst{#1}}
\long\def\email#1{\long\gdef\@email{#1}}
\long\def\kword#1{\long\gdef\@kword{#1}}
\def\recdate#1{\gdef\@recdate{#1}}

%%%%%%Definition of headings%%%%%%
\mark{{}{}}

\def\ps@headings{%
	\footnotesize
	\let\@mkboth\markboth
	\def\@oddfoot{\small\hfill{\thepage}\hfill}
	\let\@evenfoot\@oddfoot
	\if@header
	\def\@evenhead{\small%
		\underline{\hbox to\textwidth{{J. Phys. Soc. Jpn. \textbf{\pvol} (\pyear) S\supplno\artno}\hfill{Supplment{\space}\supplno}}}
			}
		\else
	\def\@evenhead{\relax}
		\fi
	\let\@oddhead\@evenhead
	}

\def\ps@firstpage{%
	\footnotesize
	\let\@mkboth\markboth
	\def\@oddfoot{\small\hfill{\thepage}\hfill}
	\let\@evenfoot\@oddfoot
	\if@header
	\def\@evenhead{\small%
		\vbox{%
		\underline{\hbox to\textwidth{{Journal of the Physical Society of Japan \textbf{\pvol} (\pyear) S\supplno\artno}\hfill{Supplment{\space}\supplno}}}\\[2pt]
		{\suppltitle}\hfill{DOI:\space\doi}
		}
	}
		\else
	\def\@evenhead{\relax}
		\fi
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

%%
%% Acknowledgements
%%
%
%\newenvironment{acknowledgment}{\par%
%  \if@l\footnotesize\paragraph{Acknowledgment}
%    \else
%  \if@sn\footnotesize\paragraph{Acknowledgment}
%    \else
%  \if@comment\footnotesize\paragraph{Acknowledgment}
%    \else
%  \if@addenda\footnotesize\paragraph{Acknowledgment}
%    \else
%      \section*{Acknowledgment}
%      \fi
%     \fi
%    \fi
%  \fi}
%{\relax}
%\newenvironment{acknowledgments}{\par%
%  \if@l\footnotesize\paragraph{\footnotesize Acknowledgments}
%    \else
%  \if@sn\footnotesize\paragraph{\footnotesize Acknowledgments}
%    \else
%  \if@comment\footnotesize\paragraph{\footnotesize Acknowledgments}
%    \else
%  \if@addenda\footnotesize\paragraph{\footnotesize Acknowledgments}
%    \else
%      \section*{Acknowledgments}
%        \fi
%      \fi
%    \fi
%  \fi}
%{\relax}
%\newenvironment{acknowledgement}{\par%
%  \if@l\footnotesize\paragraph{\footnotesize Acknowledgement}
%    \else
%  \if@sn\footnotesize\paragraph{\footnotesize Acknowledgment}
%    \else
%  \if@comment\footnotesize\paragraph{\footnotesize Acknowledgement}
%    \else
%  \if@addenda\footnotesize\paragraph{\footnotesize Acknowledgmeent}
%    \else
%      \section*{Acknowledgement}
%      \fi
%     \fi
%    \fi
%  \fi}
%{\relax}
%\newenvironment{acknowledgements}{\par%
%  \if@l\footnotesize\paragraph{\footnotesize Acknowledgements}
%    \else
%  \if@sn\footnotesize\paragraph{\footnotesize Acknowledgements}
%    \else
%  \if@comment\footnotesize\paragraph{\footnotesize Acknowledgements}
%    \else
%  \if@addenda\footnotesize\paragraph{\footnotesize Acknowledgements}
%    \else
%      \section*{Acknowledgements}
%        \fi
%      \fi
%    \fi
%  \fi}
%{\relax}

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
  {1\baselineskip \@plus\p@ \@minus\p@}%
  {\p@ \@plus\p@ \@minus\p@}%
  {\raggedright\normalfont\normalsize\bfseries\boldmath}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\endinput
%% End of file `jps-cp.cls'.
