\NeedsTeXFormat{LaTeX2e}[1997/04/30]
\ProvidesClass{utdthesis}
  [2021/11/01 v1.9 University of Texas at Dallas Thesis Class]

%% Example Usage:
%%
%% \documentclass[doublespacing]{utdthesis}
%%
%% \author{Jyuika Mehta}
%% \title{The Semantic Priming Effect Across the Life-span: \\
%%        An ERP Study Examining Processing Negativity}
%% \thesistype{Dissertation}  % or Thesis
%% \degreefull{Doctor of Philosophy}
%% \degreeabbr{PhD}
%% \subject{Computer Science}
%% \graduationmonth{August}
%% \graduationyear{2012}
%% \prevdegrees{BS} % comma-separated list of previous degrees, no periods
%%
%% \committeemember*{Austin J. Cunningham}
%% \committeemember{John J. Wiorkowski}
%% \committeemember{Raymond P. Lutz}
%% \committeemember{Juan Gonzalez}
%%
%% \begin{document}
%%
%% \frontmatter
%%
%% \signaturepage
%% \copyrightpage{2012}
%%
%% \begin{dedication}
%% This thesis is dedicated to \\
%% everyone who helped me write it.
%% \end{dedication}
%%
%% \maketitle
%%
%% \begin{acks}{March 2012} % month and year when first submitted to committee
%% Write acknowledgments here.
%% \end{acks}
%%
%% \begin{abstract}
%% Write abstract here.
%% \end{abstract}
%%
%% \tableofcontents
%% \listoffigures
%% \listoftables
%%
%% \mainmatter
%%
%% \chapter{Introduction}
%% \label{c:intro}
%% This is where the introduction goes.
%%
%% \chapter{Conclusion}
%% \label{c:conclude}
%% This is where the conclusion goes.
%%
%% \appendix
%%
%% \chapter*{Title of Only Appendix}
%% \label{a:myappendix}
%% A solo appendix looks like this.
%%
%% \begin{thesisbib}
%% \bibliography{mybibfile}
%% \end{thesisbib}
%%
%% \begin{vita}
%% This is where your vita goes.
%% \end{vita}
%%
%% \end{document}


%%% Instructions to future editors of this class file:
%%% ==================================================
%%% This class file has been carefully designed to make MINIMAL changes to the
%%% book.cls LaTeX class file necessary to meet the UTD thesis requirements,
%%% and to AVOID LOADING OTHER PACKAGES.  This is important for maintaining
%%% compatibility with other packages that the author may load.  Therefore,
%%% please avoid adding non-critical extra code to this class file in an
%%% effort to "help" future authors by providing macros that you think they
%%% will want.  If there is a helpful package or macro that you think others
%%% may want, modify the class documentation to recommend it; don't force it
%%% on everyone by loading it here.


%%% Summary of version changes
%%% ==========================
%%% v1.0 (2013/02/18) - Initial release
%%% v1.1 (2013/03/07) - Corrected improper placement of page numbers on
%%%   preliminary pages that do not start a section.  (Fixed by redefining
%%%   \frontmatter and \mainmatter to change the \pagestyle.)
%%% v1.2 (2013/04/03) - Recalibrated signature page spacing to accommodate
%%%   five or more signature lines
%%% v1.3 (2013/07/01) - Reduced default signature line gap from 5 to 4 "blank
%%%   lines", pushed full-page figures to tops of pages, pushed "continued"
%%%   table captions to left page margins, and customized float parameters to
%%%   avoid whitespace below floats whenever possible
%%% v1.4 (2013/11/15) - \thanks now works correctly within part, chapter, and
%%%   section titles; capitalization of "Co-Chair" corrected
%%% v1.5 (2015/10/15) - chaptertitlepage added, improved \thanks support for
%%%   hyperref's hyperfootnotes, set default float placement to "htp", added
%%%   support for \\ within \subject (for degree specializations)
%%% v1.6 (2015/10/27) - added support for committees with multiple supervisors
%%%   having different titles "Chair" and "Co-Chair", changed default float
%%%   placement to "tp" (complies with Turabian 7 with less drastic deviation
%%%   from LaTeX default)
%%% v1.7 (2016/11/04) - revised 2016 guide: top margin 1.5in even on special
%%%   pages, page numbers always bottom centered, biographical sketch replaces
%%%   old cv, new cv section is really a cv (no formatting requirements),
%%%   preface eliminated, 11pt font permitted
%%% v1.8 (2019/06/06) - fixed a bug in chaptertitlepage environments that
%%%   prevented chapter references (via \label) from resolving correctly
%%% v1.9 (2021/11/01) - line spacing code updated to accommodate changes in
%%%   LaTeX3 kernel that reset everything to single-spacing

%% Initialization
%% ==============

\newcommand\UTD@warn{\ClassWarning{utdthesis}}
\newcommand\UTD@warnnl{\ClassWarningNoLine{utdthesis}}
\newcommand\UTD@err{\ClassError{utdthesis}}
\newcommand\UTD@temp{}

\newif\ifUTD@preamble
\UTD@preambletrue
\AtBeginDocument{\UTD@preamblefalse}

\newcommand\UTD@texorpdf{%
  \@ifundefined{texorpdfstring}\@firstoftwo\texorpdfstring}

\newcommand\doublespacing{\def\baselinestretch{1.655}\ifUTD@preamble\else\@currsize\fi}
\newcommand\halfspacing{\def\baselinestretch{1.241}\ifUTD@preamble\else\@currsize\fi}
\DeclareOption{doublespacing}{\AtEndOfClass{\doublespacing}}
\DeclareOption{halfspacing}{\AtEndOfClass{\halfspacing}}

\DeclareOption{12pt}{\PassOptionsToClass{12pt}{book}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{book}}
\DeclareOption{draft}{\PassOptionsToClass{draft}{book}}
\DeclareOption{final}{\PassOptionsToClass{final}{book}}
\DeclareOption*{\UTD@warn{Unknown option '\CurrentOption'}}

\ExecuteOptions{doublespacing,12pt}
\ProcessOptions\relax
\LoadClass[letterpaper,oneside,openany]{book}

% The textcase Package
% --------------------
% We make one exception to our mantra of avoiding dependencies upon other
% packages:  If textcase is available, we load it in order to more safely
% convert strings to uppercase.  Without it, some unusual chapter titles
% (e.g., those with math or footnotes) can fail the conversion to uppercase,
% resulting in strange errors that the user is unlikely to diagnose.  It is
% therefore best to load textcase preemptively, since most users who need it
% don't know that they need it.  Loading it is relatively safe because it only
% defines new commands, making it unlikely to conflict with any other packages.

\IfFileExists{textcase.sty}{
  \RequirePackage{textcase}
  \newcommand\UTD@upper{\MakeTextUppercase}
  \newcommand\UTD@lower{\MakeTextLowercase}
}{
  \newcommand\UTD@upper{\MakeUppercase}
  \newcommand\UTD@lower{\MakeLowercase}
}

%% Page Layout
%% ===========
%% The following sets the page dimensions and margins as mandated by the UTD
%% thesis guidelines.  To help the user, we recheck these values at document
%% start and warn if they've been changed.  This helps the user discover and
%% avoid any external packages (e.g., "geometry") that change the settings.

\setlength{\paperheight}{11in}
\setlength{\paperwidth}{8.5in}
\@ifundefined{pdfpagewidth}{}{\pdfpagewidth=\paperwidth}
\@ifundefined{pdfpageheight}{}{\pdfpageheight=\paperheight}
\voffset\z@
\hoffset\z@
\setlength{\topmargin}{-0.25in}
\setlength{\headsep}{0.5in}
\advance\headsep-\headheight
\setlength{\oddsidemargin}{0.25in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{8.5in}
\footskip=0.5in

\newcommand\UTD@check[1]{%
  \expandafter\AtBeginDocument\expandafter{\expandafter
    \ifdim\the#1=#1\else\UTD@badval#1\fi}}

\newcommand\UTD@badval[1]{%
  \UTD@warnnl{\protect#1 has changed value.\MessageBreak
    Your thesis might not conform to the UTD thesis formatting requirements}}

\UTD@check\paperwidth
\UTD@check\paperheight
\@ifundefined{pdfpagewidth}{}{\UTD@check\pdfpagewidth}
\@ifundefined{pdfpageheight}{}{\UTD@check\pdfpageheight}
\UTD@check\voffset
\UTD@check\hoffset
\UTD@check\topmargin
\UTD@check\headheight
\UTD@check\headsep
\UTD@check\oddsidemargin
\UTD@check\evensidemargin
\UTD@check\textwidth
\UTD@check\textheight
\UTD@check\footskip

%% Page numbers
%% ============
%% Page numbers are bottom-centered (.75in from paper bottom).

\pagestyle{plain}

\renewcommand\frontmatter{%
  \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}%
}

\renewcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}%
}

%% Paragraphs
%% ==========
%% UTD prohibits widow and club lines, and disallows extra space between
%% paragraphs in regions where paragraphs are indented.

\widowpenalty\@M
\clubpenalty\@M
\parskip\z@skip

%% Document Parameters
%% ===================
%% Users specify key words of thesis title pages using the following macros.

\renewcommand\contentsname{Table of Contents}
\renewcommand\bibname{References}
\newcommand\refname{References}
\newcommand\bioname{Biographical Sketch}
\newcommand\vitaname{Curriculum Vitae}

\newcommand\UTD@newparam[3]{%
  \newcommand#1{\gdef#2}%
  \newcommand#2{#3\UTD@notset#1}%
}

\newcommand\UTD@notset[1]{\UTD@warn{\protect#1 not set}}

\UTD@newparam\graduationmonth\UTD@month{Month}
\UTD@newparam\graduationyear\UTD@year{Year}
\UTD@newparam\thesistype\UTD@type{Dissertation/Thesis}
\UTD@newparam\degreefull\UTD@degfull{Degree Name}
\UTD@newparam\degreeabbr\UTD@degabbr{???}
\UTD@newparam\subject\UTD@subject{Field of Study}
\UTD@newparam\prevdegrees\UTD@degprev{}
\let\UTD@degprev=\@empty

\newcommand\UTD@cmtitle{}
\newcommand\UTD@chairtitle{}
\newcommand\UTD@cochairtitle{}

\newcount\UTD@numchairs\UTD@numchairs\z@
\newif\ifUTD@hadnonchair\UTD@hadnonchairfalse

\newcommand\UTD@profs{%
  \ifnum\UTD@numchairs<\@ne
    \UTD@warn{\protect\committeemember\space not set}%
  \fi
}
\newcommand\committeemember{\@ifstar\UTD@starcm\UTD@nonchairmem}
\newcommand\UTD@starcm{%
  \@ifstar{\UTD@chairmem\UTD@chairtitle}{\UTD@chairmem\UTD@cochairtitle}}
\newcommand\UTD@chairmem[1]{%
  \ifUTD@hadnonchair
    \UTD@warn{Misordered chair member (preceded by non-chair)}%
  \fi
  \advance\UTD@numchairs\@ne
  \UTD@addprof{\let\UTD@cmtitle#1}}
\newcommand\UTD@nonchairmem{%
  \ifnum\UTD@numchairs<\@ne
    \UTD@warn{\protect\committeemember\space replaced with \protect\committeemember*}%
    \expandafter\UTD@chairmem\expandafter\UTD@cochairtitle
  \else
    \expandafter\UTD@@nonchairmem
  \fi
}
\newcommand\UTD@@nonchairmem{%
  \UTD@hadnonchairtrue
  \UTD@addprof{\let\UTD@cmtitle\@empty}}
\newcommand*\UTD@addprof[2]{%
  \expandafter\def\expandafter\UTD@profs\expandafter{\UTD@profs#1\do{#2}}}

%% Double-spacing
%% ==============
%% UTD requires theses to be double-spaced or one-and-a-half-spaced.
%% In practice, four document areas must be considered:
%% [A] Insertions (e.g., tables, figures, and footnotes) should be single-
%%       spaced.  Consecutive footnotes should be separated by a blank line.
%% [B] Title areas should be rigidly double-spaced as per UTD guidelines.
%% [C] Block quotations should be single-spaced with a "blank line" above and
%%       below, inset from the left margin, and non-first paragraphs indented.
%% [D] Everywhere else can be flexibly double- or one-and-a-half-spaced.
%%
%% Care is required to achieve this spacing without conflicting with other
%% packages.  First, it's best to never change \baselineskip.  LaTeX changes
%% it often and tunes it based on many font metrics, so modifying it directly
%% doesn't work well.  The best way is to change \baselinestretch instead.
%%
%% [A] To get single-spacing within insertions, we take the approach of
%% redefining \reset@font.  This macro is an internal name for \normalfont
%% that seems to only ever be invoked when preparing footnotes, floats, and
%% citations.  The first two are exactly what we want to change, and the last
%% is harmless because single-spacing has no effect until paragraph-ends are
%% reached, and citations never include a paragraph-end.  V1.9 Change: The
%% new LaTeX3 kernel now calls \reset@font within \begin{document}, which
%% was causing everything to revert to single-spacing.  To fix this, we
%% only give \reset@font its new functionality after the document begins.
%%
%% [B] To get wide double-spacing in title areas, we use a stretch of 1.8 in
%% the macros that produce those pages.  This is somewhat arbitrary but looks
%% appropriate.
%%
%% [C] We customize LaTeX's quote, quotation, and verse environments to meet
%% the formatting suggested by Turabian.  Also, the \singlespacing macro and
%% singlespace environment are provided so that users can invoke single-
%% spacing in other parts of the document that may need to look like block
%% quotes.  These macro names are intentionally chosen to conflict with the
%% setspace package so that loading it will cause an error.
%%
%% [D] We define a document-default stretch (see the Initialization section
%% of this class file) for everything else.  All Area-A, B, and C changes are
%% implemented as local assignments, so that the stretch returns to its
%% default naturally after the local group is done.  This lets users customize
%% the default stretch without their choices being overridden by subsequent
%% font changes.

\DeclareRobustCommand\reset@font{%
  \ifUTD@preamble\else
    \baselineflex\z@skip
    \def\baselinestretch{1}%
  \fi
  \normalfont
}

\footnotesep20\p@
\def\footnoterule{\kern-3\p@\hrule\@width2in\kern-3.4\p@}

\newcommand\UTD@double{\def\baselinestretch{1.8}\@currsize}
\newcommand\singlespacing{\def\baselinestretch{1}\@currsize}

\newenvironment{singlespace}{\par\begingroup\singlespacing}{\par\endgroup}

\newskip\UTD@tempskip
\newcommand\UTD@skipdiff{%
  \global\UTD@tempskip\baselineskip
  {\singlespacing\global\advance\UTD@tempskip-\baselineskip}%
  \vskip\UTD@tempskip\kern\z@
}

\renewenvironment{verse}
                 {\UTD@skipdiff
                  \let\\\@centercr
                  \list{}{\singlespacing
                          \topsep\z@skip\partopsep\z@skip\itemsep\z@skip
                          \labelwidth\z@skip\labelsep\z@skip
                          \itemindent-\parindent
                          \listparindent\itemindent
                          \leftmargin2\parindent
                          \parsep\parskip}%
                  \item\relax}
                 {\endlist}

\renewenvironment{quotation}
                 {\UTD@skipdiff
                  \list{}{\singlespacing
                          \topsep\z@skip\partopsep\z@skip\itemsep\z@skip
                          \labelwidth\z@skip\labelsep\z@skip
                          \listparindent\parindent
                          \leftmargin\parindent
                          \parsep\parskip}%
                  \item\relax}
                 {\endlist}

\renewenvironment{quote}{\quotation}{\endquotation}

%% Stretchable line heights
%% ========================
%% We would also like the [C] and [D] areas (see above) to be slightly
%% stretchable.  This lets LaTeX vertically widen the spacing ever so slightly
%% when doing so puts the next page break in a more logical, visually pleasing
%% place.  It also allows a uniform bottom margin on every text page.

\newskip\baselineflex
\baselineflex=\z@\@plus\p@\@minus\p@

\newcommand\UTD@sfs{}
\let\UTD@sfs=\set@fontsize
\newcommand\UTD@sizeupdate{}
\def\set@fontsize#1#2#3{%
  \UTD@sfs{#1}{#2}{#3}%
  \let\UTD@sizeupdate\size@update
  \def\size@update{%
    \UTD@sizeupdate
    \advance\baselineskip\baselineflex
  }%
}

\flushbottom

%% "Blank lines"
%% -------------
%% The UTD thesis guidelines routinely call for "blank lines" to be inserted
%% in various places.  However "blank lines" are a primitive notion of distance
%% reserved for typewriters and ancient word processors.  LaTeX measures
%% distances in inches or points, not "lines".  We therefore make a guess
%% that a "blank line" is 14 pts high, because that seems to look about right.
%% (Note that the baseline separation distance is not a precise measure of
%% the height of a "blank line" because the baseline skip changes from page to
%% page, and when I tried using it, the UTD grad office complained that some
%% "blank lines" were infinitesimally taller than others.)

\newdimen\UTD@blankline
\UTD@blankline=14pt

%% Special pages
%% =============
%% The following macros and environments typeset the various special pages
%% and sections mandated by the UTD thesis guidelines.

\newcount\UTD@page
\newcommand\UTD@order[3]{%
  \ifnum\UTD@page<#1\relax\UTD@warn{Misplaced #3 page}\else
    \ifnum\UTD@page<#2\relax\else\UTD@warn{Misplaced #3 page}\fi\fi
  \global\UTD@page#2\relax
}

\DeclareRobustCommand\UTD@sep{\par\nobreak\ignorespaces}
\newcommand\UTD@upsep[1]{{\let\\\UTD@sep\UTD@upper#1}}

% signature page
% --------------

\newcommand\signaturepage{%
  \if@mainmatter\UTD@warn{Missing \protect\frontmatter}\frontmatter\fi
  \clearpage
  \ifnum\c@page=\@ne\else\UTD@warn{Signature page should be page 1}\fi
  \UTD@order01{signature}%
  \thispagestyle{empty}%
  \null\nointerlineskip\nobreak\vskip-\topskip\kern0pt\nobreak
  {\centering\parskip\z@skip\baselineflex\z@skip\UTD@double
   \UTD@upsep\@title\par
   \singlespacing
   \nobreak\vskip2\UTD@blankline\relax
   by\par
   \nobreak\vskip2\UTD@blankline\relax
   {\frenchspacing\@author\par}}%
  \nobreak\vskip2cm\@plus1fill\@minus\z@
  \hbox to\textwidth{\hfil
    \hbox to3.625in{APPROVED BY SUPERVISORY COMMITTEE:\hfil}}\nointerlineskip
  {\baselineflex\z@skip\singlespacing
   \raggedright\parskip\z@skip\frenchspacing
   \let\do\UTD@profsigline\UTD@profs}%
  \newpage
}

\newcommand\UTD@profsigline[1]{%
  \nobreak\vskip4\UTD@blankline\@plus\z@\@minus3\UTD@blankline
  \hbox to\textwidth{\hfil
    \vbox{\hsize=3.625in
      \hrule\@height\z@\@depth.4\p@\@width\hsize
      \kern2\p@
      \noindent\ignorespaces#1\unskip\UTD@cmtitle\vphantom p\par
  }}%
}

% copyright page
% --------------

\newcommand*\copyrightpage[2][\@author]{%
  \UTD@order12{copyright}%
  \clearpage
  \thispagestyle{empty}%
  \null\nointerlineskip\vskip-\topskip\vfill
  {\centering\parskip\z@skip\frenchspacing\baselineflex\z@skip\UTD@double
   Copyright \textcopyright\space#2\par#1\par All rights reserved\par}%
  \vfill
  \clearpage
}

% dedication page
% ---------------

\newenvironment{dedication}{%
  \UTD@order13{dedication}%
  \clearpage
  \thispagestyle{empty}%
  \null\nointerlineskip\vskip-\topskip\vfill
  \begingroup
    \centering\parskip\z@skip\itshape
}{%
    \par
  \endgroup
  \vfill
  \clearpage
}

% title page
% ----------

\renewcommand\maketitle{%
  \UTD@order14{title}%
  \clearpage
  \thispagestyle{empty}%
  \null\nointerlineskip\nobreak\vskip-\topskip\kern0pt
  {\centering\parskip\z@skip\interlinepenalty\@M
   \baselineflex\z@skip\UTD@double
   \UTD@upsep\@title\par\nointerlineskip
   \nobreak\vskip4\UTD@blankline\@minus.15\UTD@blankline\relax
   {\singlespacing by\par}%
   \nobreak\vskip4\UTD@blankline\@minus.15\UTD@blankline\relax
   {\singlespacing\frenchspacing
    \UTD@upper\@author\par}\nointerlineskip
   \nobreak\vskip5\UTD@blankline\@minus1.25\UTD@blankline\relax}%
}

% acknowledgments section
% -----------------------

\newcommand\UTD@ackdate{Month Year}
\newenvironment*{acks}[1]{%
  \UTD@order45{acknowledgments}%
  \def\UTD@ackdate{#1}%
  \clearpage
  \chapter*{Acknowledgments}%
  \begingroup
    \parindent\z@\parskip6\p@\@plus\z@\@minus\z@
    \vskip-\parskip
}{%
    \par
    \nobreak\nointerlineskip
    \vskip2\UTD@blankline\relax
    \hbox{\UTD@ackdate}%
  \endgroup
  \clearpage
}

% abstract section
% ----------------

\newenvironment{abstract}{%
  \UTD@order47{abstract}%
  \clearpage
  \@ifundefined{phantomsection}{}{\phantomsection}%
  \addcontentsline{toc}{chapter}{\UTD@texorpdf{ABSTRACT}{Abstract}}%
  \null\nointerlineskip\vskip-\topskip\kern0pt
  {\parskip\z@skip\baselineflex\z@skip\UTD@double
   {\centering
    \UTD@upsep\@title\par
    \vskip\UTD@blankline\relax
    \@author, \UTD@degabbr\par
    \singlespacing
    The University of Texas at Dallas, \UTD@year\par}\nointerlineskip
   \singlespacing
   \vskip4\UTD@blankline\relax
   \noindent\kern.5in\frenchspacing
   Supervising Professor\ifnum\UTD@numchairs>\@ne s\fi:
   \let\do\UTD@listchair
   \vtop{\UTD@profs}\par\nointerlineskip
   \vskip4\UTD@blankline\relax}%
  \begingroup
    \parindent\z@\parskip6\p@\@plus\z@\@minus\z@
    \vskip-\parskip
}{%
    \par
  \endgroup
  \clearpage
}

\newcommand\UTD@listchair[1]{%
  \ifx\UTD@cmtitle\@empty\else
    \hbox{\vrule\@width\z@\@depth3\p@\@height\baselineskip
          \ignorespaces#1\unskip\UTD@cmtitle}%
  \fi
}

% biosketch section
% -----------------

\newenvironment{biosketch}{%
  \UTD@appendixfalse
  \chapter*{\bioname}%
  \begingroup
    \parindent\z@\parskip6\p@\@plus\z@\@minus\z@%
    \vskip-\parskip
}{%
    \par
  \endgroup
  \clearpage
}

% vita section
% ------------

\newcommand\UTD@stopnumbering{\def\UTD@dotsnum##1{\nobreak\hfill\kern\z@}}

\newenvironment{vita}{%
  \clearpage
  \UTD@appendixfalse
  \addtocontents{toc}{\protect\UTD@stopnumbering}%
  \addtocontents{lot}{\protect\UTD@stopnumbering}%
  \addtocontents{lof}{\protect\UTD@stopnumbering}%
  \chapter*{\vitaname}%
  \pagestyle{empty}%
  \thispagestyle{empty}%
  \begingroup
    \parindent\z@\parskip\z@\@plus\z@\@minus\z@%
    \singlespacing
}{%
    \par
  \endgroup
  \clearpage
}

%% Part, Chapter, and Section Titles
%% =================================
%% The following redefine the part, chapter, and section titles so that they
%% are boldface and in a normal-sized font (as per UTD guidelines).

% footnotes in titles
% -------------------
% Make the \thanks macro work correctly inside part, chapter, and section
% titles.  We want it to act like \footnote, except protect it from the
% upper-casing applied to part and chapter titles, and suppress it in
% the table of contents and pdf bookmark index.  Since hyperref does not
% support footnotemark/footnotetext with the optional arguments, the built-in
% \thanks does not hyperfootnote properly.  We here fix this by saving and
% restoring \Hy@footnote@curentHref at footnotemark and footnotetext time,
% respectively.  This has no effect on non-hyperref users, since the saved
% and restored macro is unreferenced outside hyperref.

\@ifundefined{NoCaseChange}{
  \def\thanks{\UTD@texorpdf\UTD@protected@thanks\@gobble}
}{
  \def\thanks#1{\UTD@texorpdf{\NoCaseChange{\UTD@protected@thanks{#1}}}{}}
}

\newcommand\UTD@protected@thanks{%
  \ifx\protect\@typeset@protect
    \expandafter\UTD@thanks
  \else
    \expandafter\@gobble
  \fi
}

\newcommand\UTD@chpthanks[1]{%
  \footnotemark
  \protected@xdef\@thanks{\@thanks
    \protect\UTD@thankstext
      {\the\c@footnote}%
      {\@ifundefined{Hy@footnote@currentHref}{}\Hy@footnote@currentHref}%
      {#1}%
  }%
}

\newcommand\UTD@thankstext[3]{{%
  \c@footnote#1\relax
  \def\Hy@footnote@currentHref{#2}%
  \footnotetext{#3}%
}}

\newcommand\UTD@nowthank{%
  \@thanks
  \global\let\@thanks\@empty
  \def\UTD@thanks{\footnote}%
}
\UTD@nowthank

% numbered chapter
% ----------------

\def\@chapter[#1]#2{%
  \let\UTD@thanks\UTD@chpthanks
  \ifUTD@appendix
    \ifnum\c@chapter=\z@\xdef\UTD@apxline{\on@line}\else
      \global\let\UTD@apxline\relax
      \ifx\UTD@sapxline\relax\else\UTD@apxwarn\fi
    \fi
  \fi
  \ifnum\c@secnumdepth>\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\space\thechapter.}%
      \addcontentsline{toc}{chapter}{%
        \UTD@texorpdf{\UTD@upper\@chapapp\nobreakspace}%
                     {\ifUTD@appendix\@chapapp\space\thechapter: \fi}%
        \protect\numberline{\thechapter}%
        \UTD@texorpdf{\UTD@upper{#1}}{#1}}%
    \else
      \addcontentsline{toc}{chapter}{\UTD@texorpdf{\UTD@upper{#1}}{#1}}%
    \fi
  \else
    \addcontentsline{toc}{chapter}{\UTD@texorpdf{\UTD@upper{#1}}{#1}}%
  \fi
  \chaptermark{#1}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi
  \UTD@nowthank
}

% unnumbered chapter
% ------------------
% Same as book.cls except include an entry in the table of contents.  Also,
% if this is an appendix, we need to give it a secret label ("A").

\def\@schapter#1{%
  \let\UTD@thanks\UTD@chpthanks
  \ifUTD@appendix
    \ifnum\c@chapter=\z@\xdef\UTD@sapxline{\on@line}\else\UTD@sapxwarn\fi
    \refstepcounter{chapter}%
    \addcontentsline{toc}{chapter}{\UTD@texorpdf
      {\UTD@upper{\@chapapp\kern1em\relax#1}}{\@chapapp: #1}}%
  \else
    \addcontentsline{toc}{chapter}{\UTD@texorpdf{\UTD@upper{#1}}{#1}}%
  \fi
  \if@twocolumn
    \@topnewpage[\@makeschapterhead{#1}]%
  \else
    \@makeschapterhead{#1}%
    \@afterheading
  \fi
  \UTD@nowthank
}

% numbered chapter titles
% -----------------------

\def\@makechapterhead#1{%
  \null\nointerlineskip\vskip-\topskip\kern0pt
  {\centering\let\\\UTD@sep\parskip\z@skip\UTD@double\normalfont\normalsize
   \ifnum\c@secnumdepth>\m@ne
     \if@mainmatter
       \bfseries\UTD@upper\@chapapp\nobreakspace\thechapter
       \par\nobreak
     \fi
   \fi
   \interlinepenalty\@M
   \UTD@upper{#1}\par\nobreak\nointerlineskip
   \vskip2\UTD@blankline\relax}%
}

% unnumbered chapter titles
% -------------------------

\def\@makeschapterhead#1{%
  \null\nointerlineskip\vskip-\topskip\kern0pt
  {\centering\let\\\UTD@sep\parskip\z@skip\UTD@double\normalfont\normalsize
   \if@mainmatter\bfseries\fi
   \interlinepenalty\@M
   \ifUTD@appendix\UTD@upper\@chapapp\par\nobreak\fi
   \UTD@upper{#1}\par\nobreak\nointerlineskip
   \vskip2\UTD@blankline\relax}%
}

% chapter title page
% ------------------
% Chapter title pages are needed for chapters consisting of verbatim-reproduced
% publications.  Authors may put arbitrary, extra publication information at
% the bottom of such pages, so we need an environment rather than just a macro.

\newcommand\UTD@ctitle{}
\newcommand\UTD@cdept{}
\newcommand\UTD@cauth{}
\newcommand\UTD@old@mch{}
\newcommand\UTD@old@afterhead{}

\newenvironment{chaptertitlepage}[4][\UTD@ctitle]{%
  \if@twocolumn\@restonecoltrue\onecolumn\else\@restonecolfalse\fi
  \def\UTD@ctitle{#2}\def\UTD@cauth{#3}\def\UTD@cdept{#4}%
  \let\UTD@old@mch\@makechapterhead\let\@makechapterhead\UTD@makectphead
  \let\UTD@old@afterhead\@afterheading\let\@afterheading\relax
  \chapter[{#1}]{#2}%
  \let\@makechapterhead\UTD@old@mch\let\@afterheading\UTD@old@afterhead
  \vfill
  \singlespacing
  \interlinepenalty\@M\parindent\z@\parskip\z@skip\normalfont\normalsize
}
{\clearpage\if@restonecol\twocolumn\fi}

\newcommand\UTD@makectphead[1]{%
  \null\nointerlineskip\vskip-\topskip\kern0pt
  {\centering\let\\\UTD@sep\UTD@double
   \interlinepenalty\@M\parskip\z@skip\normalfont\normalsize
   {\bfseries
    \ifnum\c@secnumdepth>\m@ne
      \UTD@upper\@chapapp\nobreakspace\thechapter\par\nobreak
    \fi
    \UTD@upper{#1}}\par\nobreak\nointerlineskip%
   \vskip6\UTD@blankline\relax
   {Authors\nobreakspace--\nobreakspace\sfcode`\.\@m\ignorespaces\UTD@cauth\par
    \nobreak}%
   \vskip\UTD@blankline\relax
   {\ignorespaces\UTD@cdept\par\nobreak}%
   \vskip\UTD@blankline\relax
   {The University of Texas at Dallas\par\nobreak}%
   \vskip\UTD@blankline\relax
   {800 West Campbell Road\par\nobreak}%
   \vskip\UTD@blankline\relax
   {Richardson, Texas 75080-3021\par\nobreak\nointerlineskip}}%
}

% numbered parts
% --------------
% Most theses just have chapters, not "parts" that group multiple chapters,
% but we define it just in case.

\def\@part[#1]#2{%
  \setcounter{footnote}\z@
  \ifnum\c@secnumdepth>-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\UTD@texorpdf
      {\UTD@upper\partname\space\thepart\hspace{1em}\UTD@upper{#1}}%
      {\partname\space\thepart: #1}}%
  \else
    \addcontentsline{toc}{part}{\UTD@upper{#1}}%
  \fi
  \markboth{}{}%
  {\centering\let\\\UTD@sep\UTD@double\parskip\z@skip
   \interlinepenalty\@M
   \normalfont\normalsize
   \ifnum\c@secnumdepth>-2\relax
     \bfseries\UTD@upper\partname\nobreakspace\thepart\par
     \vskip2\UTD@blankline\relax
   \fi
   \bfseries\UTD@upper{#2}\par}%
  \@endpart
}

% unnumbered parts
% ----------------

\def\@spart#1{%
  \setcounter{footnote}\z@
  {\centering\let\\\UTD@sep\UTD@double\parskip\z@skip
   \interlinepenalty\@M
   \normalfont\normalsize
   \bfseries\UTD@upper{#1}\par}%
  \@endpart
}

% Sections and subsections
% ------------------------
% Sections are same as book.cls, but with no font size changes.

\renewcommand\section{\@startsection{section}{1}{\z@}%
                                    {-3.5ex \@plus-1ex \@minus-.2ex}%
                                    {2.3ex \@plus.2ex}%
                                    {\normalfont\normalsize\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                       {-3.25ex \@plus-1ex \@minus-.2ex}%
                                       {1.5ex \@plus.2ex}%
                                       {\normalfont\normalsize\bfseries}}

%% Table of Contents, and Lists of Tables/Figures
%% ==============================================

\renewcommand\tableofcontents{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  {\let\addtocontents\@gobbletwo
   \chapter*{\contentsname
     \@mkboth{\UTD@upper\contentsname}{\UTD@upper\contentsname}}}%
  \UTD@firstitemtrue
  \@starttoc{toc}%
  \if@restonecol\twocolumn\fi
}

\renewcommand\listoffigures{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{\listfigurename}%
  \@mkboth{\UTD@upper\listfigurename}%
          {\UTD@upper\listfigurename}%
  \UTD@firstitemtrue
  \@starttoc{lof}%
  \if@restonecol\twocolumn\fi
}

\renewcommand\listoftables{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{\listtablename}%
  \@mkboth{\UTD@upper\listtablename}%
          {\UTD@upper\listtablename}%
  \UTD@firstitemtrue
  \@starttoc{lot}%
  \if@restonecol\twocolumn\fi
}

% Chapter entries in the table of contents
% ----------------------------------------
% Same as book.cls, but with non-bold font, single-spaced (within an entry)
% and with dotted lines added to even the high-level entries

\newcommand\UTD@dotsnum[1]{%
  \nobreak
  \leaders\hbox{$\m@th
    \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
    mu$}\hfill
  \nobreak\hb@xt@\@pnumwidth{#1}%
}

\newif\ifUTD@firstitem

\newcommand\UTD@listskip{%
  \ifUTD@firstitem\UTD@firstitemfalse\else
    \vskip.5\UTD@blankline\@plus\p@\@minus\p@
  \fi
}

\newcommand\UTD@tocpenalty{\@highpenalty}

\renewcommand*\l@chapter[2]{%
  \UTD@listskip
  \ifnum\c@tocdepth>\m@ne
    \addpenalty{-\@highpenalty}%
    \setlength\@tempdima{1.5em}%
    \begingroup\singlespacing
      \parindent\z@\rightskip\@pnumwidth
      \parfillskip-\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip-\leftskip
      #1\UTD@dotsnum{\hss#2}\par
      \penalty\UTD@tocpenalty
    \endgroup
  \fi
}

% Part entries in the table of contents
% -------------------------------------
% Same changes as chapter entries

\renewcommand*\l@part[2]{%
  \UTD@listskip
  \ifnum\c@tocdepth>-2\relax
    \addpenalty{-\@highpenalty}%
    \setlength\@tempdima{1.5em}%
    \begingroup\singlespacing
      \parindent\z@\rightskip\@pnumwidth
      \parfillskip-\@pnumwidth
      {\leavevmode#1\UTD@dotsnum{\hss#2}}\par
      \nobreak
      \global\@nobreaktrue
      \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi
}

% Dotted lines in table of contents and lists of tables/figures
% -------------------------------------------------------------
% Same as book.cls but with space added between entries and single-spaced
% within entries, and with no indentation from left margin

\def\@dottedtocline#1#2#3#4#5{%
  \ifnum#1>\c@tocdepth\else
    \UTD@listskip
    {\singlespacing\leftskip#2\relax\rightskip\@tocrmarg\parfillskip-\rightskip
     \parindent#2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima#3\relax
     \advance\leftskip\@tempdima \null\nobreak\hskip-\leftskip
     {#4}\UTD@dotsnum{\hfil\normalfont\normalcolor#5}\par}%
  \fi
}

\renewcommand*\l@figure{\@dottedtocline{1}{0pt}{2.3em}}
\let\l@table\l@figure

%% Appendixes
%% ==========
%% LaTeX appendixes work fine as-is, except if there is only one appendix.
%% A solo appendix must not be labeled (i.e., no "A") in the appendix title
%% or in the table of contents.  However, secretly its label is actually "A"
%% in case there are subsections, tables, figures, equations, etc., within it.

\newif\ifUTD@appendix
\UTD@appendixfalse

\renewcommand\appendix{\par\UTD@appendixtrue
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}}

\newcommand\UTD@apxline{}
\let\UTD@apxline\relax
\newcommand\UTD@sapxline{}
\let\UTD@sapxline\relax

\newcommand\UTD@apxwarn{%
  \UTD@warnnl{\protect\chapter* should be \protect\chapter\UTD@sapxline}%
  \global\let\UTD@sapxline\relax
}

\newcommand\UTD@sapxwarn{%
  \global\let\UTD@apxline\relax
  \ifx\UTD@sapxline\relax\else\UTD@apxwarn\fi
  \UTD@warn{\protect\chapter* should be \protect\chapter}}

\AtEndDocument{%
  \ifx\UTD@apxline\relax\else
    \UTD@warnnl{\protect\chapter\space should be \protect\chapter*\UTD@apxline}%
  \fi
}

%% Figure/Table Captions
%% =====================
%% Change figure and table captions to "Figure/Table. caption" (same as
%% book.cls except with a period instead of colon).  Also, provide a
%% \contcaption macro for split tables continued on the next page.

\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1. #2}%
  \ifdim\wd\@tempboxa>\hsize
    #1. #2\par
  \else
    \global\@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip
}

\newcommand\UTD@ccalign{\hfil}

% The following two lines push stand-alone floats to the tops of pages
% instead of centering.  Both Turabian and the grad school are unclear as to
% whether this is required.  If it is not, comment-out these two lines.
\AtBeginDocument{\@fptop\z@skip}
\let\UTD@ccalign\relax

\newcommand\contcaption{%
  \ifx\@captype\@undefined
    \@latex@error{\noexpand\caption outside float}\@ehd
  \fi
  \par
  \begingroup
    \@parboxrestore
    \if@minipage\@setminipage\fi
    \normalsize\itshape
    \vskip\abovecaptionskip
    \global\@minipagefalse
    \hb@xt@\hsize{\UTD@ccalign\csname fnum@\@captype\endcsname
                  \nobreakspace continued\hfil}%
    \vskip\belowcaptionskip
    \par
  \endgroup
}

\renewcommand\topfraction{0.9} % allow 90% of the page to be figures
\renewcommand\bottomfraction{0} % never put figures at bottom
\setcounter{topnumber}{9} % allow many figures at top
\setcounter{bottomnumber}{0} % never put figures at bottom
\setcounter{totalnumber}{9} % allow many figures per page
\renewcommand\textfraction{0.07} % allow minimal text with figures
\renewcommand\floatpagefraction{0.7} % prefer fuller float pages
\def\fps@figure{tp} % default position of figures is top-or-page
\def\fps@table{tp} % default position of tables is top-or-page

%% Bibliography
%% ============
%% LaTeX defines the "thebibliography" environment to typeset bibliographies,
%% but it is unwise to modify that environment directly because most authors
%% should use a bibliography package (there are hundreds of them) and many of
%% those completely overwrite "thebibliography", erasing any change made here.
%% UTD demands that bibliographies must be single-spaced within entries and
%% double-spaced between.  We therefore take the approach of giving users
%% a "thesisbib" environment that switches to single-spacing, and hope that
%% whatever bibliography commands are used inside it will put appropriate
%% spacing between the entries.
%%
%% The bibliography package we recommend is "natbib", which is widely
%% available and cross-compatible.  However, natbib has one annoying bug
%% (as of natbib 8.31b dated 2010/09/13) that we here correct.  When natbib's
%% "numbers" option is used to number an otherwise authoryear-only style
%% (e.g., chicago), the bibliography entries get incorrect hanging indentation
%% because the indent width depends on the largest numbered entry, and the
%% bibliography style (bst) doesn't record that information (to the bbl file)
%% because it doesn't know about numbering.  To fix this problem, we program
%% the thesisbib environment to record the largest number to the aux file.
%% Then we hack natbib's numerical mode setup macro so that if the bst file
%% has not recorded the max number, it uses the one recorded in the aux file as
%% the default.  Our implementation is carefully arranged so that if natbib is
%% not used, these hacks have no effect (they do not throw errors or break any
%% other package's behavior).  Moreover, we hope that by wrapping instead of
%% replacing the affected natbib macro, this patch will remain compatible with
%% future versions of natbib.

\newcommand\UTD@bibmax{99}
\newcommand\UTD@nbsn[1]{}

\newcommand\UTD@bibsetnum[1]{%
  \def\UTD@temp{#1}%
  \ifx\UTD@temp\@empty\UTD@nbsn\UTD@bibmax\else\UTD@nbsn{#1}\fi
}

\newcommand\UTD@bibnumsetup{%
  \@ifpackageloaded{natbib}{%
    \@ifpackagelater{natbib}{1996/03/05}{}{%
      \UTD@err{You are using a very old version of natbib, dated\MessageBreak
        \csname ver@natbib.sty\endcsname.\MessageBreak
        Utdthesis only supports natbib 6.2 or later}}%
    \let\UTD@nbsn\NAT@bibsetnum
    \let\NAT@bibsetnum\UTD@bibsetnum
  }%
}

\AtBeginDocument{\UTD@bibnumsetup}

\newenvironment{thesisbib}{%
  \clearpage
  \UTD@appendixfalse
  \addtocontents{toc}{\def\protect\UTD@tocpenalty{\@M}}%
  \begingroup\singlespacing
}{%
  \if@filesw
    \@ifundefined{c@NAT@ctr}{}{%
      \immediate\write\@mainaux{\gdef\string\UTD@bibmax{\the\c@NAT@ctr}}}%
  \fi
  \endgroup
  \clearpage
}

\endinput

