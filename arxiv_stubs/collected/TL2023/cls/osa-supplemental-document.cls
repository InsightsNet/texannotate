%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   File: osa-suppl-materials         %
%                   Version: 1.1                      %
%                   Date: 31 March 2022                %
%                                                     %
%     This class file is provided for authors         %
%     submitting supplemental material to the 		  %
%     Optical Society's Optica Journal, 			  %
%	  https://www.osa.org    						  %
%                                                     %
%     Produced by Overleaf   						  %
%													  %
%     Copyright 2022 Optical Society of America       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either
% version 1.3 of this license or any later version.
% The latest version of this license is in
% http://www.latex-project.org/lppl.txt and
% version 1.3 or later is part of all distributions
% of LaTeX version 2005/12/01 or later.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{osa-supplemental-document}[2022/03/31, v1.1]
\AtEndOfClass{\RequirePackage{microtype}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions*
\LoadClass{extarticle}

% Fonts and language
\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{mathpazo} % Widely available alternative to Garamond
\RequirePackage[scaled]{helvet}
\RequirePackage[T1]{fontenc}
\RequirePackage{url}
\RequirePackage[colorlinks=true, allcolors=blue]{hyperref}

\newcommand{\headerfont}{\normalfont\sffamily\fontsize{7}{9} \selectfont}
\newcommand{\titlefont}{\normalfont\sffamily\bfseries\fontsize{22}{25}\selectfont}
\newcommand{\datesfont}{\normalfont\sffamily\itshape\fontsize{9}{11}\selectfont}
\renewcommand\UrlFont{\color{color1}\sffamily}
\newcommand{\absfont}{\normalfont\rmfamily\bfseries\fontsize{11}{14}\selectfont}
\newcommand{\copyrightfont}{\normalfont\rmfamily\fontsize{11}{14}\selectfont}

% Author and affiliation
\RequirePackage{authblk}
\setlength{\affilsep}{1em}
\renewcommand\Authfont{\color{color2}\normalfont\sffamily\bfseries\scshape\fontsize{15}{17}\selectfont}
\renewcommand\Affilfont{\color{color0}\normalfont\sffamily\itshape\fontsize{9}{11}\selectfont}

% Options for element switching
\RequirePackage{xifthen}
\newboolean{displaycopyright}
\newboolean{shortarticle}


\RequirePackage{silence}
\WarningFilter{caption}{Unused \captionsetup}

% Copyright statement
\RequirePackage{textcomp} % For copyright symbol styling
%% 1.4 Update: Updated copyright statement


% Graphics, tables and other formatting
\RequirePackage{graphicx,xcolor}
\RequirePackage{colortbl}
\RequirePackage{booktabs}
\RequirePackage{algorithm}
\RequirePackage[noend]{algpseudocode}
\RequirePackage{changepage}
\RequirePackage[nohead,left=1.625in,right=1.625in,top=1in,bottom=1in,headheight=15pt,headsep=\dimexpr1.3in-48pt-15pt\relax]{geometry} 
\parindent1em %% em tied to font
\parskip0pc
\RequirePackage[labelfont={bf,sf},%
                labelsep=period,%
                figurename=Fig.,%
                singlelinecheck=off,%
                justification=RaggedRight]{caption}

% setting naming conventions for countable items

\renewcommand{\thefigure}{S\arabic{figure}}
\renewcommand{\thetable}{S\arabic{table}}
\renewcommand{\thealgorithm}{S\arabic{algorithm}}
\renewcommand{\theequation}{S\arabic{equation}}

% Set document color scheme
\definecolor{color0}{RGB}{0,0,0} % Base
\definecolor{color1}{RGB}{59,90,198} % author email, doi
\definecolor{color2}{RGB}{112,128,144} % Header, authors, table lines

% Bibliography
\RequirePackage[numbers,sort&compress]{natbib}
\setlength{\bibsep}{0.0pt}
\bibliographystyle{osajnl}

\newlength{\biblabelwidth}
\settowidth{\biblabelwidth}{00. }
% \makeatletter
\renewcommand\@biblabel[1]{\makebox[\biblabelwidth][l]{#1.}} % Remove brackets from label
% v1.5: no bold!
% \def\tagform@#1{\maketag@@@{\bfseries(\ignorespaces#1\unskip\@@italiccorr)}}
\def\tagform@#1{\maketag@@@{(\ignorespaces#1\unskip\@@italiccorr)}}
\renewcommand{\eqref}[1]{\textup{{\normalfont Eq.~(\ref{#1}}\normalfont)}}
% \makeatother

%% Automatically abbreviate journal titles
\RequirePackage{jabbrv}

% Table style
\arrayrulecolor{color2} % Set the color of the horizontal rules
\renewcommand{\arraystretch}{1.5} % Increased line spacing
\captionsetup[table]{position=below} % Reduce spacing below caption

% Algorithm style
% \makeatletter
\newcommand\fs@coloruled{\def\@fs@cfont{\bfseries}\let\@fs@capt\floatc@coloruled
  \def\@fs@pre{\kern2pt}%
  \def\@fs@post{\kern2pt{\color{color2}\hrule}\relax}%
  \def\@fs@mid{\kern2pt{\color{color2}\hrule}\kern2pt}%
  \let\@fs@iftopcapt\iftrue}
% \makeatother

\floatstyle{coloruled}
\restylefloat{algorithm}

% Headers and footers
\RequirePackage{fancyhdr}  % custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
% Footers
\lfoot{}%
\cfoot{}%
\rfoot{}%
\renewcommand{\headrulewidth}{0pt}% % No header rule
\renewcommand{\footrulewidth}{0pt}% % No footer rule

% Section/subsection/paragraph set-up
\RequirePackage[explicit]{titlesec}
\renewcommand{\thesubsection}{\Alph{subsection}}

\titleformat{\section}
  {\large\sffamily\bfseries}
  {\thesection.}
  {0.5em}
  {\MakeUppercase{#1}}
  []
\titleformat{name=\section,numberless}
  {\large\sffamily\bfseries}
  {}
  {0em}
  {\MakeUppercase{#1}}
  []
\titleformat{\subsection}
  {\sffamily\bfseries}
  {\thesubsection.}
  {0.5em}
  {#1}
  []
\titleformat{\subsubsection}
  {\sffamily\small\bfseries\itshape}
  {\thesubsubsection.}
  {0.5em}
  {#1}
  []
\titleformat{\paragraph}[runin]
  {\sffamily\small\bfseries}
  {}
  {0em}
  {#1}
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{2pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{2pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{12pt}


\def\xabstract{abstract}
\long\def\abstract#1\end#2{\def\two{#2}\ifx\two\xabstract
\long\gdef\theabstract{\ignorespaces#1}
\def\go{\end{abstract}}\else
\typeout{^^J^^J PLEASE DO NOT USE ANY \string\begin\space \string\end^^J
COMMANDS WITHIN ABSTRACT^^J^^J}#1\end{#2}
\gdef\theabstract{\vskip12pt BADLY FORMED ABSTRACT: PLEASE DO
NOT USE {\tt\string\begin...\string\end} COMMANDS WITHIN
THE ABSTRACT\vskip12pt}\let\go\relax\fi
\go}

% Define a new environment with abstract content and styling
% (to enable switching between long and short articles)
\newcommand{\abscontent}{
\noindent
{%
\parbox{\dimexpr\linewidth}{%
 \theabstract
    
}%
}%
%\vskip8pt%
\noindent
\parbox{\dimexpr\linewidth}{%
}%
%\hfil\rule{\linewidth}{.4pt}
}

% Custom title page
\renewcommand{\@maketitle}{%
{%
\vskip68pt%
{\raggedright \titlefont \@title\par}%
\vskip11pt
{\raggedright \@author\par}
\vskip11pt%
{\raggedright\par}
\vskip1pt%
\ifthenelse{\boolean{shortarticle}}
{% just a single line for short article
%\rule{\linewidth}{.4pt}
\vskip12pt}
{% else display the abstract contents (in reduced width box)
{%
%\begin{adjustwidth}{24pt}{24pt}
%\rule{\linewidth}{.4pt}
%\vskip12pt%
\abscontent
%\end{adjustwidth}
}%
%\vskip25pt%
}%
}%
}%

% Other packages
\RequirePackage{enumitem} % For reducing bullet list item separation
\usepackage{lipsum} % Required to insert dummy text

\RequirePackage{etoolbox}
%% Change pagestyle to fancy after \maketitle
\apptocmd{\maketitle}
  {\thispagestyle{empty}}
  {\typeout{Page style on title page set to empty.}}%
  {\ClassWarning{optica-suppl-materials}{Could not change title page style.}}

\AtBeginDocument{%
  %% If short article, add the abstract _after_ \maketitle i.e. in 2-column mode
  \ifthenelse{\boolean{shortarticle}}{%
    \apptocmd{\maketitle}{\abscontent}%
    {\typeout{shortarticle: Abstract in left column.}}%
    {\ClassWarning{optica}{shortarticle: Couldn't add abstract after title.}}%
  }{}
}
% Alternative for condensed spacing list
\newenvironment{condenseditemize}
{ \begin{itemize}
    \setlength{\itemsep}{0pt}
    \setlength{\parskip}{0pt}
    \setlength{\parsep}{0pt}     }
{ \end{itemize}                  }

%% Default template values
\setboolean{shortarticle}{false}

