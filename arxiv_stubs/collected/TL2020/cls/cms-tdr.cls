%from SVN days
\def\Fileversion$#1: #2 ${\gdef\fileversion{#2}}
\def\Filedate$#1: #2 #3 ${\gdef\filedate{#2}}
\Fileversion$Revision: 451399 $
\Filedate$Date: 2018-03-16 10:40:56 -0400 (Fri, 16 Mar 2018) $
% for those files imported from svn
\global\def\RCS$#1: #2${\expandafter\def\csname RCS#1\endcsname{#2}}
%\global\def\RCS$#1${\expandafter\def\csname RCS#1\endcsname}
\global\def\RCS$#1${\relax}
%\def\fileversion{1.0.0}\def\filedate{21 December 2006}

\typeout{=======================================================}
\typeout{ }
\typeout{        CMS TDR/NOTE style. Version 2.0.1}
\typeout{ }
\typeout{        Lucas Taylor and George Alverson,  2020-02-18}
\typeout{ }
\typeout{=======================================================}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cms-tdr}[2020/02/18]
\usepackage{ifthen}%           Conditionals
%\tracingonline2
%\showboxdepth100
%\showboxbreadth100
%\usepackage{fltrace}

% switches to handle document styles: one of these must be specified.
% pas is the same as as.
\newboolean{cms@tdr}
\setboolean{cms@tdr}{false}
\newboolean{cms@note}
\setboolean{cms@note}{false}
\newboolean{cms@an}
\setboolean{cms@an}{false}
\newboolean{cms@in}
\setboolean{cms@in}{false}
\newboolean{cms@cr}
\setboolean{cms@cr}{false}
\newboolean{cms@pas}
\setboolean{cms@pas}{false}
\newboolean{cms@dn}
\setboolean{cms@dn}{false}
\newboolean{cms@paper}
\setboolean{cms@paper}{false}
% indicates final version. remove any draft/internal use markers.
\newboolean{cms@final}
\setboolean{cms@final}{false}
% to use a footnote for the collaboration list
\newboolean{cms@collab}
\setboolean{cms@collab}{false}
%to allow external commands
\newboolean{cms@external}
\setboolean{cms@external}{false}
%to allow for italic formatting
\newboolean{cms@italic}
\setboolean{cms@italic}{false}
% to use formatting for a supplement
\newboolean{cms@supplement}
\setboolean{cms@supplement}{false}
% suppress linenumbers for a non @final version
\newboolean{cms@nolineno}
\setboolean{cms@nolineno}{false}
% suppress DRAFT watermark for a non @final version
\newboolean{cms@nowatermark}
\setboolean{cms@nowatermark}{false}
% declare available options
\DeclareOption{tdr}{\setboolean{cms@tdr}{true}\def\cms@style{tdr}} % default anyway
\DeclareOption{note}{\setboolean{cms@note}{true}\def\cms@style{note}}
\DeclareOption{cmspaper}{\setboolean{cms@paper}{true}\def\cms@style{paper}}
\DeclareOption{an}{\setboolean{cms@an}{true}\def\cms@style{an}}
\DeclareOption{cr}{\setboolean{cms@cr}{true}\def\cms@style{cr}}
\DeclareOption{in}{\setboolean{cms@in}{true}\def\cms@style{in}}
\DeclareOption{pas}{\setboolean{cms@pas}{true}\def\cms@style{pas}}
\DeclareOption{dn}{\setboolean{cms@dn}{true}\def\cms@style{dn}}
\DeclareOption{final}{\setboolean{cms@final}{true}}
\DeclareOption{collab}{\setboolean{cms@collab}{true}}
\DeclareOption{supplement}{\setboolean{cms@supplement}{true}}
\DeclareOption{nolineno}{\setboolean{cms@nolineno}{true}}
\DeclareOption{nowatermark}{\setboolean{cms@nowatermark}{true}}
% unknown options are passed on to report class or article class,
% depending on the cms@tdr switch (its value is known as its option is declared first)
\DeclareOption*{%
\ifthenelse{\boolean{cms@tdr}}%
{\typeout{Using report \CurrentOption\ option}\PassOptionsToClass{\CurrentOption,openright}{report}}%
{\typeout{Using article \CurrentOption\ option}\PassOptionsToClass{\CurrentOption,titlepage}{article}}%
{}}

\ProcessOptions\relax

\ifthenelse{\boolean{cms@note}}{\typeout{Using cms note sub-class}}{\typeout{Not using cms note sub-class}}{}
\ifthenelse{\boolean{cms@tdr}}
{\LoadClass{report}}
{\LoadClass{article}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%
% Override the (rather clunky) default fonts of LaTex throughout
% --------------------------------------------------------------
%
\usepackage{palatino}%    Choose default roman font.  Others are times, pslatex, newcent, bookman, chancery
% can use mathpazo if no one uses \mathrm{\gamma}, etc., since it doesn't supply Greek in rm. Google "mathpazo mathrm greek"
\ifthenelse{\boolean{cms@tdr}}{}{%
\providecommand{\chaptername}{Chapter}% not present in article class
}
\usepackage{mathpazo}%  Matching math fonts (see http://www.math.uiuc.edu/~hartke/computer/latex/survey/survey.html [now broken])
\usepackage{helvet}%      Choose default sans serif
\usepackage{titlesec}%     Change style of headings (should precede section redefinitions below: Set sans serif for all headings)
\titleformat*{\section}{sf}
\titleformat*{\subsection}{sf}
\titleformat*{\subsubsection}{sf}
\titleformat*{\paragraph}{sf}
\titleformat*{\subparagraph}{sf}
%\usepackage{trace}% for plain debugging---should be last package loaded
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  General style files
%  -------------------
%
%\usepackage{layout}% for debugging layouts
%\usepackage{nag} % to remind of obsolete usage
\usepackage{fancybox}%         e.g. for calling out requirements, etc.
\usepackage{multicol}%         multiple columns (e.g. glossary)
\usepackage{longtable}% GOA: added 1 Jun 2007 for Christos
\usepackage{array}%
\usepackage{lineno}%           Does line numbers in margins (see \linenumbers command)
% ... other options for lineno: [pagewise]: renumbers starting each page; [modulo]: prints only every 5th line number

%\usepackage{cite}%
\providecommand{\citen}[1]{\cite{#1}}%

\usepackage{fancyhdr}%        modern version of fancyheadings
\usepackage{caption}%[=v3.5]% v3.6 breaks topcaption; could use \caption[position=top]{...} instead or topcaption.
\captionsetup[table]{position=top, skip=10pt}
\let\topcaption=\caption
\usepackage{subfig}%
\let\subfigure\subfloat% compatibility between subfigure and subfig packages
\usepackage{xspace}%
\usepackage{multirow}%
\usepackage{dcolumn} % for aligning columns on decimal: rather picky

\usepackage[table,svgnames]{xcolor}% just for warnings so far; do not use for journal submission without prior approval

\usepackage{amsmath,amssymb}% for advanced math typesetting
\DeclareMathOperator{\sgn}{sgn}% Declare the sgn operator
\DeclareMathOperator{\sign}{sign}% for those who insist on sign instead
\DeclareMathOperator{\erf}{erf}% just missing
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator{\cov}{cov}
\DeclareMathOperator{\Arg}{Arg}
\DeclareMathOperator{\corr}{corr}
\DeclareMathOperator{\Pois}{Pois}
% Specific to CSBS but have to be included anyway
\usepackage{alltt}
\usepackage{listings}
\usepackage{tabularx}
\usepackage{pifont,mdframed}
\usepackage{seqsplit}
% PENNAMES
\usepackage[low-sup]{subdepth}  % corrects normal super/sub after subdepth: https://tex.stackexchange.com/questions/352936/wrong-superscript-placement-with-hepparticles
\ifthenelse{\boolean{cms@italic}}{
%\usepackage{pennames-ital}% particle names: converted from pennames for mathpazo
\usepackage[italic,italicGreek]{heppennames2}
}{
%\usepackage{pennames-pazo}% particle names: converted from pennames for mathpazo
\usepackage[pazoGreek]{heppennames2}
}
%\usepackage{topcapt}% for captions at top, i.e., tables
% we have a modified version of pdfdraftcopy to avoid problems with roman page numbers
\ifthenelse{\boolean{cms@final}\or\boolean{cms@nowatermark}}{}{%
\usepackage[watermark]{pdfdraftcopy}\watermarkgraphic{BigDraft}%
}
\usepackage{pdfpages}% not for use in journal submission!
%\usepackage{placeins} % for FloatBarrier: TOP-17-006 ATLAS combo only
%\usepackage{adjustbox} % TOP-17-006 ATLAS combo only
%\usepackage{float}
%\usepackage{suffix} % allows for creation of starred commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%
% CMS definitions
\usepackage{ptdr-definitions}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define the default parskip so it can be reset back to this after
% it is locally changed in other environments
%
\newlength{\parskipsaved}
\setlength{\parskipsaved}{0.5\baselineskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Fine tune definitions of sections   (from report.cls. See p 27, Latex companion)
% ---------------------------------
%
%------------------------start of chapter redefinition
\def\@makechapterhead#1{%
  \vspace*{30\p@}%  Was 50
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
        \Large\sffamily\bfseries\mathversion{bold} \@chapapp\space \thechapter % was huge
        \par\nobreak
        \vskip 10\p@ % was 20
    \fi
    \interlinepenalty\@M
    \huge\sffamily\bfseries\mathversion{bold} #1\par\nobreak % Was Huge
    \vskip 40\p@ % was 40
  }}
\def\@makeschapterhead#1{%
  \vspace*{30\p@}%  Was 50
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \huge \sffamily \bfseries\mathversion{bold}  #1\par\nobreak% new format: was Huge...
    \vskip 40\p@
  }}
%------------------------end of chapter redefinition

\renewcommand\section{\@startsection
{section}%
{1}%
{\z@}%
{-2.5ex \@plus -1ex \@minus -.2ex}%       Was: {-3.5ex \@plus -1ex \@minus -.2ex}%
{0.3ex \@plus.2ex}%                       Was: {2.3ex \@plus.2ex}
{\sffamily\Large\bfseries\mathversion{bold}}}%              Was: \normalfont ...

\renewcommand\subsection{\@startsection
{subsection}%
{2}%
{\z@}%
{-1.0ex\@plus -1ex \@minus -.2ex}%       Was: {-3.25ex\@plus -1ex \@minus -.2ex}%
{0.05ex \@plus .2ex}%                     Was:   {1.5ex \@plus .2ex}%
{\sffamily\large\bfseries\mathversion{bold}}}%           Was: \normalfont ...

\renewcommand\subsubsection{\@startsection
{subsubsection}%
{3}%
{\z@}%
{-1.0ex\@plus -1ex \@minus -.2ex}%       Was: {-3.25ex\@plus -1ex \@minus -.2ex}
{0.05ex \@plus .2ex}%                     Was:   {1.5ex \@plus .2ex}%
{\sffamily\normalsize\bfseries\mathversion{bold}}}%           Was: \normalfont ...

\renewcommand\paragraph{\@startsection
{paragraph}%
{4}%
{\z@}%
{-1.0ex\@plus -1ex \@minus -.2ex}%       Was: {3.25ex \@plus1ex \@minus.2ex}%             Was:
{-2em}%                             Was:  If negative, means in-line. Space is then the indentation.
{\sffamily\normalsize\bfseries\mathversion{bold}}}%           Was: \normalfont ...

\renewcommand\subparagraph{\@startsection
{subparagraph}%
{5}%
{\parindent}%
{-1.0ex\@plus -1ex \@minus -.2ex}%
{-2em}%
{\sffamily\normalsize\bfseries\mathversion{bold}}}%           Was: \normalfont ...



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Formatting of table of contents, etc.
% -------------------------------------
%
\renewcommand\tableofcontents{%
\setlength{\parskip}{0.15\baselineskip}%%% LT: make lines tight
  \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
\setlength{\parskip}{\parskipsaved}%%% LT: reset to default value
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define page layout
% ------------------
%
\setlength{\textwidth}{160mm}
\setlength{\textheight}{235mm}
\setlength{\columnsep}{10mm}
\setlength{\columnseprule}{0.3pt}% if zero then there is no rule between 2 columns

\if@twoside
  \setlength{\oddsidemargin}{0mm}
  \setlength{\evensidemargin}{0mm}
\else
  \setlength{\oddsidemargin}{0mm}
  \setlength{\evensidemargin}{0mm}
\fi

\setlength{\footskip}{36pt}
\setlength{\headheight}{25pt}
\setlength{\headsep}{20pt}%     Distance from bottom of header to main body
\setlength{\topmargin}{-8pt}

%
% Margin notes
% ------------
\setlength{\marginparpush}{\baselineskip}% space between successive notes
\setlength{\marginparsep}{3mm}%            distance from main text
\setlength{\marginparwidth}{20mm}%         width of note

%
% Paragraph spacing / indentation
% -------------------------------
\setlength{\parindent}{0pt}
\setlength{\parskip}{\parskipsaved}


\raggedbottom


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  PDF and graphics settings: must go after section/chapter redefinitions
%  -------------------------
%
\usepackage{graphicx,graphics}
%\DeclareGraphicsExtensions{.eps,.png,.jpg,.jpeg}  % used by includegraphics. Note: .eps and .gif not supported by pdftex
\DeclareGraphicsExtensions{.pdf,.PDF,.png,.PNG,.jpg,.JPG,.jpeg,.JPEG}  % used by includegraphics. Note: .eps and .gif not supported by pdftex
\usepackage{lscape} % part of graphicx. used for rotating entire pages.
\usepackage{rotating}%  LT: added 3 Apr 2006 for Vincenzo

% Use following line for electronic copy (coloured links etc)
%\usepackage[pagebackref=true,bookmarksnumbered,bookmarksopen,bookmarksopenlevel=1,colorlinks,linkcolor=magenta,citecolor=blue,urlcolor=red,plainpages=false,pdfpagelabels]{hyperref}
%\usepackage[bookmarksnumbered,bookmarksopen,bookmarksopenlevel=1,colorlinks,linkcolor=magenta,citecolor=blue,urlcolor=red,plainpages=false,pdfpagelabels]{hyperref}

% Use following line for paper (no coloured links etc)
\usepackage[bookmarksnumbered,bookmarksopen,bookmarksopenlevel=1,colorlinks=false,pdfborder={0 0 0},plainpages=false,pdfpagelabels, unicode=false]{hyperref}

\usepackage[numbers,sort&compress,merge]{natbib}
\ifthenelse{\boolean{cms@tdr}}
{\ifthenelse{\boolean{cms@final}}
  {}
  {\ifthenelse{\boolean{cms@nolineno}}{}{\linenumbers}}
}
{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Float handling parameters for better placing of figures
% -------------------------------------------------------
%
\renewcommand{\topfraction}{1.0}
\renewcommand{\dbltopfraction}{1.0}
\renewcommand{\bottomfraction}{1.0}
\renewcommand{\textfraction}{0.2}

\setlength{\intextsep}{10pt plus 2pt minus 4pt}       % Space between in-text figures and text.
\setlength{\floatsep}{10pt plus 2pt minus 4pt}        % Space between adjacent floats moved to top or bottom of text page.
\setlength{\textfloatsep}{10pt plus 2pt minus 4pt}    % Space between main text and floats at top or bottom of page.
\setlength{\dblfloatsep}{10pt plus 2pt minus 4pt}     % Same for double column
\setlength{\dbltextfloatsep}{10pt plus 2pt minus 4pt}

\setlength\abovecaptionskip{4pt plus 2pt minus 2pt}   % default is for caption at bottom.
                                                      % use topcapt.sty: \topcaption for cap at top
\setlength\belowcaptionskip{0pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Miscellaneous style settings
% ----------------------------
%
\bibliographystyle{cms_unsrt}  % Default CMS bib style

\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{2}

\renewcommand{\baselinestretch}{0.99}%   LT 2005-10-07   was 1.0
\normalsize% required to activate \baselinestretch

% common hyphenations
\hyphenation{had-ron-i-za-tion}
\hyphenation{cal-or-i-me-ter}
\hyphenation{de-vices}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define page header and footer content
% -------------------------------------
%
%  LT 2005-10-07 add \small's
% GOA 2006-12-26: use non-deprecated versions of fancyhdr macros
\pagestyle{fancy}
\fancyhead[LE,RO]{\sffamily\bfseries{}\thepage}
% cms@tdr has chapters, which get listed in the header; others do not
\ifthenelse{\boolean{cms@tdr}}{\fancyhead[RE]{\sffamily\small\leftmark}}{\fancyhead[RE]{}}
\fancyhead[LO]{\sffamily\small\rightmark}

\fancyfoot{}% clear

% Redefine format of text in header lines (see. fancyhdr.sty)
% ---------------------------------------
\def\MakeUppercase{\mathversion{bold}\bfseries}%     By default is:  \def\MakeUppercase{\uppercase}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define standard section headings
% --------------------------------
%
\renewcommand{\contentsname}{Contents}
\renewcommand{\listfigurename}{Figures}
\renewcommand{\listtablename}{Tables}
\renewcommand{\bibname}{References}
\renewcommand{\indexname}{Index}
\renewcommand{\chaptername}{Chapter}
\renewcommand{\appendixname}{Appendix}
\renewcommand{\abstractname}{Abstract}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Re-New itemize environment (see e.g. P61 of LaTeX companion)
% --------------------------
%

\renewenvironment{itemize}%
{\begin{list}%
{$\bullet$}%
{\setlength{\topsep}{0.0ex}%
 \setlength{\partopsep}{0.0ex}%
 \setlength{\parsep}{0.5\parskip}%
 \setlength{\itemsep}{0.0ex}%
 \setlength{\leftmargin}{5ex}%
 \setlength{\rightmargin}{5ex}%
}}%
{%
\end{list}%
}%

% itemize same as itemize: for backwards compatibility
\newenvironment{myitemize}%
{\begin{list}%
{$\bullet$}%
{\setlength{\topsep}{0.0ex}%
 \setlength{\partopsep}{0.0ex}%
 \setlength{\parsep}{0.5\parskip}%
 \setlength{\itemsep}{0.0ex}%
 \setlength{\leftmargin}{5ex}%
 \setlength{\rightmargin}{5ex}%
}}%
{%
\end{list}%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% renew today to be US/rest of world agnostic: yyyy/mm/dd
\renewcommand{\today}{\number\year/\two@digits{\number\month}/\two@digits{\number\day}}
\newcommand{\marginlabel}[1]{\mbox{}\marginpar{\raggedleft\hspace*{0pt}#1}}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\glossname{Glossary}
\providecommand{\GLOS}[2]{\makebox[0.110\textwidth][l]{\bfseries\mathversion{bold}#1}
\makebox[0.025\textwidth][l]{~}
\parbox[t]{0.32\textwidth}{#2\vspace*{-2.75mm}\\
}}
\newenvironment{theglossary}%
{\chapter*{\glossname}
\@mkboth{\MakeUppercase\glossname}{\MakeUppercase\glossname}%
\addcontentsline{toc}{chapter}{\glossname}%
\setlength{\columnseprule}{0.2mm}
\setlength{\multicolsep}{7mm}
%
\vspace*{-5mm}
\begin{multicols}{2}
\small%
\raggedcolumns%
\noindent}
{%
\end{multicols}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Colour Plates environment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newcommand{\colourplates}{CP \@arabic\c@figure}
\def\CMScpname{Colour Plates}
\newenvironment{CMScolourplates}%
{\chapter*{\CMScpname}
\@mkboth{\MakeUppercase\CMScpname}{\MakeUppercase\CMScpname}%
\addcontentsline{toc}{chapter}{\CMScpname}%
\cleardoublepage
\begingroup
\renewcommand\thefigure{\colourplates}
}
{\endgroup}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Modified bibliography processing (from article class)
%
\def\refname{References}
\renewenvironment{thebibliography}[1]
     {\chapter*{\refname}%
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
    \addcontentsline{toc}{chapter}{\refname}%
    \rule{\linewidth}{1.0pt}
    %
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Expand LOF width so we can deal with Figure 10.10; this increases the label for tables as well
\renewcommand{\l@figure}{\@dottedtocline{1}{1.5em}{3.3em}}
\renewcommand{\l@section}{\@dottedtocline{1}{1.5em}{2.5em}}  %last arg was 2.3em
\renewcommand{\l@subsection}{\@dottedtocline{2}{3.8em}{3.5em}}  %last arg was 3.2em

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Define a no-op widetext environment: to allow documents to specify the widetext environment for the APS journals
\newenvironment{widetext}{}{}
%  Environment for capatibility with Nature \begin\end{appendices} and  \bmhead command
\newenvironment{appendices}{\appendix}{}
\providecommand{\bmhead}{\section}
\providecommand{\backmatter}{\relax}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Compatibility items
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\titlerunning}[1]{\relax} % for EPJC short titles for running head
\providecommand{\authorrunning}[1]{\relax} % for EPJC short author list for running head
\providecommand{\doi}{\texttt{doi:}\begingroup \urlstyle{tt}\Url}
\providecommand{\DOI}[1]{\href{http://dx.doi.org/#1}{\doi{#1}}}

\newenvironment{acknowledgments}{\section*{Acknowledgments}\tolerance=800}{\par}
% authorlist formatting; cmsAuthorMark matches use in endnotes
\newskip{\cmsinstskip} \cmsinstskip=0pt plus 4pt
\newskip{\cmsauthskip} \cmsauthskip=16pt
%% new version w/ orcid
\newcommand{\cmsinstitute}[1]{\par\pagebreak[3]\bfseries #1 \mdseries\\[0pt]}
\newcommand{\cmsorcid}[1]{\href{https://orcid.org/#1}{\hspace*{0.1em}\raisebox{-0.45ex}{\includegraphics[width=1em]{ORCIDiD_iconvector.pdf}}}}
\newcommand{\cmsAuthorMark}[1]{\hbox{\@textsuperscript{\normalfont#1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   NOTES code
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifthenelse{\boolean{cms@tdr}}{
}
{
\typeout{Defining CMS Note commands}
%
\definecolor{cms@grey}{gray}{0.4}
%
% ignore journal specific macros in CMS style
%
\newcommand{\pacs}[1]{\relax}
%
\pagestyle{empty}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% title page %%%%%%%%%%%%%%%%%%%%%%%%%
% author/address from class 'aps2005' for AP-S/URSI 2005 conference
\newcounter{author}
\newboolean{cms@primaryAuthor}
\setboolean{cms@primaryAuthor}{false}
\renewcommand\author{\@ifstar\cmsauthorP\cmsauthor}
\newcommand{\cmsauthor}[2][]
{
   \stepcounter{author}
   \@namedef{author@\theauthor}{#2}
   \@namedef{authorlabel@\theauthor}{#1}
   \@namedef{authorP@\theauthor}{-}
}
\newcommand{\cmsauthorP}[2][]
{
   \stepcounter{author}
   \@namedef{author@\theauthor}{#2}
   \@namedef{authorlabel@\theauthor}{#1}
   \@namedef{authorP@\theauthor}{*}
   \setboolean{cms@primaryAuthor}{true}
}
\newcounter{address}
\newcommand{\address}[2][]{
   \stepcounter{address}
   \@namedef{address@\theaddress}{#2}
   \@namedef{addresslabel@\theaddress}{#1}
}

\newcommand{\alsep}{and}

% uppercase the cms@style as note type: see TeXbook exercise 20.19 for uppercase technique
\newcommand{\cmsCollabName}{The CMS Collaboration}
\newcommand{\cmsPubBlock}{CMS \ifthenelse{\boolean{cms@paper}\or\boolean{cms@pas}}{\cmsSTYLE\ }{}\cmsNUMBER}
\newcommand{\cmsNoteHeader}[1]{\edef\next{\def\noexpand\cmsSTYLE{\cms@style}}\ifx\cmsNUMBER\undefined\uppercase\expandafter{\next}\def\cmsNUMBER{#1}\else\fi}
\newcommand{\cmsNoteContact}[1]{\def\cmsContact{#1}}
\newcommand{\cmslogo}{\includegraphics[height=2cm]{CMS-bw-logo}}
\newcommand{\cmsTag}{CMS-\cmsNUMBER}
\newcommand{\cmsCopyright}{\copyright\,\the\year\ CERN for the benefit of the CMS Collaboration.}
\newcommand{\appMsg}{See Appendix~\ref{app:collab} for the list of collaboration members}
\def\cmsNoteRepoAddress{http://cdsweb.cern.ch/collection/CMS\%20PHYSICS\%20ANALYSIS\%20SUMMARIES} %this avoids a problem with the percent signs in commands
\newcommand{\cmsNoteRepo}[0]
{
    \ifthenelse{\boolean{cms@note}\or\boolean{cms@in}\or\boolean{cms@an}\or\boolean{cms@cr}}% check to see what else is listed; should note format for search, eg, CMS%20AN-2009/191
    {
        \href{http://cms.cern.ch/iCMS/jsp/iCMS.jsp?mode=single&part=publications}{Available on the CMS information server}
    }
    {
        \ifthenelse{\boolean{cms@final}}
        {
            \ifthenelse{\boolean{cms@pas}}
            {
                \href{\cmsNoteRepoAddress}{Available on the CERN CDS information server}}
            {
            }
        }
        {\relax}
    }
}
% Abstract: now a command, not an environment.
\newsavebox{\CMSabstractbox}
\savebox{\CMSabstractbox}{Please replace the default abstract using the abstract command.}
\renewcommand{\abstract}[1]{\savebox{\CMSabstractbox}{\parbox[t]{0.90\textwidth}{#1}}}
\newenvironment{CMSabstract}{\@beginparpenalty\@lowpenalty
%
    \begin{center}%
    \vskip1.2em
%    \Large\bfseries\SS@sectfont\abstractname % use this version for same style as other headings: default = sans
    \Large\bfseries\abstractname
    \@endparpenalty\@M
    \end{center}
%
    \setlength{\parindent}{0pt}%
    \setlength{\parskip}{0.5\baselineskip}%
    \ignorespaces}
{\par}
% Definition of maketitle mostly from article.cls
\renewcommand\maketitle{\begin{titlepage}%
  \thispagestyle{empty}
%  \let\footnotesize\small
%  \let\footnoterule\relax
%  \def\thanks##1{\g@addto@macro\@thanks{\footnotetext{##1}}}  %%http://www.intlpress.com/HHA/style/hha.cls
%  \let \footnote \thanks
  \setlength{\topmargin}{ -3.5cm}
  \setlength{\parskip}{ 0pt}
 \setlength{\footskip}{ 36pt}
 % \setlength{\textheight}{ 235mm}
 % \setlength{\textheight}{ 275mm}
 \enlargethispage{40mm}
  \setcounter{page}{1}\pagenumbering{roman}
\ifx\cmsCernNoTag\undefined
\cmsNoteRepo\hfill{\Large\textbf{\cmsPubBlock}}
\vskip -2em
\else
\newbox\cms@cernbox
\newbox\cms@stampbox
\setbox\cms@stampbox=\hbox to 0pt { \small \begin{tabular}[b]{@{}l}\cmsCernNoTag\\[-0.2em]\cmsCernDate\end{tabular}}
\setbox\cms@cernbox=\vbox{\hbox{\hspace{-1cm}\includegraphics[width=1cm]{cernlogo}\raise 0.35 em \box\cms@stampbox\hss}\vspace*{12mm}\vss}
\begin{center}\Large EUROPEAN ORGANIZATION FOR NUCLEAR RESEARCH (CERN)\end{center}
\vskip 2em
\fi
% Select header block: appropriate center graphic + date and optional archive info
\ifthenelse{\boolean{cms@final}}{
\ifx\cmsCernNoTag\undefined
\begin{center}\includegraphics{cms_\cms@style}\end{center}
\vskip -0.5em
\else
\begin{minipage}[t]{\textwidth}\cmslogo\hspace*{1em}
\hrulefill\box\cms@cernbox\hspace*{55mm}\parskip=0pt\\ \large\begin{tabular}[t]{@{}r@{}l} &
\cmsTag\\\end{tabular}\hspace*{55mm}\end{minipage}
\vskip 0.5em%
\fi
\ifthenelse{\boolean{cms@pas}}{\cmsContact}{}%
{\ifx\cmsCernNoTag\undefined
\hfill\large\ifx\svnDate\empty\@date\else\svnDate\fi
\fi}
}
{
\begin{center}\includegraphics{cms_draft_\cms@style}\end{center}
\vskip -0.5em%
{\hfill\raggedleft\ignorespaces\large\begin{tabular}{@{}l@{\hspace{2pt}}l}
\multicolumn{2}{@{}l}{\@date}  \\
Archive Hash:  & \ifx\svnVersion\empty\relax\else\svnVersion\fi \\
Archive Date:& \ifx\svnDate\empty\relax\else\svnDate\fi \\
\end{tabular}}
}
\par%
  \begin{center}%
    {\vskip 1.5cm%
     \LARGE \@title \par}%
    \vskip 3em%
%    {\large
     \lineskip .75em%
     %%%%%%%%%% author block %%%%%%%%%%
\ifthenelse{\boolean{cms@pas}\or\boolean{cms@paper}}
{\Large{\cmsCollabName}\ifthenelse{\boolean{cms@collab}}{\renewcommand{\thefootnote}{\fnsymbol{footnote}}\footnote[1]{\appMsg}\renewcommand{\thefootnote}{\arabic{footnote}}}{}}
{
    \newcounter{c@author}
    \newcounter{c@tmp}
    \ifthenelse{\value{author}=2}{%
      \newcommand{\liand}{ and }}{%
      \newcommand{\liand}{, and }}
    % Next add the authors
    \ifthenelse{\value{address}<2}{%
      %No address references required if there is only one
      \@nameuse{author@1}%
      \stepcounter{c@author}%
      \whiledo{\value{c@author}<\value{author}}{%
        \setcounter{c@tmp}{\value{author}}%
        \addtocounter{c@tmp}{-\value{c@author}}%
        \ifthenelse{\value{c@tmp}=1}{%
          \renewcommand{\alsep}{\liand}}{\renewcommand{\alsep}{, }}%
        \stepcounter{c@author}\alsep \@nameuse{author@\thec@author}}\\%
    }
    {%Add address references after the author's name
      \@nameuse{author@1}\ifthenelse{\equal{\@nameuse{authorP@1}}{*}}{${}^{*,\ref{\@nameuse{authorlabel@1}}}$}{${}^{\ref{\@nameuse{authorlabel@1}}}$}%
      \stepcounter{c@author}%
      \whiledo{\value{c@author}<\value{author}}{%
      \setcounter{c@tmp}{\value{author}}%
      \addtocounter{c@tmp}{-\value{c@author}}%
      \ifthenelse{\value{c@tmp}=1}{%
        \renewcommand{\alsep}{\liand}}{\renewcommand{\alsep}{, }}%
      \stepcounter{c@author}\alsep \@nameuse{author@\thec@author}%
      \ifthenelse{\equal{\expandafter\csname authorP@\thec@author \endcsname}{*}}
      {${}^{*,\ref{\@nameuse{authorlabel@\thec@author}}}$}%
      {${}^{\ref{\@nameuse{authorlabel@\thec@author}}}$}%
      }
    }
    \vspace{0.2ex}

    \ifthenelse{\value{address}>0}{%
      \ifthenelse{\value{address}=1}{
        %Output the address without any reference symbols
       %%        {\slshape\small \@nameuse{address@1}}
        {\@nameuse{address@1}}
      }
      {%Output the addresses as an enumerated list
        \newcounter{c@address}

        \begin{center}
        \whiledo{\value{c@address}<\value{address}}
        {
          \refstepcounter{c@address}
            ${}^{\thec@address}$\,%
              \label{\@nameuse{addresslabel@\thec@address}}%
              \@nameuse{address@\thec@address}\\ %
        }
        \ifthenelse{\boolean{cms@primaryAuthor}}{{}$^*$Primary author}{}
        \end{center}

      } % end of the address creation ifthenelse block
    }
    {
      \relax
    }
  }
  \end{center}
  %%%%%%%%% end author block %%%%%%%%%%
%  }

  \par
  \vskip 1cm plus 1cm%
  \ifthenelse{\not\boolean{cms@supplement}}{
   \begin{CMSabstract}
    \centering
    \usebox{\CMSabstractbox}
    \end{CMSabstract}
  }{}
  % submit to :
  \ifx\cmsMessage\undefined\else\vskip 1cm\begin{center}\textit{\cmsMessage}\end{center}\fi
  \ifthenelse{\boolean{cms@final}}{\null\vfill\ifthenelse{\boolean{cms@paper} \or \boolean{cms@pas} \or \boolean{cms@note} \or \boolean{cms@dn}}{\noindent\small{\cmsCopyright\ \href{http://creativecommons.org/licenses/by/4.0}{CC-BY-4.0 license}}}{}}{\vfill\hfill{\textcolor{cms@grey}{\framebox{
  \begin{tabular}{lp{0.8\textwidth}}
  \multicolumn{2}{l}{This box is only visible in draft mode. Please make sure the values below make sense.}\\
  \cline{1-2}\\
  PDFAuthor:&\expandafter\string\@pdfauthor\\
  PDFTitle:&\expandafter\string\@pdftitle\\
  PDFSubject:&\expandafter\string\@pdfsubject\\
  PDFKeywords:&\expandafter\string\@pdfkeywords\\
  \cline{1-2}\\
  \multicolumn{2}{l}{Please also verify that the abstract does not use any user defined symbols}
  \end{tabular}}}}\hfill\vfil}
  \null
  \end{titlepage}%
  \cleardoublepage
  \pagestyle{fancy}
  \setcounter{page}{1}\pagenumbering{arabic}
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
  % from general tdr layout
\setlength{\footskip}{36pt}
\setlength{\headheight}{25pt}
\setlength{\headsep}{20pt}%     Distance from bottom of header to main body
\setlength{\topmargin}{-8pt}
\ifthenelse{\boolean{cms@final}}{}{\ifthenelse{\boolean{cms@nolineno}}{}{\linenumbers}}
}
\renewenvironment{thebibliography}[1]
     {\section*{\refname}%
           \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}
           \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}{}
%% TOC must use \section instead of default \chapter
\renewcommand\tableofcontents{%
\setlength{\parskip}{0.15\baselineskip}%%% LT: make lines tight
  \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
\setlength{\parskip}{\parskipsaved}%%% LT: reset to default value
}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Miscellaneous macros for diagnostics and options
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% macro to set bw or colour figures: \combinedfigure{switches for includegraphics}{bw figure name}{colour figure name}
\newboolean{bwfigurespreferredswitch}
\setboolean{bwfigurespreferredswitch}{false}
%\setboolean{bwfigurespreferredswitch}{true}
\providecommand{\combinedfigure}[3]{%
\ifthenelse{\boolean{bwfigurespreferredswitch}}%
{\includegraphics[#1]{#2}}%
{\includegraphics[#1]{#3}}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  define an annotation command for pdf: most from CGvanderLaan at hetnet.nl
\providecommand\annotation[3]%Note title, note text
{\pdfannot width 1cm height 0.5cm depth 0cm
  {/Subtype/Text
  /Open false                 %Open by default in viewer?
  /T (#1)            %Title, shows up as Reviewer Name in comment filter
  /C [#2]                %Colour
  /Contents (#3)             %Annotation text
  }
}
%  and use it to call out included files: use 'perl -i -p -e 's/input\s*{/tracinginput{/g' */*.tex' first (*/*/*.tex, etc to recurse)
\def\tracinginputswitch{false}
\providecommand{\tracinginput}[1]{\ifthenelse{\equal{\tracinginputswitch}{true}}
{\annotation{Input File}{0.9 0.9 0}{#1}\input{#1}}
{\input{#1}}
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\tracinggraphicsswitch{false}
\makeatletter\let\OldGinclude@graphics\Ginclude@graphics%
\renewcommand{\Ginclude@graphics}[1]{%
\ifthenelse{\equal{\tracinggraphicsswitch}{true}}%
{\annotation{Graphics File}{0 0 .9}{#1}\typeout{<789FIG  #1 \thefigure\thesubfigure>}\OldGinclude@graphics{#1}}{\typeout{<789FIG  #1 \thefigure\thesubfigure>}\OldGinclude@graphics{#1}}}%
\makeatother
%{\annotation{Graphics File}{0 0 .9}{#1}\typeout{<789FIG  #1 \thefigure>}\OldGinclude@graphics{#1}}{\typeout{<789FIG  #1 \thefigure>}{\textcolor{cms@grey}{\fbox{\OldGinclude@graphics{#1}}}}}}%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This tags all input files with <567INP >
\makeatletter\let\OldCMS@input\InputIfFileExists%
\long\def\InputIfFileExists#1#2#3{{\typeout{<567INP #1>}}{}\OldCMS@input{#1}{#2}{#3}}%
\makeatother
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newboolean{colourplateswitch}
\setboolean{colourplateswitch}{true}

%
%
% These were previously in pieces of the skeleton. Brought here to clean up the export version.
%
\newboolean{editorOnSwitch}
\setboolean{editorOnSwitch}{true}
\providecommand{\editor}[1]{\ifthenelse{\boolean{editorOnSwitch}}{{\large\sffamily{\bfseries{}Editor(s):}
#1\\}}%
{}{}}
\providecommand{\contributor}[1]{\ifthenelse{\boolean{editorOnSwitch}}{{\large\sffamily{\bfseries{}Contributor(s):}
#1\\}}%
{}{}}
\providecommand{\fixme}[1]{{\sffamily{\bfseries{}FIXME:} #1}}
% uppercase clone
\providecommand{\FIXME}[1]{{\sffamily{\bfseries{}FIXME:} #1}}

% editorial
\providecommand {\FIXMECOLOR}{{\sffamily{\bfseries{} FIXME: Replace with BW version }}}
\providecommand {\FIXMESHADING}{{\sffamily{\bfseries{} FIXME: Turn off background shading }}}
\providecommand {\FIXMEFONT}{{\sffamily{\bfseries{} FIXME: Fonts too small }}}
\providecommand {\FIXMELOWRES}{{\sffamily{\bfseries{} FIXME: Low resolution or poor quality }}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\endinput
