%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% JINST.cls 1.0.4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This file is Copyright JINST 2006:  it can be freely distributed  but
%% NOT modified preserving its name, even in similar forms.
%%
%% JINST.cls is a LaTeX2e class file used to typeset manuscripts in
%% Journal of Instrumentation (http://jinst.sissa.it) style. It was
%% written by P. Dall'Aglio as a modification of the class JHEP3.cls
%%
%% JINST.cls is only for internal use of the JINST typesetting office.
%%
%% For bugs, comments, suggestions email to jinst-eo@jhep.sissa.it
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
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{JINST} [2015/06/07 v1.0.4 LaTeX document class - P.D.]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\logo{\raisebox{-10.5\p@}{\hb@xt@85\p@{\includegraphics{JINSTlogo}\hfil}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW SWITCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@preprint\@preprinttrue		% DEFAULT IS PREPRINT!
\newif\if@draft   \@draftfalse			% DEFAULT IS NOT DRAFT
\newif\if@hyper   \@hypertrue			% DEFAULT IS HYPER
\newif\if@proc	  \@procfalse			% DEFAULT IS NOT PROC
\newif\if@tech \@techfalse                      % DEFAULT IS NOT TECHNICAL REPORT
\newif\if@author\@authorfalse			%
\newif\if@abstract\@abstractfalse		% FOR FRONTMATTER DECLARATIONS
\newif\if@keywords\@keywordsfalse		%
\newif\if@todotoc\@todotocfalse			%
\newif\if@rece\@recefalse			%
\newif\if@revi\@revifalse			%
\newif\if@acce\@accefalse			%
\newif\if@publi\@publifalse			%
\newif\if@Jcopy\@Jcopyfalse			%
\newif\if@conf\@conffalse			%
\newif\if@Jspecialurl\@Jspecialurlfalse
\newif\if@Jcits\@Jcitsfalse

\RequirePackage{ifpdf}
%\newif\ifpdf
%\ifx\pdfoutput\undefined
%\else
%  \ifx\pdfoutput\relax
%  \else
%    \ifcase\pdfoutput
%    \else
%      \pdftrue
%    \fi
%  \fi
%\fi


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

\newcommand\@ptsize{1}                          % DEFAULT SIZE IS 11 PT

\DeclareOption{published}{%
\ifpdf
%\JINST@warnl{Option 'published' incompatible with
%pdf output, turning to dvi output}\pdffalse\pdfoutput=0
\@preprintfalse
\else
\@preprintfalse%
\fi}
\DeclareOption{tech}{\@techtrue}
\DeclareOption{nocits}{\if@preprint\@OImess{ is default for preprints}\else
		       \@Jcitsfalse
                       \fi}

\DeclareOption{cits}{%\if@preprint
                     \@Jcitstrue %\else
                     %\@OImess{ is automatic for published papers}\fi
                     }

\DeclareOption{hyper}{\@hypertrue}	% HYPER IS 11 PT
\DeclareOption{nohyper}{\@hyperfalse}	% PAPER IS ALSO 11 PT (v1.3)
\DeclareOption{paper}{\@hyperfalse}	% PAPER IS ALSO 11 PT
\DeclareOption{11pt}{\renewcommand\@ptsize{1}\ExecuteOptions{@FONT}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}\ExecuteOptions{@FONT}}
\if@compatibility\else                          % LATEX2.09 HAS NO 10PT
\DeclareOption{10pt}{\renewcommand\@ptsize{0}\ExecuteOptions{@FONT}}% v1.4
\fi       				% CHOSEN TO FREE MEMORY LATER:
\DeclareOption{@FONT}{\if@preprint              % IF PREPRINT ALLOW ANY,
                        \else			              % IF PUBLISHED:
			\renewcommand\@ptsize{1}\@NFmess{11pt}% ALWAYS 11PT
                        \fi
			}

\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}\fi
\DeclareOption{twoside}{\if@preprint\if@hyper\@OImess{ in hyper-mode}
				    \else\@twosidetrue\@mparswitchtrue\fi
			\else			% FOR PUBLISHED
			\@OImess{ in published papers}
			\fi}
\DeclareOption{notoc}{\if@preprint		% to disable TOC
			\AtBeginDocument{\@todotocfalse}
			\else
			\@OImess{ in JINST papers}
			\fi}
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
			\framebox[\textwidth]{\sf\small JINST DRAFT
			\ttfamily(\cur@opt)\hfill\sf\bfseries\jobname\sf,
			\today, \militarytime}}}
	\@drafttrue}

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
\newcommand\JINST@mess[1]{\typeout{Class JINST Message: \protect#1.}}%
\newcommand\JINST@warn[1]{\ClassWarning{JINST}{#1}}
\newcommand\JINST@warnl[1]{\ClassWarningNoLine{JINST}{#1}}
\newcommand\JINST@igno[1]{\JINST@warn{IGNORED \protect#1}}
\newcommand\JINST@ignol[1]{\JINST@warnl{IGNORED \protect#1}}
\newcommand\@OImess[1]{\JINST@ignol{OPTION '\CurrentOption'#1}}
\newcommand\@NFmess[1]{\JINST@mess{Normalsize set to #1}}
\newcommand\@ENVwarn[1]{\JINST@warn{Please use \protect#1 in place
						of LaTeX environment}}
%%%%%%%%%%%%%%%%%%%%%%%%%% PROCESS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExecuteOptions{a4paper,oneside,hyper} %WERE ALSO 10pt,onecolumn
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%%%%% REQUIRED PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{amssymb}
\RequirePackage[T1]{fontenc}
\RequirePackage{times}
\RequirePackage{mathptmx}
\ifpdf
      \RequirePackage[pdftex]{graphicx}
      \DeclareGraphicsExtensions{.pdf,.jpg,.jpeg}
\else
      \RequirePackage{graphicx}
      \DeclareGraphicsExtensions{.ps,.eps,.pstex}
\fi
%%%%%%%%%%%%%%%%%%%%%%%% TRICKS FOR DOTLESS J %%%%%%%%%%%%%%%%%%%%%%%%%
%\j and \jmath are missing in font Times. So I use the ones from
% Computer Modern. Works acceptably, but in sf
\DeclareSymbolFont{forjmath}{OT1}{cmr}{m}{sl}
\DeclareMathSymbol{\Jmath}{\mathord}{forjmath}{'021}
\def\jmath{\Jmath}
\DeclareFontFamily{OT1}{cmr}{}
\DeclareFontFamily{OT1}{cmss}{}
\def\j{\ifmmode\Jmath\else{\fontencoding{OT1}\fontfamily{cmr}\selectfont\char'021}\fi}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END DOTLESS J %%%%%%%%%%%%%%%%%%%%%%%%%%%%



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

\setcounter{topnumber}{4}
\renewcommand\topfraction{1} % default .7
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.6} %.2		% .6 ???***
\setcounter{totalnumber}{5}
\renewcommand\textfraction{0}
\renewcommand\floatpagefraction{1}
\setcounter{dbltopnumber}{3}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{1}

\textwidth  .72\paperwidth	% WIDTH OF TEXT, REMAINS .28% FOR MARGINS
%
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
%%%%%%%%%%%%%%%%%%%%%%% HYPER (AND DRAFT) STUFF %%%%%%%%%%%%%%%%%%%%%%%
\ifpdf
      \input pdfcolor.tex
\else
\fi

\bgroup\catcode`\#=12\gdef\hash{#}\egroup	% DEFINED \hash=#.
\def\H@tilde{\string~}
\newcommand{\href}[2]{\rule{0pt}{0pt}\bgroup\let~\H@tilde
		      \if@hyper\ifpdf
				    \def\hash{}%
				    \pdfstartlink attr{/Border [1 1 1] /C [0 0 1]}
                                    user{/Subtype /Link /A << /S /URI /URI (#1) >>}%
					\pdfsetcolor{0 0 0 1}%
				\else
				    \noexpand\special{html:<A href="#1">}%
				\fi
		      \fi
		      \rule{.2ex}{0pt}\rule[-.5ex]{0pt}{2.2ex}{#2}\rule[-.5ex]{0pt}{2.2ex}\rule{.1ex}{0pt}\egroup
		      \if@hyper\ifpdf
				    \Black\pdfendlink
			       \else
				    \special{html:</A>}%
			       \fi
                      \fi
		      }
% \intPlink was added because in pdflatex you need two different commands
% for internal and external links. For latex they are the same.
\newcommand{\intJlink}[2]{\rule{0pt}{0pt}\bgroup\let~\H@tilde
                        \if@hyper\ifpdf
                                       \def\hash{}%
                                       \pdfstartlink attr{/Border [1 1 1] /C [0 0 1]}
                                          goto name{#1}%
                                       \pdfsetcolor{0 0 0 1}%
				  \else
                                       \noexpand\special{html:<A href="#1">}%
				  \fi
			\fi
                        \rule[-.2ex]{0pt}{1.8ex}{#2}\rule[-.2ex]{0pt}{1.8ex}\egroup
                        \if@hyper\ifpdf
                                      \Black\pdfendlink
				 \else
                                      \special{html:</A>}%
                                 \fi
                        \fi
                        }


\newcommand{\name}[1]{{\if@hyper\ifpdf
				    \pdfdest name{#1} fith%
			       \else
				    \noexpand\special% NAME HAS NO TAGGED TEXT HERE.
					{html:<A name="#1">}\special{html:</A>}%
			       \fi
		      \fi}%
		      }
\newcommand{\base}[1]{\if@hyper\ifpdf
                        \relax\JINST@warn{Command base undefined for pdf output}
			%\pdfdest baseurl{#1} fith%
                       \else
                        \bgroup\let~\H@tilde
			\noexpand\special	% BASE HAS NO TAGGED TEXT.
			{html:<base href="#1">}\egroup
                       \fi\fi}
%------------------------------------------------------------------%
% SECTION TAGS and  THEIR REFERENCE IN TOC \d@t will be '.' for sections only
\if@hyper
\renewcommand{\@seccntformat}[1]{\name{sec\csname the#1\endcsname}%
				 \csname the#1\endcsname\d@t\hspace{1ex}}
\renewcommand{\numberline}[1]{\hb@xt@\@tempdima{\intJlink
			      {\hash\hyp@typ#1}{#1}\d@t\hfil}}
\else
\renewcommand{\@seccntformat}[1]{\csname the#1\endcsname\d@t\hspace{1ex}}
\renewcommand{\numberline}[1]{\hb@xt@\@tempdima{#1\d@t\hfil}}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% this is to obtain collapsing citations %%%%%%%%%%%%%%%%%%
\if@Jcits                             % only if 'cits' option is chosen
\newcount\@tempcntc
\def\@citex[#1]#2{%
  \@tempcnta\z@\@tempcntb\m@ne\def\@citea{}%
  \@cite{\@for\@citeb:=#2\do%                                               for aech citation...
         {\edef\@citeb{\expandafter\@firstofone\@citeb}%                    eat trailing space
          \if@filesw\immediate\write\@auxout{\string\citation{\@citeb}}\fi% write to aux
          \@ifundefined{b@\@citeb}%                                         if label undefined..
                       {\@citeo\@tempcntb\m@ne\@citea%                      ... then ...
                        \def\@citea{,\penalty\@m\ }{\reset@font\bf ?}%
	                \G@refundefinedtrue\@latex@warning%
                        {Citation `\@citeb' on page \thepage \space undefined}}%
                       {\setbox\z@\hbox{\global\@tempcntc0\csname %         ... else
                                        b@\@citeb\endcsname}%
                        \advance\@tempcntb\@ne%
                        \ifnum\@tempcntb=\@tempcntc%
                        \else\advance\@tempcntb\m@ne\@citeo%
                             \@tempcnta\@tempcntc\@tempcntb\@tempcntc
                        \fi%
                        }%
         }\@citeo}{#1}%
	 \if@draft\norm@note{CIT: }{#2}\fi			% **DRAFT**
    }% end definition of \@citex
%This really prints out the cit-numbers
\def\@citeo{\ifnum\@tempcnta>\@tempcntb%
            \else\@citea\def\@citea{,\penalty\@m\ }%
                  \ifnum\@tempcnta=\@tempcntb%
                  \intJlink{\hash bib\the\@tempcnta}{\the\@tempcnta}% if there is no range
                  \else{\advance\@tempcnta\@ne%                 % if there is a range
                       \ifnum\@tempcnta=\@tempcntb%
                       \else\def\@citea{\,--\,}%
                       \fi%
                       \advance\@tempcnta\m@ne%
                       \intJlink{\hash bib\the\@tempcnta}{\the\@tempcnta}\@citea%first
                       \intJlink{\hash bib\the\@tempcntb}{\the\@tempcntb}}%last
                  \fi%
             \fi}
%%%%%%%%%%%%%%% until here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------------------%
% CITATION TAGS ARE TOGETHER WITH BIB STUFF.
% CITATION HREF
\else             % w.r.t. \if@Jcits above
\def\@citex[#1]#2{%			% UNFORTUNATELY REDEFINED!!!!
  \let\@citea\@empty
  \@cite{\@for\@citeb:=#2\do
    {\@citea\def\@citea{,\penalty\@m\ }%
     \edef\@citeb{\expandafter\@firstofone\@citeb}%
     \if@filesw\immediate\write\@auxout{\string\citation{\@citeb}}\fi
     \@ifundefined{b@\@citeb}{\mbox{\reset@font\bf ?}%
	\G@refundefinedtrue
	\@latex@warning
	  {Citation `\@citeb' on page \thepage \space undefined}}%
	{\edef\tmp@bn{\csname b@\@citeb\endcsname}%
	 \hbox{\intJlink{\hash bib\tmp@bn}{\tmp@bn}}}}}{#1}%		% **HYPER**
	 \if@draft\norm@note{CIT: }{#2}\fi			% **DRAFT**
	 }
\fi             % w.r.t. \if@Jcits above

%-----------------------------------------------------------------%
% LABEL, REF AND PAGEREF, TEXTREF, ~ COMPATIBLE:
\let\old@label\label						% OLD LATEX COMMAND.
\def\label{\bgroup\catcode`\>=15\catcode`\"=15 \catcode`\==15\@@label}
\newcommand{\@@label}[1]{\egroup\name{ref-#1}%		% LABEL IN HYPER TAG.
			 \old@label{#1}%		%
			 \if@draft%			% DRAFT:
			 \ifmmode\math@note{#1}%
			 \else\norm@note{}{LAB: #1}\fi%
			 \fi%
			 }
\if@hyper
\let\old@ref\ref \let\old@pageref\pageref		% OLD LATEX COMMANDS.
\renewcommand{\ref}[1]{\@ifundefined{r@#1}{}{\intJlink{\hash ref-#1}}%
		       {\old@ref{#1}}} % LABEL INSIDE HREF.
\renewcommand{\pageref}[1]{\@ifundefined{r@#1}{}{%	% UNDEFINED => NO HREF
	      \edef\tmp@ref{\noexpand\@secondoftwo\csname r@#1\endcsname}%
	      \intJlink{\hash pag\tmp@ref}}{\old@pageref{#1}}}
\fi
\newcommand{\textref}[2]{\@ifundefined{r@#1}
			{%
			\protect\G@refundefinedtrue
			\nfss@text{\reset@font\bf ?#2?}%
   			\@latex@warning{Reference `#1' on page \thepage \space
				             undefined}}
			{\vrule height \z@ width \z@\intJlink{\hash ref-#1}{#2}}}
%------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%% END HYPER-STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% JINST HEADINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ps@JINST{%
    \def\@oddfoot{\ifnum\thepage=0\if@preprint\else
		\Jcopyright@box\fi\hfill % copyright only on front page of published papers
		\if@Jspecialurl\copy\Jspecial@url\else\if@preprint\else\copy\Jpaper@url\fi\fi %possible url
		\else\reset@font\hfil-- \thepage\ --\hfil\fi} % page numbers on other pages
    \if@draft\edef\cur@opt{\@curroptions}\fi
    \def\@oddhead{\name{pag\thepage}\hfil\if@draft\copy\drft@box\fi}
    \if@twoside\let\@evenhead\@oddhead\let\@evenfoot\@oddfoot\fi
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TITLE PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\maketitle{\JINST@ignol{\maketitle}}
\newcommand\auto@maketitle{\begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{\hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \let\footnote\thanks%
	 \newpage				%
	 \@maketitle				% CALL ACTUAL FORMATTING
	 \@thanks				% TITLE THANKS
	 \thispagestyle{JINST}
 	 \setcounter{page}\z@
	 \newpage				% FINE PAGINA
  \endgroup
  \setcounter{footnote}{0}%
  \if@todotoc					% IF THERE IS A SECTION
      \noindent\rule\textwidth{.1pt}		% THEN MAKE TOC...
      \vskip 2em \@plus 3ex \@minus 3ex
      \tableofcontents
      \vskip 2em \@plus 3ex \@minus 3ex
      \noindent\rule\textwidth{.1pt}
      \vskip 2em \@plus 3ex \@minus 3ex
  \fi
  \if@preprint\else
      \gdef\tableofcontents{\JINST@igno{\tableofcontents\space is automatic}}
  \fi
  \global\let\thanks\@gobble
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
  \global\let\revised\relax
  \global\let\accepted\relax
  \global\let\published\relax
  \global\let\JINSTcopydate\relax
  \global\let\Jspecialurl\relax
  \global\let\keywords\relax
  \global\let\endkeywords\relax
}
%%%%%%%%%%%%%%%%%%%%%%%%%% ACTUAL TITLEPAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%
\newskip\titlesk@ja		% Skips for titlepage
\newskip\titlesk@jb		%
\newskip\titlesk@jc		%
\titlesk@ja= 1.6em plus .4fil%			% Before title
\titlesk@jb= 2em   plus .06fil minus  .5ex%	% Between title/rule
\titlesk@jc= 2em   plus .05fil minus 1.2ex%	% Before authors

\def\@maketitle{%				% PAGE IS FLUSHED LEFT
\begin{flushleft}%				% PAY ATTENTION TO \par'S
% page with queries for authors in proof
\if@Jqueries
    \setcounter{page}{0}
\noindent{\let\thanks\@gobble\let\footnote\@gobble%
          \large\sffamily\@title\par}                     % title
\vskip.4\titlesk@jb
\noindent{\Large\sffamily\bfseries\queriesname\hfill\par} % queriesname
\vskip.7\titlesk@jb
    \hrule height 1\p@%            otherwise = 1.5pt.     % rule
\vskip.7\titlesk@jb
{\noindent\footnotesize Please reply to the following queries using
the appropriate tool ``{\sc send proofs}'' at the bottom of the
preprint page on \href{http://jinst.sissa.it}{\tt http://jinst.sissa.it}}
\vskip\titlesk@jc
\Jqueries@auth                                            % queries
    \newpage
    \setcounter{page}{0}
\fi
%header for preprints
\if@preprint					%%% PREPRINT HEADER:
    \vskip-7em					%
    \underline{\tiny Preprint typeset 		%
                in JINST style -		        %
  		\if@hyper{HYPER VERSION}	%
		\else{PAPER VERSION}\fi } 	%
    \normalsize\hfill%				%
    \begin{tabular}[t]{r}\@preprint\end{tabular}%   % PREPRINT NUMBERS
%header for technical reports
\else						%
% header for published papers
    \vskip-7em\hfill
    {\small\scshape Published by Institute of Physics
 	               Publishing and SISSA}
    \vskip-1.35\baselineskip\logo\hrulefill
    \vskip-1.5\baselineskip\hskip21.73\p@%
    \hfill{\parbox[t]{30em}{\begin{flushright}\setlength\baselineskip{11pt}\footnotesize
				\Jrece@cs\\
				\if@revi\Jrevi@cs\\\fi
				\Jacce@cs\\
				\Jpubli@cs
			      \end{flushright}}}%
\fi\null
% end headers

\if@tech					%%% TECHNICAL REPORT HEADER:
    {\sffamily \bfseries \scshape technical report}
\fi

\vskip \titlesk@ja		   % vspace before title
% TITLE large sans-serif bf
{\LARGE \sffamily\bfseries\@title\par}
%
\vskip \titlesk@jb                 % vspace between title and rule
% RULE
\hrule height 1.5\p@%
%
\vskip \titlesk@jb		   % vspace between rule and authors
% AUTHORS\\ADDRESSES
\vskip-\auth@skip
{\normalsize \bfseries \sffamily \@author \par}
%
\vskip \titlesk@jc                 % vspace between authors and abstract
% ABSTRACT
\parbox\textwidth{\abstract@cs}%
\normalsize                        % why reset size?
% KEYWORDS IF PRESENT
\if@keywords
\vskip .9\titlesk@jc	   % vspace between abstract and keywords
\par
\@keywords
\fi
% DEDICATION, IF PRESENT
\dedic@box
\end{flushleft}%			% FINISHED.
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
      \addcontentsline{toc}{part}{\string\intJlink	% UNFORTUNATELY, NO NUMBERLINE:
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
\def\bef@sec{\iffigprocessing\JINST@warnl{Floating figure \the\ffigcount\space
						and startsection colliding}\fi
	     \iftabprocessing\JINST@warnl{Floating table \the\ftabcount\space
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
\renewcommand{\section}{\secdef\JINST@sec\JINST@secs}
\renewcommand{\subsection}{\secdef\JINST@ssec\JINST@ssecs}
\renewcommand{\subsubsection}{\secdef\JINST@sssec\JINST@sssecs}
\renewcommand{\paragraph}{\secdef\JINST@par\JINST@pars}
\renewcommand{\subparagraph}{\secdef\JINST@spar\JINST@spars}
% ---- unstarred forms ---- %
\def\JINST@sec[#1]#2{\ts@flag\bef@sec\old@sec[#1]{#2}\aft@sec}
\def\JINST@ssec[#1]#2{\bef@sec\old@ssec[#1]{#2}\aft@sec}
\def\JINST@sssec[#1]#2{\bef@sec\old@sssec[#1]{#2}\aft@sec}
\def\JINST@par[#1]#2{\bef@sec\old@par[#1]{#2}\aft@sec}
\def\JINST@spar[#1]#2{\bef@sec\old@spar[#1]{#2}\aft@sec}
% ----- starred forms ----- %
\def\JINST@secs#1{\bef@sec\old@sec*{#1}\aft@sec}
\def\JINST@ssecs#1{\bef@sec\old@ssec*{#1}\aft@sec}
\def\JINST@sssecs#1{\bef@sec\old@sssec*{#1}\aft@sec}
\def\JINST@pars#1{\bef@sec\old@par*{#1}\aft@sec}
\def\JINST@spars#1{\bef@sec\old@spar*{#1}\aft@sec}
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
% *** if no address nobody closes the box!
\newif\if@speaker\@speakerfalse
\newif\if@dblspeak\@dblspeakfalse
\newtoks\prev@t
\newtoks\cur@t
\newbox\@firstaubox
\newskip\addr@skip\addr@skip=.6em\@plus.02fil\@minus.3ex %\fi
\newskip\auth@skip\auth@skip=.6em\@plus.03fil\@minus.2ex %\fi
\renewcommand\@author{\parskip\z@
		      \def\\{\egroup			% CLOSE & aftergroup!
			\par				% FIRST TIME \\=>ADDR.
			\vskip\addr@skip		% GLUE UNDER AUTHOR
			\hskip1em%			% ADDRESS INDENT
			\vbox\bgroup\hsize=.9\textwidth	%
			\small\it\raggedright		% STYLE FOR ADDRESSES
			\def\\{\par\leavevmode\ignorespaces}%\let\\\relax%
			\leavevmode\ignorespaces}%
			}
\renewcommand\author[1]{%
		\global\@authortrue			%
		\prev@t=\expandafter{\@author}%		% TWO TOKEN LISTS.
		\cur@t={\vskip\auth@skip		% glue before auth.
			\vtop\bgroup #1\egroup		% ACTUAL AUTH.\\ADD.
			\par}%				%
		\long\xdef\@author{\the\prev@t\the\cur@t}%STORE ALL IN \@AUTHOR
		}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECEIVED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\received[1]{\gdef\Jrece@cs{{\scshape\receivedname}
                                       {\itshape #1}}\@recetrue\let\received\gobble}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REVISED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\revised[1]{\gdef\Jrevi@cs{{\scshape\revisedname}
                                      {\itshape #1}}\@revitrue\let\revised\gobble}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACCEPTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\accepted[1]{\gdef\Jacce@cs{{\scshape\acceptedname}
                                       {\itshape #1}}\@accetrue\let\accepted\gobble}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PUBLISHED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\published[1]{\gdef\Jpubli@cs{{\scshape\publishedname}
                                       {\itshape #1$\vphantom{,}$}}\@publitrue\let\published\gobble}
%%%%%%%%%%%%%%%%%%%%%%%%%% COPYRIGHT DATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\Jcopy@date
\newcommand\JINSTcopydate[1]{\global\setbox\Jcopy@date
                        \hbox{\scriptsize #1}\global\@Jcopytrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEDICATED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\dedic@box{\relax}
\newcommand\dedicated[1]{\gdef\dedic@box{\vskip2em minus 1.2ex
                              \vbox{\small\it\raggedleft #1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUERIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@Jqueries\@Jqueriesfalse
\gdef\Jqueries@auth{\relax}
\newcommand\QueriesForAuth[1]{\@Jqueriestrue\gdef\Jqueries@auth{%
                              {\raggedright #1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%% ACKNOWELEDGMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\acknowledgments{\section*{\acknowlname}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EMAIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\email[1]{{\tt\href{mailto:#1}{#1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPRINT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\let\@preprint\relax
\newcommand\preprint[1]{\long\gdef\@preprint{#1}}
%%%%%%%%%%%%%%%%% SPECIAL URL overrides paper@url %%%%%%%%%%%%%%%%%%%%%
\newbox\Jspecial@url
\newcommand\Jspecialurl[1]{\global\setbox\Jspecial@url\hbox{\tiny\ttfamily
			#1}\@Jspecialurltrue}
%%%%%%%%%%%%%%%%%%%%%%%%% FILE NAME AND URL %%%%%%%%%%%%%%%%%%%%%%%%%%%
%\global\newbox\Jacce@month
%\global\newcount\Jacce@year
%\global\newbox\Jacce@number
%\def\Jsplit@ident#1(#2)#3.{\global\setbox\Jacce@month\hbox{\tiny\ttfamily #1}
%			  \global\Jacce@year= #2
%			  \global\setbox\Jacce@number\hbox{\tiny\ttfamily #3}

%\gdef\Jfile@name{\hbox{\tiny\ttfamily
%		jinst\unhcopy\Jacce@month\the\Jacce@year\unhcopy\Jacce@number}}

\newbox\Jpaper@url
\global\setbox\Jpaper@url\hbox{\tiny\ttfamily http://www.iop.org/EJ/jinst/}
                              %\Jfile@name/\Jfile@name.pdf}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COPYRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\Jcopyright@box{\hbox{\if@preprint\else{\scriptsize $\copyright$
		\if@Jcopy\unhbox\Jcopy@date\else\the\year\fi\ IOP Publishing Ltd\ and SISSA}\fi}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ABSTRACT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% *** For beton! We need a cs, not a box. Maybe also for refs.. %%%%%%

\newcommand{\abstract}[1]%		% ABSTR. IN NORMALSIZE
	{\gdef\abstract@cs{		% cs FOR WHOLE ABSTRACT
	{\noindent{\scshape\abstractname}\ \ignorespaces #1}}
	 \normalsize
	 \global\@abstracttrue\let\abstract\gobble}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KEYWORDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@keywords{\relax}%                   % CS FOR WHOLE KEYWORDS
\def\keywords{\bgroup\gdef\@comma{,}\catcode`\ =\active\catcode`,=\active
		\@@keywords}
\begingroup
\catcode`\ =\active\catcode`,=\active\global
\def\@@keywords#1{\gdef\@keywords{\noindent{\scshape\keywordsname}
		\bgroup\def, {+}\def {_}%	%ATTENTION: NO EXPANSION.
		%\href{http://jinst.sissa.it/stdsearch}%
						{\let,\@comma\let \ #1}.
		\egroup}\egroup\global\@keywordstrue\let\keywords\gobble}%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THEOREMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@twothms\@twothmsfalse

\if@preprint%\ifx\@thmcountersep\@undefined
%\def\@xthm#1#2{\@begintheorem{#2}{\csname the#1\endcsname.}\ignorespaces}% after thm number
\else									 % if published
\def\@xthm#1#2{\@begintheorem{#2\if@twothms\else.\fi}			 % theorems are numbered
		{\if@twothms\csname the#1\endcsname.\fi}		 % only if more than one
		\ifnum \csname the#1\endcsname>1 \immediate\write\@auxout% and not within sections
				{\string\global\string\@twothmstrue}\fi
		\ignorespaces}
\fi

\newcommand\Proof{\noindent\emph{Proof.}\ }

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
\def\fps@figure{htbp}
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
%% be inserted in JINST.cls;
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
	\global\let\tmp@caption\caption		% \label, LATER.
	\global\let\later@capt\relax		% UN PO' PESANTI
	\gdef\later@label{}%			% MA D'ALTRONDE...
	\let\J@ref\ref\def\ref{\protect\J@ref}% % protect ref in captions..
	\renewcommand\caption{\@ifnextchar[\J@@caption\J@caption}%
	\newcommand\J@caption[1]{\gdef\later@capt{\tmp@caption{##1}}}% LOCAL!!
	\newcommand\J@@caption[2][v]%
				{\gdef\later@capt{\tmp@caption[##1]{##2}}}% LOCAL!!
	\renewcommand\@@label[1]{\egroup\name{ref-##1}%	% TAG WHERE CALLED, AT LEAST,
			       \if@draft\norm@note{}{LAB: ##1}\fi% & DRAFTNOTE.
			       \g@addto\later@label{\old@label{##1}}}%
			}
\AtEndDocument{\iftryingfig\JINST@warnl{Floating figure \the\ffigcount\space
					remains undone}\fi
		\iftryingtab\JINST@warnl{Floating table \the\ftabcount\space
					remains undone}\fi}
%%----------------- FIGURE ---------------------------------------%%
\newenvironment{floatingfigure}[1][v]%
{\@tfor \@tempa :=#1\do {\xdef\@fside{\@tempa}}%
 \global\advance\ffigcount by 1%
 \iffigprocessing {\count0=\ffigcount\advance\count0 by -1%
   		   \JINST@warnl{Floating figures \the\count0\space\space and
       			\the\ffigcount\space colliding}}\fi
 \iftabprocessing  \JINST@warnl{Floating table \the\ftabcount\space and
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
% \JINST@mess{Floating figure \the\ffigcount\space is
%			wide becomes a LaTeX float}%
 \if\@fside v \def\@fside{ht}\fi
 \ifdim\floatfltwidth<\columnwidth
    \def\@@tempa{\@float{figure}[}\let\@@tempb\end@float
 \else
    \def\@@tempa{\@dblfloat{figure}[}\let\@@tempb\end@dblfloat
 \fi
 \expandafter\@@tempa\@fside]\center\unhbox\@tmpbox\later@capt\later@label\@@tempb
\fi
}
%%------------ TABLE ----------------------------------------------%%
\newenvironment{floatingtable}[1][v]%
{\@tfor \@tempa :=#1\do {\global\edef\@tside{\@tempa}}%
 \global\advance\ftabcount by 1%
 \iftabprocessing {\count0=\ftabcount\advance\count0 by -1%
     		   \JINST@warnl{Floating tables \the\count0\space
            		\space and \the\ftabcount \space colliding}}\fi
 \iffigprocessing  \JINST@warnl{Floating figure \the\ffigcount\space and
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
%  \JINST@mess{Floating table \the\ftabcount\space is
%			wide becomes a LaTeX float}%
  \ifdim\floatfltwidth<1.1\columnwidth
    \if\@tside v \def\@tside{ht}\fi
    \def\@@tempa{\@float{table}[}\let\@@tempb\end@float
  \else
    \if\@tside v \def\@tside{t}\fi
    \def\@@tempa{\@dblfloat{table}[}\let\@@tempb\end@dblfloat
  \fi
  \expandafter\@@tempa\@tside]%		% ACTUALLY CALL THE LATEX FLOAT
  \center\unhbox\@tmpbox\later@capt\later@label
  \@@tempb
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
%	\output
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
	   \JINST@mess{Flt. fig. \the\ffigcount\space set on page \the\count0,
	 		shifted \the\nosuccesstryfig\space par(s) forward}%
%	  \else
%	   \JINST@mess{Floating figure \the\ffigcount\space
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
	\JINST@mess{Flt. tab. \the\ftabcount\space set on page \the\count0,
			shifted \the\nosuccesstrytab\space par(s) forward}%
%       \else
%	\JINST@mess{Floating table \the\ftabcount\space
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
%%%
%%% End of ex-file `floatflt.sty'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CAPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{8\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \if@hyper{\edef\@pippo{the\@captype}
            \name{\@captype\expandafter\csname\@pippo\endcsname}}\fi%
  \vskip\abovecaptionskip
 {\let\label\@gobble%                           % FN 10.2.97 REMOVED LATEX BUG:
  \let\index\@gobble%                           % LARGE CAPTIONS PROCESS LABEL
  \let\glossary\@gobble%                        % TWO TIMES.
  \sbox\@tempboxa{\small {\bfseries #1.} #2}%   %
  \global\dimen0\wd\@tempboxa}%                 %
  \ifdim \dimen0 >\hsize
    \small {\bfseries #1.} #2\par
  \else
    \global\@minipagefalse \sbox\@tempboxa{\small {\bfseries #1.} #2}%
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
    \@starttoc{toc}%
    \gdef\tableofcontents{\JINST@igno{\tableofcontents\space already done}}}
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
		\intJlink{\hash pag#2}{#2}}}\par
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
        \nobreak\hb@xt@\@pnumwidth{\hss \intJlink{\hash pag#2}{#2}}\par
    \endgroup
  \fi}

\newcommand*\l@subsection{\def\hyp@typ{sec}\@tocline{2}{1.8em}{2.3em}}
\newcommand*\l@subsubsection{\def\hyp@typ{sec}\@tocline{3}{4.1em}{3.1em}}
\newcommand*\l@paragraph{\def\hyp@typ{sec}\@tocline{4}{7.2em}{4.3em}}
\newcommand*\l@subparagraph{\def\hyp@typ{sec}\@tocline{5}{10.5em}{5em}}

\if@hyper
  \let\old@dtl\@dottedtocline
  \def\@dottedtocline#1#2#3#4#5{\old@dtl{#1}{#2}{#3}{#4}{%
						\intJlink{\hash pag#5}{#5}}}
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
     \hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor \intJlink{\hash pag#5}{#5}}%
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
 \newcommand\listoffigures{\JINST@ignol{List of figures (draft mode only)}}
 \newcommand\listoftables{\JINST@ignol{List of tables (draft mode only)}}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%***
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]%	%UNFORTUNATELY MODIFIED..
     {\bgroup\raggedright\small\section*{\refname
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
\catcode`\|=14
|%%%% SM publications
\newcommand\jcap[3]  {\href{http://www.iop.org/EJ/abstract/1475-7516/#2/#1/#3}
		{{\it JCAP }{\bf #1} (#2) #3}}
\newcommand\jhep[3]  {\href{http://www.iop.org/EJ/abstract/1126-6708/#2/#1/#3}
		{{\it JHEP }{\bf #1} (#2) #3}}
\def\splitJINST#120#2#3#4#5#6#7#8#9{\href{http://www.iop.org/EJ/abstract/1748-0221/#1/#5#6/#4#5#6#7#8#9}
		{20#2#3 {\it JINST }{\bf #1} #4#5#6#7#8#9}}
\newcommand\jinst[3]   {\splitJINST#1#2#3}

\def\splitJSTAT 20#1#2#3#4#5#6#7#8{\href{http://www.iop.org/EJ/abstract/1742-5468/20#1#2/#4#5/#3#4#5#6#7#8}
		{{\it J. Stat. Mech.\ }(20#1#2) #3#4#5#6#7#8}}
\newcommand\jstat[2]{\splitJSTAT#1#2}
\newcommand\pos[1]{\href{http://pos.sissa.it/cgi-bin/reader/contribution.cgi?id=#1}{\tt #1}}
|%%%% APS journals
\newcommand\pr[3]{\href{http://dx.doi.org/10.1103/PhysRev.#1.#3}
  {\emph{Phys.\ Rev.} {\bf #1} (#2) #3}}
\newcommand\pra[3]{\href{http://dx.doi.org/10.1103/PhysRevA.#1.#3}
  {\emph{Phys.\ Rev.} {\bf A #1} (#2) #3}}
\newcommand\prb[3]{\href{http://dx.doi.org/10.1103/PhysRevB.#1.#3}
  {\emph{Phys.\ Rev.} {\bf B #1} (#2) #3}}
\newcommand\prc[3]{\href{http://dx.doi.org/10.1103/PhysRevC.#1.#3}
  {\emph{Phys.\ Rev.} {\bf C #1} (#2) #3}}
\newcommand\prd[3]{\href{http://dx.doi.org/10.1103/PhysRevD.#1.#3}
  {\emph{Phys.\ Rev.} {\bf D #1} (#2) #3}}
\newcommand\prl[3]{\href{http://dx.doi.org/10.1103/PhysRevLett.#1.#3}
  {\emph{Phys.\ Rev.\ Lett.} {\bf #1} (#2) #3}}
|%%%% Others
\newcommand\econf[3]  {\@spires{ECONF%2C#1%2C#3}
                {{\it eConf\ }{\bf #1} (#2) #3}}
\newcommand\rsi[3]{\href{http://scitation.aip.org/getabs/servlet/GetabsServlet?prog=normal&id=RSINAK0000#1000001#3000001}
{\emph{Rev.\ Sci.\ Instrum.} {\bf #1} (#2) #3}}
| }}}}}}}}}}}}}}}}}}}}}} "|" is here a comment (catcode defined above) to
| }}}}}}}}}}}}}}}}}}}}}} include parenthesis for emacs to parse properly.
\newcommand\ibid[3]{{\it ibid.\ }{\bf #1} (#2) #3}
\catcode`\%=14
\catcode`\|=12
% HEPTH's: \hepth{9912999} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\hepth}[1]{\href{http://www.arxiv.org/abs/hep-th/#1}{\tt hep-th/#1}}
\newcommand{\hepph}[1]{\href{http://www.arxiv.org/abs/hep-ph/#1}{\tt hep-ph/#1}}
\newcommand{\heplat}[1]{\href{http://www.arxiv.org/abs/hep-lat/#1}{\tt hep-lat/#1}}
\newcommand{\hepex}[1]{\href{http://www.arxiv.org/abs/hep-ex/#1}{\tt hep-ex/#1}}
\newcommand{\nuclth}[1]{\href{http://www.arxiv.org/abs/nucl-th/#1}{\tt nucl-th/#1}}
\newcommand{\nuclex}[1]{\href{http://www.arxiv.org/abs/nucl-ex/#1}{\tt nucl-ex/#1}}
\newcommand{\grqc}[1]{\href{http://www.arxiv.org/abs/gr-qc/#1}{\tt gr-qc/#1}}
\newcommand{\qalg}[1]{\href{http://www.arxiv.org/abs/q-alg/#1}{\tt q-alg/#1}}
\newcommand{\dgga}[1]{\href{http://www.arxiv.org/abs/dg-ga/#1}{\tt dg-ga/#1}}
\newcommand{\accphys}[1]{\href{http://www.arxiv.org/abs/accphys/#1}{\tt accphys/#1}}
\newcommand{\alggeom}[1]{\href{http://www.arxiv.org/abs/alg-geom/#1}{\tt alg-geom/#1}}
\newcommand{\astroph}[1]{\href{http://www.arxiv.org/abs/astro-ph/#1}{\tt astro-ph/#1}}
\newcommand{\chaodyn}[1]{\href{http://www.arxiv.org/abs/chao-dyn/#1}{\tt chao-dyn/#1}}
\newcommand{\condmat}[1]{\href{http://www.arxiv.org/abs/cond-mat/#1}{\tt cond-mat/#1}}
\newcommand{\nlinsys}[1]{\href{http://www.arxiv.org/abs/nlin-sys/#1}{\tt nlin-sys/#1}}
\newcommand{\quantph}[1]{\href{http://www.arxiv.org/abs/quant-ph/#1}{\tt quant-ph/#1}}
\newcommand{\solvint}[1]{\href{http://www.arxiv.org/abs/solv-int/#1}{\tt solv-int/#1}}
\newcommand{\suprcon}[1]{\href{http://www.arxiv.org/abs/supr-con/#1}{\tt supr-con/#1}}
\newcommand{\mathph}[1]{\href{http://www.arxiv.org/abs/math-ph/#1}{\tt math-ph/#1}}
\newcommand{\physics}[1]{\href{http://www.arxiv.org/abs/physics/#1}{\tt physics/#1}}
\newcommand{\Math}[2]{\href{http://www.arxiv.org/abs/math.#1/#2}{\tt math.#1/#2}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BopHook %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifpdf
\newcommand\Jwatermark[1]{\relax}
%% \JINST@warnl{ATTENTION!!! watermark disabled. Add it with pdftk
%% (use compilaJINSTpdflatex for instance)}
\else
\newcommand\Jwatermark[1]{\special{!userdict begin
/iseven {dup dup 2 idiv 2 mul eq} bind def
/BHend {
  translate rotate
/Courier findfont 30 scalefont setfont
0 0  moveto 0.80 setgray (#1) show grestore}
 bind def
statusdict /duplexmode known
  {statusdict begin duplexmode end}
  {false}
ifelse
  {/bop-hook {gsave iseven {-90 550 570} {+90 50 300} ifelse BHend} def}
  {/bop-hook {gsave         -90 550 570                      BHend} def}
ifelse
end
}\let\JHEP\gobble}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOOTNOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\skip\footins = 1\bigskipamount plus 2pt minus 4pt

\addtolength{\footnotesep}{1pt}
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
\if@draft\newcommand\listfigurename{List of figures}
	 \newcommand\listtablename{List of tables}\fi
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract:}
\newcommand\keywordsname{Keywords:}
\newcommand\receivedname{Received:}
\newcommand\revisedname{Revised:}
\newcommand\acceptedname{Accepted:}
\newcommand\publishedname{Published:}
\newcommand\acknowlname{Acknowledgments}
\newcommand\queriesname{Queries for the author}
\newcommand\today{}
\edef\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}

\setlength\columnsep{20\p@}
\setlength\columnseprule{0\p@}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pagestyle{JINST}
\pagenumbering{arabic}
\@addtoreset{equation}{section}
\if@preprint
\else
	\let\pagestyle\@gobble
	\let\thispagestyle\@gobble
	\let\pagenumbering\@gobble
\fi
\onecolumn

% FOR REQUESTED FRONTMATTER ...
\AtBeginDocument{\bgroup%		SOME NICE (LOCAL) MESSAGES...
	\def\@APPwarn#1{\JINST@warnl{\protect#1 should appear
					before \protect\begin{document}}}%
	\def\@APPerr#1{\ClassError{JINST}{\protect#1 should appear
					before \protect\begin{document}}}%
	\if@author\else\@APPerr{Some \protect\author{...}}\fi
	\if@abstract\else\@APPerr{\abstract{...}}\fi
	\if@preprint
	\else
	        \if@rece\else\@APPerr{\received{...}}\fi
		\if@acce\else\@APPerr{\accepted{...}}\fi
		\if@publi\else\@APPerr{\published{...}}\fi
		\if@keywords\else\@APPwarn{\keywords{...}}\fi
	\fi
	\egroup
	\auto@maketitle}%
\endinput
%%
%% End of file `JINST.cls'.
