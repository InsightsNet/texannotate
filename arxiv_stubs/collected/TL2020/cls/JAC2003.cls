%%
%% This file has been developed as a common template for papers
%% destined for electronic production using Adobe Acrobat
%% software for Accelerator Conferences
%%
%% See the JACo Website for more information
%% 
%%       http://www.cern.ch/accelconf/
%%

%  Special thanks to John Jowett and Michel Goossens from CERN and
%  Martin Comyn at TRIUMF for their significant contributions to 
%  this class file over the period 1996 to 2000.
%                                                 John Poole
%                                                 March 2000

%  JAC2001.cls is a modified version of JAC2000.cls to produce indented
%  first paragraphs after section, subsection and subsubsection headings.
%
%                                                 Martin Comyn  April 2001

%  This is a modified version of JAC2003.cls to adjust space around
%  section and subsection headers to be more consistent with JACOW Word
%  templates.
%
%                                                 Todd Satogata  March 2011

\def\fileversion{1.3}
\def\filedate{2011/03/06}
\def\docdate {2011/03/06}

\newlength{\dsep}
\newlength{\dwid}
\newlength{\dht}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{JAC2003}[\filedate\space Version \fileversion]
\DeclareOption{acus}
   {\setlength{\dwid}{6mm}%
    \setlength{\dht}{-18mm}
    \setlength{\paperheight}{11in}
    \setlength{\paperwidth}{8.5in}
    \typeout{Setup for US LETTER PAPER}}
\DeclareOption{aca4}
   {\setlength{\dwid}{0mm}%
    \setlength{\dht}{0mm}}
\DeclareOption{boxit}
%%
%%  This option draws a box on the output text with the correct margins
%%
   {\special{!userdict begin /bop-hook{
         gsave
         newpath
         58 55 moveto
         58 737 lineto
         539 737 lineto
         539 55 lineto
         closepath
         stroke
         grestore
         }def end}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ExecuteOptions{aca4}
\ProcessOptions

\LoadClass[10pt]{article}
%%
%%  Using Times fonts produces a Uniform, compact document
%%  suitable for the Acrobat Software and printable anywhere.
%%
%%  In a 'modern' TeX installation 
%%  e.g TeXLive Version 3 or later (more information on the JACo Website)
%%  one can use the following command
%%

\renewcommand{\rmdefault}{ptm}

%%
%%  Older installations may require
%%              \RequirePackage{times}
%%
\typeout{------------------------------------------------------------------------}
\typeout{LaTeX2e Class file for Accelerator Conference publication for LaTeX2e users}
\typeout{ }
\typeout{Use the boxit option to draw a box on page showing the correct margins}
\typeout{ }
\typeout{Itemize, Enumerate and Description environments are compact versions}
\typeout{------------------------------------------------------------------------}
\typeout{ }
 
%
% DIMENSION OF TEXT:
 
\setlength{\textheight}{241mm}
\setlength{\textwidth}{170mm}
\setlength{\topmargin}{23mm}
\addtolength{\topmargin}{\dht}
\setlength{\oddsidemargin}{20mm}
\setlength{\evensidemargin}{20mm}
\setlength{\columnsep}{5mm}

 
\hoffset -25.4mm
\voffset -25.4mm
 
\columnseprule 0pt      %    Width of rule between columns.
 
% Use Michel Goossens' dense lists
% Prevent infinite loops

\let\Otemize =\itemize
\let\Onumerate =\enumerate
\let\Oescription =\description
% Zero the vertical spacing parameters
\def\Nospacing{\itemsep=0pt\topsep=0pt\partopsep=0pt\parskip=0pt\parsep=0pt}
% Redefine the environments in terms of the original values
\newenvironment{Itemize}{\Otemize\Nospacing}{\endlist}
\newenvironment{Enumerate}{\Onumerate\Nospacing}{\endlist}
\newenvironment{Description}{\Oescription\Nospacing}{\endlist}

\renewcommand{\topfraction}{.95}
\renewcommand{\bottomfraction}{.95}
\renewcommand{\textfraction}{0.1}
\renewcommand{\floatpagefraction}{0.8}
 
\def\@oddhead{}\def\@evenhead{}
\def\@oddfoot{}
\def\@evenfoot{\@oddfoot}
 
%-----------------------------------------------------------------------
% We acknowledge the borrowing of the clever part of
% Steven Gildea's definition of \section
% from geophysi.sty.
%
% \section is tricky because we want to both support \section* and have
% the section title uppercased.
 
\def\section{\secdef\@sectionb\@sections}
\def\@sectionb[#1]#2{\@sections{#2}}
\def\@sections#1{\@startsection {section}{1}{\z@}
                {2.0ex plus 0.8ex minus .1ex}{1.0ex plus .2ex}
                {\large\bf\boldmath\centering}{\uppercase{#1}}}
% Should there be any problem with this, we can revert to the following
% but then the onus is on the user to type the argument of \section in
% uppercase in the input file.
%
%\def\section{\@startsection {section}{1}{\z@}{2.8ex plus 0.8ex minus.1ex}
%                          {1.5ex plus .2ex}{\large\bf\boldmath\centering}}
 
\def\subsection{\@startsection{subsection}{2}{\z@}{1.4ex plus .8ex minus
   .17ex}{0.8ex plus .17ex}{\large\it}}
\def\subsubsection{\@startsection{subsubsection}{3}{\parindent}
 {2.5ex plus .7ex minus .17ex}{-1em}{\normalsize\bf}}
\def\paragraph{\@startsection
     {paragraph}{4}{\z@}{2.5ex plus .7ex minus .17ex}{-1em}{\normalsize\it}}
\def\subparagraph{\@startsection
     {subparagraph}{4}{\parindent}{2.25ex plus .7ex minus
     .17ex}{-1em}{\normalsize\bf}}
 
\setcounter{secnumdepth}{0}
 
% This definition of \maketitle taken from article.sty, and has been
% somewhat modified.
 
\def\maketitle{\par
 \begingroup
   \def\thefootnote{\fnsymbol{footnote}}
   \def\@makefnmark{\hbox
       to 5pt{$^{\@thefnmark}$\hss}}
   \twocolumn[\@maketitle]
   \@thanks
 \endgroup
 \setcounter{footnote}{0}
 \let\maketitle\relax
 \let\@maketitle\relax
 \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax}
 
\newlength{\titleblockheight}       % so user can change it if need be
\setlength{\titleblockheight}{3.5cm}
 
 
\def\@maketitle{\vbox to \titleblockheight {\hsize\textwidth
  \linewidth\hsize \vskip 3pt \centering
  {\Large\bf \@title \par}
  \vskip 2em                % Vertical space after title.
  {\large\begin{tabular}[t]{@{}c@{}}\@author \end{tabular}\par}
  \vfil}}
 
 
% The \copyrightspace command is used to produce a blank space in the first
% column where a copyright notice may go.  It works by producing a
% blank footnote of the appropriate size.  Note that it should appear
% after any \footnote commands that produce footnotes for the first
% column.   Adjusted to leave just 1cm.
 
\def\copyrightspace{\footnotetext[0]{\mbox{}\vrule height 1cm width 0pt}}
 
\def\abstract{\subsection*{Abstract}}
\def\endabstract{\par}
 
% Redefine to use smaller fonts
\def\thebibliography#1{\setlength{\itemsep}{0pt}\setlength{\parsep}{0pt}
  \section*{REFERENCES\@mkboth
  {REFERENCES}{REFERENCES}}\small\list
  {[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \usecounter{enumi}}
    \def\newblock{\hskip .11em plus .33em minus .07em}
    \sloppy\clubpenalty4000\widowpenalty4000
    \sfcode`\.=1000\relax}
 
\let\endthebibliography=\endlist
 
\twocolumn
\sloppy
\parindent 1em
\leftmargini 2em
\leftmargin\leftmargini
\leftmarginv .5em
\leftmarginvi .5em
\flushbottom
%-----------------------------------------------------------------------
