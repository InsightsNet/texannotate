%
% Classe per la composizione dei "Rendiconti del Seminario Matematico"
%
% (C) 1999 Giuseppe GhibÃ²
%
%\LoadClass[leqno,10pt,draft]{book} %FORMA ABBOZZATA
\LoadClass[leqno,10pt]{book} %FORMA DEFINITIVA


\RequirePackage[italian, french, english]{babel}
\RequirePackage[dvips]{graphicx}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage[symbol]{footmisc}
\RequirePackage{pslatex}
%  \usepackage[latin1]{inputenc}% to type characters ISO-8859-1 inline (such as à,è, ...)
\RequirePackage[utf8]{inputenc}% to type characters ISO-8859-1 inline (such as à,è, ...)
\RequirePackage[T1]{fontenc} % toglie il warning per il francese


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\ttdefault}{cmtt}

\vsize=19cm
\hsize=13cm
\parindent=1cm
\parskip=2pt
\topskip=20pt
\hbadness=10000
\hoffset=1.5cm
\voffset=2cm
\evensidemargin=0pt
\oddsidemargin=0pt

\abovedisplayskip=12pt plus 3pt minus 2pt
\abovedisplayshortskip=3pt plus 3pt
\belowdisplayskip=12pt plus 3pt minus 9pt
\belowdisplayshortskip=4pt plus 3pt minus 4pt

\newcommand{\CC}{{\mathbb C}}
\newcommand{\EE}{{\mathbb E}}
\newcommand{\FF}{{\mathbb F}}
\newcommand{\GG}{{\mathbb G}}
\newcommand{\HH}{{\mathbb H}}
\newcommand{\KK}{{\mathbb K}}
\newcommand{\LL}{{\mathbb L}}
\newcommand{\NN}{{\mathbb N}}
\newcommand{\PP}{{\mathbb P}}
\newcommand{\QQ}{{\mathbb Q}}
\newcommand{\RR}{{\mathbb R}}
\newcommand{\s}{{\mathbb S}}
\newcommand{\TT}{{\mathbb T}}
\newcommand{\YY}{{\mathbb Y}}
\newcommand{\ZZ}{{\mathbb Z}}

\long\def \@gobbleopt [#1]{}
\global\let\@volume\@empty
\global\let\volume\relax

\global\let\@volumeyear\@empty
\global\let\volumeyear\relax

\global\let\@yearnumber\@empty
\global\let\yearnumber\relax

\global\let\@volumenumber\@empty
\global\let\volumenumber\relax

\def\volume#1{\gdef\@volume{#1}}
\def\volumeyear#1{\gdef\@volumeyear{#1}}
\def\yearnumber#1{\gdef\@yearnumber{#1}}
\def\volumenumber#1{\gdef\@volumenumber{#1}}



%\let\section=\subsubsection

\newcommand\llarge{\@setfontsize\llarge\@xiipt{18}} 

\renewcommand\section{\@startsection{section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\bfseries}}
\renewcommand\thesection{\@arabic\c@section}
\renewcommand\theequation
%  {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@equation}
  {\@arabic\c@equation}

\def\and{\space--\space}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\bfseries}}

\newenvironment{abstract}{%
    \if@twocolumn
      \section*{\abstractname}%
    \else
\footnotesize % aggiunto da me per ridurre dimensione abstract	
%      \small
%      \begin{center}%
%       {\bfseries \abstractname\vspace{-.5em}\vspace{\z@}}%
%      \end{center}%
      \quotation
      {\noindent\bf\abstractname.}%
    \fi}
    {\if@twocolumn\else\endquotation\fi}


\newtheoremstyle{mytheorem}% name
  {10pt}%       Space above
  {10pt}%       Space below
  {\itshape}%   Body font
  {\parindent}%           Indent amount (empty = no indent, \parindent = para indent)
  {\scshape}%   Theorem head font
  {.}%          Punctuation after Theorem head
  {.5em}%       Space after Theorem head: " " = normal interword space;
        %       \newline = linebreak
  {}%           Theorem head spec (can be left empty, meaning `normal')
%

\newtheoremstyle{myexample}
  {10pt}%       Space above
  {10pt}%       Space below
  {\rmfamily}%  Body font
  {\parindent}%           Indent amount (empty = no indent, \parindent = para indent)
  {\scshape}%   Theorem head font
  {.}%          Punctuation after Theorem head
  {.5em}%       Space after Theorem head: " " = normal interword space;
        %       \newline = linebreak
  {}%           Theorem head spec (can be left empty, meaning `normal')
%

\theoremstyle{mytheorem}

\newcounter{article}
\setcounter{article}{1}

\newtheorem{theorem}{Theorem}%[chapter]
\newtheorem{teorema}{Teorema}%[chapter]
\newtheorem{theoreme}{Th\'eor\`eme}%[chapter]

\newtheorem{lemma}{Lemma}%[chapter]
\newtheorem{lemme}{Lemme}%[chapter]

\newtheorem{proposition}{Proposition}%[chapter]
\newtheorem{proposizione}{Proposizione}%[chapter]

\newtheorem{corollary}{Corollary}%[chapter]
\newtheorem{corollario}{Corollario}%[chapter]
\newtheorem{corollaire}{Corollaire}%[chapter]

\newtheorem{definition}{Definition}%[chapter]
\newtheorem{definizione}{Definizione}%[chapter]
\newtheorem{frdefinition}{D\'efinition}%[chapter]

\newtheorem{problem}{Problem}%[chapter]
\newtheorem{problema}{Problema}%[chapter]
\newtheorem{probleme}{Probl\`eme}%[chapter]
%
\theoremstyle{myexample}
\newtheorem{example}{Example}%[chapter]
\newtheorem{esempio}{Esempio}%[chapter]
\newtheorem{exemple}{Exemple}%[chapter]

\newtheorem{examples}{Examples}%[chapter]
\newtheorem{exemples}{Exemples}%[chapter]

\newtheorem{remark}{Remark}%[chapter]
\newtheorem{osservazione}{Osservazione}%[chapter]
\newtheorem{remarque}{Remarque}%[chapter]
\newtheorem{remarks}{Remarks}%[chapter]
\newtheorem{osservazioni}{Osservazioni}%[chapter]
\newtheorem{remarques}{Remarques}%[chapter]

\newtheorem{rmk}{Remark}%[chapter]

\renewcommand{\thefigure}{\arabic{figure}}


%\newtheorem{theorem}{Theorem}[article]
%\newtheorem{teorema}{Teorema}[article]
%\newtheorem{lemma}{Lemma}[article]
%\newtheorem{proposition}{Proposition}[article]
%\newtheorem{proposizione}{Proposizione}[article]
%\newtheorem{corollary}{Corollary}[article]
%\newtheorem{corollario}{Corollario}[article]
%
%\theoremstyle{myexample}
%\newtheorem{example}{Example}[article]
%\newtheorem{esempio}{Esempio}[article]
%\newtheorem{remark}{Remark}[article]
%\newtheorem{osservazione}{Osservazione}[article]

\newenvironment{demonstration}{\textit{D\'emonstration. }}{\begin{flushright}
       																										    $ \Box $
       																										  \end{flushright}
       												                            }


\renewenvironment{thebibliography}[1]
{\section*{\refname
%   \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}
}%
 \list{\@biblabel{\@arabic\c@enumiv}}%
      {\settowidth\labelwidth{\@biblabel{#1}}%
       \leftmargin\labelwidth
       \advance\leftmargin\labelsep
       \@openbib@code
       \usecounter{enumiv}%
       \let\p@enumiv\@empty
       \renewcommand\theenumiv{\@arabic\c@enumiv}}%
 \sloppy
 \clubpenalty4000
 \@clubpenalty \clubpenalty
 \widowpenalty4000%
 \sfcode`\.\@m}
{\def\@noitemerr
  {\@latex@warning{Empty `thebibliography' environment}}%
 \endlist}

%
\def\@seccntformat#1{\csname the#1\endcsname. \ }

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
% niente sectionmark
%    \csname #1mark\endcsname{#7}%
%
% niente sezioni nella toc
%    \addcontentsline{toc}{#1}{%
%      \ifnum #2>\c@secnumdepth \else
%        \protect\numberline{\csname the#1\endcsname}%
%      \fi
%      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
%
% niente sectionmark
%      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

% Stili
\def\ps@empty{%
  \let\@mkboth\@gobbletwo\let\@oddhead\@empty\let\@oddfoot\@empty
  \let\@evenhead\@empty\let\@evenfoot\@empty}

\def\ps@plain{\let\@mkboth\@gobbletwo
     \let\@oddhead\@empty\def\@oddfoot{\reset@font\hfil\thepage\hfil}\let\@evenhead\@empty\let\@evenfoot\@oddfoot}

\def\ps@firstchp{\let\@mkboth\@gobbletwo
     \let\@oddhead\@empty\def\@oddfoot{\reset@font\hfil\thepage\hfil}
     \let\@evenhead\@empty\let\@evenfoot\@oddfoot
     \def\@oddhead{\parbox[t]{8cm}{\footnotesize Rend.~Sem.~Mat.~Univ.~Pol.~Torino\\Vol.~\@volumenumber,~\@yearnumber\ (\@volumeyear),~\thepage\ -- \pageref{\thechapter:lastpage}\par}}}

\def\ps@headings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{{\normalfont\thepage}\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil{\normalfont\thepage}}%
    \let\@mkboth\markboth
%
% questo va su evenhead
  \def\chaptermark##1{%
     \markboth {\small{%
%    \markboth {CHAPMARK{%
%      \ifnum \c@secnumdepth >\m@ne
%       \if@mainmatter
%         \@chapapp\ \thechapter. \ %
%       \fi
%      \fi
      ##1}}{}}%
%
% questo va su oddhead
  \def\sectionmark##1{%
      \markright {\small{%
%     \markright {SECMARK\MakeLowercase{%
%       \ifnum \c@secnumdepth >\z@
%        \thesection. \ %
%       \fi
      ##1}}}}

\renewcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{firstchp}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
%
% #3 = autore
\def\@chapter[#1]#2#3{%
                    \let\temp=\\ % i titoli nomi dei capitoli possono contenere
                                 % \\, per questo viene tempor. disabilitato.
                    \let\\=\@empty
                    \let\tempand=\and
                    \def\and{,\space}
                    \let\tempmark=\footnotemark
                    \let\footnotemark=\@gobbleopt

                    \ifnum \c@secnumdepth >\m@ne
                       \if@mainmatter
                         \refstepcounter{chapter}%
                         \typeout{Articolo \thechapter: #3.}%
                         \addcontentsline{toc}{chapter}%
                                   {#3, \textit{#2}}%
                       \else
                         \addcontentsline{toc}{chapter}{#2}%
                       \fi
                    \else
                      \addcontentsline{toc}{chapter}{#2}%
                    \fi

                    \def\and{~--~}
                    \chaptermark{#3}%
                    \sectionmark{#1}%

                    \let\\=\temp
                    \let\and=\tempand
                    \let\footnotemark=\tempmark

%                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
%                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}{#3}%
                      \@afterheading
                    \fi
}
\def\@makechapterhead#1#2{%
%  \hrule
  \vspace*{0\p@}%
  {\parindent \z@ \raggedright \normalfont
   \def\and{\space--\space}\centering\large\bf{#2}\\
   \vspace*{10\p@}
%    \ifnum \c@secnumdepth >\m@ne
%      \if@mainmatter
%        \huge \bfseries \@chapapp\space \thechapter
%        \par\nobreak
%        \vskip 10\p@
%      \fi
%    \fi
    \interlinepenalty\@M
    \centering
    \llarge \bfseries \uppercase{#1}\par\nobreak
    \vskip 20\p@
%  \hrule
  }}
\def\@schapter#1{\if@twocolumn
                   \@topnewpage[\@makeschapterhead{#1}]%
                 \else
                   \@makeschapterhead{#1}%
                   \@afterheading
                 \fi}
\def\@makeschapterhead#1{%
  \vspace*{0\p@}%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \Large\bfseries  #1\par\nobreak
    \vskip 10\p@
  }}


\pagestyle{headings}

\def\ps@mytoc{%
  \let\@mkboth\@gobbletwo\let\@oddhead\@empty\let\@oddfoot\@empty
  \let\@evenhead\@empty\let\@evenfoot\@empty
%  \def\@oddfoot{\reset@font\hfil\thepage\hfil}
\def\@oddfoot{\reset@font\large\bf Volume~\@volumenumber, N.~\@yearnumber\hfil\@volumeyear}
}


\renewcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
%    \chapter*{\contentsname
%        \@mkboth{%
%           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \thispagestyle{mytoc}
    \begin{flushleft}
    \Huge\textsc{Rendiconti\\ del Seminario\\ Matematico}\par
    \rule[5pt]{\textwidth}{2pt}
    \Large\textit{Universit\`a e Politecnico di Torino}
    \end{flushleft}

%da aggiungere nei numeri speciali
%    \vskip 2cm
%    \centerline{\textbf{\large{Geometry, Continua and Microstuctures, II}}}
% fine numeri speciali

    \vskip 2cm
    \centerline{\large CONTENTS}
    \bigskip
    \@mystarttoc{toc}%
    \if@restonecol\twocolumn\fi
    }

% TOC per l'ultima di copertina
\def\@mystarttoc#1{%
  \begingroup
    \makeatletter
    \@input{\jobname.#1}%
%    \if@filesw
%      \expandafter\newwrite\csname tf@#1\endcsname
%      \immediate\openout \csname tf@#1\endcsname #1.#2\relax
%    \fi
    \global\@nobreakfalse
  \endgroup}

% Quarta di copertina
\newcommand\coverfour{
%
\thispagestyle{empty}
\begin{center}
\large\bf Rendiconti del Seminario Matematico\\
dell'Universit\`a e del Politecnico di Torino\\
\end{center}
\hrule
\vskip 1cm
\centerline{Volume~\@volumenumber, N.~\@yearnumber~(\@volumeyear)}


\vskip 1,5cm % se cï¿½ progetto lagrange - decommentare sotto


\vskip 1,5cm


\centerline{\large CONTENTS}
\bigskip
%
\@starttoc{toc}
\vfill
\hrule
\noindent
\parbox[t]{3cm}{\textsf{ISSN 0373-1243}}
\parbox[t]{1,5cm}{\includegraphics{./logouni/uni15epsf.eps}}
\parbox[b]{7,5cm}{\textsf{\large{UNIVERSIT\`A DEGLI STUDI DI TORINO\\ DIPARTIMENTO DI MATEMATICA}}}

%\begin{tabular}[t]{|p{4.0cm}|c|p{8.0cm}|}
%\textsf{ISSN 0373-1243} & \includegraphics{dm.eps}& \parbox{6cm}{\textsf{UNIVERSIT\`A DEGLI STUDI DI TORINO\\ DIPARTIMENTO DI MATEMATICA}}
%\end{tabular}


\eject
}

\let\articolo=\chapter
%
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
\renewcommand*\l@chapter{\@dottedtocline{1}{0pt}{2.3em}}