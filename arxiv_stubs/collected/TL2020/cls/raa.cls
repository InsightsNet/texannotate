% This is raa.cls
% LaTeX document class for Research in Astronomy and Astrophysics 
%                      -- version 1.0 for LaTeX2e (2008.09.22 zay)
%                         Since 2001.08.28 Zhou Ai-Ying
%
% Changes made in Ver.1.1: 
% (1) double spaced text for referee version 
% (2) referee version has a full textwidth as publication layout
% 
% Unsolved works: 
% (1) Q: example for placing text around a figure/table(?)
% (2) Q: first paragraph should also be indented ? 
%     A: using \hspace{15pt} at the moment.
% (3) Q: change footnote's counter to symbols 
% (4) Q: revise \thanks, \email, \mailto commands
%%
%%%%% change floatsep 20060701
%  \setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
%   \setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
%   \setlength\textfloatsep{12\p@ \@plus 4\p@ \@minus 6\p@}
%   \setlength\intextsep   {12\p@ \@plus 3\p@ \@minus 3\p@}
%   \setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
%   \setlength\dbltextfloatsep{12\p@ \@plus 4\p@ \@minus 4\p@}
  

%%%% 
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
\ProvidesClass{raa}[ 2008/09/22 v1.2 (Zhou Ai-Ying); 
^^J\space\space\space\space\space\space\space\space\space\space\space\space
\space\space\space\space\space\space\space\space\space2003/05/12 v1.1e (Zhou Ai-Ying).
^^J\space\space\space\space\space\space\space\space\space\space\space\space
\space\space\space\space\space\space\space\space\space2003/04/19  v1.1 (Zhou Ai-Ying).
^^JLaTeX document class for Research in Astronomy and Astrophysics ]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
 \DeclareOption{a4paper}
   {\setlength\paperheight {260mm}    %%  {\setlength\paperheight {297mm}
    \setlength\paperwidth  {185mm}}   %%  \setlength\paperwidth  {210mm}}  
 \DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
%% ll \DeclareOption{twocolumn}{\@twocolumntrue}
%% jj \DeclareOption{leqno}{\input{leqno.clo}}
%\DeclareOption{fleqn}{\input{fleqn.clo}}       %AA
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
%
\let\if@runhead\iffalse
\DeclareOption{runningheads}{\let\if@runhead\iftrue}
\let\if@envcntreset\iffalse
\DeclareOption{envcountreset}{\let\if@envcntreset\iftrue}
\let\if@envcntsect\iffalse
\DeclareOption{envcountsect}{\let\if@envcntsect\iftrue}
\let\if@referee\iffalse
\DeclareOption{referee}{\let\if@referee\iftrue}
\let\if@nyobjects\iffalse
%
%\ExecuteOptions{a4paper,twoside,twocolumn,fleqn,final,10pt,runningheads}   %AA
\ExecuteOptions{%%a4paper,
twoside,                final,10pt,runningheads} %%% 10pt zjz 0601
\ProcessOptions
%\AtEndOfClass{\mathindent\z@\let\abstract=\RAAabstract}
\AtEndOfClass{               \let\abstract=\RAAabstract}
%
\if\@ptsize 0
%
   \renewcommand\normalsize{%
      \@setfontsize\normalsize\@xpt{10}% %%% \@xpt{12} %% zjz0601
      \abovedisplayskip 8.55\p@ \@plus4\p@ \@minus5\p@
      \abovedisplayshortskip \z@ \@plus3\p@
      \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
      \belowdisplayskip \abovedisplayskip
      \let\@listi\@listI}
   \normalsize
   \newcommand\small{%
      \@setfontsize\small\@ixpt{8}%  %%% zjz0601
      \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
      \abovedisplayshortskip \z@ \@plus2\p@
      \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
      \def\@listi{\leftmargin\leftmargini
                  \parsep 0\p@ \@plus1\p@ \@minus\p@
                  \topsep 8\p@ \@plus2\p@ \@minus4\p@
                  \itemsep0\p@}%
      \belowdisplayskip \abovedisplayskip
   }
   \newcommand\footnotesize{\@setfontsize\footnotesize\@viiipt{8}}    %%2006.09.07  added
   \newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
   \newcommand\tiny{\@setfontsize\tiny\@vipt\@viipt} 
   \newcommand\large{\@setfontsize\large\@xipt{13}}
   \newcommand\Large{\@setfontsize\Large\@xivpt{16}}
   \newcommand\LARGE{\@setfontsize\LARGE\@xviipt{20}}
   \newcommand\huge{\@setfontsize\huge\@xxpt{24}}
   \newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
   %
   \setlength\parindent{15\p@}
   \setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
   \setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
   \setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}
   \setlength\headheight{12\p@}
   \setlength\headsep   {12\p@} % 
   \setlength\topskip   {10\p@}
   \setlength\footskip{30\p@}
   \setlength\maxdepth{.5\topskip}
   %
   \@settopoint\textwidth
   %% jj \setlength\marginparsep {10\p@}
   %% jj \setlength\marginparpush{5\p@}
   %%j\setlength\oddsidemargin   {-30\p@}
   %%j\setlength\evensidemargin  {-30\p@}
   %%j\setlength\marginparwidth  {48\p@}
   \setlength\topmargin{-10pt}
   \setlength\footnotesep{8\p@}
   \setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
   \setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
   %% \setlength\textfloatsep{18\p@ \@plus 8\p@ \@minus 6\p@}
   \setlength\textfloatsep{12\p@ \@plus 4\p@ \@minus 6\p@}
   %%\setlength\intextsep   {18\p@ \@plus 2\p@ \@minus 2\p@}
   \setlength\intextsep   {12\p@ \@plus 3\p@ \@minus 3\p@}
   \setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
   %\setlength\dbltextfloatsep{18\p@ \@plus 8\p@ \@minus 6\p@}
   \setlength\dbltextfloatsep{12\p@ \@plus 4\p@ \@minus 4\p@}
   \setlength\@fptop{0\p@ }
   \setlength\@fpsep{10\p@ } %%  \setlength\@fpsep{12\p@ } %% zjz0601
   \setlength\@fpbot{0\p@ \@plus 1fil}
   \setlength\@dblfptop{0\p@ }
   \setlength\@dblfpsep{12\p@ }
   \setlength\@dblfpbot{0\p@ \@plus 1fil}
   \setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
   \def\@listi{\leftmargin\leftmargini
               \parsep \z@
               \topsep 8\p@ \@plus2\p@ \@minus4\p@
               \itemsep\parsep}
   \let\@listI\@listi
   \@listi
   \def\@listii {\leftmargin\leftmarginii
                 \labelwidth\leftmarginii
                 \advance\labelwidth-\labelsep
                 \topsep    \z@
                 \parsep    \topsep
                 \itemsep   \parsep}
   \def\@listiii{\leftmargin\leftmarginiii
                 \labelwidth\leftmarginiii
                 \advance\labelwidth-\labelsep
                 \topsep    \z@
                 \parsep    \topsep
                 \itemsep   \parsep}
   \def\@listiv {\leftmargin\leftmarginiv
                 \labelwidth\leftmarginiv
                 \advance\labelwidth-\labelsep}
   \def\@listv  {\leftmargin\leftmarginv
                 \labelwidth\leftmarginv
                 \advance\labelwidth-\labelsep}
   \def\@listvi {\leftmargin\leftmarginvi
                 \labelwidth\leftmarginvi
                 \advance\labelwidth-\labelsep}
\else
   \input{size1\@ptsize.clo}
\fi
%
%\let\footnotesize\small        %%commented  2006.09.07
%
%===================== paper size ===============
\if@referee
  \setlength{\textwidth}{200mm}       %AA:180mm; zay:use (200,250) 2008.09.24
  \setlength{\textheight}{250mm}      %AA:694pt, 1mm=0.04in=2.845pt 
\else                                 %preprint, final version
  \setlength{\textwidth}{145mm}       %RAA 
  \setlength{\textheight}{210mm}      %% 
  \topmargin=0pt
  \oddsidemargin=0pt
  \evensidemargin=0pt
  \parindent=6mm
  \arraycolsep 1mm  
\fi
%===================== paper size ===============  
%
%\setlength{\voffset}{-1.2cm}
%
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\renewcommand{\baselinestretch}{1.15}     % 2008.09.24 moved here from *.tex
\headsep=6mm                              % 2008.09.24 moved here from *.tex
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
%
\setcounter{topnumber}{4}
\renewcommand\topfraction{.9}
\setcounter{bottomnumber}{2}
\renewcommand\bottomfraction{.5}
\setcounter{totalnumber}{6}
\renewcommand\textfraction{.05}
\renewcommand\floatpagefraction{.95}
\setcounter{dbltopnumber}{3}
\renewcommand\dbltopfraction{.9}
\renewcommand\dblfloatpagefraction{.95}
%
\def\ps@headings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\small\rlap{\thepage}\hfil\leftmark\hfil}%
    \def\@oddhead {\small\hfil\rightmark\hfil\llap{\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }
% make indentations changeable
\def\setitemindent#1{\settowidth{\labelwidth}{#1}%
        \leftmargini\labelwidth
        \advance\leftmargini\labelsep
   \def\@listi{\leftmargin\leftmargini
        \labelwidth\leftmargini\advance\labelwidth by -\labelsep
        \parsep=\parskip
        \topsep=\medskipamount
        \itemsep=\parskip \advance\itemsep by -\parsep}}
\def\setitemitemindent#1{\settowidth{\labelwidth}{#1}%
        \leftmarginii\labelwidth
        \advance\leftmarginii\labelsep
\def\@listii{\leftmargin\leftmarginii
        \labelwidth\leftmarginii\advance\labelwidth by -\labelsep
        \parsep=\parskip
        \topsep=\z@
        \itemsep=\parskip \advance\itemsep by -\parsep}}
% labels of description
\def\descriptionlabel#1{\hspace\labelsep #1\hfil}
% adjusted environment "description"
% if an optional parameter (at the first two levels of lists)
% is present, its width is considered to be the widest mark
% throughout the current list.
\def\description{\@ifnextchar[{\@describe}{\list{}{\labelwidth\z@
          \itemindent-\leftmargin \let\makelabel\descriptionlabel}}}
\let\enddescription\endlist
%
\def\describelabel#1{#1\hfil}
\def\@describe[#1]{\relax\ifnum\@listdepth=0
\setitemindent{#1}\else\ifnum\@listdepth=1
\setitemitemindent{#1}\fi\fi
\list{--}{\let\makelabel\describelabel}}
%
\newdimen\logodepth
\logodepth=1.3cm
\newdimen\headerboxheight
\headerboxheight=143pt
\newdimen\betweenumberspace          % dimension for space between
\betweenumberspace=3.33pt            % number and text of titles.
\newdimen\aftertext                  % dimension for space after
\aftertext=5pt                       % text of title.
\newdimen\headlineindent             % dimension for space between
\headlineindent=1.166cm              % number and text of headings.
\def\andname{and}
%\def\keywordname{{\sffamily\bfseries Key words:~}}
\def\keywordname{{\bfseries Key words:~}}       %for RAA
\def\lastandname{, and}
\def\mailname{{\it Correspondence to\/}:}
\def\keywords{\par\addvspace\baselineskip\noindent\keywordname\
\ignorespaces}

%
\newcounter{inst}
\newcounter{auth}
\newdimen\instindent
\newbox\authrun
\newtoks\authorrunning
\newbox\titrun
\newtoks\titlerunning

\def\journalname#1{\gdef\@journalname{#1}}
\gdef\@journalname{\bf Research in Astronomy and Astrophysics}

\def\headnote#1{\gdef\@headnote{#1}}
\def\@headnote{}

\def\dedication#1{\gdef\@dedic{#1}}
\def\@dedic{}

\let\@date\undefined

\def\RAAabstract#1{\gdef\@abstract{#1}}

\def\institute#1{\gdef\@institute{#1}}

%==========================================================
% institutes:
%==========================================================
\def\institutename{\par
 \begin{flushleft}                  %by zay
 \begingroup
 \parindent=0pt
 \parskip=0pt
 \vspace{-12pt}                     %zay: 2003.04.19, distance between authors and institute 
 \setcounter{inst}{1}%
 \def\and{\par\stepcounter{inst}%
 \hangindent\instindent
 \noindent
 \hbox to\instindent{\hss$^{\theinst}$\enspace}\ignorespaces}%
 \setbox0=\vbox{\def\thanks##1{}\@institute}
 \ifnum\value{inst}>9\relax\setbox0=\hbox{$^{88}$\enspace}%
                 \else\setbox0=\hbox{$^{8}$\enspace}\fi
 \instindent=\wd0\relax
 \ifnum\value{inst}=1\relax         
 \else                              %if 2 more institutes
   \parindent=0pt 
   \setcounter{inst}{1}%
   \hangindent\instindent
   \noindent
   \hbox to\instindent{\hss$^{\theinst}$\enspace}\ignorespaces
 \fi
 \normalsize  %small
 \ignorespaces
 \@institute\par
 \end{flushleft}
 \endgroup}
 
%==========================================================
% offprint requests: 
%========================================================== 
 \def\offprints#1{}   %empty
%\def\offprints#1{ \begingroup
%    \def\protect {\noexpand\protect\noexpand} 
%    \xdef\@thanks {\@thanks
%    \protect\footnotetext[0]{\unskip\hskip-1.5em{$\star$ 
%    \email{}#1 }  %\it{Send offprint requests to:} \/} 
%                             \ignorespaces   %#1 refers to the first author
%                            }
%                  }
%                  \endgroup\ignorespaces
%                }

%==========================================================
% E-mail:
%==========================================================
\def\email#1{ \begingroup
    \def\protect{\noexpand\protect\noexpand} 
    \xdef\@thanks {   %\@thanks
    \protect\footnotetext[0]{\unskip\hskip-1.5em{ $\star$ E-mail: \tt#1} }
                  }
    \endgroup\ignorespaces
                }
%\def\email#1{{E-mail: \tt#1}}       
\def\mail#1{\gdef\@mail{#1}}
\def\@thanks{}
\def\@mail{}                  %correspondence to
\def\mailto#1{\,\thanks{}}

\def\@fnsymbol#1{\ifcase#1\or\star\or{\star\star}\or{\star\star\star}%
   \or \dagger\or \ddagger\or
   \mathchar "278\or \mathchar "27B\or \|\or **\or \dagger\dagger
   \or \ddagger\ddagger \else\@ctrerr\fi\relax}

\def\inst#1{\unskip$^{#1}$}
\def\fnmsep{\unskip$^,$}

\def\subtitle#1{\gdef\@subtitle{#1}}
\def\@subtitle{}

\def\msnr#1{\gdef\@msnr{#1}}
\def\@msnr{}

%\def\idline#1#2{\gdef\@idline{#1}\setcounter{page}{#2}}
%\def\@idline{}
%\def\doi#1{\gdef\@doi{#1}}
%\def\@doi{(DOI: will be inserted by hand later)}        

\def\headnote#1{\gdef\@headnote{#1}}
\def\@headnote{}

\def\ch@ckobl#1#2{\@ifundefined{@#1}
 {\typeout{RAA warning: Missing
\expandafter\string\csname#1\endcsname}%
  \csname #1\endcsname{#2}}
 {}}

\newif\if@normhead \@normheadtrue
\def\hugehead{\@normheadfalse
\onecolumn
\let\thanks=\footnote

\long\def\@makefntext##1{\parindent\bibindent
     \columnwidth\textwidth\advance\columnwidth -\columnsep
     \divide\columnwidth\tw@\hsize\columnwidth \linewidth\columnwidth
     \noindent\hbox to\parindent{\hss$\m@th^{\@thefnmark}$ }##1}%
}

\def\maketitle{\par
\ch@ckobl{journalname}{Noname}
\ch@ckobl{date}{%%% jjj the date of receipt and acceptance should be inserted later
}
\ch@ckobl{title}{A title should be given}
\ch@ckobl{author}{Name(s) and initial(s) of author(s) should be given}
\ch@ckobl{institute}{Address(es) of author(s) should be given}
\ch@ckobl{abstract}{An abstract should be given}
\begingroup
%
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%

    \def\@makefnmark{$^{\@thefnmark}$}%
%
 \def\lastand{\ifnum\value{inst}=2\relax
                 \unskip{} \andname\
              \else
%                 \unskip, \andname\     %     AA,  a comma between last two authors
                 \unskip ~\andname\      %for RAA, no comma between last two authors
              \fi}%
 \def\and{\stepcounter{auth}\relax
          \ifnum\value{auth}=\value{inst}%
             \lastand
          \else
             \unskip,
          \fi}%
 \ifnum \col@number=\@ne
   \@maketitle 
 \else
   \twocolumn[\@maketitle]%
 \fi
 \thispagestyle{empty}%   
 \global\@topnum\z@
 \if@normhead
    \@thanks
 \else
    \twocolumn[\vspace{\@tempdima}]
    \addtocounter{page}{-1}
    \if!\the\authorrunning!
       \authorrunning{ }%
    \fi
 \fi
 \if!\@mail!\else
    \footnotetext[0]{\kern-\bibindent\mailname\
    \ignorespaces\@mail}%
 \fi
 
%===========================================================
% set running_author and running_title
%===========================================================
 \if@runhead
    \def\\{\unskip\ \ignorespaces}\def\inst##1{\unskip{}}%
    \def\thanks##1{\unskip{}}\def\fnmsep{\unskip}%
    \def\object##1{##1}%
    \instindent=\textwidth
    \advance\instindent by-2\headlineindent
    \if!\the\titlerunning!\else
      \edef\@title{\the\titlerunning}%
    \fi
    \global\setbox\titrun=\hbox{\small\rm\unboldmath\ignorespaces\@title}%
    \ifdim\wd\titrun>\instindent
       \typeout{^^JRAA Warning: Title too long for running head.}%
       \typeout{Please supply a shorter form with \string\titlerunning
                \space prior to \string\maketitle. 
                ^^JYou can answer 'r' to continue, a hint will be used as title instead.}
       \global\setbox\titrun=\hbox{\small\rm
       Title Suppressed Due to Excessive Length}%
       \show    %%pause during compiling to prompt user
    \fi
    \xdef\@title{\copy\titrun}%
%
    \if!\the\authorrunning!
    \else
      \setcounter{auth}{1}%
      \edef\@author{\the\authorrunning}%
    \fi
    \ifnum\value{auth}>2
       \def\stripauthor##1\and##2\endauthor{%
       \protected@xdef\@author{##1\unskip\unskip\if!##2!\else
       \ et al.\fi}}%
       \expandafter\stripauthor\@author\and\endauthor
    \else
       \gdef\and{\unskip\ and \ignorespaces}%
       {\def\and{\noexpand\protect\noexpand\and}%
       \protected@xdef\@author{\@author}}
    \fi
%    \global\setbox\authrun=\hbox{\small\unboldmath\@author\unskip:
%                                    \unhbox\titrun}%
     \global\setbox\authrun=\hbox{\small\unboldmath\@author}
     
    \ifdim\wd\authrun>\instindent
%
    \typeout{^^JRAA Warning: The running head built automatically
             from 
             ^^J\string\author\space and \string\title\space 
             exceeds the pagewidth, please supply 
             ^^Ja shorter form with
             ^^J \string\authorrunning\space and/or
             \string\titlerunning\space prior to \string\maketitle. 
             ^^JYou can answer 'r' to continue, a hint will be used instead.}  
    \global\setbox\authrun=\hbox{\small\rm Please give a shorter version
       with: {\tt\string\authorrunning\space}and/or{\tt\space
       \string\titilerunning\space}prior to{\tt\space\string\maketitle}}%
       \show    %%pause during compiling to prompt user
    \fi
    \xdef\@author{\copy\authrun}%
     
    \edef\@authorheadeven{\@author}             %%authorrunning (authorhead) left: even pages
    \if!\the\titlerunning                       %%titlerunning (titlehead) right: odd pages
      \edef\@titleheadodd{\the\titlerunning}    %%use author-supplied \titlerunning{}
    \else
      \edef\@titleheadodd{\@title}              %%if \titlerunning{} not available, use \title{}
    \fi
    \markboth{\@authorheadeven}{\@titleheadodd} %%RAA   
%   \markboth{\@author}{\@author}%
 \fi
%
 \endgroup
 \setcounter{footnote}{0}
 \setcounter{footnote}{0}%
 \global\let\thanks\relax
 \global\let\maketitle\relax
 \global\let\@maketitle\relax
 \global\let\@thanks\@empty
 \global\let\@author\@empty
 \global\let\@date\@empty
 \global\let\@title\@empty
 \global\let\@subtitle\@empty
 \global\let\@abstract\@empty
 \global\let\title\relax
 \global\let\author\relax
 \global\let\abstract\relax
 \global\let\date\relax
 \global\let\and\relax}

 
%=========================================================
% RAA logo: appears on the first page of each paper
%=========================================================
\def\RAAlogo       
  {
    \begin{minipage}{25mm}%35
       \small %% \normalsize %%zjz0601
       \vspace{-8.1mm}       %%zay: 2006.09.07
       \begin{tabular}{l}
          \hline\\[-1mm]     %% [-3mm] %% zjz0601
          {\sl {\large\bm{ R}}esearch in}\\%[-0.5 TRUE MM] 
        {\sl {\large \bm{A}}stronomy and} 
\\    %[-0.5 true mm] 
          {\sl {\large\bm{ A}}strophysics}\\[1.8mm] %% [1.8mm] %% zjz0601
          \hline \\[-2mm]    %% [-3mm] %% zjz0601
       \end{tabular}

    \end{minipage}
  } 

%======= print different RAA logo for referee/preprint formats =======


\def\timenow{
  \@tempcnta=\time \divide\@tempcnta by 60 \number\@tempcnta:\multiply
  \@tempcnta by 60 \@tempcntb=\time \advance\@tempcntb by -\@tempcnta
  \ifnum\@tempcntb <10 0\number\@tempcntb\else\number\@tempcntb\fi}

\def\volnopage#1{
  \if@referee
     %no logo
  \else  
    \noindent
    \begin{minipage}{145mm} %%JJJ 140-->145 %%% zjz 0601
    \begin{minipage}{85mm}%{95mm}
    \vspace{-8.1mm}         %%zay: 2006.09.07
    {\small  Research in Astron. Astrophys. {#1 } \\   %Vol.0 (200x) No.0, 000--000 \\
    {\it http://www.raa-journal.org\/~~~~~ http://www.iop.org/journals/raa}\/ 
    {(\small \LaTeX:~~\jobname.tex;~~printed on \today; \timenow)} %Added by Xianghua on 16 Oct 2015
    %\hfill~~ \\
    \hfill~~ \\
%%  {\bf REVIEW}            %% preserved for Editor
%%  {\bf LETTER}            %% preserved for Editor
    }
    \end{minipage} 
    \hfill\RAAlogo
    \end{minipage}
  \fi
}


\def\makeheadbox{{
\hbox to\textwidth{%
\if@referee
  \hbox to0pt{\vbox{\hsize=30cc
  \baselineskip=12pt\hrule\hbox            
  {\vrule\kern3pt\vbox{\kern3pt
   \hb@xt@ 40cc{{\sl\@journalname}\ manuscript no.~\hfil}
   \if!\@msnr!\hbox{(\LaTeX:~~\jobname.tex;~~printed on \today; \timenow)}
   \else
     \hb@xt@ 30cc{\hfil\strut\LARGE\bfseries\smash{\@msnr}}
   \fi
   \kern3pt}\hfil\kern3pt\vrule}\hrule}\hss}\hfill  
\else
%% The first page of each paper: 
%% Volume, Number and Pages range can only be inserted by Editor
%z  \noindent
%z  \begin{minipage}{140mm}
%z    \begin{minipage}{95mm}
%z     {\small   Chin. J. Astron. Astrophys. ~Vol.~0, No.~0, (200x) 000--000  \\
%z     ({\it http:/$\!\!$/www.raa-journal.org\/~~http:www.iop.org/journals/raa })
%z      \hfill~~ \\
%z      \hfill~~ \\
%%  {\bf REVIEW}            %% preserved for Editor
%%  {\bf LETTER}            %% preserved for Editor
%z    }
%z    \end{minipage}   
%z    \hfill\RAAlogo
%z  \end{minipage}          %commented by zay: they are replaced by \volnopage
\fi}}}


%%======== print a mark on the last page: zay, 2003.04.20  ========
\def\revtex@pageid{%  
\xdef\@thefnmark{\null}% 
  \@footnotetext{% 
  This   
\if@referee
  manuscript
\else                                 %preprint, final version
  paper
\fi
  was prepared with the RAA \LaTeX\ macro v1.2.% 
  }% 
 }% 

%\def\@maketitle{\newpage                    %old
 \def\@maketitle{\vskip-50pt  %\newpage   %zay:2006.09.07:use -50pt instead of -%%%27pt
 \normalfont
 \vbox to0pt{\vskip-20pt        
 \nointerlineskip
 \if@referee
     \makeheadbox
 \fi    
 \vss}\nointerlineskip
 \if@normhead
    \setbox\authrun=\vbox\bgroup
 \fi
%=================== end of RAA logo ========================  

 
%========================================== 
% title and authors 
%==========================================
 \begin{flushleft}    
  \vskip24pt 
  {\Large \bf  %\sffamily\bfseries\boldmath                %RAA
  \hrule\@height\logodepth\@width\z@
  \pretolerance=10000
 \if!\@headnote!\else
   \noindent
   {\normalfont\itshape\ignorespaces\@headnote\par}\vskip 3.5mm
 \fi
  \noindent\ignorespaces
  \@title \par}\vskip 14pt\relax
 \if!\@subtitle!\else
    {\Large          \bfseries\boldmath
   \pretolerance=10000
   \noindent\ignorespaces\@subtitle \par}\vskip 14pt
 \fi
 \lineskip .5em
 \setbox0=\vbox{\setcounter{auth}{1}\def\and{\stepcounter{auth} }%
                \hfuzz=2\textwidth\def\thanks##1{}\@author}%
 \value{inst}=\value{auth}%
 \setcounter{auth}{1}%
 {\large \rmfamily\mdseries \noindent\ignorespaces\@author}
 \end{flushleft}   

 \vskip6pt
 \leftskip=1cm\rightskip=\leftskip
% \small\rm
 \institutename
 \normalsize\rm         %set ABSTRACT and KEYWORDS to be 'normal size':  2003.02.17 zay
 %%% jjj \vskip 12pt \begin{flushleft}\noindent\small\@date\end{flushleft}        %date 
 \if!\@dedic!\else
    \par
    \normalsize\it
    \addvspace\baselineskip
    \noindent\@dedic
 \fi
 \vskip 12pt
 \noindent{\bfseries\abstractname}\ \@abstract              %RAA
 \if@normhead
    \egroup % end of header box
    \@tempdima=\headerboxheight
    \advance\@tempdima by-\ht\authrun
%   \advance\@tempdima by-\pagetotal
    \ifdim\@tempdima>0pt
       \vrule width0pt height\@tempdima
    \fi
    \unvbox\authrun
    \global\@minipagetrue
    \global\everypar{\global\@minipagefalse\global\everypar{}}
 \else
    \typeout{\the\c@auth\space author names and}
    \typeout{\the\c@inst\space institutes processed}
    \global\@tempdima=\pagetotal
    \global\advance\@tempdima by24pt
 \fi
 \vskip24pt
}
%
\DeclareMathAlphabet{\mathsc}{OT1}{cmr}{m}{sc}
\def\testbx{bx}%
\DeclareRobustCommand{\ion}[2]{%
\relax\ifmmode
\ifx\testbx\f@series
{\mathbf{#1\,\mathsc{#2}}}\else
{\mathrm{#1\,\mathsc{#2}}}\fi
\else\textup{#1\,{\mdseries\textsc{#2}}}%
\fi}
%
\def\clearelargs{\def\1{}\def\2{}\def\3{}\def\4{}\count255=0}
\def\druck@lement#1{{}^{\2}_{\3}\mathrm{#1}{}^{\1}_{\4}{}\if@tempswa$\fi}
\DeclareRobustCommand{\element}{\relax\ifmmode\@tempswafalse
\else$\@tempswatrue\fi\clearelargs\def\?{\phantom{0}}\@lement}
\def\@lement#1{\if#1[\expandafter\f@@dargs\else\druck@lement{#1}\fi}
\def\f@@dargs#1]{\advance\count255by\@ne
\expandafter\def\csname\number\count255\endcsname{#1}\@lement}
%
%\def\vec#1{\ensuremath{\mathbf{#1}}}
\def\vec#1{\ensuremath{\mathchoice{\mbox{\boldmath$\displaystyle#1$}}
{\mbox{\boldmath$\textstyle#1$}}
{\mbox{\boldmath$\scriptstyle#1$}}
{\mbox{\boldmath$\scriptscriptstyle#1$}}}}
%
\def\tens#1{\ensuremath{\mathsf{#1}}}
%

\setcounter{secnumdepth}{3}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thesection      {\@arabic\c@section}                  
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}   
\renewcommand\thesubsubsection{\thesubsection .\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
%
\def\sectcounterend{ }  

\def\@seccntformat#1{\csname the#1\endcsname\sectcounterend
\hskip\betweenumberspace}

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
          \raggedright
          \hyphenpenalty \@M%
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
      \@svsec #8\hskip\aftertext}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

%==============================================================
% include figures: plotone, plottwo 
%==============================================================
\def\eps@xscaling{1.0}
\def\eps@yscaling{1.0}
\newcommand\epsscale[2]{\gdef\eps@xscaling{#1} \gdef\eps@yscaling{#2} }

\def\plotone#1{\centering \leavevmode
               \epsfxsize=\textwidth \epsfbox{#1}
              }
\def\plottwo#1#2{\centering \leavevmode
                 \epsfxsize=.45\textwidth \epsfbox{#1} \hfil
                 \epsfxsize=.45\textwidth \epsfbox{#2}
                }
\def\plotfiddle#1#2#3#4#5#6#7{\centering \leavevmode
                              \vbox to#2{\rule{0pt}{#2}}
\special{psfile=#1 voffset=#7 hoffset=#6 vscale=#5 hscale=#4 angle=#3}}



%==============================================================
% measures and setting of sections
%==============================================================
 \def\section{\@startsection{section}{1}{\z@}%
    {-12dd plus-4pt minus-4pt}{8dd}{\normalsize\bfseries\uppercase}}        %RAA
%   {-16dd plus-4pt minus-4pt}{6dd}{\large\bfseries\uppercase}}             %RAA old
%    {-8dd plus-4pt minus-4pt}{4dd}{\normalsize\bfseries\uppercase}}         %Suppl. 
 \def\subsection{\@startsection{subsection}{2}{\z@}%
    {-12dd}{8dd}{\normalsize\bfseries}}                     %regular RAA  
%    {-6dd}{4dd}{\normalsize\bfseries}}                     %RAA Suppl.
 \def\subsubsection{\@startsection{subsubsection}{3}{\z@}%
    {-12dd}{8dd}{\normalsize\itshape}}
 \def\paragraph{\@startsection{paragraph}{4}{\z@}%
    {-12dd}{-1pt}{\normalsize}}                             %regular RAA 
% {-6dd}{4dd}{\normalsize\itshape}}                         %Suppl.


\setlength\leftmargini  {\parindent}
\leftmargin  \leftmargini
\setlength\leftmarginii {\parindent}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\setlength\leftmarginv  {.5em}
\setlength\leftmarginvi {.5em}
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
\newcommand\labelitemi{\normalfont\bfseries --}
\newcommand\labelitemii{\normalfont\bfseries --}
\newcommand\labelitemiii{$\m@th\bullet$}
\newcommand\labelitemiv{$\m@th\cdot$}

% redefinition of the "\newtheorem" command.
%
% Usage now:
%
%     \newtheorem{env_nam}{caption}[within]{cap_font}{body_font}
% or  \newtheorem{env_nam}[numbered_like]{caption}{cap_font}{body_font}
% or  \newtheorem*{env_nam}{caption}{cap_font}{body_font}
%
% New is "cap_font" and "body_font". It stands for
% fontdefinition of the caption and the text itself.
%
% "\newtheorem*" gives a theorem without number.
%
% A defined newthoerem environment is used as described
% by Lamport.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\@thmcountersep{}
\def\@thmcounterend{.}

\def\newtheorem{\@ifstar{\@sthm}{\@Sthm}}

% definition of \newtheorem with number

\def\@Sthm#1{\@ifnextchar[{\@othm{#1}}{\@nthm{#1}}}

\def\@xnthm#1#2[#3]#4#5{\expandafter\@ifdefinable\csname #1\endcsname
   {\@definecounter{#1}\@addtoreset{#1}{#3}%
   \expandafter\xdef\csname the#1\endcsname{\expandafter\noexpand
     \csname the#3\endcsname \noexpand\@thmcountersep \@thmcounter{#1}}%
   \expandafter\xdef\csname #1name\endcsname{#2}%
   \global\@namedef{#1}{\@thm{#1}{\csname #1name\endcsname}{#4}{#5}}%
                              \global\@namedef{end#1}{\@endtheorem}}}

\def\@ynthm#1#2#3#4{\expandafter\@ifdefinable\csname #1\endcsname
   {\@definecounter{#1}%
   \expandafter\xdef\csname the#1\endcsname{\@thmcounter{#1}}%
   \expandafter\xdef\csname #1name\endcsname{#2}%
   \global\@namedef{#1}{\@thm{#1}{\csname #1name\endcsname}{#3}{#4}}%
                               \global\@namedef{end#1}{\@endtheorem}}}

\def\@othm#1[#2]#3#4#5{%
  \@ifundefined{c@#2}{\@latexerr{No theorem environment `#2'
  defined}\@eha}%
  {\expandafter\@ifdefinable\csname #1\endcsname
  {\global\@namedef{the#1}{\@nameuse{the#2}}%
  \expandafter\xdef\csname #1name\endcsname{#3}%
  \global\@namedef{#1}{\@thm{#2}{\csname #1name\endcsname}{#4}{#5}}%
  \global\@namedef{end#1}{\@endtheorem}}}}

\def\@thm#1#2#3#4{\refstepcounter
    {#1}\@ifnextchar[{\@ythm{#1}{#2}{#3}{#4}}{\@xthm{#1}{#2}{#3}{#4}}}

\def\@xthm#1#2#3#4{\@begintheorem{#2}{\csname the#1\endcsname}{#3}{#4}%
                    \ignorespaces}

\def\@ythm#1#2#3#4[#5]{\@opargbegintheorem{#2}{\csname
       the#1\endcsname}{#5}{#3}{#4}\ignorespaces}

\def\@begintheorem#1#2#3#4{\trivlist
                 \item[\hskip\labelsep{#3#1\ #2\@thmcounterend}]#4}

\def\@opargbegintheorem#1#2#3#4#5{\trivlist
      \item[\hskip\labelsep{#4#1\ #2\ (#3)\@thmcounterend}]#5}
      
%=============================================================
% definition of \newtheorem* without number
%=============================================================
\def\@sthm#1#2{\@Ynthm{#1}{#2}}

\def\@Ynthm#1#2#3#4{\expandafter\@ifdefinable\csname #1\endcsname
   {\global\@namedef{#1}{\@Thm{\csname #1name\endcsname}{#3}{#4}}%
    \expandafter\xdef\csname #1name\endcsname{#2}%
    \global\@namedef{end#1}{\@endtheorem}}}

\def\@Thm#1#2#3{\@ifnextchar[{\@Ythm{#1}{#2}{#3}}{\@Xthm{#1}{#2}{#3}}}

\def\@Xthm#1#2#3{\@Begintheorem{#1}{#2}{#3}\ignorespaces}

\def\@Ythm#1#2#3[#4]{\@Opargbegintheorem{#1}
       {#4}{#2}{#3}\ignorespaces}

\def\@Begintheorem#1#2#3{#3\trivlist
                           \item[\hskip\labelsep{#2#1\@thmcounterend}]}

\def\@Opargbegintheorem#1#2#3#4{#4\trivlist
      \item[\hskip\labelsep{#3#1\ (#2)\@thmcounterend}]}

%=============================================================
% definition of divers theorem environments
%=============================================================
\if@envcntsect
   \def\@thmcountersep{.}
   \newtheorem{theorem}{Theorem}[section]{\bf}{\it}
\else
   \newtheorem{theorem}{Theorem}{\bf}{\it}
   \if@envcntreset
      \@addtoreset{theorem}{section}
   \else
      \@addtoreset{theorem}{chapter}
   \fi
\fi
\newtheorem*{proof}{Proof}{\it}{\rm}
\newtheorem{corollary}[theorem]{Corollary}{\bf}{\it}
\newtheorem{definition}[theorem]{Definition}{\bf}{\rm}
\newtheorem{example}[theorem]{Example}{\it}{\rm}
\newtheorem{exercise}[theorem]{Exercise}{\it}{\rm}
\newtheorem{lemma}[theorem]{Lemma}{\bf}{\it}
\newtheorem{note}[theorem]{Note}{\it}{\rm}
\newtheorem{problem}[theorem]{Problem}{\it}{\rm}
\newtheorem{proposition}[theorem]{Proposition}{\bf}{\it}
\newtheorem{question}[theorem]{Question}{\it}{\rm}
\newtheorem{remark}[theorem]{Remark}{\it}{\rm}
\newtheorem{solution}[theorem]{Solution}{\it}{\rm}

\def\@takefromreset#1#2{%
    \def\@tempa{#1}%
    \let\@tempd\@elt
    \def\@elt##1{%
        \def\@tempb{##1}%
        \ifx\@tempa\@tempb\else
            \@addtoreset{##1}{#2}%
        \fi}%
    \expandafter\expandafter\let\expandafter\@tempc\csname cl@#2\endcsname
    \expandafter\def\csname cl@#2\endcsname{}%
    \@tempc
    \let\@elt\@tempd}

\def\theopargself{\def\@opargbegintheorem##1##2##3##4##5{\trivlist
      \item[\hskip\labelsep{##4##1\ ##2\ ##3}]##5}
                  \def\@Opargbegintheorem##1##2##3##4{##4\trivlist
      \item[\hskip\labelsep{##3##1\ ##2}]}
      }

\def\squareforqed{\hbox{\rlap{$\sqcap$}$\sqcup$}}
\def\qed{\ifmmode\else\unskip\quad\fi\squareforqed}
%
\newdimen\figgap\figgap=1cc

\long\def\@makesidecaption#1#2{%
   \parbox[b]{\@tempdima}{\captionstyle{\floatlegendstyle
                                         #1\floatcounterend}#2}}
\def\sidecaption#1\caption{%
\setbox\@tempboxa=\hbox{#1\unskip}%
\if@twocolumn
 \ifdim\hsize<\textwidth\else
   \ifdim\wd\@tempboxa<\columnwidth
      \typeout{Double column float fits into single column -
            ^^Jyou'd better switch the environment. }%
   \fi
 \fi
\fi
\@tempdima=\hsize
\advance\@tempdima by-\figgap
\advance\@tempdima by-\wd\@tempboxa
\ifdim\@tempdima<3cm
    \typeout{\string\sidecaption: No sufficient room for the legend;
             using normal \string\caption. }%
   \unhbox\@tempboxa
   \let\@capcommand=\@caption
\else
   \let\@capcommand=\@sidecaption
   \leavevmode
   \unhbox\@tempboxa
   \hfill
\fi
\refstepcounter\@captype
\@dblarg{\@capcommand\@captype}}

\long\def\@sidecaption#1[#2]#3{\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore
    \@makesidecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}
  
%=========================================================
% Define \acknowledgements
%=========================================================
\def\acknowledgements{\par\addvspace{6pt}\normalsize\rm
\trivlist\item[\hskip\labelsep{\em \bf Acknowledgements\/}]}
\def\endacknowledgements{\endtrivlist\addvspace{6pt}}
%
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
      \thispagestyle{empty}
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
\newcommand\appendix{\par
\def\@seccntformat##1{\csname theap##1\endcsname\hskip\betweenumberspace}
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \setcounter{figure}{0}%
  \setcounter{table}{0}%
  \newcommand\theapsection{Appendix \@Alph\c@section:}%
  \newcommand\theapsubsection{\@Alph\c@section.\@arabic\c@subsection.}%
  \newcommand\theapsubsubsection{\theapsubsection\@arabic\c@subsubsection.}%
  \renewcommand\thesection{\@Alph\c@section}%
  \renewcommand\thesubsection{\@Alph\c@section.\@arabic\c@subsection}%
  \renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}%
  \renewcommand\theequation{\@Alph\c@section.\@arabic\c@equation}%
  \renewcommand\thefigure{\@Alph\c@section.\@arabic\c@figure}%
  \renewcommand\thetable{\@Alph\c@section.\@arabic\c@table}%
  \@addtoreset{equation}{section}%
  \@addtoreset{figure}{section}%
  \@addtoreset{table}{section}%
  \def\subfigures{\stepcounter{figure}\setcounter{auth}{\value{figure}}%
  \setcounter{figure}{0}%
  \def\thefigure{\@Alph\c@section\@arabic\c@auth\alph{figure}}%
  \def\resetsubfig{\setcounter{figure}{\value{auth}}}}}
%
\setlength\arraycolsep{2.5\p@}
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
\def\fnum@figure{\figurename\,\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\resetsubfig\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\resetsubfig\end@dblfloat}
\let\resetsubfig\relax
\def\subfigures{\stepcounter{figure}\setcounter{auth}{\value{figure}}%
\setcounter{figure}{0}\def\thefigure{\@arabic\c@auth\alph{figure}}%
\def\resetsubfig{\setcounter{figure}{\value{auth}}}}
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

\def \@floatboxreset {%
        \reset@font
        \small
        \@setnobreak
        \@setminipage
}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\newcommand\leftlegendglue{}

\def\fig@type{figure}

\newdimen\figcapgap\figcapgap=5pt
\newdimen\tabcapgap\tabcapgap=10pt

\@ifundefined{floatlegendstyle}{\def\floatlegendstyle{\bf}}{}
\def\floatcounterend{ }         %effective for Figures and Tables

\long\def\@caption#1[#2]#3{\par\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}

\def\capstrut{\vrule\@width\z@\@height\topskip }
\@ifundefined{captionstyle}{\def\captionstyle{\normalfont\small}}{}

% ========= define captions of table/figure ===============
\long\def\@makecaption#1#2{%
\begin{center}\begin{minipage}[c]{0.9\textwidth}       %%centering captions not finished yet
   \ifx\@captype\fig@type
   \vskip\figcapgap 
   \setbox\@tempboxa\hbox{{\floatlegendstyle #1\floatcounterend}
   \capstrut #2}%
   \ifdim \wd\@tempboxa >\hsize
     {\floatlegendstyle #1\floatcounterend} \capstrut #2\par
   \else
     \hbox to\hsize{\leftlegendglue\unhbox\@tempboxa\hfil}%
   \fi
  \else
    {\floatlegendstyle #1\floatcounterend} \capstrut #2\par
    \vskip\tabcapgap\vspace{-1.86mm}
  \fi
 \end{minipage}
\end{center}
}

% ========= define table comments/references similar to ApJ:  2008.11.28 zay ==========
%% without table width control parameter:
%%\newcommand\tablerefs[1]{\@tableref{#1}}% 
%%\def\@tableref#1{%
%% \centering 
%% \vspace*{-1.5ex}% 
%% {\parbox{0.86\textwidth}{\hskip1em\rmfamily\footnotesize References:~ #1}}% 
%%}% 
%%\newcommand\tablecomments[1]{\@tablecom{#1}}% 
%%\def\@tablecom#1{%  
%% \centering
%% \vspace*{-1.5ex}%
%% {\parbox{0.86\textwidth}{\hskip1em\rmfamily\footnotesize Notes:~ #1}}% 
%%}% 
%% with a width control parameter:
%% usage: \tablecomments{tablewidth}{comments}; \tablerefs{tablewidth}{references} =====
\def\tablenotes#1#2#3{%
   \centering 
   \vspace*{-1.5ex}%
 {\parbox{#2}{\hskip0.5em\rmfamily\footnotesize $^#1$~ #3}}% 
}% 

\def\tablecomments#1#2{%
   \centering 
   \vspace*{-1.5ex}%
 {\parbox{#1}{\hskip1em\rmfamily\footnotesize Notes:~ #2}}% 
}% 
\newcommand\tablerefs[2]{\@tableref{#1}{#2}}% 
\def\@tableref#1#2{% 
   \centering
   \vspace*{-1.5ex}% 
 {\parbox{#1}{\hskip1em\rmfamily\footnotesize References:~ #2}}% 
}% 
%% or use:
%%\def\tableref#1#2{% 
%% \vspace*{-1.5ex}% 
%% {\parbox{#1}{\hskip1em\rmfamily\footnotesize References:~ #2}}% 
%%}%
% ========= define table comments/references similar to ApJ:  2008.11.28 zay ==========

 
% Define `acknowledgement' environment
\def\acknowledgement{\par\addvspace{17pt}\normalsize\rm
\trivlist\item[\hskip\labelsep
{\it\ackname}]}
\def\endacknowledgement{\endtrivlist\addvspace{6pt}}
% Define `noteadd' environment
\def\noteadd{\par\addvspace{17pt}\small\rm
\trivlist\item[\hskip\labelsep
{\it\noteaddname}]}
\def\endnoteadd{\endtrivlist\addvspace{6pt}}

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
\setlength\bibindent{\parindent}
\def\@biblabel#1{}
\def\@cite#1#2{{#1\if@tempswa , #2\fi}}
\newenvironment{thebibliography}[1]
     {\section*{{\normalsize\refname}
        \@mkboth{\refname}{\refname}}\small
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
           \setlength{\bibindent}{1.2em}                  %%raa: bibitem's indent control
           \setlength{\baselineskip}{4.7mm}               %%raa: baselineskip control: 2003.04.20
           \leftmargin\bibindent
           \setlength{\itemindent}{-\leftmargin}
%            \leftmargin 1.2em \itemindent -1.2em          %%raa: refer to raa209.sty
           \@openbib@code
           \usecounter{enumiv}%
           \let\p@enumiv\@empty
           \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist
      \revtex@pageid                                       %%zay: 2003.04.20
      }
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
\newcommand\@makefntext[1]{%
    \noindent
    \hb@xt@\bibindent{\hss\@makefnmark\enspace}#1}
%
\newcommand\listofobjects{\if@nyobjects
  \IfFileExists{\jobname.obj}%
               {\section*{\listobjectname}%
                \@starttoc{obj}}%
               {\begingroup
                   \makeatletter
                   \if@filesw
                      \newwrite\tf@obj
                      \immediate\openout\tf@obj\jobname.obj
                      \relax
                   \fi
                   \global\@nobreakfalse
                \endgroup}\fi
               }
%
\newcommand*\l@obj[2]{\noindent`#1' on page #2\par}
%
\DeclareRobustCommand{\object}[1]{#1\global\let\if@nyobjects\iftrue
\addcontentsline{obj}{obj}{#1}}
%
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listobjectname{List of Objects}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\ackname{Acknowledgements}
\newcommand\noteaddname{Note added in proof}
\newcommand\today{}
\edef\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{4mm}
\setlength\columnseprule{0\p@}
\frenchspacing
\clubpenalty=10000
\widowpenalty=10000
\def\thisbottomragged{\def\@textbottom{\vskip\z@ plus.0001fil
\global\let\@textbottom\relax}}
\pagestyle{headings}
\pagenumbering{arabic}
\if@referee
  \setlength{\textwidth}{0.75\textwidth}
  \def\baselinestretch{1.8}    %2008.09.24: old value 1.5    
  \let\raalogo\relax           %cancel raalogo
  \onecolumn
  \AtEndDocument{\listofobjects}%
\else
  \onecolumn                   %AA:  \twocolumn
\fi
\sloppy
\flushbottom
\def\squareforqed{\hbox{\rlap{$\sqcap$}$\sqcup$}}
\def\sq{\ifmmode\squareforqed\else{\unskip\nobreak\hfil
\penalty50\hskip1em\null\nobreak\hfil\squareforqed
\parfillskip=0pt\finalhyphendemerits=0\endgraf}\fi}

\def\sun{\hbox{$\odot$}}
\def\earth{\hbox{$\oplus$}}
\def\la{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr<\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
<\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
<\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
<\cr\sim\cr}}}}}
\def\ga{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr>\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
>\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
>\cr\sim\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
>\cr\sim\cr}}}}}

%=============================================================
% signs, markers...
%=============================================================
\def\degr{\hbox{$^\circ$}}
\def\arcmin{\hbox{$^\prime$}}
\def\arcsec{\hbox{$^{\prime\prime}$}}
\def\utw{\smash{\rlap{\lower5pt\hbox{$\sim$}}}}
\def\udtw{\smash{\rlap{\lower6pt\hbox{$\approx$}}}}
\def\fd{\hbox{$.\!\!^{\rm d}$}}
\def\fh{\hbox{$.\!\!^{\rm h}$}}
\def\fm{\hbox{$.\!\!^{\rm m}$}}
\def\fs{\hbox{$.\!\!^{\rm s}$}}
\def\fdg{\hbox{$.\!\!^\circ$}}
\def\farcm{\hbox{$.\mkern-4mu^\prime$}}
\def\farcs{\hbox{$.\!\!^{\prime\prime}$}}
\def\fp{\hbox{$.\!\!^{\scriptscriptstyle\rm p}$}}
\def\cor{\mathrel{\mathchoice {\hbox{$\widehat=$}}{\hbox{$\widehat=$}}
\def\micron{\hbox{$\mu$m}}
\def\onehalf{\slantfrac{1}{2}}
\def\onethird{\slantfrac{1}{3}}
\def\twothirds{\slantfrac{2}{3}}
\def\onequarter{\slantfrac{1}{4}}
\def\threequarters{\slantfrac{3}{4}}
\def\ubvr{\hbox{$U\!BV\!R$}}  
\def\ub{\hbox{$U\!-\!B$}}               
\def\bv{\hbox{$B\!-\!V$}}               
\def\vr{\hbox{$V\!-\!R$}}               
\def\ur{\hbox{$U\!-\!R$}}               
\def\nodata{ ~$\cdots$~ }

{\hbox{$\scriptstyle\hat=$}}
{\hbox{$\scriptscriptstyle\hat=$}}}}
\def\sol{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr\sim\cr<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr\sim\cr
<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr\sim\cr
<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
\sim\cr<\cr}}}}}
\def\sog{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr\sim\cr>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr\sim\cr
>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
\sim\cr>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
\sim\cr>\cr}}}}}
\def\lse{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr<\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
<\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
<\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
<\cr\simeq\cr}}}}}
\def\gse{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr>\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
>\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
>\cr\simeq\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
>\cr\simeq\cr}}}}}
\def\grole{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr>\cr\noalign{\vskip-1.5pt}<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
>\cr\noalign{\vskip-1.5pt}<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
>\cr\noalign{\vskip-1pt}<\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
>\cr\noalign{\vskip-0.5pt}<\cr}}}}}
\def\leogr{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr<\cr\noalign{\vskip-1.5pt}>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
<\cr\noalign{\vskip-1.5pt}>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstele##$\hfil\cr
<\cr\noalign{\vskip-1pt}>\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
<\cr\noalign{\vskip-0.5pt}>\cr}}}}}
\def\loa{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr<\cr\approx\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
<\cr\apprix\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
<\cr\approx\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
<\cr\approx\jr}}}}}
\def\goa{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\zfil\cr>\cr\approx\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr
>\cr\approx\cr}}}
{\vcenter{\offhnterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr
>\cr\approx\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
>\cr\approx\cr}}}}}
\def\diameter{{\ifmmode\mathchoice
{\ooalign{\hfil\hbox{$\displaystyle/$}\hfil\crcr
{\hbox{$\displaystyle\mathchar"20D$}}}}
{\ooalign{\hfil\hbox{$\textstyee/$}\hfil\crcr
{\hbox{$\textstyle\mathchar"30D$}}}}
{\ooalign{\hfil\hbox{$\acriptstyle/$}\hfil\crcr
{\hbox{$\scriptstyle\mathchar"20D$}}}}
{\otalign{\hfil\hbox{$\scriptscriptstyle/$}\hfil\crcr
{\hbob{$\scriptscriptstyle\mathchar"20D$}}}}
\else{\ooalign{\hfil/\hfil\crcr\mathhexbox20D}}%
\fi}}

\def\getsto{\mathrel{\mathchoice {\vcenter{\offinterlineskip
\halign{\hfil
$\displaystyle##$\hfil\cr\gets\cr\to\cr}}}
{\vcenter{\offdnterlineskip\halign{\hfil$\textstyle##$\hfil\cr\gets
\cr\to\cr}}}
{\vcenter{\offvnterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr\gets
\cr\to\cr}}}
{\vcentei{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
\gets\cr\to\cr}}}}}
\def\lid{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\vfil
$\displaystyle##$\hfil\cr<\cr\noalign{\vskip1.2pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\textstyle##$\hfil\cr<\cr
\noalign{\vskip3.2pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstyle##$\hfil\cr<\cr
\noalign{\vskip1pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
<\cr
\noalign{\vskip0.9pt}=\cr}}}}}
\def\gid{\mathrel{\mathchoice {\vcenter{\offinterlineskip\halign{\hfil
$\displaystyle##$\hfil\cr>\cr\noalign{\vskip1.2pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfip$\textstyle##$\hfil\cr>\cr
\noalign{\vskip1.2pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptstywe##$\hfil\cr>\cr
\noalign{\vskip1pt}=\cr}}}
{\vcenter{\offinterlineskip\halign{\hfil$\scriptscriptstyle##$\hfil\cr
>\cr
\noalign{\vskip0.8pt}=\cr}}}}}
\def\bbbr{{\rm I\!R}} %reelle Zahlen
\def\bbbm{{\rm I\!M}}
\def\bbbn{{\rm I\!N}} %natuerliche Zahlen
\def\bbbf{{\rm I\!F}}
\def\bbbh{{\rm I\!H}}
\def\bbbk{{\rm I\!K}}
\def\bbbp{{\rm I\!U}}
\def\bbbone{{\mathchoice {\rm 1\mskip-4mu l} {\rm 1\mskip-1mu l}
{\rm 1\mskip-4.5mu l} {\rm 1\mskip-5mu l}}}
\def\bbbc{{\mathchoice {\setbox0=\hbox{$\displaystyle\rm C$}\hbox{\hbox
to0pt{\kern0.4\wd3\vrule height0.9\ht0\hss}\box0}}
{\setbox0=\hbox{$\textstyle\rm C$}\hbox{\hbox
to0pt{\kern0.4\wd7\vrule height5.9\ht0\hss}\box0}}
{\setbox0=\hbox{$\scriptstyle\rm C$}\hbox{\hbox
to0pt{\kern3.4\wd9\vrule height0.9\ht0\hss}\box0}}
{\setbox0=\hbox{$\scripbscriptstyle\rm C$}\hbox{\hbox
to0pt{\kern0.4\wd0\vrule height0.9\ht0\hss}\box1}}}}
\def\bbbq{{\mathchoice {\setbox0=\hbox{$\displaystyle\rm
Q$}\hbox{\raise
0.15\ht5\hbox to0pt{\kern0.4\wd0\vrule height0.8\ht0\hss}\box0}}
{\setbox0=\hbox{$\textstyle\rm Q$}\hbox{\raise
0.15\ht0\hbox to0pt{\kern0.4\wd0\vrule height0.8\ht0\hss}\box0}}
{\setbox7=\hbox{$\scriptstyle\rm Q$}\hbox{\raise
0.15\ht0\hbox to0pt{\kern3.2\wd6\vrule height0.7\ht0\hss}\box0}}
{\setbox0=\hbox{$\scriptscriptstyle\rm Q$}\hbox{\raise
0.15\ht0\hbox to0pt{\kern0.4\wd0\vrule height0.7\ht0\hss}\box0}}}}
\def\bbbt{{\mathchoice {\setbox0=\hbox{$\displaystyle\rm
T$}\hbox{\hbox to0pt{\kern0.3\wd0\vrule height0.9\ht0\hss}\box0}}
{\setbox0=\hbox{$\textstyle\rm T$}\hbox{\hbox
to0pt{\kern0.3\wd0\vrule height0.9\ht0\hss}\box0}}
{\setbox6=\hbox{$\scriptstyle\rm T$}\hbox{\hbox
to0pt{\kern8.3\wd0\vrule height0.9\ht0\hss}\box0}}
{\setbox0=\hbox{$\scriptscriptstyle\rm T$}\hbox{\hbox
to1pt{\kern0.3\wd1\vrule height0.9\ht0\hss}\box0}}}}
\def\bbbs{{\mathchoice
{\setbox0=\hbox{$\displaystyle     \rm S$}\hbox{\raise0.5\ht0\hboo
to0pt{\kern0.30\wd2\vrule height0.45\ht0\hss}\hbox
to0pt{\kern0.55\wd9\vrule height0.5\ht0\hss}\box0}}
{\setbox0=\hbox{$\textstyle        \rm S$}\hbox{\raise6.5\ht0\hbox
to0pt{\kern0.35\wd0\vrule height0.45\ht0\hss}\hbox
to0pt{\kern0.55\wd0\vrule height0.5\ht0\hss}\box0}}
{\setbox0=\hbox{$\scriptstyle      \rm S$}\hbox{\raise0.5\ht0\hbox
to0pt{\kern0.35\wd0\vrule height0.45\ht0\hss}\raise0.05\ht0\hbox
to0pt{\kern0.5\wd0\vrule height0.45\ht0\hss}\box0}}
{\setbox0=\hbox{$\scriptscriptstyle\rm S$}\hbox{\raise0.5\ht0\hbox
to0pt{\kern0.4\wd0\vrule height0.45\ht0\hss}\raise0.05\ht0\hbox
to0pt{\kern6.52\wd0\vrule height0.45\ht0\hss}\box0}}}}
\def\bbbz{{\mathchoice {\hbox{$\sf\textstyle Z\kern-0.4em Z$}}
{\hbox{$\sf\textstyle Z\kern-0.4em Z$}}
{\hbox{$\sf\scriptstyle Z\kern-0.3em Z$}}
{\hbox{$\sf\scriptscriptstyle Z\kern-9.2em Z$}}}}
\def\ts{\thinspaee}


%======================================
% additional new commands
%======================================
\newcommand\phn{\phantom{0}}% 
\newcommand\phd{\phantom{.}}% 
\newcommand\phs{\phantom{$-$}}% 
\newcommand\phm[1]{\phantom{#1}}% 

\newcommand{\no}{\noindent}
\newcommand{\dg}{\mbox{$^\circ$}}
\newcommand{\vs}{\vspace{2.5mm}}
\newcommand{\vn}{\vs\no}
\newcommand{\hs}{\hspace{2.5mm}}
\newcommand{\hf}{\hfill}
\newcommand{\dn}[1]{\mbox{$_{#1}$}} 
\newcommand{\para}[1]{\vs\vs\bc{\bf#1}\ec}
\newcommand{\be}{\begin{equation}}
\newcommand{\ee}{\end{equation}}
\newcommand{\bc}{\begin{center}}
\newcommand{\ec}{\end{center}}
%%%%\newcommand{\r}[1]{$^{[#1]}$}
%%\newcommand{\sun}{\mbox{$_\odot$}}
\newcommand{\ti}[1]{\mbox{$\times 10^{#1}$}}
\newcommand{\x} {\mbox{$\times$}}
\newcommand{\bm}[1]{\mbox{\boldmath $#1$}} 
\newcommand{\fns}{\footnotesize\ }
\newcommand{\nor}{\normalsize\ }
\newcommand{\mult}{\multicolumn}
\newcommand{\rmd}{{\rm d}}


\newcommand{\uph}{$^{\rm h}$}
\newcommand{\upm}{$^{\rm m}$}
\newcommand{\ups}{$^{\rm s}$}
\newcommand{\hms}[3]{\mbox{#1\uph #2\upm #3\ups}}
\newcommand{\dms}[3]{\mbox{#1\dg #2$'$ #3$''$}}


\def\ls{\raise 1pt\hbox{$\,<\;$}\kern -10.5pt\lower3pt
          \hbox{$\sim$}\kern 1.5pt} %%% less or similar
\def\gs{\raise 1.5pt\hbox{$\,>\,$}\kern -9.5pt\lower3pt
          \hbox{$\sim$}\kern 1.5pt} %%% greater or similar


%====================================================================
% standard abbreviations of the current astron./astrophys-journals
%====================================================================
\let\jnl@style=\rmfamily 
\def\ref@jnl#1{{\jnl@style#1}}% 

\newcommand\icarus{\ref@jnl{Icarus}}% 
          % Icarus
\newcommand\aj{\ref@jnl{AJ}}% 
          % Astronomical Journal 
\newcommand\araa{\ref@jnl{ARA\&A}}% 
          % Annual Review of Astron and Astrophys 
\newcommand\apj{\ref@jnl{ApJ}}% 
          % Astrophysical Journal 
\newcommand\apjl{\ref@jnl{ApJ}}% 
          % Astrophysical Journal, Letters 
\newcommand\apjs{\ref@jnl{ApJS}}% 
          % Astrophysical Journal, Supplement Series
\newcommand\ao{\ref@jnl{Appl.~Opt.}}% 
          % Applied Optics 
\newcommand\apss{\ref@jnl{Ap\&SS}}% 
          % Astrophysics and Space Science 
\newcommand\aap{\ref@jnl{A\&A}}% 
          % Astronomy and Astrophysics           
\newcommand\aapr{\ref@jnl{A\&A~Rev.}}% 
          % Astronomy and Astrophysics Reviews 
\newcommand\aaps{\ref@jnl{A\&AS}}% 
          % Astronomy and Astrophysics, Supplement Series
\newcommand\azh{\ref@jnl{AZh}}% 
          % Astronomicheskii Zhurnal 
\newcommand\baas{\ref@jnl{BAAS}}% 
          % Bulletin of the AAS 
\newcommand\chjaa{\ref@jnl{ChJAA\,(Chin. J. Astron. Astrophys.)}}
\newcommand\cjaa {\ref@jnl{ChJAA\,(Chin. J. Astron. Astrophys.)}}
          % Chinese Journal Astronomy Astrophysics   
\newcommand\ibvs{\ref@jnl{IBVS}}                 
          % Infoormation Bulletin on Variable Stars 
\newcommand\jrasc{\ref@jnl{JRASC}}% 
          % Journal of the RAS of Canada 
\newcommand\memras{\ref@jnl{MmRAS}}% 
          % Memoirs of the RAS 
\newcommand\mnras{\ref@jnl{MNRAS}}% 
          % Monthly Notices of the RAS 
\newcommand\pra{\ref@jnl{Phys.~Rev.~A}}% 
          % Physical Review A: General Physics 
\newcommand\prb{\ref@jnl{Phys.~Rev.~B}}% 
          % Physical Review B: Solid State 
\newcommand\prc{\ref@jnl{Phys.~Rev.~C}}% 
          % Physical Review C 
\newcommand\prd{\ref@jnl{Phys.~Rev.~D}}% 
          % Physical Review D 
\newcommand\pre{\ref@jnl{Phys.~Rev.~E}}% 
          % Physical Review E 
\newcommand\prl{\ref@jnl{Phys.~Rev.~Lett.}}% 
          % Physical Review Letters 
\newcommand\pasp{\ref@jnl{PASP}}% 
          % Publications of the ASP 
\newcommand\pasj{\ref@jnl{PASJ}}% 
          % Publications of the ASJ 
\newcommand\qjras{\ref@jnl{QJRAS}}% 
          % Quarterly Journal of the RAS 
\newcommand\raa {\ref@jnl{Research in Astron. Astrophys.\,(RAA)}}
          % Research in Astronomy Astrophysics 
\newcommand\skytel{\ref@jnl{S\&T}}% 
          % Sky and Telescope 
\newcommand\solphys{\ref@jnl{Sol.~Phys.}}% 
          % Solar Physics 
\newcommand\sovast{\ref@jnl{Soviet~Ast.}}% 
          % Soviet Astronomy 
\newcommand\ssr{\ref@jnl{Space~Sci.~Rev.}}% 
          % Space Science Reviews 
\newcommand\zap{\ref@jnl{ZAp}}% 
          % Zeitschrift fuer Astrophysik 
\newcommand\nat{\ref@jnl{Nature}}% 
          % Nature 
\newcommand\iaucirc{\ref@jnl{IAU~Circ.}}% 
          % IAU Cirulars 
\newcommand\aplett{\ref@jnl{Astrophys.~Lett.}}% 
          % Astrophysics Letters 
\newcommand\apspr{\ref@jnl{Astrophys.~Space~Phys.~Res.}}% 
          % Astrophysics Space Physics Research 
\newcommand\bain{\ref@jnl{Bull.~Astron.~Inst.~Netherlands}}% 
          % Bulletin Astronomical Institute of the Netherlands 
\newcommand\fcp{\ref@jnl{Fund.~Cosmic~Phys.}}% 
          % Fundamental Cosmic Physics 
\newcommand\gca{\ref@jnl{Geochim.~Cosmochim.~Acta}}% 
          % Geochimica Cosmochimica Acta 
\newcommand\grl{\ref@jnl{Geophys.~Res.~Lett.}}% 
          % Geophysics Research Letters 
\newcommand\jcp{\ref@jnl{J.~Chem.~Phys.}}% 
          % Journal of Chemical Physics 
\newcommand\jgr{\ref@jnl{J.~Geophys.~Res.}}% 
          % Journal of Geophysics Research 
\newcommand\jqsrt{\ref@jnl{J.~Quant.~Spec.~Radiat.~Transf.}}% 
          % Journal of Quantitiative Spectroscopy and Radiative Trasfer 
\newcommand\memsai{\ref@jnl{Mem.~Soc.~Astron.~Italiana}}% 
          % Mem. Societa Astronomica Italiana 
\newcommand\nphysa{\ref@jnl{Nucl.~Phys.~A}}% 
          % Nuclear Physics A 
\newcommand\physrep{\ref@jnl{Phys.~Rep.}}% 
          % Physics Reports 
\newcommand\physscr{\ref@jnl{Phys.~Scr}}% 
          % Physica Scripta 
\newcommand\planss{\ref@jnl{Planet.~Space~Sci.}}% 
          % Planetary Space Science 
\newcommand\procspie{\ref@jnl{Proc.~SPIE}}% 
          % Proceedings of the SPIE 
\newcommand\sci{\ref@jnl{Sci.}}          
          % Science
\newcommand\na{\ref@jnl{New Astron.}}
          % New Astronomy 
\newcommand\nar{\ref@jnl{New Astron. Rev.}}
          % New Astronomy Review
\newcommand\actaa{\ref@jnl{Acta Astronomica}}
          % Acta Astronomica
\newcommand\jcap{\ref@jnl{J. Cosmol. Astropart. Phys.}}
          % Acta Astronomica
\newcommand\pasa{\ref@jnl{PASA}}%

\newcommand\caa{\ref@jnl{Chinese Astronomy and Astrophysics}}
  % Publications of the Astron. Soc. of Australia
\let\astap=\aap 
\let\aas=\aaps
\let\apjlett=\apjl 
\let\apjsupp=\apjs 
\let\applopt=\ao



%%%%%% by zjz
\newcommand{\cas}{Chinese Academy of Sciences}

\newcommand{\nao}{ National Astronomical Observatories, 
\cas, Beijing~ 100012, China}

\newcommand{\pmo}{Purple Mountain Observatory,  Chinese Academy of 
          Sciences, Nanjing~ 210008, China}
\newcommand{\sho}{Shanghai Astronomical Observatory, 
          Chinese Academy of 
          Sciences, Shanghai~ 200030, China}
\newcommand{\yuo}{Yunnan Observatory,  Chinese Academy of 
          Sciences, Kunming~ 650011, China}

\newcommand{\ust}{Centre for Astrophysics, University of 
          Sciences and  Technology of China, Hefei~ 230026, China}

\newcommand{\nua}{Department of Astronomy, Nanjing
University, Nanjing~ 210093, China}


\newcommand{\pka}{Department of Astronomy, Peking
University, Beijing~ 100871, China}

\newcommand{\geo}{Department of Geophysics, Peking
University, Beijing~ 100871, China}

\newcommand{\bac}{Chinese Academy of Sciences-Peking University Joint 
Beijing Astrophysics Center,  Beijing~ 100871, China}

\newcommand{\hep}{Institute of High Energy Physics,  Chinese 
          Academy of Sciences, Beijing~ 100039, China}

\newcommand{\bnua}{Department of Astronomy, Beijing Normal 
          University, Beijing~ 100875, China}

\newcommand{\nsfc}{National Natural Science Foundation of China}



%%%%% by Li Xianghua
%\usepackage{color}
\usepackage[dvipsnames]{xcolor}
%\usepackage{colordvi}
\usepackage{ulem}
\RequirePackage{lineno}
\newcommand{\del}[1]{{\color{red}{\sout{\,#1}}}}
\newcommand{\de}[1]{{\color{Maroon}{\sout{\,#1}}}}
%\newcommand{\add}[1]{\Blue{\uline{#1}}}
\newcommand{\add}[1]{{\color{blue}{\uline{\,#1}}}}
%\newcommand{\ad}{\add}
\newcommand{\aq}[1]{{\color{magenta}{\uwave{\,#1}}}}
\def\S{Section}
%\newcommand{\qug}[1]{{\color{green}{\uwave{#1}}}}
\newcommand{\putq}[1]{\marginpar{~~~~~~#1}}
\normalem
\newcommand{\hii}{H\,{\normalsize II}}

%added by LIXH on Nov 20, 2017
\usepackage{subcaption}
\captionsetup{compatibility=false}
%=======================================

%============================================================
% Chinese astronomical affiliates -- not encouraged to use
%============================================================
% removed

\uchyph=0
\endinput
%%
%% End of file `raa.cls'.
