%%
%% This is file `owrart.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% owrart.dtx  (with options: `class')
%%
%%% ====================================================================
%%% @LaTeX-file{
%%%   filename  = "owrart.cls",
%%%   version   = "1.36",
%%%   date      = "2019-12-12",
%%%   author    = "Oliver Wienand, Christoph Weber",
%%%   copyright = "Copyright 2004 - 2020, Mathematisches Forschungsinstitut Oberwolfach
%%%                all rights reserved.  Copying of this file is
%%%                authorized only if either:
%%%                (1) you make absolutely no changes to your copy,
%%%                including name; OR
%%%                (2) if you do make changes, you first rename it
%%%                to some other name.",
%%%   address   = "Mathematisches Forschungsinstitut Oberwolfach
%%%                Schwarzwaldstr. 9-11
%%%                77709 Oberwolfach
%%%                Germany",
%%%   telephone = "+49-7834-979-0",
%%%   email     = "reports@mfo.de",
%%%   abstract  = "This is the source for the owrart document class
%%%                designed for creating the Oberwolfach Reports.",
%%% }
%%% ====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{owrart}[2019/12/12 Oberwolfach Reports documentclass v1.36]
\RequirePackage{ifthen}
\global\let\if@withaddresses\iffalse
\DeclareOption{withaddresses}{\global\let\if@withaddresses\iftrue}
\global\let\if@report\iffalse
\DeclareOption{report}{\global\let\if@report\iftrue}
\DeclareOption*{\ClassWarning{owrart}{Unknown option \CurrentOption}}
\ProcessOptions\relax
\LoadClass[10pt]{amsart}
\if@withaddresses\RequirePackage{multicol}\fi
\setlength\paperheight {297mm}
\setlength\paperwidth  {210mm}
\newdimen\@Leftmargin   \@Leftmargin=42.5mm
\newdimen\@Rightmargin  \@Rightmargin=42.5mm
\newdimen\@Topmargin    \@Topmargin=48.5mm
\newdimen\@Bottommargin \@Bottommargin=48.5mm
\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-\@Leftmargin}
\addtolength{\textwidth}{-\@Rightmargin}
\setlength{\textheight}{\paperheight}
\addtolength{\textheight}{-\@Topmargin}
\addtolength{\textheight}{-\@Bottommargin}
\addtolength{\textheight}{-\headheight}
\addtolength{\textheight}{-\headsep}
\addtolength{\textheight}{-\footskip}
\setlength{\oddsidemargin}{\@Leftmargin}
\addtolength{\oddsidemargin}{-1truein}
\setlength{\evensidemargin}{\@Rightmargin}
\addtolength{\evensidemargin}{-1truein}
\setlength{\topmargin}{\@Topmargin}
\addtolength{\topmargin}{-1truein}
\setlength{\headheight}{12pt}
\newcommand{\owrheadrulewidth}{0.21pt}
\def\owrheadrule{\hrule\@height\owrheadrulewidth\@width\textwidth%
 \vskip-\owrheadrulewidth}
\def\@owrhead#1#2#3#4#5{#1\hbox to\textwidth{\vbox{\hbox
{\rlap{\parbox[b]{\textwidth}{\raggedright#2\strut}}\hfill
\parbox[b]{\textwidth}{\centering#3\strut}\hfill
\llap{\parbox[b]{\textwidth}{\raggedleft#4\strut}}}\owrheadrule}}#5}
\def\@loddowr{\if@reversemargin\hss\else\relax\fi}
\def\@roddowr{\if@reversemargin\relax\else\hss\fi}
\def\ps@owr{%
\ps@empty
\def\@oddhead{\@owrhead{\@roddowr}{\@reporthead}{}{\thepage}{\@loddowr}}%
\def\@oddfoot{}%
\def\@evenhead{\@owrhead{\@loddowr}{\thepage}{}%
{Oberwolfach Report \@reportnumber/\@reportyear}{\@roddowr}}%
\def\@evenfoot{}%
\let\@mkboth\markboth
}
\if@report\pagestyle{owr}\else\pagestyle{plain}\fi
\def\reporter#1{\gdef\@reporter{#1}}
\def\@reporter{\@latex@warning@no@line{No \noexpand\reporter specified}}
\def\reporterprefix#1{\gdef\@reporterprefix{#1}}
\def\@reporterprefix{Reporter:}
\def\reported{\vfill\hfill { \sl \@reporterprefix\ \@reporter}}
\def\reportyear#1{\gdef\@reportyear{#1}}
\def\@reportyear{\@latex@warning@no@line{No \noexpand\reportyear specified}}
\def\reportnumber#1{\gdef\@reportnumber{#1}}
\def\@reportnumber{\@latex@warning@no@line{No \noexpand\reportnumber specified}}
\def\workshoptype#1{\gdef\@workshoptype{#1}\gdef\@workshoptypecolon{#1: }}
\def\@workshoptype{\@latex@warning@no@line{No \noexpand\workshoptype specified}}
\def\@workshoptypecolon{}
\def\reportname#1{\gdef\@reportname{#1}%
\gdef\@reporthead{\ifthenelse{\equal{\@workshoptype}{Workshop}}{}{\@workshoptypecolon} #1}%
\gdef\@reporttitle{\ifthenelse{\equal{\@workshoptype}{Workshop}}{}{\@workshoptypecolon} #1}%
\gdef\@reporttoc{\@workshoptypecolon #1}}
\def\@reportname{\@latex@warning@no@line{No \noexpand\reportname specified}}
\def\reporthead#1{\gdef\@reporthead{#1}}
\def\@reporthead{\@latex@warning@no@line{No \noexpand\reporthead specified}}
\def\reporttitle#1{\gdef\@reporttitle{#1}}
\def\@reporttitle{\@latex@warning@no@line{No \noexpand\reporttitle specified}}
\def\reporttoc#1{\gdef\@reporttoc{#1}}
\def\@reporttoc{\@latex@warning@no@line{No \noexpand\reporttoc specified}}
\def\reportdate#1{\gdef\@reportdate{#1}}
\def\@reportdate{\@latex@warning@no@line{No \noexpand\reportdate specified}}
\def\organizers#1{\gdef\@organizers{#1}}
\def\@organizers{\@latex@warning@no@line{No \noexpand\organizers specified}}
\InputIfFileExists{\jobname.page}{}{\setcounter{page}{1}}
\newcommand{\resetcounters}{%
\setcounter{section}{0}
\setcounter{subsection}{0}
\setcounter{equation}{0}
\setcounter{footnote}{0}
\setcounter{figure}{0}
}
\def\owrsubjclassname{Mathematics Subject Classification (2010)}
\def\@owrsetsubjclass{%
  \Small{\itshape\owrsubjclassname:}\enspace\@subjclass\@addpunct.}
\renewcommand\maketitle{%
\@topnum\z@ % this prevents figures from falling at the top of page 1
\thispagestyle{empty}%
\begin{center}
  {\Large \sc Mathematisches Forschungsinstitut Oberwolfach}
     \vskip 45pt
  {\large Report No. \@reportnumber/\@reportyear }
    \vskip 12pt
  {\large DOI: 10.4171/OWR/\@reportyear/\@reportnumber }
    \vskip 20pt
  {\Large \bf \@reporttitle}

\vskip10pt
{\small Organized by \\
\@organizers}

\vskip20pt
{\large\@reportdate}

\vskip30pt
\end{center}
\@setabstracta
\ifx\@empty\@subjclass\else \bigskip\noindent\@owrsetsubjclass\fi
\normalsize\normalfont\vskip20pt
\let\maketitle\relax}
\newwrite\aidfd % a file descriptor for the aid file
\if@report\immediate\openout\aidfd \jobname.aid\fi
\newcommand{\@aindex}[3]{%
\begingroup
  \let\protect\noexpand% saves the german umlauts
  \write\aidfd{\string\aindexentry{#1}{#2}{#3}}
\endgroup}
\newcommand{\aindex}[2]{%
\@aindex{#1}{#2}{\thepage}}
\newwrite\mtfd % a file descriptor for the mt file
\renewcommand{\tableofcontents}{%
\vspace*{4mm}
\noindent {\large\bf \@reporttoc}

\bigskip
\noindent {\large \bf Table of Contents} \vspace*{8mm}

\makeatletter
\InputIfFileExists{\jobname.mt}
        {}
        {mt file missing -- run \LaTeX\ again!
         \typeout{mt file missing -- run LaTeX again!}}
\immediate\openout\mtfd \jobname.mt
\makeatother

\cleardoublepage}
\newcommand{\@mtitem}[3]{%
\begingroup
  \let\protect\noexpand% saves the german umlauts
  \write\mtfd{\string\mttitle{#1}{#2}{#3}}
\endgroup}
\newcommand{\mtitem}[2]{\@mtitem{#1}{#2}{\thepage}}
\newcommand{\mtcontentsline}[1]{%
\begingroup
  \let\protect\noexpand% saves the german umlauts
  \write\mtfd{\string\mttext{#1}}
\endgroup}
\newcommand{\mtdottedcontentsline}[1]{%
\begingroup
  \let\protect\noexpand% saves the german umlauts
  \write\mtfd{\string\mttextpage{#1}{\thepage}}
\endgroup}
\newcommand\@dotsep{2}
\renewcommand\@pnumwidth{2.05em}
\newcommand\@pautwidth{3em}
\newcommand\@ptitwidth{2em}
\renewcommand{\@tocrmarg}{2.6em}
\def\mtauthorline#1#2#3{%
    \vskip \z@ \@plus.2\p@
    {\leftskip #1\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #1\relax\@afterindenttrue
     \interlinepenalty\@M
     \hyphenpenalty\@M
     \leavevmode
     \@tempdima #2\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     \rightskip\@pautwidth plus4em \parfillskip-\@pautwidth
     {#3}\nobreak
     \leaders\hbox{}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor}%
     \par}%
}
\def\mttitleline#1#2#3#4{%
    \vskip \z@ \@plus.2\p@
    {\leftskip #1\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #1\relax\@afterindenttrue
     \interlinepenalty\@M
     \hyphenpenalty\@M
     \leavevmode
     \@tempdima #2\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     \rightskip\@ptitwidth plus8em \parfillskip-\@ptitwidth
     {#3}
     \nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     %\nobreak{\hfil\normalfont \normalcolor\ #4}
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #4}%
     \par}%
}
\newcommand{\mttitle}[3]{%
\mtauthorline{0em}{1.5em}{#1}

\nopagebreak
\mttitleline{1.5em}{0em}{\em #2}{#3}

\medskip}
\newcommand{\mttext}[1]{%
\mtauthorline{0em}{0em}{#1}

\medskip}
\newcommand{\mttextpage}[2]{%
\mttitleline{0em}{0em}{#1}{#2}

\medskip}
\newenvironment{introduction}{%
\centerline{\large\bf Introduction by the Organizers}

\bigskip}%
{\cleardoublepage}
\newenvironment{talk}[4][]
{\resetcounters\noindent\parbox{\textwidth}{%
\begin{center}%
\textbf{\boldmath #3}\\[\smallskipamount]\textsc{#2}%
\if@report\@aindex{#4}{#2}{\thepage}\fi%
\ifx\@empty#1\@empty{\@mtitem{#2}{#3}{\thepage}}%
\else{\@mtitem{#2 (joint with #1)}{#3}{\thepage}\\[\smallskipamount]%
(joint work with #1)}\fi%
\end{center}}\par\nopagebreak\bigskip\nopagebreak}%
{\bigskip\bigskip\goodbreak}
\newenvironment{talk*}[3][]
{\resetcounters\noindent\parbox{\textwidth}{%
\begin{center}%
\textbf{#3}\\[\smallskipamount]\textsc{#2}%
\ifx\@empty#1\@empty{}%
\else{\\[\smallskipamount](joint work with #1)}\fi%
\end{center}}\par\nopagebreak\bigskip}%
{\bigskip\bigskip\goodbreak}
\newenvironment{report}
{\begin{center}{\Large \bf Abstracts}\end{center}\bigskip \bigskip}
{\vfill\reported
\if@withaddresses\InputIfFileExists{\jobname.adr}{}%
{\ClassWarning{owrart}{Missing file \jobname.adr (list of participants)}}\fi}

\workshoptype{Workshop}

\endinput
%%
%% End of file `owrart.cls'.

