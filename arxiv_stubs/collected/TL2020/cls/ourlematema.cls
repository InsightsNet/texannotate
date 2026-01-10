%%%% Class file for Le Matematiche
%%% Author: Giuseppe Bilotta
%%% Email (work): bilotta@dmi.unict.it
%%% Email (home): giuseppe.bilotta@gmail.com
%
% Additional commands:
%
% *  \authorline          : put the following authors on another line
% *  \submissiondatefalse : hide the submission date on the first article page
% *  \shortauthorstrue    : shorten the author names under the title
% *  \shortauthormark     : shorten the author names in the headings
% *  \noauthor            : suppress the need for an author

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lematema}[2009/03/22 v1.3
Class for articles in ``Le Matematiche'']

\newif\if@langsel
\@langselfalse
%%% Language options
\DeclareOption{english}{\PassOptionsToPackage{\CurrentOption}{babel}\@langseltrue}
\DeclareOption{french}{\PassOptionsToPackage{\CurrentOption}{babel}\@langseltrue}
\DeclareOption{italian}{\PassOptionsToPackage{\CurrentOption}{babel}\@langseltrue}

%%% draft/final
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareMathAlphabet{\mathcal}{OMS}{cmsy}{m}{n}

\ProcessOptions\relax

\if@langsel\else
\ClassWarning{lematema}{No language specified, defaulting to english}
\PassOptionsToPackage{english}{babel}
\fi

%%% Class based on the standard article class
\LoadClass[11pt,twoside]{article}
%%% Font: times (and math stuff)
\usepackage{mathptmx}
\usepackage{mathrsfs}
%%% Per usare la fonte ``cal`` oltre ad scr, premettere: \DeclareMathAlphabet{\mathcal}{OMS}{cmsy}{m}{n}
%%% Package `babel' for language management
\RequirePackage{babel}
%%% Package `url' for urls
\RequirePackage{url}
%%% Define an \email{...} command, but let's not use the url package for this
\newcommand{\email}[1]{{e-mail: \upshape\ttfamily#1}}

%%% AMS math environments and symbols
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}

%%% Bibliography
\RequirePackage[square,numbers,sort&compress,sectionbib]{natbib}
\bibliographystyle{alpha}
\def\bibhere{\bibliography{\jobname}}
\addto\captionsitalian{%
  \def\refname{Bibliografia}%
  \def\bibname{Bibliografia}%
}
\addto\captionsenglish{%
  \def\refname{References}%
  \def\bibname{References}%
}
\addto\captionsfrench{%
  \def\refname{Bibliographie}%
  \def\bibname{Bibliographie}%
}
% from the needspace package
\newcommand{\needspace}[1]{\begingroup\setlength{\dimen@}{#1}%
  \vskip\z@\@plus\dimen@ \penalty -100\vskip\z@\@plus -\dimen@
    \vskip\dimen@ \penalty 9999\vskip -\dimen@\endgroup}
%
\def\bibsection{%
  \par
  \needspace{4cm}
  \vspace{2cm}
  \centering{\MakeUppercase{\refname}}%
  \par
  \small
}
\setlength{\bibsep}{3pt}

% %\magnification\magstephalf
%%% Page geometry, using the `geometry' package
\RequirePackage[paperwidth=17cm,%
		paperheight=24cm,%
		footskip=0pt,%
		headsep=0.5cm,%
		headheight=0.5cm,%
		width=12.2cm,%
		%height=18.5cm,% overspecification, comment out
		left=2cm,%
		top=2cm,%
		bottom=2.5cm]{geometry}

%%% Our default head/foot style

\renewcommand{\ps@plain}{%
  \renewcommand{\@oddhead}{\hfill{\footnotesize\@htitle}\hfill\thepage}%
  \renewcommand{\@evenhead}{\thepage\hfill{\footnotesize\@hauthor}\hfill}%
  \renewcommand{\@oddfoot}{}%
  \renewcommand{\@evenfoot}{}%
}
\pagestyle{plain}

\def\@htitle{\textbf{(no title)}}
\def\@hauthor{\textbf{(no author)}}

%%% Footnotes
\renewcommand\footnoterule{%
  \hrule\@width.4\columnwidth
  \kern2.6\p@}

%%% Section styles
\def\@seccntformat#1{\csname the#1\endcsname.\quad}
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-24pt \@plus -6pt \@minus -3pt}%
                                   {\medskipamount}%
                                   {\normalfont\bfseries}}

%%% Theorem environments
\addto\captionsitalian{%
  \def\theoremname{Teorema}%
  \def\corollaryname{Corollario}%
  \def\lemmaname{Lemma}%
  \def\propositionname{Proposizione}%
  \def\definitionname{Definizione}%
  \def\examplename{Esempio}%
  \def\remarkname{Osservazione}%
  \def\notename{Nota}%
  \def\questionname{Domanda}%
  \def\problemname{Problema}%
  \def\conjecturename{Congettura}%
}
\addto\captionsenglish{%
  \def\theoremname{Theorem}%
  \def\corollaryname{Corollary}%
  \def\lemmaname{Lemma}%
  \def\propositionname{Proposition}%
  \def\definitionname{Definition}%
  \def\examplename{Example}%
  \def\remarkname{Remark}%
  \def\notename{Note}%
  \def\questionname{Question}%
  \def\problemname{Problem}%
  \def\conjecturename{Conjecture}
}
\addto\captionsfrench{%
  \def\theoremname{Th\'eor\`eme}%
  \def\corollaryname{Corollaire}%
  \def\lemmaname{Lemma}%
  \def\propositionname{Proposition}%
  \def\definitionname{D\'efinition}%
  \def\examplename{Exemple}%
  \def\remarkname{Remarque}%
  \def\notename{Note}%
  \def\questionname{Question}%
  \def\problemname{Probl\'eme}%
  \def\conjeturename{Conjecture}
}

\theoremstyle{plain}
\newtheorem{thm}{\theoremname}[section]
\newtheorem{cor}[thm]{\corollaryname}
\newtheorem{lemma}[thm]{\lemmaname}
\newtheorem{prop}[thm]{\propositionname}

\theoremstyle{definition}
\newtheorem{dfn}[thm]{\definitionname}
\newtheorem{exa}[thm]{\examplename}
\newtheorem{rem}[thm]{\remarkname}
\newtheorem{note}[thm]{\notename}
\newtheorem{que}[thm]{\questionname}
\newtheorem{prob}[thm]{\problemname}
\newtheorem{conj}[thm]{\conjecturename}

%%% Commands that define the article information
\let\originaltitlecmd\title
\def\title#1{\originaltitlecmd{#1}\titlemark{#1}}
\def\subtitle#1{\def\sub@title{#1}}
\subtitle{}
\def\titlemark#1{\gdef\@htitle{\MakeUppercase{#1}}}
\def\titlenote#1{\expandafter\@titlenote\expandafter{\the\@titlenote\thanks{#1}}}
\newtoks\@titlenote

\def\makeshortauthor#1#2 #3\relax{
\if@shortauthortoks
\expandafter\@shortauthortoks\expandafter{\the\@shortauthortoks\space - \MakeUppercase{#1}. \MakeUppercase{#3}}%
\else
\expandafter\@shortauthortoks\expandafter{\the\@shortauthortoks\MakeUppercase{#1}. \MakeUppercase{#3}}%
\@shortauthortokstrue
\fi
\def\@shortauthor{\the\@shortauthortoks}%
}
\newtoks\@shortauthortoks
\@shortauthortoks{}
\newif\if@shortauthortoks\@shortauthortoksfalse

\def\authormark#1{\gdef\@hauthor{\MakeUppercase{#1}}}
\def\author#1{%
\if@authortoks
\expandafter\@authortoks\expandafter{\the\@authortoks\space - \MakeUppercase{#1}}%
\else
\expandafter\@authortoks\expandafter{\the\@authortoks\MakeUppercase{#1}}%
\@authortokstrue
\fi
\makeshortauthor#1\relax%
\authormark{\the\@authortoks}%
\def\@author{\the\@authortoks}%
\@lastauthor{#1}%
}
\newtoks\@authortoks
\@authortoks{}
\newif\if@authortoks\@authortoksfalse
\newtoks\@lastauthor

\def\authorline@hyphen{ - }
\let\authorline@sep\authorline@hyphen
\def\authorline{%
\@authortoksfalse
\expandafter\@authortoks\expandafter{\the\@authortoks\protect\authorline@sep}%
\@shortauthortoksfalse
\expandafter\@shortauthortoks\expandafter{\the\@shortauthortoks\protect\authorline@sep}%
}

\def\shortauthormark{\authormark{\the\@shortauthortoks}}

\newif\if@author\@authortrue
\def\noauthor{\@authorfalse\gdef\@hauthor{\@htitle}}

\def\address#1{%
\expandafter\expandafter\expandafter\@addresstoks\expandafter\expandafter\expandafter{%
\expandafter\the\expandafter\@addresstoks\expandafter\par
\expandafter\bigskip
\expandafter\filbreak
\expandafter\MakeUppercase\expandafter{\the\@lastauthor}\\
#1}%
}
\newtoks\@addresstoks
\def\@address{\par\bigskip\begin{flushright}%
  \itshape
  \the\@addresstoks
\end{flushright}}
\AtEndDocument{\@address}

%% Mathematics Subject Classification
\def\MSC#1{\gdef\@MSC{#1}}
\def\@MSC{}
%% Keywords
\def\keywords#1{\gdef\@keywords{#1}}
\def\@keywords{}

%% Year/Volume/Number/First Page/Last Page
\def\LM@Year{????}
\def\LM@Vol{???}
\def\LM@Num{??}
\def\LM@FirstPg{??}
\def\LM@LastPg{??}
\def\LM@Doi{}

%% Redefine \date to parse a string yyyy/mm/dd, which will be used
%% as submission date
\newcounter{LM@year}
\newcounter{LM@month}
\newcounter{LM@day}
\def\date#1{\LM@parsedate#1\LM@enddate}
\def\LM@parsedate#1/#2/#3\LM@enddate{%
\setcounter{LM@year}{#1}%
\setcounter{LM@month}{#2}%
\setcounter{LM@day}{#3}%
}

%% turn a number/counter into an italian month
\def\@itmonth#1{\ifcase#1\or gennaio\or febbraio\or marzo\or aprile\or
maggio\or giugno\or luglio\or agosto\or settembre\or ottobre\or novembre\or
dicembre\else\textbf{??}\fi}
\def\itmonth#1{\expandafter\@itmonth\csname c@#1\endcsname}

\renewcommand{\maketitle}{%
  \begingroup
    \renewcommand\thefootnote{}%
    \def\@makefnmark{}%
    \long\def\@makefntext##1{\parindent 1em\noindent##1}%
    \newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
    \thispagestyle{empty}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@shortauthor\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\sub@title\@empty
  \global\let\title\relax
  \global\let\subtitle\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \global\let\MSC\relax
  \global\let\@MSC\relax
  \global\let\keywords\relax
  \global\let\@keywords\relax
  \global\let\titlenote\relax
  \global\let\@titlenote\relax
}

%% insert the article information in the top right corner

\def\@articleinfo{ }



\newif\ifshortauthors\shortauthorsfalse
%% Make the title page
\def\@maketitle{%
  \newpage
  \@articleinfo
  %% Submission date (at the bottom)
  %% MSC, if present
  \ifx\@MSC\empty\else\thanks{%
  \textit{AMS 2010 Subject Classification:} \@MSC
  }\fi%
  %% Keywords, if present
  \ifx\@keywords\empty\else\thanks{%
  \textit{Keywords:} \@keywords
  }\fi%
  \ifx\LM@Doi\empty
    \vskip 4.5truecm%
  \else
    \vskip 4.12truecm%
  \fi
  \begin{center}%
  \let \footnote \thanks
    {\def\\{\protect\linebreak}%
    \fontsize{12}{15}\selectfont\bfseries \MakeUppercase{\@title}
    \ifx\sub@title\empty\else\vskip5pt\fontsize{10}{14}\selectfont\bfseries \MakeUppercase{\sub@title}\fi
    %% Title note, if present
    \the\@titlenote
    \par}%
    \if@author
    \vskip 0.5truecm%
    {\fontsize{11.5}{14}\selectfont
      \begin{tabular}[t]{c}%
        \let\authorline@sep\tabularnewline
        \ifshortauthors\@shortauthor\else\@author\fi
      \end{tabular}\par
    }%
    \fi
  \end{center}%
  \par
  \vskip 0.5truecm}

\renewenvironment{abstract}{%
\small\quotation
}{%
\endquotation
}

% In case the author forgets it:
\AtBeginDocument{\maketitle}

\expandafter\IfFileExists\expandafter{\jobname.pub}{%
  \InputIfFileExists{\jobname.pub}{\typeout{Volume data loaded}}\relax%
  \c@page=\LM@FirstPg\relax
  \AtEndDocument{%
    \@bsphack
    \protected@write\@auxout{}%
      {\string\xdef\string\LM@LastPg{\thepage}}%
    \@esphack
  }%
}{}

