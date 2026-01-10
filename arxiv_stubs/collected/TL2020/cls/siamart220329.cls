%%
%% This is file `siamart220329.cls', based on article.cls
%% Revision of siam macros for use with LaTeX 2e
%% 
%% March 2022
%%
%% You are not allowed to change this file. 
%% 
%% You are allowed to distribute this file under the condition that 
%% it is distributed together with all of the files in the siam macro 
%% distribution. These are:
%%
%% * siamart220329.cls: Main LaTeX class file (this file)
%% * siamplain.bst: Bibliographic style file for BibTeX
%% * docsiamart.tex: Produces documentation
%% * docsiamart.pdf: Documentation
%% * references.bib: BibTeX database for documentation and examples
%% * ex_article.tex: Template for article
%% * ex_supplement.tex: Template for supplement
%% * ex_shared.tex: Template for article/supplement shared info
%%
%% If you receive only some of these files from someone, complain! 
%% 
%% Please submit suggestions for changes to tex@siam.org.
%% 
%% You are NOT ALLOWED to distribute this file alone. You are NOT 
%% ALLOWED to take money for the distribution or use of either this 
%% file or a changed version, except for a nominal charge for copying 
%% etc. 
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
%%
% [[[TODO: Update date and version in next line]]]
\ProvidesClass{siamart220329}[2022/03/29 v1.4.4 LaTeX document e-class]
%%
%% >>jeh>> --- Modified Spring 2022 ---
%%
%% Changover from using "AMS subject classifications" to "MSC codes".
%%
%% A correction needed to bypass a recent change to the eqnarray environment.
%%
%% <<tgk<<
%%
\RequirePackage[leqno]{amsmath}[2.14]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
%_%_%_%_%add class option to change hyperref driver for Bakoma
\newif\if@bakoma
\@bakomafalse
%_%_%_%_%add class option to turn of hypdvips
\newif\if@nohypdvips
\@nohypdvipsfalse
%%
%% >>tgk>> --- Removed Summer 2015 --- %back in Winter 2017---MSC
%%
\newif\if@oneeqnum
\@oneeqnumfalse
\newif\if@onetabnum
\@onetabnumfalse
\newif\if@onefignum
\@onefignumfalse
\newif\if@onealgnum
\@onealgnumfalse
\newif\if@onethmnum
\@onethmnumfalse
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for "review" class option to turn on features like line
%% numbers for paper under review.
\newif\if@review
\@reviewfalse
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for "supplement" class option to change title and labels
%% appropriately for supplemental materials.
\newif\if@supplement
\@supplementfalse
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for "hidelinks" class option to hide hyperlinks.
\newif\if@hidelinks
\@hidelinksfalse
%%
%% <<tgk<<
%%
%_%_%_%_%
\newif\if@translated
\@translatedfalse
%_%_%_%_%
%\newif\if@openbib
%\@openbibfalse
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
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for new class options
\DeclareOption{review}{\@reviewtrue}
\DeclareOption{supplement}{\@supplementtrue}
\DeclareOption{hidelinks}{\@hidelinkstrue}
\DeclareOption{bakoma}{\@bakomatrue}
\DeclareOption{nohypdvips}{\@nohypdvipstrue}
%%
%% <<tgk<<
%%
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
%%
%% >>tgk>> --- Removed Summer 2015 --- %back in Winter 2017---JEH
%%
% \DeclareOption{leqno}{\input{leqno.clo}}
% \DeclareOption{subeqn}{\input{subeqn.clo}}
\DeclareOption{oneeqnum}{\@oneeqnumtrue}
\DeclareOption{onetabnum}{\@onetabnumtrue}
\DeclareOption{onefignum}{\@onefignumtrue}
\DeclareOption{onealgnum}{\@onealgnumtrue}
\DeclareOption{onethmnum}{\@onethmnumtrue}
%%
%% <<tgk<<
%%
\DeclareOption{translated}{\@translatedtrue} % jan 7 2004
%\DeclareOption{openbib}{\@openbibtrue}
\ExecuteOptions{letterpaper,10pt,twoside,onecolumn,leqno,draft,notitlepage}
\ProcessOptions
%
% eliminate siam10.clo altogether:
%%%%%%%%%%%%%%%%%\input{siam1\@ptsize.clo}
\renewcommand{\normalsize}{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@ %5\p@ \@plus1\p@ \@minus2.5\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@ %5\p@ \@plus1\p@ \@minus2.5\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\newcommand{\small}{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@ %4\p@ \@plus2\p@ \@minus2\p@
               \parsep \z@ %2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand{\footnotesize}{%
   \@setfontsize\footnotesize\@viiipt{9.5}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@ %\abovedisplayskip
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@ %\belowdisplayskip
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@
               \parsep \z@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand{\scriptsize}{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand{\tiny}{\@setfontsize\tiny\@vpt\@vipt}
\newcommand{\large}{\@setfontsize\large\@xiipt{14}}
\newcommand{\Large}{\@setfontsize\Large\@xivpt{18}}
\newcommand{\LARGE}{\@setfontsize\LARGE\@xviipt{22}}
\newcommand{\huge}{\@setfontsize\huge\@xxpt{25}}
\newcommand{\Huge}{\@setfontsize\Huge\@xxvpt{30}}
\if@twocolumn
  \setlength\parindent{1em}
\else
  \setlength\parindent{.25in}
\fi
\setlength\headheight{10\p@}
\setlength\headsep   {.2in}
%\setlength\topskip   {10\p@}
\setlength\footskip{.2in}
\if@compatibility 
 \setlength\maxdepth{4\p@}
\else
 \setlength\maxdepth{.5\topskip} 
\fi
\setlength\@maxdepth\maxdepth
\if@compatibility
  \if@twocolumn
    \setlength\textwidth{410\p@}
  \else
    \setlength\textwidth{5.125in}
  \fi
\else
  \if@twocolumn
    \setlength\textwidth{410\p@}
  \else
    \setlength\textwidth{5.125in}
  \fi
\fi
%\if@compatibility\else
%  \@settopoint\textwidth
%\fi
\if@compatibility
  \setlength\textheight{8.25in}
\else
  \setlength\textheight{8.25in}
\fi
%\addtolength\textheight{\topskip}
\if@compatibility
  \if@twoside
%     \setlength\oddsidemargin   {.5in}
%     \setlength\evensidemargin  {.5in}
     \setlength\marginparwidth {1.25in}
  \else
%     \setlength\oddsidemargin   {.5in}
%     \setlength\evensidemargin  {.5in}
     \setlength\marginparwidth  {1.25in}
  \fi
  \if@twocolumn
     \setlength\oddsidemargin  {30\p@}
     \setlength\evensidemargin {30\p@}
     \setlength\marginparwidth {48\p@}
  \fi
\else
  \if@twoside
%     \setlength\oddsidemargin   {.5in}
%     \setlength\evensidemargin  {.5in}
     \setlength\marginparwidth {1.25in}
  \else
%     \setlength\oddsidemargin   {.5in}
%     \setlength\evensidemargin  {.5in}
     \setlength\marginparwidth {1.25in}
  \fi
  \@settopoint\oddsidemargin
  \@settopoint\marginparwidth
\fi
\if@twocolumn
  \setlength\marginparsep {10\p@}
\else
  \setlength\marginparsep{11\p@}
\fi
\setlength\marginparpush{5\p@}
\if@compatibility
  \setlength\topmargin{\z@}
\else
\setlength\topmargin {\z@}
%  \@settopoint\topmargin
\fi

%% >>tgk>> --- Added Summer 2015 ---
%%
%% Fix to make bookmarks show up when using pdflatex (+hypertex).
\setcounter{tocdepth}{3}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% First step to adding the ntheorem package for theorems, etc. Second
%% step is further down below. Need to split them because this needs
%% to be loaded *before* cleveref and lineno.
\RequirePackage[amsmath,thmmarks,hyperref]{ntheorem}[1.33]
%%
%% <<tgk<<
%%

\setlength\footnotesep{6.65\p@}
\skip\footins 13\p@ \@plus 4\p@ \@minus 2\p@
\setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep   {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{\z@}
\def\@listI{\leftmargin\leftmargini
            \parsep \z@
            \topsep \z@
            \itemsep \parsep}
\let\@listi\@listI
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    \z@
              \parsep    \z@
              \itemsep   \parsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    \z@
              \parsep    \z@
              \partopsep \z@
              \itemsep   \topsep}
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
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
%%
%% >>tgk>> Modified Summer 2015
%%
\setlength\parskip{0\p@}
%%
%% <<tgk<<
%%
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

%\renewcommand{\ps@plain}{\let\@mkboth\@gobbletwo%
%  \renewcommand{\@oddhead}{}%
%  \renewcommand{\@evenhead}{}%
%  \renewcommand{\@evenfoot}{\hfil\footnotesize\textrm{\thepage}\hfil}%
%  \renewcommand{\@oddfoot}{\@evenfoot}}
%  
%  \def\copyrightfooter#1{\gdef\@copyrightfooter{#1}}
%  \gdef\@copyrightfooter{}
%  
%%%add copyright footer, per SIAM
%  \renewcommand{\ps@plain}{\let\@mkboth\@gobbletwo%
%  \renewcommand{\@oddhead}{}%
%  \renewcommand{\@evenhead}{}%
%  \renewcommand{\@evenfoot}{\hfil\vtop{\hsize\textwidth\centering\footnotesize\textrm{\thepage}\\[4pt] \@copyrightfooter}\hfil}%
%  \renewcommand{\@oddfoot}{\@evenfoot}}

\newlength{\fromfoliotocopyright}
\setlength{\fromfoliotocopyright}{.75in}

\newcommand{\footercopyright}{}

\newcommand{\f@@terwithc@pyright}[1]{\raisebox{0pt}[\height][0pt]{\vtop{%
  \hbox to \textwidth{\normalfont\footnotesize\hfil\rule{0pt}{14.4pt}#1\hfil}%
  \vskip\fromfoliotocopyright%
  \hbox to \textwidth{\normalfont\normalsize\hfil\footercopyright\hfil}%
  }}%
}

\renewcommand{\ps@plain}{\let\@mkboth\@gobbletwo%
  \renewcommand{\@oddhead}{}%
  \renewcommand{\@evenhead}{}%
  \renewcommand{\@evenfoot}{\f@@terwithc@pyright{\thepage}}%
  \renewcommand{\@oddfoot}{\@evenfoot}}

\def\ps@headings{%
      \renewcommand{\@oddfoot}{\hfil\vtop{\hsize\textwidth\centering\footnotesize\textrm{\strut}\\[4pt] \@copyrightfooter}\hfil}\let\@evenfoot\@oddfoot%
      \def\@evenhead{\rlap{\thepage}\hfil\upshape\footnotesize\leftmark\hfil}%          %!
      \def\@oddhead{\hbox{}\hfil{\upshape\footnotesize\rightmark}\hfil\llap{\thepage}}% %!
      \let\@mkboth\markboth
      \def\sectionmark##1{%
        \markboth {\uppercase{\ifnum \c@secnumdepth >\z@
            \thesection.\hskip 1em\relax\fi
            ##1}}{}}%
      \def\subsectionmark##1{%
        \markright {\ifnum \c@secnumdepth >\@ne
            \thesubsection\hskip 1em\relax \fi
            ##1}}}
            

%\def\ps@myheadings{%
%    \renewcommand{\@oddfoot}{\hfil\vtop{\hsize\textwidth\centering\footnotesize\textrm{\strut}\\[4pt] \@copyrightfooter}\hfil}\let\@evenfoot\@oddfoot%
%    \def\@evenhead{\rlap{\thepage}\hfil\upshape\footnotesize\leftmark\hfil}%          %!
%    \def\@oddhead{\hbox{}\hfil{\upshape\footnotesize\rightmark}\hfil\llap{\thepage}}% %!
%    \let\@mkboth\@gobbletwo
%    \let\sectionmark\@gobble
%    \let\subsectionmark\@gobble
%    }

\def\ps@myheadings{%
    \def\@evenfoot{\f@@terwithc@pyright{}}%
    \let\@oddfoot\@evenfoot
    \def\@evenhead{\rlap{\thepage}\hfil\upshape\footnotesize\leftmark\hfil}%          %!
    \def\@oddhead{\hbox{}\hfil{\upshape\footnotesize\rightmark}\hfil\llap{\thepage}}% %!
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }


\newcommand\maketitle{\par
  \begingroup\def\@fnsymbol##1{\ensuremath{\ifcase##1\or *\or \dagger\or \ddagger\or
   \mathsection\or \mathparagraph\or \|\or \#\or \dagger\dagger
   \or \ddagger\ddagger\else\@ctrerr\fi}}
    \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
    \def\@makefnmark{\hbox to\z@{$\m@th^{\@thefnmark}$\hss}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
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
%_%_%_%_%
%_%_%_%_% Macros for subtitle (subauthor?), altered slugline/slugger for translated version
%_%_%_%_%
\long\def\subtitle#1{\gdef\@subtitle{\par\vskip8pt\footnotesize#1}}
\def\@subtitle{}
%
\long\def\supertitle#1{\gdef\@supertitle{\par\bfseries#1\vskip17.5pt\par}}
\def\@supertitle{}
%_%_%_%_%
%_%_%_%_%
%_%_%_%_%
%
\def\@translation{}
%

\def\copyrightlineone#1{\gdef\@copyrightlineone{#1}}
\def\copyrightlinetwo#1{\gdef\@copyrightlinetwo{#1}}

\def\@copyrightlineone{Society for Industrial and Applied Mathematics}
\def\@copyrightlinetwo{}


\def\slugger#1#2#3#4#5{\gdef\@slugger{\thispagestyle{plain}%
\vspace*{-36pt}
{\sixptsize\baselineskip10pt
\noindent
\expandafter\csname#1\endcsname.\hspace*{\fill}
{\scriptsize{\copyright}} #2 \@copyrightlineone\vspace*{-1.2mm}\\
Vol.\ #3, No.\ #4, pp.\ #5
\hspace*{\fill} \@translation\@copyrightlinetwo\par}
\normalsize\vskip19.7pt}}
%
\if@translated
\newcommand\tpa{T{\fiveptsize HEORY}~P{\fiveptsize ROBAB.}~A{\fiveptsize PPL}}% added 1/7/04
\def\@translation{Translated from Russian Journal}  
\else%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\tpa{T{\fiveptsize HEORY}~P{\fiveptsize ROBAB.}~A{\fiveptsize PPL}}% added 1/7/04  
\fi
%
\def\@slugger{}
\def\@slugline{}
%_%_%_%_%
%_%_%_%_%
%_%_%_%_%
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for "supplement" class option, to change the title and labels.
\def\siampretitle{}
\def\siamprelabel{}
\if@supplement
\def\siampretitle{Supplementary Materials: }
\def\siamprelabel{SM}
\fi
%%
%% <<tgk<<
%%
\def\@maketitle{%
  \null
\@slugger
  \begin{center}%
\@supertitle%
%%
%% >>tgk>> --- Modified Summer 2015 ---
%%
%% Support for supplementary materials
    {\bfseries\MakeUppercase{\siampretitle}\@ucnothanks{\@title}\par}%
%%
%% <<tgk<< 
%%
    \vskip .075in%
    {\footnotesize
      \spaceskip=1.5\fontdimen2\the\font
      \def\and{\ \scriptsize AND }
      \@tempswafalse\expandafter\@doauth\@author\and\relax}%
\@subtitle%
  \end{center}%
  \par
  \vskip .11in}
\def\@ucnothanks#1{\expandafter\@ucnt#1\thanks\relax}
%%
%% >>tgk>> --- Modified Summer 2015 ---
%%
%% Fixed capitalization to work with macro for title
\def\@ucnt#1\thanks{\uppercase\expandafter{#1}\futurelet\@tempa\@ucnta}
%%
%% <<tgk<< 
%%
\def\@ucnta{\ifx\@tempa\relax\else\@ucntb\fi}
\def\@ucntb#1\thanks\relax{\thanks{#1}}
\def\@doauth#1\and{\let\@nextdoa=\@doauth
 \def\@tempc{\@ucnothanks{#1}}
 \futurelet\@tempa\@doautha}
\def\@doautha{\ifx\@tempa\relax
  \if@tempswa {\and}\fi
  \let\@nextdoa=\relax
 \else
  \if@tempswa \gdef\and{,\ \scriptsize AND }, \fi
 \fi
 \@tempc\unskip\@tempswatrue\@nextdoa}
\let\and=\relax

\newcommand{\sixptsize}{%
   \@setfontsize\sixptsize{6}{8}}

%%create five-point size
\newcommand{\fiveptsize}{%
   \@setfontsize\fiveptsize{5}{7}}


\newcommand\simac{SIAM J{\fiveptsize OURNAL} M{\fiveptsize ACRO}}
\newcommand\siap{SIAM J.\ A{\fiveptsize PPL}.\ M{\fiveptsize ATH}}
\newcommand\sicomp{SIAM J.\ C{\fiveptsize OMPUT}}
\newcommand\sicon{SIAM J.\ C{\fiveptsize ONTROL}  O{\fiveptsize PTIM}}
\newcommand\sidma{SIAM J.\ D{\fiveptsize ISCRETE} M{\fiveptsize ATH}}
\newcommand\sima{SIAM J.\ M{\fiveptsize ATH}.\ A{\fiveptsize NAL}}
\newcommand\simax{SIAM J.\ M{\fiveptsize ATRIX} A{\fiveptsize NAL}.\ A{\fiveptsize PPL}}
\newcommand\sinum{SIAM J.\ N{\fiveptsize UMER}.\ A{\fiveptsize NAL}}
\newcommand\siopt{SIAM J.\ O{\fiveptsize PTIM}}
\newcommand\sisc{SIAM J.\ S{\fiveptsize CI}.\ C{\fiveptsize OMPUT}}
\newcommand\sirev{SIAM R{\fiveptsize EV}}
\newcommand\mms{M{\fiveptsize ULTISCALE}~M{\fiveptsize ODEL}.~S{\fiveptsize IMUL}} % Added 9/17/02  
   
        
\setcounter{secnumdepth}{3}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
%%
%% >>tgk>> --- Modified Summer 2015 ---
%%
%% Adding supplement support.
\renewcommand\thesection       {\siamprelabel\arabic{section}}
%%
%% <<tgk<<
%%
\renewcommand\thesubsection    {\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection {\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph     {\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph  {\theparagraph.\arabic{subparagraph}}




\def\nopunct{\def\@mypunct{}}
\gdef\@mypunct{.}
\def\punct{\gdef\@mypunct{.}}


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
        \def\@svsechd{#6\hskip #3\@svsec #8\@mypunct\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}
\def\@ssect#1#2#3#4#5{\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M
#5\@mypunct\par}\endgroup
   \else \def\@svsechd{#4\hskip #1\relax #5\@mypunct}\fi
    \@xsect{#3}}

              
\newcommand\section{\@startsection{section}{1}{.25in}%
                                   {1.3ex \@plus .5ex \@minus .2ex}%
                                   {-.5em \@plus -.1em}%
                                   {\reset@font\normalsize\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{.25in}%
                                     {1.3ex\@plus .5ex \@minus .2ex}%
                                     {-.5em \@plus -.1em}%
                                     {\reset@font\normalsize\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{.25in}%
                                     {1.3ex\@plus .5ex \@minus .2ex}%
                                     {-.5em \@plus -.1em}%
                                     {\reset@font\normalsize\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{.25in}%
                                    {\parskip}%
                                    {-.5em plus -.1em}%
                                    {\reset@font\normalsize\itshape}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {\parskip}%
                                       {-.5em plus -.1em}%
                                      {\reset@font\normalsize\itshape}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {0.5in}
\fi
\setlength\leftmarginii  {22pt}
\setlength\leftmarginiii {18.7pt}
\setlength\leftmarginiv  {17pt}
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
\newcommand\labelenumi{\textup{\theenumi.}}
\newcommand\labelenumii{\textup{(\theenumii)}}
\newcommand\labelenumiii{\textup{\theenumiii.}}
\newcommand\labelenumiv{\textup{\theenumiv.}}
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
                                
\newenvironment{@abssec}[1]{%
     \if@twocolumn
       \section*{#1}%
     \else
       \vspace{.05in}\footnotesize
       \parindent .2in
         {\upshape\bfseries #1. }\ignorespaces 
     \fi}
     {\if@twocolumn\else\par\vspace{.1in}\fi}

\newenvironment{@doisec}[1]{%
     \if@twocolumn
       \section*{#1}%
     \else
       \vspace{.05in}\footnotesize
       \parindent .2in
         {\upshape\bfseries #1. }\ignorespaces\ignorespaces
     \fi}
     {\if@twocolumn\else\par\vspace{.1in}\fi}

\newenvironment{abstract}{\begin{@abssec}{\abstractname}}{\end{@abssec}}
\newenvironment{keywords}{\begin{@abssec}{\keywordsname}}{\end{@abssec}}
\newenvironment{keyword}{\begin{@abssec}{\keywordname}}{\end{@abssec}}
\newenvironment{MSCcodes}{\begin{@abssec}{\MSCcodesname}}{\end{@abssec}}
\newenvironment{MSCcode}{\begin{@abssec}{\MSCcodename}}{\end{@abssec}}
\newenvironment{AMS}{\begin{@abssec}{\AMSname}}{\end{@abssec}}
\newenvironment{AM}{\begin{@abssec}{\AMname}}{\end{@abssec}}
%\newenvironment{PII}{\begin{@abssec}{\PIIname}}{\end{@abssec}}
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
               
%\def\@begintheorem#1#2{\vspace{\abovedisplayskip}\par\bgroup{\scshape #1\ #2. }\it\ignorespaces}
%\def\@opargbegintheorem#1#2#3{\par\bgroup%
%   {\scshape #1\ #2\ ({\upshape #3}). }\it\ignorespaces}
%\def\@endtheorem{\egroup\vspace{\belowdisplayskip}}
%\def\proof{\par{\it Proof}. \ignorespaces}
%
%\def\endproof{\vbox{\hrule height0.6pt\hbox{%
%   \vrule height1.3ex width0.6pt\hskip0.8ex
%   \vrule width0.6pt}\hrule height0.6pt
%  }}

\newlength{\@sectionspace}
\setlength{\@sectionspace}{1.3ex \@plus .5ex \@minus .2ex} %the space added before a new section
\newlength{\@negsectionspace}
\setlength{\@negsectionspace}{-1.3ex \@plus -.5ex \@minus -.2ex} %its negation

%%
%% >>jeh>> --- Added Summer 2016 ---
%%
%% Adding ORCID support.

\newcommand{\orcid}[1]{\ignorespaces}

%%
%% >>tgk>> --- Removed Summer 2015 ---
%% 
%\newcommand{\insertsectionspace}{\addvspace{\@sectionspace}}
%\newcommand{\removesectionspace}{\vspace{\@negsectionspace}} %I didn't end up needing these, but they might be needed somewhere
%
% \def\@begintheorem#1#2{\par\addvspace{\@sectionspace}{\scshape #1\ #2. }\itshape\ignorespaces}
%
% \def\@opargbegintheorem#1#2#3{\par\addvspace{\@sectionspace}{\scshape #1\ #2\ ({\upshape #3}). }\itshape\ignorespaces}
%
% \def\@endtheorem{\par\addvspace{\@sectionspace}}
%
% \def\proof{\par\addvspace{\@sectionspace}\textit{Proof}. \ignorespaces}
%
% \newcommand{\@proofbox}{\vbox{\hrule height0.6pt\hbox{\vrule height1.3ex width0.6pt\hskip0.8ex\vrule width0.6pt}\hrule height0.6pt}}
%
% \def\endproof{\ifmmode\@proofbox\else\@proofbox\par\addvspace{\@sectionspace}\fi}
%
% \if@onethmnum
%   \newtheorem{theorem}{Theorem}
%   \newtheorem{lemma}[theorem]{Lemma}
%   \newtheorem{corollary}[theorem]{Corollary}
%   \newtheorem{proposition}[theorem]{Proposition}
%   \newtheorem{definition}[theorem]{Definition}
% \else
%   \newtheorem{theorem}{Theorem}[section]
%   \newtheorem{lemma}[theorem]{Lemma}
%   \newtheorem{corollary}[theorem]{Corollary}
%   \newtheorem{proposition}[theorem]{Proposition}
%   \newtheorem{definition}[theorem]{Definition}
% \fi
%%
%% <<tgk<<
%%

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

%not comparing against \@tempb anymore

%\ifx\eqnarray\@tempb    % Try the default eqnarray environment
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
%\else    \typeout{Warning: Unable to fix unknown version of \string\eqnarray.}
%\fi
 
\def\@tempb{}

%%
%% >>tgk>> --- Removed Summer 2015 ---
%%
%% New Mathops.

% \newcommand\const{\mathop{\operator@font const}\nolimits}
% \newcommand\diag{\mathop{\operator@font diag}\nolimits}
% \newcommand\grad{\mathop{\operator@font grad}\nolimits}
% \newcommand\Range{\mathop{\operator@font Range}\nolimits}
% \newcommand\rank{\mathop{\operator@font rank}\nolimits}
% \newcommand\supp{\mathop{\operator@font supp}\nolimits}
%%
%% <<tgk<<
%%

%%
%% >>tgk>> --- Modified Summer 2015 ---
%%
%% The original changes to introduce the appendix didn't work
%% correctly. In particular, calling \section*{Acknowledgments} after
%% declaring \appendix produced an appendix with a letter (i.e.,
%% Appendix B) but no title --- exactly the reverse of what we would
%% expect. Now, using \section* produces what you would expect, i.e.,
%% just the title "Acknowledgments". The SIAM style guide also allows
%% a numbered but untitled section, so the command \appendixnotitle is
%% defined to facilitate that. Not sure it should be explicitly
%% documented??
%%

\newcommand\gobblepars{%
    \@ifnextchar\par%
        {\expandafter\gobblepars\@gobble}%
        {}}

\newcommand\appendix{%
  \setcounter{section}{0}
  \setcounter{subsection}{0}
  \renewcommand\thesection{\Alph{section}}
  \renewcommand{\section}{\secdef\append\sappend}
  \newcommand{\appendixnotitle}{%
    \refstepcounter{section}%
    {\par\addvspace{\@sectionspace} 
      \reset@font\normalsize\bfseries\appendixname\ \thesection. \gobblepars}%
    \addcontentsline{toc}{section}{\appendixname~\thesection}%
    }
}

\newcommand\append[2][?]{%
  \refstepcounter{section}%
  {\par\addvspace{\@sectionspace} 
    \reset@font\normalsize\bfseries\appendixname\ \thesection. #2\@mypunct{} }%
  \addcontentsline{toc}{section}{\appendixname~\thesection. #2}%
  \gobblepars
}

\newcommand\sappend[1]{%
  {\par\addvspace{\@sectionspace} 
    \reset@font\normalsize\bfseries#1\@mypunct{} }%
  \addcontentsline{toc}{section}{#1}%
  \gobblepars
}
%% 
%% <<tgk<<
%%

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}


\newcounter{figure}
%%
%% >>tgk>> --- Modified Summer 2015 ---
%%
%% Added \siamprelabel for supplement.
\renewcommand\thefigure{\siamprelabel\@arabic\c@figure}
%%
%% <<tgk<<
%%
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
%%
%% >>tgk>>  Modified Summer 2015
%%
%% Adding support for supplement
\renewcommand{\thetable}{\siamprelabel\@arabic\c@table}
%%
%% <<tgk<<
%%
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
    \setbox\@tempboxa\hbox{{\normalfont\scshape #1}. {\normalfont\itshape #2}}%
    \ifdim \wd\@tempboxa >\hsize
      {\normalfont\scshape #1}. {\normalfont\itshape #2}\par
    \else
      \global\@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
  \else
    \hbox to\hsize{\hfil{\normalfont\scshape #1}\hfil}%
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
     \footnotesize\uppercase\expandafter{\refname}%
     \addcontentsline{toc}{section}{References}
     \end{center}
     \@mkboth{\uppercase\expandafter{\refname}}{\uppercase\expandafter{\refname}}
     \addvspace{.15in}\nopagebreak%
%%
%% >>tgk>> --- Modified Summer 2015
%%
%% Adding supplement support by inserting \siamprelabel
      \list{\@biblabel{\siamprelabel\arabic{enumi}}}%
%%
%% <<tgk<<
%%
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
  \hrule width .5in
  \kern 2.6\p@}
\long\def\@makefntext#1{%
    \parindent .25in%
    \noindent
    \hbox to .25in{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\keywordsname{Key words}
\newcommand\keywordname{Key word}
\newcommand\MSCcodesname{MSC codes}
\newcommand\MSCcodename{MSC code}
\newcommand\AMSname{AMS subject classifications}
\newcommand\AMname{AMS subject classification}
%\newcommand\PIIname{PII}
\newcommand\DOIname{DOI\@}
%\newcommand\URL{\protect\\ \hspace*{15.37pt}http://www.siam.org/journals/}
\newcommand\URL[1]{\protect\\ \hspace*{15.37pt}\protect\href{https://doi.org/#1}{https://doi.org/#1}}
\newcommand\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\newcommand\funding[1]{\protect\\ \hspace*{15.37pt}{\bfseries Funding:} #1}
\newcommand\sameauthor{\leavevmode\vrule height 2pt depth -1.6pt width 23pt}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{plain}
\pagenumbering{arabic}      % Arabic page numbers

%%
%% >>tgk>> --- Removed Summer 2015 ---
%%
% \if@compatibility%
% \else
%   \if@oneeqnum
%   \else
%      \@addtoreset{equation}{section}   %  \section resets 'equation' counter
%      \renewcommand{\theequation}{\thesection.\arabic{equation}}  
%   \fi
%
%   \if@onefignum
%   \else
%     \@addtoreset{figure}{section}
%     \renewcommand{\thefigure}{\thesection.\@arabic\c@figure}
%   \fi
%
%   \if@onetabnum
%   \else
%     \@addtoreset{table}{section}
%     \renewcommand{\thetable}{\thesection.\@arabic\c@table}
%   \fi
%
%   \if@onethmnum
%   \else
%     \@addtoreset{theorem}{section}
%     \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
%   \fi
% \fi
%%
%% <<tgk<<
%%

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
%%%



% \def\newarticle{\input{newart.tex}}

% \RequirePackage[dvips]{color}
%%
%% >>tgk>> --- Removed Summer 2015 ---
%%

% %\definecolor{header1}{cmyk}{.9,.5,0,.35}
% %\definecolor{blue1}{cmyk}{.9,.7,0,0}
% %\definecolor{blue2}{cmyk}{.93,.95,.2,.07}
% %\definecolor{maroon}{cmyk}{.4,1,.3,.2}
% %\definecolor{gold1}{cmyk}{.2,.2,1,.1}
% %\definecolor{gray}{cmyk}{0,0,0,.5}
% %\definecolor{green1}{cmyk}{1,0,1,0}
% %\definecolor{proofcolor}{cmyk}{1,0,1,0}
% %\definecolor{red1}{cmyk}{0,1,.8,0}
% %\definecolor{orange1}{cmyk}{0,.55,1,0}
% %\definecolor{strip}{cmyk}{.6,.1,.1,.1}

% \definecolor{header1}{cmyk}{0,0,0,1}
% \definecolor{blue1}{cmyk}{0,0,0,1}
% \definecolor{blue2}{cmyk}{0,0,0,1}
% \definecolor{maroon}{cmyk}{0,0,0,1}
% \definecolor{gold1}{cmyk}{0,0,0,1}
% \definecolor{gray}{cmyk}{0,0,0,1}
% \definecolor{green1}{cmyk}{0,0,0,1}
% \definecolor{proofcolor}{cmyk}{0,0,0,1}
% \definecolor{red1}{cmyk}{0,0,0,1}
% \definecolor{orange1}{cmyk}{0,0,0,1}
% \definecolor{strip}{cmyk}{0,0,0,1}


% \RequirePackage[]{graphics,graphicx}
% \RequirePackage[colorlinks,naturalnames=false,hypertexnames=false,breaklinks]{hyperref}%new
% \urlstyle{same}
% \usepackage{breakurl}%new
% \def\wwwbrowser{C:\string\Program\space
% Files\string\Plus!\string\Microsoft\space
% Internet\string\iexplore.exe}
% %\definecolor{extlink}{cmyk}{.05,1,1,.45}
% %\definecolor{intlink}{cmyk}{1,0,1,.5}
% %\definecolor{softpage}{cmyk}{0,0.01,.05,0}
% \definecolor{extlink}{cmyk}{0,0,0,0.7}
% \definecolor{intlink}{cmyk}{0,0,0,0.7}
% \definecolor{softpage}{cmyk}{0,0,0,0.7}

% \def\@linkcolor{intlink}
% \def\@anchorcolor{black}
% \def\@citecolor{intlink}
% \def\@filecolor{cyan}
% \def\@urlcolor{extlink}
% \def\@menucolor{red}
%%
%% <<tgk<<
%%
%%%\def\@pagecolor{softpage}

%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for cross-reference (xr-hyper).
\RequirePackage{xr-hyper}[6.00]
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
\RequirePackage{ifpdf}[2.3]
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for cross-reference hyperlinks
%% (hyperref). Made it so that it works for both dvi/ps and pdf
%% (ifpdf, breakurl).
%%
\if@bakoma
\RequirePackage[dvips]{hyperref}[6.83]
\else
\RequirePackage{hyperref}[6.83]
\fi
\hypersetup{
  colorlinks=false,
  frenchlinks=false,
  pdfborder={0 0 0},
  naturalnames=false,
  hypertexnames=false,
  breaklinks
}
\urlstyle{same}
\ifpdf
\usepackage{graphics,graphicx}
\usepackage{epstopdf}
\else
\usepackage{graphics,graphicx}
   \RequirePackage{breakurl}[1.40]
   \if@nohypdvips
   \else
   \usepackage{hypdvips}
   \fi
\fi
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%% 
\RequirePackage{xcolor}[2.11]
\colorlet{siaminlinkcolor}{green!50!black}
\colorlet{siamexlinkcolor}{red!50!black}
\colorlet{siamreviewcolor}{black!50}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%% 
%% Add support for color in order to color the hyperlinks.
%% 
\if@hidelinks
\hypersetup{ hidelinks }
\else
\hypersetup{
  colorlinks = true,
  allcolors = siaminlinkcolor,
  urlcolor = siamexlinkcolor,
}
\fi
%%
%% <<tgk<<
%%
\newcommand{\email}[1]{\protect\href{mailto:#1}{#1}}
%%
%% >>tgk>> --- Modified Summer 2015 ---
%% 
\newcommand{\mref}[1]{\burlalt{mailto:#1}{#1}}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Removed Summer 2015 ---
%\newcommand{\web}[1]{\href{#1}{#1}}
%%
%% <<tgk<< 
%%

%%%\pagecolor{softpage}


%%%%to fix link jump to "bottom" of float
\RequirePackage[all]{hypcap} [1.11]

\setlength{\parskip}{1\parskip}

%%
%% >>tgk>> --- Added Summer 2015 ---
%%
% This needs to be loaded *before* cleveref
\RequirePackage{algorithm}[0.1]
\renewcommand{\ALG@name}{Algorithm}
\renewcommand\thealgorithm{\siamprelabel\@arabic\c@algorithm}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Adding cleveref package for smart citations, with customizations to
%% make it act like SIAM expects.
\RequirePackage[capitalize,nameinlink]{cleveref}[0.19]

% Per SIAM Style Manual, "section" should be lowercase
\crefname{section}{section}{sections}
\crefname{subsection}{subsection}{subsections}
\Crefname{section}{Section}{Sections}
\Crefname{subsection}{Subsection}{Subsections}

% Per SIAM Style Manual, "Figure" should be spelled out in references
\Crefname{figure}{Figure}{Figures}

% Per SIAM Style Manual, don't say equation in front on an equation.
\crefformat{equation}{\textup{#2(#1)#3}}
\crefrangeformat{equation}{\textup{#3(#1)#4--#5(#2)#6}}
\crefmultiformat{equation}{\textup{#2(#1)#3}}{ and \textup{#2(#1)#3}}
{, \textup{#2(#1)#3}}{, and \textup{#2(#1)#3}}
\crefrangemultiformat{equation}{\textup{#3(#1)#4--#5(#2)#6}}%
{ and \textup{#3(#1)#4--#5(#2)#6}}{, \textup{#3(#1)#4--#5(#2)#6}}{, and \textup{#3(#1)#4--#5(#2)#6}}

% But spell it out at the beginning of a sentence.
\Crefformat{equation}{#2Equation~\textup{(#1)}#3}
\Crefrangeformat{equation}{Equations~\textup{#3(#1)#4--#5(#2)#6}}
\Crefmultiformat{equation}{Equations~\textup{#2(#1)#3}}{ and \textup{#2(#1)#3}}
{, \textup{#2(#1)#3}}{, and \textup{#2(#1)#3}}
\Crefrangemultiformat{equation}{Equations~\textup{#3(#1)#4--#5(#2)#6}}%
{ and \textup{#3(#1)#4--#5(#2)#6}}{, \textup{#3(#1)#4--#5(#2)#6}}{, and \textup{#3(#1)#4--#5(#2)#6}}

% Make number non-italic in any environment.
\crefdefaultlabelformat{#2\textup{#1}#3}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Setting up theorems using ntheorem package, customizing to do the
%% indentations and other features that SIAM likes. Also, adding
%% macros that can be use to declare additional theorem-like
%% environments. The \newtheorem calls have to happen /after/ loading
%% cleveref when using ntheorem and sharing the same numbering.

% We fix the default style to have the indents that SIAM wants before
% theorem and proof definitions.
\renewtheoremstyle{plain}% Allow loooong optional labels for theorems???? JR
 {\item[\hskip\labelsep\hskip\parindent \theorem@headerfont ##1\ \textup{##2\theorem@separator}]}%
 {\item[\hskip\labelsep\hskip\parindent \theorem@headerfont ##1\ \textup{##2}]\textup{(##3)\theorem@separator}\ }


\renewtheoremstyle{nonumberplain}%
 {\item[\theorem@headerfont\hskip\labelsep\hskip\parindent ##1\theorem@separator]}%
{\item[\theorem@headerfont\hskip\labelsep\hskip\parindent ##3\theorem@separator]}


% Retained from old style file
\newcommand{\proofbox}{\vbox{\hrule height0.6pt\hbox{\vrule height1.3ex width0.6pt\hskip0.8ex\vrule width0.6pt}\hrule height0.6pt}}

% Extra space around theorem-like environments
\theorempreskip{1ex plus .25ex minus .1ex}
\theorempostskip{1ex plus .25ex minus .1ex}
%\theorempreskip{10\p@ \@plus2\p@ \@minus5\p@}
%\theorempostskip{10\p@ \@plus2\p@ \@minus5\p@}



% Proof environment: No number, italic header, normal body, ends with proofbox.
\theoremstyle{nonumberplain}
\theoremheaderfont{\normalfont\itshape}
\theorembodyfont{\normalfont}
\theoremseparator{.}
\theoremsymbol{\proofbox}
\newtheorem{proof}{Proof}

% Theorem environment: Small-caps header, italize body.
\theoremstyle{plain}
\theoremheaderfont{\normalfont\sc}
\theorembodyfont{\normalfont\itshape}
\theoremseparator{.}
\theoremsymbol{}
\newtheorem{theorem}{Theorem}

% Command to create other theorem-like environments, to be numbered
% along with the theorems.
\newcommand{\newsiamthm}[2]{
  \theoremstyle{plain}
  \theoremheaderfont{\normalfont\sc}
  \theorembodyfont{\normalfont\itshape}
  \theoremseparator{.}
  \theoremsymbol{}
  \newtheorem{#1}[theorem]{#2}
}

% Other predefined theorem-like environments
\newsiamthm{lemma}{Lemma}
\newsiamthm{corollary}{Corollary}
\newsiamthm{proposition}{Proposition}
\newsiamthm{definition}{Definition}

% Command to create remark-like environments, to be numbered
% along with the theorems.
\newcommand{\newsiamremark}[2]{
  \theoremstyle{plain}
  \theoremheaderfont{\normalfont\itshape}
  \theorembodyfont{\normalfont}
  \theoremseparator{.}
  \theoremsymbol{}
  \newtheorem{#1}[theorem]{#2}
}
%%
%% <<tgk<<
%%

%new: make new head for assumptions, remarks, etc. Numbered? Unnumbered?

%%
%% >>tgk>> --- Removed Summer 2015 ---
%%
% %%% create theorems, etc. with upright font, no italic
% \def\newheading#1{%
%   \@ifnextchar[{\@othmup{#1}}{\@nthmup{#1}}}
% \def\@nthmup#1#2{%
%   \@ifnextchar[{\@xnthmup{#1}{#2}}{\@ynthmup{#1}{#2}}}
% \def\@xnthmup#1#2[#3]{%
%   \expandafter\@ifdefinable\csname #1\endcsname
%     {\@definecounter{#1}\@newctr{#1}[#3]%
%      \expandafter\xdef\csname the#1\endcsname{%
%        \expandafter\noexpand\csname the#3\endcsname \@thmcountersep
%           \@thmcounterup{#1}}%
%      \global\@namedef{#1}{\@thmup{#1}{#2}}%
%      \global\@namedef{end#1}{\@endtheoremup}}}
% \def\@ynthmup#1#2{%
%   \expandafter\@ifdefinable\csname #1\endcsname
%     {\@definecounter{#1}%
%      \expandafter\xdef\csname the#1\endcsname{\@thmcounterup{#1}}%
%      \global\@namedef{#1}{\@thmup{#1}{#2}}%
%      \global\@namedef{end#1}{\@endtheoremup}}}
% \def\@othmup#1[#2]#3{%
%   \@ifundefined{c@#2}{\@nocounterr{#2}}%
%     {\expandafter\@ifdefinable\csname #1\endcsname
%     {\global\@namedef{the#1}{\@nameuse{the#2}}%
%   \global\@namedef{#1}{\@thmup{#2}{#3}}%
%   \global\@namedef{end#1}{\@endtheoremup}}}}
% \def\@thmup#1#2{%
%   \refstepcounter{#1}%
%   \@ifnextchar[{\@ythmup{#1}{#2}}{\@xthmup{#1}{#2}}}
% \def\@xthmup#1#2{%
%   \@begintheoremup{#2}{\csname the#1\endcsname}\ignorespaces}
% \def\@ythmup#1#2[#3]{%
%   \@opargbegintheoremup{#2}{\csname the#1\endcsname}{#3}\ignorespaces}
% \def\@thmcounterup#1{\noexpand\arabic{#1}}
% \def\@thmcountersep{.}
% \def\@begintheoremup#1#2{\trivlist
%    \item[\hskip \labelsep{\bfseries #1\ #2.}]\upshape}
% \def\@opargbegintheoremup#1#2#3{\trivlist
%       \item[\hskip \labelsep{\bfseries #1\ #2\ (#3).}]\upshape}
% \def\@endtheoremup{\endtrivlist}
%%
%% <<tgk<<
%%

%%
%% >>tgk>> --- Moved elsewhere, Summer 2015
%%
%\usepackage{lineno}
%%
%% <<tgk<<
%%

\setlength{\textheight}{598pt} %{598.2275pt}

%%
%% >>jeh>> --- Updated Fall 2016 ---
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
% Support for supplement numbering
\renewcommand{\theequation}{\siamprelabel\arabic{equation}}
\renewcommand{\thepage}{\siamprelabel\arabic{page}}
\renewcommand{\thetheorem}{\siamprelabel\arabic{theorem}}
\let\svbibcite\bibcite
\def\bibcite#1#2{\svbibcite{#1}{\siamprelabel#2}}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
% Adding a command to do running heads with uppercase and supplement support.
\newcommand{\headers}[2]{
% Declare page headings - use the \siampretitle command, which inserts
% "Supplementary Material" when appropriate.
\pagestyle{myheadings}
\markboth{\uppercase\expandafter{#2}}
{\uppercase\expandafter{\siampretitle{#1}}}}
%%
%% <<tgk<<
%%
%% >>tgk>> --- Added Summer 2015 ---
%%
%% Support for "review" class option to turn on linenumbers via the
%% lineno package. Slightly complicated because the lineno and amsmath
%% packages do not play well together.
\if@review
  \RequirePackage[mathlines]{lineno}[4.41]
  \linenumbers
  \renewcommand{\linenumberfont}{\normalfont\footnotesize\color{siamreviewcolor}}
  % The \linenumbers command does not play nice with amsmath, so we
  % have added some patches to fix it. See   
  % http://phaseportrait.blogspot.com/2007/08/lineno-and-amsmath-compatibility.html
  \newcommand*\patchAmsMathEnvironmentForLineno[1]{%
    \expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
    \expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
    \renewenvironment{#1}%
    {\linenomath\csname old#1\endcsname}%
    {\csname oldend#1\endcsname\endlinenomath}}% 
  \newcommand*\patchBothAmsMathEnvironmentsForLineno[1]{%
    \patchAmsMathEnvironmentForLineno{#1}%
    \patchAmsMathEnvironmentForLineno{#1*}}%
  \patchBothAmsMathEnvironmentsForLineno{equation}%
  \patchBothAmsMathEnvironmentsForLineno{align}%
  \patchBothAmsMathEnvironmentsForLineno{flalign}%
  \patchBothAmsMathEnvironmentsForLineno{alignat}%
  \patchBothAmsMathEnvironmentsForLineno{gather}%
  \patchBothAmsMathEnvironmentsForLineno{multline}%
  \renewcommand{\footercopyright}{\textcolor{siamreviewcolor}%
    {\textit{This manuscript is for review purposes only.}}}
\fi
%%
%% <<tgk<<
%%

%_%_%_%_%
%_%_%_%_% patches, fixes JR 1/19/16
%_%_%_%_%


%_%_%_%_% for the benefit of Bakoma, no negative effect on Miktex, pdflatex
\newcommand{\listoffigures}{}
\newcommand{\listoftables}{}
\newcommand{\tableofcontents}{}
\ifpdf
  \DeclareGraphicsExtensions{.eps,.pdf,.png,.jpg,.jpeg}
\else
  \DeclareGraphicsExtensions{.eps}
\fi

%_%_%_%_% fixes a bug in ntheorem; % ending first line prevents 
%_%_%_%_% misalignment of equation numbers in eqnarray
\gdef\PotEndMark#1{%
\@ifnextchar[%]
    {\PotEndMark@opt{#1}}{\SetEndMark{\InTheoType}{#1}{\relax}}}%


%_%_%_%_% flag ro remove belowdisplay spacing in math
%\newcommand{\nomathspace}{\belowdisplayshortskip 0\p@ \@plus5\p@ \@minus3\p@%
%\belowdisplayskip 0\p@ \@plus0\p@ \@minus0\p@}
\newcommand{\nomathspace}{\belowdisplayshortskip 0\p@ \@plus3\p@ \@minus3\p@%
\belowdisplayskip 0\p@ \@plus3\p@ \@minus3\p@}

%% >>tgk>> --- Removed Summer 2015 --- %back in Winter 2017---MSC
%%
\if@oneeqnum
\else
\numberwithin{equation}{section}
\fi

\if@onetabnum
\else
\numberwithin{table}{section}
\fi

\if@onefignum
\else
\numberwithin{figure}{section}
\fi

\if@onealgnum
\else
\numberwithin{algorithm}{section}
\fi

\if@onethmnum
\else
\numberwithin{theorem}{section}
\fi

%% >>jeh>> --- Added May 2019 ---
% Hyphenation exceptions for US English.

\hyphenation{
  acad-e-my acad-e-mies ac-cu-sa-tive acro-nym acro-nyms acryl-amide acryl-
  amides acryl-alde-hyde acu-punc-ture acu-punc-tur-ist add-a-ble add-i-ble 
  adren-a-line aero-space af-ter-thought af-ter-thoughts agron-o-mist agron-o-
  mists al-ge-bra-i-cal-ly am-phet-a-mine am-phet-a-mines anach-ro-nism anach-
  ro-nis-tic an-a-lyse an-a-lysed analy-ses analy-sis an-eu-rysm an-eu-rysms an-
  eu-rys-mal an-iso-trop-ic an-iso-trop-i-cal-ly an-isot-ro-pism an-isot-ropy 
  an-ni-ver-sary an-ni-ver-saries anom-a-ly anom-a-lies anti-deriv-a-tive anti-
  deriv-a-tives anti-holo-mor-phic an-tin-o-my an-tin-o-mies anti-nu-clear anti-
  nu-cle-on anti-rev-o-lu-tion-ary a-peri-odic apoth-e-o-ses apoth-e-o-sis ap-
  pen-di-ces ap-pen-dix ap-pen-dixes ar-chi-me-dean ar-chi-pel-ago ar-chi-pel-a-
  gos ar-chive ar-chives ar-chiv-ing ar-chiv-ist ar-chiv-ists ar-che-typ-al ar-
  che-type ar-che-types ar-che-typ-i-cal arc-tan-gent arc-tan-gents a-spher-ic 
  a-spher-i-cal as-sign-a-ble as-sign-or as-sign-ors as-sist-ant as-sist-ance 
  as-sist-ant-ship as-sist-ant-ships as-trol-o-ger as-trol-o-gers as-tron-o-mer 
  as-tron-o-mers asymp-to-matic as-ymp-tot-ic asyn-chro-nous ath-er-o-scle-ro-
  sis at-mos-phere at-mos-pheres at-tri-bute at-trib-uted at-trib-ut-able au-to-
  ma-tion au-tom-a-ton au-tom-a-ta auto-num-ber-ing au-ton-o-mous auto-re-gres-
  sion auto-re-gres-sive auto-round-ing av-oir-du-pois back-scratcher back-
  scratch-ing band-lead-er band-lead-ers bank-rupt bank-rupts bank-rupt-cy bank-
  rupt-cies bar-onies base-line-skip ba-thym-e-try bathy-scaphe bean-ies be-
  drag-gle be-drag-gled bed-rid-den bed-rock be-dwarf be-dwarfs be-hav-iour be-
  hav-iours bevies bib-lio-graph-i-cal bib-li-og-ra-phy-style bib-units bi-dif-
  fer-en-tial big-gest big-shot big-shots bill-able bio-math-e-mat-ics bio-med-
  i-cal bio-med-i-cine bio-rhythms bio-weap-ons bio-weap-on-ry bit-map bit-maps 
  bland-er bland-est blind-er blind-est blondes blue-print blue-prints bo-lom-e-
  ter bo-lom-e-ters book-sell-er book-sell-ers bool-ean bool-eans bor-no-log-i-
  cal bot-u-lism brusquer buf-fer buf-fers bun-gee bun-gees busier busi-est 
  bussing butted buzz-word buzz-words cache-abil-ity cache-able ca-coph-o-ny ca-
  coph-o-nies call-er call-ers cam-era-men cart-wheel cart-wheels ca-tarrh ca-
  tarrhs ca-tas-tro-phe ca-tas-tro-phes cat-a-stroph-ic cat-a-stroph-i-cally ca-
  tas-tro-phism cat-e-noid cat-e-noids cau-li-flow-er chan-cery chap-ar-ral 
  char-treuse chemo-kine chemo-kines chemo-ther-apy chemo-ther-a-pies chloro-
  meth-ane chloro-meth-anes cho-les-teric cig-a-rette cig-a-rettes cinque-foil 
  co-asso-cia-tive coch-leas coch-lear co-designer co-designers co-gnac co-gnacs 
  co-ker-nel co-ker-nels col-lin-ea-tion col-umns com-par-and com-par-ands com-
  pen-dium com-po-nent-wise comp-trol-ler comp-trol-lers com-put-able com-put-
  abil-ity con-form-able con-form-ist con-form-ists con-form-ity con-ge-ries 
  con-gress con-gresses con-struc-ted con-struc-ti-ble con-struc-ti-bil-ity con-
  trib-ute con-trib-utes con-trib-uted copy-right-able co-re-la-tion co-re-la-
  tions co-re-li-gion-ist co-re-li-gion-ists co-re-op-sis co-re-spon-dent co-re-
  spon-dents co-se-cant co-semi-sim-ple co-tan-gent cour-ses co-work-er co-work-
  ers crank-case crank-shaft croc-o-dile croc-o-diles cross-hatch cross-hatched 
  cross-hatch-ing cross-over cryp-to-gram cryp-to-grams cuff-link cuff-links cu-
  nei-form cus-tom-iz-a-ble cus-tom-ize cus-tom-izes cus-tom-ized cy-ber-virus 
  cy-ber-viruses cy-ber-wea-pon cy-ber-wea-pons cy-to-kine cy-to-kines dachs-
  hund dam-sel-fly dam-sel-flies dactyl-o-gram dactyl-o-graph data-base data-
  bases data-path data-paths date-stamp date-stamps de-allo-cate de-allo-cates 
  de-allo-cated de-allo-ca-tion de-allo-ca-tions de-clar-able de-fin-i-tive de-
  lec-ta-ble demi-semi-qua-ver demi-semi-qua-vers de-moc-ra-tism demos der-i-va-
  tion der-i-va-tions der-i-va-tion-al de-riv-a-tive de-riv-a-tives dia-lec-tic 
  dia-lec-tics dia-lec-ti-cian dia-lec-ti-cians di-chloro-meth-ane dif-fract 
  dif-fracts dif-frac-tion dif-frac-tions direr dire-ness dis-par-and dis-par-
  ands dis-traught-ly dis-trib-ut-able dis-trib-ute dis-trib-utes dis-trib-uted 
  dis-trib-u-tive dou-ble-space dou-ble-spaced dou-ble-spac-ing dou-ble-talk 
  doll-ish drift-age driv-ers drom-e-dary drom-e-daries drop-let drop-lets du-
  op-o-list du-op-o-lists du-op-o-ly du-op-o-lies dys-lexia dys-lec-tic dys-
  topia east-end-ers eco-sys-tem eco-sys-tems eco-nom-ics econ-o-mies econ-o-
  mist econ-o-mists ei-gen-class ei-gen-classes ei-gen-val-ue ei-gen-val-ues 
  electro-mechan-i-cal electro-mechano-acoustic elec-tro-pho-re-sis elec-tro-
  pho-ret-ic elit-ist elit-ists en-dos-copy en-dos-copies en-tre-pre-neur en-
  tre-pre-neurs en-tre-pre-neur-ial ep-i-neph-rine eps-to-pdf equi-vari-ant 
  equi-vari-ance er-go-nom-ic er-go-nom-ics er-go-nom-i-cally es-sence es-sences 
  eth-ane eth-yl-am-ine eth-yl-ate eth-yl-ated eth-yl-ene ethy-nyl ethy-nyl-a-
  tion eu-sta-chian ever-si-ble evert everts evert-ed evert-ing ex-plan-a-tory 
  ex-quis-ite ex-tra-or-di-nary face-lifts face-lift-ing fall-ing fermi-ons 
  figu-rine figu-rines fi-nite-ly fla-gel-lum fla-gel-la flam-ma-bles fledg-ling 
  flow-chart flow-charts fluoro-car-bon fluor-os-copies fluor-os-copy for-mi-da-
  ble for-mi-da-bly for-syth-ia forth-right free-loader free-loaders friend-lier 
  friend-li-est fri-vol-ity fri-vol-i-ties friv-o-lous front-end front-ends ga-
  lac-tic gal-axy gal-ax-ies gaz-et-teer gaz-et-teers gas-om-e-ter ge-o-des-ic 
  ge-o-det-ic ge-om-eter ge-om-eters geo-met-ric geo-met-rics ge-o-strophic geo-
  ther-mal ge-ot-ro-pism giga-nodes gno-mon gno-mons gran-di-ose grand-uncle 
  grand-uncles griev-ance griev-ances griev-ous griev-ous-ly group-like hair-
  style hair-styles hair-styl-ist hair-styl-ists half-life half-lives half-space 
  half-spaces half-tone half-tones half-way har-bin-ger har-bin-gers har-le-quin 
  har-le-quins hatch-eries hei-nous he-lio-pause he-lio-trope hemi-demi-semi-
  qua-ver hemi-demi-semi-qua-vers he-mo-glo-bin he-mo-phil-ia he-mo-phil-iac he-
  mo-phil-iacs hemo-rhe-ol-ogy he-pat-ic he-pat-ica her-maph-ro-dite her-maph-
  ro-dit-ic he-roes hexa-dec-i-mal hip-po-po-ta-mus holo-deck holo-decks ho-lo-
  no-my ho-meo-mor-phic ho-meo-mor-phism ho-meo-stat-ic ho-meo-stat-ics ho-meo-
  sta-sis ho-mo-thetic horse-rad-ish hot-bed hot-beds hounds-teeth hounds-tooth 
  hy-dro-ther-mal hy-per-elas-tic-ity hy-phen-a-tion hy-phen-a-tions hy-po-elas-
  tic-ity hy-po-thal-a-mus ico-nog-ra-pher ico-nog-ra-phers icon-o-graph-ic ico-
  nog-ra-phy ideals ideo-graphs idio-syn-crasy idio-syn-cra-sies idio-syn-cratic 
  idio-syn-crat-i-cal-ly ig-nit-er ig-nit-ers ig-ni-tor ignore-spaces il-li-quid 
  il-li-quid-ity im-mu-ni-za-tion im-mu-no-mod-u-la-to-ry im-ped-ance im-ped-
  ances in-du-bi-ta-ble in-fin-ite-ly in-fin-i-tes-i-mal in-fra-struc-ture in-
  fra-struc-tures input-enc in-stall-er in-stall-ers in-teg-rity in-ter-dis-ci-
  pli-nary in-ter-ga-lac-tic in-ter-view-ee in-ter-view-ees in-utile in-util-i-
  ty ir-ra-tio-nal ir-re-duc-ible ir-re-duc-ibly ir-rev-o-ca-ble iso-geo-met-ric 
  iso-geo-met-rics iso-ther-mal isot-ropy iso-trop-ic itin-er-ary itin-er-ar-ies 
  je-re-mi-ads key-note key-notes key-stroke key-strokes kilo-nodes kiln-ing 
  lac-i-est lam-en-ta-ble land-scap-er land-scap-ers lar-ce-n lar-ce-ny lar-ce-
  nies lar-ce-nist leaf-hop-per leaf-hop-pers leaf-let leaf-lets let-ter-spaces 
  let-ter-spaced let-ter-spac-ing leu-ko-cyte leu-ko-cytes leu-ko-triene leu-ko-
  trienes life-span life-spans life-style life-styles lift-off light-weight lim-
  ou-sines line-backer line-spacing li-on-ess li-quid-ity lith-o-graphed lith-o-
  graphs lo-bot-omy lo-bot-om-ize loges long-est look-ahead lo-quac-ity love-
  struck macro-eco-nomic macro-eco-nomics macro-econ-omy make-in-dex mal-a-prop-
  ism mal-a-prop-isms man-slaugh-ter man-u-script man-u-scripts mar-gin-al math-
  e-ma-ti-cian math-e-ma-ti-cians mattes med-ic-aid medi-ocre medi-oc-ri-ties 
  mega-fau-na mega-fau-nal mega-lith mega-liths mega-nodes meta-bol-ic me-tab-o-
  lism me-tab-o-lisms me-tab-o-lite me-tab-o-lites meta-form meta-forms meta-
  lan-guage meta-lan-guages meta-phor meta-phors meta-phor-i-cal meta-phor-i-
  cal-ly meta-sta-bil-ity meta-stable meta-table meta-tables metem-psy-cho-sis 
  meth-am-phet-a-mine meth-ane meth-od meth-yl-am-mo-nium meth-yl-ate meth-yl-
  ated meth-yl-a-tion meth-yl-ene me-trop-o-lis me-trop-o-lises met-ro-pol-i-tan 
  met-ro-pol-i-tans micro-eco-nomic micro-eco-nomics micro-econ-omy micro-en-
  ter-prise micro-en-ter-prises mi-cro-fiche mi-cro-fiches micro-organ-ism 
  micro-organ-isms mi-cro-struc-ture mid-after-noon mill-age mil-li-liter mimeo-
  graphed mimeo-graphs mim-ic-ries mine-sweeper mine-sweepers min-is mini-sym-
  po-sium mini-sym-po-sia mi-nut-er mi-nut-est mis-chie-vous-ly mi-sers mi-sog-
  a-my mne-mon-ic mne-mon-ics mod-el-ling mo-lec-u-lar mol-e-cule mol-e-cules 
  mon-archs money-len-der money-len-ders mono-chrome mono-en-er-getic mon-oid 
  mon-oph-thong mon-oph-thongs mono-pole mono-poles mo-nop-oly mono-space mono-
  spaced mono-spacing mono-spline mono-splines mono-strofic mo-not-o-nies mo-
  not-o-nous mo-ron-ism mos-qui-to mos-qui-tos mos-qui-toes mud-room mud-rooms 
  mul-ti-fac-eted mul-ti-plic-able mul-ti-plic-ably multi-user name-space name-
  spaces neo-fields neo-nazi neo-nazis neph-ews neph-rite neph-ritic new-est 
  news-let-ter news-let-ters nil-po-tent nitro-meth-ane node-list node-lists no-
  name non-ar-ith-met-ic non-emer-gency non-equi-vari-ance none-the-less non-
  euclid-ean non-iso-mor-phic non-pseudo-com-pact non-smooth non-uni-form non-
  uni-form-ly non-zero nor-ep-i-neph-rine not-with-stand-ing nu-cleo-tide nu-
  cleo-tides nut-crack-er nut-crack-ers oer-steds off-line off-load off-loads 
  off-loaded oli-gop-o-list oli-gop-o-lists oli-gop-oly oli-gop-ol-ies om-ni-
  pres-ent om-ni-pres-ence ono-mat-o-poe-ia ono-mat-o-po-et-ic op-er-and op-er-
  ands orang-utan orang-utans or-tho-don-tist or-tho-don-tists or-tho-ker-a-tol-
  ogy ortho-nitro-toluene over-view over-views ox-id-ic pad-ding page-rank pain-
  less-ly pal-ette pal-ettes pa-rab-ola par-a-bol-ic pa-rab-o-loid par-a-digm 
  par-a-digms para-chute para-chutes para-di-methyl-benzene para-fluoro-toluene 
  para-graph-er para-le-gal par-al-lel-ism para-mag-net-ism para-medic para-
  methyl-anisole pa-ram-e-tri-za-tion pa-ram-e-trize para-mil-i-tary para-mount 
  path-o-gen-ic peev-ish peev-ish-ness pen-al-ty pen-al-ties pen-ta-gon pen-ta-
  gons pe-tro-le-um phe-nol-phthalein phe-nom-e-non phenyl-ala-nine phi-lat-e-
  list phi-lat-e-lists pho-neme pho-nemes pho-ne-mic phos-phor-ic pho-to-graphs 
  pho-to-off-set phtha-lam-ic phthal-ate phthi-sis pic-a-dor pic-a-dors pipe-
  line pipe-lines pipe-lin-ing pi-ra-nhas placa-ble plant-hop-per plant-hop-pers 
  pla-teau pla-teaus pleas-ance plug-in plug-ins pol-ter-geist poly-an-dr poly-
  an-dry poly-an-drous poly-dac-tyl poly-dac-tyl-lic poly-ene poly-eth-yl-ene 
  po-lyg-a-mist po-lyg-a-mists polyg-on-i-za-tion po-lyg-y-n po-lyg-y-ny po-lyg-
  y-nous pol-yp pol-yps po-lyph-o-n po-lyph-o-ny po-lyph-o-nous poly-phon-ic 
  poly-styrene pome-gran-ate poro-elas-tic por-ous por-ta-ble post-am-ble post-
  am-bles post-hu-mous post-script post-scripts pos-tur-al pre-am-ble pre-am-
  bles pre-dict-able pre-fers pre-loaded pre-par-ing pre-print pre-prints pre-
  proces-sor pre-proces-sors pres-ent-ly pre-split-ting pre-wrap pre-wrapped 
  priest-esses pret-ty-prin-ter pret-ty-prin-ting pro-ce-dur-al process pro-cur-
  ance prog-e-nies prog-e-ny pro-gram-mable pro-kary-ote pro-kary-otes pro-kary-
  ot-ic prom-i-nent pro-mis-cu-ous prom-is-sory prom-ise prom-ises pro-pel-ler 
  pro-pel-lers pro-pel-ling pro-hib-i-tive pro-hib-i-tive-ly pro-sciut-to pros-
  ta-glan-din pros-ta-glan-dins pro-style pro-styles pro-test-er pro-test-ers 
  pro-tes-tor pro-tes-tors pro-to-lan-guage pro-to-typ-al prov-ince prov-inces 
  pro-vin-cial pro-virus pro-viruses prow-ess pseu-do-dif-fer-en-tial pseu-do-
  fi-nite pseu-do-fi-nite-ly pseu-do-forces pseu-dog-ra-pher pseu-do-group pseu-
  do-groups pseu-do-nym pseu-do-nyms pseu-do-word pseu-do-words psy-che-del-ic 
  psychs pu-bes-cence pur-ges quad-ding qua-drat-ic qua-drat-ics quad-ra-ture 
  quad-ri-lat-er-al quad-ri-lat-er-als quad-ri-pleg-ic quad-ru-ped quad-ru-peds 
  quad-ru-pole quad-ru-poles quaint-er quaint-est qua-si-equiv-a-lence qua-si-
  equiv-a-lences qua-si-equiv-a-lent qua-si-hy-po-nor-mal qua-si-rad-i-cal qua-
  si-resid-ual qua-si-smooth qua-si-sta-tion-ary qua-si-topos qua-si-tri-an-gu-
  lar qua-si-triv-ial quin-tes-sence quin-tes-sences quin-tes-sen-tial rab-bit-
  ry ra-di-og-ra-phy raff-ish raff-ish-ly ram-shackle rav-en-ous re-allo-cate 
  re-allo-cates re-allo-cated re-arrange re-arranges re-arranged re-arrange-ment 
  re-arrange-ments rec-i-proc-i-ties rec-i-proc-i-ty rec-tan-gle rec-tan-gles 
  rec-tan-gu-lar re-di-rect re-di-rect-ion re-duc-ible re-echo re-edu-cate ref-
  u-gee ref-u-gees re-imple-ment re-imple-ments re-imple-mented re-imple-men-ta-
  tion ren-ais-sance re-phrase re-phrases re-phrased re-po-si-tion re-po-si-
  tions re-print re-prints re-print-ed re-stor-able retro-fit retro-fit-ted re-
  us-able re-use re-wire re-wrap re-wrapped re-write rhi-noc-er-os right-eous 
  right-eous-ness ring-leader ring-leaders ro-bot ro-bots ro-botic ro-bot-ics 
  roof-top roof-tops round-table round-tables sales-clerk sales-clerks sales-
  woman sales-women sa-lient sal-mo-nel-la sal-ta-tion sar-sa-par-il-la sat-el-
  lite sat-el-lites sauer-kraut scat-o-log-i-cal scene-shift-er scene-shift-ing 
  sched-ul-ing schiz-o-phrenic schnau-zer school-child school-child-ren school-
  teacher school-teach-ers scru-ti-ny scyth-ing sell-er sell-ers sec-re-tar-iat 
  sec-re-tar-iats sem-a-phore sem-a-phores se-mes-ter semi-def-i-nite semi-di-
  rect semi-ho-mo-thet-ic semi-ring semi-rings semi-sim-ple semi-skilled sem-
  itic ser-geant ser-geants sero-epi-de-mi-o-log-i-cal ser-vo-me-chan-i-cal ser-
  vo-mech-a-nism ser-vo-mech-a-nisms ses-qui-pe-da-lian set-up set-ups se-vere-
  ly shap-able shape-able shoe-string shoe-strings shop-lift-er shop-lift-ing 
  show-hy-phens side-step side-steps side-swipe sign-age single-space single-
  spaced single-spacing sky-scraper sky-scrapers sln-uni-code smoke-stack smoke-
  stacks snor-kel-ing so-le-noid so-le-noids solute solutes sov-er-eign sov-er-
  eigns spa-ces spe-cious spell-er spell-ers spell-ing spe-lunk-er spend-thrift 
  spher-oid spher-oids spher-oid-al sphin-ges spic-i-ly spin-or spin-ors spokes-
  man spokes-per-son spokes-per-sons spokes-woman spokes-women sports-cast 
  sports-cast-er spor-tive-ly sports-wear sports-writer sports-writers spright-
  lier squea-mish stand-alone star-tling star-tling-ly sta-tis-tics stealth-ily 
  steeple-chase stereo-graph-ic sto-chas-tic strange-ness strap-hanger strat-a-
  gem strat-a-gems stretch-i-er strip-tease strong-est strong-hold stu-pid-er 
  stu-pid-est sub-dif-fer-en-tial sub-ex-pres-sion sub-ex-pres-sions sub-node 
  sub-nodes sub-scrib-er sub-scrib-ers sub-tables sum-ma-ble super-deri-va-tion 
  super-deri-va-tions super-ego super-egos su-prem-a-cist su-prem-a-cists sur-
  gery sur-ge-ries sur-ges sur-veil-lance swim-ming-ly symp-to-matic syn-chro-
  mesh syn-chro-nous syn-chro-tron taff-rail take-over take-overs talk-a-tive 
  ta-pes-try ta-pes-tries tar-pau-lin tar-pau-lins te-leg-ra-pher te-leg-ra-
  phers tele-ki-net-ic tele-ki-net-ics tele-ro-bot-ics tell-er tell-ers tem-po-
  rar-ily ten-ure test-bed tera-nodes tetra-butyl-ammo-nium text-height text-
  length text-width thal-a-mus ther-mo-elas-tic time-stamp time-stamps tool-kit 
  tool-kits topo-graph-i-cal topo-iso-mer-ase topo-iso-mer-ases toques trai-tor-
  ous trans-ceiver trans-ceivers trans-par-en-cy trans-par-en-cies trans-gress 
  trans-ver-sal trans-ver-sals trans-ves-tite trans-ves-tites tra-vers-a-ble 
  tra-ver-sal tra-ver-sals tri-ethyl-amine treach-eries tribes-man trip-let 
  trip-lets tri-plex tri-plex-es trou-ba-dour tur-key tur-keys turn-around turn-
  arounds typ-al un-at-tached un-err-ing-ly un-friend-ly un-friend-li-er un-in-
  stan-ti-at-ed vaguer vaude-ville vic-ars vil-lain-ess vis-ual vis-ual-ly vi-
  vip-a-rous voice-print vspace wad-ding wall-flower wall-flow-ers warm-er warm-
  est waste-water wave-guide wave-guides wave-let wave-lets weap-ons weap-on-ry 
  web-like web-log web-logs week-night week-nights weight-lift-er weight-lift-
  ing wheel-chair wheel-chairs which-ever white-sided white-space white-spaces 
  wide-spread wing-span wing-spans wing-spread witch-craft word-spac-ing work-
  around work-arounds work-horse work-horses wrap-around wrap-arounds wretch-ed 
  wretch-ed-ly yes-ter-year Alex-an-der Alex-an-drine al-ge-brai-sche Al-gon-
  quian Al-gon-quin Al-le-ghe-ny Apol-lo-dorus Ar-kan-sas ATP-ase ATP-ases Auf-
  lage Aus-tral-asian auto-ma-ti-sier-ter Beb-chuk Be-die-nung Bembo bi-blio-
  gra-phi-sche Bos-ton Brown-ian Bruns-wick Bu-da-pest Burck-hardt Cara-theo-
  dory Car-ib-bean Charles-ton Char-lottes-ville Ches-ter Chiang Chich-es-ter 
  Cohen Co-lum-bia Czecho-slo-va-kia Del-a-ware Dijk-stra Dor-ches-ter Dorf-
  leit-ner Drechs-ler Duane dy-na-mi-sche Eijk-hout Engle Engel Eng-lish Euler-
  ian Evan-ston Feb-ru-ary Fest-schrift Flor-i-da Flor-i-d-ian For-schungs-in-
  sti-tut Free-BSD funk-tsional Gauss-ian Ge-sell-schaft Ghost-script Ghost-View 
  Gott-fried Gott-lieb Grass-mann-ian Greifs-wald Grothen-dieck Grund-leh-ren 
  Ha-da-mard Hai-fa Hamil-ton-ian Hel-sinki Her-mit-ian Hibbs Hoef-ler Hoek-
  water Hok-kai-do Huber Image-Magick Jac-kow-ski Jan-u-ary Ja-pa-nese Java-
  Script Jung-ian Kad-om-tsev Kan-sas Karls-ruhe Keynes-ian Kor-te-weg Krishna 
  Krish-na-ism Krish-nan Kron-ecker Lan-cas-ter Le-gendre Leices-ter Lip-schitz 
  Lip-schitz-ian Loj-ban Lou-i-si-ana Lucas MacBeth Mac-OS Ma-gel-lan Ma-la-ya-
  lam Man-ches-ter Mar-kov-ian Markt-ober-dorf Mass-a-chu-setts Max-well Meth-
  od-ist Meth-od-ism Mi-cro-soft Min-kow-ski Min-ne-ap-o-lis Min-ne-sota Mont-
  real Mos-cow Nach-rich-ten Nash-ville Net-BSD Net-scape Nietz-sche Nij-me-gen 
  Noe-ther-ian Noord-wijker-hout Noto-wi-digdo No-vem-ber Obst-feld Open-BSD 
  Open-Office Oreo-pou-los Pala-tino Pa-ler-mo Pe-trov-ski Pfaff-ian Phil-a-del-
  phia phi-lo-so-phi-sche Poin-care Po-ten-tial-glei-chung Po-to-mac Pres-by-
  terian Pres-by-terians Pyong-yang Py-thag-o-ras Py-thag-o-re-an Ra-dha-krish-
  nan raths-kel-ler Ravi-kumar Reich-lin Rie-mann-ian Ryd-berg Schim-mel-pfen-
  nig schot-ti-sche Schro-din-ger Schwa-ba-cher Schwarz-schild Schweid-nitz 
  Schwert Sep-tem-ber Shore-ditch Skoup Stokes-sche Stutt-gart Sus-que-han-na 
  Tau-ber-ian tech-ni-sche Ten-nes-see Thiruv-ananda-puram Tol-ches-ter To-ma-
  szew-ski Toyo-ta ty-po-graphique Ukrain-ian ver-all-ge-mei-nerte Ver-ei-ni-
  gung Ver-tei-lun-gen Vid-ias-sov Vieth viiith viith Wahr-schein-lich-keits-
  theo-rie Wein-stein Werk-zeuge Wer-ner Wer-ther-ian Will-iam Will-iams Win-
  ches-ter Wirt-schaft wis-sen-schaft-lich Wolff-ian xviiith xviith xxiiird 
  xxiind Ying-yong Shu-xue Ji-suan Zea-land
  Zeit-schrift
}

\endinput

%% 
%% End of file `siamart220329.cls'.


