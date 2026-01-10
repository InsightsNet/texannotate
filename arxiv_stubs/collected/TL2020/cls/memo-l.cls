%%
%% This is file `memo-l.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% memo-l.dtx  (with options: `cls')
%% 
%% This is a generated file.
%% 
%% Copyright 1996, 2000-2002, 2007, 2009, 2011 American Mathematical Society.
%% 
%% American Mathematical Society
%% Technical Support
%% Publications Technical Group
%% 201 Charles Street
%% Providence, RI 02904
%% USA
%% tel: (401) 455-4080
%%      (800) 321-4267 (USA and Canada only)
%% fax: (401) 331-3842
%% email: tech-support@ams.org
%% 
%% Unlimited copying and redistribution of this file are permitted as
%% long as this file is not modified.  Modifications, and distribution
%% of modified versions, are permitted, but only if the resulting file
%% is renamed.
%% 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{memo-l}[2014/05/27 v3.23 MEMO Author Class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsbook}}

\ProcessOptions\relax
\let\AMS@require@snapshot\@empty
\LoadClass{amsbook}[2008/07/02]
\def\issueinfo#1#2#3#4{%
    \def\currentvolume{#1}%
    \def\currentissue{#2}%
    \def\currentmonth{#3}%
    \def\currentyear{#4}%
}
\issueinfo{}{}{}{}
\def\publname{MEMOIRS OF THE\newline AMERICAN MATHEMATICAL SOCIETY}
\def\ISSN{0065-9266}
\newcommand\PII{\def\@PII}
\PII{}
\newif\if@revertcopyright
\@revertcopyrightfalse

\newcommand{\revertcopyright}{\global\@revertcopyrighttrue}
\copyrightinfo{}{}
\dateposted{}
\date{}
\newcommand\issuenote{\def\@issuenote}

\issuenote{}
\def\ams@release#1{%
    \begingroup
        \def\do##1{\global\let##1\relax}%
        #1%
    \endgroup
}
\providecommand{\@maketitle@hook}{}
\def\maketitle{%
    \par
    \@topnum\z@ % this prevents figures from falling at the top of page 1
    \@maketitle@hook
    \@maketitle
    \ams@release{%
        \do\maketitle \do\@maketitle
        \do\title \do\@xtitle \do\@title
        \do\author \do\@xauthor
        \do\address \do\@xaddress
        \do\email \do\@xemail
        \do\curraddr \do\@xcurraddr
        \do\dedicatory \do\@dedicatory
    }
}
\renewenvironment{abstract}{%
    \global\setbox\abstractbox=\vtop\bgroup
        \normalsize
        \@abstractheader{Abstract}
        \write\m@ne{memo-l abstract page: \the\count0\space}%
        \indent
}{%
    \egroup
    \ifx\tableofcontents\@empty \@setabstract \fi
}
\def\tableofcontents{%
    \cleardoublepage
    \@starttoc{toc}\contentsname
    \ifvoid\abstractbox\else\@setabstract\fi
    \let\tableofcontents\@empty
}
\def\@setabstract{%
    \begingroup
        \cleardoublepage
        \let\@makefnmark\relax
        \let\@thefnmark\relax
        \thispagestyle{plain}%
        \@makeabsfootnotes
        \noindent\unvbox\abstractbox
    \endgroup
    \c@footnote\z@
    \clearpage
}
\newcommand\@abstractheader[1]{%
    \typeout{#1}%
    \chaptermark{#1}%
    \@afterindenttrue
    \null
    \vskip 5.25pc
    \@makeschapterhead{#1}%
    \@afterheading
}
\def\@makeabsfootnotes{%
    \begingroup
        \let\@makefnmark\relax
        \let\@thefnmark\relax
        \ifx\H@@footnotetext\@undefined\else
            \let\@footnotetext\H@@footnotetext
        \fi
        \ifx\@empty\@date\else      \@footnotetext{\@setdate}\fi
        \ifx\@empty\@dateposted\else\@footnotetext{\@setdateposted}\fi
        \ifx\@empty\@subjclass\else \@footnotetext{\@setsubjclass}\fi
        \ifx\@empty\@keywords\else  \@footnotetext{\@setkeywords}\fi
        \ifx\@empty\thankses\else
            \@footnotetext{\def\par{\let\par\@par}\@setthanks}%
        \fi
        \ifx\@empty\copyrightyear\else
            \@footnotetext{\@setcopyright}%
        \fi
    \endgroup
    \ams@release{%
        \do\date \do\@date \do\@setdate
        \do\dateposted \do\@dateposted \do\@setdateposted
        \do\PII \do\@PII
        \do\DOI \do\@DOI
        \do\thanks \do\thankses \do\@setkeywords
        \do\keywords \do\@keywords \do\@setkeywords
        \do\subjclass \do\@subjclass
        \do\@setcopyright
    }%
}
\def\@setcopyright{%
    \parfillskip\z@\relax
    \leftskip\z@\@plus.9\textwidth\relax
    \rightskip\z@\relax
    \@copyinsfontsize
    \if@revertcopyright\else
        \leavevmode\strut\\
    \fi
    \copyright\copyrightyear\ \copyrightholder\par
    \if@revertcopyright
        Reverts to public domain 28 years from publication
    \fi
    \par
}
\def\@setdate{Received by the editor \@date\@addpunct.}
\providecommand*{\@DOI}{}
\def\@setdateposted{%
    Article electronically published on \@dateposted%
    \ifx\@PII\@empty
        \@addpunct.%
        \ifx\@DOI\@empty\else
            \par
            DOI:
            \href{http://dx.doi.org/\@DOI}{\url{http://dx.doi.org/\@DOI}}%
        \fi
    \else
        ; \@PII\@addpunct.%
    \fi
}
\def\@setsubjclass{%
    \begingroup
        \let\\=\space
        {\itshape\subjclassname.}\enspace\@subjclass\@addpunct.%
    \endgroup
}
\def\@setkeywords{%
    {\itshape \keywordsname.}\enspace \@keywords\@addpunct.%
}
\def\@maketitle{%
    \@maketitlepage
    \ifx\@empty\@dedicatory \else
        \@setdedication
    \fi
}
\def\@maketitlepage{%
    \thispagestyle{empty}%
    \begingroup
        \topskip\z@skip
        \null
        \vfil
        \begingroup
            \LARGE\bfseries \centering
            \openup\medskipamount
            \@title\par
            \vspace{24pt}%
            \def\and{\par\medskip}%
            \centering
            \mdseries\authors\par
            \bigskip
        \endgroup
        \vfil
        \ifx\@empty\addresses\else
            Author address:
            \@setaddresses
        \fi
        \bigskip
        \vfil
        \ifx\@empty\@translators\else
            \vfill
            \begin{center}
            \@settranslators
            \end{center}
        \fi
        \vfil\vfil
    \endgroup
}
\def\@setdedication{%
    \begingroup
        \cleardoublepage
        \thispagestyle{empty}%
        \vspace*{13.5pc}%
        \setbox\@tempboxa\vbox{%
            \noindent\@dedicatory\@@par
            \global\setbox\@ne\lastbox
        }%
        \ifdim\wd\@tempboxa=\z@
            \centering{\@dedicatory\@@par}%
        \else
            \noindent\@dedicatory\@@par
        \fi
    \endgroup
}
\InputIfFileExists{memo-l.cfg}{}{}
\endinput
%%
%% End of file `memo-l.cls'.
