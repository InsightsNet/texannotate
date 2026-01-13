%
% $Header: /var/local/devel/macro/cimento/cimento.cls,v 1.63 2015/08/04 13:56:13 marco Exp $
%
%

%% contact: marco.bellacosa@sif.it, http://www.sif.it
%% on behalf of the Italian Physical Society



\NeedsTeXFormat{LaTeX2e}[1995/06/01]
\ProvidesClass{cimento}
      [2002/04/09 v1.5b Il Nuovo Cimento]
\newif\ifn@title\n@titlefalse
\newif\ifn@author\n@authorfalse
\newif\if@ditorial\@ditorialfalse
\newif\if@first\@firstfalse
\newif\ifdebug\debugfalse
\newif\ifconfig\configtrue
\newif\iffinal\finalfalse
\newif\ifshortnote\shortnotefalse
\newif\iferratum\erratumfalse
\newif\iftoc\tocfalse
\newif\ifcover\coverfalse
\newif\ifrcover\rcoverfalse
\newif\ifindex\indexfalse
\newif\ifhead\headfalse
\newif\ifchrono\chronofalse
\newif\ifalpha\alphafalse
\newif\ifalphaplain\alphaplainfalse
\newif\ifpacs\pacsfalse
\newif\ifbooks\booksfalse
\newif\ifcentury\centuryfalse
\newif\iftimes\timesfalse
\newif\ifvarenna\varennafalse
\newif\ifvolume\volumefalse
\newif\ifnocopyright\nocopyrightfalse
\newif\ifnoabstract\noabstractfalse
\newif\ifrivista\rivistafalse
\newif\ifseqno\seqnofalse
\newif\ifgetcite\getcitefalse
\newif\ifoverfull\overfullfalse
\newif\ifcomments\commentsfalse
\newif\ifbareref\barereffalse
\newif\ifprefatory\prefatoryfalse
\newif\ifpreprint\preprintfalse
\newif\ifsubsub\subsubfalse
\newif\ifgetdata\getdatafalse
\newif\ifinfo\infofalse
\newif\ifproofs\proofsfalse
\newif\ifcim@special\cim@specialfalse
\newif\ifcim@english\cim@englishfalse
\newlength\belowabstractskip
\setlength\belowabstractskip{0\p@}
\DeclareOption{editorial}{\@ditorialtrue\nocopyrighttrue}
\DeclareOption{ofirst}{\@firsttrue}
\DeclareOption{debug}{\debugtrue}
\DeclareOption{config}{\configtrue}
\DeclareOption{noconfig}{\configfalse}
\DeclareOption{shortnote}{\shortnotetrue}
\DeclareOption{erratum}{\erratumtrue}
\DeclareOption{toc}{\toctrue}
\DeclareOption{toc-cover}{\toctrue\covertrue}
\DeclareOption{reprint-cover}{\rcovertrue}
\DeclareOption{indexhead}{\indextrue\headtrue}
\DeclareOption{chronoindex}{\indextrue\chronotrue}
\DeclareOption{alphaindex}{\indextrue\alphatrue}
\DeclareOption{alphaplainindex}{\indextrue\alphaplaintrue}
\DeclareOption{pacsindex}{\indextrue\pacstrue}
\DeclareOption{booksindex}{\indextrue\bookstrue}
\DeclareOption{final}{\finaltrue}
\DeclareOption{draft}{\finalfalse\overfulltrue}
\DeclareOption{overfull}{\overfulltrue}
\DeclareOption{comments}{\commentstrue}
\DeclareOption{century}{\centurytrue}
\DeclareOption{times}{\timestrue}
\DeclareOption{seceqno}{\seqnotrue}
\DeclareOption{cite}{\getcitetrue}
\DeclareOption{bareref}{\barereftrue}
\DeclareOption{varenna}{\varennatrue}
\DeclareOption{volume}{\varennatrue\volumetrue}
\DeclareOption{volumefermi}{\varennatrue\volumetrue}
\DeclareOption{nocopyright}{\nocopyrighttrue}
\DeclareOption{noabstract}{\noabstracttrue}
\DeclareOption{rivista}{\rivistatrue}
\DeclareOption{prefatory}{\prefatorytrue}
\DeclareOption{preprint}{\preprinttrue}
\DeclareOption{subsub}{\subsubtrue}
\DeclareOption{getdata}{\getdatatrue}
\DeclareOption{info}{\infotrue}
\DeclareOption{proofs}{\proofstrue}
\DeclareOption{special}{\cim@specialtrue}
\DeclareOption{english}{\cim@englishtrue}
\DeclareOption*{\OptionNotUsed
\ClassWarningNoLine{cimento}{%
    Option \CurrentOption\space not implemented.\MessageBreak
    Passed along to eventual packages}%
}
\ExecuteOptions{final}
\PassOptionsToPackage{leqno}{amsmath}
\ProcessOptions\relax
\setlength\paperheight{297mm}
\setlength\paperwidth{210mm}
\@twosidetrue\@mparswitchtrue
\@twocolumnfalse
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\global\let\d@i\@empty
\if@ditorial
  \gdef\noauthor{\global\n@authortrue}
  \gdef\notitle{\global\n@titletrue}
  \let\author@signature\@empty
  \gdef\authorsignature#1{\gdef\author@signature{#1}}
\fi
\def\DOI#1{\gdef\d@i{#1}}%
\InputIfFileExists{updatedb}{}{%
    \ClassInfo{cimento}{No DB support}%
}

%%%%%%%  topics

\usepackage{color}
\def\@nocategory{}%
\def\nocategory{\gdef\@nocategory{1}}%
\def\nc@categ@height{height4.8mm depth2.2mm}
\def\nc@categhskip{2mm}
\def\nc@categfont{\fontsize{10.3pt}{10.3pt}\selectfont}
\def\nc@head@to@categskip{13.80mm}
\def\nc@head@to@lineskip{9.0mm}
\def\@category{}
\newcommand{\category}[1]{%
  \def\@category{%
    \newbox\categbox\setbox\categbox\hbox{\nc@categfont\hskip\nc@categhskip{#1}\hskip\nc@categhskip}%
    \def\categorywidth{\wd\categbox}%
    \ifdim\categorywidth<88mm\def\categorywidth{65mm}\fi%
    %\newline\noindent%
    \rlap{\hbox{\smash{\lower\nc@head@to@categskip\hbox{%
            \ifx\@nocategory\@empty%
              \rlap{\hbox{\color[gray]{0.7}\vrule width\categorywidth \nc@categ@height}}%
         \textcolor{black}{\usebox\categbox}%
         \fi%
          }}}}%
    \rlap{\hbox{\smash{\lower\nc@head@to@lineskip\hbox{\vrule width \textwidth height.12mm depth0pt}}}}%
  }%
}%


%%%%%%%%%%%%%%%%%%%%%%

%% revision: with colour

\newcommand{\revision}[1]{{\color{red}{#1}}}
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%
%% linenumbers for proofs
\newcommand{\setlinenumbers}{
\usepackage[switch*]{lineno}
\usepackage{mlineno}
\linenumbers
}
%%%%%%%%%%%%%%


\ifvarenna
   \def\orgdivision#1{#1}
   \def\orgname#1{#1}
   \def\street#1{#1}
   \def\postcode#1{#1}
   \def\postbox#1{#1}
   \def\city#1{#1}
   \def\state#1{#1}
   \def\country#1{#1}
\else
\InputIfFileExists{sif-extensions}{}{%
    \ClassInfo{cimento}{No SIF extensions}%
}
\fi

\iffinal
    \renewcommand\normalsize{%
        \ifvarenna\@setfontsize\normalsize\@xpt{12.87}%
            \else\@setfontsize\normalsize\@xpt{11.848}\fi
        \abovedisplayskip 12\p@ \@plus4\p@ \@minus2\p@
        \abovedisplayshortskip 2\p@ \@plus1\p@ \@minus1\p@
        \belowdisplayshortskip 8\p@ \@plus3\p@ \@minus1\p@
        \belowdisplayskip \abovedisplayskip
        \let\@listi\@listI
    }
    \normalsize
    \newcommand\small{%
        \ifvarenna\@setfontsize\small\@ixpt{11}%
            \else\@setfontsize\small\@ixpt{10.5}\fi
        \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
        \abovedisplayshortskip \z@ \@plus2\p@
        \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
        \def\@listi{%
            \leftmargin\leftmargini
            \topsep 4\p@ \@plus2\p@ \@minus2\p@
            \parsep 2\p@ \@plus\p@ \@minus\p@
            \itemsep \parsep
        }%
        \belowdisplayskip \abovedisplayskip
    }
    \newcommand\footnotesize{%
        \@setfontsize\footnotesize\@viiipt{9.5}%
        \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
        \abovedisplayshortskip \z@ \@plus\p@
        \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
        \def\@listi{%
            \leftmargin\leftmargini
            \topsep 3\p@ \@plus\p@ \@minus\p@
            \parsep 2\p@ \@plus\p@ \@minus\p@
            \itemsep \parsep
        }%
        \belowdisplayskip \abovedisplayskip
    }
    \newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
    \newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
    \newcommand\large{\@setfontsize\large\@xiipt{14}}
    \newcommand\Large{\@setfontsize\Large\@xivpt{18}}
    \newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
    \newcommand\huge{\@setfontsize\huge\@xxpt{25}}
    \newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
    \setlength\parindent{14\p@}
    \setlength{\parskip}{0pt plus1pt}
    \setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
    \setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
    \setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}
    \setlength\headheight{12\p@}
    \setlength\headsep   {12\p@}
    \setlength\topskip   {12\p@}
    \setlength\footskip{20pt}
    \setlength\maxdepth{.5\topskip}
    \setlength{\textwidth}{13.5cm}
    \@settopoint\textwidth
    \ifvarenna
        \setlength{\textheight}{42\baselineskip}    % 1 less than desired:
    \else
        \setlength{\textheight}{48\baselineskip}    % top given by \topskip
    \fi
    \addtolength\textheight{\topskip}
    \setlength\marginparsep{11\p@}
    \setlength\marginparpush{5\p@}
    \setlength\@tempdima        {\paperwidth}
    \addtolength\@tempdima      {-\textwidth}
    \setlength\oddsidemargin    {.5\@tempdima}
    \addtolength\oddsidemargin  {-1in}
    \setlength\marginparwidth{80pt}
    \ifdim \marginparwidth >2in
        \setlength\marginparwidth{2in}
    \fi
    \@settopoint\oddsidemargin
    \@settopoint\marginparwidth
    \setlength\evensidemargin  {\paperwidth}
    \addtolength\evensidemargin{-2in}
    \addtolength\evensidemargin{-\textwidth}
    \addtolength\evensidemargin{-\oddsidemargin}
    \@settopoint\evensidemargin
    \setlength\topmargin{\paperheight}
    \addtolength\topmargin{-2in}
    \addtolength\topmargin{-\headheight}
    \addtolength\topmargin{-\headsep}
    \addtolength\topmargin{-\textheight}
    \addtolength\topmargin{-\footskip}     % this might be wrong!
    \addtolength\topmargin{-.5\topmargin}
    \@settopoint\topmargin
    \setlength\footnotesep{6.65\p@}
    \setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
    \setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
    \setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
    \setlength\intextsep   {12\p@ \@plus 2\p@ \@minus 2\p@}
    \setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
    \setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
    \setlength\@fptop{0\p@ \@plus 1fil}
    \setlength\@fpsep{8\p@ \@plus 2fil}
    \setlength\@fpbot{0\p@ \@plus 1fil}
    \setlength\@dblfptop{0\p@ \@plus 1fil}
    \setlength\@dblfpsep{8\p@ \@plus 2fil}
    \setlength\@dblfpbot{0\p@ \@plus 1fil}
    \setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
    \def\@listi{%
        \leftmargin\leftmargini
        \parsep 4\p@ \@plus2\p@ \@minus\p@
        \topsep 8\p@ \@plus2\p@ \@minus4\p@
        \itemsep4\p@ \@plus2\p@ \@minus\p@
    }
    \let\@listI\@listi
    \@listi
    \def\@listii{%
        \leftmargin\leftmarginii
        \labelwidth\leftmarginii
        \advance\labelwidth-\labelsep
        \topsep    4\p@ \@plus2\p@ \@minus\p@
        \parsep    2\p@ \@plus\p@  \@minus\p@
        \itemsep   \parsep
    }
    \def\@listiii{%
        \leftmargin\leftmarginiii
        \labelwidth\leftmarginiii
        \advance\labelwidth-\labelsep
        \topsep    2\p@ \@plus\p@\@minus\p@
        \parsep    \z@
        \partopsep \p@ \@plus\z@ \@minus\p@
        \itemsep   \topsep
    }
    \def\@listiv{%
        \leftmargin\leftmarginiv
        \labelwidth\leftmarginiv
        \advance\labelwidth-\labelsep
    }
    \def\@listv{%
        \leftmargin\leftmarginv
        \labelwidth\leftmarginv
        \advance\labelwidth-\labelsep
    }
    \def\@listvi{%
        \leftmargin\leftmarginvi
        \labelwidth\leftmarginvi
        \advance\labelwidth-\labelsep
    }
\else %\iffinal
    \input{size12.clo}
\fi   %\iffinal
\renewcommand\@eqnnum{%
    \hb@xt@.01\p@{}%
    \rlap{\normalfont\normalcolor\hskip -\textwidth(\theequation)}%
}
\ifoverfull\setlength{\overfullrule}{5pt}\fi


\ifcentury
    \renewcommand{\rmdefault}{bcn}
    \renewcommand{\sfdefault}{bfu}
    \renewcommand{\ttdefault}{pcr}
\fi
\iftimes
    \usepackage{times}
\fi
\ifgetcite
    \RequirePackage[nosort]{cite}
\fi
\AtBeginDocument{%
    \let\org@citeleft\citeleft
    \def\citeleft{\bgroup\ifmmode\else\upshape\fi\org@citeleft}%
    \let\org@citeright\citeright
    \def\citeright{\org@citeright\egroup}
    \def\citedash{\hbox{-}\penalty\@m}%
    \def\refname{references}%%% matteo 2001-06-04 %%%
}
\ifsubsub
    \font\subsub@font=cmss10
\fi
\ifdebug\setcounter{errorcontextlines}{999}\fi
\newcommand{\debugline}{\hrule height.1pt depth0pt width\hsize}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\setcounter{topnumber}{1}
\renewcommand\topfraction{.95}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.95}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.05}
\renewcommand\floatpagefraction{.85}
\setlength{\textfloatsep}{20pt plus 8pt minus 10pt}
\iffinal
    \setlength{\topmargin}{40pt}
\else
    \setlength{\hoffset}{-.7in}
    \setlength{\voffset}{-.7in}
    \setlength{\textwidth}{15cm}
    \ifvarenna
        \setlength{\textheight}{39\baselineskip}
    \else
        \setlength{\textheight}{45\baselineskip}
    \fi
    \setlength{\topmargin}{40pt}
    \setlength{\headheight}{12pt}
    \setlength{\headsep}{12pt}
    \setlength{\footskip}{2pc}
    \setlength{\oddsidemargin}{1.5cm}                     %??
    \setlength{\evensidemargin}{2cm}                      %??
    \setlength{\marginparsep}{1pc}
    \setlength{\marginparwidth}{3pc}
    \setlength{\topskip}{12pt}
    \renewcommand{\baselinestretch}{2}
    \setlength{\parindent}{2em}
    \setlength{\parskip}{0pt plus1pt}
\fi
\hbadness=1000
\vbadness=1000
\hfuzz=.1pt
\pretolerance=100
\tolerance=200
\setlength{\footnotesep}{0pt}
\setlength{\skip\footins}{22pt}
\let\smaller\footnotesize
\let\footnotesize\small
\renewcommand{\footnoterule}{%
    \kern-6pt\hrule height.4pt depth0pt width\textwidth\kern6pt
}
\newcommand{\@makefntext}[1]{%
    \setlength{\parindent}{1em}%
    \noindent\hbox to17pt{\@makefnmark\hfil}#1%
}
\renewcommand{\@makefnmark}{%
    \hbox{$(^{\@thefnmark})\m@th$}%
}
\def\ps@cimheadings{%
    \let\@evenfoot\@empty\let\@oddfoot\@empty
    \def\@evenhead{{\small\bfseries\thepage}\hfil\iffinal{\leftmark}\fi}%
    \def\@oddhead{\iffinal{\rightmark}\fi\hfil{\small\bfseries\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\def\ps@cimfirstpageheadings{%
    \let\@evenfoot\@empty
    \ifvolume
	\def\@evenfoot{{\small\thepage}\hfil\ifpreprint\else\@copyright@\fi}
    \fi
    \if@ditorial
    \let\@oddfoot\@empty
    \else
    \def\@oddfoot{\ifpreprint\else\@copyright@\fi\hfil{\small\thepage}}%
    \fi
    \let\@evenhead\@empty
    \def\@oddhead{%
        \iffinal
            \ifvarenna %% per DOI di VARENNA
              \ifx\d@i\@empty\else\makebox[0pt][l]{\raisebox{-3.2ex}{DOI~\d@i}}\fi
               \else
                \ifindex\else
                    \@makefirstoddhead
                \fi
            \fi
        \fi
    }%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\def\ps@cimplain{%
    \let\@evenfoot\@empty\let\@oddfoot\@empty
    \def\@evenhead{{\small\bfseries\thepage}\hfil}%
    \def\@oddhead{\hfil{\small\bfseries\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\def\ps@cimfirstpageplain{%
    \def\@evenfoot{{\small\thepage}\hfil}\def\@oddfoot{\hfil{\small\thepage}}%
    \let\@evenhead\@empty\let\@oddhead\@empty
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\def\ps@cimprefatory{%
    \let\@evenfoot\@empty\let\@oddfoot\@empty
    \def\@evenhead{{\scriptsize\thepage}\hfil{\rightmark}}%
    \def\@oddhead{{\rightmark}\hfil{\scriptsize\thepage}}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\def\ps@cimfirstpageprefatory{%
    \let\@evenfoot\@empty\def\@oddfoot{\hfil{\scriptsize\thepage}}%
    \let\@evenhead\@empty
    \let\@oddhead\@empty
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}
\ifprefatory
    \pagestyle{cimprefatory}
    \thispagestyle{cimfirstpageprefatory}
    \pagenumbering{Roman}
\else
    \pagestyle{cimheadings}
    \thispagestyle{cimfirstpageheadings}
    \pagenumbering{arabic}
\fi
\def\@copyright@{%
    {\smaller\copyright\sffamily\ Societ\`a Italiana di Fisica}%
}
\ifnocopyright
  \let\@copyright@\@empty
\fi

\newcommand{\setcopyright}[1]{\def\@copyright@{\parbox{80ex}{\scriptsize \copyright\sffamily\ #1 \ifvarenna \else\\ Creative Commons Attribution 4.0 License (http://creativecommons.org/licenses/by/4.0)\fi}}}
\setcounter{secnumdepth}{3}
\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\renewcommand{\thesection}{{\normalfont\bfseries\arabic{section}}}
\ifseqno\newcommand{\themdsection}{{\normalfont\arabic{section}}}\fi
\renewcommand{\thesubsection}{%
    \textnormal{\thesection\@highdot@\arabic{subsection}}%
}
\renewcommand{\thesubsubsection}{%
    \textnormal{\thesubsection.\arabic{subsubsection}}%
}
\renewcommand{\theparagraph}{\thesubsubsection.\arabic{paragraph}}
\renewcommand{\thesubparagraph}{\theparagraph.\arabic{subparagraph}}
\def\@seccntformat#1{\csname the#1\endcsname.\ }
\newcommand{\@highdot@}{\raise1.2ex\hbox{.}}
\newcommand{\hdot}{\@highdot@}
\def\@dash@{--}
\def\@wr@p@{\@empty}
\newcommand{\yesdash}{\gdef\@dash@{--}}
\newcommand{\nodash}{\gdef\@dash@{}}
\newcommand{\wrap}{\gdef\@wr@p@{\par\vskip10pt\noindent}}
\def\@dot@{.}
\newcommand{\yesdot}{\gdef\@dot@{.}}
\newcommand{\nodot}{\leavevmode\gdef\@dot@{}}
\def\@startsection#1#2#3#4#5#6{%
    \if@noskipsec\leavevmode\fi
    \par
    \@tempskipa #4\relax
    \@afterindenttrue
    \ifdim \@tempskipa <\z@
        \@tempskipa -\@tempskipa \@afterindentfalse
    \fi
    \if@nobreak
        \everypar{}%
    \else
        \addpenalty\@secpenalty\addvspace\@tempskipa
    \fi
    \@ifstar
        {\@ssect{#1}{#3}{#4}{#5}{#6}}%
        {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
}
\def\cim@numberline@fmt#1{\csname the#1\endcsname.}
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
                \interlinepenalty \@M \csname @#1fmt@\endcsname{#8}\@@par
            }%
        \endgroup
        \csname #1mark\endcsname{#7}%
        \begingroup
            \def\thesection{{\normalfont\arabic{section}}}
            \addcontentsline{toc}{#1}{%
                \ifnum #2>\c@secnumdepth
                \else
                    \protect\numberline{\cim@numberline@fmt{#1}}%
                \fi
                #7%
            }%
        \endgroup
    \else
        \def\@svsechd{%
            #6{%
                \hskip #3\relax
                \@svsec \csname @#1fmt@\endcsname{#8}%
            }%
            \csname #1mark\endcsname{#7}%
            \begingroup
                \def\thesection{{\normalfont\arabic{section}}}%
                \addcontentsline{toc}{#1}{%
                    \ifnum #2>\c@secnumdepth
                    \else
                        \protect\numberline{\cim@numberline@fmt{#1}}%
                    \fi
                    #7%
                }%
            \endgroup
        }%
    \fi
    \@xsect{#5}%
}
\def\@ssect#1#2#3#4#5#6{%
   \addcontentsline{toc}{#1}{%
       #6%
   }%
    \@tempskipa #4\relax
    \ifdim \@tempskipa>\z@
        \begingroup
            #5{%
                \@hangfrom{\hskip #2}%
                \interlinepenalty \@M \csname @#1fmt@\endcsname{#6}\@@par
            }%
        \endgroup
    \else
        \def\@svsechd{#5{\hskip #2\relax \csname @#1fmt@\endcsname{#6}\ }}%
    \fi
    \@xsect{#4}%
}
\newif\ifcim@secstar@
\def\cim@star{*}
\def\cim@bra{[}
\newcommand{\section}[1]{%
    \ifseqno\setcounter{equation}{0}\fi
    \def\@tempa{#1}%
    \ifx\@tempa\cim@star
        \cim@secstar@true
        \def\@temp@{\@section@*}%
    \else
        \cim@secstar@false
        \ifx\@tempa\cim@bra
            \def\@temp@{\@osection@[}%
        \else
            \def\@temp@{\@section@{#1}}%
         \fi
    \fi
    \@temp@
}
\def\@osection@[#1]#2{\@section@[#1]{#2}}
\newcommand{\@section@}{%
    \@startsection{section}{1}{0pt}{3.2ex plus1ex minus.2ex}
       {2ex plus.2ex minus.1ex}{\normalfont\bfseries\normalsize}%
}
\newcommand{\@sectionfmt@}[1]{%
    \def\@temp@{#1}%
    \ifx\@temp@\@undefined
    \else
        \ifcim@secstar@
        \else
            \@dash@\ 
        \fi
    \fi
    #1%
    \null\yesdash
}
\newcommand{\subsection}[1]{%
    \def\@tempa{#1}%
    \ifx\@tempa\cim@star
        \def\@temp@{\@ssubsection@}%
    \else
        \ifx\@tempa\cim@bra
            \def\@temp@{\@osubsection@[}%
        \else
            \def\@temp@{\@subsection@{#1}}%
        \fi
    \fi
    \@temp@
}
\def\@ssubsection@#1{\@subsection@*{#1}}
\def\@osubsection@[#1]#2{\@subsection@[#1]{#2}}
\newcommand{\@subsection@}{%
    \@startsection{subsection}{2}{\parindent}{2ex plus.5ex minus.2ex}
       {-0pt}{\normalfont\normalsize}%
}
\newcommand{\@subsectionfmt@}[1]{%
    \def\@temp@{#1}%
    \ifx\@temp@\@undefined
    \else
        \textit{#1}\@dot@\ 
    \fi
    \@dash@\
    \@wr@p@
    \null\yesdot\yesdash
    \global\let\@wr@p@\@empty
}
\newcommand{\subsubsection}[1]{%
    \def\@tempa{#1}%
    \ifx\@tempa\cim@star
        \def\@temp@{\@ssubsubsection@}%
    \else
        \ifx\@tempa\cim@bra
            \def\@temp@{\@osubsubsection@[}%
        \else
            \def\@temp@{\@subsubsection@{#1}}%
        \fi
    \fi
    \@temp@
}
\def\@ssubsubsection@#1{\@subsubsection@*{#1}}
\def\@osubsubsection@[#1]#2{\@subsubsection@[#1]{#2}}
\newcommand{\@subsubsection@}{%
    \@startsection{subsubsection}{3}{\parindent}{2ex plus.5ex minus.5ex}
       {-0pt}{\normalfont\normalsize}%
}
\newcommand{\@subsubsectionfmt@}[1]{%
    \def\@temp@{#1}%
    \ifx\@temp@\@undefined
    \else
        {\ifsubsub\subsub@font\fi#1}\@dot@\
    \fi
    \yesdot
}
\newcommand{\paragraph}[1]{%
    \def\@tempa{#1}%
    \ifx\@tempa\cim@star
        \def\@temp@{\@sparagraph@*}%
    \else
        \ifx\@tempa\cim@bra
            \def\@temp@{\@oparagraph@[}%
        \else
            \def\@temp@{\@paragraph@{#1}}%
        \fi
    \fi
    \@temp@
}
\def\@sparagraph@#1{\@paragraph@*{#1}}
\def\@oparagraph@[#1]#2{\@paragraph@[#1]{#2}}
\newcommand{\@paragraph@}{%
    \@startsection{paragraph}{4}{0pt}{3.25ex plus1ex minus.2ex}
                {-0pt}{\normalfont\normalsize}%
}
\newcommand{\@paragraphfmt@}[1]{%
    \textit{#1}\@dot@\ \yesdot
}
\newcommand{\subparagraph}{%
    \@startsection{subparagraph}{5}{\parindent}%
                  {3.25ex \@plus1ex \@minus .2ex}%
                  {-1em}{\reset@font\normalsize\itshape}%
}
\let\@undercimento@\@empty
\ifindex
    \newcommand{\issue}[3]{%
        \gdef\@volume@{#1}\gdef\@issue@{#2}\gdef\@issuedate@{#3}%
    }
\else
    \def\@volume@{?}
    \def\@issue@{?}
    \def\@issuedate@{?}
    \iffinal
        \newcommand{\@makefirstoddhead}{%
            \ifpreprint
                \hfil
            \else
                \makebox[0pt][l]{%
                    \small
		    \ifx\@undercimento@\@empty
		    \ifx\d@i\@empty\else\makebox[0pt][l]{\raisebox{-3.2ex}{DOI~\d@i}}\fi%
                    \ifx\@category\@empty\else\makebox[0pt][l]{\raisebox{1.2ex}{\@category}}\fi
	            \else
                    \makebox[0pt][l]{\raisebox{-3.2ex}{\@undercimento@}}%
                    \ifx\d@i\@empty\else\makebox[0pt][l]{\raisebox{-6.4ex}{DOI~\d@i}}\fi%
                    \ifx\@category\@empty\else\makebox[0pt][l]{\raisebox{0.2ex}{\@category}}\fi
		    \fi
		    \if@ditorial
		    \else
                    \ifrivista RIVISTA DEL \else IL \fi
                    NUOVO CIMENTO%
		    \fi
                }%
		    \if@ditorial
		    \else
                \hfil\ifrivista\hspace{40pt}\fi
                \makebox[0pt]{\if@first\else\small\scshape Vol.\ \@volume@, N.\ \@issue@\fi}%
                \hfil\makebox[0pt][r]{\if@first Online First\else\small\@issuedate@\fi}%
		\ifinfo\@info@\fi
		\fi
            \fi
        }
    \fi
    \iffinal
        \def\@headtitle{%
            {%
                \ifvarenna
                    \protect\smaller\scshape
                \else
                    \protect\scriptsize\MakeUppercase
                \fi
                {\@title@}%
            }%
        }
        \def\@headauthor{%
            {%
                \ifvarenna
                    \protect\smaller\scshape
                \else
                    \protect\scriptsize\MakeUppercase
                \fi
                {\@author@}%
            }%
        }
    \fi
    \newcommand{\issue}[3]{%
        \gdef\@volume@{#1}%
        \gdef\@issue@{#2}%
        \gdef\@issuedate@{#3}%
    }
    \newcommand{\shorttitle}[1]{%
        \gdef\@headtitle{%
            {%
                \ifvarenna
                    \protect\smaller\scshape
                \else
                    \protect\scriptsize\MakeUppercase
                \fi
                {#1}%
            }%
        }%
    }
    \newcommand{\shortauthor}[1]{%
        \gdef\@headauthor{%
            {%
                \ifvarenna
                    \protect\smaller\scshape
                \else
                    \protect\scriptsize\MakeUppercase
                \fi
                {#1}%
            }%
        }%
    }
\fi  %index
\let\@nlinepub\@empty
\newcommand{\onlinepub}[1]{\def\@nlinepub{#1}}
\ifrivista
    \def\@checkin@{(received ?)}
    \newcommand{\checkin}[1]{\gdef\@checkin@{received #1\\ \ifx\@nlinepub\@empty\else published online \@nlinepub\fi}}
\else
    \def\@checkin@{\protect\ClassWarningNoLine{cimento}{Check-in missing}}
    \newcommand{\checkin}[2]{\gdef\@checkin@{received #1; accepted #2\\ \ifx\@nlinepub\@empty\else published online \@nlinepub\fi}}
    \newcommand{\checkrec}[1]{\gdef\@checkin@{received #1 \\\ifx\@nlinepub\@empty\else published online \@nlinepub\fi}}
    \newcommand{\checkrev}[3]{%
        \gdef\@checkin@{received #1; revised #2; accepted #3\\ \ifx\@nlinepub\@empty\else published online \@nlinepub\fi}%
    }
    \let\CHECKIN\checkrev
\fi
\ifinfo
  \def\@info@{%
     \makebox[0pt][l]{
      \raisebox{10ex}[0pt][0pt]{
       \vbox{
       \hbox{\hspace{-40pt}\sffamily\bfseries\huge\jobname}%
        \medskip
        \hbox{\hspace{-40pt}\sffamily\bfseries\Large\number\year-\number\month-\number\day}
  }%
\ifproofs
\bigskip
   \vbox{
       \hbox{\hspace{-400pt}\sffamily\color{red}{\bfseries\large Please carefully read the Production queries}}
\medskip
 \hbox{\hspace{-400pt}\sffamily\color{red}{\bfseries\large at the end of the document}}%

  }%
\fi
}%
}%
}
%
\fi
\ifshortnote\def\@undercimento@{NOTE BREVI}\fi
\iferratum
%  \def\@undercimento@{ERRATA}
  \newcommand{\previssue}[4]
     {\gdef\@checkin@{(\textit{Nuovo Cimento #1}, \textbf{#2} (#3) #4)}}
  \newcommand{\makePACS}
     {\bgroup
      \small
      \noindent
      \begin{list}{}
 {\setlength{\leftmargin}{0pt}
  \setlength{\rightmargin}{\leftmargin}%
  \setlength{\itemindent}{0pt}%
  \setlength{\listparindent}{0pt}%
  \setlength{\labelsep}{0pt}%
  \setlength{\labelwidth}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\topsep}{0pt}
  \setlength{\parsep}{0pt}%
  \setlength{\itemsep}{0pt}}%
 \@makePACS
         \item PACS 99.10 -- Errata.
      \end{list}%
      \egroup
      \vspace{8ex plus2ex minus1ex}}
\fi
\newcounter{instcnt}
\ifvarenna
   \def\@authinst@{}
   \newcommand{\institute}[1]
      {\protected@xdef\@authinst@{\@authinst@\par
  \iffinal\vskip1ex\fi
  {\itshape\footnotesize\noindent #1}}}
\else
   \def\@makeinstmark{}
   \def\@makeinstmarkbis
       {\setlength{\labelsep}{0pt}\setlength{\leftmargin}{0pt}}
   \def\@institute@{\ClassWarningNoLine{cimento}{Institute(s) missing}}
   \newcommand{\@instmark}[1]{$(^{#1})$}
   \newcommand{\inst}{\item{}}
   \newcommand{\from}[1]
       {\@instmark{\ref{#1}}%
\gdef\@makeinstmark{\@instmark{0}}%
\gdef\@makeinstmarkbis{}%
\gdef\inst##1{\refstepcounter{instcnt}\protect\label{##1}%
      \item[{\footnotesize\@instmark{\ref{##1}}}]}}
   \newcommand{\instlist}[1]
      {\gdef\@institute@
 {\begin{marginlist}[\@makeinstmarkbis]{}{\@makeinstmark}
  \renewcommand{\-}{\discretionary{}{}{\kern.5em-\kern.5em}}
  #1%
  \end{marginlist}}}
\fi
\def\thanks#1{\protect\footnote{#1}}
\let\yourwelcome\thanks
\def\@deceased@{\let\@temp@\@makefnmark
                \def\@makefnmark{$^\dag$}\thanks{Deceased.}%
        \let\@makefnmark\@temp@}
\newcommand{\deceased}{\protect\@deceased@}
\DeclareRobustCommand{\MakeUppercase}[1]{{%
      \def\i{I}\def\j{J}%
      \def\reserved@a##1##2{\let##1##2\reserved@a}%
      \expandafter\reserved@a\@uclclist\reserved@b{\reserved@b\@gobble}%
      \protected@edef\reserved@a{\uppercase{#1}}%
      \reserved@a
   }}
\DeclareRobustCommand{\MakeLowercase}[1]{{%
      \def\reserved@a##1##2{\let##2##1\reserved@a}%
      \expandafter\reserved@a\@uclclist\reserved@b{\reserved@b\@gobble}%
      \protected@edef\reserved@a{\lowercase{#1}}%
      \reserved@a
   }}
\newif\ifcim@first@auth@\cim@first@auth@true
\ifvarenna
  \def\@auth@{}
  \renewcommand{\author}[1]{%
    %\catcode`\|=\active
    \begingroup
      %\def\ETC{\unskip\noexpand\unscrunch\noexpand|}\def|{}%
      \protected@xdef\@authinst@{%
        \@authinst@\par
        \iffinal\vskip3ex\fi
        {\scshape\normalsize\noindent\noexpand{#1}}%
      }%
      \def\atque{{\normalfont and\ }}%
      \let\And\atque
      \def\thanks##1{\@gobble{##1}}%
      \let\yourwelcome\thanks
      %\def\ETC{\unskip\noexpand\scrunch\noexpand|}\def|{}%
      \ifcim@first@auth@
        \gdef\@auth@{#1}%
        \cim@first@auth@false
      \else
        \protected@xdef\@auth@{\@auth@\ {#1}}%
      \fi
    \endgroup
    %\catcode`\|=12
  }
  \def\@author@{\@auth@}%\def\@author@{\@auth@|}
\else % \ifvarenna
  \def\@author@{\protect\ClassWarningNoLine{cimento}{Author(s) missing}}
  \catcode`\|=\active
  \renewcommand{\author}[1]{\gdef\raw@auth{#1}\gdef\@author@{#1|}}
  \catcode`\|=12
\fi % \ifvarenna
\def\@title@{\protect\ClassWarningNoLine{cimento}{Title missing}}
\catcode`\|=\active
\renewcommand{\title}[1]{%
    \gdef\@title@{#1|}%
}
\catcode`\|=12
\def\@subtitle@{}
\newcommand{\subtitle}[1]{\gdef\@subtitle@{\smallskip\par\noindent#1}}
\def\@varinfo@{\vspace{38pt}}
\newcommand{\varinfo}[4]
   {\def\@varinfo@
        {{\smaller\sffamily\fontseries{l}\selectfont\noindent
 Proceedings of the International School of Physics
    ``Enrico Fermi''\newline
         Course #1, #2\newline
 #3\newline
 DOI #4\par}}}
\def\cartola{\protect\@ifstar{\thanks{The authors of this paper have agreed
                              to not receive the proofs for correction.}}%
                              {\thanks{The author of this paper has agreed
                              to not receive the proofs for correction.}}}
\iftoc\else
\def\@beforemaketitle@hook@{}
\def\beforemaketitle#1{\gdef\@beforemaketitle@hook@{#1}}
\catcode`\|=\active
\gdef\unscrunch|#1|{#1}
\gdef\scrunch|#1|{}
\catcode`\|=12
\def\@maketitle{%
    \par\null
    \if@ditorial
	\noindent\textbf{\Large Editorial}\par
	\vskip20pt
    \fi
    {\ifn@title\else\bfseries\ifvarenna\Large\else\large\fi\noindent\@title@\par\fi}%
    {\bfseries\ifvarenna\large\else\normalsize\fi\noindent\@subtitle@\par}%
    \ifvarenna
       \@authinst@\par
    \else
      \if@ditorial
      \vspace{7ex}
      \else
       \iffinal\vspace{3ex}\fi
       {\scshape\normalsize\noindent\@author@\par}%
       \iffinal\vspace{1ex}\fi
       {\itshape\footnotesize\noindent\@institute@\par}%
      \fi
    \fi
    \ifvarenna
       \vspace{4.2cm}%
    \else
      \if@ditorial
      \else
        \iffinal\vspace{3ex}\fi
        \iffinal\ifpreprint\else{\small\noindent\@checkin@\par}\fi\fi
       \fi
       \iferratum
         \vspace{0.8ex plus0.1ex minus0.1ex}%
       \else
         \vspace{4ex plus2ex minus1ex}%
       \fi
       \par
    \fi
    %
    % for \ifvolume, see the volume section below
    %
    \ifvolume
	\addcontentsline{toc}{title}{\name{\@auth@}\ \@dash@\ \@title@}%
    \fi
}
\catcode`\|=\active
\newcommand{\maketitle}
  {\par
    \begingroup
      \setcounter{footnote}{0}%
      \def\@fnm@{\ifcase\thefootnote
   \or{*}\or{*}{*}\or{*}{*}{*}\or
   \raisebox{-1ex}[0pt][0pt]
                    {\makebox[0pt][l]{\kern0.225em${*}$}}{*}{*}\or
   \raisebox{-1ex}[0pt][0pt]
                    {\makebox{${*}{*}$}}%
           \makebox[0pt]{\kern-0.89em${*}$}\or
	   \raisebox{-1.5ex}[0pt][0pt]
                    {\makebox[0pt][l]{${**}$}}{*}{*}\fi}%
      \def\@makefnmark{\ensuremath{(^{\textstyle\@fnm@})}}%
      \def\@makefntext##1{\parindent1em\noindent\@makefnmark\ ##1}%
      \def\ETC{\unskip\unscrunch|}%
      \def|{}%
      \newpage
      \global\@topnum\z@     % Prevents figures from going at top of page.
      \hrule height0pt depth0pt width1pt         %*WEIRD* -do not remove-
      \iffinal\ifvarenna\@varinfo@\else\vspace*{4pc}\fi\fi
%      \ifinfo\@info@\fi
      \@beforemaketitle@hook@
      \@maketitle
    \endgroup
    \setcounter{footnote}{0}%
    \let\maketitle\relax\let\@maketitle\relax
    \let\instlist\relax\gdef\@institute@{}\gdef\@checkin@{}%
     \let\from\@gobble\let\thanks\@gobble\let\yourwelcome\@gobble
   \begingroup
      \def\atque{{\normalfont\protect\footnotesize
  \MakeLowercase{and\ }}}%
      \def\etal{{\normalfont\itshape\protect\footnotesize
                  \MakeLowercase{et al.}}}
      \def\\{\ \ignorespaces}%
      \def\ETC{\unskip\ etc.\scrunch|}%
      \def|{}%
      \iffinal\markboth{\@headauthor}{\@headtitle}\fi
    \endgroup
    \if@first
      \ifx\@nlinepub\@empty
        \ClassError{cimento}
          {ofirst option given without \string\onlinepub}
          {Please specify \string\onlinepub\space e.g. \string\onlinepub{13 May 2005} before \maketitle}
        \fi
      \ifx\d@i\@empty
        \ClassError{cimento}
          {ofirst option given without \string\DOI}
          {Please specify \string\DOI\space e.g. \string\DOI{10.1393/ncc/i2005-10021-9} before \maketitle}
        \fi
    \fi
   }
\catcode`\|=12
\fi
\let\date\relax\def\@date{}%
%
\newenvironment{dedication}{%
  \begingroup
  \par
  \small
  \itshape
  \raggedleft
  \noindent
}{%
  \par
  \endgroup
  \vspace{2pc}%
}
%
\def\@makePACS{\ClassWarningNoLine{cimento}{PACS missing}}
\newcommand{\PACSit}[2]{\item PACS \texttt{#1} -- #2.}
\newcommand{\PACSes}[1]{\gdef\@makePACS{#1}}
\newsavebox{\@abstractbox@}
\newenvironment{abstract}
  {\noindent\begin{lrbox}{\@abstractbox@}%
   \begin{minipage}[t]{\textwidth}%
      \small
      \leavevmode\null                                         %????
      \begin{list}{}
 {\setlength{\leftmargin}{2pc}
  \setlength{\rightmargin}{\leftmargin}%
  \setlength{\itemindent}{0pt}%
  \setlength{\listparindent}{0pt}%
  \setlength{\labelsep}{0pt}%
  \setlength{\labelwidth}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\topsep}{18pt}
  \setlength{\parsep}{0pt}%
  \setlength{\itemsep}{0pt}}%
  \ifnoabstract
  \vspace{-6pt}
  \else
     \item\textbf{Summary.}\ ---
  \fi
  }
 {\par\vspace{6pt}%
  \@makePACS
      \end{list}%
      \vspace{-8pt}%
      \null\par
   \end{minipage}%
   \end{lrbox}%
   \@absframe@{\usebox{\@abstractbox@}}%
     \ifdim\belowabstractskip = 0\p@%
       \vspace{6ex plus1ex minus1ex}%
     \else
       \vspace*{\belowabstractskip}%
     \fi}
\ifnoabstract
  \let\@absframe@\@empty
\else
  \let\@absframe@\frame
\fi
%
\newcommand{\abstractbreak}
  {\end{list}%
   \vspace{-28pt}%
   \null\par
   \end{minipage}%
   \end{lrbox}%
   \@upframe@{\usebox{\@abstractbox@}}%
   \vspace{2pc}%
   \par\pagebreak
   \let\@absframe@\@downframe@
   \noindent\begin{lrbox}{\@abstractbox@}%
   \begin{minipage}[t]{\textwidth}%
      \small
      \leavevmode\null                                         %????
      \begin{list}{}
 {\setlength{\leftmargin}{2pc}
  \setlength{\rightmargin}{\leftmargin}%
  \setlength{\itemindent}{0pt}%
  \setlength{\listparindent}{0pt}%
  \setlength{\labelsep}{0pt}%
  \setlength{\labelwidth}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\topsep}{18pt}
  \setlength{\parsep}{0pt}%
  \setlength{\itemsep}{0pt}}%
  \item\vspace{-20pt}}
\long\def\@upframe@#1{%
  \leavevmode
  \hbox{%
    \hskip-\@wholewidth
    \vbox{%
      \vskip-\@wholewidth
      \hrule \@height\@wholewidth
      \hbox{%
        \vrule\@width\@wholewidth
        #1%
        \vrule\@width\@wholewidth}}%
    \hskip-\@wholewidth}}
\long\def\@downframe@#1{%
  \leavevmode
  \hbox{%
    \hskip-\@wholewidth
    \vbox{%
      \hbox{%
        \vrule\@width\@wholewidth
        #1%
        \vrule\@width\@wholewidth}%
      \hrule\@height\@wholewidth
      \vskip-\@wholewidth}%
    \hskip-\@wholewidth}}
\setlength{\leftmargini}{2.5em}
\setlength{\leftmarginii}{2.2em}
\setlength{\leftmarginiii}{1.87em}
\setlength{\leftmarginiv}{1.7em}
\setlength{\leftmarginv}{1em}
\setlength{\leftmarginvi}{1em}
\setlength{\leftmargin}{\leftmargini}
\setlength{\labelsep}{.5em}
\setlength{\labelwidth}{\leftmargini}
\addtolength{\labelwidth}{-\labelsep}
\@beginparpenalty-\@lowpenalty
\@endparpenalty-\@lowpenalty
\@itempenalty-\@lowpenalty
\renewcommand{\theenumi}{\arabic{enumi}}
\renewcommand{\theenumii}{\alph{enumii}}
\renewcommand{\theenumiii}{\roman{enumiii}}
\renewcommand{\theenumiv}{\Alph{enumiv}}
\newcommand{\labelenumi}{\theenumi.}
\newcommand{\labelenumii}{(\theenumii)}
\newcommand{\labelenumiii}{\theenumiii.}
\newcommand{\labelenumiv}{\theenumiv.}
\renewcommand{\p@enumii}{\theenumi}
\renewcommand{\p@enumiii}{\theenumi(\theenumii)}
\renewcommand{\p@enumiv}{\p@enumiii\theenumiii}
\newcommand{\labelitemi}{$\m@th\bullet$}
\newcommand{\labelitemii}{\normalfont\bfseries --}
\newcommand{\labelitemiii}{$\m@th\ast$}
\newcommand{\labelitemiv}{$\m@th\cdot$}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand{\descriptionlabel}[1]{\hspace\labelsep
                                  \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\=\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item[]}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item[]}
               {\endlist}
\newenvironment{quotation}
   {\begin{list}{}{\setlength{\leftmargin}{0pt}%
   \setlength{\rightmargin}{0pt}%
   \setlength{\listparindent}{3em}%
   \setlength{\itemindent}{\listparindent}
   \setlength{\parsep}{4pt plus1pt minus0pt}
   \setlength{\topsep}{6pt plus2pt minus2pt}}
    \item[]}
   {\end{list}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\ifseqno\renewcommand{\theequation}{\themdsection.\arabic{equation}}\else
        \renewcommand\theequation{\arabic{equation}}\fi
\newif\ifcimsplit\cimsplitfalse
\AtBeginDocument{%
  \let\amssplit\split
  \let\endamssplit\endsplit
  \def\split{%
      \cimsplittrue
      \amssplit
  }
  \def\endsplit{%
      \endamssplit
      \cimsplitfalse
  }
  \def\lendsplit@{%
      \global\setbox9\vtop{\unvcopy\z@}%
      \ifinalign@
          \setbox\@ne\vbox{%
              \unvcopy\z@
              \global\setbox8\lastbox
          }%
          \setbox\@ne\hbox{%
              \unhcopy8%
              \unskip
              \setbox\tw@\lastbox
              \unskip
              \global\setbox\thr@@\lastbox
          }%
          \ifctagsplit@
              \ifcimsplit
                \gdef\split@{%
                  \hbox to\wd\thr@@{}%
                  &\vtop{\vbox{\moveleft\wd\thr@@\box9}}%
                }%
              \else
                \gdef\split@{%
                  \hbox to\wd\thr@@{}%
                  &\vcenter{\vbox{\moveleft\wd\thr@@\box9}}%
                }%
              \fi
          \else
              \gdef\split@{%
                  \hbox to\wd\thr@@{}%
                 &\vbox{\moveleft\wd\thr@@\box9}%
              }%
          \fi
      \else
          \ifctagsplit@
             \ifcimsplit
               \gdef\split@{\vtop{\box9}}%
             \else
               \gdef\split@{\vcenter{\box9}}%
             \fi
          \else
              \gdef\split@{\box9}%
          \fi
      \fi
      \aftergroup\split@
  }
}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength{\abovecaptionskip}{6pt}
\setlength{\belowcaptionskip}{6pt}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  {\protect\small{#1}\ \@dash@\ \if@intable@\itshape\fi#2\par\yesdash}%
  \vskip\belowcaptionskip}
\def\@fact@{!}
\def\@intrg@{?}
{\catcode`\!=\active\catcode`\?=\active
 \gdef\phantoms{\def\fact{\@fact@}\def\?{\@intrg@}%
\catcode`\!=\active\def!{\hphantom{0}}%
\catcode`\?=\active\def?##1{\hphantom{##1}}}
 \gdef\n@phantoms{\catcode`\!=12\catcode`\?=12}
}
\newcommand{\eqnsymbol}[1]
   {\def\@eqnnum{\hbox to.01pt{}%
                 \rlap{\reset@font\rmfamily\hskip -\textwidth #1}}}
\newif\if@eqnletter@\@eqnletter@false
\newcounter{subequation}
\renewcommand{\thesubequation}{\theequation\textit{\alph{subequation}}}
\setcounter{subequation}{1}
\def\@eqnletterinit@
  {\def\@eqnnum{\hbox to .01\p@{}%
                \rlap{\reset@font\rmfamily\hskip -\textwidth
                      (\thesubequation)}}%
   \def\@@eqncr{\let\@tempa\relax
      \ifcase\@eqcnt \def\@tempa{& & &}\or \def\@tempa{& &}%
       \or \def\@tempa{&}\else
         \let\@tempa\@empty
         \@latex@error{Too many columns in eqnarray environment}\@ehc\fi
       \@tempa \if@eqnsw\@eqnnum\stepcounter{subequation}\fi
       \global\@eqnswtrue\global\@eqcnt\z@\cr}%
   \@eqnletter@true}
\newenvironment{eqnletter}
  {\@eqnletterinit@
   \begin{eqnarray}}
  {\end{eqnarray}%
   \stepcounter{equation}\setcounter{subequation}{1}\aftergroup\ignorespaces}
\newenvironment{mathletters}
  {\@eqnletterinit@}
  {\stepcounter{equation}\setcounter{subequation}{1}\aftergroup\ignorespaces}
\newdimen\eqnarraycolsep
\setlength{\eqnarraycolsep}{.3em}
\def\eqnarray
  {\stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne\hskip \eqnarraycolsep \hfil${##}$\hfil
      &\global\@eqcnt\tw@ \hskip \eqnarraycolsep
         \if@eqnletter@\def\@currentlabel{\p@subequation\thesubequation}\fi
 $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hbox to\z@\bgroup\hss##\egroup
 \tabskip\z@skip
      \cr}
\newenvironment{eqnsystem}
   {\begingroup
    \def\arraystretch{1.5}%
    \setlength{\arraycolsep}{.2em}%
    \begin{equation}%
    \left\{
    \begin{array}{rcl}}%
   {\end{array}%
    \right.
    \end{equation}
    \endgroup\aftergroup\ignorespaces}%
\newif\if@intable@\@intable@false
\newcounter{table}
\renewcommand{\thetable}{\Roman{table}}
\def\fps@table{tb}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\textsc{\tablename}~\thetable.}
\newcommand{\tablename}{Table}
\newenvironment{table}[1][\fps@table]{%
  \@float{table}[#1]\protect\small\@intable@true
  \def\tnotes{\smallskip\par\smaller}
  \def\tnote##1{\par$({##1})$}
}
                 {\@intable@false\end@float}
\def\cim@o@sidewaystable[#1]{%
  \@rotfloat{table}[#1]%
  \protect\small\@intable@true
}%
\def\endsidewaystable{%
  \@intable@false
  \end@rotfloat
}%
\AtBeginDocument{%
  \def\sidewaystable{%
    \@ifnextchar[{%
      \cim@o@sidewaystable
    }{%
      \cim@o@sidewaystable[tbp]%
    }%
  }%
  %
  \renewenvironment{tabular}[2][]
      {\phantoms
       \def\hline{\noalign{\ifnum0=`}\fi
  \hrule height3pt depth0pt width0pt
  \hrule height\arrayrulewidth
  \hrule height3pt depth0pt width0pt
  \futurelet\reserved@a\@xhline}%
       \def\@cline##1-##2\@nil
  {\noalign{\vskip3pt}\omit
   \@multicnt##1%
   \advance\@multispan\m@ne
   \ifnum\@multicnt=\@ne\@firstofone{&\omit}\fi
   \@multicnt##2%
   \advance\@multicnt-##1%
   \advance\@multispan\@ne
   \leaders\hrule\@height\arrayrulewidth\hfill
   \cr\noalign{\ifnum0=`}\fi
   \vskip3pt
   \futurelet\reserved@a\@xcline}%
       \def\@xcline{\ifx\reserved@a\cline
    \vskip-\arrayrulewidth\vskip-6pt\fi
    \ifnum0=`{\fi}}%
       \def\tnote##1{\par$(^{##1})$}
       \begin{tabular*}{\textwidth}[#1]{@{\extracolsep{\fill}}#2@{}}}
      {\end{tabular*}\n@phantoms}%
   \setlength{\abovedisplayshortskip}{\abovedisplayskip}%
}
\newenvironment{narrowtabular}[3][]{%
    \phantoms
    \def\hline{%
        \noalign{%
            \ifnum0=`}\fi
            \hrule height3pt depth0pt width0pt
            \hrule height\arrayrulewidth
            \hrule height3pt depth0pt width0pt
            \futurelet\reserved@a\@xhline
        }%
    \def\@cline##1-##2\@nil{%
        \noalign{\vskip3pt}\omit
        \@multicnt##1%
        \advance\@multispan\m@ne
        \ifnum\@multicnt=\@ne\@firstofone{&\omit}\fi
        \@multicnt##2%
        \advance\@multicnt-##1%
        \advance\@multispan\@ne
        \leaders\hrule\@height\arrayrulewidth\hfill
        \cr\noalign{\ifnum0=`}\fi
        \vskip3pt
        \futurelet\reserved@a\@xcline
    }%
    \def\@xcline{%
	\ifx\reserved@a\cline
	\vskip-\arrayrulewidth\vskip-6pt\fi
	\ifnum0=`{\fi}}%
    \begin{tabular*}{\textwidth}[#1]
    {@{\hspace{#2}}@{\extracolsep{\fill}}#3@{\hspace{#2}}}}
   {\end{tabular*}\n@phantoms}
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure.}
\newcommand{\figurename}{Fig.}
%
%%%%%%%%%%%%%%%%%%%% new multifloat macros
%
\newif\ifcim@topfigs\cim@topfigsfalse
\newcommand{\topfigs}{\cim@topfigstrue}
\newif\ifcim@multiplefigure\cim@multiplefigurefalse
\newcounter{cim@cnt@fig}
\setcounter{cim@cnt@fig}{0}
\newcommand{\onefigure}[2][]{%
  \stepcounter{cim@cnt@fig}%
  \hbox to\hsize{\hfill\includegraphics*[#1]{#2}\hfill}%
}
\newcommand{\twofigures}[3][]{%
  \hbox to\hsize{%
    \vbox{%
       \hbox{\includegraphics*[#1]{#2}}%
       \stepcounter{cim@cnt@fig}%
       \hbox{\small\figurename\ \thecim@cnt@fig}%
    }%
    \hfill
    \vbox{%
       \hbox{\includegraphics*[#1]{#3}}%
       \stepcounter{cim@cnt@fig}%
       \hbox{\small\figurename\ \thecim@cnt@fig}}%
    \hfill
  }%
}
\newcommand{\threefigures}[4][]{%
  \hbox to\hsize{%
    \vbox{%
       \hbox{\includegraphics*[#1]{#2}}%
       \stepcounter{cim@cnt@fig}%
       \hbox{\small\figurename\ \thecim@cnt@fig}%
    }%
    \hfill
    \vbox{%
       \hbox{\includegraphics*[#1]{#3}}%
       \stepcounter{cim@cnt@fig}%
       \hbox{\small\figurename\ \thecim@cnt@fig}}%
    \hfill
    \vbox{%
       \hbox{\includegraphics*[#1]{#4}}%
       \stepcounter{cim@cnt@fig}%
       \hbox{\small\figurename\ \thecim@cnt@fig}}%
    \hfill
  }%
}
\newcommand{\oneimage}[2][]{
  \ifcim@multiplefigure\else\stepcounter{cim@cnt@fig}\fi
  \hbox to\hsize{%
    \hbox{\includegraphics*[#1]{#2}}\hfill
  }%
  \cim@multiplefiguretrue
}
\newcommand{\twoimages}[3][]{
  \ifcim@multiplefigure\else\stepcounter{cim@cnt@fig}\fi
  \hbox to\hsize{%
    \hbox{\includegraphics*[#1]{#2}}\hfill
    \hbox{\includegraphics*[#1]{#3}}\hfill
  }%
  \cim@multiplefiguretrue
}
\newcommand{\threeimages}[4][]{
  \ifcim@multiplefigure\else\stepcounter{cim@cnt@fig}\fi
  \hbox to\hsize{%
    \hbox{\includegraphics*[#1]{#2}}\hfill
    \hbox{\includegraphics*[#1]{#3}}\hfill
    \hbox{\includegraphics*[#1]{#4}}\hfill
  }%
  \cim@multiplefiguretrue
}
\newcommand{\fourimages}[5][]{
  \ifcim@multiplefigure\else\stepcounter{cim@cnt@fig}\fi
  \hbox to\hsize{%
    \hbox{\includegraphics*[#1]{#2}}\hfill
    \hbox{\includegraphics*[#1]{#3}}\hfill
    \hbox{\includegraphics*[#1]{#4}}\hfill
    \hbox{\includegraphics*[#1]{#5}}\hfill
  }%
  \cim@multiplefiguretrue
}
%%%%%%%%%%%%%%%
\newenvironment{figure}{%
%	\cim@tablecaptionfalse
	\setcounter{cim@cnt@fig}{\thefigure}%
	\cim@topfigsfalse
	\@float{figure}
}{%
	\end@float
}
\newenvironment{figure*}{%
%  \cim@tablecaptionfalse
    \setcounter{cim@cnt@fig}{\thefigure}%
    \cim@multiplefiguresfalse
    \cim@topfigsfalse
  \@dblfloat{figure}%
}{%
  \end@dblfloat
}

\newcommand{\appendix}
   {\par
    \setlength{\baselineskip}{11pt}%
    \setcounter{section}{0}%
    \setcounter{subsection}{0}%
    \newif\if@firstapp@\@firstapp@true%
    \renewcommand{\thesection}{{\normalfont\Alph{section}}}%
    \ifseqno\renewcommand{\themdsection}{{\normalfont\Alph{section}}}\else
            \newcommand{\themdsection}{{\normalfont\Alph{section}}}\fi
    \renewcommand{\theequation}{\themdsection.\arabic{equation}}%
    \def\cim@numberline@fmt##1{Appendix \csname the##1\endcsname.}%
    \addtocontents{toc}{\@tochskip@b=6.8em\relax}%
    \renewcommand{\section}[1]
       {\setcounter{equation}{0}%
        \def\@tempa{##1}%
\ifx\@tempa\cim@star\def\@temp@{\@ssection@}%
                \if@firstapp@\@firstapp@false
                              \renewcommand{\themdsection}{{\normalfont A}}\fi
\else\ifx\@tempa\cim@bra\def\@temp@{\@osection@[}%
     \else\def\@temp@{\@section@[##1]{##1}}%
     \fi
\fi\@temp@}%
    \newcommand{\@ssection@}[1]{\@section@*{##1}}%
    \renewcommand{\@section@}%
{\@startsection{section}{1}{0pt}{4ex plus1.5ex minus.2ex}%
       {2.2ex plus.2ex minus.1ex}%
       {\normalfont\normalsize
\noindent\textsc{Appendix}\ \bfseries}}%
    \renewcommand{\@sectionfmt@}[1]{\par\nopagebreak\bigskip\noindent ##1}%
    \newcommand{\@ssectionfmt@}[1]{\def\@temp@{##1}\ifx\@temp@\@undefined
                                          \else\par\nopagebreak\bigskip
                                          \noindent\fi ##1}}
\newlength{\@tochskip@a}
\setlength{\@tochskip@a}{4em}
\newlength{\@tochskip@b}
\setlength{\@tochskip@b}{2em}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \begingroup
    \small
    \noindent\rule{\textwidth}{.4pt}\par
    \@starttoc{toc}%
    \noindent\rule{\textwidth}{.4pt}\par
    \endgroup
    }
\newif\iftoc@steppage\toc@steppagefalse
\newcommand{\steppage}{\toc@steppagetrue}
\def\@pnumwidth{48pt}
\def\@tocrmarg{51.2pt}
\def\@dotsep{2.2}
% \@tocline{indentcount}{extraindentcount}{text}{page}
\def\@tocline#1#2#3#4{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \begingroup
      \setlength\@tempdima{#2\@tochskip@b}%
      \parindent \z@
      \leavevmode
      \advance\@tochskip@a#1\@tochskip@b
      \advance\leftskip\@tochskip@a
      \advance\leftskip\@tempdima
      \hskip-\@tempdima
      \hbox to0pt{\hss\hbox to\@tochskip@a{\hbox to1em{\hfill #4}\hfill}}%
      #3\par
    \endgroup
  \fi}
% \@dottedtocline{depth}{indentlen}{extraindentlen}{text}{page}
\def\@dottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \begingroup
      \small
      \vskip \z@ \@plus.2\p@
      \leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
      \parindent #2\relax\@afterindenttrue
      \interlinepenalty\@M
      \leavevmode
      \@tempdima #3\relax
      \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
      {#4}\nobreak
      \leaders\hbox{$\m@th
	 \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
	 mu$}\hfill
      \nobreak
      \hb@xt@\@pnumwidth{\hskip10pt\normalfont \normalcolor \small
                         \iftoc@steppage p.\global\toc@steppagefalse
                         \else\hskip5pt\guillemotright\fi
                         \hfil
                         #5}%
      \par
    \endgroup
  \fi
}
% \@largedottedtocline{depth}{indentlen}{extraindentlen}{text}{page}
\def\@largedottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \begingroup
      \vskip 10pt \@plus.2\p@
      \leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
      \parindent #2\relax\@afterindenttrue
      \interlinepenalty\@M
      \leavevmode
      \@tempdima #3\relax
      \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
      {\normalsize #4}\nobreak
      \leaders\hbox{$\m@th
	 \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
	 mu$}\hfill
      \nobreak
      \hb@xt@\@pnumwidth{\hskip10pt\normalfont \normalcolor \small
                         \iftoc@steppage p.\global\toc@steppagefalse
                         \else\hskip5pt\guillemotright\fi
                         \hfil
                         #5}%
      \par
      \vskip 4pt plus .2pt
    \endgroup
  \fi
}
\ifvolume
  \newcommand*\l@title{\bigskip\@largedottedtocline{0}{0pt}{0pt}}
  \newcommand*\l@section{\@dottedtocline{0}{14pt}{16pt}}
  \newcommand*\l@subsection{\@dottedtocline{1}{30pt}{24pt}}
  \newcommand*\l@subsubsection{\@dottedtocline{2}{54pt}{30pt}}
  \newcommand*\l@paragraph{\@dottedtocline{3}{84pt}{0pt}}
  \newcommand*\l@subparagraph{\@dottedtocline{4}{0pt}{0pt}}
\else
  \newcommand*\l@title{\@tocline{0}{0}}
  \newcommand*\l@section{\@tocline{0}{1}}
  \newcommand*\l@subsection{\@tocline{1}{1.3}}
  \newcommand*\l@subsubsection{\@tocline{2.3}{1.7}}
  \newcommand*\l@paragraph{\@tocline{4}{1}}
  \newcommand*\l@subparagraph{\@tocline{5}{1}}
\fi
\newcommand\listoffigures{%
    \section*{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\def\@begintheorem#1#2{%
   \def\thesection{{\normalfont\itshape\arabic{section}}}%
   \trivlist
   \item[\hskip \labelsep{\itshape #1\ #2}.]\itshape}
\def\@opargbegintheorem#1#2#3{\trivlist
      \item[\hskip \labelsep{\itshape #1\ #2\ (#3)}.]\itshape}
\newcommand\newblock{}
\newenvironment{thebibliography}[1]
     {\cim@secstar@true
      \@startsection{section}{1}{0pt}{5ex plus3ex minus1ex}
    {3ex plus.5ex minus1ex}{\normalfont\small}*{\MakeUppercase\refname}%
      \ifbareref
        \let\bibitem\item
        \begin{list}{}
           {\setlength{\labelwidth}{0pt}\setlength{\labelsep}{0pt}%
            \setlength{\itemindent}{-\parindent}%
            \setlength{\listparindent}{0pt}%
            \setlength{\leftmargin}{\labelwidth}%
              \addtolength{\leftmargin}{\labelsep}%
              \addtolength{\leftmargin}{-\itemindent}%
            \setlength{\rightmargin}{0pt}
            \setlength{\partopsep}{0pt plus0pt minus0pt}%            %????
            \setlength{\topsep}{0pt plus0pt minus0pt}%
            \setlength{\parsep}{0pt plus1pt minus0pt}%
            \setlength{\itemsep}{0pt plus1pt minus0pt}}
      \else
        \begin{marginlist}[\usecounter{enumiv}%
      \let\p@enumiv\@empty
                           \renewcommand{\theenumiv}{\arabic{enumiv}}]
                          {\@biblabel{\arabic{enumiv}}}%
                          {\@biblabel{#1}}%
      \fi
      \sloppy\hyphenpenalty10000\clubpenalty4000\widowpenalty4000%
      \sfcode`\.=\@m
      \small}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \ifbareref
        \end{list}
      \else
         \end{marginlist}
      \fi}
\newcommand{\NAME}[1]{\textsc{#1}}
\let\name\NAME
\newcommand{\BY}[1]{\NAME{#1},}
\newcommand{\IN}[4]{\textit{#1}, \textbf{#2} (#3) #4}
\newcommand{\SAME}[3]{\textbf{#1} (#2) #3}
\newcommand{\TITLE}[1]{\textit{#1}}
\newcommand{\ADLIB}[1]{{#1}}
\let\Author\BY
\let\Name\BY
\newcommand{\Review}[1]{\textit{#1},}
\newcommand{\Vol}[1]{\textbf{#1}}
\newcommand{\Year}[1]{(#1)}
\newcommand{\Page}[1]{#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}

\ifrcover
   \gdef\title#1{\gdef\@@rawtitle{#1}}
   \gdef\author#1{\gdef\@@rawauthor{#1}}
   \gdef\rev#1{\def\@rawrev{#1}}
   \gdef\vol#1{\def\@vol{#1}}
   \gdef\issue#1{\def\@issue{#1}}
   \gdef\firstpage#1{\gdef\@firstpage{#1}}
   \gdef\lastpage#1{\gdef\@lastpage{#1}}
   \gdef\reprintyear#1{\gdef\paper@year{#1}}
   \gdef\month#1{\gdef\paper@month{#1}}
   \renewcommand{\@maketitle}
   {%
	\thispagestyle{empty}
	\begin{flushright}
	\bgroup\bfseries\Large\@@rawtitle\egroup\par
        \bigskip
        \bigskip
	\bgroup\large\@@rawauthor\egroup
	\vskip100pt
	\sffamily
	Estratto da\par
        \bigskip
	\textsl{\@rawrev}\par
	\bigskip
	Vol.~\@vol\ - N.~\@issue\ - \paper@month~\paper@year\ - pp.~\@firstpage-\@lastpage\par
	\vfill\null
	\bfseries\Large SIF Bologna\par
	\number\year\par
	\bigskip
	\end{flushright}
   }
\fi


\iftoc
\def\@subvolume@{?}
\def\@issuemonth@{?}
\def\@issueyear@{?}
\def\@issuefirstpage@{?}
\def\@issuelastpage@{?}
\def\@NIF@{%
  \if A\@subvolume@
    NIFAAM%
  \else
    \if B\@subvolume@
      NIFBAP%
    \else
      \if C\@subvolume@
        NIFCAS%
      \else
        \if D\@subvolume@
          NCSDDN%
        \else
          NIF???%
        \fi
      \fi
    \fi
  \fi
}
\def\@ISSN@{%
  \if A\@subvolume@
    ISSN 0392-3546%
  \else
    \if B\@subvolume@
      ISSN 2037-4895%
    \else
      \if C\@subvolume@
        ISSN 2037-4909%
      \else
        \if D\@subvolume@
          ISSN 0392-6737%
        \else
          ISSN ???%
        \fi
      \fi
    \fi
  \fi
}
\font\XXXIIcmbx=ptmb7t at 31pt
\newcommand{\logofont}{\XXXIIcmbx\setlength{\baselineskip}{31pt}}
\pagestyle{empty}
\setlength{\textwidth}{14cm}
\renewcommand{\issue}[8]{%
  \gdef\@volume@{#1}%
  \gdef\@subvolume@{#2}%
  \gdef\@series@{#3}%
  \gdef\@issue@{#4}%
  \gdef\@issuemonth@{#5}%
  \gdef\@issueyear@{#6}%
  \gdef\@issuefirstpage@{#7}%
  \gdef\@issuelastpage@{#8}%
}

\newcommand{\@maketitle}
   {\hbox to\hsize{\ifcover\else\hfill\fi
                   {\logofont\noindent IL NUOVO CIMENTO}%
                   \hfill}

    \vspace{12pt}
    \hrule\relax
    \vspace{8pt}
    {\large\noindent
     volume \@volume@\ \@subvolume@\hfill serie \@series@\hfill
     numero \@issue@\hfill\MakeLowercase{\@issuemonth@} \@issueyear@\par}
    \vspace{12pt}
    {\large\noindent \@NIF@\ \ \@volume@(\@issue@)
                     Paper ID \@issuefirstpage@-\@issuelastpage@\ (\@issueyear@)\par}
    \newlength\covertocskip
    \setlength{\covertocskip}{30 pt minus 18 pt}
    \vspace{\covertocskip}
    \vfil
    {\large\noindent \par}
    \vspace{12pt}}
\newcommand{\maketitle}
   {\thispagestyle{empty}%
    \newpage
    \@maketitle
    \def\ETC{}}
%
%
%
% % % \ifcim@special
% % % \thispagestyle{plain}%
% % % \pagestyle{plain}%
% % % \pagenumbering{Roman}%
% % % \renewcommand{\@maketitle}{%
% % %     \vspace{12pt}%
% % %     \hbox{\ifcover\else\hfill\fi
% % %           {\large{CONTENTS}}}%
% % %     \vspace{3cm plus3cm minus2cm}%
% % %     \par
% % % }
% % % \renewcommand{\maketitle}{%
% % %    \newpage
% % %    \@maketitle
% % %    \def\ETC{}%
% % % }
% % % \newif\ifcim@pageflag\cim@pageflagfalse
% % % \newenvironment{thetoc}{%
% % %   \small
% % %   \newcommand{\tocit}[3]{%
% % %     \textsc{##2}~--~##3\dotfill%
% % %     \ifcim@pageflag
% % %       \rlap{\hbox to1cm{\quad\hfill page\hfill}\hbox to1cm{\hfill##1}}%
% % %       \cim@pageflagfalse
% % %     \else
% % %       \rlap{\hbox to1cm{\quad\hfill$\scriptstyle{"}$\hfill}\hbox to1cm{\hfill##1}}%
% % %     \fi
% % %     \par
% % %     \pagebreak[3]%
% % %   }%
% % %   \newcommand{\tocem}[2]{%
% % %     \tocskip
% % %     {##2\dotfill}%
% % %     \ifcim@pageflag
% % %       \rlap{\hbox to1cm{\quad\hfill page\hfill}\hbox to1cm{\hfill##1}}%
% % %       \cim@pageflagfalse
% % %     \else
% % %       \rlap{\hbox to1cm{\quad\hfill$\scriptstyle{"}$\hfill}\hbox to1cm{\hfill##1}}%
% % %     \fi
% % %     \par
% % %     \pagebreak[3]%
% % %   }% 
% % %   \newcommand{\tocskip}{\medskip}%
% % %   \newcommand{\shortnotes}{%
% % %     \tocskip
% % %     \textbf{Note brevi}%
% % %     \par
% % %   }%
% % %   \newcommand{\erratum}{(\textit{Erratum})}%
% % %   \newcommand{\tocpage}{\cim@pageflagtrue}%
% % %   \renewcommand{\arraystretch}{1.3}%
% % %   \parindent=-.5cm
% % %   \leftskip=.5cm
% % %   \rightskip=2cm
% % %   \parskip=0pt plus12pt minus0pt
% % %   \sloppy
% % %   \tocpage
% % % }{%
% % %   \vfill
% % % }
% % % \else  %cim@special
\newenvironment{thetoc}
   {\small
    \def\@newline@{\\}
    \newcommand{\@resetnewline}{\def\@newline@{\\}}
    \newcommand{\tocit}[3]{\@newline@\@resetnewline
     \textbf{##1}&\textsc{##2}~-- ##3}%
    \newcommand{\tocem}[2]{\@newline@\@resetnewline\textbf{##1}&##2}%
    \newcommand{\tocskip}{\def\@newline@{\\[6pt]}}%
    \newcommand{\shortnotes}
       {\tocskip\@newline@
\multicolumn{2}{@{}l}{\textbf{Note brevi}}\@resetnewline}%
    \newcommand{\erratum}{(\textit{Erratum})}%
    \newcommand{\tocbreak}{\end{thetoc}\pagebreak\begin{thetoc}}%
    \renewcommand{\arraystretch}{1.3}%
    \noindent
    \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}rp{12.6cm}@{}}
      \multicolumn{2}{@{}l}{Paper ID}}
   {\end{tabular*}\vfill}
% % % \fi %cim@special
\fi %iftoc
%
%
%
\newcommand{\ISSN}{\par\hbox to\hsize{\hfill\@ISSN@}}
\ifindex
\newlength{\indexskipamount}%
\setlength{\indexskipamount}{\bigskipamount}%
\newcommand{\indexskip}{\vspace{\indexskipamount}}%
\def\@headindex{{\protect\scriptsize INDICI}}%
\def\@maketitle{%
  \noindent
  \ifchrono
    \ifcim@english
      {\large ???}%
    \else
      {\large Indice sistematico per numeri successivi del periodico}%
    \fi
  \else
    \ifalpha
      \ifcim@english
        {\large Author index}%
      \else
        {\large Indice alfabetico per autori}%
      \fi
    \else
      \ifalphaplain
        \ifcim@english
          {\large Author index}%
        \else
          {\large Indice alfabetico per autori}%
        \fi
      \else
        \ifpacs
          \ifcim@english
            {\large ???}%
          \else
            {\large Indice per materie}%
          \fi
        \else
          \ifhead
            \ifcim@english
              {\large ??? \@volume@\ \@section@,
                      ??? \@series@, \@year@}%
            \else
              {\large INDICI DEL VOLUME \@volume@\ \@section@,
                      SERIE \@series@, \@year@}%
            \fi
          \else
            \ifbooks
              \ifcim@english
                {\large ???}%
              \else
                {\large Indice delle recensioni}%
              \fi
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi
  \par
  \vspace{2cm}%
}
\renewcommand{\maketitle}{%
  \newpage
  \thispagestyle{empty}%
  \@maketitle
  \markboth{\@headindex}{\@headindex}
  \small
}
\newcommand{\indexitem}[4]{%
  \item[#2] \textsc{#3}~-- #4
}
\newcommand{\volume}[4]{%
  \gdef\@volume@{#1}\gdef\@section@{#2}\gdef\@series@{#3}%
  \gdef\@year@{#4}
}
\newcommand{\volumeend}{%
  \vfill
  Fine del Vol.\ \@volume@\ \@section@, Serie \@series@, \@year@\par
  \vfill
}
\ifchrono
  \newenvironment{indexissue}[1]{%
    \indexskip
    \noindent{#1}\par
    \noindent pag.\par
    \begin{marginlist}{}{0000}
  }{%
    \end{marginlist}%
  }
\fi
\ifalpha
  \newcommand{\indexitemref}[4]{%
    \item[#2] \textsc{#3} (vedi \textsc{#4})
  }
  \newenvironment{alphaindex}{%
    \indexskip
    \noindent pag.\par
    \begin{marginlist}{}{0000}%
  }{%
    \end{marginlist}%
  }
\fi
\ifalphaplain
  \newenvironment{alphaplainindex}{%
    \markboth{\@headindex}{\@headindex}
    \twocolumn[\maketitle\indexskip]%
    \parindent=0pt
    \small
  }{%
  }
  \renewcommand{\indexitem}[2]{%
    #2, #1\par
  }
\fi
\ifpacs
  \renewcommand{\indexitem}[4]{%
    \item[#2] #4 -- \textit{#3}
  }
  \newcommand{\indexpacssection}[2]{%
    \bigskip
    \noindent\textbf{#1. #2}\par
  }
  \newenvironment{indexpacs}[2]{%
    \indexskip
    \noindent\textbf{#1.} \textit{#2}\par
    \noindent pag.\par
    \begin{marginlist}{}{0000}%
  }{%
    \end{marginlist}%
  }
\fi
\ifbooks
  \newenvironment{booksindex}{%
    \indexskip
    \noindent pag.\par
    \begin{marginlist}{}{0000}%
  }{%
    \end{marginlist}%
  }
  \renewcommand{\indexitem}[3]{%
    \item[#1] \textsc{#2} -- #3
  }
\fi
\ifhead
  \renewcommand{\maketitle}{%
    \newpage
    \thispagestyle{empty}%
    \@maketitle
    \markboth{\@headindex}{\@headindex}
    \small
  }
\fi
\fi % index
\newenvironment{marginlist}[3][]
   {\begin{list}{#2}
       {\settowidth{\labelwidth}{#3}%
\setlength{\labelsep}{.6em}%
\setlength{\itemindent}{0pt}%
\setlength{\listparindent}{0pt}%
\setlength{\leftmargin}{\labelwidth}%
  \addtolength{\leftmargin}{\labelsep}%
          \addtolength{\leftmargin}{\itemindent}%
\setlength{\rightmargin}{0pt}%
\setlength{\partopsep}{0pt plus0pt minus0pt}%            %????
\setlength{\topsep}{0pt plus0pt minus0pt}%
\setlength{\parsep}{0pt plus1pt minus0pt}%
\setlength{\itemsep}{0pt plus1pt minus0pt}%
#1}}
   {\end{list}}
\newcommand\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\newcommand{\atque}{{\normalfont\MakeLowercase{and\ \ignorespaces}}}
\def\And{\atque}
\newcommand{\etal}{{\rmfamily\itshape\mdseries et al.}}
\newcommand{\idest}{{\rmfamily\itshape\mdseries i.e.}}
\newcommand{\jr}{{\upshape jr.}}
\newcommand{\acknowledgments}
           {\par\medskip{\centering$\ast\ \ast\ \ast$\par}\medskip}
\let\stars\acknowledgments
\let\solong\acknowledgments
\newcommand{\drm}{\mathrm{d}}        %MATH ONLY
\newcommand{\sy}[1]{\mathrm{#1}}     %MATH ONLY
\let\ab\sy
\newcommand{\tx}[1]{\mbox{#1}}
\newcommand{\un}[1]{{\,\mbox{#1}}}
\newcommand{\chem}[1]{\ensuremath{\mathrm{#1}}}
\newcommand{\mth}[1]{\ensuremath{#1}}
\newcommand{\acro}[1]{{\normalfont #1}}
\newcommand{\vcomment}[1]{%
  \unskip
  \ifcomments
    \marginpar{%
      \hrule height2pt
      \vspace*{4pt}
      {\raggedright\footnotesize\itshape #1\par}%
      \vspace*{4pt}
      \hrule height2pt
    }%
  \fi
}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\def\cal{\protect\pcal}
\newcommand{\pcal}{\@fontswitch{\relax}{\mathcal}}
\def\mit{\protect\pmit}
\newcommand{\pmit}{\@fontswitch{\relax}{\mathnormal}}
\def\protected@xdef{%
   \let\@@protect\protect
   \let\protect\@unexpandable@protect
   \afterassignment\restore@protect
   \xdef
}
\def\restore@protect{\let\protect\@@protect}
\ifgetdata
  \nonstopmode
  \AtBeginDocument{\end{document}}
  \renewcommand{\setcounter}[2]{%
    \def\@tempa{#1}%
    \def\@tempb{page}%
    \ifx\@tempa\@tempb
      \immediate\write16{#2}%
    \fi
  }
  \renewcommand{\title}[1]{%
    \let\\\@empty
    \let\ETC\@empty
    \let\thanks\@gobble
    \let\cartola\empty
    \immediate\write16{#1}%
  }
  \renewcommand{\author}[1]{%
    \def\\{\unskip, \ignorespaces}
    \let\ETC\@empty
    \let\thanks\@gobble
    \let\from\@gobble
    \immediate\write16{#1}%
  }
  \renewcommand{\PACSit}[2]{%
    \immediate\write16{#1}%
  }
\fi
\onecolumn

\ifconfig
  \InputIfFileExists{../cimento.cfg}{%
    \ClassWarningNoLine{cimento}{Using configuration file}%
  }{%
    \ClassInfo{cimento}{No configuration file}%
  }
  \InputIfFileExists{cimento.cfg}{%
    \ClassWarningNoLine{cimento}{Using configuration file}%
  }{%
    \ClassInfo{cimento}{No configuration file}%
  }
\fi
%
% index from article.cls
% teti 2002-03-28
%
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \columnseprule \z@
                \columnsep 35\p@
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \let\item\@idxitem
		\def\subitem{\@idxitem\hspace*{15pt}}
		\def\subsubitem{\@idxitem\hspace*{25pt}}}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\newif\if@restonecol
\newcommand\indexname{Index}


%
% -- Proofs stage
%

\newif\if@hasproofs\@hasproofsfalse
\let\nocomments\proofsfalse
\setlength{\marginparsep}{6pt}
\setlength{\marginparwidth}{20pt}
\newcounter{cim@vcnum}
\setcounter{cim@vcnum}{0}
\def\cim@vclist{}
\def\cim@vcbox#1{%
  %
}
\newcommand{\vproofs}[1]{%
  \unskip
  \ifproofs
    \global\@hasproofstrue
    \stepcounter{cim@vcnum}%
    \marginpar{\hbox to18.5pt{\hfill\framebox{\hbox to10pt{\hfill\color{red}{\bfseries \thecim@vcnum}\hfill}}}}%
    \protected@xdef\cim@vclist{%
      \cim@vclist\thecim@vcnum\quad#1\par
    }%
  \fi
}
\AtEndDocument{
  \ifproofs
      \onecolumn
      \newpage
      \thispagestyle{empty}%
      \parindent=-30pt
      \leftskip=10pt
      \rightskip=10pt
      \parskip=12pt
      \fontsize{12pt}{13pt}\sffamily\selectfont
      \nolinenumbers
	  \begin{center}
        Production Queries for the Author
      \par
	  \fontsize{9pt}{10pt}\sffamily\selectfont
	  AUTHOR: Please check VERY CAREFULLY throughout\\
	  1) TEXT (Copy-editing corrections already inserted in the manuscript-to-proofs process)\\
	  2) FIGURES (if any): All writings and symbols. Thank you
	  \end{center}
	  \par
      \vspace*{5pt}
      \cim@vclist
      \vspace*{4pt}
%    \fi
  \fi
}

%
% --- volume ---------------------------------------------------------------
%
%
% should we use a further flag such as \ifgeneratetoc instead of hooking
% the \ifvolume flag ?!?
%
\ifvolume
% this is a very stupid thing I did probably under the effect of some
% sort of psycotic disease
%  \usepackage[T1]{fontenc}
% /stupid-thing
  \newenvironment{voltoc}{%
    \noindent{\Large CONTENTS}\par
    \markboth{\textsc{contents}}{\textsc{contents}}%
    \vskip3cm
    \makeatletter
%    \let\thanks\@gobble
%    \let\footnote\@gobble
    \toc@steppagetrue
    \sloppy
  }{%
    \makeatother
  }
  \ClassWarningNoLine{cimento}{starting toc file}%
  \def\nc@starttoc#1{%
    \begingroup
      \makeatletter
      \if@filesw\expandafter\newwrite\csname tf@#1\endcsname
        \immediate\openout \csname tf@#1\endcsname \jobname.#1\relax
      \fi
      \global\@nobreakfalse
    \endgroup
  }
  \nc@starttoc{toc}%
\fi % volume
\AtEndDocument{%
 \if@ditorial
  \ifn@author
   \else
   \par
   \vskip24pt
   {\raggedleft\scshape\normalsize\noindent\raw@auth\par}%
   \ifx\author@signature\@empty\else\par\raggedleft\author@signature\par\fi
  \fi 
 \fi
}
\endinput
