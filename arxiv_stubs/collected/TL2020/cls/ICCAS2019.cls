%Attribute VB_Name = "Module1"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  icase.cls  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This class is provided for the Proceedings of SICE-ICCAS 2016 Conference
% contributor   : Woonchul Ham(wcham@moak.chnbuk.ac.kr)
% Revision : 1.0.1 released on Feb-4-2002
% Revised on March-7-2016 to rename for ICCAS2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\typeout{Document Style `ICCAS 2017 Conference' <Oct-18-2017>}
\typeout{Rev. 1.0.1}

\usepackage{times}
\usepackage{layout}
\usepackage{graphicx}
\usepackage{rawfonts} %
\usepackage{oldlfont} %
\usepackage{tabu}
\usepackage{diagbox}
\usepackage{amsmath}
\renewcommand{\normalsize}{\@normalsize} %

\DeclareOption{fleqn}{\input{fleqn.clo}}        %% add options to flush quations left.

%%\AtBeginDocument{\parindent 4.0mm} %

%% define new needed boolean variables
\newif\if@tmptwocolumn  \@tmptwocolumnfalse

\def\@ptsize{10} %% default = 10pt; jhp
\@namedef{ds@9pt}{\def\@ptsize{9}}
\@namedef{ds@10pt}{\def\@ptsize{10}}
\@namedef{ds@11pt}{\def\@ptsize{11}}
\@namedef{ds@12pt}{\def\@ptsize{12}}
\@namedef{ds@twoside}{\@twosidetrue \@mparswitchtrue}
%% the file twocolumn.sty is not read as it changes \textwidth.
%% Next line sets @tmptwocolumn to true which lets later execute \twocolumn
\@namedef{ds@twocolumn}{\global\@tmptwocolumntrue }
\@options

%% change sizes and margins


%% Latex displaces 1 inch from either sides (from top and from left side)

%%%%% \paperwidth     209.9mm
%%%%% \paperheight    297.0mm     % approx. 296.7mm --> 296mm
\hoffset 0pt %-25.4mm
\voffset 0pt %-25.4mm

\evensidemargin  -5.4mm
\oddsidemargin   -5.4mm

\topmargin       -11mm
\headsep         7mm
\headheight      12pt

%%%% \topmargin       -0.4mm
%%%% \headsep         0pt
%%%% \headheight      0pt


%%\textheight      246mm
\textheight      246mm
\textwidth       170mm
\marginparsep    0pt
\marginparwidth  0pt
\marginparwidth  0pt
\marginparpush   0pt
\footskip        0pt

\columnsep       10.0mm
\parindent        4.0mm
\lineskip           1pt
\normallineskip     1pt

\def\baselinestretch{1.0}

%%%%% \topmargin       -10.0mm % paper edge to heading
%%%%% \oddsidemargin   -10.0mm % left margin
%%%%% \evensidemargin  -10.0mm % left margin
%%%%% %%\textheight     243.5mm %
%%%%% \textheight     265.0mm %
%%%%% \textwidth      180.0mm

%%%%% %%\headsep         10.0mm % heading to text
%%%%% %%\headheight        12pt
%%%%% \headsep         0.0mm % heading to text        %%modified
%%%%% \headheight        0pt                          %%modified

%%%%% \marginparsep      10pt
%%%%% \marginparwidth    20pt
%%%%% \marginparpush     25pt

\partopsep          \z@
\topsep           1.3ex
\parsep             \z@
\itemsep            \z@
%% see further below for lists

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% new title items by jhyun
\def\abstract#1{\gdef\@abstract{#1}}    % jhyun
\def\keywords#1{\gdef\@keywords{#1}}    % jhyun
\def\affils#1{\gdef\@affils{#1}}    % ham

\def\@titlefntext#1{\vskip 1em \parindent 1em #1}
\def\thanks#1{\def\@thanks{\footnotetext[0]{#1}}}

\def\BibTeX{{\rm B\kern-.05em{\sc i\kern-.025em b}\kern-.08em
    T\kern-.1667em\lower.7ex\hbox{E}\kern-.125emX}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FONT DEFINITION: avoids having to read in font files.
%%
%% Check if we have selected 9 points
\def\@tempa{9}\ifx\@ptsize\@tempa
\typeout{-- This is a 9 point document}
\def\@normalsize{\@setsize\normalsize{10.7pt}\ixpt\@ixpt
\abovedisplayskip 1em plus2pt minus5pt\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ plus3pt\belowdisplayshortskip .6em plus3pt minus3pt
\topsep \belowdisplayshortskip%
}
\def\small{\@setsize\small{9.12pt}\viiipt\@viipt}
\def\footnotesize{\@setsize\footnotesize{8.15pt}\viipt\@vipt}
\def\scriptsize{\@setsize\scriptsize{8pt}\vipt\@vpt}
\def\tiny{\@setsize\tiny{5pt}\vpt\@vpt}
\def\large{\@setsize\large{2pt}\xpt\@xpt}  %ham
\def\Large{\@setsize\Large{2pt}\xiipt\@xiipt}
\def\LARGE{\@setsize\LARGE{2pt}\xivpt\@xivpt}
\def\huge{\@setsize\huge{22pt}\xviipt\@xviipt}
\def\Huge{\@setsize\Huge{25pt}\xxpt\@xxpt}

%%\def\small{\@setsize\small{9.12pt}\viiipt\@viipt}
%%\def\footnotesize{\@setsize\footnotesize{8.15pt}\viipt\@vipt}
%%\def\scriptsize{\@setsize\scriptsize{8pt}\vipt\@vpt}
%%\def\tiny{\@setsize\tiny{5pt}\vpt\@vpt}
%%\def\large{\@setsize\large{12pt}\xpt\@xpt}
%%\def\Large{\@setsize\Large{10pt}\xiipt\@xiipt}
%%\def\LARGE{\@setsize\LARGE{18pt}\xivpt\@xivpt}
%%\def\huge{\@setsize\huge{22pt}\xviipt\@xviipt}
%%\def\Huge{\@setsize\Huge{25pt}\xxpt\@xxpt}
\fi
%%

%% Check if we have selected 10 points
\def\@tempa{10}\ifx\@ptsize\@tempa
\typeout{-- This is a 10 point document}
\def\@normalsize{\@setsize\normalsize{11.9pt}\xpt\@xpt
\abovedisplayskip 1em plus2pt minus5pt\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ plus3pt\belowdisplayshortskip .6em plus3pt minus3pt
\topsep \belowdisplayshortskip%
}
\def\small{\@setsize\small{9.2pt}\viiipt\@viiipt}
\def\footnotesize{\@setsize\footnotesize{8.8pt}\viiipt\@viiipt}
\def\scriptsize{\@setsize\scriptsize{8pt}\viipt\@viipt}
\def\tiny{\@setsize\tiny{5pt}\vpt\@vpt}
\def\large{\@setsize\large{11pt}\xiipt\@xiipt}
\def\Large{\@setsize\Large{12pt}\xivpt\@xivpt}
\def\LARGE{\@setsize\LARGE{12pt}\xviipt\@xviipt}
\def\huge{\@setsize\huge{22pt}\xxpt\@xxpt}
\def\Huge{\@setsize\Huge{28pt}\xxvpt\@xxvpt}
\fi
%%
%% Check if we have selected 11 points
\def\@tempa{11}\ifx\@ptsize\@tempa
\typeout{-- This is an 11 point document}
\def\@normalsize{\@setsize\normalsize{13.6pt}\xipt\@xipt
\abovedisplayskip 1em plus2pt minus5pt\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ plus3pt\belowdisplayshortskip .6em plus3pt minus3pt
\topsep \belowdisplayshortskip%
}
\def\small{\@setsize\small{12pt}\xpt\@xpt}
\def\footnotesize{\@setsize\footnotesize{11pt}\ixpt\@ixpt}
\def\scriptsize{\@setsize\scriptsize{9.5pt}\viiipt\@viiipt}
\def\tiny{\@setsize\tiny{7pt}\vipt\@vipt}
\def\large{\@setsize\large{14pt}\xiipt\@xiipt}
\def\Large{\@setsize\Large{18pt}\xivpt\@xivpt}
\def\LARGE{\@setsize\LARGE{22pt}\xviipt\@xviipt}
\def\huge{\@setsize\huge{25pt}\xxpt\@xxpt}
\def\Huge{\@setsize\Huge{30pt}\xxvpt\@xxvpt}
\fi
%%
%% Check if we have selected 12 points
\def\@tempa{12}\ifx\@ptsize\@tempa
\typeout{-- This is a 12 point document}
\def\@normalsize{\@setsize\normalsize{14pt}\xiipt\@xiipt
\abovedisplayskip 1em plus3pt minus6pt\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ plus3pt\belowdisplayshortskip .6em plus4pt minus4pt
\topsep \belowdisplayshortskip
}
\def\small{\@setsize\small{11.4pt}\xpt\@xpt}
\def\footnotesize{\@setsize\footnotesize{10pt}\ixpt\@ixpt}
\def\scriptsize{\@setsize\scriptsize{9pt}\viiipt\@viiipt}
\def\tiny{\@setsize\tiny{8pt}\vipt\@vipt}
\def\large{\@setsize\large{18pt}\xivpt\@xivpt}
\def\Large{\@setsize\Large{22pt}\xviipt\@xviipt}
\def\LARGE{\@setsize\LARGE{25pt}\xxpt\@xxpt}
\def\huge{\@setsize\huge{30pt}\xxvpt\@xxvpt}
\let\Huge=\huge
\fi


%% Definitions for PARAGRAPHS
%%
\abovedisplayskip       0pt plus2pt minus2pt%
\belowdisplayskip       \abovedisplayskip
\abovedisplayshortskip  0pt plus2pt%
\belowdisplayshortskip  0pt plus2pt minus2pt%

%% Definitions for LISTS
%%

%% Change aspect of lists with
%% 1) \itemindent,  label indentation  wrt to left list margin
%% 2) \leftmargini, the indentation of the whole list (on left, first level)
\itemindent        -1em
\leftmargini        2em
%\itemindent         2em  % Alternative values: sometimes used..
%\leftmargini        0em
\leftmarginii       1em
\leftmarginiii    1.5em
\leftmarginiv     1.5em
\leftmarginv      1.0em
\leftmarginvi     1.0em
\labelsep           5pt
\leftmargin\leftmargini
\labelwidth         \z@

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@listI{\leftmargin\leftmargini} \@listI
\def\@listi{\leftmargin\leftmargini  \topsep \z@ plus 1pt minus 1pt}
\def\@listii{\leftmargin\leftmarginii\labelwidth\leftmarginii
    \advance\labelwidth-\labelsep    \topsep \z@}
\def\@listiii{\leftmargin\leftmarginiii\labelwidth\leftmarginiii
    \advance\labelwidth-\labelsep    \topsep \z@}
\def\@listiv{\leftmargin\leftmarginiv\labelwidth\leftmarginiv
    \advance\labelwidth-\labelsep    \topsep \z@}
\def\@listv{\leftmargin\leftmarginv\labelwidth\leftmarginv
    \advance\labelwidth-\labelsep    \topsep \z@}
\def\@listvi{\leftmargin\leftmarginvi\labelwidth\leftmarginvi
    \advance\labelwidth-\labelsep    \topsep \z@}

\def\labelenumi{\theenumi.}     \def\theenumi{\arabic{enumi}}
\def\labelenumii{(\theenumii)}  \def\theenumii{\alph{enumii}}
\def\labelenumiii{\theenumiii.} \def\theenumiii{\roman{enumiii}}
\def\labelenumiv{\theenumiv.}   \def\theenumiv{\Alph{enumiv}}
\def\p@enumii{\theenumi}
\def\p@enumiii{\theenumi(\theenumii)}
\def\p@enumiv{\p@enumiii\theenumiii}

\def\labelitemi{$\scriptstyle\bullet$}
\def\labelitemii{\bf --}
\def\labelitemiii{$\ast$}
\def\labelitemiv{$\cdot$}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% \itemindent is set to \z@ by list, so define new temporary variable
\newdimen\tmpitemindent
\def\verse{\let\\=\@centercr
    \list{}{\itemsep\z@ \itemindent -1.5em \listparindent \itemindent
    \rightmargin\leftmargin\advance\leftmargin 1.5em}\item[]}
\let\endverse\endlist
\def\quotation{\list{}{\listparindent 1.5em \itemindent\listparindent
    \rightmargin\leftmargin \parsep 0pt plus 1pt}\item[]}
\let\endquotation=\endlist
\def\quote{\list{}{\rightmargin\leftmargin}\item[]}
\let\endquote=\endlist
\def\@mklab#1{#1}
\def\description{\tmpitemindent\itemindent\list{}{\itemindent\tmpitemindent
    \labelwidth\z@\def\makelabel##1{\hspace\labelsep\it{##1}}}}
\def\enddescription{\endlist\par}
\def\enumerate{\tmpitemindent\itemindent\ifnum \@enumdepth >3 \@toodeep\else
    \advance\@enumdepth \@ne \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
    \list{\csname label\@enumctr\endcsname}{\itemindent\tmpitemindent
    \usecounter{\@enumctr}\def\makelabel##1{\hspace\labelsep\hfil{##1}}}\fi}
\def\endenumerate{\endlist\par}
\def\itemize{\tmpitemindent\itemindent\ifnum \@itemdepth >3 \@toodeep\else
    \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list{\csname\@itemitem\endcsname}{\itemindent\tmpitemindent
    \def\makelabel##1{\hspace\labelsep\hfil\it{##1}}}\fi}
\def\enditemize{\endlist\par}

\newif\if@restonecol
\def\titlepage{\@restonecolfalse\if@twocolumn\@restonecoltrue\onecolumn
    \else \newpage \fi \thispagestyle{empty}\c@page\z@}
\def\endtitlepage{\if@restonecol\twocolumn \else \newpage \fi}

\arraycolsep     5pt
\tabcolsep       6pt
\arrayrulewidth .4pt
\doublerulesep   2pt
\tabbingsep\labelsep

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FOOTNOTES
%
\skip\footins 10pt plus 4pt minus 2pt
\footnotesep 7pt
\footskip 10mm
\skip\@mpfootins = \skip\footins
\fboxsep = 3pt \fboxrule = .4pt
\long\def\@makefntext#1{$^{\@thefnmark}$#1} %jhp
%\long\def\@makefntext#1{\parindent .8em\indent$^{\@thefnmark}$#1}

\def\footnoterule{ \kern-3\p@ \hrule\@width\columnwidth \kern\p@}

\setcounter{secnumdepth}{4}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]

\def\thesection{\arabic{section}. \hskip -1em}
\def\thesubsection{\arabic{section}.\arabic{subsection} \hskip -1em}
\def\thesubsubsection{\arabic{section}.\arabic{subsection}.\arabic{subsubsection} \hskip -1em}

\def\theequation{\arabic{equation}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIST OF FIGURES AND TABLES
%
\def\@pnumwidth{1.55em}
\def\@tocrmarg {2.55em}
\def\@dotsep{4.5}
\setcounter{tocdepth}{3}

\def\tableofcontents{\section*{Contents}\@starttoc{toc}}
\def\l@section#1#2{\addpenalty{\@secpenalty} \addvspace{1.0em plus 1pt}
    \@tempdima 1.8em \begingroup \parindent \z@ \rightskip \@pnumwidth
    \parfillskip-\@pnumwidth \bf\leavevmode #1\hfil\hbox to\@pnumwidth{\hss #2}
    \par \endgroup}
\def\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\def\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\def\listoffigures{\section*{List of Figures}\@starttoc{lof}}
\def\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\def\listoftables{\section*{List of Tables}\@starttoc{lot}}
\let\l@table\l@figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definitions for floats
%%
%% Normal Floats                      %% Double Column Floats
\floatsep 2pt plus 2pt minus 2pt     \dblfloatsep 2pt plus 2pt minus 2pt

\textfloatsep 20pt plus 2pt minus 2pt \dbltextfloatsep 10pt plus 2pt minus 2pt
%%\textfloatsep 20pt plus 2pt minus 4pt \dbltextfloatsep 2pt plus 2pt minus 2pt

%%\@maxsep 20pt                        \@dblmaxsep 4pt %

\@fptop 0pt plus 1fil                 \@dblfptop 0pt plus 1fil
\@fpsep 1pt plus 2fil                 \@dblfpsep 0pt plus 1fil
\@fpbot 0pt plus 1fil                 \@dblfpbot 0pt plus 1fil

\def\topfraction{1.0}                 \def\dbltopfraction{1.0}
\def\floatpagefraction{0.8}           \def\dblfloatpagefraction{0.8}
\setcounter{topnumber}{2}             \setcounter{dbltopnumber}{4}
%
%%  \intextsep 8pt plus 2pt minus 2pt
\intextsep 6pt plus 2pt minus 2pt
\setcounter{bottomnumber}{2}
\def\bottomfraction{.4}
\setcounter{totalnumber}{4}
\def\textfraction{.2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% redefine CAPTION

\long\def\@caption#1[#2]#3{\par\addcontentsline{\csname ext@#1\endcsname}{#1}{%
   \protect\numberline{\csname the#1\endcsname}{\ignorespaces #2}}
   \begingroup \@parboxrestore \normalsize \rm
     \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}{#1}\par
   \endgroup}

\def\tablestring{table}
\def\figurestring{figure}

%%%% no comma is used for captions.
\newlength{\captionindent}
\long\def\@makecaption#1#2#3{
\ifx\figurestring#3
    \vskip 0pt
%%    \setbox\@tempboxa\hbox{#1.~ #2}
    \setbox\@tempboxa\hbox{#1~ #2}
    \ifdim \wd\@tempboxa >\hsize
%%       \setbox\@tempboxa\hbox{#1.~ }
       \setbox\@tempboxa\hbox{#1~ }
       \setlength\captionindent{\wd\@tempboxa} \divide\captionindent by 2
       \parbox[t]{\hsize}{\hangindent \captionindent \hangafter=1%
       \unhbox\@tempboxa#2}
    \else \hbox to\hsize{\hfil\box\@tempboxa\hfil}
    \fi
\else       %%Table caption
    \ifx\fnum@figure
    %%  \begin{center}{#1.~ #2}\end{center}
      \begin{center}{#1~ #2}\end{center}
    \else
   %%   {#1.~ #2}
      {#1~ #2}
      \vskip 5pt
    \fi
\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{figure}
\def\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{Fig. ~\thefigure}
\def\figure{\@float{figure}}
\let\endfigure\end@float
\@namedef{figure*}{\@dblfloat{figure}}
\@namedef{endfigure*}{\end@dblfloat}

\newcounter{table}
\def\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{Table~\thetable}
\def\table{\@float{table}}
\let\endtable\end@float
\@namedef{table*}{\@dblfloat{table}}
\@namedef{endtable*}{\end@dblfloat}

%%\def\table{\def\@floatboxreset{\normalsize\@setminipage}\@float{table}}
%%\let\endtable\end@float
%%\@namedef{table*}{\def\@floatboxreset{\reset@font\normalsize\@setminipage}\@dblfloat{table}}
%%\@namedef{endtable*}{\end@dblfloat}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ps@headings{
    \def\@oddhead{}
    \def\@evenhead{}
    \def\@oddfoot{\hbox{}\small\footer}
    \def\@evenfoot{\hbox{}\small\footer}
    }
\def\ps@titlepagestyle{
%%    \def\@oddhead{\hbox{}\normalsize\heading}
    \def\@oddhead{
%\hspace{-197mm} %% SICE-ICCAS 2016
                   \hspace{-25.5em}
                   \begin{tabular}{l}
                          \normalsize\headinga\\
                          \normalsize\headingb
                   \end{tabular}
    }
    \def\@evenhead{\hbox{}\normalsize\heading}
%    \def\@oddhead{\hbox{}\large\heading}
%    \def\@evenhead{\hbox{}\large\heading}
%    \def\@oddhead{}
%    \def\@evenhead{}
    \def\@oddfoot{\hbox{}\small\footer}
    \def\@evenfoot{\hbox{}\small\footer}
    }
\def\rightmark{}
\def\leftmark{}
\def\rightfooter{}
\def\leftfooter{}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defines the command for putting the header. footernote{TEXT} is the same
%% as markboth{TEXT}{TEXT}. Here for compatibility with other style files.
%%\def\markboth#1#2{\def\leftmark{\uppercase{#1}}\def\rightmark{\uppercase{#2}}}

\def\markboth#1#2{\def\leftmark{#1}\def\rightmark{#2}}
\def\footernote#1#2{\def\leftfooter{#1}\def\rightfotter{#2}}

%\def\heading{SICE-ICASE International Joint Conference 2006
%             Oct. 18-21, 2006 in Bexco, Busan, Korea}
%\def\headinga{International Conference on Control, Automation and Systems 2008}
%\def\headingb{Oct. 14-17, 2008 in COEX, Seoul, Korea}
%\def\headinga{International Conference on Control, Automation and Systems 2010}
%\def\headingb{Oct. 27-30, 2010 in KINTEX, Gyeonggi-do, Korea}
%\def\headinga{2011 11th International Conference on Control, Automation and Systems}
%\def\headingb{Oct. 26-29, 2011 in KINTEX, Gyeonggi-do, Korea}
%\def\headinga{2013 13th International Conference on Control, Automation and Systems (ICCAS 2013)}
%\def\headingb{Oct. 20-23, 2013 in Kimdaejung Convention Center, Gwangju, Korea}
%\def\headinga{2014 14th International Conference on Control, Automation and Systems (ICCAS 2014)}
%\def\headingb{Oct.~22--25, 2014 in KINTEX, Gyeonggi-do, Korea}
%\def\headinga{2015 15th International Conference on Control, Automation and Systems (ICCAS 2015)}
%\def\headingb{Oct.~13--16, 2015 in BEXCO, Busan, Korea}
%\def\headinga{2017 17th International Conference on Control, Automation and Systems (ICCAS 2017)}
%\def\headingb{Oct.~18--21, 2017, Ramada Plaza, Jeju, Korea}
%\def\headinga{2018 18th International Conference on Control, Automation and Systems (ICCAS 2018)}
%\def\headingb{Oct.~17--20, 2018; YongPyong Resort, PyeongChang, GangWon, Korea}
\def\headinga{2019 19th International Conference on Control, Automation and Systems (ICCAS 2019)}
\def\headingb{Oct.~15$\sim$18, 2019; ICC Jeju, Jeju, Korea}

%\def\heading{ \bf { SICE-ICCAS2006  \hfil {  \bf October 18-21, BEXCO, Busan, Korea} } } %excluded for SI 2006
%%\def\heading{ \bf { ICCAS2005  \hfil {  \bf June 2-5, KINTEX, Gyeonggi-Do, Korea} } } %excluded for SI 2006
%
%%\def\footer{\it October 17-21, 2001, Cheju National Univ. Jeju, Korea \hfil Conference Web Site: http://www.iccas.org}
\def\footer{}

\def\today{\ifcase\month\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December\fi
    \space\number\day, \number\year}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BIBLIOGRAPHY
%
%% separate citations with "], ["
\def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
\def\@citea{}\@cite{\@for\@citeb:=#2\do {\@citea\def\@citea{],
[}\@ifundefined {b@\@citeb}{{\bf ?}\@warning {Citation `\@citeb' on
page \thepage \space undefined}}%
{\csname b@\@citeb\endcsname}}}{#1}}

\def\@cite#1#2{[{#1\if@tempswa, #2\fi}]}

%% Allow short (name-less) citations, when used in conjunction with a
%% bibliography style that creates labels like \citename{, }
\let\@internalcite\cite
\def\cite{\def\citename##1{##1}\@internalcite}
\def\shortcite{\def\citename##1{}\@internalcite}
\def\@biblabel#1{\def\citename##1{##1}[#1]\hfill}

%%\def\thebibliography#1{\section*{References}\normalsize\list
\def\thebibliography#1{\section*{References}\normalsize\list
    {[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
    \advance\leftmargin\labelsep \itemsep 0pt plus .5pt
    \usecounter{enumi}}
    \def\newblock{\hskip .11em plus .33em minus .07em}
    \sloppy\clubpenalty4000\widowpenalty4000
    \sfcode`\.=1000\relax}
\let\endthebibliography=\endlist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% appendix command for one single appendix
\def\appendix{\par
    \setcounter{section}{0}\setcounter{subsection}{0}
    \def\thesection{\Alph{section}} \section*{Appendix}
}
%% appendices command for multiple appendicies
\def\appendices{\par
    \setcounter{section}{0}\setcounter{subsection}{0}
    \def\thesection{\Alph{section}} \section*{Appendices}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\maketitle{\par
  \begingroup
  \def\thefootnote{} % the \thanks{} mark type is empty
  \twocolumn[\@maketitle]
  \thispagestyle{titlepagestyle}\@thanks
  \endgroup
  \setcounter{footnote}{0}\let\maketitle\relax\let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\gdef\@abstract{}
  \gdef\@keywords{}\gdef\@affils{}\let\thanks\relax  %ham
}

%%\def\@maketitle{\newpage \vskip-8mm%%\hrule
%%\def\@maketitle{\newpage \vskip-6mm\hrule
\def\@maketitle{\newpage \vskip-4mm %%\hrule
%%\def\@maketitle{\newpage
%%      \vskip4em{\center\Large\bf\@title\par}\vskip1.0em%
\vskip2.0em
      {\lineskip1.0em\center\Large\bf\@title\par}%\vskip0.5em%
      {\lineskip.5em\center\large\@author\par}
      {\lineskip.5em\center\normalsize\@affils\par} % ham
      %%\noindent{\small\vskip .2em \@thanks\par}
      \noindent{\vskip 1em \normalsize{\bf {Abstract:} }\@abstract\par} % jhp
      \noindent{\vskip 1em \normalsize {\bf {Keywords:} }\@keywords\par} % jhp
    \par\vskip 1.4em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SECTIONS
%%
%%\def\section{\@startsection {section}{1}{\z@}{4.0ex plus 0.5ex
%%     minus .2ex}{0.1ex}{\centering\large\MakeUppercase\rm\bf}} %ham
%%\def\subsection{\@startsection{subsection}{2}{\z@}{0.0ex
%%     }{0ex}{\rm\bf}}
%%  \def\subsubsection{\@startsection{subsubsection}{3}{\z@}{2.0ex plus 5ex
%%     minus .2ex}{0.1ex}{\rm}}
%%\def\paragraph{\@startsection{paragraph}{4}{\z@}{1.0ex plus .5ex
%%     minus .2ex}{0ex}{\rm}}

\def\section{\@startsection {section}{1}{\z@}{2.5ex plus 0.5ex
     minus .2ex}{1.5ex}{\center\large\rm\bf\MakeUppercase}}
\def\subsection{\@startsection{subsection}{2}{\z@}{1.5ex
     }{0.5ex}{\rm\bf}}
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{2.0ex plus .5ex
     minus .2ex}{0.1ex}{\rm}}
\def\paragraph{\@startsection{paragraph}{4}{\z@}{1.0ex plus .5ex
     minus .2ex}{0ex}{\rm}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ENVIRONEMTS
\def\QED{\mbox{\rule[0pt]{1.5ex}{1.5ex}}}
\newtheorem{theorem}{\noindent\hspace{1em}\bf Theorem}
\def\proof{\noindent\hspace{1em}{\bf Proof:} }
\def\endproof{\hspace*{\fill}~\QED\par\endtrivlist\unskip}
\def\@begintheorem#1#2{\tmpitemindent\itemindent\topsep 0pt\rm\trivlist
    \item[\hskip \labelsep{\indent #1\ #2:}]\itemindent\tmpitemindent}
\def\@opargbegintheorem#1#2#3{\tmpitemindent\itemindent\topsep 0pt\rm \trivlist
    \item[\hskip\labelsep{#1\ #2\ \rm(#3)}]\itemindent\tmpitemindent}
\def\@endtheorem{\endtrivlist\unskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sets up default PAGESTYLE
\ps@headings
\pagenumbering{arabic}

\if@twoside\else\raggedbottom\fi
\if@tmptwocolumn \twocolumn \sloppy \flushbottom \fi

\endinput %!
