%% This is `cimart.cls', a file generated with the docstrip utility
%% The original source file was: commat-src.dtx
%% An earlier version of this cls file was: commat.cls
%%
%% Created by Jan Lemma Sustek, 2006-2010, 2012
%% Modified by Jan Stepnicka, 2012
%% Manually adjusted by Jan Šustek, 160613, 161107, 170922, 1805**, 180619
%% Modified by Celine Barthonnat: 2021
%% Modified by Tiago Macedo: 2022-2024


\NeedsTeXFormat{LaTeX2e}
\def\ClassName@CiM{cimart}
\ProvidesClass{\ClassName@CiM}[2024/05/14 v2.4^^J%
LaTeX document class for Communications in Mathematics]

\LoadClass[letterpaper, 12pt]{article}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage[sort, nocompress]{cite}
\RequirePackage[margin=1.07in, top=1.33in, headheight=2.15in]{geometry}
\RequirePackage{graphicx}
\RequirePackage[colorlinks = true, allcolors = blue]{hyperref}
\RequirePackage[utf8]{inputenc}
\RequirePackage[dvipsnames]{xcolor}


%%%%% HEADERS AND FOOTERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}    % reset everything

\def\headrulewidth{0pt}
\def\footnoterule{\kern-3\p@ \hrule \@width1in \kern2.6\p@}

\lhead{\footnotesize
    \ifnum\thepage=1
        \rlap{\smash{\hskip-50pt\lower5pt\hbox{\includegraphics[height=9mm]{episciences.eps}}}}%
        \vskip 1ex%
        \hbox{\vbox to 0pt{%
            \the@JournalName\ \textbf{\the@VOLUME}\ (\the@YEAR), no. \the@ISSUE, Paper no. \the@NUMBER \\
            \the@DOIName~\the@DOI \\
            \textcopyright \the@YEAR\ \theshort@author \\
            This is an open access article licensed under the CC BY-SA 4.0
            \hss
            \vss
            }}%
    \else
        \relax
    \fi
    }

\chead{\footnotesize
    \ifnum\thepage=1
        \relax
    \else
        \ifodd\thepage
            \theshort@title
        \else
            \theshort@author
        \fi
    \fi
    }

\cfoot{\thepage}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% TITLE PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\narrowpar@CiM#1#2{%
    \begingroup
        \parindent1cm \narrower%
        \small \noindent%
        {\sffamily\bfseries#1.}
        \parindent15pt%
        \rm#2\par
    \endgroup
    \vskip24pt
    }

\def\footnote@CiM#1#2{%
    \def\@thefnmark{}%
    \ifx\relax#2\relax
        \relax%
    \else
        \begin{NoHyper}
            \@footnotetext{\textit{#1:}\enskip#2}%
        \end{NoHyper}
    \fi
    }

\def\makepapertitle@CiM{
    \vspace*{1.5cm}
    % Title
    {\baselineskip18pt \lineskiplimit6pt
    \noindent\sffamily\bfseries\mathversion{bold}\Large\the@title\par}
    % Authors' names
    \ifx\relax\the@author\relax
        \relax%
    \else
        \begingroup
            \baselineskip30pt%
            \noindent%
            \textit{\the@author}%
            \vskip24pt%
        \endgroup
    \fi
    % Abstract
    \narrowpar@CiM\the@AbstractName\the@abstract
    % Footer
    \footnote@CiM{\the@MscName}{\the@msc}
    \footnote@CiM{\the@KeywordsName}{\the@keywords}
    \footnote@CiM{\the@ContactInfoName}{\the@contactinfo}
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% AUXILIARY MACROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions of 'newfield's macros.
\def\newfield@CiM{\@ifnextchar*\newfieldB@CiM\newfieldA@CiM}

% If \newfield@CiM is not followed by a *, then:
% newfield@CiM defines a macro called '\#1' which defines a macro '\the@#1'
\def \newfieldA@CiM #1{%
    \def#1##1{%
        \escapechar`\@ \relax
        \long\@namedef{the\string#1}{##1}
        \escapechar=92
        }
    }

% If \newfield@CiM is followed by a *, then:
% newfield@CiM defines a macro called '\#1', which has one or two arguments.
% The first argument is optional and defines a macro called '\theshort@#1';
% the second argument is mandatory and defines a macro called '\the@#1'.
\def\newfieldB@CiM*#1{%
    \def#1{\@ifnextchar[{\@nameuse{\string#1@B}}{\@nameuse{\string#1@A}}}
    \@namedef{\string#1@A}##1{\@nameuse{\string#1@B}[##1]{##1}}
    \@namedef{\string#1@B}[##1]##2{%
        \escapechar`\@ \relax
        \@namedef{theshort\string#1}{##1}
        \@namedef{the\string#1}{##2}
        \escapechar=92
        }
    }

% \newlongfield@CiM defines a long-macro also called '\#1', which also defines a long-macro called '\the@#1'.
\def\newlongfield@CiM#1{%
    \long\def#1##1{%
        \escapechar`\@ \relax
    	\long\@namedef{the\string#1}{##1}
    	\escapechar=92
        }
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% TITLE PAGE INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newfield@CiM\JournalName  \JournalName{Communications in Mathematics}
\newfield@CiM\YEAR  \YEAR{\the\year{}}
\newfield@CiM\VOLUME  \VOLUME{{\color{red}v}}
\newfield@CiM\ISSUE  \ISSUE{{\color{red}i}}
\newfield@CiM\NUMBER  \NUMBER{{\color{red}n}}
\newfield@CiM\ISSNprint  \ISSNprint{1804-1388}
\newfield@CiM\ISSNonline  \ISSNonline{2336-1298}
\newfield@CiM\DOIName  \DOIName{DOI:}
\newfield@CiM\DOI  \DOI{{\color{red}\url{https://doi.org/10.46298/cm.ABCD}}}
\newfield@CiM*\author  \author{Authors of the paper}
\newfield@CiM*\title  \title{Title of the paper}
\newfield@CiM\AbstractName  \AbstractName{Abstract}
\newlongfield@CiM\abstract  \abstract{Abstract of the paper...}
\newfield@CiM\MscName  \MscName{MSC 2020}
\newfield@CiM\msc  \msc{AMS classification}
\newfield@CiM\KeywordsName  \KeywordsName{Keywords}
\newfield@CiM\keywords  \keywords{key words and phrases}
\newlongfield@CiM\contactinfo  \contactinfo{}
\newfield@CiM\ContactInfoName  \ContactInfoName{Contact information}
\newfield@CiM\AffiliationName  \AffiliationName{Affiliation}
\newfield@CiM\EmailName  \EmailName{Email}

% This is the macro that will actually be used in the main tex file.  It
% calls \authorsname, if the (optional) author's name is present; and calls
% addresses, otherwise (when there is only one author).
\def \authorinfo{\@ifnextchar[{\authorsname}{\addresses}}

% Each time that this macro is called, it adds the info entered (author's 
% name (#1), address (#2) and email (#3)) to \the@contactinfo.
\def \authorsname[#1]#2#3{%
    \g@addto@macro\the@contactinfo{%
        \par\noindent%
        \begingroup%
            \footnotesize%
            \interlinepenalty10000%
            \leftskip 3em%
            \rightskip 2em plus 8em%
            #1:\par
            \ifx\relax#2\relax
                \textit{\the@EmailName:} \texttt{#3}.\par
            \else
                \textit{\the@AffiliationName:} {#2}.\par
                \textit{\the@EmailName:} \texttt{#3}\par
            \fi
        \endgroup
        }
    }

% Each time that this macro is called, it adds the info entered (author's 
% address (#1) and email (#2)) to \the@contactinfo.
\def \addresses#1#2{%
    \g@addto@macro\the@contactinfo{%
        \par\noindent
        \begingroup
            \footnotesize%
            \interlinepenalty10000%
            \leftskip 3em%
            \rightskip 2em plus 8em%
            \ifx\relax#1\relax
                \textit{\the@EmailName:} \texttt{#2}.\par
            \else
                \textit{\the@AffiliationName:} #1.\par\noindent%
                \textit{\the@EmailName:} \texttt{#2}.\par
            \fi
        \endgroup
        }
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% TABLE OF CONTENTS AND LAST SECTION INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieve last section number from an auxiliary file
\newread\infile
\immediate\openin\infile=./lastdata.aux
\newcounter{lastsection}
\setcounter{lastsection}{1}
\ifeof\infile
    \relax
\else
    \newcounter{currentline}
    \loop\unless\ifeof\infile
        \immediate\read\infile to\fileline
        \ifnum\thecurrentline=0\setcounter{lastsection}{\fileline}\fi
        \stepcounter{currentline}
    \repeat
\fi
\immediate\closein\infile

% If lastsection >= 3, then print a table of contents
\AtBeginDocument{%
    % Print first page info
    \makepapertitle@CiM
    % If the paper has more that 2 sections, print a TOC
    \ifnum\thelastsection>2\tableofcontents\fi
    }

% Write the last section info in an auxiliary file
\AtEndDocument{%
    % Fix Bibtex style
    \bibliographystyle{abbrv}
    % Print editorial info
    \PrintEditInfo
    % Record the number of sections in an auxiliary file
    \newwrite\outfile
    \immediate\openout\outfile=./lastdata.aux
    \immediate\write\outfile{\thesection}
    \immediate\closeout\outfile
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% RESULTS AND PROOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newfield@CiM\ConjectureName  \ConjectureName{Conjecture}
\newfield@CiM\CorollaryName  \CorollaryName{Corollary}
\newfield@CiM\DefinitionName  \DefinitionName{Definition}
\newfield@CiM\ExampleName  \ExampleName{Example}
\newfield@CiM\LemmaName  \LemmaName{Lemma}
\newfield@CiM\ProblemName  \ProblemName{Problem}
\newfield@CiM\ProofName  \ProofName{Proof}
\newfield@CiM\PropositionName  \PropositionName{Proposition}
\newfield@CiM\RemarkName  \RemarkName{Remark}
\newfield@CiM\TheoremName  \TheoremName{Theorem}

\newtheoremstyle{cmdefinition}
	{1em} % space above the theorem
	{1ex} % space below the theorem
	{} % name of the body font
	{} % space to indent
	{\bfseries\sffamily} % name of head font
	{.} % punctuation between head and body
	{ } % space after theorem head
	{}

\theoremstyle{cmdefinition}
\newtheorem{definition}{\the@DefinitionName}[section]
\newtheorem{example}[definition]{\the@ExampleName}
\newtheorem{problem}[definition]{\the@ProblemName}
\newtheorem{remark}[definition]{\the@RemarkName}

\newtheoremstyle{cmplain}
	{1em} % space above the theorem
	{1ex} % space below the theorem
	{\itshape} % name of the body font
	{} % space to indent
	{\bfseries\sffamily} % name of head font
	{.} % punctuation between head and body
	{ } % space after theorem head
	{}

\theoremstyle{cmplain}
\newtheorem{conjecture}[definition]{\the@ConjectureName}
\newtheorem{corollary}[definition]{\the@CorollaryName}
\newtheorem{lemma}[definition]{\the@LemmaName}
\newtheorem{proposition}[definition]{\the@PropositionName}
\newtheorem{theorem}[definition]{\the@TheoremName}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% SECTIONS, SUBSECTIONS, ... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\section{\@startsection{section}{1}{\z@}
  {2em \@plus 1em \@minus 1em}{1em \@plus 1ex \@minus 1ex}
  {\normalfont\large\sffamily\bfseries\mathversion{bold}}}

\def\subsection{\@startsection{subsection}{2}{\z@}
  {1em \@plus 1ex \@minus 1ex}{1ex \@plus 0.5ex \@minus 0.5ex}
  {\normalfont\normalsize\sffamily\bfseries\mathversion{bold}}}

\def\subsubsection{\@startsection{subsubsection}{3}{\z@}
  {-2ex \@plus -2ex \@minus -0.2ex}{0.5ex \@plus 0.2ex}
  {\normalfont\normalsize\sffamily\bfseries\mathversion{bold}}}

\def\paragraph{\@startsection{paragraph}{4}{\z@}
  {3.25ex\@plus1ex\@minus.2ex}{-.5em}
  {\normalfont\normalsize\sffamily\bfseries\mathversion{bold}}}

\def\subparagraph{\@startsection{subparagraph}{5}
  {\parindent}{3.25ex\@plus1ex\@minus .2ex}{-.5em}
  {\normalfont\normalsize\sffamily\bfseries\mathversion{bold}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% EDITORIAL INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newfield@CiM\receiveddate    \receiveddate{{\color{red}Received date}}
\newfield@CiM\accepteddate    \accepteddate{{\color{red}Accepted date}}
\newfield@CiM\handlingeditor  \handlingeditor{{\color{red}Handling Editor}}

% Macro that updates the values of RECEIVEDDATE, ACCEPTEDDATE and HANDLINGEDITOR
% (this is the function that is actually used in the main latex file)
\def \EditInfo #1#2#3{%
    \receiveddate{#1}
    \accepteddate{#2}
    \handlingeditor{#3}
    }
    
% Macro that prints the editorial info
\def\PrintEditInfo{%
    \par\nobreak\bigskip
    \begingroup
    \footnotesize
    \noindent\textit{Received:} \the@receiveddate
    \par\nobreak
    \noindent\textit{Accepted for publication:} \the@accepteddate
    \par\nobreak
    \noindent\textit{Communicated by:} \the@handlingeditor
    \par
    \endgroup\par
    }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\endinput