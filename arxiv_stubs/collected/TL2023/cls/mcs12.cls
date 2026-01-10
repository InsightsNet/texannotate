% mcs12.cls
% A class declaring options used in the accompanying LaTeX template (LaTeXtemplate.tex) for an article to be submitted to the Twelfth Mediterranean Combustion Symposium (updated MCS11 template by James Massey, jcm97@cam.ac.uk). To be built using PDFLaTeX.
% 6 May 2022, v1.0

% --- Class structure: identification part
% ---
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mcs12}[2018/03/12 v1.0 MCS12 template class]

% --- Class structure: declaration of options part
% This class extends the article class.
% All options defined in this template, no need to check for user commands.
% ---

% --- Class structure: execution of options part
% ---
% Default options listed below.
\ExecuteOptions{a4paper,12pt,oneside,onecolumn,final,notitlepage,openbib}

% --- Class structure: declaration of options part
% --- 
% Using the article class as the base class with the default options specifed above.
\LoadClassWithOptions{article}

% Define the page layout using the geometry package.
\RequirePackage[left=2.5cm,right=2.5cm,top=2cm,bottom=3cm]{geometry}

% Use ragged2e package for justified text.
\RequirePackage{ragged2e}

% Apply single spacing environment.
\RequirePackage[singlespacing]{setspace}

% Set default font size to 12 pt and baseline skip to 14 pt.
\renewcommand{\normalsize}{\fontsize{12pt}{13.5pt}\selectfont}

% Set default font family to Roman (Serif).
\renewcommand{\familydefault}{\rmdefault}

% Set the text width and height values.
%\setlength{\textwidth}{16cm}
%\setlength{\textheight}{24.7cm}

% Set headers and footers using the fancyhdr package.
% First page has text in header section, but not in footer section. 
% Header formatting requirements:
% 10pt and italicized.
\RequirePackage{fancyhdr}
\setlength{\headheight}{13.5pt}
\fancypagestyle{firstpage}{%
\fancyhf{} % Clear all header and footer sections.
\lhead{\fontsize{10pt}{12pt}\textit{MCS12}} % Left heading.
\rhead{\fontsize{10pt}{12pt}\textit{Luxor, Egypt, January 23--26, 2023}} % Right heading.
\renewcommand{\headrulewidth}{0pt} % No line under the header section.
}
% Remaining pages have no text in either header or footer sections.
\fancypagestyle{followingpage}{%
\fancyhf{} 
\renewcommand{\headrulewidth}{0pt} % No line under the header section.
}
\pagestyle{followingpage} % Default for all pages.
\AtBeginDocument{\thispagestyle{firstpage}} % Override above only for the first page.

% Title formatting requirements:
% Centered, 16pt, bold-faced and upper case letters.
\renewcommand{\title}[1]{
\centering\fontsize{15pt}{17pt}\MakeUppercase{\textbf{#1}}\vspace*{\baselineskip} % 16pt seems to big.
}

% Author's names(s) formatting requirements:
% Centered, 12pt and bold-faced.
\newcommand{\authors}[1]{
\centering\fontsize{12pt}{12pt}\textbf{#1}\par
}

% Corresponding author email formatting requirements:
% Centered and 10pt.
\newcommand{\corrauthoremail}[1]{ %
\centering\fontsize{10pt}{10pt}{#1}\par
}

% Address(es) of authors formatting requirements:
% Centered and 10pt.
\newcommand{\address}[1]{
\centering\fontsize{10pt}{10pt}{#1}\par
}

% Abstract environment formatting requirements:
% Insert 2 blank lines above it to separate from author details
% Abstract heading should be 12 pt, bold-faced and left justified. 
% Text should be 12 pt and justified. 
\renewenvironment{abstract}{ 
\normalsize\vspace*{2\baselineskip}\raggedright\textbf{Abstract}\par\justifying\@afterindentfalse\@afterheading
}

% Section environment formatting requirements:
% Insert line above it to separate from previous section
% Section heading should be 12 pt, bold-faced and left justified. 
% Text should be 12 pt and justified. 
% First paragraph should be aligned with the left margin and the remaining paragraphs should have an indent of 6.6mm.
\renewcommand{\section}{%
\normalsize
\justifying
\setlength{\parindent}{6.6mm}
\@startsection
	{section} % Name referring to heading counter.
	{1} % Hierarchy level = 1 for section in article class.
	{0mm} % Zero indentation of heading from left margin.
	{-\baselineskip} % Add a line before the heading to separate the current section from the previous section. Negation supresses indentation of paragraph following heading.
	{0.01mm} % +ve implements a display heading. Value defines the vertical space after the heading. 
	{\raggedright\bfseries} % Formatting style. 
}
\setcounter{secnumdepth}{-2} % remove numbering on section, subsection and subsubsection headings.

% Subsection environment.
% Formatting similar to the section environment, only no bold faced heading.
\renewcommand{\subsection}{%
\normalsize
\justifying
\setlength{\parindent}{6.6mm}
\@startsection
	{subsection} % Name referring to heading counter.
	{2} % Hierarchy level = 2 for subsection in article class.
	{0mm} % Zero indentation of heading from left margin.
	{-\baselineskip} % Add a line before the heading to separate the current section from the previous section. Negation supresses indentation of paragraph following heading.
	{0.01mm} % +ve implements a display heading. Value defines the vertical space after the heading. 
	{\raggedright\textit} % Formatting style. 
}

% Subsubsection environment.
% Formatting identical to the subsection environment.
\renewcommand{\subsubsection}{%
\normalsize
\justifying
\setlength{\parindent}{6.6mm}
\@startsection
	{subsubsection}
	{3}
	{0mm} 
	{-\baselineskip} 
	{0.01mm} 
	{\raggedright} 
}

% Simple abbreviation environment.
\newcommand{\abbrlabel}[1]{\makebox[1cm][l]{\normalsize{#1}}}

\newenvironment{nomenclature}{
\begin{list}{}{
\setlength\parsep{0pt}
\setlength\itemsep{0pt}
\renewcommand{\makelabel}{\abbrlabel}
}} {
\end{list}
}

\newenvironment{subscripts}{
\begin{list}{}{
\normalsize
\subsection{Subcripts}
\setlength\parsep{0pt}
\setlength\itemsep{0pt}
\renewcommand{\makelabel}{\abbrlabel}
}} { 
\end{list}
}

\newenvironment{superscripts}{
\begin{list}{}{
\normalsize
\subsection{Superscripts}
\setlength\parsep{0pt}
\setlength\itemsep{0pt}
\renewcommand{\makelabel}{\abbrlabel}
}} {
\end{list}
}