%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  AASTEX7.cls                                   %%
%%  March, 2024                                   %% 
%%                                                %%
%%  Copyright 2024 American Astronomical Society  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\def\currversion{7}
%
%%
%%    These files are distributed
%%    WITHOUT ANY WARRANTY; without even the implied warranty of
%%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
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
%%   Right brace   \}     Tilde         \~}%
%%
%%%     date            = "9/19/2016",
%%%     author          = "Amy Hendrickson (mailto:amyh@texnology.com)" 
%%%                            including 
%%%                       1) code from emulateapj.cls, version 01/23/15(marked below)
%%%                            written by Alexey Vikhlinin, which relies on RevTeX4-1
%%%                            for much functionality;
%%%                       2) some code from aastex (marked below)
%%%                       3) Original work by Amy Hendrickson (marked below) for
%%%                       extensive table tools, including easy decimal entry and splitting
%%%                       tables horizontally into 2 or 3 pieces, for tabular and deluxetable
%%%                       environments; rotate tables; gridlines for use in positioning figures, 
%%%                       track changes.

%%% This work may be distributed and/or modified under the 
%%% conditions of the LaTeX Project Public License, either version 1.3c 
%%% of this license or (at your option) any later version.
%%% The latest version of this license is in
%%%  http://www.latex-project.org/lppl.txt
%%% and version 1.3 or later is part of all distributions of LaTeX 
%%% version 2005/12/01 or later.
%
%%% This work has the LPPL maintenance status `maintained'.
%
%%% The Current Maintainer of this work is Greg Schwarz <greg.schwarz@aas.org> 
%%% This work consists of the file aastex.cls
%
%%%     copyright       = "Copyright (C) 2016--2020 American Astronomical Society
%%%
%%%                        This work may be distributed and/or modified under the
%%%                        conditions of the LaTeX Project Public License, either version 1.3
%%%                        of this license or (at your option) any later version.
%%%                        The latest version of this license is in
%%%                        http://www.latex-project.org/lppl.txt
%%%                        and version 1.3 or later is part of all distributions of LaTeX
%%%                        version 2003/12/01 or later.
%%%
%%%                        This work has the LPPL maintenance status "maintained".
%%%
%%%                        The Current Maintainer of this work is the American Astronomical Society.
%%%
%%%                        This work consists of all files listed in the document README.
%%%
%%%     address         = "American Astronomical Society
%%%                        USA",
%%%     telephone       = "+1 ???",
%%%     FAX             = "",
%%%     email           = "aastex-help@aas.org",
%%%     codetable       = "ISO/ASCII",
%%%     keywords        = "latex, AAS, journal",
%%%     supported       = "yes",
%%%     abstract        = "formatter for AAS journal submissions",
%%%  }
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%     date            = "04/27/2024",
%%%     author          = "Aptara Technology Team" including 
%%%                       1) Based on aastex631.cls, version 01/23/15(marked below)
%%%                            written by Amy Hendrickson, which relies on RevTeX4-1
%%%                            for much functionality;
%%%                       2) To support the existing functionalities utilized the RevTeX4-2 macros 
%%%
\ProvidesClass{aastex7}%%%
 [2025/02/06 Version 7/AAS markup document class]%
{}
\ClassInfo{aastex}{%
^^J^^J
 Original \protect\LaTeX2.09 style
 by Chris Biemesderfer (chris@seagoat.com).
^^J
 Adapted to \protect\LaTeXe\space
 by A. Ogawa (ogawa@teleport.com)%
^^J
emulateapj.cls included, Copyright 2000-2015 Alexey Vikhlinin
^^J
Rewrite and update of emulateapj.cls,
revised and enhanced with table macros, gridlines, draft watermark,^^J
track changes, new `modern' style and much more, by Amy Hendrickson,%
^^J
 (amyh@texnology.com, http://www.texnology.com)
^^J
^^J
}%

\let\class@name\@gtempa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% aastex.cls version 2.0 is a based on emulateapj.cls, version January 23, 2015,
%% and an older version of aastex.cls, with many additional functionalities.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Options. Document style options, and additional feature options.

% These are the General document style options, 6 choices

%   manuscript	: onecolumn, doublespace, 12pt fonts

%%  Preprints are like manuscript, except they are single spaced.
%   preprint	: onecolumn, single space, 12pt fonts
%   preprint2	: twocolumn, single space, 12pt fonts

%% Modern is new design developed by David Hogg and Daniel Foreman-Mackey
%   modern      : one column, single space, 12pt fonts, more stylish

%   twocolumn	: a two column article, single space, 10pt  fonts

% Default document style option
%   onecolumn	: a one column article; single space, 10pt fonts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Additional feature options:
%%
%%   twocolappendix  :   make 2 column appendix // produces error message. 
%%   onecolappendix  :   make 1 column appendix is the default. // not needed because it is the default
%%   astrosymb	     :   Loads Astrosymb font and define \astro commands. 
%%   tighten	     :   Makes baselineskip slightly smaller, only works with twocolumn option.
%%                       author can also use the commands \tighten, or \singlespace or \doublespace in the body of their article
%%                       to get this change to the baselineskip
%%   times	     :   uses times font as the default
%%   linenumbers     :   turn on lineno package.
%%   trackchanges    :   required to see the revision mark up and print output
%%   letteredappendix:   (was numbered appendix) Not needed because it is the default, will label appendix sections A, B, ...
%%                       Legacy command, will produce same results as lettered appendix, since we don't want more
%%                       than one `section 1' in article: will cause problems for cross referencing.
%%
%%   anonymous       :   to not list authors/affiliations be listed
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
\newif\iftwelvepoint
\newif\ifmodern
\newif\ifdoublespace
\newif\if@two@col
\newif\ifonecolstyle
\newif\ifpreprinttwo
\newif\if@two@col@app
\newif\iflongauthor
\newif\iflongbib
\newif\ifresetfootnote
\newif\ifletteredappendix
\newif\if@number@appendix@floats


\DeclareOption{twocolappendix}{\@two@col@apptrue}
\DeclareOption{onecolappendix}{\@two@col@appfalse}%% this is default
\DeclareOption{longauthor}{\global\longauthortrue\ExecuteOptions{unsortedaddress}}
\DeclareOption{longbib}{\global\longbibtrue}
\DeclareOption{resetfootnote}{\global\resetfootnotetrue}
\DeclareOption{astrosymb}{
  \def\astro#1{\leavevmode\hbox{\astro@font#1}}%
  \def\load@astro@font{%
    \iftwelvepoint
      \font\astro@font=astrosym at 8pt
    \else
      \font\astro@font=astrosym at 7pt
    \fi
  }%
   \AtBeginDocument{\load@astro@font}
}
\DeclareOption{letteredappendix}{\global\letteredappendixtrue
  \def\AppendixApjSectionMarkInTitle#1{#1.\ }
}
\DeclareOption{numberedappendix}{\global\letteredappendixtrue
    \def\AppendixApjSectionMarkInTitle#1{#1.\ }
}

\DeclareOption{appendixfloats}{\@number@appendix@floatstrue}


%% Default definition for \astro, in case astrosymb option has not
%% been used:
\def\astro#1{\@latex@error{^^J^^J Please use class option `astrosymb' to
access fonts for the \string\astro\space command
^^J^^J
}\@ehc\stop}

\newlength{\bibbaselineskip}\setlength{\bibbaselineskip}{3.075mm}
\def\apjsecfont{\normalsize}
\def\secnum@size{\small}
\def\subsecnum@size{\normalsize}

\def\AppendixApjSectionMarkInTitle#1{\relax}


%%%%%%%%%%%%%
%% This option changes the baselineskips in the definitions of \normalsize etc
%% to make them a bit smaller.
\newif\iftighten
\DeclareOption{tighten}{\global\tightentrue}

\newif\iftimes
\DeclareOption{times}{\global\timestrue}

\newif\ifnumlines
\DeclareOption{linenumbers}{\global\numlinestrue}

\newif\iftrack
\DeclareOption{trackchanges}{\global\tracktrue}

\newif\ifanonymous
\DeclareOption{anonymous}{\global\anonymoustrue}

%%%%%%%%%%%%%
%

\iftimes
  \usepackage{times}
\fi

%%%%%%%%%%%%%

\if@compatibility
  \edef\reserved@a{\errhelp{%
   Change your \string\documentstyle\space statement to
   \string\documentclass\space and rerun.
  }}\reserved@a
  \errmessage{You cannot run \class@name\space in compatability mode}%
  \expandafter\@@end
\fi

\def\class@err#1{\ClassError{\class@name}{#1}\@eha}%
\def\class@warn#1{\ClassWarningNoLine{\class@name}{#1}}%
\def\class@info#1{\ClassInfo{\class@name}{#1}}%

\def\obsolete@command#1{%
 \class@warn@end{Command \string#1\space is obsolete.^^JPlease remove from your document}%
 \global\let#1\@empty
 #1%
}%
\def\replace@command#1#2{%
 \class@warn@end{Command \string#1\space is obsolete;^^JUse \string#2\space instead}%
 \global\let#1#2%
 #1%
}%
\def\replace@environment#1#2{%
 \class@warn@end{Environment #1 is obsolete;^^JUse #2 instead}%
 \glet@environment{#1}{#2}%
 \@nameuse{#1}%
}%
\def\incompatible@package#1{%
 \@ifpackageloaded{#1}{%
  \def\@tempa{I cannot continue. You must remove the \string\usepackage\ statement that caused that package to be loaded.}%
  \ClassError{\class@name}{The #1 package cannot be used with \class@name}%
  \@tempa\stop
 }{%
  \class@info{#1 was not loaded (OK!)}%
 }%
}%
\def\class@warn@end#1{%
 \gappdef\class@enddocumenthook{\class@warn{#1}}%
}%
\ifx\undefined\class@name
 \def\class@name{ltxutil}%
 \class@warn{You should define the class name before reading in this package. Using default}%
\fi
\def\t@{to}%
\dimendef\dimen@iii\thr@@
\def\halignt@{\halign\t@}%
\chardef\f@ur=4\relax
\chardef\cat@letter=11\relax
\chardef\other=12\relax
\def\let@environment#1#2{%
 \expandafter\let
 \csname#1\expandafter\endcsname\csname#2\endcsname
 \expandafter\let
 \csname end#1\expandafter\endcsname\csname end#2\endcsname
}%
\def\glet@environment#1#2{%
 \global\expandafter\let
 \csname#1\expandafter\endcsname\csname#2\endcsname
 \global\expandafter\let
 \csname end#1\expandafter\endcsname\csname end#2\endcsname
}%
\newcommand\tracingplain{%
 \tracingonline\z@\tracingcommands\z@\tracingstats\z@
 \tracingpages\z@\tracingoutput\z@\tracinglostchars\@ne
 \tracingmacros\z@\tracingparagraphs\z@\tracingrestores\z@
 \showboxbreadth5\showboxdepth3\relax %\errorstopmode
 }%
\newcommand\traceoutput{%
 \appdef\@resetactivechars{\showoutput}%
}%
\newcommand\say[1]{\typeout{<\noexpand#1=\meaning#1>}}%
\newcommand\saythe[1]{\typeout{<\noexpand#1=\the#1>}}%
\def\fullinterlineskip{\prevdepth\z@}%
\countdef\count@i\@ne
\countdef\count@ii\tw@
\long\def\prepdef#1#2{%
 \@ifxundefined#1{\toks@{}}{\toks@\expandafter{#1}}%
 \toks@ii{#2}%
 \edef#1{\the\toks@ii\the\toks@}%
}%
\long\def\appdef#1#2{%
 \@ifxundefined#1{\toks@{}}{\toks@\expandafter{#1}}%
 \toks@ii{#2}%
 \edef#1{\the\toks@\the\toks@ii}%
}%
\long\def\gappdef#1#2{%
 \@ifxundefined#1{\toks@{}}{\toks@\expandafter{#1}}%
 \toks@ii{#2}%
 \global\edef#1{\the\toks@\the\toks@ii}%
}%
\long\def\appdef@val#1#2{%
 \appdef#1{{#2}}%
}%
\long\def\appdef@e#1#2{%
 \expandafter\appdef
 \expandafter#1%
 \expandafter{#2}%
}%
\long\def\appdef@eval#1#2{%
 \expandafter\appdef@val
 \expandafter#1%
 \expandafter{#2}%
}%
\toksdef\toks@ii=\tw@
\long\def\@ifxundefined#1{\@ifx{\undefined#1}}%
\long\def\@ifnotrelax#1#2#3{\@ifx{\relax#1}{#3}{#2}}%
\long\def\@argswap#1#2{#2#1}%
\long\def\@argswap@val#1#2{#2{#1}}%
\def\@ifxundefined@cs#1{\expandafter\@ifx\expandafter{\csname#1\endcsname\relax}}%
\ifx\IfFormatAtLeastTF\undefined
  \def\rvtx@ifformat@geq{\@ifl@t@r\fmtversion}%
\else
  \let\rvtx@ifformat@geq\IfFormatAtLeastTF
\fi
\def\@boolean#1#2{%
  \long\def#1{%
    #2% \if<something>
      \expandafter\true@sw
    \else
      \expandafter\false@sw
    \fi
  }%
}%
\def\@boole@def#1#{\@boolean{#1}}% Implicit #2
\def\@booleantrue#1{\let#1\true@sw}%
\def\@booleanfalse#1{\let#1\false@sw}%
\@boole@def\@ifx#1{\ifx#1}%
\@boole@def\@ifx@empty#1{\ifx\@empty#1}%
\@boole@def\@if@empty#1{\if!#1!}%
\def\@if@sw#1#2{#1\expandafter\true@sw\else\expandafter\false@sw#2}%
\@boole@def\@ifdim#1{\ifdim#1}%
\@boole@def\@ifeof#1{\ifeof#1}%
\@boole@def\@ifhbox#1{\ifhbox#1}%
\@boole@def\@ifhmode{\ifhmode}%
\@boole@def\@ifinner{\ifinner}%
\@boole@def\@ifmmode{\ifmmode}%
\@boole@def\@ifnum#1{\ifnum#1}%
\@boole@def\@ifodd#1{\ifodd#1}%
\@boole@def\@ifvbox#1{\ifvbox#1}%
\@boole@def\@ifvmode{\ifvmode}%
\@boole@def\@ifvoid#1{\ifvoid#1}%
\long\def\true@sw#1#2{#1}%
\long\def\false@sw#1#2{#2}%
\long\def\loopuntil#1{#1{}{\loopuntil{#1}}}%
\long\def\loopwhile#1{#1{\loopwhile{#1}}{}}%
\def\@provide#1{%
 \@ifx{\undefined#1}{\true@sw}{\@ifx{\relax#1}{\true@sw}{\false@sw}}%
 {\def#1}{\def\j@nk}%
}%
\rvtx@ifformat@geq{2020/10/01}%
  {%
    \AddToHook{begindocument/before}{\document@inithook}%
  }{%
    \prepdef\document{%
     \endgroup
     \document@inithook
     \true@sw{}%
    }%
  }
\let\document@inithook\@empty
\appdef\document@inithook{%
 \AtBeginDocument{\class@documenthook}%
}%
\AtEndDocument{%
 \class@enddocumenthook
}%
\let\class@documenthook\@empty
\let\class@enddocumenthook\@empty
\rvtx@ifformat@geq{2020/10/01}{%
  % <definitions for newer LaTeX later>
}{%
  % <definitions for older LaTeX>
\def\enddocument{%
 \let\AtEndDocument\@firstofone
 \@enddocumenthook
 \@checkend{document}%
 \clear@document
 \check@aux
 \deadcycles\z@
 \@@end
}%
\def\check@aux{\do@check@aux}%
\def\do@check@aux{%
 \@if@sw\if@filesw\fi{%
  \immediate\closeout\@mainaux
  \let\@setckpt\@gobbletwo
  \let\@newl@bel\@testdef
  \@tempswafalse
  \makeatletter
  \input\jobname.aux\relax
 }{}%
 \@dofilelist
 \@ifdim{\font@submax >\fontsubfuzz\relax}{%
  \@font@warning{%
   Size substitutions with differences\MessageBreak
   up to \font@submax\space have occured.\@gobbletwo
  }%
 }{}%
 \@defaultsubs
 \@refundefined
 \@if@sw\if@filesw\fi{%
  \@ifx{\@multiplelabels\relax}{%
   \@if@sw\if@tempswa\fi{%
    \@latex@warning@no@line{%
     Label(s) may have changed.
     Rerun to get cross-references right%
    }%
   }{}%
  }{%
    \@multiplelabels
  }%
 }{}%
}%
}
\rvtx@ifformat@geq{2020/10/01}{%
  \AddToHook{enddocument}{\rvtx@enddocument@patch{}}%
}{}
\protected\long\def\rvtx@enddocument@patch#1#2\@checkend#3{%
  \begingroup
    \edef\x{\detokenize{#3}}%
    \edef\y{\detokenize{document}}%
  \expandafter\endgroup
  \ifx\x\y
    \expandafter\rvtx@enddocument@patch@end
  \else
    \expandafter\rvtx@enddocument@patch@more
  \fi
    {#1#2}{#3}}
\def\rvtx@enddocument@patch@more#1#2{%
  \rvtx@enddocument@patch{#1\@checkend{#2}}}
\long\def\rvtx@enddocument@patch@end#1#2\clearpage#3\endgroup{%
  \def\do@check@aux{#3\endgroup}%
  #1%
  \@checkend{#2}%
  \clear@document
  \check@aux}
\def\check@aux{\do@check@aux}%
\def\clear@document{%
 \clearpage
 \do@output@cclv{%
  \Call@AfterLastShipout
 }%
}%
\appdef\class@documenthook{%
 \providecommand\Call@AfterLastShipout{}%
}%
\def\flushing{%
  \let\\\@normalcr
  \leftskip\z@skip
  \rightskip\z@skip
  \@rightskip\z@skip
  \parfillskip\@flushglue
}%
\expandafter\DeclareRobustCommand\expandafter\@centercr\expandafter{\@centercr}%
\def\rvtx@tmpa#1{%
\def\eqnarray@LaTeX{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   #1% \def\@currentcounter{equation} on newer LaTeX
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{####}$\@eqnsel
      &\global\@eqcnt\@ne\hskip \tw@\arraycolsep \hfil${####}$\hfil
      &\global\@eqcnt\tw@ \hskip \tw@\arraycolsep
         $\displaystyle{####}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss####\egroup
         \tabskip\z@skip
      \cr
}%
\long\def\eqnarray@fleqn@fixed{%
 \stepcounter{equation}\def\@currentlabel{\p@equation\theequation}%
 #1% \def\@currentcounter{equation} on newer LaTeX
 \global\@eqnswtrue\m@th\global\@eqcnt\z@
 \tabskip\ltx@mathindent
 \let\\=\@eqncr
 \setlength\abovedisplayskip{\topsep}%
 \ifvmode\addtolength\abovedisplayskip{\partopsep}\fi
 \addtolength\abovedisplayskip{\parskip}%
 \setlength\belowdisplayskip{\abovedisplayskip}%
 \setlength\belowdisplayshortskip{\abovedisplayskip}%
 \setlength\abovedisplayshortskip{\abovedisplayskip}%
 $$%
 \everycr{}%
 \halignt@\linewidth\bgroup
  \hskip\@centering$\displaystyle\tabskip\z@skip{####}$\@eqnsel
  &\global\@eqcnt\@ne
   \hskip\tw@\eqncolsep
   \hfil${{}####{}}$\hfil
  &\global\@eqcnt\tw@
   \hskip\tw@\eqncolsep
   $\displaystyle{####}$\hfil\tabskip\@centering
  &\global\@eqcnt\thr@@\hb@xt@\z@\bgroup\hss####\egroup
   \tabskip\z@skip
  \cr
}%
}
\rvtx@tmpa{}% older LaTeX
\@ifx{\eqnarray\eqnarray@LaTeX}{\@firstofone}
  {%
    \rvtx@tmpa{\def\@currentcounter{equation}}% newer LaTeX
    \@ifx{\eqnarray\eqnarray@LaTeX}{\@firstofone}
      {\@gobble}
  }
{%
 \class@info{Repairing broken LaTeX eqnarray}%
 \let\eqnarray\eqnarray@fleqn@fixed
 \newlength\eqncolsep
 \setlength\eqncolsep\z@
 \let\eqnarray@LaTeX\relax
 \let\eqnarray@fleqn@fixed\relax
}%
\def\ltx@mathindent{\@centering}%
\def\set@eqnarray@skips{}%
\def\prep@math{%
 \@ifvmode{\everypar{{\setbox\z@\lastbox}}}{}%
}%
\def\prep@math@patch{%
 \prepdef\equation{\prep@math}%
 \prepdef\eqnarray{\prep@math}%
}%
\appdef\class@documenthook{%
 \let\footnote@latex\footnote
 \@ifpackageloaded{hyperref}{}{%
  \let\H@@footnotetext\@footnotetext
  \def\@footnotetext{\H@@footnotetext}%
  \let\H@@mpfootnotetext\@mpfootnotetext
  \def\@mpfootnotetext{\H@@mpfootnotetext}%
 }%
}%
\def\ltx@make@current@footnote#1#2{%
  \csname c@#1\endcsname#2\relax
  \protected@edef\Hy@footnote@currentHref{\@currentHref-#1.\csname the#1\endcsname}%
}%
\def\thempfootnote@latex{{\itshape \@alph \c@mpfootnote }}%
\def\ltx@thempfootnote{\@alph\c@mpfootnote}%
\@ifx{\thempfootnote\thempfootnote@latex}{%
 \class@info{Repairing hyperref-unfriendly LaTeX definition of \string\mpfootnote}%
 \let\thempfootnote\ltx@thempfootnote
}{}%

\long\def\@footnotetext{%
 \insert\footins\bgroup
  \make@footnotetext
}%
\long\def\@mpfootnotetext{%
 \minipagefootnote@pick
  \make@footnotetext
}%
\long\def\make@footnotetext#1{%
  \set@footnotefont
  \set@footnotewidth
  \@parboxrestore
  \protected@edef\@currentlabel{%
   \csname p@\@mpfn\endcsname\@thefnmark
  }%
  \color@begingroup
   \@makefntext{%
    \rule\z@\footnotesep\ignorespaces#1%
    \@finalstrut\strutbox\vadjust{\vskip\z@skip}%
   }%
  \color@endgroup
 \minipagefootnote@drop
}%
\def\set@footnotefont{%
  \reset@font\footnotesize
  \interlinepenalty\interfootnotelinepenalty
  \splittopskip\footnotesep
  \splitmaxdepth\dp\strutbox
}%
\def\set@footnotewidth{\set@footnotewidth@one}%
\def\robustify@contents{%
 \let \label \@gobble
 \let \index \@gobble
 \let \glossary \@gobble
 \let\footnote \@gobble
 \def\({\string\(}%
 \def\){\string\)}%
 \def\\{\string\\}%
}%
\long\def\addtocontents#1#2{%
 \protected@write\@auxout{\robustify@contents}{\string \@writefile {#1}{#2}}%
}%
\def\addcontentsline#1#2#3{%
 \addtocontents{#1}{%
  \protect\contentsline{#2}{#3}{\thepage}{}%
 }%
}%
\def\label#1{%
 \@bsphack
  \protected@write\@auxout{}{%
   \string\newlabel{#1}{{\@currentlabel}{\thepage}{}{}{}}%
  }%
 \@esphack
}%
\def\ltx@contentsline#1{%
 \expandafter\@ifnotrelax\csname l@#1\endcsname{}{%
  \expandafter\let\csname l@#1\endcsname\@gobbletwo
 }%
 \contentsline@latex{#1}%
}%
\appdef\document@inithook{%
 \let\contentsline@latex\contentsline
 \let\contentsline\ltx@contentsline
}%
\appdef\class@documenthook{%
 \prepdef\caption{\minipagefootnote@here}%
}%
\def\minipagefootnote@init{%
 \setbox\@mpfootins\box\voidb@x
}%
\def\minipagefootnote@pick{%
 \global\setbox\@mpfootins\vbox\bgroup
  \unvbox\@mpfootins
}%
\def\minipagefootnote@drop{%
 \egroup
}%
\def\minipagefootnote@here{%
    \par
    \@ifvoid\@mpfootins{}{%
      \vskip\skip\@mpfootins
      \fullinterlineskip
      \@ifinner{%
       \vtop{\unvcopy\@mpfootins}%
       {\setbox\z@\lastbox}%
      }{}%
      \unvbox\@mpfootins
    }%
}%
\def\minipagefootnote@foot{%
 \@ifvoid\@mpfootins{}{%
  \insert\footins\bgroup\unvbox\@mpfootins\egroup
 }%
}%
\def\endminipage{%
    \par
    \unskip
    \minipagefootnote@here
    \@minipagefalse   %% added 24 May 89
  \color@endgroup
  \egroup
  \expandafter\@iiiparbox\@mpargs{\unvbox\@tempboxa}%
}%
\@booleantrue\floats@sw
\let\@xfloat@LaTeX\@xfloat
\def\@xfloat#1[#2]{%
  \@xfloat@prep
  \@nameuse{fp@proc@#2}%
  \floats@sw{\@xfloat@LaTeX{#1}[#2]}{\@xfloat@anchored{#1}[]}%
}%

\let\ltx@footnote@pop\@empty
\def\@xfloat@anchored#1[#2]{%
 \def\@captype{#1}%
 \begin@float@pagebreak
  \let\end@float\end@float@anchored
  \let\end@dblfloat\end@float@anchored
        \hsize\columnwidth
        \@parboxrestore
        \@floatboxreset
  \minipagefootnote@init
}%
\def\end@float@anchored{%
  \minipagefootnote@here
  \par\vskip\z@skip
 \par
 \end@float@pagebreak
}%
\def\begin@float@pagebreak{\par\addvspace\intextsep}%
\def\end@float@pagebreak{\par\addvspace\intextsep}%

\def\triggerpar{\leavevmode\@@par}%
\def\oneapage{\def\begin@float@pagebreak{\newpage}\def\end@float@pagebreak{\newpage}}%

\chardef\@xvi=16\relax
\mathchardef\@twopowerfourteen="4000
\mathchardef\@twopowertwo="4
\def\tally@float#1{%
 \begingroup
  \@tempcnta\count\@currbox
  \divide\@tempcnta\@xxxii
  \multiply\@tempcnta\@xxxii
  \advance\count\@currbox-\@tempcnta
  \divide\@tempcnta\@xxxii
  \@ifnum{\count\@currbox>\@xvi}{%
   \advance\count\@currbox-\@xvi\@booleantrue\@temp@sw
  }{%
   \@booleanfalse\@temp@sw
  }%
  \show@box@size@sw{%
   \class@info{Float #1
    (\the\@tempcnta)[\@temp@sw{16+}{}\the\count\@currbox]^^J%
    (\the\ht\@currbox+\the\dp\@currbox)X\the\wd\@currbox
   }%
  }{}%
 \endgroup
 \expandafter\let
 \expandafter\@tempa
             \csname fbox@\csname ftype@#1\endcsname\endcsname
 \@ifnotrelax\@tempa{%
  \@ifhbox\@tempa{%
   \setbox\@tempboxa\vbox{\unvcopy\@currbox\hrule}%
   \dimen@\ht\@tempboxa
   \divide\dimen@\@twopowerfourteen
   \@ifdim{\wd\@tempboxa<\textwidth}{%
    \advance\dimen@\ht\@tempa
    \global\ht\@tempa\dimen@
   }{%
    \advance\dimen@\dp\@tempa
    \global\dp\@tempa\dimen@
   }%
  }{}%
 }{}%
}%
\def\total@float#1{%
 \expandafter\let
 \expandafter\@tempa
             \csname fbox@\csname ftype@#1\endcsname\endcsname
 \@ifnotrelax\@tempa{%
  \@ifhbox\@tempa{%
   \@tempdima\the\ht\@tempa\divide\@tempdima\@twopowertwo\@tempcnta\@tempdima
   \@tempdimb\the\dp\@tempa\divide\@tempdimb\@twopowertwo\@tempcntb\@tempdimb
   \class@info{Total #1: Column(\the\@tempcnta pt), Page(\the\@tempcnta pt)}%
  }{}%
 }{}%
}%
\def\write@float#1{\write@@float{#1}{#1}}%
\def\endwrite@float{\@Esphack}%
\def\write@floats#1{\write@@float{#1*}{#1}}%
\def\endwrite@floats{\@Esphack}%
\def\write@@float#1#2{%
  \ifhmode
     \@bsphack
  \fi
  \chardef\@tempc\csname#2write\endcsname
  \toks@{\begin{#1}}%
  \def\@tempb{#1}%
  \expandafter\let\csname end#1\endcsname\endwrite@float
  \catcode`\^^M\active
  \@makeother\{\@makeother\}\@makeother\%
  \write@floatline
}%
\begingroup
 \catcode`\[\the\catcode`\{\catcode`\]\the\catcode`\}\@makeother\{\@makeother\}%
 \gdef\float@end@tag#1\end{#2}#3\@nul[%
  \def\@tempa[#2]%
  \@ifx[\@tempa\@tempb][\end[#2]][\write@floatline]%
 ]%
 \obeylines%
 \gdef\write@floatline#1^^M[%
  \begingroup%
   \newlinechar`\^^M%
   \toks@\expandafter[\the\toks@#1]\immediate\write\@tempc[\the\toks@]%
  \endgroup%
  \toks@[]%
  \float@end@tag#1\end{}\@nul%
 ]%
\endgroup
\def\@alph#1{\ifcase#1\or a\or b\or c\or d\else\@ialph{#1}\fi}
\def\@ialph#1{\ifcase#1\or \or \or \or \or e\or f\or g\or h\or i\or j\or
  k\or l\or m\or n\or o\or p\or q\or r\or s\or t\or u\or v\or w\or x\or
  y\or z\or aa\or bb\or cc\or dd\or ee\or ff\or gg\or hh\or ii\or jj\or
  kk\or ll\or mm\or nn\or oo\or pp\or qq\or rr\or ss\or tt\or uu\or
  vv\or ww\or xx\or yy\or zz\else\@ctrerr\fi}

\def\init@hyperref{%
 \providecommand\phantomsection{}%
 \providecommand\hyper@makecurrent[1]{}%
 \providecommand\Hy@raisedlink[1]{}%
 \providecommand\hyper@anchorstart[1]{}%
 \providecommand\hyper@anchorend{}%
 \providecommand\hyper@linkstart[2]{}%
 \providecommand\hyper@linkend{}%
 \providecommand\@currentHref{}%
}%
\let\H@refstepcounter\refstepcounter
\appdef\document@inithook{%
 \init@hyperref
}%
\def\sec@upcase#1{\relax{#1}}%
\appdef\document@inithook{%
 \@ifpackageloaded{array}{\switch@array}{\switch@tabular}%
 \prepdef\endtabular{\endtabular@hook}%
 \@provide\endtabular@hook{}%
 \prepdef\endarray{\endarray@hook}%
 \@provide\endarray@hook{}%
 \providecommand\array@hook{}%
 \prepdef\@tabular{\tabular@hook}%
 \@provide\tabular@hook{}%
}%
\def\switch@tabular{%
 \let\@array@sw\@array@sw@array
 \@ifx{\@array\@array@LaTeX}{%
  \@ifx{\multicolumn\multicolumn@LaTeX}{%
   \@ifx{\@tabular\@tabular@LaTeX}{%
    \@ifx{\@tabarray\@tabarray@LaTeX}{%
     \@ifx{\array\array@LaTeX}{%
      \@ifx{\endarray\endarray@LaTeX}{%
       \@ifx{\endtabular\endtabular@LaTeX}{%
        \@ifx{\@mkpream\@mkpream@LaTeX}{%
         \@ifx{\@addamp\@addamp@LaTeX}{%
          \@ifx{\@arrayacol\@arrayacol@LaTeX}{%
           \@ifx{\@tabacol\@tabacol@LaTeX}{%
            \@ifx{\@arrayclassz\@arrayclassz@LaTeX}{%
             \@ifx{\@tabclassiv\@tabclassiv@LaTeX}{%
              \@ifx{\@arrayclassiv\@arrayclassiv@LaTeX}{%
               \@ifx{\@tabclassz\@tabclassz@LaTeX}{%
                \@ifx{\@classv\@classv@LaTeX}{%
                 \@ifx{\hline\hline@LaTeX}{%
                  \@ifx{\@tabularcr\@tabularcr@LaTeX}{%
                   \@ifx{\@xtabularcr\@xtabularcr@LaTeX}{%
                    \@ifx{\@xargarraycr\@xargarraycr@LaTeX}{%
                     \@ifx{\@yargarraycr\@yargarraycr@LaTeX}{%
                      \true@sw
                     }{%
                      \false@sw
                     }%
                    }{%
                     \false@sw
                    }%
                   }{%
                    \false@sw
                   }%
                  }{%
                   \false@sw
                  }%
                 }{%
                  \false@sw
                 }%
                }{%
                 \false@sw
                }%
               }{%
                \false@sw
               }%
              }{%
               \false@sw
              }%
             }{%
              \false@sw
             }%
            }{%
             \false@sw
            }%
           }{%
            \false@sw
           }%
          }{%
           \false@sw
          }%
         }{%
          \false@sw
         }%
        }{%
         \false@sw
        }%
       }{%
        \false@sw
       }%
      }{%
       \false@sw
      }%
     }{%
      \false@sw
     }%
    }{%
     \false@sw
    }%
   }{%
    \false@sw
   }%
  }{%
   \false@sw
  }%
 }{%
  \false@sw
 }%
 {%
  \class@info{Patching LaTeX tabular.}%
 }{%
  \class@info{Unrecognized LaTeX tabular. Please update this document class! (Proceeding with fingers crossed.)}%
 }%
 \let\@array\@array@ltx
 \let\multicolumn\multicolumn@ltx
 \let\@tabular\@tabular@ltx
 \let\@tabarray\@tabarray@ltx
 \let\array\array@ltx
 \let\endarray\endarray@ltx
 \let\endtabular\endtabular@ltx
 \let\@mkpream\@mkpream@ltx
 \let\@addamp\@addamp@ltx
 \let\@arrayacol\@arrayacol@ltx
 \let\@tabacol\@tabacol@ltx
 \let\@arrayclassz\@arrayclassz@ltx
 \let\@tabclassiv\@tabclassiv@ltx
 \let\@arrayclassiv\@arrayclassiv@ltx
 \let\@tabclassz\@tabclassz@ltx
 \let\@classv\@classv@ltx
 \let\hline\hline@ltx
 \let\@tabularcr\@tabularcr@ltx
 \let\@xtabularcr\@xtabularcr@ltx
 \let\@xargarraycr\@xargarraycr@ltx
 \let\@yargarraycr\@yargarraycr@ltx
}%
\def\switch@array{%
 \@ifpackageloaded{colortbl}{\let\switch@array@info\colortbl@message}{\let\switch@array@info\array@message}%
 \let\@array@sw\@array@sw@LaTeX
 \@ifx{\@array\@array@array}{%
  \@ifx{\@tabular\@tabular@array}{%
   \@ifx{\@tabarray\@tabarray@array}{%
    \@ifx{\array\array@array}{%
     \@ifx{\endarray\endarray@array}{%
      \@ifx{\endtabular\endtabular@array}{%
       \@ifx{\@mkpream\@mkpream@array}{%
        \@ifx{\@classx\@classx@array}{%
         \@ifx{\insert@column\insert@column@array}{%
          \@ifx{\@arraycr\@arraycr@array}{%
           \@ifx{\@xarraycr\@xarraycr@array}{%
            \@ifx{\@xargarraycr\@xargarraycr@array}{%
             \@ifx{\@yargarraycr\@yargarraycr@array}{%
              \true@sw
             }{%
              \false@sw
             }%
            }{%
             \false@sw
            }%
           }{%
            \false@sw
           }%
          }{%
           \false@sw
          }%
         }{%
          \false@sw
         }%
        }{%
         \false@sw
        }%
       }{%
        \false@sw
       }%
      }{%
       \false@sw
      }%
     }{%
      \false@sw
     }%
    }{%
     \false@sw
    }%
   }{%
    \false@sw
   }%
  }{%
   \false@sw
  }%
 }{%
  \false@sw
 }{%
  \class@info{Patching array package.}%
 }{%
  \switch@array@info
 }%
 \let\@array    \@array@array@new
 \let\@@array   \@array % Cosi fan tutti
 \let\@tabular  \@tabular@array@new
 \let\@tabarray \@tabarray@array@new
 \let\array     \array@array@new
 \let\endarray  \endarray@array@new
 \let\endtabular\endtabular@array@new
 \let\@mkpream  \@mkpream@array@new
 \let\@classx   \@classx@array@new
 \let\@arrayacol\@arrayacol@ltx
 \let\@tabacol  \@tabacol@ltx
 \let\insert@column\insert@column@array@new
 \expandafter\let\csname endtabular*\endcsname\endtabular % Cosi fan tutti
 \let\@arraycr  \@arraycr@new
 \let\@xarraycr \@xarraycr@new
 \let\@xargarraycr\@xargarraycr@new
 \let\@yargarraycr\@yargarraycr@new
}%
\def\array@message{%
 \class@info{Unrecognized array package. Please update this document class! (Proceeding with fingers crossed.)}%
}%
\def\colortbl@message{%
 \class@info{colortbl package is loaded. (Proceeding with fingers crossed.)}%
}%
\def\@array@sw@LaTeX{\@ifx{\\\@tabularcr}}%
\def\@array@sw@array{\@ifx{\d@llarbegin\begingroup}}%
\def\@tabular@LaTeX{%
 \leavevmode
 \hbox\bgroup$% $
  \let\@acol\@tabacol
  \let\@classz\@tabclassz
  \let\@classiv\@tabclassiv
  \let\\\@tabularcr
  \@tabarray
}%
\def\@tabular@ltx{%
  \let\@acoll\@tabacoll
  \let\@acolr\@tabacolr
  \let\@acol\@tabacol
  \let\@classz\@tabclassz
  \let\@classiv\@tabclassiv
  \let\\\@tabularcr
  \@tabarray
}%
\def\@tabular@array{%
 \leavevmode
 \hbox\bgroup$% $
  \col@sep\tabcolsep
  \let\d@llarbegin\begingroup
  \let\d@llarend\endgroup
  \@tabarray
}%
\def\@tabular@array@new{%
  \let\@acoll\@tabacoll
  \let\@acolr\@tabacolr
  \let\@acol\@tabacol
  \let\d@llarbegin\begingroup
  \let\d@llarend\endgroup
  \@tabarray
}%
\def\@tabarray@LaTeX{%
 \m@th\@ifnextchar[\@array{\@array[c]}%
}%
\def\@tabarray@ltx{%
 \m@th\@ifnextchar[\@array{\expandafter\@array\expandafter[\array@default]}%
}%
\def\@tabarray@array{%
 \@ifnextchar[{\@@array}{\@@array[c]}%
}%
\def\@tabarray@array@new{%
 \@ifnextchar[{\@@array}{\expandafter\@@array\expandafter[\array@default]}%
}%
\newcount\intertabularlinepenalty
\intertabularlinepenalty=100
\newcount\@tbpen
\appdef\samepage{\intertabularlinepenalty\@M}%
\def\@tabularcr@LaTeX{{\ifnum 0=`}\fi \@ifstar \@xtabularcr \@xtabularcr}%
\def\@tabularcr@ltx{{\ifnum 0=`}\fi \@ifstar {\global \@tbpen \@M \@xtabularcr }{\global \@tbpen \intertabularlinepenalty \@xtabularcr }}%
\def\@xtabularcr@LaTeX{\@ifnextchar [\@argtabularcr {\ifnum 0=`{\fi }\cr }}%
\def\@xtabularcr@ltx{\@ifnextchar [\@argtabularcr {\ifnum 0=`{\fi }\cr \noalign {\penalty \@tbpen }}}%
\def\@xargarraycr@LaTeX#1{\@tempdima #1\advance \@tempdima \dp \@arstrutbox \vrule \@height \z@ \@depth \@tempdima \@width \z@ \cr}%
\def\@xargarraycr@ltx#1{\@tempdima #1\advance \@tempdima \dp \@arstrutbox \vrule \@height \z@ \@depth \@tempdima \@width \z@ \cr \noalign {\penalty \@tbpen }}%
\def\@yargarraycr@LaTeX#1{\cr \noalign {\vskip #1}}%
\def\@yargarraycr@ltx#1{\cr \noalign {\penalty \@tbpen \vskip #1}}%
\def\@arraycr@array{%
 \relax
 \iffalse{\fi\ifnum 0=`}\fi
 \@ifstar \@xarraycr \@xarraycr
}%
\def\@arraycr@new{%
 \relax
 \iffalse{\fi\ifnum 0=`}\fi
 \@ifstar {\global \@tbpen \@M \@xarraycr }{\global \@tbpen \intertabularlinepenalty \@xarraycr }%
}%
\def\@xarraycr@array{%
 \@ifnextchar [%]
 \@argarraycr {\ifnum 0=`{}\fi\cr}%
}%
\def\@xarraycr@new{%
 \@ifnextchar [%]
 \@argarraycr {\ifnum 0=`{}\fi\cr \noalign {\penalty \@tbpen }}%
}%
\def\@xargarraycr@array#1{%
 \unskip
 \@tempdima #1\advance\@tempdima \dp\@arstrutbox
 \vrule \@depth\@tempdima \@width\z@
 \cr
}%
\def\@xargarraycr@new#1{%
 \unskip
 \@tempdima #1\advance\@tempdima \dp\@arstrutbox
 \vrule \@depth\@tempdima \@width\z@
 \cr
 \noalign {\penalty \@tbpen }%
}%
\def\@yargarraycr@array#1{%
 \cr
 \noalign{\vskip #1}%
}%
\def\@yargarraycr@new#1{%
 \cr
 \noalign{\penalty \@tbpen \vskip #1}%
}%
\def\array@LaTeX{%
 \let\@acol\@arrayacol
 \let\@classz\@arrayclassz
 \let\@classiv\@arrayclassiv
 \let\\\@arraycr
 \let\@halignto\@empty
 \@tabarray
}%
\def\array@ltx{%
 \@ifmmode{}{\@badmath$}%
 \let\@acoll\@arrayacol
 \let\@acolr\@arrayacol
 \let\@acol\@arrayacol
 \let\@classz\@arrayclassz
 \let\@classiv\@arrayclassiv
 \let\\\@arraycr
 \let\@halignto\@empty
 \@tabarray
}%
\def\array@array{%
 \col@sep\arraycolsep
 \def\d@llarbegin{$}\let\d@llarend\d@llarbegin\gdef\@halignto{}%
 \@tabarray
}
\def\array@array@new{%
 \@ifmmode{}{\@badmath$}%
 \let\@acoll\@arrayacol
 \let\@acolr\@arrayacol
 \let\@acol\@arrayacol
 \def\d@llarbegin{$}%
 \let\d@llarend\d@llarbegin
 \gdef\@halignto{}%
 \@tabarray
}%
\def\@array@LaTeX[#1]#2{%
  \if #1t\vtop \else \if#1b\vbox \else \vcenter \fi\fi
  \bgroup
  \setbox\@arstrutbox\hbox{%
    \vrule \@height\arraystretch\ht\strutbox
           \@depth\arraystretch \dp\strutbox
           \@width\z@}%
  \@mkpream{#2}%
  \edef\@preamble{%
    \ialign \noexpand\@halignto
      \bgroup \@arstrut \@preamble \tabskip\z@skip \cr}%
  \let\@startpbox\@@startpbox \let\@endpbox\@@endpbox
  \let\tabularnewline\\%
    \let\par\@empty
    \let\@sharp##%
    \set@typeset@protect
    \lineskip\z@skip\baselineskip\z@skip
    \ifhmode \@preamerr\z@ \@@par\fi
    \@preamble
}%
\def\@array@ltx[#1]#2{%
 \@nameuse{@array@align@#1}%
  \set@arstrutbox
  \@mkpream{#2}%
  \prepdef\@preamble{%
    \tabskip\tabmid@skip
    \@arstrut
  }%
  \appdef\@preamble{%
    \tabskip\tabright@skip
    \cr
    \array@row@pre
  }%
  \let\tabularnewline\\%
  \let\par\@empty
  \let\@sharp##%
  \set@typeset@protect
  \lineskip\z@skip\baselineskip\z@skip
  \tabskip\tableft@skip\relax
  \ifhmode \@preamerr\z@ \@@par\fi
  \everycr{}%
  \expandafter\halign\expandafter\@halignto\expandafter\bgroup\@preamble
}%
\def\set@arstrutbox{%
  \setbox\@arstrutbox\hbox{%
    \vrule \@height\arraystretch\ht\strutbox
           \@depth\arraystretch \dp\strutbox
           \@width\z@
  }%
}%
\def\@array@array[#1]#2{%
  \@tempdima \ht \strutbox
  \advance \@tempdima by\extrarowheight
  \setbox \@arstrutbox \hbox{\vrule
             \@height \arraystretch \@tempdima
             \@depth \arraystretch \dp \strutbox
             \@width \z@}%
  \begingroup
  \@mkpream{#2}%
  \xdef\@preamble{\noexpand \ialign \@halignto
                  \bgroup \@arstrut \@preamble
                          \tabskip \z@ \cr}%
  \endgroup
  \@arrayleft
  \if #1t\vtop \else \if#1b\vbox \else \vcenter \fi \fi
  \bgroup
  \let \@sharp ##\let \protect \relax
  \lineskip \z@
  \baselineskip \z@
  \m@th
  \let\\\@arraycr \let\tabularnewline\\\let\par\@empty \@preamble
}%

\def\endarray@LaTeX{%
 \crcr\egroup\egroup
}%
\def\endarray@ltx{%
 \crcr\array@row@pst\egroup\egroup
}%
\def\endarray@array{%
 \crcr \egroup \egroup \@arrayright \gdef\@preamble{}%
}%
\def\endarray@array@new{%
 \crcr\array@row@pst\egroup\egroup % Same as \endarray@ltx
 \@arrayright
 \global\let\@preamble\@empty
}%
\def\endtabular@LaTeX{%
 \crcr\egroup\egroup $\egroup
}%
\def\endtabular@ltx{%
 \endarray
}%
\def\endtabular@array{%
 \endarray $\egroup
}%
\def\endtabular@array@new{%
 \endarray
}%
\@namedef{endtabular*}{\endtabular}%
\long\def\multicolumn@LaTeX#1#2#3{%
 \multispan{#1}\begingroup
  \@mkpream{#2}%
  \def\@sharp{#3}\set@typeset@protect
  \let\@startpbox\@@startpbox\let\@endpbox\@@endpbox
  \@arstrut \@preamble\hbox{}\endgroup\ignorespaces
}%
\long\def\multicolumn@ltx#1#2#3{%
 \multispan{#1}%
 \begingroup
  \@mkpream{#2}%
  \def\@sharp{#3}%
  \set@typeset@protect
 %\let\@startpbox\@@startpbox\let\@endpbox\@@endpbox
  \@arstrut
  \@preamble
  \hbox{}%
 \endgroup
 \ignorespaces
}%
\def\@array@align@t{\leavevmode\vtop\bgroup}%
\def\@array@align@b{\leavevmode\vbox\bgroup}%
\def\@array@align@c{\leavevmode\@ifmmode{\vcenter\bgroup}{$\vcenter\bgroup\aftergroup$\aftergroup\relax}}%
\def\@array@align@v{%
 \@ifmmode{%
  \@badmath
  \vcenter\bgroup
 }{%
  \@ifinner{%
   $\vcenter\bgroup\aftergroup$
  }{%
   \@@par\bgroup
  }%
 }%
}%
\def\array@default{c}%
\def\array@row@rst{%
 \let\@array@align@v\@array@align@c
}%
\def\array@row@pre{}%
\def\array@row@pst{}%

\def\hline@LaTeX{%
 \noalign{\ifnum0=`}\fi\hrule \@height \arrayrulewidth \futurelet
   \reserved@a\@xhline
}%
\def\hline@ltx{%
 \noalign{%
  \ifnum0=`}\fi
  \hline@rule
  \futurelet\reserved@a\@xhline
 % \noalign ended in \@xhline
}%
\def\@xhline@unneeded{%
 \say\reserved@a
 \ifx\reserved@a\hline
  \vskip\doublerulesep
  \vskip-\arrayrulewidth
 \fi
 \ifnum0=`{\fi}%
}%
\def\column@font{}%
\def\column@fil{}%
\def\body@font{}%
\def\cell@font{}%
\def\frstrut{}%
\def\lrstrut{}%
\def\@arstrut@hline{%
 \relax
 \@ifmmode{\copy}{\unhcopy}\@arstrutbox@hline
 \@arstrut@hook
}%
\let\@arstrut@org\@arstrut
\def\@arstrut@hook{%
 \global\let\@arstrut\@arstrut@org
}%
\newbox\@arstrutbox@hline
\appdef\set@arstrutbox{%
  \setbox\@arstrutbox@hline\hbox{%
    \setbox\z@\hbox{$0^{0}_{}$}%
    \dimen@\ht\z@\advance\dimen@\@arstrut@hline@clnc
    \@ifdim{\dimen@<\arraystretch\ht\strutbox}{\dimen@=\arraystretch\ht\strutbox}{}%
    \vrule \@height\dimen@
           \@depth\arraystretch \dp\strutbox
           \@width\z@
  }%
}%
\def\hline@rule{%
 \hrule \@height \arrayrulewidth
 \global\let\@arstrut\@arstrut@hline
}%
\def\tableft@skip{\z@skip}%
\def\tabmid@skip{\z@skip}%\@flushglue
\def\tabright@skip{\z@skip}%
\def\tableftsep{\tabcolsep}%
\def\tabmidsep{\tabcolsep}%
\def\tabrightsep{\tabcolsep}%
\def\cell@fil{}%
\def\pbox@hook{}%
\appdef\@arstrut{\@arstrut@hook}%
\let\@arstrut@hook\@empty
\def\@addtopreamble{\appdef\@preamble}%
\def\@mkpream@LaTeX#1{%
  \@firstamptrue\@lastchclass6
  \let\@preamble\@empty
  \let\protect\@unexpandable@protect
  \let\@sharp\relax
  \let\@startpbox\relax\let\@endpbox\relax
  \@expast{#1}%
  \expandafter\@tfor \expandafter
    \@nextchar \expandafter:\expandafter=\reserved@a\do
       {\@testpach\@nextchar
    \ifcase \@chclass \@classz \or \@classi \or \@classii \or \@classiii
      \or \@classiv \or\@classv \fi\@lastchclass\@chclass}%
  \ifcase \@lastchclass \@acol
      \or \or \@preamerr \@ne\or \@preamerr \tw@\or \or \@acol \fi
}%
\def\@mkpream@ltx#1{%
 \@firstamptrue
 \@lastchclass6
 \let\@preamble\@empty
 \let\protect\@unexpandable@protect
 \let\@sharp\relax
 \@expast{#1}%
 \expandafter\@tfor\expandafter\@nextchar\expandafter:\expandafter=\reserved@a
 \do{%
  \expandafter\@testpach\expandafter{\@nextchar}%
  \ifcase\@chclass
   \@classz
  \or
   \@classi
  \or
   \@classii
  \or
   \@classiii
  \or
   \@classiv
  \or
   \@classv
  \fi
  \@lastchclass\@chclass
 }%
 \ifcase\@lastchclass
  \@acolr % right-hand column
 \or
 \or
  \@preamerr\@ne
 \or
  \@preamerr\tw@
 \or
 \or
  \@acolr % right-hand column
 \fi
}%
\def\insert@column@array{%
   \the@toks \the \@tempcnta
   \ignorespaces \@sharp \unskip
   \the@toks \the \count@ \relax
}%
\def\insert@column@array@new{%
 \the@toks\the\@tempcnta
 \array@row@rst\cell@font
 \ignorespaces\@sharp\unskip
 \the@toks\the\count@
 \relax
}%
\def\@mkpream@relax{%
 \let\tableftsep   \relax
 \let\tabmidsep    \relax
 \let\tabrightsep  \relax
 \let\array@row@rst\relax
 \let\cell@font    \relax
 \let\@startpbox   \relax
}%
\def\@mkpream@array#1{%
   \gdef\@preamble{}\@lastchclass 4 \@firstamptrue
   \let\@sharp\relax \let\@startpbox\relax \let\@endpbox\relax
   \@temptokena{#1}\@tempswatrue
   \@whilesw\if@tempswa\fi{\@tempswafalse\the\NC@list}%
   \count@\m@ne
   \let\the@toks\relax
   \prepnext@tok
   \expandafter \@tfor \expandafter \@nextchar
    \expandafter :\expandafter =\the\@temptokena \do
   {\@testpach
   \ifcase \@chclass \@classz \or \@classi \or \@classii
     \or \save@decl \or \or \@classv \or \@classvi
     \or \@classvii \or \@classviii
     \or \@classx
     \or \@classx \fi
   \@lastchclass\@chclass}%
   \ifcase\@lastchclass
   \@acol \or
   \or
   \@acol \or
   \@preamerr \thr@@ \or
   \@preamerr \tw@ \@addtopreamble\@sharp \or
   \or
   \else  \@preamerr \@ne \fi
   \def\the@toks{\the\toks}%
}%
\def\@mkpream@array@new#1{%
 \gdef\@preamble{}%
 \@lastchclass\f@ur
 \@firstamptrue
 \let\@sharp\relax
 \@mkpream@relax
 \@temptokena{#1}\@tempswatrue
 \@whilesw\if@tempswa\fi{\@tempswafalse\the\NC@list}%
 \count@\m@ne
 \let\the@toks\relax
 \prepnext@tok
 \expandafter\@tfor\expandafter\@nextchar\expandafter:\expandafter=\the\@temptokena
 \do{%
  \@testpach
  \ifcase\@chclass
   \@classz
  \or
   \@classi
  \or
   \@classii
  \or
   \save@decl
  \or
  \or
   \@classv
  \or
   \@classvi
  \or
   \@classvii
  \or
   \@classviii
  \or
   \@classx
  \or
   \@classx
  \fi
  \@lastchclass\@chclass
 }%
 \ifcase\@lastchclass
  \@acolr % right-hand column
 \or
 \or
  \@acolr % right-hand column
 \or
  \@preamerr\thr@@
 \or
  \@preamerr\tw@\@addtopreamble\@sharp
 \or
 \or
 \else
  \@preamerr\@ne
 \fi
 \def\the@toks{\the\toks}%
}%
\appdef\@mkpream@relax{%
 \let\CT@setup       \relax
 \let\CT@color       \relax
 \let\CT@do@color    \relax
 \let\color          \relax
 \let\CT@column@color\relax
 \let\CT@row@color   \relax
 \let\CT@cell@color  \relax
}%
\def\@addamp@LaTeX{%
  \if@firstamp\@firstampfalse\else\edef\@preamble{\@preamble &}\fi
}%
\def\@addamp@ltx{%
 \if@firstamp\@firstampfalse\else\@addtopreamble{&}\fi
}%
\def\@arrayacol@LaTeX{%
 \edef\@preamble{\@preamble \hskip \arraycolsep}%
}%
\def\@arrayacol@ltx{%
 \@addtopreamble{\hskip\arraycolsep}%
}%
\def\@tabacoll{%
 \@addtopreamble{\hskip\tableftsep\relax}%
}%
\def\@tabacol@LaTeX{%
 \edef\@preamble{\@preamble \hskip \tabcolsep}%
}%
\def\@tabacol@ltx{%
 \@addtopreamble{\hskip\tabmidsep\relax}%
}%
\def\@tabacolr{%
 \@addtopreamble{\hskip\tabrightsep\relax}%
}%
\def\@arrayclassz@LaTeX{%
 \ifcase \@lastchclass \@acolampacol \or \@ampacol \or
   \or \or \@addamp \or
   \@acolampacol \or \@firstampfalse \@acol \fi
 \edef\@preamble{\@preamble
  \ifcase \@chnum
     \hfil$\relax\@sharp$\hfil \or $\relax\@sharp$\hfil
    \or \hfil$\relax\@sharp$\fi}%
}%
\def\@arrayclassz@ltx{%
 \ifcase\@lastchclass
  \@acolampacol
 \or
  \@ampacol
 \or
 \or
 \or
  \@addamp
 \or
  \@acolampacol
 \or
  \@firstampfalse\@acoll
 \fi
 \ifcase\@chnum
  \@addtopreamble{%
   \hfil\array@row@rst$\relax\@sharp$\hfil
  }%
 \or
  \@addtopreamble{%
   \array@row@rst$\relax\@sharp$\hfil
  }%
 \or
  \@addtopreamble{%
   \hfil\array@row@rst$\relax\@sharp$%
  }%
 \fi
}%
\def\@tabclassz@LaTeX{%
  \ifcase\@lastchclass
    \@acolampacol
  \or
    \@ampacol
  \or
  \or
  \or
    \@addamp
  \or
    \@acolampacol
  \or
    \@firstampfalse\@acol
  \fi
  \edef\@preamble{%
    \@preamble{%
      \ifcase\@chnum
        \hfil\ignorespaces\@sharp\unskip\hfil
      \or
        \hskip1sp\ignorespaces\@sharp\unskip\hfil
      \or
        \hfil\hskip1sp\ignorespaces\@sharp\unskip
      \fi}}%
}%
\def\@tabclassz@ltx{%
 \ifcase\@lastchclass
  \@acolampacol
 \or
  \@ampacol
 \or
 \or
 \or
  \@addamp
 \or
  \@acolampacol
 \or
  \@firstampfalse\@acoll
 \fi
 \ifcase\@chnum
  \@addtopreamble{%
   {\hfil\array@row@rst\cell@font\ignorespaces\@sharp\unskip\hfil}%
  }%
 \or
  \@addtopreamble{%
   {\cell@fil\hskip1sp\array@row@rst\cell@font\ignorespaces\@sharp\unskip\hfil}%
  }%
 \or
  \@addtopreamble{%
   {\hfil\hskip1sp\array@row@rst\cell@font\ignorespaces\@sharp\unskip\cell@fil}%
  }%
 \fi
}%
\def\@tabclassiv@LaTeX{%
 \@addtopreamble\@nextchar
}%
\def\@tabclassiv@ltx{%
 \expandafter\@addtopreamble\expandafter{\@nextchar}%
}%
\def\@arrayclassiv@LaTeX{%
 \@addtopreamble{$\@nextchar$}%
}%
\def\@arrayclassiv@ltx{%
 \expandafter\@addtopreamble\expandafter{\expandafter$\@nextchar$}%
}%
\def\@classv@LaTeX{%
 \@addtopreamble{\@startpbox{\@nextchar}\ignorespaces
 \@sharp\@endpbox}%
}%
\def\@classv@ltx{%
 \expandafter\@addtopreamble
 \expandafter{%
 \expandafter \@startpbox
 \expandafter {\@nextchar}%
 \pbox@hook\array@row@rst\cell@font\ignorespaces\@sharp\@endpbox
 }%
}%
\def\@classx@array{%
  \ifcase \@lastchclass
  \@acolampacol \or
  \@addamp \@acol \or
  \@acolampacol \or
  \or
  \@acol \@firstampfalse \or
  \@addamp
  \fi
}%
\def\@classx@array@new{%
 \ifcase \@lastchclass
  \@acolampacol
 \or
  \@addamp \@acol
 \or
  \@acolampacol
 \or
 \or
  \@firstampfalse\@acoll
 \or
  \@addamp
 \fi
}%
\def\@xbitor@LaTeX #1{\@tempcntb \count#1
   \ifnum \@tempcnta =\z@
   \else
     \divide\@tempcntb\@tempcnta
     \ifodd\@tempcntb \@testtrue\fi
   \fi}%
\def\@xbitor@ltx#1{%
 \@tempcntb\count#1\relax
 \@ifnum{\@tempcnta=\z@}{}{%
  \divide\@tempcntb\@tempcnta
  \@ifodd\@tempcntb{\@testtrue}{}%
 }%
}%
\@ifx{\@xbitor\@xbitor@LaTeX}{%
  \class@info{Repairing broken LaTeX \string\@xbitor}%
}{%
  \class@info{Unrecognized LaTeX \string\@xbitor. Please update this document class! (Proceeding with fingers crossed.)}%
}%
\let\@xbitor\@xbitor@ltx
\newcommand*\@gobble@opt@one[2][]{}%
\def\@starttoc#1{%
  \begingroup
    \toc@pre
    \makeatletter
    \@input{\jobname.#1}%
    \if@filesw
      \expandafter\newwrite\csname tf@#1\endcsname
      \immediate\openout \csname tf@#1\endcsname \jobname.#1\relax
    \fi
    \@nobreakfalse
    \toc@post
  \endgroup
}%
\def\toc@pre{}%
\def\toc@post{}%
\def\toc@@font{}%

\let\tocdim@section       \leftmargini
\let\tocdim@subsection    \leftmarginii
\let\tocdim@subsubsection \leftmarginiii
\let\tocdim@paragraph     \leftmarginiv
\let\tocdim@appendix      \leftmarginv
\let\tocdim@pagenum       \leftmarginvi
\def\toc@pre@auto{%
  \toc@@font
  \@tempdima\z@
  \toc@setindent\@tempdima{section}%
  \toc@setindent\@tempdima{subsection}%
  \toc@setindent\@tempdima{subsubsection}%
  \toc@setindent\@tempdima{paragraph}%
  \toc@letdimen{appendix}%
  \toc@letdimen{pagenum}%
}%
\def\toc@post@auto{%
  \if@filesw
   \begingroup
    \toc@writedimen{section}%
    \toc@writedimen{subsection}%
    \toc@writedimen{subsubsection}%
    \toc@writedimen{paragraph}%
    \toc@writedimen{appendix}%
    \toc@writedimen{pagenum}%
   \endgroup
  \fi
}%
\def\toc@setindent#1#2{%
 \csname tocdim@#2\endcsname\tocdim@min\relax
 \@ifundefined{tocmax@#2}{\@namedef{tocmax@#2}{\z@}}{}%
 \advance#1\@nameuse{tocmax@#2}\relax
 \expandafter\edef\csname tocleft@#2\endcsname{\the#1}%
}%
\def\toc@letdimen#1{%
 \csname tocdim@#1\endcsname\tocdim@min\relax
 \@ifundefined{tocmax@#1}{\@namedef{tocmax@#1}{\z@}}{}%
 \expandafter\let\csname tocleft@#1\expandafter\endcsname\csname tocmax@#1\endcsname
}%
\def\toc@writedimen#1{%
 \immediate\write\@auxout{%
  \gdef\expandafter\string\csname tocmax@#1\endcsname{%
   \expandafter\the\csname tocdim@#1\endcsname
  }%
 }%
}%
\def\l@@sections#1#2#3#4{%
 \begingroup
  \everypar{}%
  \set@tocdim@pagenum\@tempboxa{#4}%
  \global\@tempdima\csname tocdim@#2\endcsname
  \leftskip\csname tocleft@#2\endcsname\relax
  \dimen@\csname tocleft@#1\endcsname\relax
  \parindent-\leftskip\advance\parindent\dimen@
  \rightskip\tocleft@pagenum plus 1fil\relax
  \skip@\parfillskip\parfillskip\z@
  \let\numberline\numberline@@sections
  \@nameuse{l@f@#2}%
  \ignorespaces#3\unskip\nobreak\hskip\skip@
  \hb@xt@\rightskip{\hfil\unhbox\@tempboxa}\hskip-\rightskip\hskip\z@skip
  \expandafter\par
  \expandafter\aftergroup\csname tocdim@#2%
  \expandafter\endcsname
  \expandafter\endgroup
              \the\@tempdima\relax
}%
\def\set@tocdim@pagenum#1#2{%
 \setbox#1\hbox{\ignorespaces#2}%
 \@ifdim{\tocdim@pagenum<\wd#1}{\global\tocdim@pagenum\wd#1}{}%
}%
\def\numberline@@sections#1{%
 \leavevmode\hb@xt@-\parindent{%
  \hfil
  \@if@empty{#1}{}{%
   \setbox\z@\hbox{#1.\kern\ltxu@dotsep}%
   \@ifdim{\@tempdima<\wd\z@}{\global\@tempdima\wd\z@}{}%
   \unhbox\z@
  }%
 }%
 \ignorespaces
}%
\def\tocdim@min{\z@}%
\def\list#1#2{%
  \ifnum \@listdepth >5\relax
    \@toodeep
  \else
    \global\advance\@listdepth\@ne
  \fi
  \rightmargin\z@
  \listparindent\z@
  \itemindent\z@
  \csname @list\romannumeral\the\@listdepth\endcsname
  \def\@itemlabel{#1}%
  \let\makelabel\@mklab
  \@nmbrlistfalse
  #2\relax
  \@trivlist
  \parskip\parsep
  \set@listindent
  \ignorespaces
}%
\def\set@listindent@parshape{%
 \parindent\listparindent
 \advance\@totalleftmargin\leftmargin
 \advance\linewidth-\rightmargin
 \advance\linewidth-\leftmargin
 \parshape\@ne\@totalleftmargin\linewidth
}%
\def\set@listindent@{%
 \parindent\listparindent
 \advance\@totalleftmargin\leftmargin
 \advance\rightskip\rightmargin
 \advance\leftskip\@totalleftmargin
}%
\let\set@listindent\set@listindent@parshape
\providecommand\href[0]{\begingroup\@sanitize@url\@href}%
\def\@href#1{\@@startlink{#1}\endgroup\@@href}%
\def\@@href#1{#1\@@endlink}%
\providecommand \url  [0]{\begingroup\@sanitize@url \@url }%
\def \@url #1{\endgroup\@href {#1}{\URL@prefix#1}}%
\providecommand \URL@prefix [0]{URL }%
\providecommand\doi[0]{\begingroup\@sanitize@url\@doi}%
\def\@doi#1{\endgroup\@@startlink{\doibase#1}doi:\discretionary {}{}{}#1\@@endlink }%
\providecommand \doibase [0]{https://doi.org/}%
\providecommand \@sanitize@url[0]{\chardef\cat@space\the\catcode`\ \@sanitize\catcode`\ \cat@space}%
\def\@@startlink#1{}%
\def\@@endlink{}%
\@ifxundefined \pdfoutput {\true@sw}{\@ifnum{\z@=\pdfoutput}{\true@sw}{\false@sw}}%
{%
 \def\@@startlink@hypertext#1{\leavevmode\special{html:<a href="#1">}}%
 \def\@@endlink@hypertext{\special{html:</a>}}%
}{%
 \def\@@startlink@hypertext#1{%
  \leavevmode
  \pdfstartlink\pdfstartlink@attr
   user{/Subtype/Link/A<</Type/Action/S/URI/URI(#1)>>}%
  \relax
 }%
 \def\@@endlink@hypertext{\pdfendlink}%
 \def\pdfstartlink@attr{attr{/Border[0 0 1 ]/H/I/C[0 1 1]}}%
}%
\def\hypertext@enable@ltx{%
 \let\@@startlink\@@startlink@hypertext
 \let\@@endlink\@@endlink@hypertext
}%
\def\href@Hy{\hyper@normalise \href@ }%
\def\href@Hy@ltx{\@ifnextchar\bgroup\Hy@href{\hyper@normalise\href@}}%
\def\Hy@href#{\hyper@normalise\href@}%
\begingroup
  \endlinechar=-1 %
  \catcode`\^^A=14 %
  \catcode`\^^M\active
  \catcode`\%\active
  \catcode`\#\active
  \catcode`\_\active
  \catcode`\$\active
  \catcode`\&\active
  \gdef\hyper@normalise@ltx{^^A
    \begingroup
    \catcode`\^^M\active
    \def^^M{ }^^A
    \catcode`\%\active
    \let%\@percentchar
    \let\%\@percentchar
    \catcode`\#\active
    \def#{\hyper@hash}^^A
    \def\#{\hyper@hash}^^A
    \@makeother\&^^A
    \edef&{\string&}^^A
    \edef\&{\string&}^^A
    \edef\textunderscore{\string_}^^A
    \let\_\textunderscore
    \catcode`\_\active
    \let_\textunderscore
    \let~\hyper@tilde
    \let\~\hyper@tilde
    \let\textasciitilde\hyper@tilde
    \let\\\@backslashchar
    \edef${\string$}^^A
    \Hy@safe@activestrue
    \hyper@n@rmalise
  }^^A
  \catcode`\#=6 ^^A
  \gdef\Hy@ActiveCarriageReturn@ltx{^^M}^^A
  \gdef\hyper@n@rmalise@ltx#1#2{^^A
    \def\Hy@tempa{#2}^^A
    \ifx\Hy@tempa\Hy@ActiveCarriageReturn
      \Hy@ReturnAfterElseFi{^^A
        \hyper@@normalise{#1}^^A
      }^^A
    \else
      \Hy@ReturnAfterFi{^^A
        \hyper@@normalise{#1}{#2}^^A
      }^^A
    \fi
  }^^A
  \gdef\hyper@@normalise@ltx#1#2{^^A
    \edef\Hy@tempa{^^A
      \endgroup
      \noexpand#1{\Hy@RemovePercentCr#2%^^M\@nil}^^A
    }^^A
    \Hy@tempa
  }^^A
  \gdef\Hy@RemovePercentCr@ltx#1%^^M#2\@nil{^^A
    #1^^A
    \ifx\limits#2\limits
    \else
      \Hy@ReturnAfterFi{^^A
        \Hy@RemovePercentCr #2\@nil
      }^^A
    \fi
  }^^A
\endgroup
\def\switch@hyperref@href{%
 \expandafter\@ifx\expandafter{\csname href \endcsname\href@Hy}{
  \class@info{Repairing hyperref 6.75r \string\href}%
  \let\hyper@normalise\hyper@normalise@ltx
  \let\hyper@@normalise\hyper@@normalise@ltx
  \let\hyper@n@rmalise\hyper@n@rmalise@ltx
  \let\Hy@ActiveCarriageReturn\Hy@ActiveCarriageReturn@ltx
  \let\Hy@RemovePercentCr\Hy@RemovePercentCr@ltx
  \let\href\href@Hy@ltx
 }{}%
}%
\appdef\document@inithook{\switch@hyperref@href}%
\def\typeout@org#1{%
 \begingroup
  \set@display@protect
  \immediate\write\@unused{#1}%
 \endgroup
}%
\long\def\typeout@ltx#1{%
 \begingroup
  \set@display@protect
  \immediate\write\@unused{#1}%
 \endgroup
}%
\@ifx{\typeout\typeout@org}{%
 \let\typeout\typeout@ltx
 \true@sw
}{%
 \rvtx@ifformat@geq{2020/10/01}%
   {\true@sw}{\false@sw}%
}%
 {\class@info{Making \string\typeout\space \string\long}}%
 {}%

\typeout{%
ltxfront%
 [2022/06/05 4.2f frontmatter package (AO,DPC,MD)]% \fileversion
}%

\appdef\class@documenthook{\frontmatter@init}%

\let\frontmatter@init\@empty
\newcommand\frontmatter@title[2][]{%
\def\@title{#2}%
 \def\@shorttitle{#1}%
 \let\@AF@join\@title@join
}%
\appdef\frontmatter@init{%
 \def\@title{\class@warn{No title}}%
 \let\@shorttitle\@empty
 \let\@title@aux\@title@aux@cleared
}%
\def\@title@join{\expandafter\@title@join@\@title@aux}%
\def\@title@join@#1#2{%
 \def\@title@aux{{\@join{\@separator}{#1}{#2}}}%
}%
\def\@title@aux@cleared{{}}%
\newcounter{affil}%
\newcounter{collab}%
\appdef\frontmatter@init{%
 \c@affil\z@
 \c@collab\z@
}%
\newcommand\frontmatter@author{% implicit #1
 \@author@def{}% implicit #2
}%

\def\collaboration{% implicit #1
 \@author@def{\@booleantrue\collaboration@sw}% implicit #2
}%
\appdef\frontmatter@init{%
 \@booleanfalse\collaboration@sw
}%
\def\@author@cleared{{}{}{}}%
\def\@author@gobble#1#2#3{}%
\def\@author@init{%
 \let\@author\@author@cleared
 \@booleanfalse\collaboration@sw
}%
\def\@authorclear@sw{\@ifx{\@author\@author@cleared}}%
\appdef\frontmatter@init{%
 \@author@init
}
%
\def\@author@def#1#2{\@ifnextchar[{\@@author@def{#1}{#2}}{\@@author@def{#1}{#2}[\relax]}}

\def\@@author@def#1#2[#3]{%
 \frontmatterverbose@sw{\typeout{\string\author\space\string\collaboration}}{}%
 \move@AU\move@AF\move@AUAF
 \let\@AF@join\@author@join
 #1%
\ifx#3\relax
 \def\@author{{#2}{}}%
  \expandafter\gdef\csname author@data@\romannumeral\the\allauthorcnt\endcsname{#2}%
\else
 \def\@author{{#3}{}}%
  \expandafter\gdef\csname author@data@\romannumeral\the\allauthorcnt\endcsname{#3}%
\fi
}%
\def\@author@join@#1#2#3{%
  \def\@author{{#1}{\@join{\@separator}{#2}{#3}}}%
}%
\def\@author@join{\expandafter\@author@join@\@author}%
\def\move@AU{%
 \@authorclear@sw{}{%
  \collaboration@sw{%
   \advance\c@collab\@ne
   \@argswap{\CO@grp\CO@opr}%
  }{%
   \@argswap{\AU@grp\AU@opr}%
  }%
   {%
    \expandafter\@argswap@val
    \expandafter{\@author}%
     {\expandafter\@argswap@val\expandafter{\the\c@collab}{\add@AUCO@grp}}%
   }%
 }%
 \@author@init
}%
\def\add@AUCO@grp#1#2#3#4{%
 \appdef#3{#4{#1}#2}%
 \frontmatterverbose@sw{\say#3}{}%
}%
\def\@author@finish{%
 \frontmatterverbose@sw{\typeout{\string\@author@finish}}{}%
 \move@AU\move@AF
 \@ifx{\AU@grp\@empty}{%
  \@ifx{\CO@grp\@empty}%
 }{%
  \false@sw
 }%
 {}{%
  \@ifx{\AF@grp\@empty}{%
   \begingroup
    \let\href\@secondoftwo
    \let\AU@opr\@secondofthree
    \let\CO@opr\@secondofthree
    \let\footnote\@gobble
    \@ifx{\CO@grp\@empty}{%
     \class@warn{Assuming \string\noaffiliation\space for authors}%
     \frontmatterverbose@sw{\say\AU@grp}%
    }{%
     \class@warn{Assuming \string\noaffiliation\space for collaboration}%
     \frontmatterverbose@sw{\say\CO@grp}{}%
    }%
   \endgroup
   \@affil@none\move@AF
  }{}%
 }%
 \move@AUAF
}%
\def\@secondofthree#1#2#3{#2}%
\def\@join#1#2#3{%
  \@if@empty{#2}{#3}{#2#1#3}%
}%

\let\surname\@firstofone
\let\firstname\@firstofone
\newcommand\frontmatter@and{\class@err{\protect\and\space is not supported}}
\def\cat@comma@active{\catcode`\,\active}%
{\cat@comma@active\gdef,{\active@comma}}%
\def\active@comma{,\penalty-300\relax}%
\newcommand\affiliation{%
 \frontmatterverbose@sw{\typeout{\string\affiliation}}{}%
 \move@AU\move@AF
 \begingroup
  \cat@comma@active
  \@affiliation
}%
\def\@affiliation#1{%
 \endgroup
 \let\@AF@join\@affil@join
 \@affil@def{#1}%
}%
\newcommand\frontmatter@noaffiliation{%
 \frontmatterverbose@sw{\typeout{\string\noaffiliation}}{}%
 \move@AU\move@AF
 \@affil@none\move@AF
 \move@AUAF
}%
\def\@affil@cleared{{{}}{}}%
\def\@affil@nil{{\relax}{}}%
\appdef\frontmatter@init{%
 \@affil@init
}%
\def\@affil@none{%
 \let\@affil\@affil@nil
}%
\def\@affil@init{%
 \let\@affil\@affil@cleared
}%
\def\@affilclear@sw{\@ifx{\@affil\@affil@cleared}}%
\def\@affil@def#1{%
 \def\@affil{{#1}{}}%
}%
\def\@affil@join@#1#2#3{%
  \def\@affil{{#1}{\@join{\@separator}{#2}{#3}}}%
}%
\def\@affil@join{\expandafter\@affil@join@\@affil}%
\def\move@AF{%
 \@affilclear@sw{}{%
  \@booleanfalse\temp@sw
  \let\@tempd\@empty
  \@affils@sw{%
    \expandafter\@affil@addr@def\expandafter\@tempa\@affil
    \def\AFF@opr{\@affil@match\@tempa}%
    \@AFF@list
  }{}\temp@sw
  {%
   \expandafter\@affil@aux@def\expandafter\@tempb\@affil
   \@ifx{\@tempb\@empty}{}{%
    \@ifx{\@tempb\@tempd}{}{%
     \class@warn{%
      Ancillary information for \@tempa\space must not be different!
      Please put all of it on the first instance%
     }%
    }%
   }%
  }%
  {%
   \@ifx{\@affil\@affil@nil}{%
    \def\@tempc{0}%
    \@argswap@val{0}%
   }{%
    \advance\c@affil\@ne
    \expandafter\def\expandafter\@tempc\expandafter{\the\c@affil}%
    \expandafter\@argswap@val\expandafter{\the\c@affil}%
   }%
   {%
    \expandafter\@argswap@val\expandafter{\the\c@collab}{%
     \expandafter\@argswap@val\expandafter{\@affil}{%
      \add@list@val@val@val\@AFF@list\AFF@opr
     }%
    }%
   }%
  }%
  \appdef@eval\AF@grp\@tempc
  \frontmatterverbose@sw{\say\AF@grp}{}%
  \@affil@init
 }%
}%
\def\@affil@addr@def#1#2#3{%
 \def#1{#2}%
}%
\def\@affil@aux@def#1#2#3{%
 \def#1{#3}%
}%
\def\add@list@val@val@val#1#2#3#4#5{%
 \appdef#1{#2{#5}{#4}#3}%
 \frontmatterverbose@sw{\say#1}{}%
}%
\def\@affil@match#1#2#3#4#5{%
 \temp@sw{}{%
  \def\@tempifx{#4}%
  \@ifx{\@tempifx#1}{%
   \groupauthors@sw{%
    \@ifnum{#3=\c@collab}{%
     \true@sw
    }{%
     \false@sw
    }%
   }{%
    \true@sw
   }%
  }{%
   \false@sw
  }%
  {%
   \@booleantrue\temp@sw
   \def\@tempc{#2}%
   \def\@tempd{#5}%
  }{%
  }%
 }%
}%
\def\move@AUAF{%
 \frontmatterverbose@sw{\say\AU@grp\say\AF@grp\say\CO@grp}{}%
 \@ifx{\AF@grp\@empty}{%
    \@ifx{\@empty\CO@grp}{%
    }{%
     \appdef     \@AAC@list{\AF@opr{{0}}}%
     \appdef@e   \@AAC@list{\CO@grp}%
     \appdef@e   \@AFG@list{\CO@grp}%
     \let\CO@grp\@empty
    }%
 }{%
      \appdef     \@AAC@list{\AF@opr}%
      \appdef@eval\@AAC@list{\AF@grp}%
      \appdef@e   \@AAC@list{\AU@grp}%
    \@ifx{\@empty\AU@grp}{%
     \@ifx{\@empty\CO@grp}%
    }{%
     \false@sw
    }%
    {%
    }{%
      \@booleanfalse\temp@sw
      \def\AFG@opr{\x@match\AF@grp}%
      \let\CO@opr\@author@gobble
      \@AFG@list
      \temp@sw{}{%
        \appdef     \@AFG@list{\AFG@opr}%
        \appdef@eval\@AFG@list{\AF@grp}%
      }%
     \@ifx{\@empty\CO@grp}{}{%
       \appdef@e   \@AAC@list{\CO@grp}%
       \appdef@e   \@AFG@list{\CO@grp}%
       \let\CO@grp\@empty
     }%
    }%
    \let\CO@grp\@empty
    \let\AU@grp\@empty
    \let\AF@grp\@empty
 }%
 \frontmatterverbose@sw{\say\@AAC@list\say\@AFG@list}{}%
}%
\appdef\frontmatter@init{%
 \let\AU@grp\@empty
 \let\CO@grp\@empty
 \let\AF@grp\@empty
 \let\@AAC@list\@empty
 \let\@AFG@list\@empty
 \let\@AFF@list\@empty
}%
\appdef\frontmatter@init{%
 \let\@AF@join\@AF@join@error
}%
\def\@AF@join@error#1{%
 \class@warn{%
  \string\email, \string\homepage, \string\thanks, or \string\altaffiliation\space
  appears in wrong context.
 }%
}%
\def\sanitize@url{%
 \@makeother\%%
 \@makeother\~%
 \@makeother\_%
}%
\newcommand*\homepage[1][]{\begingroup\sanitize@url\@homepage{#1}}%
\def\@homepage#1#2{%
 \endgroup
 \@AF@join{#1\href{#2}{#2}}%
}%
\appdef\class@documenthook{%
 \providecommand\href[1]{}%
}%
\def\frontmatter@thanks{% implicit #1
  \@AF@join
}%
\def\set@listcomma@list#1{%
  \expandafter\@reset@ac\expandafter#1#1{0}\@reset@ac{%
   \let\@listcomma\relax
  }{%
   \let\@listcomma\@listcomma@comma
  }%
}%
\def\set@listcomma@count#1{%
  \@ifnum{#1=\tw@}{%
    \let\@listcomma\relax
  }{%
    \let\@listcomma\@listcomma@comma
  }%
}%
\def\@reset@ac#1#2#3\@reset@ac{%
  \def#1{#3}%
  \@tempcnta#2\relax
  \@ifnum{#2=\tw@}%
}%
\def\@listand{\@ifnum{\@tempcnta=\tw@}{\andname\space}{}}%
\def\@listcomma@comma{\@ifnum{\@tempcnta>\@ne}{,}{}}%
\def\@listcomma@comma@UK{\@ifnum{\@tempcnta>\tw@}{,}{}}%
\def\@collaboration@gobble#1#2#3{}%

\def\x@match#1#2{%
 \temp@sw{}{%
  \def\@tempifx{#2}%
  \@ifx{\@tempifx#1}{%
    \@booleantrue\temp@sw
  }{%
  }%
 }%
}%
\def\y@match#1#2#3{%
 \temp@sw{}{%
  \def\@tempifx{#3}%
  \@ifx{\@tempifx#1}{%
    \@booleantrue\temp@sw
    \def\@tempb{#2}%
  }{%
  }%
 }%
}%
\def\frontmatter@footnote#1{%
 \begingroup
  \@booleanfalse\temp@sw
  \def\@tempa{#1}%
  \let\@tempb\@empty
  \def\@TBN@opr{\y@match\@tempa}%
  \@FMN@list
  \temp@sw{%
   \expandafter\frontmatter@footnotemark
   \expandafter{\@tempb}%
  }{%
   \stepcounter\@mpfn
   \expandafter\expandafter
   \expandafter\frontmatter@foot@mark
   \expandafter\expandafter
   \expandafter{%
   \expandafter \the\csname c@\@mpfn\endcsname
               }{#1}%
  }%
 \endgroup
}%
\def\frontmatter@foot@mark#1#2{%
 \frontmatter@footnotemark{#1}%
 \g@addto@macro\@FMN@list{\@TBN@opr{#1}{#2}}%
}%
\appdef\frontmatter@init{%
 \global\let\@FMN@list\@empty
}%
\def\frontmatter@footnotemark#1{%
 \leavevmode
 \ifhmode\edef\@x@sf{\the\spacefactor}\nobreak\fi
  \begingroup
   \hyper@linkstart {link}{frontmatter.#1}%
    \csname c@\@mpfn\endcsname#1\relax
    \def\@thefnmark{\frontmatter@thefootnote}%
    \@makefnmark
   \hyper@linkend
  \endgroup
 \ifhmode\spacefactor\@x@sf\fi
 \relax
}%
\def\keywords#1{%
  \aftermaketitle@chk{\keywords}%
  \gdef\@keywords{#1}%
}%
\appdef\frontmatter@init{%
 \let\@keywords\@empty
}%
\newcommand*\frontmatter@date[2][\Dated@name]{\def\@date{#1#2}}%
\def\@date{}%
\newcommand*\received[2][\Received@name]{\def\@received{#1#2}}%
\def\@received{}%
\newcommand*\revised[2][\Revised@name]{\def\@revised{#1#2}}%
\def\@revised{}%
\newcommand*\accepted[2][\Accepted@name]{\def\@accepted{#1#2}}%
\def\@accepted{}%
\newcommand*\published[2][\Published@name]{\def\@published{#1#2}}%
\def\@published{}%

\def\preprint#1{\gappdef\@preprint{\preprint{#1}}}%
\appdef\frontmatter@init{%
 \let\@preprint\@empty
}%
\newbox\absbox

\def\toclevel@abstract{1}%

\def\addcontents@abstract{%
 \phantomsection
 \expandafter\def\csname Parent0\endcsname{section*.2}%
 \expandafter\@argswap@val\expandafter{\abstractname}{\addcontentsline{toc}{abstract}}%
}%

\newif\ifabstract%

\newenvironment{frontmatter@abstract}{%
  \aftermaketitle@chk{\begin{abstract}}%
\global\abstracttrue
  \global\setbox\absbox\vbox\bgroup
   \color@begingroup
\ifmodern
 \columnwidth\textwidth
 \hsize\columnwidth
\else
\hsize = 478pt
\fi
   \@parboxrestore
   \def\@mpfn{mpfootnote}\def\thempfn{\thempfootnote)}\c@mpfootnote\z@ % 
   \minipagefootnote@init
   \let\set@listindent\set@listindent@
   \let\@listdepth\@mplistdepth \@mplistdepth\z@
   \let@environment{description}{frontmatter@description}%
   \@minipagerestore
   \@setminipage
    \frontmatter@abstractheading
    \frontmatter@abstractfont
\ifmodern\else\everypar={\leftskip=34pt}\fi
\ifnumlines\let\go\linenumbers\else\let\go\relax\fi\go
}{%
\ifnumlines\let\go\endlinenumbers\else\let\go\relax\fi\go
    \par
    \unskip
    \minipagefootnote@here
    \@minipagefalse   
    \color@endgroup
\egroup% end setbox\absbox
}%

\long\def\frontmatter@footnotetext#1{%
  \minipagefootnote@pick
    \set@footnotefont
    \set@footnotewidth
    \@parboxrestore
    \protected@edef\@currentlabel{\csname p@\@mpfn\endcsname\@thefnmark}%
    \color@begingroup
      \frontmatter@makefntext{%
        \rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox\vadjust{\vskip\z@skip}%
      }%
    \color@endgroup
  \minipagefootnote@drop
}%
\def\ltx@no@footnote{%
 \let\ltx@xfootnote\ltx@no@xfootnote\let\ltx@yfootnote\ltx@no@yfootnote
 \let\ltx@xfootmark\ltx@no@xfootmark\let\ltx@yfootmark\ltx@no@yfootmark
 \let\ltx@xfoottext\ltx@no@xfoottext\let\ltx@yfoottext\ltx@no@yfoottext
}%
\def\ltx@no@xfootnote[#1]#2{\ltx@no@footwarn\footnote}%
\def\ltx@no@yfootnote#1{\ltx@no@footwarn\footnote}%
\def\ltx@no@xfootmark[#1]{\ltx@no@footwarn\footnotemark}%
\def\ltx@no@yfootmark{\ltx@no@footwarn\footnotemark}%
\def\ltx@no@xfoottext[#1]#2{\ltx@no@footwarn\footnotetext}%
\def\ltx@no@yfoottext#1{\ltx@no@footwarn\footnotetext}%
\def\ltx@no@footwarn#1{%
 \class@warn{%
  The \string#1\space command is not legal on the title page;
  using \string\thanks\space instead might suit you: consult the manual for details%
 }%
}%


\newenvironment{frontmatter@description}{%
 \list{}{%
  \leftmargin\z@
  \labelwidth\z@
  \itemindent\z@
  \let\makelabel\frontmatter@descriptionlabel
 }%
}{%
 \endlist
}%
\def\frontmatter@descriptionlabel#1{%
 \hspace\labelsep
 \normalfont\bfseries
 #1:%
}%


\appdef\frontmatter@init{\let\mini@notes\@empty}%
\let\prep@absbox\@empty
\let\post@absbox\@empty

\def\maketitle@Hy{%
  \let\Hy@saved@footnotemark\@footnotemark
  \let\Hy@saved@footnotetext\@footnotetext
  \let\@footnotemark\H@@footnotemark
  \let\@footnotetext\H@@footnotetext
  \@ifnextchar[%]
   \Hy@maketitle@optarg
   {%
    \HyOrg@maketitle
    \Hy@maketitle@end
   }%
}%
\appdef\class@documenthook{\ifnumlines\nolinenumbers\fi%
  \@ifx{\maketitle\maketitle@Hy}{%
   \class@info{Taking \string\maketitle\space back from hyperref}%
   \let\maketitle\frontmatter@maketitle
  }{%
  }%
}%

\def\toclevel@title{0}%
\def\frontmatter@title@produce{%
 \begingroup
\ifnumlines\nolinenumbers\fi
  \frontmatter@title@above
\ifnumlines\linenumbers\fi
\def\thempfn{\hskip-12pt}
 \ifx\@@email\@empty\else
 \footnotetext{\hskip-11ptEmail: \@@email}\fi%
  \frontmatter@title@format
  \@title
  \@ifx{\@title@aux\@title@aux@cleared}{}{%
\ifanonymous\else%%
  \expandafter\frontmatter@footnote\expandafter{\@title@aux}%
\fi
  }%
  \par
\ifmodern
\vskip-42pt
\else
  \frontmatter@title@below
\fi
 \endgroup
}%

\appdef\let@mark{\let\\\relax}%

\newif\iffrontmatterfirsttime
\global\frontmatterfirsttimetrue
\let\savecentercr\@centercr

\def\frontmatter@author@produce@script{%
  \begingroup
    \let\@author@present\@author@present@script
    \frontmatterverbose@sw{\typeout{\string\frontmatter@author@produce@script:}\say\@AAC@list\say\@AFF@list\say\@AFG@list}{}%
    \let\AU@temp\@empty
    \@tempcnta\z@
    \let\AF@opr \@gobble
    \def\AU@opr{\@author@count\@tempcnta}%
    \def\CO@opr{\@collaboration@count\AU@temp\@tempcnta}%
    \@AAC@list
    \expandafter\CO@opr\@author@cleared
    \begingroup
     \frontmatter@authorformat
     \let\AF@opr \@affilID@def
     \let\AU@opr \@author@present
     \def\CO@opr{\@collaboration@present\AU@temp}%
     \set@listcomma@list\AU@temp
     \@AAC@list
     \, \unskip\unskip
     \par
    \endgroup
%% below
    \begingroup
     \frontmatter@above@affiliation@script
     \let\AFF@opr \@affil@script
{\parskip=2pt
\def\@centercr{\vrule depth 3pt width0pt\vskip1sp}
     \@AFF@list}
\let\@centercr\savecentercr
%%
\iffrontmatterfirsttime
\frontmatter@footnote@produce
\global\frontmatterfirsttimefalse
\fi
     \par
    \endgroup
  \endgroup
}%

\def\@author@count#1{%
 \advance#1\@ne
 \@author@gobble
}%
\def\@collaboration@present#1#2#3#4{%
 \par
 \begingroup
  \frontmatter@collaboration@above
  \@affilID@def{}%
  \@tempcnta\z@
  \@author@present{}{(\ignorespaces#3\unskip)}{#4}%
  \par
 \endgroup
 \set@listcomma@list#1%
}%

\def\@collaboration@count#1#2{%
 \appdef@eval#1{\the#2}#2\z@
 \@author@gobble
}%
\def\@affilID@def{\def\@affilID@temp}%
\let\@affilID@temp\@empty
\def\affil@script#1#2#3{%
 \def\@tempifx{#1}\@ifx{\@tempifx\@tempa}{%
  \@if@empty{#2}{}{%
   \par
   \begingroup
    \def\@thefnmark{#1}\@makefnmark\ignorespaces
    #2%
    \@if@empty{#3}{}{\frontmatter@footnote{#3}}%
    \par
   \endgroup
  }%
 }{}%
}%



\let\affil@cutoff\@ne
\def\@author@present@script#1#2#3{%
 \begingroup
  \gdef\comma@space{\textsuperscript{,\,}}%
  \doauthor{#2}{#3}{\@affil@present@script}%
 \endgroup
 \advance\@tempcnta\m@ne
}%
\def\@affilcomma#1#2{%
 \@ifx{\z@#1}{%
  \@ifx{\relax#2}{}{%
   \@affilcomma{#2}%
  }%
 }{%
  #1%
  \@ifx{\relax#2}{}{%
   \@ifx{\z@#2}{%
    \@affilcomma
   }{%
    ,\,\@affilcomma{#2}%
   }%
  }%
 }%
}%
\def\@affil@present@script{%
 \let\@tempa\@empty
 \expandafter\@affil@present@script@\@affilID@temp\relax
}%
\def\@affil@present@script@#1{%
 \@ifx{\relax#1}{%
  \@ifx{\@tempa\@empty}{%
   \aftergroup\false@sw
  }{%
   \textsuperscript{\expandafter\@affilcomma\@tempa\relax\relax}%
   \aftergroup\true@sw
  }%
 }{%
  \@ifnum{#1=\z@}{}{\appdef\@tempa{{#1}}}%
  \@affil@present@script@
 }%
}%
\@provide\@author@parskip{\z@skip}%
\def\frontmatter@author@produce@group{%
  \begingroup
    \let\@author@present\@author@present@group
    \frontmatter@authorformat
    \frontmatterverbose@sw{\typeout{\string\frontmatter@author@produce@group:}\say\@AAC@list\say\@AFF@list\say\@AFG@list}{}%
    \let\AU@temp\@empty
    \set@listcomma@list\AU@temp
    \def\CO@opr{\@collaboration@present\AU@temp}%
    \let\AFG@opr \affils@present@group
    \let\@listcomma\relax
    \@AFG@list
    \frontmatter@footnote@produce
    \par
  \endgroup
  \frontmatter@authorbelow
}%
\@provide\frontmatter@authorbelow{}%
\def\affils@present@group#1{%
 \begingroup
   \def\AF@temp{#1}%
   \@tempcnta\z@
   \let\AU@opr \@undefined
   \let\CO@opr \@undefined
   \def\AF@opr{\@affilID@count\AF@temp\@tempcnta}%
   \@AAC@list
   \@ifnum{\@tempcnta=\z@}{}{%
    \begingroup
     \frontmatter@above@affilgroup
     \set@listcomma@count\@tempcnta
     \let\AU@opr \@undefined
     \let\CO@opr \@undefined
     \def\AF@opr{\@affilID@match\AF@temp}%
     \@AAC@list
    \endgroup
    \begingroup
     \par
     \frontmatter@above@affiliation
     \frontmatter@affiliationfont
     \let\\\frontmatter@addressnewline
     \@tempcnta\z@
     \@tfor\AF@temp:=#1\do{%
      \expandafter\@ifx\expandafter{\expandafter\z@\AF@temp}{}{%
       \advance\@tempcnta\@ne
      }%
     }%
     \@ifnum{\@tempcnta=\tw@}{%
      \let\@listcomma\relax
     }{}%
     \def@after@address
     \runinaddress@sw{%
     }{%
      \tightenlines@sw{}{%
       \parskip\z@
      }%
      \appdef\after@address\par
     }%
     \let\AFF@opr \@affil@group
     \do@affil@fromgroup\@AFF@list#1\relax
    \endgroup
   }%
   \par
 \endgroup
}%
\def\def@after@address{\def\after@address{\@listcomma\ \@listand}}%
\def\def@after@address@empty{\let\after@address\@empty}%
\def\@affilID@count#1#2#3{%
  \def\@tempifx{#3}%
  \@ifx{\@tempifx#1}{%
    \def\AU@opr{\@author@count#2}%
  }{%
    \let\AU@opr \@author@gobble
  }%
  \let\CO@opr \@collaboration@gobble
}%
\def\@affilID@match#1#2{%
 \def\@tempifx{#2}%
 \@ifx{\@tempifx#1}{%
   \let\AU@opr \@author@present
 }{%
   \let\AU@opr \@author@gobble
 }%
  \let\CO@opr \@collaboration@gobble
}%
\def\do@affil@fromgroup#1#2{%
  \@ifx{\relax#2}{}{%
    \count@#2\relax
    \@ifnum{\z@=\count@}{}{#1}%
    \do@affil@fromgroup#1%
  }%
}%
\def\@affil@group#1#2#3#4{%
  \@ifnum{#1=\count@}{%
   \def\@tempa{#3}%
   \@ifx{\@tempa\blankaffiliation}{}{%
    #3%
    \@if@empty{#4}{}{%
     \frontmatter@footnote{#4}%
    }%
    \after@address
   }%
   \advance\@tempcnta\m@ne
  }{}%
}%
\def\@author@present@group#1#2#3{%
  \gdef\comma@space{\gdef\comma@space{\textsuperscript{,\,}}}%
  \doauthor{#2}{#3}{\@affil@present@group}%
  \advance\@tempcnta\m@ne
}%
\def\@affil@present@group{%
 \aftergroup\false@sw
}%

\def\frontmatter@footnote@produce@footnote{%
 \let\@TBN@opr\present@FM@footnote
 \@FMN@list
 \global\let\@FMN@list\@empty
}%
\def\present@FM@footnote#1#2{%
 \begingroup
  \csname c@\@mpfn\endcsname#1\relax
  \def\@thefnmark{\frontmatter@thefootnote}%
  \frontmatter@footnotetext{#2}%
 \endgroup
}%
\def\frontmatter@footnote@produce@endnote{%
}%

\appdef\frontmatter@init{%
 \@ifxundefined\title@column         {\let\title@column\@empty}{}%
 \@ifxundefined\preprintsty@sw       {\@booleanfalse\preprintsty@sw}{}%
 \@ifxundefined\manuscriptsty@sw       {\@booleanfalse\manuscriptsty@sw}{}%
 \@ifxundefined\frontmatter@footnote@produce{\let\frontmatter@footnote@produce\frontmatter@footnote@produce@footnote}{}%
 \@ifxundefined\do@output@MVL        {\let\do@output@MVL\@firstofone}{}%
 \@ifxundefined\comma@space          {\let\comma@space\@empty}{}%
}%
\def\frontmatter@thefootnote{%
 \altaffilletter@sw{\@alph}{\@fnsymbol}{\csname c@\@mpfn\endcsname}%
}%
\@ifx{\altaffilletter@sw\@undefined}{\@booleantrue\altaffilletter@sw}{}%

\def\frontmatter@RRAPformat#1{%
 \removelastskip
 \begingroup
  \frontmatter@RRAP@format
  #1\par
 \endgroup
}%
\def\punct@RRAP{; }%
\def\produce@RRAP#1{%
  \@if@empty{#1}{}{%
   \@ifvmode{\leavevmode}{\unskip\punct@RRAP\ignorespaces}%
   #1%
  }%
}%
\def\frontmatter@above@affilgroup{}%
\def\frontmatter@finalspace{\vskip-24\p@}
\def\frontmatter@addressnewline{%
  \@ifhmode{\skip@\lastskip\unskip\unpenalty\break\hskip\skip@}{}%
  % was: \vskip-.5ex
}%

\def\frontmatter@preabstractspace{12\p@}
\def\frontmatter@postabstractspace{12\p@}
\def\aftermaketitle@chk#1{%
  \@ifx{\maketitle\relax}{%
    \class@err{\protect#1 must be used before \protect\maketitle}%
  }{}%
}%

\def\volumeyear#1{\gdef\@volumeyear{#1}}%
\def\@volumeyear{}%
\def\volumenumber#1{\gdef\@volumenumber{#1}}%
\def\@volumenumber{}%
\def\issuenumber#1{\gdef\@issuenumber{#1}}%
\def\@issuenumber{}%
\def\eid#1{\gdef\@eid{#1}}%
\def\@eid{}%
\def\startpage#1{\gdef\@startpage{#1}\c@page#1\relax}%
\def\@startpage{\pageref{FirstPage}}%
\def\endpage#1{\gdef\@endpage{#1}}%
\def\@endpage{\pageref{LastPage}}%

\def\appendix@toc{}%

\appdef\robustify@contents{%
 \let\thanks\@gobble\let\class@warn\@gobble
 \def\begin{\string\begin}\def\end{\string\end}%
}%


\@ifxundefined\frontmatter@syntax@sw{\@booleantrue\frontmatter@syntax@sw}{}%

\frontmatter@syntax@sw{%
 \let\title         \frontmatter@title
 \let\author        \frontmatter@author
 \let\date          \frontmatter@date
 \@ifxundefined\@maketitle{%
  \let\maketitle    \frontmatter@maketitle
  \@booleantrue     \titlepage@sw
 }{%
  \let\@maketitle   \frontmatter@maketitle
  \prepdef\maketitle\@author@finish
 }%
 \let\noaffiliation \frontmatter@noaffiliation
 \let\thanks@latex  \thanks
 \let\thanks        \frontmatter@thanks
 \let\and@latex     \and
 \let\and           \frontmatter@and
 \let@environment{titlepage}{frontmatter@titlepage}%
 \let@environment{abstract}{frontmatter@abstract}%
}{%
 \let\noaffiliation\@empty
}%

\typeout{%
ltxgrid%
 [2022/06/05 4.2f page grid package (portions licensed from W. E. Baxter web at superscript.com)]% \fileversion
}%
\newcounter{linecount}
\def\loop@line#1#2{%
 \par
 \hb@xt@\hsize{%
  \global\advance#1\@ne
  \edef\@tempa{\@ifnum{100>#1}{0}{}\@ifnum{10>#1}{0}{}\number#1}%
  \@tempa\edef\@tempa{\special{line:\@tempa}}\@tempa
  \vrule depth2.5\p@#2\leaders\hrule\hfil
 }%
}%
\def\lineloop#1{%
 \loopwhile{\loop@line\c@linecount{}\@ifnum{#1>\c@linecount}}%
}%
\def\linefoot#1{%
 \loop@line\c@linecount{%
  \footnote{%
   #1\special{foot:#1}\vrule depth2.5\p@\leaders\hrule\hfill
  }%
 }%
}%
\let\@@mark\mark
\let\@@topmark\topmark
\let\@@firstmark\firstmark
\let\@@botmark\botmark
\let\@@splitfirstmark\splitfirstmark
\let\@@splitbotmark\splitbotmark
\def\@themark{{}{}{}{}}%
\def\nul@mark{{}{}{}{}\@@nul}%
\def\set@mark@netw@#1#2#3#4#5#6#7{\gdef#1{{#6}{#7}{#4}{#5}}\do@mark}%
\def\set@marktw@#1#2#3#4#5#6{\gdef#1{{#2}{#6}{#4}{#5}}\do@mark}%
\def\set@markthr@@#1#2#3#4#5#6{\gdef#1{{#2}{#3}{#6}{#5}}\do@mark}%
\def\get@mark@@ne#1#2#3#4#5\@@nul{#1}%
\def\get@mark@tw@#1#2#3#4#5\@@nul{#2}%
\def\get@mark@thr@@#1#2#3#4#5\@@nul{#3}%
\def\get@mark@f@ur#1#2#3#4#5\@@nul{#4}%
\def\mark@netw@{\expandafter\set@mark@netw@\expandafter\@themark\@themark}%
\def\marktw@{\expandafter\set@marktw@\expandafter\@themark\@themark}%
\def\markthr@@{\expandafter\set@markthr@@\expandafter\@themark\@themark}%
\def\do@mark{\do@@mark\@themark\nobreak@mark}%
\def\do@@mark#1{%
 \begingroup
  \let@mark
  \@@mark{#1}%
 \endgroup
}%
\def\let@mark{%
 \let\protect\@unexpandable@protect
 \let\label\relax
 \let\index\relax
 \let\glossary\relax
}%
\def\nobreak@mark{%
 \@if@sw\if@nobreak\fi{\@ifvmode{\nobreak}{}}{}%
}%
\def\mark@envir{\markthr@@}%
\def\bot@envir{%
 \expandafter\expandafter
 \expandafter\get@mark@thr@@
 \expandafter\@@botmark
             \nul@mark
}%
\def\markboth{\mark@netw@}%
\def\markright{\marktw@}%
\def\leftmark{%
 \expandafter\expandafter
 \expandafter\get@mark@@ne
 \expandafter\saved@@botmark
             \nul@mark
}%
\def\rightmark{%
 \expandafter\expandafter
 \expandafter\get@mark@tw@
 \expandafter\saved@@firstmark
             \nul@mark
}%
\let\primitive@output\output
\long\def\@tempa#1\@@nil{#1}%
            \toks@
\expandafter\expandafter
\expandafter{%
\expandafter \@tempa
             \the\primitive@output
             \@@nil
             }%
\newtoks\output@latex
\output@latex\expandafter{\the\toks@}%
\let\output\output@latex
\primitive@output{\dispatch@output}%
\def\dispatch@output{%
 \let\par\@@par
 \expandafter\let\expandafter\output@procedure\csname output@\the\outputpenalty\endcsname
 \@ifnotrelax\output@procedure{}{%
  \expandafter\def\expandafter\output@procedure\expandafter{\the\output@latex}%
 }%
 \expandafter\@ifx\expandafter{\csname output@-\the\execute@message@pen\endcsname\output@procedure}{%
  \let\output@procedure\@message@saved
 }{}%
 \ltxgrid@info@sw{\class@info{\string\dispatch@output}\say\output@procedure\saythe\holdinginserts}{}%
 \outputdebug@sw{\output@debug}{}%
 \output@procedure
}%
\def\set@output@procedure#1#2{%
 \count@\outputpenalty\advance\count@-#2%
 \expandafter\let\expandafter#1\csname output@\the\count@\endcsname
}%
\def\output@debug{%
 \def\@tempa{\save@message}%
 \@ifx{\output@procedure\@tempa}{%
  \true@sw
 }{%
  \@ifnum{\outputpenalty=-\save@column@insert@pen}{%
   \@ifnum{\holdinginserts>\z@}%
  }{%
   \false@sw
  }%
 }%
 {}{\output@debug@}%
}%
\def\output@debug@{%
  \saythe\outputpenalty
  \saythe\interlinepenalty
  \saythe\brokenpenalty
  \saythe\clubpenalty
  \saythe\widowpenalty
  \saythe\displaywidowpenalty
  \saythe\predisplaypenalty
  \saythe\interdisplaylinepenalty
  \saythe\postdisplaypenalty
  \saythe\badness
  \say\thepagegrid
  \saythe\pagegrid@col
  \saythe\pagegrid@cur
  \saythe\insertpenalties
  \say\@@botmark
  \saythe\pagegoal
  \saythe\pagetotal
  \saythe{\badness\@cclv}%
  \say\@toplist
  \say\@botlist
  \say\@dbltoplist
  \say\@deferlist
  \trace@scroll{%
  \showbox\@cclv
  \showbox\@cclv@saved
  \showbox\pagesofar
  \showbox\csname col@1\endcsname
  \showbox\footsofar
  \showbox\footins
  \showbox\footins@saved
  \showlists
  }%
}%
\@ifxundefined{\outputdebug@sw}{%
 \@booleanfalse\outputdebug@sw
}{}%
\def\trace@scroll#1{\begingroup\showboxbreadth\maxdimen\showboxdepth\maxdimen\scrollmode#1\endgroup}%
\def\trace@box#1{\trace@scroll{\showbox#1}}%
\prepdef\@outputpage{\@outputpage@head}%
\let\@outputpage@head\@empty
\appdef\@outputpage{\@outputpage@tail}%
\let\@outputpage@tail\@empty
\def\show@box@size#1#2{%
 \show@box@size@sw{%
  \begingroup
   \setbox\z@\vbox{\unvcopy#2\hrule}%
   \class@info{Show box size: #1^^J%
    (\the\ht\z@\space X \the\wd\z@)
    \the\c@page\space\space\the\pagegrid@cur\space\the\pagegrid@col
   }%
  \endgroup
 }{}%
}%
\def\show@text@box@size{%
 \show@box@size{Text column}\@outputbox
 \tally@box@size@sw{%
  \@ifdim{\wd\@outputbox>\z@}{%
   \dimen@\ht\@outputbox\divide\dimen@\@twopowerfourteen
   \advance\dimen@-\dp\csname box@size@\the\pagegrid@col\endcsname
   \@ifdim{\dimen@>\z@}{%
    \advance\dimen@ \ht\csname box@size@\the\pagegrid@col\endcsname
    \global\ht\csname box@size@\the\pagegrid@col\endcsname\dimen@
    \show@box@size@sw{%
     \class@info{Column: \the\dimen@}%
    }{}%
   }{}%
  }{}%
  \global\dp\csname box@size@\the\pagegrid@col\endcsname\z@
 }{}%
}%
\def\show@pagesofar@size{%
 \show@box@size{Page so far}\pagesofar
 \dimen@\ht\pagesofar\divide\dimen@\@twopowerfourteen
 \global\dp\csname box@size@1\endcsname\dimen@
 \show@box@size@sw{%
  \class@info{Pagesofar: \the\dimen@}%
 }{}%
}%
\@booleanfalse\tally@box@size@sw
\@booleanfalse\show@box@size@sw
\expandafter\newbox\csname box@size@1\endcsname
\expandafter\setbox\csname box@size@1\endcsname\hbox{}%
\expandafter\newbox\csname box@size@2\endcsname
\expandafter\setbox\csname box@size@2\endcsname\hbox{}%
\def\total@text{%
 \@tempdima\the\ht\csname box@size@2\endcsname\divide\@tempdima\@twopowertwo\@tempcnta\@tempdima
 \@tempdimb\the\ht\csname box@size@1\endcsname\divide\@tempdimb\@twopowertwo\@tempcntb\@tempdimb
 \class@info{Total text: Column(\the\@tempcnta pt), Page(\the\@tempcntb pt)}%
}%
\def\natural@output{\toggle@insert{\output@holding}{\output@moving}}%
\output@latex{\natural@output}%
\def\output@holding{%
 \csname output@init@\bot@envir\endcsname
 \@if@exceed@pagegoal{\unvcopy\@cclv}{%
  \setbox\z@\vbox{\unvcopy\@cclv}%
  \outputdebug@sw{\trace@box\z@}{}%
  \dimen@\ht\@cclv\advance\dimen@-\ht\z@
  \dead@cycle@repair\dimen@
 }{%
  \dead@cycle
 }%
}%
\def\@if@exceed@pagegoal#1{%
 \begingroup
  \setbox\z@\vbox{#1}%
  \dimen@\ht\z@\advance\dimen@\dp\z@
  \outputdebug@sw{\saythe\dimen@}{}%
  \@ifdim{\dimen@>\pagegoal}{%
   \setbox\z@\vbox{\@@mark{}\unvbox\z@}%
   \splittopskip\topskip
   \splitmaxdepth\maxdepth
   \vbadness\@M
   \vfuzz\maxdimen
   \setbox\tw@\vsplit\z@ to\pagegoal
   \outputdebug@sw{\trace@scroll{\showbox\tw@\showbox\z@}}{}%
   \setbox\tw@\vbox{\unvbox\tw@}%
   \@ifdim{\ht\tw@=\z@}{%
    \ltxgrid@info{Found overly large chunk while preparing to move insertions. Attempting repairs}%
    \aftergroup\true@sw
   }{%
    \aftergroup\false@sw
   }%
 }{%
  \aftergroup\false@sw
 }%
 \endgroup
}%
\def\output@moving{%
 \set@top@firstmark
 \@ifnum{\outputpenalty=\do@newpage@pen}{%
  \setbox\@cclv\vbox{%
   \unvbox\@cclv
   \remove@lastbox
   \@ifdim{\ht\z@=\ht\@protection@box}{\box\lastbox}{\unskip}%
  }%
 }{}%
 \@cclv@nontrivial@sw{%
  \expandafter\output@do@prep\csname output@prep@\bot@envir \endcsname
  \@makecolumn\true@sw
  \expandafter\output@column@do\csname output@column@\thepagegrid\endcsname
  \protect@penalty\do@startcolumn@pen
  \clearpage@sw{%
   \protect@penalty\do@endpage@pen
  }{}%
  \expandafter\let\expandafter\output@post@\csname output@post@\bot@envir \endcsname
  \outputdebug@sw{\say\output@post@}{}%
  \@ifx{\output@post@\relax}{\output@post@document}{\output@post@}%
 }{%
  \void@cclv
 }%
 \set@colht
 \global\@mparbottom\z@
 \global\@textfloatsheight\z@
}%
\def\output@do@prep#1{%
 \outputdebug@sw{\class@info{Prep: \string#1}}{}%
 \@ifx{#1\relax}{\output@prep@document}{#1}%
}%
\def\output@column@do#1{%
  \outputdebug@sw{\class@info{Output column: \string#1}}{}%
  \@ifx{#1\relax}{\output@column@one}{#1}%
}%
\def\void@cclv{\begingroup\setbox\z@\box\@cclv\endgroup}%
\def\remove@lastbox{\setbox\z@\lastbox}%
\def\@cclv@nontrivial@sw{%
 \@ifx@empty\@toplist{%
  \@ifx@empty\@botlist{%
   \@ifvoid\footins{%
    \@ifvoid\@cclv{%
     \false@sw
    }{%
     \setbox\z@\vbox{\unvcopy\@cclv}%
     \@ifdim{\ht\z@=\topskip}{%
      \setbox\z@\vbox\bgroup
       \unvbox\z@
       \remove@lastbox
       \dimen@\lastskip\unskip
       \@ifdim{\ht\z@=\ht\@protection@box}{%
        \advance\dimen@\ht\z@
        \@ifdim{\dimen@=\topskip}{%
         \aftergroup\true@sw
        }{%
         \aftergroup\false@sw
        }%
       }{%
        \aftergroup\false@sw
       }%
      \egroup
      {%
       \false@sw
      }{%
       \true@sw
      }%
     }{%
      \@ifdim{\ht\z@=\z@}{%
       \ltxgrid@info{Found trivial column. Discarding it}%
       \outputdebug@sw{\trace@box\@cclv}{}%
       \false@sw
      }{%
       \true@sw
      }%
     }%
    }%
   }{%
    \true@sw
   }%
  }{%
   \true@sw
  }%
 }{%
  \true@sw
 }%
}%
\def\protect@penalty#1{\protection@box\penalty-#1\relax}%
\newbox\@protection@box
\setbox\@protection@box\vbox to1986sp{\vfil}%
\def\protection@box{\nointerlineskip\copy\@protection@box}%
\def\dead@cycle@repair#1{%
 \expandafter\do@@mark
 \expandafter{%
              \@@botmark
             }%
 \unvbox\@cclv
 \nointerlineskip
 \vbox to#1{\vss}%
 \@ifnum{\outputpenalty<\@M}{\penalty\outputpenalty}{}%
}%
\def\dead@cycle@repair@protected#1{%
 \expandafter\do@@mark
 \expandafter{%
              \@@botmark
             }%
 \begingroup
  \unvbox\@cclv
  \remove@lastbox
  \nointerlineskip
  \advance#1-\ht\@protection@box
  \vbox to#1{\vss}%
  \protection@box % Reinsert protection box
  \@ifnum{\outputpenalty<\@M}{\penalty\outputpenalty}{}%
 \endgroup
}%
\def\dead@cycle{%
 \expandafter\do@@mark
 \expandafter{%
              \@@botmark
             }%
 \unvbox\@cclv
 \@ifnum{\outputpenalty<\@M}{\penalty\outputpenalty}{}%
}%
\def\output@init@document{%
 \ltxgrid@info@sw{\class@info{\string\output@init@document}}{}%
 \global\vsize\vsize
}%
\def\output@prep@document{%
 \ltxgrid@foot@info@sw{\class@info{\string\output@prep@document}\trace@scroll{\showbox\footins\showbox\footsofar}}{}%
 \@ifvoid\footsofar{%
 }{%
  \global\setbox\footins\vbox\bgroup
   \unvbox\footsofar
   \@ifvoid\footins{}{%
    \marry@baselines
    \unvbox\footins
   }%
  \egroup
  \ltxgrid@foot@info@sw{\trace@box\footins}{}%
 }%
}%
\def\output@post@document{}%
\let\@opcol\@undefined


\def\@makecolumn#1{%
 \ltxgrid@foot@info@sw{\class@info{\string\@makecolumn\string#1}}{}%
 \setbox\@outputbox\vbox\bgroup
  \boxmaxdepth\@maxdepth
  \@tempdima\dp\@cclv
  \unvbox\@cclv
  \vskip-\@tempdima
 \egroup
 \xdef\@freelist{\@freelist\@midlist}\global\let\@midlist\@empty
 \show@text@box@size
 \@combinefloats
 #1{%
  \@combineinserts\@outputbox\footins
 }{%
  \combine@foot@inserts\footsofar\footins
 }%
 \set@adj@colht\dimen@
 \count@\vbadness
 \vbadness\@M
 \setbox\@outputbox\vbox to\dimen@\bgroup
  \@texttop
  \dimen@\dp\@outputbox
  \unvbox\@outputbox
  \vskip-\dimen@
  \@textbottom
 \egroup
 \vbadness\count@
 \global\maxdepth\@maxdepth
}%
\let\@makespecialcolbox\@undefined
\def\@combineinserts#1#2{%
 \ltxgrid@foot@info@sw{\class@info{\string\@combineinserts\string#1\string#2}\trace@box#2}{}%
 \setbox#1\vbox\bgroup
  \unvbox#1%
  \@ifvoid{#2}{}{%
   \dimen@\ht#2\advance\dimen@\dp#2\advance\dimen@\skip#2%
   \show@box@size{Combining inserts}#2%
   \vskip\skip#2%
   \setbox\z@\vbox{\footnoterule}\dimen@i\ht\z@
   \color@begingroup
   \normalcolor
   \cleaders\box\z@\vskip\dimen@i\kern-\dimen@i
   \csname combine@insert@\the\pagegrid@col\endcsname#2%
   \color@endgroup
   \kern-\dimen@\kern\dimen@
  }%
 \egroup
 \ltxgrid@foot@info@sw{\trace@box#1}{}%
}%
\def\combine@insert@tw@#1{%
 \compose@footnotes@two#1\@ifvbox{#1}{\unvbox}{\box}#1%
}%
\def\combine@insert@@ne#1{%
 \compose@footnotes@one#1\@ifvbox{#1}{\unvbox}{\box}#1%
}%
\def\twocolumn@grid@setup{%
 \expandafter\let\csname combine@insert@1\endcsname\combine@insert@tw@
 \expandafter\let\csname combine@insert@2\endcsname\combine@insert@@ne
}%
\def\onecolumn@grid@setup{%
 \expandafter\let\csname combine@insert@1\endcsname\combine@insert@@ne
 \expandafter\let\csname combine@insert@2\endcsname\combine@insert@@ne
}%
\let\columngrid@setup\onecolumn@grid@setup
\columngrid@setup
\appdef\@floatplacement{%
 \global\@fpmin\@fpmin
}%
\mathchardef\pagebreak@pen=\@M
\expandafter\let\csname output@-\the\pagebreak@pen\endcsname\relax
\mathchardef\do@startcolumn@pen=10005
\@namedef{output@-\the\do@startcolumn@pen}{\do@startcolumn}%
\def\do@startcolumn{%
 \setbox\@cclv\vbox{\unvbox\@cclv\remove@lastbox\unskip}%
 \clearpage@sw{\@clearfloatplacement}{\@floatplacement}%
 \set@colht
 \@booleanfalse\pfloat@avail@sw
 \begingroup
  \@colht\@colroom
  \@booleanfalse\float@avail@sw
  \@tryfcolumn\test@colfloat
  \float@avail@sw{\aftergroup\@booleantrue\aftergroup\pfloat@avail@sw}{}%
 \endgroup
 \fcolmade@sw{%
  \setbox\@cclv\vbox{\unvbox\@outputbox\unvbox\@cclv}%
  \outputpenalty-\pagebreak@pen
  \dead@cycle
 }{%
  \begingroup
   \let\@elt\@scolelt
   \let\reserved@b\@deferlist\global\let\@deferlist\@empty\reserved@b
  \endgroup
  \clearpage@sw{%
   \outputpenalty\@M
  }{%
   \outputpenalty\do@newpage@pen
  }%
  \dead@cycle
 }%
 \check@deferlist@stuck\do@startcolumn
 \set@vsize
}%
\def\@scolelt#1{\def\@currbox{#1}\@addtonextcol}%
\def\test@colfloat#1{%
 \csname @floatselect@sw@\thepagegrid\endcsname#1{}{\@testtrue}%
 \@if@sw\if@test\fi{}{\aftergroup\@booleantrue\aftergroup\float@avail@sw}%
}%
\def\@addtonextcol{%
 \begingroup
  \@insertfalse
  \@setfloattypecounts
  \csname @floatselect@sw@\thepagegrid\endcsname\@currbox{%
   \@ifnum{\@fpstype=8 }{}{%
     \@ifnum{\@fpstype=24 }{}{%
       \@flsettextmin
       \@reqcolroom \ht\@currbox
       \advance \@reqcolroom \@textmin
       \advance \@reqcolroom \vsize % take into account split insertions
       \advance \@reqcolroom -\pagegoal
       \@ifdim{\@colroom>\@reqcolroom}{%
         \@flsetnum \@colnum
         \@ifnum{\@colnum>\z@}{%
            \@bitor\@currtype\@deferlist
            \@if@sw\if@test\fi{}{%
              \@addtotoporbot
            }%
         }{}%
       }{}%
     }%
   }%
  }{}%
  \@if@sw\if@insert\fi{}{%
    \@cons\@deferlist\@currbox
  }%
 \endgroup
}%
\mathchardef\do@startpage@pen=10006
\@namedef{output@-\the\do@startpage@pen}{\do@startpage}%
\def\do@startpage{%
 \setbox\@cclv\vbox{\unvbox\@cclv\remove@lastbox\unskip}%
 \clearpage@sw{\@clearfloatplacement}{\@dblfloatplacement}%
 \set@colht
 \@booleanfalse\pfloat@avail@sw
 \begingroup
  \@booleanfalse\float@avail@sw
  \@tryfcolumn\test@dblfloat
  \float@avail@sw{\aftergroup\@booleantrue\aftergroup\pfloat@avail@sw}{}%
 \endgroup
 \fcolmade@sw{%
  \global\setbox\pagesofar\vbox{\unvbox\pagesofar\unvbox\@outputbox}%
  \@output@combined@page
 }{%
  \begingroup
   \@booleanfalse\float@avail@sw
   \let\@elt\@sdblcolelt
   \let\reserved@b\@deferlist\global\let\@deferlist\@empty\reserved@b
  \endgroup
  \@ifdim{\@colht=\textheight}{% No luck...
   \pfloat@avail@sw{% ...but a float *was* available!
    \forcefloats@sw{%
     \ltxgrid@warn{Forced dequeueing of floats stalled}%
    }{%
     \ltxgrid@warn{Dequeueing of floats stalled}%
    }%
   }{}%
  }{}%
  \outputpenalty\@M
  \dead@cycle
 }%
 \check@deferlist@stuck\do@startpage
 \set@colht
}%
\def\@output@combined@page{%
 \@combinepage\true@sw
 \@combinedblfloats
 \@outputpage
 \global\pagegrid@cur\@ne
 \protect@penalty\do@startpage@pen
}%
\def\@sdblcolelt#1{\def\@currbox{#1}\@addtodblcol}%
\def\test@dblfloat#1{%
 \@if@notdblfloat{#1}{\@testtrue}{}%
 \@if@sw\if@test\fi{}{\aftergroup\@booleantrue\aftergroup\float@avail@sw}%
}%
\def\@if@notdblfloat#1{\@ifdim{\wd#1<\textwidth}}%
\@booleanfalse\forcefloats@sw
\def\@addtodblcol{%
 \begingroup
  \@if@notdblfloat{\@currbox}{%
   \false@sw
  }{%
   \@setfloattypecounts
   \@getfpsbit \tw@
   \@bitor \@currtype \@deferlist
   \@if@sw\if@test\fi{%
    \false@sw
   }{%
    \@ifodd\@tempcnta{%
     \aftergroup\@booleantrue\aftergroup\float@avail@sw
     \@flsetnum \@dbltopnum
     \@ifnum{\@dbltopnum>\z@}{%
       \@ifdim{\@dbltoproom>\ht\@currbox}{%
        \true@sw
       }{%
        \@ifnum{\@fpstype<\sixt@@n}{%
         \begingroup
          \advance \@dbltoproom \@textmin
          \@ifdim{\@dbltoproom>\ht\@currbox}{%
           \endgroup\true@sw
          }{%
           \endgroup\false@sw
          }%
        }{%
         \false@sw
        }%
       }%
     }{%
      \false@sw
     }%
    }{%
     \false@sw
    }%
   }%
  }%
  {%
   \@tempdima -\ht\@currbox
   \advance\@tempdima
    -\@ifx{\@dbltoplist\@empty}{\dbltextfloatsep}{\dblfloatsep}%
   \global \advance \@dbltoproom \@tempdima
   \global \advance \@colht \@tempdima
   \global \advance \@dbltopnum \m@ne
   \@cons \@dbltoplist \@currbox
  }{%
   \@cons \@deferlist \@currbox
  }%
 \endgroup
}%
\def\@tryfcolumn#1{%
  \global\@booleanfalse\fcolmade@sw
  \@ifx@empty\@deferlist{}{%
    \global\let\@trylist\@deferlist
    \global\let\@failedlist\@empty
    \begingroup
      \dimen@\vsize\advance\dimen@-\pagegoal\@ifdim{\dimen@>\z@}{%
       \advance\@fpmin-\dimen@
      }{}%
      \def\@elt{\@xtryfc#1}\@trylist
    \endgroup
    \fcolmade@sw{%
      \global\setbox\@outputbox\vbox{\vskip \@fptop}%
      \let \@elt \@wtryfc \@flsucceed
      \global\setbox\@outputbox\vbox{\unvbox\@outputbox
        \unskip \vskip \@fpbot
      }%
      \let \@elt \relax
      \xdef\@deferlist{\@failedlist\@flfail}%
      \xdef\@freelist{\@freelist\@flsucceed}%
    }{}%
  }%
}%
\def\@wtryfc #1{%
  \global\setbox\@outputbox\vbox{\unvbox\@outputbox
    \box #1\vskip\@fpsep
  }%
}%
\def\@xtryfc#1#2{%
  \@next\reserved@a\@trylist{}{}% trim \@trylist. Ugly!
  \@currtype \count #2%
  \divide\@currtype\@xxxii\multiply\@currtype\@xxxii
  \@bitor \@currtype \@failedlist
  \@testfp #2%
  #1#2%
  \@ifdim{\ht #2>\@colht   }{\@testtrue}{}%
  \@if@sw\if@test\fi{%
   \@cons\@failedlist #2%
  }{%
   \begingroup
     \gdef\@flsucceed{\@elt #2}%
     \global\let\@flfail\@empty
     \@tempdima\ht #2%
     \def \@elt {\@ztryfc#1}\@trylist
     \@ifdim{\@tempdima >\@fpmin}{%
       \global\@booleantrue\fcolmade@sw
     }{%
       \@cons\@failedlist #2%
     }%
   \endgroup
   \fcolmade@sw{%
     \let \@elt \@gobble
   }{}%
  }%
}%
\def\@ztryfc #1#2{%
  \@tempcnta \count#2%
  \divide\@tempcnta\@xxxii\multiply\@tempcnta\@xxxii
  \@bitor \@tempcnta {\@failedlist \@flfail}%
  \@testfp #2%
  #1#2%
  \@tempdimb\@tempdima
  \advance\@tempdimb \ht#2\advance\@tempdimb\@fpsep
  \@ifdim{\@tempdimb >\@colht}{%
    \@testtrue
  }{}%
  \@if@sw\if@test\fi{%
    \@cons\@flfail #2%
  }{%
    \@cons\@flsucceed #2%
    \@tempdima\@tempdimb
  }%
}%
\def\newpage@prep{%
  \if@noskipsec
    \ifx \@nodocument\relax
      \leavevmode
      \global \@noskipsecfalse
    \fi
  \fi
  \if@inlabel
    \leavevmode
    \global \@inlabelfalse
  \fi
  \if@nobreak \@nobreakfalse \everypar{}\fi
  \par
}%
\def \newpage {%
 \newpage@prep
 \do@output@MVL{%
  \vfil
  \penalty-\pagebreak@pen
 }%
}%
\def\clearpage{%
 \newpage@prep
 \do@output@MVL{%
  \vfil
  \penalty-\pagebreak@pen
  \global\@booleantrue\clearpage@sw
  \protect@penalty\do@startcolumn@pen
  \protect@penalty\do@endpage@pen
 }%
 \do@output@MVL{%
  \global\@booleanfalse\clearpage@sw
 }%
}%
\def\cleardoublepage{%
 \clearpage
 \@if@sw\if@twoside\fi{%
  \@ifodd\c@page{}{%
   \null\clearpage
  }%
 }{}%
}%
\@booleanfalse\clearpage@sw
\mathchardef\do@endpage@pen=10007
\@namedef{output@-\the\do@endpage@pen}{\csname end@column@\thepagegrid\endcsname}%
\mathchardef\do@newpage@pen=10001
\expandafter\let\csname output@-\the\do@newpage@pen\endcsname\relax
\def\@clearfloatplacement{%
 \global\@topnum     \maxdimen
 \global\@toproom    \maxdimen
 \global\@botnum     \maxdimen
 \global\@botroom    \maxdimen
 \global\@colnum     \maxdimen
 \global\@dbltopnum  \maxdimen
 \global\@dbltoproom \maxdimen
 \global\@textmin    \z@
 \global\@fpmin      \z@
 \let\@testfp\@gobble
 \appdef\@setfloattypecounts{\@fpstype16\advance\@fpstype\m@ne}%
}%
\let\@doclearpage\@undefined
\let\@makefcolumn\@undefined
\let\@makecol\@undefined
\def\clr@top@firstmark{%
 \global\let\saved@@topmark\@undefined
 \global\let\saved@@firstmark\@empty
 \global\let\saved@@botmark\@empty
}%
\clr@top@firstmark
\def\set@top@firstmark{%
 \@ifxundefined\saved@@topmark{\expandafter\gdef\expandafter\saved@@topmark\expandafter{\@@topmark}}{}%
 \@if@empty\saved@@firstmark{\expandafter\gdef\expandafter\saved@@firstmark\expandafter{\@@firstmark}}{}%
 \@if@empty\@@botmark{}{\expandafter\gdef\expandafter\saved@@botmark\expandafter{\@@botmark}}%
}%
\appdef\@outputpage@tail{%
 \clr@top@firstmark
}%
\def\@float#1{%
 \@ifnextchar[{%
  \@yfloat\width@float{#1}%
 }{%
  \@ifxundefined@cs{fps@#1}{}{\expandafter\let\expandafter\fps@\csname fps@#1\endcsname}%
  \expandafter\@argswap\expandafter{\expandafter[\fps@]}{\@yfloat\width@float{#1}}%
 }%
}%
\def\@dblfloat#1{%
 \@ifnum{\pagegrid@col=\@ne}{%
  \@float{#1}%
 }{%
  \@ifnextchar[{%
   \@yfloat\widthd@float{#1}%
  }{%
   \@ifxundefined@cs{fpsd@#1}{}{\expandafter\let\expandafter\fpsd@\csname fpsd@#1\endcsname}%
   \expandafter\@argswap\expandafter{\expandafter[\fpsd@]}{\@yfloat\widthd@float{#1}}%
  }%
 }%
}%
\def\@yfloat#1#2[#3]{%
 \@xfloat{#2}[#3]%
 \hsize#1\linewidth\hsize
 \let\set@footnotewidth\@empty
 \minipagefootnote@init
}%
\def\fps@{tbp}%
\def\fpsd@{tp}%
\def\width@float{\columnwidth}%
\def\widthd@float{\textwidth}%
\def\end@float{%
 \end@@float{%
  \check@currbox@count
 }%
}%
\def\end@dblfloat{%
 \@ifnum{\pagegrid@col=\@ne}{%
  \end@float
 }{%
  \end@@float{%
   \@iffpsbit\@ne{\global\advance\count\@currbox\m@ne}{}%
   \@iffpsbit\f@ur{\global\advance\count\@currbox-4\relax}{}%
   \global\wd\@currbox\textwidth % Klootch
   \check@currbox@count
  }%
 }%
}%
\def\end@@float#1{%
 \minipagefootnote@here
 \@endfloatbox
 #1%
 \@ifnum{\@floatpenalty <\z@}{%
  \@largefloatcheck
  \@cons\@currlist\@currbox
  \@ifnum{\@floatpenalty <-\@Mii}{%
   \do@output@cclv{\@add@float}%
  }{%
   \vadjust{\do@output@cclv{\@add@float}}%
   \@Esphack
  }%
 }{}%
}%
\newcommand\float@end@float{%
 \@endfloatbox
 \global\setbox\@currbox\float@makebox\columnwidth
 \let\@endfloatbox\relax
 \end@float
}%
\newcommand\float@end@ltx{%
 \end@@float{%
  \global\setbox\@currbox\float@makebox\columnwidth
  \check@currbox@count
 }%
}%
\newcommand\newfloat@float[3]{%
 \@namedef{ext@#1}{#3} %!
 \let\float@do=\relax
 \xdef\@tempa{\noexpand\float@exts{\the\float@exts \float@do{#3}}}%
 \@tempa
 \floatplacement{#1}{#2}%
 \@ifundefined{fname@#1}{\floatname{#1}{#1}}{} %!
 \expandafter\edef\csname ftype@#1\endcsname{\value{float@type}}%
 \addtocounter{float@type}{\value{float@type}} %!
 \restylefloat{#1}%
 \expandafter\edef\csname fnum@#1\endcsname{%
  \expandafter\noexpand\csname fname@#1\endcsname{} %!
  \expandafter\noexpand\csname the#1\endcsname
 }
 \@ifnextchar[%]
  {%
   \float@newx{#1}%
  }{%
   \@ifundefined{c@#1}{\newcounter{#1}\@namedef{the#1}{\arabic{#1}}}{}%
  }%
}%
\newcommand\newfloat@ltx[3]{%
 \@namedef{ext@#1}{#3}%
 \let\float@do=\relax
 \xdef\@tempa{\noexpand\float@exts{\the\float@exts \float@do{#3}}}%
 \@tempa
 \floatplacement{#1}{#2}%
 \@ifundefined{fname@#1}{\floatname{#1}{#1}}{}%
 \expandafter\edef\csname ftype@#1\expandafter\endcsname\expandafter{\the\c@float@type}%
 \addtocounter{float@type}{\value{float@type}}%
 \restylefloat{#1}%
 \expandafter\edef\csname fnum@#1\endcsname{%
  \expandafter\noexpand\csname fname@#1\endcsname{}%
  \expandafter\noexpand\csname the#1\endcsname
 }
 \@ifnextchar[%]
  {%
   \float@newx{#1}%
  }{%
   \@ifundefined{c@#1}{\newcounter{#1}\@namedef{the#1}{\arabic{#1}}}{}%
  }%
}%
\appdef\document@inithook{%
 \@ifxundefined\newfloat{}{%
  \@ifx{\float@end\float@end@float}{%
   \@ifx{\newfloat\newfloat@float}{\true@sw}{\false@sw}%
   }{\false@sw}%
   {%
    \class@warn{Repair the float package}%
    \let\float@end\float@end@ltx
    \let\newfloat\newfloat@ltx
   }{%
    \class@warn{Failed to patch the float package}%
   }%
 }%
}%
\def\@iffpsbit#1{%
 \begingroup
  \@tempcnta\count\@currbox
  \divide\@tempcnta#1\relax
  \@ifodd\@tempcnta{\aftergroup\true@sw}{\aftergroup\false@sw}%
 \endgroup
}%
\def\check@currbox@count{%
 \@ifnum{\count\@currbox>\z@}{%
  \count@\count\@currbox\divide\count@\sixt@@n\multiply\count@\sixt@@n
  \@tempcnta\count\@currbox\advance\@tempcnta-\count@
  \@ifnum{\@tempcnta=\z@}{%
   \ltxgrid@warn{Float cannot be placed}%
  }{}%
  \expandafter\tally@float\expandafter{\@captype}%
 }{%
 }%
}%
\providecommand\minipagefootnote@init{}%
\providecommand\minipagefootnote@here{}%
\providecommand\tally@float[1]{}%
\let\@specialoutput\@undefined
\def\@add@float{%
 \@pageht\ht\@cclv\@pagedp\dp\@cclv
 \unvbox\@cclv
 \@next\@currbox\@currlist{%
  \csname @floatselect@sw@\thepagegrid\endcsname\@currbox{%
   \@ifnum{\count\@currbox>\z@}{%
    \advance \@pageht \@pagedp
    \advance \@pageht \vsize \advance \@pageht -\pagegoal
    \@addtocurcol
   }{%
    \@addmarginpar
   }%
  }{%
   \@resethfps
   \@cons\@deferlist\@currbox
  }%
 }{\@latexbug}%
 \@ifnum{\outputpenalty<\z@}{%
  \@if@sw\if@nobreak\fi{%
   \nobreak
  }{%
   \addpenalty \interlinepenalty
  }%
 }{}%
 \set@vsize
}%
\let\@reinserts\@undefined
\def \@addtocurcol {%
   \@insertfalse
   \@setfloattypecounts
   \ifnum \@fpstype=8
   \else
     \ifnum \@fpstype=24
     \else
       \@flsettextmin
       \advance \@textmin \@textfloatsheight
       \@reqcolroom \@pageht
       \ifdim \@textmin>\@reqcolroom
         \@reqcolroom \@textmin
       \fi
       \advance \@reqcolroom \ht\@currbox
       \ifdim \@colroom>\@reqcolroom
         \@flsetnum \@colnum
         \ifnum \@colnum>\z@
           \@bitor\@currtype\@deferlist
           \if@test
           \else
             \@bitor\@currtype\@botlist
             \if@test
               \@addtobot
             \else
               \ifodd \count\@currbox
                 \advance \@reqcolroom \intextsep
                 \ifdim \@colroom>\@reqcolroom
                   \global \advance \@colnum \m@ne
                   \global \advance \@textfloatsheight \ht\@currbox
                   \global \advance \@textfloatsheight 2\intextsep
                   \@cons \@midlist \@currbox
                   \if@nobreak
                     \nobreak
                     \@nobreakfalse
                     \everypar{}%
                   \else
                     \addpenalty \interlinepenalty
                   \fi
                   \vskip \intextsep
                   \unvbox\@currbox %AO
                   \penalty\interlinepenalty
                   \vskip\intextsep
                   \ifnum\outputpenalty <-\@Mii \vskip -\parskip\fi
                   \outputpenalty \z@
                   \@inserttrue
                 \fi
               \fi
               \if@insert
               \else
                 \@addtotoporbot
               \fi
             \fi
           \fi
         \fi
       \fi
     \fi
   \fi
   \if@insert
   \else
     \@resethfps
     \@cons\@deferlist\@currbox
   \fi
}%

\def\@addmarginpar{%
 \@next\@marbox\@currlist{%
  \@cons\@freelist\@marbox\@cons\@freelist\@currbox
 }\@latexbug
 \setbox\@marbox\hb@xt@\columnwidth{%
  \csname @addmarginpar@\thepagegrid\endcsname{%
   \hskip-\marginparsep\hskip-\marginparwidth
   \box\@currbox
  }{%
   \hskip\columnwidth\hskip\marginparsep
   \box\@marbox
  }%
  \hss
 }%
 \setbox\z@\box\@currbox
    \@tempdima\@mparbottom
    \advance\@tempdima -\@pageht
    \advance\@tempdima\ht\@marbox
 \@ifdim{\@tempdima >\z@}{%
   \@latex@warning@no@line {Marginpar on page \thepage\space moved}%
 }{%
   \@tempdima\z@
 }%
    \global\@mparbottom\@pageht
    \global\advance\@mparbottom\@tempdima
    \global\advance\@mparbottom\dp\@marbox
    \global\advance\@mparbottom\marginparpush
    \advance\@tempdima -\ht\@marbox
    \global\setbox \@marbox
                   \vbox {\vskip \@tempdima
                          \box \@marbox}%
    \global \ht\@marbox \z@
    \global \dp\@marbox \z@
    \kern -\@pagedp
    \nointerlineskip
  \box\@marbox
    \nointerlineskip
    \hbox{\vrule \@height\z@ \@width\z@ \@depth\@pagedp}%
}%
\newenvironment{turnpage}{%
 \def\width@float{\textheight}%
 \def\widthd@float{\textheight}%
 \appdef\@endfloatbox{%
  \@ifxundefined\@currbox{%
   \ltxgrid@warn{Cannot rotate! Not a float}%
  }{%
   \setbox\@currbox\vbox to\textwidth{\vfil\unvbox\@currbox\vfil}%
   \global\setbox\@currbox\vbox{\rotatebox{90}{\box\@currbox}}%
  }%
 }%
}{%
}%
\def\rotatebox@dummy#1#2{%
 \ltxgrid@warn{You must load the graphics or graphicx package in order to use the turnpage environment}%
 #2%
}%
\appdef\document@inithook{%
 \@ifxundefined\rotatebox{\let\rotatebox\rotatebox@dummy}{}%
}%
\@namedef{output@-1073741824}{%
 \deadcycles\z@
 \void@cclv
}%
\mathchardef\save@column@pen=10016
\@namedef{output@-\the\save@column@pen}{\save@column}%
\let \@cclv@saved \@holdpg
\let \@holdpg \@undefined
\def\save@column{%
 \@ifvoid\@cclv@saved{%
  \set@top@firstmark
  \global\@topmark@saved\expandafter{\@@topmark}%
 }{}%
 \global\setbox\@cclv@saved\vbox{%
  \@ifvoid\@cclv@saved{}{%
   \unvbox\@cclv@saved
   \marry@baselines
  }%
  \unvbox\@cclv
  \lose@breaks
  \remove@lastbox
 }%
}%
\newtoks\@topmark@saved
\def\prep@cclv{%
 \void@cclv
 \setbox\@cclv\box\@cclv@saved
 \vbadness\@M
}%
\mathchardef\save@column@insert@pen=10017
\@namedef{output@-\the\save@column@insert@pen}{\toggle@insert{\savecolumn@holding}{\savecolumn@moving}}%
\def\savecolumn@holding{%
 \@if@exceed@pagegoal{\unvcopy\@cclv\remove@lastbox}{%
  \setbox\z@\vbox{\unvcopy\@cclv\remove@lastbox}%
  \outputdebug@sw{\trace@box\z@}{}%
  \dimen@\ht\@cclv\advance\dimen@-\ht\z@
  \dead@cycle@repair@protected\dimen@
 }{%
  \dead@cycle
 }%
}%
\def\savecolumn@moving{%
 \ltxgrid@info@sw{\class@info{\string\savecolumn@moving}}{}%
 \@cclv@nontrivial@sw{%
  \save@column
 }{%
  \void@cclv
 }%
 \@ifvoid\footins{}{%
  \ltxgrid@foot@info@sw{\class@info{\string\savecolumn@moving}\trace@scroll{\showbox\footins@saved\showbox\footins}}{}%
  \@ifvoid\footins@saved{%
   \global\setbox\footins@saved\box\footins
  }{%
   \global\setbox\footins@saved\vbox\bgroup
    \unvbox\footins@saved
    \marry@baselines
    \unvbox\footins
   \egroup
  }%
  \ltxgrid@foot@info@sw{\trace@box\footins@saved}{}%
  \protect@penalty\save@column@insert@pen
 }%
}%
\newbox\footins@saved
\newbox\footins@recovered
\newbox\column@recovered
\mathchardef\save@message@pen=10018
\@namedef{output@-\the\save@message@pen}{\save@message}%
\def\save@message{%
 \void@cclv
 \toks@\expandafter{\@@firstmark}%
 \expandafter\gdef\expandafter\@message@saved\expandafter{\the\toks@}%
 \expandafter\do@@mark\expandafter{\the\@topmark@saved}%
}%
\gdef\@message@saved{}%
\mathchardef\execute@message@pen=10019
\@namedef{output@-\the\execute@message@pen}{\@message@saved}%
\def\execute@message{%
 \@execute@message\save@column@pen
}%
\def\execute@message@insert#1{%
 \@execute@message\save@column@insert@pen{%
  \setbox \footins \box \footins@saved
  \ltxgrid@foot@info@sw{\class@info{\string\execute@message@insert}\trace@box\footins}{}%
  #1%
 }%
}%
\long\def\@execute@message#1#2{%
 \begingroup
  \dimen@\prevdepth\@ifdim{\dimen@<\z@}{\dimen@\z@}{}%
  \setbox\z@\vbox{%
   \protect@penalty#1%
   \protection@box
   \toks@{\prep@cclv#2}%
   \@@mark{\the\toks@}%
   \penalty-\save@message@pen
   \setbox\z@\null\dp\z@\dimen@\ht\z@-\dimen@
   \nointerlineskip\box\z@
   \penalty-\execute@message@pen
  }\unvbox\z@
 \endgroup
}%
\def\do@output@cclv{\execute@message}%
\def\do@output@MVL#1{%
 \@ifvmode{%
  \begingroup\execute@message{\unvbox\@cclv#1}\endgroup
 }{%
  \@ifhmode{%
   \vadjust{\execute@message{\unvbox\@cclv#1}}%
  }{%
   \@latexerr{\string\do@output@MVL\space cannot be executed in this mode!}\@eha
  }%
 }%
}%
\def\lose@breaks{%
 \loopwhile{%
  \count@\lastpenalty
  \@ifnum{\count@=\@M}{%
   \unpenalty\true@sw
  }{%
   \false@sw
  }%
 }%
}%
\def\removestuff{\do@output@MVL{\unskip\unpenalty}}%
\def\removephantombox{%
 \vadjust{%
  \execute@message{%
   \unvbox\@cclv
   \remove@lastbox
   \unskip
   \unskip
   \unpenalty
   \penalty\predisplaypenalty
   \vskip\abovedisplayskip
  }%
 }%
}%
\def\addstuff#1#2{\edef\@tempa{\noexpand\do@output@MVL{\noexpand\@addstuff{#1}{#2}}}\@tempa}%
\def\@addstuff#1#2{%
 \skip@\lastskip\unskip
 \count@\lastpenalty\unpenalty
 \@if@empty{#1}{}{\penalty#1\relax}%
 \@ifnum{\count@=\z@}{}{\penalty\count@}%
 \vskip\skip@
 \@if@empty{#2}{}{\vskip#2\relax}%
}%
\def\replacestuff#1#2{\edef\@tempa{\noexpand\do@output@MVL{\noexpand\@replacestuff{#1}{#2}}}\@tempa}%
\def\@replacestuff#1#2{%
 \skip@\lastskip\unskip
 \count@\lastpenalty\unpenalty
 \@if@empty{#1}{}{%
 \@ifnum{\count@>\@M}{}{%
   \@ifnum{\count@=\z@}{\count@=#1\relax}{%
    \@ifnum{\count@<#1\relax}{}{%
     \count@=#1\relax
    }%
   }%
 }%
 }%
 \@ifnum{\count@=\z@}{}{\penalty\count@}%
 \@if@empty{#2}{}{%
  \@tempskipa#2\relax
  \@ifdim{\z@>\@tempskipa}{%
   \advance\skip@-\@tempskipa
  }{%
   \@ifdim{\skip@>\@tempskipa}{}{%
    \skip@\@tempskipa
   }%
  }%
 }%
 \vskip\skip@
}%
\def\move@insertions{\global\holdinginserts\z@}%
\def\hold@insertions{\global\holdinginserts\@ne}%
\hold@insertions
\def\toggle@insert#1#2{%
 \@ifnum{\holdinginserts>\z@}{\move@insertions#1}{\hold@insertions#2}%
}%
\def\do@columngrid#1#2{%
 \par
 \expandafter\let\expandafter\@tempa\csname open@column@#1\endcsname
 \@ifx{\relax\@tempa}{%
  \ltxgrid@warn{Unknown page grid #1. No action taken}%
 }{%
  \do@output@MVL{\start@column{#1}{#2}}%
 }%
}%
\def\start@column#1#2{%
 \def\@tempa{#1}\@ifx{\@tempa\thepagegrid}{%
  \ltxgrid@info{Already in page grid \thepagegrid. No action taken}%
 }{%
  \expandafter\execute@message@insert
  \expandafter{%
               \csname shut@column@\thepagegrid\expandafter\endcsname
               \csname open@column@#1\endcsname{#2}%
               \set@vsize
             }%
 }%
}%
\def\thepagegrid{one}%
\newbox\pagesofar
\newbox\footsofar
\def\combine@foot@inserts#1#2{%
  \ltxgrid@info@sw{\class@info{\string\combine@foot@inserts\string#1\string#2}}{}%
  \@ifvoid#1{%
    \ltxgrid@foot@info@sw{\trace@box#2}{}\global\setbox#1\box#2%
  }{%
   \global\setbox#1\vbox\bgroup
    \ltxgrid@foot@info@sw{\trace@box#1}{}\unvbox#1%
    \@ifvoid#2{}{%
     \marry@baselines
     \ltxgrid@foot@info@sw{\trace@box#2}{}\unvbox#2%
    }%
   \egroup
  }%
  \ltxgrid@foot@info@sw{\trace@scroll{\showbox#1\showbox#2}}{}%
}%
\newcommand\onecolumngrid{\do@columngrid{one}{\@ne}}%
\let\onecolumn\@undefined
\def\open@column@one#1{%
 \ltxgrid@info@sw{\class@info{\string\open@column@one\string#1}}{}%
 \unvbox\pagesofar
 \@ifvoid{\footsofar}{}{%
  \insert\footins\bgroup\unvbox\footsofar\egroup
  \penalty\z@
 }%
 \gdef\thepagegrid{one}%
 \global\pagegrid@col#1%
 \global\pagegrid@cur\@ne
 \global\count\footins\@m
 \global\divide\count\footins\tw@
 \set@column@hsize\pagegrid@col
 \set@colht
}%
\def\shut@column@one{%
 \ltxgrid@info@sw{\class@info{\string\shut@column@one}}{}%
 \@makecolumn\false@sw
 \global\setbox\pagesofar\vbox\bgroup
  \recover@column\@outputbox\footsofar\column@recovered\footins@recovered
 \egroup
 \begingroup\setbox\z@\box\@outputbox\endgroup
 \combine@foot@inserts\footsofar\footins
 \set@colht
}%
\def\float@column@one{%
 \@makecolumn\true@sw
 \@outputpage
}%
\def\end@column@one{%
 \unvbox\@cclv\remove@lastbox
 \protect@penalty\do@newpage@pen
}%
\def\output@column@one{%
 \@outputpage
}%
\def\@addmarginpar@one{%
 \@if@sw\if@mparswitch\fi{%
  \@ifodd\c@page{\false@sw}{\true@sw}%
 }{\false@sw}{%
  \@if@sw\if@reversemargin\fi{\false@sw}{\true@sw}%
 }{%
  \@if@sw\if@reversemargin\fi{\true@sw}{\false@sw}%
 }%
}%
\def\@floatselect@sw@one#1{\true@sw}%
\def\onecolumngrid@push{%
 \do@output@MVL{%
  \@ifnum{\pagegrid@col=\@ne}{%
   \global\let\restorecolumngrid\@empty
  }{%
   \xdef\restorecolumngrid{%
    \noexpand\start@column{\thepagegrid}{\the\pagegrid@col}%
   }%
   \start@column{one}{\@ne}%
  }%
 }%
}%
\def\onecolumngrid@pop{%
 \do@output@MVL{\restorecolumngrid}%
}%
\newcommand\twocolumngrid{\do@columngrid{mlt}{\tw@}}%
\let\twocolumn\@undefined
\let\@topnewpage\@undefined
\def\open@column@mlt#1{%
 \ltxgrid@info@sw{\class@info{\string\open@column@mlt\string#1}}{}%
 \@ifvoid{\footsofar}{}{%
  \insert\footins\bgroup\unvbox\footsofar\egroup
 }%
 \gdef\thepagegrid{mlt}%
 \global\pagegrid@col#1%
 \global\pagegrid@cur\@ne
 \global\count\footins\@m
 \set@column@hsize\pagegrid@col
 \set@colht
}%
\def\shut@column@mlt{%
 \ltxgrid@info@sw{\class@info{\string\shut@column@mlt}}{}%
 \@cclv@nontrivial@sw{%
  \@makecolumn\false@sw
  \@ifnum{\pagegrid@cur<\pagegrid@col}{%
   \expandafter\global\expandafter\setbox\csname col@\the\pagegrid@cur\endcsname\box\@outputbox
   \global\advance\pagegrid@cur\@ne
  }{}%
 }{%
  \void@cclv
 }%
 \@ifnum{\pagegrid@cur>\@ne}{%
  \csname balance@\the\pagegrid@col\endcsname
  \grid@column\@outputbox{}%
  \@combinepage\false@sw
  \@combinedblfloats
  \global\setbox\pagesofar\box\@outputbox
  \show@pagesofar@size
 }{}%
 \set@colht
}%
\def\float@column@mlt{%
  \@output@combined@page
}%
\def\end@column@mlt{%
 \@ifx@empty\@toplist{%
  \@ifx@empty\@botlist{%
   \@ifx@empty\@dbltoplist{%
    \@ifx@empty\@deferlist{%
     \@ifnum{\pagegrid@cur=\@ne}{%
      \false@sw
     }{%
      \true@sw
     }%
    }{%
     \true@sw
    }%
   }{%
    \true@sw
   }%
  }{%
   \true@sw
  }%
 }{%
  \true@sw
 }%
 % true = kick out a column and try again
 {%
  \@cclv@nontrivial@sw{%
   \unvbox\@cclv\remove@lastbox
  }{%
   \unvbox\@cclv\remove@lastbox\unskip\null
  }%
  \protect@penalty\do@newpage@pen
  \protect@penalty\do@endpage@pen
 }{%
  \unvbox\@cclv\remove@lastbox
 }%
}%
\def\output@column@mlt{%
 \@ifnum{\pagegrid@cur<\pagegrid@col}{%
  \expandafter\global\expandafter\setbox\csname col@\the\pagegrid@cur\endcsname\box\@outputbox
  \global\advance\pagegrid@cur\@ne
 }{%
  \set@adj@colht\dimen@
  \grid@column\@outputbox{}%
  \@output@combined@page
 }%
}%
\let\@outputdblcol\@undefined
\def\@floatselect@sw@mlt#1{\@if@notdblfloat{#1}}%
\def\@addmarginpar@mlt{% emits a boolean
 \@ifnum{\pagegrid@cur=\@ne}%
}%
\def\set@footnotewidth@one{%
 \hsize\columnwidth
 \linewidth\hsize
}%
\def\set@footnotewidth@two{\set@footnotewidth@mlt\tw@}%
\def\set@footnotewidth@mlt#1{%
 \hsize\textwidth
 \advance\hsize\columnsep
 \divide\hsize#1%
 \advance\hsize-\columnsep
 \linewidth\hsize
}%
\def\compose@footnotes@one#1{%
 \ltxgrid@foot@info@sw{\class@info{\string\compose@footnotes@one\string#1}\trace@box#1}{}%
}%
\let\compose@footnotes\compose@footnotes@one
\def\compose@footnotes@two#1{%
 \ltxgrid@foot@info@sw{\class@info{\string\compose@footnotes@two\string#1}\trace@box#1}{}%
 \setbox\z@\box\@tempboxa
 \let\recover@column\recover@column@null
 \let\marry@baselines\@empty
 \balance@two#1\@tempboxa
 \global\setbox#1\hbox to\textwidth{\box#1\hfil\box\@tempboxa}%
 \ltxgrid@foot@info@sw{\trace@box#1}{}%
}%
\let\pagegrid@cur\col@number
\let\col@number\@undefined
\newcount\pagegrid@col
\pagegrid@cur\@ne
\expandafter\let\csname col@\the\pagegrid@cur\endcsname\@leftcolumn
\let\@leftcolumn\@undefined
\pagegrid@col\tw@
\def\pagegrid@init{%
 \advance\pagegrid@cur\@ne
 \@ifnum{\pagegrid@cur<\pagegrid@col}{%
  \csname newbox\expandafter\endcsname\csname  col@\the\pagegrid@cur\endcsname
  \pagegrid@init
 }{%
 }%
}%
\appdef\class@documenthook{%
 \pagegrid@init
}%
\def\grid@column#1#2{%
 \ltxgrid@info@sw{\class@info{\string\grid@column\string#1}}{}%
 \global\setbox#1\vbox\bgroup
  \hb@xt@\textwidth\bgroup
   \vrule\@height\z@\@width\z@\@if@empty{#2}{}{\@depth#2}%
   \pagegrid@cur\@ne
   \@ifnum{\pagegrid@cur<\pagegrid@col}{\loopwhile{\append@column@\pagegrid@cur\pagegrid@col}}{}%
   \box@column#1%
  \egroup
  \vskip\z@skip
 \egroup
}%
\def\append@column@#1#2{%
 \expandafter\box@column\csname col@\the#1\endcsname
 \hfil\vrule\@width\columnseprule\hfil
 \advance#1\@ne
 \@ifnum{#1<#2}%
}%
\def\box@column#1{%
 \ltxgrid@info@sw{\class@info{\string\box@column\string#1}}{}%
 \raise\topskip
 \hb@xt@\columnwidth\bgroup
  \dimen@\ht#1\@ifdim{\dimen@>\@colht}{\dimen@\@colht}{}%
  \count@\vbadness\vbadness\@M
  \dimen@ii\vfuzz\vfuzz\maxdimen
  \ltxgrid@info@sw{\saythe\@colht\saythe\dimen@}{}%
  \vtop to\dimen@\bgroup
   \hrule\@height\z@
   \unvbox#1%
   \raggedcolumn@skip
  \egroup
  \vfuzz\dimen@ii
  \vbadness\count@
  \hss
 \egroup
}%
\def\marry@baselines{%
 \begingroup
  \setbox\z@\lastbox
  \@ifvoid{\z@}{%
   \endgroup
  }{%
   \aftergroup\kern
   \aftergroup-%
   \expandafter\box\expandafter\z@\expandafter\endgroup\the\dp\z@\relax
  }%
 \vskip\marry@skip\relax
}%
\gdef\marry@skip{\z@skip}%
\def\set@marry@skip{%
 \begingroup
  \skip@\baselineskip\advance\skip@-\topskip
  \@ifdim{\skip@>\z@}{%
   \xdef\marry@skip{\the\skip@}%
  }{}%
 \endgroup
}%
\appdef\document@inithook{%
 \@ifxundefined\raggedcolumn@sw{\@booleanfalse\raggedcolumn@sw}{}%
}%
\def\raggedcolumn@skip{%
 \vskip\z@\raggedcolumn@sw{\@plus.0001fil\@minus.0001fil}{}\relax
}%
\def\@combinepage#1{%
 \ltxgrid@foot@info@sw{\class@info{\string\@combinepage\string#1}}{}%
 \@ifvoid\pagesofar{}{%
  \setbox\@outputbox\vbox{%
   \unvbox\pagesofar
   \marry@baselines
   \unvbox\@outputbox
  }%
 }%
 #1{%
  \@ifvoid\footsofar{}{%
   \show@box@size{Combining page footnotes}\footsofar
   \setbox\footins\box\footsofar
   \compose@footnotes
   \@combineinserts\@outputbox\footins
  }%
 }{%
 }%
}%
\def \@cflt{%
 \let \@elt \@comflelt
 \setbox\@tempboxa \vbox{}%
 \@toplist
 \setbox\@outputbox \vbox{%
  \boxmaxdepth \maxdepth
  \unvbox\@tempboxa\unskip
  \topfigrule\vskip \textfloatsep
  \unvbox\@outputbox
 }%
 \let\@elt\relax
 \xdef\@freelist{\@freelist\@toplist}%
 \global\let\@toplist\@empty
}%
\def \@cflb {%
 \let\@elt\@comflelt
 \setbox\@tempboxa \vbox{}%
 \@botlist
 \setbox\@outputbox \vbox{%
  \unvbox\@outputbox
  \vskip \textfloatsep\botfigrule
  \unvbox\@tempboxa\unskip
 }%
 \let\@elt\relax
 \xdef\@freelist{\@freelist\@botlist}%
 \global \let \@botlist\@empty
}%
\def\@combinedblfloats{%
 \@ifx@empty\@dbltoplist{}{%
  \setbox\@tempboxa\vbox{}%
  \let\@elt\@comdblflelt\@dbltoplist
  \let\@elt\relax\xdef\@freelist{\@freelist\@dbltoplist}%
  \global\let\@dbltoplist\@empty
  \setbox\@outputbox\vbox{%
   \unvbox\@tempboxa\unskip
   \@ifnum{\@dbltopnum>\m@ne}{\dblfigrule}{}%FIXME: how is \@dbltopnum maintained?
   \vskip\dbltextfloatsep
   \unvbox\@outputbox
  }%
 }%
}%
\def\set@column@hsize#1{%
 \pagegrid@col#1%
 \global\columnwidth\textwidth
 \global\advance\columnwidth\columnsep
 \global\divide\columnwidth\pagegrid@col
 \global\advance\columnwidth-\columnsep
 \global\hsize\columnwidth
 \global\linewidth\columnwidth
 \skip@\baselineskip\advance\skip@-\topskip
 \@ifnum{\pagegrid@col>\@ne}{\set@marry@skip}{}%
}%
\def\set@colht{%
 \set@adj@textheight\@colht
 \global\let\enlarge@colroom\@empty
 \set@colroom
}%
\def\set@adj@textheight#1{%
 \ltxgrid@info@sw{\class@info{\string\set@adj@textheight\string#1}\saythe\textheight}{}%
 #1\textheight
 \def\@elt{\adj@page#1}%
 \@booleantrue\firsttime@sw\@dbltoplist
 \let\@elt\relax
 \global#1#1\relax
 \ltxgrid@info@sw{\saythe#1}{}%
}%
\def\set@colroom{%
 \ltxgrid@info@sw{\class@info{\string\set@colroom}}{}%
 \set@adj@colht\@colroom
 \@if@empty\enlarge@colroom{}{%
  \global\advance\@colroom\enlarge@colroom\relax
  \ltxgrid@info@sw{\saythe\@colroom}{}%
 }%
 \@ifdim{\@colroom>\topskip}{}{%
  \ltxgrid@info{Not enough room: \string\@colroom=\the\@colroom; increasing to \the\topskip}%
  \@colroom\topskip
 }%
 \global\@colroom\@colroom
 \set@vsize
}%
\def\set@vsize{%
 \global\vsize\@colroom
 \ltxgrid@info@sw{\class@info{\string\set@vsize\string\vsize=\string\colroom}\saythe\vsize}{}%
}%
\def\set@adj@colht#1{%
 #1\@colht
 \ltxgrid@info@sw{\class@info{\string\set@adj@colht\string#1-\string\pagesofar}\saythe#1}{}%
 \@ifvoid\pagesofar{}{%
  \advance#1-\ht\pagesofar\advance#1-\dp\pagesofar
  \ltxgrid@info@sw{\class@info{\string\pagesofar}\saythe#1}{}%
 }%
 \def\@elt{\adj@column#1}%
 \@booleantrue\firsttime@sw\@toplist
 \@booleantrue\firsttime@sw\@botlist
 \let\@elt\relax
}%
\def\adj@column#1#2{%
 \advance#1-\ht#2%
 \advance#1-\firsttime@sw{\textfloatsep\@booleanfalse\firsttime@sw}{\floatsep}%
 \ltxgrid@info@sw{\class@info{\string\adj@column\string#1-\string#2}\saythe#1}{}%
}%
\def\adj@page#1#2{%
 \advance#1-\ht#2%
 \advance#1-\firsttime@sw{\dbltextfloatsep\@booleanfalse\firsttime@sw}{\dblfloatsep}%
 \ltxgrid@info@sw{\class@info{\string\adj@page\string#1-\string#2}\saythe#1}{}%
}%
\def\set@adj@box#1#2{%
 \@ifvoid#2{}{%
  \advance#1-\ht#2\advance#1-\dp#2%
  \@booleantrue\temp@sw
  \ltxgrid@foot@info@sw{\class@info{\string\set@adj@box\string#2}\saythe#1}{}%
 }%
}%
\appdef\@outputpage@tail{%
 \set@colht          % FIXME: needed?
 \@floatplacement    % FIXME: needed?
 \@dblfloatplacement % FIXME: needed?
}%
\begingroup
 \catcode`\1=\cat@letter
 \catcode`\2=\cat@letter
 \toks@{%
  \setbox\footins\box\footsofar
  \balance@two\col@1\@outputbox
  \global\setbox\col@1\box\col@1
  \global\setbox\@outputbox\box\@outputbox
  \combine@foot@inserts\footsofar\footins
 }%
 \aftergroup\def\aftergroup\balance@2\expandafter
\endgroup\expandafter{\the\toks@}%
\def\balance@two#1#2{%
 \ltxgrid@info@sw{\class@info{\string\balance@two\string#1\string#2}}{}%
 \outputdebug@sw{\trace@scroll{\showbox#1\showbox#2}}{}%
 \setbox\thr@@\copy\footsofar
 \setbox\@ne\vbox\bgroup
  \@ifvoid{#1}{}{%
   \recover@column#1\footsofar\column@recovered\footins@recovered
   \@ifvoid{#2}{}{\marry@baselines}%
  }%
  \@ifvoid{#2}{}{%
   \recover@column#2\footsofar\column@recovered\footins@recovered
  }%
 \egroup
 \outputdebug@sw{\trace@scroll{\showbox\@ne}}{}%
 \ltxgrid@foot@info@sw{\trace@scroll{\showbox\footsofar}}{}%
 \dimen@\ht\@ne\divide\dimen@\tw@
 \dimen@i\dimen@
 \vbadness\@M
 \vfuzz\maxdimen
 \splittopskip\topskip
 \loopwhile{%
  \setbox\z@\copy\@ne\setbox\tw@\vsplit\z@ to\dimen@
  \remove@depth\z@\remove@depth\tw@
  \dimen@ii\ht\tw@\advance\dimen@ii-\ht\z@
  \dimen@i=.5\dimen@i
  \ltxgrid@info@sw{\saythe\dimen@\saythe\dimen@i\saythe\dimen@ii}{}%
  \@ifdim{\dimen@ii<.5\p@}{%
   \@ifdim{\dimen@ii>-.5\p@}%
  }{%
   \false@sw
  }%
  {%
   \true@sw
  }{%
   \@ifdim{\dimen@i<.5\p@}%
  }%
  {%
   \false@sw
  }%
  {%
   \advance\dimen@\@ifdim{\dimen@ii<\z@}{}{-}\dimen@i
   \true@sw
  }%
 }%
 \ltxgrid@info@sw{\saythe\dimen@\saythe\dimen@i\saythe\dimen@ii}{}%
 \@ifdim{\ht\z@=\z@}{%
  \@ifdim{\ht\tw@=\z@}%
 }{%
  \true@sw
 }%
 {%
 }{%
  \ltxgrid@info{Unsatifactorily balanced columns: giving up}%
  \setbox\tw@\box#1%
  \setbox\z@ \box#2%
  \global\setbox\footsofar\box\thr@@
 }%
 \setbox\tw@\vbox{\unvbox\tw@\vskip\z@skip}%
 \setbox\z@ \vbox{\unvbox\z@ \vskip\z@skip}%
 \set@colht
 \dimen@\ht\z@\@ifdim{\dimen@<\ht\tw@}{\dimen@\ht\tw@}{}%
 \@ifdim{\dimen@>\@colroom}{\dimen@\@colroom}{}%
 \ltxgrid@info@sw{\saythe{\ht\z@}\saythe{\ht\tw@}\saythe\@colroom\saythe\dimen@}{}%
 \setbox#1\vbox to\dimen@{\unvbox\tw@\unskip\raggedcolumn@skip}%
 \setbox#2\vbox to\dimen@{%
   \unvbox\z@ \unskip\raggedcolumn@skip}%
 \outputdebug@sw{\trace@scroll{\showbox#1\showbox#2}}{}%
}%
\def\remove@depth#1{%
  \setbox#1\vbox\bgroup
   \unvcopy#1%
   \setbox\z@\vbox\bgroup
    \unvbox#1%
    \setbox\z@\lastbox
    \aftergroup\kern\aftergroup-\expandafter
   \egroup
   \the\dp\z@\relax
  \egroup
}%
\def\recover@column#1#2#3#4{%
 \ltxgrid@info@sw{\class@info{\string\recover@column\string#1\string#2\string#3\string#4}}{}%
 \setbox#4\vbox{\unvcopy#1}%
 \ltxgrid@foot@info@sw{\trace@scroll{\showbox#4}}{}%
 \dimen@\ht#4%
 \ltxgrid@foot@info@sw{\saythe\dimen@}{}%
 \setbox#4\vbox\bgroup
  \unvbox#4\unskip
  \dimen@i\lastkern\unkern\advance\dimen@i\lastkern
  \@ifdim{\dimen@i=\z@}{%
   \dimen@i\lastkern\unkern
   \ltxgrid@foot@info@sw{\saythe\dimen@i}{}%
   \aftergroup\dimen@i
   \expandafter\egroup\the\dimen@i\relax
  }{%
   \egroup
  }%
 \@ifdim{\dimen@i<\z@}{%
  \advance\dimen@\dimen@i
  \ltxgrid@foot@info@sw{\saythe\dimen@i\saythe\dimen@}{}%
  \splittopskip\z@skip
  \global\setbox#3\vsplit#4 to\dimen@
  \global\setbox#4\vbox{\unvbox#4}%
  \ltxgrid@foot@info@sw{\trace@scroll{\showbox#1\showbox#2\showbox#3\showbox#4}}{}%
  \global\setbox#2\vbox\bgroup\unvbox#2\vskip\z@skip\unvbox#4\egroup
 }{%
  \setbox#3\box#4%
  \ltxgrid@foot@info@sw{\trace@scroll{\showbox#1\showbox#2\showbox#3\showbox#4}}{}%
 }%
 \unvbox#3%
 \loopwhile{\dimen@\lastskip\@ifdim{\dimen@>\z@}{\unskip\true@sw}{\false@sw}}%
}%
\def\recover@column@null#1#2#3#4{%
 \unvcopy#1%
}%
\rvtx@ifformat@geq{2020/10/01}%
  {%
    \AddToHook{begindocument}{%
      \open@column@one\@ne
      \set@colht
      \@floatplacement
      \@dblfloatplacement
    }%
  }{%
    \prepdef\@begindocumenthook{%
     \open@column@one\@ne
     \set@colht
     \@floatplacement
     \@dblfloatplacement
    }%
  }
\def\longtable@longtable{%
 \par
 \ifx\multicols\@undefined\else\ifnum\col@number>\@ne\@twocolumntrue\fi\fi
 \if@twocolumn\LT@err{longtable not in 1-column mode}\@ehc\fi
 \begingroup
 \@ifnextchar[\LT@array{\LT@array[x]}%
}%
\def\longtable@new{%
 \par\if@twocolumn\onecolumngrid\fi
  \@ifnextchar[\LT@array{\LT@array[x]}%
}%
\def\endlongtable@longtable{%
  \crcr
  \noalign{%
    \let\LT@entry\LT@entry@chop
    \xdef\LT@save@row{\LT@save@row}}%
  \LT@echunk
  \LT@start
  \unvbox\z@
  \LT@get@widths
  \if@filesw
    {\let\LT@entry\LT@entry@write\immediate\write\@auxout{%
      \gdef\expandafter\noexpand
        \csname LT@\romannumeral\c@LT@tables\endcsname
          {\LT@save@row}}}%
  \fi
  \ifx\LT@save@row\LT@@save@row
  \else
    \LT@warn{Column \@width s have changed\MessageBreak
             in table \thetable}%
    \LT@final@warn
  \fi
  \endgraf\penalty -\LT@end@pen
  \endgroup
  \global\@mparbottom\z@
  \pagegoal\vsize
  \endgraf\penalty\z@\addvspace\LTpost
  \ifvoid\footins\else\insert\footins{}\fi
}%
\def\endlongtable@new{%
  \crcr
  \noalign{%
   \let\LT@entry\LT@entry@chop
   \xdef\LT@save@row{\LT@save@row}%
  }%
  \LT@echunk
  \LT@start
  \unvbox\z@
  \LT@get@widths
  \@if@sw\if@filesw\fi{%
   {%
    \let\LT@entry\LT@entry@write
    \immediate\write\@auxout{%
     \gdef\expandafter\noexpand\csname LT@\romannumeral\c@LT@tables\endcsname
     {\LT@save@row}%
    }%
   }%
  }{}%
  \@ifx{\LT@save@row\LT@@save@row}{}{%
   \LT@warn{%
    Column \@width s have changed\MessageBreak in table \thetable
   }\LT@final@warn
  }%
  \endgraf
  \nobreak
  \box\@ifvoid\LT@lastfoot{\LT@foot}{\LT@lastfoot}%
 \global\@mparbottom\z@
 \endgraf
 \LT@post
 \ifdeluxe\else\ifdeluxestar\else\if@twocolumn\twocolumngrid\fi\fi\fi
}%
\def\LT@start@longtable{%
  \let\LT@start\endgraf
  \endgraf\penalty\z@\vskip\LTpre
  \dimen@\pagetotal
  \advance\dimen@ \ht\ifvoid\LT@firsthead\LT@head\else\LT@firsthead\fi
  \advance\dimen@ \dp\ifvoid\LT@firsthead\LT@head\else\LT@firsthead\fi
  \advance\dimen@ \ht\LT@foot
  \dimen@ii\vfuzz
  \vfuzz\maxdimen
    \setbox\tw@\copy\z@
    \setbox\tw@\vsplit\tw@ to \ht\@arstrutbox
    \setbox\tw@\vbox{\unvbox\tw@}%
  \vfuzz\dimen@ii
  \advance\dimen@ \ht
        \ifdim\ht\@arstrutbox>\ht\tw@\@arstrutbox\else\tw@\fi
  \advance\dimen@\dp
        \ifdim\dp\@arstrutbox>\dp\tw@\@arstrutbox\else\tw@\fi
  \advance\dimen@ -\pagegoal
  \ifdim \dimen@>\z@\vfil\break\fi
      \global\@colroom\@colht
  \ifvoid\LT@foot\else
    \advance\vsize-\ht\LT@foot
    \global\advance\@colroom-\ht\LT@foot
    \dimen@\pagegoal\advance\dimen@-\ht\LT@foot\pagegoal\dimen@
    \maxdepth\z@
  \fi
  \ifvoid\LT@firsthead\copy\LT@head\else\box\LT@firsthead\fi
\nobreak
  \output{\LT@output}%
}%
\def\LT@start@new{%
 \let\LT@start\endgraf
 \endgraf
 \markthr@@{}%
 \LT@pre
 \@ifvoid\LT@firsthead{\LT@top}{\hbox{\ifdim\movetableright>0pt\relax\hskip\movetableright\fi\box\LT@firsthead}
\nobreak}%
 \mark@envir{longtable}%
}%

\def\LT@end@hd@ft@longtable#1{%
 \LT@echunk
 \ifx\LT@start\endgraf
  \LT@err{Longtable head or foot not at start of table}{Increase LTchunksize}%
 \fi
 \setbox#1\box\z@
 \LT@get@widths\LT@bchunk
}%
\def\LT@end@hd@ft@new#1{%
 \LT@echunk
 \@ifx{\LT@start\endgraf}{%
  \LT@err{Longtable head or foot not at start of table}{Increase LTchunksize}%
 }%
 \global\setbox#1\box\z@
 \LT@get@widths
 \LT@bchunk
}%
\def\LT@array@longtable[#1]#2{%
  \refstepcounter{table}\stepcounter{LT@tables}%
  \if l#1%
    \LTleft\z@ \LTright\fill
  \else\if r#1%
    \LTleft\fill \LTright\z@
  \else\if c#1%
    \LTleft\fill \LTright\fill
  \fi\fi\fi
  \let\LT@mcol\multicolumn
  \let\LT@@tabarray\@tabarray
  \let\LT@@hl\hline
  \def\@tabarray{%
    \let\hline\LT@@hl
    \LT@@tabarray}%
  \let\\\LT@tabularcr\let\tabularnewline\\%
  \def\newpage{\noalign{\break}}%
  \def\pagebreak{\noalign{\ifnum`}=0\fi\@testopt{\LT@no@pgbk-}4}%
  \def\nopagebreak{\noalign{\ifnum`}=0\fi\@testopt\LT@no@pgbk4}%
  \let\hline\LT@hline \let\kill\LT@kill\let\caption\LT@caption
  \@tempdima\ht\strutbox
  \let\@endpbox\LT@endpbox
  \ifx\extrarowheight\@undefined
    \let\@acol\@tabacol
    \let\@classz\@tabclassz \let\@classiv\@tabclassiv
    \def\@startpbox{\vtop\LT@startpbox}%
    \let\@@startpbox\@startpbox
    \let\@@endpbox\@endpbox
    \let\LT@LL@FM@cr\@tabularcr
  \else
    \advance\@tempdima\extrarowheight
    \col@sep\tabcolsep
    \let\@startpbox\LT@startpbox\let\LT@LL@FM@cr\@arraycr
  \fi
  \setbox\@arstrutbox\hbox{\vrule
    \@height \arraystretch \@tempdima
    \@depth \arraystretch \dp \strutbox
    \@width \z@}%
  \let\@sharp##\let\protect\relax
   \begingroup
    \@mkpream{#2}%
    \xdef\LT@bchunk{%
       \global\advance\c@LT@chunks\@ne
       \global\LT@rows\z@\setbox\z@\vbox\bgroup
       \LT@setprevdepth
       \tabskip\LTleft \noexpand\halign to\hsize\bgroup
      \tabskip\z@ \@arstrut \@preamble \tabskip\LTright \cr}%
  \endgroup
  \expandafter\LT@nofcols\LT@bchunk&\LT@nofcols
  \LT@make@row
  \m@th\let\par\@empty
  \everycr{}\lineskip\z@\baselineskip\z@
  \LT@bchunk}%
\def\LT@LR@l{\LTleft\z@   \LTright\fill}%
\def\LT@LR@r{\LTleft\fill \LTright\z@  }%
\def\LT@LR@c{\LTleft\fill \LTright\fill}%
\def\LT@array@new[#1]#2{%
 \refstepcounter{table}\stepcounter{LT@tables}%
 \table@hook
 \LTleft\fill \LTright\fill
 \csname LT@LR@#1\endcsname
 \let\LT@mcol\multicolumn
 \let\LT@@hl\hline
 \prepdef\@tabarray{\let\hline\LT@@hl}%
 \let\\\LT@tabularcr
 \let\tabularnewline\\%
 \def\newpage{\noalign{\break}}%
 \def\pagebreak{\noalign{\ifnum`}=0\fi\@testopt{\LT@no@pgbk-}4}%
 \def\nopagebreak{\noalign{\ifnum`}=0\fi\@testopt\LT@no@pgbk4}%
 \let\hline\LT@hline
 \let\kill\LT@kill
 \let\caption\LT@caption
 \@tempdima\ht\strutbox
 \let\@endpbox\LT@endpbox
 \@ifxundefined\extrarowheight{%
  \let\@acol\@tabacol
  \let\@classz\@tabclassz
  \let\@classiv\@tabclassiv
  \def\@startpbox{\vtop\LT@startpbox}%
  \let\@@startpbox\@startpbox
  \let\@@endpbox\@endpbox
  \let\LT@LL@FM@cr\@tabularcr@LaTeX
  \let\@xtabularcr\@xtabularcr@LaTeX
 }{%
  \advance\@tempdima\extrarowheight
  \col@sep\tabcolsep
  \let\@startpbox\LT@startpbox
  \let\LT@LL@FM@cr\@arraycr@array
 }%
 \let\@acoll\@tabacoll
 \let\@acolr\@tabacolr
 \let\@acol\@tabacol
 \setbox\@arstrutbox\hbox{%
  \vrule
  \@height \arraystretch \@tempdima
  \@depth \arraystretch \dp \strutbox
  \@width \z@
 }%
 \let\@sharp##%
 \let\protect\relax
 \begingroup
  \@mkpream{#2}%
  \@mkpream@relax
  \edef\@preamble{\@preamble}%
  \prepdef\@preamble{%
   \global\advance\c@LT@chunks\@ne
   \global\LT@rows\z@
   \setbox\z@\vbox\bgroup
    \LT@setprevdepth
    \tabskip\LTleft
    \halign to\hsize\bgroup
     \tabskip\z@
     \@arstrut
  }%
  \appdef\@preamble{%
     \tabskip\LTright
     \cr
  }%
  \global\let\LT@bchunk\@preamble
 \endgroup
 \expandafter\LT@nofcols\LT@bchunk&\LT@nofcols
 \LT@make@row
 \m@th
 \let\par\@empty
 \everycr{}%
 \lineskip\z@
 \baselineskip\z@
 \LT@bchunk
}%
\appdef\table@hook{}%
\def\switch@longtable{%
 \@ifpackageloaded{longtable}{%
  \@ifx{\longtable\longtable@longtable}{%
   \@ifx{\endlongtable\endlongtable@longtable}{%
    \@ifx{\LT@start\LT@start@longtable}{%
     \@ifx{\LT@end@hd@ft\LT@end@hd@ft@longtable}{%
      \@ifx{\LT@array\LT@array@longtable}{%
       \true@sw
      }{\false@sw}%
     }{\false@sw}%
    }{\false@sw}%
   }{\false@sw}%
  }{\false@sw}%
  {%
   \class@info{Patching longtable package}%
  }{%
   \class@info{Patching unrecognized longtable package. (Proceeding with fingers crossed)}%
  }%
  \let\longtable\longtable@new
  \let\endlongtable\endlongtable@new
  \let\LT@start\LT@start@new
  \let\LT@end@hd@ft\LT@end@hd@ft@new
  \let\LT@array\LT@array@new
  \@ifpackageloaded{caption}{
  \renewenvironment{longtable*}{%
   \onecolumngrid@push
   \longtable
  }{%
   \endlongtable
   \onecolumngrid@pop
  }}{
  \newenvironment{longtable*}{%
   \onecolumngrid@push
   \longtable
  }{%
   \endlongtable
   \onecolumngrid@pop
  }}%
 }{}%
}%
\def\LT@pre{\penalty\z@\vskip\LTpre}%
\def\LT@bot{\nobreak\copy\LT@foot\vfil}%
\def\LT@top{\copy\LT@head\nobreak}%
\def\LT@post{\penalty\z@\addvspace\LTpost\mark@envir{\curr@envir}}%
\def\LT@adj{%
 \setbox\z@\vbox{\null}\dimen@-\ht\z@
 \setbox\z@\vbox{\unvbox\z@\LT@bot}\advance\dimen@\ht\z@
 \global\advance\vsize-\dimen@
}%
\def\output@init@longtable{\LT@adj}%
\def\output@prep@longtable{\setbox\@cclv\vbox{\unvbox\@cclv\LT@bot}}%
\def\output@post@longtable{\LT@top}%
\let\output@init@theindex\@empty
\let\output@prep@theindex\@empty
\def\output@post@theindex{%
 \@ifodd\c@page{}{%
  \@ifnum{\pagegrid@cur=\@ne}{%
  }%
 }%
}%
\def\check@aux{\do@output@MVL{\do@check@aux}}%
\def\check@deferlist@stuck#1{%
 \@ifx{\@deferlist@postshipout\@empty}{}{%
  \@ifx{\@deferlist@postshipout\@deferlist}{%
   \@fltstk
   \clearpage@sw{%
    \ltxgrid@warn{Deferred float stuck during \string\clearpage\space processing}%
   }{%
    \force@deferlist@stuck#1%
   }%
  }{%
  }%
  \global\let\@deferlist@postshipout\@empty
 }%
}%
\appdef\@outputpage@tail{%
 \global\let\@deferlist@postshipout\@deferlist
}%
\def\@next#1#2{%
 \@ifx{#2\@empty}{\false@sw}{%
  \expandafter\@xnext#2\@@#1#2%
  \true@sw
 }%
}%
\def\@xnext\@elt#1#2\@@#3#4{%
 \def#3{#1}%
 \gdef#4{#2}%
 \def\@tempa{#4}\def\@tempb{\@freelist}%
 \@ifx{\@tempa\@tempb}{%
  \@ifx{#4\@empty}{%
   \force@deferlist@empty%{Float register pool exhausted}%
  }{}%
 }{}%
}%
\def\force@deferlist@stuck#1{%
 \force@deferlist@sw{%
  \@booleantrue\clearpage@sw
  \@booleantrue\forcefloats@sw
  #1%
 }{%
 }%
}%
\def\force@deferlist@empty{%
 \force@deferlist@sw{%
  \penalty-\pagebreak@pen
  \protect@penalty\do@forcecolumn@pen
 }{%
 }%
}%


\mathchardef\do@forcecolumn@pen=10009
\@namedef{output@-\the\do@forcecolumn@pen}{\do@forcecolumn}%
\def\do@forcecolumn{%
 \@booleantrue\clearpage@sw
 \@booleantrue\forcefloats@sw
 \do@startcolumn
}%
\def\enlargethispage{%
 \@ifstar{%
  \@enlargethispage{}%
 }{%
  \@enlargethispage{}%
 }%
}%
\def\@enlargethispage#1#2{%
 \begingroup
  \dimen@#2\relax
  \edef\@tempa{#1}%
  \edef\@tempa{\noexpand\@@enlargethispage{\@tempa}{\the\dimen@}}%
  \expandafter\do@output@MVL\expandafter{\@tempa}%
 \endgroup
}%
\def\@@enlargethispage#1#2{%
 \def\@tempa{one}%
 \@ifx{\thepagegrid\@tempa}{%
  \true@sw
 }{%
  \def\@tempa{mlt}%
  \@ifx{\thepagegrid\@tempa}{%
   \@ifnum{\pagegrid@cur=\@ne}{%
    \gdef\enlarge@colroom{#2}%
    \true@sw
   }{%
    \ltxgrid@warn{Too late to enlarge this page; move the command to the first column.}%
    \false@sw
   }%
  }{%
   \ltxgrid@warn{Unable to enlarge a page of this kind.}%
   \false@sw
  }%
 }%
 {%
  \class@info{Enlarging page \thepage\space by #2}%
  \global\advance\@colroom#2\relax
  \set@vsize
 }{%
 }%
}%
\let\enlarge@colroom\@empty
\let\@kludgeins\@undefined
\@booleantrue\textheight@sw
\prepdef\@outputpage@head{%
 \textheight@sw{%
  \count@\vbadness\vbadness\@M
  \dimen@\vfuzz\vfuzz\maxdimen
  \setbox\@outputbox\vbox to\textheight{\unvbox\@outputbox}%
  \vfuzz\dimen@
  \vbadness\count@
 }{}%
}%
\appdef\@outputpage@head{%
 \@ifx{\LS@rot\@undefined}{}{\LS@rot}%
}%
\def\ltxgrid@info{%
 \ltxgrid@info@sw{\class@info}{\@gobble}%
}%
\@booleanfalse\ltxgrid@info@sw
\def\ltxgrid@warn{%
 \ltxgrid@warn@sw{\class@warn}{\@gobble}%
}%
\@booleantrue\ltxgrid@warn@sw
\@booleanfalse\ltxgrid@foot@info@sw
\def\def@next@handler#1#2#3{%
 \advance#1\@ne\mathchardef#2\the#1%
 \expandafter\def\csname output@-\the#1\endcsname{#3}%
}%
\def\def@line@handler#1#2{%
 \begingroup
  \@tempcnta\int@parpenalty
  \advance\@tempcnta-#1%
  \aftergroup\def
  \expandafter\aftergroup\csname output@-\the\@tempcnta\endcsname
 \endgroup{#2}%
}%
\mathchardef\int@parpenalty11012
\def@line@handler\z@{\@handle@line@ltx{}{}{}}%
\def@line@handler\@ne{\@handle@line@ltx{}{}{\brokenpenalty@ltx}}%
\def@line@handler\tw@{\@handle@line@ltx{}{\clubpenalty@ltx}{}}%
\def@line@handler\thr@@{\@handle@line@ltx{\clubpenalty@ltx}{}{\brokenpenalty@ltx}}%
\def@line@handler\f@ur{\@handle@line@ltx{\widowpenalty@ltx}{}{}}%
\def@line@handler{5}{\@handle@line@ltx{\widowpenalty@ltx}{}{\brokenpenalty@ltx}}%
\def@line@handler{6}{\@handle@line@ltx{\widowpenalty@ltx}{\clubpenalty@ltx}{}}%
\def@line@handler{7}{\@handle@line@ltx{\widowpenalty@ltx}{\clubpenalty@ltx}{\brokenpenalty@ltx}}%
\def@line@handler{8}{\@handle@line@ltx{\displaywidowpenalty@ltx}{}{}}%
\def@line@handler{9}{\@handle@line@ltx{\displaywidowpenalty@ltx}{}{\brokenpenalty@ltx}}%
\def@line@handler{10}{\@handle@line@ltx{\displaywidowpenalty@ltx}{\clubpenalty@ltx}{}}%
\def@line@handler{11}{\@handle@line@ltx{\displaywidowpenalty@ltx}{\clubpenalty@ltx}{\brokenpenalty@ltx}}%
\def\@handle@line@ltx#1#2#3{%
 \@@handle@line@ltx
 \@tempcnta\lastpenalty
 \@tempcntb\interlinepenalty@ltx\relax
 \@if@empty{#1}{}{\advance\@tempcntb#1\relax}%
 \@if@empty{#2}{}{\advance\@tempcntb#2\relax}%
 \@if@empty{#3}{}{\advance\@tempcntb#3\relax}%
 \penalty\@ifnum{\@tempcnta<\@tempcntb}{\@tempcntb}{\@tempcnta}%
}%
\let\@@handle@line@ltx\@empty
\@tempcnta\int@parpenalty
\def@next@handler\@tempcnta\int@postparpenalty{\reset@queues@ltx\handle@par@ltx}%
\def@next@handler\@tempcnta\int@vadjustpenalty{\handle@vadjust@ltx}%
\def@next@handler\@tempcnta\int@whatsitpenalty{\handle@whatsit@ltx}%
\def@next@handler\@tempcnta\int@predisplaypenalty{\reset@queues@ltx\@handle@display@ltx{\predisplaypenalty@ltx}}%
\def@next@handler\@tempcnta\int@interdisplaylinepenalty{\@handle@display@ltx{\interdisplaylinepenalty@ltx}}%
\def@next@handler\@tempcnta\int@postdisplaypenalty{\@handle@display@ltx{\postdisplaypenalty@ltx}}%
\def\@handle@display@ltx#1{%
 \@@handle@display@ltx
 \@tempcnta\lastpenalty
 \@tempcntb#1%
 \penalty\@ifnum{\@tempcnta<\@tempcntb}{\@tempcntb}{\@tempcnta}%
}%
\let\@@handle@display@ltx\@empty
\def\handle@par@ltx{}%
\def\set@linepenalties{%
 \expandafter\def\expandafter\interlinepenalty@ltx\expandafter{\the\interlinepenalty}%
 \interlinepenalty-\int@parpenalty
 \expandafter\def\expandafter\brokenpenalty@ltx\expandafter{\the\brokenpenalty}%
 \brokenpenalty\@ne
 \expandafter\def\expandafter\clubpenalty@ltx\expandafter{\the\clubpenalty}%
 \clubpenalty\tw@
 \expandafter\def\expandafter\widowpenalty@ltx\expandafter{\the\widowpenalty}%
 \widowpenalty\f@ur
 \expandafter\def\expandafter\displaywidowpenalty@ltx\expandafter{\the\displaywidowpenalty}%
 \displaywidowpenalty8\relax
}%
\def\restore@linepenalties{%
 \interlinepenalty\interlinepenalty@ltx
 \brokenpenalty\brokenpenalty@ltx
 \clubpenalty\clubpenalty@ltx
 \widowpenalty\widowpenalty@ltx
 \displaywidowpenalty\displaywidowpenalty@ltx
 \relax
}%
\def\set@displaypenalties#1{%
 \expandafter\def\expandafter\predisplaypenalty@ltx\expandafter{\the\predisplaypenalty}%
 \expandafter\def\expandafter\interdisplaylinepenalty@ltx\expandafter{\the\interdisplaylinepenalty}%
 \expandafter\def\expandafter\postdisplaypenalty@ltx\expandafter{\the\postdisplaypenalty}%
 \@ifhmode{\predisplaypenalty-\int@predisplaypenalty\relax}{}%
 #1{\interdisplaylinepenalty-\int@interdisplaylinepenalty\relax}{}%
 #1{\postdisplaypenalty-\int@postdisplaypenalty\relax}{}%
}%
\def\enqueue@whatsit@ltx#1{%
 \gappdef\g@whatsit@queue{{#1}}%
 \vadjust{\penalty-\int@whatsitpenalty}%
}%
\def\handle@whatsit@ltx{%
 \unvbox\@cclv
 \g@pop@ltx\g@whatsit@queue\@tempa
 \expandafter\do@whatsit\expandafter{\@tempa}%
}%
\def\do@whatsit#1{}%
\def\g@pop@ltx#1#2{%
 \expandafter\@g@pop@ltx#1{}{}\@@#1#2%
}%
\def\@g@pop@ltx#1#2\@@#3#4{%
 \gdef#3{#2}%
 \def#4{#1}%
}%
\let\vspace@ltx\vspace
\let\pagebreak@ltx\pagebreak
\let\nopagebreak@ltx\nopagebreak
\let\endline@ltx\\
\let\@arrayparboxrestore@ltx\@arrayparboxrestore
\def\@tempa#1{%
\def\@vspace@org ##1{%
  \ifvmode
    #1% \vskip #1
    \vskip\z@skip
   \else
     \@bsphack
     \vadjust{\@restorepar
              #1% \vskip #1
              \vskip\z@skip
              }%
     \@esphack
   \fi
}%
\def\@vspace@ltx##1{%
 \@ifvmode{%
  #1% \vskip #1
  \vskip\z@skip
 }{%
  \@bsphack
  \ex@vadjust@ltx{%
   \@restorepar
   \nobreak
   #1% \vskip #1
   \vskip\z@skip
  }%
  \@esphack
 }%
}%
\def\@vspacer@org##1{%
  \ifvmode
    \dimen@\prevdepth
    \hrule \@height\z@
    \nobreak
    #1%\vskip #1
    \vskip\z@skip
    \prevdepth\dimen@
  \else
    \@bsphack
    \vadjust{\@restorepar
             \hrule \@height\z@
             \nobreak
             #1%\vskip #1
             \vskip\z@skip}%
    \@esphack
\fi
}%
\def\@vspacer@ltx##1{%
 \@ifvmode{%
  \dimen@\prevdepth
  \hrule\@height\z@
  \nobreak
  #1%\vskip#1
  \vskip\z@skip
  \prevdepth\dimen@
 }{%
  \@bsphack
  \ex@vadjust@ltx{%
   \@restorepar
   \hrule\@height\z@
   \nobreak
   #1%\vskip#1
   \vskip\z@skip
  }%
  \@esphack
 }%
}%
}
\rvtx@ifformat@geq{2020/10/01}%
  {\@tempa{\@vspace@calcify{#1}}}%
  {\@tempa{\vskip #1 }}%
\def\@no@pgbk@org #1[#2]{%
  \ifvmode
    \penalty #1\@getpen{#2}%
  \else
    \@bsphack
    \vadjust{\penalty #1\@getpen{#2}}%
    \@esphack
  \fi
}%
\def\@no@pgbk@ltx#1[#2]{%
 \@ifvmode{%
  \penalty#1\@getpen{#2}%
 }{%
  \@bsphack
  \ex@vadjust@ltx{%
   \penalty#1\@getpen{#2}%
  }%
  \@esphack
 }%
}%
\rvtx@ifformat@geq{2020/02/02}%
{\protected}{\long}\def\end@line@org{%
 \let\reserved@e\relax
 \let\reserved@f\relax
 \@ifstar{%
  \let\reserved@e\vadjust
  \let\reserved@f\nobreak
  \@xnewline
 }%
 \@xnewline
}%
\rvtx@ifformat@geq{2020/02/02}%
{\protected}{\long}\def\end@line@ltx{%
 \let\reserved@e\relax
 \let\reserved@f\relax
 \@ifstar{%
  \let\reserved@e\ex@vadjust@ltx
  \let\reserved@f\nobreak
  \@xnewline
 }{%
  \@xnewline
 }%
}%
\def\@tempa#1{%
  \def\@newline@org[##1]{%
   \let\reserved@e\vadjust
   \@gnewline{#1}% \vskip#1
  }%
  \def\@newline@ltx[##1]{%
   \let\reserved@e\ex@vadjust@ltx
   \@gnewline{#1}% \vskip#1
  }%
}
\rvtx@ifformat@geq{2020/10/01}%
  {\@tempa{\@vspace@calcify{#1}}}%
  {\@tempa{\vskip #1}}%
 \@ifx{\@vspace\@vspace@org}{%
  \@ifx{\@vspacer\@vspacer@org}{%
   \@ifx{\@no@pgbk\@no@pgbk@org}{%
    \@ifx{\@newline\@newline@org}{%
     \expandafter\@ifx\expandafter{%
       \csname\rvtx@ifformat@geq{2020/02/02}%
         {\expandafter\@gobble\string\\}%
         {\expandafter\@gobble\string\\ }\endcsname
       \end@line@org
     }{%
       \true@sw
     }{\false@sw}%
    }{\false@sw}%
   }{\false@sw}%
  }{\false@sw}%
 }{\false@sw}%
 {%
  \class@info{Overriding \string\@vspace, \string\@vspacer, \string\@no@pgbk, \string\@newline, and \string\\ }%
  \let\@normalcr\end@line@ltx
  \expandafter\let
    \csname\rvtx@ifformat@geq{2020/02/02}%
      {\expandafter\@gobble\string\\}%
      {\expandafter\@gobble\string\\ }\endcsname\@normalcr
  \let\@newline\@newline@ltx
  \let\@vspace\@vspace@ltx
  \let\@vspacer\@vspacer@ltx
  \let\@no@pgbk\@no@pgbk@ltx
 }{%
  \class@warn{%
   Failed to recognize \string\@vspace, \string\@vspacer, \string\@no@pgbk, \string\@newline, and \string\\;
   no patches applied. Please get a more up-to-date class,
  }%
 }%
\let\ex@vadjust@ltx\vadjust
\def\enqueue@vadjust@ltx#1{%
 \gappdef\g@vadjust@queue{{#1}}%
 \vadjust{\penalty-\int@vadjustpenalty}%
}%
\def\handle@vadjust@ltx{%
 \unvbox\@cclv
 \g@pop@ltx\g@vadjust@queue\@tempa
 \expandafter\gappdef\expandafter\g@vadjust@line\expandafter{\@tempa}%
}%
\let\g@vadjust@line\@empty
\def\reset@queues@ltx{%
 \global\let\g@whatsit@queue\@empty
 \global\let\g@vadjust@queue\@empty
}%
\let\setup@hook\@empty
\appdef\document@inithook{%
 \switch@longtable
 \let\LT@makecaption\LT@makecaption@rtx
}%
\def\LT@makecaption@rtx#1#2#3{%
  \LT@mcol\LT@cols c{%
    \hbox to\z@{%
     \hss
     \parbox[t]\LTcapwidth{%
      \sbox\@tempboxa{#1{#2: }#3\unskip\nobreak\vrule\@width\z@\@height\z@\@depth .5\baselineskip}%
      \ifdim\wd\@tempboxa>\hsize
        #1{#2: }#3\unskip\nobreak\vrule\@width\z@\@height\z@\@depth .5\baselineskip
      \else
        \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
      \fi
      \endgraf
     }%
     \hss
    }%
  }%
}%
\def\protectdef@boldmath{%
 \expandafter\@ifnotrelax\csname boldmath \endcsname{}{%
  \class@info{Robustifying \string\LaTeX's \string\boldmath\space command}%
  \expandafter\let\csname boldmath \endcsname\boldmath
  \expandafter\def\expandafter\boldmath\expandafter{\expandafter\protect\csname boldmath \endcsname}%
 }%
}%
\appdef\document@inithook{%
 \protectdef@boldmath
}%

\@booleanfalse\dateinRH@sw
\def\checkindate{\dateinRH@sw{{\tiny(\today)}}{}}%
\def\allow@breaking@tables{%
 \def\array@default{v}% tabular can break over pages
 \@booleanfalse\floats@sw % table can break over pages
}%

\DeclareOption{modern}{\@two@colfalse\twelvepointtrue\moderntrue}
\DeclareOption{preprint2}{\@two@coltrue\preprinttwotrue\twelvepointtrue}% 
\DeclareOption{manuscript}{%
  \@booleantrue\manuscriptsty@sw
  \global\doublespacetrue
  \twelvepointtrue}% 

\@booleanfalse\manuscriptsty@sw

\DeclareOption{preprint}{%
  \@booleantrue\preprintsty@sw
  \twelvepointtrue%
  \@two@colfalse%
   \twelvepointtrue
}%

\DeclareOption{reprint}{%
 \@booleanfalse\preprintsty@sw
 \@booleantrue\twocolumn@sw
 \ExecuteOptions{10pt}%
}
\@booleanfalse\preprintsty@sw
\DeclareOption{showkeys}{%
  \@booleantrue\showKEYS@sw
}%
\DeclareOption{noshowkeys}{%
  \@booleanfalse\showKEYS@sw
}%
\@booleantrue\showKEYS@sw

\DeclareOption{nopreprintnumbers}{\@booleanfalse\preprint@sw}%
\DeclareOption{preprintnumbers}{\@booleantrue\preprint@sw}%
\appdef\setup@hook{%
 \@ifxundefined\preprint@sw{\let\preprint@sw\preprintsty@sw}{}%
}%
\DeclareOption{hyperref}{%
 \class@warn{Class option "hyperref" is no longer supported.^^JEmploy \string\usepackage{hyperref} instead}%
}%
\DeclareOption{10pt}{\def\@pointsize{10}}%
\DeclareOption{11pt}{\def\@pointsize{11}}%
\DeclareOption{12pt}{\def\@pointsize{12}}%
\let\@pointsize\@undefined
\DeclareOption{a4paper}{%
    \setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}%
}%
\DeclareOption{a5paper}{%
    \setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}%
}%
\DeclareOption{b5paper}{%
    \setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}%
}%
\DeclareOption{letterpaper}{%
    \setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}%
}%
\DeclareOption{legalpaper}{%
    \setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}%
}%
\DeclareOption{executivepaper}{%
    \setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}%
}%
\DeclareOption{landscape}{%
    \setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}%
}%
\ds@letterpaper
\DeclareOption{bibnotes}{\let\frontmatter@footnote@produce\frontmatter@footnote@produce@endnote}%
\DeclareOption{nobibnotes}{\let\frontmatter@footnote@produce\frontmatter@footnote@produce@footnote}%
\let\frontmatter@footnote@produce\frontmatter@footnote@produce@footnote
\DeclareOption{footinbib}{\@booleantrue\footinbib@sw}
\DeclareOption{nofootinbib}{\@booleanfalse\footinbib@sw}
\@booleanfalse\footinbib@sw
\DeclareOption{altaffilletter}{\@booleantrue\altaffilletter@sw}%
\DeclareOption{altaffilsymbol}{\@booleanfalse\altaffilletter@sw}%
\@booleanfalse\altaffilletter@sw
\DeclareOption{superbib}{%
 \let\place@bibnumber\place@bibnumber@sup
}%
\def\place@bibnumber{\NATx@bibnumfmt}%
\def\place@bibnumber@sup#1{\textsuperscript{#1}}%
\def\place@bibnumber@inl#1{[#1]}%
\DeclareOption{citeautoscript}{\@booleantrue\citeautoscript@sw}%
\@booleanfalse\citeautoscript@sw
\DeclareOption{eprint}{\@booleantrue\eprint@enable@sw}%
\DeclareOption{noeprint}{\@booleanfalse\eprint@enable@sw}%
\@booleantrue\eprint@enable@sw
\DeclareOption{onecolumn}{\@booleanfalse\twocolumn@sw\onecolstyletrue}%
\DeclareOption{twocolumn}{\@booleantrue\twocolumn@sw\onecolstylefalse\@twocolumntrue\@two@coltrue\twelvepointfalse}%
\@booleanfalse\twocolumn@sw
\def\select@column@grid{%
 \twocolumn@sw{%
  \twocolumn@grid@setup
  \open@twocolumn
 }{%
  \onecolumn@grid@setup
 }%
}%
\appdef\class@documenthook{%
 \select@column@grid
}%
\appdef\setup@hook{%
 \let\clearpage@ltx\clearpage
 \prepdef\clear@document{\let\clearpage\clearpage@ltx\let\clear@document\@empty\close@column}%
 \appdef\class@documenthook{%
  \appdef\class@enddocumenthook{%
   \let\clearpage\clear@document
  }%
 }%
}%
\DeclareOption{author-year}{\@booleantrue\authoryear@sw}%
\DeclareOption{numerical}{\@booleanfalse\authoryear@sw}%
\@booleanfalse\authoryear@sw
\DeclareOption{galley}{%
  \ExecuteOptions{onecolumn}%
  \@booleantrue\galley@sw
  \@booleanfalse\preprintsty@sw
  \appdef\setup@hook{%
    \advance\textwidth-\columnsep
    \textwidth.5\textwidth
  }%
}%
\@booleanfalse\galley@sw
\DeclareOption{raggedbottom}{\@booleantrue\raggedcolumn@sw}
\DeclareOption{flushbottom}{\@booleanfalse\raggedcolumn@sw}
\@booleanfalse\raggedcolumn@sw
\appdef\setup@hook{%
 \raggedcolumn@sw{\raggedbottom}{\flushbottom}%
}%
\DeclareOption{tightenlines}{\@booleantrue\tightenlines@sw}
\@booleanfalse\tightenlines@sw
\@booleanfalse\lengthcheck@sw
\DeclareOption{lengthcheck}{%
 \@booleantrue\lengthcheck@sw
 \ExecuteOptions{reprint}%
}%
\appdef\setup@hook{%
 \lengthcheck@sw{\@booleantrue\tally@box@size@sw}{}%
}%
\appdef\setup@hook{%
 \draft@sw{\overfullrule 5\p@}{\overfullrule\z@}%
}%
\DeclareOption{draft}{\@booleantrue\draft@sw}%
\DeclareOption{final}{\@booleanfalse\draft@sw}%
\@booleanfalse\draft@sw
\appdef\setup@hook{%
 \eqsecnum@sw{%
  \@addtoreset{equation}{section}%
  \def\theequation@prefix{\arabic{section}.}%
 }{}%
}%
\DeclareOption{eqsecnum}{\@booleantrue\eqsecnum@sw}%
\@booleanfalse\eqsecnum@sw


\DeclareOption{fleqn}{%
 \input{fleqn.clo}%
}%
\DeclareOption{floats}{\@booleantrue\floats@sw\@booleanfalse\floatp@sw}
\DeclareOption{endfloats}{\@booleanfalse\floats@sw\@booleanfalse\floatp@sw}
\DeclareOption{endfloats*}{\@booleanfalse\floats@sw\@booleantrue\floatp@sw}
\@booleantrue\floats@sw
\@booleantrue\floatp@sw
\DeclareOption{titlepage}{\@booleantrue\titlepage@sw}
\DeclareOption{notitlepage}{\@booleanfalse\titlepage@sw}
\@booleanfalse\titlepage@sw
\def\change@society#1{%
 \def\@tempa{#1}%
 \@ifxundefined\@society{%
  \class@info{Selecting society \@tempa}%
  \let\@society\@tempa
 }{%
  \@ifx{\@tempa\@society}{}{%
   \class@warn{Conflicting society \@tempa<>\@society; not selected}%
  }%
 }%
}%
\let\rtx@require@packages\@empty
\appdef\rtx@require@packages{%
 \RequirePackage[overload]{textcase}%
}%
\DeclareOption{amsfonts}{%
  \def\class@amsfonts{\RequirePackage{amsfonts}}%
}%
\DeclareOption{noamsfonts}{%
  \let\class@amsfonts\@empty
}%
\appdef\rtx@require@packages{%
 \@ifxundefined\class@amsfonts{}{\class@amsfonts}%
}%
\DeclareOption{amsmath}{%
  \def\class@amsmath{\RequirePackage{amsmath}[\ver@amsmath@prefer]}%
}%
\DeclareOption{noamsmath}{%
  \let\class@amsmath\@empty
}%
\appdef\rtx@require@packages{%
 \preserve@LaTeX
 \@ifxundefined\class@amsmath{}{\class@amsmath}%
 \appdef\class@enddocumenthook{\test@amsmath@ver}%
}%
\appdef\preserve@LaTeX{%
 \let\@ifl@aded@LaTeX\@ifl@aded
 \let\@ifpackageloaded@LaTeX\@ifpackageloaded
 \let\@pkgextension@LaTeX\@pkgextension
 \let\@ifpackagelater@LaTeX\@ifpackagelater
 \let\@ifl@ter@LaTeX\@ifl@ter
 \let\@ifl@t@r@LaTeX\@ifl@t@r
 \let\@parse@version@LaTeX\@parse@version
}%
\appdef\restore@LaTeX{%
 \let\@ifl@aded\@ifl@aded@LaTeX
 \let\@ifpackageloaded\@ifpackageloaded@LaTeX
 \let\@pkgextension\@pkgextension@LaTeX
 \let\@ifpackagelater\@ifpackagelater@LaTeX
 \let\@ifl@ter\@ifl@ter@LaTeX
 \let\@ifl@t@r\@ifl@t@r@LaTeX
 \let\@parse@version\@parse@version@LaTeX
}%
\def\test@amsmath@ver{%
 \begingroup
  \restore@LaTeX
  \@ifpackageloaded{amsmath}{%
   \@ifpackagelater{amsmath}{\ver@amsmath@prefer}{}{%
     \class@warn{%
      You have loaded amsmath, version "\csname ver@amsmath.sty\endcsname",\MessageBreak
      but this class requires version "\ver@amsmath@prefer", or later.\MessageBreak
      Please update your LaTeX installation.
     }%
   }%
  }{%
  }%
 \endgroup
}%
\def\ver@amsmath@prefer{2000/01/15 v2.05 AMS math features}%

\DeclareOption{floatfix}{\@booleantrue\force@deferlist@sw}%
\DeclareOption{nofloatfix}{\@booleanfalse\force@deferlist@sw}%
\@booleantrue\force@deferlist@sw
\gdef\@fltovf{%
 \@latex@error{%
  Too many unprocessed floats%
  \force@deferlist@sw{}{; try class option [floatfix]}%
 }\@ehb
}%
\def\@fltstk{%
 \@latex@warning{%
  A float is stuck (cannot be placed)%
  \force@deferlist@sw{}{; try class option [floatfix]}%
 }%
}%
\DeclareOption{ltxgridinfo}{%
 \@booleantrue\ltxgrid@info@sw
}%
\DeclareOption{outputdebug}{%
 \@booleantrue\outputdebug@sw
 \@booleantrue\ltxgrid@info@sw
 \@booleantrue\ltxgrid@foot@info@sw
 \traceoutput
}%
\DeclareOption{raggedfooter}{\@booleanfalse\textheight@sw}%
\DeclareOption{noraggedfooter}{\@booleantrue\textheight@sw}%
\DeclareOption{frontmatterverbose}{\@booleantrue\frontmatterverbose@sw}%
\@booleanfalse\frontmatterverbose@sw

\DeclareOption{nomerge}{%
 \appdef\setup@hook{%
  \@ifnum{\NAT@merge>\z@}{\let\NAT@merge\z@}{}%
 }%
}%

\DeclareOption{hypertext}{\hypertext@enable@ltx}%
\appdef\document@inithook{\@ifpackageloaded{hyperref}{\hypertext@enable@ltx}{}}%

\DeclareOption{frontmatterverbose}{\@booleantrue\frontmatterverbose@sw}%
\@booleanfalse\frontmatterverbose@sw

\@booleanfalse\runinaddress@sw
\@booleantrue\@affils@sw
\@booleanfalse\groupauthors@sw

\DeclareOption{groupedaddress}{\clo@groupedaddress}%
\def\clo@groupedaddress{%
 \@booleantrue\groupauthors@sw
 \@booleantrue\@affils@sw
 \@booleanfalse\runinaddress@sw
}%
\DeclareOption{unsortedaddress}{\clo@unsortedaddress}%
\def\clo@unsortedaddress{%
 \@booleantrue\groupauthors@sw
 \@booleanfalse\@affils@sw
 \@booleanfalse\runinaddress@sw
}%
\DeclareOption{runinaddress}{\clo@runinaddress}%
\def\clo@runinaddress{%
 \@booleantrue\groupauthors@sw
 \@booleantrue\@affils@sw
 \@booleantrue\runinaddress@sw
}%
\DeclareOption{superscriptaddress}{\clo@superscriptaddress}%
\def\clo@superscriptaddress{%
 \@booleanfalse\groupauthors@sw
 \@booleantrue\@affils@sw
 \@booleanfalse\runinaddress@sw
}%
\DeclareOption*{\OptionNotUsed}%

\def\@fnsymbol#1{%
 \ensuremath{%
  \ifcase#1\or
   *\or
   \dagger\or
   \ddagger\or
   \mathsection\or
   \mathparagraph\or
   **\or
   \dagger\dagger\or
   \ddagger\ddagger\or
   \mathsection\mathsection\or
   \mathparagraph\mathparagraph\or
   ***\or
   \dagger\dagger\dagger\or
   \ddagger\ddagger\ddagger\or
   \mathsection\mathsection\mathsection\or
   \mathparagraph\mathparagraph\mathparagraph\or
   \@ctrerr
  \fi
 }%
}%
\appdef\document@inithook{%
 \@ifxundefined\TextOrMath{%
  \DeclareRobustCommand\TextOrMath{\@ifmmode{\false@sw}{\true@sw}}%
 }{}%
}%
\let\thefootnote@latex\thefootnote
\clo@groupedaddress

\newenvironment{titlepage}{%
  \let\wastwocol@sw\twocolumn@sw
  \onecolumngrid
  \newpage
  \thispagestyle{titlepage}%
  \c@page\z@
}{%
  \wastwocol@sw{\twocolumngrid}{\newpage}%
}%


\def\adjust@abstractwidth{%
 \dimen@\textwidth\advance\dimen@-\frontmatter@abstractwidth
 \divide\dimen@\tw@
 \galley@sw{%
  \advance\rightskip\tw@\dimen@
 }{%
  \advance\leftskip\dimen@
  \advance\rightskip\dimen@
 }%
 \@totalleftmargin\leftskip
}%

\@booleanfalse\preprintsty@sw
\@booleanfalse\titlepage@sw


\def\frontmatter@above@affiliation@script{%
 \skip@\@flushglue
 \@flushglue\z@ plus.3\hsize\relax
 \centering
 \@flushglue\skip@
 \addvspace{3.5\p@}%
}%
\def\frontmatter@above@affiliation{%
 \preprintsty@sw{}{%
 }%
}%
\def\frontmatter@collaboration@above{%
 \preprintsty@sw{%
 }{%
  \parskip1.5\p@\relax
 }%
}%
\def\frontmatter@setup{%
 \normalfont
}%

\def\@author@parskip{3\p@}%
\def\frontmatter@makefnmark{%
 \@textsuperscript{%
  \normalfont\@thefnmark
 }%
}%
\def\frontmatter@authorbelow{%
 \addvspace{3\p@}%
}%
\def\frontmatter@RRAP@format{%
  \small
  \centering
  \everypar{\hbox\bgroup(\@gobble@leavemode@uppercase}%
  \def\par{\@ifvmode{}{\unskip)\egroup\@@par}}%
}%
\def\punct@RRAP{;\egroup\ \hbox\bgroup}%
\def\@gobble@leavemode@uppercase#1#2{\expandafter\MakeTextUppercase}%


\def\produce@preprints#1{%
 \vtop to \z@{%
  \def\baselinestretch{1}%
  \small
  \let\preprint\preprint@count
  \count@\z@
  #1%
  \@ifnum{\count@>\tw@}{%
   \hbox{%
    \let\preprint\preprint@hlist
    #1%
    \setbox\z@\lastbox
   }%
  }{%
   \let\preprint\preprint@cr
   \halign{\hfil##\cr#1\crcr}%
   \par
   \vss
  }%
 }%
}%
\def\preprint@cr#1{#1\cr}%
\def\preprint@count#1{\advance\count@\@ne}%
\def\preprint@hlist#1{#1\hbox{, }}%
\def\@seccntformat#1{\csname the#1\endcsname.\quad}%
\def\@hang@from#1#2#3{#1#2#3}%
\def\@hangfrom@section#1#2#3{\@hangfrom{#1#2}\MakeTextUppercase{#3}}%
\def\@hangfroms@section#1#2{#1\MakeTextUppercase{#2}}%

\let\frontmatter@footnote@produce\frontmatter@footnote@produce@footnote
\def\@pnumwidth{1.55em}%
\def\@tocrmarg {2.55em}%
\def\@dotsep{2}%
\def\ltxu@dotsep{4.5pt}%
\setcounter{tocdepth}{3}%
\def\tableofcontents{%
 \addtocontents{toc}{\string\tocdepth@munge}%
 \print@toc{toc}%
 \addtocontents{toc}{\string\tocdepth@restore}%
}%
\def\tocdepth@munge{%
  \let\l@section@saved\l@section
  \let\l@section\@gobble@tw@
}%
\def\@gobble@tw@#1#2{}%
\def\tocdepth@restore{%
  \let\l@section\l@section@saved
}%
\def\l@part#1#2{\addpenalty{\@secpenalty}%
 \begingroup
  \set@tocdim@pagenum\@tempboxa{#2}%
  \parindent \z@
  \rightskip\tocleft@pagenum plus 1fil\relax
  \skip@\parfillskip\parfillskip\z@
  \addvspace{2.25em plus\p@}%
  \large \bf %
  \leavevmode\ignorespaces#1\unskip\nobreak\hskip\skip@
  \hb@xt@\rightskip{\hfil\unhbox\@tempboxa}\hskip-\rightskip\hskip\z@skip
  \par
  \nobreak %
 \endgroup
}%
\def\tocleft@{\z@}%
\def\tocdim@min{5\p@}%
\def\l@section{%
 \l@@sections{}{section}% Implicit #3#4
}%
\def\l@f@section{%
 \addpenalty{\@secpenalty}%
 \addvspace{1.0em plus\p@}%
 %\bf
}%
\def\l@subsection{%
 \l@@sections{section}{subsection}% Implicit #3#4
}%
\def\l@subsubsection{%
 \l@@sections{subsection}{subsubsection}% Implicit #3#4
}%
\def\l@paragraph#1#2{}%
\def\l@subparagraph#1#2{}%
\let\toc@pre\toc@pre@auto
\let\toc@post\toc@post@auto
\@booleanfalse\raggedcolumn@sw
\def\tableft@skip@float{\z@ plus\hsize}%
\def\tabmid@skip@float{\@flushglue}%
\def\tabright@skip@float{\z@ plus\hsize}%
\def\array@row@pre@float{\hline\hline\noalign{\vskip\doublerulesep}}%
\def\array@row@pst@float{\noalign{\vskip\doublerulesep}\hline\hline}%

\long\def\frontmatter@makefntext#1{%
 \def\baselinestretch{1}%
 \parindent1em%
 \noindent
 \nobreak
 \Hy@raisedlink{\hyper@anchorstart{frontmatter.\expandafter\the\csname c@\@mpfn\endcsname}\hyper@anchorend}%
 \@hangfrom{\hb@xt@3mm{\hss\@makefnmark}~}#1%
 \par
}%

\def\@hangfrom@appendix#1#2#3{%
 #1%
 \@if@empty{#2}{%
  #3%
 }{%
  #2\@if@empty{#3}{}{:\ #3}%
 }%
}%
\def\@hangfroms@appendix#1#2{%
 #1#2%
}%
\def\@appendixcntformat#1{\appendixname\ \csname the#1\endcsname}%
\@booleanfalse\authoryear@sw
\appdef\setup@hook{%
 \bibpunct{[}{]}{,}{n}{}{,}%
}%


\appdef\setup@hook{%
 \def\bibsection{%
  \par
  \onecolumngrid@push
  \begingroup
   \baselineskip26\p@
   \bib@device{\textwidth}{245.5\p@}%
  \endgroup
  \nobreak\@nobreaktrue
  \addvspace{19\p@}%
  \par
  \onecolumngrid@pop
 }%
}%
\def\bib@device#1#2{%
 \hb@xt@\z@{%
  \hb@xt@#1{%
   \hfil
   \phantomsection
   \addcontentsline {toc}{section}{\protect\numberline{}\refname}%
   \hb@xt@#2{%
    \skip@\z@\@plus-1fil\relax
                           \leaders\hrule height.25 \p@ depth.25 \p@ \hskip\z@\@plus1fil
    \hskip\skip@
    \hskip\z@\@plus0.125fil\leaders\hrule height.375\p@ depth.375\p@ \hskip\z@\@plus0.75fil \hskip\z@\@plus0.125fil
    \hskip\skip@
    \hskip\z@\@plus0.25 fil\leaders\hrule height.5  \p@ depth.5  \p@ \hskip\z@\@plus0.5 fil \hskip\z@\@plus0.25 fil
    \hskip\skip@
    \hskip\z@\@plus0.375fil\leaders\hrule height.625\p@ depth.625\p@ \hskip\z@\@plus0.25fil \hskip\z@\@plus0.375fil
 %  \hskip\skip@
 %  \hfil
   }%
   \hfil
  }%
  \hss
 }%
}%
\appdef\setup@hook{%
 \let\bibpreamble\@empty
 \bibsep\z@\relax
 \def\newblock{\ }%
}%
\newenvironment{theindex}{%
 \columnseprule \z@
 \columnsep 35\p@
 \c@secnumdepth-\maxdimen
 \onecolumngrid@push
 \section{\indexname}%
 \thispagestyle{plain}%
 \parindent\z@
 \parskip\z@ plus.3\p@\relax
 \let\item\@idxitem
 \onecolumngrid@pop
}{%
}%
\def\@idxitem{\par\hangindent 40\p@}%
\def\subitem{\par\hangindent 40\p@ \hspace*{20\p@}}%
\def\subsubitem{\par\hangindent 40\p@ \hspace*{30\p@}}%
\def\indexspace{\par \vskip 10\p@ plus5\p@ minus3\p@\relax}%

\let\place@bibnumber\place@bibnumber@inl


\appdef\setup@hook{%
 \@ifx{\place@bibnumber\place@bibnumber@sup}{%
  \footinbib@sw{}{%
   \class@warn{Citations are superscript numbers: footnotes must be endnotes; changing to that configuration}%
   \@booleantrue\footinbib@sw
  }%
 }{}%
}%

\let\@journal\@undefined

\marginparwidth 107pt
\marginparsep 6pt
\splittopskip\topskip
\footskip 30pt
\columnseprule 0pt

\def\footnoterule{%
 \dimen@\skip\footins\divide\dimen@\tw@
 \kern-\dimen@\hrule width.5in\kern\dimen@
}%

\floatsep 12pt plus 2pt minus 2pt
\intextsep 12pt plus 2pt minus 2pt
\dblfloatsep 12pt plus 2pt minus 2pt
\@fptop 0pt plus 1fil
\@fpsep 8pt plus 2fil
\@fpbot 0pt plus 1fil
\@dblfptop 0pt plus 1fil
\@dblfpsep 8pt plus 2fil
\@dblfpbot 0pt plus 1fil
\marginparpush 5pt
\parskip 0pt plus 1pt
%\parindent 10pt
\emergencystretch8\p@
\partopsep 2pt plus 1pt minus 1pt
\leftmargini 25pt
\leftmarginii 22pt
\leftmarginiii 18.7pt
\leftmarginiv 17pt
\leftmarginv 10pt
\leftmarginvi 10pt

\def\@listI{%
  \leftmargin\leftmargini
  \parsep 4\p@ plus2\p@ minus\p@
  \topsep 8\p@ plus2\p@ minus4\p@
  \itemsep 4\p@ plus2\p@ minus\p@
}%
\labelsep 4pt

\def\heading@cr{\unskip\space\ignorespaces}%
\let\@oddhead\@empty
\let\@evenhead\@empty
\let\@oddfoot\@empty
\let\@evenfoot\@empty

\def\lastpage@putlabel{%
 \if@filesw
  \begingroup
    \advance\c@page\m@ne
    \immediate\write\@auxout{\string\newlabel{LastPage}{{}{\thepage}{}{}{}}}%
  \endgroup
 \fi
}%
\appdef\clear@document{%
 \do@output@cclv{%
  \lastpage@putlabel
  \tally@box@size@sw{\total@text}{}%
 }%
}%
\providecommand\write@column@totals{}%
\appdef\document@inithook{%
 \incompatible@package{cite}%
 \incompatible@package{mcite}%
 \incompatible@package{multicol}%
}%
\def\labelenumi{\theenumi.}
\def\theenumi{\arabic{enumi}}
\def\labelenumii{(\theenumii)}
\def\theenumii{\alph{enumii}}
\def\p@enumii{\theenumi}
\def\labelenumiii{\theenumiii.}
\def\theenumiii{\roman{enumiii}}
\def\p@enumiii{\theenumi(\theenumii)}
\def\labelenumiv{\theenumiv.}
\def\theenumiv{\Alph{enumiv}}
\def\p@enumiv{\p@enumiii\theenumiii}
\def\labelitemi{\textbullet}
\def\labelitemii{\normalfont\bfseries\textendash}
\def\labelitemiii{\textasteriskcentered}
\def\labelitemiv{\textperiodcentered}
\pagenumbering{arabic}
\newenvironment{verse}{%
  \let\\=\@centercr
  \list{}{%
    \itemsep\z@ \itemindent -1.5em\listparindent \itemindent
    \rightmargin\leftmargin\advance\leftmargin 1.5em}\item[]%
}{%
 \endlist
}%
\newenvironment{quotation}{%
  \list{}{%
    \listparindent 1.5em
    \itemindent\listparindent
    \rightmargin\leftmargin \parsep \z@ \@plus\p@}\item[]%
}{%
 \endlist
}%
\newenvironment{quote}{%
  \list{}{%
  \rightmargin\leftmargin}\item[]%
}{%
 \endlist
}%
\def\descriptionlabel#1{%
  \hspace\labelsep \normalfont\bfseries #1\unskip:%
}%
\newenvironment{description}{%
 \list{}{%
    \labelwidth\z@ \itemindent-\leftmargin
    \let\makelabel\descriptionlabel
 }%
}{%
 \endlist
}%
\newcounter{part}%
\let\thepart\@undefined
\newcounter{section}%
\let\thesection\@undefined
\newcounter{subsection}[section]%
\let\thesubsection\@undefined
\newcounter{subsubsection}[subsection]%
\let\thesubsubsection\@undefined
\newcounter{paragraph}[subsubsection]%
\let\theparagraph\@undefined
\newcounter{subparagraph}[paragraph]%
\let\thesubparagraph\@undefined


\def\part{\par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}%
\def\@part[#1]#2{%
 \@ifnum{\c@secnumdepth >\m@ne}{%
        \refstepcounter{part}%
        \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
 }{%
      \addcontentsline{toc}{part}{#1}%
 }%
 \begingroup
    \parindent \z@ \raggedright
    \interlinepenalty\@M
    \@ifnum{\c@secnumdepth >\m@ne}{%
      \Large \bf \partname~\thepart%
      \par\nobreak
    }{}%
    \huge \bf
    #2%
    \markboth{}{}\par
 \endgroup
   \nobreak
   \vskip 3ex
   \@afterheading
}%
\def\@spart#1{{\parindent \z@ \raggedright
    \interlinepenalty\@M
    \huge \bf
    #1\par}
    \nobreak
    \vskip 3ex
    \@afterheading}

\def\theequation{%
 \theequation@prefix\arabic{equation}%
}%
\def\theequation@prefix{}%
\lineskip 1pt
\normallineskip 1pt
\def\baselinestretch{1}%
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\arraycolsep 3pt
\tabcolsep 2pt
\arrayrulewidth .4pt
\doublerulesep 2pt
\skip\@mpfootins = 0pt
\fboxsep  = 3.0pt
\fboxrule = 0.4pt
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\def\listoffigures{\print@toc{lof}}%
\def\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}%
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{5\p@}
\setlength\belowcaptionskip{4\p@}


\def\@footnotemark@gobble{%
 \@footnotemark
 \@ifnextchar[{\@gobble@opt@i}{\@gobble}%
}%
\def\@gobble@opt@i[#1]#2{}%
\def\@mpmakefntext#1{%
 \flushing
 \parindent=1em
 \noindent
 \hb@xt@1em{\hss\@makefnmark}%
 #1%
}%
\def\@caption@fignum@sep{. }%
\def\setfloatlink{\def\float@link}%
\let\float@link\@empty
\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{{\bf\figurename~\thefigure}}
\expandafter\newbox\csname fbox@\ftype@figure\endcsname
\expandafter\setbox\csname fbox@\ftype@figure\endcsname\hbox{}%
\appdef\@xfloat@prep{%
 \appdef\@parboxrestore{\centering}%
}%
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@Roman\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{{\bf\tablename~\ifappletter\thesection\fi\thetable}}
\expandafter\newbox\csname fbox@\ftype@table\endcsname
\expandafter\setbox\csname fbox@\ftype@table\endcsname\hbox{}%
\def\listoftables{\print@toc{lot}}%
\let\l@table\l@figure
\def\table@hook{\small}%
\def\squeezetable{\def\table@hook{\scriptsize}}%
\appdef\@floatboxreset{\table@hook}%

\newenvironment{turnpage@anchored}{%
 \onecolumngrid@push
 \setbox\z@\vbox to\textwidth\bgroup
  \columnwidth\textheight
}{%
  \vfil
 \egroup
 \rotatebox{90}{\box\z@}%
 \onecolumngrid@pop
}%
\newenvironment{video}
 {\@float{video}}
 {\end@float}%
\newenvironment{video*}
 {\@dblfloat{video}}
 {\end@dblfloat}%
\newcounter{video}
\renewcommand \thevideo {\@arabic\c@video}
\def\ext@video{lov}%
\def\fname@video{Video}%
\def\lovname{List of Videos}%
\def\fps@video{tbp}%
\def\ftype@video{4}%
\def\fnum@video{\fname@video~\thevideo}%
\appdef\document@inithook{%
 \@ifxundefined\c@float@type{}{%
  \global\setcounter{float@type}{8}%
 }%
}%
\expandafter\newbox\csname fbox@\ftype@video\endcsname
\expandafter\setbox\csname fbox@\ftype@video\endcsname\hbox{}%
\let\theHvideo\thevideo
\def\listofvideos{\print@toc{lov}}%
\let\l@video\l@figure

\def\endtabular@hook{}%
\appdef\document@inithook{%
 \@ifpackageloaded{dcolumn}{%
  \expandafter\@ifnotrelax\csname NC@find@d\endcsname{}{%
   \newcolumntype{d}{D{.}{.}{-1}}%
  }%
 }{}%
}%

\def\toprule{\hline\hline}%
\def\colrule{\hline}%
\def\botrule{\hline\hline}%

\newenvironment{ruledtabular}{%
 \def\array@default{v}%
 \appdef\tabular@hook{\def\@halignto{to\hsize}}%
 \let\tableft@skip@default\tableft@skip
 \let\tableft@skip\tableft@skip@float
 \let\tabmid@skip@default\tabmid@skip
 \let\tabmid@skip\tabmid@skip@float
 \let\tabright@skip@default\tabright@skip
 \let\tabright@skip\tabright@skip@float
 \let\array@row@pre@default\array@row@pre
 \let\array@row@pre\array@row@pre@float
 \let\array@row@pst@default\array@row@pst
 \let\array@row@pst\array@row@pst@float
 \appdef\array@row@rst{%
  \let\array@row@pre\array@row@pre@default
  \let\array@row@pst\array@row@pst@default
  \let\tableft@skip\tableft@skip@default
  \let\tabmid@skip\tabmid@skip@default
  \let\tabright@skip\tabright@skip@default
  \appdef\tabular@hook{\let\@halignto\@empty}%
 }%
}{%
}%
\def\@makefnmark{%
 \leavevmode{%
  \@textsuperscript{%
   \normalfont\@thefnmark
  }%
 }%
}%
\expandafter\DeclareRobustCommand
\expandafter\rev@citet
\expandafter{%
 \expandafter\begingroup
  \expandafter\rtx@swap@citea
  \expandafter\g@bblefirsttoken
              \csname citet \endcsname
}%
\expandafter\DeclareRobustCommand
\expandafter\rev@citealp
\expandafter{%
 \expandafter\begingroup
  \expandafter\rtx@swap@citea
  \expandafter\g@bblefirsttoken
              \csname citealp \endcsname
}%
\expandafter\DeclareRobustCommand
\expandafter\rev@citealpnum
\expandafter{%
 \expandafter\begingroup
  \expandafter\rtx@swap@citenum
  \expandafter\g@bblefirsttoken
              \csname citealp \endcsname
}%
\def\rtx@swap@citenum{%
  \rtx@swap@citea
  \let\@cite\NAT@citenum
  \let\NAT@mbox\mbox
  \let\citeyear\NAT@citeyear
  \let\NAT@space\NAT@spacechar
}%
\def\g@bblefirsttoken{%
 \expandafter\true@sw
 \expandafter\@empty
}%
\newcommand\rtx@citesuper[3]{%
 \ifNAT@swa
  \leavevmode
  \unskip
  \textsuperscript{\normalfont#1}%
  \if*#3*\else\ (#3)\fi
 \else
  #1%
 \fi
 \endgroup
}%
\def\@makefnmark@cite{\begingroup\NAT@swatrue\@cite{{\@thefnmark}}{}{}}%

\def\rtx@swap@citea{%
 \let\NAT@def@citea\rtx@def@citea
 \let\NAT@def@citea@close\rtx@def@citea@close
 \let\NAT@def@citea@box\rtx@def@citea@box
}%
\def\rtx@def@citea{%
 \def\@citea{\NAT@separator\NAT@space}%
 \advance\c@NAT@ctr\@ne
 \@ifnum{\count@>\tw@}{%
  \@ifnum{\c@NAT@ctr=\count@}{\appdef\@citea{\NAT@conj\NAT@space}}{}%
 }{%
  \def\@citea{\NAT@space\NAT@conj\NAT@space}%
 }%
}%
\def\rtx@def@citea@close{%
 \rtx@def@citea
 \prepdef\@citea{\NAT@@close}%
}%
\def\rtx@def@citea@box{%
 \rtx@def@citea@close
 \expandafter\def\expandafter\@citea\expandafter{\expandafter\NAT@mbox\expandafter{\@citea}}%
}%
\def\NAT@conj{and}%
\def\NAT@BibitemShut#1{%
 \def\@bibstop{#1}%
 \let\bibitem@Stop\bibitemStop
 \let\bibitem@NoStop\bibitemNoStop
 \@ifx{\bibitemShut\relax}{\let\@bibitemShut\@empty}{%
  \expandafter\def\expandafter\@bibitemShut\expandafter{\bibitemShut}%
 }%
}%
\def\BibitemShut@ltx#1{%
 \unskip
 \def\@bibstop{#1}%
 \let\bibitem@Stop\bibitemStop
 \let\bibitem@NoStop\bibitemNoStop
 \@ifx{\bibitemShut\relax}{\let\@bibitemShut\@empty}{%
  \expandafter\def\expandafter\@bibitemShut\expandafter{\bibitemShut}%
 }%
}%

 \newenvironment{thebibliography}{}{}%

\let\@listi\@empty
\appdef\rtx@require@packages{%
 \RequirePackage[sort&compress]{natbib}[2009/11/07 8.31a (PWD, AO)]%
 \let@environment{NAT@thebibliography}{thebibliography}%
 \let@environment{thebibliography}{rtx@thebibliography}%
 \let\bibliographystyle@latex\bibliographystyle
 \let\NAT@citesuper\rtx@citesuper
\let\bibsection\rtx@bibsection
\let\NATx@bibsetnum\NAT@bibsetnum
\def\NAT@bibsetnum#1{%
 \setlength{\topsep}{\z@}%
 \NATx@bibsetnum{\ref{LastBibItem}}%
}%
\let\NATx@bibsetup\NAT@bibsetup
\def\NAT@bibsetup{%
 \setlength{\labelwidth}{\z@}%
 \setlength{\labelsep}{\z@}%
 \setlength{\itemindent}{\z@}%
 \setlength{\listparindent}{\z@}%
 \setlength{\topsep}{\z@}%
 \setlength{\parsep}{\z@}%
 \NATx@bibsetup
}%
\let\bibpreamble\@empty
\def\newblock{\ }%
\let\NATx@bibnumfmt\bibnumfmt
\def\bibnumfmt{\place@bibnumber}%
\let\NAT@merge\thr@@
\let\NAT@citeyear\citeyear
\let\onlinecite\rev@citealp
\let\textcite\rev@citet
\@ifx{\BibitemShut\NAT@BibitemShut}{%
 \class@info{Repairing natbib's \string\BibitemShut}%
 \let\BibitemShut\BibitemShut@ltx
}{}%

\let\bibliographystyle@latex\bibliographystyle

\def\NAT@bibitem@cont{%
 \let\bibitem@Stop\bibitemContinue@Stop
 \let\bibitem@NoStop\bibitemContinue
}%
\def\bibitemNoStop{%
 \@ifx@empty\@bibitemShut{.\spacefactor\@mmm\space}{\@bibitemShut}%
}%
\def\bibitemContinue{%
 \@ifx@empty\@bibitemShut{;\spacefactor\@mmm\space}{\@bibitemShut}%
}%
\def\bibitemContinue@Stop{%
 \@ifx@empty\@bibitemShut{\spacefactor\@mmm\space}{\@bibitemShut}%
}%
}%
\DeclareRobustCommand\onlinecite{\@onlinecite}%
\DeclareRobustCommand\textcite{\@textcite}%


\def\write@bibliographystyle{%
 \@ifxundefined\@bibstyle{}{%
  \expandafter\bibliographystyle@latex\expandafter{\@bibstyle}%
  %\bibliographystyle@sw{}{\@bibdataout@rev}%
 }%
 \global\let\write@bibliographystyle\relax
}%

 \AtEndDocument{\write@bibliographystyle}%

\def\rtx@@citetp[#1]{\@ifnextchar[{\rtx@citex[#1]}{\rtx@citex[][#1]}}%
\def\rtx@citex[#1][#2]#3{%
 \begingroup
  \def\@tempa{[#1][#2]{#3}}%
  \@ifx{\@cite\NAT@citesuper}{%
   \leavevmode
   \skip@\lastskip
   \unskip
   \super@cite@let
  }{%
   \super@cite@end
  }%
}%
\def\super@cite@let{%
 \futurelet\@let@token\super@cite@check
}%
\def\super@cite@end{%
 \aftergroup\@citex\expandafter\endgroup\@tempa
}%
\def\super@cite@check{%
 \@ifx{\@let@token\@sptoken}{%
  \super@cite@end
 }{%
  \super@cite@swap
 }%
}%
\long\def\super@cite@swap#1{%
 \expandafter\@ifx\expandafter{\csname rtx@automove#1\endcsname\@empty}{%
  #1%
  \super@cite@let
 }{%
  \super@cite@end
  #1%
 }%
}%
\expandafter\let\csname rtx@automove.\endcsname\@empty
\expandafter\let\csname rtx@automove,\endcsname\@empty
\expandafter\let\csname rtx@automove:\endcsname\@empty
\expandafter\let\csname rtx@automove;\endcsname\@empty

\appdef\class@documenthook{%
 \citeautoscript@sw{%
  \@ifx{\@cite\NAT@citesuper}{%
   \let\NAT@@citetp\rtx@@citetp
  }{}%
 }{}%
}%
\def\mini@note{\save@note\mini@notes}%Implicit #2
\def\save@note#1#2{%
  \stepcounter\@mpfn
  \protected@xdef\@thefnmark{\thempfn}%
  \@footnotemark
  \expandafter\g@addto@macro
  \expandafter#1%
  \expandafter{%
  \expandafter \@@footnotetext
  \expandafter {\@thefnmark}{#2}%
              }%
}%
\long\def\@@footnotetext#1{\def\@thefnmark{#1}\@footnotetext}%
\let\mini@notes\@empty
\def\rev@citemark#1{%
 \expandafter\cite\expandafter{\@thefnmark}%
}%
\def\rev@endtext#1{%
 \let\@endnotelabel\@thefnmark
 \@endnotetext
}%
\def\endnote@ext{.end}%
\def\bibdata@app{Notes}%
\def\bibdata@ext{bib}%
\long\def\@endnotetext#1{%
  \begingroup
    \endnote@relax
    \immediate\write\@bibdataout{%
     @FOOTNOTE{%
      \@endnotelabel,%
      key="\@endnotelabel",%
      note="#1"%
     }%
    }%
  \endgroup
}%


\def\endnote@relax{%
 \let\label\relax \let\index\relax \let\glossary\relax
 \let\cite \relax \let\ref  \relax \let\pageref \relax
 \let\(    \relax \let\)    \relax \let\\       \relax
 \let~\relax
 \let \protect \@unexpandable@protect
 \newlinechar`\^^M%
 \let\begin\relax \let\end\relax
}%


\def\make@footnote@endnote{%
 \footinbib@sw{%
  \authoryear@sw{}{%
   \ltx@footnote@push
   \def\thempfn{Note\thefootnote}%
   \let\ltx@footmark\rev@citemark
   \let\ltx@foottext\rev@endtext
  }%
 }{}%
}%
\def\ltx@footnote@push{%
 \let\ltx@footmark@latex\ltx@footmark
 \let\ltx@foottext@latex\ltx@foottext
 \let\thempfn@latex\thempfn
 \def\ltx@footnote@pop{%
  \let\ltx@footmark\ltx@footmark@latex
  \let\ltx@foottext\ltx@foottext@latex
  \let\thempfn\thempfn@latex
 }%
}%
\appdef\class@documenthook{%
 \make@footnote@endnote
}%

\def\thepage{\@arabic\c@page}%
\appdef\setup@hook{%
 \tabbingsep \labelsep
 \leftmargin\leftmargini
 \labelwidth\leftmargin\advance\labelwidth-\labelsep
 \let\@listi\@listI
 \@listi
}%
\appdef\class@documenthook{%
 \global\c@page\@ne
 \def\curr@envir{document}%
 \mark@envir{\curr@envir}%
}%
\def\open@onecolumn{%
 \open@column@one\@ne
 \set@colht
 \@floatplacement
 \@dblfloatplacement
}%
\def\open@twocolumn{%
 \open@column@mlt\tw@
 \set@colht
 \@floatplacement
 \@dblfloatplacement
 \sloppy
 \let\set@listindent\set@listindent@
}%

\def\title@column#1{%
 \minipagefootnote@init
 #1%
 \minipagefootnote@foot
}%
\def\close@column{%
 \newpage
}%


\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\def\partname{Part}
\def\tocname{Contents}
\def\lofname{List of Figures}
\def\lotname{List of Tables}
\def\refname{References}
\def\indexname{Index}
\def\figurename{Figure}
\def\figuresname{Figures}%
\def\tablename{Table}
\def\tablesname{Tables}%
\def\abstractname{Abstract}
\def\appendixesname{Appendixes}%
\def\appendixname{Appendix}%
\def\acknowledgmentsname{ACKNOWLEDGMENTS}
\def\journalname{??}
\def\copyrightname{??}
\def\andname{and}
\def\ppname{pp}
\def\numbername{number}
\def\volumename{volume}
\def\Dated@name{Dated: }%
\def\Received@name{Received }%
\def\Revised@name{Revised }%
\def\Accepted@name{Accepted }%
\def\Published@name{Published }%

\def\address{\replace@command\address\affiliation}%
\def\altaddress{\replace@command\altaddress\altaffiliation}%


%
\def\tablenote{\replace@command\tablenote\footnote}%

\DeclareRobustCommand\text[1]{%
 \relax
 \ifmmode
  \mathchoice
   {\hbox{{\everymath{\displaystyle     }#1}}}%
   {\hbox{{\everymath{\textstyle        }#1}}}%
   {\hbox{{\everymath{\scriptstyle      }\let\f@size\sf@size\selectfont#1}}}%
   {\hbox{{\everymath{\scriptscriptstyle}\let\f@size\ssf@size\selectfont#1}}}%
  \glb@settings
 \else
  \mbox{#1}%
 \fi
}%
\DeclareRobustCommand\REV@bbox[1]{%
 \relax
 \ifmmode
  \mathchoice
   {\hbox{{\everymath{\displaystyle     }\boldmath$#1$}}}%
   {\hbox{{\everymath{\textstyle        }\boldmath$#1$}}}%
   {\hbox{{\everymath{\scriptstyle      }\boldmath$#1$}}}%
   {\hbox{{\everymath{\scriptscriptstyle}\boldmath$#1$}}}%
  \glb@settings
 \else
  \mbox{#1}%
 \fi
}%
\DeclareRobustCommand\REV@bm[1]{%
 \class@warn@end{To use \string\bm, please load the bm package!}%
 \global\let\bm\relax
}%

\newenvironment{quasitable}{%
 \let@environment{tabular}{longtable}%
}{%
}%
\let\bm\REV@bm

\appdef\setup@hook{%
\iflongbib
 \renewcommand\bibinfo[2]{#2}%
\else
 \renewcommand\bibinfo[2]{\unskip\unskip\unskip}%
\fi
 \providecommand\eprint[2][]{#2}%
}%

%
\def\REVSYMB@warn#1{\PackageWarningNoLine{revsymb}{#1}}%
\DeclareRobustCommand\lambdabar{%
  \bgroup
    \def\@tempa{%
      \hbox{%
        \raise.73\ht\z@
        \hb@xt@\z@{%
          \kern.25\wd\z@
          \vrule \@width.5\wd\z@\@height.1\p@\@depth.1\p@
          \hss
        }%
        \box\z@
      }%
    }%
    \mathchoice
      {\setbox\z@\hbox{$\displaystyle     \lambda$}\@tempa}%
      {\setbox\z@\hbox{$\textstyle        \lambda$}\@tempa}%
      {\setbox\z@\hbox{$\scriptstyle      \lambda$}\@tempa}%
      {\setbox\z@\hbox{$\scriptscriptstyle\lambda$}\@tempa}%
  \egroup
}%
\DeclareRobustCommand\openone{\leavevmode\hbox{\small1\normalsize\kern-.33em1}}%
\DeclareRobustCommand\corresponds{\replace@command\corresponds\triangleq}%
\DeclareRobustCommand\overcirc{\replace@command\overcirc\mathring}%
\DeclareRobustCommand\overdots{\replace@command\overdots\dddot}%
\DeclareRobustCommand\REV@triangleq{%
 {\lower.2ex\hbox{=}}{\kern-.75em^\triangle}%
}%
\DeclareRobustCommand\REV@dddot[1]{%
 \@ontopof{#1}{\cdots}{1.0}\mathord{\box2}%
}%
\DeclareRobustCommand\altsuccsim{\succ\kern-.9em_\sim\kern.3em}%
\DeclareRobustCommand\altprecsim{\prec\kern-1em_\sim\kern.3em}%
\let\REV@succsim\altsuccsim
\let\REV@precsim\altprecsim
\DeclareRobustCommand\REV@lesssim{\mathrel{\mathpalette\vereq{<}}}%
\DeclareRobustCommand\REV@gtrsim{\mathrel{\mathpalette\vereq{>}}}%
\DeclareRobustCommand\alt{\lesssim}
\DeclareRobustCommand\agt{\gtrsim}
\def\vereq#1#2{%
 \lower3\p@\vbox{%
  \baselineskip1.5\p@
  \lineskip1.5\p@
  \ialign{$\m@th#1\hfill##\hfil$\crcr#2\crcr\sim\crcr}%
 }%
}%
\DeclareRobustCommand\tensor[1]{\@ontopof{#1}{\leftrightarrow}{1.15}\mathord{\box2}}
\DeclareRobustCommand\overstar[1]{\@ontopof{#1}{\ast}{1.15}\mathord{\box2}}
\DeclareRobustCommand\loarrow[1]{\@ontopof{#1}{\leftarrow}{1.15}\mathord{\box2}}
\DeclareRobustCommand\roarrow[1]{\@ontopof{#1}{\rightarrow}{1.15}\mathord{\box2}}
\def\@ontopof#1#2#3{%
 {%
  \mathchoice
    {\@@ontopof{#1}{#2}{#3}\displaystyle     \scriptstyle      }%
    {\@@ontopof{#1}{#2}{#3}\textstyle        \scriptstyle      }%
    {\@@ontopof{#1}{#2}{#3}\scriptstyle      \scriptscriptstyle}%
    {\@@ontopof{#1}{#2}{#3}\scriptscriptstyle\scriptscriptstyle}%
 }%
}%
\def\@@ontopof#1#2#3#4#5{%
  \setbox\z@\hbox{$#4#1$}%
  \setbox\f@ur\hbox{$#5#2$}%
  \setbox\tw@\null\ht\tw@\ht\z@ \dp\tw@\dp\z@
  \@ifdim{\wd\z@>\wd\f@ur}{%
    \setbox\f@ur\hb@xt@\wd\z@{\hss\box\f@ur\hss}%
    \mathord{\rlap{\raise#3\ht\z@\box\f@ur}\box\z@}%
  }{%
    \setbox\f@ur\hb@xt@.9\wd\f@ur{\hss\box\f@ur\hss}%
    \setbox\z@\hb@xt@\wd\f@ur{\hss$#4\relax#1$\hss}%
    \mathord{\rlap{\copy\z@}\raise#3\ht\z@\box\f@ur}%
  }%
}%

\def\Bigglb{\REV@boldopen \Bigg}%
\def\Biglb {\REV@boldopen \Big }%
\def\bigglb{\REV@boldopen \bigg}%
\def\biglb {\REV@boldopen \big }%
\def\Biggrb{\REV@boldclose\Bigg}%
\def\Bigrb {\REV@boldclose\Big }%
\def\biggrb{\REV@boldclose\bigg}%
\def\bigrb {\REV@boldclose\big }%
\def\REV@pmb#1{%
 \hbox{%
  \setbox\z@=\hbox{#1}%
  \kern-.02em\copy\z@\kern-\wd\z@
  \kern .04em\copy\z@\kern-\wd\z@
  \kern-.02em
  \raise.04em\copy\z@
 }%
}%
\def\REV@boldopen #1#2{\mathopen {\REV@pmb{$#1#2$}}}%
\def\REV@boldclose#1#2{\mathclose{\REV@pmb{$#1#2$}}}%
\def\revsymb@inithook{%
 \@ifxundefined\dddot{\let\dddot\REV@dddot}{}%
 \@ifxundefined\triangleq{\let\triangleq\REV@triangleq}{}%
 \@ifxundefined\succsim{\let\succsim\altsuccsim}{}%
 \@ifxundefined\precsim{\let\precsim\altprecsim}{}%
 \@ifxundefined\lesssim{\let\lesssim\REV@lesssim}{}%
 \@ifxundefined\gtrsim {\let\gtrsim \REV@gtrsim }{}%
 \@ifxundefined\mathbb{\let\mathbb\REV@mathbb}{}%
}%


\appdef\class@documenthook{\revsymb@inithook}%
%%
\def\@startflt#1{%
  \begingroup
    %\toc@pre
    \makeatletter
    \@input{\jobname.#1}%
    \if@filesw
      \expandafter\newwrite\csname tf@#1\endcsname
      \immediate\openout \csname tf@#1\endcsname \jobname.#1\relax
    \fi
    \@nobreakfalse
    %\toc@post
  \endgroup
}%
\def\att@TOC{toc}%
\def\print@toc#1{%
 \begingroup
  \expandafter\section
  \expandafter*%
  \expandafter{%
              \csname#1name\endcsname
              }%
  \let\appendix\appendix@toc
  \def\tempa{#1}%
  \ifx\tempa\att@TOC%%
  \@starttoc{#1}%
  \else%%
  \@startflt{#1}%%
  \fi%%
 \endgroup
}%

\appdef\rtx@require@packages{%
 \InputIfFileExists{\jobname.rty}{}{}%
}%


  \iftwelvepoint
      \iflongauthor
         \ExecuteOptions{unsortedaddress,12pt,onecolumn,onecolappendix,letteredappendix}
     \else
        \ExecuteOptions{superscriptaddress,12pt,onecolumn,onecolappendix,letteredappendix}
     \fi
  \else %not twelvepoint
     \iflongauthor
         \ExecuteOptions{unsortedaddress,10pt,onecolumn,onecolappendix,letteredappendix}
     \else
        \ExecuteOptions{superscriptaddress,10pt,onecolumn,onecolappendix,letteredappendix}
    \fi
  \fi


\@options
\rtx@require@packages
\setup@hook


%%%%%%%%%%%%%%%%%%%%

\def\blankaffiliation{~}%
\def\@eapj@cap@font{\bfseries}
\def\@eapj@figname{Figure}
\def\@eapj@tabname{Table}

% Restore natbib package without sorting. 
\def\NAT@sort{0}
\def\NAT@cmprs{0}

% only redefine sort@cites for natbib versions < 2009
\@ifundefined{NAT@sort@cites@}{\def\NAT@sort@cites#1{\edef\NAT@cite@list{#1}}}%

\RequirePackage{latexsym}% 
\RequirePackage{amssymb}% 

\newcommand{\bibstyle@aas}{\bibpunct{(}{)}{;}{a}{}{,}}% 
\@citestyle{aas}% 

%\def\baselinestretch{1.0}

%% Default vertical space between horizontal lines. Can change definition
%% of arraystretch in the body of the paper; either for full article or
%% for a single table.
\AtBeginDocument{\def\arraystretch{1}}

%% needed?
\def\raggedcolumn@sw#1#2{#2}  % implement flushbottom as it was in revtex4

\RequirePackage{epsf,graphicx}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tighten only works with two column styles:
\if@twocolumn\else\global\tightenfalse\fi

%%% preprint, preprint2, manuscript are 12pt
%% Modified bk12.clo
\iftwelvepoint

\renewcommand\normalsize{%
\ifdoublespace % manuscript
  \iftighten
   \@setfontsize\normalsize\@xiipt{20}%
  \else
   \@setfontsize\normalsize\@xiipt{24}%
  \fi
\else
  \iftighten
   \@setfontsize\normalsize\@xiipt{13}%
   \else
      \ifmodern
      \@setfontsize\normalsize\@xiipt{16}%
      \else
        \@setfontsize\normalsize\@xiipt{15}%
      \fi
   \fi
\fi %% end doublespace/no double space
   \abovedisplayskip 12\p@ \@plus3\p@ \@minus7\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}

\normalsize

\newcommand\small{%
\ifdoublespace % manuscript
   \@setfontsize\small\@xipt{20}%
\else
\ifmodern
   \@setfontsize\small\@xipt{12}%
\else
   \@setfontsize\small\@xipt{13.6}%
\fi\fi
%% end doublespace/no double space
   \abovedisplayskip 11\p@ \@plus3\p@ \@minus6\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 9\p@ \@plus3\p@ \@minus5\p@
               \parsep 4.5\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}

\newcommand\footnotesize{%
\ifdoublespace % manuscriptstyle
   \@setfontsize\footnotesize\@xpt{18}
\else
   \ifmodern
   \@setfontsize\footnotesize\@xpt{11}%
   \else
   \@setfontsize\footnotesize\@xpt\@xiipt
\fi\fi
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 6\p@ \@plus2\p@ \@minus2\p@
               \parsep 3\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\ifdoublespace % manuscript style
\newcommand\scriptsize{\@setfontsize\scriptsize\@viiipt{14}}
\newcommand\tiny{\@setfontsize\tiny\@vipt{10}}
\newcommand\large{\@setfontsize\large\@xivpt{18}}
\newcommand\Large{\@setfontsize\Large\@xviipt{22}}
\newcommand\LARGE{\@setfontsize\LARGE\@xxpt{25}}
\newcommand\huge{\@setfontsize\huge\@xxvpt{30}}
\else
\newcommand\scriptsize{\@setfontsize\scriptsize\@viiipt{9.5}}
\newcommand\tiny{\@setfontsize\tiny\@vipt\@viipt}
\newcommand\large{\@setfontsize\large\@xivpt{22}}
\newcommand\Large{\@setfontsize\Large\@xviipt{24}}
\newcommand\LARGE{\@setfontsize\LARGE\@xxpt{28}}
\newcommand\huge{\@setfontsize\huge\@xxvpt{30}}
\fi
\let\Huge=\huge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\else %% not twelvepoint, now tenpoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% no doublespace here, because the only doublespace is in `manuscript style' which is 12pt

\renewcommand\normalsize{%
\iftighten
   \@setfontsize\normalsize\@xpt{11.5}%
\else
   \@setfontsize\normalsize\@xpt{12.5}%
\fi
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}

\normalsize

\newcommand\small{%
\iftighten
   \@setfontsize\small\@ixpt{12}%
\else
   \@setfontsize\small\@ixpt{11}%
\fi
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}

\newcommand\footnotesize{%
\iftighten
   \@setfontsize\footnotesize\@viiipt{9}%
\else
   \@setfontsize\footnotesize\@viiipt{9.5}% standard eightpoint size
\fi
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}

%% Standard 10pt font sizes
\newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}
\newcommand\Large{\@setfontsize\Large\@xivpt{18}}
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\newcommand\huge{\@setfontsize\huge\@xxpt{25}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

\fi

%% End font sizes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
\setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\headheight{12\p@}

\def\@listi{\leftmargin\leftmargini
            \parsep 4\p@ \@plus2\p@ \@minus\p@
            \topsep 8\p@ \@plus2\p@ \@minus4\p@
            \itemsep4\p@ \@plus2\p@ \@minus\p@}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    4\p@ \@plus2\p@ \@minus\p@
              \parsep    2\p@ \@plus\p@  \@minus\p@
              \itemsep   \parsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    2\p@ \@plus\p@\@minus\p@
              \parsep    \z@
              \partopsep \p@ \@plus\z@ \@minus\p@
              \itemsep   \topsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}

%  ****************************************************
%  *             TWO AND SINGLE ONE COLUMN STYLES: AV *
%  ****************************************************
%

%%%%% include atbeginend.sty by AV:

% Copy \begin and \end to \BeginEnvironment and \EndEnvironment
\let\BeginEnvironment=\begin
\let\EndEnvironment=\end
%% \ifundefined from TeXbook
\def\IfUnDef#1{\expandafter\ifx\csname#1\endcsname\relax}
% Null command needed to eat its argument
\def\NullCom#1{}
\def\begin#1{%
% if defined \BeforeBeg for this environment, execute it
\IfUnDef{BeforeBeg#1}\else\csname BeforeBeg#1\endcsname\fi%
\IfUnDef{AfterBeg#1}% This is done to skip the command for environments
                     % which can take arguments, like multicols; YOU MUST NOT
                     % USE \AfterBegin{...}{...} for such environments! 
        \let\SaveBegEnd=\BeginEnvironment%
\else
        % Start this environment
                \BeginEnvironment{#1}%
        % and execute code after \begin{environment}
                \csname AfterBeg#1\endcsname
        \let\SaveBegEnd=\NullCom
\fi%
\SaveBegEnd{#1}%
}
\def\end#1{%
% execute code before \end{environment}
\IfUnDef{BeforeEnd#1}\else\csname BeforeEnd#1\endcsname\fi%
% close this environment
\EndEnvironment{#1}%
% and execute code after \begin{environment}
\IfUnDef{AfterEnd#1}\else\csname AfterEnd#1\endcsname\fi%
}
\long\def\BeforeBegin#1#2{\expandafter\gdef\csname BeforeBeg#1\endcsname {#2}}
\long\def\BeforeEnd  #1#2{\expandafter\gdef\csname BeforeEnd#1\endcsname {#2}}
\long\def\AfterBegin #1#2{\expandafter\gdef\csname AfterBeg#1\endcsname {#2}}
\long\def\AfterEnd   #1#2{\expandafter\gdef\csname AfterEnd#1\endcsname{#2}}

%%%% end of atbeginend.sty

%  ****************************************
%  *            PAGE LAYOUT               *
%  ****************************************

% Page size, spacing parameters, etc. 

\textwidth=7.1in
\columnsep=0.3125in
\parindent=0.125in
\voffset=-20mm
\hoffset=-7.5mm

\topmargin=0in
\headheight=.15in
\headsep=0.5in
\oddsidemargin=0in
\evensidemargin=0in
\parskip=0cm

\tolerance=600          % 3x "normal" value; cuts down on overfull complaints

%% AV,MM, to have 64 lines per column, with textheight 25cm:
\textheight=64\baselineskip
\textheight=\baselinestretch\textheight
\ifdim\textheight>25.2cm\textheight=25.0cm\fi

%% so that the margin at the bottom of the page is about equal to margin at top. -- AH
\advance\textheight -54pt

\topskip\baselineskip
\maxdepth\baselineskip



\def\eqsecnum{
    \@newctr{equation}[section]
    \def\theequation{\hbox{\normalsize\arabic{section}-\arabic{equation}}}}

%% running heads:
\def\lefthead#1{\gdef\@versohead{#1}} \lefthead{\relax}
\def\righthead#1{\ifanonymous\gdef\@rectohead{Anonymous author(s)}\else\gdef\@rectohead{#1}\fi} \righthead{\relax}
\let\shorttitle\lefthead
\let\shortauthors\righthead

\def\ps@apjheads{\let\@mkboth\markboth
     \def\@evenfoot{}
    \def\@evenhead{\lower9mm\hbox to\textwidth{%
                     \rm\thepage\hfill\textsc{\@rectohead}\hfill}}}
    \def\@oddfoot{}
    \def\@oddhead{\lower9mm\hbox to\textwidth{
                     \hfil\rm\textsc{\@versohead}\hfil \rm\thepage}}

\pagestyle{apjheads}

 \@twosidetrue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    TITLE PAGE                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifcorrespauthor
\newif\if@correspauthor

%% October 2017, adding preprint number capability
\newcount\rptnum
\newcount\rptloopnum
\def\reportnum#1{\global\advance\rptnum by 1
\expandafter\gdef\csname report\the\rptnum\endcsname{\hbox to
\textwidth{\hskip.75\textwidth\relax#1\relax\hfill}}}

\def\frontmatter@title@format{\normalsize\bf\centering}
\def\frontmatter@title@below{\vskip8pt}%

\long\def\frontmatter@title@above{
\vbox to 0pt{\vskip-48pt\normalsize\rptloopnum=0\loop
\global\advance\rptloopnum by 1
\expandafter\ifx\csname report\the\rptloopnum\endcsname\relax
\else
\csname report\the\rptloopnum\endcsname
\vskip1pt
\repeat
\vss
}
\ifmodern
\vglue-18pt
{\footnotesize
\raggedright
{\sc Draft version \today}\\[2pt]
{\footnotesize
Typeset using \LaTeX\ {\bf modern} style in AASTeX7}
\par\vspace*{-\baselineskip}\vspace*{0.625in}
}
\else
%%
\ifpreprinttwo
\vspace*{-\headsep}\vspace*{\headheight}
\footnotesize
{\footnotesize\textsc{\@journalinfo}}\par
{\footnotesize Typeset using \LaTeX\ {\bf preprint2} style in AASTeX7}
\par\vspace*{-\baselineskip}\vspace*{0.625in}
\else
%%
\if@twocolumn
\if@correspauthor\vspace*{-16.2pt}\fi%
\vspace*{-\headsep}\vspace*{\headheight}
\footnotesize
{\footnotesize\textsc{\@journalinfo}}\par
{\footnotesize Typeset using \LaTeX\ {\bf twocolumn} style in AASTeX7}
\par\vspace*{-\baselineskip}\vspace*{0.625in}
\else
\preprintsty@sw{
\vspace*{-\headsep}\vspace*{\headheight}
\footnotesize
{\footnotesize\textsc{\@journalinfo}}\par
{\footnotesize Typeset using \LaTeX\ {\bf preprint} style in AASTeX7}
\par\vspace*{-\baselineskip}\vspace*{0.625in}
}{
  \manuscriptsty@sw{%
    \vspace*{-\headsep}\vspace*{\headheight}
    \footnotesize
        {\footnotesize\textsc{\@journalinfo}}\par
        {\footnotesize Typeset using \LaTeX\ {\bf manuscript} style in AASTeX7}
        \par\vspace*{-\baselineskip}\vspace*{0.625in}
  }{
%% Default
\vspace*{-\headsep}\vspace*{\headheight}
\footnotesize
{\footnotesize\textsc{\@journalinfo}}\par
{\footnotesize Typeset using \LaTeX\ {\bf default} style in AASTeX7}%% default style
\par\vspace*{-\baselineskip}\vspace*{0.625in}
}}
\fi\fi\fi
%%
    %% none of this command will be activated.
}%


\newcount\fncount
\newcount\endfncount
\long\def\tempfootnote#1{\global\advance\fncount by 1\relax%
\expandafter\gdef\csname footnote\the\fncount\endcsname{\if@two@col\hsize=.5\textwidth
\advance\hsize by -18pt
\fi\relax#1}}

\def\tempfootnoteintitle#1{}

\long\def\ltx@foottext#1#2{%
 \begingroup
\expandafter\ltx@make@current@footnote\expandafter{\@mpfn}{#1}%
\@footnotetext{\vtop{\if@twocolumn\hsize=.5\textwidth
\advance\hsize-18pt
\fi #2\vskip2pt}}% fixed for two col style, march 15, 2019
 \endgroup
}%


\def\kickoutfootnotes{\c@footnote=0\relax%
\loop\advance\endfncount by 1\relax%
\expandafter\ifx\csname footnote\the\endfncount\endcsname\relax%
\else%
\def\thempfn{\fnsymbol{footnote}}%
\advance\c@footnote by 1\relax%
\unskip\footnote{\csname footnote\the\endfncount\endcsname}%
\repeat}

%% 
\renewcommand\title[2][]{%
\def\@title{\setbox0=\vbox{\let\footnote\tempfootnote #2}%
{\let\footnote\tempfootnoteintitle%\uppercase
{#2}}%% right place for kickoutfootnotes below
\kickoutfootnotes
%\ifdoublespace\vskip 3\baselineskip\fi
}%
 \def\@shorttitle{#1}%
 \let\@AF@join\@title@join
}%



\def\frontmatter@authorformat{\small\advance\baselineskip-3pt
\parskip=0pt\scshape
\ifmodern
\vskip48pt
\centering
\leftskip=.05in plus 1fil
\rightskip=.05in plus 1 fil
\baselineskip=13pt
\else
\centering
\fi
}%


\def\frontmatter@affiliationfont{\normalfont\footnotesize
%% changed october 2017
\it
\iflongauthor\else
\rightskip-12pt plus 1fil
\leftskip6pt \parindent-4pt
\fi
}%


\def\@separator{\\}%

\newcounter{front@matter@foot@note}\setcounter{front@matter@foot@note}{0}


\def\affil@error#1{\@latex@error{^^J^^J^^J^^JThe compiler quit because AASTeX v7 requires all authors to have an affiliation. Please edit your latex file to include a \string\affiliation\space command with  author "#1".^^J^^J^^J^^J}\@ehc\stop}

\def\email@error#1{\@latex@error{^^J^^J^^J^^JThe compiler quit because AASTeX v7 requires all authors to have an email address. Please edit your latex file to include a \string\email\space command with author "#1".^^J^^J^^J^^J}\@ehc\stop}


\iflongauthor%
\renewcommand\affiliation[1]{%
\parskip=2pt\expandafter\gdef\csname affil@\romannumeral\the\allauthorcnt\endcsname{}%
\def\@centercr{\vrule depth 3pt width0pt\vskip1sp}
 \move@AU\move@AF%
\iflongauthor\let\@listand\relax\fi
 \begingroup%
  \@affiliation{%\hspace*{2mm}
\ifnum\countauthors<\AuthorCollaborationLimit
 #1\ifmodern\iflongauthor\baselineskip=12pt\else\vskip2pt\fi\else\baselineskip=11pt
\fi\fi
\ifnum\countauthors=\AuthorCollaborationLimit
 #1\ifmodern\iflongauthor\baselineskip=12pt\else\vskip2pt\fi\else\baselineskip=11pt
\fi\fi
\iflongauthor \vskip-10pt\ifnum\countauthors>\AuthorCollaborationLimit\iftwelvepoint\vskip-3pt\else\if@twocolumn\else\vskip-6pt\fi\fi\fi%
\fi
}%
\let\@centercr\savecentercr}%
\else
%% older version
\renewcommand\affiliation[1]{%
 \expandafter\gdef\csname affil@\romannumeral\the\allauthorcnt\endcsname{}%
 \move@AU\move@AF%
 \begingroup%
  \@affiliation{%
\centering%
#1%
\ifmodern%
 \baselineskip=9.5pt%
\else%
  \iftwelvepoint%
   \ifpreprinttwo\else%
     \preprintsty@sw{}{\baselineskip19pt}%
     \fi%
   \else%
     \baselineskip=9.5pt%
   \fi%
\fi}%
}%
\fi %% end switch for longauthor

%   ABSTRACT
\def\frontmatter@abstractfont{\normalsize\parindent=9pt
}%
%% 
\def\frontmatter@abstractwidth{478pt}

\def\abstractname{ABSTRACT}

\long\def\frontmatter@abstractheading{%
 \begingroup
  \centering
\ifmodern\else\hskip34pt \fi \abstractname
  \vskip 1mm
  \par
 \endgroup
}%

\let\abstract\frontmatter@abstract

\def\frontmatter@abstract@produce{%
  \par
  %% \preprintsty@sw{%
  %%  \do@output@MVL{%
  %%   \vskip\frontmatter@preabstractspace
  %%   \vskip200\p@\@plus1fil
  %%   \penalty-200\relax
  %%   \vskip-200\p@\@plus-1fil
  %%  }%
  %% }{%
    \addvspace{\frontmatter@preabstractspace}%
  %% }%
   \begingroup
    \dimen@\baselineskip
    \setbox\z@\vtop{\unvcopy\absbox}%
    \advance\dimen@-\ht\z@\advance\dimen@-\prevdepth
    \@ifdim{\dimen@>\z@}{\vskip\dimen@}{}%
   \endgroup
   \begingroup
   \prep@absbox
%% centered, oct 2017
\unvbox\absbox
    \post@absbox
   \endgroup
  \@ifx{\@empty\mini@notes}{}{\mini@notes\par}%
  \addvspace\frontmatter@postabstractspace
\global\abstractfalse
\vskip12pt
}%

\newif\ifbib

%  ****************************************
%  *             KEYWORDS                 *
%  ****************************************


\def\@keys@name{\textit{Keywords:}\/~\mbox{}}%

\newlength{\keys@width}
\def\frontmatter@keys@format{\ifmodern\vskip0pt\else\vspace*{0.5mm}\fi%
  \settowidth{\keys@width}{\normalsize\@keys@name}%
\ifmodern\else
\rightskip=0.5in
\leftskip=34pt
\fi
\parindent=0pt%
    \hangindent=\keys@width\hangafter=1\normalsize}%

\def\@keywords@produce#1{%
 \showKEYS@sw{%
  \begingroup%
   \frontmatter@keys@format%
   \@keys@name#1
\vrule depth 12pt width 0pt
\ifnobreakafterkeywords
\vrule depth 24pt width0pt\fi
\par
  \endgroup
 }{%
  \@if@empty{#1}{}{%
   \class@warn{If you want your keywords to appear in your output, use document class option showkeys}%
  }%
 }%
}%

\let\subjectheadings=\keywords


%  ****************************************
%  *             FOOTNOTES                *
%  ****************************************

%% legacy notes and footnote code

% Footnotes on the last page: user issues \lastpagefootnotes. It catches all
% footnotes and issues them before \begin{refernces} or
% \begin{\thebibliography} or \begin{appendix}, whichever comes first,
% at the end of right column.  
\newcounter{lastfootnote}
\let\orig@footnote=\footnote
%
\def\spit@out@footnotes@{\addtocounter{footnote}{-\c@lastfootnote}\vspace*{-\baselineskip}\vspace*{\skip\footins}\bgroup\footnotesize\lastfootnote\par\egroup\let\footnote=\orig@footnote}
%
\let\spit@out@footnotes\relax
%
\long\def\lastpagefootnotes{%
\raggedbottom% Have to use flushbottom with revtex4-1 but it eats away
             % last page footnotes
\setcounter{lastfootnote}{0}
\long\gdef\lastfootnote{\mbox{}}
\let\spit@out@footnotes\spit@out@footnotes@
\long\def\footnote##1{\refstepcounter{lastfootnote}\footnotemark\g@addto@macro\lastfootnote{\\[\footnotesep]\refstepcounter{footnote}\mbox{}\hspace*{3mm}\textsuperscript{\thefootnote}~##1}}
% We need to mess with footnotes in appendix only if it is in a
% different mode (twocol vs onecol) than the main text
\def\mess@with@appendix@footnotes{
\BeforeBegin{appendix}{\spit@out@footnotes\let\spit@out@footnotes\relax}
\BeforeEnd{appendix}{\spit@out@footnotes\let\spit@out@footnotes\relax}
\AfterEnd{appendix}{\let\footnote=\orig@footnote}
}

\if@two@col
  \if@two@col@app\else
    \mess@with@appendix@footnotes
  \fi
\fi

\BeforeBegin{references}{\spit@out@footnotes\let\spit@out@footnotes\relax}
\BeforeBegin{thebibliography}{\spit@out@footnotes\let\spit@out@footnotes\relax}
% in case \lastpagefootnotes were given inside \begin{appendix}\end{appendix},
\AfterEnd{references}{\let\footnote=\orig@footnote}
\AfterEnd{thebibliography}{\let\footnote=\orig@footnote}
}
\let\lastpagefootnote=\lastpagefootnotes

%% probably not needed:
\def\notetoeditor#1{}%   % We do not need notes to editor in the preprint
\def\placetable#1{}%   % We do not need notes to editor in the preprint
\def\placefigure#1{}%   % We do not need notes to editor in the preprint

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifdoublespace %used for manuscript
  \footnotesep 12pt
  \skip\footins 36pt
\else
  \footnotesep 12pt
  \skip\footins 24pt
\fi

\let\footnoterule\relax

\def\@makefntext#1{%
\@ifnum{\pagegrid@col=\@ne}{\onecolumngrid}{}%
\leavevmode\@hangfrom{\hb@xt@3mm{\hss\@makefnmark}~}#1}


%  ****************************************
%  *             SECTIONS                 *
%  ****************************************

\setcounter{secnumdepth}{3}

\newcount\tempsectnum

\newif\if@firstsection \@firstsectiontrue


\def\section{%
\ifanonymous\nocollaboration{0}\fi%
\if@firstsection% 
%% In case no collaboration is listed:
\ifcollaborationon\else\let\doauthor\olddoauthor%
\ifanonymous \else%
\let\allauthors=\oldallauthors\fi%
\fi%
%\edef\currauthorlimit{\the\AuthorCollaborationLimit}
%\collaboration{\currauthorlimit}{}
\maketitle%
\global\@firstsectionfalse%
%     \setcounter{footnote}{\thefront@matter@foot@note}% 
     \let\footnotetext=\old@foot@note@text%
     \let\footnotemark=\old@foot@note@mark%
\ifnobreakafterkeywords%
\ifmodern\vskip24pt%
\else%
\vskip12pt\fi%%
\goodbreak%
\else%
 \clearpage%
\fi%
   \if@two@col%
   \twocolumngrid%
   \fi%
\fi%
\tempsectnum=\the\c@section%
\advance\tempsectnum by 1
\xdef\cref@currentlabel{section \the\tempsectnum}%
    \@startsection{section}{1}{\z@}{9pt plus 1pt minus 1pt}{4pt}{\apjsecfont\center}} 

\def\subsection{\@startsection{subsection}{2}{\z@}{9pt plus 1pt minus 1pt}{4pt}%
  {\normalsize\itshape \center}}

\def\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {2ex plus 1ex minus .2ex}{1ex plus .2ex}{\small\itshape \center}}

\def\paragraph{\@startsection{paragraph}{4}{\z@}%
  {1.5ex plus 1ex minus .2ex}{0pt}{\small\itshape}}

\def\subparagraph{\@startsection{subparagraph}{5}{\z@}%
  {1ex plus 1ex minus .2ex}{-0.5\parindent}{\small\itshape}}


\def\thesection{\arabic{section}}
\def\thesubsection{\thesection.\arabic{subsection}}
\def\thesubsubsection{\thesubsection.\arabic{subsubsection}}
\def\theparagraph{\thesubsubsection.\arabic{paragraph}}
\def\p@section        {}
\def\p@subsection     {}
\def\p@subsubsection  {}
\def\p@paragraph      {}
\def\p@subparagraph   {}


\def\sec@upcase#1{\uppercase{#1}}
\def\subsec@upcase#1{\relax{#1}}

%
% How the section number will appear in the section title - AV
\def\ApjSectionMarkInTitle#1{#1.\ }
\def\ApjSectionpenalty{\@M}


\def\@sect#1#2#3#4#5#6[#7]#8%
{\ifnum#2=1\setbox0=\hbox{\def\label##1{\gdef\templabel{##1}}#7}\fi
\@tempskipa #5\relax 
 \ifdim \@tempskipa >\z@ \begingroup
     #6\relax 
  \ifnum #2>\c@secnumdepth \def \@svsec {}\else 
    \refstepcounter{#1} \edef \@svsec {\ApjSectionMarkInTitle 
    {\csname the#1\endcsname}}\fi
  \@hangfrom {\hskip #3\relax 
    \ifnum #2=1{\secnum@size {\rm\@svsec~}}%
    \else {\subsecnum@size {\rm\@svsec~}}\fi }%
  {\interlinepenalty \@M 
   \ifnum #2=1\sec@upcase{#8}%
   \else \subsec@upcase{#8}\fi\par}\endgroup 
  \csname #1mark\endcsname {#7}\addcontentsline{toc}{#1}%
  {\ifnum #2>\c@secnumdepth \else \protect \numberline 
     {\csname the#1\endcsname }\fi #7}%
  \else 
  \ifnum #2>\c@secnumdepth \def \@svsec {}\else 
    \refstepcounter{#1} \edef \@svsec {\ApjSectionMarkInTitle 
    {\csname the#1\endcsname}}\fi
    \def \@svsechd {#6\hskip #3%
    \ifnum #2=1{\secnum@size{\rm\@svsec~}}\else{\subsecnum@size{\rm\@svsec~}}\fi%
    \ifnum #2=1\sec@upcase{#8}\else\subsec@upcase{#8}\fi%
    \ifnum #2=4\hskip 0.4ex{\rm ---}\fi%
     \csname #1mark\endcsname {#7}\addcontentsline{toc}{#1}%
      {\ifnum #2>\c@secnumdepth \else \protect \numberline {\csname
      the#1\endcsname }\fi #7}}\fi \@xsect {#5} \penalty \ApjSectionpenalty
%-refstepcounter is now within a group. So \@currentlabel, which is normally
%-set by \refstepcounter is hidden within a group. Need to set it manually. 
\protected@edef\@currentlabel{\csname p@#1\endcsname\csname
the#1\endcsname} 
\expandafter\ifx\csname templabel\endcsname\relax
\let\go\relax
\else
\def\go{\label{\templabel}}\fi\go
\let\templabel\relax
}

\def\@ssect#1#2#3#4#5{\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M
       \sec@upcase{#5}\par}\endgroup
   \else \def\@svsechd{#4\hskip #1\relax \sec@upcase{#5}}\fi
    \@xsect{#3}
% MM:
\penalty \ApjSectionpenalty}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% changed to begin...end form, May 20,2020, AH
%% Acknowledgments, use \begin{acknowledgments}...\end{acknowledgments}
%% or \begin{acknowledgements}...\end{acknowledgements}

{\catcode`#=12
\gdef\hashmark{#}}

\def\xacknowledgments{acknowledgments}
\def\xacknowledgements{acknowledgements}
\newbox\ackbox

\def\acknowledgments{\@ifnextchar[{\@acknowledgments}{\@acknowledgments[acknowledgments]}}%

\def\@acknowledgments[#1]{%
\ifx\@currenvir\xacknowledgments\let\go\relax\else
\let\go\stop
\typeout{x^^J^^J^^J^^J^^J^^J^^J^^J
 ===================^^J
In AASTeX v6.3.1 the \string\acknowledgments\space command has been deprecated.^^J^^J
Instead, please use the begin/end form:^^J^^J
"\string\begin\string{acknowledgments\string}...\string\end\string{acknowledgments\string}"^^J^^J 
when using acknowledgments.^^J^^J See here:
\url{https://journals.aas.org/aastexguide/\hashmark acknowledgments}
^^J^^J
 for more
details.^^J
 ===================^^J
}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printed error
\vskip12pt
\hrule height 1pt
\vskip12pt
\noindent ERROR:
In AASTeX v6.3.1 the {\tt\string\acknowledgments} command has been
deprecated.\\
Instead, please use the begin/end form:\\
{\tt
\string\begin\string{acknowledgments\string}...\string\end\string{acknowledgments\string}}\\
when using acknowledgments. For more details, see:\\ 
\url{https://journals.aas.org/aastexguide/\hashmark acknowledgments}
%
\fi\go
%%
\ifanonymous
\global\setbox\ackbox=\vbox\bgroup
\expandafter\ifx\csname internallinenumbers\endcsname\relax\else
\begin{internallinenumbers}
\fi
\fi%
\vskip 5.8mm plus 1mm minus 1mm			% 
\vskip1sp
\section*{#1}
\noindent\ignorespaces}

\def\endacknowledgments{
\ifanonymous\expandafter\ifx\csname internallinenumbers\endcsname\relax\else
\end{internallinenumbers}
\fi
\egroup\fi%% completes ackbox
\ifanonymous
\vskip 5.8mm plus 1mm minus 1mm
\vskip1sp
%\section*{Acknowledgments}
\centerline{(Acknowledgments anonymized for review)}
\else
\unvbox\ackbox
\fi\vskip6pt}

%%%alternate spelling
\def\acknowledgements{\@ifnextchar[{\@acknowledgements}{\@acknowledgements[acknowledgements]}}%

\def\@acknowledgements[#1]{%
\ifx\@currenvir\xacknowledgements\let\go\relax\else
\let\go\stop
\typeout{x^^J^^J^^J^^J^^J^^J^^J^^J
 ===================^^J
In AASTeX v6.3.1 the \string\acknowledgements\space command has been deprecated.^^J^^J
Please use the begin/end form:^^J^^J
"\string\begin\string{acknowledgements\string}...\string\end\string{acknowledgements\string}"^^J^^J 
when using acknowledgements.^^J^^J See here:
\href{https://journals.aas.org/aastexguide/\hashmark acknowledgments}
{https://journals.aas.org/aastexguide/\hashmark acknowledgments}
^^J^^J
 for more
details.^^J
 ===================^^J
}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printed error
\vskip12pt
\hrule height 1pt
\vskip12pt
\noindent ERROR:
In AASTeX v6.3.1 the {\tt\string\acknowledgements} command has been
deprecated.\\
Instead, please use the begin/end form:\\
{\tt
\string\begin\string{acknowledgements\string}...\string\end\string{acknowledgements\string}}\\
For more details, see:\\ 
\url{https://journals.aas.org/aastexguide/\hashmark acknowledgments}
%
\fi\go
%%
\ifanonymous
\global\setbox\ackbox=\vbox\bgroup
\expandafter\ifx\csname internallinenumbers\endcsname\relax\else
\begin{internallinenumbers}
\fi\fi
\vskip 5.8mm plus 1mm minus 1mm
\vskip1sp
\section*{#1}
\noindent\ignorespaces}

\def\endacknowledgements{
\ifanonymous\expandafter\ifx\csname internallinenumbers\endcsname\relax\else
\end{internallinenumbers}
\fi
\egroup\fi%% completes ackbox
\ifanonymous
\vskip 5.8mm plus 1mm minus 1mm
\vskip1sp
%\section*{Acknowledgements}
\centerline{(Acknowledgements anonymized for review)}
\else
\unvbox\ackbox
\fi\vskip6pt}


\usepackage{ifthen}
\newbox\contribbox

%\def\chkcontrib{false}
\def\chkcontrib{true}
%
\newenvironment{contribution}{%
  \gdef\chkcontrib{true}%
  \ifanonymous
    \global\setbox\contribbox=\vbox\bgroup
 \else
 \section*{Author contributions}
 \noindent\ignorespaces
  \fi
}{\ifanonymous\egroup\vskip6pt\centerline{(Author contributions anonymized for review)}\fi\null\vskip6pt}



\AtEndDocument{
\ifthenelse{\equal{\chkcontrib}{true}}{}{%
\@latex@error{^^J^^J Please use 
"\string\begin\string{contribution\string}...\string\end\string{contribution\string} in your document.
^^J^^J}\@ehc
\stop}
}
%  ****************************************
%  *          APPENDIX                    *
%  ****************************************

\newcounter{remember@figure@num}
\newcounter{remember@table@num}

% this was an environment earlier, which doesn't make sense since we don't
% do \begin{appendix}...\end{appendix}. Changed to \appendix which is how it is used.

%   numberedappendix: Needed to label appendix sections A, B, .
%   appendixfloats: Needed. ??

\newif\ifappendixon
\def\appendix{\global\appendixontrue
\if@two@col  
\onecolumngrid
\noindent\mbox{}\vrule height 24pt width0pt\hfill{\apjsecfont APPENDIX}\hfill\mbox{}\par\vskip18pt
   \if@two@col@app\global\@two@coltrue\twocolumngrid \fi
   % above, we want onecolumngrid to be default. Only twocolumn is asked for in documentclass option
\else
\noindent\mbox{}\vrule height 24pt width0pt\hfill{\apjsecfont APPENDIX}\hfill\mbox{}\par 
\vskip18pt
    \if@two@col@app\global\@two@coltrue\twocolumngrid 
         \fi\fi
% \vrule used for extra space; otherwise revtex4-1 sometimes eats
% away the last line before appendix
        \nopagebreak\medskip\@nobreaktrue\def\ApjSectionpenalty{\@M}
        \@firstsectionfalse
          \setcounter{section}{0}
          \setcounter{subsection}{0}
          \setcounter{equation}{0}
%%
\ifletteredappendix
          \def\thesection{\Alph{section}}
          \def\theequation{\hbox{\Alph{section}\arabic{equation}}}
%% these are NOT supposed to reset to zero
%\setcounter{table}{0}
%\setcounter{figure}{0}
\fi
%%
\if@number@appendix@floats
% we don't want to set equations to zero in appendix, because there
% might then be two equation 1's, etc., confusing for cross referencing.
%\setcounter{equation}{0}
          \def\thesection{\Alph{section}}
          \def\theequation{\hbox{\Alph{section}\arabic{equation}}}
          \def\section{\@startsection {section}{1}{\z@} 
            {10pt}{5pt}{\centering\scshape\apjsecfont}}
\else
% Do not use appendix numbers in the titles
          \def\ApjSectionMarkInTitle{\AppendixApjSectionMarkInTitle}
\fi
\ifappletter
\let\savesection\section
\def\section{\resetapptablenumbers\savesection}
\fi
}
%


%%

%  ****************************************
%  *          BIBLIOGRAPHY                *
%  ****************************************

\newenvironment{references}[0]{
  \onecolumngrid
  \par
  \vspace{10pt plus 3pt}
  \noindent \makebox[\textwidth][c]{\small\scshape REFERENCES}
  \par
  \vspace*{4pt plus 3pt}
  \set@column@hsize{2}\twocolumngrid 
%% Jan29, 2021, added \ifonecolstyle, \ifpreprinttwo
\ifnumlines
\ifonecolstyle
\ifpreprinttwo\else
\advance\linenumbersep-12pt\fi\fi\fi
  \parindent=0cm \parskip=0cm
  \def\baselinestretch{1.0}
  \footnotesize \baselineskip=\baselinestretch\bibbaselineskip plus 1pt
  minus 1pt \interlinepenalty \@M
  \hyphenpenalty=10000
  \frenchspacing    % AV - to get right spacing after ``et al.'' 
  \def\refpar{\par\hangindent=1.2em\hangafter=1}}
{
  \onecolumngrid
}

% redefine thebibliography

% remove numbers from the reference list
\def\@biblabel#1{\relax}

\newskip\bibskip
\bibskip=0pt plus 1pt
\let\savebibitem\bibitem
\def\bibitem{\vskip\bibskip\savebibitem}
\newdimen\bibindent

\newenvironment{thebibliography}[1]{\global\bibtrue
\onecolumngrid 
\vspace{20pt}
\goodbreak
    \hbox to\textwidth{\hss\normalsize REFERENCES\hss}
\vspace{6pt}\parskip=0pt
\twocolumngrid\@twocolumntrue
\ifonecolstyle\advance\linenumbersep 12pt\fi% 
%% Jan29, 2021, added \ifonecolstyle
\ifnumlines
\ifonecolstyle
\ifpreprinttwo\else
\advance\linenumbersep-12pt\fi\fi\fi
\par
 \raggedright
\small
\ifmodern\else
 \vspace{10pt plus 3pt}\fi
\par
\topsep=0pt
 \list{}%
   {
     \parindent=0pt \parskip=1pt plus 1pt \parsep=0pt % AV
     \bibindent=0pt                          %
\ifmodern\vskip-12pt
\baselineskip=13pt plus 1pt
\else
\ifdoublespace
\baselineskip=20pt
\else
\baselineskip=13pt plus 1pt \fi\fi \interlinepenalty \@M  % AV
     \frenchspacing    % AV - to get right spacing after ``et al.'' 
     \hyphenpenalty=10000
     \itemindent=-1.0em                      %
     \itemsep=0pt                            %
     \listparindent=0pt                      %
     \settowidth\labelwidth{0pt} %
     \labelsep=0pt                           %
     \leftmargin=1.0em
     \advance\leftmargin\labelsep
%%%      \usecounter{enumiv}%
      \let\p@enumiv\@empty
      \renewcommand\theenumiv{\relax}}%
    \sloppy\clubpenalty10000\widowpenalty10000%
    \sfcode`\.\@m\relax
%%%\item[] This May be necessary, but causes extra vertical space in first column
%%%          of the bibliography.
}
  {\def\@noitemerr
    {\@latex@warning{Empty `thebibliography' environment}}%
\endlist
    \onecolumngrid % to balance references
\global\bibfalse
\newpage
  }

% %% AV: 

\def\reference{\@ifnextchar\bgroup {\@reference}
        {\@latexerr{Missing key on reference command}
        {Each reference command should have a key corresponding to a markcite somewhere in the text}}}
\def\@reference#1{\refpar}


 \def\journalinfo#1{\gdef\@journalinfo{#1}}
 \journalinfo{Draft version \today}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Equations                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EQNARRAY with reduced spacing around tab characters - AV
\def\eqnarray{%
  \stepcounter{equation}%
  \def\@currentlabel{\p@equation\theequation}%
  \global\@eqnswtrue
  \setlength{\arraycolsep}{0.25\arraycolsep}
  \m@th
  \global\@eqcnt\z@
  \tabskip\@centering
  \let\\\@eqncr
  $$\everycr{}\halign to\displaywidth\bgroup
  \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
  &\global\@eqcnt\@ne\hskip \tw@\arraycolsep \hfil${##}$\hfil
  &\global\@eqcnt\tw@ \hskip \tw@\arraycolsep
  $\displaystyle{##}$\hfil\tabskip\@centering
  &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
  \tabskip\z@skip
  \cr
  }

%  ****************************************
%  *         TABLES AND FIGURES           *
%  ****************************************

\def\@arstrut@hline@clnc{0.5\p@}% % Klootch: magic number

\setlength{\textfloatsep}{9pt}
\setlength{\dbltextfloatsep}{0pt}
\setcounter{topnumber}{9}
\renewcommand{\topfraction}{1.0}
\setcounter{bottomnumber}{9}
\renewcommand{\bottomfraction}{1.0}
\setcounter{totalnumber}{20}
\def\floatpagefraction{.9}
\renewcommand{\textfraction}{0.0}
\setcounter{dbltopnumber}{9} 
\renewcommand{\dbltopfraction}{0.85}
\renewcommand{\dblfloatpagefraction}{0.85}

% Copied from revtex4.cls; without it, captions are centered
\def\@xfloat@prep{%
  \let\footnote\footnote@latex
  \def\@mpfn{mpfootnote}%
  \def\thempfn{\thempfootnote}%
  \c@mpfootnote\z@
  \let\@footnotetext\@mpfootnotetext
  \let\H@@footnotetext\@mpfootnotetext
  \let\@makefntext\@mpmakefntext
}%


%%%%%%%%%%%% \cutinhead

%% Number of \pt@ncol set when \tablecolumns{} used at beginning of
%% deluxetable.

\def\@ptabularcr{\\}
\newcommand\cutinhead[1]{% 
 \noalign{\vskip 1.5ex}% 
 \hline 
 \@ptabularcr 
 \noalign{\vskip -1.5ex}% 
 \multicolumn{\pt@ncol}{c}{#1}% 
 \@ptabularcr 
 \noalign{\vskip .8ex}% 
 \hline 
 \@ptabularcr 
 \noalign{\vskip -2ex}% 
}% 

\newcommand\sidehead[1]{% 
 \noalign{\vskip 1.5ex}% 
%  \hline 
%  \@ptabularcr 
%  \noalign{\vskip -1.5ex}% 
 \multicolumn{\pt@ncol}{l}{#1}% 
 \@ptabularcr 
 \noalign{\vskip .8ex}% 
%  \hline 
%  \@ptabularcr 
%  \noalign{\vskip -2ex}% 
}% 


%% these don't seem to be relevant:
\newcommand\figcaption{\@testopt{\@xfigcaption}{}}% 
%% suggested by Joern Wilms
\def\@figcaption#1{{\def\@captype{figure}\caption{\footnotesize #1}}}
\def\@xfigcaption[#1]#2{{\def\@captype{figure}\caption{\footnotesize
#2}}}

\def\thetable{\@arabic\c@table}
%%% Table captions without making a floating table
\def\tabcaption{\@ifnextchar[{\@xtabcaption}{\@tabcaption}}
\def\@tabcaption#1{{\def\@captype{table}\caption{#1}}}
\def\@xtabcaption[#1]#2{{\def\@captype{table}\caption{#2}}}


 \let\fnum@ptable=\fnum@table
 \def\fnum@ptablecont{{\centering{\scshape Table~\thetable}---{\itshape
 Continued}}}% 
 \long\def\@make@caption@text#1#2{% 
   {\small\centering#1{\scshape #2}\par\vskip1.4ex}
 }% 

\long\def\@makecaption@plano@cont#1#2{% 
  {\small \centering#1\par}\vskip1.4ex\relax
}% 


%% Commands from aastex.cls:

% This has been redefined below

\newcommand\facility{\@testopt\@facility{[}}%
\def\@facility[#1]#2{{\vskip6pt{\large\it Facility:} #2}}%

\newcommand\facilities{\@testopt\@facilities{[}}%
\def\@facilities[#1]#2{{\vskip6pt{\large\it Facilities:} #2}}%


\long\def\software{\bgroup\@testopt \@software {[}}
\def\@software[#1]#2{\vskip 6pt{
\frenchspacing
\iftwelvepoint
\font\foo=cmr12
\else
\font\foo=cmr10\fi
%%
\fontdimen2\foo=3pt %% Changed from 1.5pt to 3pt, March12, 2019
%%
{\large \it Software: }
#2
%% returning to original fontdimen
\iftwelvepoint
\fontdimen2\foo=3.91663pt
\else
\fontdimen2\foo=3.33333pt
\fi
}\egroup}





\newcommand\object{\@testopt\@object{[}}%
\def\@object[#1]#2{#2}%
\newcommand\objectname{\@testopt\@objectname{[]}}% 
\def\@objectname[#1]#2{#2}% 
\newlength{\plot@width}
\def\eps@scaling{1.0}% 
\newcommand\epsscale[1]{\def\eps@scaling{#1}}% 
\newcommand\plotone[1]{% 
 \centering 
 \leavevmode 
 \setlength{\plot@width}{0.85\linewidth}
 \includegraphics[width={\eps@scaling\plot@width}]{#1}% 
}% 
\newcommand\plottwo[2]{% 
 \centering 
 \leavevmode 
 \setlength{\plot@width}{0.425\linewidth}
 \includegraphics[width={\eps@scaling\plot@width}]{#1}% 
 \hfil 
 \includegraphics[width={\eps@scaling\plot@width}]{#2}% 
}% 
\newcommand\plotfiddle[7]{% 
 \centering 
 \leavevmode 
 \vbox\@to#2{\rule{\z@}{#2}}% 
 \includegraphics[% 
  scale=#4, 
  angle=#3, 
  origin=c 
 ]{#1}% 
}%

\gdef\get@fig@number#1:->#2#3\@nil{%
\ifnum\catcode`#2=12\relax%
  \def\thefigure{#2#3}%
  \let\@currentlabel\thefigure% 
  \setcounter{figure}{\thefigure}%
  \global\advance\c@figure\m@ne\relax%
  \addtocounter{figure}{\m@ne}% 
\else%
  \def\thefigure{#2#3}%
  \let\@currentlabel\thefigure% 
\fi}
%
\newcommand\figurenum[1]{%\figurenum{A1}
  \edef\temp{#1}%
  \expandafter\get@fig@number\meaning\temp\@empty\@nil%
}% 

\newcommand\phn{\phantom{0}}% 
\newcommand\phd{\phantom{.}}% 
\newcommand\phs{\phantom{$-$}}% 
\newcommand\phm[1]{\phantom{#1}}% 
\let\la=\lesssim            % For Springer A&A compliance... 
\let\ga=\gtrsim 
\newcommand\sq{\mbox{\rlap{$\sqcap$}$\sqcup$}}% 
\newcommand\arcdeg{\mbox{$^\circ$}}% 
\newcommand\arcmin{\mbox{$^\prime$}}% 
\newcommand\arcsec{\mbox{$^{\prime\prime}$}}% 
\newcommand\fd{\mbox{$.\!\!^{\mathrm d}$}}% 
\newcommand\fh{\mbox{$.\!\!^{\mathrm h}$}}% 
\newcommand\fm{\mbox{$.\!\!^{\mathrm m}$}}% 
\newcommand\fs{\mbox{$.\!\!^{\mathrm s}$}}% 
\newcommand\fdg{\mbox{$.\!\!^\circ$}}% 
\newcommand\farcm@mss{\mbox{$.\mkern-4mu^\prime$}}% 
\let\farcm\farcm@mss 
\newcommand\farcs@mss{\mbox{$.\!\!^{\prime\prime}$}}% 
\let\farcs\farcs@mss 
\newcommand\fp{\mbox{$.\!\!^{\scriptscriptstyle\mathrm p}$}}% 
\newcommand\micron{\mbox{$\mu$m}}% 

 

\newcommand\ion[2]{#1$\;${%
\ifx\@currsize\normalsize\small \else
\ifx\@currsize\small\footnotesize \else
\ifx\@currsize\footnotesize\scriptsize \else
\ifx\@currsize\scriptsize\tiny \else
\ifx\@currsize\large\normalsize \else
\ifx\@currsize\Large\large
\fi\fi\fi\fi\fi\fi
\rmfamily\@Roman{#2}}\relax}% 

\newcommand\case[2]{\mbox{$\frac{#1}{#2}$}}% 
\newcommand\slantfrac{\case}% 
\newcommand\onehalf{\slantfrac{1}{2}}% 
\newcommand\onethird{\slantfrac{1}{3}}% 
\newcommand\twothirds{\slantfrac{2}{3}}% 
\newcommand\onequarter{\slantfrac{1}{4}}% 
\newcommand\threequarters{\slantfrac{3}{4}}% 
\newcommand\ubvr{\mbox{$U\!BV\!R$}}%% UBVR system 
\newcommand\ub{\mbox{$U\!-\!B$}}%   % U-B 
\newcommand\bv{\mbox{$B\!-\!V$}}%   % B-V 
\newcommand\vr{\mbox{$V\!-\!R$}}%   % V-R 
\newcommand\ur{\mbox{$U\!-\!R$}}%   % U-R 

%% need this change so that it works correctly in tables:
{\catcode`\$=\active
\gdef\nodata{ ~$\cdots$~ }}% 

\newcommand\diameter{\ooalign{\hfil/\hfil\crcr\mathhexbox20D}}% 
\newcommand\degr{\arcdeg}% 
\newcommand\Sun{\sun}% 
\newcommand\Sol{\sun}% 
\newcommand\sun{\odot}% 
\newcommand\Mercury{\astro{\char1}}% Mercury symbol, "1" 
\newcommand\Venus{\astro{\char2}}% Venus symbol, "2" 
\newcommand\Earth{\earth}% 
\newcommand\Terra{\earth}% 
\newcommand\earth{\oplus}% 
\newcommand\Mars{\astro{\char4}}% Mars symbol, "4" 
\newcommand\Jupiter{\astro{\char5}}% Jupiter symbol, "5" 
\newcommand\Saturn{\astro{\char6}}% Saturn symbol, "6" 
\newcommand\Uranus{\astro{\char7}}% Uranus symbol, "7" 
\newcommand\Neptune{\astro{\char8}}% Neptune symbol, "8" 
\newcommand\Pluto{\astro{\char9}}% Pluo symbol, "9" 
\newcommand\Moon{\astro{\char10}}% Moon symbol, "M" 
\newcommand\Luna{\Moon}% 
\newcommand\Aries{\astro{\char11}}% 
\newcommand\VEq{\Aries}% vernal equinox (Aries) 
\newcommand\Taurus{\astro{\char12}}% 
\newcommand\Gemini{\astro{\char13}}% 
\newcommand\Cancer{\astro{\char14}}% 
\newcommand\Leo{\astro{\char15}}% 
\newcommand\Virgo{\astro{\char16}}% 
\newcommand\Libra{\astro{\char17}}% 
\newcommand\AEq{\Libra}% autumnal equinox (Libra) 
\newcommand\Scorpius{\astro{\char18}}% 
\newcommand\Sagittarius{\astro{\char19}}% 
\newcommand\Capricornus{\astro{\char20}}% 
\newcommand\Aquarius{\astro{\char21}}% 
\newcommand\Pisces{\astro{\char22}}% 
 

\newcommand\sbond{\chem@bnd{\@sbnd}}%
\newcommand\dbond{\chem@bnd{\@dbnd}}%
\newcommand\tbond{\chem@bnd{\@tbnd}}%


\newcommand\aj{\ref@jnl{AJ}}%        % Astronomical Journal 
\newcommand\psj{\ref@jnl{PSJ}}%       % Planetary Science Journal
\newcommand\araa{\ref@jnl{ARA\&A}}%  % Annual Review of Astron and Astrophys 
\newcommand\apj{\ref@jnl{ApJ}}%    % Astrophysical Journal 
\newcommand\apjl{\ref@jnl{ApJL}}     % Astrophysical Journal, Letters 
\newcommand\apjs{\ref@jnl{ApJS}}%    % Astrophysical Journal, Supplement 
\newcommand\ao{\ref@jnl{ApOpt}}%   % Applied Optics 
\newcommand\apss{\ref@jnl{Ap\&SS}}%  % Astrophysics and Space Science 
\newcommand\aap{\ref@jnl{A\&A}}%     % Astronomy and Astrophysics 
\newcommand\aapr{\ref@jnl{A\&A~Rv}}%  % Astronomy and Astrophysics Reviews 
\newcommand\aaps{\ref@jnl{A\&AS}}%    % Astronomy and Astrophysics, Supplement 
\newcommand\azh{\ref@jnl{AZh}}%       % Astronomicheskii Zhurnal 
\newcommand\baas{\ref@jnl{BAAS}}%     % Bulletin of the AAS 
\newcommand\icarus{\ref@jnl{Icarus}}% % Icarus
\newcommand\jaavso{\ref@jnl{JAAVSO}}  % The Journal of the American Association of Variable Star Observers
\newcommand\jrasc{\ref@jnl{JRASC}}%   % Journal of the RAS of Canada 
\newcommand\memras{\ref@jnl{MmRAS}}%  % Memoirs of the RAS 
\newcommand\mnras{\ref@jnl{MNRAS}}%   % Monthly Notices of the RAS 
\newcommand\pra{\ref@jnl{PhRvA}}% % Physical Review A: General Physics 
\newcommand\prb{\ref@jnl{PhRvB}}% % Physical Review B: Solid State 
\newcommand\prc{\ref@jnl{PhRvC}}% % Physical Review C 
\newcommand\prd{\ref@jnl{PhRvD}}% % Physical Review D 
\newcommand\pre{\ref@jnl{PhRvE}}% % Physical Review E 
\newcommand\prl{\ref@jnl{PhRvL}}% % Physical Review Letters 
\newcommand\pasp{\ref@jnl{PASP}}%     % Publications of the ASP 
\newcommand\pasj{\ref@jnl{PASJ}}%     % Publications of the ASJ 
\newcommand\qjras{\ref@jnl{QJRAS}}%   % Quarterly Journal of the RAS 
\newcommand\skytel{\ref@jnl{S\&T}}%   % Sky and Telescope 
\newcommand\solphys{\ref@jnl{SoPh}}% % Solar Physics 
\newcommand\sovast{\ref@jnl{Soviet~Ast.}}% % Soviet Astronomy 
\newcommand\ssr{\ref@jnl{SSRv}}% % Space Science Reviews 
\newcommand\zap{\ref@jnl{ZA}}%       % Zeitschrift fuer Astrophysik 
\newcommand\nat{\ref@jnl{Nature}}%  % Nature 
\newcommand\iaucirc{\ref@jnl{IAUC}}% % IAU Cirulars 
\newcommand\aplett{\ref@jnl{Astrophys.~Lett.}}%  % Astrophysics Letters 
\newcommand\apspr{\ref@jnl{Astrophys.~Space~Phys.~Res.}}% % Astrophysics Space Physics Research 
\newcommand\bain{\ref@jnl{BAN}}% % Bulletin Astronomical Institute of the Netherlands 
\newcommand\fcp{\ref@jnl{FCPh}}%   % Fundamental Cosmic Physics 
\newcommand\gca{\ref@jnl{GeoCoA}}% % Geochimica Cosmochimica Acta 
\newcommand\grl{\ref@jnl{Geophys.~Res.~Lett.}}%  % Geophysics Research Letters 
\newcommand\jcp{\ref@jnl{JChPh}}%     % Journal of Chemical Physics 
\newcommand\jgr{\ref@jnl{J.~Geophys.~Res.}}%     % Journal of Geophysics Research 
\newcommand\jqsrt{\ref@jnl{JQSRT}}%   % Journal of Quantitiative Spectroscopy and Radiative Trasfer 
\newcommand\nphysa{\ref@jnl{NuPhA}}%     % Nuclear Physics A 
\newcommand\physrep{\ref@jnl{PhR}}%       % Physics Reports 
\newcommand\physscr{\ref@jnl{PhyS}}%        % Physica Scripta 
\newcommand\planss{\ref@jnl{Planet.~Space~Sci.}}%  % Planetary Space Science 
\newcommand\procspie{\ref@jnl{Proc.~SPIE}}%      % Proceedings of the SPIE 

\newcommand\actaa{\ref@jnl{AcA}}%  % Acta Astronomica
\newcommand\caa{\ref@jnl{ChA\&A}}%  % Chinese Astronomy and Astrophysics
\newcommand\cjaa{\ref@jnl{ChJA\&A}}%  % Chinese Journal of Astronomy and Astrophysics
\newcommand\jcap{\ref@jnl{JCAP}}%  % Journal of Cosmology and Astroparticle Physics
\newcommand\na{\ref@jnl{NewA}}%  % New Astronomy
\newcommand\nar{\ref@jnl{NewAR}}%  % New Astronomy Review
\newcommand\pasa{\ref@jnl{PASA}}%  % Publications of the Astron. Soc. of Australia
\newcommand\rmxaa{\ref@jnl{RMxAA}}%  % Revista Mexicana de Astronomia y Astrofisica

%% added feb 9, 2016
\newcommand\maps{\ref@jnl{M\&PS}}% Meteoritics and Planetary Science
\newcommand\aas{\ref@jnl{AAS Meeting Abstracts}}% American Astronomical Society Meeting Abstracts
\newcommand\dps{\ref@jnl{AAS/DPS Meeting Abstracts}}% American Astronomical Society/Division for Planetary Sciences Meeting Abstracts



\let\astap=\aap 
\let\apjlett=\apjl 
\let\apjsupp=\apjs 
\let\applopt=\ao 

\newcommand\ulap[1]{\vbox\@to\z@{{\vss#1}}}% 
\newcommand\dlap[1]{\vbox\@to\z@{{#1\vss}}}% 


\newcounter{table@save}

%% March 25, 2019
%% Old v5.2 way, From Greg, This allows a number like 33N to be used
%% for a table, and the cross-references will work correctly

\AtBeginDocument{
  
\gdef\get@table@number#1:->#2#3\@nil{%
\ifnum\catcode`#2=12\relax%
  \def\thetable{#2#3}%
  \let\@currentlabel\thetable% 
   \setcounter{table}{\thetable}%
   \global\advance\c@table\m@ne\relax%
\else%
  \def\thetable{#2#3}%
  \let\@currentlabel\thetable% 
\fi}
%
\def\tablenum#1{% Clashing with siunitx
  \edef\temp{#1}%
  \expandafter\get@table@number\meaning\temp\@empty\@nil}%

\let\savetablenum\tablenum
}


\def\tabletypesize#1{\gdef\currtabletypesize{#1}
\def\@table@type@size{#1}}%

\tabletypesize{\small}
\let\tablefontsize=\tabletypesize % for compatibility with old documents

\gdef\@tablecaption{}
\def\tablecaption#1{\gdef\@tablecaption{#1}}

\def\LT@endpbox{%
  \@finalstrut\@arstrutbox
  \egroup
  \the\LT@p@ftn
  \global\LT@p@ftn{}%
  \hfil}

%% Used for longtable
\def\LT@makecaption#1#2#3{%
  \LT@mcol\LT@cols c{\hbox to\z@{\hss\parbox[t]\LTcapwidth
{%
\xdef \@currentlabel{\thetable}
     \sbox\@tempboxa{\small #2. 
%% disable trackchanges commands here, so they aren't entered 2 times:
\let\added\relax
#3}%
     \ifdim\wd\@tempboxa>\hsize
      \small#2. #3%
     \else
       \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
     \fi
    \endgraf\vskip\baselineskip}%
  \hss}}
}%% 

\let\LT@makecaption@rtx=\LT@makecaption % to fight redefinition in Revtex-4.1

\def\xfigure{figure}
%% from book.cls/ used??
\AtBeginDocument{
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
%% \small added to keep currtabletypesize from determining size of caption
  \sbox\@tempboxa{\small
%% disable trackchanges commands here, so they aren't entered 2 times:
\let\added\relax
{\bf #1.} #2}%
  \ifdim \wd\@tempboxa >\hsize
\small
\ifdigitasset%
\highlighcaption{\vbox{\hsize=.96\linewidth\unhbox\@tempboxa}}
\else%
\unhbox\@tempboxa\par
\fi%
  \else
    \global \@minipagefalse
     \ifdigitasset%
       \highlighcaption{\hb@xt@\hsize{\hfill\box\@tempboxa\hfill}}
     \else%
       \hb@xt@\hsize{\hfill\box\@tempboxa\hfill}
     \fi%
  \fi\global\digitassetfalse
  \vskip\belowcaptionskip
}
%% \@ifpackageloaded{subcaption}{
%% \long\def\caption@makecaption#1#2{%
%%   \caption@nobreak
%%   \caption@make@above
%%   \caption@nobreak
%%   \ifdigitasset%
%%   \highlighcaption{\caption@@make{#1}{#2}}%
%%   \else
%%   \caption@@make{#1}{#2}%
%%   \fi
%%   \caption@nobreak
%%   \caption@make@below
%%   \caption@nobreak}
%%   }{}
}

\newdimen\@abovenoteskip
\newcommand\tablerefs[1]{\ifdim\@abovenoteskip=0pt\global\@abovenoteskip=10pt\fi
{\small\@tableref{\parfillskip\z@ plus1fil\relax #1\endgraf}}}%

\global\def\tablenotemark#1{{\normalfont\textsuperscript{\currtabletypesize\it #1}}}%\normalsize #128


%% this version of \tablehead doesn't seem to be used, so set to \xyztablehead{}
\def\xyztablehead#1{\@table@not@headedfalse%
  \kill
  \caption{\\%
   \@tablecaption\gdef\@currentlabel{\thetable}(0)}
    \\\hline\hline%
  #1\vrule height 12pt depth 10pt width 0pt\relax 
\hskip\tabcolsep\\[.7ex]
  \hline\\[-1.5ex]
  \endfirsthead
  \caption[]{--- \emph{Continued}}\\
  \hline
  \hline\\[-1.7ex]
  #1\hskip\tabcolsep\\[.7ex]
  \hline\\[-1.5ex]
  \endhead
  \hline
  \endfoot%
}

\newif\if@table@not@headed

\newlength{\table@note@skip}
\setlength{\table@note@skip}{0.5ex}
\newlength{\deluxe@table@width}
\newlength{\@d@t@a}
\newcounter{deluxe@table@num}
\newdimen\LTcapwidth

%% \ignorespaces necessary ++== depth 6pt was depth 3pt, == added height 12pt, nov 2017
\def\colhead#1{\multicolumn{1}{c}{\vrule depth 6pt height 12pt width
0pt\relax#1}\ignorespaces}
\def\twocolhead#1{\multicolumn{2}{c}{\hss\vrule depth 6pt height 12pt width
0pt\relax#1\hss}\ignorespaces}
\def\nocolhead#1{\multicolumn{1}{h}{}\ignorespaces}
\def\dcolhead#1{\multicolumn{1}{c}{$\vrule depth 6pt height12pt
width0pt\relax#1$}\ignorespaces}

%\newcounter{LT@tables}
\def\tablewidth#1{%
  \ifdim#1=\z@
  \else
  \gdef\@d@t@@flag{1}
  \if@filesw\immediate\write\@auxout{%
   \gdef\expandafter\noexpand
   \csname deluxe@table@width@\romannumeral\c@LT@tables\endcsname
   {#1}}
  \fi
  \fi
}


\def\save@natural@width{%
      \ifnum\@d@t@@flag=0
        \setlength{\@d@t@a}{0pt}%
        \let\@d@t@b=\LT@entry%
        \def\LT@entry##1##2{\addtolength{\@d@t@a}{##2}%
        }%
        \expandafter\csname LT@\romannumeral\c@deluxe@table@num\endcsname
        \setlength{\@d@t@a}{-\@d@t@a}
        \tablewidth{\the\@d@t@a}
        \def\LT@entry{\@d@t@b}
      \fi
}

\def\lt@expand@linewidth@one{\setlength\LTleft{0pt}\setlength\LTright{0pt}}
\def\lt@expand@linewidth@two{@{\extracolsep{0pt plus 1filll}}}

\def\find@table@width{%
%%% set table width using aux file and command \tablewidth
    \setcounter{deluxe@table@num}{\c@LT@tables}
    \refstepcounter{deluxe@table@num}
    \expandafter\ifx\csname deluxe@table@width@\romannumeral\c@deluxe@table@num\endcsname\relax
      \def\@d@t@{0.999\linewidth}
    \else
      \edef\@d@t@{\expandafter\csname deluxe@table@width@\romannumeral\c@deluxe@table@num\endcsname}
    \fi
    \ifdim\@d@t@<\z@% then natural width is used
      \setlength{\deluxe@table@width}{-\@d@t@}
      \setlength{\LTcapwidth}{-\@d@t@}
      \def\lt@expand@linewidth{\relax}
      \def\lt@expand@linewidth@{}
    \else% we will enclose table in the minipage of the given width and make
         % longtable to span the full minipage width
      \ifdim\@d@t@>\z@\else\def\@d@t@{0.999\linewidth}\fi
      \setlength{\deluxe@table@width}{\@d@t@}
      \setlength{\LTcapwidth}{\@d@t@}
      \def\lt@expand@linewidth{\lt@expand@linewidth@one}
      \def\lt@expand@linewidth@{\lt@expand@linewidth@two}
    \fi
}

\newlength{\abovedeluxetableskip}
\newlength{\belowdeluxetableskip}
\setlength{\abovedeluxetableskip}{0pt}
\setlength{\belowdeluxetableskip}{0pt}
\setlength{\tabcolsep}{5pt}

\setlength\doublerulesep{1.5pt}
\newdimen\lastrowheight
\def\set@last@row@height{\setlength{\lastrowheight}{\ht\strutbox}\addtolength{\lastrowheight}{\dp\strutbox}\setlength{\lastrowheight}{-\arraystretch\lastrowheight}}

\let\tableline=\colrule % Revtex said: Command \tableline is obsolete; Use \colrule instead.. 

%% 
\newtoks\DT@p@ftn 
\global\def\xtablenotetext@DT#1#2{
  \edef\@tempa{\the\DT@p@ftn\noexpand\tablenotemark{#1}~}
  \global\DT@p@ftn\expandafter{\@tempa{\@table@type@size#2}\par}}%

%%% AH %%%%%%%%%%%%%%%%%%%%%
\let\savedollar$
\catcode`\$=\active
\let$\savedollar

%%

\def\resetdecimals{\global\let\zdoit\relax\global\let\ddoit\relax}

\def\tableheadfrac#1{}
\newcount\pt@column 
\newcount\pt@ncol 

\newcommand\tablecolumns[1]{% 
 \pt@column=#1\relax 
 \pt@ncol=#1\relax 
 \global\let\pt@addcol\@empty 
}% 

%% from older version, probably can delete:
\def\@tablecom#1{% 
 \vspace*{\table@note@skip}
\par 
{\parbox{\linewidth}{\hskip1em\rmfamily {\@eapj@cap@font Note}. --- #1}\par}% 
}% 
\def\@tableref#1{% 
 \vspace*{\table@note@skip}
\par 
{\parbox{\linewidth}{\hskip1em\rmfamily {\@eapj@cap@font References}. --- #1}\par}% 
}% 
\def\spew@tblnotes{% 
 \@ifx@empty\tblref@list{}{% 
  \@tablenotes{\tblref@list}%
  \vspace*{\table@note@skip}%
  \global\let\tblref@list\@empty 
 }% 
 \@ifx@empty\tblnote@list{}{% 
  \@tablenotes{\tblnote@list}% 
  \vspace*{\table@note@skip}%
  \global\let\tblnote@list\@empty
 }
 \the\DT@p@ftn%
}% 

%% for notes on emulateapj please see http://hea-www.harvard.edu/~alexey/emulateapj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End of code taken from emulateapj.cls %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% New as of august 2015:

%% These commands requested AAS
\newcommand{\noprint}[1]{}
\newcommand{\figsetstart}{{\bf Fig. Set} }
\newcommand{\figsetend}{}
\newcommand{\figsetgrpstart}{}
\newcommand{\figsetgrpend}{}
\newcommand{\figsetnum}[1]{{\bf #1.}}
\newcommand{\figsettitle}[1]{ {\bf #1}}
\newcommand{\figsetgrpnum}[1]{\noprint{#1}}
\newcommand{\figsetgrptitle}[1]{\noprint{#1}}
\newcommand{\figsetplot}[1]{\noprint{#1}}
\newcommand{\figsetgrpnote}[1]{\noprint{#1}}

\usepackage[hyphens]{url}
%% if we take away the xx before UrlBreaks we will get a url that breaks
%% at any letter or number. It might be better to break only at / however...
\expandafter\def\expandafter\xxUrlBreaks\expandafter{\UrlBreaks%  save the current one
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j%
  \do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t%
  \do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D%
  \do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N%
  \do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X%
  \do\Y\do\Z\do\1\do\2\do\3\do\4\do\5\do\6\do\7\do\8\do\9}


%% for tables continuing over pages
\usepackage{longtable}

%% for editing changes
\usepackage{xcolor}
% hyperref link defaults to "blue" (0000ff) as this matches our publisher produced pdf style
\definecolor{xlinkcolor}{cmyk}{1,1,0,0}


%% \PassOptionsToPackage{hyphens}{url}
%% In response to request from AAS
 \usepackage[bookmarks=true,         % show bookmarks bar?/ Changed March 22, 2019 for
                                     % improved accessibility
    pdfnewwindow=true,      % links in new window
   colorlinks=true,    % false: boxed links; true: colored links
  linkcolor=xlinkcolor,     % color of internal links
 citecolor=xlinkcolor,     % color of links to bibliography
filecolor=xlinkcolor,  % color of file links
urlcolor=xlinkcolor,      % color of external links
final=true
 ]{hyperref}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Additions to  AASTeX by Amy Hendrickson, TeXnology Inc, August 17, 2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table Tools, written by Amy Hendrickson
%% for American Astronomical Society
%% August 17, 2015
%% array package is necessary:
\usepackage{array}

\def\@fmtversion#1-#2-#3\@nil{\gdef\@fmtyear{#1}}
\expandafter\@fmtversion\fmtversion\@nil

\ifnum\@fmtyear > 2017\def\@endpbox{\@finalstrut\@arstrutbox  \color@endgroup \egroup\hfil}\fi
%%%%%%%%
%% 1) h in table preamble will makes text in that column ignored.

%%%%%%%%
%% 2) uppercase C L or R will make those columns in math mode.

%%%%%%%%
%% 3) \begin{splittabular}{<preamble B preamble>}...\end{splittabular}
%%    `B' in the preamble will show where the table should be broken. It may
%%    be used once in a preamble to break the table into two parts, or 
%%    two times in a preamble to break the table into three parts.

%%    The resulting table will position left half of table above right half of table.

%%    Care should be taken with \multicolumn so that it won't be broken between
%%    the two parts of the table. You may need to shorten the \multicolumn argument
%%    for number of columns to be appropriate to the number of columns in
%%    the new split table.

%%     In this example, for instance, we start with:
%%        \begin{tabular}{ccccccc}
%%        \multicolumn{7}{c}{\textsc{Table 1}}
%%     and change it to:
%%        \begin{splittabular}{ccccBccc}
%%        \multicolumn{4}{c}{\textsc{Table 1}}\\
%% 
%%     If you'd like to have a table number in the second half of the table,
%%     you can ask for a second multicolumn command that will position at the
%%     top of the second half of the table:
%%
%%        \begin{splittabular}{ccccBccc}
%%        \multicolumn{4}{c}{\textsc{Table 1}}&\multicolumn{3}{c}{\textsc{Table 1, Continued}}\\
%%
%%     You can do the same for the caption, and give a Continued caption for
%%     the second half of the table. Originally:
%%        \multicolumn{7}{c}{\textsc{Log of \textit{HST} Observations for
%%         NGC~6388}}
%%     Now, changed so that we get a caption on both halves of the table:
%%        \multicolumn{4}{c}{\textsc{Log of \textit{HST} Observations for
%%         NGC~6388}}&\multicolumn{3}{c}{\textsc{Log of \textit{HST} Observations for
%%         NGC~6388, Continued}}\\
%%     
%%     Similarly, you can rearrange table notes to appear at the bottom of
%%     the appropriate half of the table. For instance, starting with this,
%%     which would make table notes both appear at the bottom of the top half
%%     of the table:
%%        \multicolumn{4}{l}{\small{$\dagger$ Average distance of data set from
%%            cluster center.}}\\
%%        \multicolumn{4}{l}{$^{\rm a}$SNAP program.}\\
%%     
%%     We may substitute the following:
%%        \multicolumn{4}{l}{$^{\rm a}$SNAP program.}&\multicolumn{3}{l}{\small{$\dagger$ Average distance of data set from
%%            cluster center.}}\\
%%     
%%     Which will produce the first endnote underneath the top half of the
%%     table, and the second underneath the bottom half.
%%     
%%     Another option would be to have both endnotes appear below the bottom
%%     half of the table. Easily done:
%%        &&&&\multicolumn{3}{l}{$^{\rm a}$SNAP program.}\\
%%        &&&&\multicolumn{3}{l}{\small{$\dagger$ Average distance of data set from
%%            cluster center.}}\\
%%     %%     %%     %%     %%     %%     %%     

%%%%%%%%
%% 4) \colnumbers will make line with column numbers automatic. It will work with splittabular
%%     and splitdeluxetable as well as tabular.
%%     To use: type in \colnumbers within the table whereever you'd like it to appear, typically
%%     underneath the column headers, before the lines of data.

%%%%%%%%
%% 5) Easy Decimal numbering
%%    How to make decimal numbers in tables line up on the period:

%%     Use D (for decimal column) in table preamble for every decimal number. The decimal
%%     numbers will use two columns, one for the left part of the decimal
%%     number and one for the right part.

%%     D may be used more than once in a table preamble.

%%     If you want to type in a column header  over the decimal
%%     numbers, please use \multicolumn2c{} to span both columns.

%%     After the column headers, to start decimal numbering, 
%%     type in \decimals in the body of the table.

%%     When entering decimal numbers
%%     remember to leave a space after the decimal number, before the following &.
%%     For instance: &22.3 &35.96 \\

%%     If you'd like an empty entry, please supply a period and a space: & . &. You
%%     will not see the period in the resulting table.

%%     example:
%    \begin{tabular}{rDD}
%     \hline
%     &&&\multicolumn2c{\bf More}\\
%     &\multicolumn2c{\bf Decimals}&\multicolumn2c{\bf Decimals}\\
%     \hline
%     \hline
%     \decimals
%     one& . &34.2 \\
%     two &567.0 &21345 \\
%     three&.0 &62.5 \\
%     four&245 &5034.349923 \\
%     five&21 & \\
%     six& &21.6 
%    \end{tabular}
%%
%    Decimal numbering works within \begin{splittabular}...\end{splittabular}
%    \begin{splitdeluxetable} and \end{splitdeluxetable} for tables broken into two
%    or three parts. \colnumbers will number the columns counting both sides 
%    of the decimal number as one column; \tablehead{\colhead{}...} will make
%    the column headers position above the two columns used for one decimal
%    number as well.
%
%    Decimal numbers will be in math mode so that plus and minus signs are printed
%    correctly, expressions like `$\pm$ 1.2' or `\pm 1.2', will both work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\savedollar$
\catcode`\$=\active

\let\savetabular\tabular
\let\saveendtabular\endtabular


\def\tabular{\catcode`\&=\active\relax\catcode`\$=\active\relax\hskip\movetableright\global\movetableright\z@\savetabular}%

\long\gdef\eatone{\setbox0=\hbox\bgroup\savedollar\let$\relax}
\gdef\endeatone{\savedollar\egroup\hskip-2\tabcolsep}

%% Hide, important because it allows us to split tables horizontally
\newcolumntype{h}{>\eatone c<\endeatone}

\newcolumntype{C}{>{\bgroup\savedollar\let$\relax}c<{\savedollar\egroup}}
\newcolumntype{L}{>{\bgroup\savedollar\let$\relax}l<{\savedollar\egroup}}
\newcolumntype{R}{>{\bgroup\savedollar\let$\relax}r<{\savedollar\egroup}}  %$

\newcolumntype{B}{>\eatone c<\endeatone}  %% used for \splittabular to indicate break in
                                          %% two or three parts of table

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Split tables into 2 or 3 parts; stack the parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Process table preamble

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Count number of columns in preamble

\newcount\colcount
\newcount\firstcolcount
\newcount\secondcolcount
\newcount\thirdcolcount
\newcount\columncount

%% \makeatother is necessary to keep @ from being treated as a letter
%% when counting the number of columns in table.
\makeatother
\def\xD{D}
\def\xaster{*}
\newcount\howmanyDs
\newcount\firsthowmanyDs
\newcount\secondhowmanyDs

\newif\ifD

\def\countcols#1{\ifcat#1c
\global\advance\colcount by 1\relax\fi
%%
\def\lookforD{#1}
\ifx\lookforD\xD
\global\advance\howmanyDs by 1
\global\advance\colcount by1\relax
\fi
%%
\futurelet\next\lookatnext
}
\makeatletter

\def\xeatone#1{\countcols}
\def\xrelax{\relax}

%% second conditional deals with expressions like @{} in
%% the preamble.
\def\lookatnext{\if\next\xrelax\let\go\relax
\else
\ifx\next\bgroup\let\go\xeatone\else
\let\go\countcols\fi\fi\go}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% reset line counting at \\

%% arraycr redefined to match revtex4-1
\def\new@arraycr{\relax 
\global\columncount=0\relax
\global\colheadcount=0\relax
\iffalse {\fi \ifnum 0=`}\fi \@ifstar {\global \@tbpen \@M \@xarraycr}
{\global \@tbpen \intertabularlinepenalty \@xarraycr}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Redefining & is necessary to get around \omit in \multicolumn,
%% which prevents @{} from being used to change the meaning of multicolumn.
%% Now column number and top or bottom table is used to determine whether
%% multicolumn should be turned on or off.
\let\saveampersand&

\newif\iffirstbox
\newif\ifsecondbox
\newif\ifthirdbox

\long\gdef\CheckNumberAndSwitch{\unskip\global\advance\columncount by 1\relax%
\saveampersand}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse and count preamble

\def\catchfirstpreamble#1B#2Z{%firstpreamble
\def\leftpreamble{#1\relax}
\colcount=0
\global\howmanyDs=0\relax
\expandafter\countcols\leftpreamble
\global\firstcolcount\the\colcount
\global\firsthowmanyDs\the\howmanyDs
\ifnum\firstcolcount>25
\typeout{^^J
-----------------------------------------------------
^^J
Warning!
^^J^^J 
Too many columns in first part of table!
^^J^^J
Maximum number of columns in each part of the table is 25. Each `D' counts as two columns.
^^J
-----------------------------------------------------
}\fi
\global\howmanyDs=0\relax
\global\colcount=0\relax
\newcolumntype{A}{#1}}

\def\catchsecondpreamble#1B#2Z{%secondpreamble
\def\rightpreamble{#2\relax}
\colcount=0
\expandafter\countcols\rightpreamble
\global\secondcolcount\colcount
\global\secondhowmanyDs\the\howmanyDs
\ifnum\secondcolcount>25
\typeout{^^J-----------------------------------------------------
^^J
Warning!
^^J^^J 
Too many columns in second part of table!
^^J^^J
Maximum number of columns in each part of the table is 25. Each `D' counts as two columns.
^^J
-----------------------------------------------------
}\fi
\global\totalcolumns=\firstcolcount
\global\advance\totalcolumns by \secondcolcount
\global\colcount=0\relax
\newcolumntype{Z}{#2}}


\def\catchsecondofthreepreamble#1B#2B#3Z{%secondpreamble
\def\rightpreamble{#2\relax}
\colcount=0
\howmanyDs=0
\expandafter\countcols\rightpreamble
\global\secondcolcount\colcount
\global\secondhowmanyDs\the\howmanyDs
\global\totalcolumns=\firstcolcount
\global\advance\totalcolumns by \secondcolcount
\global\colcount=0\relax
\newcolumntype{Z}{#2}}


\def\catchthirdpreamble#1B#2B#3Z{%firstpreamble
\def\thirdpreamble{#3}
\colcount=0
\expandafter\countcols\thirdpreamble
\global\thirdcolcount\the\colcount
\global\advance\totalcolumns by \thirdcolcount
\global\colcount=0\relax
\newcolumntype{z}{#3}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define splittabular/endsplittabular

\newcount\PartsOfTable
\newif\ifbreaktab

\def\checkforB #1B#2B#3B{
%% defaults, may be used in \colnumbers
\gdef\tabfullpreamble{#1#2#3\relax}
\gdef\firstpreamble{#1}
\gdef\secondpreamble{#2}
\gdef\thirdpreamble{#3}
\ifx\thirdpreamble\empty
\global\PartsOfTable=2
\else
\global\PartsOfTable=3
\fi
}

\def\lookforD#1{\def\zone{#1}\ifx\zone\xD
\global\Dtrue\else\Dfalse\fi}

\newcount\columnoneandtwo
\newif\ifdonullmulticol

\newcount\colnumsused
\newcount\loopnum

\catcode`\&=\active
\let&\CheckNumberAndSwitch
\let$\savedollar

%sss
\def\splittabular{\catcode`\&=\active
\catcode`\$=\active
\global\colnumbersonfalse
\let\colnumbers\savesplitplaincolnumbers
\let\splitdecimalcolnumbers\savesplitdecimalcolnumbers
\def\decimalcolnumbers{\splitdecimalcolnumbers}
\xsplittabular}

\def\xsplittabular#1#2\end{{
\global\firsttimetrue
\let&\CheckNumberAndSwitch
\let$\savedollar
%%%$
\def\endtabular{\endarray
\global\let\zdoit\relax
\global\let\ddoit\relax
\global\Dfalse}
\setbox0=\hbox{\def\firstarg{#1}\expandafter\lookforD\firstarg}
\PartsOfTable=0
\def\tempfullpreamble{#1BB}
\setbox0=\hbox{\expandafter\checkforB\tempfullpreamble}
%% Now PartsOfTable is either =2 or 3
%%
\global\colnumsused=0
\global\breaktabtrue
\global\colcount=0
%%
\ifnum\PartsOfTable=3
\let\multicolumn\threebreakmulticolumn
\else
\let\multicolumn\breakmulticolumn
\fi
%%
\def\one{#1Z}%% full preamble
\ifnum\PartsOfTable=3
\expandafter\catchfirstpreamble\one
\expandafter\catchsecondofthreepreamble\one
\expandafter\catchthirdpreamble\one
\makefirstdummycolumns %f
\makeseconddummycolumns %F
\makethirddummycolumns %E
\else %% PartsOfTable=2
\expandafter\catchfirstpreamble\one
\expandafter\catchsecondpreamble\one
\makefirstdummycolumns %f
\makeseconddummycolumns %F
\fi
%%%
\global\columncount=0
\ifnum\PartsOfTable=3
%% For table divided into three parts !!
\firstboxtrue\secondboxfalse\thirdboxfalse
%
\setbox\firsttablebox=\hbox{%
\begin{tabular}{AFE}% 
#2\crcr
\end{tabular}}
%
\hbox to \hsize{\hss\unhbox\firsttablebox\hss}
\vskip6pt
\hrule
\vskip6pt
\global\columncount=0
\firstboxfalse\secondboxtrue\thirdboxfalse
\ifcolnumberson
\let\colnumbers\xplain
\setbox\secondtablebox=\hbox{%
\begin{tabular}{fZE}% fZE
#2\crcr\end{tabular}}
\else
\setbox\secondtablebox=\hbox{
\begin{tabular}{fZE}% fZE
#2
\end{tabular}}
\fi
\hbox to \hsize{\hss\unhbox\secondtablebox\hss}
%%
\vskip6pt
\hrule
\vskip6pt
\firstboxfalse\secondboxfalse\thirdboxtrue
\global\columncount=0
\ifcolnumberson
\let\colnumbers\xplain
\setbox\thirdtablebox=\hbox{%
\begin{tabular}{fFz}% fFz
#2\crcr\end{tabular}}
\else
\setbox\thirdtablebox=\hbox{
\begin{tabular}{fFz}% fFz
#2
\end{tabular}}
\fi
\hbox to \hsize{\hss\unhbox\thirdtablebox\hss}
\else
%%
%% For table divided into two parts:
%%
\global\columncount=0
\secondboxfalse
 \setbox\firsttablebox=\hbox{%
\begin{tabular}{AF}% should be AF
#2
\end{tabular}
}
 \hbox to \hsize{\hss\unhbox\firsttablebox\hss}
\vskip6pt
\hrule
\vskip6pt
\global\columncount=0
\secondboxtrue
\ifcolnumberson
\setbox\secondtablebox=\hbox{\let\colnumbers\xplain
\begin{tabular}{fZ}% should be fZ
#2
\end{tabular}
}
\else
\setbox\secondtablebox=\hbox{
\begin{tabular}{fZ}% should be fZ
#2
\end{tabular}
}
\fi
\hbox to \hsize{\hss\unhbox\secondtablebox\hss}
%%
%% end of conditional testing for 2 or 3 part table:
\fi
%\global\breaktabfalse
}
\firsthowmanyDs=0
\secondhowmanyDs=0
\resetdecimals
\end
}

%yyy
\def\endsplittabular{\global\firsttimefalse\global\colnumbersonfalse
\global\let\splitplaincolnumbers\savesplitplaincolnumbers
\global\breaktabfalse}

\long\gdef\breakmulticolumn#1#2#3{%
\multispan{#1}%
\let&\CheckNumberAndSwitch
\ifsecondbox%
\ifnum\columncount<\firstcolcount%
\global\donullmulticoltrue%
\else%
\global\donullmulticolfalse%
\fi%
%%%
   \else% first box
\ifnum\columncount<\firstcolcount%
\global\donullmulticolfalse%
\else%
\global\donullmulticoltrue%
\fi%
\fi%
\ifdonullmulticol%
\global\advance\colheadcount by 1\relax
\begingroup
   \def\@addamp{\if@firstamp \@firstampfalse \else
                \@preamerr 5\fi}%
   \@mkpream{h}\@addtopreamble\@empty
   \endgroup
   \def\@sharp{}%
%% comment out \@arstrut to prevent blank line where multicolumn was found
%% on other parts of the table, but not on the current part.
   \@arstrut 
\@preamble
   \null\ignorespaces
\else%
\begingroup
   \def\@addamp{\if@firstamp \@firstampfalse \else
                \@preamerr 5\fi}%
   \@mkpream{#2}\@addtopreamble\@empty
   \endgroup
   \def\@sharp{#3}%
   \@arstrut \@preamble
   \null\ignorespaces
\fi%
\global\donullmulticolfalse%
\global\advance\columncount by #1\relax%
\global\advance\columncount-1\relax%
}


\long\gdef\threebreakmulticolumn#1#2#3{%
\multispan{#1}%
\columnoneandtwo=\firstcolcount\relax%
\advance\columnoneandtwo by \secondcolcount\relax%
%%
\global\donullmulticoltrue\relax%
\iffirstbox\relax%
\ifnum\columncount<\firstcolcount%
\global\donullmulticolfalse%
\fi\relax%
\ifnum\columncount=\firstcolcount\relax%
\donullmulticoltrue\fi\relax%
\else\relax%
%%
\ifsecondbox%
\ifnum\columncount=\firstcolcount\relax%
\global\donullmulticolfalse\fi\relax%
\ifnum\columncount>\firstcolcount%
\ifnum\columncount<\columnoneandtwo\relax%
\global\donullmulticolfalse\relax%
\fi\fi\relax%
\else\relax%
%%%
\ifthirdbox%
\ifnum\columncount<\columnoneandtwo%
\global\donullmulticoltrue%
\else\relax%
\global\donullmulticolfalse%
\fi\relax%
\fi%% end if third box
\fi%% end if second box
\fi%% end if first box
%%
\ifdonullmulticol%
\begingroup\relax%
\global\advance\colheadcount by 1\relax%
   \def\@addamp{\if@firstamp \@firstampfalse \else%
                \@preamerr 5\fi}%
   \@mkpream{h}\@addtopreamble\@empty%
   \endgroup%
   \def\@sharp{}%
%% comment out \@arstrut to prevent blank line where multicolumn was found
%% on other parts of the table, but not on the current part.
   \@arstrut \@preamble%
   \null\ignorespaces
\else%
\begingroup%
   \def\@addamp{\if@firstamp \@firstampfalse \else%
                \@preamerr 5\fi}%
   \@mkpream{#2}\@addtopreamble\@empty%
   \endgroup%
   \def\@sharp{#3}%
   \@arstrut \@preamble%
   \null\ignorespaces
\fi%
\global\donullmulticolfalse%
\global\advance\columncount by #1\relax%
\global\advance\columncount-1\relax%
}

%% First dummy columns is the part of the table that will not print,
%% in this case the first part to the left.
%%\makefirstdummycolumns
%%
%% and second dummy columns
%% \makeseconddummycolumns.
\gdef\makefirstdummycolumns{
\ifcase\firstcolcount
\or% 1
\newcolumntype{f}{h} % no D possible
%%%%%%%%%%%%%%%%%%
\or% 2
  \ifcase\firsthowmanyDs
  \newcolumntype{f}{hh}%% 0
  \or
  \newcolumntype{f}{d} %% 1
  \fi
%%%%%%%%%%%%%%%%%%
\or% 3
  \ifcase\firsthowmanyDs%
  \newcolumntype{f}{hhh}% 0 
  \or%
  \newcolumntype{f}{dh}% 1
  \fi%
%%%%%%%%%%%%%%%%%%
\or% 4
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhh} % 0 
    \or
   \newcolumntype{f}{dhh} % 1
   \or
   \newcolumntype{f}{dd} % 2 
   \fi
%%%%%%%%%%%%%%%%%%
\or% 5
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh} % 0 
    \or
   \newcolumntype{f}{dhhh} % 1
   \or
   \newcolumntype{f}{ddh} % 2 
   \fi
%%%%%%%%%%%%%%%%%%
\or% 6
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhh} % 1
   \or
   \newcolumntype{f}{ddhh} % 2 
    \or
   \newcolumntype{f}{ddd} % 3
   \fi
%%%%%%%%%%%%%%%
\or % 7
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhh} % 2 
   \or
   \newcolumntype{f}{dddh} % 3
   \fi
%%%%%%%%%%%%%%%%%%
\or % 8
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhh} % 2 
   \or
   \newcolumntype{f}{dddhh} % 3
   \or
   \newcolumntype{f}{dddd} % 4
   \fi
%%%%%%%%%%%%%%%%%%
\or % 9
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhh} % 3
   \or
   \newcolumntype{f}{ddddh} % 4
   \fi
%%%%%%%%%%%%%%%%%%
\or %10
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhh} % 3
   \or
   \newcolumntype{f}{ddddhh} % 4
   \or
   \newcolumntype{f}{ddddd} % 5
   \fi
%%%%%%%%%%%%%%%%%%
\or % 11
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhh} % 4
   \or
   \newcolumntype{f}{dddddh} % 5
   \fi
%%%%%%%%%%%%%%%%%%
\or % 12
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhh} % 4
   \or
   \newcolumntype{f}{dddddhh} % 5
   \or
   \newcolumntype{f}{dddddd} % 6
   \fi
%%%%%%%%%%%%%%%%%%
\or %13
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhh} % 5
   \or
   \newcolumntype{f}{ddddddh} % 6
   \fi
%%%%%%%%%%%%%%%%%%
\or %14
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhh} % 6
   \or
   \newcolumntype{f}{ddddddd} % 7
   \fi
%%%%%%%%%%%%%%%%%%
\or %15
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhh} % 6
   \or
   \newcolumntype{f}{dddddddh} % 7
   \fi
%%%%%%%%%%%%%%%%%%
\or %16
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhh} % 7
   \or
   \newcolumntype{f}{dddddddd} % 8
\fi
%%%%%%%%%%%%%%%%%%
\or %17
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhh} % 7
   \or
   \newcolumntype{f}{ddddddddh} % 8
\fi
%%%%%%%%%%%%%%%%%%
\or %18
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhh} % 6
   \or
   \newcolumntype{f}{ddddddhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhh} % 8
   \or
   \newcolumntype{f}{ddddddddd} % 9
\fi
%%%%%%%%%%%%%%%%%%
\or %19
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhh} % 8
   \or
   \newcolumntype{f}{ddddddddddh} % 9
\fi
%%%%%%%%%%%%%%%%%%
\or %20
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh} % 0 
    \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhh} % 8
   \or
   \newcolumntype{f}{dddddddddhh} % 9
   \or
   \newcolumntype{f}{dddddddddd} % 10
   \fi
%%%%%%%%%%%%%%%%%%
\or %21
  \ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh h} % 0 
   \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhhh} % 8
   \or
   \newcolumntype{f}{ddd ddd ddd hhh} % 9
   \or
   \newcolumntype{f}{ddd ddd ddd d h} % 10
   \fi
%%%%%%%%%%%%%%%%%%
\or %22
\ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh hh} % 0 
   \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhhhh} % 8
   \or
   \newcolumntype{f}{ddd ddd ddd hhhh} % 9
   \or
   \newcolumntype{f}{ddd ddd ddd dhh} % 10
   \or
   \newcolumntype{f}{ddddddddddd} % 11
   \fi
%%%%%%%%%%%%%%%%%%
\or %23
\ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh hhh} % 0 
   \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhhhhh} % 8
   \or
   \newcolumntype{f}{ddd ddd ddd hhhhh} % 9
   \or
   \newcolumntype{f}{ddddddddddhhh} % 10
   \or
   \newcolumntype{f}{ddddd ddddd dh} % 11
   \fi
%%%%%%%%%%%%%%%%%%
\or %24
\ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh hhhh} % 0 
   \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhhhhhh} % 8
   \or
   \newcolumntype{f}{ddd ddd ddd hhhhhh} % 9
   \or
   \newcolumntype{f}{ddddddddddhhhh} % 10
   \or
   \newcolumntype{f}{ddddd ddddd dhh} % 11
   \or
   \newcolumntype{f}{ddddd ddddd dd} % 12
   \fi
%%%%%%%%%%%%%%%%%%
\or %25
\ifcase\firsthowmanyDs
   \newcolumntype{f}{hhhhh hhhhh hhhhh hhhhh hhhhh} % 0 
   \or
   \newcolumntype{f}{dhhhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{f}{ddhhhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{f}{dddhhhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{f}{ddddhhhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{f}{dddddhhhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{f}{ddddddhhhhhhhhhhhhh} % 6
   \or
   \newcolumntype{f}{dddddddhhhhhhhhhhh} % 7
   \or
   \newcolumntype{f}{ddddddddhhhhhhhhh} % 8
   \or
   \newcolumntype{f}{ddd ddd ddd hhhhhhh} % 9
   \or
   \newcolumntype{f}{ddddddddddhhhhh} % 10
   \or
   \newcolumntype{f}{dddddddddddhhh} % 11
   \or
   \newcolumntype{f}{ddddddddddddh} % 12
   \fi
%%%%%%%%%%%%%%%%%%
\else
\typeout{^^J----------------------------------------------------- ^^J
Warning!^^J^^J 
Too many Columns using in Splittabular. 
^^J
25 column maximum in
each part of the table.^^J Each`T' counts as two columns.
^^J-----------------------------------------------------^^J}
\fi
}


%% Second dummy columns is the part of the table that will not print,
%% in this case the part to the right.
%%\makeseconddummycolumns

\gdef\makeseconddummycolumns{%
\ifcase\secondcolcount
%0
\or
%1
\newcolumntype{F}{h} % no D possible
%%%%%%%%%%%%%%%%%%
\or
%2
  \ifcase\secondhowmanyDs
  \newcolumntype{F}{hh}%% 0
  \or
  \newcolumntype{F}{d} %% 1
  \fi
%%%%%%%%%%%%%%%%%%
\or
%3
  \ifcase\secondhowmanyDs
  \newcolumntype{F}{hhh} % 0 
  \or
  \newcolumntype{F}{dh} % 1 
  \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhh} % 0 
    \or
   \newcolumntype{F}{dhh} % 1
   \or
   \newcolumntype{F}{dd} % 2 
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh} % 0 
    \or
   \newcolumntype{F}{dhhh} % 1
   \or
   \newcolumntype{F}{ddh} % 2 
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhh} % 1
   \or
   \newcolumntype{F}{ddhh} % 2 
   \or
   \newcolumntype{F}{ddd} % 3
   \fi
%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhh} % 2 
   \or
   \newcolumntype{F}{dddh} % 3
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhh} % 2 
   \or
   \newcolumntype{F}{dddhh} % 3
   \or
   \newcolumntype{F}{dddd} % 4
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhh} % 3
   \or
   \newcolumntype{F}{ddddh} % 4
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhh} % 3
   \or
   \newcolumntype{F}{ddddhh} % 4
   \or
   \newcolumntype{F}{ddddd} % 5
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhh} % 4
   \or
   \newcolumntype{F}{dddddh} % 5
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhh} % 4
   \or
   \newcolumntype{F}{dddddhh} % 5
   \or
   \newcolumntype{F}{dddddd} % 6
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhh} % 5
   \or
   \newcolumntype{F}{ddddddh} % 6
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhh} % 6
   \or
   \newcolumntype{F}{ddddddd} % 7
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhh} % 6
   \or
   \newcolumntype{F}{dddddddh} % 7
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhh} % 7
   \or
   \newcolumntype{F}{dddddddd} % 8
\fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhh} % 7
   \or
   \newcolumntype{F}{ddddddddh} % 8
\fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhh} % 8
   \or
   \newcolumntype{F}{ddddddddd} % 9
\fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhhhhhhhhhhhhhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhh} % 8
   \or
   \newcolumntype{F}{dddddddddh} % 9
\fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh} % 0 
    \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhh} % 8
   \or
   \newcolumntype{F}{dddddddddhh} % 9
   \or
   \newcolumntype{F}{dddddddddd} % 10
   \fi
%%%%%%%%%%%%%%%%%%
\or
  \ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh h} % 0 
   \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhhh} % 8
   \or
   \newcolumntype{F}{ddd ddd ddd hhh} % 9
   \or
   \newcolumntype{F}{ddd ddd ddd d h} % 10
   \fi
%%%%%%%%%%%%%%%%%%
\or
\ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh hh} % 0 
   \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhhhh} % 8
   \or
   \newcolumntype{F}{ddd ddd ddd hhhh} % 9
   \or
   \newcolumntype{F}{ddddddddddhh} % 10
   \or
   \newcolumntype{F}{ddddddddddd} % 11
   \fi
%%%%%%%%%%%%%%%%%%
\or
\ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh hhh} % 0 
   \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhhhhh} % 8
   \or
   \newcolumntype{F}{ddd ddd ddd hhhhh} % 9
   \or
   \newcolumntype{F}{ddddddddddhhh} % 10
   \or
   \newcolumntype{F}{ddddd ddddd dh} % 11
   \fi
%%%%%%%%%%%%%%%%%%
\or
\ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh hhhh} % 0 
   \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhhhhhh} % 8
   \or
   \newcolumntype{F}{ddd ddd ddd hhhhhh} % 9
   \or
   \newcolumntype{F}{ddddddddddhhhh} % 10
   \or
   \newcolumntype{F}{ddddd ddddd dhh} % 11
   \or
   \newcolumntype{F}{ddddd ddddd dd} % 12
   \fi
%%%%%%%%%%%%%%%%%%
\or
\ifcase\secondhowmanyDs
   \newcolumntype{F}{hhhhh hhhhh hhhhh hhhhh hhhhh} % 0 
   \or
   \newcolumntype{F}{dhhhhhhhhhhhhhhhhhhhhhhh} % 1
   \or
   \newcolumntype{F}{ddhhhhhhhhhhhhhhhhhhhhh} % 2 
   \or
   \newcolumntype{F}{dddhhhhhhhhhhhhhhhhhhh} % 3
   \or
   \newcolumntype{F}{ddddhhhhhhhhhhhhhhhhh} % 4
   \or
   \newcolumntype{F}{dddddhhhhhhhhhhhhhhh} % 5
   \or
   \newcolumntype{F}{ddddddhhhhhhhhhhhhh} % 6
   \or
   \newcolumntype{F}{dddddddhhhhhhhhhhh} % 7
   \or
   \newcolumntype{F}{ddddddddhhhhhhhhh} % 8
   \or
   \newcolumntype{F}{ddd ddd ddd hhhhhhh} % 9
   \or
   \newcolumntype{F}{ddddddddddhhhhh} % 10
   \or
   \newcolumntype{F}{ddddd ddddd dhhh} % 11
   \or
   \newcolumntype{F}{ddddd ddddd ddh} % 12
   \fi
%%%%%%%%%%%%%%%%%%
\else
\typeout{^^J----------------------------------------------------- ^^J
Warning!^^J^^J 
Too many Columns using in Splittabular. 
^^J
25 column maximum in
each part of the table.^^J Each`D' counts as two columns.
^^J-----------------------------------------------------^^J}
\fi
}

%% we don't have to worry about D's in this section, fortunately.
\gdef\makethirddummycolumns{
\ifcase\thirdcolcount 
\or\newcolumntype{E}{h}
\or\newcolumntype{E}{hh}
\or\newcolumntype{E}{hhh}
\or\newcolumntype{E}{hhhh}
\or\newcolumntype{E}{hhhhh}
\or\newcolumntype{E}{hhhhhh}
\or\newcolumntype{E}{hhhhhhh}
\or\newcolumntype{E}{hhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhhhhhh}
\or\newcolumntype{E}{hhhhhhhhhhhhhhhhhhhhhhhhh} %% up to 25 columns
\else \typeout{^^J-----------------------------------------------------^^J
Warning!
^^J^^J Too many Columns in Splittabular. 
^^J
25 column maximum in
each part of the table.^^J
Each `D' counts as two columns.
^^J-----------------------------------------------------^^J}\fi
}

%%%%%%%%%%%%%%%%%
%% Colnums

%% defaults

\gdef\settabnumdefaults{%
\loopnum=0\relax\loop%
\ifnum\loopnum<31\relax%
\expandafter\gdef\csname tab\the\loopnum\endcsname{%
\multicolumn1{c}{\global\advance\colnumsused by 1\relax%
(\the\colnumsused)}}%
\global\advance\loopnum by1\repeat}

%%%%%%%%%%%%%%%%%%%%%%%%%
%% this version of countcols  is for \colnumbers
\newcount\totalcolumncount
\def\xH{h}

\makeatother
\def\tabcountcols#1{\ifcat#1c
\global\advance\colcount by 1\relax\fi%
%%
\def\lookforD{#1}%
\ifx\lookforD\xD%
\expandafter\gdef\csname tab\the\colcount\endcsname{%
\multicolumn2{c}{\global\advance\colnumsused by 1\relax%
(\the\colnumsused)}}%
\fi%
\ifx\lookforD\xH%
\expandafter\gdef\csname tab\the\colcount\endcsname{%
\multicolumn1{h}{}}%
\fi%
%%
\futurelet\next\tablookatnext}

\def\tabxeatone#1{\tabcountcols}

%% second conditional deals with expressions like @{} in
%% the preamble.
\def\tablookatnext{\if\next\xrelax\let\xgo\relax\else%
\ifx\next\bgroup\let\xgo\tabxeatone\else\let\xgo\tabcountcols\fi\fi\xgo}
\makeatletter
%%%%%%%%%%%%%%%

\newcount\totalcolumns
\newbox\firsttablebox
\newbox\secondtablebox
\newbox\thirdtablebox
\newif\ifdbreaktab

%% A loop would be more elegant, of course, but using & in a loop
%% within a table column produces errors.
%% was\tabnumberline, now \colnumbers

%% Is this test necessary?
%\newif\ifcolumnums

\newif\ifcolnumberson
\def\deluxecolnumbers{\global\colnumbersontrue}

\def\colnumbers{\omit\\\omit\xcolnumbers}
\def\xcolnumbers{\global\let\colnumbers\xcolnumbers%
\global\colnumbersontrue\let&\CheckNumberAndSwitch%
\global\colcount=0\relax%
\global\totalcolumncount=0\relax%
%% above here
\settabnumdefaults%
%% Now, change the columns that have `D' to be \multicolumn2c, by redefining
%% the \csname tab<number>\endcsname
%%
\expandafter\tabcountcols\tabfullpreamble%
\global\totalcolumncount=\the\colcount\relax%
\global\colcount=0\relax%
\ifbreaktab\else\ifdbreaktab\else\global\colnumsused=0\relax\fi\fi%
%%
%
\ifdeluxe\ifbreaktab\\\else\\[-6pt]\fi%\hline% not above
\else%
\\[-14pt]\fi%
\ifcase\totalcolumncount%
\or%
\csname tab1\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname%
\or
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname%
\or%22
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname%
\or% 24
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname%
\or% 25
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname%
\or% 
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname%
\or% 27
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname%
\or% 28
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname%
\or% 29
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname%
\or% 30
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname&\csname tab30\endcsname%
\else%
\typeout{^^J^^J
Sorry, more than 30 columns cannot be numbered with^^J
\string\colnumbers. Please number the columns manually.^^J
Thank you!^^J}\fi%
%\ifbreaktab
\\\hline% below, hline is wanted
%\else
\noalign{\vskip-8pt}
%\vrule height 28pt width0pt %the \vrule is in the line below colnumbers; 
                          % it causes all the vrules on that line to grow to 28pt.
                          % The -14pt will cause the lower line to overlap the upper line.
                          % Complication, needed to add this vrule to Z and z in order to
                          % have it also work for split tabular.
%\fi
}



\let\savecolnumbers\colnumbers

\gdef\plaincolnumbers{%
\omit\\\omit%
\global\colnumbersontrue\let&\CheckNumberAndSwitch%
\global\colcount=0\relax%
\global\totalcolumncount=0\relax%
%% above here
\settabnumdefaults%
%% Now, change the columns that have `D' to be \multicolumn2c, by redefining
%% the \csname tab<number>\endcsname
%%
\expandafter\tabcountcols\tabfullpreamble%
\global\totalcolumncount=\the\colcount\relax%
\global\colcount=0\relax%
\ifbreaktab\else\ifdbreaktab\else\global\colnumsused=0\relax\fi\fi%
%%
\\\ifcase\totalcolumncount%
\or%
\csname tab1\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname%
\or
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname%
\or%22
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname%
\or% 24
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname%
\or% 25
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname%
\or% 
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname%
\or% 27
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname%
\or% 28
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname%
\or% 29
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname%
\or% 30
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname&\csname tab30\endcsname%
\else%
\typeout{^^J^^J
Sorry, more than 30 columns cannot be numbered with^^J
\string\colnumbers. Please number the columns manually.^^J
Thank you!^^J}\fi%
\\\hline% below, hline is wanted
\\\noalign{\vskip-30pt }%%%%% 
%\vrule height 28pt width0pt %the \vrule is in the line below colnumbers; 
                          % it causes all the vrules on that line to grow to 28pt.
                          % The -14pt will cause the lower line to overlap the upper line.
                          % Complication, needed to add this vrule to Z and z in order to
                          % have it also work for split tabular.
}

\let\saveplaincolnumbers\plaincolnumbers


\def\splitplaincolnumbers{%
\omit\\\omit%
\xplain}

\let\savesplitplaincolnumbers\splitplaincolnumbers

\newif\iffirsttime
\firsttimetrue
\gdef\xplain{%
\global\let\plaincolnumbers\xplain%
\global\colnumbersontrue\let&\CheckNumberAndSwitch%
\global\colcount=0\relax%
\global\totalcolumncount=0\relax%
%% above here
\settabnumdefaults%
%% Now, change the columns that have `D' to be \multicolumn2c, by redefining
%% the \csname tab<number>\endcsname
%%
\expandafter\tabcountcols\tabfullpreamble%
\global\totalcolumncount=\the\colcount\relax%
\global\colcount=0\relax%
\ifbreaktab\else\ifdbreaktab\else\global\colnumsused=0\relax\fi\fi%
%%
\iffirsttime
\\%\hline% above not wanted
\else
\\[-12pt]%\hline% above not wanted
\fi
\ifcase\totalcolumncount%
\or%
\csname tab1\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname%
\or
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname%
\or%22
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname%
\or%
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname%
\or% 24
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname%
\or% 25
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname%
\or% 
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname%
\or% 27
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname%
\or% 28
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname%
\or% 29
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname%
\or% 30
\csname tab1\endcsname&\csname tab2\endcsname&%
\csname tab3\endcsname&\csname tab4\endcsname&%
\csname tab5\endcsname&\csname tab6\endcsname&%
\csname tab7\endcsname&\csname tab8\endcsname&%
\csname tab9\endcsname&\csname tab10\endcsname&%
\csname tab11\endcsname&\csname tab12\endcsname&%
\csname tab13\endcsname&\csname tab14\endcsname&%
\csname tab15\endcsname&\csname tab16\endcsname&%
\csname tab17\endcsname&\csname tab18\endcsname&%
\csname tab19\endcsname&\csname tab20\endcsname&%
\csname tab21\endcsname&\csname tab22\endcsname&%
\csname tab23\endcsname&\csname tab24\endcsname&%
\csname tab25\endcsname&\csname tab26\endcsname&%
\csname tab27\endcsname&\csname tab28\endcsname&%
\csname tab29\endcsname&\csname tab30\endcsname%
\else%
\typeout{^^J^^J
Sorry, more than 30 columns cannot be numbered with^^J
\string\colnumbers. Please number the columns manually.^^J
Thank you!^^J}\fi%
\\\hline% below, hline is wanted
\iffirsttime
\\\noalign{\vskip-30pt}%% 
%\noalign{\vskip-8pt}
\vrule height 28pt width0pt %the \vrule is in the line below colnumbers; 
                          % it causes all the vrules on that line to grow to 28pt.
                          % The -14pt will cause the lower line to overlap the upper line.
                          % Complication, needed to add this vrule to Z and z in order to
                          % have it also work for split tabular.
\fi\global\firsttimefalse
}

\def\decimalcolnumbers{\crcr\saveplaincolnumbers\\%
\noalign{\global\savetabskip\tabskip
\tabskip=0pt
\global\let\extracolsep\relax
\global\let\ddoit\saveddoit
\global\let\zdoit\savezdoit
\vskip-32pt 
}{\vrule height28pt depth0pt width0pt}\relax}

\def\splitdecimalcolnumbers{\\[-15pt]%
\savesplitplaincolnumbers
\global\colnumbersonfalse
\\\noalign{\vskip-32pt %!!!
\global\savetabskip\tabskip
\tabskip=0pt
\global\let\extracolsep\relax
\global\let\ddoit\saveddoit
\global\let\zdoit\savezdoit
}\vrule height 28pt width0pt %!!!
\global\let\splitdecimalcolnumbers\secondsplitdecimalcolnumbers}

\def\secondsplitdecimalcolnumbers{\omit\\ 
\plaincolnumbers
\global\colnumbersonfalse
\\\noalign{\vskip-26pt %!!! was -28pt
\global\savetabskip\tabskip
\tabskip=0pt
\global\let\extracolsep\relax
\global\let\ddoit\saveddoit
\global\let\zdoit\savezdoit
}\\\relax}

\let\savesplitdecimalcolnumbers\splitdecimalcolnumbers

%%AAA
\newif\ifdeluxestar
\expandafter\def\csname deluxetable*\endcsname{\deluxestartrue\bgroup\floattrue \hsize=\textwidth	
\deluxetable}

\expandafter\def\csname enddeluxetable*\endcsname{\enddeluxetable
\egroup
\ifstartlongtable\null\fi% added june 2020
\global\colnumbersonfalse
\global\deluxedecimalsfalse
\global\deluxestarfalse
}

\def\deluxedecimalcolnumbers{\deluxedecimalstrue\colnumbersontrue}
\def\deluxetablecaption#1{\gdef\@tablecaption{#1}}

\newif\ifstartlongtable
\def\startlongtable{\vskip1sp\global\startlongtabletrue}

\newif\iffloat
\def\floattable{\global\deluxestartrue\global\floattrue}

%% for equivalent but in \begin...\end form.
\def\floatrotatetable{\global\deluxestartrue\global\floattrue}
\let\endfloatrotatetable\relax

\newcount\deluxetablecnt
\newdimen\toprulebelowsep
\manuscriptsty@sw{
\toprulebelowsep 30pt
  }{
\toprulebelowsep 18pt
}

\def\deluxetable{\global\deluxetrue
\catcode`\&=\active
\catcode`\$=\active
%% Mar 30, 2019, to make label outside of \caption work correctly
{\advance\c@table by 1
\global\advance\deluxetablecnt by 1
\xdef\@currentlabel{\thetable}}
\let\tablecaption\deluxetablecaption
\deluxetablecaption{}
\ifstartlongtable
%% this works for both deluxetable and deluxetable*:
%% nov 2017:
\def\arraystretch{1.1}
%% March 2019 
\if@two@col\global\returntotwocoltrue\vskip1pt
\ifdeluxestar\onecolumngrid\fi\fi
%%
\ifdeluxestar
\vskip12pt
\fi
\let\go\longdeluxetable
\else
\let\go\ydeluxetable
\fi\go
}

\def\ydeluxetable#1{%
\@ifnextchar[{\xdeluxetable{#1}}{\zdeluxetable{#1}}}

%%
% x and z are the same, except that xdeluxetable allows optional square bracket arg, like [h].
\def\xdeluxetable#1[#2]{\global\breaktabtrue
%% not here
\let\colnumbers\deluxecolnumbers
\global\deluxedecimalsfalse
\let\decimals\deluxedecimals
\let\decimalcolnumbers\deluxedecimalcolnumbers
\let\tablehead\ztablehead
\gdef\tabfullpreamble{#1}%<<== needed
\def\endtabular{\endarray
\global\let\zdoit\relax
\global\let\tdoit\relax
\global\Dfalse}
\global\colnumsused=0
\global\breaktabtrue
\global\colcount=0
%%
%%%%%%%%%%%%
\lineskiplimit=\z@ % restore default setting
\ifmodern%
\@ifundefined{total@deluxe@table@width@\romannumeral\the\deluxetablecnt}{\global\deluxesidewaystablefalse}{%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>465\p@%
    \ifdeluxestar\else\global\deluxestarfalse\fi%
    \ifcenterwidetable\global\centerwidetablefalse\else\global\deluxesidewaystabletrue\fi%
    \else%
      \global\deluxestartrue\global\deluxesidewaystablefalse%
    \fi%
  }%
\else%
  \@ifundefined{total@deluxe@table@width@\romannumeral\the\deluxetablecnt}{\global\deluxesidewaystablefalse}{%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>255\p@%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>516\p@%
    \ifdeluxestar\global\deluxestartrue\else\global\deluxestarfalse\fi%
    \ifcenterwidetable\global\centerwidetablefalse\else\global\deluxesidewaystabletrue\fi%
    \else%
      \global\deluxestartrue\global\deluxesidewaystablefalse%
    \fi%
  \else%
      \global\deluxestarfalse%
  \fi%
  }%
\fi%
%
\ifdeluxestar
\gdef\two{#2}\gdef\checkh{h}
\ifx\two\checkh\onecolumngrid\fi
   \ifdeluxesidewaystable
     \begin{sidewaystable*}\hsize=\textwidth
   \else
     \begin{table*}[#2]\hsize=\textwidth
   \fi
\else
  \begin{table}[#2]
\fi
\noindent\setbox\aassplitbox=\vtop\bgroup%
\currtabletypesize
    \vspace*{\abovedeluxetableskip}
%%

\def\startdata##1\enddata{%
\currtabletypesize
\setbox0=\hbox{
\begin{tabular}{#1}
\pt@head
##1\end{tabular}}
\expandafter\ifx\csname @tablecaption\endcsname\empty\else
%% 
  \ifdigitasset
   \noindent{\hbox%
    to\hsize{\hss\vtop{\hsize=\wd0
      \caption{\@tablecaption}}\hss}}
  \else
   \noindent\hbox to\hsize{\hss\vtop{\hsize=\wd0
    \caption{\@tablecaption}}\hss}
  \fi%
\vskip3pt\fi
%% not here
\global\setbox3\hbox{%
\begin{tabular}{#1}%
  \hline\hline\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep
  }%
\pt@head%
##1\crcr% added october 2017
\omit\\\omit\\\hline\end{tabular}}

%\noindent\hskip-1.25em %% kludge! but seems necessary
\hbox to\hsize{\hss\copy3\hss}
\global\setbox4\vtop\bgroup\ifdeluxestar\hsize=\textwidth\else\hsize=\wd0\fi\leftskip6pt\parindent-6pt
}}

\usepackage[figuresright]{rotating}
\setlength\rotFPtop{0\p@ \@plus 1fil}

\newcount\zdeluxetablecnt
\newif\ifdeluxesidewaystable

\def\zdeluxetable#1{\global\breaktabtrue
\let\colnumbers\deluxecolnumbers
\global\deluxedecimalsfalse
\let\decimals\deluxedecimals
\let\decimalcolnumbers\deluxedecimalcolnumbers
\let\tablehead\ztablehead
\gdef\tabfullpreamble{#1}%<<== needed
\def\endtabular{\endarray
\global\let\zdoit\relax
\global\let\tdoit\relax
\global\Dfalse}
\global\breaktabtrue
\global\colnumsused=0
\global\colcount=0
%%
\global\advance\zdeluxetablecnt\@ne%
%%%%%%%%%%%%
  \lineskiplimit=\z@ % restore default setting
%
\ifmodern%
\@ifundefined{total@deluxe@table@width@\romannumeral\the\deluxetablecnt}{\global\deluxesidewaystablefalse}{%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>465\p@%
    \ifdeluxestar\else\global\deluxestarfalse\fi%
    \ifcenterwidetable\global\centerwidetablefalse\else\global\deluxesidewaystabletrue\fi%
    \else%
      \global\deluxestartrue\global\deluxesidewaystablefalse%
    \fi%
  }%
\else%
  \@ifundefined{total@deluxe@table@width@\romannumeral\the\deluxetablecnt}{\global\deluxesidewaystablefalse}{%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>255\p@%
    \expandafter\ifdim\csname total@deluxe@table@width@\romannumeral\the\deluxetablecnt\endcsname>516\p@%
    \ifdeluxestar\global\deluxestartrue\else\global\deluxestarfalse\fi%
    \ifcenterwidetable\global\centerwidetablefalse\else\global\deluxesidewaystabletrue\fi%
    \else%
      \global\deluxestartrue\global\deluxesidewaystablefalse%
    \fi%
  \else%
      \global\deluxestarfalse%
  \fi%
  }%
\fi%
%
\ifdeluxestar
  \ifdeluxesidewaystable
    \begin{sidewaystable*}\hsize=\textwidth
  \else
    \begin{table*}\hsize=\textwidth
  \fi
\else
  \ifdeluxesidewaystable
    \begin{sidewaystable}\hsize=\textwidth
  \else
    \begin{table}
  \fi
\fi
\noindent\setbox\aassplitbox=\vtop\bgroup%
\currtabletypesize
    \vspace*{\abovedeluxetableskip}
%%
\def\startdata##1\enddata{%
\currtabletypesize
\setbox0=\hbox{\colnumbersonfalse
\begin{tabular}{#1}
\pt@head %% 
##1\end{tabular}}% not here
\expandafter\ifx\csname @tablecaption\endcsname\empty\else
  \ifdigitasset
   \noindent{\hbox%
to\hsize{\hss\vtop{\hsize=\wd0
\caption{\@tablecaption}}\hss}}
\vskip-\baselineskip
\else
   \noindent\hbox to\hsize{\hss\vtop{\hsize=\wd0
       \caption{\@tablecaption}}\hss}
\fi%
\vskip3pt\fi
\global\setbox3\hbox{%
\begin{tabular}{#1}%
\hline\hline\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep}%
\pt@head%
##1\crcr%% added October 2017
\omit\\\omit\\\hline\end{tabular}}%%<<== original
\vskip-\parskip
\noindent\hbox to\hsize{\hss\copy3\hss}
\global\setbox4\vtop\bgroup\hsize=\wd0\relax
\leftskip6pt\parindent-6pt
%
\immediate\write\@mainaux{\string\gdef\string\total@deluxe@table@width@\romannumeral\deluxetablecnt{\the\wd3}}
%
}}

%%% 
\newbox\longtablebox
\def\longdeluxetable#1{
\global\rotateonfalse
\let\colnumbers\deluxecolnumbers
\global\deluxedecimalsfalse
\let\decimals\deluxedecimals
\let\decimalcolnumbers\deluxedecimalcolnumbers
\let\tablehead\ztablehead
\gdef\tabfullpreamble{#1}%<<== needed
\def\endtabular{\endarray
\global\let\zdoit\relax
\global\let\tdoit\relax
\global\Dfalse}
\global\colnumsused=0
\global\colcount=0
%%
%%%%%%%%%%%%
  \lineskiplimit=\z@ % restore default setting
\let\enddeluxetable\endlongdeluxetable
    \vspace*{\abovedeluxetableskip}
%%
\def\startdata##1\enddata{%
\global\setbox\longtablebox=\hbox{\currtabletypesize
\tabcolsep=3pt
\begin{tabular}{#1}
\pt@head
##1\end{tabular}}
%%%
\bgroup\centering
\def\table@hook{\currtabletypesize}
      \LTcapwidth=\wd\longtablebox
%% march 2019, added [c] and these terms: 
\ifcenterwidetable\global\centerwidetablefalse
  \def\LT@LR@c{\LTleft=0pt minus1fill 
  \let\LTright\LTleft}%
\else
%% default, will center table that is narrower than text width
  \def\LT@LR@c{\LTleft=0pt plus1fill 
  \LTright\LTleft}%
\fi
%%
%
\begin{longtable}[c]{#1}%%
\ifdim\movetableright>0pt
 \noalign{\ifdim\movetableright>0pt
  \global\LTleft=\movetableright
 \fi}
%
 \noalign{\hbox to \wd\longtablebox{
 \vtop{\hsize=.8\wd\longtablebox 
  \advance\baselineskip4pt
 \raggedright
  {\bf \fnum@table}.\vrule depth 6pt width0pt\
  \@tablecaption}\hss}\vskip-3pt }\\
  \hline
  \hline\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep}%
 \pt@head%
\else
\caption{\hsize=\wd\longtablebox 
\advance\baselineskip2pt
\@tablecaption}\\ %
\hline\hline\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep}%
\pt@head%
\fi
\endfirsthead

\noalign{\centerline{\small 
\hskip\movetableright{\bf \fnum@table}\ \it(continued)}\vskip6pt}
\hline\hline
\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep}
\pt@head%
\endhead

\hline
\multicolumn{\totalcolumns}{c}{\vrule height 24pt width0pt\small\it
\fnum@table\
continued  \if@two@col\else on next page\fi}\\ 
\endfoot

\hline%\nobreak
\endlastfoot
##1
\end{longtable}
\vglue-\LTpost
\vskip-6pt
\egroup
\global\setbox4=\vtop\bgroup
\ifdim\wd\longtablebox>\textwidth
\hsize=\textwidth
\else
\hsize=\wd\longtablebox\fi
\leftskip=6pt
\parindent=-6pt
\currtabletypesize
\global\startlongtablefalse
\global\movetableright=0pt
}% end data, endlongtable
}

\def\endlongdeluxetable{
%%
\vrule depth 6pt width 0pt
\vskip1sp
\egroup
\ifdim\dp4>6pt
\vglue-6pt
\vbox{\hbox to \columnwidth{\hfill
\vtop{\hsize\wd\longtablebox
\leftskip=6pt\parindent-6pt
\copy4
}\hfill}%%
}
\fi
\vglue\ht4 
\global\colnumbersonfalse
\global\deluxedecimalsfalse
\global\rotateonfalse
%%
\relax\null%% \null is an empty hbox.
%% This keeps final page(s) of startlongtable/deluxetable
%% from begin thrown away when at end of article.
% \global\advance\c@table-1\relax
%%
%
%% march 2019
\ifdeluxestar%Feb 2024
\ifreturntotwocol\global\returntotwocolfalse\twocolumngrid\fi\fi
%% May 2020
\ifappendixon
\if@two@col@app
\twocolumngrid
\else
\onecolumngrid\fi\fi
\null
}%% 


%% bbb
%% \end{deluxetable}:
\def\enddeluxetable{%
\egroup%end box 4
\ifdim\dp4>6pt
\hbox to\hsize{\hss\copy4\hss}
\fi
\egroup% end splitbox
\centering
\ifrotateon\global\rotateonfalse
\rotatebox{90}{\hbox to\textheight{\hfill\vbox{
\unvbox\aassplitbox
\vspace*{\belowdeluxetableskip}}\hfill}}
\else
\centering\unvbox\aassplitbox
\vspace*{\belowdeluxetableskip}
\vspace*{24pt}
\fi
\ifdeluxestar
  \ifdeluxesidewaystable
    \end{sidewaystable*}
  \else
    \end{table*}
  \fi
  \global\deluxestarfalse
  \if@two@col\twocolumngrid\hsize=\columnwidth\fi%% check this!!
\else
  \ifdeluxesidewaystable
    \end{sidewaystable}
  \else
    \end{table}
  \fi
\fi
%\null
% added june 2020
\gdef\colnumbers{\saveplaincolnumbers}
\global\breaktabfalse
\global\deluxefalse
\global\colnumbersonfalse
\global\deluxedecimalsfalse
\global\rotateonfalse
\startlongtablefalse
\global\movetableright=0pt
%\global\floatfalse
%\global\advance\c@table by -1\relax
%% check this!!
}


\newbox\aassplitbox
\newif\ifdeluxe
\def\splitdeluxetable{
%% Mar 30, 2019, to make label outside of \caption work correctly
{\advance\c@table by 1
\xdef\@currentlabel{\thetable}}
\global\deluxetrue\catcode`\&=\active
\catcode`\$=\active
\xsplitdeluxetable}

\def\xsplitdeluxetable#1{
\global\breaktabtrue
\let\colnumbers\deluxecolnumbers
\let\decimals\deluxedecimals
\global\deluxedecimalsfalse
\let\decimalcolnumbers\deluxedecimalcolnumbers
\let\tablehead\xtablehead
\gdef\tabfullpreamble{#1}
\def\endtabular{\endarray
\global\let\zdoit\relax
\global\let\tdoit\relax
\global\Dfalse}
%%% modification of emulateapj \deluxetable %%%%
\setbox0=\hbox{\def\firstarg{#1}\expandafter\lookforD\firstarg}
\gdef\temppreamble{#1\relax}
\PartsOfTable=0
\def\tempfullpreamble{#1BB}
\setbox0=\hbox{\expandafter\checkforB\tempfullpreamble}
%% Now PartsOfTable is either =2 or 3
%%
\gdef\one{#1Z}
\global\colnumsused=0
\global\breaktabtrue
\global\colcount=0
%%
\ifnum\PartsOfTable=3
\let\multicolumn\threebreakmulticolumn
\else
\let\multicolumn\breakmulticolumn
\fi
%%%%%%%%%%%%
  \lineskiplimit=\z@ % restore default setting
  \gdef\tblnote@list{}
  \gdef\tblref@list{}
  \ifsplitstar
    \begin{table*}
  \else
    \begin{table}
  \fi
\noindent\setbox\aassplitbox=\vtop\bgroup%
\currtabletypesize
    \vspace*{\abovedeluxetableskip}
\let\startdata\xstartdata}
%% \end{splitdeluxetable}:

\newdimen\movetabledown

\def\endsplitdeluxetable{\vskip1sp\egroup%% end box with tablenotes
\hbox to \hsize{\hss\copy4\hss}
\egroup
\vskip1pt
\ifrotateon\global\rotateonfalse
\vskip\movetabledown\rotatebox{90}{\vbox{\noindent\unvbox\aassplitbox %
\vspace*{\belowdeluxetableskip}
}}\global\movetabledown=0pt\else
\noindent\unvbox\aassplitbox
\vspace*{\belowdeluxetableskip}
\fi
\ifsplitstar
  \end{table*}
\else
  \end{table}
\fi
\gdef\colnumbers{\saveplaincolnumbers}
\tabletypesize{\small}
\global\breaktabfalse
\global\deluxefalse
\global\splitstarfalse
\global\colnumbersonfalse
\global\deluxedecimalsfalse
}


\newif\ifsplitstar
\expandafter\def\csname splitdeluxetable*\endcsname{\global\splitstartrue\splitdeluxetable}
\expandafter\def\csname endsplitdeluxetable*\endcsname{\endsplitdeluxetable\global\splitstarfalse 
\global\colnumbersonfalse
\global\deluxedecimalsfalse
}

\newdimen\maxtablewidth

\gdef\NoTableCaption{\global\@table@not@headedtrue}

%% For splitdeluxetable

%%% ====================================================== %%%
\gdef\dbreaktabular{\catcode`\&=\active
\let&\CheckNumberAndSwitch\xdbreaktabular}

\long\gdef\xdbreaktabular#1{%% #1=contents of table
{\global\maxtablewidth=0pt
\let&\CheckNumberAndSwitch
\let$\savedollar
\global\colnumsused=0
%%$
\global\dbreaktabtrue
\global\colcount=0
%%
\ifnum\PartsOfTable=3
\let\multicolumn\threebreakmulticolumn
\else
\let\multicolumn\breakmulticolumn
\fi
%%
\ifnum\PartsOfTable=3
\expandafter\catchfirstpreamble\one
\expandafter\catchsecondofthreepreamble\one
\expandafter\catchthirdpreamble\one
\makefirstdummycolumns
\makeseconddummycolumns
\makethirddummycolumns
\else %% PartsOfTable=2
\ifnum\PartsOfTable=2
\expandafter\catchfirstpreamble\one
\expandafter\catchsecondpreamble\one
\makefirstdummycolumns
\makeseconddummycolumns
\fi\fi
%%%
\global\columncount=0
\ifnum\PartsOfTable=3
%% For table divided into three parts
\firstboxtrue\secondboxfalse\thirdboxfalse
\setbox\firsttablebox=\hbox{%
\begin{tabular}{AFE}
\ifx\csname pt@head\endcsname\relax\else
\pt@head\fi#1\crcr\end{tabular}}
\global\maxtablewidth=\wd\firsttablebox

\noindent\hbox to \hsize{\hss\unhbox\firsttablebox\hss}
\vskip6pt
\hrule
\vskip6pt
\global\columncount=0
\firstboxfalse\secondboxtrue\thirdboxfalse
\ifcolnumberson%
\setbox\secondtablebox=\hbox{%
\let\savecolnumbers\xcolnumbers%
\notfirsttrue%
\begin{tabular}{fZE} %fZE !!!
\ifx\csname pt@head\endcsname\relax\else%
\pt@head\fi#1\crcr\end{tabular}}
\else
%%
\setbox\secondtablebox=\hbox{%
\begin{tabular}{fZE}%
\ifx\csname pt@head\endcsname\relax\else%
\pt@head\fi\\ [-14pt]% 
#1\crcr%
\end{tabular}}
\fi
\ifdim\wd\secondtablebox>\maxtablewidth
\global\maxtablewidth\wd\secondtablebox\fi

\noindent\hbox to \hsize{\hss\unhbox\secondtablebox\hss}
%%
\vskip6pt
\hrule
\vskip6pt
\firstboxfalse\secondboxfalse\thirdboxtrue
\global\columncount=0
\ifcolnumberson
\notfirsttrue
\setbox\thirdtablebox=\hbox{
\let\savecolnumbers\xcolnumbers
\notfirsttrue
\begin{tabular}{fFz}
\ifx\csname pt@head\endcsname\relax\else
\pt@head\fi#1\crcr\end{tabular}}
\else
\setbox\thirdtablebox=\hbox{
\begin{tabular}{fFz}
\ifx\csname pt@head\endcsname\relax\else
\pt@head\fi\\[-14pt]
#1
\end{tabular}}
\fi
\ifdim\wd\thirdtablebox>\maxtablewidth
\global\maxtablewidth\wd\thirdtablebox\fi

\noindent\hbox to \hsize{\hss\unhbox\thirdtablebox\hss}
\vskip6pt
\hrule
\else
%% Original for table divided into two parts
\global\columncount=0
\secondboxfalse
\setbox\firsttablebox=\hbox{%
\begin{tabular}{AF}
\ifx\csname pt@head\endcsname\relax\else
\pt@head\fi%
#1\end{tabular}}
\global\maxtablewidth=\wd\firsttablebox
\hbox to \hsize{\hss\unhbox\firsttablebox\hss}
\vskip6pt
\hrule
\vskip6pt
\global\columncount=0
\secondboxtrue
\ifcolnumberson
\setbox\secondtablebox=\hbox{%
\let\savecolnumbers\xcolnumbers
\notfirsttrue
\begin{tabular}{fZ}%%
\ifx\csname pt@head\endcsname\relax\else%
\pt@head\fi#1\crcr%%= tablecontents
\end{tabular}}%
\else
\setbox\secondtablebox=\hbox{%
\begin{tabular}{fZ}%% was 12
\ifx\csname pt@head\endcsname\relax\else%
\pt@head\fi\\[-14pt]%
#1%%= tablecontents
\end{tabular}}\fi
\ifdim\wd\secondtablebox>\maxtablewidth
\global\maxtablewidth\wd\secondtablebox\fi

\noindent\hbox to \hsize{\hss\unhbox\secondtablebox\hss}
\vskip6pt
\hrule
\secondboxtrue
%%
%% end of conditional testing for 2 or 3 part table:
\fi
%%
\global\dbreaktabfalse}}
%%% ====================================================== %%%

\newif\ifnotfirst
%% 
%% xstartdata, modified from \startdata in emulateapj, for splitdeluxetable
\gdef\xstartdata#1\enddata{\def\tablecontents{%
\ifcolnumberson%
\\\savecolnumbers\\[2pt]\fi% this is for top level split
\ifdeluxedecimals\savedecimals\fi%
#1}%
\currtabletypesize%
\setbox2=\vtop{\dbreaktabular{\tablecontents}}%
%
\expandafter\ifx\csname @tablecaption\endcsname\empty\else
\noindent\hbox
to\hsize{\hss\vtop{\hsize=\maxtablewidth\caption{\@tablecaption}}\hss}\vskip3pt\fi
\dbreaktabular{\tablecontents\noalign{\global\let\zdoit\relax
\global\let\ddoit\relax}}
\parindent=0pt
\global\setbox4=\vtop\bgroup% egroup in enddeluxetable
\currtabletypesize
\ifsplitstar
\hsize=\textwidth\else\hsize=245.3pt\fi
\parindent=-6pt \leftskip=6pt 
}

\def\tablecomments#1{\vskip1pt{\small\vskip1sp\indent\vrule height 11pt depth 2pt
width 0pt\currtabletypesize{\sc Note}---{#1}\vskip1pt}}

\def\tablenotetext#1#2{\vskip1pt{\currtabletypesize\vskip1pt\indent\vrule
height 11pt depth
2pt width0pt\relax$^{\hbox to 5pt{$#1$}}$#2\vskip1pt}}

\def\tablerefs#1{{\small\vskip3pt\indent\vrule height 11pt depth 2pt
width 0pt\currtabletypesize{\bf References}---{#1}\vskip1sp}}

\let\tablereferences\tablerefs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Simple entry decimal numbers

%% extra unused args are to get rid of unnecessary commands revtex puts in
\gdef\lookfordecimal#1#2#3#4.#5 {\gdef\xone{{\let$\relax\savedollar#4\savedollar}}
\gdef\xtwo{#5}\ifx\xtwo\empty\else\gdef\xtwo{{\let$\relax\savedollar#5\savedollar}}\fi}

%% D 
\def\newdoit{\setbox0=\hbox\bgroup\zdoit}
\def\endnewdoit{\egroup\unhbox0}

\long\gdef\zdoit#1 {\let$\relax %$
\def\bothcols{#1 }%
\setbox0=\hbox{\let$\relax\expandafter\lookfordecimal\bothcols{}{}{}{}.{} }% $
\xdoit}

\global\let\savezdoit\zdoit
\let\zdoit\relax

\gdef\xdoit{\relax\hskip\tabcolsep\relax\xone&\tabskip=0pt%
\ifx\xtwo\empty\let\go\relax\else.\def\go{\xtwo}\fi\go}

%% d
\def\xnewdoit{\setbox0=\hbox\bgroup\ddoit}
\def\xendnewdoit{\egroup}

\long\gdef\ddoit#1#2#3{\xxdoit}
\let\saveddoit\ddoit
\let\ddoit\relax

%% to delete all D material: 

\gdef\xxdoit{&}

\newcolumntype{D}{>\newdoit r<{\endnewdoit} @{}l}%% 
\newcolumntype{d}{>\xnewdoit h<{\xendnewdoit} @{}h} %% 

\newdimen\savetabskip
\gdef\decimals{\noalign{\global\savetabskip\tabskip
\tabskip=0pt
\global\let\extracolsep\relax
\global\let\ddoit\saveddoit
\global\let\zdoit\savezdoit
}}

\let\savedecimals\decimals

%% to allow \decimals to be used before \startdata:
\newif\ifdeluxedecimals
\def\deluxedecimals{\global\deluxedecimalstrue}

%%%%%%%%%
%% This needed to be redefined so that \colhead in \tablehead would span both parts
%% of decimal numbers.

%% in case there isn't a table head
\let\pt@head\relax

%% for splitdeluxetable
\def\xtablehead{\catcode`\&=\active%
\catcode`\$=\active%
\xxtablehead}

%%
\def\xxtablehead#1{%
\let&\CheckNumberAndSwitch%
\gdef\pt@head{%
\hline\hline%
\multicolumn1c{\vrule height 12pt width0pt\relax\tempcounter=0
\expandafter\getDs\tabfullpreamble\relax
\global\colcount=0
\global\colheadcount=0}%
\\ 
\iftwelvepoint%
  \ifpreprinttwo%
    \iflongrotateon\else\noalign{\vskip-6.5pt}\fi%
  \else%
    \ifmodern\iflongrotateon\else\noalign{\vskip-9pt}\fi%
    \else%
    \fi%% end ifmodern
  \fi%% end ifpreprinttwo
\else%
%% not twelvepoint
  \if@twocolumn%
    \iflongrotateon\else\noalign{\vskip-5pt}\fi%
  \else%
    \ifonecolstyle% default
      \iflongrotateon\noalign{\vskip2pt}\else\noalign{\advance\toprulebelowsep-\f@size pt \vskip-\toprulebelowsep}\fi%
    \fi% end ifonecol
  \fi%endif@twocolumn
\fi%end iftwelvepoint
#1\ifcolnumberson%
\ifnotfirst\\[-22pt]\fi
\else\\\hline\\[-8pt]\fi% space below hline for 2nd and 3rd part of split table 
}%
%
}

\def\ztablehead{\catcode`\&=\active%
\catcode`\$=\active%
\zztablehead}

\def\zztablehead#1{\let&\CheckNumberAndSwitch%
\gdef\pt@head{%
%% this is needed:
\multicolumn1c{\vrule height12pt width0pt\relax\expandafter\getDs\tabfullpreamble\relax
\global\tempcounter=0
\global\colcount=0
\global\colheadcount=0}\\
\iftwelvepoint%
    \ifpreprinttwo%
      \iflongrotateon\else\noalign{\vskip-6.5pt}\fi%
    \else%
      \ifmodern%
        \iflongrotateon\else\noalign{\vskip-5pt}\fi%
      \else%
      \fi%% end ifmodern
    \fi%% end ifpreprinttwo
\else%
%% not twelvepoint
    \if@twocolumn%
    \iflongrotateon\else\noalign{\vskip-5pt}\fi%
          \else%
              \ifonecolstyle% default
                \iflongrotateon\noalign{\vskip2pt}\else\noalign{\vskip-4.5pt}\fi%
              \fi% end ifonecol
   \fi%endif@twocolumn
\fi%end iftwelvepoint
#1\unskip%
\ifcolnumberson\\[6pt]
\savecolnumbers\vrule height 11pt depth 4pt width 0pt\relax%
\\%
\ifdeluxedecimals\\[-14pt]% 
\savedecimals\fi%
\else \vrule depth 6pt
width0pt\\\ifdeluxedecimals\savedecimals\fi\hline\fi%
}}


\newcount\tempcounter

\gdef\getDs#1{\let&\CheckNumberAndSwitch
\def\lookforD{#1}%
\ifx\lookforD\xD%
\expandafter\gdef\csname col\the\tempcounter\endcsname{2}\else
\expandafter\gdef\csname col\the\tempcounter\endcsname{1}\fi 
\global\advance\tempcounter by 1
\futurelet\next\checkingpreamble}

\gdef\checkingpreamble{\ifx\next\relax
\let\go\relax\else\let\go\getDs\fi\go}

%%% Something like this could be used to automate the width of colheads in the tablehead,
%% making those that match the D in preamble are multicolumn2c instead of
%% multicolumn 1c.
\newcount\colheadcount
\newcommand\xcolhead[1]{\multicolumn{\expandafter\ifx\csname
col\the\colheadcount\endcsname\relax 1\else\expandafter%
\csname col\the\colheadcount\endcsname\fi}{c}{\vrule depth 4pt
width0pt\relax#1\relax\global\advance\colheadcount
by 1\relax}\ignorespaces}%
%

%%
\extrarowheight=2pt
\def\matrixpreamble{*\c@MaxMatrixCols c}
%% this causes problem, must be fixed!
%\let\save@array@array@new\@array@array@new
\def\@array@array@new[#1]#2{%
\ifbreaktab
\else
%%% added so that we can use \colnumbers in any tabular environment
%%% and avoid error messages for breaktabular
\def\catchpreamble{#2\relax}
\gdef\tabfullpreamble{#2\relax}
{\colcount=0
%% important fix, makes it possible to use amsmath and matrices.
\def\two{#2}
\ifx\matrixpreamble\two
\else
\expandafter\countcols\catchpreamble
\global\totalcolumns=\colcount\fi}
\fi
%%% end of additions
  \@tempdima\ht\strutbox
  \advance\@tempdima by\extrarowheight
  \setbox\@arstrutbox\hbox{%
   \vrule \@height\arraystretch\@tempdima
          \@depth \arraystretch\dp\strutbox
          \@width \z@
  }%
  \begingroup
   \@mkpream{#2}%
   \xdef\@preamble{\@preamble}%
  \endgroup
  \prepdef\@preamble{%
   \tabskip\tabmid@skip
    \@arstrut
  }%
  \appdef\@preamble{%
   \tabskip\tabright@skip
   \cr
   \array@row@pre
  }%
  \@arrayleft
  \@nameuse{@array@align@#1}%
  \m@th
  \let\\\new@arraycr %<<== defined above, original plus reset counters
  \let\tabularnewline\\%
  \let\par\@empty
  \let\@sharp##%
  \set@typeset@protect
  \lineskip\z@\baselineskip\z@
  \tabskip\tableft@skip
  \everycr{}%
  \expandafter\halign\expandafter\@halignto\expandafter\bgroup\@preamble
}%

%% \rotate 
\newif\ifrotateon
\def\rotate{\global\floattrue\iffloat\global\let\go\relax\global\rotateontrue\else
\global\rotateonfalse 
\let\go\relax
\fi\go}

\def\colnumbers{\plaincolnumbers}

%% add 6pt of space between table and following text:
\let\saveendtable\endtable
\def\endtable{\vskip6pt\saveendtable}
\expandafter \let \csname endtable*\endcsname = \endtable
%%


%%% \movetabledown works
\newbox\rotatetablebox
\def\rotatetable{%
\clearpage
\global\startlongtabletrue\setbox\rotatetablebox=\vbox\bgroup
}

\def\endrotatetable{\egroup
\vglue\movetabledown
\hbox to
\textwidth{\hss\rotatebox{90}{\hbox{\box\rotatetablebox}}\hss}
\global\movetabledown=0pt\relax
\global\startlongtablefalse
}

%%% \movetabledown works
\expandafter\def\csname rotatetable*\endcsname{%
\clearpage
\global\startlongtabletrue\setbox\rotatetablebox=\vbox to
\textwidth\bgroup\vfill}

\expandafter\def\csname endrotatetable*\endcsname{\vfill\egroup
\vbox to \textheight{\vfill
\vglue\movetabledown
\hbox to
\textwidth{\hss\rotatebox{90}{\box\rotatetablebox}\hss}\global\movetabledown=0pt\relax 
\vfill}
\clearpage
\if@two@col
\twocolumngrid
\global\startlongtablefalse
}

%
%%% \movetabledown works
\newif\iflongrotateon
\def\longrotatetable{%
\global\longrotateontrue
   \if@two@col\onecolumngrid\clearpage
   \fi
\clearpage
   \clearpage
  \begingroup
\expandafter\def\csname deluxetable*\endcsname{\deluxetable}
\expandafter\def\csname enddeluxetable*\endcsname{\enddeluxetable}
\global\floatfalse
\global\startlongtabletrue
\def\LS@rot{%
  \setbox\@outputbox\vbox{\vskip\movetabledown\hbox{\rotatebox{90}{\box\@outputbox}}}}

\let\LS@makecol=\@makecol
\let\LS@makefcolumn=\@makefcolumn

  \vsize=\textwidth
  \hsize=\textheight
  \linewidth=\hsize
  \columnwidth=\hsize
  \@colroom=\vsize
  \textheight=\vsize
  \@colht=\vsize
  \def\@makecol{\LS@makecol\LS@rot}%
  \def\@makefcolumn##1{\LS@makefcolumn{##1}\LS@rot}}

\def\endlongrotatetable{%
\onecolumngrid %% ??
\clearpage
  \ifGin@pdftex
    \pdfpageattr{/Rotate 90}
  \fi
  \clearpage
  \endgroup
   \if@two@col\twocolumngrid\fi
\clearpage
\global\longrotateonfalse
\global\movetabledown=0pt
  \global\@colht=\textheight
  \global\vsize=\textheight
  \global\@colroom=\textheight}

\newif\ifGin@pdftex
\Gin@pdftexfalse
\DeclareOption{pdftex}{%
  \PassOptionsToPackage\CurrentOption{graphicx}
  \Gin@pdftextrue
}

\DeclareOption*{\PassOptionsToPackage\CurrentOption{graphicx}}
\ProcessOptions

%% set &, $ catcode back to normal:

\catcode`&=4
\catcode`$=3



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% end table tools $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gridlines for positioning multiple illustrations in 
%% one figure environment.

\def\gridline#1{\vskip6pt\hbox to\hsize{#1}\vskip6pt}

\def\boxedfig#1#2#3{\hfill\fbox{\vbox{\parskip=0pt\relax
\hsize=#2
\includegraphics[width=#2]{#1}\vskip2pt\vtop{\hsize=#2
\centerline{#3}}}}\hfill}

\def\fig#1#2#3{\hfill\vbox{\parskip=0pt\hsize=#2
\includegraphics[width=#2]{#1}\vskip2pt\vtop{\centering
\footnotesize
\hsize=#2
#3\vskip1pt
}}\hfill}

\def\leftfig#1#2#3{\vbox{\parskip=0pt\relax\hsize=#2
\includegraphics[width=#2]{#1}\vskip2pt\vtop{\hsize=#2
\centering
#3\vskip1sp\vskip1sp}}\hfill}

\def\rightfig#1#2#3{\hfill\vbox{\parskip=0pt\relax\hsize=#2
\includegraphics[width=#2]{#1}\vskip2pt\vtop{\hsize=#2
\centering#3\vskip1sp}}}

\def\rotatefig#1#2#3#4{\hfill\vbox{\centering\parskip=0pt\hsize=#3
\includegraphics[width=#3,angle=#1]{#2}\vskip2pt\vtop{\centering
\footnotesize
\hsize=#3
#4\vskip1pt
}}\hfill}

%%%%%%%%%% End Grid line Macros %%%%%%%%%%

%%%%%%%%%% Color Editing Macros %%%%%%%%%%
\newif\ifturnoffedit
\def\turnoffedit{\global\turnoffedittrue}
\def\turnoffedits{\global\turnoffedittrue}
\let\turnoffediting\turnoffedits

\newif\ifturnoffone
\newif\ifturnofftwo
\newif\ifturnoffthree

\def\turnoffeditone{\turnoffonetrue}
\def\turnoffedittwo{\turnofftwotrue}
\def\turnoffeditthree{\turnoffthreetrue}


%% Other choices can be made, but this should be
%% standardized, so didn't make an user interface
%% to change the colors easily.

\expandafter\def\csname editcolor1\endcsname{black}% was magenta
\expandafter\def\csname editcolor2\endcsname{black}% was blue
\expandafter\def\csname editcolor3\endcsname{black}% was violet

\let\newgo\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Draft watermark

\definecolor{ltgray}{gray}{.9}% .89
\font\bighelv=phvr at 2in %
\def\setwatermarkfontsize#1{\font\bighelv=phvr at #1}

\def\watermark#1{\def\thewatermark{\hbox to\textwidth{\vtop to
1.1\textheight{\vss
\hskip24pt\rotatebox{60}{\hbox{\bighelv \color{ltgray} 
\uppercase{#1}}}\vss}}\hss}}
\let\thewatermark\empty

%% Used in titlepage definition, as \pagestyle{titlepage}
\def\ps@titlepage{%
  \let\@mkboth\@gobbletwo
\def\@oddhead{\ifx\thewatermark\empty\hfill\else
\hbox to \textwidth{\rlap{\thewatermark}\hfill}\fi}
\let\@oddfoot\@empty
\let\@evenhead\@empty\let\@evenfoot\@empty}

% end of watermark definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*\submitjournal[1]
{\def\@submitted{Submitted to #1}}%

\newcount\tempallauthorcnt
\newcount\printallauthorcnt
%% this one is used &&&
\def\titleblock@produce{%
 \begingroup
 \ltx@footnote@pop
 \def\@mpfn{mpfootnote}% 
 \def\thempfn{\thempfootnote}%
 \c@mpfootnote\z@
 \let\@makefnmark\frontmatter@makefnmark
  \frontmatter@setup
  \thispagestyle{titlepage}\label{FirstPage}%
\ifmodern\leftskip=0pt\rightskip\leftskip\fi
  \frontmatter@title@produce
  \groupauthors@sw{%
  \frontmatter@author@produce@group
  }{%
   \frontmatter@author@produce@script
  }%
  \frontmatter@RRAPformat{%
\vskip12pt
   \expandafter\produce@RRAP\expandafter{\@date}%
   \expandafter\produce@RRAP\expandafter{\@received}%
   \expandafter\produce@RRAP\expandafter{\@revised}%
   \expandafter\produce@RRAP\expandafter{\@accepted}%
   \expandafter\produce@RRAP\expandafter{\@published}%
  }%
\expandafter\ifx\csname @submitted\endcsname\relax\else
\vskip6pt
\expandafter\produce@RRAP\expandafter{\centerline{\@submitted\hbox
to 20pt{\hfill}}\vskip12pt}%
\fi
  \frontmatter@abstract@produce
  \@ifx@empty\@keywords{}{%
   \@keywords@produce\@keywords
  }%
  \par
  \frontmatter@finalspace
  \tempallauthorcnt\allauthorcnt%
  \ifnum\tempallauthorcnt>\z@%
   \@whilenum\tempallauthorcnt>\z@\do{%
     \global\advance\printallauthorcnt\@ne%
     \@ifundefined{affil@\romannumeral\the\printallauthorcnt}{\affil@error{\csname author@data@\romannumeral\the\printallauthorcnt\endcsname }}{}\par%
     \@ifundefined{email@\romannumeral\the\printallauthorcnt}{\email@error{\csname author@data@\romannumeral\the\printallauthorcnt\endcsname}}{}\par%
     \global\advance\tempallauthorcnt\m@ne%
     }%
  \fi%
\endgroup%
}%


% needed??
\gdef\specialbibitem#1[#2]#3#4{
{\tt\string\bibitem}[#2]{\tt\string{\string}}
#4}



%%%%%%%%%%%%%%%%%%%%%%%%%
%% Track Changes
%% Amy Hendrickson, Nov 2015
%% Change Jan 2016, to allow list of changes
%% to give line and page numbers for more than one entry on the same line.
%% Change Feb 2016, to allow optional argument for time/date, and/or editor initials, etc.


\providecolor{trackchange}{cmyk}{0,0,0,1}
\providecolor{explain}{cmyk}{0,0,0,1}

\newif\ifsilent

\newcount\refchangenumber
\DeclareRobustCommand\added{\@ifnextchar[{\xadded}{\yadded}}

\long\def\xadded[#1]#2{%
\iftrack 
{\global\advance\refchangenumber by 1\relax%
\vtop to 0pt{\vss
\hypertarget{link\the\refchangenumber}{}
\vskip14pt}%
\ifnumlines%
%% \ifabstract\else%
%%  \protected@xdef\doit{\noexpand\linelabel{\the\refchangenumber}}\doit\fi
\else%
\xdef\doit{\noexpand\label{\the\refchangenumber}{}{}{}}\doit\fi}%
{\color{trackchange}\bf [#1] #2}%%
\ifabstract\label{\the\refchangenumber}%
\expandafter\gdef\csname
changenum\the\refchangenumber\endcsname{\bf  [#1]
\textcolor{trackchange}\bf\relax{#2}\global\silenttrue}%
\else\expandafter\gdef\csname
changenum\the\refchangenumber\endcsname{\bf\relax  [#1]
\textcolor{trackchange}\bf\relax{\let\bibitem\specialbibitem #2}\global\silentfalse}\fi%
\else#2\fi}



\long\def\yadded#1{%
\iftrack
{\global\advance\refchangenumber by 1\relax%
\vtop to 0pt{\vss
\hypertarget{link\the\refchangenumber}{}
\vskip14pt}%
 \ifnumlines
\else%
 \xdef\doit{\noexpand\label{\the\refchangenumber}{}{}{}}\doit%
 \fi}%
{\color{trackchange}\bf #1}%%
\ifabstract%
\label{\the\refchangenumber}%
\expandafter\gdef\csname
changenum\the\refchangenumber\endcsname{\bf 
\textcolor{trackchange}\bf\relax{#1},
\global\silenttrue}\else
\expandafter\gdef\csname changenum\the\refchangenumber\endcsname{\bf 
\textcolor{trackchange}{\bf\relax\let\bibitem\specialbibitem #1},%
\global\silentfalse}\fi%
\else{#1}\fi}



\def\deleted{\@latex@error{=================^^J^^J!!! The deleted command no longer
  allowed!^^J^^J Please use \@backslashchar added{}{}^^J^^J
  Thank-you!^^J^^J=================}\@ehc\stop}%


\DeclareRobustCommand\replaced{\@latex@error{=================^^J^^J!!! The replaced command no longer
  allowed!^^J^^J Please use \@backslashchar added{}{}^^J^^J
  Thank-you!^^J^^J=================}\@ehc\stop}%


\def\explain{\@ifnextchar[{\xexplain}{\yexplain}}

\def\xexplain[#1]#2{\iftrack\ {\bfseries\itshape\color{explain} [Explanation of change:
#2 (#1)]\ }\fi}

\def\yexplain#1{\iftrack\ {\bfseries\itshape\color{explain} [Explanation of change:
#1]\ }\fi}


\newcount\listchangenum

\def\listofchanges{\@latex@error{=================^^J^^J!!! The \string\listofchanges{} command no longer
  allowed!^^J^^J 
  Thank-you!^^J^^J=================}\@ehc\stop}


\usepackage[normalem]{ulem}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% From earlier version of AASTeX, for usefulness and 
%% backward compatibility, with some requested additions

\let\jnl@style=\rmfamily
\def\ref@jnl#1{{\jnl@style#1}}%

%%%
\newcommand\memsai{\ref@jnl{Mem.~Soc.~Astron.~Italiana}}%
          % Mem. Societa Astronomica Italiana
%% longer version:
\newcommand\memsocai{Mem. Societ\`a Astronomica Italiana}
\newcommand\aspconf{Ast. Soc. of the Pac. Conference Series}

\let\astap=\aap
\let\apjlett=\apjl
\let\apjsupp=\apjs
\let\applopt=\ao

%%% More useful commands from Earlier version of Aastex:
\let\la=\lesssim            % For Springer A&A compliance...
\let\ga=\gtrsim

\let\farcm\farcm@mss
\let\farcs\farcs@mss


\def\chem@bnd#1{%
 {%
  \kern.1em\relax
  \setbox\z@\hbox{M}%
  \dimen@ii.8em\relax
  \p@=.1em\relax
  \dimen@.5\ht\z@\dimen@i-\dimen@
  \advance\dimen@1.5\p@\advance\dimen@i-1.0\p@
  #1%
  \kern.1em\relax
  }%
 }%
\def\@sbnd{%
 \advance\dimen@-1.5\p@\advance\dimen@i1.5\p@
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 }%
\def\@dbnd{%
 \advance\dimen@-0.5\p@\advance\dimen@i0.5\p@
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 \advance\dimen@-1.5\p@\advance\dimen@i1.5\p@
 \hskip-\dimen@ii
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 }%
\def\@tbnd{%
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 \advance\dimen@-1.5\p@\advance\dimen@i1.5\p@
 \hskip-\dimen@ii
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 \advance\dimen@-1.5\p@\advance\dimen@i1.5\p@
 \hskip-\dimen@ii
 \vrule\@height\dimen@\@depth\dimen@i\@width\dimen@ii\nobreak
 }%

\renewcommand\LaTeX{%
 \leavevmode
 L%
 \raise.42ex\hbox{%
  \count@=\the\fam
  $\fam\count@\scriptstyle\kern-.3em A$% $
 }%
 \kern-.15em\TeX
}%

%% added Feb 2, 2016, redefining definition of \caption made with hyperref
%% package. Making \caption[] be the default, to prevent sending caption 
%% text to listoftables or listoffigures, which we are not going to use
%% anyway. This change enables track changes commands to work in captions.
\def\xtable{table}
\def\caption{\numlinesfalse
\ifx\@captype\@undefined 
\@latex@error {\noexpand \caption outside float}\@ehd 
\expandafter \@gobble \else 
\H@refstepcounter \@captype \let \Hy@tempa \@caption \@ifundefined
{float@caption}{}
{\expandafter \ifx \csname @float@c@\@captype\endcsname
\float@caption\let\Hy@tempa\Hy@float@caption\fi} 
\expandafter\@firstofone\fi 
{\@dblarg {\Hy@tempa \@captype}}[]}

\def\@caption#1[#2]#3{{\small\rm\expandafter \ifx \csname if@capstart\expandafter \endcsname 
\csname iftrue\endcsname \global \let \@currentHref \hc@currentHref \else \hyper@makecurrent {\@captype }\fi 
\@ifundefined {NR@gettitle}{\def \@currentlabelname{\thesection\relax #2}}
{\NR@gettitle {#2}}\par 
%\addcontentsline {\csname ext@#1\endcsname }{#1}{\protect \numberline {\csname the#1\endcsname }{\ignorespaces #2}}
\begingroup \@parboxrestore \if@minipage \@setminipage \fi \normalsize 
\expandafter\ifx \csname if@capstart\expandafter \endcsname 
\csname iftrue\endcsname \global \@capstartfalse 
\@makecaption {\bf\csname fnum@#1\endcsname }{\ignorespaces #3}
\else \@makecaption {\bf\csname fnum@#1\endcsname }{\ignorespaces \ifHy@nesting 
\expandafter \hyper@@anchor \expandafter {\@currentHref }{#3}\else 
\Hy@raisedlink {\expandafter \hyper@@anchor \expandafter
{\@currentHref }{\relax }}{#3}\fi }\fi \par
\endgroup}}

%% changed, March 23, 2019, took out \\ at end of definition:
\newcommand\tablebreak{\\[-11pt]\noalign{\break}}

%% As suggested by Greg Schwarz, August Meunch, Feb 11

\def\dataset{\def\doi##1{https://doi.org/##1}
\@ifnextchar[{\ydataset}{\xdataset}}
\def\xdataset#1{\ydataset[]{#1}\let\doi\savedoi}
\def\ydataset[#1]#2{\def\one{#1}\ifx\one\empty
\href{#2}{[DATASET]}\else
\href{#2}{#1}\fi\let\doi\savedoi}

%% this seems in the middle of nowhere...
\advance\columnsep6pt

%%%%%%%%%%
%% macros to give hyperref link to authors when orcid numbers
%% are supplied with \author[0000-2345-3333-0023]{author name}
 \def\lookforbracket{\ifx\next[\let\go\xauthor\else\let\go\yauthor\fi\go}

\newcount\entriesinthiscollab 
\newcount\allentries
\newif\ifseesmessage
\newcount\allauthorcnt


\def\author{\global\advance\allauthorcnt\@ne\relax\global\advance\entriesinthiscollab by 1\relax%
  \global\advance\allentries by 1\relax\global\correspauthorfalse%
  \let\ignorespacesafterend\protect\ignorespacesafterend%
  \futurelet\next\lookforbracket}


\def\new@author@def#1#2#3{%
 \move@AU\move@AF\move@AUAF
 \let\@AF@join\@author@join
\ifx!#1!\relax%
  \ifthenelse{\equal{#3}{yes}}{\def\@author{{#2\IfFileExists{CoFirstAuthor.png}{\hskip2pt\includegraphics[width=9pt]{CoFirstAuthor}}{}}{}}}{
\expandafter\gdef\csname author@data@\romannumeral\the\allauthorcnt\endcsname{#2}%
\def\@author{{#2}{}}}%
  %
 \else%
\ifthenelse{\equal{#3}{yes}}{%
  \expandafter\gdef\csname author@data@\romannumeral\the\allauthorcnt\endcsname{#2}%
 \protected@xdef\@author{{\href{http://orcid.org/#1}{#2\protect\IfFileExists{Orcid-ID.png}{\hskip2pt\protect\includegraphics[width=9pt]{Orcid-ID.png}}{}}{\protect\IfFileExists{CoFirstAuthor.png}{\hskip2pt\leavevmode\protect\includegraphics[width=9pt]{CoFirstAuthor}}{}%
}}{}}}{%
\expandafter\gdef\csname author@data@\romannumeral\the\allauthorcnt\endcsname{#2}%
 \protected@xdef\@author{{\href{http://orcid.org/#1}{#2%
\protect\IfFileExists{Orcid-ID.png}{%
\hskip2pt\protect\includegraphics[width=9pt]{Orcid-ID.png}}{}%
}}{}}}\fi%
}%

\def\orciderrormessage{%
\typeout{^^J^^J [\firstarg]\space Invalid ORCID Identifier!^^J^^J The ID
should consist of four sets of four digits,^^J separated with -, ie,
0000-0012-3245-1234 or ^^J
0000-0012-3245-123X
^^J^^J
Please fix, or don't use square bracket argument with
\string\author[]\string{\string}
^^J^^J}%
}

%% Tests to see if author gave reasonable Orcid number;
%% if not, stops processing and gives error message.
\newif\ifbadOrcid
\def\lookatOrcid #1-#2-#3-#4-{%
\def\one{#1}\def\two{#2}\def\three{#3}\def\four{#4}%
\ifx\one\empty%
\global\badOrcidtrue%
\else%
\ifx\two\empty%
\global\badOrcidtrue%
\else%
\ifx\three\empty%
\global\badOrcidtrue%
\else%
\ifx\four\empty%
\global\badOrcidtrue%
\fi\fi\fi\fi}

\def\lookforDigits #1#2#3#4{
\def\xone{#1}\def\xtwo{#2}\def\xthree{#3}\def\xfour{#4}
%%
\ifx\xone\empty 
\global\badOrcidtrue
\else
  \ifcat \xone 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xtwo\empty 
\global\badOrcidtrue
\else
 \ifcat \xtwo 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xthree\empty 
\global\badOrcidtrue
\else
 \ifcat \xthree 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xfour\empty 
\global\badOrcidtrue
\else
 \ifcat \xfour 1\else
  \global\badOrcidtrue\fi
\fi}

\def\FinallookforDigits #1#2#3#4{
\def\xone{#1}\def\xtwo{#2}\def\xthree{#3}\def\xfour{#4}
%%
\ifx\xone\empty 
\global\badOrcidtrue
\else
  \ifcat \xone 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xtwo\empty 
\global\badOrcidtrue
\else
 \ifcat \xtwo 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xthree\empty 
\global\badOrcidtrue
\else
 \ifcat \xthree 1\else
  \global\badOrcidtrue\fi
\fi
%%%
\ifx\xfour\empty 
\global\badOrcidtrue
\else
   \ifcat \xfour 1\else
      \if\xfour X
      \else
      \global\badOrcidtrue\fi%
   \fi%
\fi}


%% Last digit might be X
\let\@orcid\empty
\def\@filter@audata#1=#2\@nil{%
  \ifthenelse{\equal{#2}{orcid}}{\def\@orcid{#1}}{%
  \ifthenelse{\equal{#2}{\space orcid}}{\def\@orcid{#1}}{%
    \ifthenelse{\equal{#2}{co-firstauthor}}{}{%
    \ifthenelse{\equal{#2}{\space co-firstauthor}}{}{%
    \ifthenelse{\equal{#2}{suffix}}{}{%
      \ifthenelse{\equal{#2}{\space suffix}}{}{%
        \ifthenelse{\equal{#2}{\space gname}}{}{%
          \ifthenelse{\equal{#2}{\space sname}}{}{%
            \ifthenelse{\equal{#2}{sname}}{}{%
              \ifthenelse{\equal{#2}{gname}}{}{\@latex@error{"#2" should be orcid, gname, sname or suffix}\@ehc}}}}}}}}}}%
}

\def\@cofirstauthor{no}
\newcount\cofirstauthorcnt

\def\filter@audata#1=#2\@nil{%
\@ifx{!#2!}{\ifthenelse{\equal{#1}{co-firstauthor}}{\global\advance\cofirstauthorcnt\@ne\gdef\@cofirstauthor{no}}{%
\ifthenelse{\equal{#1}{ co-firstauthor}}{\global\advance\cofirstauthorcnt\@ne\gdef\@cofirstauthor{no}}{%
\xdef\@orcid{#1}}}}{\expandafter\@filter@audata#2#1\@nil}
}

\def\xauthor[#1]#2{\def\@cofirstauthor{no}\def\@orcid{}%
\@for\@audata:=#1\do{%
  \expandafter\filter@audata\@audata=\@nil}
 \ifx\@orcid\@empty%
   \ifthenelse{\equal{\@cofirstauthor}{yes}}{\new@author@def{}{#2}{yes}}{\new@author@def{}{#2}{no}}%
 \else%
\edef\testone{\@orcid-}\edef\firstarg{\@orcid}%
\setbox0=\hbox{\expandafter\lookatOrcid\testone {}-{}-{}-{}-
\expandafter\lookforDigits\one {}{}{}{}%
\expandafter\lookforDigits\two {}{}{}{}%
\expandafter\lookforDigits\three {}{}{}{}%
\expandafter\FinallookforDigits\four {}{}{}{}}%
%%
\ifbadOrcid\let\go\orciderrormessage
\else\let\go\relax\fi\go%
\ifbadOrcid\let\go\stop\else\let\go\relax\fi\go%
 \ifthenelse{\equal{\@cofirstauthor}{yes}}{\new@author@def{\@orcid}{#2}{yes}}{\new@author@def{\@orcid}{#2}{no}}%
\fi
}%% oct 7, this doesn't seem to work

\def\yauthor{\@author@def{}}


\newcount\AuthorCollaborationLimit
\let\AuthorCallLimit\AuthorCollaborationLimit
%% no limit for default
\AuthorCollaborationLimit=10000
\newcount\largestAffilNum

\def\lookfornumbers#1#2#3#4#5#6#7#8#9{\def\one{#1}
\def\two{#2}
\def\three{#3}
\def\four{#4}
\def\five{#5}
\def\six{#6}
\def\seven{#7}
\def\eight{#8}
\def\nine{#9}
\ifnum\one>\largestAffilNum
\global\largestAffilNum=\one\fi
%%%
\ifx\two\empty\else
\ifnum\two>\largestAffilNum
\global\largestAffilNum=\two\fi\fi
%%%
\ifx\three\empty\else
\ifnum\three>\largestAffilNum
\global\largestAffilNum=\three\fi\fi
%%%
\ifx\four\empty\else
\ifnum\four>\largestAffilNum
\global\largestAffilNum=\four\fi\fi
%%%
\ifx\five\empty\else
\ifnum\five>\largestAffilNum
\global\largestAffilNum=\five\fi\fi
%%%
\ifx\six\empty\else
\ifnum\six>\largestAffilNum
\global\largestAffilNum=\six\fi\fi
%%%
\ifx\seven\empty\else
\ifnum\seven>\largestAffilNum
\global\largestAffilNum=\seven\fi\fi
%%%
\ifx\eight\empty\else
\ifnum\eight>\largestAffilNum
\global\largestAffilNum=\eight\fi\fi
%%%
\ifx\nine\empty\else
\ifnum\nine>\largestAffilNum
\global\largestAffilNum=\nine\fi\fi
}

%\gdef\newcomma@space{\hskip-3pt\textsuperscript{,}}%
\def\doEtAl{\rm et al.\gdef\doEtAl{\relax}}
%% =====================
\newif\iffirsttime
\firsttimetrue
\newcount\totalentries
\newcount\docollabnum
\newcount\@docollabnum\@docollabnum\@ne
\newcount\tempauthornumber
\newcount\countauthors
\newif\ifdothis
\def\doAnd{}
\newcount\testnum

\def\olddoauthor#1#2#3{%
\iflongauthor\vskip6pt\fi
\global\advance\countauthors by 1
\ifnum\countauthors>\AuthorCollaborationLimit
\doEtAl
\else
\ifnum\AuthorCollaborationLimit=1
\let\@listand\relax
\fi
  \ignorespaces\leavevmode\hbox{#1\unskip\@listcomma}% nice, keeps name from breaking across lines
\fi
  \begingroup
\ifnum\countauthors>\AuthorCollaborationLimit\else
  #3% all affil numbers
\ifx\@affilID@temp\empty
\else%
\setbox0=\hbox{\expandafter\lookfornumbers\@affilID@temp{}{}{}{}{}{}{}{}{}}%
\fi\fi
%% #2= \altaffiliation{} or \email{} or 
%% possibly anything other than author, affiliation, or collaboration 
  \@if@empty{#2}{\endgroup{}{}}
{\ifnum\countauthors>\AuthorCollaborationLimit\endgroup{}{}%% <<< bug fix, added \endgroup{}{}
\else
\endgroup{\comma@space}{}\frontmatter@footnote{#2}\fi}%
\ifnum\countauthors>\AuthorCollaborationLimit\else  \space
\@listand\fi 
}%

\newif\ifaddspace

\newcount\restauentries

\def\authorcnt#1{\global\restauentries=#1}
\authorcnt{0}


\def\doauthor#1#2#3{%
\iflongauthor\vskip6pt\fi%%%
\ifanonymous%
    \iffirsttime%
     \global\firsttimefalse%
     Anonymous author(s)%
    \fi%
\else%% ends at end of this def
%%%
\@ifundefined{specificCollabLimit\the\@docollabnum}{%
 \@ifnum{\restauentries<\z@}{\AuthorCollaborationLimit=9999}{%
 \AuthorCollaborationLimit=\restauentries}%
}{%
 \AuthorCollaborationLimit=\csname specificCollabLimit\the\@docollabnum\endcsname%
}%
%% this won't change until after collaboration name at end
 %% end ifnum\docollabnum
%%
%%%%%%%%%%%%%%%%
\global\advance\totalentries by 1\relax%
\global\advance\countauthors by 1\relax%
%%%
\ifallauthors\global\AuthorCollaborationLimit=9999 \fi%
%%%
%
\gdef\xone{#1}%
\ifnum\countauthors < \AuthorCollaborationLimit
\global\addspacetrue
\gdef\docomma{,}\else\gdef\docomma{}\fi% ok
%%%
\ifnum\countauthors = \AuthorCollaborationLimit
\ifnum\AuthorCollaborationLimit=\@ne\gdef\doAnd{}\else
\gdef\doAnd{And }\fi%
\ifnum\tempauthornumber= 1
\gdef\doAnd{  } \fi\fi%
%%
{\tempauthorminusone=\AuthorCollaborationLimit
\advance\tempauthorminusone by -1
\ifnum\countauthors=\tempauthorminusone
\gdef\doAnd{And }%
\gdef\docomma{}\fi}%
%%%
\global\dothisfalse%
%% if num countauthors is less than or equal to \AuthorCollaborationLimit, print name
\ifnum\countauthors< \AuthorCollaborationLimit
%%% 
\ifx\xone\empty\else%
\global\dothistrue%
%\expandafter\gdef\csname
%dothisaffil-\the\countauthors\the\docollab\endcsname{dothisone}
  \ignorespaces\leavevmode\hbox{#1\unskip\docomma}% nice, keeps name from breaking across lines
\fi%
\fi%
%%
\ifnum\countauthors= \AuthorCollaborationLimit
%%% 
\ifx\xone\empty\else
\global\dothistrue
  \ignorespaces\leavevmode\hbox{\doAnd #1\unskip\docomma}%nice, keeps name from breaking across lines
\fi%
\fi%
%% ++++
%%
\ifsuppressAffiliations\else%
\ifx\xone\empty\else%
\begingroup%
\ifnum\countauthors>\AuthorCollaborationLimit\else
  #3% all affil numbers
\ifx\@affilID@temp\empty %% number following author
\else%
\setbox0=\hbox{\expandafter\lookfornumbers\@affilID@temp{}{}{}{}{}{}{}{}{}}%
\fi\fi%
%% #2= \altaffiliation{} or \email{} or 
%% possibly anything other than author, affiliation, or collaboration 
  \@if@empty{#2}{\endgroup{}{}}%
{\ifnum\countauthors>\AuthorCollaborationLimit\endgroup{}{}%% <<< bug fix, added \endgroup{}{}
\else
\endgroup{\comma@space}{}\frontmatter@footnote{#2}\fi}%
\fi%% end test of empty
\fi%% end test of suppressAffiliations
%%%%%%%%%%%%%%%%%%%%%%%%
%%% Collaboration name is always used if available:
\expandafter\ifx\csname currCollabName\the\totalentries\endcsname\relax\else 
%%%
%%%
%%%
%% changed locally:
{\advance\docollabnum 1 
\advance\countauthors-1
%%%
%%% We need to test to see if more than one author in collaboration
%%% and if the number of authors is greater than the \AuthorCollaborationLimit.
%%% If both of these are true, than use `et al.' , otherwise do not:
\expandafter\ifx\csname CollabTotalAuthors\the\docollabnum\endcsname\relax
\else
\expandafter\ifnum\csname CollabTotalAuthors\the\docollabnum\endcsname < 2 %%%%% Don't use et al if there is only one author
\else
\expandafter\ifnum\csname CollabTotalAuthors\the\docollabnum\endcsname>\AuthorCollaborationLimit\relax%
\ifnum\AuthorCollaborationLimit=0\else
\vskip3pt
{\rm et al.} \vskip-3pt
\fi\fi\fi\fi%
}%% end local change to docollabnum
%%%%
\expandafter\ifx\csname currCollabName\the\totalentries\endcsname\empty
\vskip-3pt
\else
\vskip6pt
\expandafter\csname currCollabName\the\totalentries\endcsname\vskip8pt
\affiliation{testing}
\fi%
%%%%%%%%
\global\advance\@docollabnum\@ne
\global\countauthors=0
%%%
%%%
\global\advance\docollabnum  by 1
%% Set up counters for next time through this loop:
{\advance\docollabnum by1
  \expandafter\ifx\csname specificCollabLimit\the\docollabnum\endcsname\relax
 \else
   \global\AuthorCollaborationLimit=\csname specificCollabLimit\the\docollabnum\endcsname 
  \fi%
\expandafter\ifx\csname CollabTotalAuthors\the\docollabnum\endcsname\relax
\else
\global\tempauthornumber= \csname CollabTotalAuthors\the\docollabnum\endcsname
\fi}%
\fi %% ends test to see if it is time to use collaboration name
\fi %% ends ifanonymous
%
\ifaddspace\ \fi\global\addspacefalse}% oct 7, 2020, allows multiple names to break over lines,
                                         %but no extra space if \collaboration{1}


%%%% 
\newcount\tempauthorminusone
%% 
\def\doAllauthors#1#2#3{%
\global\suppressAffiliationsfalse
\iflongauthor\vskip6pt\fi
%%%
\ifanonymous
    \iffirsttime
     \global\firsttimefalse
     Anonymous author(s)
    \fi
\else %% ends at end of this def
%%%
\ifnum\docollabnum< 1
%% these won't change until after collaboration name at end
\global\AuthorCollaborationLimit\expandafter\csname currCollabLimit0\endcsname 
\global\tempauthornumber=\csname CollabTotalAuthors1\endcsname
\fi%% end ifnum\docollabnum
%%
%%%%%%%%%%%%%%%%
\global\advance\totalentries by 1
\global\advance\countauthors by 1
%%%
\ifallauthors\global\AuthorCollaborationLimit=9999 \fi
%%%
% for testing
%[author number=\the\countauthors/ temp author
%=\the\tempauthornumber]
\def\one{#1}
{\tempauthorminusone=\tempauthornumber
\advance\tempauthorminusone by -1
\ifnum\countauthors < \tempauthornumber
\gdef\xdocomma{,}%
\else\gdef\xdocomma{}\fi%
%%%
\ifnum\countauthors = \tempauthornumber
\gdef\xdoAnd{And}\gdef\xdocomma{}%
\else\gdef\xdoAnd{}\fi%
\ifnum\tempauthornumber= 1
\gdef\xdoAnd{}\gdef\xdocomma{}\fi%
\ifnum\countauthors=\tempauthorminusone
\gdef\xdocomma{}\fi%
}
%%%
%% if num countauthors is less than or equal to \AuthorCollaborationLimit, print name
\ifnum\countauthors< \AuthorCollaborationLimit
%%% 
\ifx\one\empty\else
  \ignorespaces\leavevmode\hbox{\unskip\xdoAnd\ #1\unskip\xdocomma}% nice, keeps name from breaking across lines
\fi\fi%
%%
\ifnum\countauthors= \AuthorCollaborationLimit
%%% 
\ifx\one\empty\else
\ignorespaces\leavevmode\hbox{\unskip\xdoAnd\ #1\unskip\xdocomma}% nice, keeps name from breaking across lines
\fi%
\fi%
%%
\ifx\one\empty\else
 \begingroup
\ifnum\countauthors>\AuthorCollaborationLimit\else
  #3% all affil numbers
\ifx\@affilID@temp\empty
\else%
\setbox0=\hbox{\expandafter\lookfornumbers\@affilID@temp{}{}{}{}{}{}{}{}{}}%
\fi\fi
%% #2= \altaffiliation{} or \email{} or 
%% possibly anything other than author, affiliation, or collaboration 
  \@if@empty{#2}{\endgroup{}{}}
{\ifnum\countauthors>\AuthorCollaborationLimit\endgroup{}{}%% <<< bug fix, added \endgroup{}{}
\else
\endgroup{\comma@space}{}\frontmatter@footnote{#2}\fi}%
\fi%% end test of empty
%%%%%%%%%%%%%%%%%%%%%%%%
%%% Collaboration name is always used if available:
\expandafter\ifx\csname currCollabName\the\totalentries\endcsname\relax\else 
%%%
%% No et al in allauthors, because all authors are listed!
%%
\expandafter\ifx\csname currCollabName\the\totalentries\endcsname\empty
\else
\vskip6pt
\expandafter\csname currCollabName\the\totalentries\endcsname\vskip6pt
\fi
\global\countauthors=0
%%%
%%%
\global\advance\docollabnum  by 1
%% Set up counters for next time through this loop:
{\advance\docollabnum by1
  \expandafter\ifx\csname specificCollabLimit\the\docollabnum\endcsname\relax
 \else
   \global\AuthorCollaborationLimit=\csname specificCollabLimit\the\docollabnum\endcsname 
  \fi
%
\expandafter\ifx\csname CollabTotalAuthors\the\docollabnum\endcsname\relax
\else
\global\tempauthornumber=\csname CollabTotalAuthors\the\docollabnum\endcsname
\fi}
\fi %% ends test to see if it is time to use collaboration name
\fi %% ends ifanonymous
}% 

%%%
%% set \affil to match \affiliation found in revtex, since authors are accustomed to using \affil{}
\let\affil\affiliation

\newif\iffirstaffil
\firstaffiltrue

\newcount\affilnum
%%
\def\@affil@script#1#2#3#4{%
\ifsuppressAffiliations\else
\iffirstaffil
% Oct 2017
\vskip2pt
\global\firstaffilfalse\fi
 \@ifnum{#1=\z@}{}{%
  \par
  \begingroup
   \frontmatter@affiliationfont
   \@ifnum{\c@affil<\affil@cutoff}{}{%
\def\one{#1}
%%
%%
\ifnum\one<\largestAffilNum
%% this makes the numbers
   \def\@thefnmark{#1}\@makefnmark\fi
\ifnum\one=\largestAffilNum
   \def\@thefnmark{#1}\@makefnmark\fi
   }%
\ifnum\one<\largestAffilNum
   \ignorespaces#3%
\fi
\ifnum\one=\largestAffilNum
   \ignorespaces#3%
\fi
   \@if@empty{#4}{}{\frontmatter@footnote{#4}}%
   \par
  \endgroup
 }%
\fi}%

\newif\ifnobreakafterkeywords
\def\NoNewPageAfterKeywords{\global\nobreakafterkeywordstrue}
\NoNewPageAfterKeywords
\def\NewPageAfterKeywords{\global\nobreakafterkeywordsfalse}

%%%
\def\frontmatter@maketitle{%
\onecolumngrid\ifnumlines\linenumbers\fi
\@author@finish
\ifthenelse{\equal{\@cofirstauthor}{yes}}{\cofirstauthor}{}%
%
\if@firstsection% not appendix, in other words
  \title@column\titleblock@produce 
\else
%
\global\firstaffiltrue
 \title@column\secondtitleblock@produce
\fi
  \suppressfloats[t]%
  \let\affiliation\@gobble
  \let\author\@gobble
\if@firstsection
\let\abstract\@undefined\let\endabstract\@undefined
\titlepage@sw{%
\ifnobreakafterkeywords
\else
\vfil
\clearpage
\fi
 }{}%
\fi
\ifresetfootnote
  \setcounter{footnote}{0}%
\else
  \setcounter{footnote}{\the\c@affil}%
\fi
\immediate\write\@mainaux{\string\authorcnt{\the\allauthorcnt}}
}%


\let\maketitle\frontmatter@maketitle

\def\secondtitleblock@produce{%
 \begingroup
  \ltx@footnote@pop
  \def\@mpfn{footnote}%
  \def\thempfn{\thefootnote}%
  \c@footnote\z@
  \let\@makefnmark\frontmatter@makefnmark
%  \frontmatter@setup
  \thispagestyle{titlepage}%\label{FirstPage}%
%  \frontmatter@title@produce
  \groupauthors@sw{%
   \frontmatter@author@produce@group
  }{%
   \frontmatter@author@produce@script
  }%
  \endgroup
}%

%% no club or widow lines
\widowpenalty=10000
\clubpenalty\widowpenalty
\setlength{\footnotesep}{8pt}

\ifmodern
\setlength{\voffset}{0in}
\setlength{\hoffset}{0in}
\setlength{\textwidth}{6in}
\setlength{\textheight}{9.2in}
\setlength{\headheight}{0ex}
\setlength{\headsep}{36pt} % this is 2 lines in ``manuscript''
\setlength{\footnotesep}{0in}
\setlength{\topmargin}{-\headsep}
\setlength{\oddsidemargin}{0.25in}
\setlength{\evensidemargin}{0.25in}
\setlength{\parindent}{0.54\baselineskip}
\sloppy\sloppypar
\fi


\def\tempfootmark#1{}

\newcount\c@affilcount
\newcommand*\altaffiliation[2][]{%
\@AF@join{\ifanonymous\else
#1#2\ifmodern\baselineskip=14pt\fi
\if@two@col\hsize=.5\textwidth
\advance\hsize by -18pt
\fi\fi}%
}%

\newif\ifcorrespauthor
\newif\if@correspauthor
\let\@correspondingauthor\empty

\def\correspondingauthor#1{{\ifanonymous%
 \else\global\@correspauthortrue\global\correspauthortrue%
\renewcommand\thefootnote{}%
\gdef\@correspondingauthor{#1}%
\footnotetext{\hskip-11ptCorresponding author: #1\ifmodern\vrule depth 5pt width 0pt\relax\fi}%
\fi}%
}

\def\cofirstauthor{{\ifanonymous
\else\global\correspauthortrue%
\renewcommand\thefootnote{}
\@ifnum{\cofirstauthorcnt=\@ne}{
%\footnotetext{This author share co-first authorship \ifmodern\vrule depth 5pt width 0pt\relax\fi}
}{\@ifnum{\cofirstauthorcnt>\@ne}{%\footnotetext{There are multiple co-first authors for this work\ifmodern\vrule depth 5pt width 0pt\relax\fi}
}{}}
\fi}}


\let\@@email\empty
\def\email{\@ifnextchar[\@email{\@email[]}}



\def\@email[#1]#2{\ifanonymous
\else\ifcorrespauthor%
{\onecolumngrid\renewcommand\thefootnote{}\addtocounter{footnote}{-1}%
\footnote{\hskip-11pt\href{mailto: #2}{#2}\ifmodern\vrule depth 7pt width 0pt\relax\else\vrule depth 7pt width0pt\fi}}
\else%
\expandafter\gdef\csname email@\romannumeral\the\allauthorcnt\endcsname{}%
\ifthenelse{\equal{#1}{show}}{%
\protected@xdef\@@email{\ifx\@@email\empty#2\else\@@email, #2\fi}}{}%
\fi\fi\global\correspauthorfalse}

\def\nocollaboration#1{%
\collaboration{#1}{\vbox to 0pt{\vss\centerline{---}\vskip2pt}}
}

\def\xcollaboration#1#2{
\global\advance\allentries by 1
\expandafter\def\csname
currCollabLimit\the\allentries\endcsname{#1}
\@author@def{\@booleantrue
\collaboration@sw}{#2}
}

\let\savelistand\@listand
\newcount\numauthors
\newcount\collabnum
\newbox\collabnamebox

\edef\chk@all{all}
\edef\chk@All{All}


\newif\ifcollaborationon
\def\collaboration#1#2{\global\collaborationontrue
\global\advance\collabnum by 1
\expandafter\xdef\csname CollabTotalAuthors\the\collabnum\endcsname{\the\entriesinthiscollab} 
\edef\@temp{#1}% 
\@ifx{\@temp\chk@All}{\typeout{=================^^J^^J!!! In \string\collaboration\space {All} should be in lower case {all}.
  !^^J^^J 
  Thank-you!^^J^^J=================}\stop}{}
 \@ifx{\@temp\chk@all}{
  \expandafter\xdef\csname currCollabLimit0\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname}
 }{
  \expandafter\ifnum\@temp>\csname CollabTotalAuthors\the\collabnum\endcsname
    \expandafter\xdef\csname currCollabLimit0\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname}
  \else
    \expandafter\xdef\csname currCollabLimit0\endcsname{#1}
  \fi
}
\@ifx{\@temp\chk@all}{
  \expandafter\xdef\csname specificCollabLimit\the\collabnum\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname} 
 }{
  \expandafter\ifnum\@temp>\csname CollabTotalAuthors\the\collabnum\endcsname
    \expandafter\xdef\csname specificCollabLimit\the\collabnum\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname}
  \else
    \expandafter\xdef\csname specificCollabLimit\the\collabnum\endcsname{#1}
  \fi
 }
\global\entriesinthiscollab=0
%%Calculating the Last group of authors
\advance\expandafter\restauentries-\csname specificCollabLimit\the\collabnum\endcsname
%
\global\advance\allentries by 1
%% 
%% we should have only one of these with this number; this used to say when
%% use specificCollabLimit:
\@ifx{\@temp\chk@all}{
  \expandafter\xdef\csname currCollabLimit\the\allentries\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname}
}{
  \expandafter\ifnum\@temp>\csname CollabTotalAuthors\the\collabnum\endcsname
    \expandafter\xdef\csname currCollabLimit\the\allentries\endcsname{\csname CollabTotalAuthors\the\collabnum\endcsname}
  \else
    \expandafter\xdef\csname currCollabLimit\the\allentries\endcsname{#1}
  \fi
}
%% we should have only one of these with this number
\expandafter\gdef\csname currCollabName\the\allentries\endcsname{%\ifnum#1>0
#2}
%%
\let\doEtAl\relax
%% not here
\@author@def{\@booleanfalse
\collaboration@sw}{}}


\def\and{
\centerline{\vbox {\vrule height 12pt width0pt and\vskip2pt}}
}


\let\auto@bib\relax

\newif\iffirstaffil
\firstaffiltrue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% These commands were in aastex earlier; I redefined.
\def\tighten{\global\tightentrue\normalsize}
\let\tightenlines=\tighten
\def\singlespace{\par\global\doublespacefalse\global\tightenfalse\normalsize}
\def\doublespace{\par\global\doublespacetrue\global\tightenfalse\normalsize}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% October 2017

\newbox\widetext@top
\newbox\widetext@bot

\newenvironment{widetext}{%
\if@two@col
  \par\ignorespaces
  \setbox\widetext@top\vbox{%
   \hb@xt@\hsize{%
    \leaders\hrule\hfil
    \vrule\@height6\p@
   }%
  }%
  \setbox\widetext@bot\hb@xt@\hsize{%
    \vrule\@depth6\p@
    \leaders\hrule\hfil
  }%
  \onecolumngrid
  \vskip10\p@
  \dimen@\ht\widetext@top\advance\dimen@\dp\widetext@top
  \cleaders\box\widetext@top\vskip\dimen@
  \vskip6\p@
  \prep@math@patch
\fi}{%
\if@two@col
  \par
  \vskip6\p@
  \setbox\widetext@bot\vbox{%
   \hb@xt@\hsize{\hfil\box\widetext@bot}%
  }%
  \dimen@\ht\widetext@bot\advance\dimen@\dp\widetext@bot
  \cleaders\box\widetext@bot\vskip\dimen@
  \vskip8.5\p@
  \twocolumngrid\global\@ignoretrue
  \@endpetrue
\fi}%


\urlstyle{rm}

\def\doi#1{\href{https://doi.org/#1}{https://doi.org/#1}}
\let\savedoi\doi

\def\mdash{---}

\newif\ifcenterwidetable
%% these two definitions are the same, but it might
%% be convenient to have both
\def\centerwidetable{\global\centerwidetabletrue}


%% this doesn't seem to be documented, assume we don't need it:
%\def\centernarrowtable{\global\centerwidetablefalse}

%% default, center within width of text on both sides
 \def\LT@LR@c{\LTleft=0pt plus1fill 
  \LTright\LTleft}%

\def\widetable{\def\LT@LR@c{\LTleft=0pt minus1fill 
  \let\LTright\LTleft}}

\newif\ifreturntotwocol


%%%%%%%%%
%% to help with graceful linebreaks in two column text:
  \tolerance 9999%
%% sloppy defines emergencystretch to be 3 em, this is a bit
%% more conservative:
  \emergencystretch 1em 
  \hfuzz .5\p@

%%%%%%%%%
%% Nominal Conversion Constants

%%  \boldmath inside the \hbox ??
\def\nomSolarEffTemp{\leavevmode\hbox{\boldmath$\mathcal{T}^{\rm N}_{\mathrm{eff}\odot}$}}
\def\nomTerrEqRadius{\leavevmode\hbox{\boldmath$\mathcal{R}^{\rm N}_{E\mathrm e}$}}
\def\nomTerrPolarRadius{\leavevmode\hbox{\boldmath$\mathcal{R}^{\rm N}_{E\mathrm p}$}}
\def\nomJovianEqRadius{\leavevmode\hbox{\boldmath$\mathcal{R}^{\rm
N}_{J\mathrm e}$}}
 \def\nomJovianPolarRadius{\leavevmode\hbox{\boldmath$\mathcal{R}^{\rm
 N}_{J\mathrm p}$}}
 \def\nomTerrMass{\leavevmode\hbox{\boldmath$(\mathcal{GM})^{\rm N}_{\mathrm E}$}}
 \def\nomJovianMass{\leavevmode\hbox{\boldmath$(\mathcal{GM})^{\rm N}_{\mathrm J}$}}
 \def\Qnom{\leavevmode\hbox{\boldmath$\mathcal{Q}^{\rm N}_{\odot}$}}
\let\Qn\Qnom

%% Generic commands that can be given an argument:
\def\nom#1{\leavevmode\hbox{\boldmath$\mathcal{#1}^{\rm N}_{\odot}$}}
\def\Eenom#1{\leavevmode\hbox{\boldmath$\mathcal{#1}^{\rm N}_{Ee}$}}
\def\Epnom#1{\leavevmode\hbox{\boldmath$\mathcal{#1}^{\rm N}_{Ep}$}}
\def\Jenom#1{\leavevmode\hbox{\boldmath$\mathcal{#1}^{\rm N}_{Je}$}}
\def\Jpnom#1{\leavevmode\hbox{\boldmath$\mathcal{#1}^{\rm N}_{Jp}$}}

%%%%%%%%%%%%%%%%
%% Ability to have tables, equations, figures in appendix start from 1, and use appendix section letter.

\newif\ifappletter
\def\apptablenumbers{\global\applettertrue
\setcounter{table}{0}
\setcounter{figure}{0}
\setcounter{equation}{0}
\def\thetable{\thesection\the\c@table}%
\def\fnum@table{{\bf\tablename~\thetable}}%
\def\theHtable      {\thesection\arabic{table}}%
\def\thefigure{\thesection\the\c@figure}%
\def\fnum@figure{{\bf\figurename~\thefigure}}%
\def\theHfigure     {\thesection\arabic{figure}}%
}%

%%% easier to remember than \apptablenumbers
\let\restartappendixnumbering\apptablenumbers

\def\resetapptablenumbers{\global\c@table=0
\global\c@figure=0
\global\c@equation=0
\def\thetable{\thesection\the\c@table}
\def\fnum@table{{\bf\tablename~\thetable}}%
\def\thefigure{\thesection\the\c@figure}
\def\fnum@figure{{\bf\figurename~\thefigure}}%
}

%% written for aastex63
\newif\ifallauthors
\def\allauthors{
\global\allauthorstrue
\let\doauthor\doAllauthors
\ifanonymous
\vskip6pt\vskip1sp\centerline{\large\bf All Authors and
Affiliations\vrule depth 18pt width0pt}\nobreak
\centerline{Anonymous author(s)}
\else
\ifnumlines\nolinenumbers\fi
\onecolumngrid
\clearpage
{\vskip6pt\vskip1sp\centerline{\large\bf All Authors and
Affiliations\vrule depth 18pt width0pt}\nobreak
\global\docollabnum=0
\global\totalentries=0
\global\countauthors=0
\maketitle
}\fi}

\def\oldallauthors{%% this conditional keeps \allauthors from turning on
%%                 unless \AuthorCollaborationLimit is used:
\ifnumlines\nolinenumbers\fi
\onecolumngrid
\clearpage
\AuthorCollaborationLimit=10000
%\largestAffilNum=10000 <<== not needed
{\vskip6pt\vskip1sp\centerline{\large\bf All Authors and
Affiliations\vrule depth 18pt width0pt}\nobreak
\maketitle
}}
\let\AllAuthors\allauthors


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Highlight Figure
\definecolor{ltblue}{cmyk}{.5,.1,.1,0}
\newdimen\currwidth
\long\def\highlightfigure#1{
\bgroup
\fboxrule=4pt
\fboxsep=12pt
\vskip6pt
\global\currwidth=\hsize
\global\advance\currwidth by -32pt
\noindent\hbox to\currwidth{\fcolorbox{ltblue}{white}{%
$\vcenter{\hbox to\currwidth{\hss#1\hss}}$}}
\egroup}

\long\def\highlighcaption#1{
\bgroup
\fboxrule=4pt
\fboxsep=2pt
\vskip4pt
\global\currwidth=\hsize
%\global\advance\currwidth by -32pt
\noindent\hbox to\currwidth{\fcolorbox{ltblue}{white}{%
$\vcenter{\hbox to\currwidth{\hss#1\hss}}$}}
\egroup}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New interactive command:
%% online only tabular data
\newif\ifdigitasset
\def\digitalasset{\digitassettrue}
\def\digitasset{\@latex@error{^^J^^J Please use \string\digitalasset\string{\string}\space command instead of  \string\digitasset\string{\string}\space
^^J^^J
}\@ehc\stop}

\def\xlc{lc}
\def\xjs{js}
\def\xanimation{animation}
\newbox\interactbox
\newif\ifcorrectentries


\def\interactive#1#2{
\global\correctentriesfalse\def\checkone{#1}
\ifx\checkone\xlc\correctentriestrue\fi
\ifx\checkone\xjs\correctentriestrue\fi
\ifx\checkone\xanimation \correctentriestrue\fi
\def\checktwo{#2}
\ifx\checktwo\empty\global\correctentriesfalse\fi
\ifcorrectentries\global\digitassettrue
\else\hrule height1pt\vskip12pt\bf ERROR:
The command
{\tt\string\begin\string{interactive\string}\string{\string}\string{\string}} 
needs two arguments. The
first describes the interactive type and the only allowed choices are
lc, js, or animation.\\
The second argument is the movie file or package
containing the interactive figure components. See\\
\url{https://journals.aas.org/aastexguide/\hashmark interactivefig} for more
details.
\vskip12pt\hrule height1pt
\fi \global\currwidth\hsize
\global\advance\currwidth by -32pt
%% we need to set \currwidth here because interactbox expands 
%% before highlightfigure
\global\setbox\interactbox=\vbox\bgroup\hsize=\currwidth\relax\centering
}

\def\endinteractive{\egroup
\ifcorrectentries\copy\interactbox\fi
}

%%%% For cases in which footnotes are called in full width environment
%%   but are used in two cols. This keeps them from overwriting the
%%   second column:

\let\savefootnote\footnote
\def\onecolfootnote#1{\savefootnote{\hsize=.5\textwidth\advance\hsize
by-18pt\relax#1}}

\def\onecolumnfootnotes{\let\footnote\onecolfootnote}

\newdimen\movetableright

%% for anonymous option
\newif\ifsuppressAffiliations
\def\suppressAffiliations{\global\suppressAffiliationstrue}

%% new definition to be used in trackchanges:
\def\sout#1{\raise5pt\hbox{\underline{\vbox to
0pt{\vskip-4pt\hbox{#1\vrule height 8.5pt depth 3.5pt width0pt}\vss}}}} 

%% changes for affiliations when anonymous option is used:
\ifanonymous
  \suppressAffiliationstrue
  \gdef\affiliation#1{}%%
  \def\xauthor[#1]#2{}
  \let\yauthor\@gobble
  \def\lookforbracket{\ifx\next[
      \let\go\xauthor\else\let\go\yauthor\fi\go}
    \def\author{\futurelet\next\lookforbracket}
\fi


%%%%%%%%%%%%%
%% Line numbering

\usepackage[mathlines,left]{lineno}
%% 
\advance\linenumbersep 0pt
\ifnumlines
  \linenumbers*[1]
\else
 \def\thelinenumber{}
\fi

%% Use when line numbers are on, and after \usepackage{amsmath}.
%% Will make line numbering work on math as it would without amsmath.
\def\fixmathlinenumbering{
\let\saveopensqbracket\[
\def\[{\linenomath\saveopensqbracket}
\let\saveequation\equation
\let\saveendequation\endequation
%%
 \let\savealign\align
 \let\saveendalign\endalign
%%
 \let\savealigned\aligned
 \let\saveendaligned\endaligned
%%
\def\align{\linenomath\savealign}
 \def\endalign{\saveendalign}
 \def\aligned{\linenomath\savealigned}
 \def\endaligned{\linenomath\saveendaligned}
%%
\def\equation{\linenomath\saveequation}
\def\endequation{\linenomath\saveendequation}
}

\AtBeginDocument{\expandafter\ifx\csname @amsmath@err\endcsname\relax\else\fixmathlinenumbering\fi}

\hbadness\@M

\newcommand{\uat}[2]{\@ifx{!#2!}{#1}{\href{http://astrothesaurus.org/uat/#2}{#1 (#2)}}}

\def\altcaption#1{}


\endinput

%% End of aastex7.cls

