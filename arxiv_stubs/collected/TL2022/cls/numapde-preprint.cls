\PassOptionsToPackage{fit}{truncate}
\ProvidesClass{numapde-preprint}[2019/09/05]
% Part of this work has been inspired by the jnsao.cls file
% from http://jnsao.episciences.org

% Declare the options for the class
% Option lineno will turn on line numbering
\DeclareOption{lineno}{\AtBeginDocument{\linenumbers}}

% Pass all non-implemented options to the base class scrartcl
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}

% Process all options
\ProcessOptions\relax

% Load the base class scrartcl with default documentclass option english
% https://tex.stackexchange.com/questions/147243/a-class-with-default-language-settings
\RequirePackage{etoolbox}
\preto\@classoptionslist{english,}
\LoadClass[a4paper,DIV=12,parskip=full]{scrartcl}

% Resolve the dependencies of this class
\RequirePackage{numapde-cls-commons}
\RequirePackage{lineno}

% Configure the document class specific settings
% Set document type
\def\numapde@documenttype{\GetTranslation{Manuscript}}

% Remove \@date and spacing following it from \@maketitle
% https://tex.stackexchange.com/questions/288800/omit-the-date-in-maketitle-without-blanking-the-date
\patchcmd{\@maketitle}{{\usekomafont{date}{\@date \par}}\vskip \z@ \@plus 1em}{}{}{}

% Set up the page header and footer
\if@twoside
	\rohead[]{\truncate{1.0\textwidth}{\ifx\numapde@shorttitle\empty{}\else{\numapde@shorttitle}\fi}}
	\lehead[]{\truncate{1.0\textwidth}{\numapde@shortauthor}}
	\refoot[]{\ISOToday}
	\cofoot[]{\numapde@license}
	\ofoot[{\GetTranslation{page}~\thepage~\GetTranslation{of}~\pageref*{LastPage}}]{\GetTranslation{page}~\thepage~\GetTranslation{of}~\pageref*{LastPage}}
\else
	\ohead[]{\truncate{0.45\textwidth}{\ifx\numapde@shorttitle\empty{}\else{\numapde@shorttitle}\fi}}
	\ihead[]{\truncate{0.45\textwidth}{\numapde@shortauthor}}
	\ofoot*{\GetTranslation{page}~\thepage~\GetTranslation{of}~\pageref*{LastPage}}
	\cfoot[]{\numapde@license}
	\ifoot*{\ISOToday}
\fi

% Define keywords environment (following etna.cls)
\newenvironment{@abs}[1]{\vspace{4pt}\footnotesize \parindent 15pt {\bfseries #1. }\ignorespaces}{\par\vspace{7pt}}
\newenvironment{keywords}{\begin{@abs}{Keywords}}{\end{@abs}}
\newenvironment{AMS}{\begin{@abs}{AMS subject classifications (MSC2010)}}{\end{@abs}}

