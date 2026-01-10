\NeedsTeXFormat{LaTeX2e} 
\ProvidesPackage{stars-techreport}[2018/09/10 STARS Technical Report class]

% Load article class as a base.
\DeclareOption{twocolumn}{\OptionNotUsed}
\DeclareOption{titlepage}{\OptionNotUsed}
\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\typeout{What's \CurrentOption?}} 
\ProcessOptions\relax
\LoadClass[oneside,letterpaper]{article}

% For logo image.
\RequirePackage[pdftex]{graphicx}

% Global font settings.
\usepackage{charter}
\usepackage{color}

% Colour for hyperlinks.
\definecolor{darkblue}{rgb}{0.0,0.0,0.65}

%---------- User Settings ----------
\newcommand{\STARStitle}[1]{\title{#1}}
\newcommand{\STARSdate}[1]{\date{#1}}
\newcommand{\STARSauthor}[1]{\gdef\@STARSauthor{#1}}
\newcommand{\STARSidentifier}[1]{\gdef\@STARSidentifier{#1}}
\newcommand{\STARSmajorrev}[1]{\gdef\@STARSmajorrev{#1}}
\newcommand{\STARSminorrev}[1]{\gdef\@STARSminorrev{#1}}

\def\@STARSauthor{\@latex@error{No \noexpand\STARSauthor given.}\@ehc}
\def\@STARSidentifier{\@latex@error{No \noexpand\STARSidentifier given.}\@ehc}
\def\@STARSmajorrev{\@latex@error{No \noexpand\STARSmajorrev given.}\@ehc}
\def\@STARSminorrev{\@latex@error{No \noexpand\STARSminorrev given.}\@ehc}

% Use geometry package to make things easy...
\usepackage[margin=1in,headsep=0.25in]{geometry}

% Fix some error reporting.
\vfuzz2pt % Don't report over-full v-boxes if over-edge is small.
\hfuzz2pt % Don't report over-full h-boxes if over-edge is small.

% Hyperlink support.
\usepackage[colorlinks,linkcolor=darkblue,urlcolor=darkblue]{hyperref}

% Redefine internal maketitle commands.
\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
    \thispagestyle{empty}\@thanks
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
  \begin{center}%
  \let\footnote\thanks
  \includegraphics[scale=0.80]{figs/stars_text_red_on_white}
  \par\vspace{0.5in}
  {\LARGE\@title\par}%
  \vskip 1.5em%
  {\Large Technical Report \@STARSidentifier}
      \vskip 0.75em
  {\large Revision \@STARSmajorrev.\@STARSminorrev, \@date}
  \vskip 2em%
  {\Large\@STARSauthor}%
\end{center}%
\par
\vskip 1.5em}

\renewenvironment{abstract}{%
  \begin{center}%
    {\bfseries\abstractname\vspace{\z@}}
  \end{center}%
  \quotation}
{\endquotation}

% Headers and footers.
\RequirePackage{fancyhdr}
\pagestyle{fancy}

% Header and footer on every page except the first.
\lhead{\@STARSidentifier}
\chead{}
\rhead{Rev.\ \@STARSmajorrev.\@STARSminorrev}
\lfoot{}
\cfoot{\thepage}
\rfoot{}

% Kill header rule.
\renewcommand{\headrulewidth}{0pt}