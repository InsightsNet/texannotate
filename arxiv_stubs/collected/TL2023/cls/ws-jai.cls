%% Job Name  : ws-jai.cls
%% Trim Size : 11in x 8.5in
%% Text Area : 9.6in (include Runningheads) x 7in
%% Created   : 26 April 2012
%% Support   : Yolande Koh, <ykoh@wspc.com.sg>                         
%%             D. Rajesh Babu, <rajesh@wspc.com.sg>            
%%             World Scientific Publishing Co.
%%
%% The content, structure, format and layout of this style file
%% is the property of World Scientific Publishing Co. Pte. Ltd.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ws-jai}[1994/07/13 v1.2u Standard LaTeX document class]
\@twosidetrue\@mparswitchtrue\@twocolumnfalse
\newif\if@openright
\@openrighttrue
\newif\if@restonecol
%
\newif\if@wsdraft
%
\newdimen\wsdraftrule
\wsdraftrule=0pt
\AtEndDocument{\label{eof}}
\def\thebepage{\thepage}
\def\theeepage{\pageref{eof}}
%
\DeclareOption{splissue}{\@splissuetrue}
\DeclareOption{wsdraft}{\@wsdrafttrue\setlength\overfullrule{5pt}\wsdraftrule0.01pt}%
%
\DeclareOption{final}{\setlength\overfullrule{0pt}}
%
\ExecuteOptions{a4paper,11pt,twoside,twocolumn,final}
\ProcessOptions
%
\def\appendixname{Appendix~}
\newcommand\abstractname{Abstract}
\newcommand\bibname{References}
%
\newcommand\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
    \space\number\day, \number\year}
\newcount\minute
\newcount\hour
\def\currenttime{%
    \minute\time
    \hour\minute
    \divide\hour60
    \the\hour:\multiply\hour60\advance\minute-\hour\the\minute}
%
\newdimen\trimheight
\newdimen\trimwidth
\newdimen\typeheight
\newdimen\typewidth
\newdimen\tempdimen
\newdimen\tablewidth
\newdimen\normaltextheight
\newdimen\realtextheight
\newbox\tempbox
\newdimen\tablewd
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\NINE{\fontsize{9}{11}\selectfont}
\def\TEN{\fontsize{10}{12}\selectfont}
\def\ELEVEN{\fontsize{11}{13}\selectfont}
\def\EIGHT{\fontsize{8}{10}\selectfont}
\def\TWELVE{\fontsize{12}{14}\selectfont}
\def\foliofont{\fontsize{9}{11}\selectfont}
\def\bibfont{\fontsize{10}{12}\selectfont}
\def\rhfont{\NINE\itshape{}}
\def\catchlinefont{\footnotesize}
\def\abstractfont{\fontsize{8}{10}\selectfont}
\font\tifont=cmbx10 at 11pt
\def\timath{\fontsize{12}{14}\selectfont}
\def\titlefont{\baselineskip14pt\bfseries\boldmath\centering{}\tifont}
\def\authorfont{\NINE}
\def\affiliationfont{\NINE\itshape}
\def\datefont{\footnotesize}
\def\sectionfont{\fontsize{11}{13}\bfseries\boldmath\rightskip2pc plus1fill{}}
\def\subsectionfont{\fontsize{11}{13}\bfseries\boldmath\itshape\rightskip2pc plus1fill{}}
\def\subsubsectionfont{\fontsize{11}{13}\itshape\rightskip2pc plus1fill{}}
\def\paragraphfont{\fontsize{11}{13}\selectfont}
\def\subparagraphfont{\itshape}
\def\appendixfont{\fontsize{11}{13}}
\let\figurefont\NINE
\let\figurecaptionfont\NINE
\let\tablefont\NINE
\let\tablecaptionfont\NINE
\let\captionfont\NINE
\def\foot{\small}%\fontsize{9}{11}\selectfont}
%
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xipt{13}%\@xiiipt
   \abovedisplayskip6\p@\@plus4\p@\@minus2\p@
   \abovedisplayshortskip\abovedisplayskip
   \belowdisplayshortskip\abovedisplayshortskip
   \belowdisplayskip\abovedisplayskip
   \let\@listi\@listI}
%\normalsize
%
\newcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 8\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip}
%
\newcommand\footnotesize{%
   \@setfontsize\footnotesize\@ixpt{11}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip}

\newcommand\theoremsize{%
   \@setfontsize\theoremsize\@xpt{12}%\@xiiipt
   \abovedisplayskip 4pt plus 4pt minus 2pt
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI\baselineskip13pt plus 0.33pt minus 0.25pt\relax}
%
\newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}%
\newcommand\Large{\@setfontsize\Large\@xivpt{16}}%%
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\newcommand\huge{\@setfontsize\huge\@xxpt{25}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
\setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
\setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}
%
\DeclareOldFontCommand{\rm}{\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\scshape}{\@nomath\sc}
\DeclareOldFontCommand{\bi}{\bfseries\itshape}{\bfseries\itshape}
\renewcommand{\rmdefault}{cmr}%
%
\DeclareMathSizes{28}{28}{25}{20}
\DeclareMathSizes{24}{24}{21}{18}
\DeclareMathSizes{22}{22}{19}{17}
\DeclareMathSizes{20}{20}{17}{15}
\DeclareMathSizes{18}{18}{15}{10}
\DeclareMathSizes{12}{11}{8}{5}
\DeclareMathSizes{11}{11}{8}{5}
\DeclareMathSizes{10}{10}{7}{5}
\DeclareMathSizes{9.5}{9}{7}{5}
\DeclareMathSizes{9}{9}{7}{5}
\DeclareMathSizes{8}{8}{6}{5}
\DeclareMathSizes{7}{7}{5}{5}
\DeclareMathSizes{6}{6}{5}{5}
\DeclareMathSizes{5}{5}{5}{5}
\def\bm#1{\mathchoice
    {\mbox{\boldmath$#1$}}%
          {\mbox{\boldmath$#1$}}%
          {\mbox{\boldmath$\scriptstyle#1$}}%
          {\mbox{\boldmath$\scriptscriptstyle#1$}}}%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Initializations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\trimheight11truein
\trimwidth8.5truein
\typeheight9.4truein
\typewidth7truein
\setlength\realtextheight{9.28truein}
%
\setlength\parindent{20\p@}
\setlength\headheight{5\p@}
\setlength\headsep{19pt}%15
\setlength\topskip{7\p@}%{10\p@}
\setlength\footskip{10pt}%18pt
\setlength\maxdepth{4\p@}
\setlength\@maxdepth\maxdepth
\setlength\textwidth{7truein}
\setlength\textheight\typeheight
\advance\textheight-\headheight
\advance\textheight-\headsep
\setlength\normaltextheight{\textheight}
\setlength\oddsidemargin{21mm}%.625in%
\setlength\evensidemargin{\trimwidth}
\addtolength\evensidemargin{-\textwidth}
\addtolength\evensidemargin{-\oddsidemargin}
\setlength\marginparwidth{.75in}
\setlength\marginparsep{7\p@}
\setlength\marginparpush{5\p@}
%\setlength\topmargin{.85926in}%
\setlength\topmargin{.59926in}%
\setlength\footnotesep{6\p@}%6pt
\setlength{\skip\footins}{18\p@ \@plus 5\p@ \@minus 2\p@}
\setlength\floatsep{18\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{18\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep{18\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dblfloatsep{18\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{18\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{0\p@}
%
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}%
\renewcommand\baselinestretch{}%{}
\setlength\parskip{0\p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\title#1{
\gdef\@title{\def\@makefnmark{\rlap{\ifnum\c@footnote=1{\raise5pt\hbox{\rm{\thefootnote}\,}}\else
           \@textsuperscript{{\foot\@thefnmark}}\fi}}\vspace*{-10.3pt}{#1}}}
\def\subtitle#1{{\titlefont:~#1}}
\newcommand\maketitle{\par
  \begingroup
%   \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \renewcommand\thefootnote{\arabic{footnote}}
   \def\@makefnmark{\rlap{\ifnum\c@footnote=1{\raise5pt\hbox{\rm{\thefootnote}\,}}\else
           \@textsuperscript{{\foot\@thefnmark}}\fi}}%
    \long\def\@makefntext##1{\noindent
%   \@textsuperscript{\normalfont\@thefnmark}{\lowercase{##1}}}%
    \@textsuperscript{\normalfont\@thefnmark}{##1}}%
      %\newpage
      \global\@topnum\z@
      \@maketitle
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\@subtitle\@empty
  \global\let\subtitle\relax
  \global\let\author\relax
}
\def\@maketitle{%
  \newpage
  \null
  \vspace*{-10pt}
   \vspace*{-25pt}% to have the bylines on the beginning of the page
  \@clinebuf
  \vspace*{70pt}
  \begin{center}%
  \let\footnote \thanks
  {\titlefont\@title \par}
  \vspace*{12pt}
    \ifx\@subtitle\undefined
    \else{\EIGHT\@subtitle}\fi
  \vspace*{14pt}
  \@aabuffer\par
  \end{center}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End Title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Local Definitions %%%%%%%%%%%%%%%%%%%%%%
%
%\def\u#1{\uppercase{#1}}
\def\uc#1{\uppercase{#1}}
\newcommand{\cal}{\protect\pcal}
\newcommand{\pcal}{\@fontswitch{\relax}{\mathcal}}
%
\def\mtb{\fboxsep=0pt\fbox{\phantom{e}}}
\def\breakhere{\par\vskip-\lastskip
            \pagebreak}
\def\forcebreak{\vadjust{\pagebreak}}
%
\def\thebepage{\thepage}
\def\theeepage{\pageref{eof}}
\def\pub#1#2{\par%
    \addvspace{-2pt plus-2pt minus-2pt}
    {\centering{
    \authorfont #1\par
    #2\par}\par}
    \addvspace{15pt plus2pt minus2pt}}%
%
\def\@clinebuf{}

\newcount\clcount
\def\@clinebuf{}
\def\catchline#1#2#3#4#5{
%    \clcount=#3
\expandafter\def\expandafter\@clinebuf\expandafter
    {\@clinebuf\catchlinefont
    \noindent Journal of Astronomical Instrumentation\par
    \noindent \copyright\ World Scientific Publishing Company\par
        \noindent\vskip-\baselineskip \hphantom{#4 \hskip2em #5}\par
%        \noindent \doi\\[-20pt]
    }\relax\par
    }%

\def\No{No.}
%
%\def\and{\hbox{\lowercase{ and }}}
\def\and{\hbox{\lowercase{and }}}
\def\aand{\\[10pt]{\upshape{and}}\\[-3pt]}
\def\@aabuffer{}
\def\author#1{\expandafter\def\expandafter\@aabuffer\expandafter
{\@aabuffer{\vskip-3.5pt\par{\authorfont#1}}\relax\par}}
\def\address#1{\expandafter\def\expandafter\@aabuffer\expandafter
    {\@aabuffer{\par{\affiliationfont#1\par}}\relax\par\vskip12pt}}
%
\newenvironment{abstract}{\par%
\vskip9pt\par
 \leftskip.625in\rightskip\leftskip
   \abstractfont
   \begingroup\baselineskip12pt
    \parindent0pt\ignorespaces\par}
{\endgroup\par\vspace*{35pt}}
%
\def\keywords#1{\par%
   \vspace*{-32pt}
   \begingroup
    \begin{center}\begin{minipage}[t]{5.75in}\abstractfont{\it Keywords}\/:\ #1\end{minipage}\end{center}
    \endgroup\par\vskip12pt}
%
\newenvironment{dedication}{%
\vspace*{-2.6pt}
\par
   \leftskip.625in\rightskip\leftskip
\begin{center}
   \begingroup
    \EIGHT
    \parindent0pt\ignorespaces\par}
{\endgroup\end{center}\par\vskip9pt}
%
\newenvironment{history}{%
\vspace*{-6.6pt}
\par
   \leftskip.625in\rightskip\leftskip
\begin{center}
   \begingroup
    \EIGHT
    \parindent0pt\ignorespaces\par}
{\endgroup\end{center}\par}
%
\def\email#1{\it #1\par}
\def\received#1{Received #1}
\def\revised#1{Revised #1}
\def\accepted#1{Accepted #1}
%
%%%%%%%%%% LIST OF FIGURES & TABLES AND TABLE OF CONTENTS %%%%%%%%%%
%
\def\@pnumwidth{2em}
\def\@tocrmarg{2.55em}
\def\@dotsep{6}
\setcounter{tocdepth}{3}
%
\def\tableofcontents{{\ELEVEN\@starttoc{toc}}\vspace*{20pt}}
\def\numberline#1{#1.\hspace*{8.5pt}}
\def\l@section{\@dottedtocline{1}{0em}{1.5em}}
\def\l@subsection{\@dottedtocline{2}{1.5em}{2.27em}}
\def\l@subsubsection{\@dottedtocline{3}{3.7em}{3.05em}}
\def\l@paragraph{\@dottedtocline{4}{6.5em}{5.5em}}
\def\l@subparagraph{\@dottedtocline{5}{6.5em}{6.5em}}
\def\listoffigures{\section*{List of Figures}\@starttoc{lof}}
\def\l@figure{\@dottedtocline{1}{0em}{2.75em}}
\def\listoftables{\section*{List of Tables}\@starttoc{lot}}
\let\l@table\l@figure
\def\l@appendix#1#2{\addpenalty{\@secpenalty}\addvspace{1.0em plus 1pt}%
    \@tempdima 2.75em \begingroup \parindent \z@ \rightskip \@pnumwidth%
    \parfillskip-\@pnumwidth {\leavevmode #1}\leaderfill\hbox to\@pnumwidth{\hss #2}\par%
    \endgroup}
\def\l@appendix{\@dottedtocline{1}{0em}{6.1em}}
\def\l@subappendix{\@dottedtocline{2}{6.1em}{6.86em}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End TOC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\category#1#2{\par
    \vspace*{8pt}
    {\authorfont{\leftskip18pt\rightskip\leftskip
    \noindent{\it Categories}\/:\ #1:\ #2\par}}\par}
%
\newcount\@tempcntc
\def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
 \@tempcnta\z@\@tempcntb\m@ne\def\@citea{}\@cite{\@for\@citeb:=#2\do
  {\@ifundefined
   {b@\@citeb}{\@citeo\@tempcntb\m@ne\@citea\def\@citea{,}%
     {\mbox{\bfseries ?}}\@warning
   {Citation `\@citeb' on page \thepage \space undefined}}%
  {\setbox\z@\hbox{\global\@tempcntc0\csname b@\@citeb\endcsname\relax}%
   \ifnum\@tempcntc=\z@ \@citeo\@tempcntb\m@ne
    \@citea\def\@citea{;\ }\hbox{\csname b@\@citeb\endcsname}%
   \else
    \advance\@tempcntb\@ne
    \ifnum\@tempcntb=\@tempcntc
    \else\advance\@tempcntb\m@ne\@citeo
    \@tempcnta\@tempcntc\@tempcntb\@tempcntc\fi\fi}}\@citeo}{#1}}
\def\@citeo{\ifnum\@tempcnta>\@tempcntb\else\@citea\def\@citea{;\ }%
 \ifnum\@tempcnta=\@tempcntb\the\@tempcnta\else
  {\advance\@tempcnta\@ne\ifnum\@tempcnta=\@tempcntb \else \def\@citea{--}\fi
   \advance\@tempcnta\m@ne\the\@tempcnta\@citea\the\@tempcntb}\fi\fi}
 \def\@refcite#1#2{{#1\if@tempswa\typeout
        {WSPC warning: optional citation argument
    ignored: `#2'} \fi}}
 \def\refcite{\@ifnextchar[{\@tempswatrue
    \@refcitex}{\@tempswafalse\@refcitex[]}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Lists %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\@listI{\leftmargin\leftmargini
            \listparindent\itemindent
            \parsep \z@\labelsep.5em
            \topsep 6.5\p@ \@plus3\p@% \@minus2\p@
            \itemsep0\p@}
%
\let\@listi\@listI
\@listi
%
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    3.5\p@ \@plus2\p@ \@minus\p@
              \parsep    \z@
              \itemsep\z@}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep 3.5\p@ \@plus\p@\@minus\p@
              \parsep \z@
             % \partopsep \p@ \@plus\z@ \@minus\p@
              \itemsep0\p@}%
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}
%
\setlength\leftmargini{3em}
\setlength\leftmarginii{2.2em}
\setlength\leftmarginiii{1.87em}
\setlength\leftmarginiv{1.7em}
\setlength\leftmarginv{1em}
\setlength\leftmarginvi{1em}
\setlength\leftmargin{\leftmargini}
\setlength\listparindent{\parindent}
\setlength\labelsep{.5em}
\setlength\labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\renewcommand\theenumi{\arabic{enumi}}
\renewcommand\theenumii{\alph{enumii}}
\renewcommand\theenumiii{\roman{enumiii}}
\renewcommand\theenumiv{\Alph{enumiv}}
\newcommand\labelenumi{(\theenumi)}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{$\m@th\bullet$}
\newcommand\labelitemii{\normalfont\bfseries --}
\newcommand\labelitemiii{$\m@th\ast$}
\newcommand\labelitemiv{$\m@th\cdot$}
%
\newskip\topsepm@th
\newif\if@wslist
\newif\if@margspec
\if@wslist
  \def\wsitemargs{%
   \topsep        \z@ \@plus 1pt
   \partopsep     \z@ \@plus 1pt
   \itemsep       \z@ \@plus \z@
   \parsep        \z@ \@plus 1pt
   \if@margspec \else \leftmargini   \z@ \fi
   \if@margspec \else \leftmarginii  1em \fi
   \if@margspec \else \leftmarginiii 1em \fi
   \if@margspec \else \leftmarginiv  1em \fi
   \if@margspec
     \leftmargin\csname leftmargin\romannumeral\@itemdepth\endcsname
     \labelwidth\leftmargin
     \advance\labelwidth-\labelsep
   \fi
   \rightmargin   \z@
   \listparindent \z@
   \itemindent    \z@
  }
  \def\wsenumargs{%
   \topsep        \z@ \@plus 1pt
   \partopsep     \z@ \@plus 1pt
   \itemsep       \z@ \@plus \z@
   \parsep        \z@ \@plus 1pt
   \if@margspec \else \leftmargini   1em \fi
   \if@margspec \else \leftmarginii  1em \fi
   \if@margspec \else \leftmarginiii 1em \fi
   \if@margspec \else \leftmarginiv  1em \fi
   \if@margspec
     \leftmargin\csname leftmargin\romannumeral\@enumdepth\endcsname
     \labelwidth\leftmargin
     \advance\labelwidth-\labelsep
   \fi
   \rightmargin   \z@
   \listparindent \z@
   \itemindent    \z@
  }
  \renewcommand{\@mklab}[1]{#1}
\else
    \def\wsenumargs{}
    \def\wsitemargs{}
\fi
\def\@@enum@label#1{\hss\llap{#1}}
\def\@@item@label#1{\hss#1\hfil}
\def\enumerate{\@ifnextchar[%
    {\ws@enumerate}%
    {\if@margspec \ws@enumerate[] \else \ws@enumerate[\csname label\@enumctr\endcsname] \fi }}
\def\ws@enumerate[#1]{%
     \ifnum \@enumdepth >3 \@toodeep\else
       \advance\@enumdepth \@ne
       \edef\@enumctr{enum\romannumeral\the\@enumdepth}
       \list{\csname label\@enumctr\endcsname}{%
         \topsepm@th\topsep
         \wsenumargs
         \usecounter{\@enumctr}
         \settowidth\labelwidth{#1}
         \setlength{\@tempdima}{\labelwidth}
         \addtolength{\@tempdima}{\labelsep}
         \if@margspec
           \ifdim \@tempdima > \leftmargin
             \setlength{\leftmargin}{\@tempdima}
           \fi
         \else
             \setlength{\leftmargin}{\@tempdima}
         \fi
         \let\makelabel\@@enum@label}
     \fi
   }
  \let\endenumerate\endlist
%
\let\Item\item
\newenvironment{enumeroman}{%
  \def\theenumi{\roman{enumi}}\def\theenumii{\alph{enumii}}%
  \def\labelenumi{(\theenumi)}\def\labelenumii{(\theenumii)}%
        \let\item\Item
  \begin{enumerate}%
}{%
  \end{enumerate}}
%
\newenvironment{alphlist}{%
  \def\theenumi{\alph{enumi}}\def\theenumii{\alph{enumii}}%
  \def\labelenumi{{\upshape (\theenumi)}}\def\labelenumii{{\upshape (\theenumii)}}%
  \let\item\Item
  \begin{enumerate}%
}{%
  \end{enumerate}}
%
\newenvironment{arabiclist}{%
  \def\theenumi{\arabic{enumi}}\def\theenumii{\alph{enumii}}
  \def\labelenumi{{\upshape (\theenumi)}}\def\labelenumii{{\upshape (\theenumii)}}%
  \let\item\Item
  \begin{enumerate}
}{%
  \end{enumerate}}
%
\newenvironment{romanlist}{%
  \def\theenumi{\roman{enumi}}\def\theenumii{\alph{enumii}}
  \def\labelenumi{{\upshape (\theenumi)}}\def\labelenumii{{\upshape (\theenumii)}}%
  \let\item\Item
  \begin{enumerate}
}{%
  \end{enumerate}}
%
\newenvironment{itemlist}{%
    \def\labelenumi{\labelitemi}
    \let\item\Item
    \begin{enumerate}
    }{%
    \end{enumerate}}
%
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
%
\newenvironment{unnumlist}{%
    \let\item\Item
    \leftmargini2pc
    \ifnum \@enumdepth >3 \@toodeep\else
        \advance\@enumdepth \@ne
        \list{}{\itemindent-2pc\topsep6pt
              \def\makelabel##1{\hss\llap{##1}}}%
   \fi
}{%
  \endlist}
%
\newenvironment{quote}
               {\list{}{\rightmargin18pt\leftmargin18pt}%
                \item[]}
               {\endlist}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sections %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\setcounter{secnumdepth}{4}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thesection      {\arabic{section}}
\renewcommand\thesubsection   {\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection{\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph    {\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph {\theparagraph.\arabic{subparagraph}}
%
\newcommand\section{\@startsection{section}{1}{\z@}{-18pt \@plus-3pt minus-6pt}{5pt}{\sectionfont}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}{-18pt \@plus-3pt minus-6pt}{5pt}{\subsectionfont}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}{-18pt \@plus-3pt minus-3pt}{5pt}{\subsubsectionfont}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}{-12pt \@plus-3pt minus-3pt}{5pt}{\paragraphfont}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}{3.25ex \@plus1ex}{-1em}{\subparagraphfont}}

\newcommand{\nonumsection}[1]{\par\addvspace{24pt plus2pt minus2pt}
    \noindent{\sectionfont #1}\par
    \vspace*{8pt}}
\newcommand{\nonumsubsection}[1]{\par\addvspace{18pt plus2pt minus2pt}
    \noindent{\subsectionfont #1}\par
    \vspace*{8pt}}
%
\def\@seccntformat#1{{\upshape{\csname the#1\endcsname.}}\hskip10pt}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Floats %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\setcounter{topnumber}{3}
\def\topfraction{.98}
\setcounter{bottomnumber}{3}
\def\bottomfraction{.98}
\setcounter{totalnumber}{6}%4
\def\textfraction{.01}
\def\floatpagefraction{.98100}
\setcounter{dbltopnumber}{2}
\def\dbltopfraction{.981}
\def\dblfloatpagefraction{.99}
%
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{6\p@}% plus3pt minus3pt}
\setlength\belowcaptionskip{-1\p@}
%
\def\FigName{figure}%
%
\newbox\wscaptionbox
%
\long\def\@makecaption#1#2{%
    \vskip\abovecaptionskip
    \setbox\wscaptionbox\hbox{%
    {\figurecaptionfont#1.\unskip\ignorespaces\hskip1em#2\par}}
    \ifdim\wd\wscaptionbox>\hsize
    {\figurecaptionfont#1.\unskip\ignorespaces\hskip1em#2\par}\par
    \else
    \centerline{\figurecaptionfont#1.\unskip\ignorespaces\hskip1em#2}\par
    \fi
}
%\long\def\@makecaption#1#2{\captionfont\vskip 2ex\noindent#1.\ #2\par}%
%
\def\figurename{Fig.}
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure\rm}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
%
\newenvironment{figurehere}
  {\parskip0pt\topskip 13pt plus 2pt minus 1pt\def\@captype{figure}}
  {\vskip 13pt plus 2pt minus 1pt}
%
\def\@wsrfiguref{\begin{sidewaysfigure}\begin{center}}
\def\@wsrfigure[#1]{\begin{sidewaysfigure}\begin{center}}
\newenvironment{rotatefigure}{\@ifnextchar[{\@wsrfigure}{\@wsrfiguref}}
{\end{center}\end{sidewaysfigure}} 
%
\newcounter{table}
\def\tablename{Table}
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
%
\def\@wstablef{\begin{table}\begin{center}\tablefont\begin{threeparttable}}
\def\@wstable[#1]{\begin{table}[#1]\begin{center}\tablefont\begin{threeparttable}}
\newenvironment{wstable}{\@ifnextchar[{\@wstable}{\@wstablef}}
{\end{threeparttable}\end{center}\end{table}}
\def\@wsstablef{\begin{table*}\begin{center}\tablefont\begin{threeparttable}}
\def\@wsstable[#1]{\begin{table*}[#1]\begin{center}\tablefont\begin{threeparttable}}
\newenvironment{spantable}{\@ifnextchar[{\@wsstable}{\@wsstablef}}
{\end{threeparttable}\end{center}\end{table*}}
\def\@wsrtablef{\begin{sidewaystable}\begin{center}\tablefont\begin{threeparttable}}
\def\@wsrtable[#1]{\begin{sidewaystable}\begin{center}\tablefont\begin{threeparttable}}
\newenvironment{rotatetable}{\@ifnextchar[{\@wsrtable}{\@wsrtablef}}
{\end{threeparttable}\end{center}\end{sidewaystable}}
%
\long\def\tbl#1#2{%
    \parindent\z@\ignorespaces\noindent
    {\NINE
    \caption{#1}%
    \par\setbox\tempbox\hbox{{#2}}%
    \tablewd\hsize\advance\tablewd-\wd\tempbox\global\divide\tablewd\tw@
    \ifdim\wd\wscaptionbox<\wd\tempbox\centerline{\unhbox\wscaptionbox}
    \else\leftskip\tablewd\rightskip\leftskip{\unhbox\wscaptionbox}\par
    \fi\vskip5pt\centerline{\box\tempbox}}
}%
\long\def\ttbl#1#2#3{%
    \parindent\z@
    \noindent
    \tablecaptionfont
    \caption{#2}%
    \tablewd\hsize
    \advance\tablewd-#1
    \global\divide\tablewd\tw@
    \ifdim \wd\wscaptionbox<#1
    \centerline{\unhbox\wscaptionbox}
    \else
    {\leftskip\tablewd% plus1fill{}
    \rightskip\tablewd% plus1fill{}
    \unhbox\wscaptionbox\par}
    \fi
    \vskip-8pt
    \centerline{#3}
}
%
\newenvironment{InTextTable}{%
    \par\addvspace{16pt plus6pt minus6pt}%
    \begin{center}
    \tablecaptionfont\noindent\ignorespaces
}{\end{center}\par\addvspace{17pt plus6pt minus6pt}}
%
\newenvironment{tablenotes}{%
    \par\vskip5pt\footnotesize%
    \@ifnextchar[{\@tabnote}{\@tabnote[Note]}}{%
    \par\vskip-5pt}
\def\@tabnote[#1]{%
    \leftskip\tablewd\rightskip\leftskip {\it #1}\/:\ \ignorespaces}
%
\def\Hline{%
  \noalign{\ifnum0=`}\fi\hrule \@height 2\arrayrulewidth \futurelet
   \@tempa\@xhline}
%
\def\tline{%
  \noalign{\ifnum0=`}\fi\hrule \@height .25\arrayrulewidth \futurelet
   \@tempa\@xhline}
%
\newenvironment{tablehere}
  {\parskip0pt\topskip 13pt plus 2pt minus 1pt\def\@captype{table}\begin{small}\begin{center}}
  {\end{center}\end{small}\vskip 13pt plus 2pt minus 1pt}
%
\def\x{@{\extracolsep{\fill}}}
\def\toprule{\Hline\\[-6.5pt]}
\def\colrule{\\[-7pt]\hline\\[-6pt]}
\def\TMcolrule{\\[-9.5pt]\hline\\[-9.5pt]}
\def\botrule{\\[-7pt]\Hline}
\def\crule#1{\\[-7pt]#1\\[-6pt]}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Maths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\setlength\arraycolsep{1.5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand\theequation{\arabic{equation}}
%
\setlength\columnsep{0.25truein}
\setlength\columnseprule{0\p@}
%
\def\bstrut{\vrule width0pt depth5pt}
\def\tstrut{\vrule width0pt height10pt}
\jot=3pt
%
\renewcommand{\[}{\relax\ifmmode\@badmath\else\bgroup\let\eqnnum\relax\let\refstepeqcnt\relax\@equation\fi}
\renewcommand{\]}{\relax\ifmmode\end@equation\egroup\@endparenv\@doendpe\else\@badmath\fi}
%
%\@namedef{equation*}{\let\eqnnum\relax\let\refstepeqncnt\relax\@equation}
%\@namedef{endequation*}{\end@equation}
\renewenvironment{equation}{\@equation}{\end@equation}
%
\def\refstepeqcnt{\refstepcounter{equation}}
\def\eqnnum{\displaywidth\linewidth\hbox{\@eqnnum}}
%
\def\@equation{\let\topsep\abovedisplayskip\@beginparpenalty\predisplaypenalty\@endparpenalty\postdisplaypenalty
     \refstepeqcnt
     \trivlist \item[]\leavevmode
       \hbox to\linewidth\bgroup\hfill $\m@th% $
       \displaystyle}%
\def\end@equation{$\hfill\eqnnum\egroup\endtrivlist}
%
\renewenvironment{eqnarray}{%
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
      \cr}
        {%
      \@@eqncr
      \egroup
      \global\advance\c@equation\m@ne
   $$\global\@ignoretrue
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Footnote %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule depth0pt height.5pt \@width7.1cm
%  \hrule width 7.1cm
  \kern2.6\p@}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
     \@makefnmark#1}
%
\def\@fnsymbol#1{\ensuremath{\ifcase#1\or *\or \dagger\or \ddagger\or
    \mathchar "278\or \mathchar "27B\or \|\or **\or \dagger\dagger
    \or \ddagger\ddagger \else\@ctrerr\fi}}
%
\def\thefootnote{\alph{footnote}}
%\def\thefootnote{\arabic{footnote}}
\def\@makefnmark{{$^{\rm \@thefnmark}$}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Page Style %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\mark{{}{}}
%
\def\ps@plain{%
\global\textheight9.26in\relax
    \let\@mkboth\@gobbletwo
     \let\@oddhead\@empty
     \let\@evenhead\@empty
     \def\@oddfoot{\hfill\mbox{\lower20pt\hbox{\foliofont\thepage}}\hfill}%
     \let\@evenfoot\@oddfoot}

%\def\ps@plain{%
    %\global\textheight\realtextheight\relax
   %  \let\@mkboth\@gobbletwo
   %  \let\@oddhead\@empty
   %  \let\@evenhead\@empty
  %   \def\@oddfoot{\hfill\mbox{\lower20pt\hbox{\foliofont\thepage}}\hfill}%
 %    \let\@evenfoot\@oddfoot
%     }
%
\def\RightMark{}
%


\def\eh{\rhfont{\upshape{\thepage}}\hskip1em\leftmark\hfill}
\def\evhead{\eh}
\def\oh{\hfill\rhfont\rightmark\hskip1em{\upshape{\thepage}}}
\def\odhead{\oh}




\def\fol{\hfill\mbox{\lower18pt\hbox{\foliofont\thepage}}\hfill}%

\def\odfoot{\@empty}
\def\evfoot{\@empty}



\def\ps@headings{%
   %\global\textheight9.5truein\relax
    \def\@oddfoot{\odfoot}
    \def\@evenfoot{\evfoot}
    \def\@evenhead{\evhead}%
    \def\@oddhead{\odhead}%
    \let\@mkboth\markboth
    \def\authormark##1{\markboth{##1}{\RightMark}}%
    \def\chaptermark##1{\gdef\RightMark{##1}\markright{##1}}}




\def\ps@nwheadings{%
   %\global\textheight9.5truein\relax
    \let\@oddfoot\@empty
    \let\@evenfoot\@empty
    \def\@evenhead{\rhfont{\upshape{\thepage}}\hskip1em\leftmark\hfill}%
    \def\@oddhead{\hfill\rhfont\rightmark\hskip1em{\upshape{\thepage}}}%
    \let\@mkboth\markboth
    \def\authormark##1{\markboth{##1}{\RightMark}}%
    \def\chaptermark##1{\gdef\RightMark{##1}\markright{##1}}}
%
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\rlap{\foliofont \thepage}\hfill{\rhfont\leftmark}\hfill}%
    \def\@oddhead{\hfill{\rhfont\rightmark}\hfill{\foliofont\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble}
%

\def\ps@land{%
%\global
\textheight9.24in\relax
    \let\@mkboth\@gobbletwo
     \let\@oddhead\@empty
     \let\@evenhead\@empty
     \def\@oddfoot{\hfill\mbox{\lower18pt\hbox{\foliofont\thepage}}\hfill}%
     \let\@evenfoot\@oddfoot}


\def\ps@pblind{%
    \let\@mkboth\@gobbletwo
    \def\@evenhead{}%
    \def\@oddhead{}
    \def\@oddfoot{\hfill\mbox{\lower8pc\hbox{}}\hfill}
   \let\@evenfoot\@oddfoot}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% theorem environments %%%%%%%%%%%%%%%%%%%%
%
%\def\@xthm#1#2{\@begintheorem{#2}{\csname the#1\endcsname}{}\ignorespaces}
%\def\@ythm#1#2[#3]{\@begintheorem{}{\csname the#1\endcsname}{#3}\ignorespaces}
%
\let\Definitionfont\upshape%
\let\Theoremfont\itshape
\let\Corollaryfont\itshape
\let\Propositionfont\itshape
\let\Lemmafont\itshape
\let\Examplefont\upshape
\let\Stepfont\upshape
\let\Remarkfont\upshape
\def\Theoremheadfont{\TEN\bfseries}
\def\Corollaryheadfont{\TEN\bfseries}
\def\Propositionheadfont{\TEN\bfseries}
\def\Lemmaheadfont{\TEN\bfseries}
\def\Definitionheadfont{\TEN\bfseries}
\def\Exampleheadfont{\TEN\bfseries}
\def\Remarkheadfont{\TEN\itshape}
\def\Stepheadfont{\TEN\bfseries}
%
\def\@begintheorem#1#2#3{\trivlist
   \item[\hskip \labelsep{\csname#1headfont\endcsname#1\ #2.} ]~\ignorespaces{\rm #3}\csname#1font\endcsname\ignorespaces}
\def\@opargbegintheorem#1#2#3{\trivlist
      \item[\hskip \labelsep{\csname#1headfont\endcsname#1\ #2\ }][#3].~\csname#1font\endcsname\ignorespaces}
\def\@endtheorem{\endtrivlist}
%
%\def\@begintheorem#1#2#3{\trivlist
%   \item[\hskip \labelsep{\bfseries #1\ #2.} ]{\rm #3}\ \itshape}
%\def\@opargbegintheorem#1#2#3{\trivlist
%      \item[\hskip \labelsep{\bfseries #1\ #2\ }(#3).]\ \itshape}
%\def\@endtheorem{\endtrivlist}


%\def\@begintheorem#1#2#3{\par\addvspace{8pt plus3pt minus2pt}%
%              \noindent{\csname#1headfont\endcsname#1~\ignorespaces#3#2.}%
%              \csname#1font\endcsname\hskip10pt\ignorespaces}
%\def\@endtheorem{\par\addvspace{8pt plus3pt minus2pt}\@endparenv}


\newcounter{lemma}
\newcounter{corollary}
\newcounter{proposition}
\newcounter{definition}
\newcounter{example}
\newcounter{remark}
\newcounter{question}
\newcounter{notation}
%

\newtheorem{theorem}{Theorem}
\newtheorem{corollary}{Corollary}[section]
\newtheorem{lemma}{Lemma}
\newtheorem{proposition}{Proposition}
\newtheorem{definition}{Definition}[section]
\newtheorem{example}{Example}[section]
\newtheorem{remark}{Remark}[section]
\newtheorem{notation}{Notation}[section]
\newtheorem{question}{Question}[section]
%
%\newtheorem{theorem}{Theorem}
%\newtheorem{corollary}[theorem]{Corollary}%[section]
%\newtheorem{lemma}[theorem]{Lemma}
%\newtheorem{proposition}[theorem]{Proposition}
%\newtheorem{definition}[theorem]{Definition}%[section]
%\newtheorem{example}[theorem]{Example}%[section]
%\newtheorem{remark}[theorem]{Remark}%[section]
%\newtheorem{notation}[theorem]{Notation}%[section]
%\newtheorem{question}[theorem]{Question}%[section]
%
\newenvironment{stheorem}[2]{\parskip0pt\topsep=13pt plus 2pt minus 1pt
\begin{trivlist}\item[]
{\theoremsize #1}\enskip\enskip #2}
{\end{trivlist}%\vskip 6pt plus 2pt minus 1pt
}
%

\newif\iflogo
\def\prbox{\hbox to \hsize{\hfill\fboxsep0pt\fbox{\phantom{\vrule width5pt height5pt depth0pt}}}\global\logofalse}%

\newenvironment{proof}{%
\par\addvspace{12pt plus3pt minus3pt}\global\logotrue%
\noindent{\TEN\it Proof.\quad}\ignorespaces}{\quad%
%\par\iflogo\vskip-\lastskip
%\vskip-\baselineskip
$\blacksquare$\par\addvspace{12pt plus3pt minus3pt}
%\fi
}

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bibliography %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\let\@internalcite\cite
\def\cite{\def\@citeseppen{-1000}%
    \def\@cite##1##2{({##1\if@tempswa , ##2\fi})}%
    \def\citeauthoryear##1##2{##1, ##2}\@internalcite}
%
\def\shortcite{\def\@citeseppen{1000}%
    \def\@cite##1##2{({##1\if@tempswa , ##2\fi})}%
    \def\citeauthoryear##1##2{##2}\@internalcite}
%
\def\citeauthor#1{\def\@citeseppen{1000}%
    \def\@cite##1##2{{##1\if@tempswa , ##2\fi}}%
    \def\citeauthoryear##1##2{##1}\@citedata{#1}}
%
\def\citeyear#1{\def\@citeseppen{1000}%
    \def\@cite##1##2{{##1\if@tempswa , ##2\fi}}%
    \def\citeauthoryear##1##2{##2}\@citedata{#1}}
%
\def\@citedata#1{\@tempswafalse%
    \if@filesw\immediate\write\@auxout{\string\citation{#1}}\fi
  \def\@citea{}\@cite{\@for\@citeb:=#1\do
    {\@citea\def\@citea{,\penalty\@citeseppen\ }\@ifundefined
       {b@\@citeb}{{\bf ?}\@warning
       {Citation `\@citeb' on page \thepage \space undefined}}%
{\csname b@\@citeb\endcsname}}}{}}
\def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
 \let\@citea\@empty
  \@cite{\@for\@citeb:=#2\do
    {\@citea\def\@citea{;\penalty\@citeseppen\ }%
     \def\@tempa##1##2\@nil{\edef\@citeb{\if##1\space##2\else##1##2\fi}}%
     \expandafter\@tempa\@citeb\@nil
     \@ifundefined{b@\@citeb}{{\bf ?}\@warning
       {Citation `\@citeb' on page \thepage \space undefined}}%
     {\csname b@\@citeb\endcsname}}}{#1}}
%\def\@biblabel#1{\def\citeauthoryear##1##2{##1, ##2}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newdimen\bibindent
\bibindent=1.5em
%\def\@biblabel#1{[#1]}
\def\@biblabel#1{}
\newenvironment{thebibliography}%[1]
     {\section*{\bibname}\bibfont%
      \list{}%
            {\leftmargin1pc%\bibindent
            \itemindent-1pc\labelwidth0pt
        \labelsep0pt%.33em
            \advance\leftmargin\labelsep
        \itemsep0pt\parsep0pt
            \usecounter{enumiv}%
            \renewcommand\theenumiv{\arabic{enumiv}}}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.=\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Appendix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newcounter{appendixc}
\newcounter{subappendixc}[appendixc]
\newcounter{subsubappendixc}[subappendixc]
\renewcommand{\thesubappendixc}{\Alph{appendixc}.\arabic{subappendixc}}
\renewcommand{\thesubsubappendixc}
    {\Alph{appendixc}.\arabic{subappendixc}.\arabic{subsubappendixc}}

\newcommand{\appendix}[1]{
        \vspace{14pt}
        \refstepcounter{appendixc}
        \setcounter{figure}{0}
        \setcounter{table}{0}
        \setcounter{lemma}{0}
        \setcounter{theorem}{0}
        \setcounter{corollary}{0}
        \setcounter{definition}{0}
        \setcounter{equation}{0}
        \renewcommand{\thefigure}{\Alph{appendixc}.\arabic{figure}}
        \renewcommand{\thetable}{\Alph{appendixc}.\arabic{table}}
        \renewcommand{\theappendixc}{\Alph{appendixc}}
        \renewcommand{\thelemma}{\Alph{appendixc}.\arabic{lemma}}
        \renewcommand{\thetheorem}{\Alph{appendixc}.\arabic{theorem}}
        \renewcommand{\thedefinition}{\Alph{appendixc}.\arabic{definition}}
        \renewcommand{\thecorollary}{\Alph{appendixc}.\arabic{corollary}}
        \renewcommand{\theequation}{\Alph{appendixc}.\arabic{equation}}
        \noindent{\sectionfont\appendixname\enskip\theappendixc\enskip\boldmath~#1}\par\vspace{5pt}
        \addcontentsline{toc}{appendix}{Appendix~\theappendixc.\enskip#1}\noindent\ignorespaces}
\newcommand{\subappendix}[1]{\vspace{14pt}
        \refstepcounter{subappendixc}
        \noindent{\sectionfont\appendixname~\thesubappendixc.\enskip{\kern1pt \bfseries\boldmath\itshape #1}}
        \par\vspace{8pt}
        \addcontentsline{toc}{subappendix}{Appendix~\thesubappendixc.\enskip#1}\noindent\ignorespaces}
\newcommand{\subsubappendix}[1]{\vspace{14pt}
        \refstepcounter{subsubappendixc}
        \noindent{\appendixfont\appendixname~\thesubsubappendixc.\enskip{\kern1pt \it #1}\noindent\ignorespaces}
        \par\vspace{8pt}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End Appendix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Contents Pages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\journalname{\uppercase{International Journal of Bifurcation and Chaos}}
\def\No{No.}
\def\chead#1#2#3{\par
\thispagestyle{empty}
{\centering{%
{\titlefont\journalname}\par
{\sl Vol.~#1, \No~#2 (#3)}\par
\vspace*{34pt}
\noindent CONTENTS\par}}
\vspace*{14pt}}
\def\leaderfill{\leaders\hbox to 1em{\hss.\hss}\hfill}
\def\centry#1#2#3{\par
    {\foliofont
    \setbox\tempbox\hbox{#3}
    {\rightskip3.5pc plus1fil
    \noindent{\uppercase{#1}}\par}
    {\leftskip12pt{\rightskip1pc plus1fil
    \ignorespaces\noindent#2\leaderfill\hspace*{2pt}\hskip\wd\tempbox\par}\par}\par
    \vskip-\lastskip
    \vskip-\baselineskip
    \hbox to \hsize{\hfill#3}\par}
    \addvspace{8pt plus1pt minus1pt}\par}
%%
\def\cent#1#2#3{\par{\foliofont
    {\rightskip2pc plus1fil
    \noindent\par}
    {\noindent{\uppercase{#1}}\ignorespaces#2\leaderfill\hspace*{2pt}#3\par}}\par
%   \noindent{\uppercase{#1}}\par}
%   \hbox to 30pc{\noindent\ignorespaces\hspace*{12pt}#2\leaderfill\hspace*{2pt}#3\par}}\par
    \addvspace{8pt plus1pt minus1pt}\par
    }
%
%\def\cent#1#2#3{\par
%   {\foliofont
%   \setbox\tempbox\hbox{#3}
%   {\rightskip3.5pc plus1fil
%   \noindent{\uppercase{#1}}\par}
%   {\leftskip12pt{\rightskip1pc plus1fil
%   \ignorespaces\noindent#2\leaderfill\hspace*{2pt}\hskip\wd\tempbox\par}\par}\par
%   \vskip-\lastskip
%   \vskip-\baselineskip
%   \hbox to \hsize{\hfill#3}\par}
%   \addvspace{8pt plus1pt minus1pt}\par}
%
%\def\cent#1#2#3{\par\bibfont\addvspace{10pt plus2pt minus2pt}
%   {\foliofont{\rightskip4pc plus1fil
%   \noindent#1\par}\par
%   \vskip-\lastskip\vskip-\baselineskip
%   \hbox to \hsize{\hfill#3}\par
%   {\noindent\leftskip15pt{\rightskip4pc plus1fil{\it #2}\par}}}\par}
%
\def\ehead#1#2#3{\par
    \addvspace{12pt plus1pt minus1pt}
    {\foliofont\rightskip4pc plus1fil
    \noindent{\bf #1{#2}{#3}\par}
    \vspace*{4pt}}\par}
%
\def\eehead#1#2#3{\par
%   \addvspace{6pt plus1pt minus1pt}
    \addvspace{12pt plus1pt minus1pt}
    {\foliofont\rightskip4pc plus1fil
    \noindent{\bf #1{#2}{#3}\par}
    \vspace*{4pt}}\par}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trim Marks %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\wsdraftnote{\qquad\today\quad\currenttime\quad\jobname}%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ss %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\cropmarks{\nointerlineskip%
     \vbox to 0pt{\vskip-8.6pt
    \parindent0pt\wsdraftnote
     \par\advance\trimheight by 2pc
     \vbox to \trimheight{\offinterlineskip\parindent0pt\vskip-2pc
     \hbox to \trimwidth{\raise2.6pc\hbox{\vrule height2pc width0.3pt}\raisebox{2pc}
   {\hspace*{-2.6pc}\vrule width2pc height0.3pt}\hfill\raisebox{2pc}
   {\vrule width2pc height0.3pt}\hspace*{-2.6pc}\raise2.6pc\hbox{\vrule height2pc width0.3pt}}\vfill
     \hbox to \trimwidth{\lower1.2pc\hbox{\vrule height2pc width0.3pt}\raisebox{1.4pc}
        {\hspace*{-2.6pc}\vrule width2pc height0.3pt}\hfill
    \lower1.2pc\hbox{\vrule height2pc width0.3pt}\rlap{\hspace*{0.6pc}\raisebox{1.4pc}{\vrule width2pc height0.3pt}}}}}
     \vbox to 0pt{\offinterlineskip\parindent0pt\vskip\topmargin%\vskip1.3pt
     \tempdimen\normaltextheight
          \advance\tempdimen37pt
     %\advance\tempdimen24pt
     \moveright\@themargin
     \vbox to \tempdimen{\hrule height\wsdraftrule
     \vbox to 0pt{\vskip\headheight\vskip\headsep%\vskip3pt
                \vrule height\wsdraftrule width\textwidth}%
      \hbox to \textwidth{\vrule width\wsdraftrule \hfill\vrule height\tempdimen width\wsdraftrule}%
           \hrule height\wsdraftrule}}}%%
\def\xcropmarks{\nointerlineskip%
     \vbox to 0pt{\vskip-8.6pt
    \parindent0pt\hspace*{6pt}\wsdraftnote
     \par\advance\trimheight by 2pc
     \vbox to \trimheight{\offinterlineskip\parindent0pt\vskip-2pc
     \hbox to \trimwidth{\raise2.6pc\hbox{\vrule height2pc width0.3pt}\raisebox{2pc}
   {\hspace*{-2.6pc}\vrule width2pc height0.3pt}\hfill\raisebox{2pc}
   {\vrule width2pc height0.3pt}\hspace*{-2.6pc}\raise2.6pc\hbox{\vrule height2pc width0.3pt}}\vfill
     \hbox to \trimwidth{\lower1.2pc\hbox{\vrule height2pc width0.3pt}\raisebox{1.4pc}
        {\hspace*{-2.6pc}\vrule width2pc height0.3pt}\hfill
    \lower1.2pc\hbox{\vrule height2pc width0.3pt}\rlap{\hspace*{0.6pc}\raisebox{1.4pc}{\vrule width2pc height0.3pt}}}}}
     \vbox to 0pt{\offinterlineskip\parindent0pt\vskip\topmargin%\vskip1.3pt
     \tempdimen\normaltextheight
     \advance\tempdimen27pt
     \moveright\@themargin
     \vbox to \tempdimen{\hrule height\wsdraftrule
     \vbox to 0pt{\vskip\headheight\vskip\headsep%\vskip3pt
                \vrule height\wsdraftrule width\textwidth}%
      \hbox to \textwidth{\vrule width\wsdraftrule \hfill\vrule height\tempdimen width\wsdraftrule}%
           \hrule height\wsdraftrule}}}%%
%
\let\trimmarks\cropmarks
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output Routine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\@outputpage{%
\begingroup           % the \endgroup is put in by \aftergroup
  \let \protect \noexpand
  \@resetactivechars
  \let\-\@dischyph
  \let\'\@acci\let\`\@accii\let\=\@acciii
  \let\\\@normalcr
  \let\par\@@par          %% 15 Sep 87
  \shipout \vbox{%
    \set@typeset@protect
    \aftergroup \endgroup
    \aftergroup \set@typeset@protect
                                % correct? or just restore by ending
                                % the group?
  \if@specialpage
    \global\@specialpagefalse\@nameuse{ps@\@specialstyle}%
  \fi
  \if@twoside
    \ifodd\count\z@ \let\@thehead\@oddhead \let\@thefoot\@oddfoot
         \let\@themargin\oddsidemargin
    \else \let\@thehead\@evenhead
       \let\@thefoot\@evenfoot \let\@themargin\evensidemargin
    \fi
  \fi
  \reset@font
  \normalsize
  \baselineskip\z@skip \lineskip\z@skip \lineskiplimit\z@
    \@begindvi\trimmarks
    \vskip \topmargin
    \moveright\@themargin \vbox {%
      \setbox\@tempboxa \vbox to\headheight{%
        \vfil
        \color@hbox
          \normalcolor
          \hb@xt@\textwidth {%
            \let \label \@gobble
            \let \index \@gobble
            \let \glossary \@gobble %% 21 Jun 91
            \@thehead
            }%
        \color@endbox
        }%                        %% 22 Feb 87
      \dp\@tempboxa \z@
      \box\@tempboxa
      \vskip \headsep
      \box\@outputbox
      \baselineskip \footskip
      \color@hbox
        \normalcolor
        \hb@xt@\textwidth{%
          \let \label \@gobble
          \let \index \@gobble      %% 22 Feb 87
          \let \glossary \@gobble   %% 21 Jun 91
          \@thefoot
          }%
      \color@endbox
      }%
    }%
\global \@colht \textheight
\stepcounter{page}%
\let\firstmark\botmark
}
%
\def\hruleup{\raise4pt\hbox to\hsize{\hrulefill\hbox{\vrule height6pt}}\unskip}
\def\hruledown{\noindent\leavevmode\kern-.5pt\lower2pt\hbox{\hbox{\vrule
height6pt}\raise5.5pt\hbox to\hsize{\hrulefill}}}

\def\hruleuuup{\raise4pt\hbox to\hsize{\hbox{\vrule height6pt}\hrulefill}\unskip}
\def\hruleuup{\hspace*{-10pt}\raise4pt\hbox to\hsize{\hbox{\vrule height6pt}\hrulefill}\unskip}
\def\hruleddown{\noindent\raise5.5pt\hbox to\hsize{\hrulefill}\leavevmode\lower0pt\hbox{\hbox{\vrule
height6pt}}}

%
%\def\logodir{/usr/lib/teTeX/texmf/tex/latex/wspc_local/jai}
\def\slogo{0}
\def\letters{\def\slogo{3}}
\def\papers{\def\slogo{2}}
\def\tutorials{\def\slogo{1}}
%\def\inpro{\def\slogo{4}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Process Options %%%%%%%%%%%%%%%%%%%%%%%%
%
\pagestyle{headings}
\pagenumbering{arabic}
\frenchspacing
\def\sloppy{\tolerance=100000\hfuzz=\maxdimen \vfuzz=\maxdimen}
\sloppy
\vbadness=12000
\hbadness=12000
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{amsmath}
\RequirePackage{graphicx}
\RequirePackage{dcolumn}
\RequirePackage{ws-rotating}
\RequirePackage{natbib}
    \let\cite=\citep
    \setlength{\bibhang}{24pt}
    \def\bibfont{\fontsize{10}{12}\selectfont}
    \renewcommand\bibsection{\section*{\sectionfont\refname}}
\RequirePackage{url}
    \urlstyle{rm}

\flushbottom
\hoffset=-2.5cm
\voffset=-1cm

\def\fbase{\baselineskip=13.001pt plus 0.001pt}

\def\mncap#1{\vskip4.6pt%
\begin{center}{\baselineskip11pt\NINE #1\par}\end{center}}

\def\@opargbegintheorem#1#2#3{\trivlist
      \item[\hskip \labelsep{\bfseries #1\ #2} {\rm [#3].}]\ \itshape}
\def\@endtheorem{\endtrivlist}

\newcolumntype{d}[1]{D{.}{.}{#1}}

\def\vvsp#1{\vadjust{\vspace{#1pt}\pagebreak}} 
\def\x{\end{document}} 
\def\tra#1{\spaceskip0.#1em plus0.09em minus0.06em} 
\def\ol#1{\kern0.025cm\overline{\kern-0.025cm #1\kern-0.025cm}\kern0.025cm}
\def\ds{\displaystyle}
\def\nn{\nonumber}
\def\corres{\gdef\@thefnmark{}\@footnotetext}

\hoffset=-3cm
\voffset=-2.5cm

\ProcessOptions
\endinput
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of file %%%%%%%%%%%%%%%%%%%%%%%%%%%%

