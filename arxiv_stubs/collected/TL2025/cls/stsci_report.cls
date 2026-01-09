% STScI Report class file
% Created by Nicholas Earl
% Updated 2014/08/15

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stsci_report}[2014/08/04 STScI Report LaTeX class by Nicholas Earl]
\LoadClass[12pt]{article}

\RequirePackage[margin=1in]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage{titling}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\setlength{\RaggedRightParindent}{\parindent}
\setlength{\droptitle}{-10em}
\RequirePackage[backend=biber,style=authoryear,citestyle=authoryear,maxcitenames=2,maxbibnames=99]{biblatex}

\renewcommand\headrule{}
\g@addto@macro{\maketitle}{
    % \RaggedRight
    \pagestyle{restpage}
    \thispagestyle{firstpage}
}

% Format spacing
\setlength{\droptitle}{0.5in}

% Create a pre-title command
\newcommand{\presubtitle}[1]{
    \def\@presubtitle{#1}
    
    \pretitle{
        \par
        \begin{flushright}
        \large\textbf{#1}
        \vskip0.5em\Huge
    }
}

% Create copyright command
\newcommand{\copyrighttext}[1]{
    \def\@copyrighttext{\footnotesize #1}
}

% Setup page header/footer styles
\fancypagestyle{firstpage}
{
   \fancyhf{}
   \raisebox{-1.5in}[0pt][0pt]{\includegraphics[width=2in]{stlogoplus.pdf}}
   \fancyfoot[L]{\@copyrighttext}
}

\fancypagestyle{restpage}
{
   \fancyhf{}
   \fancyhead[L]{\@presubtitle}
   \fancyfoot[C]{\thepage}
}

% Create abstract command
\renewcommand{\abstract}[1]{%
    \par
    \begin{flushleft}
    \noindent\makebox[\linewidth]{\rule{\textwidth}{1.0pt}}
    \vskip0.25em
    \textsc{Abstract}
    \vskip0.25em
    \begin{justify}
    \textit{#1}
    \end{justify}
    \vskip0.25em
    \noindent\makebox[\linewidth]{\rule{\textwidth}{1.0pt}}
    \vskip0.5em
    \end{flushleft}%
}

% Generate title information
\posttitle{
    \end{flushright} 
    \begin{flushright} 
    \rule{5cm}{0.5pt} 
    \end{flushright}
}
\preauthor{\begin{flushright}} % makes author flush right
\postauthor{\end{flushright}}
\predate{\begin{flushright}} % makes date title flush right
\postdate{\end{flushright}}