%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% © DRL CSAIL MIT 2022 - All RIGHTS RESERVED.
% AUTHORS: RAMIN HASANI and ALEXANDER AMINI

% License: Creative Commons license 
% Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SAGEA}[2022/05/31 SAGEA Template]



%%Preliminary definitions, needed by the options
\newcommand{\headlinecolor}{\normalcolor}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}

% \DeclareOption{onecolumn}{\OptionNotUsed}
% \DeclareOption{green}{\renewcommand{\headlinecolor}{\color{green}}}
% \DeclareOption{lab}{\newcommand\myworries[1]{\textcolor{red}{test}}}
% \DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% \ProcessOptions\relax


\LoadClass[11pt]{article}

\RequirePackage[sort&compress,round,authoryear]{natbib} 
\RequirePackage[colorlinks=true, citecolor=blue, linkcolor=black]{hyperref}


\RequirePackage{amsmath}
\RequirePackage{amsthm}  
\RequirePackage{amssymb}
\RequirePackage{color}
\RequirePackage{mathtools} 
\RequirePackage{multirow}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage[labelsep=colon]{caption}
\RequirePackage{mathpazo}
\RequirePackage{algorithm}
\RequirePackage{booktabs}
\RequirePackage{xcolor}
\RequirePackage{adjustbox}
\RequirePackage{subcaption}
\RequirePackage{tabularx}
\RequirePackage{svg}
\RequirePackage{wrapfig}
\RequirePackage{titlesec}

\titlelabel{\thetitle.\quad}

\captionsetup[figure]{font=small}
\captionsetup[table]{font=small}



%%Body of the class, most of the declarations appear here.
\renewcommand*{\thefootnote}{\fnsymbol{footnote}}

\topmargin -1.0cm
\oddsidemargin -0.2cm
\textwidth 17cm 
\textheight 22cm
\footskip 1cm
\setlength{\headheight}{36.67937pt}


\renewenvironment{abstract}
 {\bfseries
  \list{}{%
    \setlength{\leftmargin}{6mm}% <---------- CHANGE HERE
    \setlength{\rightmargin}{\leftmargin}%
  }%
  \item\relax}
  
  
\makeatletter
\renewcommand{\maketitle}{\bgroup\setlength{\parindent}{0pt}
\begin{flushleft}
  \textbf{\LARGE \@title}\vspace*{2.5em}

  \textbf{\@author}
\end{flushleft}\egroup
}

\pagestyle{fancy}   % Enables the custom headers/footers

\fancypagestyle{firstpagestyle}{
    \fancyhf{}
	\fancyhead[L]{\includegraphics[width=120pt]{images/logo.png}
}}

\fancyhf{}
\if \thepage=1 {\chead{}} \else \chead{\@title} \fi
\rfoot{\thepage}

\makeatother




\renewcommand{\figurename}{\textbf{Fig.}}
\renewcommand{\tablename}{\textbf{Table}}
\renewcommand{\thetable}{\textbf{\arabic{table}}}
\renewcommand{\thefigure}{\textbf{\arabic{figure}}}


\newtheorem{definition}{Definition}
\newtheorem{lemma}{Lemma}
\newtheorem{proposition}{Proposition}
\newtheorem{theorem}{Theorem}
\newtheorem{remark}{Remark}
\newtheorem{corollary}{Corollary}
\newtheorem{example}{Example}

\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newcommand{\act}[1]{\xlongrightarrow{#1}}       
\newcommand{\eps}{\varepsilon}


\newcommand{\calA}{{\mathcal{A}}}
\newcommand{\calR}{{\mathcal{R}}}
\newcommand{\calX}{{\mathcal{X}}}
\newcommand{\calP}{{\mathcal{P}}}
\newcommand{\calQ}{{\mathcal{Q}}}
\newcommand{\calI}{{\mathcal{I}}}
\newcommand{\calG}{{\mathcal{G}}}
\newcommand{\calS}{{\mathcal{S}}}
\newcommand{\calT}{{\mathcal{T}}}
\newcommand{\calH}{{\mathcal{H}}}
\newcommand{\calU}{{\mathcal{U}}}
\newcommand{\calO}{{\mathcal{O}}}
\newcommand{\calD}{\mathcal{D}}
\newcommand{\ods}[1]{\mathds{1}_{\{#1\}}}
\newcommand{\RE}{\mathbb{R}}

\newcommand{\beginsupplement}{%
        \setcounter{table}{0}
        %\renewcommand{\tablename}{S}%
        \renewcommand{\thetable}{S\arabic{table}}%
        \setcounter{algorithm}{0}
        %\renewcommand{\tablename}{S}%
        \renewcommand{\thealgorithm}{S\arabic{algorithm}}%
        \setcounter{equation}{0}
        %\renewcommand{\tablename}{S}%
        \renewcommand{\theequation}{S\arabic{equation}}%
        \setcounter{figure}{0}
        %\renewcommand{\figurename}{\textbf{Extended Data Fig.}}%
        \renewcommand{\thefigure}{S\arabic{figure}}%
        \setcounter{section}{0}  
        \renewcommand{\thesection}{S\arabic{section}}%
     }
