%% Elseiver Document Class for Major Reference Works (MRWs) -- version 0.1 (21-July-2023)
%%
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{els-mrws}[07/21/202 v1.0]% A class file for Elsevier MRWs
\edef\ELSVER{07/21/202 v1.0}

\newif\if@openright   \@openrighttrue
\newif\if@mainmatter  \@mainmattertrue
\newif\if@NumberedChapter\global\@NumberedChapterfalse
\newif\if@spellout    \@spelloutfalse
\newif\if@final       \@finalfalse%
\newif\if@altmathv     \@altmathvfalse
\gdef\@stageid{printer}

\DeclareOption{proof}{\gdef\@stageid{proof}}
\DeclareOption{revises}{\gdef\@stageid{revises}}
\DeclareOption{NumberedChapter}{\global\@NumberedChaptertrue}
\DeclareOption{final}{\gdef\@stageid{final}}
\DeclareOption{authoryear}{\xdef\@biboptions{round,authoryear}}
\DeclareOption{number}{\xdef\@biboptions{numbers}}
\DeclareOption{numbers}{\xdef\@biboptions{numbers}}
\DeclareOption{super}{\xdef\@biboptions{numbers,super}}
\DeclareOption{altmathv}{\global\@altmathvtrue}

\ExecuteOptions{a4paper,10pt,twoside}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}

\@ifundefined{@biboptions}{\xdef\@biboptions{numbers}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MAIN ELEMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newif\if@frontmatter\@frontmatterfalse
\newif\if@mainmatter \@mainmatterfalse
\newif\if@backmatter \@backmatterfalse

\newcommand\Frontmatter{\cleardoublepage
            \@frontmattertrue\@mainmatterfalse\@backmatterfalse\pagenumbering{roman}}
%
\newcommand\Mainmatter{\addtocontents{toc}{\vskip\tocfmsep}\cleardoublepage
       \@frontmatterfalse\@mainmattertrue\@backmatterfalse\pagenumbering{arabic}}
%
\newcommand\Backmatter{\addtocontents{toc}{\vskip\tocbmsep}\cleardoublepage\@frontmatterfalse\@mainmatterfalse\@backmattertrue}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPENERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
\newcommand*{\@noindent@fpara}{%
  \everypar{{\setbox\z@\lastbox}\everypar{}}}
%
\newenvironment{frontmatter}{}{\gdef\elsauthors{}\gdef\elsaddress{}\gdef\@subtitle{}\ \aftergroup\@noindent@fpara\par\addvspace{2\baselineskip}}
%
\newcounter {chapter}
\newcounter {subsubparagraph}[subparagraph]
\newcounter {subsubsubparagraph}[subsubparagraph]
\@addtoreset{section}{chapter}
\@addtoreset{subsection}{section}
\@addtoreset{subsubsection}{subsection}
\@addtoreset{paragraph}{subsubsection}
\@addtoreset{subparagraph}{paragraph}
\@addtoreset{subsubparagraph}{subparagraph}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\elsauthors{}
\def\elsaddress{}

%% Article Author(s)
\let\ausep\@empty%
\let\authorsep\@empty%
\newcount\aucount%
\def\au@and{\nobreak, }%
\newif\if@auemail%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHAPTER Opener %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newcommand\@chapapp{\chaptername}
%
\global\@twosidetrue
\def\cleardoublepage{\clearpage\if@twoside  \ifodd\c@page\else
    \thispagestyle{empty}\hbox{}\newpage\if@twocolumn\thispagestyle{empty}\hbox{}\newpage\fi\fi\fi}%
%
\def\@chaptertitle{}
%
\newcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi%
                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}

\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                    \if@mainmatter
                        \refstepcounter{chapter}%
                        \typeout{\@chapapp\space\thechapter.}%
                        \addcontentsline{toc}{chapter}%
                        {\protect\numberline{\thechapter}#1}%
                    \else
                         \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \gdef\@chaptertitle{#2}}

\def\@schapter#1{\gdef\@chaptertitle{#1}}

\RequirePackage{color}
\definecolor{graysixty}{cmyk}{0,0,0,0.6}
\definecolor{graytwenty}{cmyk}{0,0,0,0.2}
\def\chapternamefont{\fontfamily{\sfdefault}\fontsize{16}{16}\bfseries\selectfont}
\def\chaptertitlefont{\fontfamily{\sfdefault}\fontsize{14}{16}\bfseries\selectfont}
\def\chapterauthorfont{\fontfamily{\sfdefault}\fontsize{9}{11}\selectfont\bfseries}
\def\chapteraffilfont{\fontfamily{\sfdefault}\fontsize{9}{11}\selectfont}
\def\copyrightfont{\fontfamily{\sfdefault}\fontsize{8}{11}\selectfont}

\def\articlecopyright{\textcopyright\ 20xx Elsevier Ltd. All rights reserved.}
\gdef\@articletag{}
\def\articletag#1{\gdef\@articletag{#1}}%

\def\@makechapterhead#1{%
  {\parindent \z@ \raggedright
  \normalfont
%     \ifnum \c@secnumdepth >\m@ne
%       \if@mainmatter
%         \vskip4pt%
%         \hbox{\chapternamefont{\MakeUppercase{\@chapapp}}\hskip6pt{\thechapter}}
%       \fi
%     \fi
  \vglue-5mm  \@dochapfootnote%
    \interlinepenalty\@M
    {\chaptertitlefont\if@NumberedChapter\thechapter\quad\fi#1\par\nobreak}
%    \ifx\@subtitle\@empty\else
%    \vskip3pt
%    {\chaptersubtitlefont\@subtitle\par}
%    \fi
    \global\punctcount\aucount
    \@doaufootnote%
    \ifx\elsauthors\@empty\else
    \vskip6\p@
    {\chapterauthorfont\elsauthors\par}
    \vskip1pt%
    {\chapteraffilfont\elsaddress\par}
    \vskip6pt%
    {\copyrightfont\articlecopyright\par}
    {\copyrightfont\@articletag\par}
    \fi
    \vspace*{20\p@}%
  }}


\def\@makeschapterhead#1{\protect\phantomsection%
  {\parindent \z@ \raggedright
    \normalfont
    \@dochapfootnote%
        \interlinepenalty\@M
    \vskip0pt%
    {\chapternamefont{\MakeUppercase{#1}\par}}
    \xdef\contentcheck{#1}%
    \thispagestyle{fmbmplain}%
    \markboth{#1}{#1}%
    \ifx\contentcheck\contentsname\else\addcontentsline{toc}{fmbmchapter}{#1}\fi% For toc entry
    \ifx\@subtitle\@empty\else\vskip20pt{\large\@subtitle\par}\fi
    \global\punctcount\aucount
    \ifx\elsauthors\@empty\else
    %\vskip10pt%
    \normalsize\elsauthors\par
    \footnotesize\itshape\elsaddress\par
    \fi
    }}


\renewcommand\maketitle{\xdef\@insertpag##1##2{##2}\@afterindentfalse%
                                     \if@twocolumn
                       \twocolumn[\@makechapterhead{\@chaptertitle}]%
                     \else
                       \@makechapterhead{\@chaptertitle}%
                     \fi\@afterheading
                \setcounter{footnote}{0}%
                \gdef\thefootnote{\arabic{footnote}}%
                \@afterheading}


%%%%%%%%%%%%%%%% Subtitle

\def\@subtitle{}
\def\subtitle#1{\gdef\@subtitle{#1}}


%%%%%%%%%%%%%%%% Authors & Affiliations

\newif\ifcorrauthor\global\corrauthorfalse

%% Cross Link for Author & Address
\def\jmkLabel#1{\@bsphack\protected@write\@auxout{}{\string\Newlabel{#1}{\@currentlabel}}\@esphack}
\def\Newlabel#1#2{\expandafter\xdef\csname X@#1\endcsname{#2}}
\def\jmkRef#1{\@ifundefined{X@#1}{0}{\csname X@#1\endcsname}}

%% Article Author(s)
\let\ausep\@empty%
\let\authorsep\@empty%
\newcount\aucount%
\def\author{\advance\aucount by 1\@ifstar{\protect\g@addto@macro\elsauthors{\protect\global\corrauthortrue}\@@corrauthor}{\protect\g@addto@macro\elsauthors{\protect\global\corrauthorfalse}\@@author}}%
\newcount\punctcount%
\def\au@and{\ifnum\punctcount=2\ and \else\unskip, \advance\punctcount by -1 \fi}%
\newif\if@auemail%

\def\affilnumbering#1{%
  \gdef\theaulink{\csname @#1\endcsname\c@aulink}% for author number
  \gdef\theafflink{\csname @#1\endcsname\c@afflink}% for address number
   }

\def\@dochapfootnote{}
\def\chapfootnotenumbering#1{%
  \gdef\@dochapfootnote{\setcounter{footnote}{0}\def\thefootnote{\csname @#1\endcsname\c@footnote}% for author number
   }}

\def\@doaufootnote{}
\def\aufootnotenumbering#1{%
  \gdef\@doaufootnote{%
  \let\oldfootnote\footnote%
  \def\footnote{\gdef\@authfoot{yes}\oldfootnote}%
  \setcounter{footnote}{0}\def\thefootnote{\csname @#1\endcsname\c@footnote}% for author number
   }}

\def\@currauthornumbering{}
\def\currauthornumbering#1{%
\gdef\@currauthornumbering{\csname @#1\endcsname}%
}%

\newcounter{aulink}
\affilnumbering{alph}

\newcommand{\@@author}[2][]{\g@addto@macro\elsauthors{%
    \ifnum\aucount=1%
    \global\@auemailtrue%
    \else%
    \global\@auemailfalse%
    \fi%
    \def\baselinestretch{1}%
    \authorsep{#2}\ifx\@authfoot\@empty\else\textsuperscript{,}\def\@authfoot{}\fi\unskip\ifx#1\empty\else\textsuperscript{\smash{{%
      \@for\@@affmark:=#1\do{\edef\affnum{\@ifundefined{X@\@@affmark}{1}{\jmkRef{\@@affmark}}}%
    \unskip\ausep\setcounter{aulink}{\affnum}\theaulink\let\ausep=,}}}}\fi%
    \def\authorsep{\au@and}%%%
    \global\let\ausep\@empty\global\let\@corref\@empty%
}}%

\newcommand{\@@corrauthor}[2][]{\g@addto@macro\elsauthors{%
    \global\@auemailtrue%
    \def\baselinestretch{1}%
    \authorsep{#2}\ifx\@authfoot\@empty\else\textsuperscript{,}\def\@authfoot{}\fi\textsuperscript{\@currauthornumbering{1},}\unskip\ifx#1\empty\else\textsuperscript{\smash{{%
      \@for\@@affmark:=#1\do{\edef\affnum{\@ifundefined{X@\@@affmark}{1}{\jmkRef{\@@affmark}}}%
    \unskip\ausep\setcounter{aulink}{\affnum}\theaulink\let\ausep=,}}}}\fi%
    \def\authorsep{\au@and}%%%
    \global\let\ausep\@empty\global\let\@corref\@empty%
}}%

\long\def\@mpfootnotetext#1{%
  \global\setbox\@mpfootins\vbox{%
    \unvbox\@mpfootins
    \reset@font\footnotesize
    \hsize\columnwidth
    \@parboxrestore
    \protected@edef\@currentlabel
         {\csname p@mpfootnote\endcsname\@thefnmark}%
    \color@begingroup
      \@makefntext{%
        \rule\z@\footnotesep\ignorespaces%
        \renewcommand{\source}[1]{##1}%
        #1\@finalstrut\strutbox}%
    \color@endgroup}}

\def\@corthanks{}
\def\auaddress{}

\newcounter{affn}
\renewcommand\theaffn{\arabic{affn}}
\def\address{\@ifstar\@@coraddress\@@address}
\newcount\addcount% To check the count of address

\newcounter{afflink}
\newcommand{\@@address}[2][]{%
%\advance\addcount by 1%
     \stepcounter{affn}%
     \setcounter{afflink}{#1}%
     \xdef\@currentlabel{\theaffn}%
     \jmkLabel{\theaffn}%
\protected@xdef\elsaddress{%
\elsaddress\protect\par{{%
     \ifx#1\@empty\else\textsuperscript{\theafflink}\fi\noindent #2}}
}}%

\newcommand{\@@coraddress}[2][]{%
{%
     \stepcounter{affn}%
     \setcounter{afflink}{#1}%
     \xdef\@currentlabel{\theaffn}%
     \jmkLabel{\theaffn}%
    \protected@xdef\elsaddress{%
    \elsaddress\protect\par{%
    \ifx#1\@empty\else\textsuperscript{\@currauthornumbering{1}}\hskip.25em\fi\noindent #2}}
}}%

\def\orgdiv#1{#1}%
\def\orgname#1{#1}%
\def\orgaddress#1{#1}%

\gdef\email#1{\texttt{#1}}

%%%%%%%%%%%%%%%% Abstract and Keyword for web (non-print)

\def\abstractfont{\small\selectfont}
\def\abstractheadfont{\fontfamily{\sfdefault}\fontsize{9}{10}\leftskip9mm\selectfont}
\renewenvironment{abstract}[1][\abstractname:]{\removelastskip\vskip12pt%
\def\abstracthead##1{\noindent\vbox{\parindent=0pt\abstractheadfont\textbf{##1 }\par}}%
\par%
\abstracthead{#1}
\vskip5.5pt%
\abstractfont\parindent0pt\leftskip9mm\rightskip9mm}
 {\par\addvspace{\baselineskip}}
%
\newenvironment{keywords}[1][\keywordname:]{%
\def\keywordhead##1{\noindent\textbf{##1 }}
\def\sep{\unskip, }%
\par\addvspace{\baselineskip}%
\abstractfont\raggedright\keywordhead{\abstractheadfont#1}}{\par\addvspace{\baselineskip}}

%%%%%%%%%%%%%%% Quote

\def\quotefont{\fontfamily{\rmdefault}\fontsize{7}{9}\selectfont}



\renewenvironment{quote}%
               {
               \def\quotehead##1{\vbox{\parindent=0pt\leftskip=12pt\rightskip=12pt\textbf{##1 }\par}}
               %
               \list{}{\leftmargin12pt\rightmargin12pt\topsep=13.5pt\partopsep=0pt\parsep=0pt\itemsep=0pt}%
                \item\relax\quotefont}
               {\endlist}

\newcommand{\source}[1]{\par \hfill\textbf{\textit{#1}}\par}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LISTS


\def\listfont{}%

\def\enumargs{%
   \listfont%
   \leftmargini0pt%
   \leftmarginii0pt%
   \leftmarginiii0pt%
   \topsep0pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      7pt%
   \rightmargin   \z@%
   %\raggedright%
   \listparindent \parindent%
   \itemindent    \z@}%

\def\enumerate{%
    \@ifnextchar[{\@numerate}{\@numerate[0.]}}

\def\@numerate[#1]{\par%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{\csname label\@enumctr\endcsname}{%
       \enumargs%
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@enumdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss\llap{\textnormal{\textbf{##1}}}}}%
     \fi
   }
\let\endenumerate\endlist

%%Unnumbered list%%
\def\unenumargs{%
   \listfont%
   \leftmargini15pt%
   \leftmarginii15pt%
   \topsep0pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      0em%
   \rightmargin   \z@%
   %\raggedright%
   \listparindent \parindent%
   \itemindent    0pt}%

\def\unenumerate{%
    \@ifnextchar[{\@unenumerate}{\@unenumerate[]}}

\def\@unenumerate[#1]{\par%
     \ifnum \@enumdepth >3 \@toodeep\else
     \advance\@enumdepth \@ne
     \edef\@enumctr{enum\romannumeral\the\@enumdepth}
     \list{}{%
       \unenumargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@enumdepth\endcsname}
       \usecounter{\@enumctr}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss\llap{##1}}}%
     \fi
   }%
\let\endunenumerate\endlist%
%
\def\itemargs{%
   \listfont%
   \leftmargini-1pt%
   \leftmarginii-1pt%
   \leftmarginiii-1pt%
   \topsep0pt%
   \partopsep     \z@%
   \itemsep       \z@%
   \parsep        \z@%
   \labelsep      10pt%
   \rightmargin   \z@%
   %\raggedright%
   \listparindent \parindent%
   \itemindent    \z@}%
%
\def\itemize{%
   \@ifnextchar[{\@itemize}{\@itemize[$\bullet$]}}
%
\def\@itemize[#1]{\par%
     \ifnum \@itemdepth >3 \@toodeep\else
     \advance\@itemdepth \@ne
     \edef\@itemctr{item\romannumeral\the\@itemdepth}
     \list{\csname label\@itemctr\endcsname}{%
       \itemargs
       \setlength{\leftmargin}{\csname leftmargin\romannumeral\the\@itemdepth\endcsname}
       \settowidth\labelwidth{#1}
       \addtolength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
       \def\makelabel##1{\hss \llap{##1}}}%
     \fi
   }%
\let\enditemize\endlist

\renewenvironment{description}
               {\list{}{\leftmargin\parindent\labelwidth\z@ \itemindent-\leftmargin
                        \itemsep=0pt%
                        \partopsep=0pt%
                        \parsep=0pt%
                        \topsep=0pt%
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\renewcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries#1}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIGURE & TABLES

\usepackage[figuresright]{rotating}%
\RequirePackage{threeparttable}
%\RequirePackage{floatpag}
\RequirePackage{dblfloatfix}
\renewcommand\dbltopfraction{.88}
\renewcommand\dblfloatpagefraction{.88}
\setlength\dblfloatsep    {20\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{15\p@ \@plus 4\p@ \@minus 2\p@}

\RequirePackage{booktabs}
\RequirePackage{url}

\def\captionnumfont{\fontfamily{\sfdefault}\fontsize{8}{10}\bfseries\selectfont}
\def\captionfont{\fontfamily{\sfdefault}\fontsize{8}{10}\selectfont}

\setlength\abovecaptionskip{3.5\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\captionfont#1\hskip.5em#2}%
  \ifdim \wd\@tempboxa >\hsize
    {\captionnumfont #1}{\captionfont\hskip.5em#2\par}
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\box\@tempboxa}%
  \fi
  \vskip\belowcaptionskip}


\def\TPTtagStyle{\textit}
\def\tablebodyfont{\fontfamily{\sfdefault}\fontsize{8}{10}\selectfont}
\def\TCHfont{\reset@font\fontfamily{\sfdefault}\fontsize{8}{10}\selectfont\itshape}
\def\tablefootfont{\fontfamily{\sfdefault}\fontsize{7.5}{10}\raggedright\selectfont}

\long\def\TBL#1#2#3{%
\let\footnotemark\tnote%
\renewcommand\footnotetext[2][]{\tablefootfont\leftskip=-15pt\labelsep=0pt\ifx##1\empty\item[]##2\else\item[]\textsuperscript{##1}##2\fi}
\renewcommand{\source}[1]{\bgroup\tablefootfont\parindent=0pt\textit{Source: ##1}\egroup}
\begin{threeparttable}%
\tablebodyfont%
#1#2#3
\end{threeparttable}}

\newenvironment{TBL*}{%
\let\footnotemark\tnote%
\renewcommand\footnotetext[2][]{\tablefootfont\ifx##1\empty\item[]##2\else\item[##1]##2\fi}%
\renewcommand{\source}[1]{\textit{Source: ##1}}%
\begin{threeparttable}\tablebodyfont}{\end{threeparttable}}

\newcommand{\TCH}[1]{{\TCHfont#1}}%

\heavyrulewidth=.5pt
\lightrulewidth=.5pt
\cmidrulewidth=.5pt
\abovetopsep=-1pt
\aboverulesep=2.8pt
\belowrulesep=4pt
\belowbottomsep=2pt
%
\def\toprule{\noalign{\ifnum0=`}\fi
  \@aboverulesep=\abovetopsep
  \global\@belowrulesep=4pt%
  \global\@thisruleclass=\@ne
  \@ifnextchar[{\@BTrule}{\@BTrule[\heavyrulewidth]}}
%
\def\colrule{\noalign{\ifnum0=`}\fi
  \@aboverulesep=2pt
  \global\@belowrulesep=\belowrulesep
  \global\@thisruleclass=\@ne
  \@ifnextchar[{\@BTrule}{\@BTrule[\lightrulewidth]}}
\def\botrule{\noalign{\ifnum0=`}\fi
  \@aboverulesep=\aboverulesep
  \global\@belowrulesep=\belowbottomsep
  \global\@thisruleclass=\@ne
  \@ifnextchar[{\@BTrule}{\@BTrule[\heavyrulewidth]}}
%
\def\colhdrule{\noalign{\ifnum0=`}\fi
  \@aboverulesep=0.11pt
  \global\@belowrulesep=0pt %global cos for use in the next noalign
  \global\@thisruleclass=\@ne
  \@ifnextchar[{\@BTrule}{\@BTrule[1pt]}}
%
\def\colhdendrule{\noalign{\ifnum0=`}\fi
  \@aboverulesep=0pt
  \global\@belowrulesep=0pt %global cos for use in the next noalign
  \global\@thisruleclass=\@ne
  \@ifnextchar[{\@BTrule}{\@BTrule[1.2pt]}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOXES

\def\BoxTypeAfont{\fontfamily{\rmdefault}\fontsize{7}{9}\selectfont\parskip=0pt}
\newenvironment{BoxTypeA}[2][]
{\par\addvspace{12pt plus2pt}%
\def\@xfloat##1[{\@ifnextchar{H}{\@float@HH{##1}[}{\@float@Hx{##1}[}}%% reinstate float.sty macro (over floatpag)
\gdef\@envopt{#1}%
\BoxTypeAfont%
\def\boxsectionfont{\fontfamily{\rmdefault}\fontsize{7}{9}\bfseries\selectfont}
\def\boxsubsectionfont{\fontfamily{\rmdefault}\fontsize{7}{9}\bfseries\itshape\selectfont}
\def\boxsubsubsectionfont{\fontfamily{\rmdefault}\fontsize{7}{9}\bfseries\itshape\selectfont}
\def\boxsection{\@startsection {section}{1}{\z@}%
                                   {-6pt \@plus -2pt}%
                                   {0.001pt}%
                                   {\boxsectionfont}}
\def\boxsubsection{\@startsection{subsection}{2}{\z@}%
                                     {-3pt \@plus -2pt}%
                                     {0.001pt}%
                                     {\boxsubsectionfont}}
\def\boxsubsubsection{\@startsection{paragraph}{3}{\z@}%
                                    {-3pt}%
                                    {-1em}%
                                    {\boxsubsubsectionfont}}
\def\boxparagraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\itshape}}
\let\section\boxsection
\let\subsection\boxsubsection
\let\subsubsection\boxsubsubsection
\let\paragraph\boxparagraph
\ifx\@envopt\empty\begin{BoxA*}{#2}\else\begin{BoxA}[#1]{#2}\fi}
{\ifx\@envopt\empty\end{BoxA*}\else\end{BoxA}\fi\@endparenv}

\RequirePackage{framed}
\definecolor{shadecolor}{gray}{.85}%
\newcounter{box}

\newenvironment{myshade}{%
    \def\FrameCommand{\colorbox{shadecolor}}%
    \MakeFramed {\advance\hsize-\width\FrameRestore\@setminipage}}%
   {\par\unskip\endMakeFramed}
%
\def\boxcaptionfont{\fontfamily{\rmdefault}\fontsize{7}{9}\bfseries\selectfont\raggedright}
\def\boxcaptionnumfont{\fontfamily{\rmdefault}\fontsize{7}{9}\bfseries\selectfont\raggedright}
%
\newenvironment{BoxA}[2][]%
       {\fboxsep=12pt\relax
        \begin{myshade}%
        \ifx#1\@empty\else\refstepcounter{box}\label{#1}\fi
        \ifx#2\@empty\else \noindent{%\boxcaptionnumfont
\boxcaptionfont{#2\par}\nointerlineskip}\fi
        \list{}{\leftmargin0pt\listparindent=12pt\rightmargin=\leftmargin\parskip=0pt\parsep=0pt\topsep=\z@\relax}%
        \expandafter\item%
        \hskip-\listparindent}%
       {\endlist\end{myshade}}%

\@namedef{BoxA*}{\BoxA}
\@namedef{endBoxA*}{\endBoxA}


%%%%%%% TE Type A

\def\TETypeAfont{\fontfamily{\rmdefault}\fontsize{10}{12}\selectfont\leftskip\parindent\rightskip\parindent}
\newenvironment{TETypeA}[2][]{\par
\def\@xfloat##1[{\@ifnextchar{H}{\@float@HH{##1}[}{\@float@Hx{##1}[}}%% reinstate float.sty macro (over floatpag)
\gdef\@TEenvopt{#1}%
\TETypeAfont%
\def\boxsectionfont{\fontfamily{\sfdefault}\fontsize{7}{9}\bfseries\selectfont}
\def\boxsubsectionfont{\fontfamily{\sfdefault}\fontsize{7}{9}\bfseries\itshape\selectfont}
\def\boxsubsubsectionfont{\fontfamily{\sfdefault}\fontsize{7}{9}\bfseries\itshape\selectfont}
\def\boxsection{\@startsection {section}{1}{\z@}%
                                   {-6pt \@plus -2pt}%
                                   {0.001pt}%
                                   {\boxsectionfont}}
\def\boxsubsection{\@startsection{subsection}{2}{\z@}%
                                     {-3pt \@plus -2pt}%
                                     {0.001pt}%
                                     {\boxsubsectionfont}}
\def\boxsubsubsection{\@startsection{paragraph}{3}{\z@}%
                                    {0.001pt}%
                                    {-1em}%
                                    {\boxsubsubsectionfont}}
\def\boxparagraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\itshape}}
\let\section\boxsection
\let\subsection\boxsubsection
\let\subsubsection\boxsubsubsection
\let\paragraph\boxparagraph
\ifx\@TEenvopt\empty\begin{TEXTTypeA*}{#2}\else\begin{TEXTTypeA}[#1]{#2}\fi}
{\ifx\@TEenvopt\empty\end{TEXTTypeA*}\else\end{TEXTTypeA}\fi}

\newcounter{textbox}
\def\textcaptionnumfont{\fontfamily{\sfdefault}\fontsize{11}{13.5pt}\bfseries\selectfont}
\def\textcaptionfont{\fontfamily{\sfdefault}\fontsize{11}{13.5pt}\bfseries\selectfont}

\newenvironment{TEXTTypeA}[2][]
{\par\addvspace{17pt plus2pt}%
\ifx#1\@empty\else\refstepcounter{textbox}\label{#1}\fi%
\noindent\ifx#2\@empty\else\subsection*{\raise15pt\hbox{\rlap{\hskip-\parindent\rule{\textwidth}{3pt}}}\reset@font\textcaptionnumfont{\thetextbox}\textcaptionfont{\hskip.5em#2}}\fi%
}%
{\par\nobreak\noindent\hskip-\parindent\rule{\textwidth}{1pt}\par\addvspace{12pt}}

\@namedef{TEXTTypeA*}{\TEXTTypeA}
\@namedef{endTEXTTypeA*}{\endTEXTTypeA}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Additional macros

\RequirePackage{appendix}
\newenvironment{backmatter}{}{}

%%%%%%%%%%%% Glossary
\def\glossaryfont{\fontsize{8.5}{11}\selectfont}
\newenvironment{glossaryA}[1][\glossaryhead]
               {\begingroup\glossaryfont\ifx#1\empty\else\section*{#1}\fi\par%
               \leftskip=9pt\rightskip=9pt\raggedright}
               {\endgroup}

\def\term#1{\noindent{\bfseries #1}}


%%%%%%%%%%%% Acknowledgement

\def\ackfont{\fontsize{9}{11}\selectfont}
\newenvironment{ack}[2][\acknowledgmenthead]%
{\ackfont\ifx#1\empty\else\section*{#1}\fi\par}
{\par}


%%%%%%%%%%%% Addresses

\newenvironment{addresses}%
{\par\def\address##1{\par\noindent ##1\par\addvspace{12pt}}}
{\par}

%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bibliography %%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[\@biboptions,sectionbib]{natbib}
\def\bibfont{\fontfamily{\sfdefault}\sf\fontsize{7.5}{9}\selectfont}
%%\def\@biblabel#1{#1.}  %% Commented to align number
\bibsep=0pt

\@ifpackageloaded{natbib}{%
\@namedef{thebibliography*}{\thebibliography}
\@namedef{endthebibliography*}{\endthebibliography}
}
{
\@namedef{thebibliography*}{\thebibliography}
\@namedef{endthebibliography*}{\endthebibliography}
}

  \renewcommand\bibsection{%
   \section*{\refname}%
  }

\def\@bibtype{}
\def\bibtype#1{\gdef\@bibtype{#1}}

%%%%%%%%%%%%%%%%%%%%%%% Definition for T1 symbols %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOOK FRONTMATTER %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% PRELIMES
\def\booktitlefont{\fontfamily{\sfdefault}\fontsize{33}{33}\bfseries\selectfont\leftskip58pt\rightskip0pt plus1fill}
\def\booksubtitlefont{\fontfamily{\sfdefault}\fontsize{26}{26}\selectfont\leftskip58pt\rightskip0pt plus1fill}
\def\bookauthorfont{\fontfamily{\sfdefault}\fontsize{12}{12}\selectfont\bfseries\leftskip97pt\rightskip0pt plus1fill}
\def\bookaddressfont{\fontfamily{\sfdefault}\fontsize{10}{10}\selectfont\leftskip97pt\rightskip0pt plus1fill}
\def\bookeditiontextfont{\fontfamily{\sfdefault}\fontsize{10}{10}\selectfont\leftskip97pt\rightskip0pt plus1fill}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Table of Contents

\renewcommand\tableofcontents{{%
    \section*{\vspace*{-18pt}}%
    \let\@dottedtocline\@maindottedtocline%
    \let\l@chapter\mainl@chapter%
    \let\l@section\mainl@section%
    \let\l@subsection\mainl@subsection%
    \let\l@subsubsection\mainl@subsubsection%
    \@starttoc{toc}%
    }}

\newdimen\tocfmsep\tocfmsep=6pt
\newdimen\tocbmsep\tocbmsep=19pt
\newdimen\tocchapnumskip
\newdimen\tocsecnumskip
\newdimen\tocsbsecnumskip
\newdimen\tocsbsbsecnumskip
\newdimen\tocseclabelwidth
\newdimen\tocsbseclabelwidth
\newdimen\tocsbsbseclabelwidth

\gdef\MaxmTocnum#1#2#3#4{%
\setbox\@tempboxa\hbox{#1.\hskip6\p@}\global\tocchapnumskip=\wd\@tempboxa%
\setbox\@tempboxa\hbox{#2.\hskip6\p@}\global\tocsecnumskip=\wd\@tempboxa%
\setbox\@tempboxa\hbox{#3.\hskip6\p@}\global\tocsbsecnumskip=\wd\@tempboxa%
\setbox\@tempboxa\hbox{#4.\hskip6\p@}\global\tocsbsbsecnumskip=\wd\@tempboxa%
\global\tocseclabelwidth=\tocchapnumskip%
\global\tocsbseclabelwidth=\tocchapnumskip\advance\tocsbseclabelwidth by \tocsecnumskip%
\global\tocsbsbseclabelwidth=\tocsbseclabelwidth\advance\tocsbsbseclabelwidth by \tocsbsecnumskip}

\def\tocpartfont{\reset@font\fontfamily{\sfdefault}\fontsize{11}{13}\bfseries\selectfont}
\def\tocchapterfont{\reset@font\fontfamily{\sfdefault}\fontsize{10}{12.5}\bfseries\selectfont}
\def\tocfmbmchapterfont{\reset@font\fontfamily{\sfdefault}\fontsize{9}{13}\itshape\selectfont}
\def\tocsecfont{\reset@font\fontfamily{\sfdefault}\fontsize{9}{13}\selectfont}
\def\tocsbsecfont{\reset@font\fontfamily{\sfdefault}\fontsize{9}{13}\itshape\selectfont}
\def\tocsbsbsecfont{\reset@font\fontfamily{\sfdefault}\fontsize{9}{9}\bfseries\itshape\selectfont}

\renewcommand*\l@part{\tocpartfont\vskip13pt\def\numberline##1{\hbox{\hfil##1.\hskip12\p@}}\@dottedtocline{-1}{0pt}{16pt}}
\newcommand*\mainl@chapter{\tocchapterfont\vskip12.5pt\def\numberline##1{\hb@xt@\@tempdima{\hfil##1.\hskip6\p@}}\@dottedtocline{1}{0pt}{\tocchapnumskip}}
\newcommand*\l@fmbmchapter{\tocfmbmchapterfont\def\numberline##1{\hb@xt@\@tempdima{\hfil##1.\hskip6\p@}}\@dottedtocline{1}{0pt}{\tocchapnumskip}}
\newcommand*\mainl@section{\tocsecfont\vskip0pt\def\numberline##1{\hb@xt@\@tempdima{\hfil##1.\hskip6\p@}}\@dottedtocline{2}{\tocseclabelwidth}{\tocsecnumskip}}
\newcommand*\mainl@subsection{\tocsbsecfont\def\numberline##1{\hb@xt@\@tempdima{\hfil##1.\hskip6\p@}}\@dottedtocline{3}{\tocsbseclabelwidth}{\tocsbsecnumskip}}
\newcommand*\mainl@subsubsection{\tocsbsbsecfont\def\numberline##1{\hb@xt@\@tempdima{\hfil##1.\hskip6\p@}}\@dottedtocline{4}{\tocsbsbseclabelwidth}{\tocsbsbsecnumskip}}
\renewcommand*\l@paragraph{\@dottedtocline{5}{7.0em}{4.1em}}
\renewcommand*\l@subparagraph{\@dottedtocline{6}{10em}{5em}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOOK BACKMATTER %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% For Each Element Headings
\IfFileExists{booksetup.sty}{%
\RequirePackage{booksetup}}{\@latex@error{!!! booksetup.sty not found. !!!}\@ehc}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
\newcommand{\weblink}[2]{{{#1}\ \ref{#2}}}%
\def\eqweblink#1#2{{#1}~(\ref{#2})}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To differ greek 'nu' and letter 'v'

\if@altmathv%
\AtBeginDocument{%
\@ifpackageloaded{txfonts}{%
\DeclareSymbolFont{normalletter}{U}{txmia}{m}{it}%
\SetSymbolFont{normalletter}{bold}{U}{txmia}{b}{it}
\DeclareMathSymbol{v}{\mathalpha}{normalletter}{51}
}{}}%
\fi

\AtBeginDocument{\@ifpackageloaded{hyperref}
  {\def\@linkcolor{blue}
   \def\@anchorcolor{blue}
   \def\@citecolor{blue}
   \def\@filecolor{blue}
   \def\@urlcolor{blue}
   \def\@menucolor{blue}
   \def\@pagecolor{blue}
\begingroup
  \@makeother\`%
  \@makeother\=%
  \edef\x{%
    \edef\noexpand\x{%
      \endgroup
      \noexpand\toks@{%
        \catcode 96=\noexpand\the\catcode`\noexpand\`\relax
        \catcode 61=\noexpand\the\catcode`\noexpand\=\relax
      }%
    }%
    \noexpand\x
  }%
\x
\@makeother\`
\@makeother\=
}{}}

\hoffset=-1in
\voffset=-1in

%%%% Template Definitions %%%%%
\setlength{\paperwidth}{216mm}
\setlength{\paperheight}{276mm}
\setlength{\oddsidemargin}{23.8mm}
\setlength{\textwidth}{166.4mm}
\setlength{\textheight}{54.75pc}
\setlength{\columnsep}{6.2mm}
\setlength{\evensidemargin}{\paperwidth}%
\advance\evensidemargin by -\textwidth%
\advance\evensidemargin by -\oddsidemargin%
\setlength{\marginparsep}{0pt}%
\setlength{\marginparwidth}{0pt}%
\setlength\topmargin{35pt}
\setlength\topskip{0pt}%
\setlength\headsep{23pt}
\setlength\headheight{6pt}%

\setlength\maxdepth{0pt}%
\setlength\footskip{21.55pt}%
\parskip=0pt%

\setlength\parindent{12pt}%


%% page styles
\def\chaptermark#1{\markright{#1}}%

\def\foliostyle{\reset@font\fontfamily{\sfdefault}\fontsize{9}{0}\selectfont}
\def\rhheadstyle{\reset@font\fontfamily{\sfdefault}\fontsize{9}{0}\selectfont\bfseries}

\def\ps@headings{\let\@mkboth\markboth%
\def\@evenhead{\hbox to \textwidth{{\foliostyle\thepage}\hskip18pt\rhheadstyle\rightmark\hfill}}%
\def\@oddhead{\hbox to \textwidth{\hfill\rhheadstyle\rightmark\hskip18pt{\foliostyle\thepage}}}%
\def\@evenfoot{}%
\let\@oddfoot\@evenfoot}%
%
\def\ps@plain{\let\@mkboth\markboth%
\def\@evenhead{}
\def\@oddhead{}
\def\@evenfoot{\hbox to \textwidth{\foliostyle\thepage\hfill}}%
\def\@oddfoot{\hbox to \textwidth{\hfill\foliostyle\thepage}}%
}%

\def\ps@fmbmplain{\let\@mkboth\markboth%
\def\@evenhead{}
\def\@oddhead{}
\def\@evenfoot{\hbox to \textwidth{\llap{\hbox to 28.5pt{\foliostyle\thepage\hfill}}}\hfill}%
\def\@oddfoot{\hbox to \textwidth{\hfill\rlap{\hbox to 28.5pt{\hfill\foliostyle\thepage}}}}
}%

\pagestyle{headings}


%% Fonts & Sizes
\renewcommand\normalsize{%
\@setfontsize\normalsize{8.5bp}{11pt}%
\abovedisplayskip 6.15\p@ \@plus0\p@ \@minus0\p@%
\belowdisplayskip      \abovedisplayskip
\advance\belowdisplayskip by .3pt%
\abovedisplayshortskip \abovedisplayskip
\belowdisplayshortskip \abovedisplayskip
\let\@listi\@listI}%
\normalsize%

\renewcommand\small{%
   \@setfontsize\small{8}{\@xpt}%
}%
%
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize{7pt}{9pt}%
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
}%
%
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}

\renewcommand\@makefntext[1]{%
    \parindent 12\p@
    \noindent
    \mbox{\@makefnmark}#1}%
%
\footnotesep 0\p@
\skip\footins=18pt % space added when footnote is present
%
\renewcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\renewcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\renewcommand\large{\@setfontsize\large\@xipt{15}}
\renewcommand\Large{\@setfontsize\Large\@xiipt{16}}
\renewcommand\LARGE{\@setfontsize\LARGE\@xivpt{18}}
\renewcommand\huge{\@setfontsize\huge\@xxpt{30}}
\renewcommand\Huge{\@setfontsize\Huge{24}{36}}



%% Sections
\def\secfont{\fontfamily{\sfdefault}\fontsize{10}{11}\bfseries\selectfont}%
\def\subsecfont{\fontfamily{\sfdefault}\fontsize{9}{11}\bfseries\selectfont}%
\def\subsubsecfont{\fontfamily{\sfdefault}\fontsize{9}{11}\bfseries\itshape\selectfont}%
\def\parasecfont{\fontfamily{\sfdefault}\fontsize{8.5}{11}\selectfont}%
\def\subparaheadfont{\fontsize{8.5}{12pt}\bfseries\itshape\selectfont}%
\def\subsubparaheadfont{\fontsize{8.5}{12pt}\itshape\selectfont}%
\def\subsubsubparaheadfont{\fontsize{8.5}{12pt}\itshape\selectfont}%

\renewcommand\section{\@startsection {section}{1}{\z@}%
           {-22\p@ \@plus -2\p@}%
           {11pt}%
           {\reset@font\secfont\raggedright}}%

\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
           {-11\p@ \@plus -2\p@}%
           {3pt}%
           {\reset@font\subsecfont\raggedright}}

\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
           {-13\p@ \@plus -2\p@}%
           {0.0001pt}%
           {\reset@font\subsubsecfont\itshape\raggedright}}

\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
           {-13\p@ \@plus -2\p@}%
           {0.0001pt}%
	   {\reset@font\parasecfont\raggedright}}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\z@}%
           {-7\p@ \@plus -2\p@}%
           {0.0001pt}%
	   {\reset@font\subparaheadfont}}

\newcommand\subsubparagraph{\@startsection{subsubparagraph}{6}{\z@}%
           {-7\p@ \@plus -2\p@}%
           {-.5em}%
	   {\reset@font\subsubparaheadfont}}

\newcommand\subsubsubparagraph{\@startsection{subsubsubparagraph}{7}{\z@}%
           {-7\p@ \@plus -2\p@}%
           {-.5em}%
	   {\reset@font\subsubsubparaheadfont}}





\def\@seccntformat#1{\csname the#1\endcsname\hskip.5em}
\def\@sbseccntformat#1{\csname the#1\endcsname:\hskip.5em}
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
          \interlinepenalty \@M #8\@@par}%
    \endgroup
%    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

%% Pagination
\setlength\@fptop{\z@ }
\setlength\@fpsep{12\p@ }
\setlength\@fpbot{\z@ \@plus 1fil }
\def\textfraction{.01}
\def\floatpagefraction{.8}
\setlength{\intextsep}{20\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{24\p@ \@plus 2\p@ \@minus 4\p@}
\setcounter{topnumber}{4}
\def\topfraction{.9}
\setcounter{bottomnumber}{2}
\def\bottomfraction{.7}
\setcounter{totalnumber}{6}
\medmuskip=4mu%
\thickmuskip=5mu%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\seealso#1{\vskip\baselineskip\noindent\fontfamily{\sfdefault}\fontsize{9}{11}\selectfont\textbf{\textit{See Also:}}~\sf#1}

\RequirePackage{wrapfig}%
%
%
%  \begin{wrapfigure}[12]{r}[34pt]{5cm} <figure> \end{wrapfigure}
%                     --  -  ----  ---
%  [number of narrow lines] {placement} [overhang] {width of figure}
\newcount\wraplines%
%%\wraplines=5%
%
\newbox\@authorfigbox%
\newskip\@authorfigboxdim%
%
\newskip\biofigadjskip%
\biofigadjskip=0pt%
%
\def\authbiotextfont{\reset@font\fontsize{8bp}{9.5bp}\selectfont}%
%
\newenvironment{biography}[2]{\par\addvspace{11.5pt plus3.375pt minus1.6875pt}%\lineno@off%
\def\author##1{{\bfseries##1}}%
\if!#1!\def\@authorfig{}\else\def\@authorfig{{#1}}\fi%
\setbox\@authorfigbox=\hbox{#1}%
\@authorfigboxdim=\wd\@authorfigbox%
\wraplines=9\fboxrule=1pt\fboxsep=6pt%
\noindent{%
\ifx\@authorfig\@empty\else\unskip%
\begin{wrapfigure}[\wraplines]{l}[0pt]{\@authorfigboxdim}%
\addvspace{\biofigadjskip}%
\@authorfig%
\end{wrapfigure}%
\fi%
{\authbiotextfont#2\par}%
\par%
}}{\par\addvspace{10.5pt plus3.375pt minus1.6875pt}}


\endinput

