%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT CHANGE THIS FILE!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{bvm}[2022-12-02 v0.2.0 -- based on svmult by Springer Nature]


% Option - show article numbers as margingpar
\let\if@paperid\iffalse
\DeclareOption{paperid}{\let\if@paperid\iftrue}

% Opption - create toc entries
\let\if@autotoc\iffalse
\DeclareOption{autotoc}{\let\if@autotoc\iftrue}

% Opption - create toc entries
\let\if@hyperref\iftrue
\DeclareOption{nohyperref}{\let\if@hyperref\iffalse}

% other options are passed to article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[10pt,twoside]{article}  % base class


% Packages
\RequirePackage[latin1,utf8]{inputenc}
\RequirePackage[T1]{fontenc}

\RequirePackage[english,ngerman]{babel}
\RequirePackage{csquotes}
\RequirePackage[backend=biber, defernumbers=true, citestyle=numeric-comp, bibstyle=numeric]{biblatex} % Caution: Biber is casesensitive!

\RequirePackage{graphicx}

\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{amsxtra}

\RequirePackage{newtxtext} % selects Times Roman as basic font
\RequirePackage{newtxmath}
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}

\RequirePackage[labelfont=bf, labelsep=period, font=small]{caption}
\RequirePackage[font+=small]{subcaption} % for Subfigures, use subfigure enviroment
\RequirePackage[rightcaption]{sidecap}  % for SideCaption, use SCfigure or SCtable enviroment, use rightcaption to avoid a strange bug with babel and sidecap in a two-sided article

\RequirePackage[bottom]{footmisc}% places footnotes at page bottom

\RequirePackage{multicol}
\RequirePackage{multirow}

%\RequirePackage{eurosym} % Still usefull?

\RequirePackage{color}
\RequirePackage{tikz}
\usetikzlibrary{svg.path}
\definecolor{orcidlogocol}{HTML}{a6ce39}
\tikzset{
	orcidlogo/.pic={
		\fill[orcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
		\fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
								 svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
								 svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
	}
}
\newcommand{\@OrigHeightRecip}{0.00390625}
\newlength{\@curXheight}
\newcommand{\@preventExternalization}{%
\ifcsname tikz@library@external@loaded\endcsname%
\tikzset{external/export next=false}\else\fi%
}

\newcommand{\orcidlogo}{%
\texorpdfstring{%
\setlength{\@curXheight}{\fontcharht\font`X}%
\XeTeXLinkBox{%
\@preventExternalization%
\begin{tikzpicture}[yscale=-\@OrigHeightRecip*\@curXheight,
xscale=\@OrigHeightRecip*\@curXheight,transform shape]
\pic{orcidlogo};
\end{tikzpicture}%
}}{}}


\sloppy

% Toc settings
\if@autotoc
	\newcommand\chapter{} % needed to create chapter-toc
	\def\l@chapter{} % needed to create chapter-toc

	\RequirePackage{tocloft}
	\setlength{\cftchapnumwidth}{3em} % space between chapter number and text
	%\setlength{\emergencystretch}{1em} % erlaubt dem Kompiler mehr horizontalen Leerraum
	\renewcommand{\@tocrmarg}{60pt} %space between toc and right page end
	\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % dots in toc
	\renewcommand\cftchapfont{\mdseries}
	\renewcommand\cftchappagefont{\mdseries}
\fi

% Incude hyperref package as last!
\if@hyperref
	\RequirePackage[hidelinks]{hyperref}

	\newcommand{\bb}[1]{\textbf{\hyperpage{#1}}}
\else
	\newcommand{\bb}[1]{\textbf{#1}}
\fi

%Set pdf minor version to 1.7 to avoid warnings
\pdfminorversion=7

% If splitidx is not loaded define an empty sindex command, so an sindex entry does not prevent compilation
\AtBeginDocument{\@ifpackageloaded{splitidx}{}{\newcommand{\sindex}[2][]{}}}


% Shortcut for et al.
\newcommand{\etal}{et al.}

% Command for English quotes
\newcommand{\elqq}{``}%
\newcommand{\erqq}{''}%
\newcommand{\elq}{`}%
\newcommand{\erq}{'}%

\newcounter{equalContributionCounter}
\newcommand\equalContribution{% Command for equal contributions
	\renewcommand{\thefootnote}{$\dagger$}%
	\ifnum \value{equalContributionCounter}=0
		\footnote{These authors contributed equally to this work.}%
		\setcounter{equalContributionCounter}{1}%
	\else
		\footnotemark[1]%
	\fi
	\renewcommand{\thefootnote}{\arabic{footnote}}%
	\setcounter{footnote}{0}%
}

% Start Bibliogrphy settings
\ExecuteBibliographyOptions{
	sorting=none, % sorting
	giveninits=true, % first names as inits
	terseinits=true, % no dot or space in inits
	date=year, % format of date
	isbn=false, % show isbn
	eprint=false, % show eprint
	url=false, % show url
	doi=false % show doi
}
\AtBeginBibliography{
	\setcounter{maxnames}{6} % Maximum numbers of names shown
	\setcounter{minnames}{6} % Number of names shown if maxnames overrun
}
\DefineBibliographyExtras{english}{\def\finalandcomma{\empty}} % No comma before 'and' or 'et al'
% order of first an last name
\DeclareNameAlias{default}{family-given}
\DeclareNameAlias{sortname}{family-given}

\renewcommand*{\revsdnamepunct}{} % Remove comma between first and last name
\renewbibmacro*{in:}{} % Remove 'in:'
\DeclareFieldFormat*{title}{#1} % format for title
\DeclareFieldFormat*{journaltitle}{#1} % format for journaltitle
\DeclareFieldFormat*{booktitle}{#1} % format for booktitle
\renewcommand*{\subtitlepunct}{\addcolon\addspace} % punctation between title and subtitle
\renewcommand*{\finalnamedelim}{\addcomma\addspace} % Removes the 'and' between the last authors
\renewcommand*{\bibpagespunct}{\addcolon}
\DeclareFieldFormat{labelnumberwidth}{#1\adddot} % number format
\renewcommand{\bibfont}{\normalfont\small} % Font of References
\setlength{\biblabelsep}{2mm} % space between numbers and references
\setlength{\bibitemsep}{0pt} % space between references
\DeclareFieldFormat{pages}{\mkcomprange{#1}} % compresses pagenumbers
\DeclareFieldFormat*{number}{\mkbibparens{#1}} % number in brackets
\DeclareFieldFormat*{series}{\mkbibparens{#1}} % series in brackets

% Change date and volume order
\renewbibmacro*{journal+issuetitle}{%
	\usebibmacro{journal}%
	\setunit*{\adddot\addspace}%
	\usebibmacro{date}
	\iffieldundef{series}
	{\setunit*{\addsemicolon}}
	{\newunit
		\printfield{series}%
		\setunit{\addsemicolon}}%
	\usebibmacro{volume+number+eid}%
	%	\usebibmacro{issue}%
	\newunit}

% Change volume and number occurence
\renewbibmacro*{volume+number+eid}{%
	\printfield{volume}%
	%	\setunit*{\adddot}%
	\printfield{number}%
	%	\setunit{\addcomma\space}%
	%	\printfield{eid}
}

% Set all bibliographies to English
\let\printbib\printbibliography
\renewcommand{\printbibliography}{\selectlanguage{english}\printbib}


% new length to use in figures or tables
\newlength{\figwidth}
\setlength{\figwidth}{\textwidth}

\newcommand{\ts}{\unskip\,\ignorespaces} % Small space for units


% language selection
% use \selectlanguage{} with ngerman or english to change languages
\let\switcht@@therlang\relax
\def\ds@deutsch{\def\switcht@@therlang{\switcht@deutsch}}
%
\AtBeginDocument{\@ifundefined{url}{\def\url#1{#1}}{}%
	\@ifpackageloaded{babel}{%
		\@ifundefined{extrasamerican}{}{\addto\extrasamerican{\switcht@english}}%
		\@ifundefined{extrasaustralian}{}{\addto\extrasaustralian{\switcht@english}}%
		\@ifundefined{extrasbritish}{}{\addto\extrasbritish{\switcht@english}}%
		\@ifundefined{extrascanadian}{}{\addto\extrascanadian{\switcht@english}}%
		\@ifundefined{extrasenglish}{}{\addto\extrasenglish{\switcht@english}}%
		\@ifundefined{extrasnewzealand}{}{\addto\extrasnewzealand{\switcht@english}}%
		\@ifundefined{extrasUKenglish}{}{\addto\extrasUKenglish{\switcht@english}}%
		\@ifundefined{extrasUSenglish}{}{\addto\extrasUSenglish{\switcht@english}}%
		\@ifundefined{extrasgerman}{}{\addto\extrasgerman{\switcht@deutsch}}%
		\@ifundefined{extrasngerman}{}{\addto\extrasngerman{\switcht@deutsch}}%
	}{\switcht@@therlang}%
}


% defines various texts and their translations
%English section
\def\switcht@english{%
	\frenchspacing  % normal space after a period
	\def\abbrsymbname{List of Abbreviations and Symbols}%
	\def\abstractname{Abstract.}%
	\def\ackname{Acknowledgement.}%
	\def\disname{Disclaimer.}%
	\def\andname{and}%
	\def\bibname{References}%
	\def\lastandname{, and}%
	\def\appendixname{Appendix}%
	\def\chaptername{Chapter}%
	\def\claimname{Claim}%
	\def\conjecturename{Conjecture}%
	\def\contentsname{Contents}%
	\def\corollaryname{Corollary}%
	\def\definitionname{Definition}%
	\def\emailname{e-mail}%
	\def\examplename{Example}%
	\def\exercisename{Exercise}%
	\def\figurename{Fig.}%
	\def\forewordname{Foreword}%
	\def\keywordname{{\bf Key words:}}%
	\def\indexname{Index}%
	\def\lemmaname{Lemma}%
	\def\contriblistname{List of Contributors}%
	\def\listfigurename{List of Figures}%
	\def\listtablename{List of Tables}%
	\def\mailname{{\it Correspondence to\/}:}%
	\def\noteaddname{Note added in proof}%
	\def\notename{Note}%
	\def\partname{Part}%
	\def\prefacename{Preface}%
	\def\problemname{Problem}%
	\def\proofname{Proof}%
	\def\propertyname{Property}%
	\def\propositionname{Proposition}%
	\def\questionname{Question}%
	\def\refname{References}%
	\def\remarkname{Remark}%
	\def\seename{see}%
	\def\solutionname{Solution}%
	\def\subclassname{{\it Subject Classifications\/}:}%
	\def\tablename{Tab.}%
	\def\theoremname{Theorem}
	% Rename algorithmic command names
	\floatname{algorithm}{Alg.}
}
%
% German section
\def\switcht@deutsch{
	\frenchspacing  % normal space after a period
	\def\abbrsymbname{Abk\"urzungs- und Symbolverzeichnis}%
	\def\abstractname{Zusammenfassung.}%
	\def\ackname{Danksagung.}%
	\def\disname{Disclaimer.}% BVM - Disclaimer name
	\def\andname{und}%
	\def\lastandname{ und}%
	\def\appendixname{Anhang}%
	\def\bibname{Literaturverzeichnis}%
	\def\chaptername{Kapitel}%
	\def\claimname{Behauptung}%
	\def\conjecturename{Hypothese}%
	\def\contentsname{\begin{center}Inhaltsverzeichnis\end{center}}%
	\def\corollaryname{Korollar}%
	%\def\definitionname{Definition}%
	\def\emailname{E-mail}%
	\def\examplename{Beispiel}%
	\def\exercisename{\"Ubung}%
	\def\figurename{Abb.}%
	\def\forewordname{Geleitwort}%
	\def\keywordname{{\bf Schl\"usselw\"orter:}}%
	\def\indexname{Sachverzeichnis}%
	%\def\lemmaname{Lemma}%
	\def\contriblistname{Mitarbeiter}%
	\def\listfigurename{Abbildungsverzeichnis}%
	\def\listtablename{Tabellenverzeichnis}%
	\def\mailname{{\it Correspondence to\/}:}%
	\def\noteaddname{Nachtrag}%
	\def\notename{Anmerkung}%
	\def\partname{Teil}%
	\def\prefacename{Vorwort}%
	%\def\problemname{Problem}%
	\def\proofname{Beweis}%
	\def\propertyname{Eigenschaft}%
	%\def\propositionname{Proposition}%
	\def\questionname{Frage}%
	\def\refname{Literaturverzeichnis}%
	\def\remarkname{Anmerkung}%
	\def\seename{siehe}%
	\def\solutionname{L\"osung}%
	\def\subclassname{{\it Subject Classifications\/}:}%
	\def\tablename{Tab.}%
	%\def\theoremname{Theorem}%
	\floatname{algorithm}{Alg.}
	% \algrenewcommand\algorithmicwhile{\textbf{solange}}
}
\switcht@deutsch % default langeuage is German



% various sizes and settings for contributed works
\setlength{\textwidth}{117mm}
\setlength{\textheight}{191mm}
\setlength{\topmargin}{0cm}
\setlength\oddsidemargin{63\p@}
\setlength\evensidemargin{63\p@}
\setlength\marginparwidth{90\p@}
\setlength\headsep   {12\p@}

\setlength{\parskip}{\z@ \@plus \p@} % size of an paragraph
\setlength{\hfuzz}{2\p@}  % affects when a box is reported as overfull

\setlength{\arraycolsep}{1.4\p@} % size of array collums
\setlength{\tabcolsep}{1.4\p@}  % space bezween table collums

\setlength\arrayrulewidth{.5\p@} % line thickness

\tolerance=500  % Error/badness tolerance
\predisplaypenalty=0  % penalty for page break before displayed equation
\clubpenalty=10000  % penalty for single line on preceding page
\widowpenalty=10000 % penalty for single line on succeeding page

\setlength\footnotesep{7.7\p@}  % space between to footnotes

\newdimen\betweenumberspace          % dimension for space between
\betweenumberspace=10\p@              % number and text of titles
\newdimen\headlineindent             % dimension for space of
\headlineindent=2.5cc                % number and gap of running heads

\raggedbottom  % allows page break without stretching the page


% list settings
% labels of enumerate
\renewcommand\labelenumii{\theenumii.}
\renewcommand\theenumii{\@alph\c@enumii}

% labels of itemize
\renewcommand\labelitemi{\textbullet}
\renewcommand\labelitemii{\textendash}
\let\labelitemiii=\labelitemiv

% labels of description
\renewcommand*\descriptionlabel[1]{\hspace\labelsep #1\hfil}

% fixed indentation for standard itemize-environment
\newdimen\svitemindent \setlength{\svitemindent}{\parindent}

\setlength \labelsep     {5\p@}
\setlength\leftmargini   {17\p@}
\setlength\leftmargin    {\leftmargini}
\setlength\leftmarginii  {\leftmargini}
\setlength\leftmarginiii {\leftmargini}
\setlength\leftmarginiv  {\leftmargini}
\setlength\labelwidth    {\leftmargini}
\addtolength\labelwidth{-\labelsep}

\def\@listI{\leftmargin\leftmargini
	\parsep=\parskip
	\topsep=\medskipamount
	\itemsep=\parskip \advance\itemsep by -\parsep}
\let\@listi\@listI
\@listi

\def\@listii{\leftmargin\leftmarginii
	\labelwidth\leftmarginii
	\advance\labelwidth by -\labelsep
	\parsep=\parskip
	\topsep=6\p@
	\itemsep=\parskip
	\advance\itemsep by -\parsep}

\def\@listiii{\leftmargin\leftmarginiii
	\labelwidth\leftmarginiii\advance\labelwidth by -\labelsep
	\parsep=\parskip
	\topsep=\z@
	\itemsep=\parskip
	\advance\itemsep by -\parsep
	\partopsep=\topsep}



% redefine font sizes
\renewcommand\normalsize{%
	\@setfontsize\normalsize\@xpt\@xiipt
	\abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
	\abovedisplayshortskip \z@ \@plus3\p@
	\belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
	\belowdisplayskip \abovedisplayskip
	\let\@listi\@listI}
\normalsize

\renewcommand\small{%
	\@setfontsize\small\@ixpt{11}%
	\abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
	\abovedisplayshortskip \z@ \@plus2\p@
	\belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
	\def\@listi{\leftmargin\leftmargini
		\parsep 0\p@ \@plus1\p@ \@minus\p@
		\topsep 8\p@ \@plus2\p@ \@minus4\p@
		\itemsep0\p@}%
	\belowdisplayskip \abovedisplayskip
}

\renewcommand\Large{\@setfontsize\large{14}{16}}
\newcommand\LArge{\@setfontsize\Large{16}{18}}
\renewcommand\LARGE{\@setfontsize\LARGE{18}{20}}


% modification of automatic positioning of floating objects
\setlength\@fptop{\z@ }  % space between top of page and first float object
\setlength\@fpsep{12\p@ }  % space between two float objects
\setlength\@fpbot{\z@ \@plus 1fil } % space between bottom of page and first float object
\def\textfraction{0.01} % amout of space for floating objects
\def\floatpagefraction{0.8}
\setlength{\intextsep}{20\p@ \@plus 2\p@ \@minus 2\p@} % space between float object and runningtext above
\setlength\textfloatsep{24\p@ \@plus 2\p@ \@minus 4\p@} % space between float object and runningtext
\setcounter{topnumber}{4} % max number of float object at top of the page
\def\topfraction{.99} % amount of space at top of page allowed for float objects
\setcounter{bottomnumber}{3} % max number of float object at bottom of the page
\def\bottomfraction{.99} % amount of space at bottom of page allowed for float objects
\setcounter{totalnumber}{8} % max number of float object at the page

% figures and tables are processed in small print
\def \@floatboxreset {%
	\centering
	\reset@font
	\small
	\@setnobreak
	\@setminipage
}
\def\fps@figure{b} % default position of figures
\def\fps@table{t} % default position of tables
\def\fps@algorithm{t} % default position of algorithms

% sidecap settings
\renewenvironment{SCfigure}{\small\SC@float[t]{figure}}{\endSC@float}
\renewenvironment{SCfigure*}{\small\SC@dblfloat[t]{figure}}{\endSC@dblfloat}
\renewenvironment{SCtable}{\small\SC@float[t]{table}}{\endSC@float}
\renewenvironment{SCtable*}{\small\SC@dblfloat[t]{table}}{\endSC@dblfloat}

% command for alt texts
\newcommand{\altText}[1]{\ignorespaces}

% Algorithmic font size
\algrenewcommand\ALG@beginalgorithmic{
	\small
	\renewcommand\em{\bfseries}
}

% Caption settings for Agorithm and co
\DeclareCaptionStyle{ruled}{labelfont=bf,labelsep=space,strut=off,font=small}

% defines page breaks
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
			\hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi}

\newcommand{\clearemptydoublepage}{%
	\clearpage{\pagestyle{empty}\cleardoublepage}}

%\newcommand{\startnewpage}{\clearemptydoublepage}



% define page segments
\newcommand\frontmatter{
	\selectlanguage{ngerman}
	\clearemptydoublepage
	\pagenumbering{roman}
	\setcounter{page}{5}}
%
\newcommand\mainmatter{
	\clearemptydoublepage
	\markboth{}{}
	\pagenumbering{arabic}}
%
\newcommand\backmatter{%
	\selectlanguage{ngerman}
	\pagestyle{headings}%
	\clearemptydoublepage
}


% define sectioning
\setcounter{secnumdepth}{3} % depth of numbering (3 - until subsubsections)

\renewcommand\section{\@startsection{section}{1}{\z@}%
  {-18\p@ \@plus -4\p@ \@minus -4\p@}%
  {12\p@ \@plus 4\p@ \@minus 4\p@}%
  {\normalfont\large\bfseries\boldmath
	  \rightskip=\z@ \@plus 8em\pretolerance=10000 }}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
	{-18\p@ \@plus -4\p@ \@minus -4\p@}%
	{8\p@ \@plus 4\p@ \@minus 4\p@}%
	{\normalfont\normalsize\bfseries\boldmath
		\rightskip=\z@ \@plus 8em\pretolerance=10000 }}
\newcommand\bvmsubsubsection{\@startsection{subsubsection}{3}{\z@}%
	{-18\p@ \@plus -4\p@ \@minus -4\p@}%
	{-0.5em \@plus -0.22em \@minus -0.1em}%
	{\normalfont\normalsize\bfseries\boldmath}}
\renewcommand{\subsubsection}[1]{\bvmsubsubsection{#1.}}

\newcommand\bvmparagraph{\@startsection{paragraph}{4}{\z@}%
	{-12\p@ \@plus -4\p@ \@minus -4\p@}%
	{-0.5em \@plus -0.22em \@minus -0.1em}%
	{\normalfont\normalsize\itshape}}
\renewcommand{\paragraph}[1]{\bvmparagraph{#1.}}

\renewcommand\subparagraph[1]{\typeout{LLNCS warning: You should not use
		\string\subparagraph\space with this class}\vskip0.5cm
	You should not use \verb|\subparagraph| with this class.\vskip0.5cm}



%%%%%%%%%%%%%%%%%%%%%


% new title and subtitle size/style
\newcommand{\titlesize}{\Large}
\newcommand{\titlestyle}{\bfseries\boldmath}
\newcommand{\subtitlesize}{\large}
\newcommand{\subtitlestyle}{\bfseries\boldmath}

\newcommand{\partnumsize}{\LArge}
\newcommand{\partnumstyle}{\bfseries\boldmath}
\newcommand{\partsize}{\LARGE}
\newcommand{\partstyle}{\bfseries\boldmath}
\newcommand{\chapnumsize}{\Large}
\newcommand{\chapnumstyle}{\bfseries\boldmath}
\newcommand{\chapsize}{\LArge}
\newcommand{\chapstyle}{\bfseries\boldmath}
\newcommand{\chapauthsize}{\normalsize}
\newcommand{\chapauthstyle}{\bfseries\boldmath}
\newcommand{\mottosize}{\small}
\newcommand{\mottostyle}{\itshape\unboldmath\raggedright}
\newcommand{\secsize}{\large}
\newcommand{\secstyle}{\bfseries\boldmath}
\newcommand{\subsecsize}{\normalsize} % BVM
%\newcommand{\subsecsize}{\fontsize{11}{13}\selectfont}
\newcommand{\subsecstyle}{\bfseries\boldmath}
\newcommand{\subsubsecstyle}{\bfseries\boldmath}
%

%%%%%%%%%%%%%%%%%%%%%%%%%%



\setcounter{tocdepth}{0} % Depth of table of content

% Counters for Type in toc, do not reset in maketitle!
\newcounter{@V}  % Presentation (Vortrag)
\newcounter{@P}  % Poster
\newcounter{@S}  % Softwaredemonstration
\newcounter{@K}  % Keynote
\newcounter{@ERROR}


\newcounter{@inst}
\newcounter{@auth}
\newcounter{auco}
\newcounter{contribution}

% Due to the counter resets hyperreff gets confused and cannot differentiate between destinations with the same name
% So contribution as 'parent' counter is introduced and all counters are bind to it
% So a \stepcounter{contribution} sets all binded counters to 0 and hyperref uses the parent counter contribution for diffferiantion - I hope
\@addtoreset{section}{contribution}
\@addtoreset{figure}{contribution}
\@addtoreset{table}{contribution}
\@addtoreset{equation}{contribution}
\@addtoreset{footnote}{contribution}

\newdimen\instindent
\newbox\authrun
\newtoks\authorrunning
\newtoks\tocauthor
\newbox\titrun
\newtoks\titlerunning


\def\clearheadinfo{
\gdef\@author{No Author Given}
\global\authorrunning={No Authorrunning Given}% empty if optional
\gdef\@authorfortoc{}
\let\if@notoc\iffalse

\gdef\@title{No Title Given}
\gdef\@subtitle{}
\global\titlerunning={}
\gdef\@titlefortoc{}

\gdef\@institute{}
\gdef\@email{No Email Given}

\gdef\@type{ERROR}
\gdef\@typefortoc{}
\gdef\@paperid{No Paper Id Given}
}

% Style of institutes
\def\institutename{\par
	\begingroup
	\parskip=\z@
	\parindent=\z@
	\ignorespaces
	\@institute\par
	\endgroup}


% Define commands for maketitle
\def\title#1{\gdef\@title{#1}}
\def\subtitle#1{\gdef\@subtitle{#1}}

\def\institute#1{\gdef\@institute{#1}}
\def\email#1{\gdef\@email{#1}\ignorespaces}
\def\inst#1{\ignorespaces$^{#1}$\ignorespaces} % sets institute number
\def\fname#1{\ignorespaces#1\unskip\ignorespaces} % For firstname
\newcommand{\lname}[2][]{\ignorespaces~#2\ifthenelse{\equal{#1}{}}{}{\,\href{https://orcid.org/#1}{\orcidlogo}\,}\unskip\ignorespaces} % For lastname
\def\authorsEmail#1{\ignorespaces} % Email for publisher
\def\affiliation#1{\ignorespaces} % Affiliation for publisher
\def\street#1{\ignorespaces} % Street for publisher
\def\housenumber#1{\ignorespaces} % Housenumber for publisher
\def\zipcode#1{\ignorespaces} % Zip code for publisher
\def\city#1{\ignorespaces} % City for publisher
\def\country#1{\ignorespaces} % Country for publisher
\def\isResponsibleAuthor{\ignorespaces} % Corresponding author for publisher

\def\authorfortoc#1{\gdef\@authorfortoc{#1}} % Author displayed in toc
\def\titlefortoc#1{\gdef\@titlefortoc{#1}}  % Institutes displayed in toc
\def\typefortoc#1{\gdef\@typefortoc{#1}}  % Institutes displayed in toc

\def\notoc{\let\if@notoc\iftrue} % If true no toc entry will be generated

\def\paperid#1{\gdef\@paperid{#1}}  % Paper Id
\def\type#1{\gdef\@type{#1}} %Type of article - 'S', 'V' or 'P'


\clearheadinfo

% redefine maketitle
\renewcommand\maketitle{
	\par
	%\clearemptydoublepage  % Creates an ampty page if end on even page number
	\clearpage  % Creates just a new page

	\enlargethispage{-3\baselineskip} % Springer needs 4 lines space for source line

	\newrefsection % Begins a new reference/bibliography section

	% Commeted out: Counters got binded to contribution, so a \stepcounter{contribution} resets all counters
	%   % resets counter
	%   \setcounter{section}{0}%
	%   \setcounter{subsection}{0}%
	%   \setcounter{figure}{0}
	%   \setcounter{table}{0}
	%   \setcounter{equation}{0}
	%   \setcounter{footnote}{0}%

	\stepcounter{contribution}


	% try to be hyperref-compatible
	\csname phantomsection\endcsname
	\begingroup
	\parindent=\z@


	\newpage
	\global\@topnum\z@   % Prevents figures from going at top of page.
	\@maketitle
	%

	% Create an automated toc, but you can set \typefortoc, \titlefortoc or \authorfortoc for individual articles
	\if@autotoc
	\if@notoc
	\ClassWarningNoLine{bvm}{No toc entry for `\@title'}
	\else

	\if!\@titlefortoc!
	\def\@titlefortoc{
		\@title
		\if!\@subtitle!
		\else

		\unskip: \ignorespaces\@subtitle
		\fi
	}
	\fi

	\if!\@authorfortoc!
	\renewcommand{\inst}[1]{\unskip\ignorespaces} % hide numbers
	\renewcommand{\lname}[1]{\unskip\ ##1\ignorespaces} % Change protected to normal whitspace
	\def\@authorfortoc{\@author}
	\fi

	% sets article type and counter
	\if!\@typefortoc!
	\ifthenelse{\equal{\@type}{V}}{\stepcounter{@V}\def\@typefortoc{V\the@V}}
	{\ifthenelse{\equal{\@type}{P}}{\stepcounter{@P}\def\@typefortoc{P\the@P}}
		{\ifthenelse{\equal{\@type}{S}}{\stepcounter{@S}\def\@typefortoc{S\the@S}}
			{\ifthenelse{\equal{\@type}{K}}{\stepcounter{@K}\def\@typefortoc{K\the@K}}
				{\def\@typefortoc{ERROR}}}}}
	\fi

	\if@hyperref
	\if!\the\titlerunning!
	\edef\@pdfstring{\@title}
	\else
	\edef\@pdfstring{\the\titlerunning}%
	\fi
	% Add to toc
	\addcontentsline{toc}{chapter}{\texorpdfstring{\protect\numberline{\@typefortoc}\textit{\unskip\@authorfortoc}\newline\@titlefortoc\vspace{0.2cm}}{\@pdfstring}}
	\else
	\addcontentsline{toc}{chapter}{\protect\numberline{\@typefortoc}\textit{\unskip\@authorfortoc}\newline\@titlefortoc\vspace{0.2cm}}
	\fi



	\fi %notoc
	\fi %autotoc

	% sets the title as default runningtitle if empty
	% Must be empty in \clearheadinfo
	\if!\the\titlerunning!\else
	\edef\@title{\the\titlerunning}%
	\fi


	\instindent=0.7\hsize % max size of runningtitle and authorrunning
	\advance\instindent by-\headlineindent

	\global\setbox\titrun=\hbox{\small\rm\unboldmath\ignorespaces\@title}%

	%error if titlerunning is too long
	\ifdim\wd\titrun>\instindent
		\typeout{Title too long for running head. Please supply}%
		\typeout{a shorter form with \string\titlerunning\space prior to
			\string\maketitle}%
		\global\setbox\titrun=\hbox{\small\rm
			Title Suppressed Due to Excessive Length}%
	\fi
	\xdef\@title{\copy\titrun}%

	%error if authorrunning is too long
	\if!\the\authorrunning!
	\value{@inst}=\value{@auth}%
	\setcounter{@auth}{1}%
	\else
	\edef\@author{\the\authorrunning}%
	\fi
	\global\setbox\authrun=\hbox{\small\unboldmath\@author\unskip}%
	\ifdim\wd\authrun>\instindent
		\typeout{Names of authors too long for running head. Please supply}%
		\typeout{a shorter form with \string\authorrunning\space prior to
			\string\maketitle}%
		\global\setbox\authrun=\hbox{\small\rm
			Authors Suppressed Due to Excessive Length}%
	\fi
	\xdef\scratch{\copy\authrun}%
	\markboth{\scratch}{\@title}%
	\endgroup
	\@afterindentfalse\@afterheading
	\clearheadinfo
}


% Style of title pages
\def\@maketitle{\newpage
	\markboth{}{}%

	\centering
	%\thispagestyle{bchap} % sets page number to the bottom on tite page
	\thispagestyle{titlepage}

	%title
	{\pretolerance=10000  % no hyphenation in title
		\hyphenpenalty \@M
		\interlinepenalty \@M

		\let\\=\newline
		\centering
		\ignorespaces

		\Large
		\bfseries\boldmath
		\@title \par

		% prints paper id on the side if option selected
		\if@paperid
			\marginpar{\color{black}\centering\@paperid}
		\fi
	}

	\vskip .8cm

	% subtitle
	\if!\@subtitle!
	\else {
		\large
		\bfseries\boldmath
		\vskip -.65cm
		\pretolerance=10000
		\@subtitle \par}
	\vskip .8cm
	\fi

	%  \setbox0=\vbox{\setcounter{@auth}{1}
	%  \def\and{\stepcounter{@auth}}%
	%  \def\thanks##1{}\@author}%
	%  \global\value{@inst}=\value{@auth}%
	%  \global\value{auco}=\value{@auth}%
	%  \setcounter{@auth}{1}%

	% authors
	{\lineskip .5em
		\noindent
		\ignorespaces
		\@author
		\vskip.35cm}
	%institutes
	{\small\institutename}
	% email
	{\small\rm\unboldmath\ignorespaces\tt\@email}
	\vskip 2em

	% minimum space between email and running text
	% \ifdim\pagetotal>157\p@
	%     \vskip 11\p@
	% \else
	%     \@tempdima=168\p@\advance\@tempdima by-\pagetotal
	%     \vskip\@tempdima
	% \fi
}


% acknowledgement enviroment
\newenvironment{acknowledgement}{\par\addvspace{17\p@}
	\trivlist\item[\hskip\labelsep{\bfseries\ackname}]}
{\endtrivlist\addvspace{6\p@}}


% disclaimer enviroment
\newenvironment{disclaimer}{\par\addvspace{17\p@}
	\trivlist\item[\hskip\labelsep{\bfseries\disname}]}
{\endtrivlist\addvspace{6\p@}}

% redifines the abstract
\renewenvironment{abstract}{%
	\list{}{\advance\topsep by0.35cm\relax\small
		\leftmargin=1cm
		\labelwidth=\z@
		\listparindent=\z@
		\itemindent\listparindent
		\rightmargin\leftmargin}
	\item[\hskip\labelsep
	            \bfseries\abstractname]}
{\endlist\addvspace{6\p@}}



% define the running headings of a twoside text
\def\runheadsize{\small}
\def\runheadstyle{\rmfamily\upshape}
\def\customizhead{\hspace{\headlineindent}}

\def\ps@bchap{%\let\@mkboth\@gobbletwo
	\let\@oddhead\@empty\let\@evenhead\@empty
	\def\@oddfoot{\reset@font\small\hfil\thepage}%
	\let\@evenfoot\@oddfoot}

\def\ps@titlepage{
	\let\@oddhead\@empty
	\let\@evenhead\@empty
	\def\@oddfoot{}
	\def\@evenfoot{}
}

\def\ps@headings{\let\@mkboth\markboth
	\let\@oddfoot\@empty\let\@evenfoot\@empty
	\def\@evenhead{\runheadsize\runheadstyle\rlap{\thepage}\hfil
		\leftmark}
	\def\@oddhead{\runheadsize\runheadstyle\hspace{-\spaceLength}\rightmark\hfil
		\llap{\thepage}}
	\def\chaptermark##1{\markboth{{\ifnum\c@secnumdepth>\m@ne
						\thechapter\thechapterend\hskip\betweenumberspace\fi ##1}}{{\ifnum %!!!
						\c@secnumdepth>\m@ne\thechapter\thechapterend\hskip\betweenumberspace\fi ##1}}}%!!!
	\def\sectionmark##1{\markright{{\ifnum\c@secnumdepth>\z@
						\thesection\hskip\betweenumberspace\fi ##1}}}}

\def\ps@myheadings{\let\@mkboth\@gobbletwo
	\let\@oddfoot\@empty\let\@evenfoot\@empty
	\def\@evenhead{\runheadsize\runheadstyle\rlap{\thepage}\hfil
		\leftmark}
	\newlength{\spaceLength}
	\settowidth{\spaceLength}{ }
	\addtolength{\spaceLength}{.111111111em} % 1/9em = 2mu
	\def\@oddhead{\runheadsize\runheadstyle\hspace{-\spaceLength}\rightmark\hfil
		\llap{\thepage}}
	\let\chaptermark\@gobble
	\let\sectionmark\@gobble
	\let\subsectionmark\@gobble}

\ps@myheadings



\endinput
