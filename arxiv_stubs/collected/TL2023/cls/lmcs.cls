%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%    PLEASE NOTE: Changes are not tracked in this file. When submitting
%%    your final version, always use the latest version found at
%%
%%      https://lmcs.episciences.org/public/lmcs.cls
%%
%%    This file was authored by
%%
%%                 Juergen Koslowski, Stefan Milius
%%                 and the LMCS Layout editors
%%
%%    LMCS Layout Editors <lmcs-layout@lists.cs.fau.de>
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lmcs}
              [2023/06/30 v0.92 LMCS Layout Editor Class]

\@ifundefined{pdfoutput}{}{
  % if \pdfoutput is available, then activate it:
  \pdfoutput=1
  % Disclaimer:
  % we activate \pdfoutput to make the document produced by arxiv closer to
  % what happens locally for most users. However, putting \pdfoutput=1 in a
  % class file is a bit tricky: if (plain) latex is called, a build system
  % (like latexmk or arxiv's scripts) expect a dvi file to be produced. With
  % \pdfoutput=1 however, a pdf file is produced instead. It seems that arxiv
  % adapts its further build process accordingly, but e.g. latexmk fails.
  % If you encounter any further issues with \pdfoutput=1, please write to the
  % LMCS layout editors (see above).
}

% Do not pass any options to amsart to ensure a uniform look: always usletter,
% always 11pt. (see the options to \LoadClass below)
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ProcessOptions\relax

\LoadClass[11pt,reqno]{amsart}
\RequirePackage{cclicenses}

% We do not load the helvet package because it overwrites the \sfdefault macro to 'phv' but
% we need it to be 'cmss' in order to have the font size in the main text consistent if
% the author uses \textsf{}.
% Thus, we do not use \textsf{} in the header/footer on the front page but use the following
% macro that switches to helvet's phv font:
\newcommand{\headertextsf}[1]{\textsf{\fontfamily{phv}\selectfont #1}}
% Do not pass options directly to the package to avoid option clashes
% if the user or some other package uses this package with different options.
\PassOptionsToPackage{shortlabels}{enumitem}
\PassOptionsToPackage{inline}{enumitem}
% We prefer plain \autoref over \cref from cleveref. But if the authors insist on using
% cleveref, then they should use the 'capitalise' option:
\PassOptionsToPackage{capitalise}{cleveref}
\RequirePackage{enumitem}
\setlist[enumerate]{font=\normalfont,labelindent=*,leftmargin=*,start=1}
\setlist[itemize]{labelindent=*,leftmargin=*}
%\setlist[description]{labelindent=*,leftmargin=*,itemindent=-1 em}
\setlist[description]{labelindent=0mm,labelwidth=*,labelsep=2mm,leftmargin=1cm}
\RequirePackage{microtype}
\RequirePackage{tikz}
\RequirePackage{color}
\RequirePackage{amsthm}
\RequirePackage{thmtools}
\RequirePackage{etoolbox}

% boot up hyperref. this needs to be done before \begin{document}
\AtEndPreamble{
% if hypersetup is not defined
\ifcsname hypersetup\endcsname%
\else%
% then load the package
\RequirePackage{hyperref}%
\fi
% if it's defined now, then use it
\ifcsname hypersetup\endcsname%
\hypersetup{
    hidelinks,
    final,
}
\else
\fi
}

% set metadata. this needs to be done after \author which is after \begin{document}
\def\doHyperrefSetup{
\ifcsname hypersetup\endcsname%
\edef\andBackup{\and}
\def\and{, } % make authors comma separated in the pdf metadata
\hypersetup{
    pdftitle={\@title},
    pdfauthor={\authors},
    pdfkeywords={\ignorespaces\@keywords},
}%
\edef\and{\andBackup} % restore old definition
\else
\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   		Use of this class, cf. also lmcs-smp.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This class builds upon the amsart class of AMS-LaTeX and requires use
% of LaTeX 2e. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Start of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% \documentclass{lmcs} 
%
% without any options followed optionally by
%
% \usepackage{package1,package2,...}
%
% loading additional macro packages you may wish to use, (eg, xypic, etc.)
% (This also is the place to define further theorem-environments, in case
% those provided by default do not suffice, cf. below.)
%
% \begin{document}
% \title[short_title]{real title}
%
% and a list of author information of the form
%
% \author[short_author1]{Author 1}
% \address{address 1}
% \email{author1@email1}
% \thanks{thanks 1}
%
% \author[short_author2]{Author 2}
% \address{address 2}
% \email{author2@email2}
% \thanks{thanks 2}
%
% \author[short_author3]{Author 3}
% \address{address 3}
% \email{author3@email3}
% \thanks{thanks 3}
%
% The \author, \address and \email fields are mandatory.
%
% The \thanks fields are optional.  They appear
% in footnotes on the title page, the addresses and email information
% is relegated to the top of the article.  The optional arguments to
% the \title and \author macros determine a running head on the odd
% and even pages, respectively.
%
% Lists of keywords and phrases as well as an ACM Subject
% classification are mandatory; these appear in footnotes on the
% title page, preceeding any \thanks fields.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Body of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We encourage the use of LaTeX's crossreferencing capabilities with the
% \label and \ref commands, for sections, subsections, theorems etc., and
% displayed equations and figures.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Theorems, Definitions etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The following theorem-like environments are available.  The
% numbering is consecutive within sections.
%
% thm   Theorem
% cor   Corollary
% lem   Lemma
% prop  Proposition
% asm   Asumption
%
% defi  Definition
% rem   Remark
% rems  Remarks (intended for use with itemized remarks)
% exa   Example
% exas  Examples (intended for use with itemized examples)
% conj  Conjecture
% prob  Problem
% oprob Open Problem
% algo  Algorithm
% obs   Observation
%
% If you require additional environments, you can add them before
% \begin{document} by means of
%
% \theoremstyle{plain}\newtheorem{env}[thm]{Environment}
%
% or
%
% \theoremstyle{definition}\newtheorem{env}[thm]{Environment}
%
% In the first case the font within the new environment will be italicised.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Proofs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Proofs start with the command \proof and should be ended by \qed,
% which provides an end-of-proof box at the right margin:
%
% \proof ... \qed
%
% In itemized or enumerated proofs the \qed command has to occur BEFORE 
% \end{itemize} or \end{enumerate} to ensure proper placement of the box:
%
% \proof
% \begin{itemize}
% \item[(1)] ...
% \item[(2)] ...
% ...
% \item[(n)] ... \qed
% \end{itemize}
%
% Similarly, the box may be used within theorem environments, when no
% explicit proof is given:
%
% \begin{thm} ... \qed \end{thm}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Itemized or enumerated environments and proofs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% By default, the first item of an itemized (or enumerated) environment
% or proof appears inlined on the same line as the environment title.
% This can be prevented by placing \hfill before the itemization, e.g.:
%
% \begin{thm}\label{T:abc}\hfill
% \begin{itemize} ...
%
% \proof\hfill
% \begin{itemize} ...


%
%		End of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Acknowledgements should be placed in a non-numbered section:
%
% \section*{Acknowledgement}
%
% The bibliography uses alpha.bst where references are built from the 
% authors' initials and the year of publication.  The use of bibtex
% for creating the bibliography is strongly encouraged.  Then the
% end of the paper takes the form
%
% \begin{thebibliography}{key}
% \end{thebibliography}
% \end{document}
%
% where ``key'' is the longest alphanumerical key expected to occur.
%
% Optionally, appendices can be inserted after the bibliography by
% means of
%
% \end{thebibliography}
% \appendix
% \section{} % Appendix A
% \section{} % Appendix B
% % etc.
% \end{document}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   actual macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifsuPer \suPertrue
\def\rsuper#1{\texorpdfstring{\ifsuPer${\,}^{\MakeLowercase{#1}}$\fi}{}}%
\def\lsuper#1{\texorpdfstring{\llap{${}^{\MakeLowercase{#1}\,}$}}{}}%

\def\titlecomment#1{\def\@titlecomment{#1}}
\let\@titlecomment=\@empty
\renewcommand*\subjclass[2][2012]{%
  \def\@subjclass{#2}%
  \@ifundefined{subjclassname@#1}{%
    \ClassWarning{\@classname}{Unknown edition (#1) of ACM
      Subject Classification; using '2012'.}%
  }{%
    \@xp\let\@xp\subjclassname\csname subjclassname@2012\endcsname
  }%
}
\@namedef{subjclassname@1998}{1998 ACM Subject Classification}
\@namedef{subjclassname@2012}{2012 ACM CCS}

\def\ACMCCS#1{\def\@ACMCCS{#1}}
\let\@ACMCCS=\@empty
\def\ACMCCSname{2012 ACM CCS}
    \@xp\let\@xp\subjclassname\csname subjclassname@2012\endcsname

\def\amsclass#1{\def\@amsclass{#1}}
\let\@amsclass=\@empty
\def\amsclassname{2010 Mathematics Subject Classification}

\renewenvironment{abstract}{%
  \ifx\maketitle\relax
    \ClassWarning{\@classname}{Abstract should precede
      \protect\maketitle\space in AMS documentclasses; reported}%
  \fi
  \global\setbox\abstractbox=\vtop \bgroup
    \normalfont\Small
    \list{}{\labelwidth\z@
      \leftmargin3pc \rightmargin\leftmargin
      \listparindent\normalparindent \itemindent\z@
      \parsep\z@ \@plus\p@
      \let\fullwidthdisplay\relax
    }%
    \item[\hskip\labelsep\scshape\abstractname.]%
}{%
  \endlist\egroup
  \ifx\@setabstract\relax \@setabstracta \fi
}
\newcommand{\revisionname}{Revision Note}
\newbox\revisionbox
\newenvironment{revision}{%
  \ifx\maketitle\relax
    \ClassWarning{\@classname}{Revision should precede 
      \protect\maketitle\space in LMCS documentclasses; reported}%
  \fi
  \global\setbox\revisionbox=\vtop \bgroup
    \normalfont\Small
    \list{}{\labelwidth\z@
      \leftmargin3pc \rightmargin\leftmargin
      \listparindent\normalparindent \itemindent\z@
      \parsep\z@ \@plus\p@
      \let\fullwidthdisplay\relax
    }%
    \item[\hskip\labelsep\scshape\revisionname.]%
}{%
  \endlist\egroup
  \ifx\@setrevision\relax \@setrevisiona \fi
}
\def\@setrevision{\@setrevisiona \global\let\@setrevision\relax}
\def\@setrevisiona{%
  \ifvoid\revisionbox
  \else
    \skip@20\p@ \advance\skip@-\lastskip
    \advance\skip@-\baselineskip \vskip\skip@
    \box\revisionbox
    \prevdepth\z@ % because \revisionbox is a vtop
    \bigskip\hrule\medskip
  \fi
}
\def\@setACMCCS{%
  {\itshape\subjclassname:}\enspace\@ACMCCS\@addpunct.}
\def\@setamsclass{%
  {\itshape\amsclassname:}\enspace\@amsclass\@addpunct.}
\def\@setkeywords{%
  {\itshape \keywordsname:}\enspace\@keywords\@addpunct.}
\def\@settitlecomment{\@titlecomment\@addpunct.}
\def\@maketitle{%
  \normalfont\normalsize
  \let\@makefnmark\relax  \let\@thefnmark\relax
  \ifx\@empty\@date\else \@footnotetext{\@setdate}\fi
  \ifx\@empty\@ACMCCS\else \@footnotetext{\@setACMCCS}\fi
  \ifx\@empty\@amsclass\else \@footnotetext{\@setamsclass}\fi
  \ifx\@empty\@keywords\else \@footnotetext{\@setkeywords}\fi
  \ifx\@empty\@titlecomment\else \@footnotetext{\@settitlecomment}\fi
  \ifx\@empty\thankses\else \@footnotetext{%
    \def\par{\let\par\@par}\@setthanks\par}\fi
  \@mkboth{\@nx\shortauthors}{\@nx\shorttitle}%
  \global\topskip12\p@\relax % 5.5pc   "   "   "     "     "
  \topskip42 pt\@settitle
  \ifx\@empty\authors \else \@setauthors \fi
  \@setaddresses
  \ifx\@empty\@dedicatory
  \else
    \baselineskip18\p@
    \vtop{\centering{\footnotesize\itshape\@dedicatory\@@par}%
      \global\dimen@i\prevdepth}\prevdepth\dimen@i
  \fi
  \endfront@text
  \bigskip\hrule\medskip
  \@setrevision
  \@setabstract
  \vskip-\bigskipamount
  \normalsize
  \if@titlepage
    \newpage
  \else
    \dimen@34\p@ \advance\dimen@-\baselineskip
    \vskip\dimen@\relax
  \fi
  \doHyperrefSetup
}

% Override author command to add optional affiliation superscript.
\RequirePackage{xparse}
\newif\ifmultiauthor
\multiauthorfalse
\RenewDocumentCommand{\author}{O{}mO{}}{%
  \ifx\@empty\authors
    \gdef\authors{#2\@ifnotempty{#3}{\rsuper{#3}}}%
  \else
    \multiauthortrue
    \g@addto@macro\authors{\and#2\@ifnotempty{#3}{\rsuper{{#3}}}}%
    \g@addto@macro\addresses{\author{}}%
  \fi
  \@ifnotempty{#1}{%
    \ifx\@empty\shortauthors
      \gdef\shortauthors{#1}%
    \else
      \g@addto@macro\shortauthors{\and#1}%
    \fi
  }%
}


% command for collecting addresses
\newcounter{addresstotalcount}
\renewcommand{\address}[2][]{%
  \g@addto@macro\addresses{\address{#1}{#2}}%
  \addtocounter{addresstotalcount}{1}%
}

% Addresses with superscripts on the left if there are multiple authors
\RequirePackage{mathtools}
\newcounter{addressctr}
\def\@setaddresses{\par
  \nobreak \begingroup
\footnotesize
  \def\author##1{\nobreak}%
  \def\\{\unskip, \ignorespaces}%
  \interlinepenalty\@M
  \def\address##1##2{\begingroup
    \par\addvspace\bigskipamount\noindent\narrower
    \@ifnotempty{##1}{(\ignorespaces##1\unskip) }%
    {\ifmultiauthor%
       \ifnum\value{addresstotalcount}=1\else%
         \addtocounter{addressctr}{1}%
         $\lsuper{\alph{addressctr}}{}{}$%
       \fi%
     \fi%
     \ignorespaces##2}\par\endgroup}%
  \def\curraddr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape Current address}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      ##2\par}\endgroup}%
  \def\email##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape e-mail address}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      {##2}\par}\endgroup}%
  \def\urladdr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape URL}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      \ttfamily##2\par}\endgroup}%
  \addresses
  \endgroup
}
\copyrightinfo{}{}

\newinsert\copyins
\skip\copyins=3pc
\count\copyins=1000 % magnification factor, 1000 = 100%
\dimen\copyins=.5\textheight % maximum allowed per page

\renewcommand{\topfraction}{0.95}   % let figure take up nearly whole page
\renewcommand{\textfraction}{0.05}  % let figure take up nearly whole page

%% Specify the dimensions of each page

\setlength{\oddsidemargin}{.25 in}  %   Note \oddsidemargin = \evensidemargin
\setlength{\evensidemargin}{.25 in}
\setlength{\marginparwidth}{0.07 true in}
\setlength{\topmargin}{-0.7 in}
\addtolength{\headheight}{1.84 pt}
\addtolength{\headsep}{0.25in}
\addtolength{\voffset}{0.7 in}
\setlength{\textheight}{8.5 true in}  % Height of text (including footnotes & figures)
\setlength{\textwidth}{6.0 true in}   % Width of text line.
\setlength{\parindent}{20 pt}   % Width of text line.
% FIXME: do these cause problems?
\widowpenalty=10000
\clubpenalty=10000
\@twosidetrue \@mparswitchtrue \def\ds@draft{\overfullrule 5pt}

%% Pagestyle
%% Defines the pagestyle for the title page.

%% define metadata used for the doi
%% Usage: \lmcsdoi{volume}{issue}{papernumber}
\def\lmcsdoi#1#2#3{%
    \def\@lmcsvolume{#1}%
    \def\@lmcsissue{#2}%
    \def\@lmcspaper{#3}%
    \pgfmathparse{int(#1+2004)}
    \edef\@lmcsyear{\pgfmathresult}
    \renewcommand{\dOi}{\@lmcsvolume(\@lmcsissue:\@lmcspaper)\@lmcsyear}
\def\ps@headings{
\def\@oddhead{\scriptsize Vol.~\@lmcsvolume:\@lmcsissue\hfill{\scriptsize \shorttitle}\hfill\@lmcspaper:\thepage}%
\def\@evenhead{\scriptsize \@lmcspaper:\thepage\hfill {\scriptsize\sc \shortauthors{}} \hfill Vol.~\@lmcsvolume:\@lmcsissue}%
}
\pagestyle{headings}
}

\def\lmcsurl{https://lmcs.episciences.org/}
\def\dOi{{\color{red}Volume/Paper Nr.~missing}}
%% Usage: \lmcsheading{vol}{issue}{year}{pages}{subm}{publ}{rev}{spec_iss}{title}
\def\lmcsheading#1#2#3#4#5#6#7{\def\ps@firstpage{\let\@mkboth\@gobbletwo%
\def\@oddhead{%
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{\headertextsf{Logical Methods in Computer Science}\hfil}
%    \hbox{\headertextsf{Vol.~\doi, pp.\ 1--#2}}
    \hbox{\headertextsf{Volume~\@lmcsvolume, Issue~\@lmcsissue, \@lmcsyear, pp.\ \@lmcspaper:1--\@lmcspaper:#2}}
    \hbox{\headertextsf{\href{\lmcsurl}{\lmcsurl}}}
    \rlap{\vrule width\hsize depth .4 pt}}}\hfill
\raise 4pt
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{\headertextsf{#3}}
    \hbox{\headertextsf{#4}}}}\hfill
\raise 4pt
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox to 94 pt{\headertextsf{Submitted\hfill #5}}
    \hbox to 94 pt{\headertextsf{Published\hfill #6}}
    #7}}}
\def\@evenhead{}\def\@evenfoot{}}%
\thispagestyle{firstpage}}

%% Creative Commons fonts %%

\DeclareRobustCommand{\crC}{%
  \ifmmode{\nfss@text{\text@cc}}\else\text@cc\fi}
\DeclareRobustCommand{\crCnd}{%
  \ifmmode{\nfss@text{\text@ccnd}}\else\text@ccnd\fi}
\DeclareRobustCommand{\crCby}{%
  \ifmmode{\nfss@text{\text@ccby}}\else\text@ccby\fi}
\DeclareRobustCommand{\crCnc}{%
  \ifmmode{\nfss@text{\text@ccnc}}\else\text@ccnc\fi}
\DeclareRobustCommand{\crCsa}{%
  \ifmmode{\nfss@text{\text@ccsa}}\else\text@ccsa\fi}
\renewcommand{\by}{\crCby}
\renewcommand{\bynd}{\crCby\crCnd}
\renewcommand{\byncnd}{\crCby\crCnc\crCnd}
\renewcommand{\bync}{\crCby\crCnc}
\renewcommand{\byncsa}{\crCby\crCnc\crCsa}
\renewcommand{\bysa}{\crCby\crCsa}
\renewcommand{\nd}{\crCnd}
\renewcommand{\ndnc}{\crCnd\crCnc}
\renewcommand{\nc}{\crCnc}
\renewcommand{\ncsa}{\crCnc\crCsa}
\renewcommand{\sa}{\crCsa}
%%%%%%%%%%%%

\def\endfront@text{%
\insert\copyins{\hsize\textwidth%
\fontsize{6}{7\p@}\normalfont\upshape%
\noindent%
\IfFileExists{./LMCS-logo.mf}{%
\hbox{\fontencoding{T1}%
\vbox{\fontsize{6}{8 pt}\baselineskip=6 pt\vss
\hbox{\hbox to 20 pt{\hfill}
          \headertextsf{LOGICAL METHODS}\hfil}
\hbox{\hbox to 20 pt{\font\logo=LMCS-logo\smash{\logo l}}
          \headertextsf{IN COMPUTER SCIENCE}}}}
\hfill\headertextsf{DOI:10.46298/LMCS-\dOi}
}{%
\vbox{\fontsize{6}{8 pt}\baselineskip=6 pt\vss%
\hbox{\headertextsf{Preprint submitted to}}
\hbox{\headertextsf{Logical Methods in Computer Science}}
}
}
%\hfill\textsf{\copyright\shortauthors}
\hfill
\hbox{\fontencoding{T1}%
  \vbox{\fontsize{6}{8 pt}\baselineskip=6 pt\vss
    \hbox{\headertextsf{\hspace{2 pt}\copyright\quad \shortauthors}\hfil}
    \hbox{\headertextsf{\crC\ \href{http://creativecommons.org/about/licenses}{Creative Commons}}\hfil}}}
\par\kern\z@}%
}

% If the logo is not present, then emulate an \lmcsheading call
% This draws the first horizontal line and fixes the page style on the first
% page
\IfFileExists{./LMCS-logo.mf}{}{
\def\ps@firstpage{\let\@mkboth\@gobbletwo%
\def\@oddhead{%
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{\phantom{LMgp}}
%    \hbox{\textsf{Vol.~\doi, pp.\ 1--#2}}
    \hbox{\phantom{Volume,pp}}
    \hbox{\phantom{https://example.org}}
    \rlap{\vrule width\hsize depth .4 pt}}}\hfill
\raise 4pt
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{}
    \hbox{}}}\hfill
\raise 4pt
\hbox{\fontencoding{T1}%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox to 94 pt{}
    \hbox to 94 pt{}
    }}}
\def\@evenhead{}\def\@evenfoot{}}%
\thispagestyle{firstpage}}

\def\enddoc@text{%
    \vspace{-2cm}% add space for the following text.
    % if the page is quite filled, the text is simply hidden
    % otherwise.
    \nobreak%
    \insert\copyins{\hsize.58\textwidth
\vbox to 0pt{\vskip12 pt%
      \fontsize{6}{7\p@}\normalfont\upshape
      \everypar{}%
      \noindent\fontencoding{T1}%
  \headertextsf{This work is licensed under the Creative Commons
  Attribution License. To view a copy of this license, visit
  \texttt{https://creativecommons.org/licenses/by/4.0/} or send a
  letter to Creative Commons, 171 Second St, Suite 300, San Francisco,
    CA 94105, USA, or Eisenacher Strasse~2, 10777 Berlin, Germany}\vss}
      \par
      \kern\z@}%
}

%% Defines the pagestyle for the rest of the pages
%% Usage: \ShortHeadings{Minimizing Conflicts}{Minton et al}
%%	  \ShortHeadings{short title}{short authors}

%\def\firstpageno#1{\setcounter{page}{#1}}
%\def\ShortHeadings#1#2{\def\ps@lmcsps{\let\@mkboth\@gobbletwo%
%\def\@oddhead{\hfill {\small\sc #1} \hfill}%
%\def\@oddfoot{\hfill \small\rm \thepage \hfill}%
%\def\@evenhead{\hfill {\small\sc #2} \hfill}%
%\def\@evenfoot{\hfill \small\rm \thepage \hfill}}%
%\pagestyle{lmcsps}}

%% MISCELLANY

\def\@startsection#1#2#3#4#5#6{\bigskip%
 \if@noskipsec \leavevmode \fi
 \par \@tempskipa #4\relax
 \@afterindentfalse
 \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
 \if@nobreak \everypar{}\else
     \addpenalty\@secpenalty\addvspace\@tempskipa\fi
 \@ifstar{\@dblarg{\@sect{#1}{\@m}{#3}{#4}{#5}{#6}}}%
         {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
%  \aftergroup\@afterindentfalse
%  \aftergroup\@afterheading
}

\def\figurecaption#1#2{\noindent\hangindent 40pt
                       \hbox to 36pt {\small\sl #1 \hfil}
                       \ignorespaces {\small #2}}
% Figurecenter prints the caption title centered.
\def\figurecenter#1#2{\centerline{{\sl #1} #2}}
\def\figurecenter#1#2{\centerline{{\small\sl #1} {\small #2}}}

%
%  Allow ``hanging indents'' in long captions
%
\long\def\@makecaption#1#2{
   \vskip 10pt 
   \setbox\@tempboxa\hbox{#1: #2}
   \ifdim \wd\@tempboxa >\hsize               % IF longer than one line:
       \begin{list}{#1:}{
       \settowidth{\labelwidth}{#1:}
       \setlength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
        }\item #2 \end{list}\par   % Output in quote mode
     \else                                    %   ELSE  center.
       \hbox to\hsize{\hfil\box\@tempboxa\hfil}  
   \fi}


% Define strut macros for skipping spaces above and below text in a
% tabular environment.
\def\abovestrut#1{\rule[0in]{0in}{#1}\ignorespaces}
\def\belowstrut#1{\rule[-#1]{0in}{#1}\ignorespaces}

%%% Theorem environments

% the following environments switch to a slanted font:
\theoremstyle{plain}

\newtheorem{thm}{Theorem}[section]
\newtheorem{cor}[thm]{Corollary}
\newtheorem{lem}[thm]{Lemma}
\newtheorem{slem}[thm]{Sublemma}
\newtheorem{prop}[thm]{Proposition}
\newtheorem{asm}[thm]{Assumption}

% the following environments keep the roman font:
\theoremstyle{definition}

\newtheorem{rem}[thm]{Remark}
\newtheorem{rems}[thm]{Remarks}
\newtheorem{exa}[thm]{Example}
\newtheorem{exas}[thm]{Examples}
\newtheorem{defi}[thm]{Definition}
\newtheorem{conv}[thm]{Convention}
\newtheorem{conj}[thm]{Conjecture}
\newtheorem{prob}[thm]{Problem}
\newtheorem{oprob}[thm]{Open Problem}
\newtheorem{oprobs}[thm]{Open Problems}
\newtheorem{algo}[thm]{Algorithm}
\newtheorem{obs}[thm]{Observation}
\newtheorem{desc}[thm]{Description}
\newtheorem{fact}[thm]{Fact}
\newtheorem{qu}[thm]{Question}
\newtheorem{oqu}[thm]{Open Question}
\newtheorem{pty}[thm]{Property}
\newtheorem{clm}[thm]{Claim}
\newtheorem{nota}[thm]{Notation}
\newtheorem{com}[thm]{Comment}
\newtheorem{coms}[thm]{Comments}

%% goal is to omit parens from note, place cite as part of theorem number
\newtheoremstyle{defC}%
  {6pt}% (space above)
  {6pt}% (space below)
  {\normalfont}% (body font)
  {}% (indent amount)
  {\bfseries}% {theorem head font}
  {{\bfseries .}}% {punctuation after theorem head}
  {5pt plus 1pt minus 1pt}% {space after theorem head}
  {\thmname{#1} \thmnumber{#2} \thmnote{\normalfont#3}}% {theorem head spec}
\theoremstyle{defC}
\newtheorem{defiC}[thm]{Definition}

\newtheoremstyle{thmC}%
  {6pt}% (space above)
  {6pt}% (space below)
  {\itshape}% (body font)
  {}% (indent amount)
  {\bfseries}% {theorem head font}
  {{\bfseries .}}% {punctuation after theorem head}
  {5pt plus 1pt minus 1pt}% {space after theorem head}
  {\thmname{#1} \thmnumber{#2} \thmnote{\normalfont#3}}% {theorem head spec}

\theoremstyle{thmC}
\newtheorem{thmC}[thm]{Theorem}
\newtheorem{propC}[thm]{Proposition}
\newtheorem{lemC}[thm]{Lemma}

% switch back to standard theorem style for document specific theorems
\theoremstyle{plain}

\numberwithin{equation}{section}

% end-of-proof sign, to appear at right margin
% Paul Taylor and Chris Thompson, Cambridge, 1986
%
\def\pushright#1{{%        set up
   \parfillskip=0pt            % so \par doesn't push #1 to left
   \widowpenalty=10000         % so we dont break the page before #1
   \displaywidowpenalty=10000  % ditto
   \finalhyphendemerits=0      % TeXbook exercise 14.32
  %
  %                 horizontal
   \leavevmode                 % \nobreak means lines not pages
   \unskip                     % remove previous space or glue
   \nobreak                    % don't break lines
   \hfil                       % ragged right if we spill over
   \penalty50                  % discouragement to do so
   \hskip.2em                  % ensure some space
   \null                       % anchor following \hfill
   \hfill                      % push #1 to right
   {#1}                        % the end-of-proof mark (or whatever)
  %
  %                   vertical
   \par}}                      % build paragraph

\newsavebox{\lmcsQEDSymbol}
\savebox{\lmcsQEDSymbol}{\begin{tikzpicture}[baseline=\the\pgflinewidth]
    \draw (-\the\pgflinewidth,-\the\pgflinewidth) rectangle (8pt,8pt);
  \end{tikzpicture}}
\renewcommand\qedsymbol{\usebox{\lmcsQEDSymbol}}


% ### The following code is adapted from the orcidlink package
% ### Copyright (C) 2020 by Leo C. Stein <leo.stein@gmail.com>
% ### Originally licensed under the LaTeX Project Public License
% ### either version 1.3 or (at your option) any later version.
% ### https://github.com/duetosymmetry/orcidlink-LaTeX-command/blob/master/orcidlink.sty
% ### The code is included directly in the lmcs.cls file rather than calling the
% ### package so as to ensure compatibility with old tex distributions
\usetikzlibrary{svg.path}

\definecolor{lmcsorcidlogocol}{HTML}{A6CE39}
\tikzset{
  lmcsorcidlogo/.pic={
    \fill[lmcsorcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
    \fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
                 svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
                 svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
  }
}

%% Reciprocal of the height of the svg whose source is above.  The
%% original generates a 256pt high graphic; this macro holds 1/256.
\newcommand{\@lmcsOrigHeightRecip}{0.00390625}

%% We will compute the current X height to make the logo the right height
\newlength{\@lmcscurXheight}

\DeclareRobustCommand\lmcsorcid[1]{%
\texorpdfstring{%
\hspace*{2pt}%
\setlength{\@lmcscurXheight}{\fontcharht\font`X}%
\href{https://orcid.org/#1}{\XeTeXLinkBox{\mbox{%
\begin{tikzpicture}[yscale=-\@lmcsOrigHeightRecip*\@lmcscurXheight,
xscale=\@lmcsOrigHeightRecip*\@lmcscurXheight,transform shape,
baseline=(current bounding box.south)]
\pic{lmcsorcidlogo};
\end{tikzpicture}%
}}}}{}}
% ### end of code from the orcidlink package


\newcommand{\backuprestoremacros}[2]{%
  % first backup all macros:
  \foreach \macroname in {#1} {
    % backup contents of macro
    % for each \macro, create a copy in \oldvalueofmacro
    % the \global ensures that the backup is visible outside the foreach loob
    % the second \expandafter is a trick from https://tex.stackexchange.com/a/543594/46552
    \global\expandafter\let\csname oldvalueof\macroname\expandafter\endcsname\csname\macroname\endcsname
  }
  % then run the actual command:
  #2
  % restore backup all macros again:
  \foreach \macroname in {#1} {
    \global\expandafter\let\csname\macroname\expandafter\endcsname\csname oldvalueof\macroname\endcsname
  }
}


% Bibliographystyle

\bibliographystyle{alphaurl}


\ifcsname bibfont\endcsname%
  % if \bibfont is defined, then the authors probably use biblatex
  % and so we fix biblatex's \bibfont to match the font size of LMCS's
  % bibtex style, which is specified in \bibliofont (usually \footnotesize):
  \renewcommand*{\bibfont}{\normalfont\bibliofont}
\else
\fi


\def\eqalign#1{\null\,\vcenter{\openup\jot\mathsurround=0 pt
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      \crcr#1\crcr}}\,}

\def\Rlap#1{\rlap{\mths$#1$}}
\def\Llap#1{\llap{\mths$#1$}}

% make amsart paragraph headings bold
\def\paragraph{\@startsection{paragraph}{4}%
  \z@\z@{-\fontdimen2\font}%
  {\normalfont\bfseries}}

\endinput
