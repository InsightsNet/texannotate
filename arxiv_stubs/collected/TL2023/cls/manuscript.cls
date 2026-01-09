\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{manuscript}[2023/07/18 Two-column Scientific Manuscript LaTeX class]

% -------  Inherit the standrad article class

%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}

\ProcessOptions\relax

%\LoadClass[twocolumn]{article}
\LoadClass[twocolumn,10pt]{extarticle}
%\RequirePackage[utf8]{inputenc}

% ------- Some essential packages

\RequirePackage{amsmath,amssymb}

% hyperlinks 
\RequirePackage[colorlinks,linkcolor=blue,citecolor=blue]{hyperref}

\RequirePackage{cleveref}% Load AFTER hyperref!

\RequirePackage{mathrsfs}  
\RequirePackage{graphicx}
\RequirePackage{placeins}
\RequirePackage{subfig}
%\RequirePackage[labelfont=bf,font=footnotesize]{caption}
\RequirePackage[labelfont={bf,sf},labelsep=period,figurename=Fig.]{caption}
\RequirePackage{multicol}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{dblfloatfix}
\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{booktabs}

% remove indendation
\RequirePackage[skip=3pt plus0pt, indent=0pt]{parskip}

%No hyphenation of words at the end of line
%DEACTIVATE WHILE WRITING ACTIVATE IN CAMERA-READY VERSION
%\RequirePackage[none]{hyphenat}

%No hyphenation of words at the end of line
\widowpenalty=10000 % To avoid widow & orphan lines
\clubpenalty=10000  % To avoid single line remain at preceding page
\hyphenpenalty=750 % For proper hyphenation


% ------- Simple layout settings -------------------------------

% nicer font
%\RequirePackage{stix2}

% section formatting
\RequirePackage{titlesec,titletoc}
\titleformat*{\section}{\bfseries}
\titleformat*{\subsection}{\small\bfseries}
\def\subsectionautorefname{Section}

\RequirePackage{datetime}
%\newdateformat{stddate}{\monthname[\THEMONTH] \THEDAY \THEYEAR}
\newdateformat{monthyeardate}{\small \monthname[\THEMONTH] \THEDAY, \THEYEAR}

% set margins

\RequirePackage[margin=13mm, top=12mm, bottom=15mm, includehead,headheight=8mm]{geometry}
\setlength{\columnsep}{12pt}

% figure caption style
\RequirePackage[labelfont=bf,font=footnotesize]{caption}

% Equation references as Eq. (1)
\RequirePackage{letltxmacro}
\LetLtxMacro{\originaleqref}{\eqref}
\renewcommand{\eqref}{Eq.~\originaleqref}

% bold-style vectors
\renewcommand{\vec}[1]{\boldsymbol{#1}}


% -------- Title, abstract, header ---------------------------------

% title already defined
% short title for header, default to full title
\newcommand\shorttitle[1]{\renewcommand\@shorttitle{#1}}
\newcommand\@shorttitle{\@title}

% for author/affiliation 
\RequirePackage{authblk}

\newcommand{\affiliation}[2][]{\affil[#1]{{\small #2}}}

\newcommand{\myrule}{\par\noindent\rule{\textwidth}{0.4pt}}

% version variable
\newcommand\version[1]{\renewcommand\@version{#1}}
\newcommand\@version{}

% keywords
\newcommand\keywords[1]{\renewcommand\@keywords{#1}}
\newcommand\@keywords{keyword1, keyword2, keyword3}

% abstract
\renewcommand\abstract[1]{\renewcommand\@abstract{#1}}
\newcommand\@abstract{abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract}

%header upper right
\newcommand\headerupperright[1]{\renewcommand\@headerupperright{#1}}
\newcommand\@headerupperright{Version \@version, \@date}

\RequirePackage{fancyhdr}

% Define layout of title, abstract, header blocks
\renewcommand{\maketitle}{%
    % Title and author horizontal section
    \thispagestyle{empty}
    \twocolumn[
            
        \vspace{-2cm}
        {\noindent\bfseries\large \@title}
        \myrule
        \vspace{2mm}	
        \@author

        \vspace{2mm}
        %\noindent \@date \hfill version: \@version	
        \noindent \monthyeardate\today
        \myrule
        \vspace{6mm}
        \begin{center}
        \begin{minipage}{0.7\textwidth}
            \@abstract
	 		%\textbf{Keywords:} \textit{\@keywords}
            \textcolor{gray}{\footnotesize \@keywords}
             %\fontfamily{cmr}\selectfont{\small \textcolor{gray}{\@keywords}}
        \end{minipage}
        \end{center}
        \vspace{10mm}
    ]
    % \noindent\fbox{%
	% 	\parbox{0.92\columnwidth}{%
	% 		\vspace{1mm}
	% 		\textbf{Abstract:} \@abstract
			  			
	% 		\vspace{2mm}
	% 		\textbf{Keywords:} \textit{\@keywords}
	% 	}%
	% }
    
    %\fancyhead[R]{\@headerupperright}
    \fancyhead[R]{Ramírez et al. (2025)}
    %\fancyhead[L]{Ramírez et al. (2025)}
    \fancyhead[L]{}
    \fancyfoot{}
    \fancyfoot[R]{\thepage}
    \pagestyle{fancy}
}


% ------- Referencing supplementary material
\RequirePackage{xr-hyper}

% To add an 'S' prefix to a reference (Emil's code)
\newcommand{\supp}{Supplementary}
\newcommand{\suppmat}{\supp{} Material}
\newcommand{\suppfig}{\supp{} Figure}
\newcommand{\suppsec}{\supp{} Note}
\newcommand{\sref}[2]{\begin{NoHyper}\ref{supp:#1}\end{NoHyper}}
\newcommand{\suppfigref}[2]{\suppfig{} \sref{#1}{}}
\newcommand{\suppsecref}[2]{\suppsec{} \sref{#1}{}}

\newcommand\suppdoc[1]{\externaldocument[supp:]{#1}}

% To add an 'S' prefix to SI tables and figs (My code)
\newcommand{\beginsupplement}{%
        \setcounter{table}{0}
        \renewcommand{\thetable}{S\arabic{table}}%
        \setcounter{figure}{0}
        \renewcommand{\thefigure}{S\arabic{figure}}%
     }


% ------- Appendix ------------------------------
\RequirePackage{appendix}

\let\orgappendix\appendix

\renewcommand{\appendix}{%
\orgappendix % Switch to appendix mode
	\section*{APPENDIX} % Define new unnumbered section for appendices
	\addcontentsline{toc}{section}{APPENDIX} % Add section to table of contents
	\renewcommand{\thesubsection}{\Alph{subsection}} % Set subsection numbering to alphabets
	%\makeatletter
	\renewcommand{\p@subsection}{Appendix }
	%\makeatother
}


% ------- Acknowledgements --------------------
\newcommand{\acknowledgements}{%
    \section*{Acknowledgements}
    \addcontentsline{toc}{section}{Acknowledgments}
}

% ------- Bibliography -----------------------------

%\RequirePackage{cite}

\RequirePackage[
    backend=bibtex,
    %style=numeric-comp,
    style=phys,
    biblabel=brackets,
    pageranges=false,
    maxnames=6,
    isbn=false
]{biblatex}

% remove ugly "in"
\renewbibmacro{in:}{}

\renewcommand\bibfont{\normalfont\sffamily\fontsize{8}{10}\selectfont} % set font to be sans serif

% make title link to doi & remove quotation marks
% \ExecuteBibliographyOptions{doi=false}
% \newbibmacro{string+doi}[1]{%
%   \iffieldundef{doi}{#1}{\href{http://dx.doi.org/\thefield{doi}}{#1}}}
% \DeclareFieldFormat{title}{\usebibmacro{string+doi}{\mkbibemph{#1}}}
% \DeclareFieldFormat[article]{title}{\usebibmacro{string+doi}{#1}} %{\mkbibquote{#1}}}
\DeclareFieldFormat[article]{title}{#1}


% Make format: 70(2):11--19
% \DeclareFieldFormat{pages}{#1}
% \usepackage{xpatch}
% \xpatchbibmacro{journal+issuetitle}{%
%   \setunit*{\addspace}%
%   \iffieldundef{series}}
%   {%
%   \setunit*{\addcomma\space}%
%   \iffieldundef{series}}{}{}
% \renewcommand\bibpagespunct{\ifentrytype{article}{\addcolon}{\addcomma}\space}
% \renewbibmacro*{volume+number+eid}{%
%   \textbf{\printfield{volume}}
%   \printfield[parens]{number}%
%   \setunit{\addcomma\space}%
%   \printfield{eid}}