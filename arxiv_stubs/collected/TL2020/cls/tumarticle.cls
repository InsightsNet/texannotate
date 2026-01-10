% File: tumarticle.cls Copyright (C) 2019 The LaTeX4EI Team
% Provides a scientific article template in the TUM Corporate Design.
%
% It may be distributed and/or modified under the conditions of the
% LaTeX Project Public License (LPPL), either version 1.3c of this
% license or (at your option) any later version. The latest version
% of this license is in the file
%
%    https://www.latex-project.org/lppl.txt
%
% This file is part of the "tum-templates bundle" (The Work in LPPL)
% and all files in that bundle must be distributed together.
%
%
% ----------------------------------------------------------------------------
%
% The development version of the bundle can be found at
%
%    https://gitlab.lrz.de/latex4ei/tum-templates
%
% for those people who are interested.
%
% ----------------------------------------------------------------------------
%
% Version history:
% v1.0 2020/10/01 Initial version.
% v2.0 2021/04/19 Use tumpage.sty layers and pagestyles, add tumboxes and
%                 pdf metadata.
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tumarticle}[2021/04/19 v2.0]


% .:: Load required packages
% ----------------------------------------------------------------------------

%\RequirePackage{placeins}
\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}


% .:: Package options for tumarticle class
% ----------------------------------------------------------------------------

\ProcessPgfOptions{/TUM/article}


% .:: Load base class
% ----------------------------------------------------------------------------

% print debug info to logfile
\typeout{Global options before any option parsing.}
\typeout{classoptions: \@classoptionslist}
\typeout{unused classoptions: \@unusedoptionlist}

% pass options to scrartcl
\PassOptionsToClass{bibliography=totoc,numbers=noenddot}{scrartcl}
% pass tumarticle class options down to scrartcl
\PassOptionsToClass{\@classoptionslist}{scrartcl}
\LoadClass{scrartcl}

% print debug info to logfile
\typeout{Global options after scrartcl option parsing.}
\typeout{classoptions: \@classoptionslist}
\typeout{unused classoptions: \@unusedoptionlist}


% .:: Load TUM packages
% ----------------------------------------------------------------------------

\RequirePackage{tumbase}
\RequirePackage{tumcolors}
\RequirePackage{tumlogo}
\RequirePackage{tumlang}
\RequirePackage{tumauthblk}
\RequirePackage{tumcaptions}
\RequirePackage{tumpage}
\RequirePackage{tumfonts}
\RequirePackage{tumboxes}
\RequirePackage{tumuser}


% .:: Layout
% ----------------------------------------------------------------------------

% page style for the title page including the TUM logo and headline
\DeclareNewPageStyleByLayers{TUM.article.titlepage}{%
  TUM.head.tumlogo.oneside,%
  TUM.head.tumlogo.odd,%
  TUM.head.tumlogo.even,%
  TUM.head.headline.oneside,%
  TUM.head.headline.odd,%
  TUM.head.headline.even,%
  TUM.foot.pagenumber.oneside,%
  TUM.foot.pagenumber.odd,%
  TUM.foot.pagenumber.even,%
}

\renewcommand{\titlepagestyle}{TUM.article.titlepage}

% load the default pagestyle for articles
\pagestyle{TUM.insidepage}


% .:: Fonts
% ----------------------------------------------------------------------------

% title block fonts
\setkomafont{title}{\sffamily\LARGE\bfseries}
\setkomafont{subtitle}{\sffamily\large\mdseries}
\setkomafont{author}{\sffamily\large\bfseries\textcolor{TUMBlue}}
\newkomafont{affiliation}{\sffamily\small\mdseries}
\setkomafont{date}{\sffamily\footnotesize\mdseries}

% chapter/section/subsection/... headings should always be in helvet
\setkomafont{disposition}{\sffamily\bfseries}

% avoid buggy handling of numbers in URLs
\renewcommand\UrlFont{\normalfont}


% .:: Custom title
% ----------------------------------------------------------------------------

\renewcommand{\@maketitle}{
  \newpage
  \begingroup
  \raggedright
  {\usekomafont{title}\@title\par}
  \ifdefempty{\@subtitle}{}{
    \vspace{.4em}
    {\usekomafont{subtitle}\@subtitle\par}
  }
  \vspace{1.5em}
  {\usekomafont{author}\@author\par}
  \vspace{.4em}
  {\usekomafont{affiliation}\theAffil\par}
  \ifdefempty{\theEmail}{}{
    \vspace{.25em}
    {\usekomafont{affiliation}\theEmail\par}
  }
  \ifdefstring{\@date}{}{}{
    \vspace{.25em}
    {\usekomafont{date}\@date\par}
  }
  \vspace{1.5em}
  \endgroup
  \FloatBarrier
}


% .:: Custom abstract
% ----------------------------------------------------------------------------

\renewenvironment{abstract}{%
  \fontfamily{phv}\selectfont
  \setlength{\parindent}{0mm}
  \textcolor{TUMBlue}{\textbf{\abstractname}}
  \normalfont\textcolor{black}{---}}{}


% .:: Set default PDF metadata
% ----------------------------------------------------------------------------

\AtBeginDocument{
  \def\@tum@pdftitle@{\@title\ifdefempty{\@subtitle}{}{~-~\@subtitle}}
  \hypersetup{
    pdftitle = {\@tum@pdftitle@},
    pdfauthor = {\pgfkeysvalueof{/TUM/author list}},
    pdfsubject = {\@subject},
    % pdfkeywords = {},
    pdfcreator = {\theUniversityName}
  }
}

% open bookmarks tree, use SinglePage layout
\hypersetup{
  bookmarksnumbered = true,
  bookmarksopen = true,
  bookmarksopenlevel = 1,
  pdfpagemode=UseOutlines,
  pdfpagelayout=SinglePage,
}
