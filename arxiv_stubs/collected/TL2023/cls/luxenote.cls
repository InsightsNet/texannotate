%LUXE Note document version 0.1
%Adapted for use in LUXE from:
%
%CERN ATLAS Note document Class version 0.1
% Adopted for use in ATLAS notes by Thorsten Wengler from:
%
% CERN Accelerator and Technology Sector Note document class Version 0.1

%  Previous history of this file:
%  CERN SL Division LHC Project Note style in LaTeX format
%  CERN SL Division SL MD Note style in LaTeX format
%  Version 1.0  (14/2/95)  JMJ
%  Adapted to latex2e from the old slmdnote.sty, just a rather minor
%  modification of 12pt article class.
%
%  Last Modification: 14/2/95
%
%  Version 1.0  (13/9/95)  AFG and BAT :)
%  Adapted to latex2e from the old slmdnote.cls
%
%  Version 1.1  (01/07/97) Scott Berg
%    Fixed \@maketitle to do line spacing right and avoid underfull hbox
%    complaints
%
%  Version 1.2  (31/07/98) Frank Schmidt
%               (06/10/98) Frank Schmidt fiddled a bit
%    Disclaimer added as numberless footnote
% Some fixes John Jowett 2/6/2010
%
% Modified into a first version of ATS Note  John Jowett 1/3/2011
% Some of the things done:
%   remove health warning footnote
%   change LHC magnet logo to CERN logo
%   use more modern options and include more standard packages (eg hyperref, amsmath, isodate)
%   fix up title block a bit
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
\def\fileversion{0.1}
\def\filedate{11/12/2017}
\def\docdate {11/12/2017}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{luxenote}%
[\filedate\space version \fileversion]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\LoadClass[12pt,a4paper]{article}

\RequirePackage{graphics}
\RequirePackage{array}
\usepackage{multirow}
\usepackage[table]{xcolor}
\RequirePackage[UKenglish]{babel} % http://ectan.org/pkg/babel
\RequirePackage{amsmath}
%\RequirePackage{ucs}
%\RequirePackage[utf8x]{inputenc}

\usepackage[utf8]{inputenc}
\usepackage{authblk}
\usepackage{pdflscape}
\usepackage{lscape}
%Tabular packages
\usepackage{array,booktabs,colortbl,multirow,tablefootnote}
\usepackage{makecell}
\usepackage{chngcntr}
\usepackage{relsize}
%Color
\usepackage{colortbl,colordvi,color}
\usepackage{subcaption}
%\usepackage{todonotes}
\usepackage[toc,page]{appendix}
\usepackage[colorinlistoftodos]{todonotes}
\usepackage{placeins}
\usepackage{lineno}

%LUXE note definitions
\usepackage{luxenotedefs}

%LUXE contribution table
%\usepackage{luxecontribute}

% EURO symbol
\usepackage{eurosym}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{wrapfig,mdframed,caption}
\usepackage{comment}
\usepackage{xspace}
\usepackage{amsmath}
\usepackage[bibstyle= nature, citestyle=numeric-comp, sorting=none]{biblatex}


\RequirePackage{hyperref}
\hypersetup{
	%backref,
	pdfpagemode=UseOutlines ,
    linkcolor=black,
    citecolor=blue,
    urlcolor=blue,
    %hyperfigures=true,
    colorlinks=true
}

\RequirePackage[UKenglish,cleanlook]{isodate} %%% gives dates in non-American format
\cleanlookdateon %% this is for the english option of isodate

%% not sure how this interacts with a4paper option to article class
%% may not be quite the right thing to do
%% See also LaTeX book p 182
\setlength{\topmargin}{-1.0cm}
\setlength{\oddsidemargin}{0.1cm}
\setlength{\textwidth}{16.0cm}
\setlength{\textheight}{23.0cm}
%no indentation
\setlength\parindent{0pt}


%it uses the following info
%   \email{..}  (electronic mail adress) printed at top left of title page
%   \title{..}
%   \author{..}
%   \date{..}  optional
%   \documentlabel{..}  printed at top right of title page

% You also need to use \begin{document} and \end{document}


\def\section{\@startsection{section}{1}{\z@}{-3.5ex plus -1ex minus
    -.2ex}{2.3ex plus .2ex}{\bfseries\Large}}

\def\subsection{\@startsection{subsection}{2}{\z@}{-3.25ex plus -1ex minus
   -.2ex}{1.5ex plus .2ex}{\bfseries\large}}

\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{-3.25ex plus
 -1ex minus -.2ex}{1.5ex plus .2ex}{\bfseries\normalsize}}

\def\paragraph{\@startsection
   {paragraph}{4}{\z@}{-2.25ex plus 1ex minus .2ex}{1em}{\normalsize}}
% Sign changes for BEFORE&AFTERSKIP  at 15:09:43 on 30 Nov 1987 by JOWETT
% Makes unnumbered headings without running in to text (subparagraph will
% still do that for you).

\def\subparagraph{\@startsection
     {subparagraph}{4}{\parindent}{3.25ex plus 1ex minus .2ex}
     {-1em}{\normalsize}}

% The value of the counter secnumdepth gives the depth of the
% highest-level sectioning command that is to produce section numbers.
%

\setcounter{secnumdepth}{3}

%-----------------------------------------------------------------------
% Use same font series in contents
\def\l@section#1#2{\addpenalty{\@secpenalty}  % good place for page break
   \addvspace{1.0em plus 1pt}  % space above toc entry
   \@tempdima 1.5em            % width of box holding section number
   \begingroup
     \parindent \z@ \rightskip \@pnumwidth
     \parfillskip -\@pnumwidth
     \bfseries                  % Bold sans serif
%%                         Modified at 17:10:02 on 29 Mar 1989 by JOWETT
     \leavevmode          % TeX command to enter horizontal mode.
     #1\hfil \hbox to\@pnumwidth{\hss #2}\par
   \endgroup}
%-----------------------------------------------------------------------
% Change label style in description environment
\def\descriptionlabel#1{\hspace\labelsep \bfseries #1}
%-----------------------------------------------------------------------
% The abstract Environment (actually generates a Summary)

\def\abstract{\paragraph*{Abstract}\small}
\def\endabstract{\par\noindent\rule{\textwidth}{1.5pt}}
\def\endtitlepage{\setcounter{footnote}{0}}

%-----------------------------------------------------------------------
% fancy double line

\def\fancyline{\par\noindent
               \parbox{\textwidth}{
               \setlength{\baselineskip}{1.2mm}
               \rule{\textwidth}{0.8pt}
               \rule{\textwidth}{1.5pt}\par
              }}
%-----------------------------------------------------------------------

\renewcommand\maketitle{%
                % Here we put the document label, email and file
                % name at top right. Defaults are an
                % empty box for email and "Preliminary draft" with
                % time of day and date for the label.  Tabular
                % environments are used to allow for the possibility
                % of multiple line document labels - lines separated
                % by \\ in the argument of \documentlabel - and
                % multiple line email (which could have other uses).
  {\setlength{\arrayrulewidth}{1pt}
    \setlength{\parindent}{0pt}
    \begin{tabular}[t]{@{}p{0.45\textwidth}}
      {
        \protect{\includegraphics[width=40mm]{fig/LUXElogo.png}}
        }
    \end{tabular}
    \hfill
    \begin{tabular}[b]{r@{}}
      {\normalsize\@date}\\
      {\normalsize LUXE-PROC-2023-003} \\
    \end{tabular}
    \par
    \vskip\baselineskip
    \vskip1ex
    {\bfseries\Large\raggedright\hyphenpenalty=10000\@title\par}
    \vskip\baselineskip
    {\large\raggedright\hyphenpenalty=10000\@author\par}
    \vskip\baselineskip
    \hfill\par
    }
  \fancyline
  \endtitlepage
  }
  
  
  
  \newcommand{\makereviewtable}{
    {\flushleft
    \begin{center}
     \begin{tabular}[bhp]{|p{0.5\textwidth}|p{0.5\textwidth}|}
     \hline
     \multicolumn{2}{|l|}{LUXE  Doc: \@LUXEDocNo}  \\
 %    \multicolumn{1}{|l}{EDMS Id:}  & \multicolumn{2}{l|}{\@EDMSDocId}  \\
     \multicolumn{2}{|l|}{Version: \@draftversion}  \\
     \multicolumn{2}{|l|}{Last modified: \@documentlabel}  \\
     \hline
     \textbf{Note Authors:} &  \textbf{Editorial Board:}\\ 
     &  \\
        \begin{minipage}{0.5\textwidth}
            \@DocAuthors
        \end{minipage}
     & 
        \begin{minipage}{0.5\textwidth} 
            \@DocEdBoard
        \end{minipage}   
     \\
     &  \\
     &  \\
    \hline
    \end{tabular}
    \end{center}
    }
  }
%------------------------------------------------------------------------
% compute the time in hours and minutes; make new variables \timehh and \timemm
%%                            Added at 11:19:59 on 26 Sep 1988 by JOWETT
%
\newcount\timehh\newcount\timemm
\timehh=\time
\divide\timehh by 60 \timemm=\time
\count255=\timehh\multiply\count255 by -60 \advance\timemm by \count255
%
\def\timeofday{\ifnum\timehh<10 0\fi\number\timehh:%
               \ifnum\timemm<10 0\fi\number\timemm
               }

\def\documentlabel#1{\gdef\@documentlabel{\large\bfseries #1}}
                                          % see \@maketitle
\gdef\@documentlabel{\tt\timeofday\ on \today}

\def\email#1{\gdef\@email{#1}}          % see \@maketitle
\gdef\@email{\hbox{}}

\def\keywords#1{\gdef\@keywords{#1}}          % see \@maketitle

\gdef\@keywords{{\tt ATLAS, TDAQ}}

\def\@EDMSDocNo{}
\newcommand{\EDMSDocNo}[1]%
{
  \def\@EDMSDocNo{#1}
}
\def\@LUXEDocNo{}
\newcommand{\LUXEDocNo}[1]%
{
  \def\@LUXEDocNo{#1}
}
\def\@EDMSDocId{}
\newcommand{\EDMSDocId}[1]%
{
  \def\@EDMSDocId{#1}
}
\def\@DocAuthors{}
\newcommand{\DocAuthors}[1]%
{
  \def\@DocAuthors{#1}
}
\def\@DocCheckedBy{}
\newcommand{\DocCheckedBy}[1]%
{
  \def\@DocCheckedBy{#1}
}
\def\@DocApprovedBy{}
\newcommand{\DocApprovedBy}[1]%
{
  \def\@DocApprovedBy{#1}
}
\def\@DocEdBoard{}
\newcommand{\DocEdBoard}[1]%
{
  \def\@DocEdBoard{#1}
}
% Draft version 
\def\@draftversion{}
\newcommand{\draftversion}[1]%
{
  \def\@draftversion{#1}
}

% The \documentlabel, \email and \keywords
% commands do not exist in ordinary LaTeX.

\endinput