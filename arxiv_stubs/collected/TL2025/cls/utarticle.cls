\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{utarticle}[1997/07/29 modified article class]

\newif\if@uttitlepage
\@uttitlepagefalse
\DeclareOption{titlepage}{\@uttitlepagetrue}
\ProcessOptions\relax
\LoadClassWithOptions{article}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}

\setlength{\topmargin}{-.5in}
\setlength{\textheight}{8.9in}
\setlength{\hoffset}{-.53in}
\setlength{\textwidth}{6.5in}
\newdimen\addresswidth
\setlength{\addresswidth}{3.75in}

%%%%%%%Miscellaneous Commands (should be a package)%%%%%%%%%%%%%%%%%%
\newcommand{\field}[1]{\mathbb{#1}}
\newcommand{\BZ}{\field{Z}}
\newcommand{\BR}{\field{R}}
\newcommand{\BC}{\field{C}}
\newcommand{\BP}{\field{P}}
\newcommand{\BQ}{\field{Q}}
\newcommand{\BF}{\field{F}}
\newcommand{\BN}{\field{N}}
\newcommand{\BA}{\field{A}}
% Blackboard bold "1". Not in the AMS font set.
\def\Bid{{\mathchoice {\rm {1\mskip-4.5mu l}} {\rm
{1\mskip-4.5mu l}} {\rm {1\mskip-3.8mu l}} {\rm {1\mskip-4.3mu l}}}}

\newcommand{\sheaf}[1]{\ensuremath{\mathcal{#1}}}
\newcommand\CA{\sheaf{A}}
\newcommand\CC{\sheaf{C}}
%\newcommand\CD{\sheaf{D}} %conflicts with the CD environment of amscd.sty
\newcommand\CF{\sheaf{F}}
\newcommand\CG{\sheaf{G}}
\newcommand\CH{\sheaf{H}}
\newcommand\CI{\sheaf{I}}
\newcommand\CJ{\sheaf{J}}
\newcommand\CL{\sheaf{L}}
\newcommand\CM{\sheaf{M}}
\newcommand\CN{\sheaf{N}}
\newcommand\CO{\sheaf{O}}
\newcommand\CP{\sheaf{P}}
\newcommand\CQ{\sheaf{Q}}
\newcommand\CT{\sheaf{T}}
\newcommand\CU{\sheaf{U}}

\newcommand{\coho}[2]{\ensuremath{\mathrm{H}^{#1}(#2)}}
\newcommand{\homo}[2]{\ensuremath{\mathrm{H}_{#1}(#2)}}
\newcommand{\ex}[1]{\ensuremath{\mathrm{e}^{#1}}}
\DeclareMathOperator{\Real}{Re}
\DeclareMathOperator{\Imag}{Im}
\DeclareMathOperator{\semidir}{\mathbb{n}}


%%%%%%%%%%%%Titlepage formatting%%%%%%%%%%%%%%%%%%%%
%	\preprint{
%	UTTG--96--XX\\
%	NWU--XXXX\\
%	{\tt hep-th/yymmnnn}\\
%	}
%	\title{A Random Paper}
%
%	\author{Zippy the Pinhead
%	 \thanks{
%	  Work supported in part by
%	  NSF Grant PHY9511000, the Robert A.~Welch Foundation and a
%	  grant from ChemRon.
%	  }
%	 \address{
%	  Theory Group, Physics Department\\
%	  University of Texas at Austin\\
%	  Austin TX 78712 USA. \\
%	  {~}\\
%	  \email{pinhead@zippy.ph.utexas.edu}\\
%	  }
%	and Second Author
%	 \address{
%	  Institute for Advanced Navel Examination\\
%	  Nowhere University\\
%	  Princeton, New Jersey\ 08540\\
%	  {~}\\
%	  \email{secondauthor@nowhereu.edu}\\
%	 }
%	}
%
%	\date{August 2, 1996.}                     %default date is \today
%	\Abstract{The very interesting abstract goes here.}
%
%	\maketitle                                 % this finally produces the title
%
%If all the authors are at the same institution, substitute in the above
%
%    \author{Zippy the Pinhead and Bozo the Clown
%      \thanks{
%	  Work supported in part by
%	  NSF Grant PHY9511000, the Robert A.~Welch Foundation and a
%	  grant from ChemRon.
%       }
 %     \oneaddress{
%	  Theory Group, Physics Department\\
%	  University of Texas at Austin\\
%	  Austin TX 78712 USA. \\
%	  {~}\\
%	  \email{pinhead@zippy.ph.utexas.edu}\\
%	  \email{bozo@clown.ph.utexas.edu}\\
%       }
 %  }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\preprint#1{\gdef\@preprint{#1}}
\def\@preprint{}
\def\Abstract#1{\gdef\@abstract{#1}}
\def\@abstract{}
\providecommand{\href}[2]{#2}
\newcommand{\email}[1]{{\rm Email: }\href{mailto:#1}{\tt #1}}
\newcommand{\emailt}[1]{{\rm }\href{mailto:#1}{\tt #1}}

%ADDRESS
\newcounter{address} 
\def\theaddress{\arabic{address}}
\def\@makeadmark#1{\mbox{$^{\rm #1}$}}   

\def\address#1{\addressmark\begingroup
  \xdef\@tempa{\theaddress}\let\\=\relax
  \def\protect{\noexpand\protect\noexpand}\xdef\@address{\leavevmode \@address
  \quad \vtop{\protect\addresstext{\@tempa}{#1}}}\endgroup}
\def\oneaddress#1{\begingroup
  \xdef\@tempa{\theaddress}\let\\=\relax
  \def\protect{\noexpand\protect\noexpand}\xdef\@address{\leavevmode \@address
  \quad \vtop{\protect\oneaddresstext{\@tempa}{#1}}}\endgroup}

\def\@address{}

\def\addressmark{\stepcounter{address}%
  \xdef\@tempb{\theaddress}\@makeadmark{\@tempb}}

\def\addresstext#1#2{\parindent=-10pt\hsize=\addresswidth\leavevmode 
\begingroup
  \centering
%\raggedright 
  \hyphenpenalty\@M \@makeadmark{#1}#2\par \endgroup
  \vskip\baselineskip}

\def\oneaddresstext#1#2{\hsize=\addresswidth\leavevmode 
\begingroup
  \centering 
  \hyphenpenalty\@M \@makeadmark{#1}#2\par \endgroup
  \vskip\baselineskip}

% TITLE and ABSTRACT
  \if@uttitlepage
    \renewenvironment{abstract}{%
     \null\vfil
      \@beginparpenalty\@lowpenalty
      \begin{center}%
        \bfseries \abstractname
        \@endparpenalty\@M
      \end{center}}%
     {\par\vfil\null}
  \renewcommand\maketitle{\begin{titlepage}%
      \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
  \let\footnotesize\small
  \let \footnote \thanks
  \begin{flushright}
  \@preprint
  %\bigskip
  %{\@date \par}%       
  \end{flushright}
  \vskip 20\p@
  \null\vfil
  \begin{center}%
  \vskip-1cm
    {\LARGE\bfseries \@title}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
          \end{tabular}}%
      \vskip 2.5em%
    {\small\it \@address}        % all addresses
    \end{center}\par
     \vskip-.5cm
     \begin{abstract} 
     \hrule\vskip.5cm
     \@abstract
     \end{abstract}
     \vskip-.5cm
     \hrule
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
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
\def\@maketitle{%
  \newpage
  \null
    \begin{flushright}
  \@preprint
  \bigskip
      { \@date \par}%       
  \end{flushright}
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title}%
    \vskip 2em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}}%
    \vskip 1.3em%
   {\small\it \@address}        % all addresses
  \end{center}%
  \par
  \vskip 1.5em
  \begin{abstract}
     \@abstract
  \end{abstract}
   }
\fi
%%%%%Section Headings%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\hskip 1em}
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\large\bfseries\raggedright}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                {\normalfont\normalsize\bfseries\raggedright}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                 {\normalfont\normalsize\itshape\raggedright}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                 {\normalfont\normalsize\itshape\raggedright}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                 {\normalfont\normalsize\itshape\raggedright}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%citations
\def\@citex[#1]#2{%
  \let\@citea\@empty
  \@cite{\@for\@citeb:=#2\do
    {\@citea\def\@citea{,\penalty\@m\relax}%
     \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
     \if@filesw\immediate\write\@auxout{\string\citation{\@citeb}}\fi
     \@ifundefined{b@\@citeb}{\mbox{\reset@font\bfseries ?}%
       \G@refundefinedtrue
       \@latex@warning
         {Citation `\@citeb' on page \thepage \space undefined}}%
       {\hbox{\csname b@\@citeb\endcsname}}}}{#1}}


%% New matrix environment
\newenvironment{tinymatrix}{\null\vcenter\bgroup
  \Let@\restore@math@cr\default@tag
  \baselineskip4\ex@ \lineskip1\ex@ \lineskiplimit\lineskip
  \ialign\bgroup\hfil$\m@th\scriptscriptstyle##$\hfil&&\thinspace\hfil
  $\m@th\scriptscriptstyle##$\hfil\crcr
}{%
  \crcr\egroup\egroup%
}

\endinput
