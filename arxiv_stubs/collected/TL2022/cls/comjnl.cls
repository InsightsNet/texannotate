\NeedsTeXFormat{LaTeX2e}[2009/07/27]
\ProvidesClass{comjnl}
          [2009/07/27 v0.1c The Computer Journal class (DPC)]
\def\CJ@err#1{\ClassError{cj}{#1}\@eha}
\def\CJ@warn#1{\ClassWarningNoLine{cj}{#1}}
\DeclareOption{12pt}{}
\DeclareOption{12pt}{\CJ@warn{11pt used (not optional)}}
\DeclareOption{12pt}{\CJ@warn{11pt used (not optional)}}
\DeclareOption{twoside}{}
%\DeclareOption{twocolumn}{}
%\DeclareOption{onecolumn}{\CJ@warn{twocolumn used (not optional)}}
\DeclareOption{mathptm}{%
  \def\CJ@fonts{\RequirePackage{times,mathptm}}}
\DeclareOption{mathtime}{%
  \def\CJ@fonts{\RequirePackage{times,mathtime}}}     %use for Mac
%  \def\CJ@fonts{\RequirePackage{times,mathtimy}}}    %use for PC
\DeclareOption{cmfonts}{%
  \let\CJ@fonts\relax}
\DeclareOption{epsfig}{\AtEndOfClass{\RequirePackage{epsfig}}}
\ExecuteOptions{cmfonts,epsfig}
\ProcessOptions
\LoadClass[a4paper,twoside,onecolumn]{article}
% tolerances
\pretolerance=6000
\tolerance=9500
\hbadness=5000
\vbadness=5000
\topmargin=0\p@
\emergencystretch=5pt
\sloppy
%
\RequirePackage{rotating}


\def\shortauthors#1{\gdef\@shortauthors{\scshape#1}}
\def\title{\@dblarg\CJ@title}
\def\CJ@title[#1]#2{%
  \def\@title{#2}%
  \def\@shorttitle{\scshape#1}}
\def\@title{\CJ@warn{No title}}
\def\@shorttitle{}
\newcounter{affil}
\newcounter{remaffil}
\def\author#1{%
  \g@addto@macro\@authors{%
    \@andorcomma,{\ignorespaces#1\unskip\affil@mark}}%
  \def\CJ@noaffil{\CJ@warn{No affiliation specified for #1}}}
\def\CJ@noaffil{%
 \CJ@err{No author specified}%
 \global\let\@andorcomma\relax
  \@gobbletwo}
\def\@authors{\relax\@gobbletwo}
\def\and{\CJ@err{\protect\and\space is not supported}}
\def\@andorcomma#1#2\@andorcomma#3{%
  \ifx#3\relax
    \ifx#1\relax%
      \let\@tempa\relax
    \else
    \def\@tempa{\space\andname\space #2\@gobbletwo}%
    \fi
  \else
    \def\@tempa{#1 #2\@andorcomma#3}%
  \fi
  \@tempa}
\def\affiliation#1{%
  \def\@tempa{#1}%
  \@tempswatrue
  \@affils
  \if@tempswa
    \stepcounter{affil}\setcounter{remaffil}{\theaffil}%
    \edef\@tempa##1{%
      \noexpand\g@addto@macro\noexpand\@affils{%
        \noexpand\doaffil{\theaffil}{##1}}}%
    \@tempa{#1}%
    \edef\@tempa{\noexpand\CJ@addaffil{\theaffil}}%
  \fi
  \expandafter\@tempa\@authors\relax\relax
  \let\CJ@noaffil\relax}
\let\@affils\@empty
\def\CJ@addaffil#1#2\relax#3\relax{%
  \def\@authors{#2\def\theaffil{#1}#3\relax}}
\def\doaffil#1#2{%
  \def\@tempb{#2}%
  \ifx\@tempa\@tempb
    \@tempswafalse
    \def\@tempa{\CJ@addaffil{#1}}%
  \fi}
\def\address#1{%
  \g@addto@macro\@authors{\textsuperscript{$*$}}%
  \def\@address{#1}%
  \def\address##1{%
    \CJ@err{You may only specify one correspondence address}}}
\def\@address{\CJ@warn{No correspondence address specified}}
%
%
%%SDH David's \email puts email addresses at the bottom of the page--wrong!
%\def\email#1{%
%  \g@addto@macro\@address{\endgraf\noindent(e-mail: #1)}%
%  \def\email##1{%
%    \CJ@err{You may only specify one correspondence email}}}
\def\email#1{%
\def\@email{Email: #1}%
}
%
\let\affil@mark\@empty
\def\keywords#1{%
  \gdef\@keywords{%
    \addvspace\medskipamount
    \noindent\strut{\itshape Keywords:\/} \ignorespaces#1\unskip}}
\def\@keywords{\ClassWarningNoLine{cj}{No keywords}}
\def\received#1{%
  \gdef\@received{\medskip\noindent\strut{\itshape Received #1}}}
\def\@received{\ClassWarningNoLine{cj}{No received date}}
\def\revised#1{%
  \gdef\@revised{{\itshape; revised #1}}} %SDH
\let\@revised\@empty
\def\accepted#1{%
  \gdef\@accepted{{\itshape; accepted #1}}}
\def\@accepted{\CJ@warn{No accepted date}}
\newbox\absbox
\def\abstract{\lrbox\absbox\minipage{.75\textwidth}%
  \hrule\@height.2pt
  \medskip
  \normalfont\bfseries\small
  \leftskip\fill
  \rightskip-\fill
  \parfillskip\stretch2}
\def\endabstract{\endminipage\endlrbox}
\def\maketitle{{%
  \long\def\@makefntext##1{\parindent 1em\noindent
    \@textsuperscript{\normalfont\@thefnmark}##1}%
  \twocolumn[%
    \thispagestyle{title}\label{FirstPage}%
    \normalfont\centering
     \vspace{-\headheight}\vspace{-\voffset}\vspace{-12\p@}%
    {\parbox[b]{.80\textwidth}{\centering
      {\Huge\@title\par}%
      \addvspace{17pt}% 
      \ifnum\c@affil>\@ne
        \def\affil@mark{\textsuperscript{\theaffil}}%
        \def\doaffil##1##2{\noindent\textsuperscript{##1}##2\par}%
      \else
        \def\doaffil##1##2{\noindent##2\par}%
      \fi
      \setcounter{affil}{1}%
      \CJ@noaffil
      \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
      \global\c@footnote\@ne
\ifnum\theremaffil>1 \typeout{caffil>1}
      \setcounter{footnote}{\theremaffil}
     \else \typeout{caffil not> 1}
      \setcounter{footnote}{0}\fi
      \def\@makefnmark{\@textsuperscript{\normalfont\@thefnmark}}%
      {\large\scshape\@authors\@andorcomma\relax\@andorcomma\relax\par}%
       \addvspace{15pt}% 75mm - 15.5pc - 12pt baseline from affils
      {\small\itshape\@affils}\par              %%SDH affils made italic--should really be addresses
      {\small\itshape\@email}\par               %%SDH Emails moved to correct place
      \addvspace\bigskipamount
      \usebox\absbox\par
     \addvspace\bigskipamount
     \small\itshape
     \@keywords\par
     \@received\@revised\@accepted\par
     \addvspace\bigskipamount
  }}%
  \hrule\@height.5pt
  \vspace{18pt}%
  ]%
  %{\def\thefootnote{\@fnsymbol\c@footnote}%
  % \footnotetext[1]{\def\\{\unskip, \ignorespaces}\@address}%
  % \@thanks}%
  \suppressfloats[t]}%
  \let\and\relax
  \let\affiliation\relax
  \let\author\relax
  \let\@affils\relax
  \let\keywords\relax
  \let\@keywords\relax
  \let\address\relax
  \let\email\relax
  \let\@address\relax
  \let\maketitle\relax
  \let\thanks\@gobble}
\def\ps@cj{%
  \def\@oddhead{%
    \CJ@ruledhead
      \relax
      \@shorttitle
      \thepage}%
  \def\@evenhead{%
    \vbox to \headheight{\vss
   \let\textsuperscript\@gobble
    \CJ@ruledhead
      \thepage
 %     {\@authors\@andorcomma\relax\@andorcomma\relax}%
     {\@shortauthors}%
      \relax}}%
  \def\@oddfoot{%
    \CJ@ruledhead\relax{%
      }\relax}%     \textsc\journalname,\quad\volumename\space\@volumenumber,\quad
        %\numbername\space\@issuenumber,\quad\@volumeyear
  \let\@evenfoot\@oddfoot}
\def\ps@title{%
  \def\@oddhead{%
    \vbox to \headheight{%
    \vfil
    \hrule \@height.5pt\@width\textwidth
    \vskip 14.5pt}}%
  \let\@evenhead\@oddhead
    \def\@oddfoot{%
    \CJ@ruledhead\relax{%  \textsc\journalname,\quad\volumename\space\@volumenumber,\quad
       %  \numbername\space\@issuenumber,\quad\@volumeyear
     }\relax}%
  \let\@evenfoot\@oddfoot}
\def\CJ@ruledhead#1#2#3{%
  \vbox{%
    \hrule \@height.5pt%
    \hbox to\textwidth{%
      \normalfont\vrule\@width\z@\@height 9.5pt\@depth 4.5pt%
      \rlap{#1}%
      {\hfil#2\hfil}%
      \llap{#3}}%
    \hrule\@height.5pt}}
\ps@cj
\def\@volumeyear{????}
\def\@volumenumber{??}
\def\@issuenumber{??}
\def\@startpage{\pageref{FirstPage}}
\def\@endpage{\pageref{LastPage}}
\def\volumeyear#1{\gdef\@volumeyear{#1}}
\def\volumenumber#1{\gdef\@volumenumber{#1}}
\def\issuenumber#1{\gdef\@issuenumber{#1}}
\def\startpage#1{\gdef\@startpage{#1}\c@page#1}
\def\endpage#1{\gdef\@endpage{#1}}
\def\lastpage@putlabel{%
  \advance\c@page\m@ne
   \immediate\write\@auxout{\string
   \newlabel{LastPage}{{}{\thepage}}}%
   \advance\c@page\@ne}
\AtEndDocument{%
   \clearpage\lastpage@putlabel}%
\def\enumerate{\ifnum \@enumdepth >3 \@toodeep\else
    \advance\@enumdepth \@ne 
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}\list
    {\csname label\@enumctr\endcsname}{\usecounter
    {\@enumctr}\def\makelabel##1{##1\hss}%
    \labelsep=3\p@\parsep=0pt\listparindent=0pt\itemsep=0pt\partopsep=0pt
    \rightmargin=0pt}\fi}
%
\def\itemize{\ifnum \@itemdepth >3 \@toodeep\else \advance\@itemdepth \@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list{\csname\@itemitem\endcsname}{\def\makelabel##1{##1\hss}%
    \labelsep=3\p@\parsep=0pt\listparindent=0pt\itemsep=0pt\partopsep=0pt
    \rightmargin=0pt}\fi}
%
\setlength\parskip{0pt plus 0.1pt}
\setlength\parindent{1em}
\setlength\topsep{8pt plus 2pt minus 4pt}
\setlength\partopsep{0pt plus 2pt}
\setlength\itemsep{0pt plus 1pt}
\def\@seccntformat#1{\csname the#1\endcsname.\quad}
\def\section{%
  \@startsection
    {section}{1}{\z@}{-14\p@ \@plus -2\p@ \@minus -2\p@}%
    {6\p@ plus 2\p@}{\normalfont\normalsize\bfseries\MakeUppercase}}
\def\subsection{%
  \@startsection
    {subsection}{2}{\z@}{-14\p@ \@plus -2\p@ \@minus -2\p@}%
    {6\p@ plus 2\p@}{\normalfont\normalsize\bfseries}}
\def\subsubsection{%
  \@startsection
    {subsubsection}{3}{\z@}{-14\p@ \@plus -2\p@ \@minus-2\p@}%
    {1sp}{\normalfont\normalsize\itshape}}
\def\paragraph{%
  \@startsection
    {paragraph}{4}{\z@}{12\p@}%
    {-1em}{\normalfont\normalsize\itshape}}
\def\subparagraph{%
  \@startsection
    {paragraph}{5}{\z@}{12\p@}%
    {-1em}{\normalfont\normalsize\itshape}}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\def\fps@eqnfloat{!tp}
\def\ftype@eqnfloat{4}
\newenvironment{eqnfloat}
               {\@float{eqnfloat}}
               {\end@float}
\newenvironment{eqnfloat*}
               {\@dblfloat{eqnfloat}}
               {\end@dblfloat}
\renewenvironment{table}
               {\@float{table}\small\ignorespaces}
               {\end@float}
\renewenvironment{table*}
               {\@dblfloat{table}\small\ignorespaces}
               {\end@dblfloat}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{\bfseries\small#1.} \small#2}%
  \ifdim \wd\@tempboxa >\hsize
    {\bfseries\small#1.} \small#2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
\def\fnum@figure{\MakeUppercase\figurename~\thefigure}
\def\fnum@table{\MakeUppercase\tablename~\thetable}

\RequirePackage{amsthm}
\newtheoremstyle{theor}
    {6pt}% above space (default)
    {6pt}% below space
    {\itshape}% body
    {1em}% indent
    {\scshape}% head
    {.}% punct
    { }% space
    {}% custom
\theoremstyle{theor}

\newtheorem{definition}{Definition}[section]
\def\thedefinition{\thesection.\arabic{definition}}
\newtheorem{lemma}{Lemma}[section]
\def\thelemma{\thesection.\arabic{lemma}}
\newtheorem{proposition}{Proposition}[section]
\def\theproposition{\thesection.\arabic{proposition}}
\newtheorem{corollary}{Corollary}[section]
\def\thecorollary{\thesection.\arabic{corollary}}
\newtheorem{axiom}{Axiom}[section]
\def\theaxiom{\thesection.\arabic{axiom}}

\newtheoremstyle{remark}
    {6pt}% above space (default)
    {6pt}% below space
    {\normalfont}% body
    {1em}% indent
    {\scshape}% head
    {.}% punct
    { }% space
    {}% custom
\theoremstyle{remark}

\newtheorem{remark}{Remark}
\newtheorem{example}{Example}
\newtheorem{algorithm}{Algorithm}

{\theoremstyle{theor}
\newtheorem{theorem}{Theorem}[section]
\def\thetheorem{\thesection.\arabic{theorem}}
}

\setlength\voffset{-1in}
\setlength\hoffset{-1in}
\setlength\paperheight{276mm}
\setlength\paperwidth{210mm}
\setlength\headsep{4mm}
\setlength\topskip\baselineskip
\setlength\marginparsep{1mm}
\setlength\marginparwidth{5mm}
\setlength\headheight{26mm}
\setlength\topmargin{0mm}
\setlength{\footskip}{10mm}
\setlength\@tempdima{276mm}
\addtolength\@tempdima{-\headheight}
\addtolength\@tempdima{-\headsep}
  \divide\@tempdima\baselineskip
  \@tempcnta=\@tempdima
  \setlength\textheight{\@tempcnta\baselineskip}
\setlength\columnsep{2pc}
\setlength\textwidth{42pc}
\setlength\oddsidemargin\paperwidth
\addtolength\oddsidemargin{-\textwidth}
\setlength\oddsidemargin{.5\oddsidemargin}
\setlength\evensidemargin\oddsidemargin
\CJ@fonts

\providecommand{\textsuperscript}[1]{%
  \ensuremath{{}^{\mbox{\normalfont\scriptsize#1}}}}
\providecommand{\@textsuperscript}[1]{%
  \ensuremath{{}^{\mbox{\normalfont\scriptsize#1}}}}
\providecommand\MakeUppercase[1]{%
  \protected@edef\@tempa{\uppercase{#1}}\@tempa}
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
          \interlinepenalty \@M #5\@@par}%
    \endgroup
  \else
    \def\@svsechd{#4{\hskip #1\relax #5}}%
  \fi
  \@xsect{#3}}
\def\journalname{}
\def\copyrightname{Oxford University Press}
\def\andname{and}
\def\ppname{}
\def\numbername{}
\def\volumename{}

%extra macros

% Inserts space after macro unless followed by punctuation.
\def\@xspace{%
  \ifx\@let@token\bgroup\else%
  \ifx\@let@token\egroup\else%
  \ifx\@let@token\/\else%
  \ifx\@let@token\ \else%
  \ifx\@let@token~\else%
  \ifx\@let@token.\else%
  \ifx\@let@token!\else%
  \ifx\@let@token,\else%
  \ifx\@let@token:\else%
  \ifx\@let@token;\else%
  \ifx\@let@token?\else%
  \ifx\@let@token'\else%
  \ifx\@let@token)\else%
  \ifx\@let@token-\else%
  \ifx\@let@token$\else%
  \ifx\@let@token/\else%
   \space%
   \fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi}
\newcommand{\xspace}{\futurelet\@let@token\@xspace}

% Omit extra full stop after et al. if at end of sentence
\def\@etstop{%
  \ifx\@let@token.%
   \else.%
  \fi\xspace}
\def\etstop{\futurelet\@let@token\@etstop}
\def\etal{{\it et al}\etstop}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\DeclareMathAlphabet\mathbit
    \encodingdefault\rmdefault\bfdefault\itdefault
\DeclareOldFontCommand{\bi}{\normalfont\bfseries\itshape}{\mathbit}

%Appendix commands
\def\appendix{\@@par
 \@addtoreset{table}{section}        
 \@addtoreset{figure}{section} 
 \@addtoreset{equation}{section} 
 \setcounter{section}{0}
 \setcounter{subsection}{0}
 \setcounter{subsubsection}{0}
 \setcounter{equation}{0}
 \setcounter{figure}{0}
 \setcounter{table}{0}
 \def\thesection{Appendix~\Alph{section}}   
\def\thelemma{\Alph{section}.\arabic{lemma}}
\def\thedefinition{\Alph{section}.\arabic{definition}}
\def\thetheorem{\Alph{section}.\arabic{theorem}}
\def\theproposition{\Alph{section}.\arabic{proposition}}
\def\thecorollary{\Alph{section}.\arabic{corollary}}
\def\theaxiom{\Alph{section}.\arabic{axiom}}
 \def\theequation{%
      \Alph{section}.\arabic{equation}}  
 \def\thetable{%              
      \Alph{section}.\arabic{table}}
 \def\thefigure{%
      \Alph{section}.\arabic{figure}}
}

\newcommand{\centre}[2]{\multispan{#1}{\hfill #2\hfill}}
\newcommand{\crule}[1]{\multispan{#1}{\hrulefill}}

\def\lo#1{\llap{${}#1{}$}}

\def\tabnote#1{\par\rlap{\begin{minipage}[l]{\hsize}
\small#1
\end{minipage}}\\}

\def\lineup{\def\0{\hbox{\phantom{\small\rm 0}}}%
    \def\m{\hbox{$\phantom{-}$}}%
    \def\-{\llap{$-$}}}

\newcommand{\ms}{\noalign{\vspace{3\p@ plus2\p@ minus1\p@}}}
\newcommand{\ns}{\noalign{\vspace{-3\p@ plus-1\p@ minus-1\p@}}}

%%%%%%%%%%%%%%%%%%%%%
% Tables rules      %
%%%%%%%%%%%%%%%%%%%%%

\newcommand{\boldarrayrulewidth}{1\p@} 
% Width of bold rule in tabular environment.

\def\bhline{\noalign{\ifnum0=`}\fi\hrule \@height  
\boldarrayrulewidth \futurelet \@tempa\@xhline}

\def\@xhline{\ifx\@tempa\hline\vskip \doublerulesep\fi
      \ifnum0=`{\fi}}

%
% Rules for tables with extra space around
%
\newcommand{\br}{\ms\bhline\ms}
\newcommand{\mr}{\ms\hline\ms}

\newcommand{\case}[2]{{\textstyle\frac{#1}{#2}}}

\newcommand{\ack}{\section*{Acknowledgements}}
\newcommand{\ackn}{\section*{Acknowledgement}}

% need to be explicit with `References' for \uppercase'ing
\def\thebibliography#1{\section*{References}\small\list
 {[\arabic{enumi}]}{\labelsep 0.5em%
\hyphenpenalty=50\itemsep=-1pt
 \settowidth\labelwidth{[#1]}\leftmargin\labelwidth
 \advance\leftmargin\labelsep
 \usecounter{enumi}}
 \def\newblock{\hskip .14em plus .38em minus -.1em}
 \sloppy
 \sfcode`\.=1000\relax}
\let\endthebibliography=\endlist

\def\@cite#1#2{[{#1\if@tempswa , #2\fi}]}
\def\@biblabel#1{[#1]}

\let\origthebibliography\thebibliography
\def\thebibliography#1{\origthebibliography{\hbox to 1em{\hss}}}

\hyphenpenalty=20
\renewcommand{\floatpagefraction}{0.95}
\renewcommand{\dblfloatpagefraction}{0.95}
\renewcommand{\topfraction}{0.95}
\renewcommand{\dbltopfraction}{0.95}
%\renewcommand{\topnumber}{3}
%\renewcommand{\dbltopnumber}{3}

\endinput
%% End of file `cj.cls'.