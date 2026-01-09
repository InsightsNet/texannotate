\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ssh}

\makeatletter
\@ifclasswith{ssh}{main}%
    {% for [main]
        \@ifclasswith{ssh}{onecolumn}%
            {% for [main, onecolumn]
                \def\titlemaker{\makeTitleMainOneColumn{}}
               % \PassOptionsToClass{onecolumn}{article}
            }%
            {%  for [main]
                \def\titlemaker{\makeTitleMainTwoColumn{}}
                \PassOptionsToClass{twocolumn}{article}
            }
    }%
    {% Behavior for no [main]
        \@ifclasswith{ssh}{SI}%
            {% for [SI]
                \def\titlemaker{\makeTitleSI{}}
                \PassOptionsToClass{onecolumn}{article}
            }%
            {% for no [SI], [main]
                \def\titlemaker{\makeTitleMainTwoColumn{}}
                \PassOptionsToClass{twocolumn}{article}
            }
    }
\makeatother

\DeclareOption{main}{}
\DeclareOption{onecolumn}{}
\DeclareOption{SI}{}

\ProcessOptions\relax
\LoadClass[twoside]{article}
\RequirePackage{setspace}

\def\maketitle{\titlemaker{}}

\makeatletter
\def\makeTitleMainOneColumn{{\sffamily%
        \noindent\textbf{\Large\@title}\par\vspace{12pt}%
        \noindent\textbf{\normalsize\authors}\par\vspace{12pt}%
        \noindent{\scriptsize\affs}\par\vspace{24pt}%
        \centering\parbox{7in}{\noindent\textbf{\normalsize\abstractString}}\par\vspace{24pt}}
    \rmfamily%
    \newcommand{\titleString}{\@title}%
    \runFancy}
    \onehalfspacing
\makeatother

\makeatletter
\def\makeTitleMainTwoColumn{\sffamily%
    \twocolumn[
        \noindent\textbf{\Large\@title}\par\vspace{12pt}%
        \noindent\textbf{\normalsize\authors}\par\vspace{12pt}%
        \noindent{\scriptsize\affs}\par\vspace{24pt}%
        \centering\parbox{7in}{\noindent\textbf{\normalsize\abstractString}}\par\vspace{24pt}
    ]
    \rmfamily%
    \newcommand{\titleString}{\@title}%
    \runFancy}
    \singlespacing
\makeatother

\makeatletter
\def\makeTitleSI{\sffamily%
    \noindent\textbf{\LARGE{Supplementary Information for}}\par\vspace{12pt}%
    \noindent\textbf{\Large\@title}\par\vspace{12pt}%
    \noindent\textbf{\normalsize\authorsSI}\par\vspace{12pt}%
    \rmfamily%
    \newcommand{\titleString}{SI: \@title}
    \runFancy}
\makeatother

%% Basic Formatting
\RequirePackage[letterpaper, left=0.6in,right=0.6in, top=0.6in, bottom=0.8in,headsep=0.05in]{geometry}
\RequirePackage[colorlinks=true, allcolors=blue]{hyperref}
\RequirePackage{setspace}
\RequirePackage{helvet}
\RequirePackage{newtxtext}
\setlength{\parskip}{6pt}%
\raggedbottom

%%%% Author & Affiliations
%% Authors
\newcommand{\authorList}{}
\newcommand{\authorListSI}{}
\newcounter{numAuthors}

\newcommand{\addToAuthorList}[1]{%
    \stepcounter{numAuthors}\listadd\authorList{#1}%
}
\newcommand{\addToAuthorListSI}[1]{%
    \listadd\authorListSI{#1}%
}

\renewcommand{\author}[2][]{%
    \addToAuthorList{#2\textsuperscript{#1}}%
    \addToAuthorListSI{#2}%
    \ifnumequal{\value{numAuthors}}{1}%
        {\newcommand{\firstAuthor}{#2}}{}
}

\def\doAuthor#1{%
 \ifnumequal{\value{numAuthors}}{1}{%
  and #1}{\addtocounter{numAuthors}{-1}#1,~}%   
}


\def\authors{\forlistloop{\doAuthor}{\authorList}}
\def\authorsSI{\forlistloop{\doAuthor}{\authorListSI}}

%% Affiliations
\newcommand{\affList}{}
\newcounter{numAffs}
\newcommand{\addToAffList}[1]{\stepcounter{numAffs}\listadd\affList{#1}}
\newcommand{\affil}[2][]{\addToAffList{\textsuperscript{#1}#2}}

\def\doAff#1{%
 \ifnumequal{\value{numAffs}}{1}{%
  #1}{\addtocounter{numAffs}{-1}#1.~}%   
}

\def\affs{\forlistloop{\doAff}{\affList}}


%% Header Footer
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\newcommand{\firstAuthorLastNameString}{}
\newcommand{\firstAuthorLastName}[1]{\renewcommand{\firstAuthorLastNameString}{#1}}

\def\runFancy{%
    \pagestyle{fancy}
    \fancyfoot[RO]{\bfseries\sffamily\footnotesize \firstAuthor{}~et al. | \thepage{} of \pageref*{LastPage}}
    \fancyfoot[RE]{\bfseries\sffamily\footnotesize \firstAuthor{}~et al.}
    \fancyfoot[LE]{\bfseries\sffamily\footnotesize \thepage{} of \pageref*{LastPage} | \titleString}
    \fancyfoot[LO]{\bfseries\sffamily\footnotesize \titleString}
    \fancyfoot[C]{}
    \fancyhead{}
    \renewcommand{\headrulewidth}{0pt}
}

%% Abstract
\newcommand{\abstractString}{}
\renewcommand{\abstract}[1]{\renewcommand{\abstractString}{#1}}


%% Section Headers
\RequirePackage{titlesec}
\titleformat*{\section}{\sffamily\large\bfseries}
\titlespacing{\section}{0pt}{12pt}{0pt}
\titleformat*{\subsection}{\sffamily\normalsize\bfseries}
\titlespacing{\subsection}{0pt}{8pt}{0pt}

%% Figure
\RequirePackage{float}
\RequirePackage{graphicx}


%% Caption
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{vline}{~\rule[-0.4ex]{0.2ex}{1.0em}~}
\DeclareCaptionLabelFormat{mylabel}{\sffamily{\textbf{#1#2}}}
\captionsetup[figure]{font={footnotesize,sf},labelfont={footnotesize},name={Fig.},labelformat=mylabel,labelsep=vline}

%% Section and Figure heading for SI
\makeatletter
\@ifclasswith{ssh}{SI}%
    {% for [SI]
        \renewcommand{\thefigure}{S\arabic{figure}}
        \renewcommand{\thesection}{S\arabic{section}}
    }%
    {% 
    }
\makeatother

%% Appendix
\def\beginAppendix{%
    \renewcommand{\thefigure}{A\arabic{figure}}
    \renewcommand{\thesubsection}{Appendix \Alph{subsection}:}
    \section*{Methods}
    \setcounter{figure}{0}
}
    


% Bibliography
\RequirePackage[backend=biber, style=nature,doi=true]{biblatex}
\renewcommand*{\bibfont}{\footnotesize}
\setlength{\bibitemsep}{1pt}

\def\beginReferences{%
    \section*{References}
    {\printbibliography[heading=none]}
}




%% Cross Referencing
\RequirePackage{xr}
\makeatletter
\newcommand*{\addFileDependency}[1]{% argument=file name and extension
  \typeout{(#1)}
  \@addtofilelist{#1}
  \IfFileExists{#1}{}{\typeout{No file #1.}}
}
\makeatother

\newcommand*{\myexternaldocument}[1]{%
    \externaldocument{#1}%
    \addFileDependency{#1.tex}%
    \addFileDependency{#1.aux}%
}
%%
