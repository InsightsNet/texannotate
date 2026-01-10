%%
%% This is file `rmmcart.cls' based on 'amsart.cls'
%%% ====================================================================
\NeedsTeXFormat{LaTeX2e}% LaTeX 2.09 can't be used (nor non-LaTeX)
[1994/12/01]% LaTeX date must December 1994 or later
% \ProvidesPackage{rmmcart}[2000/01/01 The new millenium]
% \ProvidesClass{rmmcart}[2005/10/02 v1.00]
\ProvidesClass{rmmcart}[2014/07/19 v1.61]

% \input amsart.cls
\LoadClass{amsart}
\usepackage{amsthm}
\usepackage{endnotes}
% \usepackage{amsrefs}

\newdimen\trimht
\newdimen\trimwd
\trimht=9in
\trimwd=6in

\newdimen\trimrulethickness	\trimrulethickness=0.4pt
\newdimen\trimrulelength	\trimrulelength=1pc

\newcommand{\ulap}[1]{\vbox to 0pt{\vss#1}}
\newcommand{\dlap}[1]{\vbox to 0pt{#1\vss}}

\newcommand{\topcornerregister}{%
  \dlap{\hbox to \trimwd{%
    \rlap{\vrule height 0pt depth \trimrulethickness width \trimrulelength}%
    \rlap{\vrule height 0pt depth \trimrulelength width \trimrulethickness}%
    \hfil
    \llap{\vrule height 0pt depth \trimrulethickness width \trimrulelength}%
    \llap{\vrule height 0pt depth \trimrulelength width \trimrulethickness}%
    }}%
  }

\newcommand{\botcornerregister}{%
  \ulap{\hbox to \trimwd{%
    \rlap{\vrule height \trimrulethickness width \trimrulelength}%
    \rlap{\vrule height \trimrulelength width \trimrulethickness}%
    \hfil
    \llap{\vrule height \trimrulethickness width \trimrulelength}%
    \llap{\vrule height \trimrulelength width \trimrulethickness}%
    }}%
  }

\newcommand{\topregister}{}
\newcommand{\broadsidetopregister}{}
\newcommand{\botregister}{}
\newcommand{\broadsidebotregister}{}
\newcommand{\cornermarks}{
  \renewcommand{\topregister}{\topcornerregister}
  \renewcommand{\broadsidetopregister}{\topcornerregister}
  \renewcommand{\botregister}{\botcornerregister}
  \renewcommand{\broadsidebotregister}{\botcornerregister}
  }
\newcommand{\nocornermarks}{
  \renewcommand{\topregister}{}
  \renewcommand{\broadsidetopregister}{}
  \renewcommand{\botregister}{}
  \renewcommand{\broadsidebotregister}{}
  }

\cornermarks
\newbox\trimbox@
\setbox\trimbox@\vbox to \trimht{%
    \topregister
    \vfil
    \botregister
    }
\newcommand{\showtrim}{\showbox\trimbox@}
\newcommand{\trimmarks}{\dlap{\copy\trimbox@}}
\newcommand{\notrimmarks}{\renewcommand{\trimmarks}{}}


\renewcommand{\@outputpage}{%
  \begingroup           % the \endgroup is put in by \aftergroup
    \let \protect \noexpand
    \@resetactivechars
    \@parboxrestore
    \shipout \vbox{%
      \set@typeset@protect
      \aftergroup \endgroup
      \aftergroup \set@typeset@protect
                                  % correct? or just restore by ending
                                  % the group?
    \if@specialpage
      \global\@specialpagefalse\@nameuse{ps@\@specialstyle}%
    \fi
    \if@twoside
      \ifodd\count\z@ \let\@thehead\@oddhead \let\@thefoot\@oddfoot
           \let\@themargin\oddsidemargin
      \else \let\@thehead\@evenhead
         \let\@thefoot\@evenfoot \let\@themargin\evensidemargin
      \fi
    \fi
    \reset@font
    \normalsize
    \normalsfcodes
    \let\label\@gobble
    \let\index\@gobble
    \let\glossary\@gobble
    \baselineskip\z@skip \lineskip\z@skip \lineskiplimit\z@
      \@begindvi
      \trimmarks
      \vskip \topmargin
      \moveright\@themargin \vbox {%
        \setbox\@tempboxa \vbox to\headheight{%
          \color@hbox
            \normalcolor
            \hb@xt@\textwidth{\@thehead}%
          \color@endbox
          \vss
          }%                        %% 22 Feb 87
        \dp\@tempboxa \z@
        \box\@tempboxa
        \vskip \headsep
        \box\@outputbox
        \baselineskip\footskip
        \color@hbox
          \normalcolor
          \hb@xt@\textwidth{\@thefoot}%
        \color@endbox
        }%
      }%
    % \global\let\if@newlist\@@if@newlist   %% 2007 Oct 19: No clue why this was here.
                                            %%              It kept producing warnings about \if@newlist
                                            %%              being undefined, so I commented it out.
    \global \@colht \textheight
    \stepcounter{page}%
    \let\firstmark\botmark
}

\def\commby#1{\def\@commby{Communicated by #1}}

\renewcommand{\maketitle}{\par
  \@topnum\z@ % this prevents figures from falling at the top of page 1
  %\@setcopyright  % we do this in a footnote
  \thispagestyle{firstpage}% this sets first page specifications
  \uppercasenonmath\shorttitle
  \ifx\@empty\shortauthors \let\shortauthors\shorttitle
  \else \andify\shortauthors
  \fi
  \@maketitle@hook
  \begingroup
  \@maketitle
  \toks@\@xp{\shortauthors}\@temptokena\@xp{\shorttitle}%
  \toks4{\def\\{ \ignorespaces}}% defend against questionable usage
  \edef\@tempa{%
    \@nx\markboth{\the\toks4
      \@nx\MakeUppercase{\the\toks@}}{\the\@temptokena}}%
  \@tempa
  \endgroup
  \c@footnote\z@
  \def\do##1{\let##1\relax}%
  \do\maketitle \do\@maketitle \do\title \do\@xtitle \do\@title
  \do\author \do\@xauthor \do\address \do\@xaddress
  \do\email \do\@xemail \do\curraddr \do\@xcurraddr
  \do\commby \do\@commby
  \do\dedicatory \do\@dedicatory \do\thanks \do\thankses
  \do\keywords \do\@keywords \do\subjclass \do\@subjclass
}
\renewcommand{\@maketitle}{%
  \normalfont\normalsize
  \let\@makefnmark\relax  \let\@thefnmark\relax
  \ifx\@empty\@subjclass\else \@footnotetext{\@setsubjclass}\fi
  \ifx\@empty\@keywords\else \@footnotetext{\@setkeywords}\fi
  \ifx\@empty\thankses\else \@footnotetext{%
    \def\par{\let\par\@par}\@setthanks}\fi
  \ifx\@empty\@date\else \@footnotetext{\@setdate}\fi
  \@footnotetext{\doicopyright}%
  \@mkboth{\@nx\shortauthors}{\@nx\shorttitle}%
  \global\topskip22\p@\relax % 5.5pc   "   "   "     "     "  % rmmc change
  \@settitle
  \ifx\@empty\authors \else \@setauthors \fi
  \ifx\@empty\@commby
  \else
  \ifx\@jiepublisherpubid\@publisherpubid  % only use "Communicated by" in JIE
    \baselineskip18\p@
    \vtop{\centering{\footnotesize\@commby\@@par}%
      \global\dimen@i\prevdepth}\prevdepth\dimen@i
    \fi \fi
  \ifx\@empty\@dedicatory
  \else
    \baselineskip18\p@
    \vtop{\centering{\footnotesize\itshape\@dedicatory\@@par}%
      \global\dimen@i\prevdepth}\prevdepth\dimen@i
  \fi
  \@setabstract
  \normalsize
  \if@titlepage
    \newpage
  \else
    \dimen@12\p@ \advance\dimen@-\baselineskip
    \vskip\dimen@\relax
  \fi
} % end \@maketitle

\def\@setabstracta{%
  \ifvoid\abstractbox
  \else
  % \skip@20\p@ \advance\skip@-\lastskip
  % \advance\skip@-\baselineskip \vskip\skip@
  \box\abstractbox
  \prevdepth\z@ % because \abstractbox is a vtop
  \fi}

\footnotesep=0pt
\def\footnoterule{\kern-.4\p@
  \hrule\@width 2in\kern11\p@\kern-\footnotesep}
\long\def\@footnotetext#1{%
  \insert\footins{%
    \normalfont\footnotesize
    \interlinepenalty\interfootnotelinepenalty
    \splittopskip\footnotesep \splitmaxdepth \dp\strutbox
    \floatingpenalty\@MM \hsize\columnwidth
    \@parboxrestore \parindent\normalparindent \sloppy
    \protected@edef\@currentlabel{%
      \csname p@footnote\endcsname\@thefnmark}%
    \@makefntext{%
      \rule\z@\footnotesep\advance\baselineskip-2pt\ignorespaces#1\unskip\strut\par}}}

\renewcommand{\keywordsname}{Keywords and phrases}

\renewcommand{\subjclassname}{%
  \textup{1991} {\rm AMS \itshape Mathematics subject classification}}
\@xp\let\csname subjclassname@1991\endcsname \subjclassname
\@namedef{subjclassname@2000}{%
  \textup{2000} {\rm AMS \itshape Mathematics subject classification}}
\@namedef{subjclassname@2010}{%
  \textup{2010} {\rm AMS \itshape Mathematics subject classification}}

\renewcommand{\@settitle}{\begin{center}%
  \baselineskip12\p@\relax                 % rmmc change
  \bfseries\uppercasenonmath\@title
  \@title
  \end{center}%
}

\renewcommand{\@setauthors}{%
  \begingroup
  \trivlist
  \centering\footnotesize \@topsep26\p@\relax
  \advance\@topsep by -\baselineskip
  \item\relax
  \andify\authors
  \def\\{\protect\linebreak}%
  \MakeUppercase{\authors}%
  \endtrivlist
  \endgroup
}

\renewcommand{\author}[2][]{%
  \ifx\@empty\authors
    \gdef\authors{#2}%
  \else
    \g@addto@macro\authors{\and#2}%
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
\edef\author{\@nx\@dblarg
    \@xp\@nx\csname\string\author\endcsname}
\let\shortauthors\@empty \let\authors\@empty
\newif\ifresetcontrib \resetcontribfalse
\renewcommand\contrib[2][]{%
  \def\@tempa{#1}%
  \ifx\@empty\@tempa
  \else
    \ifresetcontrib \@xcontribs
    \else \global\resetcontribtrue
    \fi
  \fi
  \ifx\@empty\contribs
    \gdef\contribs{#1 #2}%
  \else
    \g@addto@macro\contribs{\and#1 #2}%
  \fi
  \@wraptoccontribs{#1}{#2}%
}
\def\wraptoccontribs#1#2{}
\def\@xcontribs{%
  \author@andify\contribs
  \ifx\@empty\xcontribs
    \xdef\xcontribs{\contribs}%
  \else
    \xdef\xcontribs{\xcontribs, \contribs}%
  \fi
  \let\contribs\@empty
}
\let\contribs\@empty \let\xcontribs\@empty \let\toccontribs\@empty
\let\addresses\@empty \let\thankses\@empty
\renewcommand{\address}[2][]{\g@addto@macro\addresses{\address{#1}{#2}}}
\renewcommand{\curraddr}[2][]{\g@addto@macro\addresses{\curraddr{#1}{#2}}}
\renewcommand{\email}[2][]{\g@addto@macro\addresses{\email{#1}{#2}}}
\renewcommand{\urladdr}[2][]{\g@addto@macro\addresses{\urladdr{#1}{#2}}}


% \def\enddoc@text{\ifx\@empty\@translators \else\@settranslators\fi
%    \ifx\@empty\addresses \else\@setaddresses\fi}
%    \AtEndDocument{\enddoc@text}

\def\curraddrname{{\itshape Current address}}
\def\emailaddrname{{\bf Email address}}
\def\urladdrname{{\itshape URL}}
\renewcommand{\@setaddresses}{\par
  \nobreak \begingroup
  \footnotesize
  \parskip\z@
  \def\author##1{\nobreak\addvspace\bigskipamount}%
  \def\\{\unskip, \ignorespaces}%
  \interlinepenalty\@M
  \def\address##1##2{\begingroup
    \par\addvspace\bigskipamount\noindent
    \@ifnotempty{##1}{(\ignorespaces##1\unskip) }%
    {\scshape\ignorespaces##2}\par\endgroup}%
  \def\curraddr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\noindent\curraddrname
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      ##2\par}\endgroup}%
  \def\email##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\noindent\emailaddrname
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      \rmfamily\bf##2\par}\endgroup}%
  \def\urladdr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\noindent\urladdrname
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      \rmfamily##2\par}\endgroup}%
  \addresses
  \endgroup
}

\renewcommand{\ps@firstpage}{\ps@plain
  \def\@oddfoot{\normalfont\normalsize \hfil\thepage\hfil
     \global\topskip\normaltopskip}%
  \let\@evenfoot\@oddfoot
  \def\@oddhead{\@serieslogo\hss}%
  \let\@evenhead\@oddhead % in case an article starts on a left-hand page
}
\renewcommand{\ps@plain}{\ps@empty
  \def\@oddfoot{\normalfont\normalsize \hfil\thepage\hfil}%
  \let\@evenfoot\@oddfoot}
\renewcommand{\ps@headings}{\ps@empty
  \def\@evenhead{%
    \setTrue{runhead}%
    \normalfont\footnotesize
    \rlap{\normalsize\thepage}\hfil \leftmark{}{}\hfil}%
  \def\@oddhead{%
    \setTrue{runhead}%
    \normalfont\footnotesize \hfil
    \rightmark{}{}\hfil \llap{\normalsize\thepage}}%
  \let\@mkboth\markboth
}


% adjusted to \@issueinfo
\renewcommand{\article@logo}{%
  \if@genericstyle\else
  \set@logo{%
    \let\\\newline
    % \expandafter\uppercase\expandafter{\publname}%
    % \ifx\@empty\currentvolume
    % \else \newline\volinfo, \pageinfo
    % \fi
    \@issueinfo
    %% rmmc change
    %% comment out next two lines
    % \newline \@PII
    % \ifx\@empty\@dateposted \else \@setdateposted\fi
  }\fi
}

\renewenvironment{abstract}{%
  \ifx\maketitle\relax
    \ClassWarning{\@classname}{Abstract should precede
      \protect\maketitle\space in AMS documentclasses; reported}%
  \fi
  \global\setbox\abstractbox=\vtop \bgroup
    \normalfont\Small\advance\baselineskip\m@ne\p@
    \list{}{\labelwidth\z@
      \leftmargin3.25pc \rightmargin\leftmargin
      \listparindent0.75pc \itemindent0.75pc
      \parsep\z@ \@plus\p@
      \advance\spaceskip 0.333em plus 0.3em\relax
      \advance\xspaceskip 0.5em plus 0.3em\relax
      % \hyphenpenalty\maxdimen
      \let\fullwidthdisplay\relax
    }%
    \item[\hskip\labelsep\expandafter\uppercase\expandafter{\abstractname}.]%
}{%
  \endlist\egroup
  \ifx\@setabstract\relax \@setabstracta \fi
}

\def\part{\@startsection{part}{0}%
  \z@{\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\bfseries\raggedright}}
\def\specialsection{\@startsection{section}{1}%
  \z@{\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\centering}}
\def\section{\@startsection{section}{1}%
  {0.75em}{9pt plus 2.5pt}{-.5em}%
%  {0.75em}{.7\linespacing\@plus0.05\linespacing}{-.5em}%
%  {0.75em}{.4\linespacing\@plus0.05\linespacing}{-.5em}%
%  {0.5em}{.7\linespacing\@plus\linespacing}{-0.5pc}%
  {\normalfont\bfseries}}
% \def\thesection{{\bf\arabic{section}}}
\def\@secnumfont{\bfseries}
\def\thesection{\arabic{section}}
\def\subsection{\@startsection{subsection}{2}%
  \z@{.5\linespacing\@plus.7\linespacing}{-.5em}%
  % {\normalfont\bfseries}}  % remove bold per Linda's request, Aug 2013
  {\normalfont\bfseries}}
\def\subsubsection{\@startsection{subsubsection}{3}%
  \z@{.5\linespacing\@plus.7\linespacing}{-.5em}%
  % {\normalfont\itshape}}  % remove italic per Linda's request, Aug 2013
  {\normalfont}}
\def\paragraph{\@startsection{paragraph}{4}%
  \z@\z@{-\fontdimen2\font}%
  \normalfont}
\def\subparagraph{\@startsection{subparagraph}{5}%
  \z@\z@{-\fontdimen2\font}%
  \normalfont}
\def\appendix{\par\c@section\z@ \c@subsection\z@
   \let\sectionname\appendixname
   \def\thesection{\Alph{section}}
   \@startsection{section}{1}%
    {0.75em}{.4\linespacing\@plus0.05\linespacing}{-.5em}%
  {\normalfont\mdseries}}
\def\appendixname{}

\def\@@adjustvertspacing{%
  \bigskipamount1\baselineskip plus.3\baselineskip
  \medskipamount\bigskipamount \divide\medskipamount\tw@
  \smallskipamount\medskipamount \divide\smallskipamount\tw@
  % \abovedisplayskip0.9\bigskipamount
  \abovedisplayskip=4.2\p@ plus 2\p@  % rmmc reduce base amount and make stretch less than section
  \abovedisplayskip=6.2\p@ plus 2\p@  % adjust per Linda's remarks, Aug 2013
  \belowdisplayskip \abovedisplayskip
  % \abovedisplayshortskip\abovedisplayskip          % July 2014.  These lines set \abovedisplayshortskip to 0pt and consequently also \belowdisplayshortskip.
  % \advance\abovedisplayshortskip-\abovedisplayskip % We adjust \belowdisplayshortskip to agree with amsppt.sty.
  % \belowdisplayshortskip\abovedisplayshortskip
  \abovedisplayshortskip=0\p@
  \belowdisplayshortskip\abovedisplayskip
  % \advance\belowdisplayshortskip 1\smallskipamount
  \jot\baselineskip \divide\jot 4 \relax
}

\newenvironment{labeleditemize}{%
  \setlength\leftmargini{0pt}
  \setlength{\parindent}{0pt}
  \setlength{\listparindent}{0pt}
%  \setlength{\labelwidth}{-10pt}
  \ifnum\@itemdepth>3 \@toodeep
  \else \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list{\csname\@itemitem\endcsname}%
%    {\def\makelabel##1{\hss\llap{\upshape##1}}}%
    {\def\makelabel##1{\hbox{\upshape##1}}}%
  \fi
}{%
  \endlist
}
%% \renewcommand{\descriptionlabel}[1]{\hspace\labelsep \upshape\bfseries #1:}
\renewenvironment{description}{\list{}{%
  \advance\leftmargini6\p@ \itemindent-12\p@
  \labelwidth\z@ \let\makelabel\descriptionlabel}%
  }{
  \endlist
}

% Add some vertical space around the tag
\def\tagform@#1{\maketag@@@{(\ignorespaces\vrule height 1.5\ht\Mathstrutbox@ depth \ht\Mathstrutbox@ width\z@#1\unskip\@@italiccorr)}}

% 3 Jul 2014
% Figure captions should not be set to a narrower width
\captionindent\z@

\theoremstyle{plain} % default style for declarations
% Add a hook to the \document macro so that we can adjust package settings which are loaded
% after the rmmc macros
\let\@rmmcdocument\document
\def\document{\@rmmcdocument
  \theoremstyle{plain}
  \ifx\theorem\undefined \newtheorem{theorem}{Theorem}\fi
  \ifx\proposition\undefined \newtheorem{proposition}[theorem]{\bf Proposition}\fi
  \ifx\lemma\undefined\newtheorem{lemma}{Lemma}\fi
  \ifx\corollary\undefined\newtheorem{corollary}{Corollary}\fi
  \theoremstyle{remark}
  \ifx\example\undefined\newtheorem{example}{Example}\fi
  \ifx\remark\undefined\newtheorem{remark}{Remark}\fi
  \theoremstyle{definition}
  \ifx\definition\undefined\newtheorem{definition}{\bf Definition}\fi
  \ifx\assumption\undefined\newtheorem{assumption}{\bf Assumption}\fi
  \@documenthook}
\newtoks\@@dochooktoks
\def\@documenthook{\the\@@dochooktoks}
\def\addtoDocHook#1{\expandafter\@@dochooktoks\expandafter{\the\@@dochooktoks#1}}


% Endnotes
% The package was loaded above
%\addtodoctoks{%
  \def\notesname{Endnotes}%
  \def\enoteheading{\vskip14\p@
    \begingroup\centering
    \normalfont\normalsize\expandafter\uppercase\expandafter{\notesname}\endgraf
    \endgroup}%
  % \hbox{$^\theenmark$}
  % \def\@makeenmark{{\footnotesize\@theenmark\enspace}}%
%  }

\def\doendnotes{
  \begingroup
  \renewcommand{\enotesize}{\normalsize}
  \theendnotes
  \endgroup
}


\addtoDocHook{\@@adjustvertspacing}


\def\@cite#1#2{{%
  \m@th\upshape\bfseries[{#1\if@tempswa, {\rm #2}\fi}]}}
\def\@biblabel#1{\@ifnotempty{#1}{#1.}}


\bibliographystyle{plain}
\renewenvironment{thebibliography}[1]{%
  \vskip4\p@
  \begin{center}
  \normalfont\normalsize\expandafter\uppercase\expandafter{\refname}%
  \end{center}
  \normalfont\footnotesize\labelsep .5em\relax
  \renewcommand\theenumiv{{\bf\arabic{enumiv}}}%
  \list{\@biblabel{\theenumiv}}{\settowidth\labelwidth{\@biblabel{#1}}%
    \leftmargin\z@\labelwidth-\labelwidth\labelsep0.5em\usecounter{enumiv}\itemsep2pt}%
  \sloppy \clubpenalty\@M \widowpenalty\clubpenalty
  \sfcode`\.=\@m \parindent2pc
  \nobreak
}{%
  \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

%% \addtoDocHook{%
%% \renewenvironment{bibdiv}{%
%%   \vskip4\p@
%%   \begin{center}
%%   \normalfont\normalsize\expandafter\uppercase\expandafter{\refname}%
%%   \end{center}
%% }{%
%%   \endlist
%% }}


\def\vspace@{\def\vspace##1{\crcr\noalign{\vskip##1\relax}}}
\def\multilimits@{\bgroup\vspace@\Let@
 \baselineskip\fontdimen10 \scriptfont\tw@
 \advance\baselineskip\fontdimen12 \scriptfont\tw@
 \lineskip\thr@@\fontdimen8 \scriptfont\thr@@
 \lineskiplimit\lineskip
 \vbox\bgroup\ialign\bgroup\hfil$\m@th\scriptstyle{##}$\hfil\crcr}
\def\Sb{_\multilimits@}
\def\endSb{\crcr\egroup\egroup\egroup}

\def\tagform@#1{\maketag@@@ {(\ignorespaces \vrule height 1.0\ht \Mathstrutbox@ depth \dp \Mathstrutbox@ width\z@ #1\unskip \@@italiccorr )}}
\newcommand{\lbreak}{\par\vskip12pt\relax}

% 2014 Feb 17/v1.51  pulled this def in to adjust indentation and theorem preskip
% Note the \theorempreskipamount is undefined, contrary to the LateX Companion and its apparent
% use below
\def\th@plain{%
  % \def\thm@indent{\hskip\parindent}% regular parindent % 3 Jul 2014; not sure why this was set to be non-zero
  \def\thm@indent{\hskip\z@}%
%%  \thm@headfont{\bfseries}% heading font is bold
%%  \thm@notefont{}% same as heading font
%%  \thm@headpunct{.}% add period after heading
%%  \let\thm@swap\@gobble
  \thm@preskip\bigskipamount
%%  \thm@postskip\theorempreskipamount
  \itshape % body font
}

% This macro is used for new theorem environments, so should be consistent (4 Jul 2014) with the settings above
\def\thm@space@setup{%
%  \thm@preskip=\topsep \thm@postskip=\thm@preskip
  % rmmc   reduce base and make stretch a little more than abovedisplayskip
  \thm@preskip\bigskipamount \thm@postskip=\thm@preskip
}

% 4 Jul 2014: Added specification of \thm@preskip
\def\th@definition{%
  \thm@preskip\bigskipamount
  \normalfont % body font
}

% 4 Jul 2014: Changed specification of \thm@preskip
\def\th@remark{%
  \thm@headfont{\itshape}%
  \normalfont % body font
  % \thm@preskip\topsep \divide\thm@preskip\tw@
  \thm@preskip\bigskipamount
  \thm@postskip\thm@preskip
}


% Brought in for v1.51 to cause the Proof header to indent.
\renewenvironment{proof}[1][\proofname]{\par
  \pushQED{\qed}%
  \normalfont \topsep6\p@\@plus6\p@\relax
  \trivlist
  \item[\hskip1.4\parindent
        \itshape
    #1\@addpunct{.}]\ignorespaces
}{%
  \popQED\endtrivlist\@endpefalse
}

% 4 Jul 2014: added these in an attempt to get latex to break lines containing math more gracefully (as in our plain macros).
\pretolerance 400
\tolerance 800
\hbadness 10001
\vbadness 10001
\clubpenalty 1000
\widowpenalty 1000
\brokenpenalty 100

\addtoDocHook{\tolerance 800\relax}

% 3 Jul 2014 Modified definition to remove serial comma
% \def\@andlistb#1#2#3#4#5\and{\@ifempty {#5}{\@andlistc {#2#4}}{\@andlistc {#1#4}\@andlistb {#1}{#3}{#3}{#5}}}
\def\@andlistb#1#2#3#4#5\and{\@ifempty {#5}{\@andlistc {#2#4}}{\@andlistc {#1#4}\@andlistb {#1}{#2}{#3}{#5}}}




\def\issueinfo#1{\def\@issueinfo{\ignorespaces#1\unskip}}
\def\pubyear#1{\def\@pubyear{\ignorespaces#1\unskip}}

\def\doipublisherid#1{\def\@doipublisherid{\ignorespaces#1\unskip}}
\doipublisherid{xx.xxx}
\def\copyrightholder#1{\def\@copyrightholder{\ignorespaces#1\unskip}}
\copyrightholder{Rocky Mountain Mathematics Consortium}
\def\publisherpubid#1{\def\@publisherpubid{\ignorespaces#1\unskip}}
\publisherpubid{PUBID}
\def\volno#1{\def\@volno{#1}}
\volno{0}
\def\volissno#1{\def\@volissno{#1}}
\volissno{0}
\newcommand{\volinfo}{%
  Volume \@volno, Number \@volissno, \@pubyear
}
\def\@jiepublisherpubid{\ignorespaces JIE\unskip}

\newcount\@startpage
\def\startpage#1{\@startpage#1\relax\pageno\@startpage}
\let\@copyrightyear\relax
\def\copyrightyear#1{\def\@copyrightyear{#1}}
\def\doicopyright{%\spaceskip1pt plus 10em minus 5em
  % \vskip4\p@
  \if@genericstyle\else
  \leavevmode\hbox{}\kern-\parindent\tiny
   DOI:\@doipublisherid/\@publisherpubid-\@pubyear-\@volno-\@volissno-\thepage
   \hskip1em plus 10em minus 5em Copyright
   \copyright \ifx\@copyrightyear\relax\@pubyear\else\@copyrightyear\fi\ \@copyrightholder\hskip-\parfillskip\hbox{}\fi
}


\topmargin=0.75in
\headheight=12pt
\headsep=24pt         % 17 Feb 2014/v 1.51  increased to 24pt from 18pt
\advance\headsep -3pt % so that baseline-of-running-head to top-of-text is about 2pc
%\footskip=0.333in
\footskip=1.7pc
\textheight=6.5in \topskip=10pt
\textwidth=4.25in
\parskip=1.0ex plus 0.5pt

\oddsidemargin0.875in
\evensidemargin\oddsidemargin

\def\calclayout{\advance\textheight -\headheight
  \advance\textheight -\headsep
  \oddsidemargin0.875in
  \evensidemargin\oddsidemargin
  \topmargin\paperheight \advance\topmargin -\textheight
  \advance\topmargin -\headheight \advance\topmargin -\headsep
  \divide\topmargin\tw@
  \ifdim\topmargin<.5truein \topmargin.5truein \fi
  \advance\topmargin -1truein\relax
}

\pagenumbering{arabic}%
\pagestyle{headings}%
\thispagestyle{plain}%

\def\tiny{\Tiny}
\def\defaultfont{\normalfont}
\def\rom{\textup}

\def\publname{Rocky Mountain\\Journal of Mathematics}

\def\nullifyPageOffsets{
  \topmargin\z@ \oddsidemargin\z@ \evensidemargin\z@}

\newif\if@genericstyle

\newcommand{\genericRMMC}{%
 \@genericstyletrue
 \doipublisherid{}
 \copyrightholder{Rocky Mountain Mathematics Consortium}
 \publisherpubid{}
 \issueinfo{SOME\\JOURNAL OF MATHEMATICS\\Volume \@volno, Number \@volissno, \@pubyear}
% \indentstyle
}

\newcommand{\rmj}{%
 \@genericstylefalse
 \doipublisherid{10.1216}
 \copyrightholder{Rocky Mountain Mathematics Consortium}
 \publisherpubid{RMJ}
 \issueinfo{ROCKY MOUNTAIN\\JOURNAL OF MATHEMATICS\\Volume \@volno, Number \@volissno, \@pubyear}
% \indentstyle
}


\def\jie{%
 \rmj
 \publisherpubid{JIE}
 \issueinfo{JOURNAL OF INTEGRAL EQUATIONS\\AND APPLICATIONS\\Volume \@volno, Number \@volissno,
   \ifnum\@volissno=1 Spring\else
   \ifnum\@volissno=2 Summer\else
   \ifnum\@volissno=3 Fall\else
   \ifnum\@volissno=4 Winter\else
   ????\fi\fi\fi\fi
   \ \@pubyear}
}

\def\jca{%
 \rmj
 \publisherpubid{JCA}
 \issueinfo{JOURNAL OF COMMUTATIVE ALGEBRA\\Volume \@volno, Number \@volissno,
   \ifnum\@volissno=1 Spring\else
   \ifnum\@volissno=2 Summer\else
   \ifnum\@volissno=3 Fall\else
   \ifnum\@volissno=4 Winter\else
   ????\fi\fi\fi\fi
   \ \@pubyear}
}

\genericRMMC
\volno{\relax}
\volissno{\relax}
\pubyear{\relax}
\notrimmarks
\nullifyPageOffsets


\InputIfFileExists{rmmcart.supplement}{}{%
}

\InputIfFileExists{rmmcart.cfg}{}{%
  % \calclayout % initialize
  \pagenumbering{arabic}%
  \pagestyle{headings}%
  \thispagestyle{plain}%
}


\endinput
%%
%% End of file `rmmcart.cls'.