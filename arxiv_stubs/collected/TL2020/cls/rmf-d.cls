%%
%% This is file `article.cls',
%% generated with the docstrip utility.
%% 
%% The original source files were:
%% 
%% classes.dtx  (with options: `article')
%% 
%% 
%% This is a generated file. 
%% 
%% Copyright 1993 1994 1995 1996 
%% The LaTeX3 Project and any individual authors listed elsewhere 
%% in this file. 
%% 
%% For further copyright information, and conditions for modification 
%% and distribution, see the file legal.txt, and any other copyright 
%% notices in this file. 
%% 
%% This file is part of the LaTeX2e system. 
%% ---------------------------------------- 
%% This system is distributed in the hope that it will be useful, 
%% but WITHOUT ANY WARRANTY; without even the implied warranty of 
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
%% 
%% For error reports concerning UNCHANGED versions of this file no 
%% more than one year old, see bugs.txt. 
%% 
%% Please do not request updates from us directly. Primary 
%% distribution is through the CTAN archives. 
%% 
%% 
%% IMPORTANT COPYRIGHT NOTICE: 
%% 
%% You are NOT ALLOWED to distribute this file alone. 
%% 
%% You are allowed to distribute this file under the condition that it 
%% is distributed together with all the files listed in manifest.txt. 
%% 
%% If you receive only some of these files from someone, complain! 
%% 
%% 
%% Permission is granted to copy this file to another file with a 
%% clearly different name and to customize the declarations in that 
%% copy to serve the needs of your installation, provided that you 
%% comply with the conditions in the file legal.txt. 
%% 
%% However, NO PERMISSION is granted to generate or to distribute a 
%% modified version of this file under its original name. 
%% 
%% You are NOT ALLOWED to change this file. 
%% 
%% 
%% MODIFICATION ADVICE: 
%% 
%% If you want to customize this file, it is best to make a copy of 
%% the source file(s) from which it was produced. Use a different 
%% name for your copy(ies) and modify the copy(ies); this will ensure 
%% that your modifications do not get overwritten when you install a 
%% new release of the standard system. You should also ensure that 
%% your modified source file does not generate any modified file with 
%% the same name as a standard file. 
%% 
%% You can then easily distribute your modifications by distributing 
%% the modified and renamed copy of the source file, taking care to 
%% observe the conditions in legal.txt; this will ensure that other 
%% users can safely use your modifications. 
%% 
%% You will also need to produce your own, suitably named, .ins file to 
%% control the generation of files from your source file; this file 
%% should contain your own preambles for the files it generates, not 
%% those in the standard .ins files. 
%% 
%% The names of the source files used are shown above. 
%% 
%% 
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
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{rmf-d}
              [1996/05/26 v1.3r
 Standard LaTeX document class]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
\if@compatibility\else
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
\fi
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\DeclareOption{titlepage}{\@titlepagetrue}
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep=\z@
      }%
   \renewcommand\newblock{\par}}%
}
\ExecuteOptions{letterpaper,10pt,twoside,onecolumn,final,leqno}
\ProcessOptions
\input{size1\@ptsize.clo}
\setlength\lineskip{0\p@}
\setlength\normallineskip{0\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{5}
\renewcommand\topfraction{1}
\setcounter{bottomnumber}{5}
\renewcommand\bottomfraction{1}
\setcounter{totalnumber}{10}
\renewcommand\textfraction{0}
\renewcommand\floatpagefraction{1}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{1}
\renewcommand\dblfloatpagefraction{1}
%
% RMF layout
%
\textwidth =42pc
\textheight=56\baselineskip
\setlength\columnsep{18\p@}
\setlength\columnseprule{0\p@}
\oddsidemargin =-0.1in
\evensidemargin=-0.4in
\topmargin=0pt
\voffset=-0.5in
\headsep= 1pc
\floatsep=20pt
\topsep=3pt
%
\abovedisplayskip=6pt plus 3pt minus 1pt
\belowdisplayskip=6pt plus 3pt minus 1pt
\abovedisplayshortskip=0pt plus 3pt
\belowdisplayshortskip=4pt plus 3pt
\jot=7pt
%
% Remates de columna
%
\def\rd1{\vskip0\baselineskip\vbox{\hrule width 19pc height0.5pt%
\hbox{\vrule height5pt width0.5pt depth2pt}}}
%
\def\ru{\vskip0\baselineskip%
\hfill\hbox{\vrule width19pc height0.5pt depth0pt%
\vbox{\hrule width0.5pt height8pt depth0pt}}\par}
%
\def\rd{\vskip0\baselineskip\vbox{\hrule depth8pt height0.5pt width0.5pt}%
\vspace*{-12pt}\hbox{\vrule width 19pc  height0.5pt depth0pt}}%
%\vbox{\hrule depth8pt height0.5pt width0.5pt   }

%
%\if@twoside
%  \def\ps@headings{%
%      \let\@oddfoot\@empty\let\@evenfoot\@empty
%      \def\@evenhead{\thepage\hfil\slshape\hfil\leftmark}%
%      \def\@oddhead{\hfil{\slshape\rightmark}\hfil\thepage}%
%      \let\@mkboth\markboth
%    \def\sectionmark##1{%
%      \markboth {\MakeUppercase{%
%        \ifnum \c@secnumdepth >\z@
%          \thesection\quad
%        \fi
%        ##1}}{}}%
%    \def\subsectionmark##1{%
%      \markright {%
%        \ifnum \c@secnumdepth >\@ne
%          \thesubsection\quad
%        \fi
%        ##1}}}
%\else
%  \def\ps@headings{%
%    \let\@oddfoot\@empty
%    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
%    \let\@mkboth\markboth
%    \def\sectionmark##1{%
%      \markright {\MakeUppercase{%
%        \ifnum \c@secnumdepth >\m@ne
%          \thesection\quad
%        \fi
%        ##1}}}}
%\fi
%
% RMF modification: Temporal
%
%added \rmfcintilla 17.12.97
\def\ps@myheadings{%
    \def\@oddfoot{\hfil\centerline{\small\rmfcintilla}\hfil}
     \def\@evenfoot{\hfil\centerline{\small\rmfcintilla}\hfil}
    \def\@evenhead{{\bf\thepage}\hfil\footnotesize\MakeUppercase\leftmark\hfil}%
    \def\@oddhead{\hfil{\footnotesize\MakeUppercase\rightmark}\hfil
{\bf\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble}
%  \if@titlepage
%  \newcommand\maketitle{\begin{titlepage}%
%  \let\footnotesize\small
%  \let\footnoterule\relax
%  \let\footnote\thanks
%  \null\vfil
%  \vskip 60\p@
%  \begin{center}%
%    {\LARGE\bf \@title \par}%
%    \vskip 3em%
%    {\sc
%     \lineskip .75em%
%      \begin{tabular}[t]{c}%
%        \@author
%      \end{tabular}\par}%
%      \vskip 1.5em%
%    {\large \@date \par}%       % Set date in \large size.
%  \end{center}\par
%  \@thanks
%  \vfil\null
%  \end{titlepage}%
%  \setcounter{footnote}{0}%
%  \global\let\thanks\relax
%  \global\let\maketitle\relax
%  \global\let\@thanks\@empty
%  \global\let\@author\@empty
%  \global\let\@date\@empty
%  \global\let\@title\@empty
%  \global\let\title\relax
%  \global\let\author\relax
%  \global\let\date\relax
%  \global\let\and\relax
%}
%\else
%% Modificado el footnote del thanks 17.12.97.
\def\boxit#1{\hskip-10pt\vbox{\hbox{\vbox{#1}}}} 
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em%\noindent
        \setbox4=\vbox{\hsize 20pc \noindent \strut
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1 \strut}%
\boxit{\boxit{\box4}}}
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  %\setcounter{footnotein}{0}%% For footnotein enviroment
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
}
%
% RMF modification: Definition of PACS and recibido
% and keybords and descriptores, added 17.12.97.
%
\def\pacs#1{\vskip1\baselineskip\par{\raggedright{\small PACS: #1}}%
            \vskip1.5\baselineskip\ignorespaces}
\def\keys#1{\vskip0.5\baselineskip\par{\raggedright{\small{\it Keywords:} #1}}%
            \vskip0.5\baselineskip\ignorespaces}
\def\descript#1{\vskip0.5\baselineskip\par{\raggedright{
\small{\it Descriptores:} #1}}%
            \vskip0\baselineskip\ignorespaces}
\def\recibido#1#2{\par%
\centerline{\small Received\ #1;\ accepted\ #2}\par%
\vskip1.25\baselineskip\ignorespaces}
\def\rmf{Revista Mexicana de F\'{\i}sica}
\def\smf{Sociedad Mexicana de F\'{\i}sica}
%
% Figure boxes (in cm)
%
\def\sqrcm#1#2{{{\vbox{\hrule height0.3pt
    \hbox{\vrule width0.3pt height#2truecm\kern#1truecm
     \vrule width0.3pt}\hrule height0.3pt}}}}
%%%%%
%
% Miscellaneous math symbols
%
\def\sen{\mathop{\rm sen}\nolimits}
\def\tr{\mathop{\rm Tr}\nolimits}
\def\arcsinh{\mathop{\rm arcsinh}\nolimits}
\def\lilahh#1{\setbox4=\vbox{\hsize 42pc\noindent\strut
\small #1 \strut}
\boxit{\boxit{\box4}}}
\def\lilaht#1{\hskip-12pt\setbox4=\vbox{\hsize 19.5pc \noindent%\strut
\small\begin{center} #1 \end{center}}%\strut}
\boxit{\boxit{\box4}}}
\def\lilahf#1{\hskip-12pt\setbox4=\vbox{\hsize 20pc \noindent\strut
\small #1 \strut}
\boxit{\boxit{\box4}}} % para las llamadas al final del paper,
%%               se usa con el entorno 'description' y tambien para formar la
%%               caja del caption de figuras y tablas en 2 columnas
\def\lilahrge#1{\hskip-12pt\setbox4=\vbox{\hsize 42pc  \noindent\strut
\small #1 \strut}
\boxit{\boxit{\box4}}}           %para formar la
\def\lilahrgec#1{\hskip-12pt\setbox4=\vbox{\hsize 42pc  \noindent%\strut
\small \begin{center} #1 \end{center}}%\strut}
\boxit{\boxit{\box4}}}           %para formar la
%%               caja del caption de figuras y tablas  a 1 columna
%
% RMF modification
%
\def\@authoraddress{}  
\def\@title{}
\def\and{\par\vspace*{5pt}} 
\def\title#1{\gdef\@title{{\centering\ignorespaces#1\vskip\baselineskip\par}}}
\def\author#1{\expandafter\def\expandafter\@authoraddress\expandafter
             {\@authoraddress{\lineskip0pt\normalsize\centering\ignorespaces#1\par}}}
\def\address#1{\expandafter\def\expandafter\@authoraddress\expandafter
{\@authoraddress{\itshape\normalsize\centering\ignorespaces#1\vskip0.5\baselineskip\par}}}
%
\def\@maketitle{%
  \newpage
  \vspace*{-3.0pc}
   \centerline{\rmfcornisa}\par
  \let\footnote\thanks
  {\vspace*{1pc}\renewcommand{\baselinestretch}{0.9}\Large\bfseries\@title \par}%
  \@authoraddress}
%\fi
\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {subsubsubsection}[subsubsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thepart       {\@Roman\c@part}
\renewcommand\thesection    {\@arabic\c@section{.}}
\renewcommand\thesubsection {\thesection\@arabic\c@subsection{.}}
\renewcommand\thesubsubsection{\thesubsection\@arabic\c@subsubsection{.}}
\renewcommand\thesubsubsubsection{\thesubsubsection\@arabic\c@subsubsubsection{.}}
\renewcommand\theparagraph    {\thesubsubsection\@arabic\c@paragraph{.}}
\renewcommand\thesubparagraph {\theparagraph\@arabic\c@subparagraph{.}}
\newcommand\part{\par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >\m@ne
       \Large\bfseries \partname~\thepart
       \par\nobreak
     \fi
     \huge \bfseries #2%
     \markboth{}{}\par}%
    \nobreak
    \vskip 3ex
    \@afterheading}
\def\@spart#1{%
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \huge \bfseries #1\par}%
     \nobreak
     \vskip 3ex
     \@afterheading}
%
% RMF modification
%
\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.0ex \@plus.2ex}%
                                   {\normalfont\large\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-2.5ex\@plus -1ex \@minus -.2ex}%
                                     {2.0ex \@plus .2ex}%
                              {\normalfont\normalsize\bfseries}}
%small\MakeUppercase\bfseries}}
%
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-2.5ex\@plus -1ex \@minus -.2ex}%
                                     {2.0ex \@plus .2ex}%
                                     {\normalfont\normalsize\itshape}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
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
\newcommand\labelitemi{$\m@th\bullet$}
\newcommand\labelitemii{\normalfont\bfseries --}
\newcommand\labelitemiii{$\m@th\ast$}
\newcommand\labelitemiv{$\m@th\cdot$}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep{\hskip-0pt $\m@th #1$}}
%                                \normalfont\bfseries #1}
\if@titlepage
%  \newenvironment{abstract}{%
%      \titlepage
%      \null\vfil
%      \@beginparpenalty\@lowpenalty
%      \begin{center}%
%        \bfseries \abstractname
%        \@endparpenalty\@M
%      \end{center}}%
%     {\par\vfil\null\endtitlepage}
\else
  \newenvironment{abstract}{%
%      \if@twocolumn
%        \section*{\abstractname}%
%      \else
        \small\vskip0.5\baselineskip\columnwidth42pc\hsize\columnwidth%
        \parindent0pt\vspace{\z@}}
%      \fi}
%      {\if@twocolumn\else\endquotation\fi}
\fi
%
% RMF
%
\newenvironment{resumen}{%
\small\vskip0.5\baselineskip\columnwidth42pc\hsize\columnwidth%
\parindent0pt\vspace{\z@}}

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
\if@compatibility
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
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
\fi
%
% RMF modification for the use of captions
%
\newcommand*\rmfcaptionstyle{%
  \captionstyle{indent}%
  \renewcommand\captionfont{\small}%
  \renewcommand\captionlabelfont{\scshape}%
  \setcaptionmargin{0pt}%
  \setlength\captionindent{0pt}%
  \renewcommand\captionlabeldelim{.}%
  \onelinecaptionstrue}
%
% RMF modification for the use of serial captions
\newcommand*\srmfcaptionstyle{%
  \captionstyle{indent}%
  \renewcommand\captionfont{\small}%
  \renewcommand\captionlabelfont{\scshape}%
  \setcaptionmargin{0pt}%
  \setlength\captionindent{0pt}%
  \renewcommand\captionlabeldelim{}%
  \onelinecaptionstrue}
%

\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins 
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand\theequation{\@arabic\c@equation}
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
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
\renewcommand\thetable{\@Roman\c@table}
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
\setlength\abovecaptionskip{5\p@}
\setlength\belowcaptionskip{0\p@}
%
\def\tableline{\hrule width20.3pc }    %\textwidth}
\def\tablelinea{\hskip5pc\vrule width 8.5truecm height 1pt depth-0.5pt}
\def\tabletopline{\hskip 0pc\tableline\vspace*{1.5pt}\tableline}
\def\longtableline{\hrule width\textwidth}
\def\longtabletopline{\longtableline\vspace*{1.5pt}\longtableline}
\def\medline{\vskip13pt\centerline{\vrule width 10truecm height 1pt depth-0.5pt}}
\def\fl{\medline\vspace*{-23.5pt}\medline}
\def\smalline{\vskip13pt\centerline{\vrule width 5truecm height 1pt depth-0.5pt}}
%
\def\footnota#1{\hrule width 14pc 
\setbox4=\vbox{\hsize 20pc \noindent \strut \small\quad #1 \strut}
\boxit{\boxit{\box4}}}
\def\footnotas#1{  \small #1 }
\long\def\@makecaption#1#2{%
  \tabletopline
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
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
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    }
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \setlength\@tempdima{3em}%
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}
\newcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
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
%
% RMF modification
%
%
\setlength\itemsep{-4pt}
%
\setlength\bibindent{1.5em}

\newenvironment{thebibliography}[1] 
    {%\section*%\refname
        %\@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}%
     \small
     \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m}
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
  \kern-1\p@
  \hrule\@width0.36\columnwidth
  \kern2.6\p@}
% \hb@xt@1.8em{\hss\@makefnmark}#1}  es la linea original
\newcommand\@makefntext[1]{
    \parindent 1em%
\setbox4=\vbox{\hsize 20pc \noindent \strut
\hb@xt@1.8em{\hss\@makefnmark} #1 \strut}
\boxit{\boxit{\box4}}}
% las anteriores 6 lineas introduje en     17.12.97.
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\today{}
\edef\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
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
\endinput
%% 
%% End of file `article.cls'.
