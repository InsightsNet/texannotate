%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A LaTeX document class for nice-looking papers. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jkpapershort}[2023/02/16 Josh Kirklin's Paper Class (short)]
\LoadClass[11pt]{article}

% Options
\newif\iffrontimage
\frontimagefalse
\DeclareOption{frontimage}{\frontimagetrue} % Enable front image
\newif\ifdiff
\difffalse
\DeclareOption{diff}{\difftrue} % Enable edit highlighting
\newif\ifcompact
\compactfalse
\DeclareOption{compact}{\compacttrue} % Compact format
\newif\ifhidetodos
\hidetodosfalse
\DeclareOption{hidetodos}{\hidetodostrue} % Hide todos
\newif\ifdraftwarning
\draftwarningfalse
\DeclareOption{draftwarning}{\draftwarningtrue} % Draft label
\newif\ifnoparskip
\noparskipfalse
\DeclareOption{noparskip}{\noparskiptrue} % Draft label
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% Load packages
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{mathtools}
\RequirePackage{mathrsfs}
\RequirePackage{mathbbol}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{tensor}
\RequirePackage{dsfont}
\RequirePackage{bm}
\RequirePackage{slashed}
\RequirePackage{physics}
\RequirePackage{booktabs}
\RequirePackage{tabulary}
\RequirePackage{float}
\RequirePackage{subcaption}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage{microtype} % OCD proportions
\RequirePackage{fancyhdr}
\RequirePackage{xparse}
\ifnoparskip
\else
    \RequirePackage{parskip}
\fi
\RequirePackage[pdfusetitle,unicode]{hyperref}
\RequirePackage{xcolor}
\RequirePackage{lmodern}
\RequirePackage{enumitem}
\RequirePackage{tocloft}
\RequirePackage[
    sorting=none,
    style=numeric-comp,
    maxbibnames=99,
    date=year,
    doi=false,
    url=false,
    giveninits=true
  ]{biblatex}
\RequirePackage[a4paper, top=0.85in, bottom=1in, left=0.8in, right=0.8in]{geometry}
\RequirePackage[margin=0.2\linewidth,font=small,labelfont=bf]{caption}
\RequirePackage[normalem]{ulem}
\RequirePackage{marginnote}

% Bibliography style
\renewcommand{\newunitpunct}{,\space}
\DeclareFieldFormat{doilink}{\iffieldundef{doi}{#1}{\href{http://dx.doi.org/\thefield{doi}}{#1}}}
\DeclareFieldFormat[article]{volume}{\textbf{#1}}
\DeclareFieldFormat[article]{pages}{#1}
\DeclareFieldFormat[inbook]{pages}{#1}
\DeclareFieldFormat[inproceedings]{pages}{#1}
\DeclareFieldFormat{eprint:arxiv}{%
  \ifhyperref
  {\mkbibbrackets{\href{https://arxiv.org/\abx@arxivpath/#1}{\nolinkurl{#1}}}}
    {\nolinkurl{#1}}}
\DeclareFieldFormat[inbook]{title}{\mkbibitalic{#1}}
\DeclareFieldFormat[inproceedings]{title}{\mkbibitalic{#1}}
\DeclareFieldFormat[article]{title}{\mkbibitalic{#1}}
\DeclareFieldFormat[unpublished]{title}{\mkbibitalic{#1}}
\DeclareBibliographyDriver{article}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\labelnamepunct}\newblock
  \usebibmacro{title}%
  \newunit
  \printlist{language}%
  \newunit\newblock
  \usebibmacro{byauthor}%
  \newunit\newblock
  \usebibmacro{bytranslator+others}%
  \newunit\newblock
  \printfield{version}%
  \newunit\newblock
  \printtext[doilink]{%
  \usebibmacro{journal+issuetitle}%
  \newunit
  \usebibmacro{byeditor+others}%
  \newunit
  \usebibmacro{note+pages}%
  }%
  \newunit\newblock
  \iftoggle{bbx:isbn}
    {\printfield{issn}}
    {}%
  \newunit\newblock
  \usebibmacro{doi+eprint+url}%
  \newunit\newblock
  \usebibmacro{addendum+pubstate}%
  \setunit{\bibpagerefpunct}\newblock
  \usebibmacro{pageref}%
  \usebibmacro{finentry}
}

% Appearance
\renewcommand{\baselinestretch}{1.07}
%\setlength{\floatsep}{0.6in plus 2.0pt minus 4.0pt}
\numberwithin{equation}{section}
\numberwithin{figure}{section}
\numberwithin{table}{section}
%\renewcommand{\theequation}{{\textcolor{red!60!black}{\thesection.\arabic{equation}}}}
\ifnoparskip
\else
    \setlength{\parindent}{15pt} 
    \setlength{\parskip}{.5\baselineskip plus 3pt}
\fi
\hypersetup{
	colorlinks,
	linkcolor={red!60!black},
	citecolor={blue!60!black},
	urlcolor={blue!80!black},
	breaklinks=true
}
\DeclareSymbolFontAlphabet{\amsmathbb}{AMSb}
\let\altmathbb\mathbb
\let\mathbb\amsmathbb
\mathtoolsset{centercolon}
\renewcommand*\footnoterule{{\color{white!60!black}\noindent\rule{\textwidth}{.4pt}}}
\setlength{\skip\footins}{0.2in}
\addtolength{\footnotesep}{0.1in}
\setlength{\cftbeforesecskip}{0.2\baselineskip}
\setlength{\cftbeforesubsecskip}{0.1\baselineskip}
\setlength{\cftbeforesubsubsecskip}{0.05\baselineskip}
\renewcommand{\cftdot}{}
\renewcommand{\cftsecpagefont}{\large\bfseries}
\renewcommand{\cftsubsecpagefont}{}
\renewcommand{\contentsname}{}
\renewcommand{\cftsecfont}{\bfseries}
\renewcommand{\cftsubsecfont}{}
\renewcommand{\cftsubsubsecfont}{}
\titleformat*{\section}{\Large\bfseries}
\titleformat*{\subsection}{\large\bfseries}
\titlespacing{\section}{0pt}{1\baselineskip}{0.65\baselineskip}
\titlespacing{\subsection}{0pt}{1\baselineskip}{0.35\baselineskip}
\let\oldfootnote\footnote
\renewcommand\footnote[1]{\oldfootnote{\hspace{.7mm}#1}}

\ifdraftwarning
    \pagestyle{fancyplain}
    \lhead[]{}
    \rhead[]{}
    \chead[\textcolor{gray}{\tt \large DRAFT}]{\textcolor{gray}{\tt \large DRAFT \today}}
    \renewcommand{\headrulewidth}{0pt}
    \setlength{\headheight}{14.5pt}
\fi

% Author notes
% Define a new command that can be used with and without an asterisk
\NewDocumentCommand{\newauthornote}{mmm}{
    % #1 = command name
    % #2 = author's name (displayed in bold in the emphasized version)
    % #3 = color of text for both versions
    \NewDocumentCommand{#1}{s m}{%
        \textcolor{#3}{\IfBooleanTF{##1}%
            {{\emph{\footnotesize \textbf{#2}:~##2}}} % Emphasized note with author's name in bold
            {{##2}}% Regular note
    }}
}

% Custom math commands
\newcommand{\scri}{\mathscr{I}}
\newcommand{\lie}{\mathcal{L}}
\newcommand{\flie}{\mathscr{L}}
\newcommand{\hook}{\mathop\lrcorner}
\newcommand{\transp}{{\mkern-0.8mu\boldsymbol{\top}}}
\newcommand{\spann}{\mathop{\mathrm{span}}}
\providecommand{\RR}{\mathbb{R}}
\providecommand{\NN}{\mathbb{N}}
\providecommand{\ZZ}{\mathbb{Z}}
\providecommand{\CC}{\mathbb{C}}
\newenvironment{nalign}{ % Align environment with only 1 equation number
	\begin{equation}
	\begin{aligned}
}{
	\end{aligned}
	\end{equation}
	\ignorespacesafterend
}
\def\diffD{\mathrm{D}}
\DeclareDocumentCommand\Differential{ o g d() }{ % Differential 'D'
	% o: optional n for nth differential
	% g: optional argument for readability and to control spacing
	% d: long-form as in d(cos x)
	\IfNoValueTF{#2}{
		\IfNoValueTF{#3}
		{\diffd\IfNoValueTF{#1}{}{^{#1}}}
		{\mathinner{\diffd\IfNoValueTF{#1}{}{^{#1}}\argopen(#3\argclose)}}
	}
	{\mathinner{\diffD\IfNoValueTF{#1}{}{^{#1}}#2} \IfNoValueTF{#3}{}{(#3)}}
}
\DeclareDocumentCommand\Dd{}{\Differential} % Shorthand for \Differential

\newcommand{\Expval}[1]{\expval{\!\expval{#1}\!}} % double bracket expval

\newcommand{\hodge}{\mathop{\ast}}
\newcommand{\ubar}[1]{\mkern 1.5mu\underline{\mkern-1.5mu#1\mkern-1.5mu}\mkern 1.5mu}
\newcommand{\uubar}[1]{\ubar{\ubar{#1}}}
\newcommand{\tang}{\mathrm{T}}

\DeclareMathAlphabet\mathbfcal{OMS}{cmsy}{b}{n}
\DeclareMathAlphabet\mathbfscr{OMS}{mdugm}{b}{n}

% PHYSICAL Bra-ket notation
\DeclareDocumentCommand\Bra{ s m t\Ket s g }
{ % Bra
	\IfBooleanTF{#3}
	{ % Contraction
		\IfBooleanTF{#1}
		{ % Bra has a star: no resize
			\IfNoValueTF{#5}
			{\Braket*{#2}{} \IfBooleanTF{#4}{*}{}}
			{\Braket*{#2}{#5}}
		}
		{
			\IfBooleanTF{#4}
			{ % Ket has a star: no resize
				\IfNoValueTF{#5}
				{\Braket{#2}{} *}
				{\Braket*{#2}{#5}}
			}
			{\Braket{#2}{\IfNoValueTF{#5}{}{#5}}} % Neither term is starred: auto sizing
		}
	}
	{ % No contraction
		\IfBooleanTF{#1}
		{\vphantom{#2}\left(\smash{#2}\right\rvert}
		{\left({#2}\right\rvert}
		\IfBooleanTF{#4}{*}{}
		\IfNoValueTF{#5}{}{#5}
	}
}

\DeclareDocumentCommand\Ket{ s m }
{ % Ket
	\IfBooleanTF{#1}
	{\vphantom{#2}\left\lvert\smash{#2}\right)} % No resize
	{\left\lvert{#2}\right)} % Auto sizing
}

\DeclareDocumentCommand\Innerproduct{ s m g }
{ % Inner product
	\IfBooleanTF{#1}
	{ % No resize
		\IfNoValueTF{#3}
		{\vphantom{#2}\left(\smash{#2}\middle\vert\smash{#2}\right)}
		{\vphantom{#2#3}\left(\smash{#2}\middle\vert\smash{#3}\right)}
	}
	{ % Auto resize
		\IfNoValueTF{#3}
		{\left({#2}\middle\vert{#2}\right)}
		{\left({#2}\middle\vert{#3}\right)}
	}
}
\DeclareDocumentCommand\Braket{}{\Innerproduct} % Alternative for \innerproduct
\DeclareDocumentCommand\Ip{}{\Innerproduct} % Shorthand for \innerproduct
	
\DeclareDocumentCommand\Outerproduct{ s m g }
{ % Dyad
	\IfBooleanTF{#1}
	{ % No resize
		\IfNoValueTF{#3}
		{\vphantom{#2}\left\lvert\smash{#2}\middle)\!\middle(\smash{#2}\right\rvert}
		{\vphantom{#2#3}\left\lvert\smash{#2}\middle)\!\middle(\smash{#3}\right\rvert}
	}
	{ % Auto resize
		\IfNoValueTF{#3}
		{\left\lvert{#2}\middle)\!\middle({#2}\right\rvert}
		{\left\lvert{#2}\middle)\!\middle({#3}\right\rvert}
	}
}
\DeclareDocumentCommand\Dyad{}{\Outerproduct} % Alternative for \outerproduct
\DeclareDocumentCommand\Op{}{\Dyad} % Shorthand for \outerproduct
\DeclareDocumentCommand\Ketbra{}{\Dyad} % Alternative for \outerproduct

\DeclareDocumentCommand\Expectationvalue{ s s m g }
{ % Expectation value
	\IfNoValueTF{#4}
	{
		\IfBooleanTF{#1}
		{\vphantom{#3}\left(\smash{#3}\right)} % Starred implicit form: no resizing
		{\left({#3}\right)} % Normal implicit form: auto sizing
	}
	{
		\IfBooleanTF{#1}
		{
			\IfBooleanTF{#2}
			{\left({#4}\middle\vert{#3}\middle\vert{#4}\right)} % Double starred explicit form: total auto sizing
			{\vphantom{#3#4}\left(\smash{#4}\middle\vert\smash{#3}\middle\vert\smash{#4}\right)} % Starred explicit form: no resizing
		}
		{\vphantom{#3}\left({#4}\middle\vert\smash{#3}\middle\vert{#4}\right)} % Normal explicit form: only resize based on bra/ket arguments
	}
}
\DeclareDocumentCommand\Expval{}{\Expectationvalue} % Shorthand for \expectationvalue
\DeclareDocumentCommand\Ev{}{\Expectationvalue} % Shorthand for \expectationvalue
\DeclareDocumentCommand\Vev{ m }{\Expectationvalue{#1}{0}} % Vacuum expectation value

\DeclareDocumentCommand\Matrixelement{ s s m m m }
{ % Matrix element
	\IfBooleanTF{#1}
	{
		\IfBooleanTF{#2}
		{\left({#3}\middle\vert{#4}\middle\vert{#5}\right)} % Double starred: total resizing
		{\vphantom{#3#4#5}\left(\smash{#3}\middle\vert\smash{#4}\middle\vert\smash{#5}\right)} % Starred: no resizing
	}
	{\vphantom{#4}\left({#3}\middle\vert\smash{#4}\middle\vert{#5}\right)} % Normal: only resize based on bra/ket arguments
}
\DeclareDocumentCommand\Matrixel{}{\Matrixelement} % Shorthand for \Matrixelement
\DeclareDocumentCommand\Mel{}{\Matrixelement} % Shorthand for \Matrixelement

% Todo notes
\ifhidetodos
    \newcommand\todo[1]{}
\else
    \newcommand\todo[1]{\textnormal{\color{red}{\bf\footnotesize (\emph{\underline{TODO}:~#1})}}\marginnote{\tikz[baseline=-0.5ex]{\draw[red,fill,thick,->](0,0)--(-0.5,0);}}}
\fi


\newcommand{\emaillink}[1]{{\tt\href{mailto:#1}{#1}}}

% Title, table of contents, bibliography
\newcommand{\email}[1]{\def\@email{#1}}
\newcommand{\abstr}[1]{\def\@abstr{#1}}
\newcommand{\institution}[1]{\def\@institution{#1}}
\renewcommand{\maketitle}{%
    \ifcompact
        \begin{center}
            \vspace*{0.5\baselineskip}

            \parbox{\linewidth}{\centering\LARGE\bf\@title}
           
            \vspace*{0.75\baselineskip}
            
            {\large \@author}
            
            \vspace*{0.5\baselineskip}
            
            {\small \@email}
            
            \vspace*{0.7\baselineskip}
            
            \parbox{0.8\linewidth}{\centering\em\small\@institution}

            \vspace*{1\baselineskip}
        \end{center}
        \begin{quote}
            \textbf{Abstract:} \small\@abstr
        \end{quote}
        \setcounter{footnote}{0}
    \else
        \begin{titlepage}
            \vspace*{\fill}
            \vspace*{0.3in}
            \begin{center}
                \parbox{\linewidth}{\centering\LARGE\bf\@title}
                \vspace*{1\baselineskip}
                
                {\large \@author}
                
                \vspace*{1\baselineskip}
                
                \parbox{0.8\linewidth}{\centering\em\small\@institution}
                
                \vspace*{1\baselineskip}
                
                {\small \tt \@email}
                
                
                \iffrontimage
                    \vspace*{1.5\baselineskip}
                    \begin{center}
                        \includegraphics[width=0.4\linewidth]{front.png}
                    \end{center}
                    \vspace*{2\baselineskip}
                \else
                    \vspace*{1.5\baselineskip}
                \fi

                {\large\bf Abstract}
            \end{center}
            \begin{quote}
                \small\@abstr
            \end{quote}

            \ifdraftwarning \vspace{0.5in} \begin{center}
                \textcolor{gray}{\LARGE \tt DRAFT \today}
            \end{center}\fi

            \ifdiff \vspace{0.5in} \begin{center}
                This is a revised version with indicated edits. 
        
                \highlight[green!25]{Text highlighted in green has been added.} 
                
                {\color{red} \sout{Red text with a strikethrough has been removed.}} 
                
                There may be some unindicated revisions to references. 
            \end{center}\fi

            \vspace*{0.7in}\vspace*{\fill}
        \end{titlepage}
        \setcounter{footnote}{0}
        \newpage
        \ifdiff \listofchange \newpage \fi
    \fi
}
\newcommand{\maketitleandtoc}{%
	\maketitle%
    \ifcompact%
        \vspace*{\fill}
        \setlength{\cftbeforetoctitleskip}{-1em}\tableofcontents
        \vspace*{\fill}
        \newpage
    \else%
        \newgeometry{top=0.85in, bottom=1in, left=1.25in, right=1.25in}
        \vspace*{1em}
        \begin{center}
            {\Large\bf Contents}
        \end{center}
        \tableofcontents
        \restoregeometry
        \newpage
    \fi
}
\setlength\bibitemsep{0.2\baselineskip}
\let\oldprintbibliography\printbibliography
\renewcommand{\printbibliography}{%
    \phantomsection
\addcontentsline{toc}{section}{\protect\numberline{}References}
\raggedright\oldprintbibliography}

% Revisions

\newcommand{\listchangename}{List of Edits}
\newlistof{change}{ch}{\listchangename}

\newcommand{\hltext}[1]{\bgroup\markoverwith{\textcolor{#1}{\rule[-0.5ex]{2pt}{2.5ex}}}\ULon}
\newcommand{\hlmath}[2]{\mathchoice%
	{\colorbox{#1}{$\displaystyle#2$}}%
	{\colorbox{#1}{$\textstyle#2$}}%
	{\colorbox{#1}{$\scriptstyle#2$}}%
	{\colorbox{#1}{$\scriptscriptstyle#2$}}}%

% \highlight[<colour>]{<stuff>}
\newcommand{\highlight}[2][yellow]{\relax\ifmmode\hlmath{#1}{#2}\else \hltext{#1}{#2}\fi}
\newcommand{\soutsafe}[1]{\relax\ifmmode\hbox{\sout{\(#1\)}}\else \sout{#1}\fi}

\ifdiff
	\newcommand{\removed}[1]{{\color{red}{\soutsafe{#1}}}}
	\newcommand{\added}[1]{\highlight[green!25]{#1}}
\else
	\newcommand{\removed}[1]{}
	\newcommand{\added}[1]{#1}
\fi
% \changed[<old>]{<new>}
\newcommand{\changed}[2][]{%
	\refstepcounter{change}%
	\added{#2}{\ifx\relax#1\relax\empty\else\removed{#1}\fi}%
	\addcontentsline{ch}{change}{{%
		\ifx\relax#1\relax%
		{ \textbf{Added}: \added{\relax\ifmmode\(#2\)\else#2\fi} }%
		\else%
		{ \textbf{Changed}: \removed{#1} $\longrightarrow$ \added{\relax\ifmmode\(#2\)\else#2\fi} }%
		\fi}}%
}


% Final set up
\AtBeginDocument{%
	\hypersetup{
		pdftitle={\@title},
		pdfauthor={\@author}
	}
	
	\def\UrlBreaks{\do\/\do-}
}
