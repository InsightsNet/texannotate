\newcommand\classname{styled}
\newcommand\lastmodifieddate{2004/07/05}
\newcommand\versionnumber{0.1}

\NeedsTeXFormat{LaTeX2e}[2000/06/01]
\ProvidesClass{ptephy_v1}

\setlength{\paperheight}{279truemm}
\setlength{\paperwidth}{216truemm}

\newif\if@numberedref \@numberedreftrue
\newif\if@endproofbox \@endproofboxtrue
\newif\ifcopyedit
\newif\ifunarticle
\newif\ifletterpaper
\newif\ifpreview
\newif\ifcolorfigs
\newif\ifendnotes
\newif\iffproof\fprooffalse %to make surname in magenta color
\newif\iffunding\fundingfalse % to make magenta color in funding text
\newif\ifnum@bib\num@bibtrue
\newif\iferratum
\newif\ifpteplogo
\newif\ifpreprint

\DeclareOption{erratum}{\erratumtrue}
\DeclareOption{letterpaper}{\letterpapertrue}
\DeclareOption{copyedit}{\copyedittrue}
\DeclareOption{preview}{\previewtrue}
\DeclareOption{draft}{\PassOptionsToPackage{draft}{graphicx}}
\DeclareOption{a3paper}{\PassOptionsToPackage{a3}{crop}}
\DeclareOption{centre}{\PassOptionsToPackage{center}{crop}}
\DeclareOption{info}{\PassOptionsToPackage{info}{crop}}
\DeclareOption{noinfo}{\PassOptionsToPackage{noinfo}{crop}}
\DeclareOption{numbered}{\global\@numberedreftrue}
\DeclareOption{named}{\global\@numberedreffalse}
\DeclareOption{noproofbox}{\global\@endproofboxfalse}
\DeclareOption{proofbox}{\global\@endproofboxtrue}
\DeclareOption{courier}{\def\verbatim@font{\normalfont\ttfamily}}
\DeclareOption{times}{\def\verbatim@font{\normalfont\rmfamily}}
\DeclareOption{bookreview}{\global\unarticletrue}
\DeclareOption{fproof}{\fprooftrue}
\DeclareOption{funding}{\fundingtrue}
\DeclareOption{endnotes}{\global\endnotestrue}
\DeclareOption{colorfigs}{\colorfigstrue}
\DeclareOption{numbib}{\num@bibtrue}
\DeclareOption{nonumbib}{\num@bibfalse}
\DeclareOption{pteplogo}{\pteplogotrue}
\DeclareOption{preprint}{\preprinttrue}
%\DeclareOption{preprint}{\InputIfFileExists{ptephy.clo}{\typeout{-----Reading ptephy.clo-----}}%
%{\ClassError{PTPTeX}{This class file needs the file named ``ptephy.clo'' in case the option `preprint' is specified.}{Please ensure the file is exist in proper location.}}}


\ExecuteOptions{a4paper,centre,info,proofbox}
%\ExecuteOptions{a4paper,centre,info,proofbox,dvipdfmx} % add by ysueno

\ProcessOptions

\RequirePackage{graphicx,array,amsthm,amsmath,amssymb,amsfonts,endnotes,rotating}
%\RequirePackage{array,amsthm,amsmath,amssymb,amsfonts,endnotes,rotating}  % add by ysueno


\ifendnotes
\RequirePackage{endnotes}
\let\footnote\endnote
\fi

\usepackage{multicol}

\usepackage{comment}
\usepackage{color}
\specialcomment{authorquery}{\begingroup\textcolor{red}}{\endgroup}

\newcommand\preprintnumber[2][30mm]{\gdef\@preprtnumwidth{#1}\gdef\@preprtnum{#2}}

% Not sure if needed.
\newcommand\@ptsize{0}

% Set twoside printing
\@twosidetrue

% Marginal notes are on the outside edge
\@mparswitchtrue

% Default font sizes
\def\normalsize{%
  \@setfontsize\normalsize{11\p@}{15\p@}%
  \abovedisplayskip 8\p@ \@plus 3\p@ \@minus4\p@
  \abovedisplayshortskip 2\p@ \@plus 3\p@ \@minus1\p@
  \belowdisplayshortskip 5\p@ \@plus 3\p@ \@minus2\p@
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI}
\normalsize
\let\@bls\baselineskip

\def\small{%
  \@setfontsize\small{9\p@}{11\p@}%
  \abovedisplayskip 6\p@ \@plus1\p@ \@minus1\p@
  \abovedisplayshortskip 3\p@ \@plus 2\p@ \@minus1\p@
  \belowdisplayshortskip 2\p@ \@plus 1\p@ \@minus1\p@
  \def\@listi{\leftmargin\leftmargini
              \listparindent \parindent
              \topsep 6\p@ \@plus2\p@ \@minus1\p@
              \parsep \z@ \itemsep \z@}%
  \belowdisplayskip \abovedisplayskip}

\def\footnotesize{%
 \@setfontsize\footnotesize{8\p@}{10\p@}%
  \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
  \abovedisplayshortskip \z@ \@plus \p@
  \belowdisplayshortskip 1\p@ \@plus2\p@ \@minus2\p@
  \def\@listi{\leftmargin\leftmargini
              \listparindent 1em
              \topsep 5\p@ \@plus 2\p@ \@minus 1\p@
              \parsep \z@ \itemsep \z@}%
  \belowdisplayskip \abovedisplayskip}

\def\scriptsize{\@setfontsize\scriptsize{7\p@}{9\p@}}
\def\tiny{\@setfontsize\tiny{6\p@}{7\p@}}
\def\little{\@setfontsize\little{5\p@}{6\p@}}
\def\large{\@setfontsize\large{12\p@}{14\p@}}
\def\Large{\@setfontsize\Large{14\p@}{16\p@}}
\def\LARGE{\@setfontsize\LARGE{16\p@}{18\p@}}
\def\huge{\@setfontsize\huge{24\p@}{26\p@}}
\def\Huge{\@setfontsize\Huge{25\p@}{27\p@}}

\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}

% Line spacing
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}

% Paragraph dimensions and inter-para spacing
\setlength\parskip{0\p@}
\setlength\parindent{9pt}

% Set inter-para skips
\setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
\setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}

% Page break penalties
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301

% Disallow widows and orphans
\clubpenalty 10000
\widowpenalty 10000

% Disable page breaks before equations, allow pagebreaks after
% equations and discourage widow lines before equations.
\displaywidowpenalty 100
\predisplaypenalty   10000
\postdisplaypenalty  2500

% Allow breaking the page in the middle of a paragraph
\interlinepenalty 0

% Disallow breaking the page after a hyphenated line
\brokenpenalty 10000

% Hyphenation; don't split words into less than three characters
\lefthyphenmin=3
\righthyphenmin=3

%
% Set page layout dimensions
%
\setlength\headheight{7\p@}          % height of running head
\setlength\topmargin{2.3pc}            % top margin 3pc, 9pt
\addtolength\topmargin{8\p@}         %
\addtolength\topmargin{-1in}         % subtract out the 1 inch driver margin
%% \addtolength\topmargin{-\headheight} %  and the running head

\setlength\topskip{8\p@}            % height of first line of text%% {10\p@}
\setlength\headsep{30\p@}          % space below running head --
\addtolength\headsep{-\topskip}      %   base to base with first line of text

\setlength\footskip{18\p@}           % space above footer line
\setlength\maxdepth{.5\topskip}      % pages can be short or deep by half a line?

\setlength\textwidth{36.4pc}%41.4           % text measure excluding margins
%\addtolength\textwidth{9.89\p@}      % -> textwidth of 30pc, 9.89pt!

\setlength\textheight{44\@bls}       % text height of 48pc,
\addtolength\textheight{\topskip}    %  - including first line of text

% Set the margins
\setlength\marginparsep{16\p@} \setlength\marginparpush{8\p@}
\setlength\marginparwidth{4.1pc}

\setlength\oddsidemargin{88pt}%
\addtolength\oddsidemargin{-1in}    % subtract out the 1 inch driver margin
\setlength\@tempdima{\paperwidth}
\addtolength\@tempdima{-\textwidth}
\addtolength\@tempdima{-88pt}
\setlength\evensidemargin{\@tempdima}
\addtolength\evensidemargin{-1in}

\setlength\columnsep{18\p@}          % space between columns for double-column text
\setlength\columnseprule{0\p@}      % width of rule between two columns

% Footnotes
\setlength\footnotesep{0\p@}     % space between footnotes
% space between text and footnote
\setlength{\skip\footins}{24\p@ \@plus 6\p@ \@minus 1\p@}

% Float placement parameters

% The total number of floats that can be allowed on a page.
\setcounter{totalnumber}{10}
% The maximum number of floats at the top and bottom of a page.
\setcounter{topnumber}{5}
\setcounter{bottomnumber}{5}
% The maximum part of the top or bottom of a text page that can be
% occupied by floats. This is set so that at least four lines of text
% fit on the page.
\renewcommand\topfraction{.921}
\renewcommand\bottomfraction{.921}
% The minimum amount of a text page that must be occupied by text.
% This should accomodate four lines of text.
\renewcommand\textfraction{.079}
% The minimum amount of a float page that must be occupied by floats.
\renewcommand\floatpagefraction{.887}

% The same parameters repeated for double column output
\renewcommand\dbltopfraction{.88}
\renewcommand\dblfloatpagefraction{.88}

% Space between floats
\setlength\floatsep    {18\p@ \@plus 2\p@ \@minus 2\p@}
% Space between floats and text
\setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
% Space above and below an inline figure
\setlength\intextsep   {18\p@ \@plus 2\p@ \@minus 2\p@}

% For double column floats
\setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}

% Space left at top, bottom and inbetween floats on a float page.
\setlength\@fptop{0\p@}         % no space above float page figures
\setlength\@fpsep{12\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}

% The same for double column
\setlength\@dblfptop{0\p@}
\setlength\@dblfpsep{12\p@ \@plus 1fil}
\setlength\@dblfpbot{0\p@ \@plus 2fil}

\AtEndDocument{%
\ifendnotes%
\theendnotes%
\fi%
   \message{Setting LastPage}%
   \clearpage\lastpage@putlabel%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Article Identification %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@default@journal@title{Journal Title}
\let\@journal@title\@default@journal@title
\def\month@info{Month~}
\def\artid@info{00000}
\def\year@info{\the\year}
\def\eyear@info{00}
\def\vol@info{00}
\def\issue@info{00}
\def\@print@issn{0000-0000}
\def\@online@issn{0000-0000}
\def\ceby@info{}
\def\qaby@info{}
\def\mcby@info{}
\newcommand{\page@extent@info}{%
  \thepage--\pageref{LastPage}}
\gdef\pap#1{\gdef\@pap{#1}}\pap{}

\newcommand{\totalpage}{%
  \pageref{LastPage}}

\gdef\doi@string{0000000000}

\def\@doi@fixed@field{}
\def\@doi@variable@field{00000000000000000000}

\gdef\backack#1{\gdef\@backack{#1}}\backack{}

% Article information user commands
\def\Year#1{\gdef\year@info{#1}}
\def\ErrYear#1{\gdef\eyear@info{#1}}
\def\Vol#1{\gdef\vol@info{#1}}
\def\Issue#1{\gdef\issue@info{#1}}
\def\Month#1{\gdef\month@info{#1}}
\def\artid#1{\gdef\artid@info{#1}}
\def\ceby#1{\gdef\ceby@info{#1}}
\def\qaby#1{\gdef\qaby@info{#1}}
\def\mcby#1{\gdef\mcby@info{#1}}
\newcommand\DOI[2][\@doi@fixed@field]{%
  \gdef\@doi@variable@field{#1}%
  \setDOI{#1}{#2}}
\newcommand{\setDOI}[2]{%
  \gdef\doi@string{#1#2}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% Page Styles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ps@titlepage{%
\vskip-1.9pt
  \addtolength\headsep{3pt}      %   base to base with first line of text
  \def\@evenfoot{}
 \def\@evenhead{\fontsize{10}{12}\selectfont \titlepageheadline}
 \def\@oddhead{\fontsize{10}{12}\selectfont \titlepageheadline}%
  \def\@oddfoot{\titlepagefootline}%%
  \def\authormark##1{\def\leftmark{##1}}%
  \def\titlemark##1{\markboth{##1}{##1}}}

\def\ps@headings{%
  \def\@oddfoot{\vbox{\vskip16pt\hbox to \textwidth{}
  \hbox to \textwidth{\fontsize{10}{12}\selectfont\hfill \thepage/\pageref{LastPage}\hfill}}}%
  \def\@evenfoot{\vbox{\vskip16pt\hbox to \textwidth{}
  \hbox to \textwidth{\fontsize{10}{12}\selectfont\hfill\thepage/\pageref{LastPage}\hfill}}}%
  \def\@oddhead{\let\etal=\tetal{\vbox{\hbox to \textwidth{{\fontsize{10}{12}\selectfont\rightmark\hfill}}\vskip2pt
  \hbox to \textwidth{\rule{\textwidth}{.5pt}}
  }}}%
  \def\@evenhead{\let\etal=\tetal{\vbox{\hbox to \textwidth{{\fontsize{10}{12}\selectfont\leftmark\hfill}}\vskip2pt
  \hbox to \textwidth{\rule{\textwidth}{.5pt}}
  }}}%
  \def\authormark##1{\def\leftmark{##1}}%
  \def\titlemark##1{\markboth{##1}{##1}}}

\def\ps@myheadings{%
  \let\@oddfoot\@empty%
  \let\@evenfoot\@empty%
  \def\@evenhead{\hfil}%
  \def\@oddhead{\hfil}%
  \def\authormark##1{\def\leftmark{##1}}%
  \def\titlemark##1{\markboth{##1}{##1}}}

\newcommand{\titlepageheadline}{%
  \vbox to 2\baselineskip{%
    \hbox to \textwidth{%
      {\raisebox{3.85pt}{\parbox{79.5\p@}{%
\hbox to 3.3pc{\vbox{\begin{minipage}[t]{2.5pc}\includegraphics[scale=0.40]{newlogo}\hspace*{1.5pc}\end{minipage}}}}}}
      \parbox{396\p@}{\hfill%                   <- textwidth minus logo width
  \fontsize{10}{12}\selectfont
        {Prog. Theor. Exp. Phys.} {\bf \year@info},\ \artid@info\ (\pageref{LastPage} pages)\ \\
        \hspace*{\fill} DOI: 10.1093$/$ptep/\doi@string}\\[-3.5pt]
}\vspace*{6.25pt}
\hbox to \textwidth{\rule{\textwidth}{.5pt}}
%\rule{\textwidth}{.5pt}
}}

\def\today{\number\day/\ifcase\month\or
 1\or 2\or 3\or 4\or 5\or 6\or 7\or 8\or 9\or 10\or 11\or 12\fi/\number\year}

\newcommand{\titlepagefootline}{%
  \fontsize{6.5}{8.5}\selectfont
  \vbox{\vspace*{12pt}
\hbox to 436.9pt{\hspace*{-1.9pt}\hspace*{-1.4pt}}
\hbox to \textwidth{$\copyright$ The Author(s) 2012. Published by Oxford University Press on behalf of the Physical Society of Japan.\hfill}
\hbox to \textwidth{This is an Open Access article distributed under the terms of the Creative Commons Attribution License\hfill}
\hbox to \textwidth{(http://creativecommons.org/licenses/by-nc/3.0), which permits unrestricted use,\hfill}
\hbox to \textwidth{distribution, and reproduction in any medium, provided the original work is properly cited.\hfill}
 \vspace*{12pt}}}

\setcounter{footnote}{1}
\renewcommand\thefootnote{\@fnsymbol\c@footnote}

% Counters
\newcounter{part}
\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\newcounter{refsection}[section]
\newcounter{acksection}[section]
\newcounter{scheme}

% Form of the numbers
\newcommand\thepage{\arabic{page}}
\renewcommand\thesection{\arabic{section}}
\renewcommand\thesubsection{{\thesection.\arabic{subsection}}}
\renewcommand\thesubsubsection{{\thesubsection.\arabic{subsubsection}}}
\renewcommand\theparagraph{\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph{\theparagraph.\arabic{subparagraph}}
\renewcommand\theequation{\arabic{equation}}

% Form of the words
\newcommand\contentsname{Contents}
\newcommand\guestname{GUEST EDITORS}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\refname{References}
\newcommand\bibname{{{References}}}
\newcommand\normsname{Norms}
\newcommand\indexname{Index}
\newcommand\schemename{Scheme}
\newcommand\tablename{Table}

% Clearemptydoublepage should really clear the running heads too
\newcommand{\clearemptydoublepage}{\newpage{\pagestyle{empty}\cleardoublepage}}

\def\and{\MakeLowercase{and}\space\ignorespaces}

% Ifs for titling commands
\newif\if@supertitle@provided \@supertitle@providedfalse
\newif\if@specialissue@provided \@specialissue@providedfalse
\newif\if@guesteditor@provided \@guesteditor@providedfalse
\newif\if@subtitle@provided \@subtitle@providedfalse
\newif\if@date@provided \@date@providedfalse
\newif\if@dedi@provided \@dedi@providedfalse
\newif\if@classification@provided \@classification@providedfalse
\newif\if@abstract@provided \@abstract@providedfalse %%5/7/2004
\newif\if@keywords@provided \@keywords@providedfalse
\newif\if@subjectindex@provided \@subjectindex@providedfalse

\def\keywordsname{Keywords}
\def\subindexname{Subject Index}

\def\address#1{\gdef\@address{#1}}\address{}
\def\author#1{\gdef\@author{#1}}\author{}
\def\date#1{\gdef\@date{#1}\global\@date@providedtrue}
\def\dedi#1{\def\@dedi{#1}\global\@dedi@providedtrue}
\def\keywords#1{\gdef\@keywords{#1}\global\@keywords@providedtrue}
\def\subjectindex#1{\gdef\@subjectindex{#1}\global\@subjectindex@providedtrue}
\def\subtitle#1{\def\@subtitle{{#1}}\global\@subtitle@providedtrue}
\def\supertitle#1{\def\@supertitle{{\noindent #1}}\global\@supertitle@providedtrue}
\def\specialissue#1{\def\@specialissue{{\noindent SPECIAL ISSUE:~#1}}\global\@specialissue@providedtrue}
\def\guesteditor#1{\def\@guesteditor{{\noindent \guestname:~#1}}\global\@guesteditor@providedtrue}
\def\@abbreviations{}
\def\@classification{}
\newcommand\classification[2][Jel Classification]{%
     \global\@classification@providedtrue
     \gdef\@classification{{\leftskip=2pc\rightskip=2pc \noindent\textit{#1}:\enskip #2\par}}}

\newbox\@abstractbox%
\newenvironment{abstract}{\leftskip=4.7pc\rightskip=0pc\global\@abstract@providedtrue%%% 5/7/2004
  \global\setbox\@abstractbox\vbox\bgroup\fontsize{10}{12}\selectfont%
  \@hangfrom{\@afterindentfalse\@afterheading}}{\par\egroup}%

\def\@fnsymbol#1{\ifcase#1\or *\or \dagger\or \ddagger\or
    \S\or \P\or \|\or **\or \dagger\dagger
    \or \ddagger\ddagger \else\@ctrerr\fi}


\mathchardef\Register="20AE%
\mathchardef\ter="099%
\def\titdagger{\hbox{$\dagger$}}
\def\titddagger{\hbox{$\ddagger$}}
\def\titS{\hbox{$\S$}}
\def\titP{\hbox{$\P$}}

%% Reimplement Titling Layout
\newcommand\maketitle{\par
   \begingroup
\renewcommand{\@fnsymbol}[1]{\ifcase##1\or \hbox{*}\or \titdagger\or \titddagger\or
    \titS\or \titP\or $\|$\or \hbox{**}\or \titdagger\titdagger
    \or \titddagger\titddagger \else\@ctrerr\fi}
    \thispagestyle{titlepage}%
    \setcounter{footnote}{1}
    \renewcommand\thefootnote{\textsuperscript{\@fnsymbol\c@footnote}}%
    \def\@makefnmark{\rm\@thefnmark}%
    \long\def\@makefntext##1{%\noindent
      {${\@thefnmark}$}{##1}}%
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
      \markboth{\@shortauthorlist}{\@shorttitle}
    \@thanks
  \endgroup
  \@afterindentfalse
  \@afterheading
  \setcounter{footnote}{0}%
  \global\let\maketitle\relax
  \global\let\@maketitle\relax}

\usepackage{authblk-TI}

\def\@maketitle{%
  \vspace*{2.5pt}%
\let\footnote\thanks
     \if@supertitle@provided%
 \vskip17pt
       {\fontfamily{\sfdefault}\fontsize{12}{14}\bfseries\selectfont\@supertitle\par%
 \vskip8pt}
    \else
       \vskip14pt%
     \fi
  \begingroup
    {\fontsize{20}{20}\fontseries{b}\selectfont\raggedright
      \mathversion{bold}%
      {\@title}%
      \par}%
     \if@subtitle@provided%
       \vspace{12.5\p@}%
       {\fontsize{12}{14}\fontseries{b}\selectfont\@subtitle\par
        %\vspace{1.5\p@}%
        }%
     \else
       \vspace{0\p@}%
%       \vspace{12.5\p@}%
     \fi
    \vspace{14pt}%
    {\fontsize{12}{14}\selectfont\raggedright
      \begingroup
      {\noindent\@author}%
    \vspace{6\p@}%
      \endgroup
      \par}%
    {\fontsize{10}{12}\fontshape{it}\selectfont\raggedright{\@address}\par}%
 \vspace{8\p@}%
     \if@date@provided%
         {\noindent\fontsize{9}{11}\fontshape{m}\selectfont{\@date\kern1pt}\par}%
\vspace{8.5\p@}%%
     \else
    \vspace{0\p@}%
     \fi
     \if@dedi@provided%
       {\fontsize{9}{10}\fontseries{rm}\selectfont{\@dedi}\par
        \vspace{18.25\p@}}%
     \else%
       \vspace{0\p@}%
     \fi%
\endgroup%
\if@abstract@provided%
    \vskip.1pt%
      {\hbox to 448.6pt{\hskip4.5pc\dotfill\hskip10pt}}\vskip3pt%
    {\fontsize{10}{12}\selectfont\noindent\unvbox\@abstractbox\par}%
    \vspace{1.5\p@}%
    \else%
       \vspace{0\p@}%
     \fi%
\if@subjectindex@provided%
\vspace*{-4.5pt}
      {\fontfamily{\sfdefault}\fontsize{9}{11}\selectfont\leftskip=4.7pc\parindent=0pt
      {\hbox to 448.6pt{\hskip4.5pc\dotfill\hskip10pt}}%
       \@hangfrom{{\begin{tabular}{@{}p{6pc}@{\hskip0.8pt}}{\subindexname}\end{tabular}}}\@subjectindex\par}\vspace*{-2pt}%
    \vspace{11\p@}%
\else%
       \vspace{0\p@}%
\fi%
    \if@classification@provided
      {\leftskip\z@\parfillskip=\z@ plus1fill%
        \fontsize{8}{9}\selectfont\@classification\par}%
    \fi
  \par
  \ifunarticle%
  \vspace{-.8pc plus 6\p@}%
  \else%
  \vspace{2pc plus 6\p@ minus 3\p@}%
  \fi\enlargethispage{-12pt}
 }
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lastpage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\lastpage@putlabel{\addtocounter{page}{-1}%
   \immediate\write\@auxout{\string
   \newlabel{LastPage}{{}{\thepage}}}%
   \addtocounter{page}{1}
   }
\AtEndDocument{%
   \message{Setting LastPage}%
   \clearpage\lastpage@putlabel}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% Sectioning macros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lowest level heading that takes a number by default
%\ifletterpaper
%\setcounter{secnumdepth}{0}
%\else
%\setcounter{secnumdepth}{3}
%\fi

\setcounter{secnumdepth}{3}

% Reset the default section macros to help with title casing
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M
% Modified to uppercase H1's and titlecase the rest
          \ifnum #2=1\relax
             {#8}%
          \else
            {#8}%
          \fi
        \@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec \ifletterpaper#8\else#8.\fi\quad}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

% H1
\ifletterpaper
\def\section{%
\renewcommand{\@seccntformat}[1]{{{\rm\csname the##1\endcsname.\quad}}}
  \@startsection{section}{1}{\z@}
  {-15\p@ plus -3\p@ minus -3\p@}{-0.0001\p@}
  {\reset@font\fontsize{12}{14}\selectfont\itshape\selectfont
    \mathversion{bold}\raggedright%\setcounter{thm}{0}%
}}
\else
\def\section{%
\renewcommand{\@seccntformat}[1]{{{\csname the##1\endcsname.\quad}}}
  \@startsection{section}{1}{\z@}
  {-15\p@ plus -3\p@ minus -3\p@}{3\p@}
  {\reset@font\fontsize{12}{14}\selectfont\fontseries{b}\selectfont
    \mathversion{bold}\raggedright%\setcounter{thm}{0}%
}}
\fi

\def\ssection{%
\renewcommand{\@seccntformat}[1]{{{\csname the##1\endcsname.\quad}}}
  \@startsection{section}{1}{\z@}
  {-15\p@ plus -3\p@ minus -3\p@}{10\p@}
  {\reset@font\fontsize{12}{14}\selectfont\fontseries{b}\selectfont
    \mathversion{bold}\raggedright%\setcounter{thm}{0}%
}}

% H2
\def\subsection{%
\renewcommand{\@seccntformat}[1]{{{\it\csname the##1\endcsname.\quad}}}
  \@startsection{subsection}{2}{\z@}
  {-16.5\p@ plus -1\p@ minus -2\p@}{2\p@}
  {\reset@font\fontsize{12}{14}\fontseries{m}\fontshape{it}\selectfont
    \raggedright}}

\def\ssubsection{%
\renewcommand{\@seccntformat}[1]{{{\csname the##1\endcsname.\quad}}}
  \@startsection{subsection}{2}{\z@}
  {-16.5\p@ plus -1\p@ minus -2\p@}{14\p@}
  {\reset@font\fontsize{10}{12}\fontseries{b}\fontshape{m}\selectfont
    \mathversion{bold}\raggedright}}

% H3
\def\subsubsection{%
\renewcommand{\@seccntformat}[1]{{{\csname the##1\endcsname.\quad}}}
  \@startsection{subsubsection}{3}{\z@}
  {-12\p@ plus -1\p@ minus -2\p@}{0.0001\z@}
  {\reset@font\fontsize{11}{15}\fontseries{m}\fontshape{it}\selectfont
    \raggedright}}

\def\paragraph{%
\renewcommand{\@seccntformat}[1]{{{\csname the##1\endcsname.\quad}}}
  \@startsection{paragraph}{4}{\z@}
  {-1\@bls plus -1\p@}{-1em}
  {\reset@font\normalfont\normalsize\itshape}}


 % H5
 \def\subparagraph{%
   \@startsection{subparagraph}{5}{\z@}
   {-12\p@ plus -1\p@}{-1em}
   {\indent\reset@font\normalfont\normalsize%\bfseries
   }}


\def\acksection{%
  \@startsection{section}{1}{\z@}
  {-15\p@ plus -2\p@ minus -1\p@}{6\p@}
  {\reset@font\fontsize{12}{14}\selectfont\fontseries{b}\selectfont
    \mathversion{bold}\raggedright}}

\def\refsection{%
  \@startsection{section}{1}{\z@}
  {-17\p@ plus -2\p@ minus -1\p@}{1.5001\p@}
  {\reset@font\fontsize{12}{14}\selectfont\fontseries{b}\selectfont
    \mathversion{bold}\raggedright}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Footnotes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\def\@makefnmark{\parindent1em%
%\@textsuperscript{\normalfont\@thefnmark}}%
\renewcommand{\thefootnote}{\arabic{footnote}}
\def\@makefnmark{$^{\@thefnmark}$}%


%\renewcommand\footnoterule{\setcounter{footnote}{0}\leftskip\z@\noindent
%  \rule{8pc}{0.5\p@}\vspace{4\p@}}

\ifunarticle
\renewcommand\footnoterule{}
\else
\renewcommand\footnoterule{\leftskip\z@\noindent
\rule{6pc}{.5pt}
\vspace{2.5\p@}}
\fi
\newcommand\@makefntext[1]{%
 \begingroup
    \leftskip=\z@\rightskip=\z@
    \fontsize{10}{12}\selectfont
    \setlength\parindent{1em}%
    \@makefnmark\ignorespaces\,#1%
  \endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From ifmtarg.sty
% Copyright Peter Wilson and Donald Arseneau, 2000
\begingroup
\catcode`\Q=3
\long\gdef\@ifmtarg#1{\@xifmtarg#1QQ\@secondoftwo\@firstoftwo\@nil}
\long\gdef\@xifmtarg#1#2Q#3#4#5\@nil{#4}
\long\gdef\@ifnotmtarg#1{\@xifmtarg#1QQ\@firstofone\@gobble\@nil}
\endgroup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% PostScript Rotation Macros %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@rotate \@rotatefalse
\newif\if@rotatecenter \@rotatecenterfalse
\def\rotatecenter{\global\@rotatecentertrue}
\def\rotateendcenter{\global\@rotatecenterfalse}
\def\rotate{\global\@rotatetrue}
\def\endrotate{\global\@rotatefalse}
\newdimen\rotdimen
\def\rotstart#1{\special{ps: gsave currentpoint currentpoint translate
    #1 neg exch neg exch translate}}
\def\rotfinish{\special{ps: currentpoint grestore moveto}}
\def\rotl#1{\rotdimen=\ht#1\advance\rotdimen by \dp#1
    \hbox to \rotdimen{\vbox to\wd#1{\vskip \wd#1
    \rotstart{270 rotate}\box #1\vss}\hss}\rotfinish}
\def\rotr#1{\rotdimen=\ht #1\advance\rotdimen by \dp#1
    \hbox to \rotdimen{\vbox to \wd#1{\vskip \wd#1
    \rotstart{90 rotate}\box #1\vss}\hss}\rotfinish}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ********************
% Figures and tables *
% ********************

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}

\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{4\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\newcommand\figurename{Fig.}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\textbf{#1}\hspace*{1em}#2}%
  \ifdim \wd\@tempboxa >\hsize
    \textbf{#1}\hspace*{1em} #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lists %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\labelenumi{{\rm(\arabic{enumi})}}
\def\theenumi{\arabic{enumi}}
\def\labelenumii{{\rm(\alph{enumii})}}
\def\theenumii{\alph{enumii}}
\def\p@enumii{\theenumi}
\def\labelenumiii{{\rm(\arabic{enumiii})}}
\def\theenumiii{\roman{enumiii}}
\def\p@enumiii{\theenumi(\theenumii)}
\def\labelenumiv{{\rm(\arabic{enumiv})}}
\def\theenumiv{\Alph{enumiv}}
\def\p@enumiv{\p@enumiii\theenumiii}
\def\labelitemi{$\circ$}
\def\labelitemii{$\bullet$}
\def\labelitemiii{$\bullet$}
\def\labelitemiv{$\bullet$}

\setlength{\leftmargini}{9pt}
\setlength{\leftmarginii}{\z@}
\setlength{\leftmarginiii}{\z@}
\setlength{\leftmarginiv}{\z@}

\def\enumargs{%
   \partopsep     \z@
   \itemsep       \z@
   \parsep        \z@
   \rightmargin   \z@
   \labelsep      0.5em
   \listparindent \parindent
   \itemindent    \z@}

\def\enumerate{%
    \@ifnextchar[{\@numerate}{\@numerate[(3)]}}

\def\@numerate[#1]{%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{\csname label\@enumctr\endcsname}{%
       \enumargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@listdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }
\def\endenumerate{\endlist\advance \@listdepth -1}

% Changes to the list parameters for itemize
\def\itemargs{%
   \partopsep     \z@
   \itemsep       \z@
   \parsep        \z@
   \rightmargin   \z@
   \labelsep      0.5em
   \listparindent \parindent
   \itemindent    \z@}

\def\itemize{%
    \@ifnextchar[{\@itemize}{\@itemize[$\bullet$]}}

\def\@itemize[#1]{%
     \ifnum \@itemdepth >3 \@toodeep\else
     \advance\@itemdepth \@ne
     \edef\@itemctr{item\romannumeral\the\@itemdepth}
     \list{\csname label\@itemctr\endcsname}{%
       \itemargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@listdepth\endcsname}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }
\let\enditemize\endlist

\setlength{\topsep}{6\p@}% \@plus 1\p@ \@minus 1\p@}
\setlength{\itemsep}{\z@}

\def\@listI{\leftmargin\leftmargini\topsep4\p@ plus 2\p@ minus 1\p@}
\let\@listi\@listI
\@listi
\def\@listii{\leftmargin\leftmarginii\topsep\z@}
\def\@listiii{\leftmargin\leftmarginiii\topsep\z@}
\def\@listiv{\leftmargin\leftmarginiv\topsep\z@}
\def\@listv{\leftmargin\leftmarginv\topsep\z@}
\def\@listvi{\leftmargin\leftmarginvi\topsep\z@}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% unnumbered list %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{description}{%
  \begin{list}{}{%
      \usecounter{enumi}%
      \setlength{\itemsep}{\z@}%
      \setlength{\labelwidth}{\z@}%
      \setlength{\leftmargin}{2em}%
      \setlength{\itemindent}{-2em}}}%
{\end{list}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Extracts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\quotation{\par\begin{list}{}{\footnotesize%  Extracts in small type
      \setlength{\topsep}{\medskipamount}%
      \setlength{\itemsep}{\z@}%
      \setlength\labelwidth{\z@}%
      \setlength\labelsep{\z@}%
      \setlength\leftmargin{12pt}%
      \setlength\rightmargin{12pt}%
      \listparindent \parindent}%
  \item[\vrule width\z@ height 9\p@]}
\def\endquotation{\end{list}}
\let\quote\quotation
\let\endquote\endquotation
\newcommand{\source}[1]{\newline\hbox{}{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\qedsymbol}{\ensuremath{\blacksquare}}
\renewenvironment{proof}[1][\proofname]{\par
  \if@endproofbox\pushQED{\qed}\fi%
  \normalfont
  \topsep\bigskipamount
  \labelsep=1em\relax
  \trivlist
  \item[\hskip\labelsep
        \itshape
    #1.]\ignorespaces
}{%
  \if@endproofbox\popQED\fi
  \endtrivlist\@endpefalse
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{thebibliography}[1]
     {\vbox{\vskip12pt\centering{\sc References}}
                  % \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
   \list{\ifnum@bib\@biblabel{\@arabic\c@enumiv}\fi}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
           \topsep3.5pt
            \fontsize{9}{11}\selectfont  
            \parsep0pt        
            \ifnum@bib
            \itemsep0pt
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
          \else
            \leftmargin18pt
            \listparindent -18pt%
                         \leftmargin 18pt
                         \itemindent    \listparindent
                        \rightmargin 0pt
                        \itemsep 1pt
            \fi
           \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m
      }
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist
     }
       
      
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty

% Counter for saving the section numbering depth
\newcounter{savesecnumdepth}

%%%%%%%%%%%%%%%%%%%%%%%%%% Acknowledgments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\ackname}{Acknowledgements}
\newcommand{\ack}[1][\ackname]{\fontsize{10}{12}\selectfont\par%
  \setcounter{savesecnumdepth}{\value{secnumdepth}}%
  \setcounter{secnumdepth}{0}%
  \acksection{#1}%
  \setcounter{secnumdepth}{\value{savesecnumdepth}}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Nomenclature %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\nomenname}{Nomenclature}
\newcommand{\nomen}[1][\nomenname]{%
  \setcounter{savesecnumdepth}{\value{secnumdepth}}%
  \setcounter{secnumdepth}{0}%
  \section{#1}%
  \setcounter{secnumdepth}{\value{savesecnumdepth}}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\enoteheading{\section*{\notesname
  \@mkboth{\uppercase{\notesname}}{\uppercase{\notesname}}}%
     \leavevmode\par}

\def\enoteformat{\rightskip\z@ \leftskip=16pt\parindent=0pt
     \leavevmode\llap{\hbox{${\@theenmark}$}.\enskip}}


\newenvironment{notes}[1][99]{%
  \begingroup%
 }%
{\endgroup}%

\ifnum@bib
\usepackage[sort&compress]{natbib}
\bibpunct{[}{]}{,}{n}{,}{;}
\else
\usepackage{natbib}
\bibpunct{(}{)}{;}{a}{,}{,}
\def\@biblabel#1{}
\fi

\renewenvironment{thebibliography}[1]
     {\vbox{\vskip12pt{\noindent\bf References}}
   \list{\ifnum@bib\@biblabel{\@arabic\c@enumiv}\fi}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
           \topsep3.5pt
            \fontsize{9}{11}\selectfont  
            \parsep0pt        
            \ifnum@bib
            \itemsep0pt
            \leftmargin\labelwidth
                  \setlength{\labelsep}{0.7em}%%chgd. 1em to 0.5em on 21/7/2004 -- devi
            \advance\leftmargin\labelsep
          \else
            \leftmargin18pt
            \listparindent -18pt%
                         \leftmargin 18pt
                         \itemindent    \listparindent
                        \rightmargin 0pt
                        \itemsep 1pt
            \fi
           \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m
      }
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist
     }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  NORMES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newskip\normskip
\setlength\normskip{6pt}

\newenvironment{normes}{%
  \begingroup
  \footnotesize\parindent=0pt
  \setcounter{secnumdepth}{0}
  \vskip\normskip
  {\fontsize{10}{12}\selectfont\bf\normsname}%
  \begin{list}{}{%
      \usecounter{enumi}%
      \setlength{\itemsep}{\z@}%
      \setlength{\labelwidth}{0pt}%
      \setlength{\leftmargin}{2em}%
      \setlength{\itemindent}{-2em}}}%
{\end{list}\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@restonecol
\def\theindex{\@mainmatterfalse
  \@restonecoltrue\if@twocolumn\@restonecolfalse\fi
  \begingroup\parindent \z@
  \addcontentsline{toc}{section}{Index}
  \columnseprule \z@
  \columnsep 1pc\section*{\indexname} %Subject or Author here
  \parskip\z@ plus .3\p@\relax\let\item\idxitem\fontsize{8\p@}{10\p@}\selectfont}
\def\idxitem{\par\raggedright\hangindent 3em}
\def\subitem{\par\penalty1000\raggedright\hangindent 3em\hspace*{1em}}
\def\subsubitem{\par\penalty1000\raggedright\hangindent 3em\hspace*{2em}}
\def\endtheindex{\if@restonecol\endgroup\onecolumn\else\clearpage\fi}
\def\indexspace{\par \vskip 18\p@ plus 12\p@ minus 12\p@\relax}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Appendix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifappend % Are we in the Appendix?
\def\appendix{%
\normalsize\selectfont\par%
  \setcounter{secnumdepth}{3}
\renewcommand{\thesection}{\Alph{section}}
\numberwithin{equation}{section}
\numberwithin{figure}{section}
\numberwithin{table}{section}
\def\theequation{\Alph{section}\@arabic\c@equation}
\def\thetable{\Alph{section}\@arabic\c@table}
\def\thefigure{\Alph{section}\@arabic\c@figure}
        \setcounter{section}{0}
        \setcounter{table}{0}
        \setcounter{figure}{0}
        \setcounter{equation}{0}
        \setcounter{subsection}{0}
        \appendtrue}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Override settings in MathTime back to TeX defaults
\DeclareMathSizes{5}     {5}   {5}  {5}
\DeclareMathSizes{6}     {6}   {5}  {5}
\DeclareMathSizes{7}     {7}   {5}  {5}
\DeclareMathSizes{8}     {8}   {6}  {5}
\DeclareMathSizes{9}     {9}   {7}  {5}
\DeclareMathSizes{10}   {10}   {7}  {5}
\DeclareMathSizes{12}   {12}   {9}  {7}

%Math parameters
\setlength{\jot}{5\p@}
\skip\@mpfootins = \skip\footins
\fboxsep=6\p@
\fboxrule=.25\p@

\medmuskip=4mu% plus 2mu minus 4mu
\thickmuskip=5mu% plus 5mu

\vbadness=9999
\tolerance=9999
\doublehyphendemerits=10000
\doublehyphendemerits 640000
\finalhyphendemerits  1000000

\flushbottom
\frenchspacing
\onecolumn
\pagestyle{headings}

% Author queries
\fboxsep=4\p@
\fboxrule=0.5\p@

% Short-form coding
\newcommand\tetal{{{\rm et~al.}}}
\newcommand\etal{\textit{et~al.}}
\newcommand\eg{\textit{e.g.}}
\newcommand\ie{\textit{i.e.}}
\let\endash\textendash

\def\dbond{\raise0.18ex\hbox{$=$}}
\def\bond{\raise0.18ex\hbox{$-$}}

\def\endash{--}
\def\emdash{\,--\,}
\def\sdot#1{{\buildrel{\scriptscriptstyle\bullet}\over{\hbox{$#1$}}}}
\def\ssdot#1{{\buildrel{\scriptscriptstyle\bullet\bullet}\over{\hbox{$#1$}}}}


\hyphenation{Table}
\hyphenation{Figure}
\hyphenation{Section}
\hyphenation{equation}
\hyphenation{Theorem}
\hyphenation{Lemma}
\hyphenation{Algorithm}
\hyphenation{Definition}
\hyphenation{Corollary}
\hyphenation{Proof}
\hyphenation{Remark}

\newcommand\@pnumwidth{13.5pt}
\newcommand\@dotsep{15}
\newcommand\@tocrmarg {3pt}
\setcounter{tocdepth}{3}

\def\@dottedtocline#1#2#3#4#5{% FROM LATEX.LTX
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg %\parfillskip -\rightskip
     \parfillskip -2.5pt% to give 20pt \rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\hskip -\leftskip
     {#4}\nobreak
     \leaders\hbox{}\hfill
     \nobreak
     {#5}%
     \par}%
  \fi
}

\def \twocolumn {%
  \global\columnwidth\textwidth
  \global\advance\columnwidth-\columnsep
  \global\divide\columnwidth\tw@
  \global\hsize\columnwidth
  \global\linewidth\columnwidth
  \global\@twocolumntrue
  \global\@firstcolumntrue
  \col@number \tw@
  \@ifnextchar [\@topnewpage\@floatplacement
}

\def\tocspace#1{\vphantom{\vrule height#1 width0pt}}

\newcommand\tableofcontents{%\setbox4=\hbox to \textwidth{%
  \@restonecoltrue
 \hsize\textwidth
  \section*{\hspace*{\fill}\centering Contents\hspace*{\fill}{\textsc{PAGE}\hspace*{23.5pt}}}%
  \@starttoc{toc}%
%  \if@restonecol\twocolumn\fi
  \par\addvspace{18\p@}}

\newcommand\guidetableofcontents{%
  \@restonecolfalse
  \if@twocolumn\@restonecoltrue\onecolumn\fi
  \section*{\contentsname\\[0.5\baselineskip]
    \footnotesize\textit{Note that authors are not asked to include a
    table of contents in their articles.\\ This is for reference only.}}%
  \@starttoc{toc}%
  \if@restonecol\twocolumn\fi
  \par\addvspace{\full@line}%
}

\newcommand*\l@part[2]{%
  \addpenalty{-\@highpenalty}%
  \addvspace{\baselineskip}%
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \rightskip=33.5pt%
    {\small\normalfont\rmfamily
     \leavevmode
     \hspace*{33.5pt}%
     {\rm #1}\hfil \hb@xt@\@pnumwidth{\hss {\rm #2}}}\par
     \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
  \endgroup
}

\newcommand*\l@section[2]{%
  \addpenalty{\@secpenalty}%
  \@tempdima 17.5pt% (equiv 1.5em at 9pt)
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \normalfont\rmfamily\leavevmode
    \advance\leftskip\@tempdima
    \leftskip=23pt\rightskip=35.5pt% added 24-jul-02
    #1\hfill{#2}\par
      \endgroup
}

\newcommand*\l@subsection[2]{%
  \addpenalty{\@secpenalty}%
  \@tempdima 28.5pt% (equiv 1.5em at 9pt)
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \normalfont\rmfamily\leavevmode
    \advance\leftskip\@tempdima
    \leftskip=3.2pc\rightskip=35.5pt% added 24-jul-02
    #1\hfill{#2}\par
      \endgroup
}

\newcommand*\l@subsubsection[2]{%
  \addpenalty{\@secpenalty}%
  \@tempdima 32.5pt% (equiv 1.5em at 9pt)
  \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    \normalfont\rmfamily\leavevmode
    \advance\leftskip\@tempdima
  %  \hskip -\leftskip
    \leftskip=5.5pc\rightskip=35.5pt% added 24-jul-02
    #1\hfill{#2}\par
      \endgroup
}

\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}

\newenvironment{tabenumerate}[1][10pc]{
\begin{minipage}[t]{#1}
\begin{enumerate}
}{\end{enumerate}
\end{minipage}}

\def\email#1{{\par $^{\ast}$E-mail: #1}}

\newenvironment{tabitemize}[1][10pc]{
\begin{minipage}[t]{#1}
\begin{itemize}
}{\end{itemize}
\end{minipage}}

\Year{2015}

\def\shortauthorlist#1{\gdef\@shortauthorlist{\uppercase{#1}}}
\let\@shortauthorlist\@empty
\def\shorttitle#1{\gdef\@shorttitle{\uppercase{#1}}}
\let\@shorttitle\@empty

%%%%%%%%%%%%%%%%%%%%%% Macros from PTPTEX %%%%%%%%%%%%%%%%%%%%
\newcommand\tocite[1]{$^{\hbox{--}}$\cite{#1}}%\cite{xx}\tocite{yy}
\def\halftext{.471\textwidth}
\def\@JLone<#1,#2>{#1}
\def\@JLtwo<#1,#2,#3>{#2}
\def\@JLyear<#1,#2,#3,#4>{#3}
\def\@JLpage<#1,#2,#3,#4>{#4}
\newcommand\JL[1]{\@JLone<#1>\ {\bfseries \@JLtwo<#1>}, \@JLyear<#1> (\@JLpage<#1>)}
\def\@Jpage<#1,#2,#3>{#3}
\newcommand\andvol[1]{{\bfseries \@JLone<#1>}, \@JLtwo<#1> (\@Jpage<#1>).}
\newcommand\PTP[1]{Prog.\ Theor.\ Phys.,\ \andvol{#1}}
\newcommand\PTPS[1]{Prog.\ Theor.\ Phys. Suppl.,\ \andvol{#1}} %%Modified by TD 12/06/14
\newcommand\JPSJ[1]{J.~Phys.\ Soc.\ Jpn.,\ \andvol{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\PR[1]{Phys.\ Rev.,\ \andvol{#1}}%Maybe deleted in future version
\newcommand\PRA[1]{Phys.\ Rev.\ A,\ \andvol{#1}}
\newcommand\PRB[1]{Phys.\ Rev.\ B,\ \andvol{#1}}
\newcommand\PRC[1]{Phys.\ Rev.\ C,\ \andvol{#1}}
\newcommand\PRD[1]{Phys.\ Rev.\ D,\ \andvol{#1}}
\newcommand\PRE[1]{Phys.\ Rev.\ E,\ \andvol{#1}}
\newcommand\PRX[1]{Phys.\ Rev.\ X,\ \andvol{#1}} %%Added by TD 12/06/14
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\PRL[1]{Phys.\ Rev.\ Lett.,\ \andvol{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\RMP[1]{Rev.\ Mod.\ Phys.,\ \andvol{#1}} %%Added by TD 12/06/14
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\PL[1]{Phys.\ Lett.,\ \andvol{#1}}%Maybe deleted in future version
\newcommand\PLA[1]{Phys.\ Lett.\ A,\ \andvol{#1}}
\newcommand\PLB[1]{Phys.\ Lett.\ B,\ \andvol{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\NP[1]{Nucl.\ Phys.,\ \andvol{#1}}%Maybe deleted in future version
\newcommand\NPA[1]{Nucl.\ Phys.\ A,\ \andvol{#1}}
\newcommand\NPB[1]{Nucl.\ Phys.\ B,\ \andvol{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\JMP[1]{J.~Math.\ Phys.,\ \andvol{#1}}
\newcommand\JMPNY[1]{J.~Math.\ Phys.\ (N.Y.),\ \andvol{#1}} %%Added by TD 12/06/14
\newcommand\JMPCA[1]{J.~Math.\ Phys.\ (Cambridge, Mass.),\ \andvol{#1}} %%Added by TD 12/06/14
\newcommand\IJMP[1]{Int.\ J.~Mod.\ Phys.,\ \andvol{#1}}
\newcommand\CMP[1]{Commun.\ Math.\ Phys.,\ \andvol{#1}}
\newcommand\JP[1]{J.~Phys.,\ \andvol{#1}} %%Modified by TD 12/06/14
\newcommand\JPA[1]{J.~Phys.\ A,\ \andvol{#1}} %%Added by TD 12/06/14
\newcommand\JPG[1]{J.~Phys.\ G,\ \andvol{#1}} %%Added by TD 12/06/14
\newcommand\JPCM[1]{J.~Phys.:\ Condens.\ Matter, \andvol{#1}} %%Added by TD 12/06/14
\newcommand\ANN[1]{Ann.\ Phys.,\ \andvol{#1}} %%Added by TD 12/06/14
\newcommand\ANNB[1]{Ann.\ Phys.\ (Berlin), \andvol{#1}} %%Added by TD 12/06/14
\newcommand\ANNNY[1]{Ann. Phys.\ (N.Y.), \andvol{#1}} %%Added by TD 12/06/14
\newcommand\NC[1]{Nuovo Cimento,\ \andvol{#1}} %%Modified by TD 12/06/14
%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\AJ[1]{Astrophys. J.,\ \andvol{#1}}
\newcommand\PRP[1]{Phys. Rep.,\ \andvol{#1}}
\newcommand\JHEP[1]{J. High Energy Phys.,\ \andvol{#1}}
\mark{{}{}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\name#1#2{#1$^{#2}$}

%\def\affil#1#2{$^{#1}$#2\par}

\def\fname#1{#1}
\def\surname#1{#1}
\def\midname#1{#1}
\def\collaborator#1{\textbf{#1}\par}

\newcommand{\PTPTeX}{\raisebox{-.2ex}{$\mathcal P$}\kern-.05em{$\mathcal T$}\kern-.18em\raisebox{-.2ex}{$\mathcal P$}\kern-.03em\TeX}
\newcommand{\@typeset}{typeset using \PTPTeX.cls}

\iferratum
\parindent0pt
\def\supertitle#1{\def\@supertitle{{\noindent{\sf\textbf{Erratum}: Prog. Theor. Exp. Phys. \textbf{\eyear@info}, #1}}}\global\@supertitle@providedtrue}
\Year{20xx}
\ErrYear{20xx}
\fi

\ifpreprint
\input preprint_v1.clo
\fi

\endinput
