%%
%% This is file siamltexmm.cls, based on siamltex.cls. This revised
%% SIAM multimedia macro is for use with LaTeX 2e for the
%% Society for Industrial and Applied Mathematics. 
%% 
%% March 9, 2001
%%
%% Version 1.2
%% 
%% This multimedia macro requires the hyperref package.
%%
%% You are not allowed to change this file. 
%% 
%% You are allowed to distribute this file under the condition that it is
%% distributed together with all of the files in the SIAM multimedia
%% macro distribution. These are:
%%
%%  siamltexmm.cls (this file)
%%  siam11.clo   (required size option for 11pt papers)
%%  subeqn.clo   (allows equation numbers with lettered subelements)
%%  siam.bst     (bibliographic style file for BibTeX)
%%  docultexmm.tex (documentation file)
%%
%% If you receive only some of these files from someone, please contact: 
%% multimedia@siam.org  
%% 
%% You are not allowed to distribute this file alone. You are not 
%% allowed to take money for the distribution or use of either this 
%% file or a changed version, except for a nominal charge for copying 
%% etc.
%%
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{LaTeX2e}[1995/06/01]
\ProvidesClass{siamltexmm}[1996/10/11 v1.2 LaTeX document class]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
\newif\if@oneeqnum
\@oneeqnumfalse
\newif\if@onetabnum
\@onetabnumfalse
\newif\if@onefignum
\@onefignumfalse
\newif\if@onethmnum
\@onethmnumfalse
%\newif\if@openbib
%\@openbibfalse
\DeclareOption{siamltexmmpaper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}} %restored
\DeclareOption{subeqn}{\input{subeqn.clo}}
\DeclareOption{oneeqnum}{\@oneeqnumtrue} % added 7.19.96
\DeclareOption{onetabnum}{\@onetabnumtrue} % added 7.19.96
\DeclareOption{onefignum}{\@onefignumtrue} % added 7.19.96
\DeclareOption{onethmnum}{\@onethmnumtrue} % added 7.29.96
%\DeclareOption{openbib}{\@openbibtrue}
%%%\ExecuteOptions{letterpaper,10pt,twoside,onecolumn,leqno,draft,notitlepage}
\ExecuteOptions{siamltexmmpaper,twoside,onecolumn,draft,notitlepage}
\ProcessOptions
\input{siam11.clo}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.9}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.1}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.1}
\renewcommand\floatpagefraction{.91}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\renewcommand{\ps@plain}{\let\@mkboth\@gobbletwo%
  \renewcommand{\@oddhead}{\slugmaster}%
  \renewcommand{\@evenhead}{\slugmaster}%
  \renewcommand{\@evenfoot}{\hfil\footnotesize\color{header1}\HLsmall\thepage\hfil}%
  \renewcommand{\@oddfoot}{\@evenfoot}}
\setlength{\textwidth}{6.151in}
%\setlength{\oddsidemargin}{\evensidemargin}
\addtolength{\evensidemargin}{1.08pc}
\addtolength{\oddsidemargin}{1.08pc}

%%%NOTE: For "dviwindo" hyperref option, add "\hspace*{-0.282pc}" after "\HLsmall"
%%%in both the even and odd heads below.
    \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\color{header1}\HLsmall\rlap{\thepage}\hfill\HLsmall\leftmark}%
      \def\@oddhead{\color{header1}\HLsmall\rightmark\hfill\llap{\thepage}}%
      \let\@mkboth\markboth
      \def\sectionmark##1{%
        \markboth {\uppercase{\ifnum \c@secnumdepth >\z@
            \thesection.\hskip 1em\relax\fi
            ##1}}{}}%
      \def\subsectionmark##1{%
        \markright {\ifnum \c@secnumdepth >\@ne
            \thesubsection\hskip 1em\relax \fi
            ##1}}}

%%%NOTE: For "dviwindo" hyperref option, add "\hspace*{-0.282pc}" before "\vbox"
%%%in both the even and odd heads below.
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\color{header1}\HLsmall\vbox{\thepage\hfill\HLsmall\leftmark\\[-0.35pc]
\color{gray}\rule{\textwidth}{2pt}}}%
%%%\color{gray}\rule{\textwidth}{2pt}\\[-0.166pc]
%%%\color{strip}\hspace*{-0.341pc}\rule{2pt}{52.188pc}}}%
    \def\@oddhead{\color{header1}\HLsmall\vbox{\rightmark\hfill\thepage\\[-0.35pc]
\color{gray}\rule{\textwidth}{2pt}}}%
%%%\color{gray}\rule{\textwidth}{2pt}\\[-0.166pc]
%%%\color{strip}\hspace*{\textwidth}\hspace*{0.175pc}\rule{2pt}{52.188pc}}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }

\newcommand\maketitle{\par
  \begingroup
    \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
    \def\@makefnmark{\hbox to\z@{$\m@th^{\@thefnmark}$\hss}}%
    \long\def\@makefntext##1{\sf\parindent 1em\noindent
            \hbox to1.8em{\hss$\m@th^{\@thefnmark}$}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \let\maketitle\relax\let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax}
\def\@maketitle{%
  \null
  \begin{center}%
\noindent
\color{header1}
%%%    {\bfseries\@ucnothanks\@title\par}%
    {\HLtitle\@title\par}%
    \vskip .125in%
%%%\begin{flushleft}
    {\normalsize
      \spaceskip=1.5\fontdimen2\the\font
%%%      \def\and{\ \scriptsize AND }
      \def\and{\hspace*{0.29pc}\protect\sf\footnotesize\lowercase{and} }
      \@tempswafalse\expandafter\@doauth\@author\and\relax}\\
\color{gray}\rule{\textwidth}{4pt}
  \end{center}%
%%%\end{flushleft}
  \par
  \vskip .11in}
\def\@ucnothanks#1{\expandafter\@ucnt#1\thanks\relax}
%%%\def\@ucnt#1\thanks{\uppercase{#1}\futurelet\@tempa\@ucnta}
\def\@ucnt#1\thanks{\normalsize{\sf #1}\futurelet\@tempa\@ucnta}
\def\@ucnta{\ifx\@tempa\relax\else\@ucntb\fi}
\def\@ucntb#1\thanks\relax{\thanks{\sf #1}}
\def\@doauth#1\and{\let\@nextdoa=\@doauth
 \def\@tempc{\@ucnothanks{#1}}
 \futurelet\@tempa\@doautha}
\def\@doautha{\ifx\@tempa\relax
  \if@tempswa {\and}\fi
  \let\@nextdoa=\relax
 \else
%%%  \if@tempswa \gdef\and{,\ \scriptsize AND }, \fi
  \if@tempswa \gdef\and{$\!$,\ \protect\sf\footnotesize\lowercase{and} }$\!$, \fi
 \fi
 \@tempc\unskip\@tempswatrue\@nextdoa}
\let\and=\relax

\newcommand{\sevenptsize}{%
   \@setfontsize\sixptsize{7}{9}}

\newcommand{\sixptsize}{%
   \@setfontsize\sixptsize{6}{8}}

%%create five-point size
\newcommand{\fiveptsize}{%
   \@setfontsize\fiveptsize{5}{7}}

\newcommand\simac{SIAM J{\HLlittlest OURNAL} M{\HLlittlest ACRO}}
\newcommand\siads{SIAM J.\ A{\HLlittlest PPLIED} D{\HLlittlest YNAMICAL} S{\HLlittlest YSTEMS}}
\newcommand\siap{SIAM J.\ A{\HLlittlest PPL.} M{\HLlittlest ATH.}}
\newcommand\sicomp{SIAM J.\ C{\HLlittlest OMPUT.}}
\newcommand\sicon{SIAM J.\ C{\HLlittlest ONTROL}  O{\HLlittlest PTIM.}}
\newcommand\sidma{SIAM J.\ D{\HLlittlest ISCRETE} M{\HLlittlest ATH.}}
\newcommand\sima{SIAM J.\ M{\HLlittlest ATH.} A{\HLlittlest NAL.}}
\newcommand\simax{SIAM J.\ M{\HLlittlest ATRIX} A{\HLlittlest NAL.} A{\HLlittlest PPL.}}
\newcommand\sinum{SIAM J.\ N{\HLlittlest UMER.} A{\HLlittlest NAL.}}
\newcommand\siopt{SIAM J.\ O{\HLlittlest PTIM.}}
\newcommand\sisc{SIAM J.\ S{\HLlittlest CI.} C{\HLlittlest OMPUT.}}
\newcommand\sirev{SIAM R{\HLlittlest EV.}}
\newcommand\siims{SIAM J. I{\HLlittlest MAGING} S{\HLlittlest CIENCES}}
\newcommand\sifin{SIAM J. F{\HLlittlest INANCIAL} M{\HLlittlest ATH.}}
\newcommand\juq{SIAM/ASA J. U{\HLlittlest NCERTAINTY} Q{\HLlittlest UANTIFICATION}}

\RequirePackage[dvips]{color}
\definecolor{header1}{cmyk}{.9,.5,0,.35}
\definecolor{blue1}{cmyk}{.9,.7,0,0}
\definecolor{blue2}{cmyk}{.93,.95,.2,.07}
\definecolor{maroon}{cmyk}{.4,1,.3,.2}
\definecolor{gold1}{cmyk}{.2,.2,1,.1}
\definecolor{gray}{cmyk}{0,0,0,.5}
\definecolor{green1}{cmyk}{1,0,1,0}
\definecolor{proofcolor}{cmyk}{1,0,1,0}
\definecolor{red1}{cmyk}{0,1,.8,0}
\definecolor{orange1}{cmyk}{0,.55,1,0}
\definecolor{strip}{cmyk}{.6,.1,.1,.1}

%\newcommand{\slugline}[7]{%
%\vbox{%
%{\color{gray}\HLlittle\baselineskip10pt
%\noindent
%\hspace*{-0.282pc}\expandafter\csname#1\endcsname\hfill
%{\scriptsize{\copyright}} #6 Society for Industrial and
%Applied\vspace*{-1.2mm}  Mathematics\hspace*{0.272pc}\\
%\hspace*{-0.282pc}Vol.\ #2, No.\ #3, pp.\ #4, #5\ #6
%\hfill #7\hspace*{0.272pc}\par}%
%}
%\normalsize}
%
%\newcommand{\slugger}[5]{%
%\vbox{%
%{\color{gray}\HLlittle\baselineskip10pt
%\noindent
%\hspace*{-0.282pc}\expandafter\csname#1\endcsname\hfill
%{\scriptsize{\copyright}} #2 Society for Industrial and
%Applied\vspace*{-1.2mm} Mathematics\hspace*{0.272pc}\\
%\hspace*{-0.282pc}Vol.\ #3, No.\ #4, pp.\ #5
%\hspace*{\fill} \par}%
%}
%\normalsize}
\newcommand{\slugline}[7]{%
\vbox{%
{\HLlittle\baselineskip10pt
\noindent
\expandafter\csname#1\endcsname\hfill
{\scriptsize{\copyright}} #6 Society for Industrial and
Applied\vspace*{-1.2mm}  Mathematics\\
Vol.\ #2, No.\ #3, pp.\ #4, #5\ #6
\hfill #7\par}%
}
\normalsize}

%%%\newcommand{\slugger}[5]{%
\newcommand{\slugger}[4]{%
\vbox{%
{\HLlittle\baselineskip10pt
\noindent
\expandafter\csname#1\endcsname\hfill
{\scriptsize{\copyright}} #2 Society for Industrial and
Applied\vspace*{-1.2mm} Mathematics\\
%%%Vol.\ #3, No.\ #4, pp.\ #5
Vol.\ #3, pp.\ #4
\hspace*{\fill} \par}%
}
\normalsize}

\setcounter{secnumdepth}{3}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thesection       {\arabic{section}}
\renewcommand\thesubsection    {\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection {\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph     {\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph  {\theparagraph.\arabic{subparagraph}}

\def\@sect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \def\@svsec{}\else
     \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname.\hskip .5em }\fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M #8\par}
        \endgroup
       \csname #1mark\endcsname{#7}\addcontentsline
         {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi
                    #7}\else
        \def\@svsechd{#6\hskip #3\@svsec #8.\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}
\def\@ssect#1#2#3#4#5{\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M
#5.\par}\endgroup
   \else \def\@svsechd{#4\hskip #1\relax #5.}\fi
    \@xsect{#3}}

\newcommand\section{\@startsection{section}{1}{.25in}%
                                  {1.3ex \@plus .5ex \@minus .2ex}%
                                  {-.5em \@plus -.1em}%
                                  {\reset@font\color{header1}\normalsize\HLtext}}
\newcommand\subsection{\@startsection{subsection}{2}{.25in}%
                                     {1.3ex\@plus .5ex \@minus .2ex}%
                                     {-.5em \@plus -.1em}%
                                     {\reset@font\color{header1}\normalsize\HLtext}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{.25in}%
                                        {1.3ex\@plus .5ex \@minus .2ex}%
                                        {-.5em \@plus -.1em}%
                                        {\reset@font\color{header1}\normalsize\HLtext}}
\newcommand\paragraph{\@startsection{paragraph}{4}{.25in}%
                                    {\parskip}%
                                    {-.5em plus -.1em}%
                                    {\reset@font\color{header1}\normalsize\HLtextlfital}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {\parskip}%
                                       {-.5em plus -.1em}%
                                       {\reset@font\color{header1}\normalsize\HLtextlf}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {0.5in}
\fi
\setlength\leftmarginii   {22pt}
\setlength\leftmarginiii  {18.7pt}
\setlength\leftmarginiv   {17pt}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {10pt}
  \setlength\leftmarginvi {10pt}
\fi
\setlength  \leftmargin{\leftmargini}
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\arabic{enumi}}
\renewcommand\theenumii{\alph{enumii}}
\renewcommand\theenumiii{\roman{enumiii}}
\renewcommand\theenumiv{\Alph{enumiv}}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi\theenumii}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{$\m@th\bullet$}
\newcommand\labelitemii{\normalfont\bfseries --}
\newcommand\labelitemiii{$\m@th\ast$}
\newcommand\labelitemiv{$\m@th\cdot$}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newcounter{rmnum}
\newenvironment{romannum}
               {\begin{list}{{\upshape (\roman{rmnum})}}{\usecounter{rmnum}
                \setlength{\leftmargin}{0pt}
                \setlength{\itemindent}{42pt}}}{\end{list}}
\newcounter{muni}
\newenvironment{remunerate}
               {\begin{list}{{\upshape \arabic{muni}.}}{\usecounter{muni}
                \setlength{\leftmargin}{0pt}
                \setlength{\itemindent}{38pt}}}{\end{list}}

\newenvironment{abstract}{%
     \if@twocolumn
       \section*{Abstract}%
     \else
\list{}{\footnotesize\itemsep \z@
\labelwidth 3.658pc%
\itemindent 0pt%
\labelsep 0.5pc%
\listparindent 1pc
\leftmargin 3.658pc
\item[\color{header1}\scshape\HLsmall \abstractname.]}
     \fi}
     {\if@twocolumn\else\endlist\vspace{.1in}\fi}

\newenvironment{@abssec}[1]{%
     \if@twocolumn
       \section*{#1}%
     \else
       \vspace{.05in}\footnotesize
       \parindent 0in
       \hangindent 3.658pc
         {\color{header1}\scshape\HLsmall #1.\hspace*{0.5pc}}\ignorespaces
     \fi}
     {\if@twocolumn\else\par\vspace{.1in}\fi}

\newenvironment{@piisec}[1]{%
     \if@twocolumn
       \section*{#1}%
     \else
       \vspace{.05in}\footnotesize
       \parindent 0in
       \hangindent 3.658pc
         {\color{header1}\scshape\HLsmall #1.\hspace*{0.5pc}}\ignorespaces
     \fi}
     {\if@twocolumn\else\par
{\color{gray}\rule{\textwidth}{1pt}}
\vspace{-3ex}\fi}

\newenvironment{@doisec}[1]{%
     \if@twocolumn
       \section*{#1}%
     \else
       \vspace{.05in}\footnotesize
       \parindent 0in
       \hangindent 3.658pc
         {\color{header1}\scshape\HLsmall #1.\hspace*{0.5pc}}\ignorespaces
     \fi}
     {\if@twocolumn\else\par
{\color{gray}\rule{\textwidth}{1pt}}
\vspace{-3ex}\fi}

%%%\newenvironment{abstract}{\begin{@abssec}{\abstractname}}{\end{@abssec}}
\newenvironment{keywords}{\begin{@abssec}{\keywordsname}}{\end{@abssec}}
\newenvironment{keyword}{\begin{@abssec}{\keywordname}}{\end{@abssec}}
\newenvironment{AMS}{\begin{@abssec}{\AMSname}}{\end{@abssec}}
\newenvironment{AM}{\begin{@abssec}{\AMname}}{\end{@abssec}}
\newenvironment{PII}{\begin{@piisec}{\PIIname}}{\end{@piisec}}
\newenvironment{DOI}{\begin{@doisec}{\DOIname}}{\end{@doisec}}

\newenvironment{verse}
               {\let\\=\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item[]}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item[]}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item[]}
               {\endlist}
%%%\def\@begintheorem#1#2{\par\bgroup{\scshape #1\ #2. }\it\ignorespaces}
%%%\def\@opargbegintheorem#1#2#3{\par\bgroup%
%%%   {\scshape #1\ #2\ ({\upshape #3}). }\it\ignorespaces}
\def\@begintheorem#1#2{\par\bgroup{\color{black}\mbox{\sffamily{\color{header1}#1\ #2.}\color{black}}}\color{black}\it\ignorespaces}
\def\@opargbegintheorem#1#2#3{\par\bgroup{\color{black}\mbox{\sffamily{\color{header1}#1\ #2\ (#3).}\color{black}}}\color{black}\it\ignorespaces}
\def\@endtheorem{\egroup}
\def\proof{\par{\color{black}{\mbox{\color{header1}{\it Proof}.$\,$}\color{black}}} \ignorespaces\color{black}}
\def\endproof{{\color{header1}\rule{1.5ex}{1.5ex}}}

\def\prooftext#1{\par{\color{header1}{\it #1}.} \ignorespaces}

%%%\def\endproof{\vbox{\hrule height0.6pt\hbox{%
%%%   \vrule height1.3ex width0.6pt\hskip0.8ex
%%%   \vrule width0.6pt}\hrule height0.6pt
%%%  }}

\if@onethmnum
  \newtheorem{theorem}{Theorem}
  \newtheorem{lemma}[theorem]{Lemma}
  \newtheorem{corollary}[theorem]{Corollary}
  \newtheorem{proposition}[theorem]{Proposition}
  \newtheorem{definition}[theorem]{Definition}
\else
  \newtheorem{theorem}{Theorem}[section]
  \newtheorem{lemma}[theorem]{Lemma}
  \newtheorem{corollary}[theorem]{Corollary}
  \newtheorem{proposition}[theorem]{Proposition}
  \newtheorem{definition}[theorem]{Definition}
\fi

% FROM FIXUP.STY
% We now redefine the eqnarray environment to correct the space around
% the operator.   Any changes to the definition in LaTeX itself
% will cause the `Warning: unable...'
% message to appear.  If this happens it will be necessary to update the
% definition of  \@tempb below and incorperate the changes into
% the new definitions of \eqnarray.

% This is the current definition of \eqnarray for the fleqn document style
% latex.ltx

\def\@tempb{%
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
      \cr
}
\ifx\eqnarray\@tempb    % Try the default eqnarray environment
  \def\eqnarray{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne \hfil$\displaystyle{{}##{}}$\hfil
      &\global\@eqcnt\tw@ $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
         \tabskip\z@skip
      \cr
}
\else    \typeout{Warning: Unable to fix unknown version of \string\eqnarray.}
\fi

\def\@tempb{}


%% New Mathops.

\newcommand\const{\mathop{\operator@font const}\nolimits}
\newcommand\diag{\mathop{\operator@font diag}\nolimits}
\newcommand\grad{\mathop{\operator@font grad}\nolimits}
\newcommand\Range{\mathop{\operator@font Range}\nolimits}
\newcommand\rank{\mathop{\operator@font rank}\nolimits}
\newcommand\supp{\mathop{\operator@font supp}\nolimits}

\newcommand\appendix{%
\renewcommand{\section}{%
\secdef\append\sappend}%
 \setcounter{section}{0}%
 \setcounter{subsection}{0}%
 \renewcommand\thesection{\Alph{section}}}

\newcommand\Appendix{%
\renewcommand{\section}{%
\secdef\Append\sAppend}%
 \setcounter{section}{0}%
 \setcounter{subsection}{0}%
 \renewcommand\thesection{\Alph{section}}}

\newcommand\append[2][?]{%
\refstepcounter{section}%
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\color{header1}\reset@font\normalsize\HLtext\appendixname\ \thesection. #2.}}

\newcommand\sappend[1]{%
\refstepcounter{section}
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\color{header1}\reset@font\normalsize\HLtext\appendixname\ \thesection.}}

\newcommand\Append[2][?]{%
\refstepcounter{section}%
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\color{header1}\reset@font\normalsize\HLtext\appendixname. #2.}}

\newcommand\sAppend[1]{%
\refstepcounter{section}
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\color{header1}\reset@font\normalsize\HLtext\appendixname.}} 

%\newcommand\append[2][?]{%
%\refstepcounter{section}%
%{\vskip 1.3ex \@plus .5ex \@minus .2ex
%\reset@font\normalsize\HLtext\appendixname\ \thesection. #2.}}
%
%\newcommand\sappend[1]{%
%\refstepcounter{section}
%{\vskip 1.3ex \@plus .5ex \@minus .2ex
%\reset@font\normalsize\HLtext\appendixname\ \thesection.}}
%
%\newcommand\Append[2][?]{%
%\refstepcounter{section}%
%{\vskip 1.3ex \@plus .5ex \@minus .2ex
%\reset@font\normalsize\HLtext\appendixname. #2.}}
%
%\newcommand\sAppend[1]{%
%\refstepcounter{section}
%{\vskip 1.3ex \@plus .5ex \@minus .2ex
%\reset@font\normalsize\HLtext\appendixname.}}

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}

\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand{\thetable}{\@arabic\c@table}
\def\fps@table{tp}
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
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{10\p@}
\def\@figtxt{figure}
\long\def\@makecaption#1#2{%
    \footnotesize
    \setlength{\parindent}{1.5pc}
  \ifx\@captype\@figtxt
    \vskip\abovecaptionskip
    \setbox\@tempboxa\hbox{{\normalfont\color{header1}\HLsmall #1.} {\normalfont\itshape #2}}%
    \ifdim \wd\@tempboxa >\hsize
      {\normalfont\color{header1}\HLsmall #1.} {\normalfont\itshape #2}\par
    \else
      \global\@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
  \else
    \hbox to\hsize{\hfil{\normalfont\color{header1}\HLsmall #1}\hfil}%
    \setbox\@tempboxa\hbox{{\normalfont\itshape #2}}%
    \ifdim \wd\@tempboxa >\hsize
      {\normalfont\itshape #2}\par
    \else
     \global\@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
    \vskip\belowcaptionskip
  \fi}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch{\relax}{\mathcal}}
\DeclareRobustCommand*\mit{\@fontswitch{\relax}{\mathnormal}}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg {2.55em}
\newcommand\@dotsep{4.5}

\newdimen\bibindent
\bibindent=16pt
\newenvironment{thebibliography}[1]
     {\par\addvspace{.25in}
     \begin{center}
     \mbox{\color{header1}\footnotesize\HLtext REFERENCES}
     \end{center}
     \@mkboth{\color{header1}\expandafter{\refname}}{\color{header1}\expandafter{\refname}}
     \addvspace{.15in}\nopagebreak%
      \list{\@biblabel{\arabic{enumi}}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
%            \if@openbib
              \advance\leftmargin\bibindent
              \itemindent -\bibindent
              \listparindent \itemindent
              \parsep \z@
%            \fi
            \usecounter{enumi}%
            \let\p@enumi\@empty
            \renewcommand\theenumi{\arabic{enumi}}}%
%      \if@openbib
%        \renewcommand\newblock{\par}
%      \else
        \renewcommand\newblock{\hskip .11em \@plus.33em \@minus.07em}%
%      \fi
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.=\@m\relax\footnotesize}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{}
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \columnseprule \z@
                \columnsep 35\p@
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\uppercase{\indexname}}%
                        {\uppercase{\indexname}}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem  {\par\hangindent 40\p@}
\newcommand\subitem   {\par\hangindent 40\p@ \hspace*{20\p@}}
\newcommand\subsubitem{\par\hangindent 40\p@ \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule width \textwidth
  \kern 2.6\p@}
\long\def\@makefntext#1{%
    \parindent .25in%
    \noindent
    \hbox to .25in{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{REFERENCES}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\keywordsname{Key words}
\newcommand\keywordname{Key word}
\newcommand\AMSname{AMS subject classifications}
\newcommand\AMname{AMS subject classification}
\newcommand\PIIname{PII}
\newcommand\DOIname{DOI}
%%%\newcommand\URL{\protect\\ \hspace*{15.37pt}http://www.siam.org/journals/}
\newcommand\URL[1]{\protect\\ \hspace*{15.37pt}\protect\href{http://www.siam.org/journals/#1}{http://www.siam.org/journals/#1}}
\newcommand\URLskip{\protect\\ \hspace*{15.37pt}}
\newcommand\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\newcommand\sameauthor{\leavevmode\vrule height 2pt depth -1.6pt width 23pt}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{plain}
\pagenumbering{arabic}      % Arabic page numbers

\if@compatibility%
\else
  \if@oneeqnum
  \else
     \@addtoreset{equation}{section}   %  \section resets 'equation' counter
     \renewcommand{\theequation}{\thesection.\arabic{equation}}
  \fi
%
  \if@onefignum
  \else
    \@addtoreset{figure}{section}
    \renewcommand{\thefigure}{\thesection.\@arabic\c@figure}
  \fi
%
  \if@onetabnum
  \else
    \@addtoreset{table}{section}
    \renewcommand{\thetable}{\thesection.\@arabic\c@table}
  \fi
%
  \if@onethmnum
  \else
    \@addtoreset{theorem}{section}
    \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
  \fi
\fi

\onecolumn

\gdef\@siamlabel@error#1#2{%
   \GenericError{%
      \space\space\space\@spaces\@spaces\@spaces
   }{%
      SIAM Label Error: #1%
   }{%
      Correct multiply-defined labels.%
   }{#2}%
}

%%% NEW -- causes multiply defined labels to generate errors
\def\@newl@bel#1#2#3{%
  \@ifundefined{#1@#2}%
    \relax
    {\gdef \@multiplelabels {%
      \@latex@warning@no@line{Label `#2' multiply defined}}%
      \@siamlabel@error{There were multiply-defined labels}{}}%
  \global\@namedef{#1@#2}{#3}}
\def\newlabel{\@newl@bel r}
\@onlypreamble\@newl@bel
\let \@multiplelabels \relax
\def\label#1{\@bsphack
  \protected@write\@auxout{}%
         {\string\newlabel{#1}{{\@currentlabel}{\thepage}}}%
  \@esphack}
\def\refstepcounter#1{\stepcounter{#1}%
    \protected@edef\@currentlabel
       {\csname p@#1\endcsname\csname the#1\endcsname}%
}

%\renewcommand\@eqnnum{\hb@xt@.01\p@{}%
%                      \rlap{\sf\color{header1}
%                        \hskip -\displaywidth(\theequation)}}

%%%\RequirePackage[LY1]{fontenc}
%%%\RequirePackage[LY1,expert,seriftt]{lucidabr}
%\font\HLtitle agd at 12pt
%\font\HLtitleital agdo at 12pt
%\font\HLtext agd at 10pt
%\font\HLtextital agdo at 10pt
%\font\HLsmall agd at 8pt
%\font\HLsmallital agdo at 8pt
%\font\HLlittle agd at 6pt
%\font\HLlittleital agdo at 6pt
%\font\HLlittlest agd at 4.5pt
%\font\HLlittlestital agdo at 4.5pt
\newcommand{\HLtitle}{\large\sf\bfseries}
\newcommand{\HLtitleital}{\sf\bfseries\itshape}
\newcommand{\HLtext}{\sf\bfseries}
\newcommand{\HLtextital}{\sf\bfseries\itshape}
\newcommand{\HLtextlf}{\sf}
\newcommand{\HLtextlfital}{\sf\itshape}
\newcommand{\HLsmall}{\footnotesize\sf\bfseries}
\newcommand{\HLsmallital}{\footnotesize\sf\bfseries\itshape}
\newcommand{\HLlittle}{\sevenptsize\sf}
\newcommand{\HLlittleital}{\sevenptsize\sf\itshape}
\newcommand{\HLlittlest}{\sixptsize\sf}
\newcommand{\HLlittlestital}{\sixptsize\sf\itshape}
\RequirePackage[dvips]{graphics,graphicx}
\RequirePackage[colorlinks,pdfmark,dvips]{hyperref}
\def\wwwbrowser{C:\string\Program\space
Files\string\Plus!\string\Microsoft\space
Internet\string\iexplore.exe}
\definecolor{extlink}{cmyk}{.05,1,1,.45}
\definecolor{intlink}{cmyk}{1,0,1,.5}
\definecolor{softpage}{cmyk}{0,0.01,.05,0}
\def\@linkcolor{intlink}
\def\@anchorcolor{black}
\def\@citecolor{intlink}
\def\@filecolor{cyan}
\def\@urlcolor{extlink}
\def\@menucolor{red}
%%%\def\@pagecolor{softpage}
\newcommand{\email}[1]{\protect\href{mailto:#1}{#1}}
\newcommand{\mref}[2]{\href{mailto:#1}{#2}}
\newcommand{\web}[1]{\href{#1}{#1}}
%%%\pagecolor{softpage}
\endinput
%%
%% End of file siamltexmm.cls.

