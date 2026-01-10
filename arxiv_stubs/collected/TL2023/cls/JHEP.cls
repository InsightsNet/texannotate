%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% JHEP.cls 2.0.3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This file is Copyright JHEP 1998 under GPL: it can be freely distri-
%% buted but NOT modified preserving its name, even in similar forms.
%% 
%% JHEP.cls is a LaTeX2e class file used to typeset manuscripts in JHEP
%% style. It was written by F. Nesti as a (radical) modification of the
%% class `article.cls' from distribution 960601 of LaTeX2e.
%%
%% For bugs, comments, suggestions email to nesti@jhep.sissa.it
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ***:to do  **?:question  ...:to choose  XXX:to delete  ???:unknown %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{JHEP} [1999/03/24 v2.0.3 LaTeX document class - F.N.]
\def\logo{\raisebox{-10.5\p@}{\hb@xt@85\p@{\special{psfile=logo.eps}\hfil}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW SWITCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@preprint\@preprinttrue		% DEFAULT IS PREPRINT!
\newif\if@draft   \@draftfalse			% DEFAULT IS NOT DRAFT
\newif\if@hyper   \@hypertrue			% DEFAULT IS HYPER
\newif\if@proc	  \@procfalse			% DEFAULT IS NOT PROC

%\newif\if@title\@titlefalse			%
\newif\if@author\@authorfalse			%
\newif\if@abstract\@abstractfalse		% FOR FRONTMATTER DECLARATIONS
\newif\if@keywords\@keywordsfalse		%
\newif\if@todotoc\@todotocfalse			%
\newif\if@rece\@recefalse			%
\newif\if@acce\@accefalse			%
\newif\if@conf\@conffalse			%

%\newif\if@restonecol
\@twocolumnfalse

\if@compatibility
    \setlength\paperheight {297mm}%		% DEFAULT FOR LATEX209 IS a4
    \setlength\paperwidth  {210mm}%
\else						% CHOSE PAPER:
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}{\@OImess{}}		% IGNORED a5
\DeclareOption{b5paper}{\@OImess{}}		% IGNORED b5
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}{\@OImess{}}		% IGNORED landscape
\fi

\newcommand\@ptsize{2}                          % DEFAULT SIZE IS 12 PT

\DeclareOption{proceedings}{\@preprintfalse\@proctrue
			   \renewcommand\@ptsize{0}% PROCS: 10 PT
			   \AtBeginDocument{\@todotocfalse}}
\DeclareOption{published}{\@preprintfalse}

\DeclareOption{hyper}{\@hypertrue}	% HYPER IS 12 PT
%\DeclareOption{screen}{\@hypertrue}	% HYPER IS 12 PT
\DeclareOption{nohyper}{\@hyperfalse}	% PAPER IS ALSO 12 PT (v1.3)
\DeclareOption{paper}{\@hyperfalse}	% PAPER IS ALSO 12 PT
\DeclareOption{11pt}{\renewcommand\@ptsize{1}\ExecuteOptions{@FONT}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}\ExecuteOptions{@FONT}}
\if@compatibility\else                          % LATEX2.09 HAS NO 10PT 
\DeclareOption{10pt}{\renewcommand\@ptsize{0}\ExecuteOptions{@FONT}}% v1.4
\fi       				% CHOSEN TO FREE MEMORY LATER:
\DeclareOption{@FONT}{\if@preprint              % IF PREPRINT ALLOW ANY,
                        \else			% IF PROCEEDINGS OR PUBLISHED: 
			\if@proc		% 
			\renewcommand\@ptsize{0}\@NFmess{10pt}% ALWAYS 10PT
			\else
			\renewcommand\@ptsize{2}\@NFmess{12pt}% ALWAYS 12PT
                        \fi\fi}
                        
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}\fi
\DeclareOption{twoside}{\if@preprint\if@hyper\@OImess{ in hyper-mode}
				    \else\@twosidetrue\@mparswitchtrue\fi
			\else			% FOR PROCEED./PUBLIC.:
			\@OImess{ in published papers}
			\fi}
\DeclareOption{notoc}{\if@preprint		% to disable TOC
			\AtBeginDocument{\@todotocfalse}
			\else
			\if@proc\@OImess{ is automatic for proceedings}
			\else\@OImess{ in JHEP papers}\fi\fi}
\DeclareOption{draft}{\setlength\overfullrule{5pt}% EXTENDED DRAFT
	\newcount\hour\newcount\minute
	\hour=\time \divide\hour by60 \minute=\time
	{\multiply\hour by60 \global\advance\minute by-\hour}
	\edef\militarytime{\number\hour:\ifnum\minute<10 0\fi\number\minute}
	\let\old@eqnnum\@eqnnum
	\def\@eqnnum{\old@eqnnum\rlap{\kern\marginparsep
				\if@twocolumn\if@firstcolumn
				  \kern-2\marginparsep\kern-\columnwidth\
				  \llap\bgroup\else\bgroup\fi
				\else
				\if@twoside\ifodd\c@page
				  \kern-2\marginparsep\kern-\textwidth
				  \llap\bgroup\else\bgroup\fi
				\else\bgroup\fi				
				\fi
				\sf\scriptsize\@eqnlabel\egroup}%
				\gdef\@eqnlabel{}}
	\let\@eqnlabel\relax
	\def\math@note#1{\gdef\@eqnlabel{LAB: #1}}
	\def\norm@note#1#2{\special{}% SORRY AGAIN.
			 \ifinner{\ifdim\baselineskip=\z@% IN ARRAY..
					\baselineskip18\p@\fi%%
				\ifhmode%   ATTENTION TO RESTRICTED VMODE!
				\raisebox{.5\baselineskip}[\z@][\z@]{%
					\rlap{\sf\scriptsize #2}}%
				\else\vskip-\baselineskip%
				\raisebox{-.6\baselineskip}[\z@][\z@]{%
						\rlap{\sf\scriptsize #2}}%
				\fi}%
			 \else\marginpar{\raggedright\if@twoside\ifodd\c@page%
					\raggedleft\fi\fi\sf\scriptsize #1#2}%
			 \fi}%
	\AtBeginDocument{\newbox\drft@box\setbox\drft@box=\hbox{%
			\framebox[\textwidth]{\sf\small JHEP 2.0 DRAFT 
			\ttfamily(\cur@opt)\hfill\sf\bfseries\jobname\sf, 
			\today, \militarytime}}}
	\@drafttrue}

%\if@compatibility\else
%\DeclareOption{final}{\setlength\overfullrule{\z@}} % ***? NO FINAL?
%\fi
\DeclareOption{titlepage}{\@OImess{}}		% IGNORED
\if@compatibility\else
\DeclareOption{notitlepage}{\@OImess{}}		% IGNORED
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@OImess{}}		% IGNORED
\fi
\DeclareOption{twocolumn}{\@OImess{}}		% IGNORED
\DeclareOption{leqno}{\@OImess{}}	%\input{leqno.clo}} IGNORED ...
\DeclareOption{fleqn}{\@OImess{}}	%\input{fleqn.clo}} IGNORED ...
\DeclareOption{openbib}{\@OImess{}}		% IGNORED


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MESSAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\JHEP@mess[1]{\typeout{Class JHEP Message: \protect#1.}}%
\newcommand\JHEP@warn[1]{\ClassWarning{JHEP}{#1}}
\newcommand\JHEP@warnl[1]{\ClassWarningNoLine{JHEP}{#1}}
\newcommand\JHEP@igno[1]{\JHEP@warn{IGNORED \protect#1}}
\newcommand\JHEP@ignol[1]{\JHEP@warnl{IGNORED \protect#1}}
\newcommand\@OImess[1]{\JHEP@ignol{OPTION '\CurrentOption'#1}}
\newcommand\@NFmess[1]{\JHEP@mess{Normalsize set to #1}}
\newcommand\@ENVwarn[1]{\JHEP@warn{Please use \protect#1 in place 
						of LaTeX environment}}
%%%%%%%%%%%%%%%%%%%%%%%%%% PROCESS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExecuteOptions{a4paper,oneside,hyper} %WERE ALSO 10pt,onecolumn
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% START CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\input{size1\@ptsize.clo}
\renewcommand{\baselinestretch}{1.1}\normalsize
\setlength\lineskip{1\p@}
\setlength\parindent{1.2\parindent}	% AT 12pt 1.5em BECOMES 1.8em=tocindent
\setlength\normallineskip{1\p@}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\widowpenalty 1000
\clubpenalty 1000

\setcounter{topnumber}{3}
\renewcommand\topfraction{.95} %.7
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.6} %.2		% .6 ???***
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.05}
\renewcommand\floatpagefraction{1}
\setcounter{dbltopnumber}{3}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{1}

\textwidth  .72\paperwidth	% WIDTH OF TEXT, REMAINS .28% FOR MARGINS
\if@proc
  \addtolength\textwidth{.02\paperwidth}
\fi

\setlength\@tempdima{.76\paperheight}	% HEIGHT OF TEXT WITH FOOTNOTES
\divide\@tempdima\baselineskip		% EXCLUDING HEAD (AND FOOT)
\@tempcnta=\@tempdima			% rounded to integer (#lines-1)
\setlength\textheight{\@tempcnta\baselineskip}
\addtolength\textheight{\topskip}

\voffset -1in
\topmargin   .05\paperheight	% FROM TOP OF PAGE TO TOP OF HEADING (0=1inch)
\headheight  .02\paperheight	% HEIGHT OF HEADING BOX.
\headsep     .03\paperheight	% VERT. SPACE BETWEEN HEAD AND TEXT.
\footskip    .07\paperheight	% FROM END OF TEX TO BASE OF FOOTER. (40pt)

\marginparsep 9\p@		% HOR. SPACE BETWEEN TEXT AND MARGINAL NOTE
\marginparpush 6\p@		% MIN. VERT. SPACE BETWEEN MARGINAL NOTES

\hoffset -1in				% TO ADJUST WITH PAPER:
\if@twoside				% IF TWO-SIDED:
	\oddsidemargin .13\paperwidth	% LEFT MARGIN FOR ODD PAGES (10)
	\evensidemargin .15\paperwidth	% LEFT MARGIN FOR EVEN PAGES (30)
	\marginparwidth .10\paperwidth	% TEXTWIDTH OF MARGINALNOTES
	\reversemarginpar		% BECAUSE OF TITLEPAGE.
\else					% IF ONE-SIDED:
	\oddsidemargin .14\paperwidth	% LEFT MARGIN FOR ODD PAGES (20)
	\evensidemargin .14\paperwidth	% LEFT MARGIN FOR EVEN PAGES (20)
	\marginparwidth .11\paperwidth	% TEXTWIDTH OF MARGINALNOTES
\fi					%
\if@proc
\addtolength\oddsidemargin{-.01\paperwidth}
\addtolength\evensidemargin{-.01\paperwidth}
\fi
%%%%%%%%%%%%%%%%%%%%%%% HYPER (AND DRAFT) STUFF %%%%%%%%%%%%%%%%%%%%%%%
%\let\textref\@gobble
%\if@hyper			% IF NOHYPER WE DO LESS DAMAGE AS POSSIBLE.***
\bgroup\catcode`\#=12\gdef\hash{#}\egroup	% DEFINED \hash=#.
%\fi
\def\H@tilde{\string~}
\newcommand{\href}[2]{\bgroup\let~\H@tilde
			\if@hyper\noexpand\special{html:<a href="#1">}\fi
			{#2}\egroup\if@hyper\special{html:</a>}\fi}
\newcommand{\name}[1]{\if@hyper\noexpand\special% NAME HAS NO TAGGED TEXT HERE.
			{html:<a name="#1">}\special{html:</a>}\fi}
\newcommand{\base}[1]{\if@hyper\bgroup\let~\H@tilde
			\noexpand\special	% BASE HAS NO TAGGED TEXT.
			{html:<base href="#1">}\egroup\fi}
\newcommand{\textref}[2]{\vrule height \z@ width \z@\href{\hash ref-#1}{#2}}
%------------------------------------------------------------------%
% SECTION TAGS and  THEIR REFERENCE IN TOC \d@t will be '.' for sections only
\if@hyper
\renewcommand{\@seccntformat}[1]{\name{sec\csname the#1\endcsname}%
				 \csname the#1\endcsname\d@t\hspace{1ex}}
\renewcommand{\numberline}[1]{\hb@xt@\@tempdima{\href
			      {\hash\hyp@typ#1}{#1}\d@t\hfil}}
\else
\renewcommand{\@seccntformat}[1]{\csname the#1\endcsname\d@t\hspace{1ex}}
\renewcommand{\numberline}[1]{\hb@xt@\@tempdima{#1\d@t\hfil}}
\fi
%------------------------------------------------------------------%
% CITATION TAGS ARE TOGETHER WITH BIB STUFF.
% CITATION HREF
\def\@citex[#1]#2{%			% UNFORTUNATELY REDEFINED!!!!
  \let\@citea\@empty
  \@cite{\@for\@citeb:=#2\do
    {\@citea\def\@citea{,\penalty\@m\ }%
     \edef\@citeb{\expandafter\@firstofone\@citeb}%
     \if@filesw\immediate\write\@auxout{\string\citation{\@citeb}}\fi
     \@ifundefined{b@\@citeb}{\mbox{\reset@font\bfseries ?}%
       \G@refundefinedtrue
       \@latex@warning
         {Citation `\@citeb' on page \thepage \space undefined}}%
       {\edef\tmp@bn{\csname b@\@citeb\endcsname}%
	\hbox{\href{\hash bib\tmp@bn}{\tmp@bn}}}}}{#1}%		% **HYPER**
	\if@draft\norm@note{CIT: }{#2}\fi			% **DRAFT**
	}
%-----------------------------------------------------------------%
% LABEL, REF AND PAGEREF, ~ COMPATIBLE:
\let\old@label\label					% OLD LATEX COMMAND.
\renewcommand{\label}[1]{\name{ref-#1}%			% LABEL IN HYPER TAG.
			 \old@label{#1}%		% 
			 \if@draft%			% DRAFT:
			 \ifmmode\math@note{#1}%
			 \else\norm@note{}{LAB: #1}\fi%
			 \fi%
			 }
\if@hyper
\let\old@ref\ref \let\old@pageref\pageref		% OLD LATEX COMMANDS.
\renewcommand{\ref}[1]{\@ifundefined{r@#1}{}{\href{\hash ref-#1}}%
		       {\old@ref{#1}}} % LABEL INSIDE HREF.
\renewcommand{\pageref}[1]{\@ifundefined{r@#1}{}{%	% UNDEFINED => NO HREF
	      \edef\tmp@ref{\noexpand\@secondoftwo\csname r@#1\endcsname}%
	      \href{\hash pag\tmp@ref}}{\old@pageref{#1}}}
\fi
%------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%% END HYPER-STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% JHEP HEADINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ps@JHEP{%
    \def\@oddfoot{\reset@font\hfil\thepage\hfil}
    \if@draft\edef\cur@opt{\@curroptions}\fi
    \def\@oddhead{\name{pag\thepage}\hfil\if@draft\copy\drft@box\fi}
    \if@proc
	\def\@oddhead{\name{pag\thepage}
		      \smash{\if@draft\raise 2.5em\rlap{\copy\drft@box}\fi
		      	     \vbox{\hsize=\textwidth\noindent
			     \copy\conf@box\hfill
			     \copy\@firstauthorbox\vskip.17em \hrule}}
		      }%
    \fi
    \if@twoside\let\@evenhead\@oddhead\let\@evenfoot\@oddfoot\fi
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TITLE PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\maketitle{\JHEP@ignol{\maketitle}}
\newcommand\auto@maketitle{\begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{\hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \let\footnote\thanks%
	\newpage				%
	\if@proc				% IF PROCEEDINGS: 
	\global\let\@nodocument\relax		% LaTeX FOULED:)
	\twocolumn[\@maketitle]%		% TWOCOLUMN AFTER REAL TITLE
	\@thanks				% TITLE THANKS IN 1st COLUMN
	\let\@evenfoot\@empty			% NO PAGENO.
 	\let\@oddfoot\@empty
	\setcounter{page}{1}%
	\thispagestyle{empty}%			% PROCS HAVE NO PAGENUMBER
	\else
	\@maketitle				% CALL ACTUAL FORMATTING
	\@thanks				% TITLE THANKS
	\let\@evenfoot\@empty			% NO PAGENO.
 	\let\@oddfoot\@empty
	\setcounter{page}\z@
	\newpage				% FINE PAGINA
	\fi	
  \endgroup
  \setcounter{footnote}{0}%			
  \if@todotoc					% IF THERE IS A SECTION
      \noindent\rule\textwidth{.1pt}		% THEN MAKE TOC...
      \vskip 2em \@plus 2ex \@minus 2ex
      \tableofcontents
      \vskip 2em \@plus 2ex \@minus 2ex
      \noindent\rule\textwidth{.1pt}
      \vskip 2em \@plus 2ex \@minus 2ex
  \fi
  \if@preprint\else
	\gdef\tableofcontents{\JHEP@igno{\tableofcontents\space is automatic}}
  \fi
  \global\let\thanks\@gobble
  \setbox\@tmpbox=\vbox{\rm\@author}%		% FOR PROCS RESET HEADERS
%  \global\let\maketitle\relax			% NO LONGER EXISTS.
  \global\let\@maketitle\relax			%
  \global\let\@thanks\@empty			%
  \global\let\@author\@empty			% KILL ALL 
  \global\let\@date\@empty			%
  \global\let\@title\@empty			%
  \global\let\@abstract\@empty			%
  \global\let\title\relax			%
  \global\let\author\relax			%
  \global\let\date\relax			%
  \global\let\and\relax				%
  \global\let\email\@gobble
  \global\let\received\relax
  \global\let\accepted\relax
  \global\let\keywords\relax
  \global\let\endkeywords\relax
}
%%%%%%%%%%%%%%%%%%%%%%%%%% ACTUAL TITLEPAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@maketitle{%				% PAGE IS FLUSHED LEFT
\begin{flushleft}%				% PAY ATTENTION TO \par'S
\if@preprint					%%% PREPRINT HEADER: 
  \vskip-7em					%
  \underline{\tiny Preprint typeset 		%
		in JHEP style. -		%
  		\if@hyper{HYPER VERSION}	%
		\else{PAPER VERSION}\fi } 	%
  \normalsize\hfill%				% *** MAYBE PUT IN A ZERO BOX
  \begin{tabular}[t]{r}\@preprint\end{tabular}% % PREPRINT NUMBERS
\else						%
\if@proc					%%% PROCEEDINGS: LOGO ETC..
\vskip-4.48em\hfill\copy\conf@box
  \vskip-.7\baselineskip\logo\hrulefill
  \vskip-.4\baselineskip\hskip32\p@%	% *** IDEM BOXIZE
		{\tiny PROCEEDINGS}
\else
%						%%% PUBLISHED: LOGO  ETC..
  \vskip-7em\hfill\unhbox\rece@box\unhbox\acce@box
  \vskip-.7\baselineskip\logo\hrulefill
  \vskip-.5\baselineskip\hskip23\p@%	% *** IDEM BOXIZE
		{\tiny \if@hyper{HYPER VERSION}\else{PAPER VERSION}\fi}
\fi\fi\null
    \vskip 1.5em plus .4fil			% V. SPACE BEFORE TITLE
        {\LARGE \sffamily                       % TITLE: large sans-serif bf
        \bfseries                               %
%       \if@hyper\else\huge\fi                  % IF PAPER: no longer HUGE.
        \@title\par}                            %
    \vskip .6em plus .06fil minus .5ex          %
    \rule\textwidth{\if@proc\else1.5\fi\p@}     % RULE for PROC = 1pt else 1.5pt.
    \vskip 1em plus .06fil minus .6ex           %   (symmetric is 1em)
        {\normalsize \bfseries \sffamily        %
        \@author \par}                          % AUTHORS\\ADDRESSES
    \vskip 2em plus 0.05fil minus 1ex           %
        \parbox\textwidth{\unhbox\abstract@box} % ABSTRACT IF PRESENT (SHOULD)
    \vskip 2em plus 1em minus 1ex		%
        \par                                    %
    \@keywords                                  % KEYWORDS IF PRESENT
        \par
    \vskip\baselineskip
        \dedic@box                              % DEDICATION, IF PRESENT
  \end{flushleft}%                              % FINISHED.
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% STANDARD STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand\thepart         {\@Roman\c@part}
\renewcommand\thesection      {\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
%%%%%%%%%%%%%%%%%%%%%%%%%%% SECTION FORMATS %%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\secstyle{\bfseries}
\def\ts@flag{\let\d@t.%					% Sections get ``.''
	     \immediate\write\@auxout			% IF THERE IS A SECTION
	     {\string\global\string\@todotoctrue}}	% THEN SIGNAL IN AUX.

\newcommand\part{\par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}

\def\@part[#1]#2{\ts@flag
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{part}%			% DAMN LATEX !!! BELOW,
      \addcontentsline{toc}{part}{\string\href	% UNFORTUNATELY, NO NUMBERLINE:
				  {\string\hash\space part\the\c@part}%
				  {\thepart}\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >\m@ne
       \name{part\the\c@part}\Large\bfseries \partname~\thepart
       \par\nobreak
     \fi
     \huge \bfseries #2%
     \markboth{}{}\par}%
    \nobreak
    \vskip 3ex
    \@afterheading\let\d@t\relax}
\def\@spart#1{%
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \huge \bfseries #1\par}%
     \nobreak
     \vskip 3ex
     \@afterheading}

\newcommand\section{\@startsection{section}{1}{\z@}%
                                   {-3.5ex \@plus -1.3ex \@minus -.7ex}%
                                   {2.3ex \@plus.4ex \@minus .4ex}%
                                   {\normalfont\large\secstyle}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                   {-2.3ex\@plus -1ex \@minus -.5ex}%
                                   {1.2ex \@plus .3ex \@minus .3ex}%
                                   {\normalfont\normalsize\secstyle}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                   {-2.3ex\@plus -1ex \@minus -.5ex}%
                                   {1ex \@plus .2ex \@minus .2ex}%
                                   {\normalfont\normalsize\secstyle}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                   {1.75ex \@plus1ex \@minus.2ex}%
                                   {-1em}%
                                   {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                   {1.75ex \@plus1ex \@minus .2ex}%
                                   {-1em}%
                                   {\normalfont\normalsize\bfseries}}

% ---- turnaround for sections with figures ------ %
\def\bef@sec{\iffigprocessing\JHEP@warnl{Floating figure \the\ffigcount\space
						and startsection colliding}\fi
	     \iftabprocessing\JHEP@warnl{Floating table \the\ftabcount\space
						and startsection colliding}\fi
	     \edef\bef@everypar{\the\everypar}}	% HACK FOR FLOATS AND \everypar
\def\aft@sec{\let\d@t\relax			% RESTORE: NO DOTTED SUBSECS..
	     \edef\tmp@everypar{\the\everypar}% % DELETED CLUBPENALTY, BELOW.
	     \everypar\expandafter{\bef@everypar{\tmp@everypar}}}% RESTORE.
\let\old@sec\section				%
\let\old@ssec\subsection			%
\let\old@sssec\subsubsection			% OLD SECTIONING COMMANDS.
\let\old@par\paragraph				%
\let\old@spar\subparagraph			%
% ------- new forms ------- %
\renewcommand{\section}{\secdef\JHEP@sec\JHEP@secs}
\renewcommand{\subsection}{\secdef\JHEP@ssec\JHEP@ssecs}
\renewcommand{\subsubsection}{\secdef\JHEP@sssec\JHEP@sssecs}
\renewcommand{\paragraph}{\secdef\JHEP@par\JHEP@pars}
\renewcommand{\subparagraph}{\secdef\JHEP@spar\JHEP@spars}
% ---- unstarred forms ---- %
\def\JHEP@sec[#1]#2{\ts@flag\bef@sec\old@sec[#1]{#2}\aft@sec}
\def\JHEP@ssec[#1]#2{\bef@sec\old@ssec[#1]{#2}\aft@sec}
\def\JHEP@sssec[#1]#2{\bef@sec\old@sssec[#1]{#2}\aft@sec}
\def\JHEP@par[#1]#2{\bef@sec\old@par[#1]{#2}\aft@sec}
\def\JHEP@spar[#1]#2{\bef@sec\old@spar[#1]{#2}\aft@sec}
% ----- starred forms ----- %
\def\JHEP@secs#1{\bef@sec\old@sec*{#1}\aft@sec}
\def\JHEP@ssecs#1{\bef@sec\old@ssec*{#1}\aft@sec}
\def\JHEP@sssecs#1{\bef@sec\old@sssec*{#1}\aft@sec}
\def\JHEP@pars#1{\bef@sec\old@par*{#1}\aft@sec}
\def\JHEP@spars#1{\bef@sec\old@spar*{#1}\aft@sec}
% ----- end hack for sections with floats --------%

\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
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
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
%%%%%%%%%%%%%%%%%%%%%%%%%% AUTHORS/ADDRESSES %%%%%%%%%%%%%%%%%%%%%%%%%%
% *** After proceedings, the authors go in a hbox. => \break does not work!!
\newtoks\prev@t
\newtoks\cur@t
\newbox\@firstauthorbox
\renewcommand\@author{%					% FIRST TIME \\=>ADDR.
		      \def\\{\egroup			% 
			\copy\@firstauthorbox\par	% CLOSE & COPY HBOX
			\vskip.6em\@plus.02fil\@minus.3ex% GLUE UNDER AUTHOR
			\hskip1em%			% ADDRESS INDENT
			\vbox\bgroup\hsize=.9\textwidth	% 
			\let\\\par\small\it\raggedright}%% STYLE FOR ADDRESSES
                      }
\renewcommand\author[1]{%
		\if@proc\if@author\@PROCerr\fi\fi	% PROCS ONLY 1 AUTHOR!
		\global\@authortrue
		\prev@t=\expandafter{\@author}%		% TWO TOKEN LISTS.
                \cur@t={\global\setbox\@firstauthorbox  % 
			\hbox\bgroup #1\egroup\par	% ACTUAL AUTH.\\ADD.
		\vskip.6em\@plus.03fil\@minus.2ex}% 	% Glue!
                \long\xdef\@author{\the\prev@t\the\cur@t}%
		}					% STORE ALL IN \@AUTHOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PROCEEDINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\conf@box
\newcommand\conference[1]{\global\setbox\conf@box\hbox{%
			 \itshape #1}\@conftrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECEIVED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\rece@box
\newcommand\received[1]{\global\setbox\rece@box\hbox{\small
			{\scshape\receivedname} \itshape #1, }\@recetrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PUBLISHED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\acce@box
\newcommand\accepted[1]{\global\setbox\acce@box\hbox{\small
			 {\scshape\acceptedname} \itshape #1}\@accetrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEDICATED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\dedic@box{\relax}
\newcommand\dedicated[1]{\gdef\dedic@box{\vbox{\small\it\raggedleft #1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%% ACKNOWELEDGMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\acknowledgments{\section*{\acknowlname}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EMAIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\email[1]{{\tt\href{mailto:#1}{#1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPRINT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@preprint{\relax}
\newcommand\preprint[1]{\long\gdef\@preprint{#1}} 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ABSTRACT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\abstract@box%			% HBOX FOR WHOLE ABSTRACT
\newcommand{\abstract}[1]%		% ABSTR. IN NORMALSIZE
	{\global\setbox\abstract@box=\hbox{\noindent{\scshape
	\abstractname}\ \ignorespaces #1}\global\@abstracttrue}
%\newenvironment{abstract}%		% ABSTR. ENV. IN NORMALSIZE
%	{\global\setbox\abstract@box=\hbox\bgroup\noindent{\scshape
%	\abstractname}\ \ignorespaces}
%	{\egroup\global\@abstracttrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KEYWORDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@keywords{\relax}%                   % CS FOR WHOLE KEYWORDS
\def\keywords{\bgroup\gdef\@comma{,}\catcode`\ =\active\catcode`,=\active
		\@@keywords}
\begingroup
\catcode`\ =\active\catcode`,=\active\global
\def\@@keywords#1{\gdef\@keywords{\noindent{\scshape\keywordsname}
		\bgroup\def, {+}\def {_}%	%ATTENTION: NO EXPANSION.
		\href{http://jhep.sissa.it/stdsearch?keywords=#1}%
						{\let,\@comma\let \ #1}.
		\egroup}\egroup\global\@keywordstrue}%
\endgroup
%%%%%%%%%%%%%%%%%%%%%%%%%% OTHER ENVIRONMENTS %%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% APPENDIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}}

%%%%%%%%%%%%%%%%%%%%%%%%%%% SOME MORE LENGHTS %%%%%%%%%%%%%%%%%%%%%%%%%
\setlength\arraycolsep{2\p@}		% TO MATCH eqnarrays<->equations
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THE EQUATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand\theequation{\ifnum\c@section=0\else\thesection.\fi
			  \@arabic\c@equation}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURES, TABLES %%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{Htbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure}
\newenvironment{figure}
               {\@ENVwarn{\FIGURE{...}}\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@ENVwarn{\FIGURE{...}}\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename~\thetable}
\newenvironment{table}
               {\@ENVwarn{\TABLE{...}}\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@ENVwarn{\TABLE{...}}\@dblfloat{table}}
               {\end@dblfloat}
%%-----------------------------------------------------------------%%
\newcommand{\FIGURE}[2][v]{\begin{floatingfigure}[#1]#2
                                        \end{floatingfigure}}
\newcommand{\TABLE}[2][v]{\begin{floatingtable}[#1]{#2}
                                        \end{floatingtable}}
\newcommand{\EPSFIGURE}[3][v]{\begin{floatingfigure}[#1]\epsfig{file=#2}
                                        \caption{#3}\end{floatingfigure}}
\newcommand{\TABULAR}[4][v]{\begin{floatingtable}[#1]{\begin{tabular}{#2}
					#3\end{tabular}}\caption{#4}
                                        \end{floatingtable}}
%Check below, and put automatic width ***
\newcommand{\DOUBLEFIGURE}[5][ht]{\@dblfloat{figure}[#1]\centerline{%
		\parbox{.45\textwidth}{\centerline{\epsfig{file=#2}}}~~~~
		\parbox{.45\textwidth}{\centerline{\epsfig{file=#3}}}}
		\centerline{\parbox[t]{.45\textwidth}{\caption{#4}}~~~~
		\parbox[t]{.45\textwidth}{\caption{#5}}}\end@dblfloat}
\newcommand{\DOUBLETABLE}[5][ht]{\@dblfloat{table}[#1]\centerline{%
		\parbox{.45\textwidth}{\centerline{#2}}~~~~
		\parbox{.45\textwidth}{\centerline{#3}}}
		\centerline{\parbox[t]{.45\textwidth}{\caption{#4}}~~~~
		\parbox[t]{.45\textwidth}{\caption{#5}}}\end@dblfloat}
%%%%%%---------------- FROM FLOATFLT PACKAGE ------------------%%%%%%%%
%% Original file `floatflt.sty', modified by F.Nesti <nesti@sissa.it> to:
%% be inserted in JHEP.cls;
%% correct float placement when shifting past pages;
%% correct incompatibility with \marginpar;
%% correct incompatibility with \@startsection;
%% correct persisting indentation in following pars;
%% let float also at beginning of pages; 
%% avoid the widht specification.
%% 
%% Original was 1994-1996 by Mats Dahlgren <matsd@physchem.kth.se>. 
%% 
%%%%%%%%\NeedsTeXFormat{LaTeX2e}[1994/06/01]		%LEFT THIS STUFF TO 
%%%%%%%%\ProvidesPackage{floatflt}[1996/02/27 v. 1.3]	%RECONVERT TO PACKAGE.
\newcounter{OptionTest}
\if@twoside
 \setcounter{OptionTest}{0}
\else							% POS: 2side=p/1side=r
 \setcounter{OptionTest}{1}
\fi
%%%%%%%%\DeclareOption{rflt}{\setcounter{OptionTest}{1}}
%%%%%%%%\DeclareOption{lflt}{\setcounter{OptionTest}{2}} % CHOSEN.
%%%%%%%%\DeclareOption{vflt}{\setcounter{OptionTest}{0}}
%%%%%%%%\DeclareOption*{\OptionNotUsed}
%%%%%%%%\ProcessOptions
\newbox\@tmpbox
\newbox\figbox
\newbox\tabbox
\newbox\pagebox
\newcount\ffigcount
\newcount\ftabcount
\newcount\hangcount
\newcount\nosuccesstryfig
\newcount\nosuccesstrytab
\newdimen\figgutter   \figgutter=1truepc
\newdimen\tabgutter   \tabgutter=1truepc
\newdimen\fl@wd
\newdimen\fl@ht
%\newdimen\fl@gut
\newdimen\htdone      \htdone=\z@
\newdimen\pageht
\newdimen\startpageht
\newdimen\floatfltwidth
\newdimen\fltitemwidth
\newif\iftryingfig     \tryingfigfalse
\newif\iftryingtab     \tryingtabfalse
\newif\ifdoingfig      \doingfigfalse
\newif\ifdoingtab      \doingtabfalse
\newif\iffigprocessing \figprocessingfalse
\newif\iftabprocessing \tabprocessingfalse
\newif\ifpageafterfig  \pageafterfigfalse
\newif\ifpageaftertab  \pageaftertabfalse
\newif\ifoddpages
\newif\ifoutput
\newtoks\outputpretest
\def\@captype{}
%%---------------- ORRIBLE HACKS, SORRY -------------------------%%
\let\old@marginpar\marginpar				% 
\renewcommand\marginpar[1]{{\outputpretest={\outputtrue}% REDEF \marginpar.
			    \old@marginpar{#1}}}	%
\def\g@addto#1#2{{\toks@\expandafter{#1#2}%
		  \xdef#1{\the\toks@}}}%
\def\postpone@captions{%			%
%	\global\let\tmp@label\label		% REDEF \caption AND 
	\global\let\tmp@caption\caption		% \label, LATER.
	\global\let\later@capt\relax		% UN PO' PESANTI 
	\gdef\later@label{}			% MA D'ALTRONDE...
	\renewcommand\caption[1]{\gdef\later@capt{\tmp@caption{##1}}}% LOCAL!!
	\renewcommand\label[1]{\name{ref-##1}%	% TAG WHERE CALLED, AT LEAST,
			       \if@draft\norm@note{}{LAB: ##1}\fi% & DRAFTNOTE.
			       \g@addto\later@label{\old@label{##1}}}%
			}
\AtEndDocument{\iftryingfig\JHEP@warnl{Floating figure \the\ffigcount\space
					remains undone}\fi
		\iftryingtab\JHEP@warnl{Floating table \the\ftabcount\space
					remains undone}\fi}
%%----------------- FIGURE ---------------------------------------%%
\newenvironment{floatingfigure}[1][v]%
{\@tfor \@tempa :=#1\do {\xdef\@fside{\@tempa}}%
 \global\advance\ffigcount by 1%
 \iffigprocessing {\count0=\ffigcount\advance\count0 by -1%
   		   \JHEP@warnl{Floating figures \the\count0\space\space and
       			\the\ffigcount\space colliding}}\fi
 \iftabprocessing  \JHEP@warnl{Floating table \the\ftabcount\space and 
			floating figure \the\ffigcount\space colliding}\fi
 \postpone@captions
 \global\setbox\@tmpbox=\hbox\bgroup% begin of figbox %HBOX FOR AUTO WIDTH!
}
{%
\egroup%				% CALCULATE WIDTH (NO CAPTION FOR NOW)
\global\setlength{\floatfltwidth}{\the\wd\@tmpbox}%
% New behavior:	wd < .6 columnwidth => floatflt.
%		wd < columnwidth    => float{figure}
%		wd > columnwidth    => dblfloat{figure}
\ifdim\floatfltwidth<.6\columnwidth%	% IF NOT TOO WIDE OK:
 \global\setbox\figbox=\vbox{\hsize=\floatfltwidth
			     \def\@captype{figure}%
			     \noindent\unhbox\@tmpbox
			     \later@capt\later@label}%
 \global\figprocessingtrue
 \global\everypar={\tryfig\oldeverypar}% must be set globally!
 \figinsert\par
\else%					% ELSE NORMAL LATEX FIGURE, SIGH.
% \JHEP@mess{Floating figure \the\ffigcount\space is 
%			wide becomes a LaTeX float}%
 \if\@fside v \def\@fside{ht}\fi
 \ifdim\floatfltwidth<\columnwidth
    \def\@tempa{\@float{figure}[}\let\@tempb\end@float
 \else
    \def\@tempa{\@dblfloat{figure}[}\let\@tempb\end@dblfloat
 \fi
 \expandafter\@tempa\@fside]\center\unhbox\@tmpbox\later@capt\later@label\@tempb
\fi
}
%%------------ TABLE ----------------------------------------------%%
\newenvironment{floatingtable}[1][v]%
{\@tfor \@tempa :=#1\do {\global\edef\@tside{\@tempa}}%
 \global\advance\ftabcount by 1%
 \iftabprocessing {\count0=\ftabcount\advance\count0 by -1%
     		   \JHEP@warnl{Floating tables \the\count0\space
            		\space and \the\ftabcount \space colliding}}\fi
 \iffigprocessing  \JHEP@warnl{Floating figure \the\ffigcount\space and 
			floating table \the\ftabcount\space colliding}\fi
 \postpone@captions
 \global\setbox\@tmpbox=\hbox\bgroup% begin of tabbox, ACTUALLY AN HBOX.
}
{%
\egroup% end of \tabbox, 		% ACTUALLY \@tmpbox
\global\setlength{\floatfltwidth}{\the\wd\@tmpbox}%
\ifdim\floatfltwidth<.6\columnwidth%	% IF NOT TOO WIDE OK:
  \global\setbox\tabbox=\vbox{\hsize=\floatfltwidth
			     \def\@captype{table}%
			     \noindent\unhbox\@tmpbox
			     \later@capt\later@label}%
  \global\tabprocessingtrue
  \global\everypar={\trytab\oldeverypar}%
  \tabinsert\par%
\else%					% ELSE NORMAL LATEX TABLE.
%  \JHEP@mess{Floating table \the\ftabcount\space is 
%			wide becomes a LaTeX float}%
  \ifdim\floatfltwidth<1.1\columnwidth
    \if\@tside v \def\@tside{ht}\fi
    \def\@tempa{\@float{table}[}\let\@tempb\end@float
  \else
    \if\@tside v \def\@tside{t}\fi
    \def\@tempa{\@dblfloat{table}[}\let\@tempb\end@dblfloat
  \fi
  \expandafter\@tempa\@tside]%		% ACTUALLY CALL THE LATEX FLOAT
  \center\unhbox\@tmpbox\later@capt\later@label
  \@tempb
\fi%
}
%----------- prepare for tries ----------------------------%
\def\figinsert{%
   \global\nosuccesstryfig=0%
   \global\outputpretest={\do@test}%
   \global\tryingfigtrue \global\doingfigfalse%
   \global\pageafterfigfalse}%
\def\tabinsert{%
   \global\nosuccesstrytab=0%
   \global\outputpretest={\do@test}%
   \global\tryingtabtrue \global\doingtabfalse%
   \global\pageaftertabfalse}%
%----------- init -----------------------------------------%
\AtBeginDocument{%
 \edef\oldoutput{\the\output}
 \output={\the\outputpretest\ifoutput\oldoutput\fi}%
 \outputpretest={\outputtrue}%
 \edef\oldeverypar{\the\everypar}% PERCHE' NESSUNO LO RIMETTE PIU' A POSTO?***
}
%---- tests during \outputpretest -------------------------%
\def\do@test{%
   \ifnum\outputpenalty=-10005
     \setbox\pagebox=\vbox{\unvbox255}%
     \global\pageht=\ht\pagebox
     \global\outputfalse
     \unvbox\pagebox
     \dimen0=\pageht\advance\dimen0 by 2 \baselineskip
     \ifdim\dimen0>\vsize\pagebreak[4]\global\pageht\z@\fi
   \else
     \global\outputtrue
     \ifnum\outputpenalty>-\@Mi			%ie \marginpar's give penalty.
	\ifdoingtab\global\pageaftertabtrue\fi
	\ifdoingfig\global\pageafterfigtrue\fi
     \fi
   \fi}%
%-------- check for side ----------------------------------%
\def\chk@side#1{% DEFINED \fl@sid, BUT IF CHOSEN A DEFAULT, ELIMINATE ALL ***
	{\edef\fl@sid{#1}%
	  \if\fl@sid r\global\oddpagestrue\fi
          \if\fl@sid l\global\oddpagesfalse\fi
          \if\fl@sid p%
              \ifodd\c@page\global\oddpagesfalse
                \else\global\oddpagestrue\fi
          \fi
          \if\fl@sid v%
             \ifnum\theOptionTest=0%
                 \ifodd\c@page\global\oddpagesfalse
                   \else\global\oddpagestrue\fi
             \else
                  \ifodd\theOptionTest\global\oddpagestrue
                    \else\global\oddpagesfalse\fi
             \fi
          \fi
         }}%
%-------- get point in page -------------------------------%
\def\get@pageht{{\everypar={\relax}\setbox0=\lastbox
       		\parindent=\wd0 \parskip=\z@ \par
         	\penalty-10005 \leavevmode}}%
%-------- try at everypar ---------------------------------%
\def\tryfig{%
	\global\fl@ht\ht\figbox
	\global\fl@wd\wd\figbox
	\global\let\fl@gut\figgutter
      \iftryingfig
	\get@pageht
	\dimen0=\vsize
	\advance\dimen0 by -\pageht
	\advance\dimen0 by -2\baselineskip
	\ifdim\dimen0>\fl@ht
	  \chk@side\@fside
	  \dimen0=0.3\baselineskip
	  \vrule depth \dimen0 width \z@%height 1.5\baselineskip
	  \vadjust{\kern -\dimen0
	  \vtop to \dimen0{%
             \baselineskip=\dimen0
             \vss \vbox to 1ex{%
             \ifoddpages
               \hb@xt@\hsize{\hss\copy\figbox}%
             \else% leftsetting
               \hb@xt@\hsize{\copy\figbox\hss}%
             \fi
             \vss}\null}}%
	  \global\tryingfigfalse
	  \global\doingfigtrue
	  \global\startpageht=\pageht
	  \global\htdone=\z@
	  \dohang
	  \ifnum\nosuccesstryfig>0%
	   \JHEP@mess{Flt. fig. \the\ffigcount\space set on page \the\count0, 
	 		shifted \the\nosuccesstryfig\space par(s) forward}%
%	  \else
%	   \JHEP@mess{Floating figure \the\ffigcount\space 
%			set on page \the\count0}%
	  \fi
	\else
          \global\advance\nosuccesstryfig by 1
	\fi
      \else%				% IF NOT TRYING
	\ifdoingfig
	  \get@pageht
	  \global\htdone=\pageht
	  \global\advance\htdone by -\startpageht
	  \ifpageafterfig
	    \global\doingfigfalse% IN CASE A PAGEBREAK JUST BELOW?
	  \else
	    \dimen0=\fl@ht
	    \advance\dimen0 by .85\baselineskip	% .85 ENOUGH: WE ARE AT NEW PAR
%	    \typeout{FLOAT HT: \the\dimen0, HTDONE: \the\htdone}
	    \ifdim\htdone<\dimen0%
		\dohang
	    \else
		\global\doingfigfalse
	    \fi
	  \fi
	  \ifdoingfig\else\global\figprocessingfalse\fi% IF NO MORE DOING.
	\else
	  \global\outputpretest={\outputtrue}% NOT RESTORE EVPAR IF NOT DOING?
	\fi%			% END IF DOING
      \fi%			% END IF TRYING
}
\def\trytab{%
	\global\fl@ht\ht\tabbox
	\global\fl@wd\wd\tabbox
	\global\let\fl@gut\tabgutter
       \iftryingtab
	\get@pageht
       \dimen0=\vsize
       \advance\dimen0 by -\pageht
       \advance\dimen0 by -2\baselineskip
       \ifdim\dimen0>\fl@ht
	 \chk@side\@tside
         \dimen0=0.3\baselineskip
         \vrule depth \dimen0 width \z@
         \vadjust{\kern -\dimen0
         \vtop to \dimen0{%
             \baselineskip=\dimen0
             \vss \vbox to 1ex{%
             \ifoddpages
               \hb@xt@\hsize{\hss\copy\tabbox}%
             \else% leftsetting
               \hb@xt@\hsize{\copy\tabbox\hss}%
             \fi
             \vss}\null}}%
       \global\tryingtabfalse
       \global\doingtabtrue
       \global\startpageht=\pageht
       \global\htdone=\z@
       \dohang
       \ifnum\nosuccesstrytab>0%
	\JHEP@mess{Flt. tab. \the\ftabcount\space set on page \the\count0, 
			shifted \the\nosuccesstrytab\space par(s) forward}%
%       \else
%	\JHEP@mess{Floating table \the\ftabcount\space 
%			set on page \the\count0}%
       \fi
     \else
       \global\advance\nosuccesstrytab by 1
     \fi
     \else
     \ifdoingtab
       \get@pageht
    \global\htdone=\pageht
    \global\advance\htdone by -\startpageht
    \ifpageaftertab
      \global\doingtabfalse
    \else
      \dimen0=\fl@ht
      \advance\dimen0 by .85\baselineskip	% .85 ENOUGH: WE ARE AT NEW PAR
      \ifdim\htdone<\dimen0%
         \dohang
      \else
         \global\doingtabfalse
      \fi
    \fi
    \ifdoingtab\relax\else\global\tabprocessingfalse\fi
  \else
    \global\outputpretest={\outputtrue}%
  \fi
\fi
}
%----- hanging lord -----------------------------%
\def\dohang{%
   \dimen0=\fl@ht
   \advance\dimen0 by -\htdone
   \advance\dimen0 by 1.999\baselineskip	% (16/12/98) WAS 1.49 BUT
   \hangcount=\dimen0				% TEX ROUNDS ON STRICT INTEGERS
   \divide\hangcount by \baselineskip		% IN THIS DIVISION!
%	\typeout{HANGCOUNT: \the\hangcount.}
%   \ifnum\hangcount > 0	% IF ZERO ALSO INDENT MUST BE NULL. (7/6/97)
     \dimen0=\fl@wd
     \advance\dimen0 by \fl@gut
     \ifoddpages
       \global\hangindent=-\dimen0% placing right
     \else 
       \global\hangindent=\dimen0% placing left
     \fi
   \global\hangafter=-\hangcount
%   \fi
}
%----------------------- TWO NEWITEMS ---------------------%
\newcommand{\fltitem}[2][\z@]{\setlength{\fltitemwidth}{\linewidth}%
  \addtolength{\fltitemwidth}{-\floatfltwidth}%
  \addtolength{\fltitemwidth}{-0.5em}%
  \item \parbox[t]{\fltitemwidth}{#2}\\[#1]}
\newcommand{\fltditem}[3][\z@]{\setlength{\fltitemwidth}{\linewidth}%
  \addtolength{\fltitemwidth}{-\floatfltwidth}%
  \addtolength{\fltitemwidth}{-0.5em}%
  \item[#2] \parbox[t]{\fltitemwidth}{#3}\\[#1]}
%%%%%%\endinput
%% 
%% End of ex-file `floatflt.sty'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CAPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{8\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \if@hyper{\edef\@pippo{the\@captype}
	    \name{\@captype\expandafter\csname\@pippo\endcsname}}\fi%
  \vskip\abovecaptionskip
 {\let\label\@gobble%				% FN 10.2.97 REMOVED LATEX BUG:
  \let\index\@gobble%				% LARGE CAPTIONS PROCESS LABEL
  \let\glossary\@gobble%			% TWO TIMES.
  \sbox\@tempboxa{\small {\bfseries #1:} #2}%	% 
  \global\dimen0\wd\@tempboxa}%			%
  \ifdim \dimen0 >\hsize
    \small {\bfseries #1:} #2\par
  \else
    \global\@minipagefalse \sbox\@tempboxa{\small {\bfseries #1:} #2}%
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FONTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\tocsecs{}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \section*{\contentsname\label{-TOC-}}
%        \@mkboth{%
%           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}%
    \@starttoc{toc}%
    \gdef\tableofcontents{\JHEP@igno{\tableofcontents\space already done}}}
\newcommand*\l@part[2]{\def\hyp@typ{part}%	
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \setlength\@tempdima{3em}%
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries \tocsecs#1\hfil \hb@xt@\@pnumwidth{\hss
		\href{\hash pag#2}{#2}}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}
\newcommand*\l@section[2]{\def\hyp@typ{sec}%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.8em}%	%WIDTH OF SECT. N.
    \begingroup
      \let\d@t.%
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
        \tocsecs#1\nobreak\hfil %HREF HERE WOULD GET ALSO THE TITLE(...)
        \nobreak\hb@xt@\@pnumwidth{\hss \href{\hash pag#2}{#2}}\par
    \endgroup
  \fi}

\newcommand*\l@subsection{\def\hyp@typ{sec}\@tocline{2}{1.8em}{2.3em}}
\newcommand*\l@subsubsection{\def\hyp@typ{sec}\@tocline{3}{4.1em}{3.1em}}
\newcommand*\l@paragraph{\def\hyp@typ{sec}\@tocline{4}{7.2em}{4.3em}}
\newcommand*\l@subparagraph{\def\hyp@typ{sec}\@tocline{5}{10.5em}{5em}}

\if@hyper
  \let\old@dtl\@dottedtocline
  \def\@dottedtocline#1#2#3#4#5{\old@dtl{#1}{#2}{#3}{#4}{%
						\href{\hash pag#5}{#5}}}
\fi

\def\@tocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\nobreak
     %\leaders\hbox{$\m@th
     %   \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
     %	   mu$}
     \hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor \href{\hash pag#5}{#5}}%
     \par}%
  \fi}


%%%%%%%%%%%%%%%%%%%%%% LIST OF FIGURES AND TABLES %%%%%%%%%%%%%%%%%%%%%
\if@draft			% ONLY IF DRAFT! ... 
 \newcommand\listoffigures{%
     \section*{\listfigurename
       \@mkboth{\MakeUppercase\listfigurename}%
               {\MakeUppercase\listfigurename}}%
     \@starttoc{lof}%
     }
 \newcommand*\l@figure{\def\hyp@typ{figure}\@dottedtocline{1}{1.5em}{2.3em}}
 \newcommand\listoftables{%
     \section*{\listtablename
       \@mkboth{%
           \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
     \@starttoc{lot}%
     }
 \newcommand*\l@table{\def\hyp@typ{table}\@dottedtocline{1}{1.5em}{2.3em}}
\else
 \newcommand\listoffigures{\JHEP@ignol{List of figures (draft mode only)}}
 \newcommand\listoftables{\JHEP@ignol{List of tables (draft mode only)}}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%***
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]%	%UNFORTUNATELY MODIFIED..
     {\bgroup\small\section*{\refname
        \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}%
      \list{\name{bib\@arabic\c@enumiv}% HOPE!
	    \@biblabel{\@arabic\c@enumiv}}%
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
      \endlist\egroup}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\if@draft
 \let\old@bbt\@bibitem\let\old@lbbt\@lbibitem% LOOK THE DISASTER HERE BELOW.
 \def\@lbibitem[#1]#2{\old@lbbt[#1]{#2}\reversemarginpar{\sf\bfseries\small#2}}
 \def\@bibitem#1{\old@bbt{#1}\reversemarginpar{\sf\bfseries\small#1}}
\fi
\let\@openbib@code\@empty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JOURNALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@spires#1{\href{http://www-spires.slac.stanford.edu/spires/find/hep/www?j=#1}} 
%                               	%PITY THAT target IS NOT IMPLEMENTED.
\catcode`\%=12
\newcommand\adp[3]   {\@spires{ADPHA%2C#1%2C#3}
		{{\it Adv.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\ap[3]    {\@spires{APNYA%2C#1%2C#3}
		{{\it Ann.\ Phys.\ (NY) }{\bf #1} (#2) #3}}
\newcommand\app[3]   {\@spires{APHYE%2C#1%2C#3}
		{{\it Astropart.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\appol[3] {\@spires{APPOL%2C#1%2C#3}
		{{\it Acta Phys.\ Polon.\ }{\bf #1} (#2) #3}}
\newcommand\arnps[3] {\@spires{ARNUA%2C#1%2C#3}
		{{\it Ann.\ Rev.\ Nucl.\ Part.\ Sci.\ }{\bf #1} (#2) #3}}
\newcommand\atmp[3] {\@spires{00203%2C#1%2C#3}
		{{\it Adv.\ Theor.\ Math.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\cpc[3]   {\@spires{CPHCB%2C#1%2C#3}
		{{\it Comput.\ Phys.\ Commun.\ }{\bf #1} (#2) #3}}
\newcommand\cmp[3]   {\@spires{CMPHA%2C#1%2C#3}
		{{\it Comm.\ Math.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\dmj[3]   {\@spires{DUMJA%2C#1%2C#3}
		{{\it Duke Math.\ J. }{\bf #1} (#2) #3}}
\newcommand\epjc[3]  {\@spires{EPHJA%2CC#1%2C#3}
		{{\it Eur.\ Phys.\ J. }{\bf C #1} (#2) #3}}
\newcommand\jmp[3]   {\@spires{JMAPA%2C#1%2C#3}
		{{\it J.\ Math.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\jgp[3]   {\@spires{JGPHE%2C#1%2C#3}
		{{\it J.\ Geom.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\jphg[3]   {\@spires{JPAGB%2CG#1%2C#3}
		{{\it J. Phys.\ }{\bf G #1} (#2) #3}}
\newcommand\cqg[3]   {\@spires{CQGRD%2C#1%2C#3}
		{{\it Class.\ and Quant.\ Grav.\ }{\bf #1} (#2) #3}}
\newcommand\hpa[3]   {\@spires{HPACA%2C#1%2C#3}
		{{\it Helv.\ Phys.\ Acta }{\bf #1} (#2) #3}}
\newcommand\jhep[3]  {\href{http://jhep.sissa.it/stdsearch?paper=#1%28#2%29#3}
		{{\it J. High Energy Phys.\ }{\bf #1} (#2) #3}}
\newcommand\lmp[3]   {\@spires{LMPHD%2CA#1%2C#3}
		{{\it Lett.\ Math.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\npa[3]   {\@spires{NUPHA%2CA#1%2C#3}
		{{\it Nucl.\ Phys.\ }{\bf A #1} (#2) #3}}
\newcommand\npb[3]    {\@spires{NUPHA%2CB#1%2C#3}
		{{\it Nucl.\ Phys.\ }{\bf B #1} (#2) #3}}
\newcommand\npps[3]  {\@spires{NUPHZ%2C#1%2C#3}
		{{\it Nucl.\ Phys.\ }{\bf #1} {\it(Proc.\ Suppl.)} (#2) #3}}
\newcommand\pla[3]   {\@spires{PHLTA%2CA#1%2C#3}
		{{\it Phys.\ Lett.\ }{\bf A #1} (#2) #3}}
\newcommand\plb[3]   {\@spires{PHLTA%2CB#1%2C#3}
		{{\it Phys.\ Lett.\ }{\bf B #1} (#2) #3}}
\newcommand\ppnp[3]  {\@spires{PPNPD%2C#1%2C#3}
		{{\it Prog.\ Part.\ Nucl.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\pr[3]    {\@spires{PHRVA%2C#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf #1} (#2) #3}}
\newcommand\pra[3]   {\@spires{PHRVA%2CA#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf A #1} (#2) #3}}
\newcommand\prb[3]   {\@spires{PHRVA%2CB#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf B #1} (#2) #3}}
\newcommand\prc[3]   {\@spires{PHRVA%2CC#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf C #1} (#2) #3}}
\newcommand\prd[3]   {\@spires{PHRVA%2CD#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf D #1} (#2) #3}}
\newcommand\pre[3]   {\@spires{PHRVA%2CE#1%2C#3}
		{{\it Phys.\ Rev.\ }{\bf E #1} (#2) #3}}
\newcommand\prep[3]  {\@spires{PRPLC%2C#1%2C#3}
		{{\it Phys.\ Rep.\ }{\bf #1} (#2) #3}}
\newcommand\prl[3]   {\@spires{PRLTA%2C#1%2C#3}
		{{\it Phys.\ Rev.\ Lett.\ }{\bf #1} (#2) #3}}
\newcommand\ptp[3]   {\@spires{PTPKA%2C#1%2C#3}
		{{\it Prog.\ Theor.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\rmp[3]   {\@spires{RMPHA%2C#1%2C#3}
		{{\it Rev.\ Mod.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\zpc[3]   {\@spires{ZEPYA%2CC#1%2C#3}
		{{\it Z.\ Physik }{\bf C #1} (#2) #3}}
\newcommand\mpla[3]  {\@spires{MPLAE%2CA#1%2C#3}
		{{\it Mod.\ Phys.\ Lett.\ }{\bf A #1} (#2) #3}}
\newcommand\mplb[3]  {\@spires{MPLAE%2CB#1%2C#3}
		{{\it Mod.\ Phys.\ Lett.\ }{\bf B #1} (#2) #3}}
\newcommand\sjnp[3]  {\@spires{SJNCA%2C#1%2C#3}
		{{\it Sov.\ J.\ Nucl.\ Phys.\ }{\bf #1} (#2) #3}}
\newcommand\jetp[3]  {\@spires{SPHJA%2C#1%2C#3}
		{{\it Sov.\ Phys.\ JETP\/ }{\bf #1} (#2) #3}}
\newcommand\jetpl[3]  {\@spires{JTPLA%2C#1%2C#3}
		{{\it Sov.\ Phys.\ JETP Lett.\ }{\bf #1} (#2) #3}}
\newcommand\zetf[3]  {\@spires{ZETFA%2C#1%2C#3}
		{{\it Zh.\ Eksp.\ Teor.\ Fiz.\ }{\bf #1} (#2) #3}}
\newcommand\yf[3]    {\@spires{YAFIA%2C#1%2C#3}
		{{\it Yad.\ Fiz.\ }{\bf #1} (#2) #3}}
\newcommand\nc[3]    {\@spires{NUCIA%2C#1%2C#3}
		{{\it Nuovo Cim.\ }{\bf #1} (#2) #3}}
\newcommand\joth[3]  {\@spires{JOTHE%2C#1%2C#3}
		{{\it J.\ Operator Theory }{\bf #1} (#2) #3}}
\newcommand\ibid[3]{{\it ibid.\ }{\bf #1} (#2) #3}
\newcommand\ijmpa[3] {\@spires{IMPAE%2CA#1%2C#3}
		{{\it Int.\ J.\ Mod.\ Phys.\ }{\bf A #1} (#2) #3}}
\newcommand\ijmpb[3] {\@spires{IMPAE%2CB#1%2C#3}
		{{\it Int.\ J.\ Mod.\ Phys.\ }{\bf B #1} (#2) #3}}
\catcode`\%=14
\catcode`\|=12
% HEPTH's: \hepth{9912999} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\hepth}[1]{\href{http://xxx.lanl.gov/abs/hep-th/#1}{\tt hep-th/#1}}
\newcommand{\hepph}[1]{\href{http://xxx.lanl.gov/abs/hep-ph/#1}{\tt hep-ph/#1}}
\newcommand{\heplat}[1]{\href{http://xxx.lanl.gov/abs/hep-lat/#1}{\tt hep-lat/#1}}
\newcommand{\hepex}[1]{\href{http://xxx.lanl.gov/abs/hep-ex/#1}{\tt hep-ex/#1}}
\newcommand{\nuclth}[1]{\href{http://xxx.lanl.gov/abs/nucl-th/#1}{\tt nucl-th/#1}}
\newcommand{\nuclex}[1]{\href{http://xxx.lanl.gov/abs/nucl-ex/#1}{\tt nucl-ex/#1}}
\newcommand{\grqc}[1]{\href{http://xxx.lanl.gov/abs/gr-qc/#1}{\tt gr-qc/#1}}
\newcommand{\qalg}[1]{\href{http://xxx.lanl.gov/abs/q-alg/#1}{\tt q-alg/#1}}
\newcommand{\accphys}[1]{\href{http://xxx.lanl.gov/abs/accphys/#1}{\tt accphys/#1}}
\newcommand{\alggeom}[1]{\href{http://xxx.lanl.gov/abs/alg-geom/#1}{\tt alg-geom/#1}}
\newcommand{\astroph}[1]{\href{http://xxx.lanl.gov/abs/astro-ph/#1}{\tt astro-ph/#1}}
\newcommand{\chaodyn}[1]{\href{http://xxx.lanl.gov/abs/chao-dyn/#1}{\tt chao-dyn/#1}}
\newcommand{\condmat}[1]{\href{http://xxx.lanl.gov/abs/cond-mat/#1}{\tt cond-mat/#1}}
\newcommand{\nlinsys}[1]{\href{http://xxx.lanl.gov/abs/nlin-sys/#1}{\tt nlin-sys/#1}}
\newcommand{\quantph}[1]{\href{http://xxx.lanl.gov/abs/quant-ph/#1}{\tt quant-ph/#1}}
\newcommand{\solvint}[1]{\href{http://xxx.lanl.gov/abs/solv-int/#1}{\tt solv-int/#1}}
\newcommand{\suprcon}[1]{\href{http://xxx.lanl.gov/abs/supr-con/#1}{\tt supr-con/#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BopHook %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\if@preprint\else
\if@proc
\newcommand\PrHEP[1]{\special{!userdict begin
/iseven {dup dup 2 idiv 2 mul eq} bind def
/BHend {
  translate rotate 
/Courier findfont 30 scalefont setfont 
0 0  moveto 0.80 setgray (PrHEP#1) show grestore}
 bind def
statusdict /duplexmode known 
  {statusdict begin duplexmode end}
  {false}
ifelse
  {/bop-hook {gsave iseven {-90 550 570} {+90 50 300} ifelse BHend} def}
  {/bop-hook {gsave         -90 550 570                      BHend} def}
ifelse 
end
}\let\PrHEP\gobble}\else
\newcommand\JHEP[1]{\special{!userdict begin
/iseven {dup dup 2 idiv 2 mul eq} bind def
/BHend {
  translate rotate 
/Courier findfont 30 scalefont setfont 
0 0  moveto 0.80 setgray (JHEP#1) show grestore}
 bind def
statusdict /duplexmode known 
  {statusdict begin duplexmode end}
  {false}
ifelse
  {/bop-hook {gsave iseven {-90 550 570} {+90 50 300} ifelse BHend} def}
  {/bop-hook {gsave         -90 550 570                      BHend} def}
ifelse 
end
}\let\JHEP\gobble}\fi
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INDEX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%..?
%\newenvironment{theindex}	% REMOVED
%               {\if@twocolumn
%                  \@restonecolfalse
%                \else
%                  \@restonecoltrue
%                \fi
%                \columnseprule \z@
%                \columnsep 35\p@
%                \twocolumn[\section*{\indexname}]%
%                \@mkboth{\MakeUppercase\indexname}%
%                        {\MakeUppercase\indexname}%
%                \thispagestyle{plain}\parindent\z@
%                \parskip\z@ \@plus .3\p@\relax
%                \let\item\@idxitem}
%               {\if@restonecol\onecolumn\else\clearpage\fi}
%\newcommand\@idxitem{\par\hangindent 40\p@}
%\newcommand\subitem{\@idxitem \hspace*{20\p@}}
%\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
%\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOOTNOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand\footnoterule{%	% NO HYPER...
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NAMES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\contentsname{Contents}
\if@draft\newcommand\listfigurename{List of Figures}
	 \newcommand\listtablename{List of Tables}\fi
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract:}
\newcommand\keywordsname{Keywords:}
\newcommand\receivedname{Received:}
\newcommand\acceptedname{Accepted:}
\newcommand\acknowlname{Acknowledgments}

\newcommand\today{}
\edef\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}

\setlength\columnsep{20\p@}
\setlength\columnseprule{0\p@}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\pagestyle{plain}
\pagestyle{JHEP}
\pagenumbering{arabic}
\@addtoreset{equation}{section}
\if@preprint\else\if@proc\else
		\let\pagestyle\@gobble
		\let\thispagestyle\@gobble
		\let\pagenumbering\@gobble\fi\fi
%\if@twoside\else\raggedbottom\fi
  \onecolumn
						
% FOR REQUESTED FRONTMATTER ...
\AtBeginDocument{\bgroup%		SOME NICE (LOCAL) MESSAGES... 
	\def\@APPwarn#1{\JHEP@warnl{\protect#1 should appear 
					before \protect\begin{document}}}%
	\def\@APPerr#1{\ClassError{JHEP}{\protect#1 should appear 
					before \protect\begin{document}}}%
	\def\@PROCerr{\ClassError{JHEP}{A single \protect\author 
					should appear, in proceedings. 
					Use \protect\thanks.}}%
%	\if@title\else\@APPerr{Some \protect\title{...}}\fi%
	\if@author\else\@APPerr{Some \protect\author{...}}\fi
	\if@abstract\else\@APPerr{\abstract{...}}\fi
%	\if@email\else\@APPwarn{\email}\fi%
	\if@keywords\else\@APPwarn{\keywords{...}}\fi
	\if@preprint
		\if\@preprint\relax\@APPwarn{\preprint{...}}\fi
	\else
		\if@proc\if@conf\else\@APPwarn{\conference{...}}\fi
		\else	\if@rece\else\@APPwarn{\received{...}}\fi
			\if@acce\else\@APPwarn{\accepted{...}}\fi
		\fi
	\fi
	\egroup
	\auto@maketitle}% IN THE BEGINNING THERE WAS THE TITLE, TYPESET IN TeX 
\endinput
%% 
%% End of file `JHEP.cls'.
