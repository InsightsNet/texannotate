%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              File: osajnl.cls		                  %
%              Version: 1.12                          %
%              Date: 12th December 2019               %
%                                                     %
%     This class file and associated style files 	  %
%	  listed below are provided for authors           %
%     submitting to the Optical Society's Applied     %
%     Optics Journal, http://www.osa.org  	          %
%													  %
%     Style files: ao, aop, ol, josaa, josab.sty      %
%                                                     %
%     Produced by Overleaf (WriteLaTeX Limited)		  %
%													  %
%     Copyright 2019 Optical Society of America       %
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
\ProvidesClass{osajnl}[2019/12/12, v1.12]
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
\newcommand{\titlefont}{\normalfont\sffamily\bfseries\fontsize{21}{23}\selectfont}
\newcommand{\datesfont}{\normalfont\sffamily\itshape\fontsize{8}{10}\selectfont}
\renewcommand\UrlFont{\color{color1}\sffamily}
\newcommand{\absfont}{\normalfont\rmfamily\bfseries\linespread{1.2}\fontsize{10}{12}\selectfont}
\newcommand{\copyrightfont}{\normalfont\sffamily\fontsize{8}{10}\selectfont}
\newcommand{\ociscodefont}{\normalfont\sffamily\fontsize{8}{10}\selectfont}

% Author and affiliation
\RequirePackage{authblk}
\setlength{\affilsep}{1em}
\renewcommand\Authfont{\color{color2}\normalfont\sffamily\bfseries\scshape\fontsize{12}{14}\selectfont}
\renewcommand\Affilfont{\color{color0}\normalfont\sffamily\itshape\fontsize{8}{10}\selectfont}

% Set journal type
\newcommand*{\journal}[1]{%
  \RequirePackage{legacy-styles/#1}% Choose the corresponding style file
  \def\journalref{#1}}% Set a reference for the chosen journal type
  
% Choose article type
\newcommand*{\articletype}[1]{%
  \RequirePackage{articletypes/#1}}

% Options for element switching
\RequirePackage{xifthen}
\newboolean{displaycopyright}
\newboolean{shortarticle}
\newboolean{singlecolumn}

% Copyright statement
\RequirePackage{textcomp} % For copyright symbol styling
\newcommand{\copyrightstatement}{\, \textcopyright\, \the\year{} Optica Publishing Group}

% Graphics, tables and other formatting
\RequirePackage{graphicx,xcolor}
\RequirePackage{colortbl}
\RequirePackage{booktabs}
\RequirePackage{algorithm}
\RequirePackage[noend]{algpseudocode}
\RequirePackage{changepage}
\RequirePackage[left=48pt,%
                right=42pt,%
                top=46pt,%
                bottom=60pt,%
                headheight=15pt,%
                headsep=10pt,%
                letterpaper,twoside]{geometry}%
\RequirePackage[labelfont={bf,sf},%
                labelsep=period,%
                figurename=Fig.,%
                singlelinecheck=off,%
                justification=RaggedRight]{caption}
% \@ifpackagelater{newfloat}{2019/08/28}{}{%
  \RequirePackage{wrapfig} % For author photos and bios for AOP articles
% }
\setlength{\columnsep}{24pt} % Distance between the two columns of text
\setlength{\parindent}{12pt} % Paragraph indent

% Set document color scheme
\definecolor{color0}{RGB}{0,0,0} % Base
\definecolor{color1}{RGB}{59,90,198} % author email, doi
% color2 defined by the specific journal style file

% Bibliography
\RequirePackage[numbers,sort&compress]{natbib}
\setlength{\bibsep}{0.0pt}
% bibliography style defined by the specific journal style file

\def\bibfont{\normalfont\sffamily\fontsize{8}{10}\selectfont}
\newlength{\biblabelwidth}
\settowidth{\biblabelwidth}{\bibfont 00. }
% \makeatletter
\renewcommand\@biblabel[1]{\makebox[\biblabelwidth][l]{#1.}} % Remove brackets from label
\def\tagform@#1{\maketag@@@{\bfseries(\ignorespaces#1\unskip\@@italiccorr)}}
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
\pagestyle{fancy}          % Enables the custom headers/footers
% Headers
\fancyhead[LE]{\headerfont \begin{tabular*}{\textwidth}{!{\color{black}\vrule}c!{\color{black}\vrule} @{\extracolsep{\fill}} c!{\color{black}\vrule}}\arrayrulecolor{black}
      \hline
      \cellcolor{black}\textcolor{white}{\ifthenelse{\boolean{shortarticle}}{\journalshorttype}{\journallongtype}} & \journalname\hspace{21pt}\thepage \\
      \hline
    \end{tabular*}}
\fancyhead[RO]{\headerfont \begin{tabular*}{\textwidth}{!{\color{black}\vrule}c!{\color{black}\vrule} @{\extracolsep{\fill}} c!{\color{black}\vrule}}\arrayrulecolor{black}
      \hline
      \cellcolor{black}\textcolor{white}{\ifthenelse{\boolean{shortarticle}}{\journalshorttype}{\journallongtype}} & \journalname\hspace{21pt}\thepage \\
      \hline
    \end{tabular*}}
\fancyhead[LO,RE]{}
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


% Article meta data additional fields
% v1.8: Make OCIS codes non-compulsory
\def\@ociscodes{}
\newcommand{\ociscodes}[1]{\def\@ociscodes{#1}}
\newcommand{\ociscodesname}{\textbf{\textit{OCIS codes:}}} % Defines the heading name
\newcommand{\dates}[1]{\def\@dates{#1}}
\newcommand{\doi}[1]{\def\@doi{#1}}

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
	\absfont \theabstract
    \copyrightfont \ifthenelse{\boolean{displaycopyright}}{\copyrightstatement}{}
}%
}%
\vskip8pt%
\ifdefempty{\@ociscodes}{}{%
  \noindent
  \parbox{\dimexpr\linewidth}{%
  {\ociscodefont \ociscodesname\hspace*{0.5em} \@ociscodes}%
  }%
  \vskip8pt%
} %% END if ocis codes not provided
\noindent
\parbox{\dimexpr\linewidth}{%
\@doi%
}%
\hfil\rule{\linewidth}{.4pt}
}

% Format abstract in reduced width box for certain layouts
\newcommand{\abscontentformatted}{
\begin{adjustwidth}{24pt}{24pt}
\rule{\linewidth}{.4pt}
\vskip12pt%
\abscontent
\end{adjustwidth}
}

% Custom title page
\renewcommand{\@maketitle}{%
{\vphantom{M}%
\vskip50pt%
{\raggedright \titlefont \@title\par}%
\vskip11pt
{\raggedright \@author\par}
\vskip11pt%
{\raggedright \datesfont \@dates\par}
\vskip1pt%
\ifthenelse{\boolean{shortarticle}}
{\ifthenelse{\boolean{singlecolumn}}{}{
% just a single line for short article
\rule{\linewidth}{.4pt}
\vskip12pt}}
{% else display the abstract contents (in reduced width box)
{%
\abscontentformatted
}%
\vskip25pt%
}%
}%
}%

% Other packages
\RequirePackage{enumitem} % For reducing bullet list item separation
\usepackage{lipsum} % Required to insert dummy text

%%%%%%%%%%%%%
%% LLT: Providing the list of full refs
% Creating a new bibliography
\RequirePackage[resetlabels]{multibib}
\newcites{fullrefs}{Full References}  %% Or whatever the heading might be
\bibliographystylefullrefs{osajnl}    %% The full style

% Patching \cite to automatically add cite
% to fullrefs list
\RequirePackage{letltxmacro}
\RequirePackage{xparse}
\LetLtxMacro\oldcite\cite
\RenewDocumentCommand{\cite}{O{} O{} m}{\oldcite[#1][#2]{#3}\nocitefullrefs{#3}}
%% 13 Jul 2016: Patch the same for \citep and \citet
\LetLtxMacro\oldcitep\citep
\RenewDocumentCommand{\citep}{O{} O{} m}{\oldcitep[#1][#2]{#3}\nocitefullrefs{#3}}
\LetLtxMacro\oldcitet\citet
\RenewDocumentCommand{\citet}{O{} O{} m}{\oldcitet[#1][#2]{#3}\nocitefullrefs{#3}}

% Silence the "citation multiply defined" warning
\RequirePackage{silence}
\WarningFilter{natbib}{Citation `}
\WarningFilter{natbib}{There were multiply}
\WarningFilter{caption}{Unused \captionsetup}

% Delay certain patches/options till \begin{document} when all the booleans are set
\RequirePackage{xpatch}
%% Change pagestyle to fancy after \maketitle
\apptocmd{\maketitle}
  {\thispagestyle{fancy}}
  {\typeout{Banner added to title page.}}%
  {\ClassWarning{optica}{Could not change title page style.}}

\AtBeginDocument{%
  \ifthenelse{\boolean{shortarticle}}{\colorlet{color2}{color2b}}{\colorlet{color2}{color2}} % Automatically switches colors for short articles
  %
  %% If shortarticle, add the abstract after \maketitle
  \ifthenelse{\boolean{shortarticle}}%
    {\ifthenelse{\boolean{singlecolumn}}%
      {\apptocmd{\maketitle}{\abscontentformatted}
        {\typeout{shortarticle: Abstract added.}}
        {\ClassWarning{osajnl}{shortarticle: Couldn't add abstract after title.}}}%
      {\apptocmd{\maketitle}{\abscontent}%
        {\typeout{shortarticle: Abstract added.}}
        {\ClassWarning{osajnl}{shortarticle: Couldn't add abstract after title.}}}%
  }{} % nothing to do if not shortarticle
  %
  %% Ignore \bibliographyfullrefs if not submitting to Optics Letters
  \pretocmd{\bibliographyfullrefs}{\clearpage}{}{}
  \ifthenelse{\equal{\journalref}{ol}}{}{\renewcommand{\bibliographyfullrefs}[1]{}}
}

%% Default template values
\setboolean{shortarticle}{false}
\setboolean{displaycopyright}{true}
\dates{Compiled \today}
\doi{\url{http://dx.doi.org/10.1364/ao.XX.XXXXXX}}