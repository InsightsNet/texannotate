%% Note by Overleaf (29 March 2016): the graphicx package is used instead of the graphics package in the original iucr.cls file, for more robust handling of image files
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the IUCr LaTeX 2e class macro file iucr.cls                        %
% Copyright (c) 1998-2016 International Union of Crystallography             %
%                                                                            %
% Usage:                                                                     %
%  \documentclass{iucr}               for Acta A/JAC/IUCrJ paper (default)   %
%  \documentclass[a]{iucr}            for Acta A/JAC/IUCrJ Research paper    %
%  \documentclass[a,short]{iucr}      for Acta A/JAC Short Communication     %
%  \documentclass[c]{iucr}            for Acta C paper                       %
%  \documentclass[d]{iucr}            for Acta B/Acta D Research paper       %
%  \documentclass[d,short]{iucr}      for Acta B/Acta D Short paper          %
%  \documentclass[d,conference]{iucr} for Acta B/Acta D Conference paper     %
%  \documentclass[e]{iucr}            for Acta E paper                       %
%  \documentclass[s]{iucr}            for JSR Full article                   %
%  \documentclass[s,short]{iucr}      for JSR Short Communication            %
%  \documentclass[s,conference]{iucr} for JSR Conference paper               %
%  \documentclass[s,nohead]{iucr}     for JSR paper with no header/footer    %
%  \documentclass[preprint]{iucr}     for preprint (1 col., wide-spaced)     %
%  \documentclass[it]{iucr}           for International Tables chapter       %
%  \documentclass[vanilla]{iucr}      for vanilla (general) style            %
%                                                                            %
% Other options (in square brackets):                                        %
%  pdf                                allow processing by pdflatex           %
%  full                               Research paper style (default)         %
%  keywords                           force printed keywords                 %
%  nokeywords                         force no keywords                      %
%  nohead                             do not print header/footer on page     %
%  synopsis                           print synopsis (default in preprint)   %
%  nosynopsis                         do not print synopsis                  %
%  optima                             use Optima fonts                       %
%  nopalatino                         do not use Palatino fonts              %
%  boldsection                        bold subsection style (IT Vol G)       %
%  itabstract                         show abstract/keywords (IT - default)  %
%  itnoabstract                       hide abstract and keywords (IT only)   %
%  fullsize                           set text for large page size (IT only) %
%                                                                            %
% Compatibility options for old-style journal articles                       %
%  o                                  for 'old' Acta/JAC                     %
%  x                                  for 'old' JSR                          %
%                                                                            %
% Author: Brian McMahon bm@iucr.org                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ChangeLog:                                                                 %
%   2.1.10                                                                   %
%          2016-01-28  Sets IT content to small page measure unless new      %
%                      option "fullsize" specified                           %
%   2.1.9                                                                    %
%          2016-01-14  Support for abstract/keywords in IT chapters          %
%                      and a new bst style for IT                            %
%   2.1.8                                                                    %
%          2014-10-01  Fixes bibtex error when there are spaces in the       %
%                      argument to a \cite command. Thanks to Robin Wilke    %
%   2.1.7                                                                    %
%          2014-01-16  New category (RP) for Acta B                          %
%   2.1.6                                                                    %
%          2013-03-28  New categories etc for IUCrJ                          %
%   2.1.5                                                                    %
%          2012-03-07  \journalaccepted etc.now defaults to \relax           %
%                      version label footnote \b@r only in preprint now      %
%   2.1.4                                                                    %
%          2010-12-07  Don't redefine \hline in table environment            %
%                      for preprint or vanilla modes (John Edmiston)         %
%   2.1.3                                                                    %
%          2010-11-11  Constrained smaller Summation to Istyle only          %
%   2.1.2                                                                    %
%          2010-05-13  Fixed \parindent in two-column table environment      %
%                      (thanks to Phil Bentley)                              %
%   2.1.1                                                                    %
%          2009-05-11  Added new paper category ST (running heads)           %
%   2.1                                                                      %
%          2007-05-15  Added some new paper categories (running heads)       %
%          2007-04-05  Added null multicols call to definition of \section   %
%                      in preprint style (stops page running long);          %
%                      fixed bug in \pdfbookmark calls to sections in        %
%                      Appendices in IT style;                               %
%                      added optional argument to \aufn allowing multiple    %
%                      footnote symbols to share same text, thanks to        %
%                      Christian Biertuempfel                                %
%   2.0                                                                      %
%          2005-07-13  Released upon publication of Volume G                 %
%   2.0beta16                                                                %
%          2005-07-05  Added \smallitcifname; changed the cifdefblock and    %
%                      related macros to improve space management            %
%          2005-06-29  Translated esd-su in \itemtypeconditionscode          %
%          2005-06-23  Small tweak to placement of figure caption.           %
%          2005-05-31  Tweaked \caption in IT tables for right font family   %
%   2.0beta15                                                                %
%          2005-01-07  Further fine tuning of cif dictionary macros          %
%          2004-11-26  Began fine tuning cif dictionary macros               %
%          2004-09-09  Fixed bug that lost 'A' in appendix section headings  %
%                      with the boldsection option                           %
%          2004-08-12  New wording in parent/child CIF dictionary term       %
%          2004-08-10  New option 'boldsection' for alternative style of     %
%                      (sub)section headings in some Int. Tables volumes     %
%          2004-07-06  Introduced example environment (similar to figure)    %
%                      for International Tables G                            %
%          2004-05-19  Began to introduce some macros for Acta F             %
%          2004-05-06  Allowed multiple correspondence addresses             %
%          2004-04-21  Suppressed the macro version footline for IT          %
%          2004-04-20  Introduced \footnotes (which draws the rule), \fnmark %
%                      and \fntext for manual placement of single-column     %
%                      footnotes in the multicolumn environment. The         %
%                      affiliationnote environment (intended primarily for   %
%                      International Tables) is an alternative for a footnote%
%                      with no identifying mark                              %
%   2.0beta14: changes for International Tables production                   %
%          2004-01-12  Fixed punctuation in \ref calls; thanks to Christian  %
%                      Anders Cumbaa; modified the environments table and    %
%                      figure to allow an optional overriding numbering -    %
%                      replaces the [caption] hack of beta12 and is necessary%
%                      for correct \ref strings                              %
%          2004-01-09  Began modifying page layout                           %
%   2.0beta13: changes for new conference abstracts style                    %
%   2.0beta12: changes for International Tables style                        %
%          2003-10-25  New command \backmatter for unnumbered final sections %
%          2003-10-21  Swapped order of running heads                        %
%          2003-10-19  Modified \caption in Int. Tables style to print       %
%                      section no. and figure sequence no.                   %
%                      Incorporated the 'tweaklist.sty' package to allow     %
%                      modification of item spacing (for Int. Tables)        %
%   2.0beta11                                                                %
%          2003-06-30  Bugfix to handle \pdfbookmark if the \hyperref        %
%                      package hasn't been invoked. Thanks to Loic Bertrand  %
%   2.0beta10                                                                %
%          2002-12-11  Allowed keywords option in Acta conference style      %
%   2.0beta9                                                                 %
%          2002-10-09  Added category SG (structural genomics papers)        %
%          2002-10-28  Modified textheight in IT style from 254 to 260mm     %
%   2.0beta8                                                                 %
%          2002-04-11  Backed out RequirePackage{html}: not reqd in TeXLive6 %
%          2002-01-09  Backed out the inclusion of \bgroup and \egroup in    %
%                      the redefined \mathbf. The problem is that there is a %
%                      conflict in standard LaTeX between the scope of \bf   %
%                      and \mathbf, yet \bf in math mode calls upon the      %
%                      \mathbf macro construction. It may be best later to   %
%                      remove the \mathbf redefinition altogether            %
%   2.0beta7                                                                 %
%          2002-01-08  Added \DeclareMathSymbol{/} for bold solidus          %
%          2001-12-14  Fixed scoping problem in redefined \mathbf. Thanks to %
%                      Gunnar Thorkildsen                                    %
%                      Changed some comments; thanks to Chris Cousins        %
%   2.0beta6                                                                 %
%          2001-10-25  Added RequirePackage{html} ahead of                   %
%                      RequirePackage{harvard} to cure dependency problems   %
%                      of these two packages that call each other            %
%   2.0beta5                                                                 %
%          2001-06-20  Major revamp of all styles to weed out bugs           %
%          2001-06-14  New vanilla style introduced for general purposes     %
%          2001-06-12  New styles introduced for Acta C and Acta E           %
%                      There is a problem with the footer on the last page   %
%                      of a conference paper if that page is full: the page  %
%                      is ejected with the standard footer before the        %
%                      AtEndDocument comes into effect. For now, we leave    %
%                      this because conference papers will usually be run    %
%                      with the nohead option anyway                         %
%   2.0beta4                                                                 %
%          2001-06-12  New style introduced for JSR; old style renamed x;    %
%                      option nohead introduced for JSR to omit headers and  %
%                      footers in camera-ready contributions                 %
%   2.0beta3                                                                 %
%          2001-04-05  some small mods to CIF macros for ITVG                %
%          2000-10-10  default LaTeX \index commands reinstated in it style  %
%   2.0beta2                                                                 %
%          2000-04-06  fixed single-line fig captions, conference r/head     %
%          2000-02-08  modified \thebibliography to include heading for [a,d]%
%          1999-12-16  added \pdfbookmark to section definitions (pdflatex)  %
%   2.0beta1                                                                 %
%          1999-12-10  preprint style simplified: no r/heads, wider margins  %
%          1999-12-07  new journal styles introduced as option a; old style  %
%                      renamed as option o                                   %
%   1.0                                                                      %
%          1999-07-01  twoside option reintroduced to article base class     %
%          1999-06-04  bold upright Greek font descriptions introduced       %
%          1999-05-15  version released as 1.0                               %
%   beta-4                                                                   %
%          1999-05-15  some more small improvements; release version         %
%          1999-05-14  some small bugfixes and improvements; \PDBref and     %
%                      \NDBref added for Acta D papers; awkward positioning  %
%                      of footnotes on first page of new-style Acta articles %
%                      achieved                                              %
%          1999-05-13  full articles and short contributions working         %
%          1999-05-11  some minor style mods to D/conference style           %
%          1999-05-07  first working version of conference style             %
%          1999-05-06  began work on Acta D/SAS conference style             %
%   beta-3                                                                   %
%          1999-05-04  bugfix: _ in ciflisting environment redefined as      %
%                      \char'137{} (with trailing {} to prevent collision    %
%                      with following material)                              %
%          1999-04-01  bugfix: \journalreceived failed for e.g. 11 May       %
%          1999-03-09  cif macros modified so that underscore can be used    %
%                      in \ref and other places (thanks to Thomas Proffen)   %
%          1999-03-01  \section now uses standard \@startsection directives  %
%                      (with \global\@afterindentfalse to cancel indent of   %
%                      first paragraph)                                      %
%          1999-02-10  macros added for typesetting CIF listings and CIF     %
%                      dictionary entries                                    %
%          1999-02-04  `raggedstyle' conditional introduced for subject      %
%                      indexes (and \idxsubentry)                            %
%          1998-11-18  Organic, Inorganic index categories for Acta C        %
%          1998-11-09  Bugfix to catchline for Acta C                        %
%          1998-11-05  Made \journal... and \paper... macros preamble only   %
%          1998-11-03  Added 4th and 5th level sections to IT                %
%          1998-10-28  Font work: Times allowed in equations, sloping Greek  %
%                      and bold Greek handled OK                             %
%          1998-10-27  first pass at an International Tables style: page     %
%                      size and gross style elements                         %
%          1998-10-26  index environment introduced; catchline built up      %
%                      in a box (not on the fly as before)                   %
%   beta-2                                                                   %
%          1998-09-08  thebibliography environment modified following        %
%                      Matt Newville newville@cars.uchicago.edu; originally  %
%                      \referencelist was a wrapper for \bibliography that   %
%                      supplied appropriate font and style changes; but some %
%                      authors habitually use \bibliography explicitly       %
%          1998-09-04  Added preprint style                                  %
%                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WARNING: the following global box registers are specifically assigned:
% \box0, \box2 (in \author); \box4 (\aff); \box6 (\cauthor);
% \box8 (keyindicators environment); \box128 (synopsis environment)
% Non-global registers are \box1 (\author); \box3 (\aff);
% \box5 (\journalreceived, journalaccepted); \box7 (\keyword)
%
% ====================== version and identifying label =======================
\def\f@@{2016/01/28 }
%\def\b@r{{\tiny IUCr macros version 2.1.10: \f@@ \hfill}}
\def\b@r{\relax}

% ====================== some early conditionals declared ====================
\newif\ifAstyl@\Astyl@true                       % Logical flags to check
\newif\ifCstyl@\Cstyl@false                      %  style of journal; default
\newif\ifDstyl@\Dstyl@false                      %  is A (Acta A/JAC); also
\newif\ifEstyl@\Estyl@false                      %  provided: D (Acta B/D); C
\newif\ifIstyl@\Istyl@false                      %  (Acta C); E (Acta E); S
\newif\ifSstyl@\Sstyl@false                      %  (camera-ready JSR); O (old
\newif\ifOstyl@\Ostyl@false                      %  Acta/JAC); X (old JSR);
\newif\ifPstyl@\Pstyl@false                      %  I (International Tables);
\newif\ifVstyl@\Vstyl@false                      %  P (preprint); V (vanilla),
\newif\ifXstyl@\Xstyl@false                      %  Y (conference abstract)
\newif\ifYstyl@\Ystyl@false                      %
\newif\ifF@ll\F@lltrue                           % Paper styles: default F
\newif\ifSh@rt\Sh@rtfalse                        %  (full); S (short); C
\newif\ifC@nf\C@nffalse                          %  conference proceedings)
\newif\ifsingl@col\singl@coltrue                 % Single column setting?
\newif\ifOptim@\Optim@false                      % Is Optima font available?
\newif\ifPalatin@\Palatin@true                   % Is Palatino font available?
\newif\ifChe@dings\Che@dingsfalse                % Acta C subject headings?
\newif\ifhe@ders\he@derstrue                     % Print page headers/footers?
\newif\ifsyn@p\syn@pfalse                        % Print synopsis?
\newif\ifkeyw@rd\keyw@rdfalse                    % Print keywords?
\newif\ifc@pyright\c@pyrighttrue                 % Print copyright details?
\newif\ifmkttl\mkttlfalse                        % Was author group printed?
\newif\iffirsts@c\firsts@ctrue                   % Short contributions effect
                                                 %  many page layout actions
                                                 %  when first section begins
\newif\iffn@ffset\fn@ffsetfalse                  % Footnotes with an offset?
\newif\ifprintd@tes\printd@testrue               % Print recd/acc dates?
\newif\ifPDF\PDFfalse                            % Using pdflatex?
\newif\ifC@l@r\C@l@rfalse                        % colour available?
\newif\if@ppend@x\@ppend@xfalse                  % within appendix section?
\newif\ifb@lds@ction\b@lds@ctionfalse            % subsection style of IT
\newif\ifshow@bs\show@bstrue                     % print abstract (in IT only)
\newif\iff@llsize\f@llsizefalse                  % large page size (in IT only)

\let\f@@tn@te\footnote%                          % In new-style articles a
                                                 %  title footnote is treated
                                                 %  differently; in the title
                                                 %  \footnote is \let equal to
                                                 %  \t@tlefn; so need to store
                                                 %  old definition of \footnote
\newcommand{\chapter}{\relax}%                   % Gets redefined for IT
\newcommand{\theBOOKMARKsection}{\relax}%       % Gets redefined for IT
\newcounter{chapter}
\newcounter{example}

% ====================== identification ======================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{iucr}[\f@@ IUCr article/chapter class]

% ====================== declaration of options ==============================
\DeclareOption{a}{%                              % Acta A/JAC style
  \ifC@nf%                                       % conference type overrides
    \Astyl@false%
    \Dstyl@true%
  \else%
    \Astyl@true%
    \Dstyl@false%
  \fi%
  \Cstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{c}{%                              % Acta C style
  \Astyl@false%
  \Cstyl@true%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{d}{%                              % Acta B/Acta D style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@true%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{e}{%                              % Acta E style
  \Astyl@false%
  \Cstyl@false%
  \ifC@nf%                                       % conference type overrides
    \Estyl@false%
    \Dstyl@true%
  \else%
    \Estyl@true%
    \Dstyl@false%
  \fi%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{s}{%                              % JSR style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@true%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{o}{%                              % old Acta style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@true%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{vanilla}{%                        % vanilla style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@true%
  \Xstyl@false%
  \Ystyl@false%
}
\DeclareOption{x}{%                              % old JSR style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@true%
  \Ystyl@false%
}
\DeclareOption{it}{%                             % International Tables style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@true%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
  \let\b@r\relax%                                % vanish iucr identifier too
}
\DeclareOption{preprint}{%                       % Preprint style
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@true%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@false%
  \syn@ptrue%                                    % print synopsis
}
\DeclareOption{full}{%                           % Full articles
  \C@nffalse%
  \F@lltrue%
  \Sh@rtfalse%
}
\DeclareOption{short}{%                          % Short Communications
  \C@nffalse%
  \F@llfalse
  \Sh@rttrue%
}
\DeclareOption{abstract}{%                       % Conference abstracts
  \C@nffalse%
  \F@llfalse
  \Sh@rtfalse%
  \Astyl@false%
  \Cstyl@false%
  \Dstyl@false%
  \Estyl@false%
  \Istyl@false%
  \Sstyl@false%
  \Ostyl@false%
  \Pstyl@false%
  \Vstyl@false%
  \Xstyl@false%
  \Ystyl@true%
}
\DeclareOption{conference}{%                     % Conference proceedings
  \C@nftrue%
  \F@llfalse%
  \Sh@rtfalse%
  \ifAstyl@%
    \Astyl@false\Dstyl@true\fi%                  % conference overrides
  \ifCstyl@%
    \Cstyl@false\Dstyl@true\Che@dingstrue\fi%    % conference overrides
  \ifEstyl@%
    \Estyl@false\Dstyl@true\Che@dingstrue\fi%    % conference overrides
  \ifOstyl@%
    \C@nffalse\Sh@rttrue\fi%                     % same as short for old Acta
  \ifXstyl@%
    \C@nffalse\Sh@rttrue\fi%                     % same as short for old JSR
}
\DeclareOption{keywords}{%                       % Force printed keywords
  \keyw@rdtrue
}
\DeclareOption{nokeywords}{%                     % Force no keywords
  \keyw@rdfalse
}
\DeclareOption{nohead}{%                         % No page headers or footers
  \he@dersfalse%
  \let\b@r\relax%                                % vanish iucr identifier too
}
\DeclareOption{nosynopsis}{%                     % Do not print synopsis
  \syn@pfalse%
}
\DeclareOption{synopsis}{%                       % Print synopsis
  \syn@ptrue%
}
\DeclareOption{optima}{%                         % Optima available as sanserif
  \Optim@true%
}
\DeclareOption{nopalatino}{%                     % Palatino for 'sanserif'
  \Palatin@false%                                % (unless unavailable)
}
\DeclareOption{pdf}{%                            % Allow processing by pdftex
  \PDFtrue%
}
\DeclareOption{boldsection}{%                    % Use bold subsection heads
  \b@lds@ctiontrue%
}
\DeclareOption{itabstract}{%                     % Show abstract/keywords in IT
  \show@bstrue%
}
\DeclareOption{itnoabstract}{%                   % Hide abstract/keywords in IT
  \show@bsfalse%
}
\DeclareOption{fullsize}{%                       % Use large page size in IT
  \f@llsizetrue%
}

% ====================== execution of options ================================
\ProcessOptions

% ====================== load required packages ==============================
\ifPstyl@\RequirePackage{multicol}\else\RequirePackage{multicol, times}\fi
% Change sanserif family for new-style Acta papers; authors probably won't have
%  Optima (the house font), so may use Palatino (which is actually a serifed
%  font); if that's not available, they can fall back on Times
\ifAstyl@%
  \renewcommand{\sfdefault}{ptm}                 % Times
  \ifPalatin@\renewcommand{\sfdefault}{ppl}\fi   % Palatino
  \ifOptim@\renewcommand{\sfdefault}{pop}\fi     % Optima
\fi
\ifCstyl@%
  \renewcommand{\sfdefault}{ptm}                 % Times
  \ifPalatin@\renewcommand{\sfdefault}{ppl}\fi   % Palatino
  \ifOptim@\renewcommand{\sfdefault}{pop}\fi     % Optima
\fi
\ifDstyl@%
  \renewcommand{\sfdefault}{ptm}                 % Times
  \ifPalatin@\renewcommand{\sfdefault}{ppl}\fi   % Palatino
  \ifOptim@\renewcommand{\sfdefault}{pop}\fi     % Optima
\fi
\ifEstyl@%
  \renewcommand{\sfdefault}{ptm}                 % Times
  \ifPalatin@\renewcommand{\sfdefault}{ppl}\fi   % Palatino
  \ifOptim@\renewcommand{\sfdefault}{pop}\fi     % Optima
\fi
\ifVstyl@%
  \renewcommand{\sfdefault}{ptm}                 % Times
  \ifPalatin@\renewcommand{\sfdefault}{ppl}\fi   % Palatino
  \ifOptim@\renewcommand{\sfdefault}{pop}\fi     % Optima
\fi

% \ifPDF\RequirePackage[dvips,pdftex]{graphics}%
%   \else\RequirePackage[dvips]{graphics}\fi
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{tabularx}
\InputIfFileExists{colordvi.tex}{\global\C@l@rtrue}{\global\C@l@rfalse}
%\RequirePackage{boxedminipage}
% The boxedminipage environment of Wolczko is incorporated in its entirety to
%  reduce the number of extra packages that users need to have installed
%#############################################################################
%%% ====================================================================
%%%  @LaTeX-style-file{
%%%     author          = "Mario Wolczko",
%%%     version         = "2",
%%%     date            = "21 May 1992",
%%%     time            = "20:55:01 BST",
%%%     filename        = "boxedminipage.sty",
%%%     address         = "Dept of Computer Science
%%%                        The University of Manchester
%%%                        Oxford Road
%%%                        Manchester M13 9PL
%%%                        UK",
%%%     telephone       = "+44-61-275-6146",
%%%     FAX             = "+44-61-275-6236",
%%%     checksum        = "04781 71 253 2587",
%%%     email           = "mario@cs.man.ac.uk (Internet)",
%%%     codetable       = "ISO/ASCII",
%%%     keywords        = "LaTeX, minipage, framebox",
%%%     supported       = "yes",
%%%     docstring       = "LaTeX document-style option which defines
%%%     the boxedminipage environment -- just like minipage, but with
%%%     a box around it.",
%%%  }
%%% ====================================================================
%
% The thickness of the rules around the box is controlled by
% \fboxrule, and the distance between the rules and the edges of the
% inner box is governed by \fboxsep.
%
% This code is based on Lamport's minipage code.
%
% Fixed, 7 Jun 89 by Jerry Leichter
%       Leave \fboxsep worth of separation at top and bottom, not just at
%       the sides!
%
\def\boxedminipage{\@ifnextchar [{\@iboxedminipage}{\@iboxedminipage[c]}}

\def\@iboxedminipage[#1]#2{\leavevmode \@pboxswfalse
  \if #1b\vbox
    \else \if #1t\vtop
             \else \ifmmode \vcenter
                       \else \@pboxswtrue $\vcenter
                    \fi
          \fi
  \fi\bgroup % start of outermost vbox/vtop/vcenter
    \hsize #2
    %\hrule\@height\fboxrule %% amended as below by bm
     \hrule height9.4pt depth-9pt
    \hbox\bgroup % inner hbox
      \vrule\@width\fboxrule \hskip\fboxsep \vbox\bgroup % innermost vbox
        \vskip\fboxsep
        \advance\hsize -2\fboxrule \advance\hsize-2\fboxsep
        \textwidth\hsize \columnwidth\hsize
        \@parboxrestore
        \def\@mpfn{mpfootnote}\def\thempfn{\thempfootnote}\c@mpfootnote\z@
        \let\@footnotetext\@mpfootnotetext
        \let\@listdepth\@mplistdepth \@mplistdepth\z@
        \@minipagerestore\@minipagetrue
        \everypar{\global\@minipagefalse\everypar{}}}

\def\endboxedminipage{%
        \par\vskip-\lastskip
        \ifvoid\@mpfootins\else
          \vskip\skip\@mpfootins\footnoterule\unvbox\@mpfootins\fi
        \vskip\fboxsep
      \egroup % ends the innermost \vbox
      \hskip\fboxsep \vrule\@width\fboxrule
    \egroup % ends the \hbox
    \hrule\@height\fboxrule
  \egroup% ends the vbox/vtop/vcenter
  \if@pboxsw $\fi}
%#############################################################################
%\RequirePackage{tweaklist}
% The tweaklist.sty package of Schiotz is incorporated in its entirety to
%  reduce the number of extra packages that users need to have installed
% It provides hooks to change line spacing in various list environments
%#############################################################################
\def\enumhook{}
\def\enumhooki{}
\def\enumhookii{}
\def\enumhookiii{}
\def\enumhookiv{}
\def\itemhook{}
\def\itemhooki{}
\def\itemhookii{}
\def\itemhookiii{}
\def\itemhookiv{}
\def\descripthook{}
\def\enumerate{%
  \ifnum \@enumdepth >\thr@@\@toodeep\else
    \advance\@enumdepth\@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
      \expandafter
      \list
        \csname label\@enumctr\endcsname
        {\usecounter\@enumctr\def\makelabel##1{\hss\llap{##1}}%
          \enumhook \csname enumhook\romannumeral\the\@enumdepth\endcsname}%
  \fi}
\def\itemize{%
  \ifnum \@itemdepth >\thr@@\@toodeep\else
    \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \expandafter
    \list
      \csname\@itemitem\endcsname
      {\def\makelabel##1{\hss\llap{##1}}%
        \itemhook \csname itemhook\romannumeral\the\@itemdepth\endcsname}%
  \fi}
%\renewenvironment{description}
                 %{\list{}{\labelwidth\z@ \itemindent-\leftmargin
                          %\let\makelabel\descriptionlabel\descripthook}}
                 %{\endlist}
%#############################################################################
% eqalign.sty: filched from http://keil.home.cern.ch/keil/Doc/eqalign.sty
%#############################################################################
% This is eqalign.tex in text format as of 30 July 1987.
% The following definition is straight from PLAIN.TEX
% This file exists as a LaTeX style option to enable users to
% put back something that LaTeX removed from PLAIN but which
% is sorely missed by people who write long equations.
% You should be able to add 'eqalign' to the options list in square
% brackets which specifies the options of any standard LaTeX style.
% This file may also be input into a STY file e.g. the LEPNOTE style
% option includes it automatically.
% Do not attempt to input it anywhere in a LaTeX document.
 
\def\eqalign#1{%
\null\,\vcenter{\openup\jot\m@th
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      \crcr#1\crcr}}\,}
% \eqalign works inside $$ ... $$ or \[ ... \] in LaTeX thanks to the
% above restoration.   This should help remedy the deficiencies of
% the eqnarray environment for long expressions.
% It seems to work also in the equation environment if you put
% the \label command inside an \hbox.
% This seems to resolve a problem with math glue from \eqalign mixing
% with ordinary glue generated by \label.  God help us.
% Use of \eqalign is explained in the TeXbook.
%                       * * Restored at 12:21:30 on 17 Jul 1987 by JOWETT
%#############################################################################

% ====================== load base class =====================================
\ifPstyl@%
  \LoadClass[11pt]{article}%
\else%
  \LoadClass[twoside]{article}%
\fi%

% ================ load additional required packages =========================
% (harvard.sty loads html.sty if present, which uses counters defined in
%  article.cls)
% \RequirePackage{html}
\RequirePackage{harvard}

% The following hack addresses a problem with bibtex failing when
% there is whitespace in a comma-separated list of labels passed as
% an argument to \cite - see 
% http://tex.stackexchange.com/questions/4517/cite-that-tolerates-whitespace
%
\let\OLDcite\cite
\def\tok@scan#1{%
  \ifx#1\relax
    \let\tok@next\relax
  \else
    \edef\my@list{\my@list#1}%
    \let\tok@next\tok@scan
  \fi
  \tok@next
}
\newcommand{\@strip}[2]{%
  \def\my@list{}\tok@scan#2\relax\let#1\my@list}
\renewcommand{\cite}[1]{\@strip\@args{#1}\OLDcite\@args}

% ======================================================================

% ====================== main code ===========================================
% First, some fairly hairy font stuff, based originally on the mathptm
%  package by S. Rahtz, distributed as part of standard LaTeX. Declare the
%  standard PostScript fonts for use in equations, but prefer Computer
%  Modern for symbols and Greek lower-case letters, which we need in a
%  slanted form. Sometimes we need bold Greek lowercase letters. We achieve
%  this in two ways: the \SetSymbolFont{greek}{bold} makes Greek letters
%  bold when \mathversion{bold} is declared (this is used e.g. to make a
%  formula bold within a heading or title). We also define individual
%  symbols (e.g. \bfalpha) to obtain bold single letters. This is compatible
%  with the practice in the iucmac plain TeX macro package. However, it
%  introduces non-standard macro names which we prefer not to inflict upon
%  authors. So instead we redefine the standard \mathbf to change every Greek
%  symbol macro name to its bold equivalent.
\ifPstyl@
  \DeclareMathAlphabet{\mathsfrm}{OT1}{phv}{m}{n}
  \DeclareMathAlphabet{\mathsfit}{OT1}{phv}{m}{it}
  \DeclareMathAlphabet{\mathsfbf}{OT1}{phv}{b}{n}
  \DeclareMathAlphabet{\mathsfbi}{OT1}{phv}{b}{it}
\else
  \def\rmdefault{ptm}
  \DeclareSymbolFont{operators}   {OT1}{ptmcm}{m}{n}
    \SetSymbolFont{operators}     {bold}{OT1}{ptm}{b}{n}
  \DeclareSymbolFont{letters}     {OML}{ptmcm}{m}{it}
    \SetSymbolFont{letters}       {bold}{OT1}{ptm}{b}{it}
  \message{FONT WARNINGS CAN USUALLY BE IGNORED. IF YOU EXPERIENCE}
  \message{PROBLEMS WITH FONTS, USE THE [preprint] OPTION}
  \DeclareSymbolFont{symbols}     {OMS}{cmsy}{m}{n}
  \DeclareSymbolFont{largesymbols}{OMX}{cmex}{m}{n}
  \DeclareSymbolFont{bold}        {OT1}{ptm}{bx}{n}
  \DeclareSymbolFont{italic}      {OT1}{ptm}{m}{it}
    \SetSymbolFont{italic}        {bold}{OT1}{ptm}{b}{it}
  \DeclareSymbolFont{greek}       {OML}{cmm}{m}{it}
    \SetSymbolFont{greek}         {bold}{OML}{cmm}{b}{it}
  \DeclareSymbolFont{uprightgreek}{OT1}{ptmcm}{m}{n}
    \SetSymbolFont{uprightgreek}  {bold}{OT1}{cmr}{bx}{n}
  \DeclareSymbolFont{boldgreek}   {OML}{cmm}{b}{it}
  \DeclareSymbolFont{bolduprightgreek}{OT1}{cmr}{bx}{n}
  \DeclareMathSymbol{\alpha}{0}{greek}{"0B}
  \DeclareMathSymbol{\bfalpha}{0}{boldgreek}{"0B}
  \DeclareMathSymbol{\beta}{0}{greek}{"0C}
  \DeclareMathSymbol{\bfbeta}{0}{boldgreek}{"0C}
  \DeclareMathSymbol{\gamma}{0}{greek}{"0D}
  \DeclareMathSymbol{\bfgamma}{0}{boldgreek}{"0D}
  \DeclareMathSymbol{\delta}{0}{greek}{"0E}
  \DeclareMathSymbol{\bfdelta}{0}{boldgreek}{"0E}
  \DeclareMathSymbol{\epsilon}{0}{greek}{"0F}
  \DeclareMathSymbol{\bfepsilon}{0}{boldgreek}{"0F}
  \DeclareMathSymbol{\zeta}{0}{greek}{"10}
  \DeclareMathSymbol{\bfzeta}{0}{boldgreek}{"10}
  \DeclareMathSymbol{\eta}{0}{greek}{"11}
  \DeclareMathSymbol{\bfeta}{0}{boldgreek}{"11}
  \DeclareMathSymbol{\theta}{0}{greek}{"12}
  \DeclareMathSymbol{\bftheta}{0}{boldgreek}{"12}
  \DeclareMathSymbol{\iota}{0}{greek}{"13}
  \DeclareMathSymbol{\bfiota}{0}{boldgreek}{"13}
  \DeclareMathSymbol{\kappa}{0}{greek}{"14}
  \DeclareMathSymbol{\bfkappa}{0}{boldgreek}{"14}
  \DeclareMathSymbol{\lambda}{0}{greek}{"15}
  \DeclareMathSymbol{\bflambda}{0}{boldgreek}{"15}
  \DeclareMathSymbol{\mu}{0}{greek}{"16}
  \DeclareMathSymbol{\bfmu}{0}{boldgreek}{"16}
  \DeclareMathSymbol{\nu}{0}{greek}{"17}
  \DeclareMathSymbol{\bfnu}{0}{boldgreek}{"17}
  \DeclareMathSymbol{\xi}{0}{greek}{"18}
  \DeclareMathSymbol{\bfxi}{0}{boldgreek}{"18}
  \DeclareMathSymbol{\pi}{0}{greek}{"19}
  \DeclareMathSymbol{\bfpi}{0}{boldgreek}{"19}
  \DeclareMathSymbol{\rho}{0}{greek}{"1A}
  \DeclareMathSymbol{\bfrho}{0}{boldgreek}{"1A}
  \DeclareMathSymbol{\sigma}{0}{greek}{"1B}
  \DeclareMathSymbol{\bfsigma}{0}{boldgreek}{"1B}
  \DeclareMathSymbol{\tau}{0}{greek}{"1C}
  \DeclareMathSymbol{\bftau}{0}{boldgreek}{"1C}
  \DeclareMathSymbol{\upsilon}{0}{greek}{"1D}
  \DeclareMathSymbol{\bfupsilon}{0}{boldgreek}{"1D}
  \DeclareMathSymbol{\phi}{0}{greek}{"1E}
  \DeclareMathSymbol{\bfphi}{0}{boldgreek}{"1E}
  \DeclareMathSymbol{\chi}{0}{greek}{"1F}
  \DeclareMathSymbol{\bfchi}{0}{boldgreek}{"1F}
  \DeclareMathSymbol{\psi}{0}{greek}{"20}
  \DeclareMathSymbol{\bfpsi}{0}{boldgreek}{"20}
  \DeclareMathSymbol{\omega}{0}{greek}{"21}
  \DeclareMathSymbol{\bfomega}{0}{boldgreek}{"21}
  \DeclareMathSymbol{\varepsilon}{0}{greek}{"22}
  \DeclareMathSymbol{\bfvarepsilon}{0}{boldgreek}{"22}
  \DeclareMathSymbol{\vartheta}{0}{greek}{"23}
  \DeclareMathSymbol{\bfvartheta}{0}{boldgreek}{"23}
  \DeclareMathSymbol{\varpi}{0}{greek}{"24}
  \DeclareMathSymbol{\bfvarpi}{0}{boldgreek}{"24}
  \DeclareMathSymbol{\varrho}{0}{greek}{"25}
  \DeclareMathSymbol{\bfvarrho}{0}{boldgreek}{"25}
  \DeclareMathSymbol{\varsigma}{0}{greek}{"26}
  \DeclareMathSymbol{\bfvarsigma}{0}{boldgreek}{"26}
  \DeclareMathSymbol{\varphi}{0}{greek}{"27}
  \DeclareMathSymbol{\bfvarphi}{0}{boldgreek}{"27}
  \DeclareMathSymbol{\Gamma}{0}{uprightgreek}{"00}
  \DeclareMathSymbol{\bfGamma}{0}{bolduprightgreek}{"00}
  \DeclareMathSymbol{\Delta}{0}{uprightgreek}{"01}
  \DeclareMathSymbol{\bfDelta}{0}{bolduprightgreek}{"01}
  \DeclareMathSymbol{\Theta}{0}{uprightgreek}{"02}
  \DeclareMathSymbol{\bfTheta}{0}{bolduprightgreek}{"02}
  \DeclareMathSymbol{\Lambda}{0}{uprightgreek}{"03}
  \DeclareMathSymbol{\bfLambda}{0}{bolduprightgreek}{"03}
  \DeclareMathSymbol{\Xi}{0}{uprightgreek}{"04}
  \DeclareMathSymbol{\bfXi}{0}{bolduprightgreek}{"04}
  \DeclareMathSymbol{\Pi}{0}{uprightgreek}{"05}
  \DeclareMathSymbol{\bfPi}{0}{bolduprightgreek}{"05}
  \DeclareMathSymbol{\Sigma}{0}{uprightgreek}{"06}
  \DeclareMathSymbol{\bfSigma}{0}{bolduprightgreek}{"06}
  \DeclareMathSymbol{\Upsilon}{0}{uprightgreek}{"07}
  \DeclareMathSymbol{\bfUpsilon}{0}{bolduprightgreek}{"07}
  \DeclareMathSymbol{\Phi}{0}{uprightgreek}{"08}
  \DeclareMathSymbol{\bfPhi}{0}{bolduprightgreek}{"08}
  \DeclareMathSymbol{\Psi}{0}{uprightgreek}{"09}
  \DeclareMathSymbol{\bfPsi}{0}{bolduprightgreek}{"09}
  \DeclareMathSymbol{\Omega}{0}{uprightgreek}{"0A}
  \DeclareMathSymbol{\bfOmega}{0}{bolduprightgreek}{"0A}
  \@ifundefined{mathbf}{}{\DeclareMathAlphabet{\mathbf}{OT1}{ptm}{bx}{n}}
  \@ifundefined{mathit}{}{\DeclareMathAlphabet{\mathit}{OT1}{ptm}{m}{it}}
  \@ifundefined{mathbi}{}{\DeclareMathAlphabet{\mathbi}{OT1}{ptm}{b}{it}}
  \ifIstyl@\else\DeclareMathSymbol{/}{\mathord}{operators}{"2F}\fi

  \ifAstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi
  \ifCstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi
  \ifDstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi
  \ifEstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi
  \ifIstyl@%
    \DeclareMathAlphabet{\mathsfrm}{OT1}{phv}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{phv}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{phv}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{phv}{b}{it}
  \fi
  \ifSstyl@%
    \DeclareMathAlphabet{\mathsfrm}{OT1}{phv}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{phv}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{phv}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{phv}{b}{it}
  \fi
  \ifOstyl@%
    \DeclareMathAlphabet{\mathsfrm}{OT1}{phv}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{phv}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{phv}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{phv}{b}{it}
  \fi
  \ifVstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi
  \ifXstyl@%
    \DeclareMathAlphabet{\mathsfrm}{OT1}{phv}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{phv}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{phv}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{phv}{b}{it}
  \fi
  \ifYstyl@%                                     % Appropriate 'sanserif' font
    \DeclareMathAlphabet{\mathsfrm}{OT1}{ptm}{m}{n}
    \DeclareMathAlphabet{\mathsfit}{OT1}{ptm}{m}{it}
    \DeclareMathAlphabet{\mathsfbf}{OT1}{ptm}{b}{n}
    \DeclareMathAlphabet{\mathsfbi}{OT1}{ptm}{b}{it}
    \ifOptim@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{pop}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{pop}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{pop}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{pop}{b}{it}
    \fi
    \ifPalatin@
      \DeclareMathAlphabet{\mathsfrm}{OT1}{ppl}{m}{n}
      \DeclareMathAlphabet{\mathsfit}{OT1}{ppl}{m}{it}
      \DeclareMathAlphabet{\mathsfbf}{OT1}{ppl}{b}{n}
      \DeclareMathAlphabet{\mathsfbi}{OT1}{ppl}{b}{it}
    \fi
  \fi

  \let\m@thbf\mathbf
  \renewcommand{\mathbf}[1]{
    \let\alpha\bfalpha
    \let\beta\bfbeta
    \let\gamma\bfgamma
    \let\delta\bfdelta
    \let\epsilon\bfepsilon
    \let\zeta\bfzeta
    \let\eta\bfeta
    \let\theta\bftheta
    \let\iota\bfiota
    \let\kappa\bfkappa
    \let\lambda\bflambda
    \let\mu\bfmu
    \let\nu\bfnu
    \let\xi\bfxi
    \let\pi\bfpi
    \let\rho\bfrho
    \let\sigma\bfsigma
    \let\tau\bftau
    \let\upsilon\bfupsilon
    \let\phi\bfphi
    \let\chi\bfchi
    \let\psi\bfpsi
    \let\omega\bfomega
    \let\varepsilon\bfvarepsilon
    \let\vartheta\bfvartheta
    \let\varpi\bfvarpi
    \let\varrho\bfvarrho
    \let\varsigma\bfvarsigma
    \let\varphi\bfvarphi
    \let\Gamma\bfGamma
    \let\Delta\bfDelta
    \let\Theta\bfTheta
    \let\Lambda\bfLambda
    \let\Xi\bfXi
    \let\Pi\bfPi
    \let\Sigma\bfSigma
    \let\Upsilon\bfUpsilon
    \let\Phi\bfPhi
    \let\Psi\bfPsi
    \let\Omega\bfOmega
    \m@thbf{#1}
  }
\fi

% ====================== some small utilities ================================
% Macro to compare text strings
\newif\ifstringsequal
\def\strcmp#1#2{%
  \def\stringone{#1}\def\stringtwo{#2}%
  \ifx\stringone\stringtwo\stringsequaltrue\else\stringsequalfalse\fi%
}

% A fix to set verbatim text in small typewriter font (see J. Gibbons,
%  TUGBOAT (1997), 18, 248
\let\VERBATIM\verbatim
\def\verbatim{%
  \def\verbatim@font{\footnotesize\ttfamily}%
  \parskip0pt
  \VERBATIM%
}
\newenvironment{smallverbatim}{%
  \baselineskip=9pt%
  \parindent=0pt%
  \fontsize{7}{9pt}%
    \def\setupverbatim{\ttfamily%
      \parskip0pt\def\par{\endgraf\leavevmode}\obeylines\obeyspaces}%
    \setupverbatim
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ====================== PAGE MAKEUP - THE BASIC JOURNAL STYLES ==============
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newlength{\colwidth}                            % width of a column
\newlength{\frontwidth}                          % width of front matter (JSR)
\parindent 1em
\newif\ifFIG\FIGfalse
\newif\ifEG\EGfalse
\newif\ifTAB\TABfalse
% For list environments delete extra spacing between items
\renewcommand{\itemhook}{%                       % from tweaklist.sty
  \setlength{\parsep}{0pt}%
  \setlength{\itemsep}{0pt}%
  \setlength{\topsep}{0pt}%
  \setlength{\partopsep}{0pt}}
% we redefine \dotfill to use \leaders and not \cleaders (see TeXBook p. 357)
% so that leaders in contents tables line up
\def\dotfill{\leaders\hbox{$\m@th \mkern1.5mu . \mkern1.5mu$}\hfill}
% Define a bold italic math font macro
\def\mathbi#1{\textbf{\em #1}}

\ifAstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% ACTA A/JAC STYLE %%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \setlength{\textheight}{239mm}                 % Page dimensions
  \setlength{\textwidth}{184mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{18pt}                   % definitive measure from ps
  \ifF@ll\setlength{\colwidth}{21pc}\fi          % definitive measure from ps
  \ifSh@rt\setlength{\colwidth}{21pc}\fi         % definitive measure from ps
  \ifC@nf\setlength{\colwidth}{21pc}\fi          % definitive measure from ps
  \setlength{\frontwidth}{128mm}
  \ifC@nf\frontwidth=\colwidth\fi                % Conference papers are 2-col
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          {\fontsize{7}{12pt}%
          \sffamily%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          \hfill%
          \d@i%
          \hfill%
          \ifC@nf%                               % Conference:
            Received \recd@te                    %     dates in 1st footer
            $\,\cdot$
            Accepted \accd@te
          \else
            {\sffamily \AUTITLE}%
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \kern12pt%
          {\fontsize{12}{12pt}
          \sffamily\bfseries{\thepage}}
          }%
        }%
        \b@r\hfill%                              % version info
      }%
    }
    \renewcommand{\@evenfoot}{
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          {\fontsize{12}{12pt}
          \sffamily\bfseries{\thepage}}
          \kern12pt%
          {\fontsize{7}{12pt}%
          \sffamily%
          \ifC@nf%                               % Conference:
            Received \recd@te                    %     dates in 1st footer
            $\,\cdot$
            Accepted \accd@te
          \else
            {\sffamily \AUTITLE}%
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \hfill%
          \d@i%
          \hfill%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          }%
        }%
        \b@r\hfill%                              % version info
      }%
    }
    \renewcommand{\@oddhead}{%
      \vbox to 30pt{%
        \hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill%
          \sffamily\textbf{\RHEAD}%
            }%
        }%
        \vskip 3pt \hrule height .1 pt width \textwidth%
      }%
    }
    \renewcommand{\@evenhead}{%
      \vbox to 30pt{%
        \hbox to \textwidth{%
          {\fontsize{16}{18pt}%
          \sffamily\textbf{\RHEAD}\hfill%
            }%
        }%
        \vskip 3pt \hrule height .1 pt width \textwidth%
      }%
    }%
  }%
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
            \hfill%
            \d@i%
            \hfill%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \kern12pt%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
              }%
          }%
        \b@r\hfill%                              % version info
        }%
      \fi%
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \fontsize{7}{12pt}\sffamily%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
            \kern12pt%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \hfill%
            \d@i%
            \hfill%
            {\fontsize{8}{12pt}%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi%
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi%
    }%
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi%
    }%
  }
  \newcommand{\ps@nofootings}{%                  % Running heads on other pages
    \renewcommand{\@oddfoot}{}%                  % version info
    \renewcommand{\@evenfoot}{}%                 % version info
    \renewcommand{\@oddhead}{%
      \hfill\llap\thepage}%
    \renewcommand{\@evenhead}{%
      \hbox to 0pt{\thepage}\hfill}%
  }
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for the new Acta style we need
%  various conditionals at the level of \section, so an expanded redefinition
%  is needed. This really only matters for applications that depend on standard
%  LaTeX features for \section, e.g. the generation of bookmarks to sections
%  within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col%
      \iffirsts@c%                               % Unbox title material
%   Here is a map of the page layout for a new-style Acta A paper. The left
%     ------------   ------------------------    box has the logo, received
%    |   50 mm    | |       128 mm           |   and accepted dates at the
%    |            | |                        |   top, and the copyright
%    |  Logo      | |   Article title        |   line at the bottom. The
%    |            | |                        |   right box has title, names
%    |  rec       | |   Author names         |   and addresses, and the
%    |  acc       | |                        |   abstract. These components
%    |            | |   Author addresses     |   are all stored in boxes
%    |            | |                        |   via their various defining
%    |            | |                        |   macros. All the stored boxes
%    |            | |   ABSTRACT             |   are then dumped out when we
%    | copyright  | |                        |   encounter the first section
%     ------------   ------------------------    in the article body. The
%     ------------------    -----------------    complication is in aligning
%    |                  /  /                 |   the bases of the left and
%    |  ARTICLE         /  /                 |   right boxes. The trick is to
%    |  BODY            /  /                 |   unpack them into a scratch
%    |                  /  /                 |   box, measure the height of
%    |                  /  /                 |   that box, and then unpack the
%    |                  /  /                 |   contents of the left and right
%    |                  /  /                 |   boxes into another box of that
%    |                  /  /                 |   height.
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%    |                  /  /                 |
%     ------------------    -----------------
         \newbox\topleft\newbox\topright         % declare the component boxes
         \newbox\TOPscr@tch
         \newdimen\toph@ight
         \setbox\topleft=\hbox{\vbox{%           % fill box to natural height
           \noindent\unhcopy\l@go\break\noindent\unhcopy\@ccline\vfill%
           \noindent\unhcopy\c@pyline}}%
         \setbox\topright=\hbox{\vbox{%          % fill box to natural height
           \vbox{\unhcopy\t@tle}\break%
           \bigskip\vbox{\noindent\unhcopy0\noindent\unhcopy2\hfill}\break%
           \bigskip\vbox{\noindent\unhcopy4\noindent\unhcopy6\hfill}\break%
           \bigskip\noindent\unhcopy\@bstract}}%
         \setbox\TOPscr@tch=\hbox{%              % stash in scratch box
           \unhbox\topleft\unhbox\topright}
         \global\dimen\toph@ight=\ht\TOPscr@tch  % determine overall height
         \hbox to 180mm{%                        % now unpack the boxes
           \hbox{%                               % first the left
             \noindent\hbox to 56mm{%
               \vtop to \dimen\toph@ight{%
                 \noindent\unhbox\l@go\break%
                 \noindent\unhbox\@ccline%
                 \vfill%
                 \noindent\unhbox\c@pyline}}}%
           \hbox{%                               % now the right
             \hbox to 114mm{%
               \vtop to \dimen\toph@ight{%
                 \hsize=114mm\vbox{\noindent\unhbox\t@tle}\break%
                 \bigskip\vbox{\noindent\unhbox0%% empty au boxes
                 \unhbox2\hfill}\break%
                 \bigskip\vbox{\noindent\unhbox4%% empty aff boxes
                 \unhbox6\hfill}\break%
                 \bigskip\noindent\unhbox\@bstract% % empty abstract box
         }}}%
         }
        % emit vita, author footnotes, title footnote (if present):
        \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
        \ifhbox\@ufn{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\@ufn}}\fi
        \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi
      \begin{multicols}{2}\singl@colfalse%
      \fi%                                       % END of \iffirsts@c
    \fi%                                         % END of \ifsingl@col
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                         % style of section heading
    \ifF@ll\sffamily\normalsize\bfseries\fi%
    \ifSh@rt\sffamily\small\bfseries\fi%
    \ifC@nf\sffamily\small\bfseries\fi%
    \thesection.\ #1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \ifF@ll
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\bfseries}}%               % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\quad\sffamily\small\bfseries}}%          % the style
  \fi
  \ifSh@rt
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\bfseries}}%               % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\sffamily\small\bfseries}}%               % the style
  \fi
  \ifC@nf
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\bfseries}}%               % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\quad\sffamily\small\bfseries}}%          % the style
  \fi
\fi
\ifCstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% ACTA C STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \setlength{\textheight}{239mm}                 % Page dimensions
  \setlength{\textwidth}{184mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{6mm}
  \setlength{\colwidth}{89mm}
  \setlength{\frontwidth}{89mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \ifc@pyright%
              \fontsize{7}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \kern3pt$\cdot$\kern3pt %
            \fi%
            \fontsize{7}{12pt}\sffamily Printed
            in Singapore -- all rights reserved
            \hfill\d@i%
            \hfill\unhbox\c@tchline%
            {\quad\fontsize{12}{12pt}\sffamily\bfseries\thepage}%
        }%
      }%
    \fi
  }
    \renewcommand{\@evenfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}\sffamily\bfseries\thepage\quad}%
            \ifc@pyright%
              \fontsize{7}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \kern3pt$\cdot$\kern3pt %
            \fi%
            \fontsize{7}{12pt}\sffamily Printed
            in Singapore -- all rights reserved
            \hfill\d@i%
            \hfill\unhbox\c@tchline%
          }%
        }%
      \fi
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}\hfill%
            \sffamily\textbf{\RHEAD}%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}%
            \sffamily\textbf{\RHEAD}\hfill%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
  }
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
            \hfill\d@i%
              \hfill%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \kern12pt%
            {\fontsize{12}{12pt}
            \textbf{\thepage}}
              }%
          }%
        \b@r\hfill%                              % version info
        }%
      \fi
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}
              \sffamily%
            \textbf{\thepage}}
            \kern12pt%
            \fontsize{7}{12pt}%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            {\fontsize{7}{12pt}%
            \hfill\sffamily\d@i%
              \hfill%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  }%
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for JSR we need a conditional at the
%  level of \section to test whether to switch to double-column mode, and so an
%  expanded redefinition is needed. This really only matters for applications
%  that depend on standard LaTeX features for \section, e.g. the generation of
%  bookmarks to sections within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                       % style of section heading
    \fontsize{11}{11pt}\sffamily\bfseries%
    %\thesection\                                % Sections not numbered
    #1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       % this segment of code
    \everypar{%                                  % is extracted with
      \if@noskipsec                              % rather little detailed
        \global\@noskipsecfalse                  % analysis from the
        {\setbox\z@\lastbox}%                    % @startsection stuff in
        \clubpenalty\@M                          % latex.ltx to ensure
        \unskip                                  % that the first paragraph
      \else                                      % following is not
        \clubpenalty \@clubpenalty               % indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \renewcommand{\subsection}{%
    \setcounter{secnumdepth}{-2}%                % Don't number
    \@startsection%                              % Subsection heading
    {subsection}%                                % the name
    {2}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip
    {\fontsize{10}{11pt}\sffamily\bfseries}}%    % the style
  \renewcommand{\subsubsection}%
    {\setcounter{secnumdepth}{-3}%               % Don't number
    \@startsection%                              % Subsubsection heading
    {subsubsection}%                             % the name
    {3}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip (run-in)
    {\fontsize{9}{11pt}\rmfamily\itshape}}%      % the style
\fi
\ifDstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% ACTA B/D STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \setlength{\textheight}{239mm}                 % Page dimensions
  \setlength{\textwidth}{184mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{6mm}
  \ifF@ll\setlength{\colwidth}{89mm}\fi
  \ifSh@rt\setlength{\colwidth}{60mm}\fi
  \ifC@nf\setlength{\colwidth}{89mm}\fi
  \setlength{\frontwidth}{128mm}
  \ifF@ll\fn@ffsettrue\fi%                       % Footnotes offset on 1st page
  \ifSh@rt\fn@ffsettrue\fi%                      % Footnotes offset on 1st page
  \ifC@nf\frontwidth=\colwidth\fi                % Conference papers are 2-col
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
            \sffamily%
            \textit{\j@urnalname}
            (\j@urnalyear).
            \if\j@urnalcode\@A@ A\fi%            % Print Acta section letter
            \if\j@urnalcode\@B@ B\fi%
            \if\j@urnalcode\@C@ C\fi%
            \if\j@urnalcode\@D@ D\fi%
            \if\j@urnalcode\@E@ E\fi%
            \if\j@urnalcode\@F@ F\fi%
            \if\j@urnalcode\@J@\fi%
            \if\j@urnalcode\@M@\fi%
            \if\j@urnalcode\@S@\fi%
            \textbf{\v@lume},
            \f@rstpage\l@stpage
            \hfill%
            \d@i%
            \hfill%
            \ifC@nf%                             % Conference:
              Received \recd@te                  %     dates in 1st footer
              $\,\cdot$
              Accepted \accd@te
            \else
              {\sffamily \AUTITLE}%
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \kern12pt%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi%
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
            \kern12pt%
            {\fontsize{7}{12pt}%
            \sffamily%
            \ifC@nf%                             % Conference:
              Received \recd@te                  %     dates in 1st footer
              $\,\cdot$
              Accepted \accd@te
            \else
                {\sffamily \AUTITLE}%
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \hfill%
            \d@i%
            \hfill%
            \textit{\j@urnalname}
            (\j@urnalyear).
            \if\j@urnalcode\@A@ A\fi%            % Print Acta section letter
            \if\j@urnalcode\@B@ B\fi%
            \if\j@urnalcode\@C@ C\fi%
            \if\j@urnalcode\@D@ D\fi%
            \if\j@urnalcode\@E@ E\fi%
            \if\j@urnalcode\@F@ F\fi%
            \if\j@urnalcode\@J@\fi%
            \if\j@urnalcode\@M@\fi%
            \if\j@urnalcode\@S@\fi%
            \textbf{\v@lume},
            \f@rstpage\l@stpage
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi%
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}\hfill%
            \sffamily\textbf{\RHEAD}%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi%
    }
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}%
            \sffamily\textbf{\RHEAD}\hfill%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi%
    }%
  }%
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
            \sffamily%
            \textit{\j@urnalname}
            (\j@urnalyear).
            \if\j@urnalcode\@A@ A\fi%            % Print Acta section letter
            \if\j@urnalcode\@B@ B\fi%
            \if\j@urnalcode\@C@ C\fi%
            \if\j@urnalcode\@D@ D\fi%
            \if\j@urnalcode\@E@ E\fi%
            \if\j@urnalcode\@F@ F\fi%
            \if\j@urnalcode\@J@\fi%
            \if\j@urnalcode\@M@\fi%
            \if\j@urnalcode\@S@\fi%
            \textbf{\v@lume},
            \f@rstpage\l@stpage
              \hfill%
              \d@i%
              \hfill%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \kern12pt%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
              }%
          }%
        \b@r\hfill%                              % version info
        }%
      \fi%
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \fontsize{7}{12pt}\sffamily%
            {\fontsize{12}{12pt}
            \sffamily\bfseries{\thepage}}
            \kern12pt%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
              \hfill%
              \d@i%
              \hfill%
            {\fontsize{7}{12pt}%
            \sffamily%
            \textit{\j@urnalname}
            (\j@urnalyear).
            \if\j@urnalcode\@A@ A\fi%            % Print Acta section letter
            \if\j@urnalcode\@B@ B\fi%
            \if\j@urnalcode\@C@ C\fi%
            \if\j@urnalcode\@D@ D\fi%
            \if\j@urnalcode\@E@ E\fi%
            \if\j@urnalcode\@F@ F\fi%
            \if\j@urnalcode\@J@\fi%
            \if\j@urnalcode\@M@\fi%
            \if\j@urnalcode\@S@\fi%
            \textbf{\v@lume},
            \f@rstpage\l@stpage
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi%
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi%
    }%
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi%
    }%
  }
  \newcommand{\ps@nofootings}{%                  % Running heads on other pages
    \renewcommand{\@oddfoot}{}%                  % version info
    \renewcommand{\@evenfoot}{}%                 % version info
    \renewcommand{\@oddhead}{%
      \hfill\llap\thepage}%
    \renewcommand{\@evenhead}{%
      \hbox to 0pt{\thepage}\hfill}%
  }
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for the new Acta style we need
%  various conditionals at the level of \section, so an expanded redefinition
%  is needed. This really only matters for applications that depend on standard
%  LaTeX features for \section, e.g. the generation of bookmarks to sections
%  within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col%
      \ifF@ll\begin{multicols}{2}\singl@colfalse\fi%
      \ifSh@rt%
        \iffirsts@c%                             % Unbox abstract and authors
          \noindent\hbox{%                       % The strange order of doing
            \hskip56mm\hbox{%                    %  things and the awkward
              \unhbox\@bstract%                  %  placement commands arise
              \hskip-146mm%                      %  from complex interactions
              \unhbox\deferredt@tle%             %  with the multicol output
            }%                                   %  routine. I don't fully
          }%                                     %  understand why it works;
        \fi                                      %  this was found empirically
        \begin{multicols}{3}\singl@colfalse%
        \iffirsts@c%                             % First switch to 3-column
           \global\multicol@leftmargin=-10mm%    % Then hack first page width
           \global\full@width=192mm%             %  and offset to generate the
           \let\h@ckoutputpage\@outputpage%      %  non-standard text columns
           \def\@outputpage{%                    %  on the first page
             \h@ckoutputpage%
             \global\multicol@leftmargin=0mm%    % Reset proper values after
             \global\full@width=184mm%           %  first page output
             \global\fn@ffsetfalse%              % Don't offset footnotes
             \global\let\@hackfntext\@makefntext%% Restore usual footnotes
             \global\frontwidth=\textwidth%      % Restore width of footnotes
             \gdef\footnoterule{%                % Ftnote rule no longer offset
               \hbox{%
                 \rule{30mm}{0.4pt}\vspace*{3pt}%
             }}%
           }%
           % The very first section starts in the second column; the bottom of
           %  the first contains the copyright line
           \vbox to \@colroom{%                  % \@colroom from multicol
             \parindent=0pt\vfill%
             \vbox{\hskip10mm\vbox{
               \fontsize{7}{10pt}\sffamily%
               \ifc@pyright%
                 \hbox{\copyright\  \j@urnalyear\
                 International Union of Crystallography}\par
               \fi%
               \if\j@urnalcode\@D@{Printed in Denmark -- all rights reserved}\fi
             }}%
           }%
          \firsts@cfalse
        \fi%
      \fi%
      \ifC@nf\begin{multicols}{2}\singl@colfalse\fi%
    \fi%                                         % END of \ifsingl@col
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                       % style of section heading
    \ifF@ll\sffamily\normalsize\bfseries\fi%
    \ifSh@rt\sffamily\small\bfseries\fi%
    \ifC@nf\sffamily\small\bfseries\fi%
      \ifChe@dings%                              % Not numbered in Acta C,E
        #1\par%
      \else%
        \thesection.\ #1\par%
      \fi%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \ifF@ll
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\normalsize\bfseries}}%          % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\quad\sffamily\normalsize\bfseries}}%     % the style
  \fi
  \ifSh@rt
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\bfseries}}%               % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\sffamily\small\bfseries}}%               % the style
  \fi
  \ifC@nf
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\bfseries}}%               % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\quad\sffamily\small\bfseries}}%          % the style
    \ifChe@dings%                                % Different style for Acta C
      \renewcommand{\subsection}{%
        \setcounter{secnumdepth}{-2}%            % Don't number
        \@startsection%                          % Subsection heading
        {subsection}%                            % the name
        {2}%                                     % the level
        {0pt}%                                   % the indent
        {\baselineskip}%                         % the beforeskip
        {2pt}%                                   % the afterskip
        {\fontsize{10}{11pt}\sffamily\small\bfseries}}%  % the style
      \renewcommand{\subsubsection}{%
        \setcounter{secnumdepth}{-3}%            % Don't number
        \@startsection%                          % Subsubsection heading
        {subsubsection}%                         % the name
        {3}%                                     % the level
        {0pt}%                                   % the indent
        {\baselineskip}%                         % the beforeskip
        {2pt}%                                   % the afterskip (run-in)
        {\fontsize{9}{11pt}\rmfamily\itshape}}%  % the style
    \fi
  \fi%
\fi%
\ifEstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% ACTA E STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \setlength{\textheight}{239mm}                 % Page dimensions
  \setlength{\textwidth}{184mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{6mm}
  \ifF@ll\setlength{\colwidth}{89mm}\fi
  \ifSh@rt\setlength{\colwidth}{60mm}\fi
  \ifC@nf\setlength{\colwidth}{89mm}\fi
  \setlength{\frontwidth}{128mm}
  \ifF@ll\fn@ffsettrue\fi%                       % Footnotes offset on 1st page
  \ifSh@rt\fn@ffsettrue\fi%                      % Footnotes offset on 1st page
  \ifC@nf\frontwidth=\colwidth\fi                % Conference papers are 2-col
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          {\fontsize{7}{12pt}%
          \sffamily%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          \hfill%
          \d@i%
          \hfill%
          \ifC@nf%                               % Conference:
            Received \recd@te                    %     dates in 1st footer
            $\,\cdot$
            Accepted \accd@te
          \else
            {\sffamily \AUTITLE}%
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \kern12pt%
          {\fontsize{12}{12pt}
          \textbf{\p@geprefix\thepage}}
          }%
        }%
        \b@r\hfill%                              % version info
      }%
    }
    \renewcommand{\@evenfoot}{
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          \sffamily%
          {\fontsize{12}{12pt}
          \textbf{\p@geprefix\thepage}}
          \kern12pt%
          {\fontsize{7}{12pt}%
          \sffamily%
          \ifC@nf%                               % Conference:
            Received \recd@te                    %     dates in 1st footer
            $\,\cdot$
            Accepted \accd@te
          \else
            {\sffamily \AUTITLE}%
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \hfill%
          \d@i%
          \hfill%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          }%
        }%
        \b@r\hfill%                              % version info
      }%
    }
    \renewcommand{\@oddhead}{%
      \vbox to 30pt{%
        \hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill%
          \sffamily\textbf{\RHEAD}%
            }%
        }%
        \vskip 3pt \hrule height .1 pt width \textwidth%
      }%
    }
    \renewcommand{\@evenhead}{%
      \vbox to 30pt{%
        \hbox to \textwidth{%
          {\fontsize{16}{18pt}%
          \sffamily\textbf{\RHEAD}\hfill%
            }%
        }%
        \vskip 3pt \hrule height .1 pt width \textwidth%
      }%
    }%
  }%
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          {\fontsize{7}{12pt}%
          \sffamily%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          \hfill%
          \sffamily\d@i%
          \hfill%
          {\sffamily \AUTITLE}%
          \ifC@nf%                               % Conference: no short title
          \else
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \kern12pt%
          {\fontsize{12}{12pt}
          \textbf{\p@geprefix\thepage}}
            }%
        }%
      \b@r\hfill%                                % version info
      }%
    }
    \renewcommand{\@evenfoot}{
      \vbox to 0pt{%
        \hrule height .1 pt width \textwidth \vskip 3pt%
        \hbox to \textwidth{%
          \sffamily%
          {\fontsize{12}{12pt}
          \textbf{\p@geprefix\thepage}}
          \kern12pt%
          \fontsize{7}{12pt}%
          {\sffamily \AUTITLE}%
          \ifC@nf%                               % Conference: no short title
          \else
            $\,\cdot$
            {\sffamily \STITLE}%
          \fi%
          \hfill%
          \sffamily\d@i%
          \hfill%
          {\fontsize{7}{12pt}%
          \sffamily%
          \textit{\j@urnalname}
          (\j@urnalyear).
          \if\j@urnalcode\@A@ A\fi%              % Print Acta section letter
          \if\j@urnalcode\@B@ B\fi%
          \if\j@urnalcode\@C@ C\fi%
          \if\j@urnalcode\@D@ D\fi%
          \if\j@urnalcode\@E@ E\fi%
          \if\j@urnalcode\@F@ F\fi%
          \if\j@urnalcode\@J@\fi%
          \if\j@urnalcode\@M@\fi%
          \if\j@urnalcode\@S@\fi%
          \textbf{\v@lume},
          \f@rstpage\l@stpage
          }%
        }%
        \b@r\hfill%                              % version info
      }%
    }
    \renewcommand{\@oddhead}{%
      \vbox to 30pt{\hbox to \textwidth{%
        {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
        \vskip 3pt \hrule height .1 pt width \textwidth}%
    }%
    \renewcommand{\@evenhead}{%
      \vbox to 30pt{\hbox to \textwidth{%
        {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
        \vskip 3pt \hrule height .1 pt width \textwidth}%
    }%
  }
  \newcommand{\ps@nofootings}{%                  % Running heads on other pages
    \renewcommand{\@oddfoot}{}%                  % version info
    \renewcommand{\@evenfoot}{}%                 % version info
    \renewcommand{\@oddhead}{%
      \hfill\llap\thepage}%
    \renewcommand{\@evenhead}{%
      \hbox to 0pt{\thepage}\hfill}%
  }
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for the new Acta style we need
%  various conditionals at the level of \section, so an expanded redefinition
%  is needed. This really only matters for applications that depend on standard
%  LaTeX features for \section, e.g. the generation of bookmarks to sections
%  within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col%
      \ifF@ll\begin{multicols}{2}\singl@colfalse\fi%
      \ifSh@rt%
        \iffirsts@c%                             % Unbox abstract and authors
          \noindent\hbox{%                       % The strange order of doing
            \hskip56mm\hbox{%                    %  things and the awkward
              \unhbox\@bstract%                  %  placement commands arise
              \hskip-146mm%                      %  from complex interaction
              \unhbox\deferredt@tle%             %  with the multicol output
            }%                                   %  routine. I don't fully
          }%                                     %  understand why it works;
        \fi                                      %  this was found empirically
        \begin{multicols}{3}\singl@colfalse%
        \iffirsts@c%                             % First switch to 3-column
           \global\multicol@leftmargin=-10mm%    % Then hack first page width
           \global\full@width=192mm%             %  and offset to generate the
           \let\h@ckoutputpage\@outputpage%      %  non-standard text columns
           \def\@outputpage{%                    %  on the first page
             \h@ckoutputpage%
             \global\multicol@leftmargin=0mm%    % Reset proper values after
             \global\full@width=184mm%           %  first page output
             \global\fn@ffsetfalse%              % Don't offset footnotes
             \global\let\@hackfntext\@makefntext%% Restore usual footnotes
             \global\frontwidth=\textwidth%      % Restore width of footnotes
             \gdef\footnoterule{%                % Ftnote rule no longer offset
               \hbox{%
                 \rule{30mm}{0.4pt}\vspace*{3pt}%
             }}%
           }%
           % The very first section starts in the second column; the bottom of
           %  the first contains the copyright line
           \vbox to \@colroom{%                  % \@colroom from multicol
             \parindent=0pt\vfill%
             \vbox{\hskip10mm\vbox{
               \fontsize{7}{10pt}\sffamily%
               \ifc@pyright%
                 \hbox{\copyright\  \j@urnalyear\
                 International Union of Crystallography}\par
               \fi%
               \if\j@urnalcode\@D@{Printed in Denmark -- all rights reserved}\fi
             }}%
           }%
          \firsts@cfalse
        \fi%
      \fi%
      \ifC@nf\begin{multicols}{2}\singl@colfalse\fi%
    \fi
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                       % style of section heading
    \ifF@ll\sffamily\normalsize\bfseries\fi%
    \ifSh@rt\sffamily\small\bfseries\fi%
    \ifC@nf\sffamily\small\bfseries\fi%
    %\thesection\                                % Sections not numbered
    #1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \renewcommand{\subsection}{%
    \setcounter{secnumdepth}{-2}%                % Don't number
    \@startsection%                              % Subsection heading
    {subsection}%                                % the name
    {2}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip
    {\fontsize{10}{11pt}\sffamily\bfseries}}%    % the style
  \renewcommand{\subsubsection}{%
    \setcounter{secnumdepth}{-3}%                % Don't number
    \@startsection%                              % Subsubsection heading
    {subsubsection}%                             % the name
    {3}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip (run-in)
    {\fontsize{9}{11pt}\rmfamily\itshape}}%      % the style
\fi
\ifSstyl@  %%%%%%%%%%%%%%%%%%%%%%% NEW JSR STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \fontsize{9}{12pt}\usefont{OT1}{ptm}{m}{n}
  \setlength{\textheight}{238mm}                 % Page dimensions
  \setlength{\textwidth}{183mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{7mm}
  \setlength{\colwidth}{88mm}
  \setlength{\frontwidth}{88mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \ifc@pyright%
              \fontsize{7}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \kern3pt$\cdot$\kern3pt %
            \fi%
            \fontsize{7}{11pt}\sffamily Printed
            in Singapore -- all rights reserved
            \hfill\unhbox\c@tchline%
            {\quad\fontsize{12}{12pt}\sffamily\bfseries\thepage}%
        }%
      }%
    \fi
  }
    \renewcommand{\@evenfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}\sffamily\bfseries\thepage\quad}%
            \ifc@pyright%
              \fontsize{7}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \kern3pt$\cdot$\kern3pt %
            \fi%
            \fontsize{7}{11pt}\sffamily Printed
            in Singapore -- all rights reserved
            \hfill\unhbox\c@tchline%
        }%
      }%
    \fi
  }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}\hfill%
            \sffamily\textbf{\RHEAD}%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}%
            \sffamily\textbf{\RHEAD}\hfill%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
  }
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
              \hfill%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
            \kern12pt%
            {\fontsize{12}{12pt}
            \textbf{\thepage}}
              }%
          }%
        \b@r\hfill%                              % version info
        }%
      \fi
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}
              \sffamily%
            \textbf{\thepage}}
            \kern12pt%
            \fontsize{7}{12pt}%
            {\sffamily \AUTITLE}%
            \ifC@nf%                             % Conference: no short title
            \else
              $\,\cdot$
              {\sffamily \STITLE}%
            \fi%
              \hfill%
            {\fontsize{7}{12pt}%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
            }%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  }%
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for JSR we need a conditional at the
%  level of \section to test whether to switch to double-column mode, and so an
%  expanded redefinition is needed. This really only matters for applications
%  that depend on standard LaTeX features for \section, e.g. the generation of
%  bookmarks to sections within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                       % style of section heading
    \fontsize{8}{11pt}\sffamily\bfseries%
    \thesection.\ #1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
    {subsection}%                                % the name
    {2}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip
    {\fontsize{8}{11pt}\sffamily\itshape}}%      % the style
  \renewcommand{\subsubsection}{\@startsection%  % Subsubsection heading
    {subsubsection}%                             % the name
    {3}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {-6pt}%                                      % the afterskip (run-in)
    {\fontsize{8}{11pt}\sffamily\itshape}}%      % the style
\fi
\ifVstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% VANILLA STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-12mm}
  \setlength{\textheight}{239mm}                 % Page dimensions
  \setlength{\textwidth}{184mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{6mm}
  \setlength{\colwidth}{89mm}
  \setlength{\frontwidth}{89mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \ifc@pyright%
              \fontsize{8}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \hfill%
            \fi%
            {\quad\fontsize{12}{12pt}\sffamily\bfseries\thepage}%
        }%
      }%
    \fi
  }
    \renewcommand{\@evenfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}\sffamily\bfseries\thepage\quad}%
            \ifc@pyright%
              \fontsize{8}{12pt}\sffamily \copyright\ %
              \j@urnalyear\ International Union of Crystallography%
              \hfill%
            \fi%
          }%
        }%
      \fi
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}\hfill%
            \sffamily\textbf{\RHEAD}%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{%
          \hbox to \textwidth{%
            {\fontsize{16}{18pt}%
            \sffamily\textbf{\RHEAD}\hfill%
              }%
          }%
          \vskip 3pt \hrule height .1 pt width \textwidth%
        }%
      \fi
    }
  }
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{7}{12pt}%
              \hfill%
            \kern12pt%
            {\fontsize{12}{12pt}
            \textbf{\thepage}}
              }%
          }%
        \b@r\hfill%                              % version info
        }%
      \fi
    }
    \renewcommand{\@evenfoot}{
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}
              \sffamily%
            \textbf{\thepage}}
            \kern12pt%
            \fontsize{7}{12pt}%
              \hfill%
          }%
          \b@r\hfill%                            % version info
        }%
      \fi
    }
    \renewcommand{\@oddhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\hfill\sffamily\textbf{\RHEAD}}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
    \renewcommand{\@evenhead}{%
      \ifhe@ders%
        \vbox to 30pt{\hbox to \textwidth{%
          {\fontsize{16}{18pt}\sffamily\textbf{\RHEAD}\hfill}}%
          \vskip 3pt \hrule height .1 pt width \textwidth}%
      \fi
    }%
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  }%
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}{\@startsection%        % Subsection heading
    {section}%                                   % the name
    {1}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip
    {\fontsize{11}{11pt}\sffamily\bfseries}}%    % the style
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
    {subsection}%                                % the name
    {2}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {2pt}%                                       % the afterskip
    {\fontsize{8}{11pt}\sffamily\itshape}}%      % the style
  \renewcommand{\subsubsection}{\@startsection%  % Subsubsection heading
    {subsubsection}%                             % the name
    {3}%                                         % the level
    {0pt}%                                       % the indent
    {\baselineskip}%                             % the beforeskip
    {-6pt}%                                      % the afterskip (run-in)
    {\fontsize{8}{11pt}\sffamily\itshape}}%      % the style
\fi
\ifXstyl@  %%%%%%%%%%%%%%%%%%%%%%% OLD JSR STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\fontsize{9.5}{12pt}\usefont{OT1}{ptm}{m}{n}
  \setlength{\textheight}{240mm}                 % Page dimensions
  \setlength{\textwidth}{174mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{6mm}
  \setlength{\colwidth}{85mm}
  \setlength{\frontwidth}{142mm}
  \ifSh@rt\frontwidth=\colwidth\fi               % Short comms are 2-col
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \vbox to 0pt{%
        \hbox to \textwidth{%
          \ifc@pyright%
            \fontsize{8}{11pt}\sffamily \copyright\ %
            \j@urnalyear\ International Union of
            Crystallography%
          \fi%
          \hfill\itshape\j@urnalfullname%
        }%
      }\hskip-\textwidth\vbox to 0pt{%
        \vskip12pt\hbox to \textwidth{%
          \fontsize{8}{11pt}\sffamily Printed
          in Singapore -- all rights reserved
          \hfill ISSN \issn\ \ifc@pyright\copyright\ \j@urnalyear\fi%
      }%
    }%
  }
    \renewcommand{\@evenfoot}{\@oddfoot}%
    \renewcommand{\@oddhead}{%
      {\hfill\fontsize{9}{12pt}\sffamily\bfseries\thepage}%
    }
    \renewcommand{\@evenhead}{%
      {\fontsize{9}{12pt}\sffamily\bfseries\thepage}\hfill%
    }
  }
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{\b@r}%              % version info
    \renewcommand{\@evenfoot}{\b@r}%             % version info
    \renewcommand{\@oddhead}{%
      \fontsize{9}{12pt}\hfill\sffamily\AUTITLE%
      \hfill$\smash{\mathsfbf\thepage}$%
    }
    \renewcommand{\@evenhead}{%
      \fontsize{9}{12pt}\sffamily%
      $\smash{\mathsfbf\thepage}$\hfill\STITLE\hfill%
    }
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  }%
% Ideally the \section command should be redefined in the LaTeX standard way
%  (as is done for \subsection etc). But for JSR we need a conditional at the
%  level of \section to test whether to switch to double-column mode, and so an
%  expanded redefinition is needed. This really only matters for applications
%  that depend on standard LaTeX features for \section, e.g. the generation of
%  bookmarks to sections within pdflatex
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}[1]{%
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
    \refstepcounter{section}%                    % increment counter
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection.\  #1}{section.0.\thesection}\fi
    {\bigskip\raggedright%                         % style of section heading
    \ifF@ll\sffamily\normalsize\bfseries\fi%
    \ifSh@rt\sffamily\normalsize\bfseries\fi%
    \ifC@nf\sffamily\normalsize\bfseries\fi%
    \thesection.\ #1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
      \fi%                                       %
    }%                                           %
  }
  \ifF@ll
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\normalsize\itshape}}%           % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\sffamily\normalsize\itshape}}%           % the style
  \fi
  \ifSh@rt
    \renewcommand{\subsection}{\@startsection%   % Subsection heading
      {subsection}%                              % the name
      {2}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {2pt}%                                     % the afterskip
      {\sffamily\small\itshape}}%                % the style
    \renewcommand{\subsubsection}{\@startsection%% Subsubsection heading
      {subsubsection}%                           % the name
      {3}%                                       % the level
      {0pt}%                                     % the indent
      {\baselineskip}%                           % the beforeskip
      {-6pt}%                                    % the afterskip (run-in)
      {\sffamily\small\itshape}}%                % the style
  \fi
\fi
\ifPstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%% PREPRINT STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%
  \def\b@r{{\tiny IUCr macros version 2.1.10: \f@@ \hfill}}
  \setlength{\textheight}{220mm}                 % Page dimensions
  \setlength{\textwidth}{143mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{10pt}
  \setlength{\evensidemargin}{10pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{4mm}
  \setlength{\colwidth}{80mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
      \vbox to 0pt{%
        \hrule\vskip6pt%
        \hbox to \textwidth{%
          \fontsize{8}{10pt}\rmfamily%
          PREPRINT: \itshape\j@urnalfullname\hfill%
          \rmfamily A Journal of the International Union of
          Crystallography%
        }%
      }%
    \hskip-\textwidth\vbox to 0pt{%
      \vskip16pt\hbox to \textwidth{%
        \fontsize{8}{10pt}\rmfamily%
      }%
    }%
  }
    \renewcommand{\@evenfoot}{\@oddfoot}%
    \renewcommand{\@oddhead}{%
      \hbox to \textwidth{%
        \ifF@ll%
          {\fontsize{10}{12pt}\hfill\rmfamily\thepage}
        \fi%
        \ifSh@rt%
          {\fontsize{10}{12pt}\hfill%
          \hfill\rmfamily\thepage}%
        \fi%
        }%
      }
    \renewcommand{\@evenhead}{%
      \hbox to\textwidth{%
      \ifF@ll%
        {\fontsize{10}{12pt}\rmfamily\thepage}\hfill%
      \fi%
      \ifSh@rt%
        {\fontsize{10}{12pt}\rmfamily\thepage}\hfill%
      \fi%
      }%
    }%
  }%
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{\b@r}%              % version info
    \renewcommand{\@evenfoot}{\b@r}%             % version info
     \renewcommand{\@oddhead}{\hfill\llap\thepage}%
     \renewcommand{\@evenhead}{\hfill\llap\thepage}%
  }%
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}{\@startsection%        % Subsection heading
     {section}%                                  % the name
     {1}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {6pt}%                                      % the afterskip
     {\bigskip\centering%
       \rmfamily\normalsize\bfseries %           % the style
       \global\@afterindentfalse
     }
  }
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
     {subsection}%                               % the name
     {2}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {6pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
  \renewcommand{\subsubsection}{\@startsection%  % Subsubsection heading
     {subsubsection}%                            % the name
     {3}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {-6pt}%                                     % the afterskip (run-in)
     {\normalfont\normalsize\itshape}%           % the style
  }
% Some stuff for IT in preprint mode only
  \renewcommand{\part}[1]{\setcounter{part}{#1}}
  \@onlypreamble{\part}%                         % Only in preamble
  \renewcommand{\chapter}[1]{\setcounter{chapter}{#1}}
  \@onlypreamble{\chapter}%                      % Only in preamble
\fi
\ifIstyl@ %%%%%%%%%%%%%%%%%%% INTERNATIONAL TABLES STYLE %%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-23.75pt}
  \setlength{\voffset}{-38.27pt}
  \setlength{\textheight}{220mm}                 % Page dimensions (was 254 mm)
  \setlength{\textwidth}{143mm}
  \iff@llsize  % Full page size for International Tables
    \setlength{\textheight}{756pt}
    \setlength{\textwidth}{546pt}
  \fi
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{6pt}
  \setlength{\footskip}{18pt}
  \setlength{\columnsep}{18pt}
  \setlength{\colwidth}{264pt}
  \setlength{\parskip}{0pt}
  \renewcommand{\theequation}{%
    \arabic{part}.%
    \arabic{chapter}.%
    \arabic{section}.%
    \arabic{equation}%
  }
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{\hfill\fontsize{11}{12}\selectfont%
      \thepage\hfill}%
    \renewcommand{\@evenfoot}{\@oddfoot}%
    \renewcommand{\@oddhead}{}%
    \renewcommand{\@evenhead}{}%
  }%
\def\cifdicname{\relax}%                         % Set in CIF dictionaries
\def\cifdiccategory{\relax}%                     % Set in CIF dictionaries
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{%
      \fontsize{11}{12}\selectfont%
      \hfill\thepage\hfill\llap{\b@r}}%          % version info
    \renewcommand{\@evenfoot}{%
      \fontsize{11}{12}\selectfont%
      \hfill\thepage\hfill\llap{\b@r}}%          % version info
    \renewcommand{\@oddhead}{%
\rlap{\textbf{\cifdicname}}%
      \hfill\thepart.\thechapter. \STITLE\hfill%
\llap{\textbf{\botmark}}}
    \renewcommand{\@evenhead}{%
\rlap{\textbf{\firstmark}}
      \hfill\thepart. \PARTTITLE\hfill%
\llap{\textbf{\cifdicname}}}%
  }%
  \renewcommand{\thepart}{%                      % Section numbering
     \arabic{part}}
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{part}.\arabic{chapter}.\arabic{section}}
\let\theBOOKMARKsection\thesection
\ifb@lds@ction%
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \if@ppend@x A\fi%
      \arabic{part}.\arabic{chapter}.\arabic{section}.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \if@ppend@x$\mathrm{A}$\fi%
     $\arabic{part}.\arabic{chapter}.\arabic{section}.\arabic{subsection}%
     .\arabic{subsubsection}$}
\else%
  \renewcommand{\thesubsection}{%                % Subsection numbering
     $\thesection.\arabic{subsection}$}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.$\arabic{subsubsection}$}
\fi
  \renewcommand{\theparagraph}{%                 % 4th-level section numbering
     \thesubsubsection.$\arabic{paragraph}$}
  \renewcommand{\thesubparagraph}{%              % 5th-level section numbering
     \theparagraph.$\arabic{subparagraph}$}
\renewcommand{\theexample}{%
  \thesection.$\arabic{example}$}
\renewcommand{\thefigure}{%
  \thesection.$\arabic{figure}$}
\renewcommand{\thetable}{%
  \thesection.$\arabic{table}$}
  \renewcommand{\part}[1]{\setcounter{part}{#1}}
  \@onlypreamble{\part}%                         % Only in preamble
  \renewcommand{\chapter}[1]{\setcounter{chapter}{#1}}
  \@onlypreamble{\chapter}%                      % Only in preamble
  \renewcommand{\section}[1]{%                   % 
    \ifmkttl\else\maketitle\fi                   % Ensure title block flushed
      \iffirsts@c%                               % Unbox title material
        \ifshow@bs%                              % Unbox abstract/keywords
          \@ifundefined{@bstract}%
            {\relax}%
            {\bigskip\noindent\unhcopy\@bstract\show@bsfalse}
        \fi
      \fi
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
    \refstepcounter{section}%                    % increment counter
    \setcounter{example}{0}                      % caption numbering by section
    \setcounter{figure}{0}                       % caption numbering by section
    \setcounter{table}{0}                        % caption numbering by section
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection\  #1}{section.0.\thesection}\fi
    {\vskip 12pt plus8pt minus2pt\centering%     % style of section heading
    \rmfamily\normalsize\bfseries%
    \thesection.\ #1\par%
    \vskip-\baselineskip%
    %\vskip4pt minus 4pt}%
    \vskip3pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
     \fi%                                        %
    }%                                           %
  }
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
\ifb@lds@ction%
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
     {subsection}%                               % the name
     {2}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {3pt}%                                      % the afterskip
     {\normalfont\normalsize\bfseries}%          % the style
   }
\else%
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
     {subsection}%                               % the name
     {2}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {3pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
\fi
  \renewcommand{\subsubsection}{\@startsection%  % Subsubsection heading
     {subsubsection}%                            % the name
     {3}%                                        % the level
     %{1em}%                                     % the indent
     {\ifb@lds@ction0pt\else1em\fi}%             % the indent
     {\baselineskip}%                            % the beforeskip
     {3pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
  \addtocounter{secnumdepth}{2}
  \newcommand{\sectioniv}{\@startsection%        % Subsubsection heading
     {paragraph}%                                % the name
     {4}%                                        % the level
     {1em}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {3pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
  \newcommand{\sectionv}{\@startsection%         % Subsubsection heading
     {subparagraph}%                             % the name
     {5}%                                        % the level
     {1em}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {3pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
\fi
\ifOstyl@ %%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD ACTA STYLE %%%%%%%%%%%%%%%%%%%%%
  \setlength{\textheight}{220mm}                 % Page dimensions
  \setlength{\textwidth}{163mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headsep}{5mm}
  \setlength{\footskip}{5mm}
  \setlength{\columnsep}{4mm}
  \setlength{\colwidth}{80mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{%
    \if\relax\j@urnalcode
    \else
      \vbox to 0pt{%
        \hbox to \textwidth{%
          \ifc@pyright%
            \fontsize{8}{10pt}\rmfamily \copyright\ %
            \j@urnalyear\ International Union of
            Crystallography%
          \fi%
          \hfill\itshape\j@urnalfullname%
        }%
      }%
    \hskip-\textwidth\vbox to 0pt{%
      \vskip11pt\hbox to \textwidth{%
        \fontsize{8}{10pt}\rmfamily Printed
        in Singapore -- all rights reserved
        \hfill ISSN \issn\ \ifc@pyright\copyright\ \j@urnalyear\fi%
      }%
    }%
  \fi
  }
    \renewcommand{\@evenfoot}{\@oddfoot}%
    \renewcommand{\@oddhead}{%
      \hbox to \textwidth{%
        \ifF@ll%
          {\fontsize{10}{12pt}\hfill\rmfamily\thepage}
        \fi%
        \ifSh@rt%
          {\fontsize{10}{12pt}\hfill%
          \rmfamily{SHORT COMMUNICATIONS}%
          \hfill\rmfamily\thepage}%
        \fi%
        }%
      }
    \renewcommand{\@evenhead}{%
      \hbox to\textwidth{%
      \ifF@ll%
        {\fontsize{10}{12pt}\rmfamily\thepage}\hfill%
      \fi%
      \ifSh@rt%
        {\fontsize{10}{12pt}\rmfamily\thepage}\hfill%
        \rmfamily{SHORT COMMUNICATIONS}\hfill%
      \fi%
      }%
    }%
  }%
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{\b@r}%              % version info
    \renewcommand{\@evenfoot}{\b@r}%             % version info
    \renewcommand{\@oddhead}{%
      \hfill\uppercase{\AUTITLE}\hfill\llap\thepage}%
    \renewcommand{\@evenhead}{%
      \hbox to 0pt{\thepage}\hfill\STITLE\hfill}%
  }%
  \newcommand{\ps@nofootings}{%                  % Running heads on other pages
    \renewcommand{\@oddfoot}{}%                  % version info
    \renewcommand{\@evenfoot}{}%                 % version info
    \renewcommand{\@oddhead}{%
      \hfill\llap\thepage}%
    \renewcommand{\@evenhead}{%
      \hbox to 0pt{\thepage}\hfill}%
  }
  \renewcommand{\thesection}{%                   % Section numbering
     \arabic{section}
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{%                % Subsection numbering
     \thesection.\arabic{subsection}}
  \renewcommand{\thesubsubsection}{%             % Subsubsection numbering
     \thesubsection.\arabic{subsubsection}}
  \renewcommand{\@seccntformat}[1]{\csname the#1\endcsname.\ }
  \renewcommand{\section}{\@startsection%        % Subsection heading
     {section}%                                  % the name
     {1}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {6pt}%                                      % the afterskip
     {\ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
       \smallskip\centering%
       \rmfamily\normalsize\bfseries %           % the style
       \global\@afterindentfalse
     }
  }
  \renewcommand{\subsection}{\@startsection%     % Subsection heading
     {subsection}%                               % the name
     {2}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {6pt}%                                      % the afterskip
     {\normalfont\normalsize\itshape}%           % the style
  }
  \renewcommand{\subsubsection}{\@startsection%  % Subsubsection heading
     {subsubsection}%                            % the name
     {3}%                                        % the level
     {0pt}%                                      % the indent
     {\baselineskip}%                            % the beforeskip
     {-6pt}%                                     % the afterskip (run-in)
     {\normalfont\normalsize\itshape}%           % the style
  }
\fi
\ifYstyl@ %%%%%%%%%%%%%%%%%%% CONFERENCE ABSTRACTS STYLE %%%%%%%%%%%%%%%%%%%%%
  \setlength{\hoffset}{-4.4mm}
  \setlength{\voffset}{-0.4mm}
  \setlength{\textheight}{247mm}                 % Page dimensions
  \setlength{\textwidth}{168mm}
  \setlength{\topmargin}{0pt}
  \setlength{\oddsidemargin}{0pt}
  \setlength{\evensidemargin}{0pt}
  \setlength{\headheight}{0mm}
  \setlength{\headsep}{0mm}
  \setlength{\footskip}{0mm}
  \setlength{\columnsep}{8mm}
  \setlength{\colwidth}{80mm}
  \setlength{\frontwidth}{80mm}
  \renewcommand{\ps@plain}{%                     % Running heads on first page
    \renewcommand{\@oddfoot}{\relax}
    \renewcommand{\@evenfoot}{\relax}
    \renewcommand{\@oddhead}{\relax}
    \renewcommand{\@evenhead}{\relax}
  }
  \renewcommand{\ps@myheadings}{%                % Running heads on other pages
    \renewcommand{\@oddfoot}{\relax}
    \renewcommand{\@evenfoot}{\relax}
    \renewcommand{\@oddhead}{\relax}
    \renewcommand{\@evenhead}{\relax}
  }
  \renewcommand{\thesection}{\relax}   
\let\theBOOKMARKsection\thesection
  \renewcommand{\thesubsection}{\relax}   
  \renewcommand{\thesubsubsection}{\relax}   
  \renewcommand{\section}{\relax}   
  \renewcommand{\subsection}{\relax}   
  \renewcommand{\subsubsection}{\relax}   
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ================================== END OF STYLES ===========================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\endminipage{%                               % Hack: redefine endminipage
    \par%                                        %  to omit footnote rule
    \unskip
    \ifvoid\@mpfootins\else
      \vskip\skip\@mpfootins
      \normalcolor
      %\footnoterule
      \unvbox\@mpfootins
    \fi
    \@minipagefalse
  \color@endgroup
  \egroup
  \expandafter\@iiiparbox\@mpargs{\unvbox\@tempboxa}}

%
% ====================== new environments ====================================
% Syntax is \newenvironment{myenv}[narg][default]{begdef}{enddef}
%

% Some special environments for listings of Crystallographic Information File
%  (CIF) extracts
\def\setupverbatim{\ttfamily\bfseries%
  \def\par{\endgraf\leavevmode}\obeylines\obeyspaces}
\newenvironment{cifdefblock}%                    % CIF DICTIONARY DEFINITION
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}%
  \par\noindent\begin{minipage}[t]{\colwidth}%
  \parindent=0pt\parskip=1pt%
}
{%                                               % End environment
  \end{minipage}%
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi%
}
\newenvironment{boxedcifdefblock}%               % BOXED CIFDIC ENTRY
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}
  \par\noindent\begin{boxedminipage}[t]{\colwidth}
  \parindent=0pt\parskip=1pt
}
{%                                               % End environment
  \end{boxedminipage}%
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi%
}
\catcode`\^^@=8
\newenvironment{ciflisting}%                     % CIF LISTING
{%                                               % Begin new environment
  % Make the underscore character active so that it can be treated as part
  %  of a CIF data name in macros which typeset CIF listings
  \catcode`\_=\active\def\_{\ifmmode^^@\else\char'137{}\fi}
  \vskip 6pt plus 0pt minus 1pt%
  \baselineskip=9pt%
  \parindent=0pt%
  \fontsize{8}{9pt}%
  \setupverbatim%
}
{%                                               % End environment
  \baselineskip=8pt%
  \parskip=-10pt%
  \fontsize{8}{9pt}%
\par%
  \catcode`\_=8%
}

% JSR has awkward placement of the title and author group. This was
%  originally handled by a minipage, but title and author footnotes then
%  come out in the wrong place or vanish. "meenypage" is a minipage-like
%  environment to keep footnotes.
\newenvironment{meenypage}%                      % MODIFIED MINIPAGE
{%                                               % Begin new environment
  \leavevmode
  \@pboxswfalse
  \ifF@ll%
    \setlength\@tempdima{158mm}%                 % \frontwidth + indent
  \fi
  \ifSh@rt%
    \setlength\@tempdima{\colwidth}%             % same as \frontwidth
  \fi
  \setbox\@tempboxa\vbox\bgroup
    \hsize\@tempdima
    \textwidth\hsize \columnwidth\hsize
    \@parboxrestore
    \ifF@ll\everypar{\hangindent=16mm\hangafter=0}\fi
    \ifSh@rt\everypar{\noindent\raggedright}\fi
    \ifC@nf\everypar{\noindent}\fi
}
{%                                               % End environment
    \egroup
  \unvbox\@tempboxa
}

\newenvironment{references}%                     % REFERENCES
{%                                               % Begin new environment
  \bigskip%                                      % extra space above
  \ifAstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifCstyl@%
    \begin{small}
    \hrule height .1 pt width \colwidth \vskip 3pt%  % Suppl. data footnote
    \noindent Supplementary data for this paper are available from
    the IUCr electronic archives (Reference: \cn@r). Services for
    accessing these data are described at the back of the journal.
    \vskip 3pt \hrule height .1 pt width \colwidth%
    \bigskip%
    {\noindent\sffamily\fontsize{11}{11}%
    \bfseries References}                        % Heading
  \fi%
  \ifDstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifEstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifIstyl@%
%   \begin{center}%
%   \textbf{References}%
%   \end{center}%                                % Heading
    \baselineskip=20pt
    \parskip=10pt
  \fi%
  \ifSstyl@%
    {\noindent\fontsize{8}{12pt}\sffamily%
    \bfseries References}                        % Heading
    \fontsize{8}{9pt}\usefont{OT1}{ptm}{m}{n}
  \fi%
  \ifOstyl@%
    \ifF@ll%
      \begin{small}
      \begin{center}%
      \textbf{References}%
      \end{center}%                              % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      \begin{center}%
      \textbf{References}%
      \end{center}%                              % Heading
    \fi%
  \fi%
  \ifPstyl@%
    \begin{small}
    \begin{center}%
    \textbf{References}%
    \end{center}%                                % Heading
    \baselineskip=20pt
    \parskip=10pt
  \fi%
  \ifVstyl@%
    \begin{small}
    {\noindent\sffamily\normalsize%
    \bfseries References}                        % Heading
  \fi%
  \ifXstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifYstyl@%
    %\begin{small}
  \fi%
  \medskip%                                      % Space after heading
  \everypar{\noindent}%
}
{%                                               % End environment
  \everypar{\noindent%
  \hangindent=1em\hangafter=1}%                  % Hanging paragraphs
    \ifC@nf
      \end{footnotesize}%
    \fi
    \ifF@ll%
      \ifIstyl@%
      \else%
        \ifSstyl@%
        \else%
          \end{small}%
        \fi%
      \fi%
    \fi
    \ifSh@rt%
      \ifPstyl@%
        \end{small}%
      \else%
        \end{footnotesize}%
      \fi%
    \fi
  \ifYstyl@%
    \everypar{\noindent}%
    %\end{small}
  \fi
}

% The optional argument is not used, but is supplied (with a default) to
% ensure that the leading space is omitted from the body text if it starts
% on a new line after the environment declaration (which is usual)
\newbox\@ffnote
\newenvironment{affiliationnote}[1][\relax]%     % AFFILIATION NOTE
{%                                               % Begin new environment
\global\setbox\@ffnote\vbox\bgroup%              % store in \box126
\bigskip%                                        % extra space above
\fontsize{8}{10}\selectfont%
\hrule width 64pt%
\medskip\noindent%
}
{%                                               % End environment
\par%
\egroup%
\unvbox\@ffnote%
}
\newbox\k@ynote
\newenvironment{keynote}[1][\relax]%             % CIF CATEGORY LISTING NOTE
{%                                               % Begin new environment
\global\setbox\k@ynote\vbox\bgroup%              % store in \box126
%\bigskip%                                        % extra space above
\fontsize{8}{10}\selectfont%
\begin{it}
\smallskip\noindent%
}
{%                                               % End environment
\par%
\end{it}
\egroup%
\unvbox\k@ynote%
\smallskip                                         % discardable glue
}


\newenvironment{synopsis}%                       % SYNOPSIS
{%                                               % Begin new environment
  \ifmkttl\else\maketitle\fi%                    % ensure author group printed
                                                 %  (breaks environment, but
                                                 %  ensures that front matter
                                                 %  doesn't disappear)
\global\setbox128\vbox\bgroup                    % store in \box128
  \begin{center}%                                % centre on page
  \begin{minipage}{\textwidth}%                  % constrain width
  \bigskip%                                      % extra space above
  \hrule%
  \small%                                        % small typeface
  \smallskip%
  \begin{center}\textbf{Synopsis}\end{center}%   % Heading
}
{%                                               % End environment
  \smallskip%
  \hrule%
  \end{minipage}%
  \end{center}%
\egroup
}

% In the abstract footnotes are not allowed for new-style papers. If they
%  do appear, we make them vanish; but to give a clue to the author we
%  redefine the footnote macro in preprint mode to emit a warning
\newcommand{\warnfootnote}[1]{%
  \w@rn{\textbf{(WARNING: Footnotes not permitted here.
    This will not be printed in the publication version.)} %
    #1}%
}
\renewenvironment{abstract}%                     % ABSTRACT
{%                                               % Begin new environment
  \ifmkttl\else\maketitle\fi%                    % ensure author group printed
%                                                %  (breaks environment, but
%                                                %  ensures that front matter
%                                                %  doesn't disappear)
  \ifAstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \newbox\@bstract                             % The contents are stored
    \global\setbox\@bstract%                     %  in a box for subsequent
    \hbox to 0mm\bgroup\vbox\bgroup\hsize114mm%  %  retrieval
      \parindent=0pt%\vskip-\baselineskip%
      \ifSh@rt\begin{normalsize}\fi
  \fi
  \ifCstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \parindent=0pt%
  \fi
  \ifDstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \ifC@nf%
      \bigskip%
      \parindent=0pt%
    \fi
    \ifF@ll%
      \parindent=0pt%
    \fi
    \ifSh@rt%
      \newbox\@bstract                           % The contents are stored
      \global\setbox\@bstract%                   %  in a box for subsequent
      \hbox to 0mm\bgroup\vtop\bgroup\hsize90mm% %  retrieval
        \parindent=0pt\vskip-\baselineskip%
    \fi
  \fi
  \ifEstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \ifC@nf%
      \bigskip%
      \parindent=0pt%
    \fi
    \ifF@ll%
      \parindent=0pt%
    \fi
    \ifSh@rt%
      \newbox\@bstract                           % The contents are stored
      \global\setbox\@bstract%                   %  in a box for subsequent
      \hbox to 0mm\bgroup\vtop\bgroup\hsize90mm% %  retrieval
        \parindent=0pt\vskip-\baselineskip%
    \fi
  \fi
  \ifSstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \parindent=0pt%
    \fontsize{9}{11pt}\usefont{OT1}{ptm}{m}{n}
  \fi
  \ifIstyl@%
    \parindent=0pt%
    \ifshow@bs%
      \keyw@rdtrue
    \fi%
      \let\footnote\v@nish                         % Footnotes not allowed!
      \newbox\@bstract                             % The contents are stored
      \global\setbox\@bstract%                     %  in a box for subsequent
      \hbox to 0mm\bgroup\vbox\bgroup\hsize\textwidth%  %  retrieval
      \bigskip%                                    % extra space above
      \begin{center}\textbf{Abstract}\end{center}% % Heading
        \parindent=0pt%\vskip-\baselineskip%
%    \fi%
  \fi%
  \ifOstyl@%
    \bigskip%                                    % extra space above
    \begin{center}\textbf{Abstract}\end{center}% % Heading
  \fi%
  \ifPstyl@
    \let\w@rn\footnote
    \let\footnote\warnfootnote                   % Footnotes not allowed!
    \bigskip%
    \begin{center}\textbf{Abstract}\end{center}%
  \fi%
  \ifVstyl@%
    \let\footnote\v@nish                         % Footnotes not allowed!
    \parindent=0pt%
  \fi
  \ifXstyl@%
    \begin{center}%
    \begin{minipage}{\frontwidth}
  \fi
  \ifYstyl@%
    {\noindent\rmfamily\fontsize{9}{11pt}\bfseries
    \ifvoid7\else\vskip10pt\raggedright Keywords: \unhbox7.\par\fi}%
    \parindent=0pt%
    \parskip=6pt%
    \fontsize{9}{11pt}\usefont{OT1}{ptm}{m}{n}
  \fi
  \smallskip%                                    % Space after heading
}
{%                                               % End environment
  \ifAstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
      \ifSh@rt\end{normalsize}\fi
    \egroup\egroup%
  \fi%
  \ifCstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
  \fi%
  \ifDstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
    \ifSh@rt\egroup\egroup\fi%                   % Finish storing in box
    \bigskip%
  \fi%
  \ifEstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
    \ifSh@rt\egroup\egroup\fi%                   % Finish storing in box
    \bigskip%
  \fi%
  \ifSstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \smallskip%
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7%
      \else%
        \par\raggedright Keywords: \unhbox7.\par%
      \fi%
    \fi%
  \fi%
  \ifIstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\rmfamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
    \egroup\egroup%
  \fi%
  \ifOstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
  \fi%
  \ifPstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
  \fi%
  \ifVstyl@%
    \ifkeyw@rd%                                  % keywords in \box7
      \noindent\sffamily\fontsize{8}{11}\bfseries
      \ifvoid7\else\vskip6pt\raggedright Keywords: \unhbox7.\par\fi%
    \fi
  \fi%
  \ifXstyl@%
    \smallskip%
    \ifF@ll%
      \noindent\sffamily\normalsize\bfseries
      \ifvoid7%
      \else%
        \raggedright Keywords: \unhbox7.\par%    % keywords are in \box7
      \fi%
    \fi%
    \ifSh@rt%
      \noindent\sffamily\small\bfseries
      \ifvoid7%
      \else%
        \raggedright Keywords: \unhbox7.\par%    % keywords are in \box7
      \fi%
    \fi%
    \end{minipage}%
    \end{center}%
  \fi%
}

\newbox\b@x
\renewenvironment{figure}[1][\relax]             % FIGURE (not float)
{%                                               % Begin new environment
  \if\relax#1\else\renewcommand{\thefigure}{#1}\fi  % Override autonumbering
  \global\fn@ffsetfalse%                         % Don't offset footnotes
  \vskip 12pt plus 4pt minus 12pt
  \noindent
  \ifsingl@col%
    \bgroup                                                % Added to fix
    \parskip-11pt                                          % top/bottom  
    \leavevmode\vtop to 3pt{\vfill}\par\nobreak\noindent%  % spacings
    \begin{minipage}{\textwidth}%
  \else%
    \hskip-\leftskip%                      % back out of indented environments
    \bgroup                                                % Added to fix
    \parskip-11pt                                          % top/bottom  
    \leavevmode\vtop to 3pt{\vfill}\par\nobreak\noindent%  % spacings
    \begin{minipage}{\colwidth}%
  \fi%
  \begin{center}
  \refstepcounter{figure}
  \FIGtrue
}
{%                                               % End environment
  \end{center}
  \ifIstyl@%
    \vskip -6pt%
  \else%
    \vskip 6pt plus 2pt minus 2pt%
  \fi
  \setbox\b@x=\hbox{\captionbox}
  \ifOstyl@                                      % Old style:
    \ifdim\wd\b@x>\colwidth                      %   multiline caption:
      \captionbox%                               %   print deferred caption
    \else                                        %   single-line caption:
      \begin{center}                             %   centred
      \captionbox                                %   print deferred caption
      \end{center}
    \fi
  \else
      \captionbox%                               % print deferred caption
  \fi
  \end{minipage}%
  \vspace*{10pt}\par\noindent\nobreak \smash{\phantom{0}}  % Added to fix
  \egroup                                                  % spacing
  \vskip 10pt plus 4 pt minus 4pt%
  \FIGfalse
}
\newenvironment{bottomfigure}[1][\relax]             % FIGURE (not float)
{%                                               % Begin new environment
  \if\relax#1\else\renewcommand{\thefigure}{#1}\fi  % Override autonumbering
  \global\fn@ffsetfalse%                         % Don't offset footnotes
  \vskip 12pt plus 4pt minus 12pt
  \noindent
  \ifsingl@col%
    \begin{minipage}{\textwidth}%
  \else%
    \hskip-\leftskip%                      % back out of indented environments
    \begin{minipage}{\colwidth}%
  \fi%
  \begin{center}
  \refstepcounter{figure}
  \FIGtrue
}
{%                                               % End environment
  \end{center}
  \vskip 6pt plus 2pt minus 2pt%
  \setbox\b@x=\hbox{\captionbox}
  \ifOstyl@                                      % Old style:
    \ifdim\wd\b@x>\colwidth                      %   multiline caption:
      \captionbox%                               %   print deferred caption
    \else                                        %   single-line caption:
      \begin{center}                             %   centred
      \captionbox                                %   print deferred caption
      \end{center}
    \fi
  \else
      \captionbox%                               % print deferred caption
  \fi
  \end{minipage}%
% \vskip 10pt plus 4 pt minus 4pt%
  \FIGfalse
}
\newenvironment{example}[1][\relax]              % EXAMPLE (not float)
{%                                               % Begin new environment
  \if\relax#1\else\renewcommand{\theexample}{#1}\fi  % Override autonumbering
  \global\fn@ffsetfalse%                         % Don't offset footnotes
  \vskip 12pt plus 4pt minus 12pt
  \noindent
  \ifsingl@col%
    \bgroup                                                % Added to fix
    \parskip-11pt                                          % top/bottom  
    \leavevmode\vtop to 3pt{\vfill}\par\nobreak\noindent%  % spacings
    \begin{boxedminipage}{\textwidth}%
  \else%
    \hskip-\leftskip%                      % back out of indented environments
    \bgroup                                                % Added to fix
    \parskip-11pt                                          % top/bottom  
    \leavevmode\vtop to 3pt{\vfill}\par\nobreak\noindent%  % spacings
    \begin{boxedminipage}{\colwidth}%
  \fi%
  \refstepcounter{example}
  \EGtrue
}
{%                                               % End environment
  \vskip 6pt plus 2pt minus 2pt%
  \end{boxedminipage}%
  \vspace*{10pt}\par\noindent\nobreak \smash{\phantom{0}}  % Added to fix
  \egroup                                                  % spacing
  \vskip 10pt plus 4 pt minus 4pt%
  \EGfalse
}

\renewenvironment{table}[1][\relax]              % TABLE (not float)
{%                                               % Begin new environment
  \if\relax#1\else\renewcommand{\thetable}{#1}\fi  % Override autonumbering
  \global\fn@ffsetfalse%                         % Don't offset footnotes
  \ifPstyl@\else\ifVstyl@\else
    \def\hline{\noindent%                        % resize hlines
      \kern0pt\hbox to 0pt{%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth%
        }%
      }%
      \\%
    }%
  \fi\fi
  \vskip 12pt plus 2pt minus 12pt%
  \noindent%
  \ifsingl@col%
    \begin{minipage}{\textwidth}%
  \else%
    \hskip-\leftskip%                      % back out of indented environments
    \begin{minipage}{\colwidth}%
    \parindent-6pt%
  \fi%
  \refstepcounter{mpfootnote}                    % start footnotes with dagger
  \ifOstyl@\begin{center}\fi
  \refstepcounter{table}%
  \TABtrue%
  \ifIstyl@%
    \fontsize{8}{10}\selectfont
  \else%
    \begin{small}%
  \fi
}
{%                                               % End environment
  \ifIstyl@%
  \else%
  \end{small}%
  \fi
  \ifAstyl@\hrule height .1pt\fi%                % end rule for new Acta tables
  \ifCstyl@\hrule height .1pt\fi%                % end rule for new Acta tables
  \ifDstyl@\hrule height .1pt\fi%                % end rule for new Acta tables
  \ifEstyl@\hrule height .1pt\fi%                % end rule for new Acta tables
  \ifSstyl@\hrule height .1pt\fi%                % end rule for new Acta tables
  \ifVstyl@\hrule height .1pt\fi%                % end rule for vanilla tables
  \ifXstyl@\hrule height .1pt\fi%                % end rule for JSR tables
  \ifYstyl@\hrule height .1pt\fi%                % end rule for JSR tables
  \vskip 6pt plus 2pt minus 2pt%
  \ifOstyl@\end{center}\fi
  \end{minipage}%
  \vskip 12pt plus 2 pt minus 6pt%
  \TABfalse
}

\renewenvironment{thebibliography}[1]            % BIBLIOGRAPHY
{%                                               % Begin new environment
  \penalty-2000\medskip%
  \ifAstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifCstyl@%
    \begin{small}
    {\noindent\sffamily\normalsize%
    \bfseries References}                        % Heading
  \fi%
  \ifDstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifEstyl@%
    \ifF@ll%
      \begin{small}
      {\noindent\sffamily\normalsize%
      \bfseries References}                      % Heading
    \fi%
    \ifSh@rt%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
    \ifC@nf%
      \begin{footnotesize}
      {\noindent\sffamily\small%
      \bfseries References}                      % Heading
    \fi%
  \fi%
  \ifOstyl@%
    \ifF@ll\begin{small}\fi%
    \ifSh@rt\begin{footnotesize}\fi%
    \begin{center}\textbf{References}\end{center}%% Supply new head
  \fi%
 \ifPstyl@%
    \begin{small}%
    \begin{center}\textbf{References}\end{center}%% Supply new head
  \fi%
  \ifSstyl@%
    \begin{small}
    {\noindent\sffamily\normalsize%
    \bfseries References}                        % Heading
    \fontsize{8}{12pt}\usefont{OT1}{ptm}{m}{n}
  \fi%
  \ifVstyl@%
    \begin{small}
    {\noindent\sffamily\normalsize%
    \bfseries References}                        % Heading
  \fi%
  \ifXstyl@%
    \ifF@ll\begin{small}%
      {\noindent\sffamily\normalsize%
      \bfseries References}%                     % Heading
    \fi
    \ifSh@rt\begin{footnotesize}%
      {\noindent\sffamily\small%
      \bfseries References}%                     % Heading
    \fi
  \fi%
  \list{\@biblabel{\@arabic\c@enumiv}}%
  {\settowidth\labelwidth{\@biblabel{#1}}%
  \leftmargin\labelwidth
  \advance\leftmargin\labelsep
  \@openbib@code
  \usecounter{enumiv}%
  \let\p@enumiv\@empty
  \renewcommand\theenumiv{\@arabic\c@enumiv}}%
  \sloppy\clubpenalty4000\widowpenalty4000%
  \sfcode`\.\@m%
}
{%                                               % End environment
  \def\@noitemerr%
    {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist%

  \ifAstyl@%
    \ifF@ll\end{small}\fi%
    \ifSh@rt\end{footnotesize}\fi%
    \ifC@nf\end{footnotesize}\fi%
  \fi%
  \ifCstyl@%
    \end{small}
  \fi%
  \ifDstyl@%
    \ifF@ll\end{small}\fi%
    \ifSh@rt\end{footnotesize}\fi%
    \ifC@nf\end{footnotesize}\fi%
  \fi%
  \ifEstyl@%
    \ifF@ll\end{small}\fi%
    \ifSh@rt\end{footnotesize}\fi%
    \ifC@nf\end{footnotesize}\fi%
  \fi%
  \ifOstyl@%
    \ifF@ll\end{small}\fi%
    \ifSh@rt\end{footnotesize}\fi%
  \fi%
  \ifPstyl@%
    \end{small}
  \fi%
  \ifSstyl@%
    \end{small}
  \fi%
  \ifVstyl@%
    \end{small}
  \fi%
  \ifXstyl@%
    \ifF@ll\end{small}\fi%
    \ifSh@rt\end{footnotesize}\fi%
  \fi%
}

% An environment for typesetting author, subject and formula indexes
\newif\ifraggedstyle\raggedstylefalse
\ifIstyl@\else                                   % NOT for IT style
\renewenvironment{index}[1][A]{
  \gdef\b@r{}
  \thispagestyle{nofootings}%                    % no r/head on title page
  \gdef\AUTITLE{INDEX}%
  \strcmp{#1}{A}\ifstringsequal\gdef\AUTITLE{AUTHOR INDEX}\fi%
  \strcmp{#1}{F}\ifstringsequal\gdef\AUTITLE{FORMULA INDEX}\fi%
  \strcmp{#1}{I}\ifstringsequal\gdef\AUTITLE{INORGANIC FORMULA INDEX}\fi%
  \strcmp{#1}{O}\ifstringsequal\gdef\AUTITLE{ORGANIC FORMULA INDEX}\fi%
  \strcmp{#1}{S}\ifstringsequal\gdef\AUTITLE{SUBJECT INDEX}%
    \global\raggedstyletrue\fi%
  \gdef\STITLE{\AUTITLE}%
  \parfillskip0pt%
  \parindent0pt%
  \hangafter=1\hangindent=1em%
  \strcmp{#1}{A}\ifstringsequal\gdef\ITITLE{Author Index}\fi%
  \strcmp{#1}{F}\ifstringsequal\gdef\ITITLE{Formula Index}\fi%
  \strcmp{#1}{I}\ifstringsequal\gdef\ITITLE{Inorganic Formula Index}\fi%
  \strcmp{#1}{O}\ifstringsequal\gdef\ITITLE{Organic Formula Index}\fi%
  \strcmp{#1}{S}\ifstringsequal\gdef\ITITLE{Subject Index}\fi%
  \ \vskip 0.5cm%                                % fix for headsep problem
  \begin{centering}%
    {\large\bf \ITITLE\ to Volume \j@urnalcode\v@lume~(\j@urnalyear)}\par%
  \end{centering}%
  \vskip 1.1cm%                                  % distance from title to text
  \setlength{\columnsep}{18pt}%
  \strcmp{#1}{F}\ifstringsequal%
    \begin{multicols}{3}\singl@colfalse%
  \fi%
  \strcmp{#1}{I}\ifstringsequal%
    \begin{multicols}{3}\singl@colfalse%
  \fi%
  \strcmp{#1}{O}\ifstringsequal%
    \begin{multicols}{3}\singl@colfalse%
  \fi%
  \strcmp{#1}{A}\ifstringsequal%
    \begin{multicols}{2}\singl@colfalse%
  \fi%
  \strcmp{#1}{S}\ifstringsequal%
    \begin{multicols}{2}\singl@colfalse%
  \fi%
  \fontsize{9}{10pt}\usefont{OT1}{ptm}{m}{n}%
}
{
\par
\ifPstyl@\else\end{multicols}\fi
}
\fi

\global\newbox\keyb@x
\newenvironment{keyindicators}%                  % KEYINDICATORS
{%                                               % Begin new environment
  \global\setbox\keyb@x\vbox\bgroup              % store in \box\keyb@x
  \hbox to 0pt\bgroup
    \noindent\begin{minipage}{50mm}%             % constrain width
    \bigskip%                                    % extra space above
    \sffamily\begin{scriptsize}%                 % small typeface
    \baselineskip10pt%
    \textbf{Key indicators}%                     % Heading
}
{%                                               % End environment
    \medskip%
    \par\noindent\raggedright%
    For details of how these key indicators were
    automatically derived from the article, see
    http://journals.iucr.org/e.\par%
    \end{scriptsize}%
    \end{minipage}%
  \egroup
\egroup
}

%
% ====================== new floats ==========================================
%
\newfloat{inset}{b}{nst}                         % inset text; used in \vita

%
% ====================== new commands ========================================
%

% Three commands for manual placement of single-column footnotes in a
% two-column environment.
%
% \footnotes just sets the footnote area rule
\newcommand{\footnotes}{%
  %\vskip 12pt plus 4pt minus 4pt
  %\vskip 18pt plus5pt minus5pt%
  \vskip\skip\footins%
  \footnoterule%
  \vskip 0pt plus6pt minus 0pt
}
% placement of the footnote mark (with optional argument to allow override)
\newcommand{\fnmark}[1][\relax]{%
  \if\relax#1\footnotemark%
\else
  \setcounter{footnote}{#1}\addtocounter{footnote}{-1}\footnotemark%
\fi
}
% placement of footnote text; the marker must be given (in square brackets)
\newcommand{\fntext}[2][\relax]{
\def\@currentlabel{#1}%
\if\relax#1%
  \noindent\hskip-\leftskip\parbox{\colwidth}{%
  \fontsize{8}{10pt}\usefont{OT1}{ptm}{m}{n}%
  #2}%
  \par
\else%
\noindent\hskip-\leftskip\parbox[b]{\colwidth}{%
  \fontsize{8}{10pt}\usefont{OT1}{ptm}{m}{n}%
  \noindent\makebox[6pt][l]{{}${}^{\mathbf{#1}}$} #2}%
  \par
\fi
}

\renewcommand{\@makefntext}[1]{%
\iffn@ffset%             % Print footnotes with an offset, e.g. on first page
  \gdef\footnoterule{%
    \hbox{\hskip56mm\rule{30mm}{0.4pt}\vspace*{3pt}}}% % Footnote rule offset
  \hskip56mm\makebox[6pt][l]{\@makefnmark}#1%
\else%
  \noindent\makebox[6pt][l]{\@makefnmark}#1%     % set footnotes flush left
\fi%
}

% A utility macro to break a paragraph and justify the cut line
\newcommand{\breakpar}{%
  \parfillskip0pt%
  \par
  \parfillskip=0pt plus2fil%
}

%%%%%%%%%%%%%%%%%%%%% MAY NOT BE NEEDED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%v
% \let\thef@@tnote\thefootnote
% \renewcommand{\thefootnote}{%                    % symbolic footnotemarkers
%   \ifYstyl@%                                     % in conf. abstracts style
%     \fnsymbol{footnote}
%   \else%
%     \thef@@tnote
%   \fi
% }
%%%%%%%%%%%%%%%%%%%%% MAY NOT BE NEEDED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^
\renewcommand{\thempfootnote}{%                  % symbolic footnotemarkers
  \fnsymbol{mpfootnote}}                         %  in minipage
\renewcommand{\@makefnmark}{%                    % symbolic footnotemarkers
  \mbox{$^{\mathbf\@thefnmark}$}}                %  in minipage

% A bunch of administrative macros referring to the type of paper and the
%  journal to which submitted. The main use of these is to pass the
%  bibliographic information into a derived SGML file or database
\def\j@urnalcode{\relax}                         % Some defaults in case the
\def\j@urnaltitle{\relax}                        %  relevant items are not
\def\j@urnalfullname{\relax}                     %  declared in the source
\def\j@urnalyear{0000}                           %  file
\def\v@lume{00}                                  %
\def\issn{\relax}

\newcommand{\v@nish}[1]{}                        % useful vanishing macro
\newcommand{\paperref}[1]{%
\gdef\cn@r{\uppercase{#1}}%
}                                                % store coed no.
\newcommand{\paperprodcode}[1]{}                 % vanish prod. no.
\newcommand{\papertype}[1]{%                     % category of paper
\gdef\RHEAD{#1}                                  % default case
\gdef\p@geprefix{\relax}                         % default case
\strcmp{#1}{FA}\ifstringsequal\gdef\RHEAD{research papers}\fi%
\strcmp{#1}{SC}\ifstringsequal\gdef\RHEAD{short communications}\fi%

\strcmp{#1}{AA}\ifstringsequal\gdef\RHEAD{abstracts}\fi%
\strcmp{#1}{AD}\ifstringsequal\gdef\RHEAD{addenda and errata}\fi%
\strcmp{#1}{AI}\ifstringsequal\gdef\RHEAD{inorganic compounds}\fi%
\strcmp{#1}{AM}\ifstringsequal\gdef\RHEAD{metal-organic compounds}\fi%
\strcmp{#1}{AO}\ifstringsequal\gdef\RHEAD{organic compounds}\fi%
\strcmp{#1}{BC}\ifstringsequal\gdef\RHEAD{books received}\fi%
\strcmp{#1}{BL}\ifstringsequal\gdef\RHEAD{beamlines}\fi%
\strcmp{#1}{BR}\ifstringsequal\gdef\RHEAD{book reviews}\fi%
\strcmp{#1}{BI}\ifstringsequal\gdef\RHEAD{biography}\fi%
\strcmp{#1}{CA}\ifstringsequal\gdef\RHEAD{cif applications}\fi%
\strcmp{#1}{CD}\ifstringsequal\gdef\RHEAD{crystal data}\fi%
\strcmp{#1}{CE}\ifstringsequal\gdef\RHEAD{current events}\fi%
\strcmp{#1}{CI}\ifstringsequal\gdef\RHEAD{inorganic compounds}\fi%
\strcmp{#1}{CL}\ifstringsequal\gdef\RHEAD{calendar of events}\fi%
\strcmp{#1}{CM}\ifstringsequal\gdef\RHEAD{metal-organic compounds}\fi%
\strcmp{#1}{CN}\ifstringsequal\gdef\RHEAD{cryocrystallography papers}\fi%
\strcmp{#1}{CO}\ifstringsequal\gdef\RHEAD{organic compounds}\fi%
%\strcmp{#1}{CP}\ifstringsequal\gdef\RHEAD{conference papers}\fi%
\strcmp{#1}{CP}\ifstringsequal\gdef\RHEAD{computer programs}\fi%
\strcmp{#1}{CR}\ifstringsequal\gdef\RHEAD{crystallographers}\fi%
\strcmp{#1}{CS}\ifstringsequal\gdef\RHEAD{scientific comment}\fi%
\strcmp{#1}{ED}\ifstringsequal\gdef\RHEAD{editorial}\fi%
\strcmp{#1}{EI}\ifstringsequal\gdef\RHEAD{inorganic compounds}%
  \gdef\p@geprefix{i}\fi%
\strcmp{#1}{EM}\ifstringsequal\gdef\RHEAD{metal-organic compounds}%
  \gdef\p@geprefix{m}\fi%
\strcmp{#1}{EO}\ifstringsequal\gdef\RHEAD{organic compounds}%
  \gdef\p@geprefix{o}\fi%
\strcmp{#1}{FC}\ifstringsequal\gdef\RHEAD{fast communications}\fi%
\strcmp{#1}{FE}\ifstringsequal\gdef\RHEAD{feature articles}\fi%
\strcmp{#1}{FI}\ifstringsequal\gdef\RHEAD{inorganic compounds}%
  \gdef\p@geprefix{i}\fi%
\strcmp{#1}{FM}\ifstringsequal\gdef\RHEAD{metal-organic compounds}%
  \gdef\p@geprefix{m}\fi%
\strcmp{#1}{FO}\ifstringsequal\gdef\RHEAD{organic compounds}%
  \gdef\p@geprefix{o}\fi%
\strcmp{#1}{IF}\ifstringsequal\gdef\RHEAD{issue foreword}\fi%
\strcmp{#1}{ST}\ifstringsequal\gdef\RHEAD{structural communications}\fi%
\strcmp{#1}{GC}\ifstringsequal\gdef\RHEAD{structural genomics communications}\fi%
\strcmp{#1}{IP}\ifstringsequal\gdef\RHEAD{issue preface}\fi%
\strcmp{#1}{IU}\ifstringsequal\gdef\RHEAD{international union of crystallography}\fi%
\strcmp{#1}{LA}\ifstringsequal\gdef\RHEAD{lead article}\fi%
\strcmp{#1}{LC}\ifstringsequal\gdef\RHEAD{laboratory communications}\fi%
\strcmp{#1}{LE}\ifstringsequal\gdef\RHEAD{letters to the editor}\fi%
\strcmp{#1}{LN}\ifstringsequal\gdef\RHEAD{laboratory notes}\fi%
\strcmp{#1}{ME}\ifstringsequal\gdef\RHEAD{forthcoming meetings and short courses}\fi%
\strcmp{#1}{MR}\ifstringsequal\gdef\RHEAD{meeting reports}\fi%
\strcmp{#1}{NC}\ifstringsequal\gdef\RHEAD{nucleic acid structure communications}\fi%
\strcmp{#1}{NN}\ifstringsequal\gdef\RHEAD{notes and news}\fi%
\strcmp{#1}{NP}\ifstringsequal\gdef\RHEAD{new commercial products}\fi%
\strcmp{#1}{OB}\ifstringsequal\gdef\RHEAD{obituaries}\fi%
\strcmp{#1}{PA}\ifstringsequal\gdef\RHEAD{computer program abstracts}\fi%
\strcmp{#1}{PC}\ifstringsequal\gdef\RHEAD{protein structure communications}\fi%
\strcmp{#1}{QI}\ifstringsequal\gdef\RHEAD{inorganic compounds}%
  \gdef\p@geprefix{i}\fi%
\strcmp{#1}{QM}\ifstringsequal\gdef\RHEAD{metal-organic compounds}%
  \gdef\p@geprefix{m}\fi%
\strcmp{#1}{QO}\ifstringsequal\gdef\RHEAD{organic compounds}%
  \gdef\p@geprefix{o}\fi%
\strcmp{#1}{RI}\ifstringsequal\gdef\RHEAD{reference information}\fi%
\strcmp{#1}{RL}\ifstringsequal\gdef\RHEAD{research letters}\fi%
\strcmp{#1}{RP}\ifstringsequal\gdef\RHEAD{research perspectives}\fi%
\strcmp{#1}{SG}\ifstringsequal\gdef\RHEAD{structural genomics papers}\fi%
\strcmp{#1}{SH}\ifstringsequal\gdef\RHEAD{short reviews}\fi%
\strcmp{#1}{SI}\ifstringsequal\gdef\RHEAD{short format inorganic compounds}\fi%
\strcmp{#1}{SM}\ifstringsequal\gdef\RHEAD{short format metal-organic compounds}\fi%
\strcmp{#1}{SO}\ifstringsequal\gdef\RHEAD{short format organic compounds}\fi%
\strcmp{#1}{SP}\ifstringsequal\gdef\RHEAD{short structural papers}\fi%
\strcmp{#1}{SR}\ifstringsequal\gdef\RHEAD{software reviews}\fi%
\strcmp{#1}{SS}\ifstringsequal\gdef\RHEAD{scientific commentaries}\fi%
\strcmp{#1}{TE}\ifstringsequal\gdef\RHEAD{teaching and education in crystallography}\fi%
\strcmp{#1}{TR}\ifstringsequal\gdef\RHEAD{topical review}\fi%
\strcmp{#1}{XC}\ifstringsequal\gdef\RHEAD{crystallization communications}\fi%
\strcmp{#1}{XL}\ifstringsequal\gdef\RHEAD{crystallization papers}\fi%
\ifC@nf\gdef\RHEAD{conference papers}\fi         % proceedings overrides type
}
\newcommand{\paperlang}[1]{}                     % vanish language
  \gdef\@A@{A}%
  \gdef\@B@{B}%
  \gdef\@C@{C}%
  \gdef\@D@{D}%
  \gdef\@E@{E}%
  \gdef\@F@{F}%
  \gdef\@J@{J}%
  \gdef\@M@{M}%
  \gdef\@S@{S}%
\gdef\j@urnalname{\relax}                        % default (null) case
\gdef\j@urnalcode{\relax}                        % default (null) case
\newbox\c@tchline                                % Article catchline
\newcommand{\journalcode}[1]{%                   % Assign journal details
  \gdef\j@urnalcode{#1}
  \if\j@urnalcode\@A@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section A}
     \gdef\j@urnaltitle{Foundations of\hfill\break Crystallography}
     \gdef\issn{0108-7673}
     \global\setbox\c@tchline=\hbox{\normalfont\rmfamily\itshape%
       \noindent\j@urnalname}
  }\fi
  \if\j@urnalcode\@B@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section B}
     \gdef\j@urnaltitle{Structural Science,\hfill\break Crystal
       Engineering\hfill\break and Materials}
     \gdef\issn{0108-7681}
     \global\setbox\c@tchline=\hbox{\normalfont\rmfamily\itshape%
       \noindent\j@urnalname}
  }\fi
  \if\j@urnalcode\@C@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section C}
     \gdef\j@urnaltitle{Crystal Structure\hfill\break Communications}
     \gdef\issn{0108-2701}
     \global\setbox\c@tchline=\hbox{\normalfont\fontsize{8}{12}\sffamily\itshape%
       \noindent\j@urnalname}
  }\fi
  \if\j@urnalcode\@D@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section D}
     \gdef\j@urnaltitle{Biological\hfill\break Crystallography}
     \gdef\issn{0907-4449}
  }\fi
  \if\j@urnalcode\@E@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section E}
     \gdef\j@urnaltitle{Structure\hfill\break Reports %
       \ifC@l@r{\Red{Online}}\else{Online}\fi%
       }
     \gdef\issn{1600-5368}
  }\fi
  \if\j@urnalcode\@F@{%
     \gdef\j@urnalname{Acta Cryst.}
     \gdef\j@urnalfullname{Acta Crystallographica Section F}
     \gdef\j@urnaltitle{Structural Biology\hfill\break and Crystallization\hfill\break Communications}
     \gdef\issn{0000-0009}
  }\fi
  \if\j@urnalcode\@J@{%
     \gdef\j@urnalname{J. Appl. Cryst.}
     \gdef\j@urnalfullname{Journal of Applied Crystallography}
     \gdef\j@urnaltitle{}
     \gdef\issn{0021-8898}
     \global\setbox\c@tchline=\hbox{\normalfont\rmfamily\itshape%
       \noindent\j@urnalname}
  }\fi
  \if\j@urnalcode\@M@{%
     \gdef\j@urnalname{IUCrJ}
     \gdef\j@urnalfullname{IUCrJ}
     \gdef\j@urnaltitle{}
     \gdef\issn{2052-2525}
     \global\setbox\c@tchline=\hbox{\normalfont\rmfamily\itshape%
       \noindent\j@urnalname}
  }\fi
  \if\j@urnalcode\@S@{%
     \gdef\j@urnalname{J. Synchrotron Rad.}
     \gdef\j@urnalfullname{Journal of Synchrotron Radiation}
     \gdef\j@urnaltitle{}
     \gdef\issn{0909-0495}
     \ifXstyl@%
     \global\setbox\c@tchline=\hbox{\normalfont\sffamily\itshape%
       \noindent\j@urnalname}
     \else%
       \ifSstyl@%
         \global\setbox\c@tchline=\hbox{\fontsize{7}{11pt}\sffamily\itshape%
           \noindent\j@urnalname}
       \else%
         \global\setbox\c@tchline=\hbox{\rmfamily\itshape%
           \noindent\j@urnalname}
       \fi%
     \fi%
  }\fi
}

\newcommand{\journalyr}[1]{%                     % year of publication
  \gdef\j@urnalyear{#1}
  \ifAstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifCstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifDstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifEstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifSstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifOstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \rmfamily(#1). }%
  \fi%
  \ifPstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \rmfamily(#1). }%
  \fi%
  \ifVstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily(#1). }%
  \fi%
  \ifXstyl@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \sffamily(#1). }%
  \fi%
}

\newcommand{\journaliss}[1]{}                    % vanish issue

\newcommand{\journalvol}[1]{%                    % volume number
  \gdef\v@lume{#1}
  \ifAstyl@%                                     % no-op
  \fi%
  \ifCstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{8}{12pt}\sffamily%
      \j@urnalcode\bfseries{#1}, }
  \fi%
  \ifDstyl@%                                     % no-op
  \fi%
  \ifEstyl@%                                     % no-op
  \fi%
  \ifSstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily%
      \bfseries{#1}, }
  \fi%
  \ifOstyl@%
    \if\j@urnalcode\@J@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\normalfont\bfseries\ #1, }%
    \else
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\normalfont\rmfamily\ \j@urnalcode%
        \textbf{#1}, }%
    \fi
  \fi%
  \ifPstyl@%
    \if\j@urnalcode\@J@%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \textbf{#1}, }%
    \else%
      \if\j@urnalcode\@S@%
        \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \textbf{#1}, }%
      \else%
      \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \j@urnalcode%
        \textbf{#1}, }%                          % include Acta section
      \fi
    \fi
  \fi%
  \ifVstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \fontsize{7}{11pt}\sffamily%
      \bfseries{#1}, }
  \fi%
  \ifXstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ \sffamily%
      \bfseries{#1}, }
  \fi%
}

\def\f@rstpage{000}
\def\l@stpage{000}
\newcommand{\journalfirstpage}[1]{%              % first page number
  \def\f@rstpage{#1}%
  \ifx\f@rstpage\l@stpage
    \setcounter{page}{1}%
    \def\f@rstpage{ 000}%
  \else%
    \setcounter{page}{\f@rstpage}%
    \gdef\f@rstpage{\p@geprefix#1}%
  \fi
}

\newcommand{\journallastpage}[1]{%               % last page number
  \def\l@stpage{#1}%
  \ifx\f@rstpage\l@stpage%
    \def\l@stpage{}%
  \else%
    \def\l@stpage{--\p@geprefix#1}%
  \fi
  \ifAstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifCstyl@%
    \global\setbox\c@tchline=\hbox{\unhcopy\c@tchline%
    \fontsize{8}{12}\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifDstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifEstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifSstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\fontsize{7}{11pt}\sffamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifOstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifPstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\rmfamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifVstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\fontsize{7}{11pt}\sffamily\ \f@rstpage\l@stpage}%
  \fi%
  \ifXstyl@%
    \global\setbox\c@tchline=%
      \hbox{\unhcopy\c@tchline\ {\sffamily%
      \f@rstpage\l@stpage}}%
  \fi%
}

% Sometimes (e.g. camera-ready conference papers) we don't want to print
%  the received/accepted line; can suppress printing by supplying a value
%  of \relax. But we need to test \if\relax\scr@tch and not (as in versions
%  prior to 1999-04-01) \if\scr@tch\relax, because the second version
%  expands the first tokens of the argument and falls over for dates such
%  as 11, 22 (bug reported by Klas Andersson, klasa@struc.su.se)
\newcommand{\journalreceived}[1]{%               % received date
  \gdef\scr@tch{#1}%
  \ifAstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifCstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifDstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifEstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifSstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifOstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{\rmfamily\itshape\small{(Received #1; }}%
    \fi%
  \fi%
  \ifPstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{\rmfamily\itshape\small{(Received #1; }}%
    \fi%
  \fi%
  \ifVstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\recd@te{#1}%
    \fi%
  \fi%
  \ifXstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{{\sffamily\itshape\small(Received  #1; }}%
    \fi%
  \fi%
}

\newcommand{\journalaccepted}[1]{%               % accepted date
  \gdef\scr@tch{#1}%
  \ifAstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifCstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifDstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifEstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifSstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifOstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{\unhcopy5 \rmfamily\itshape\small{accepted #1)}}%
    \fi%
  \fi%
  \ifPstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{\unhcopy5 \rmfamily\itshape\small{accepted #1)}}%
    \fi%
  \fi%
  \ifVstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\accd@te{#1}%
    \fi%
  \fi%
  \ifXstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \setbox5=\hbox{\unhcopy5{\sffamily\itshape\small accepted #1)}}%
    \fi%
  \fi%
}
\newcommand{\journalonline}[1]{%                 % received date
  \gdef\scr@tch{#1}%
  \ifAstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifCstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
      \printd@tesfalse%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifDstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifEstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifSstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifOstyl@%
  \fi%
  \ifPstyl@%
  \fi%
  \ifVstyl@%
    \if\relax\scr@tch%
      \setbox5=\null%
    \else%
      \def\onlined@te{#1}%
    \fi%
  \fi%
  \ifXstyl@%
  \fi%
}

\newcommand{\doi}[1]{%
\gdef\d@i{DOI: #1}%
}

\@onlypreamble{\paperprodcode}%                  % Only in preamble
\@onlypreamble{\paperref}%                       % Only in preamble
\@onlypreamble{\papertype}%                      % Only in preamble
\@onlypreamble{\paperlang}%                      % Only in preamble
\@onlypreamble{\journalcode}%                    % Only in preamble
\@onlypreamble{\journalyr}%                      % Only in preamble
\@onlypreamble{\journaliss}%                     % Only in preamble
\@onlypreamble{\journalvol}%                     % Only in preamble
\@onlypreamble{\journalfirstpage}%               % Only in preamble
\@onlypreamble{\journallastpage}%                % Only in preamble
\@onlypreamble{\journalreceived}%                % Only in preamble
\@onlypreamble{\journalaccepted}%                % Only in preamble
\@onlypreamble{\journalonline}%                  % Only in preamble
\@onlypreamble{\doi}%                            % Only in preamble

% To use, specify date in form \journalreceived{7 March 2012} etc.
\journalreceived{\relax}                 % default value
\journalaccepted{\relax}                 % default value
\journalonline{\relax}                   % default value

\def\SEP{\relax}%                                % keyword separator
\newcommand\keyword[1]{%
  \ifF@ll%
    \setbox7=\hbox{%
      \unhcopy7\SEP%                             % collect in \box7
      \ifXstyl@%
        \sffamily\normalsize\bfseries #1%
      \else
        \ifIstyl@%
          \rmfamily\normalsize\bfseries #1%
        \else
          \sffamily\fontsize{8}{11}\bfseries #1%
        \fi
      \fi
    }%
  \fi
  \ifSh@rt%
    \setbox7=\hbox{%
      \unhcopy7\SEP%                             % collect in \box7
      \ifXstyl@%
        \sffamily\small\bfseries #1%
      \else
        \sffamily\fontsize{8}{11}\bfseries #1%
      \fi
    }%
  \fi
  \ifC@nf%
    \setbox7=\hbox{%
      \unhcopy7\SEP%                             % collect in \box7
      \sffamily\fontsize{8}{11}\bfseries #1%
    }%
  \fi
  \ifYstyl@%
    \setbox7=\hbox{%
      \unhcopy7\SEP%                             % collect in \box7
      \rmfamily\fontsize{9}{11}\bfseries #1%
    }%
  \fi
  \def\SEP{; }
}

% Key indicators
\newcommand\KIstudy[2]{%
  \par\noindent#1 #2 study\par%
}
\newcommand\KIconditions[2]{%
  \par\noindent $T = $ #1~K\par%
  %$P = $ #2 study\par%                          % need to test and display P
}
\newcommand\KIgeom[2]{%
  \par\noindent Mean $\sigma$(#1) = #2 \AA\par%
}
\newcommand\KIRfactor[1]{%
  \par\noindent $R$ factor = #1\par%
}
\newcommand\KIwRfactor[1]{%
  \par\noindent $wR$ factor = #1\par%
}
\newcommand\KIdatapar[1]{%
  \par\noindent Data-to-parameter ratio = #1\par%
}

\renewcommand\maketitle{%                        % print author group
  \ifAstyl@%
    \newbox\@ccline
    \global\setbox\@ccline=\hbox to 0mm{\vtop{%
      \hsize=56mm
      \parindent=0pt\raggedright%
      \fontsize{7}{10pt}\sffamily%
      \ifprintd@tes
        Received \recd@te\hfill\break%           % received/accepted line
        Accepted \accd@te\hfill\break%           % received/accepted line
        Online \onlined@te\hfill\break%          % online line
      \fi
      }}
    \newbox\c@pyline
    \global\setbox\c@pyline=\hbox to 0mm{\vbox{%
      \hsize=56mm
      %\vfill%
      \fontsize{7}{10pt}\sffamily%
      \ifc@pyright%
        \hbox{\copyright\  \j@urnalyear\
        International Union of Crystallography%
        }\par%
      \fi%
      \if\j@urnalcode\@A@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@B@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@C@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@D@{\noindent Printed in Singaport -- all rights reserved}\fi%
      \if\j@urnalcode\@E@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@F@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@J@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \if\j@urnalcode\@J@{\noindent \relax}\fi%
      \if\j@urnalcode\@S@{\noindent Printed in Singapore -- all rights reserved}\fi%
      \par$\phantom{(}$%                         % hack to balance boxes
      }}
    \mkttltrue
  \fi
  \ifCstyl@%
    \begin{raggedright}%                         % raggedright
    \bigskip\unhbox0\unhbox2\par%                % empty au boxes
    \end{raggedright}%
    \begin{raggedright}%
    \bigskip\unhbox4\par\noindent\unhbox6\par%   % empty aff boxes
    \medskip\noindent%                           % received/accepted line
    \fontsize{7}{10}\sffamily%
    Received \recd@te\hfill\break%
    Accepted \accd@te\hfill\break%
    Online \accd@te\hfill\break%
    \bigskip%
    \end{raggedright}%
    % emit vita, author footnotes, title footnote (if present):
    \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
    \ifhbox\@ufn{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\@ufn}}\fi
    \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi  % emit title footnote
    \mkttltrue%
  \fi
  \ifDstyl@%
    \ifC@nf%
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
      \medskip%
      \bgroup%
      \raggedright\unhbox0\unhbox2\par%
      \medskip\noindent%
      \raggedright\unhbox4\unhbox6\par%          % empty aff boxes
      \egroup%
      % emit vita (if present):
      \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
      \mkttltrue%
    \fi
    \ifF@ll%
      \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi%  % Dump out titlefn
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
%   A spectacular hack! Here is a map of the page layout for a new-style
%     ------------   ------------------------    research paper or other
%    |   50 mm    | |       128 mm           |   full article. The top
%    |            | |                        |   part (logo + title) is
%    |  Logo      | |   Article title        |   built from boxes in the
%    |            | |                        |   \title macro. Then the
%     ------------   ------------------------    page switches to 2-column
%     ------------   ---------------   ------    using \begin{multicols}{2}.
%    |            | |      90 mm    | | 32mm |   because the rest of the paper
%    |  Author    | |               | |      |   is double-column format. So
%    |  names     | |     ABSTRACT  | | rec  |   we hack the layout of the
%    |            |6|               |6| acc  |   first page in this way: the
%    |  Addresses | |               | |      |   first column is built of a
%    |            | |     ARTICLE   | |      |   50mm wide hbox with the author
%    |  Footnotes | |      BODY     | |      |   information etc, AND an hbox
%    |            | |               | |      |   displaced 96 mm horizontally
%    |            | |               | |      |   that contains the dates. The
%    |            | |               | |      |   vertical extent of the first
%    |            | |               | |      |   box is the remainder of the
%    |            | |               | |      |   page, thus forcing the body
%    |            | |               | |      |   into the next column. But we
%    |            | |               | |      |   need to displace the second
%    |            | |               | |      |   column to the left. We set the
%    |            | |               | |      |   multicol parameter
%    |            | |               | |      |   \multicol@leftmargin to be
%    |            | |               | |      |   -40 mm; then hack the output
%    |            | |               | |      |   routine so that after the 1st
%    | copyright  | |               | |      |   page is output the value is
%     ------------   ---------------   ------    reset to 0 mm. This of course
%   would also set the leftmost column too far left, so we have to unpack it
%   with its own horizontal offset to compensate. Phew!
      \global\multicol@leftmargin=-40mm%
      \let\h@ckoutputpage\@outputpage
      \def\@outputpage{
        \h@ckoutputpage
        \global\multicol@leftmargin=0mm
           \global\fn@ffsetfalse%                % Don't offset footnotes
      }
      \hskip37mm\hbox to 56mm{%
        \vtop to \@colroom{%                     % \@colroom from multicol
          \hsize50mm
          \parindent=0pt\raggedright
          \unhbox0\unhbox2\par%                  % empty au boxes
          \smallskip\unhbox4\par%
          \bigskip\unhbox\@ufn\par%              % empty author footnote boxes
          \bigskip\unhbox6\par%                  % empty aff boxes
          \vfill
          \fontsize{7}{10pt}\sffamily%
          \ifc@pyright%
            \hbox{\copyright\  \j@urnalyear\
            International Union of Crystallography}\par
          \fi%
          \if\j@urnalcode\@A@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@B@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@C@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@D@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@E@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@F@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@J@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@M@{\relax}\fi
          \if\j@urnalcode\@S@{Printed in Singapore -- all rights reserved}\fi
        }%
%
        \hskip 96mm\hbox{%
          \vtop to \@colroom{%                   % \@colroom from multicol
            \hsize32mm
            \parindent=0pt\raggedright
            \fontsize{7}{10pt}\sffamily%
            Received \recd@te\hfill\break%       % received/accepted line
            Accepted \accd@te\hfill\break%       % received/accepted line
            Online \onlined@te\hfill\break%      % online line
            \ifhbox\@PDB\par\unhbox\@PDB\fi%     % PDB reference
            \ifhbox\@NDB\par\unhbox\@NDB\fi%     % NDB reference
            \vfill
          }
        }%
      }
      \mkttltrue%
      \let\footnote\f@@tn@te%                    % Done with special title fn
    \fi
    \ifSh@rt%
      \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi%  % Dump out titlefn
%   Short contributions are even more convoluted. Here is a map of the page
%     ------------   ------------------------    layout. Note that the two
%    |   50 mm    | |       128 mm           |   columns of the main text are
%    |            | |                        |   60 mm wide (instead of 56 mm
%    |  Logo      | |   Article title        |   of regular 3-column setting on
%    |            | |                        |   the other pages). It is very
%     ------------   ------------------------    difficult to achieve this
%     ------------   ---------------   ------    with LaTeX; here is what has
%    |            | |      90 mm    | | 32mm |   been done. The logo and title
%    |  Author    | |               | |      |   are set as for full papers.
%    |  names     | |     ABSTRACT  | | rec  |   The top part of the author bar
%    |            |6|               |6| acc  |   (including dates) is stored in
%    |  Addresses | |               | |      |   a zero-height, zero-width box
%    |            |  ---------------   ------    here. The abstract will be
%    |  Footnotes |  -----------   ----------    boxed via the abstract
%    |            | |           | |          |   environment. When the first
%    |            | |           |6|          |   section is encountered, the
%    |            | |           | |          |   author and abstract boxes are
%    |            | |  ARTICLE  | |          |   output (in a very convoluted
%    |            | |   BODY    | |          |   way that has to do with how
%    |            | |           | |          |   the multicol output routine
%    |            | |           | |          |   works). At the same time, the
%    |            | |           | |          |   3-col layout is invoked and
%    |            | |           | |          |   the copyright is forced to the
%    |            | |           | |          |   base of the first column (so
%    |            | |           | |          |   the text columns don't match
%    |            | |           | |          |   the desired 60 mm width).
%    | copyright  | |   60 mm   | |  60 mm   |
%     ------------   -----------   ----------
      \newbox\deferredt@tle
      \setbox\deferredt@tle%
        \hbox to 0mm{%
          \vtop to 0mm{%                         % zero height so that the
            \hsize50mm                           %  abstract box determines
            \parindent=0pt\raggedright           %  where the multicols begin
            \unhbox0\unhbox2\par%                % empty au boxes
            \smallskip\unhbox4\par%
            \bigskip\unhbox\@ufn\par%            % empty author footnote boxes
            \bigskip\unhbox6\par%                % empty aff boxes
          }
          \hskip 100mm\vtop to 0mm{%             % also zero height
            \hsize32mm
            \parindent=0pt\raggedright
            \fontsize{7}{10pt}\sffamily%
            Received \recd@te\hfill\break%       % received/accepted line
            Accepted \accd@te\hfill\break%       % received/accepted line
            Online \onlined@te\hfill\break%      % online line
            \ifhbox\@PDB\par\unhbox\@PDB\fi%     % PDB reference
            \ifhbox\@NDB\par\unhbox\@NDB\fi%     % NDB reference
            \vfill
          }%
        }
      \mkttltrue%
      \let\footnote\f@@tn@te%                    % Done with special title fn
    \fi%
  \fi%
  \ifEstyl@%
    \ifC@nf%
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
      \medskip%
      \bgroup%
      \raggedright\unhbox0\unhbox2\par%
      \medskip\noindent%
      \raggedright\unhbox4\unhbox6\par%          % empty aff boxes
      \egroup%
      \mkttltrue%
    \fi
    \ifF@ll%
      \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi%  % Dump out titlefn
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
%   A spectacular hack! Here is a map of the page layout for a new-style
%     ------------   ------------------------    research paper or other
%    |   50 mm    | |       128 mm           |   full article. The top
%    |            | |                        |   part (logo + title) is
%    |  Logo      | |   Article title        |   built from boxes in the
%    |            | |                        |   \title macro. Then the
%     ------------   ------------------------    page switches to 2-column
%     ------------   ---------------   ------    using \begin{multicols}{2}.
%    |            | |      90 mm    | | 32mm |   because the rest of the paper
%    |  Author    | |               | |      |   is double-column format. So
%    |  names     | |     ABSTRACT  | | rec  |   we hack the layout of the
%    |            |6|               |6| acc  |   first page in this way: the
%    |  Addresses | |               | |      |   first column is built of a
%    |            | |     ARTICLE   | |      |   50mm wide hbox with the author
%    |  Footnotes | |      BODY     | |      |   information etc, AND an hbox
%    |            | |               | |      |   displaced 96 mm horizontally
%    |            | |               | |      |   that contains the dates. The
%    |            | |               | |      |   vertical extent of the first
%    |            | |               | |      |   box is the remainder of the
%    |            | |               | |      |   page, thus forcing the body
%    |            | |               | |      |   into the next column. But we
%    |            | |               | |      |   need to displace the second
%    |            | |               | |      |   column to the left. We set the
%    |            | |               | |      |   multicol parameter
%    |            | |               | |      |   \multicol@leftmargin to be
%    |            | |               | |      |   -40 mm; then hack the output
%    |            | |               | |      |   routine so that after the 1st
%    | copyright  | |               | |      |   page is output the value is
%     ------------   ---------------   ------    reset to 0 mm. This of course
%   would also set the leftmost column too far left, so we have to unpack it
%   with its own horizontal offset to compensate. Phew!
      \global\multicol@leftmargin=-40mm%
      \let\h@ckoutputpage\@outputpage
      \def\@outputpage{
        \h@ckoutputpage
        \global\multicol@leftmargin=0mm
           \global\fn@ffsetfalse%                % Don't offset footnotes
      }
      \hskip37mm\hbox to 56mm{%
        \vtop to \@colroom{%                     % \@colroom from multicol
          \hsize50mm
          \parindent=0pt\raggedright
          \unhbox0\unhbox2\par%                  % empty au boxes
          \smallskip\unhbox4\par%
          \bigskip\unhbox\@ufn\par%              % empty author footnote boxes
          \bigskip\unhbox6\par%                  % empty aff boxes
          \bigskip\noindent\unvbox\keyb@x\par%   % empty keyindicators box
          \vfill
          \fontsize{7}{10pt}\sffamily%
          \ifc@pyright%
            \hbox{\copyright\  \j@urnalyear\
            International Union of Crystallography}\par
          \fi%
          \if\j@urnalcode\@A@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@B@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@C@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@D@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@E@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@F@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@J@{Printed in Singapore -- all rights reserved}\fi
          \if\j@urnalcode\@M@{\relax}\fi
          \if\j@urnalcode\@S@{Printed in Singapore -- all rights reserved}\fi
        }%
%
        \hskip 96mm\hbox{%
          \vtop to \@colroom{%                   % \@colroom from multicol
            \hsize32mm
            \parindent=0pt\raggedright
            \fontsize{7}{10pt}\sffamily%
            Received \recd@te\hfill\break%       % received/accepted line
            Accepted \accd@te\hfill\break%       % received/accepted line
            Online \onlined@te\hfill\break%      % online line
            \ifhbox\@PDB\par\unhbox\@PDB\fi%     % PDB reference
            \ifhbox\@NDB\par\unhbox\@NDB\fi%     % NDB reference
            \vfill
          }
        }%
      }
      \mkttltrue%
      \let\footnote\f@@tn@te%                    % Done with special title fn
    \fi
    \ifSh@rt%
      \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi%  % Dump out titlefn
%   Short contributions are even more convoluted. Here is a map of the page
%     ------------   ------------------------    layout. Note that the two
%    |   50 mm    | |       128 mm           |   columns of the main text are
%    |            | |                        |   60 mm wide (instead of 56 mm
%    |  Logo      | |   Article title        |   of regular 3-column setting on
%    |            | |                        |   the other pages). It is very
%     ------------   ------------------------    difficult to achieve this
%     ------------   ---------------   ------    with LaTeX; here is what has
%    |            | |      90 mm    | | 32mm |   been done. The logo and title
%    |  Author    | |               | |      |   are set as for full papers.
%    |  names     | |     ABSTRACT  | | rec  |   The top part of the author bar
%    |            |6|               |6| acc  |   (including dates) is stored in
%    |  Addresses | |               | |      |   a zero-height, zero-width box
%    |            |  ---------------   ------    here. The abstract will be
%    |  Footnotes |  -----------   ----------    boxed via the abstract
%    |            | |           | |          |   environment. When the first
%    |            | |           |6|          |   section is encountered, the
%    |            | |           | |          |   author and abstract boxes are
%    |            | |  ARTICLE  | |          |   output (in a very convoluted
%    |            | |   BODY    | |          |   way that has to do with how
%    |            | |           | |          |   the multicol output routine
%    |            | |           | |          |   works). At the same time, the
%    |            | |           | |          |   3-col layout is invoked and
%    |            | |           | |          |   the copyright is forced to the
%    |            | |           | |          |   base of the first column (so
%    |            | |           | |          |   the text columns don't match
%    |            | |           | |          |   the desired 60 mm width).
%    | copyright  | |   60 mm   | |  60 mm   |
%     ------------   -----------   ----------
      \newbox\deferredt@tle
      \setbox\deferredt@tle%
        \hbox to 0mm{%
          \vtop to 0mm{%                         % zero height so that the
            \hsize50mm                           %  abstract box determines
            \parindent=0pt\raggedright           %  where the multicols begin
            \unhbox0\unhbox2\par%                % empty au boxes
            \smallskip\unhbox4\par%
            \bigskip\unhbox\@ufn\par%            % empty author footnote boxes
            \bigskip\unhbox6\par%                % empty aff boxes
          \bigskip\noindent\unvbox\keyb@x\par%   % empty keyindicators box
          }
          \hskip 100mm\vtop to 0mm{%             % also zero height
            \hsize32mm
            \parindent=0pt\raggedright
            \fontsize{7}{10pt}\sffamily%
            Received \recd@te\hfill\break%       % received/accepted line
            Accepted \accd@te\hfill\break%       % received/accepted line
            Online \onlined@te\hfill\break%      % online line
            \ifhbox\@PDB\par\unhbox\@PDB\fi%     % PDB reference
            \ifhbox\@NDB\par\unhbox\@NDB\fi%     % NDB reference
            \vfill
          }%
        }
      \mkttltrue%
      \let\footnote\f@@tn@te%                    % Done with special title fn
    \fi%
  \fi%
  \ifIstyl@%
    \begin{center}%                              % centre on page
    \unhbox0\unhbox2\par%                        % empty au boxes
    \end{center}%
    \vskip12pt%
    \mkttltrue%
  \fi%
  \ifSstyl@%
    \begin{raggedright}%                         % raggedright
    \bigskip\unhbox0\unhbox2\par%                % empty au boxes
    \end{raggedright}%
    \begin{raggedright}%
    \bigskip\unhbox4\unhbox6\par%                % empty aff boxes
    \smallskip\unhbox5%                          % received/accepted line
    \end{raggedright}%
    % emit vita (if present):
    \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
    \ifhbox\@ufn{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\@ufn}}\fi
    \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi
    \mkttltrue%
  \fi
  \ifOstyl@%
    \ifF@ll%
      \begin{center}%                            % centre on page
      \unhbox0\unhbox2\par%                      % empty au boxes
      \end{center}%
      \begin{center}%
      \smallskip\unhbox4\unhbox6\par%            % empty aff boxes
      \smallskip\unhbox5%                        % received/accepted line
      \end{center}%
      \mkttltrue%
    \fi
    \ifSh@rt%
      \medskip%
      \noindent\unhbox0\unhbox2%
      {\small\textit{ at }}%                     % empty au boxes
      \unhbox4\unhbox6\par%                      % empty aff boxes
      \smallskip\noindent\unhbox5%               % received/accepted line
      \mkttltrue%
    \fi
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
  \fi%
  \ifPstyl@%
     \ifsingl@col\begin{multicols}{2}\end{multicols}\fi
    \begin{center}%                              % centre on page
    \unhbox0\unhbox2\par%                        % empty au boxes
    \end{center}%
    \begin{center}%
    \smallskip\unhbox4\unhbox6\par%              % empty aff boxes
    \smallskip\unhbox5%                          % received/accepted line
    \ifhbox7\smallskip\par\unhbox7\fi%           % Keywords
    \ifhbox\@PDB\smallskip\par\unhbox\@PDB\fi%   % PDB reference codes
    \ifhbox\@NDB\smallskip\par\unhbox\@NDB\fi%   % NDB reference codes
    \ifhbox\keyb@x\smallskip\par\unhbox\keyb@x\fi%% key indicators
    \end{center}%
    \mkttltrue%
  \fi%
  \ifVstyl@%
    \begin{raggedright}%                         % raggedright
    \bigskip\unhbox0\unhbox2\par%                % empty au boxes
    \end{raggedright}%
    \begin{raggedright}%
    \bigskip\unhbox4\par\noindent\unhbox6\par%   % empty aff boxes
    \medskip\noindent%                           % received/accepted line
    \end{raggedright}%
    % emit vita, author footnotes, title footnote (if present):
    \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
    \ifhbox\@ufn{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\@ufn}}\fi
    \ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi
    \mkttltrue%
  \fi
  \ifXstyl@%
    \begin{meenypage}%                           % author block
    \raggedright\unhbox0\unhbox2\par%            % empty au boxes
    \medskip\noindent%
    \raggedright\unhbox4\unhbox6%                % empty aff boxes
    \ifhbox5\par\smallskip\unhbox5\fi%           % received/accepted line
    \end{meenypage}%
    \ifSh@rt%
      % emit vita (if present):
      \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
    \fi
    \mkttltrue%
  \fi%
  \ifYstyl@%
    %%%%\begin{raggedright}%                         % raggedright
    \noindent\unhbox\t@tle\unhbox0\unhbox2,%         % empty title, au boxes
    \unhbox4\unhbox6%                            % empty aff boxes
    \noindent%                               % received/accepted line
    %%%%\end{raggedright}%
    % emit vita, author footnotes, title footnote (if present):
    \ifhbox\vit@{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\vit@}}\fi
    \ifhbox\@ufn{\renewcommand{\@makefntext}{}\footnotetext{\unhbox\@ufn}}\fi
    %\ifhbox\t@tlebox\footnotetext{\unhbox\t@tlebox}\fi
    \mkttltrue%
  \fi
}

\@onlypreamble{\parttitle}
\newcommand{\parttitle}[1]{%                     % part title (IT)
  \ifIstyl@%
    \gdef\PARTTITLE{{\uppercase{#1}}}%           % for running heads
  \fi%
}

\newcommand{\shorttitle}[1]{%                    % short title
  \ifAstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifCstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifDstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifEstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifIstyl@%
    \gdef\STITLE{{\uppercase{#1}}}%              % for running heads
  \fi%
  \ifSstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifOstyl@%
    \ifF@ll\gdef\STITLE{\uppercase{#1}}\fi%      % for running heads
    \ifSh@rt%
      \gdef\STITLE{SHORT COMMUNICATIONS}%        % for running heads
    \fi%
  \fi%
  \ifPstyl@%
    \gdef\STITLE{#1}%                            % for running heads
  \fi%
  \ifVstyl@%
    \gdef\STITLE{\relax}%                        % for running heads
  \fi%
  \ifXstyl@%
    \gdef\STITLE{\uppercase{#1}}%                % for running heads
  \fi%
}

\newcommand{\shortauthor}[1]{%                   % short author group
  \ifAstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
  \ifCstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
  \ifDstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
  \ifEstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
  \ifIstyl@%
    \gdef\AUTITLE{\uppercase{#1}}%               % for running heads
                                                 % (not used in IT)
  \fi%
  \ifSstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
  \ifOstyl@%
    \ifF@ll\gdef\AUTITLE{\uppercase{#1}}\fi%     % for running heads
    \ifSh@rt%
      \gdef\AUTITLE{SHORT COMMUNICATIONS}%       % for running heads
    \fi%
  \fi%
  \ifPstyl@%
    \gdef\AUTITLE{\uppercase{#1}}%               % for running heads
  \fi%
  \ifVstyl@%
    \gdef\AUTITLE{\relax}%                       % for running heads
  \fi%
  \ifXstyl@%
    \gdef\AUTITLE{#1}%                           % for running heads
  \fi%
}

% The authors' affiliations are handled in a similar manner to the author
%  names (see \author below); but only a single global box register is
%  needed because superscripts precede the addresses without interfering
%  with punctuation

\def\ET{\relax}                                  % separator
\def\ETC{\relax}                                 % separator

\newcommand{\aff}[2][\relax]{%                   % Affiliation
  \global\setbox4=\hbox{%
    \unhcopy3%                                   % Final string
    \ifAstyl@%
      {\fontsize{7}{10pt}\sffamily%
      {\ETC$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifCstyl@%
      {\fontsize{7}{10pt}\sffamily%
      {\ETC$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifDstyl@%
      \ifC@nf%
        {\fontsize{7}{10pt}\sffamily\itshape{\ET$^{#1}$#2}}%
      \else
        {\fontsize{7}{10pt}\sffamily%
        {\ETC$^\mathsfrm{#1}$#2}}%
      \fi
    \fi%
    \ifEstyl@%
      \ifC@nf%
        {\fontsize{7}{10pt}\sffamily\itshape{\ET$^{#1}$#2}}%
      \else
        {\fontsize{7}{10pt}\sffamily%
        {\ETC$^\mathsfrm{#1}$#2}}%
      \fi
    \fi%
    \ifSstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ETC$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifOstyl@%
      {\textit{\ETC$^{#1}$#2}}%
    \fi%
    \ifPstyl@%
      {\textit{\ETC$^{#1}$#2}}%
    \fi%
    \ifVstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ETC$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifXstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ETC$^\mathsfit{#1}$#2}}%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily\itshape%
      {\ETC$^{#1}$#2}}%
    \fi%
  }%
  \setbox3=\hbox{%
    \unhcopy3%                                   % Add to accumulator register
    \ifAstyl@%
      {\fontsize{7}{10pt}\sffamily%
      {\ET$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifCstyl@%
      {\fontsize{7}{10pt}\sffamily%
      {\ET$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifDstyl@%
      \ifC@nf%
        {\fontsize{7}{10pt}\sffamily\itshape{\ET$^{#1}$#2}}%
      \else
        {\fontsize{7}{10pt}\sffamily%
        {\ET$^\mathsfrm{#1}$#2}}%
      \fi
    \fi%
    \ifEstyl@%
      \ifC@nf%
        {\fontsize{7}{10pt}\sffamily\itshape{\ET$^{#1}$#2}}%
      \else
        {\fontsize{7}{10pt}\sffamily%
        {\ET$^\mathsfrm{#1}$#2}}%
      \fi
    \fi%
    \ifSstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ET$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifOstyl@%
      {\textit{\ET$^{#1}$#2}}%
    \fi%
    \ifPstyl@%
      {\textit{\ET$^{#1}$#2}}%
    \fi%
    \ifVstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ET$^\mathsfrm{#1}$#2}}%
    \fi%
    \ifXstyl@%
      {\fontsize{9}{12pt}\sffamily\itshape%
      {\ET$^\mathsfit{#1}$#2}}%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily\itshape%
      {\ET$^{#1}$#2}}%
    \fi%
  }%
  \def\ET{, }%
  \def\ETC{, and }%
}

\newcommand{\nee}[1]{%                           % nee (inside \author#3)
  ({\textit{n\'ee} #1})%
}

\newcommand{\jr}[1][Jr]{ %                       % Jr (inside \author#3)
  #1%                                            % defaults to "Jr"
}

% The author listing is tricky because we want to convert between SGML
%  entries of the form <AU><SNM>Other</SNM><FNM>A.N.</FNM></AU><ORF id="a">
%  (to be expressed as a series of LaTeX expressions of the form
%  \author[a]{A.N.}{Other}) and a compound typeset sentence expressed as
%  Author1,^a Author2^a and Author3^b
%
% We establish an accumulator box register \box1, which chains together
%  entries separated by a comma (internal macro \AND), and a final (global)
%  box register \box0 which chains together the new and accumulated entries
%  with a final "and" (internal macro \ANDX, initially set to null in case
%  there is only one entry). The global box register \box2 is also needed for
%  storing the superscripts, which have to come AFTER the punctuation

\ifIstyl@\def\AND{By }\else\def\AND{\relax}\fi%  % separator
\ifIstyl@\def\ANDX{By }\else\def\ANDX{\relax}\fi%% separator

% \CORRLABEL has the same role of introducing and separating multiple
% correspondence email entries
\ifAstyl@\def\CORRLABEL{. Correspondence e-mail: }\fi%
\ifCstyl@\def\CORRLABEL{Correspondence e-mail: }\fi%
\ifDstyl@%
  \ifC@nf\def\CORRLABEL{. E-mail:~}%
  \else\def\CORRLABEL{Correspondence e-mail: }\fi%
\fi%
\ifEstyl@%
  \ifC@nf\def\CORRLABEL{. E-mail:~}%
  \else\def\CORRLABEL{Correspondence e-mail: }\fi%
\fi%
\ifSstyl@\def\CORRLABEL{. E-mail:~}\fi%
\ifOstyl@\def\CORRLABEL{. E-mail:~}\fi%
\ifPstyl@\def\CORRLABEL{. E-mail:~}\fi%
\ifXstyl@\def\CORRLABEL{. E-mail:~}\fi%
\ifYstyl@\def\CORRLABEL{. E-mail:~}\fi%

% There are four possible ways in which an author name may be presented:
%  (1)     \author{J.}{Soap}
%  (2)     \author[a]{J.}{Soap}
%  (3)     \cauthor{J.}{Soap}{e-mail}{address}
%  (4)     \cauthor[a]{J.}{Soap}{e-mail}{address}
% Correspondence author (one only) is handled by the \cauthor macro, others
%  by the \author macro

\newif\ifcorraut\corrautfalse                    % Tests if already output

\newcommand{\corrmark}{*}                        % Asterisk for corr. author
\newcommand{\cauthor}[5][\relax]{%               % Correspondence author names
  \global\setbox0=\hbox{%
    \unhcopy1%                                   % Final string
    \ifAstyl@%
      \ifSh@rt\normalsize\fi%
      {\sffamily\textbf{\ANDX#2~#3}}
    \fi
    \ifCstyl@%
      {\sffamily\textbf{\ANDX#2~#3}}
    \fi
    \ifDstyl@%
      \ifF@ll{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifSh@rt{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifC@nf{\sffamily\textbf{\ANDX#2~#3}}\fi%
    \fi%
    \ifEstyl@%
      \ifF@ll{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifSh@rt{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifC@nf{\sffamily\textbf{\ANDX#2~#3}}\fi%
    \fi%
    \ifIstyl@%
      \fontsize{10.23}{12}\selectfont             % 11 pt scale 93% (ps)
      \textsc{\ANDX#2~#3}
    \fi%
    \ifSstyl@%
      \fontsize{10}{12pt}%
      {\sffamily\textbf{\ANDX#2~#3}}
    \fi%
    \ifOstyl@%
      \ifF@ll{\textsc{\ANDX#2~#3}}\fi%
      \ifSh@rt{\ANDX\textsc{#2~#3}}\fi%
    \fi%
    \ifPstyl@%
      \textsc{\ANDX#2~#3}
    \fi%
    \ifVstyl@%
      {\sffamily\textbf{\ANDX#2~#3}}
    \fi
    \ifXstyl@%
      \ifF@ll%
        {\fontsize{11}{12pt}\sffamily\bfseries%
        {\ANDX#2~#3}}%
      \fi%
      \ifSh@rt%
        {\fontsize{10}{12pt}\sffamily\bfseries%
        {\ANDX#2~#3}}%
      \fi%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily%
      {\ANDX#2~#3}}%
    \fi%
  }%
  \setbox1=\hbox{%
    \unhcopy1%                                   % Add to accumulator register
    \ifAstyl@%
      \ifSh@rt\normalsize\fi%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifCstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifDstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifEstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifIstyl@%
      \fontsize{10.23}{12}\selectfont             % 11 pt scale 93% (ps)
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifSstyl@%
      \if\AND\relax%
        \fontsize{10}{12pt}%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        \fontsize{10}{12pt}%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifOstyl@%
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifPstyl@%
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifVstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifXstyl@%
      {\fontsize{11}{12pt}\sffamily\bfseries%
      \if\AND\relax%
        {\AND\unhbox2#2~#3}%                     % No initial space
      \else%
        {\AND\unhbox2\ #2~#3}%                   % space separates entries
      \fi%
      }%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily%
      \if\AND\relax%
        {\AND\unhbox2#2~#3}%                     % No initial space
      \else%
        {\AND\unhbox2\ #2~#3}%                   % space separates entries
      \fi%
      }%
    \fi%
  }%
  \ifAstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifCstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifDstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifEstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifSstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifOstyl@%
     \global\setbox2=\hbox{$^{#1}$\corrmark}%
  \fi%
  \ifPstyl@%
     \global\setbox2=\hbox{$^{#1}$\corrmark}%
  \fi%
  \ifVstyl@%
     \global\setbox2=\hbox{$^\mathsfbf{#1}$\corrmark}%
  \fi%
  \ifXstyl@%
     \global\setbox2=\hbox{$^\mathsfbi{#1}$\corrmark}%
  \fi%
  \ifYstyl@%
     \global\setbox2=\hbox{$^{#1}$\corrmark}%
  \fi%
  \ifAstyl@%
    \gdef\@mail{#4}\ifx\empty\@mail%
   \else%
     \global\setbox6=\hbox{\unhbox6%
       \fontsize{7}{10pt}%
       \sffamily{\CORRLABEL\@mail}%
       }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifCstyl@%
    \gdef\@mail{#4}\ifx\empty\@mail%
   \else%
     \global\setbox6=\hbox{\unhbox6%
       \fontsize{7}{10pt}%
       \sffamily{\CORRLABEL\@mail}%
       }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifDstyl@%
   \gdef\@mail{#4}\ifx\empty\@mail%
  \else%
    \ifC@nf%
     \global\setbox6=%
     \hbox{\unhbox6\fontsize{7}{10pt}\sffamily\itshape{\CORRLABEL\@mail}}%
    \else%
     \global\setbox6=\hbox{\unhbox6%
       \fontsize{7}{10pt}%
       \sffamily{\CORRLABEL\@mail}%
     }
    \fi%
   \def\CORRLABEL{, }
   \fi%
  \fi%
  \ifEstyl@%
    \gdef\@mail{#4}\ifx\empty\@mail%
   \else%
     \ifC@nf%
      \global\setbox6=\hbox{\unhbox6\fontsize{7}{10pt}\sffamily\itshape%
        {\CORRLABEL\@mail}}%
     \else%
      \global\setbox6=\hbox{\unhbox6%
        \fontsize{7}{10pt}%
        \sffamily{\CORRLABEL\@mail}%
        }
     \fi%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifSstyl@%
    \def\@mail{#4}\ifx\empty\@mail%
   \else%
      \global\setbox6=\hbox{\unhbox6%
        \fontsize{9}{10pt}%
        \sffamily\itshape{\CORRLABEL\@mail}%
        }
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifOstyl@%
    \gdef\@mail{#4}\ifx\empty\@mail%
  \else%
    \global\setbox6=\hbox{\unhbox6%
        \textit{\CORRLABEL\@mail}%
      }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifPstyl@%
    \gdef\@mail{#4}\ifx\empty\@mail%
  \else%
    \global\setbox6=\hbox{\unhbox6%
      \textit{\CORRLABEL\@mail}%
    }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifXstyl@%
    \def\@mail{#4}%
   \fi
  \ifXstyl@%
    \def\@mail{#4}\ifx\empty\@mail%
   \else%
      \global\setbox6=\hbox{\unhbox6%
        \sffamily\itshape{\CORRLABEL\@mail}%
      }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \ifYstyl@%
    \def\@mail{#4}\ifx\empty\@mail%
   \else%
      \global\setbox6=\hbox{\unhbox6%
        \rmfamily{\CORRLABEL\@mail}%
      }%
    \def\CORRLABEL{, }
    \fi%
  \fi%
  \def\AND{,}%
  \def\ANDX{\unhcopy2\ and }%
}

\renewcommand{\author}[3][\relax]{%              % Author names
  \global\setbox0=\hbox{%
    \unhcopy1%                                   % Final string
    \ifAstyl@%
      \ifF@ll{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifSh@rt{\normalsize\sffamily\textbf{\ANDX#2~#3}}\fi%
    \fi%
    \ifCstyl@%
      \sffamily\textbf{\ANDX#2~#3}%
    \fi%
    \ifDstyl@%
      \ifF@ll{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifSh@rt{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifC@nf{\sffamily\textbf{\ANDX#2~#3}}\fi%
    \fi%
    \ifEstyl@%
      \ifF@ll{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifSh@rt{\sffamily\textbf{\ANDX#2~#3}}\fi%
      \ifC@nf{\sffamily\textbf{\ANDX#2~#3}}\fi%
    \fi%
    \ifIstyl@%
      \fontsize{10.23}{12}\selectfont             % 11 pt scale 93% (ps)
      \textsc{\ANDX#2~#3}%
    \fi%
    \ifSstyl@%
      \fontsize{10}{12pt}%
      \sffamily\textbf{\ANDX#2~#3}%
    \fi%
    \ifOstyl@%
      \ifF@ll{\textsc{\ANDX#2~#3}}\fi%
      \ifSh@rt{\ANDX\textsc{#2~#3}}\fi%
    \fi%
    \ifPstyl@%
      \textsc{\ANDX#2~#3}%
    \fi%
    \ifVstyl@%
      \sffamily\textbf{\ANDX#2~#3}%
    \fi%
    \ifXstyl@%
      {\fontsize{11}{12pt}\sffamily\bfseries%
      {\ANDX#2~#3}}%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily%
      {\ANDX#2~#3}}%
    \fi%
  }%
  \setbox1=\hbox{%
    \unhcopy1%                                   % Add to accumulator register
    \ifAstyl@%
      \ifSh@rt\normalsize\fi%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifCstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifDstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifEstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifIstyl@%
      \fontsize{10.23}{12}\selectfont             % 11 pt scale 93% (ps)
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else%
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifSstyl@%
      \if\AND\relax%
        \fontsize{10}{12pt}%
       {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        \fontsize{10}{12pt}%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifOstyl@%
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else%
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifPstyl@%
      \if\AND\relax%
        {\textsc{\AND\unhbox2#2~#3}}%            % No initial space
      \else%
        {\textsc{\AND\unhbox2\ #2~#3}}%          % space separates entries
      \fi%
    \fi%
    \ifVstyl@%
      \if\AND\relax%
        {\sffamily\textbf{\AND\unhbox2#2~#3}}%   % No initial space
      \else%
        {\sffamily\textbf{\AND\unhbox2\ #2~#3}}% % space separates entries
      \fi%
    \fi%
    \ifXstyl@%
      {\fontsize{11}{12pt}\sffamily\bfseries%
      \if\AND\relax%
        {\AND\unhbox2#2~#3}%                     % No initial space
      \else%
        {\AND\unhbox2\ #2~#3}%                   % space separates entries
      \fi%
      }%
    \fi%
    \ifYstyl@%
      {\fontsize{10}{12pt}\rmfamily%
      \if\AND\relax%
        {\AND\unhbox2#2~#3}%                     % No initial space
      \else%
        {\AND\unhbox2\ #2~#3}%                   % space separates entries
      \fi%
      }%
    \fi%
    }%
  \ifAstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifCstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifDstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifEstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifSstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifOstyl@%
    \global\setbox2=\hbox{$^{#1}$}%
  \fi
  \ifPstyl@%
    \global\setbox2=\hbox{$^{#1}$}%
  \fi
  \ifVstyl@%
    \global\setbox2=\hbox{$^\mathsfbf{#1}$}%
  \fi
  \ifXstyl@%
    \global\setbox2=\hbox{$^\mathsfbi{#1}$}%
  \fi%
  \ifYstyl@%
    \global\setbox2=\hbox{$^{#1}$}%
  \fi%
  \def\AND{,}%
  \def\ANDX{\unhcopy2\ and }%
}

\newcounter{aufn}\setcounter{aufn}{2}
\newbox\@ufn
\newcommand{\aufn}[2][0]{%                       % Footnote to author name
\if0#1
  \ifAstyl@%
    \global\setbox2=\hbox{\sffamily\bfseries%    % Add fn symbol to author list
      \unhcopy2${\fnsymbol{aufn}}$}%
    \global\setbox\@ufn=\hbox{%                  % Put fn in its own box
      \fontsize{8}{10pt}%
      \noindent\rmfamily\unhcopy\@ufn%           % Keep existing contents
      $^\fnsymbol{aufn}$#2\hfill\break}%
   \stepcounter{aufn}
  \fi%
  \ifCstyl@%
      \global\setbox2=\hbox{\sffamily\bfseries%  % Add fn symbol to author list
        \unhcopy2${\fnsymbol{aufn}}$}%
      \global\setbox\@ufn=\hbox{%                % Put fn in its own box
        \fontsize{8}{10pt}%
        \noindent\rmfamily\unhcopy\@ufn%         % Keep existing contents
        $^\fnsymbol{aufn}$#2\hfill\break}%
     \stepcounter{aufn}
  \fi%
  \ifDstyl@%
    \ifC@nf%
      \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
    \else%
      \global\setbox2=\hbox{\sffamily\bfseries%  % Add fn symbol to author list
        \unhcopy2${\fnsymbol{aufn}}$}%
      \global\setbox\@ufn=\hbox{%                % Put fn in its own box
        \fontsize{7}{10pt}%
        \sffamily\unhcopy\@ufn%                  % Keep existing contents
        $^\fnsymbol{aufn}$#2\hfill\break}%
     \stepcounter{aufn}
    \fi%
  \fi%
  \ifEstyl@%
    \ifC@nf%
      \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
    \else%
      \global\setbox2=\hbox{\sffamily\bfseries%  % Add fn symbol to author list
        \unhcopy2${\fnsymbol{aufn}}$}%
      \global\setbox\@ufn=\hbox{%                % Put fn in its own box
        \fontsize{7}{10pt}%
        \sffamily\unhcopy\@ufn%                  % Keep existing contents
        $^\fnsymbol{aufn}$#2\hfill\break}%
     \stepcounter{aufn}
    \fi%
  \fi%
  \ifIstyl@%
  \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
  \fi%
  \ifSstyl@%
    \global\setbox2=\hbox{\sffamily\bfseries%    % Add fn symbol to author list
      \unhcopy2${\fnsymbol{aufn}}$}%
    \global\setbox\@ufn=\hbox{%                  % Put fn in its own box
      \fontsize{8}{10pt}%
      \noindent\rmfamily\unhcopy\@ufn%           % Keep existing contents
      $^\fnsymbol{aufn}$#2\hfill\break}%
    \stepcounter{aufn}
  \fi%
  \ifOstyl@%
  \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
  \fi%
  \ifPstyl@%
  \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
  \fi%
  \ifVstyl@%
    \global\setbox2=\hbox{\sffamily\bfseries%    % Add fn symbol to author list
      \unhcopy2${\fnsymbol{aufn}}$}%
    \global\setbox\@ufn=\hbox{%                  % Put fn in its own box
      \fontsize{8}{10pt}%
      \noindent\rmfamily\unhcopy\@ufn%           % Keep existing contents
      $^\fnsymbol{aufn}$#2\hfill\break}%
    \stepcounter{aufn}
  \fi%
  \ifXstyl@%
  \global\setbox2=\hbox{\unhcopy2\footnote{#2}}%
  \fi%
  \ifYstyl@%
    \global\setbox2=\hbox{\sffamily\bfseries%    % Add fn symbol to author list
      \unhcopy2${\fnsymbol{aufn}}$}%
    \global\setbox\@ufn=\hbox{%                  % Put fn in its own box
      \fontsize{8}{10pt}%
      \noindent\rmfamily\unhcopy\@ufn%           % Keep existing contents
      $^\fnsymbol{aufn}$#2\hfill\break}%
    \stepcounter{aufn}
  \fi%
\else  % allows multiple footnote markers pointing to same text
  \newcounter{fnm@rk}\setcounter{fnm@rk}{#1}\stepcounter{fnm@rk}
    \global\setbox2=\hbox{\sffamily\bfseries%    % Add fn symbol to author list
      \unhcopy2${\fnsymbol{fnm@rk}}$}%
\fi
}

\renewcommand{\title}[1]{%                       % Article title
  \mathversion{bold}%                            % maths in bold type
  \ifAstyl@\relax\fi%                            % no catchline%
  \ifCstyl@\relax\fi%                            % no catchline%
  \ifDstyl@\relax\fi%                            % no catchline%
  \ifEstyl@\relax\fi%                            % no catchline%
  \ifSstyl@\relax\fi%                            % no catchline%
  \ifOstyl@\par\noindent\unhbox\c@tchline\par\fi%% journal article catchline
  \ifPstyl@\relax\fi%                            % journal article catchline
  \ifVstyl@\relax\fi%                            % no catchline%
  \ifXstyl@\par\noindent\unhbox\c@tchline\par\fi%% journal article catchline
  \ifIstyl@\relax\fi%                            % no catchline%
%
  \ifAstyl@%
% For the new-style Acta papers (apart from conference proceedings) the
%  layout is more complex. The title area contains a 50mm box (+6 mm gutter)
%  containing the journal name and ISSN in a stylised logo layout; and a
%  114 mm box with the title.
    \newbox\l@go                                 % Journal typographic logo
    \newbox\t@tle                                % Title box
    \global\setbox\l@go=\hbox{\vtop{%            % Logo: vtop to align at top
      \vskip-12pt%                               % Different line spacing
\def\mc@de{M}
\if\j@urnalcode\mc@de
      {\noindent\sffamily\bfseries\small\j@urnalfullname\hfill\break}
\else
      {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
      {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
\fi
      \if\relax\issn%
      \else{\noindent\sffamily\scriptsize ISSN \issn\hfill\break}\fi
    }}
    \global\setbox\t@tle=\hbox{\vtop{%           % Title box
    \let\footnote\t@tlefn%                       % Redefine \footnote
      \hsize=128mm\baselineskip=14pt\raggedright
     {\noindent\sffamily\bfseries\Large #1}
    }}
  \fi%
  \ifCstyl@%
  \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
    \newbox\l@go                                 % Journal typographic logo
    \newbox\t@tle                                % Title box
    \global\setbox\l@go=\hbox{\vtop{%            % Logo: vtop to align at top
      \vskip-12pt%                               % Different line spacing
      {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
      {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
      \if\relax\issn
      \else{\noindent\sffamily\scriptsize ISSN \issn\hfill\break}\fi
    }}
    \noindent\unhbox\l@go\par
    \global\setbox\t@tle=\hbox{\vtop{%           % Title box
    \let\footnote\t@tlefn%                       % Redefine \footnote
      \hsize=\colwidth\baselineskip=14pt\raggedright
     {\noindent\fontsize{16}{18}\sffamily\bfseries #1}
    }}
    \bigskip\noindent\unhbox\t@tle\par
    \gdef\STITLE{#1}%                            % for running heads
    \thispagestyle{plain}%                       % no r/head on title page
  \fi
  \ifDstyl@%
    \ifC@nf%
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
      \noindent{\bgroup%
        \fontsize{14}{16pt}\sffamily\bfseries #1%
        \raggedright\par%
        \egroup}%                                % large bold font
      \vskip 24pt%
    \fi
% For the new-style Acta papers (apart from conference proceedings) the
%  layout is more complex. The title area contains a 50mm box (+6 mm gutter)
%  containing the journal name and ISSN in a stylised logo layout; and a
%  128 mm box with the title.
    \newbox\l@go                                 % Journal typographic logo
    \newbox\t@tle                                % Title box
    \ifF@ll%                                     % Research papers
      \global\setbox\l@go=\hbox{\vtop{%          % Logo: vtop to align at top
        \vskip-10pt%                             % Different line spacing
        {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
        {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
        {\noindent\sffamily\scriptsize ISSN \issn\hfill\break}
      }}
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
        \let\footnote\t@tlefn%                   % Redefine \footnote
        \hsize=128mm\baselineskip=14pt\raggedright
       {\noindent\sffamily\bfseries\Large #1}
      }}
      \noindent\hbox to \textwidth{%             % Unpack logo and title
        \hbox to 56mm{\unhbox\l@go}%             % side by side
        \hbox to 128 mm{\unhbox\t@tle%
      }}%
    \fi%
    \ifSh@rt%                                    % Short papers: same as full
    \par\noindent%
      \global\setbox\l@go=\hbox{\vtop{%          % Logo: vtop to align at top
        \vskip-10pt%                             % Different line spacing
        {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
        {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
        {\noindent\sffamily\scriptsize ISSN \issn\hfill\break}
      }}
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
      \let\footnote\t@tlefn%                     % Redefine \footnote
        \hsize=128mm\baselineskip=14pt\raggedright
       {\noindent\sffamily\bfseries\Large #1}
      }}
      \noindent\hbox to \textwidth{%             % Unpack logo and title
        \hbox to 56mm{\unhbox\l@go}%             % side by side
        \hbox to 128 mm{\unhbox\t@tle%
      }}%
    \fi
    \ifC@nf%
      \thispagestyle{myheadings}%                % no r/head on title page
    \else
      \thispagestyle{plain}%                     % no r/head on title page
    \fi
  \fi%
   \ifEstyl@%
    \ifC@nf%
      \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
      \noindent{\bgroup%
        \fontsize{14}{16pt}\sffamily\bfseries #1%
        \raggedright\par%
        \egroup}%                                % large bold font
      \vskip 24pt%
    \fi
% For the new-style Acta papers (apart from conference proceedings) the
%  layout is more complex. The title area contains a 50mm box (+6 mm gutter)
%  containing the journal name and ISSN in a stylised logo layout; and a
%  128 mm box with the title.
    \newbox\l@go                                 % Journal typographic logo
    \newbox\t@tle                                % Title box
    \ifF@ll%                                     % Research papers
      \global\setbox\l@go=\hbox{\vtop{%          % Logo: vtop to align at top
        \vskip-10pt%                             % Different line spacing
        {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
        {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
        {\noindent\sffamily\scriptsize ISSN \issn\hfill\break}
      }}
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
        \let\footnote\t@tlefn%                   % Redefine \footnote
        \hsize=128mm\baselineskip=14pt\raggedright
       {\noindent\sffamily\bfseries\Large #1}
      }}
      \noindent\hbox to \textwidth{%             % Unpack logo and title
        \hbox to 56mm{\unhbox\l@go}%             % side by side
        \hbox to 128 mm{\unhbox\t@tle%
      }}%
    \fi%
    \ifSh@rt%                                    % Short papers: same as full
      \par\noindent%
      \global\setbox\l@go=\hbox{\vtop{%          % Logo: vtop to align at top
        \vskip-10pt%                             % Different line spacing
        {\noindent\sffamily\scriptsize\j@urnalfullname\hfill\break}
        {\noindent\sffamily\bfseries\small\j@urnaltitle\hfill\break}
        {\noindent\sffamily\scriptsize ISSN \issn\hfill\break}
      }}
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
        \let\footnote\t@tlefn%                   % Redefine \footnote
        \hsize=128mm\baselineskip=14pt\raggedright
       {\noindent\sffamily\bfseries\Large #1}
      }}
      \noindent\hbox to \textwidth{%             % Unpack logo and title
        \hbox to 56mm{\unhbox\l@go}%             % side by side
        \hbox to 128 mm{\unhbox\t@tle%
      }}%
    \fi
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifIstyl@%
    \vbox to 24pt{\vfill}%
    \begin{centering}%                           % centred
    \fontsize{13.02}{16}\selectfont%             % 14 pt scaled 93% (ps)
    \bf\thepart.\thechapter. #1\par%       % large bold font
    \gdef\STITLE{\uppercase{#1}}%                % for running heads
    \end{centering}%
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifSstyl@%
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
    \newbox\t@tle                                % Title box
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
      \let\footnote\t@tlefn%                     % Redefine \footnote
        \hsize=\colwidth\baselineskip=14pt\raggedright
       {\noindent\fontsize{12}{18}\sffamily\bfseries #1}
      }}
    \bigskip\noindent\unhbox\t@tle\par
    \gdef\STITLE{#1}%                            % for running heads
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifOstyl@%
    \bigskip%
    \ifF@ll%
      \begin{centering}%                         % centred
      \Large\bf #1\par%                          % large bold font
      \gdef\STITLE{\uppercase{#1}}%              % for running heads
      \end{centering}%
    \fi%
    \ifSh@rt%
      \noindent{\large\bf #1}\par%               % large bold font
      \gdef\STITLE{SHORT COMMUNICATIONS}%        % for running heads
    \fi%
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifPstyl@%
    \bigskip%
    \begin{centering}%                           % centred
    \Large\bf #1\par%                            % large bold font
    \gdef\STITLE{\uppercase{#1}}%                % for running heads
    \end{centering}%
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifVstyl@%
  \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
    \newbox\l@go                                 % Journal typographic logo
    \newbox\t@tle                                % Title box
      \global\setbox\t@tle=\hbox{\vtop{%         % Title box
      \let\footnote\t@tlefn%                     % Redefine \footnote
        \hsize=\colwidth\baselineskip=14pt\raggedright
       {\noindent\fontsize{16}{18}\sffamily\bfseries #1}
      }}
    \bigskip\noindent\unhbox\t@tle\par
    \gdef\STITLE{#1}%                            % for running heads
    \thispagestyle{plain}%                       % no r/head on title page
  \fi
  \ifXstyl@%
    \begin{meenypage}%                           % title block
    \raggedright
    \ifF@ll\sffamily\bfseries\Large #1\fi%       % Large bold font
    \ifSh@rt\sffamily\bfseries\large #1\fi%      % large bold font
    \gdef\STITLE{#1}%                            % for running heads
    \end{meenypage}%
    \thispagestyle{plain}%                       % no r/head on title page
  \fi%
  \ifYstyl@%
    \newbox\t@tle                                % Title box
    \global\setbox\t@tle=\hbox{%                 % Title box
    \let\footnote\t@tlefn%                       % Redefine \footnote
      %\hsize=21pc\baselineskip=12pt
      \usefont{OT1}{ptm}{m}{n}\fontsize{10}{12pt}%
     {\rmfamily\bfseries #1,}
    }
   \fi
  \mathversion{normal}%                          % normal maths hereafter
}

\newbox\vit@
\newcommand{\vita}[1]{%                          % author biography
  \ifsingl@col%
    \begin{inset}\hrule\smallskip%               % ruled float
    \def\\{\par\quad}%                           % \\ between paragraphs
    \textit{#1}%                                 % italic text
    \smallskip\hrule\end{inset}%
  \else
    \global\setbox\vit@%
      \hbox{\vbox{%
        \bigskip\hrule\smallskip%                % rule (no float)
        \def\\{\par}%                            % \\ between paragraphs
        \noindent\textit{#1}%                    % italic text
        \smallskip\hrule\bigskip%
      }
    }
  \fi
}

\newcommand{\ack}[1]{%                           % acknowledgement
  \smallskip\par#1%
}

\renewcommand{\appendix}{%                       % APPENDIX MATTER
\global\@ppend@xtrue%
  \vspace\baselineskip%
  \renewcommand{\section}{%                      % Redefine \section: invoke
    \secdef\APPSEC\sAPPSEC%                      %  \APPSEC as the section
  }%
  \setcounter{section}{0}%                       % header (see p.31 of The
% \theBOOKMARKsection is introduced for PDF bookmarks. In the case of
% International Tables, a roman letter A must be forced by \mathrm{A},
% but this breaks as an argument to \pdfbookmark
\ifIstyl@%
  \newcommand{\theappendix}{\arabic{part}.\arabic{chapter}.\arabic{section}}%   %  LaTeX Companion)
  \renewcommand{\thesection}{\mathrm{A}\arabic{part}.\arabic{chapter}.\arabic{section}}%   %  LaTeX Companion)
  \renewcommand{\theBOOKMARKsection}{A\arabic{part}.\arabic{chapter}.\arabic{section}}%   %  LaTeX Companion)
\else%
  \renewcommand{\thesection}{\Alph{section}}%   %  LaTeX Companion)
  \renewcommand{\theBOOKMARKsection}{\Alph{section}}%   %  LaTeX Companion)
\fi
}
\newcommand{\APPSEC}[2][?]{%
  \refstepcounter{section}%
  \setcounter{table}{0}%
  % Output bookmarks in hyperref package if using pdflatex
  \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
  \ifPDF\pdfbookmark[1]{\theBOOKMARKsection\  #1}{section.0.\theBOOKMARKsection}\fi
  \vspace\baselineskip%                          % Skip before
  \ifAstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifCstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifDstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifEstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifIstyl@%
    %{\large\bfseries\centering%
    {\rmfamily\normalsize\bfseries\centering%
      \appendixname\ \theappendix\par#2\par}%
  \vspace{3pt}\noindent%                 % Skip after
  \fi
  \ifSstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifOstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifPstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifVstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
  \ifXstyl@%
    {\sffamily\bfseries\large%
      \noindent\appendixname\ \thesection\par\noindent#2\par}%
  \vspace\baselineskip\noindent%                 % Skip after
  \fi
}

\newcommand{\sAPPSEC}[1]{%
  \vspace\baselineskip%                          % Skip before
  \ifAstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifCstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifDstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifEstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifSstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifOstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifPstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifVstyl@%
    {\large\bfseries\centering%
      \appendixname\ \thesection\par#1\par}%
  \fi
  \ifXstyl@%
    {\sffamily\bfseries\large%
      \noindent\appendixname\ \thesection\par\noindent#1\par}%
  \fi
  \vspace\baselineskip\noindent%                 % Skip after
}

\newcounter{refno}\setcounter{refno}{1}
\newcommand{\reference}[1]{%                     % MANUAL REFERENCE (in
  \ifYstyl@%
    \parindent=0pt%
    \parskip=0pt%
    \fontsize{8}{9pt}\usefont{OT1}{ptm}{m}{n}
    \par[\therefno] #1\refstepcounter{refno}\par
  \else%
    \ifIstyl@\fontsize{9}{10pt}\usefont{OT1}{ptm}{m}{n}
    \parskip2pt
    \par\noindent\parbox{\hsize}{%               %  references environment)
      \everypar{\hangindent=1em \hangafter=1}%   % Hanging paragraphs
      #1}\par%
    \else
    \vskip0pt plus3pt%
    \par\noindent\parbox[b]{\hsize}{%               %  references environment)
      \everypar{\hangindent=1pc \hangafter=1}%   % Hanging paragraphs
      #1}\par%
    \fi
  \fi
}

\newcommand{\backmatter}{%                       % BACK MATTER (after appendix)
  \renewcommand{\section}[1]{%                   % Allow unnumbered \section
    \ifmkttl\else\maketitle\fi                   % Ensure title block flushed
    \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi
    \refstepcounter{section}%                    % increment counter
    \setcounter{figure}{0}                       % caption numbering by section
    \setcounter{example}{0}                      % caption numbering by section
    \setcounter{table}{0}                        % caption numbering by section
    % Output bookmarks in hyperref package if using pdflatex
    \providecommand{\pdfbookmark}[5]{\relax} % in case hyperref not loaded
    \ifPDF\pdfbookmark[1]{\thesection\  ##1}{section.0.\thesection}\fi
    {\vskip 12pt plus8pt minus2pt\centering%     % style of section heading
    \rmfamily\normalsize\bfseries%
    ##1\par%
    \vskip-\baselineskip%
    \vskip4pt minus 4pt}%
    \noindent
    \@nobreakfalse                               % Living dangerously -
    \global\@noskipsectrue                       %  this segment of code
    \everypar{%                                  %  is extracted with
      \if@noskipsec                              %  rather little detailed
        \global\@noskipsecfalse                  %  analysis from the
        {\setbox\z@\lastbox}%                    %  @startsection stuff in
        \clubpenalty\@M                          %  latex.ltx to ensure
        \unskip                                  %  that the first paragraph
      \else                                      %  following is not
        \clubpenalty \@clubpenalty               %  indented
        \everypar{}%                             %
     \fi%                                        %
    }%                                           %
  }
}


% The iucr.bst BibTeX bibliography style requires the harvard.sty package.
% IUCr citations are similar to the "dcu" style within harvard.sty, but
% require the conjunction to be changed to '&'; also abbreviated citations
% ('et al.') are always used.
\citationstyle{dcu}                              % (Doe, 1990; Soape, 1991)
\renewcommand{\harvardand}{\&}                   % (Doe & Soape, 1990)
\citationmode{abbr}                              % (Doe et al., 1990)

\newcommand{\referencelist}[1][iucr]{%           % BibTeX REFERENCE LIST
  \renewcommand{\section}{\normalsection}{%                   % Suppress section head
    \renewcommand{\thesection}{}%
\let\theBOOKMARKsection\thesection
  }%
  \bibliography{#1}%                             % Invoke bibliography
  \ifIstyl@%
    \bibliographystyle{iucrit}%                  % Use IUCr IT bibliography style
  \else%
    \bibliographystyle{iucr}%                    % Use IUCr bibliography style
  \fi
}

% \newblock is output by BibTeX to separate logical sections of a reference
% listing. It serves no useful purpose, and can cause extra spacing to
% intrude
\let\newblock\relax

% A complication of the preferred style of citation of IUCr journals
%  is that the volume number for Acta includes the section label,
%  which is NOT printed in bold; to accommodate this, \volbf is defined
%  and generated by iucr.bst. \volbf needs to test just the first character
%  of the volume number
\newif\iffirst\firsttrue
\def\volbf#1{%
  {\firsttrue\v@lbf#1\end}%
}
\def\v@lbf#1{%
  \ifx#1\end
    \let\next=\relax%
  \else
    \let\next=\v@lbf\iffirst
    \def\t@st{#1}
    \if\t@st\@A@{\rmfamily{#1}}\else
      \if\t@st\@B@{\rmfamily{#1}}\else
        \if\t@st\@C@{\rmfamily{#1}}\else
          \if\t@st\@D@{\rmfamily{#1}}\else
            \if\t@st\@E@{\rmfamily{#1}}\else
              \if\t@st\@F@{\rmfamily{#1}}\else
              \textbf{#1}%
              \fi
            \fi
          \fi
        \fi
      \fi
    \fi%
    \firstfalse%
    \else
      {\textbf #1}%
    \fi%
  \fi
  \next%
}

\renewcommand{\caption}[1]%
{%
  \ifAstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \ifF@ll\fontsize{8}{10pt}\fi%
        \ifSh@rt\fontsize{7}{9pt}\fi%
        \ifC@nf\fontsize{7}{9pt}\fi%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent%
        \ifF@ll{\fontsize{9}{10pt}\sffamily\bfseries Figure \thefigure}\fi%
        \ifSh@rt{\fontsize{8}{10pt}\sffamily\bfseries Figure \thefigure}\fi%
        \ifC@nf{\fontsize{8}{10pt}\sffamily\bfseries Figure \thefigure}\fi%
        \par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \ifF@ll\fontsize{8}{10pt}\fi%
      \ifSh@rt\fontsize{7}{9pt}\fi%
      \ifC@nf\fontsize{7}{9pt}\fi%
      \usefont{OT1}{ptm}{m}{n}%
      \ifF@ll{\fontsize{9}{10pt}\sffamily\bfseries Table~\thetable}\fi%
      \ifSh@rt{\fontsize{8}{10pt}\sffamily\bfseries Table~\thetable}\fi%
      \ifC@nf{\fontsize{8}{10pt}\sffamily\bfseries Table~\thetable}\fi%
      \par\noindent %
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifCstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \fontsize{9}{10pt}%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \fontsize{9}{10pt}%
      \usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifDstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \ifF@ll\fontsize{9}{10pt}\fi%
        \ifSh@rt\fontsize{9}{10pt}\fi%
        \ifC@nf\fontsize{8}{9pt}\fi%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \ifF@ll\fontsize{9}{10pt}\fi%
      \ifSh@rt\fontsize{9}{10pt}\fi%
      \ifC@nf\fontsize{8}{9pt}\fi%
      \usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifEstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \ifF@ll\fontsize{9}{10pt}\fi%
        \ifSh@rt\fontsize{9}{10pt}\fi%
        \ifC@nf\fontsize{8}{9pt}\fi%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \ifF@ll\fontsize{9}{10pt}\fi%
      \ifSh@rt\fontsize{9}{10pt}\fi%
      \ifC@nf\fontsize{8}{9pt}\fi%
      \usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifIstyl@%
    \ifEG  % Example (fully defined only for International Tables)
      %\gdef\captionbox{%
        \par\noindent\hangindent=1pc\hangafter=1%
        \fontsize{10}{11pt}\usefont{OT1}{ptm}{m}{n}%
        \noindent{\rmfamily Example~\theexample}. %
         \textit{#1}%
      %}%
    \fi
    \ifFIG
      \gdef\captionbox{%
        \par\noindent\hangindent=1pc\hangafter=1%
        \fontsize{8}{10pt}\usefont{OT1}{ptm}{m}{n}%
        \noindent{\rmfamily Fig.~\thefigure}. %
         #1%
      }%
    \fi
    \ifTAB
      \bgroup
      \fontsize{9}{10pt}\usefont{OT1}{ptm}{m}{n}%
      % The glue parameters force the final line to be centred.
      \parindent=0pt\leftskip=0pt plus1fil\rightskip=0pt plus-1fil%
      \parfillskip=0pt plus2fil%
      {\textrm Table~}\ifmmode\thetable\else{\let\mathrm\textrm\thetable}\fi. %
      {\itshape #1}\par%
      \egroup
    \fi
  \fi
  \ifSstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \fontsize{8}{9pt}%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \fontsize{8}{9pt}%
      \usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifOstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent\hangindent=1pc\hangafter=1%
        \fontsize{8}{10pt}\usefont{OT1}{ptm}{m}{n}%
        \noindent{\rmfamily Fig.~\thefigure}. %
         #1%
      }%
    \fi
    \ifTAB
      \begin{centering}
      \fontsize{9}{10pt}\usefont{OT1}{ptm}{m}{n}%
      {\rmfamily Table~\thetable}. %
      {\itshape #1}\par%
      \end{centering}
    \fi
  \fi
  \ifPstyl@%
  \baselineskip=16pt
    \ifFIG
      \gdef\captionbox{%
        \par\noindent\hangindent=1pc\hangafter=1%
        \noindent{\rmfamily Fig.~\thefigure}. %
         #1%
      }%
    \fi
    \ifTAB
      \begin{centering}
      {\rmfamily Table~\thetable}. %
      {\itshape #1}\par%
      \end{centering}
    \fi
  \fi
  \ifVstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \fontsize{9}{10pt}%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \fontsize{9}{10pt}%
      \usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
  \ifXstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \fontsize{8.5}{10pt}%
        \usefont{OT1}{ptm}{m}{n}%
        \noindent{\sffamily\bfseries
        Figure \thefigure}\par\noindent%
         #1%
      }%
    \fi
    \ifTAB
      \fontsize{8.5}{10pt}\usefont{OT1}{ptm}{m}{n}%
      {\sffamily\bfseries Table~\thetable}\par\noindent%
      {#1}\par%
      \smallskip\hrule height .2pt%
    \fi
  \fi
  \ifYstyl@%
    \ifFIG
      \gdef\captionbox{%
        \par\noindent%
        \fontsize{7}{9pt}\usefont{OT1}{ptm}{m}{n}%
        %\noindent%
         #1\par%
      }%
    \fi
    \ifTAB
      \fontsize{7}{9pt}\usefont{OT1}{ptm}{m}{n}%
      %\par\noindent %
      {#1}\par%
      \smallskip\hrule height .1pt%
    \fi
  \fi
}

% PDB and NDB reference codes may occur in Acta Cryst. D. They appear before
%  the synopsis, and so should be scooped up into a box, punctuated and
%  annotated according as there are one or several, with or without compound
%  names; then dumped out after the received and accepted lines by \maketitle
% The box and punctuation manipulations follow those of \author and \aff

\newbox\@PDB\newbox\@PDBscr@tch
\gdef\QUE{\relax}                                % separator - Latin !
\gdef\ATQUE{\relax}                              % separator - Latin !
\gdef\PDBr@f{PDB reference: }                    % prefatory label

\newcommand{\PDBref}[2][\relax]{%                % PDB reference codes
  \def\t@mp{#1}
  \def\c@mma{\if\relax\t@mp\else,\fi}
  \global\setbox\@PDB=\hbox{%
    \if\j@urnalcode\@D@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@E@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@F@\fontsize{7}{10pt}\sffamily\fi%
    {\bfseries\PDBr@f}
    \unhcopy\@PDBscr@tch%                        % Final string
    {\ATQUE #1\c@mma\ #2}.%
  }%
  \global\setbox\@PDBscr@tch=\hbox{%
    \if\j@urnalcode\@D@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@E@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@F@\fontsize{7}{10pt}\sffamily\fi%
    \unhcopy\@PDBscr@tch%                        % Add to accumulator register
    {\QUE #1\c@mma\ #2}%
  }%
  \gdef\QUE{; }%
  \gdef\ATQUE{; }%
  \gdef\PDBr@f{PDB references: }                 % plural on next invocations
}

\newbox\@NDB\newbox\@NDBscr@tch
\gdef\UND{\relax}                                % separator - German !
\gdef\UNDX{\relax}                               % separator
\gdef\NDBr@f{NDB reference: }                    % prefatory label

\newcommand{\NDBref}[2][\relax]{%                % NDB reference codes
  \def\t@mp{#1}
  \def\c@mma{\if\relax\t@mp\else,\fi}
  \global\setbox\@NDB=\hbox{%
    \if\j@urnalcode\@D@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@E@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@F@\fontsize{7}{10pt}\sffamily\fi%
    {\bfseries\NDBr@f}
    \unhcopy\@NDBscr@tch%                        % Final string
    {\UNDX #1\c@mma\ #2}.%
  }%
  \global\setbox\@NDBscr@tch=\hbox{%
    \if\j@urnalcode\@D@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@E@\fontsize{7}{10pt}\sffamily\fi%
    \if\j@urnalcode\@F@\fontsize{7}{10pt}\sffamily\fi%
    \unhcopy\@NDBscr@tch%                        % Add to accumulator register
    {\UND #1\c@mma\ #2}%
  }%
  \gdef\UND{; }%
  \gdef\UNDX{; }%
  \gdef\NDBr@f{NDB references: }                 % plural on next invocations
  }

% Special handling of title footnotes in new-style Acta
\newbox\t@tlebox
\newcommand{\t@tlefn}[1]{%
\ifAstyl@%                                       % Acta A/JAC
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \par\fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
\ifCstyl@%                                       % Acta A/JAC
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
\ifDstyl@%                                       % Acta D/Acta B
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \par\fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
\ifEstyl@%                                       % Acta D/Acta B
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \par\fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
\ifSstyl@%                                       % Acta A/JAC
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
\ifVstyl@%                                       % Acta A/JAC
  $^1$\stepcounter{footnote}%                    % emit the footnote marker
  \global\setbox\t@tlebox%                       % Store text in \t@tlebox
    \hbox{%
      \fontsize{8}{10pt}\rmfamily\mdseries%
      #1%
    }%
\fi
}

% Special handling of footnotes in new-style Acta
\newcommand{\@hackfntext}[1]{%                   % Hacked footnote on first
  \gdef\footnoterule{%                           % page of new-style articles
    \hbox{%
      \hskip56mm\rule{30mm}{0.4pt}\vspace*{3pt}% % Footnote rule offset
  }}%
  \hbox{%
    \hbox to56mm{\hfill}%
    \hbox{\vtop{\noindent$^\@thefnmark$ #1}}%
  }%
}

% Simple multicolumns switching macros
\renewcommand{\onecolumn}{%                      % set in single column
  \ifsingl@col\else\end{multicols}\singl@coltrue\fi%
  % If called in the appendix section, the redefinition of \section
  % goes out of scope and so must be redeclared
  \if@ppend@x\renewcommand{\section}{\secdef\APPSEC\sAPPSEC}%
    \renewcommand{\thesection}{\Alph{section}.}\fi
\let\theBOOKMARKsection\thesection
}

\renewcommand{\twocolumn}{%                      % set in two columns
  \ifsingl@col\begin{multicols}{2}\singl@colfalse\fi%
  % If called in the appendix section, the redefinition of \section
  % goes out of scope and so must be redeclared
% \if@ppend@x\renewcommand{\section}{\secdef\APPSEC\sAPPSEC}%
%   \renewcommand{\thesection}{\Alph{section}.}\fi
  \if@ppend@x\renewcommand{\section}{\secdef\APPSEC\sAPPSEC}%
\ifIstyl@
    \global\renewcommand{\thesection}{\relax}%
\else
    \renewcommand{\thesection}{\Alph{section}.}%
\fi
\let\theBOOKMARKsection\thesection
\fi
}

\newcommand{\threecolumn}{%                      % set in three columns
  \ifsingl@col\begin{multicols}{3}\singl@colfalse\fi%
  % If called in the appendix section, the redefinition of \section
  % goes out of scope and so must be redeclared
  \if@ppend@x\renewcommand{\section}{\secdef\APPSEC\sAPPSEC}%
    \renewcommand{\thesection}{\Alph{section}.}\fi
\let\theBOOKMARKsection\thesection
}

% The index entry and index page wrappers (for use in the index environment)
\newif\ifdebug\debugfalse
\newif\ifcommaneeded\commaneededfalse

\newcommand{\idxentry}[1]{%
  \par%
  \ifraggedstyle\raggedright\fi%
  #1%
  \hfill%
  \global\commaneededfalse%
  \ifraggedstyle\hangafter=1\hangindent=1.5em%
    \else\hangafter=1\hangindent=1em\fi%
}
\newcommand{\idxsubentry}[1]{%
  \par%
  \ifraggedstyle\raggedright\fi%
  \quad#1%
  \hfill%
  \global\commaneededfalse%
  \hangafter=1\hangindent=1.5em%
}
\newcommand{\idxpage}[1]{{%
  \ifcommaneeded\unskip,\fi%
  \penalty1000 \hskip.33em plus-3em minus.11em%
  \vadjust{}\penalty10000 \hskip0pt plus3em%
  #1%
  \global\commaneededtrue%
}}

% Macros used in listing CIF extracts of CIF dictionary entries
% Example:
%    \cifname{_atom_site_attached_hydrogens}            \ciftype{numb}
%    \cifdefinition{The number of hydrogen atoms attached to the atom
%    at this site excluding any H atoms for which coordinates (measured
%    or calculated) are given.}
%    %
%    \cifattributes{Appears in list containing \cifname{_atom_site_label}.
%    Where no value is given, the assumed value is `0'. The permitted
%    range is 0 $\rightarrow$ 4.}
%    %
%    \cifexamples{Example(s): `2' (water oxygen), `1' (hydroxyl oxygen),
%    `4' (ammonium nitrogen).}
\newif\iff@rst\f@rsttrue

\newcommand{\cifattributes}[1]{%
  \par\footnotesize#1\par%
}
% Some hairy stuff here and in \cifname
% Because argument can have underscores, we need a way to treat the underscores
%  as normal characters and not subscript codes. The first attempt (making _ an
%  active character) doesn't work because references and file inputs in LaTeX
%  break if their argument (which of course might contain _) expands to TeX
%  control sequences. The fix is to use \string which will return just the
%  underscore character; but string works just on a single token, and so the
%  input argument has to be treated iteratively as a list of tokens. \cifcat
%  puts a stop token at the end of the argument and passes it recursively to
%  \CIFCAT, and the same for \cifname
\newcommand{\cifcat}[1]{%
  {\fontsize{8}{11pt}\f@rsttrue\CIFCAT#1\end}%   % pass separate tokens
  ]%
}
\newcommand{\CIFCAT}[1]{%
  \ifx#1\end%
    \let\next=\relax
  \else%
    \let\next=\CIFNAME%
    \iff@rst%                                    % first token
      \hfill[\setupverbatim{\string#1}%
      \f@rstfalse%
    \else%                                       % subsequent tokens
      \string#1%
    \fi%
  \fi
  \next%
}
\newcommand{\cifdefinition}[1]{%
  \par#1\par%
}
\newcommand{\cifexamples}[1]{%
  \par\footnotesize#1%
}
\newcommand{\cifname}[1]{%
  {\fontsize{8}{11pt}\f@rsttrue\CIFNAME#1\end}%  % pass separate tokens
}
\newcommand{\CIFNAME}[1]{%
  \ifx#1\end%
    \let\next=\relax
  \else
    \let\next=\CIFNAME%
    \iff@rst%                                    % first token
      \setupverbatim{\string#1}%
      \f@rstfalse%
    \else%                                       % subsequent tokens
    % some complex stuff to print out \% as % - unfortunately verbatim
    % scanning of unescaped % characters doesn't work if the \cifname
    % macro is embedded in an argument to a command (which it often is)
    % because of early token expansion
      \def\stringpercent{\string\%}\def\stringtest{\string#1}%
      \ifx\stringpercent\stringtest%
        \%%
      \else%
        \string#1%
      \fi%
    \fi%
  \fi%
  \next%
}
\newcommand{\ciftype}[1]{%
  \fontsize{9}{11pt}%
  \hfill(\textit{#1})\par%
}
\newcommand{\cifcategory}[1]{%
  {\f@rsttrue\CIFCATEGORY#1\end}%                % pass separate tokens
}
\newcommand{\CIFCATEGORY}[1]{%
  \ifx#1\end%
    \let\next=\relax
  \else%
    \let\next=\CIFCATEGORY%
    \if#1_%
      {\setupverbatim{\string#1}}%
    \else%
      %\uppercase{\string#1}%
      %\sc{\lowercase{\string#1}}%
      \fontsize{8}{12pt}\selectfont{\uppercase{\string#1}}%
    \fi%
  \fi%
  \next%
}

% Some macros that map to specific SGML tags but have no formatting effect
\newcommand{\city}[1]{#1}                        % city in a corr. address
\newcommand{\country}[1]{#1}                     % country in corr. address

%
% ------------------- initialising the job -----------------------------------
%

\pagestyle{myheadings}                           % pages have running heads
\lefthyphenmin=3\righthyphenmin=3                % hyphenation rules

\def\AUTITLE{LIST OF AUTHORS}
\def\STITLE{(SHORTENED) TITLE}
\def\PARTTITLE{PART TITLE}
\gdef\RHEAD{\relax}                              % default running head
\gdef\p@geprefix{\relax}                         % default page prefix letter
\gdef\d@i{\relax}                                % default DOI

\AtBeginDocument{%
  \message{Beginning to process article (iucr) }
  \scrollmode
  \ifAstyl@%
    \singl@coltrue
    \ifSh@rt\begin{small}\fi%
  \fi%
  \ifCstyl@%
    \begin{multicols}{2}
    \singl@colfalse%
  \fi%
  \ifDstyl@%
    \ifF@ll\singl@coltrue\fi
    \ifSh@rt%
      \begin{small}
      \singl@coltrue\
    \fi
    \ifC@nf%
      \begin{small}
      \begin{multicols}{2}
      \singl@colfalse%
    \fi
  \fi%
  \ifEstyl@%
    \ifF@ll\singl@coltrue\fi
    \ifSh@rt%
      \begin{small}
      \singl@coltrue\
    \fi
    \ifC@nf%
      \begin{small}
      \begin{multicols}{2}
      \singl@colfalse%
    \fi
  \fi%
  \ifSstyl@%
    \begin{multicols}{2}
    \singl@colfalse%
    \fontsize{9}{11pt}\usefont{OT1}{ptm}{m}{n}
  \fi%
  \ifOstyl@%
    \singl@coltrue
    \ifSh@rt\begin{small}\fi%
  \fi%
  \ifPstyl@%
    \singl@coltrue
    \baselineskip=24pt
  \fi%
  \ifVstyl@%
    \begin{multicols}{2}
    \singl@colfalse%
  \fi%
  \ifXstyl@%
    \ifF@ll\singl@coltrue\fi
    \ifSh@rt%
      \begin{small}
      \begin{multicols}{2}
      \singl@colfalse%
    \fi
  \fi%
  \ifYstyl@%
    \begin{multicols}{2}
    \singl@colfalse%
    \raggedcolumns
  \fi%
  \frenchspacing
}

\AtEndDocument{%
  \ifYstyl@%
\break
  \end{multicols}
  \fi
  \ifDstyl@%
    \ifC@nf%
    % running footers on last page of conference papers have the recd/acc dates
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \fontsize{7}{12pt}\sffamily %
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
          \hfill%
          \d@i%
          \hfill%
          Received \recd@te \kern3pt$\cdot$\kern3pt%
          Accepted \accd@te%
          {\quad\fontsize{12}{12pt}\sffamily\bfseries\thepage}%
          }
        }
      \fi
    }
    \renewcommand{\@evenfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}\sffamily\bfseries\thepage}\quad%
            \fontsize{7}{12pt}\sffamily %
            Received \recd@te \kern3pt$\cdot$\kern3pt%
            Accepted \accd@te%
            \hfill%
            \d@i%
            \hfill%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
          }
        }
      \fi
    }    \fi
  \fi
  \ifSstyl@%
    % running footers on last page of new-style JSR have the recd/acc dates
    \renewcommand{\@oddfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            \fontsize{7}{12pt}\sffamily %
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
          \hfill%
          \d@i%
          \hfill%
          Received \recd@te \kern3pt$\cdot$\kern3pt%
          Accepted \accd@te%
          {\quad\fontsize{12}{12pt}\sffamily\bfseries\thepage}%
          }
        }
      \fi
    }
    \renewcommand{\@evenfoot}{%
      \ifhe@ders%
        \vbox to 0pt{%
          \hrule height .1 pt width \textwidth \vskip 3pt%
          \hbox to \textwidth{%
            {\fontsize{12}{12pt}\sffamily\bfseries\thepage}\quad%
            \fontsize{7}{12pt}\sffamily %
            Received \recd@te \kern3pt$\cdot$\kern3pt%
            Accepted \accd@te%
            \hfill%
            \d@i%
            \hfill%
            \if\relax\j@urnalcode\else           % skip if null journal
              \sffamily%
              \textit{\j@urnalname}
              (\j@urnalyear).
              \if\j@urnalcode\@A@ A\fi%          % Print Acta section letter
              \if\j@urnalcode\@B@ B\fi%
              \if\j@urnalcode\@C@ C\fi%
              \if\j@urnalcode\@D@ D\fi%
              \if\j@urnalcode\@E@ E\fi%
              \if\j@urnalcode\@F@ F\fi%
              \if\j@urnalcode\@J@\fi%
              \if\j@urnalcode\@M@\fi%
              \if\j@urnalcode\@S@\fi%
              \textbf{\v@lume},
              \f@rstpage\l@stpage
            \fi
          }
        }
      \fi
    }
  \fi
  \ifsingl@col%
  \else%
    \end{multicols}\singl@coltrue%
  \fi%
  \ifPstyl@%
  \else%
    \ifSh@rt\end{small}\fi%
    \ifC@nf\end{small}\fi%
  \fi%
  \ifsyn@p\unvbox128\fi                          % dump out synopsis
  \errorstopmode
  \if\relax\j@urnalfullname
    \message{Finished processing article}
  \else
    \message{Finished processing article for \j@urnalfullname}
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some typographic refinements:
% Smaller verbatim font inline
\def\verb{\relax\ifmmode\hbox\else\leavevmode\null\fi
  \bgroup
  \def\verbatim@font{\fontsize{8}{12pt}\selectfont\ttfamily}%
    \verb@eol@error \let\do\@makeother \dospecials
    \verbatim@font\@noligs
    \@ifstar\@sverb\@verb}
% and a similar but sloping version
\def\verbit{\relax\ifmmode\hbox\else\leavevmode\null\fi
  \bgroup
  \def\verbatim@font{\fontsize{8}{12pt}\selectfont\ttfamily\itshape}%
    \verb@eol@error \let\do\@makeother \dospecials
    \verbatim@font\@noligs
    \@ifstar\@sverb\@verb}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dictmacros.tex: macros for CIF dictionaries                                %
% -------------------------------------------------------------------------- %
% These macros were developed largely for the purpose of typesetting CIF     %
% dictionary chapters in International Tables Volume G. The LaTeX code for   %
% these chapters was generated automatically from the CIF dictionary source  %
% files using makedict.pl; some of the logic in that script compensates for  %
% shortcomings in the macros (for example where it is not known whether one  %
% or more examples follow, so that the default generated text is the         %
% inelegant "Example(s): "                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifIstyl@
% make all summation signs the same size as in textstyle
\let\Displ@ysum\sum
\gdef\sum{\textstyle\Displ@ysum}
\fi

\newcommand{\bigcifname}[1]{%
  {\ttfamily\bfseries%
  \fontsize{9.5}{10pt}\f@rsttrue\CIFNAME#1\end}%  % pass separate tokens
}
\newcommand{\smallcifname}[1]{%
  {\ttfamily\bfseries%
  \fontsize{7}{9pt}\f@rsttrue\CIFNAME#1\end}%  % pass separate tokens
}
\newcommand{\itcifname}[1]{%
  {\ttfamily\bfseries\itshape%
  \fontsize{8}{11pt}\f@rsttrue\CIFNAME#1\end}%  % pass separate tokens
}
\newcommand{\smallitcifname}[1]{%
  {\ttfamily\bfseries\itshape%
  \fontsize{7}{9pt}\f@rsttrue\CIFNAME#1\end}%  % pass separate tokens
}
% cifdefblock and boxedcifdefblock for tweaking
\gdef\defaultblockskip{\medskip}
\def\blockskip{\defaultblockskip}
\newenvironment{nobreakcifdefblock}%                    % CIF DICTIONARY DEFINITION
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}%
  \par\vspace*{-9pt}
  \par\noindent\begin{minipage}[t]{\colwidth}%
  \parindent=0pt\parskip=1pt%
}
{%                                               % End environment
  \end{minipage}\par%
  %\blockskip\goodbreak%
  \vskip 6pt plus6pt minus 6pt\goodbreak%
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi%
}
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-
\renewenvironment{cifdefblock}%                    % CIF DICTIONARY DEFINITION
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}%
  \par\vspace*{-9pt}
  \par\noindent\bgroup%
  \parindent=0pt\parskip=1pt%
}
{%                                               % End environment
  \egroup\par%
  \goodbreak
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi%
}
\newenvironment{bottomboxedcifdefblock}%               % BOXED CIFDIC ENTRY
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}
  \par \vskip3pt
  \par\noindent\begin{boxedminipage}[t]{\colwidth}
  \parindent=0pt\parskip=1pt
}
{%                                               % End environment
  \end{boxedminipage}\par%
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi
  %\blockskip\goodbreak
}
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-
\renewenvironment{boxedcifdefblock}%               % BOXED CIFDIC ENTRY
{%                                               % Begin new environment
  \def\cifdicrhead{\relax}
  \par \vskip3pt
  \par\noindent\begin{boxedminipage}[t]{\colwidth}
  \parindent=0pt\parskip=1pt
}
{%                                               % End environment
  \end{boxedminipage}%
  \ifx\relax\cifdicrhead\else\mark{\cifdicrhead}\fi
  \blockskip\goodbreak
}
%\renewenvironment{cifdefblock}{\parskip6pt\tolerance=9996}{}

\newif\ifckey\ckeytrue
\newif\ifcgrp\cgrptrue
\newif\ifnewcgl\newcgltrue
\newif\ifreplaced\replacedfalse % flags deprecated definitions
\newif\ifneedpoint\needpointfalse
\newif\ifneedfinalpoint\needfinalpointfalse
\newif\ifneedpar\needparfalse
\newif\ifneedrule\needruletrue  % need separator rule in category examples?

% The next line is rather mysterious. For some reason the way in which \_ is
% set up requires that it be instantiated in some hidden way like this:
% undoubtedly a subtle bug, but this provides a workaround for current
% dictionaries
% \gdef\RHUBARB{\smash{$\phantom{\_}$}}%
%   \RHUBARB% % hack - see above
\def\DATA#1{%
  \baselineskip10pt%
  \ckeytrue%
  \cgrptrue%
  \global\needruletrue%
  \gdef\MC{\relax}%
  \gdef\DITCon{\relax}%
  \needpointfalse%
  \needparfalse%
   \gdef\lidhead{\fontsize{7}{10}\selectfont {\ containing }}%
   \gdef\llchead{{\ifneedpoint{. }\fi\fontsize{7}{10}\selectfont%
      May match child data name(s): }}%
  \gdef\rihead{\fontsize{7}{10}\selectfont \par\noindent Related item(s):\par}%
  \gdef\lihead{\fontsize{7}{10}\selectfont \par\noindent%
    \textit{The following item(s) have an equivalent role in their respective categories:} }%
  \gdef\eghead{\fontsize{7}{10}\selectfont Example(s): \par}%
  \gdef\enumhead{\fontsize{7}{10}\selectfont The data value must be one of the following: \par}%
  \gdef\replacedhead{\fontsize{8}{10}\selectfont\bfseries\par%
  This definition has been superseded and is retained here %
   only for  archival purposes. Use instead }%
  \needfinalpointtrue%
}

%%%%% macros for DDL1 data names that have no DDL2 equivalent
\def\Dlistmember#1{\fontsize{7}{10}\selectfont \ifneedpoint{. }\else\par\fi%
  \strcmp{#1}{yes}\ifstringsequal{Appears in list}\needpointtrue\fi%
  \strcmp{#1}{both}\ifstringsequal{May appear in list}\needpointtrue\fi%
  }
\def\Dlistreference#1{\fontsize{7}{10}\selectfont\lidhead\smallcifname{#1}%
  \def\lidhead{, }\needpointtrue}
\def\Dlistmandatory#1{\fontsize{7}{10}\selectfont\strcmp{#1}{yes}%
  \ifstringsequal { as essential element of loop structure. }\needpointfalse%
  \else{. }\needpointfalse\fi}
\def\Dlistlevel#1{ at level #1}
\def\Dlistlinkchild#1{\llchead\smallcifname{#1}\def\llchead{{,} }\needpointtrue}
\def\Dlistlinkparent#1{\ifneedpoint{. }\fi%
  \fontsize{7}{10}\selectfont%
  { \textbf{Must} match parent data name \smallcifname{#1}. }%
  \needpointfalse}
\def\Dreplacedby#1{%
  \replacedhead\smallcifname{#1}\def\replacedhead{, }%
  \replacedtrue}

%%%%% macros for DDL2 data names

\def\blockdescription#1{#1}

\def\blockid#1{}

\long\def\categorydescription#1{\bgroup%
  \parindent0pt\parskip6pt\fontsize{10}{11}\selectfont%
   #1\par\egroup}

\def\Dcompliance#1{{\centerline{\it Version:  \bf #1}}\medskip}

\def\categoryid#1{\hfil{\uppercase{\textbf{#1}}}\hfil\par}
%\def\categoryname#1{\hfil{\cifname{#1}}\hfil\par}
\def\categoryname#1{\hfil{\textbf{#1}}\hfil\par}

\def\categorymandatorycode#1{ % 'whether category must be specified in a dict.'
        \strcmp{#1}{yes}\ifstringsequal{\par\fontsize{8}{10}\selectfont\textbf{Mandatory category.}}\fi
        \strcmp{#1}{no}\ifstringsequal\fi
}

\def\categorymethodid#1{#1}

\long\def\categoryexamplescase{\relax}

\long\def\categoryexamplesdetail#1{%
\begin{it}
    {\ifneedrule\smallskip\hrule\smallskip\fi%
      \noindent\fontsize{8}{10}\selectfont#1}%
\end{it}
      \global\needruletrue%
}

\def\categoryexamplesid#1{#1}

\def\categorygroupcategoryid#1{#1}

\def\categorygroupid#1{
   \ifcgrp{\par\noindent{\fontsize{7}{10}\selectfont
                    Category group(s): \smallcifname{#1}}\global\cgrpfalse}
   \else{\par\noindent{\fontsize{7}{10}\selectfont\hskip 55pt\smallcifname{#1}}}\fi
\baselineskip8pt
   }

\def\categorygrouplistid#1{
  \ifnewcgl%
  \medskip\hfil\textbf{Category groups}\hfil
  \par\global\newcglfalse%
  \fi%
  \par\noindent #1
}

\def\categorygrouplistparentid#1{} %{(parent #1):}

\def\categorygrouplistdescription#1{\par\qquad #1}
\def\categorygrouplistdescription#1{\parskip2pt\hfill\parbox[t]{64mm}{#1}}

\def\categorykeyid#1{#1}

\def\categorykeyname#1{
   \ifckey{\par\noindent{\fontsize{7}{10}\selectfont
             Category key(s): \smallcifname{#1}}\global\ckeyfalse}
   \else{\par\noindent{\fontsize{7}{10}\selectfont\hskip 48.4pt\smallcifname{#1}}}\fi
   }

\let\ttsl\relax
\def\dictionaryblockid#1{}

\def\dictionarytitle#1{\global\def\DDDname{{\let\tt=\tenbf\tt #1}}
  \centerline{\let\tt=\bf Dictionary name: {\bf #1}}}

\def\dictionaryversion#1{\par\centerline{Version: #1}\par}

\def\dictionaryhistoryrevision#1{{\hangindent=3pc\hangafter=1\parindent=2pc\obeylines\sevenpoint\it\qquad #1}}

\def\dictionaryhistoryupdate#1{{\sevenpoint\it\quad #1}}

\def\dictionaryhistoryupdateday#1{#1}

\def\dictionaryhistoryupdatemonth#1{#1}

\def\dictionaryhistoryupdateyear#1{#1}

\def\dictionaryhistoryversion#1{{\sevenpoint\it\par #1}}

\def\itemcategoryid#1{\raggedright\ifneedpoint.\needpointfalse\fi%
  \ifneedfinalpoint.\needfinalpointfalse\fi%
  \hfil $\phantom{0}$\penalty-100\hfill\smallcifname{[#1]}%
  \parfillskip0pt plus -1fil\par}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \itemmandatorycode is complex: we want to print a marginal * or (*):
% the marginhack macro generates a zero-size box following the method of
% Exercise 14.28 of The TeXBook
\def\strutdepth{\dp\strutbox}
\def\marginhack#1{\strut\vadjust{\kern-\strutdepth\specialbox{#1}}}
\def\specialbox#1{\vtop to \strutdepth{
\baselineskip\strutdepth
 \vss\llap{#1}\null}}

% The optional argument is not used, but is supplied (with a default) to
% ensure that the leading space is omitted from the body text if it starts
% on a new line after the environment declaration (which is usual)

\newcommand{\itemmandatorycode}[2][\relax]%
{\fontsize{9}{10}\selectfont%
   \strcmp{#2}{no}\ifstringsequal\fi%
   \strcmp{#2}{yes}\ifstringsequal{\marginhack{*}}\fi%
   \strcmp{#2}{implicit}\ifstringsequal{\marginhack{(*)}}\fi%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\itemname#1{\ifneedpar\par\fi\bigcifname{#1}\needpartrue}

\def\itemsubcategoryid#1{{\par\sevenpoint\let\tt=\rm Subcategory #1. }}

\def\itemaliasesaliasname#1{
   \ifx\needhead\relax{{\sid\headfont _\saveframename}}\let\needhead=\saveframename\else\fi
   \Dnname\goodbreak{\sevenpoint(#1)}\let\Dnname=\relax}

\def\itemaliasesaliasname#1{%
  \par\gdef\DAliasVers{\relax}
  \textit{\smallcifname{#1}}%
  }
\def\itemaliasesdictionary#1{%
  \fontsize{7}{9}\selectfont\ (\textit{#1}\DAliasVers)\par%
  }

\def\itemaliasesversion#1{%
  \gdef\DAliasVers{\fontsize{7}{9}\selectfont\ \textit{#1}}%
  }

\def\itemaliasesname#1{#1}

\def\itemdefaultname#1{#1}

\def\itemdefaultvalue#1{\ifneedpoint{. }\fi\eightrm{Where no value is given, the assumed {}
   value is \eighttt {`#1'}.}\needpointfalse}

\def\itemdependentdependentname#1{%
   \ifDDN{{\par\sevenpoint Forms a set with #1}}\DDNfalse%
   \else{{\sevenpoint, #1}}\fi%
   \needpointtrue%
   }

\def\itemdependentname#1{#1}

\long\def\itemdescriptiondescription#1{%
  \ifreplaced\ifneedfinalpoint.\fi\par\fontsize{9}{10}\selectfont\normalfont\itshape #1\par%
  \else%
  \par\fontsize{10}{11}\selectfont #1\par%
  \fi\needfinalpointfalse}

\def\itemdescriptionname#1{#1}

\def\itemenumerationdefault#1{\fontsize{7}{10}\selectfont%
  \ifneedpoint{. }\fi{Where no value is given, the assumed  value is
  `\texttt {#1}'.}\needpointfalse}

\def\itemenumerationdetail#1{{\fontsize{8}{10}\selectfont \hfill\parbox[t]{220pt}{\fontsize{8}{9}\selectfont\everypar{\hangindent=6pt\hangafter=1}%
\leavevmode#1\par}}%
  \parskip2pt\par\needpointfalse}

\def\wideitemenumerationdetail#1{{\fontsize{8}{10}\selectfont \hfill\parbox[t]{174pt}{\fontsize{8}{9}\selectfont\everypar{\hangindent=6pt\hangafter=1}%
\leavevmode#1\par}}%
  \parskip2pt\par\needpointfalse}

\def\wideritemenumerationdetail#1{{\fontsize{8}{10}\selectfont \hfill\parbox[t]{168pt}{\fontsize{8}{9}\selectfont\everypar{\hangindent=6pt\hangafter=1}%
\leavevmode#1\par}}%
  \parskip2pt\par\needpointfalse}

\def\itemenumerationname#1{#1}

\def\itemenumerationvalue#1{\ifneedpoint{. }\fi\parskip0pt{\par\noindent%
  \fontsize{8}{10}\normalfont\selectfont%
  \enumhead%
  \fontsize{8}{10}\ttfamily\selectfont%
   \quad\parbox[t]{78pt}{\rlap{#1}}}%
  \gdef\enumhead{\relax}\needpointfalse}

%%% example: put in a box for intro, else print in quotes
\long\def\itemexamplescase#1{\ifneedpoint{. }\needpointfalse\fi%
    \def\setupverbatim{\ttfamily%
      \parskip0pt\def\par{\endgraf\leavevmode}\obeylines\obeyspaces}%
  \eghead`{\setupverbatim\hbox{#1}}'\def\eghead{, }\needfinalpointtrue}
\long\def\itemexamplescasetext{\ifneedpoint{. }\needpointfalse\fi%
  \eghead\par\def\eghead{\relax}}

%%% example detail
\long\def\itemexamplesdetail#1{%
\strcmp{#1}{.}\ifstringsequal\else{\fontsize{7}{10}\selectfont\ (#1)}\fi}

\def\itemexamplesname#1{#1}

\def\itemlinkedchildname#1{\lihead\par\noindent\textit{\smallcifname{#1}}\def\lihead{, }\needpointtrue}

\def\itemlinkedparentname#1{#1}

\def\itemrangemaximum#1{{\eightrm Maximum allowed value: #1. }}

\def\itemrangeminimum#1{{\eightrm Minimum allowed value: #1. }}

\def\itemrangename#1{#1}

\def\itemrange#1{\ifneedpoint{. }\needpointfalse\fi%
\fontsize{7}{9}\selectfont\par\noindent
The permitted range is #1. }

\def\itemrelatedfunctioncode#1{\space(#1)\needpointtrue}

\def\itemrelatedname#1{#1}

\def\itemrelatedrelatedname#1{\rihead\smallcifname{#1}\def\rihead{,\break}\needpointtrue}

\def\itemstructurecode#1{\ifneedpoint{. }\needpointfalse\fi{\eightpoint\par Structure: #1. }}

\def\itemstructurename#1{#1}

\def\itemstructurelistcode#1{#1}

\def\itemstructurelistdimension#1{#1}

\def\itemstructurelistindex#1{#1}

\def\itemtypecode#1{\hfill\fontsize{8}{10}\selectfont(\textit{#1}\DITCon)}

\def\itemtypename#1{#1}

\def\itemtypeconditionscode#1{%
  \strcmp{#1}{esd}\ifstringsequal
    \gdef\DITCon{\fontsize{8}{10}\selectfont\textit{, su}}%
  \else
    \gdef\DITCon{\fontsize{8}{10}\selectfont\textit{, #1}}%
  \fi
  }

\def\itemtypeconditionsname#1{#1}

\def\itemtypelistcode#1{#1}

\def\itemtypelistconstruct#1{#1}

\def\itemtypelistdetail#1{#1}

\def\itemtypelistprimitivecode#1{#1}

\def\itemunitscode#1{\ifneedpoint{. }\needpointfalse\fi{\eightrm\let\tt=\rm Units are #1. }}

\def\itemunitsname#1{#1}

\def\itemunitsconversionfactor#1{#1}

\def\itemunitsconversionfromcode#1{#1}

\def\itemunitsconversionoperator#1{#1}

\def\itemunitsconversiontocode#1{#1}

\def\itemunitslistcode#1{#1}

\def\itemunitslistdetail#1{#1}

\def\methodid#1{#1}

\def\methodname#1{#1}

\def\methodlistcode#1{#1}

\def\methodlistdetail#1{#1}

\def\methodlistid#1{#1}

\def\methodlistinline#1{#1}

\def\methodlistlanguage#1{#1}

\def\subcategoryid#1{
   \ifnewscgl\medskip{\bf Subcategories in this dictionary}\par\newscglfalse\fi
   \par{\let\tt=\it\tt #1}}

\def\subcategorymethodid#1{#1}

\def\subcategoryexamplescase#1{#1}

\def\subcategoryexamplesdetail#1{#1}

\def\subcategoryexamplesid#1{#1}

\newskip\currentlineskip
\def\breakblock{\currentlineskip=\baselineskip%
  \end{cifdefblock}%
  \goodbreak
  \begin{cifdefblock}%
  \baselineskip=\currentlineskip}

\def\breakboxedblock{\let\currentlineskip\baselineskip%
  \end{boxedcifdefblock}%
  \goodbreak
  \begin{boxedcifdefblock}%
  \global\needrulefalse%
  \global\cgrptrue%
  \global\ckeytrue%
  \baselineskip\currentlineskip}

\def\breakbottomboxedblock{\let\currentlineskip\baselineskip%
  \end{bottomboxedcifdefblock}%
  \vspace*{0pt}%
  \goodbreak
  \vspace*{-9pt}%
  \begin{boxedcifdefblock}%
  \global\needrulefalse%
  \global\cgrptrue%
  \global\ckeytrue%
  \baselineskip\currentlineskip}

\def\breaklongbottomboxedblock{\let\currentlineskip\baselineskip%
  \end{bottomboxedcifdefblock}%
  \vspace*{0pt}%
  \goodbreak
  \vspace*{-9pt}%
  \begin{bottomboxedcifdefblock}%
  \global\needrulefalse%
  \global\cgrptrue%
  \global\ckeytrue%
  \baselineskip\currentlineskip}

\overfullrule=0pt

\newskip\interblockskip
\newskip\defaultinterblockskip
\interblockskip=6pt plus12pt minus2pt
\defaultinterblockskip=6pt plus12pt minus2pt
\def\tilda{\lower.5ex\hbox{\char'176}}
\def\carrot{{\font\symx=cmtt8\symx\char'136}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ---------------------- work in progress ------------------------------------
% This is where new or modified macros may be placed for testing.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newcommand{\url}[1]{%
% {\fontsize{9}{11}\selectfont #1}%
% }

% For testing when Nicola has completed Vol. A1 (smaller verbatim font inline)
\def\verb{\relax\ifmmode\hbox\else\leavevmode\null\fi
  \bgroup
  \def\verbatim@font{\fontsize{8}{12pt}\selectfont\ttfamily}%
    \verb@eol@error \let\do\@makeother \dospecials
    \verbatim@font\@noligs
    \@ifstar\@sverb\@verb}
% and a similar but sloping version
\def\verbit{\relax\ifmmode\hbox\else\leavevmode\null\fi
  \bgroup
  \def\verbatim@font{\fontsize{8}{12pt}\selectfont\ttfamily\itshape}%
    \verb@eol@error \let\do\@makeother \dospecials
    \verbatim@font\@noligs
    \@ifstar\@sverb\@verb}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
