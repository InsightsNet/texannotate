%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSC TEMPLATE CLASS FILE.                                                     %
% Written by Steffen W. R. Werner, 13-10-2020                                  %
% Extended by Jens Saak, 05-05-2023-- 11-08-2023                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mpi2015-cscpreprint}[2023/08/11 MPI-DCTS CSC Preprint Style]

\newif\iftwocolumn\twocolumnfalse%
\DeclareOption{twocolumn}{\twocolumntrue}

\newif\ifhidelinks\hidelinksfalse%
\DeclareOption{hidelinks}{\colorlinksfalse\hidelinkstrue}

\newif\ifcolorlinks\colorlinkstrue%
\DeclareOption{colorlinks}{\colorlinkstrue}

\newif\ifmonolinks\monolinksfalse%
\DeclareOption{monolinks}{\colorlinksfalse\monolinkstrue}

\newif\ifhidempi\hidempifalse%
\DeclareOption{hidempi}{\hidempitrue}

\newif\iflinenumbers\linenumbersfalse%
\DeclareOption{linenumbers}{\linenumberstrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}

\ProcessOptions\relax

\LoadClass[10pt, a4paper, oneside]{scrartcl}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% META INFORMATION.                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hide current dates.
\date{}

% Author part.
\RequirePackage[noblocks]{authblk}

\renewcommand\Affilfont{\itshape\small}% chktex 6

\newlength{\authorsep}
\setlength\authorsep{2\baselineskip}
\renewcommand\Authsep{\hspace*{\authorsep}}
\renewcommand\Authand{\hspace*{\authorsep}}
\renewcommand\Authands{\hspace*{\authorsep}}

% Email and ORCID.
\newcommand{\email}[1]{{\normalfont{} Email:~\texttt{\href{mailto:#1}{#1}}}}
\newcommand{\orcid}[1]{{\normalfont{} ORCID:~\texttt{\href{https://orcid.org/#1}{#1}}}}


% Header and footer infos.
\RequirePackage{scrlayer-scrpage}
\RequirePackage{scrdate}

\let\@shorttitle\empty%
\newcommand{\shorttitle}[1]{\gdef\@shorttitle{#1}}

\let\@shortauthor\empty%
\newcommand{\shortauthor}[1]{\gdef\@shortauthor{#1}}

\ohead{\usekomafont{pagenumber}\thepage}

\renewcommand*\pagemark{}
\ifhidempi%
  \ifoot*{\small Preprint.}
\else
  \ifoot*{\small Preprint (Max Planck Institute for Dynamics of Complex Technical
    Systems, Magdeburg).}
\fi

% Footline.
\let\@shortdate\empty%
\newcommand{\shortdate}[1]{\gdef\@shortdate{#1}}

  
% Abstract parts.
\let\@keywords\empty%
\newcommand{\keywords}[1]{\gdef\@keywords{#1}}

\let\@msc\empty%
\newcommand{\msc}[1]{\gdef\@msc{#1}}

% Maketitle.
\let\oldmaketitle\maketitle
\let\oldabstract\abstract%
\let\endoldabstract\endabstract%

\let\@abstract\empty%
\renewcommand{\abstract}[1]{\gdef\@abstract{#1}}
\gdef\@novelty{This is mandatory! Use \textbackslash{}\texttt{novelty}, before
  \textbackslash{}\texttt{maketitle} to set it.}
\newcommand{\novelty}[1]{\gdef\@novelty{#1}}
\newlength{\noveltyboxwidth}

\renewcommand{\maketitle}{%
  % Fill PDF information.
  \hypersetup{%
    pdftitle    = {\@title},%
    pdfauthor   = {\@shortauthor},%
    pdfkeywords = {\@keywords}
  }

  % Headers and footers.
  \ifx\@shortauthor\empty%
    \ifx\@shorttitle\empty%
    \else
      \ihead{\@shorttitle}
    \fi
  \else
    \ifx\@shorttitle\empty%
      \ihead{\@shortauthor}
    \else
      \ihead{\@shortauthor:~\@shorttitle}
    \fi
  \fi
  
  \KOMAoptions{headsepline = true, footsepline = true, plainfootsepline = true}
  \ModifyLayer[addvoffset=-.6ex]{scrheadings.foot.above.line}
  \ModifyLayer[addvoffset=-.6ex]{plain.scrheadings.foot.above.line}
  
  % Footline date.
  \ifx\@shortdate\empty%
    \ofoot*{\small \ISOToday}
  \else
    \ofoot*{\small \@shortdate}
  \fi
  
  % Abstract and plotting.
  \if@twocolumn%
    \makeatletter
    \twocolumn[%
      \begin{@twocolumnfalse}%
        \oldmaketitle%
        \vspace{-2\baselineskip}
        \begin{oldabstract}
          \begin{linenumbers}
          \noindent\textbf{Abstract:}
          \@abstract%

          \ifx\@keywords\empty%
            \ifx\@msc\empty%
            \else
              \vspace{1em}
            \fi
          \else
            \vspace{1em}
            \noindent\textbf{Keywords:}
            \@keywords%
          \fi
          
          \ifx\@msc\empty%
          \else
            \vspace{1em}
            \noindent\textbf{Mathematics subject classification:}
            \@msc%
          \fi

          \setlength{\noveltyboxwidth}{\linewidth}%
          \addtolength{\noveltyboxwidth}{-2.1\fboxsep}%
          \vspace{1em}%
          \noindent\fcolorbox{black!10}{black!10}{%
            \parbox{\noveltyboxwidth}{\textbf{Novelty statement:}
              \@novelty%
            }%
          }%
              
          \end{linenumbers}
        \end{oldabstract}
        \vspace{2\baselineskip}
      \end{@twocolumnfalse}]{}
    \makeatother
    \iflinenumbers%
      \linenumbers%
    \fi%
  \else%
    \oldmaketitle%
    \vspace{-2\baselineskip}
  
    \begin{oldabstract}
      \noindent\textbf{Abstract:}
      \@abstract
         
      \ifx\@keywords\empty%
        \ifx\@msc\empty%
        \else
          \vspace{1em}
        \fi
      \else
        \vspace{1em}
        \noindent\textbf{Keywords:}
        \@keywords
      \fi
          
      \ifx\@msc\empty%
      \else
        \vspace{1em}
        \noindent\textbf{Mathematics subject classification:}
        \@msc
      \fi
      
      \setlength{\noveltyboxwidth}{\linewidth}%
      \addtolength{\noveltyboxwidth}{-2.3\fboxsep}%
      \vspace{1em}%
      \noindent\fcolorbox{black!10}{black!10}{%
        \parbox{\noveltyboxwidth}{\textbf{Novelty statement:}
          \@novelty%
        }%
      }%
    \end{oldabstract}
    \vspace{0\baselineskip}
    \iflinenumbers%
      \linenumbers%
      \leftlinenumbers*
    \fi
  \fi%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPRINT STYLE.                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geometry of page.
\RequirePackage{geometry}
\if@twocolumn
  \geometry{paper=a4paper,%
            left = 1.5cm, right = 1.5cm,%
            top = 3.0cm, bottom = 3.0cm,%
            marginparsep=.2cm,%
            marginparwidth=1.2cm}
  \setlength{\columnsep}{1.25\baselineskip}
\else
  \geometry{paper=a4paper,%
            margin = 3cm,%
            marginparsep=.25cm,%
            marginparwidth=2.65cm}
\fi

% References.
\RequirePackage[noadjust]{cite}

% Math packages.
\RequirePackage{amsmath}

% Line numbers.
\RequirePackage[switch]{lineno}

\newcommand*\patchMATHlinenumbers[1]{%
  \expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
  \expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
  \renewenvironment{#1}%
  {\linenomath\csname old#1\endcsname}%
  {\csname oldend#1\endcsname\endlinenomath}}% 
\iflinenumbers%
  \AtBeginDocument{%
    \patchMATHlinenumbers{equation}%
    \patchMATHlinenumbers{equation*}%
    \patchMATHlinenumbers{align}%
    \patchMATHlinenumbers{align*}%
    \patchMATHlinenumbers{flalign}%
    \patchMATHlinenumbers{flalign*}%
    \patchMATHlinenumbers{alignat}%
    \patchMATHlinenumbers{alignat*}%
    \patchMATHlinenumbers{gather}%
    \patchMATHlinenumbers{gather*}%
    \patchMATHlinenumbers{multline}%
    \patchMATHlinenumbers{multline*}%
  }
  \renewcommand\linenumberfont{\sffamily\scriptsize}
\fi

% Link packages.
\RequirePackage{xcolor}

\definecolor{linkBlue}{HTML}{0055C9}
\definecolor{linkRed}{HTML}{FF1A24}
\definecolor{linkPurple}{HTML}{6200D9}

\ifhidelinks%
  \RequirePackage[%
    colorlinks = false,
    hidelinks
  ]{hyperref}
\fi
\ifcolorlinks%
  \RequirePackage[%
    colorlinks = true,
    linkcolor  = linkBlue,
    citecolor  = linkRed,
    urlcolor   = linkPurple
  ]{hyperref}
\fi
\ifmonolinks%
  \RequirePackage[%
    colorlinks = true,
    allcolors  = linkBlue
  ]{hyperref}
\fi
    
\RequirePackage{url}
\RequirePackage{doi}

\PassOptionsToPackage{nameinlink}{cleveref}
\AtBeginDocument{
  \RequirePackage{cleveref}

  % Change cleveref equations without eq.
  \crefformat{equation}{\textup{#2(#1)#3}}
  \crefrangeformat{equation}{\textup{#3(#1)#4--#5(#2)#6}}
  \crefmultiformat{equation}%
                  {\textup{#2(#1)#3}}%
                  { and \textup{#2(#1)#3}}%
                  {, \textup{#2(#1)#3}}%
                  {, and \textup{#2(#1)#3}}
  \crefrangemultiformat{equation}%
                       {\textup{#3(#1)#4--#5(#2)#6}}%
                       { and \textup{#3(#1)#4--#5(#2)#6}}%
                       {, \textup{#3(#1)#4--#5(#2)#6}}%
                       {, and \textup{#3(#1)#4--#5(#2)#6}}
  \Crefformat{equation}{\textup{#2Equation~(#1)#3}}
  \Crefrangeformat{equation}{\textup{#3Equations~(#1)#4--#5(#2)#6}}
  \Crefmultiformat{equation}%
                  {\textup{#2Equations~(#1)#3}}%
                  { and \textup{#2(#1)#3}}%
                  {, \textup{#2(#1)#3}}%
                  {, and \textup{#2(#1)#3}}
  \Crefrangemultiformat{equation}%
                       {\textup{#3Equations~(#1)#4--#5(#2)#6}}%
                       { and \textup{#3(#1)#4--#5(#2)#6}}%
                       {, \textup{#3(#1)#4--#5(#2)#6}}%
                       {, and \textup{#3(#1)#4--#5(#2)#6}}%
}