%%  Copyright (c) 1997, Russel Winder.
%%  With DMTCS-specific alterations by Jeremy Thompson (September 1997)
%%
%%  Copyright (c) 1998-2015 Jens Gustedt
%%
\def\EAT#1: #2\endEAT{\expandafter\gdef\csname rcs#1\endcsname{#2}}
\def\RCSdef$#1$\endRCSdef{\xdef\RCSA{#1}\expandafter\EAT\RCSA\endEAT}
\def\MajMin#1.#2\endMajMin{\def\rcsMaj{#1}\gdef\rcsMin{#2}}
\def\rcsMajMin{\expandafter\MajMin\rcsRevision\endMajMin}
\def\IdNum#1#2#3#4#5#6#7#8#9\endIdNum{\def\fileversion{rev #1#2#3#4#5#6#7#8... (git)}}
\def\fileIdScan#1 #2 #3\endfileIdScan{%
\xdef \fileversion{#2}%
\xdef\xxXxx{XXX}%
\ifx\fileversion\xxXxx%
\xdef \fileversion{#1}%
\expandafter\IdNum\fileversion\endIdNum%
\else%
\xdef \fileversion{rev #2 (svn)}%
\fi%
}
\def\IdScan$#1: #2 ${%
\fileIdScan#2 XXX YYY\endfileIdScan%
}
\IdScan$Id: b4d1f048711b5809305c73fcf33974404bfef7f4 $
\def \filedate{2016/5/12}
\def \docdate{\filedate}
\newcommand \JOURNAL{Discrete Mathematics and Theoretical Computer Science}
\newcommand \journalacronym{dmtcs}
\newcommand \JOURNALACRONYM{DMTCS }
\newcommand \JOURNALHOME{http://dmtcs.episciences.org/}
\newcommand \VOLUMEHOME{\JOURNALHOME}
\newcommand \VOLUMEABREV{DMTCS vol. }
\newcommand \ISSN{1365--8050}
\newif \if@@draft
\NeedsTeXFormat{LaTeX2e}
\usepackage{ifthen}
\ProvidesClass{dmtcs-episciences}[\filedate \space \fileversion \space \JOURNALACRONYM Paper class]
\DeclareOption{11pt}{\ClassError{\journalacronym}{Option `11pt' not supported}{}}
\DeclareOption{12pt}{\ClassError{\journalacronym}{Option `12pt' not supported}{}}
\DeclareOption{twocolumn}{\ClassError{\journalacronym}{Option `twocolumn' not supported}{}}
\DeclareOption{draft}{\setlength\overfullrule{5\p@}\@@drafttrue}
\newcommand{\@unplug}[2]{\message{[unplugging #1 in #2]}
  \expandafter\def\csname #1\endcsname{%
    \ClassError{dmtcs}{#1 not allowed in #2}{^^J%
      *****************************************************************^^J%
      ************** #1 not allowed in #2 *********************^^J%
      Please read the corresponding instructions in the sample document^^J%
      *****************************************************************}%
  }}
\AtBeginDocument{
\@unplug{epsfig}{document}%
\@unplug{psfig}{document}%
\@unplug{epsbox}{document}%
\@unplug{epsfile}{document}%
}
\DeclareOption{ojs} {%
\AtBeginDocument{
\renewcommand \JOURNALHOME{http://www.dmtcs.org/dmtcs-ojs/index.php/}
\renewcommand \VOLUMEHOME{\JOURNALHOME volumes/}
\renewcommand \publicationdetails[4]{%
   \getinfo%
   \message{page is #3--\lastpage^^J}%
   \gdef \@firsthead{\href{\VOLUMEHOME}{\textit{\JOURNAL}}\hfill%
     \href{\VOLUMEHOME dm#1ind.html}{\VOLUMEABREV \textbf{#1}, #2, #3--#4}}%
    \setcounter{page}{#3}%
    \gdef \@copyright{\ISSN\ \copyright\ #2 Discrete Mathematics and
      Theoretical Computer Science (DMTCS), Nancy, France}
  }
}
}
\DeclareOption{submission} {%
\AtBeginDocument{\renewcommand{\ISSN}{subm.~to \JOURNALACRONYM}%
\publicationdetails{(subm.)}{by the authors}{\@version}{rev}{}
\setcounter{page}{1}
}
\def\@version{1}%
\newcommand\revision[1]{\def\@version{#1}}%
\def\processDates#1, #2\endprocessDates{#1}%
}
\newcommand\getinfo{\xdef\lastpage{\thepage}}%
\newcommand\setinfo{\protected@write\@auxout{}{%
\string\setcounter{page}{\thepage}^^J%
}%
}%
%
%
%%%%%%%%%%%%% journal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{final}{\setlength\overfullrule{\z@}\@@draftfalse
%\AtBeginDocument{\ifthenelse{\isodd\thepage}{}{%
%    \message{Warning: page counter incremented to start on an odd numbered page}%
%    \addtocounter{page}{1}}}
\gdef\processDates#1, #2\endprocessDates{%
  \def\pArg{#1}%
  \ifx\pArg\empty%
  \else%
  \bgroup%
  \message{found #1 and #2.}%
  \processDate#1\endprocessDate%
  \def\pArg{#2}%
  \ifx\pArg\empty%
  \else%
  ,{ }\let\processDateNext=\processDates%
  \processDateNext#2\endprocessDates%
  \fi%
  \egroup%
  \fi%
}
}
%%%%%%%%%%%%% proceedings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{proceedings}{\setlength\overfullrule{\z@}\@@draftfalse
\input{../volume-info}%
\input{previous}%
\def\JOURNAL{\publicationname}%
\renewcommand \VOLUMEHOME{\JOURNALHOME proceedings/}
\def\VOLUMEABREV{DMTCS proc. }%
%
\AtBeginDocument{%
\bgroup\def\pagestart#1{}\def\authorhead#1{}%
\def\keywords#1{}\def\titlehead#1{}\def\titlelong#1{}%
\def\pageend#1{%
\newcounter{fpage}
\setcounter{fpage}{#1}\addtocounter{fpage}{1}
\message{proceedings, previous is \previous}%
\publicationdetails{\publicationid}{\publicationyear}{\thefpage}{oo}%
}%
\input{../\previous/header}%
\egroup%
\ifthenelse{\isodd\thepage}{}{%
    \message{Warning: page counter incremented to start on an odd numbered page}%
    \addtocounter{page}{1}}%
\newwrite\@headerfile
\immediate\openout\@headerfile=header.tex
\protected@write\@headerfile{}{% automatically produced file^^J
\string\pagestart{\thepage}^^J%
}}
\AtEndDocument{\ifthenelse{\isodd\thepage}{%
    \message{Warning: trailing empty page added to end on an even numbered page}%
    \clearpage\ \ }{}%
\def\affiliationmark#1{}\def\thanks#1{}\def\ignorespaces{}
\protected@write\@headerfile{}{% automatically produced file^^J
\string\pageend{\thepage}^^J%
\string\authorhead{\@@authorhead}^^J%
\string\titlehead{\@titlehead}^^J%
\string\titlelong{\@title}^^J%
\string\keywords{\@keywords}^^J%
}%
\setinfo%
}%
\def\processDates#1, #2\endprocessDates{#1}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\reftexRun}{\RequirePackage[hypertex]{hyperref}}
\newcommand{\amsRun}{\RequirePackage{amsfonts}}
\DeclareOption{pdftex}{\renewcommand{\reftexRun}{\RequirePackage[pdftex]{hyperref}}}
\DeclareOption{nohyperref}{\renewcommand{\reftexRun}{}\newcommand{\href}[2]{#2}}
\newcommand{\timesRun}{\amsRun\RequirePackage{times}%\RequirePackage{mathptm}
}
\DeclareOption{notimes}{\renewcommand{\timesRun}{}}
\DeclareOption{noams}{\renewcommand{\amsRun}{}}
\DeclareOption{nomarks}{\AtBeginDocument{\@marksrequiredfalse}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\RequirePackage{ifpdf}
\RequirePackage{latexsym}
\RequirePackage{enumerate}
\ifpdf
  \message{PDF!}
  \RequirePackage[pdftex]{graphicx}
  \renewcommand{\reftexRun}{\RequirePackage[pdftex]{hyperref}}
  \newcommand{\inputfig}[1]{\csname input\endcsname{#1.pdftex_t}}
  \DeclareGraphicsRule{.pdftex}{pdf}{.pdftex}{}
\else
  \message{NO PDF!}
  \RequirePackage[dvips]{graphicx}
  \newcommand{\inputfig}[1]{\csname input\endcsname{#1.pstex_t}}
\fi
\timesRun
\reftexRun
\renewcommand\figurename{Fig.}
\renewcommand\tablename{Tab.}
\setlength \textheight{44pc}
\setlength \textwidth{35pc}
\setlength \headsep{12\p@}
\setlength \footskip{10\p@}
\setlength \oddsidemargin{10\p@}
\setlength \evensidemargin{21\p@}
\setlength \textfloatsep{13\p@ \@plus 2\p@ \@minus 4\p@}
\setlength \dbltextfloatsep{13\p@ \@plus 2\p@ \@minus 4\p@}
\setlength \parskip{\z@ \@plus 1\p@}
\setlength \parindent{10\p@}
\setlength \topsep{4\p@ \@plus 2\p@ \@minus 1\p@}
\setlength \partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
\def \title{\@ifnextchar[{\@gettitletwo}{\@gettitleone}}
\def \@gettitleone#1{\@gettitletwo[#1]{#1}}
\def \@gettitletwo[#1]#2{{%
    \gdef \@title{#2}%
    \def \thanks##1{\relax}%
    \def \\{\unskip \space \ignorespaces}%
    \gdef \@titlehead{#1}%
}}
\newcommand \affiliationmark[1]{%
    \if@marksrequired%
        $^{#1}$%
    \fi%
}
\newif \if@marksrequired
\def \author{\@ifnextchar[{\@getauthortwo}{\@getauthorone}}
\def \@getauthorone#1{\@getauthortwo[#1]{#1}}
\def \@getauthortwo[#1]#2{{%
    \global \@marksrequiredtrue%
    \global \let \latexand \and%
    \gdef \and{\mbox{}\hfil}%
    \gdef \@author{\if@@draft \strut \else \hfil #2\fi}%
    \def \thanks##1{\relax}%
    \def \\{\unskip \space \ignorespaces}%
    \@marksrequiredfalse%
    \gdef \@authorhead{\if@@draft \space \else #1\fi}%
    \gdef \@@authorhead{#1}
}}
\newcommand\address[1]{\message{address command no longer supported,
    you may publish address information on the episcience server, if
    you want to}}
\newcommand{\affiliation}[1]{\gdef\@affil{#1}}
\newcommand \publicationdetails[5]{%
  \getinfo%
    \gdef \@firsthead{\href{\VOLUMEHOME}{\textit{\JOURNAL}}\hfill%
      \href{\VOLUMEHOME #5}{\VOLUMEABREV \textbf{#1}:#3, #2, \##4}}%
    \gdef\Issue{#3}%
    \gdef\Number{#4}%
    \gdef \@copyright{ISSN \ISSN
      \hfill
      \copyright\ #2 by the author(s)
      \hfill
      Distributed under a Creative Commons Attribution 4.0 International License}
}
\def \@firsthead{\relax}
\def \@copyright{\ISSN\ \copyright\ 2005 Discrete Mathematics and
  Theoretical Computer Science (DMTCS), Nancy, France}
\def\processDate#1-#2-#3\endprocessDate{%
  \printdate{#3}{#2}{#1}%
}
\def\processDateNext#1, #2\endprocessDates{}%
\def \@received{\relax}
\newcommand
\received[1]{\gdef\@received{\emph{received \processDates#1, \endprocessDates}, }}
\def \@revised{\relax}
\newcommand \revised[1]{\gdef\@revised{\emph{revised \processDates#1, \endprocessDates}, }}
\def \@accepted{\relax}
\newcommand \accepted[1]{\def\@accepted{\emph{accepted \processDates#1, \endprocessDates}.}}
\def \@keywords{\relax}
\newcommand \keywords[1]{\gdef \@keywords{#1}}
\newcommand \@afterabstract@keywords[1]{%
    \gdef \@keywords{#1}%
    \@dokeywords%
}
\newcommand \@dokeywords{%
    {\small \noindent \textbf{Keywords:} \@keywords \par}%
    \vspace{10\p@}%
    \hrule \@height 1\p@%
    \vspace{10\p@}%
    \global \let \keywords \@gobbleone%
}
\newcommand \trykeywords{%
    \if \relax \@keywords%
        \global \let \keywords \@afterabstract@keywords%
    \else%
        \@dokeywords%
    \fi%
}
\renewcommand \part{}
\renewcommand \section{\@startsection {section}{1}{\z@}%
    {-10\p@ \@plus -3\p@ \@minus -2\p@}{6\p@ \@plus 1\p@ \@minus 1\p@}{\sffamily\Large}}
\renewcommand \subsection{\@startsection{subsection}{2}{\z@}%
    {-8\p@ \@plus -2\p@ \@minus -2\p@}{5\p@ \@plus 1\p@ \@minus 1\p@}{\sffamily\large\itshape}}
\renewcommand \subsubsection{\@startsection{subsubsection}{3}{\z@}%
    {-6\p@ \@plus -1 pt \@minus -1\p@}{4\p@ \@plus 1\p@ \@minus 1\p@}{\sffamily\large\itshape}}
\renewcommand \paragraph{\@startsection{paragraph}{4}{\z@}%
    {6\p@ \@plus 1\p@ \@minus -2\p@}{-1em}{\normalsize\bfseries}}
\renewcommand \subparagraph{\@startsection{subparagraph}{4}{\parindent}%
    {6\p@ \@plus 1\p@ \@minus 2\p@}{-1em}{\normalsize\bfseries}}
\renewcommand \appendix{%
    \par%
    \setcounter{section}{0}%
    \setcounter{subsection}{0}%
    \gdef \thesection{\Alph{section}}%
}
\renewcommand \footnoterule{\kern-3\p@ \hrule \@height 0.8\p@ \kern 2.2\p@}
\long \def \@makefntext#1{\hangindent 7\p@$^{\textrm{\@thefnmark}}$ #1}
\renewcommand \thefootnote{\fnsymbol{footnote}}
\long \def \@makecaption#1#2{%
    \vskip \abovecaptionskip%
    \small%
    \sbox \@tempboxa{\textbf{#1:} #2}%
    \ifdim \wd \@tempboxa > \hsize%
        \textbf{#1:} #2%
        \par%
    \else%
        \global \@minipagefalse%
        \hb@xt@ \hsize{\hfil \box\@tempboxa \hfil}%
    \fi%
    \vskip \belowcaptionskip%
}
\renewcommand \maketitle{\par%
    \begingroup%
        \def \thefootnote{\fnsymbol{footnote}}%
        \def \@makefnmark{\hb@xt@ \z@{$\m@th^{\@thefnmark}$\hss}}%
        \long \def \@makefntext##1{\parindent 1em\noindent
            \hb@xt@ 1.8em{\hss $\m@th^{\@thefnmark}$}##1}%
        \newpage%
        \global \@topnum \z@%
        \@maketitle%
        \thispagestyle{first}%
        \@thanks%
    \endgroup%
    \setcounter{footnote}{0}
    \renewcommand\thefootnote{(\roman{footnote})}
    \global \let \maketitle \relax%
    \global \let \@maketitle \relax%
    \gdef \and{\unskip\ignorespaces,\space}%
    \gdef \@thanks{}%
    \gdef \@address{}%
    \gdef \thanks##1{}%
    \gdef \affiliationmark##1{}%
    \gdef \@author{}%
    %\gdef \@title{}%
}
\newenvironment{titlesp}{%
    \list{}{\leftmargin \z@}\item[]%
}{\endlist}
\def \@maketitle{%
    \newpage%
    \null%
    \begin{titlesp}%
        {\sffamily \raggedright \hyphenpenalty=\@M \huge \textit{\@title} \par}%
        \vspace{16\p@}%
        {\Large \@author \par}%
        \vspace*{-2\p@}%
        %{\small \itshape \@address \par}%
        {
          \if@marksrequired%
          \begin{enumerate}[%
            ${}^1$%
            ]%
            \small \itshape\parsep=0pt\itemsep=-0.5ex%
            \let\\=\item%
            \\%
            \@affil%
          \end{enumerate}%
          \else%
          \begin{center}%
            \small \itshape\parsep=0pt\itemsep=-0.5ex%
            \@affil%
          \end{center}%
          \fi%
        }
        \vspace*{-2\p@}%
        \if \relax \@received \else {\small \textit{\@received} \par}\fi%
        \if \relax \@revised \else {\small \textit{\@revised} \par}\fi%
        \if \relax \@accepted \else {\small \textit{\@accepted} \par}\fi%
        \vspace{8\p@}%
        \hrule \@height 1\p@%
\vspace{2\p@}%
    \end{titlesp}%
}
\gdef\abstract{%
    \begin{titlesp}%
      \bgroup%
      \@unplug{cite}{abstract}%
      \@unplug{ref}{abstract}%
      \def\paragraph##1{\noindent\textbf{##1}\ \ignorespaces}
        \small%
        \vspace*{-2ex}%\\
}
\gdef\endabstract{%
  \egroup%
    \end{titlesp}%
    \trykeywords%
}
\newcommand \noabstract{\trykeywords}
\newcommand \acknowledgments{\section*{Acknowledgments}}
\newcommand \acknowledgements{\section*{Acknowledgements}}
\def \ps@first{%
    \let \@mkboth \@gobbletwo%
    \def \@oddhead{\normalfont \@firsthead \hss}%
    \def \@oddfoot{%
        \vbox to \z@{%
            \hb@xt@ \textwidth{\footnotesize \@copyright \hss}%
            \if@@draft \@typesetdetails \fi%
            \vss%
        }%
    }%
    \let \@evenhead = \@oddhead%
    \let \@evenfoot = \@oddfoot%
    \let \sectionmark = \@gobble%
    \let \subsectionmark = \@gobble%
}
\def \ps@journal{%
    \let \@mkboth \@gobbletwo%
    \def \@oddhead{%
\normalsize%
\ifodd \c@page%
    \textit{\@titlehead} \hfill \textrm{\thepage}%
\else%
            \textrm{\thepage} \hfill \textit{\@authorhead}%
        \fi%
    }
    \def \@oddfoot{\vbox to \z@{\if@@draft \@typesetdetails \fi \vss}}%
    \let \@evenhead = \@oddhead%
    \let \@evenfoot = \@oddfoot%
    \let \sectionmark = \@gobble%
    \let \subsectionmark = \@gobble%
}
\pagestyle{journal}
\let \ps@plain = \ps@journal
\let \ps@myheadings = \ps@journal
\let \ps@headings = \ps@journal
\newcount \hour
\newcount \minute
\hour \time
\divide \hour by 60
\minute \hour
\multiply \minute by 60
\advance \minute by -\time
\minute -\minute
\newcommand \printtime[2]{%
    \def \@printnum##1{%
        \ifnum ##1 < 10 %  NB. This space is CRUCIAL.
            0%
        \fi%
        \number ##1%
    }%
    \@printnum{#1}:\@printnum{#2}%
}
\newcommand \printdate[3]{%
    \def \@suffix##1{%
        \def \@n{##1}%
        \ifnum \@n = 1 st\else%
        \ifnum \@n = 2 nd\else%
        \ifnum \@n = 3 rd\else%
        \ifnum \@n = 21 st\else%
        \ifnum \@n = 22 nd\else%
        \ifnum \@n = 23 rd\else%
        \ifnum \@n = 31 st\else%
        th\fi \fi \fi \fi \fi \fi \fi%
    }%
    \relax%
    \number #1\raise0.7ex\hbox{\footnotesize \@suffix{#1}}\kern0.15em%
    \ifcase #2\or%
        Jan.\or Feb.\or Mar.\or%
        Apr.\or May\or June\or%
        July\or Aug.\or Sep.\or%
        Oct.\or Nov.\or Dec.%
    \fi\ %
    \number #3%
}
\def \today{\printdate{\day}{\month}{\year}}
\newcommand \@typesetdetails{%
    \vspace{35\p@}%
    \hb@xt@ \textwidth{\normalsize \textbf{\printtime{\hour}{\minute} %
    \today\ --- \JOURNAL\ \@copyright \hss}}%
}
\pagenumbering{arabic}
\flushbottom
\setcounter{page}{1}
% some commands for the convinience of the authors
\newcommand\email[1]{\message{email command no longer supported,
    you may publish address information on the episcience server, if
    you want to}}
\newcommand\addressmark[1]{\message{addressmark command no longer supported,
    please use affiliationmark if necessesary, instead}}
\newcommand{\qed}{\hfill$\Box$}
\def\@proof[#1]{\noindent\textbf{Proof #1:} \ignorespaces}
\def\@@proof{\noindent\textbf{Proof:} \ignorespaces}
\AtBeginDocument{
  \def\proof{\medskip\@ifnextchar[\@proof\@@proof}
  \def\endproof{\qed\medskip}
}
% Some commonly used 
\newcommand{\naturals}{\ensuremath{\mathbb N}}
\newcommand{\integers}{\ensuremath{\mathbb Z}}
\newcommand{\rationals}{\ensuremath{\mathbb Q}}
\newcommand{\reals}{\ensuremath{\mathbb R}}
\newcommand{\complexes}{\ensuremath{\mathbb C}}
\newcommand{\primes}{\ensuremath{\mathbb P}}
\endinput
%% 
%% End of file `dmtcs.cls'.
