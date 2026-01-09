\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{shinybook}[2018/03/29 v0.6 Shiny lecture notes]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessOptions

\LoadClass[
a4paper,
12pt,
titlepage=firstiscover,
headings=small,
oneside,
numbers=noenddot,
parskip=half,
bookmarkpackage=false
]{scrbook}
\KOMAoptions{DIV=11}

\providecommand{\ExecuteBeforeCleveref}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% language support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[utf8]{inputenc}
\RequirePackage{babel}
\RequirePackage[autostyle=true]{csquotes}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define colors 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[svgnames,hyperref]{xcolor}
\definecolor{hrefcolor}{rgb}{0.0,0.4,0.7}
\definecolor{citecolor}{rgb}{0.0,0.35,0.2}
\definecolor{structure}{rgb}{0.09,0.09,0.44}
\definecolor{linkcolor}{RGB}{0,76,147}
\definecolor{halfgray}{gray}{0.55}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% amsmath, amsthm, hyperref, cleveref, autonum (in this order!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[leqno]{amsmath}
\RequirePackage{amsthm}
\RequirePackage[centercolon]{mathtools}
\numberwithin{equation}{chapter} % must be *before* cleveref!

\RequirePackage{algorithm}

\PassOptionsToPackage{hyphens}{url}
\RequirePackage[  
colorlinks=true,
linkcolor=linkcolor,
citecolor=linkcolor,
filecolor=linkcolor,
urlcolor=linkcolor,
pdfencoding=auto,
hypertexnames=false,
linktocpage=true,%
]{hyperref}
\newcommand{\email}[1]{\href{mailto:#1}{\texttt{#1}}}
\ExecuteBeforeCleveref

\RequirePackage[
nameinlink,
capitalise,
]{cleveref}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load fonts (warning: microtype must be *before* cleveref for luatex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[T1]{fontenc}
\RequirePackage[proportional]{libertine}
\RequirePackage[libertine,smallerops,liby,vvarbb]{newtxmath}
\RequirePackage[scaled=0.95,varqu,varl]{inconsolata}
\useosf
\frenchspacing
\RequirePackage[kerning,spacing]{microtype}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format: title, sectioning in colored sans smallcaps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[overload]{textcase}
\renewcommand*{\sectfont}{\color{structure}\sffamily}
\addtokomafont{title}{\color{structure}\sffamily\scshape}
\setkomafont{subtitle}{\large\sffamily\scshape}
\addtokomafont{author}{\sffamily}
\addtokomafont{date}{\sffamily}
\addtokomafont{publishers}{\sffamily}
\addtokomafont{part}{\scshape}
\addtokomafont{chapter}{\scshape}
\addtokomafont{section}{\scshape}
\addtokomafont{subsection}{\scshape}
\addtokomafont{subsubsection}{\scshape\itshape}

% title in all caps 
\let\Title\title
\renewcommand{\title}[1]{\Title{\MakeUppercase{#1}}}

% section headers in small caps (requires lowercasing)
\renewcommand*\chapterformat{\MakeUppercase{\@appname\liningnumsf{\thechapter}}\enskip}
\renewcommand*\sectionformat{\MakeLowercase{\@appname\thesection}\enskip}
\renewcommand*\subsectionformat{\MakeLowercase{\@appname\thesubsection}\enskip}
\renewcommand*\subsectionformat{\MakeLowercase{\@appname\thesubsection}\enskip}
\renewcommand*\subsubsectionformat{\upshape\MakeLowercase{\@appname\thesubsubsection}\enskip}

\let\Part\part
\renewcommand*{\part}{%
    \@ifstar {\star@part}{\@dblarg\nonstar@part}%
}
\newcommand*{\star@part}[1]{%
    \Part*{\MakeUppercase{#1}}%
}
\newcommand*{\nonstar@part}[2][]{%
    \Part[{#1}]{\MakeUppercase{#2}}%
}
\renewcommand{\chapterlinesformat}[3]{%
    \MakeUppercase{#2#3}
    \rule{\textwidth}{0.4pt}
}
\let\Section\section
\renewcommand*{\section}{%
    \@ifstar {\star@section}{\@dblarg\nonstar@section}%
}
\newcommand*{\star@section}[1]{%
    \Section*{\MakeLowercase{#1}}%
}
\newcommand*{\nonstar@section}[2][]{%
    \Section[{#1}]{\MakeLowercase{#2}}%
}
\let\Subsection\subsection
\renewcommand*{\subsection}{%
    \@ifstar {\star@subsection}{\@dblarg\nonstar@subsection}%
}
\newcommand*{\star@subsection}[1]{%
    \Subsection*{\MakeLowercase{#1}}%
}
\newcommand*{\nonstar@subsection}[2][]{%
    \Subsection[{#1}]{\MakeLowercase{#2}}%
}
\let\Subsubsection\subsubsection
\renewcommand*{\subsubsection}{%
    \@ifstar {\star@subsubsection}{\@dblarg\nonstar@subsubsection}%
}
\newcommand*{\star@subsubsection}[1]{%
    \Subsubsection*{\MakeLowercase{#1}}%
}
\newcommand*{\nonstar@subsubsection}[2][]{%
    \Subsubsection[{#1}]{\MakeLowercase{#2}}%
}

% Appendix A, B etc. (in small caps)
\newcommand{\@appname}{\relax}
\newcommand*{\appendixmore}{%
    \renewcommand{\thesection}{\scshape{\alph{section}}}
}

% Configure table of contents
\RequirePackage[titles]{tocloft}
\setcounter{tocdepth}{1}
\renewcommand{\cftpartfont}{\color{structure}\sffamily\scshape\uppercase}
\renewcommand{\cftchapfont}{\sffamily\scshape\lowercase}
\renewcommand{\cftsecfont}{\sffamily}
\renewcommand{\cftsubsecfont}{\sffamily\itshape}
\renewcommand{\cftpartpagefont}{\sffamily}
\renewcommand{\cftchappagefont}{\sffamily}
\renewcommand{\cftsecpagefont}{\sffamily}
\renewcommand{\cftsubsecpagefont}{\sffamily}

\renewcommand{\cftpartleader}{}
\renewcommand{\cftpartafterpnum}{\cftparfillskip}
\cftpagenumbersoff{part}
\renewcommand{\cftchapleader}{}
\renewcommand{\cftchapafterpnum}{\cftparfillskip}
\renewcommand{\cftsecleader}{}
\renewcommand{\cftsecafterpnum}{\cftparfillskip}
\renewcommand{\cftsubsecleader}{}
\renewcommand{\cftsubsecafterpnum}{\cftparfillskip}
% page numbers flushleft 
\renewcommand{\cftchapfillnum}[1]{%
    {\cftchapleader}%
    \hspace{1em}\hbox{\cftchappagefont#1}%
\cftchapafterpnum\par}
\renewcommand{\cftsecfillnum}[1]{%
    {\cftsecleader}%
    \hspace{1em}\hbox{\cftsecpagefont#1}%
\cftsecafterpnum\par}

% Configure headers and footers
\RequirePackage[headsepline]{scrlayer-scrpage}  % more flexible headers
\pagestyle{scrheadings}
\addtokomafont{pageheadfoot}{\normalfont}
\addtokomafont{headsepline}{\color{structure}}
% truncate running title to header width
\RequirePackage[fit]{truncate}
\chead{\color{structure}\sffamily\scshape\MakeLowercase{\headmark}}
\renewcommand{\chaptermark}[1]{%
    \markright{%
        \truncate{0.95\textwidth}%
        {\thechapter\enspace{#1}}%
}}

% Format theorem etc. labels
\def\th@plain{%
    \thm@headfont{\sffamily\color{structure}}
    \itshape % body font
}
\def\th@definition{%
    \thm@headfont{\sffamily\color{structure}}
    \normalfont % body font
}
\def\th@remark{%
    \thm@headfont{\sffamily\color{structure}}
    \normalfont % body font
}

% Format (sub) figure labels
\RequirePackage[labelfont={color=structure,sf}]{caption}
\RequirePackage[labelfont={color=structure,sf}]{subcaption}

% Url
\renewcommand{\UrlFont}{\normalfont\sffamily}
\def\email#1{\href{mailto:#1}{\sffamily#1}}
\providecommand{\orcid}[1]{\mbox{\scshape\sffamily orcid:}\,\href{https://orcid.org/#1}{\detokenize{#1}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\doi}[1]{doi:\href{https://dx.doi.org/#1}{\detokenize{#1}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bibliography with biblatex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[backend=biber,%
safeinputenc,% encode unicode as latex (needs to be first)
maxcitenames=3,% 
maxbibnames=99,% 
bibstyle=authoryear,%
citestyle=authoryear,%
uniquename=false,% last names only in authoryear cite
giveninits=true,%
dashed=false,% do not print dash for repeated entries
isbn=false,%
useprefix=true,%
]{biblatex}

% make full citation hyperlink, enclose in brackets, make roman
\DeclareCiteCommand{\cite}
{\bibopenbracket\usebibmacro{prenote}}
{\usebibmacro{citeindex}%
    \printtext[bibhyperref]{\usebibmacro{cite}}}
{\multicitedelim}
{\usebibmacro{postnote}\bibclosebracket}

% format bibliography
\DeclareNameAlias{sortname}{given-family}
\renewcommand{\bibinitdelim}{\addnbthinspace}
\renewcommand*{\finalnamedelim}{\addspace\textulc{\&}\space}   
\renewcommand*{\finallistdelim}{\addspace\textulc{\&}\space}  
% make author+year in bibliography sans small caps
\renewbibmacro*{author}{%
    {\scshape\sffamily
    \ifboolexpr{
        test \ifuseauthor
        and
        not test {\ifnameundef{author}}
    }
    {\usebibmacro{bbx:dashcheck}
        {\bibnamedash}
        {\usebibmacro{bbx:savehash}%
            \printnames{author}%
            \iffieldundef{authortype}
            {\setunit{\printdelim{nameyeardelim}}}
        {\setunit{\addcomma\space}}}%
        \iffieldundef{authortype}
        {}
        {\usebibmacro{authorstrg}%
    \setunit{\printdelim{nameyeardelim}}}}%
    {\global\undef\bbx@lasthash
        \usebibmacro{labeltitle}%
    \setunit*{\printdelim{nonameyeardelim}}}%
    \usebibmacro{date+extradate}%
}}
% no "in:"
\renewbibmacro{in:}%
{\ifentrytype{article}{}{\printtext{\bibstring{in}\intitlepunct}}}
\renewcommand*{\newunitpunct}{\addcomma\space}
% format titles etc.
\DeclareFieldFormat*{title}{#1}
\DeclareFieldFormat[book]{title}{\mkbibemph{#1}}
\DeclareFieldFormat{journaltitle}{\mkbibemph{#1}} 
\DeclareFieldFormat{pages}{#1}
\renewbibmacro*{volume+number+eid}{%
  \printfield{volume}\printfield[parens]{number}%
  \setunit{\addcomma\space}%
  \printfield{eid}}
% switch publisher and location
  \renewbibmacro*{publisher+location+date}{%
  \printlist{publisher}%
  \setunit*{\addcomma\space}
  \printlist{location}%
  \setunit*{\addcomma\space}%
  \newunit}
% format dois, arxiv id, urls
% Print acronyms in small caps if possible
\renewcommand*{\mkbibacro}[1]{%
    \ifcsundef{\f@encoding/\f@family/\f@series/sc}
    {#1}
    {\textsc{\sffamily\MakeLowercase{#1}}}
}
\DeclareFieldFormat{eprint:arxiv}{%
    \mkbibacro{arXiv}\addcolon\thinspace\href{https://arxiv.org/\abx@arxivpath/#1}{
    \nolinkurl{#1}}%
}
\DeclareFieldFormat{doi}{%
    \mkbibacro{doi}\addcolon\thinspace\href{https://dx.doi.org/#1}{
    \MakeLowercase{\nolinkurl{#1}}}%
}
