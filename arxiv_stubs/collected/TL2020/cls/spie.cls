%% spie.cls - Version 3.40
%% LaTeX2e class file to format manuscript for SPIE Proceedings
%% See end of file for history of changes
%
%  The following commands will not be understood in other classes:
%  \authorinfo{}, \keywords{} 
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{spie}[2015/08/14  v3.4 SPIE Proceedings class]
\LoadClassWithOptions{article}  % build on standard article class

\DeclareOption{a4paper}{%
   \AtEndOfClass{%
%       \oddsidemargin -0.61cm    % for side margins of 1.93 cm
%       \evensidemargin -0.61cm   % for side margins of 1.93 cm
       \typeout{a4paper used}
       }
   }

\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}   
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}

\ProcessOptions\relax      % set margins for a4paper if specified

%% type out specified font size
\if0\@ptsize\typeout{ten-point font}\fi
\if1\@ptsize\typeout{eleven-point font}\fi
\if2\@ptsize\typeout{twelve-point font}\fi

\RequirePackage{authblk}
\RequirePackage{ifthen}
\RequirePackage[superscript]{cite}[2003/11/04] % need vers. > 4.01 

%% page format (see "Sample manuscript showing specifications and style")
%% following based on default top and left offset of 1 inch = 25.4mm
\topmargin 0.0in                % for top margin of 1.00in
%% the next two side margins are for US letter paper 
%% and are overridden by the a4paper option
\oddsidemargin -0.125in           % for side margin of 0.875 in
\evensidemargin -0.125in          % for side margin of 0.875 in
%
\textheight 8.74in                % approx 22.2 cm
\textwidth 6.75in                 % approx 17.1 cm
\headheight 0in \headsep 0in      % avoid extra space for header
\pagestyle{empty}                 % no page numbers is default
\setlength{\parskip}{1ex plus 1ex minus 0.3ex} % spacing between paragraphs
\date{}                           % avoid date

%%  space for floats - figures and tables
\setlength{\abovecaptionskip}{0ex}
\setlength{\floatsep}{0.9ex plus 0.3ex minus 0.6ex} 
\setlength{\textfloatsep}{4ex plus 3ex minus 1.5ex}
\renewcommand{\textfraction}{0.10} 
\renewcommand{\floatpagefraction}{0.60} 
\renewcommand{\topfraction}{0.90} 
\renewcommand{\bottomfraction}{0.90}
\setcounter{totalnumber}{3} 
\setcounter{topnumber}{2} 
\setcounter{bottomnumber}{2} 

%%%%%%%%%%%%%%%%%%%%
%%%%  define \ample font size %%%%
%% 10% larger than \normalsize for 10 pt, 
%% but smaller than \large
\def\ample{\large}   % insurance

\def\setamplefont{
\if0\@ptsize    % 10pt text; use 11pt bold fonts
  \def\ample{\@setsize\large{12pt}\xipt\@xipt}
\fi

\if1\@ptsize    % 10pt text; use 11pt bold fonts
  \def\ample{\@setsize\large{12pt}\xiipt\@xiipt}
\fi

\if2\@ptsize    % 12pt text; use 13.2pt bold fonts
  \renewcommand{\ample}{\fontsize{13.2pt}{15.8pt}\selectfont\bfseries} 
  \ifcmr \font\ample = cmbx17 at 13.2truept  \fi
\fi  }


%%%% define title aspects %%%%
\def\titlefont{\normalfont\LARGE\bfseries}  %% insurance
\def\title#1{\gdef\@title{\titlefont #1}} 

\def\settitlefont{
%%% identify font used; cmr = Computer Modern Roman, ptm = Times Roman
\typeout{\rmdefault -font_in_spiecls}
\def\cmr{cmr}  % variables for font tests
\newif\ifcmr
\def\ptm{ptm}
\newif\ifptm
\ifthenelse{\equal{\rmdefault}{\cmr}}{\cmrtrue}{\cmrfalse}
\ifthenelse{\equal{\rmdefault}{\ptm}}{\ptmtrue}{\ptmfalse}
%%% scale title according to default font and size
\if0\@ptsize    % 10pt text; use 16pt bold fonts
  \renewcommand{\titlefont}{\fontsize{16pt}{19.2pt}\selectfont\bfseries}
  \ifcmr  \font\titlefont = cmbx12 at 16truept  \fi
\fi
% for 11pt text, title font should be 17pt = \LARGE for 11pt. No change needed
\if2\@ptsize    % 12pt text; use 19.2pt bold fonts
  \renewcommand{\titlefont}{\fontsize{19.2pt}{23pt}\selectfont\bfseries}
  \ifcmr  \font\titlefont = cmbx12 at 19.2truept  \fi
\fi  }

\def\authorinfo#1{\gdef\@authorinfo{#1}}
\authorinfo{}     %% default is empty
%\let\@affiliation\@empty
%\def\affiliation#1{\gdef\@affiliation{#1}}

% Set special footnote indentation for authorinfo
\renewcommand\@makefntext[1]{\leftskip=1.4em\hskip-0em\@makefnmark#1}


\def\maketitle{\par 
\settitlefont
\setamplefont
 \begingroup
   \def\thefootnote{\fnsymbol{footnote}}%
   \def\@makefnmark{\hbox
       to\z@{$\m@th^{\@thefnmark}$\hss}}%
   \if@twocolumn
     \twocolumn[\@maketitle]%
     \else \newpage
     \global\@topnum\z@
     \@maketitle \fi     
     \@thanks
 \endgroup
 \let\maketitle\relax
 \let\@maketitle\relax
 \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax

%%%%  define footnote attributes %%%%
\renewcommand{\footnotesize}{\small}  % enlarge footnote font to small
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
\ifx\@authorinfo\empty \else\footnotetext[0]{\@authorinfo}\fi      
%% NB use zero to avoid footnote mark
%% use footnote symbols, not numbers
\renewcommand{\thefootnote}{\fnsymbol{footnote}}  

% Set footnote indentation back to standard
\renewcommand\@makefntext{\leftskip=0em\hskip1.4em\@makefnmark}
}




% redefine \and for author list because \tabular was removed
\def\and{\bigskip\\}    
 
\def\@maketitle{\newpage
 \null
% move title to top of page 
\if0\@ptsize\vspace{-10mm}\else\vspace{-12mm}\fi
 \begin{center}%
  \ifcmr 
    \if0\@ptsize {\typeout{10pt}\setlength{\baselineskip}{19.2pt} \@title \par}  \fi
    \if1\@ptsize {\typeout{11pt}\setlength{\baselineskip}{20.4pt} \@title \par} \fi
    \if2\@ptsize {\typeout{12pt}\setlength{\baselineskip}{23pt} \@title \par} \fi
  \else 
    {\@title \par} 
  \fi 
%  {\setlength{\baselineskip}{4.3ex} \@title \par}
  \vskip 3.5mm 
  {\large        % author and organization font size 
   \@author \par}   % remove tabular used in article.cls
  \vskip 1.5ex	
  {\large \@date}%
 \end{center}%
 \par
}


%%%% section aspects %%%%
% all headings bold
% center section headings, ample size
\def\sectfont{\centering\ample\bf}
% sub- and subsubsection headings flush left
\def\subsectfont{\raggedright\ample\bf}
\def\subsubsectfont{\raggedright\normalsize\bf}
\def\append{0}

\def\section{\@startsection{section}{1}{\z@}
   {-2.5ex plus -1ex minus -0.5ex}{0.2ex plus 0.5ex minus 0ex}{\sectfont}} 
\def\subsection{\@startsection{subsection}{2}{\z@}
   {-1.5ex plus -1ex minus -0.5ex}{0.1ex plus 0.1ex minus 0.1ex}{\subsectfont}}
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}
   {-1ex plus -1ex minus -0.5ex}{0.1ex plus 0.1ex}{\subsubsectfont}}

%% from latex.sty 
%% \@sect{NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}
%% {STYLE}[ARG1]{ARG2}
\def\@sect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \let\@svsec\@empty
     \let\@svsecp\@empty
     \let\@svsub\@empty
     \else
     \refstepcounter{#1}
     \edef\@svsec{\csname the#1\endcsname\hskip 0.5em plus 0.3em}
     \edef\@svsecp{\csname the#1\endcsname.\hskip 0.3em plus 0.3em}
     \edef\@svsub{\csname the#1\endcsname\hskip 0.5em plus 0.3em}\fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
       \begingroup #6\relax
          \ifnum #2=1
%%(kmh) in appendix, add word appendix in front of section number  
             \ifnum \append=1 {\interlinepenalty \@M 
	        APPENDIX \@svsecp\uppercase{#8}\par}
	     \else {\interlinepenalty \@M \@svsecp\uppercase{#8}\par}
	     \fi
	  \else\ifnum #2=2
             \noindent{\interlinepenalty \@M \@svsub #8\par}
	  \else
             \noindent{\interlinepenalty \@M \@svsub #8\par}
	       \fi
	  \fi
       \endgroup
       \csname #1mark\endcsname{#7}\addcontentsline
         {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi
                    #7}\else
        \def\@svsechd{#6\hskip #3\relax  %% \relax added 2 May 90
                   \@svsec #8\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}

%%%%% Special sections %%%%%
\def\abstract{\section*{ABSTRACT}}
\def\endabstract{}

% Keywords
\def\keywords#1{
\par\vspace{0.5ex}{\noindent\normalsize\bf Keywords:} #1
\vspace{0.5ex}   %% provide extra space before first section
}

\def\acknowledgments{\section*{ACKNOWLEDGMENTS}}
\def\endacknowledgments{}
% include old spelling - which is acceptable, but not preferred
\def\acknowledgements{\section*{ACKNOWLEDGMENTS}}
\def\endacknowledgements{}

%%%% references %%%%
% Give the references section a section number
\def\thebibliography#1{\section*{REFERENCES\@mkboth
 {REFERENCES}{REFERENCES}}\list
 {[{\hskip .02em}\arabic{enumi}{\hskip .05em}]}
 {\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
 \advance\leftmargin\labelsep \usecounter{enumi}}
 \def\newblock{\hskip .11em plus .33em minus .07em}
 %% reduce vspace between items
  \parskip -0.7ex plus 0.5ex minus 0ex   
\if0\@ptsize\else\small\fi      %% smaller fonts
 \sloppy\clubpenalty4000\widowpenalty4000
 \sfcode`\.=1000\relax}
\let\endthebibliography=\endlist

%%%% Add theorem, lemma, and definition environments %%%%
% kmh - noindent
\def\@begintheorem#1#2{
   \par\noindent\bgroup{\sc #1\ #2. }\it\ignorespaces}
\def\@opargbegintheorem#1#2#3{
   \par\bgroup{\sc #1\ #2\ (#3). }\it\ignorespaces}
\def\@endtheorem{\egroup}
\def\proof{\par{\it Proof}. \ignorespaces}
\def\endproof{{\ \vbox{\hrule\hbox{%
   \vrule height1.3ex\hskip0.8ex\vrule}\hrule
  }}\par}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{definition}[theorem]{Definition}

%%%% Figure and table captions %%%
\long\def\@makecaption#1#2{%     % from article.cls
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{\footnotesize #1.\ }{\footnotesize #2}}%
  \ifdim \wd\@tempboxa >\hsize   % with period
    {\footnotesize #1.\ }{\footnotesize #2 \par}
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

%%%% appendix aspects %%%% 
% use \appendix to start an appendix
% use \section{} for each appendix section
\def\appendix{\def\append{1}
  \par
  \setcounter{section}{0}
  \setcounter{subsection}{0}
  \setcounter{subsubsection}{0}
  \def\thesection{\Alph{section}}  
  \def\thesubsection{\Alph{section}.\arabic{subsection}}
\def\thesubsubsection{
\Alph{section}.\arabic{subsection}.\arabic{subsubsection}}
}

%% end of spie.cls
%%
% History
% Prepared by Rick Zaccone <zaccone@bucknell.edu> on 6/3/91.
% Modified by Adrian F Clark <alien@uk.ac.essex> 11-Jan-1992.
% Modified by Ken Hanson <kmh@lanl.gov>  April, 1995
% Modified by Ken Hanson <kmh@lanl.gov>  June 23, 1997
% Modified by Ken Hanson <kmh@lanl.gov>  Nov. 3, 1997
% Modified by Ken Hanson <kmh@lanl.gov>  Dec. 10, 1997
% Modified by Ken Hanson <kmh@lanl.gov>  Mar. 8, 1998
% Modified by Ken Hanson <kmh@lanl.gov>  July 18, 2001
% Modified by Guenter Milde <G.Milde@physik.tu-dresden.de>  
%   August 1, 2001
%  Convert to LaTex2e class and added option a4paper
% Modified by Ken Hanson <kmh@lanl.gov>  August 29, 2001
%  Update SPIE format, including new text field: 6.75 in by 8.75 in
%  citesort.sty embedded to facilitate concatenation of citations.
%  However, citesort may lead to problems when used with babel, 
%   in which case it should be removed from this file.
% 2.70 Modified by Ken Hanson <kmh@lanl.gov>  August 29, 2002
%  Remove tabular in maketitle to properly handle long author list.
%  Use of \and in \author{} will start new line after inserting a
%    blank line.
%  Remove a4 option, leaving standard a4paper option in place.
%  Remove \hoffset and \voffset commands.  Defaults are again zero.
% 2.71 Modified by Ken Hanson <kmh@lanl.gov>  Sept. 18, 2002
%  Correct short figure caption format, replacing : with .  Thanks Mats.
% 2.8 Modified by Ken Hanson <kmh2@lanl.gov>  July 16, 2003
%  Margins changed to match SPIE's new specs.
% 2.9 Modified by Ken Hanson <kmh@lanl.gov>  January 23, 2006
%  Fixed bug; CMR fonts used for title with times package. Moved text 
%  slightly for A4 paper at suggestion of Markus Knauer.
% 3.00 Modified by Ken Hanson <kmh@lanl.gov>  March 5, 2006
%  Proper sized font for title and section headings for times package 
%  and other fonts. Use latest cite.sty for citations instead of 
%  imbedded code. Beware of incompatabilities with Babel and hyperref.
% 3.10 Modified by Ken Hanson <kmh@lanl.gov>  March 16, 2006
%  For title fonts, scale CMR fonts from 12pt, instead of 17pt
% 3.20 Modified by Ken Hanson <kmh@lanl.gov>  April 17, 2007
%  Small format revisions to match SPIE specifications
% 3.30 Modified by Ken Hanson <kmh@lanl.gov> January 19, 2008
%  Place reference numbers in square brackets to match new SPIE specs 
% 3.40 MOdified by John Hammersley August 14 2015
%  Remove superseded/outdated instructions and tidy up with new packages
%  
%%