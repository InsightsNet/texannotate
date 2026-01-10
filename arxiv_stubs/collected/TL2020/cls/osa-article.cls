% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either
% version 1.3 of this license or any later version.
% The latest version of this license is in
% http://www.latex-project.org/lppl.txt and
% version 1.3 or later is part of all distributions
% of LaTeX version 2005/12/01 or later.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{osa-article}[2020/12/22 LaTeX package for OSA Journal Submissions]

%% Disable twocolumn
\DeclareOption{twocolumn}{%
  \ClassWarning{osa-article}{twocolumn option ignored.}
  \AtBeginDocument{\onecolumn}
}

%% Toggle for displaying copyright
\newif\ifosa@openaccess

\ProcessOptions\relax
% 24 July 2018: extarticle is problematic with \textls math
% \LoadClass{extarticle}
\LoadClass{article}

%% Disable \twocolumn
\renewcommand{\twocolumn}[1][]{\ClassWarning{osa-article}{\twocolumn ignored.}#1}

%% Packages
\RequirePackage[letterpaper]{geometry}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}

%% fonts
\RequirePackage{silence}
\WarningFilter{microtype}{Font}
\RequirePackage[T1]{fontenc}
%% 5 Jul 2016: switched to newtx; removed textcomp
\RequirePackage{newtxtext,newtxmath,courier}
\RequirePackage{helvet}
%% 17 Apr 2016: for letterspacing the title
%% 26 May 2016: letterspacing doesn't work in latex + dvipdf, so need the soul package for that. See http://tex.stackexchange.com/a/271714/226
%% 13 Jul 2016: ifpdf not available by default
\RequirePackage{ifpdf}
\ifpdf
  \RequirePackage[tracking = true, letterspace = 16]{microtype}
\else
  \RequirePackage{microtype}
  \RequirePackage{soul}
  \soulregister\hspace7
  \sodef\lscaps{}{.1em}{.4em plus.08em minus.06em}{.4em plus.15em minus.83em}%
  \sodef\lsbold{}{.02em}{.3em plus.08em minus.06em}{.3em plus.15em minus.83em}%
\fi

% Set journal type
\newcommand*{\journal}[1]{%
  \IfFileExists{styles/#1.sty}{%
    \RequirePackage{styles/#1}
  }{%
    \ClassError{osa-article}{You've specified an unsupported journal '#1'. Was that a typo, or are you using a copy of the template without the complete set of style files?}{Was that a typo, or are you using a copy of the template without the complete set of style files?}
  }
}

%% 17 Apr 2016: colors for author list
% \definecolor{BOE}{RGB}{124,19,14}
% \definecolor{OME}{RGB}{20,120,182}
% \definecolor{OE}{RGB}{148,54,52}

\definecolor{urlblue}{RGB}{46,46,177}
\colorlet{authorcolor}{black}

\newcommand{\@authorcolor}{black}
\newcommand{\@journamename}{Journal Name}
\newcommand{\@articletype}{Article Type}
\newcommand{\articletype}[1]{\def\@articletype{#1}}
\newcommand{\headerfont}{\normalfont\sffamily\fontsize{7}{9}\selectfont}

%% Page-layout commands
%% 12 pt = 1 pc; 6 pc = 1 in.
%% 17 Apr 2016: top and bottom margins to 1.3in; left and right margins to 1.625in
\geometry{nohead,left=1.625in,right=1.625in,top=1.3in,bottom=1.3in,headheight=15pt,headsep=\dimexpr1.3in-48pt-15pt\relax} %% uses geometry.sty
\parindent1em %% em tied to font
\parskip0pc

%% 17 Apr 2016: redefinitions of front matter formatting
%% (headings are now sans serif; left-aligned)
% \newcommand\OEtitle[1]{\LARGE \bf \hskip2.25pc \parbox{.8\textwidth}{ \noindent%
%    \LARGE \bf \begin{center} #1 \end{center}\rm } \vskip.1in \rm\normalsize }
\ifpdf
  % microtype only works in pdflatex
  \newcommand\OEtitle[1]{%
    {\fontsize{16pt}{18.5pt}\sffamily\bfseries\selectfont\raggedright\textls{#1}\par\vskip.15in}
  }
\else
  \newcommand\OEtitle[1]{%
    {\fontsize{16pt}{18.5pt}\sffamily\bfseries\selectfont\raggedright\lsbold{#1}\par\vskip.15in}
  }
\fi

% \newcommand\OEauthor[1]{\hskip2.25pc \parbox{.8\textwidth}{ \noindent%
%    \normalsize \bf \begin{center} #1 \end{center}\rm } \vskip-1pc }
\newcommand\OEauthor[1]{%
{\raggedright\sffamily\bfseries\scshape\large \boldmath\color{authorcolor}#1\vskip1ex\par}%
}

% \newcommand\OEaddress[1]{\hskip2.25pc \parbox{.8\textwidth}{ \noindent%
%    \footnotesize \it \begin{center} #1 \end{center}\rm }  \normalsize \vskip-.2cm }
\newcommand\OEaddress[1]{%
  {\raggedright\small\itshape #1\par}
}

%% 2 July 2016: fix the superscripts in author
%% 31 August 2016: removed \upshape so that it follows
%% the font style around
\newcommand\authormark[1]{\textsuperscript{#1}}

%% 1 July 2016: updated color for \url, \email and \homepage

% \newcommand\OEemail[1]{\vskip-.3cm \parskip0pc\hskip2.25pc \footnotesize%
%    \parbox{.8\textwidth}{\begin{center}\it \textcolor{blue}{\underline{#1}} \rm \end{center} } \normalsize  \vskip-.2cm}
\newcommand\OEemail[1]{%
  {\raggedright\footnotesize\itshape\color{urlblue}#1\par}
}

\newcommand\url[1]{\textcolor{urlblue}{\underline{#1}}}

\newcommand\homepage[1]{%
  {\raggedright\footnotesize\itshape\color{urlblue}#1\par}
}

\let\title\OEtitle
\let\author\OEauthor
\let\affil\OEaddress
\let\address\OEaddress
\let\email\OEemail

\def\@copyrighttext{}
\newcommand{\setcopyright}[1]{\gdef\@copyrighttext{#1}}
\setcopyright{Optica Publishing Group}

\AtBeginDocument{%
   \ifosa@openaccess
     \appto{\@copyrighttext}{%
     \space under the terms of the \href{https://www.osapublishing.org/submit/review/copyright_permissions.cfm}{Optica Publishing Group Publishing Agreement}
     }
   \fi%
}

%% 29 August 2017: Updated the copyright text to OA
%% 3 April 2018: Only Express journals should have this copyright statement
%% 18 July 2018: changed font of copyright statement
\renewenvironment{abstract}%%
{\vskip1pc\noindent\textbf{Abstract:\space}}
{\\[12pt]\noindent{\fontsize{8pt}{9pt}\sffamily\copyright\, \number\year \hskip.05in\@copyrighttext}\par\vskip12pt
}


%% Legacy commands that do nothing except generate a warning
\newcommand{\ociscodes}[1]{\ClassWarning{osa-article}{The \string\ociscodes command is no longer supported; nor will you need to provide any OCIS code.}}
\newcommand{\ocis}[1]{\ClassWarning{osa-article}{The \string\ocis command is no longer supported; nor will you need to provide any OCIS code.}}

\newenvironment{abstract*}%%
{\vskip1pc\noindent\textbf{\textsf{Abstract:}\space}}
{}

% Headers and footers
\RequirePackage{fancyhdr}  % custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\RequirePackage{array}
\pagestyle{fancy}          % Enables the custom headers/footers
\fancyhf{}                 % Clear everything first
\renewcommand{\headrule}{}
% Headers
\fancyhead[L]{\headerfont \begin{tabular*}{\textwidth}{!{\color{black}\vrule}c!{\color{black}\vrule} @{\extracolsep{\fill}} c!{\color{black}\vrule}}\arrayrulecolor{black}
      \hline
      \cellcolor{black}\textcolor{white}{\@articletype} & \@journalname\hspace{21pt}\thepage \\
      \hline
    \end{tabular*}}

%% Various customizations
\renewcommand\figurename{Fig.}
\def\fps@table{h}%\def\fps@table{!htb}
\renewcommand\refname{References}
\bibliographystyle{osajnl}
\AtBeginDocument{\pretocmd{\bibliography}{\typeout{}}{}{}}

% Table style
\arrayrulecolor{authorcolor} % Set the color of the horizontal rules
\renewcommand{\arraystretch}{1.5} % Increased line spacing

%% New caption commands; updated 1 Aug, 2019 by Overleaf to accommodate subcaption or subfigure
\RequirePackage{caption}
\captionsetup{font=small,width=4.25in,labelsep=period}

%% New (more liberal than the default) float commands
\renewcommand{\topfraction}{.85}
\renewcommand{\bottomfraction}{.7}
\renewcommand{\textfraction}{.15}
\renewcommand{\floatpagefraction}{.66}
\renewcommand{\dbltopfraction}{.66}
\renewcommand{\dblfloatpagefraction}{.66}
\setcounter{topnumber}{9}
\setcounter{bottomnumber}{9}
\setcounter{totalnumber}{20}
\setcounter{dbltopnumber}{9}


%% Bibliography commands
%% 13 Jul 2016: Added cite package
\RequirePackage{cite}
%% 13 Jul 2016: no indent
% \setlength\bibindent{.2in}
\renewenvironment{thebibliography}[1]
     {\section*{\refname
        \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}%
        \list{\@arabic\c@enumiv .\hfill}%      \list{\@biblabel{\@arabic\c@enumiv .}}%
           {\settowidth\labelwidth{\footnotesize 99.}%{.25in}
%               \leftmargin\labelwidth
  \setlength{\parsep}{-0.05in}
  \setlength{\labelsep}{.25em}%{0.5em}
  \setlength{\itemsep}{0.05in}%{-0.06in}
  \setlength{\listparindent}{0in}
  \setlength{\itemindent}{0in}
%   \setlength{\leftmargin}{.2in}
  \setlength{\leftmargin}{\labelwidth}
  \addtolength{\leftmargin}{\labelsep}
  \setlength{\rightmargin}{0in}
%             \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m \footnotesize}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
%\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newcommand\OEReflinks{\thebibliography{}}
\newcommand\References{\thebibliography{}}
\let\endOEReferences\endthebibliography
\let\endOEReflinks\endthebibliography
\let\endReferences\endthebibliography

%% 2017/12/06 Automatically abbreviate journal titles
\RequirePackage{jabbrv}

%% New section parameters 4/28/2003 sdinee
%% Authors may now use \cite \ref for section numbers

\renewcommand\@seccntformat[1]{\csname the#1\endcsname.\quad }
\renewcommand\thesubsection{\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection{\thesubsection.\arabic{subsubsection}}

%% 17 Apr 2016: headings are now sans serif
\renewcommand\section{\@startsection {section}{1}{0pt}%
                                     {-2.5ex plus -1ex minus -.2ex}%
                                     {1.3ex plus .2ex}%
                                     {\normalsize\bfseries\sffamily}}
\renewcommand\subsection{\@startsection{subsection}{2}{0pt}%
                                     {-2.25ex plus -1ex minus -.2ex}%
                                     {1ex plus .2ex}%
                                     {\normalsize\itshape\sffamily}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{0pt}%
                                     {-2.25ex plus -1ex minus -.2ex}%
                                     {1ex plus .2ex}%
                                     {\small\upshape\sffamily}}

% 2020-12-22: Backmatter sections should use smaller font
% size, including run-in headings \bmsection.
\newenvironment{backmatter}{%
  \small%
  \newcommand{\bmsection}[1]{\par\medskip\noindent{\bfseries ##1.\enspace}}%
}{}

\RequirePackage[colorlinks=true,urlcolor=urlblue,linkcolor=black,citecolor=black,breaklinks=true,bookmarks=false]{hyperref}

\hyphenation {ac-cord-ing
           allow
           back-scat-ter
           back-scat-te-ring
           back-scat-tered
           scat-te-ring
           Based based
           cases
           cen-tered
           changed
           co-incide
           con-cerning
           con-ven-tional
           de-creased
           de-po-lar-iz-ation
           de-tector de-tectors
           de-vi-ation
           dis-cussion
           dis-tribu-tion
           dis-tribu-tions
           dis-trib-ute
           dis-trib-uted
           Ehhalt
           extinc-tion
           found
           Geest-hacht
           ground
           Hink-ley
           il-lus-trated
           il-lus-trate
           Intro-ducing
           Klap-heck
           lati-tude
           measure-ment
           measure-ments
           meas-ured
           measuring
           mixing
           north-east
           orig-inated
           op-er-ating
           out-flow
           pres-ence
           primary
           rather
           rela-tive
           sig-nal
           sig-nals
           solid
           tem-pera-ture
           Tem-pera-ture
           trans-ported
           tropo-pause
           Tropo-pause
           tropo-sphere
           Tropo-sphere
           tube
           tubes
           Values
           varies
           Weather
           re}

%% Journal abbreviation macros
\def\opex{ Opt.\ Express }
\def\boe{ Biomed.\ Opt.\ Express }
\def\ome{ Opt.\ Mater.\ Express }
\def\ao{ Appl.\  Opt.\ }
\def\aop{ Adv.\ Opt.\ Photon.\ }
\def\ap{ Appl.\  Phys.\ }
\def\apa{ Appl.\  Phys.\ A }
\def\apb{ Appl.\  Phys.\ B }
\def\apl{ Appl.\ Phys.\ Lett.\ }
\def\apj{ Astrophys.\ J.\ }
%\def\as{ Appl.\ Spectrosc.\ }--\as conflicts when authors use the siunitx package
\def\bell{ Bell Syst.\ Tech.\ J.\ }
\def\jqe{ IEEE J.\ Quantum Electron.\ }
\def\assp{ IEEE Trans.\ Acoust.\ Speech Signal Process.\ }
\def\aprop{ IEEE Trans.\ Antennas Propag.\ }
\def\mtt{ IEEE Trans.\ Microwave Theory Tech.\ }
\def\iovs{ Invest.\ Ophthalmol.\ Visual\ Sci.\ }
\def\jcp{ J.\ Chem.\ Phys.\ }
\def\jmo{ J.\ Mod.\ Opt.\ }
\def\jocn{ J.\ Opt.\ Commun.\ Netw.\ }
\def\jon{ J.\ Opt.\ Netw.\ }
\def\josa{ J.\ Opt.\ Soc.\ Am.\ }
\def\josaa{ J.\ Opt.\ Soc.\ Am.\ A }
\def\josab{ J.\ Opt.\ Soc.\ Am.\ B }
\def\jpp{ J.\ Phys.\ }
\def\nat{ Nature }
\def\oc{ Opt.\ Commun.\ }
\def\ol{ Opt.\ Lett.\ }
\def\opn{ Opt.\ Photon.\ News }
\def\pl{ Phys.\ Lett.\ }
\def\pra{ Phys.\ Rev.\ A }
\def\prb{ Phys.\ Rev.\ B }
\def\prc{ Phys.\ Rev.\ C }
\def\prd{ Phys.\ Rev.\ D }
\def\pre{ Phys.\ Rev.\ E }
\def\prl{ Phys.\ Rev.\ Lett.\ }
\def\pr{ Photon.\ Res.\ }
\def\rmp{ Rev.\ Mod.\ Phys.\ }
\def\pspie{ Proc.\ SPIE }
\def\sjqe{ Sov.\ J.\ Quantum Electron.\ }
\def\vr{ Vision Res.\ }
\def\cleo{ {\it Conference on Lasers and Electro-Optics }}
\def\assl{ {\it Advanced Solid State Lasers }}
\def\tops{ Trends in Optics and Photonics }

%% end osa-article.sty
