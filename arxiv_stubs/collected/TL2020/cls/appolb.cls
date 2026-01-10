%%
%% This is file `appolb.cls',
%% adapted from `article.cls' ver. 1997/10/10 v1.3x
%%
%% with Copyright info:
%%
%% Copyright 1993 1994 1995 1996 1997
%% The LaTeX3 Project and any individual authors listed elsewhere
%% in this file.
%% 
%% For further copyright information, and conditions for modification
%% and distribution, see the file legal.txt, and any other copyright
%% notices in this file.
%% 
%% This file defines the style for articles
%% to be published in Acta Physica Polonica B.
%% ----------------------------------------
%%   This file is distributed in the hope that it will be useful,
%%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%% 
%%   For error reports concerning UNCHANGED versions of this file
%%   contact via e-mail to acta@if.uj.edu.pl.
%% 
%---------------------------------------------------------
%	History:
%
% ver. 3.5 2022/02/15
% \appheadcs and \appheadit
% redefined to comply with the TeX-2021 method of applying font attributes 
%
% ver. 3.4.1 2021/08/26
% clean-up
% \def\TitlePageStyle{titpage} and use it in \maketitle
% ...
% ver. 3.3.2 2015/01/27
%  Added \newcommand\lambdabar
%
% ver. 3.3.1 2013/12/05
%  \over replaced by \frac
%
% ver. 3.02 2012/09/12
% appbsize.clo not used any more. Instead:
% \input{size11.clo}
% \setlength\headsep {16\p@}
%
% ver. 3.01 2010/12/15
% \DOI defined
% New \PACS command using \PACSsize
%   \def\PACSsize{\footnotesize}
% \ibid defined
%   \DeclareRobustCommand{\ibid}{{\it ibid.}\comsp}
%
% ver. 3.00 2009/07/17
% redakcja.sty is loaded when the option 'reda' is defined
% \usepackage{reda} not used any more
%
% ver. 2.02b 2002/10/04
% changes in preprint ...
%
% ver. 2.02 2002/01/25
% changes in preprint ...
%
% ver. 2.01 2002/01/10
% corr. bugs in the environment appendix
%
% ver. 1.2.04  2000.08.29
%	\tableofcontents adjusted for APPB and 4 opt. args added
%   which are max. length examples of appropriate numbers:
%   \tableofcontents [page][section][subsection][subsubsection]
% \part adjusted for APPB
%
% ver. 1.2.03  2000.04.20
%	new environment appendix, instead of command
% \def\@fnsymbol removed from \maketitle and 2 symbols added
% \DeclareRobustCommand for \ie etc. --- now OK in captions
%---------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\def\appolb@ver{3.5}
\ProvidesClass{appolb}
              [2022/02/15 v.\appolb@ver\space
 Acta Physica Polonica B]
\newif\ifRedakcja \Redakcjafalse
\newif\if@restonecol
\newif\if@titlepage
\newif\if@mbtit
\newif\if@html \@htmlfalse
\@titlepagefalse
\@twosidetrue  \@mparswitchtrue
\@mbtitfalse
%
% --- OPTIONS
%
\DeclareOption{reda}{\Redakcjatrue
%\ExecuteOptions{druk}%
}
\DeclareOption{draft}{\setlength\overfullrule{5pt}%
%\ifRedakcja\ExecuteOptions{a4paper}\fi
}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{HTML}{\@htmltrue}
%
%--- paper sizes
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{druk}
   {\setlength\paperheight {235mm}%
    \setlength\paperwidth  {160mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
%-----
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{mbtit}{\@mbtittrue}
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
%\DeclareOption*{\APPB@ver=\CurrentOption}%

\DeclareOption*{\ifRedakcja\PassOptionsToPackage{\CurrentOption}{redakcja}\else
\if@html\PassOptionsToPackage{\CurrentOption}{tex4ht}\else
\PackageWarning{appolb}{Unknown option `\CurrentOption'}\fi\fi
}
\ExecuteOptions{a4paper,final}
\ProcessOptions\relax
%\ifRedakcja\RequirePackage{redakcja}\fi
%\ifnum\APPB@ver<\APPB@curver\typeout{Old version}\fi
%
%
%-------------------------------------------------------------
%\setlength\paperheight{190mm}%
%\setlength\paperwidth{126mm}%

% \InputIfFileExists{../VolNo.tex}%
	% {\REDAinfo{Reading `../VolNo.tex'}}%
	% {}%

% \input{appbsize.clo}
\if@html
  \input{size10.clo}%
  % \RequirePackage[xhtml,charset=utf-8,html]{tex4ht}
  \RequirePackage[charset=utf-8,html]{tex4ht}
\else
  \input{size11.clo}%
\fi

\setlength\headsep {16\p@}

\textwidth=126mm
\textheight=190mm
    \setlength\@tempdima        {\paperwidth}
    \addtolength\@tempdima      {-\textwidth}
    \setlength\oddsidemargin    {.5\@tempdima}
    \addtolength\oddsidemargin  {-1in}
    \setlength\marginparwidth   {.5\@tempdima}
    \addtolength\marginparwidth {-\marginparsep}
    \addtolength\marginparwidth {-0.4in}
  \@settopoint\oddsidemargin
  \@settopoint\marginparwidth
  \setlength\evensidemargin  {\paperwidth}
  \addtolength\evensidemargin{-2in}
  \addtolength\evensidemargin{-\textwidth}
  \addtolength\evensidemargin{-\oddsidemargin}
  \@settopoint\evensidemargin
  \setlength\topmargin{\paperheight}
  \addtolength\topmargin{-2in}
  \addtolength\topmargin{-\headheight}
  \addtolength\topmargin{-\headsep}
  \addtolength\topmargin{-\textheight}
  \addtolength\topmargin{-\footskip}     % this might be wrong!
  \addtolength\topmargin{-.5\topmargin}
  \@settopoint\topmargin
%***************************************************************************
\DeclareFontFamily{T1}{appb}{}
\DeclareFontShape{T1}{appb}{m}{n}{<8>ecrm0800 <12>ecrm0700 <14.4>ecrm1440}{}
%\DeclareFontShape{T1}{appb}{bx}{n}{<24.88>ecbx0700 <29.86>ecbx0700 <35.83>ecbx0700}{}
\DeclareFontShape{T1}{appb}{bx}{n}{<24.88>ecbx1200 <29.86>ecbx1200 <35.83>ecbx1200}{}
\DeclareFontFamily{OT1}{appb}{}
\DeclareFontShape{OT1}{appb}{m}{n}{<8>cmr8 <12>cmr7 <14.4>cmr12}{}
\DeclareFontShape{OT1}{appb}{bx}{n}{<24.88>cmbx12 <29.86>cmbx12 <35.83>cmbx12}{}
\def\titlefont{\large\fontfamily{appb}\fontseries{m}\fontshape{n}\selectfont\ignorespaces}
\def\appHuge{\fontfamily{appb}\fontseries{bx}\fontshape{n}\fontsize{24.88pt}{30pt}\selectfont\ignorespaces}
\def\appHUge{\fontfamily{appb}\fontseries{bx}\fontshape{n}\fontsize{29.86pt}{36pt}\selectfont\ignorespaces}
\def\appHUGe{\fontfamily{appb}\fontseries{bx}\fontshape{n}\fontsize{35.83pt}{42pt}\selectfont\ignorespaces}

% \def\appheadcs{\small\scshape}
% \def\appheadit{\small\itshape}
\def\appheadcs{\small\sc}
\def\appheadit{\small\it}

\def\appauthcs{\normalsize\scshape}
\def\appfont{\scriptsize\itshape}

\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}

\def\AbstractSize{\small}
\def\PACSsize{\footnotesize}
\renewcommand{\baselinestretch}{0.94}
%\setlength\paperheight{190mm}
%\setlength\paperwidth{126mm}

%\setlength\parskip{\z@ \@plus \p@}
\parskip=0pt plus 1pt
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{1}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{1}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{0}
\renewcommand\floatpagefraction{1}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{1}
\renewcommand\dblfloatpagefraction{1}
% \let\ThePage\thepage
\def\ThePage{\thepage}
\if@twoside
  \def\ps@headings{%
		\let\@oddfoot\@empty
		% \def\@oddhead{{\slshape\rightmark}\phantom{00}\hfil{\small\ThePage}}%
		\def\@oddhead{{\rightmark}\phantom{00}\hfil{\small\ThePage}}%
		\let\@evenfoot\@empty
		% \def\@evenhead{{\small\ThePage}\phantom{00}\hfil\slshape\leftmark}%
		\def\@evenhead{{\small\ThePage}\phantom{00}\hfil\leftmark}%
		\let\@mkboth\markboth
	}
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
    % \def\@oddhead{{\slshape\rightmark}\hfil\ThePage}%
    \def\@oddhead{{\rightmark}\hfil\ThePage}%
    \let\@mkboth\markboth
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \thesection\quad
        \fi
        ##1}}}}%
\fi

\def\ps@titpage{%
	% \def\@oddfoot{\ifPreprint~\else\hfil\small(\ThePage)\hfil\fi}%
	\def\@oddfoot{\hfil\small(\ThePage)\hfil}%
	\let\@evenfoot\@oddfoot
	% \let\@evenfoot\@empty
	\let\@evenhead\@empty
	\def\@oddhead{\ifRedakcja\titleheading
		\else
			\ifPreprint\hfill\prep@head\hfill\else ~\fi
		\fi
		}%
	\let\@mkboth\@gobbletwo
	\let\sectionmark\@gobble
	\let\subsectionmark\@gobble
	}

% --- page number only
\def\ps@plain{%
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@evenhead{{\small\ThePage}\hfil}%
  \def\@oddhead{\hfil{\small\ThePage}}%
}

\newif\ifPreprint
\Preprintfalse
\def\prepNo{}
\def\prep@head{}
\long\def\preprint#1{\Preprinttrue\long\gdef\prepNo{#1}}
\newcount\volume \volume=0
\let\pageno=\c@page
\newcount\No     \No=0
% \def\pub@date{0}

\def\titleheading{\ifPreprint~\else\small\rm Vol.~\thevolume\ (\theyear)
  \hfil {\appfont ACTA PHYSICA POLONICA B} \hfil No \theNo\fi}
\def\thevolume{\ifnum\volume=0
?\else \the\volume\fi}
\def\theyear{\ifnum\year=0
????\else\the\year\fi}
\def\theNo{\ifnum\No=0
?\else\the\No\fi}

\def\runhead{\ifPreprint ~\else\jobname ~~ printed on \today\fi}
\def\thetitle{\ifRedakcja Use $\backslash${\tt headtitle\{...\}}\else\runhead\fi}
\def\headtitle#1{\gdef\thetitle{#1}}

\def\and{\\\vskip6pt and\\\vskip6pt}
%\def\authorskip{\\\vskip12pt}
\def\thenames{\ifRedakcja Use $\backslash${\tt headauthor\{...\}}\else\runhead\fi}
\def\headauthor#1{\gdef\thenames{#1}}

% \def\Out@received{(Received \@date )}
\def\Out@received{{\small\itshape Received \@date}}
% \def\Out@published{published online \pub@date}
% \newcommand\thePublished{published online \pub@date}

\let\WERS\MakeUppercase
%\let\WERS\uppercase

\def\title#1{\gdef\@title{#1}}
\newskip\AdrSkip \AdrSkip=12pt plus 0pt minus 0pt
%\newskip\RcvSkip \RcvSkip=12pt plus 0pt minus 0pt
\newskip\TitSkip \TitSkip=52pt plus 0pt minus 0pt
% \newskip\TitSkip \TitSkip=26pt plus 0pt minus 0pt

\def\address#1{\par\vskip\AdrSkip{\small\rm #1}}
\def\received#1{\date{#1}}
\def\PACS#1{\par\noindent\strut\kern18pt{\PACSsize\rm PACS numbers: #1}\par}

\def\TitlePageStyle{titpage}
\def\AtMkTitleEnd{\relax}
\if@titlepage % --- not adapted
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
				\begin{tabular}[t]{c}%
					\@author
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
		\global\let\@thanks\@empty
		\global\let\@author\@empty
		\global\let\@date\@empty
		\global\let\@title\@empty
		\global\let\title\relax
		\global\let\author\relax
		\global\let\date\relax
		\global\let\and\relax
	}
\else % (\if@titlepage) --- adapted
	\newcommand\maketitle{%
		\begingroup
			\renewcommand\thefootnote{\@fnsymbol\c@footnote}%
			\def\@makefnmark{\@textsuperscript{\normalfont\@thefnmark}}%
			\if@twocolumn
				\ifnum \col@number=\@ne
					\@maketitle
				\else
					\twocolumn[\@maketitle]%
				\fi
			\else
				\newpage
				\global\@topnum\z@ % Prevents figures from going at top of page.
				\@maketitle
			\fi
			% \thispagestyle{titpage}%
			\thispagestyle\TitlePageStyle
			\@thanks
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
		\markboth{\appheadcs\thenames\hfil}{\hfil\appheadit\thetitle}%
% \markboth{\textsc{\thenames}\hfil}{\hfil\textit{\thetitle}}
% \markboth{\sc\thenames\hfil}{\hfil\it\thetitle}
	}

	\def\@maketitle{%
		\newpage

		\ifPreprint\vbox to\TitSkip{\parindent=0pt\prepNo\vfill}\else
		\vbox{\vskip\TitSkip}\fi

		{\centering
			\let \footnote \thanks
			\if@mbtit\mathversion{bold}\fi
			{\let\\=\break
			%	\def\@fnsymbol##1{\ensuremath{\ifcase##1\or *\or **\or {\char42}{\char42}{\char42}\else\@ctrerr\fi}}%
				\def\@makefnmark{\@textsuperscript{\normalfont\large\@thefnmark}}%
				\titlefont\@title\par
				\ifnum\value{footnote}<3\setcounter{footnote}{3}\fi
				}%
			\mathversion{normal}%
			\vskip\AdrSkip
			{\appauthcs
			\@author
			\par}%
			\vskip\AdrSkip
			\par
			%
			\Out@received
			% \if0\@date\vskip12pt\relax\else{\small\itshape\Out@received}\fi
			% \if0\pub@date\relax\else{;\par\small\itshape\Out@published}\fi
			\par
			\AtMkTitleEnd
		}%
	}%
\fi % end of \if@titlepage

\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
%\newcounter {paragraph}[subsubsection]
%\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thesection {\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection .\@arabic\c@subsubsection}
%\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
%\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
\newcommand\part{\par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\string\indent@wid\space\thepart.#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >\m@ne
       \Large\bfseries %\partname~
       \setbox0=\hbox{\thepart .\hskip 0.5em}
       \hangindent=\wd0
       \hangafter=1
       \unhbox0
       %\par\nobreak
     \fi
     \Large \bfseries #2%
     %\markboth{}{}
     \par
     }%
    \nobreak
    \vskip 3ex
    \@afterheading}

\def\@spart#1{%
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \Large \bfseries #1\par}%
     \nobreak
     \vskip 3ex
     \@afterheading}

%%%%%%%%%%%%%%%    SECTIONS

% \section etc. defined in article.cls
% \@startsection {NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE}
% \z@ = 0pt
% if BEFORESKIP < 0 the no parindent for the first paragraph
\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {3.5ex \@plus 1ex \@minus .2ex}%
                                   {1.3ex \@plus.2ex}%
                                   {\normalfont\normalsize\bfseries\mathversion{bold}\centering}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {3.25ex\@plus 1ex \@minus .2ex}%
                                     {1ex \@plus .2ex}%
                                     {\normalfont\normalsize\it\centering}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {3.25ex\@plus 1ex \@minus .2ex}%
                                     {1ex \@plus .2ex}%
                                     {\normalfont\footnotesize\bfseries\mathversion{bold}}}

% \@seccntformat is LaTeX command
\renewcommand\@seccntformat[1]{\csname the#1\endcsname .~}

%\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
%                                    {3.25ex \@plus1ex \@minus.2ex}%
%                                    {-1em}%
%                                    {\normalfont\normalsize\bfseries}}
%\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
%                                       {3.25ex \@plus1ex \@minus .2ex}%
%                                       {-1em}%
%                                      {\normalfont\normalsize\bfseries}}
\setlength\leftmargini  {2.5em}
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\setlength\leftmarginv  {1em}
\setlength\leftmarginvi {1em}
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
  	\let\ooocite=\cite
  	\let\oooref=\ref
%<???>
  	\def\cite{\GenericError{}{References are not allowed in abstracts}{}{Abstracts must be self-contained.^^JIf you really must refer to anything^^Jgive an explicit reference or description.}}
%  	\def\cite{\errhelp{relax}\errmessage{References are not allowed in abstract}}
		\let\ref\cite
				\topsep=0.5\AdrSkip
				\list{}{\listparindent 1.5em
				    \itemindent\listparindent
				    \leftmargin\parindent
				    \rightmargin\leftmargin
				\AbstractSize
				}\item\relax}
      {\endquotation\let\cite=\ooocite\let\ref\oooref}
\fi

%%%%%%%%%%%%%%%%  EQUATIONS

\newif\ifeq@sec
\eq@secfalse

\def\eqsec{%
\eq@sectrue
\def\theequation{\thesection.\@arabic\c@equation}%
\@addtoreset{equation}{section}%
}

\newlength{\eqcolsep}

\def\inc@eqCount{\stepcounter{equation}}
\def\dec@eqCount{\global\advance\c@equation\m@ne}
%---> \eqnarray is LaTeX command
%\def\equation{$$\refstepcounter{equation}}
%\def\endequation{\eqno \hbox{\@eqnnum}$$\@ignoretrue}
\renewenvironment{eqnarray}{%
   \inc@eqCount
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne\hskip \eqcolsep \hfil${##}$\hfil
      &\global\@eqcnt\tw@ \hskip \eqcolsep
         $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
         \tabskip\z@skip
      \cr
}
{%
      \@@eqncr
      \egroup
%      \global\advance\c@equation\m@ne
      \dec@eqCount
   $$\@ignoretrue
}

\def\@@eqncr{\let\reserved@a\relax
    \ifcase\@eqcnt \def\reserved@a{& & &}\or \def\reserved@a{& &}%
     \or \def\reserved@a{&}\else
       \let\reserved@a\@empty
       \@latex@error{Too many columns in eqnarray environment}\@ehc\fi
     \reserved@a \if@eqnsw\@eqnnum\inc@eqCount\fi
     \global\@eqnswtrue\global\@eqcnt\z@\cr}
\let\@seqncr=\@eqncr
%----------------------------------------------------------------
\newcounter{eqlett}

\newenvironment{eqletters}{%
\inc@eqCount \setcounter{eqlett}{0}%
\edef\@currentlabel{\theequation}%
\let\@oeq\theequation
%\ifeq@sec
%\def\theequation{\thesection.\@arabic\c@equation\alph{eqlett}}%
%\else
%\def\theequation{\@arabic\c@equation\alph{eqlett}}%
%\fi
\def\theequation{\@oeq\alph{eqlett}}%
\def\inc@eqCount{\addtocounter{eqlett}{1}}%
\def\dec@eqCount{\addtocounter{eqlett}{-1}}%
\def\equation{$$\stepcounter{eqlett}%
   \def\@currentlabel{\p@equation\theequation}%
}\bgroup
}
{%\ignorespaces
\egroup%\ignorespaces
\@ignoretrue
%\relax
}

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
%\if@compatibility
%\newenvironment{titlepage}
%    {%
%      \if@twocolumn
%        \@restonecoltrue\onecolumn
%      \else
%        \@restonecolfalse\newpage
%      \fi
%      \thispagestyle{empty}%
%      \setcounter{page}\z@
%    }%
%    {\if@restonecol\twocolumn \else \newpage \fi
%    }
%\else
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
%\fi
%\ifnum\APPB@ver<10203\relax\else
\newenvironment{appendix}[1][all]{\par
	\edef\org@scnt{\the\value{section}}
	\edef\org@sscnt{\the\value{subsection}}
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}%
	\edef\arg@{#1}%
	\def\opt@all{all}%
	\def\opt@nolet{noletter}%
	\def\opt@noleq{noeqletter}%
	\ifx\arg@\opt@noleq
		\def\theequation{\@arabic\c@equation}%
		\let\arg@\opt@nolet
	\else
		\def\theequation{\thesection.\@arabic\c@equation}%
		\@addtoreset{equation}{section}%
	\fi
	%%--- Always turn on sec.num if \eqsec called
	\ifeq@sec
		\def\theequation{\thesection.\@arabic\c@equation}%
		\@addtoreset{equation}{section}%
	\fi
	\ifx\arg@\opt@nolet
		\renewcommand\@seccntformat[1]{\appendixname}%
	\else
		\renewcommand\@seccntformat[1]{\appendixname~\csname the##1\endcsname}%
	\fi
	%
	\let\org@section\section
	\let\org@c@secnumdepth\c@secnumdepth
	\c@secnumdepth=1
	\def\section ##1{%
%	\typeout{App section \the\c@secnumdepth}
		\org@section{}
		\def\x@temp{##1}%
		\ifx\x@temp\empty\relax\else \begin{center}
		\it
		%\bf\mathversion{bold}
%<???>
			\noexpand{##1}
			\end{center}%
			\fi
	}
}
{% \end command
	\let\section\org@section
	\let\c@secnumdepth\org@c@secnumdepth
	\setcounter{section}{\org@scnt}%
	\setcounter{subsection}{\org@sscnt}%
}
%\fi

%%%%%%%%%%%%%%%%%   FOOTNOTES
\def\@fnsymbol#1{\ensuremath
	{\ifcase#1\or *\or **\or {\char42}{\char42}{\char42}% \char42 = '*'
	\or \dagger          \or \ddagger	\or \mathsection
	\or \mathparagraph   \or \|       \or \dagger\dagger
  \or \ddagger\ddagger \or \mathsection\mathsection \or \mathparagraph\mathparagraph
  \else\@ctrerr\fi
  }%
}%

\def\footnoterule{\kern-3\p@
%  \hrule width .4\columnwidth
  \hrule width \columnwidth
  \kern 2.6\p@}

\long\def\@makefntext#1{%
\hbox to \hsize{%
\hbox to 18pt{\hss$\m@th^{\@thefnmark}$~}%
\vtop{%\rightskip 18pt%
\hangindent-18pt\hangafter0
\everypar{\hangindent-18pt\hangafter0}
#1}}}

\setlength\arraycolsep{6\p@}
\eqcolsep=\arraycolsep
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
%<???>
\def\fnum@figure{\figurename\thinspace\thefigure}
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
\def\fnum@table{\tablename~\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{4\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\small #1. #2}%
  \ifdim \wd\@tempboxa >\hsize
    {\small #1. #2}
  \else
    \global \@minipagefalse
    \hbox to .993\hsize{\hfil\box\@tempboxa\hfil}%
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
%--- see \tableofcontents
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}

%<???>
\newcommand\tableofcontents{%
  \@ifnextchar[{\setTOC@pwid}{\t@c}}

\newdimen\w@slab
\newdimen\w@sslab
\newdimen\w@ssslab

\def\setTOC@pwid[#1]{\setbox0=\hbox{#1}%
  \setlength\@tempdima{\wd0}%
  %\advance\@tempdima by -0.5em%
  \xdef\@pnumwidth{\the\@tempdima}%
  \advance\@tempdima by 1.0em%
  \xdef\@tocrmarg{\the\@tempdima}%
  \@ifnextchar[{\setTOC@slab}{\t@c}}

\def\setTOC@slab[#1]{\setbox0=\hbox{\bfseries ~#1}\global\w@slab=\wd0
  \@ifnextchar[{\setTOC@sslab}{\t@c}}

\def\setTOC@sslab[#1]{\setbox0=\hbox{~#1}\w@sslab=\wd0
  \@ifnextchar[{\setTOC@ssslab}{\t@c}}

\def\setTOC@ssslab[#1]{\setbox0=\hbox{~#1}\w@ssslab=\wd0\t@c}

\def\setTOChspacing{\let\t@c=\relax\@ifnextchar[{\setTOC@pwid}{}}

\setTOChspacing[11][1][1.1][2.1.1]

\newcommand\t@c{%
	\vspace*{24pt}%
	\centerline{\contentsname}%
	\vspace*{8pt}%
  \@starttoc{toc}%
}

\newcommand*\l@section{\@dottedtocline{1}{0em}{\w@slab}}
\newcommand*\l@subsection{\@dottedtocline{2}{1em}{\w@sslab}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{2em}{\w@ssslab}}

\def\indent@wid#1.{%
       \setbox0=\hbox{\bfseries #1.\hskip 0.5em}%
       \hangindent=\wd0
       \hangafter=1
       \unhbox0
}

\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \parindent \z@
      \dimen255=\@pnumwidth
      \divide\dimen255 by 6
      \rightskip \@pnumwidth
      \advance\rightskip by \dimen255
      \advance\rightskip by 1em
      \parfillskip -\rightskip
      {\leavevmode
       %\large
%\setlength\fboxsep{0\p@}
       \bfseries #1\hfil \hb@xt@\rightskip{\hfil #2}%
       \par}\par
       \nobreak
%       \if@compatibility
%         \global\@nobreaktrue
%         \everypar{\global\@nobreakfalse\everypar{}}%
%      \fi
    \endgroup
  \fi}
%\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
%\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\newcommand\listoffigures{%
    \section*{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
{
	\vskip24pt
	\centerline{\refname}%
	\kern8pt
	\small
  \list{\@biblabel{\@arabic\c@enumiv}}%
	  {\settowidth\labelwidth{\@biblabel{#1}}%
	    \leftmargin\labelwidth
	    \advance\leftmargin\labelsep
	    \@openbib@code
	    \usecounter{enumiv}%
	    \let\p@enumiv\@empty
	    \renewcommand\theenumiv{\@arabic\c@enumiv}%
			\parskip=0pt \parsep=0pt%
	    \small}%
	  \sloppy
	  \clubpenalty4000
	  \@clubpenalty \clubpenalty
	  \widowpenalty4000%
	  \sfcode`\.\@m
	}
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
                \columnseprule \z@
                \columnsep 35\p@
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
  
% ----  Acta names

\newcommand\contentsname{CONTENTS}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{REFERENCES}
\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\def\MoName#1{\ifcase#1\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
}
\def\today{\MoName{\month}\space\number\day, \number\year}
% ----  end of Acta names

\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{headings}
\markboth{\appheadcs\thenames\hfil}{\hfil\appheadit\thetitle}
% \markboth{\textsc{\thenames}\hfil}{\hfil\appheadit\thetitle}
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


%%%%%%%%%%%%%%%%%%%%    USEFUL DEFINITIONS

\def\anymode#1{\ifmmode #1\else $#1$\fi}

\def\comsp{%
	\@ifnextchar,\relax
	{\@ifnextchar\ \relax
		{\@ifnextchar:\relax
		 {\@ifnextchar:\relax
  {\ }}}}%
}
%\def\comsp{\futurelet\nx@ch\test@ch}\def\test@ch{\if\nx@ch,\relax\else\ifx\nx@ch:\relax\else\ \fi\fi}
\DeclareRobustCommand{\ie}{{\it i.e.}\comsp}
%\def\ie{{\it i.e.}\comsp}
\DeclareRobustCommand{\eg}{{\it e.g.}\comsp}
\DeclareRobustCommand{\cf}{{\it cf.}\comsp}
\DeclareRobustCommand{\etal}{{\it et~al.}\comsp}
\DeclareRobustCommand{\ibid}{{\it ibid.}\comsp}

%%%  for math mode:

\newcommand\lambdabar{%
\relax
\bgroup
\def\@tempa{\hbox{\raise.73\ht0
\hbox to0pt{\kern.25\wd0\vrule width.5\wd0
height.2pt depth.1pt\hss}\box0}}%
\mathchoice{\setbox0\hbox{$\displaystyle\lambda$}\@tempa}%
{\setbox0\hbox{$\textstyle\lambda$}\@tempa}%
{\setbox0\hbox{$\scriptstyle\lambda$}\@tempa}%
{\setbox0\hbox{$\scriptscriptstyle\lambda$}\@tempa}%
\egroup
}


\@ifundefined{frac} {%
  \def\half{{\textstyle{1\over 2}}}
  \def\Half{{1\over 2}}
}{
  \def\half{{\textstyle\frac12}}
  \def\Half{\frac12}}

\DeclareMathSymbol{\e}{\mathalpha}{operators}{`e}
%\DeclareMathSymbol{\Tr}{\mathop}{operators}{`e}
\def\Tr{\mathop{\operator@font Tr}\nolimits}
%\def\e{\mathop{\operator@font e}\nolimits}
\def\Eq#1{Eq. (\ref{#1})}

\def\seteqprefix#1{\renewcommand{\p@equation}{#1}}
\def\reseteqprefix#1{\setcounter{equation}{0}\renewcommand{\p@equation}{#1}}


\clubpenalty\@highpenalty
\widowpenalty\@highpenalty

\RequirePackage{latexsym}
%\endinput


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\xxxxxxxxxxxxxxxxxx
\def\eqalabel#1{\@bsphack
  \protected@write\@auxout{}%
         {\string\newlabel{#1}{{\p@equation\arabic{equation}}{\thepage}}}%
\@esphack}

\def\@eqlettcr{%
\if@eqnsw\@eqncr\stepcounter{eqlett}\addtocounter{equation}{-1}\else%
\@eqncr\fi%
}

\def\@@eqlettcr{\let\reserved@a\relax
    \ifcase\@eqcnt \def\reserved@a{& & &}\or \def\reserved@a{& &}%
     \or \def\reserved@a{&}\else
       \let\reserved@a\@empty
       \@latex@error{Too many columns in eqlettarray environment}\@ehc\fi
     \reserved@a \if@eqnsw\@eqnnum\stepcounter{eqlett}\fi
     \global\@eqnswtrue\global\@eqcnt\z@\cr}

\newenvironment{eqlettarray}{%
  \setcounter{eqlett}{1}
	\def\theequation{\@arabic\c@equation\alph{eqlett}}%
	\def\@@eqncr{\let\reserved@a\relax
    \ifcase\@eqcnt \def\reserved@a{& & &}\or \def\reserved@a{& &}%
     \or \def\reserved@a{&}\else
       \let\reserved@a\@empty
       \@latex@error{Too many columns in eqnarray environment}\@ehc\fi
     \reserved@a \if@eqnsw\@eqnnum\stepcounter{eqlett}\fi
     \global\@eqnswtrue\global\@eqcnt\z@\cr}
     \eqnarray
}
{%
\endeqnarray
\ifnum\value{eqlett} >1\stepcounter{equation}\fi
}
% \newcommand{\DOI}[1]{doi:#1}
% \newcommand{\DOI}[1]{\relax}
\ifRedakcja\RequirePackage{redakcja}\fi
\endinput
%% End of file `appolb.cls'.
