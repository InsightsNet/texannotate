\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SciPostAnonymous} % SciPost Latex Template v1a (2016/06/14)


\LoadClass[11pt]{article}


% Layout
\RequirePackage[top=12mm,bottom=12mm,left=30mm,right=30mm,head=12mm,includeheadfoot]{geometry}
\bigskipamount 6mm

% For table of contents: remove trailing dots
\RequirePackage{tocloft}
\renewcommand{\cftdot}{}
% Add References to TOC
\RequirePackage[nottoc,notlot,notlof]{tocbibind}


% Spacings between (sub)sections:
\RequirePackage{titlesec}
\titlespacing*{\section}{0pt}{1.8\baselineskip}{\baselineskip}


% Unicode characters
\RequirePackage[utf8]{inputenc}

% doi links in references
\RequirePackage{doi}

% Math formulas and symbols
\RequirePackage{amsmath,amssymb}

% Hyperrefs
\RequirePackage{hyperref}

% Include line numbers in submissions
\RequirePackage{lineno}

% SciPost BiBTeX style
\bibliographystyle{SciPost_bibstyle}

% SciPost header and footer
\RequirePackage{fancyhdr}
\pagestyle{fancy}

\makeatletter
  \let\ps@plain\ps@fancy
\makeatother

%\RequirePackage{xcolor}
%\definecolor{scipostdeepblue}{HTML}{002B49}

\lhead{}

%\lhead{
%  \colorbox{scipostdeepblue}{\strut \bf \color{white} ~SciPost Physics }
%}

%\DeclareOption{LectureNotes}{
%  \lhead{
%    \colorbox{scipostdeepblue}{\strut \bf \color{white} ~SciPost Physics Lecture Notes }
%  }
%}
\ProcessOptions\relax

%\rhead{
%  \colorbox{scipostdeepblue}{\strut \bf \color{white} ~Submission }
%}


