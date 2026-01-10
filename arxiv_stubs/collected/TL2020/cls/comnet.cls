%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class file last modified by JMH April 2009
%%    IMA Journal of Complex Networks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{COMNET}
              [2012/12/11 v1.0
 Standard LaTeX document class]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\newif\ifnum@bib\num@bibtrue
\@titlepagefalse
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\DeclareOption{titlepage}{\@titlepagetrue}
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{numbib}{\num@bibtrue}
\DeclareOption{nonumbib}{\num@bibfalse}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}

\def\newsymbols#1{
\let\symb=#1
}

\DeclareOption{mathptmx}{\AtEndOfClass{\RequirePackage[subscriptcorrection,nofontinfo]{mathptmx}}
\DeclareMathSymbol\Gamma  {\mathord}{letters}{48}
\ifx Y\symb
\DeclareMathSymbol\Delta  {\mathord}{letters}{49}
\fi
\DeclareMathSymbol\Theta  {\mathord}{letters}{50}
\DeclareMathSymbol\Lambda {\mathord}{letters}{51}
\DeclareMathSymbol\Xi     {\mathord}{letters}{52}
\DeclareMathSymbol\Pi     {\mathord}{letters}{53}
\DeclareMathSymbol\Sigma  {\mathord}{letters}{54}
\DeclareMathSymbol\Upsilon{\mathord}{letters}{55}
\DeclareMathSymbol\Phi    {\mathord}{letters}{56}
\DeclareMathSymbol\Psi    {\mathord}{letters}{57}
\DeclareMathSymbol\Omega  {\mathord}{letters}{127}
}
\DeclareOption{mathptmx}{%
    \g@addto@macro{\@greeksetup}{%
        \DeclareMathSymbol\varGamma    {\mathord}{letters}{0}
    \ifx Y\symb
       \DeclareMathSymbol\varDelta    {\mathord}{letters}{1}
     \fi
       \DeclareMathSymbol\varTheta    {\mathord}{letters}{2}
       \DeclareMathSymbol\varLambda   {\mathord}{letters}{3}
       \DeclareMathSymbol\varXi       {\mathord}{letters}{4}
       \DeclareMathSymbol\varPi       {\mathord}{letters}{5}
       \DeclareMathSymbol\varSigma    {\mathord}{letters}{6}
       \DeclareMathSymbol\varUpsilon  {\mathord}{letters}{7}
       \DeclareMathSymbol\varPhi      {\mathord}{letters}{8}
       \DeclareMathSymbol\varPsi      {\mathord}{letters}{9}
       \DeclareMathSymbol\varOmega    {\mathord}{letters}{10}
      }
}
\DeclareOption{slantedgreek}{\def\@greeksetup{\AtBeginDocument{%
\renewcommand{\Gamma}{{\mit\varGamma}}
\ifx Y\symb
\renewcommand{\Delta}{{\mit\varDelta}}
\fi
\renewcommand{\Theta}{{\mit\varTheta}}
\renewcommand{\Lambda}{{\mit\varLambda}}
\renewcommand{\Xi}{{\mit\varXi}}
\renewcommand{\Pi}{{\mit\varPi}}
\renewcommand{\Sigma}{{\mit\varSigma}}
\renewcommand{\Upsilon}{{\mit\varUpsilon}}
\renewcommand{\Phi}{{\mit\varPhi}}
\renewcommand{\Psi}{{\mit\varPsi}}
\renewcommand{\Omega}{{\mit\varOmega}}
}}}
\newsymbols{Y}

\DeclareOption{uprightgreek}{\def\@greeksetup{}}

\ExecuteOptions{letterpaper,numbib,10pt,twoside,onecolumn,final,slantedgreek,times,mathptmx}
\ProcessOptions
\input{size1\@ptsize.clo}

\usepackage{lastpage,}
%%%%%%%%%%%%%%%%%%%%trim size setting
\textwidth145mm
\textheight46pc
\oddsidemargin7mm
\evensidemargin5mm
\topmargin59pt
\headsep16pt
\parindent15pt
\footskip24pt
\setlength{\fboxsep}{0pt}
\@greeksetup
%%%%%%%%%%%%%%%Plain Style

\def\jno#1{\gdef\@kxi{#1}}
\def\ps@plain{%
        \def\@oddfoot{\gridpl\hfill\fontsize{6.8}{9}\selectfont  $\copyright$
        The author \number\year. Published by Oxford University Press on behalf of
         the Institute of Mathematics and its Applications. All rights reserved.}
        %\let\@evenfoot\@empty
      \def\@evnhead{\CROPMARKSA}%
      \def\@oddhead{\CROPMARKSA\begin{tabular}{@{}l}\\[-1pt]\textit{IMA Journal of Complex Networks} (\number\year) Page \fpage\ of\hspace*{2pt} \lpage\\doi:10.1093/comnet/\@kxi\end{tabular}
      }%
       \let\@mkboth\markboth
}

\def\fpage{1}
\def\lpage{1}

\def\gridframe#1{
\let\grid=#1
\ifx Y\grid
\def\gridpl{\setlength{\fboxsep}{0pt}\setlength{\unitlength}{1pc}\begin{picture}(0,0)
\put(0,2){\framebox(34.4,47.4)}
\end{picture}}
\def\gridod{\setlength{\unitlength}{1pc}\begin{picture}(0,0)
\put(0,-47.35){\framebox(34.4,48)}
\end{picture}}
\def\gridev{\setlength{\unitlength}{1pc}\begin{picture}(0,0)
\put(0,-47.35){\framebox(34.4,48)}
\end{picture}}
\else
\def\gridpl{}
\def\gridod{}
\def\gridev{}
\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%Default font size
\renewcommand\normalsize{%
  \@setfontsize\normalsize{10}{12}%
  \abovedisplayskip 10\p@ \@plus 2\p@ \@minus5\p@
  \abovedisplayshortskip \z@ \@plus 3\p@
  \belowdisplayshortskip 6\p@ \@plus 3\p@ \@minus3\p@
 \parindent 15pt \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI\baselineskip12pt
  }
%%%%%%%%%%%%%%%%%%%%%%%%%

\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0pt\relax}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\CROPMARKSA\gridev\thepage \ of\ \pageref{LastPage}\hfill\fontsize{8}{8}\selectfont\leftmark \hfill }%
      \def\@oddhead{\CROPMARKSA\gridod\hfill{\fontsize{8}{8}\selectfont{\rightmark }}\hfill\thepage \ of\ \pageref{LastPage}}%
      \let\@mkboth\markboth
        }
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
     \def\@evenhead{\CROPMARKSA\gridev\thepage \centering \leftmark }%
      \def\@oddhead{\CROPMARKSA\gridod\hfill{\slshape\rightmark}\hfill\thepage}%
     \let\@mkboth\markboth
    \def\sectionmark##1{%
      }
\fi

\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }
  \if@titlepage
  \newcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\LARGE\@title \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\newcommand\maketitle{\par
  \begingroup
   \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
     \def\@makefnmark{{{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@12pt{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
        \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
      \markboth{\@shortauthorlist}{\@shorttitle}
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \newpage\setcounter{footnote}{0}
  \null
  \vspace*{12pt}%
  \parbox{132mm}{
  \begin{center}%
  \let \footnote \thanks
    {\fontsize{12}{15}\bf\selectfont \@title \par}%
    \vskip 1.2em%
    {
       {\fontsize{10}{12}\it\selectfont \@author\\[6pt]
       \rm[\@received\@revised\@accepted]\\[9.5pt]}
     }
          \vskip 1em%
  \end{center}
  }
  \vspace*{-.75pc}}
\fi

\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thesection {\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection .\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
\newcommand\part{%
   \if@noskipsec \leavevmode \fi
   \par
   \addvspace{4ex}%
   \@afterindentfalse
   \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >\m@ne
       \Large\bfseries \partname\nobreakspace\thepart
       \par\nobreak
     \fi
     %\huge \bfseries #2%
     \huge \bfseries #2%
     \markboth{}{}\par}%
    \nobreak
    \vskip 3ex
    \@afterheading}
\def\@spart#1{%
    {\parindent \z@ \raggedright
     \interlinepenalty \@M
     \normalfont
     \huge \bfseries #1\par}%
     \nobreak
     \vskip 3ex
     \@afterheading}
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Sectioning
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%\newcount\@secpenalty
\@secpenalty = -300

\newif\if@noskipsec \@noskipsectrue

\def\@startsection#1#2#3#4#5#6{\if@noskipsec \leavevmode \fi
   \par \@tempskipa #4\relax
   \@afterindenttrue
   \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
   \if@nobreak \everypar{}\else
     \addpenalty{\@secpenalty}\addvspace{\@tempskipa}\fi \@ifstar
     {\@ssect{#3}{#4}{#5}{#6}}{\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\@substartsection#1#2#3#4#5#6{\if@noskipsec \leavevmode \fi
   \par \@tempskipa #4\relax
   \@afterindenttrue
   \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
   \if@nobreak \everypar{}\else
     \addpenalty{\@secpenalty}\addvspace{\@tempskipa}\fi \@ifstar
     {\@ssect{#3}{#4}{#5}{#6}}{\@dblarg{\@subsect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\@subsubstartsection#1#2#3#4#5#6{\if@noskipsec \leavevmode \fi
   \par \@tempskipa #4\relax
   \@afterindenttrue
   \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
   \if@nobreak \everypar{}\else
     \addpenalty{\@secpenalty}\addvspace{\@tempskipa}\fi \@ifstar
     {\@sssect{#3}{#4}{#5}{#6}}{\@dblarg{\@subsubsect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\@subsubsect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \let\@svsec\@empty\else
     \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname\hskip 1em}\fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M   #8}%
        \endgroup
       \csname #1mark\endcsname{#7}\addcontentsline
         {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi
                    #7}\else
        \def\@svsechd{#6\hskip #3\relax  %% \relax added 2 May 90
                   \@svsec \itshape #8\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}

\def\@subsect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \let\@svsec\@empty\else
     \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname\hskip 1em}\fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M \itshape #8}%
        \endgroup
       \csname #1mark\endcsname{#7}\addcontentsline
         {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi
                    #7}\else
        \def\@svsechd{#6\hskip #3\relax  %% \relax added 2 May 90
                   \@svsec #8\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}

\def\@sect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \let\@svsec\@empty\else
     \refstepcounter{#1}\edef\@svsec{\csname the#1\endcsname.\hskip .5em}\fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M  #8\par}%
        \endgroup
       \csname #1mark\endcsname{#7}\addcontentsline
         {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi
                    #7}\else
        \def\@svsechd{#6\hskip #3\relax  %% \relax added 2 May 90
                   \@svsec #8\csname #1mark\endcsname
                      {#7}\addcontentsline
                           {toc}{#1}{\ifnum #2>\c@secnumdepth \else
                             \protect\numberline{\csname the#1\endcsname}\fi
                       #7}}\fi
     \@xsect{#5}}

\def\@xsect#1{\@tempskipa #1\relax
      \ifdim \@tempskipa>\z@
       \par \nobreak
       \vskip \@tempskipa
       \@afterheading
    \else \global\@nobreakfalse \global\@noskipsectrue
       \everypar{\if@noskipsec \global\@noskipsecfalse
                   \clubpenalty\@M \hskip -\parindent
                   \begingroup \@svsechd \endgroup \unskip
                   \hskip -#1\relax  % relax added 14 Jan 91
                  \else \clubpenalty \@clubpenalty
                    \everypar{}\fi}\fi\ignorespaces}

\def\@ssect#1#2#3#4#5{\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M #5\par}\endgroup
   \else \def\@svsechd{#4\hskip #1\relax #5}\fi
    \@xsect{#3}}

\newif\if@afterindent \@afterindenttrue

\def\@afterheading{\global\@nobreaktrue
      \everypar{\if@nobreak
                   \global\@nobreakfalse
                   \clubpenalty \@M
                   \if@afterindent \else {\setbox\z@\lastbox}\fi
                 \else \clubpenalty \@clubpenalty
                    \everypar{}\fi}}


% \@hangfrom{TEXT} : Puts TEXT in a box, and makes a hanging indentation
%    of the following material up to the first \par.  Should be used
%    in vertical mode.
%
\def\@hangfrom#1{\setbox\@tempboxa\hbox{#1}%
      \hangindent \wd\@tempboxa\noindent\box\@tempboxa}

\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {5.5pt\relax}%
                                   {\normalfont\normalsize\bf}}
\newcommand\subsection{\@substartsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {5.5pt\relax}%
                                     {\normalfont\normalsize}}
\newcommand\subsubsection{\@subsubstartsection{subsubsection}{3}{\z@}%
                                     {3.25ex \@plus1ex \@minus.2ex}%
                                     {-1em}%
                                     {\normalfont\normalsize}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\sc}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth0pt \leftmargin32pt\itemindent-\leftmargin
                        \let\makelabel\descriptionlabel
                                      }}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont #1\hspace*{-1pt}}
\if@titlepage
  \newenvironment{abstract}{%
      \titlepage
      \null\vfil
      \@beginparpenalty\@lowpenalty
      \begin{center}%
        \bfseries \abstractname
        \@endparpenalty\@M
      \end{center}}%
     {\vfil\null\endtitlepage}
\else
  \newenvironment{abstract}[2]{%
      \if@twocolumn
     %   \section*{\abstractname}%
      \else
        \small
    \fi \begin{minipage}{132mm}
        \vspace*{4pt}\fontsize{9}{11}\selectfont #1\\[8pt]\keyname #2\vspace*{6pt}}
            {\end{minipage}\vskip 1.5em}
\fi
\if@titlepage
  \newenvironment{msc}{%
      \titlepage
      \null\vfil
      \@beginparpenalty\@lowpenalty
      %\begin{center}%
        \bfseries \mscname
        \@endparpenalty\@M
      %\end{center}}%
     {\vfil\null\endtitlepage}
\else
  \newenvironment{msc}{%
      \if@twocolumn
        \section*{\mscname}%
      \else
        \small
        %\begin{center}%
          {\hspace{-21pt}\bfseries \mscname.\vspace{\z@}}%
        %\end{center}%
        %\quotation
        \vspace{12pt}
      \fi}
      {\if@twocolumn\else\fi}
\fi
\if@titlepage
  \newenvironment{key}{%
      \titlepage
      \null\vfil
      \@beginparpenalty\@lowpenalty
      %\begin{center}%
        \itseries \keyname
        \@endparpenalty\@M
      %\end{center}}%
     {\vfil\null\endtitlepage}
\else
  \newenvironment{key}{%
      \if@twocolumn
        \section*{\keyname}%
      \else
        \small
        %\begin{center}%
          {\hspace{-21pt}\bfseries \keyname.\vspace{\z@}}%
        %\end{center}%
        %\quotation
      \fi}
      {\if@twocolumn\else\fi}
\fi
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}

\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}

\newbox\boxH
\newbox\boxHrunin

\newenvironment{NumberedList}[1]{
  \setbox\boxH=\hbox{{#1}}%
 \begin{list}{\arabic{enumii}.}{%
 \usecounter{enumii}
  \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=2pt
 \parsep=0pt
 \labelsep=4.5pt
 \labelwidth\wd\boxH\advance\labelwidth\labelsep
 \leftmargin=24pt
%% \advance\leftmargin\labelsep
 \rightmargin=0pt
 \listparindent=0pt
 %\itemindent-\wd\boxH\advance\itemindent-\labelsep
% \itemindent-\labelsep
}}{\end{list}}%

%%%%%%%%%%%%%%%%%%%%bracketNL
%
%

\newenvironment{BNL}[1]{
  \setbox\boxH=\hbox{{#1}}%
 \begin{list}{\arabic{enumii})}{%
 \usecounter{enumii}
  \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=2pt
 \parsep=0pt
 \labelsep=6pt
 \labelwidth\wd\boxH\advance\labelwidth\labelsep
 \leftmargin=24pt
%% \advance\leftmargin\labelsep
 \rightmargin=0pt
 \listparindent=0pt
 %\itemindent-\wd\boxH\advance\itemindent-\labelsep
% \itemindent-\labelsep
}}{\end{list}}%

%%%%%%%%%%%%%%%%%AlphabetNL
%
\newenvironment{NumberedListAlpha}{
  \setbox\boxH=\hbox{{a)}}%
 \begin{list}{(\alph{enumii})}{%
 \usecounter{enumii}
  \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=2pt
 \parsep=0pt
 \labelsep=5pt
 \labelwidth\wd\boxH\advance\labelwidth\labelsep
 \leftmargin=28pt
%% \advance\leftmargin\labelsep
 \rightmargin=0pt
 \listparindent=0pt
 %\itemindent-\wd\boxH\advance\itemindent-\labelsep
% \itemindent-\labelsep
}}{\end{list}}%

%%%%%%%%%%%%%%roman NL
%
\newenvironment{NumberedListRoman}{
  \setbox\boxH=\hbox{{ii)}}%
 \begin{list}{(\roman{enumii})}{%
 \usecounter{enumii}
  \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=2pt
 \parsep=0pt
 \labelsep=5pt
 \labelwidth\wd\boxH\advance\labelwidth\labelsep
 \leftmargin18pt\advance\leftmargin\wd\boxH
 \rightmargin=0pt
 \listparindent=0pt
 %\itemindent-\wd\boxH\advance\itemindent-\labelsep
% \itemindent-\labelsep
}}{\end{list}}%

%%%%%%%%%%Double alpha NL
%
\newenvironment{DANL}[1]{
  \setbox\boxH=\hbox{{#1}}%
 \begin{list}{(\alph{enumii})}{%
 \usecounter{enumii}
  \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=2pt
 \parsep=0pt
 \labelsep=6pt
 \labelwidth\wd\boxH\advance\labelwidth\labelsep
 \leftmargin=24pt
%% \advance\leftmargin\labelsep
 \rightmargin=0pt
 \listparindent=0pt
 %\itemindent-\wd\boxH\advance\itemindent-\labelsep
% \itemindent-\labelsep
}}{\end{list}}%

\newenvironment{BulletedList}{
  \begin{list}{$\bullet$}{\fontsize{10}{12}\selectfont%
 \topsep=6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=6pt
 \parsep=0pt
 \labelsep=10pt
 \labelwidth\labelsep
 \leftmargin=14pt
 \rightmargin=0pt
 \listparindent=0pt}
}
{\end{list}}%

\newenvironment{UnnumberedList}{
  \begin{list}{}{
 \topsep=0pt %6pt plus 2pt minus 1.5pt
 \partopsep=0pt
 \itemsep=0pt
 \parsep=0pt
 %\labelsep=5pt
 %\labelwidth\labelsep
 \leftmargin=0pt
 \rightmargin=0pt
 \listparindent=0pt}
}
{\end{list}}%

\def\smlc{\fontencoding{OT1}\fontfamily{ptm}\fontseries{m}\fontshape{sc}\fontsize{10pt}{12pt}\selectfont}

\newenvironment{references}
               { %\vskip12pt\centering\fboxsep0pt\mbox{{\smlc References\vspace*{-2.5pt}}}
                          \fontsize{9}{11}\selectfont
        \list{}%
           {\vskip12pt\centering\mbox{\smlc References}\vspace*{5.5pt}
           \topsep0pt
           \labelwidth\z@%
            \leftmargin 18\p@
            \itemindent-\leftmargin
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
            \fontsize{9}{11}\selectfont\parindent\z@
            \itemsep1pt
            \parskip0pt\relax%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m
          }
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist
     }

\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
\if@compatibility
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@Alph\c@section}%
  \renewcommand{\theequation}{A.\arabic{equation}}%
  \renewcommand{\thelemma}{A.\arabic{lemma}}%
  \renewcommand{\thetheorem}{A.\arabic{theorem}}%
  \renewcommand{\thecorollary}{A.\arabic{corollary}}%
  \renewcommand{\thefigure}{A.\arabic{figure}}%
  \renewcommand{\thetable}{A.\arabic{table}}%
  \setcounter{equation}{0}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{1.2pc}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand \theequation {\@arabic\c@equation}
\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}
\newenvironment{figure}
               {\noindent\@float{figure}}
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
\setlength\abovecaptionskip{5\p@}
\addtolength\abovecaptionskip{2.9pt}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\noindent\fontsize{8}{9.5}\selectfont #1. #2}%
  \ifdim \wd\@tempboxa >\hsize
    \noindent\fontsize{8}{9.5}\selectfont #1. #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\newcounter{tblcap}
\renewcommand\thetblcap{\@arabic\c@tblcap}

\newsavebox{\tabbox}
\newlength{\tablen}

\long\def\tblcaption#1#2{
\sbox{\tabbox}{#2}
\settowidth{\tablen}{\usebox{\tabbox}}
%\addtolength{\tablen}{-18pt}
\refstepcounter{tblcap}
\vskip\abovecaptionskip
\centering\parbox[c]{\tablen}{
%\fontsize{9}{11}\selectfont
\noindent\mbox{\noindent
\sc Table \thetblcap.}\hskip4.5pt  {\it #1}}\\[7pt]
\fontsize{10}{11}\selectfont \mbox{#2}
}

\long\def\tblcaptionnotes#1#2#3{
\sbox{\tabbox}{#2}
\settowidth{\tablen}{\usebox{\tabbox}}
\vskip8pt\refstepcounter{tblcap}
\centering\parbox[c]{\tablen}{
\noindent\mbox{\noindent
\sc Table \thetblcap}\hskip4.5pt  {\it #1}}\\[7pt]
\fontsize{10}{11}\selectfont \mbox{#2}\\[6pt]
\hspace*{6pt}\parbox[l]{\tablen}{\fontsize{8}{10}\selectfont #3}}

\def\tblhead#1{\hline\\[-9pt]#1\\[1.5pt]\hline\\[-9.75pt]}
\def\lastline{\\\hline}
\def\phz{\phantom{0}}
\def\phzz{\phantom{00}}
\def\phzzz{\phantom{000}}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\RequirePackage{mathptmx}

\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    }
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}
\newcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\newcommand\listoffigures{%
    \section*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}

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
                  \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  %\kern-3\p@
  %\hrule\@width.4\columnwidth
  %\kern2.6\p@
  }
\newcommand\@makefntext[1]{%
    \parindent 6pt%
    \noindent
    \hb@xt@12pt{\hss\@makefnmark}\fontsize{8}{10}\selectfont #1}
\addtolength{\skip\footins}{6pt}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{F{\sc ig}.}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\mscname{\it Mathematical subject classification 2000:\ }
\newcommand\keyname{\emph{Keywords}:\ }
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagenumbering{arabic}
\thispagestyle{myheadings}
\if@twoside
\else
  \raggedbottom
\fi
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%begin_CROPMARKS
\newdimen\markwidth
\newdimen\marklength
\newdimen\markdistance
\newdimen\trimwidth
\newdimen\trimheight
\newdimen\rhsink
\newdimen\leftmarginodd
\newdimen\leftmargineven
\newdimen\leftmarginodda
\newdimen\leftmarginevena
\newdimen\auxaaa
\newdimen\auxbbb
\newdimen\auxccc
\newdimen\auxddd
\newdimen\tempbbb
\newdimen\rhsinka

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Numbers supplied down here!
\markwidth=.5pt %0.4 truept % Thickness of the mark line
\marklength=20 truept % Length of the mark line
\markdistance=-6 truept % Distance of the real corner to the beg. of the mark
\trimwidth=189mm
\trimheight=246mm
\rhsink=4.9pc %%%48 truept % Sink from the top of paper to the BASE of RH
                 %  where the crops are hooked to (2pc + height of 10pt digit
\leftmarginodd=5.6pc %%%77pt %%%  yyyy
\leftmargineven=4.76pc %%77pt %%%

\leftmarginodda=5.6pc %%%77pt %%%  yyyy
\leftmarginevena=4.76pc %%77pt %%%
\rhsinka=4.9pc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 \auxaaa\marklength\advance\auxaaa\markdistance
 \def\oddevenswitch{\ifodd\c@page \auxbbb=\leftmarginodd
  \else\auxbbb=\leftmargineven\fi}%

\def\oddevenswitcha{\ifodd\c@page \tempbbb=\leftmarginodda
  \else\tempbbb=\leftmarginevena\fi}%

\def\Vtrim{\VRHDW{20pt}{0pt}{1pt}}%
\def\Htrim{\VRHDW{1pt}{0pt}{20pt}}%

\def\ULtrim{\koo{-\markdistance}{0pt}{\zeroLR{\Htrim}}%
  \koo{0pt}{-\markdistance}{\zeroLR{\Vtrim}}}%
\def\URtrim{\koo{\markdistance}{0pt}{\zeroLL{\Htrim}}%
  \koo{0pt}{-\markdistance}{\zeroLL{\Vtrim}}}%
\def\LLtrim{\koo{-\markdistance}{0pt}{\zeroUR{\Htrim}}%
  \koo{0pt}{\markdistance}{\zeroUR{\Vtrim}}}%
\def\LRtrim{\koo{\markdistance}{0pt}{\zeroUL{\Htrim}}%
  \koo{0pt}{\markdistance}{\zeroUL{\Vtrim}}}%

\def\CROPMARKS{\oddevenswitch
  \koo{-\auxbbb}{-\rhsink}{%
     \koo{0pt}{0pt}{\ULtrim}%
     \koo{\trimwidth}{0pt}{\URtrim}%
     \koo{0pt}{\trimheight}{\LLtrim}%
     \koo{\trimwidth}{\trimheight}{\LRtrim}
     }}

\def\CROPMARKSA{\oddevenswitcha
  \koo{-\tempbbb}{-\rhsinka}{%
     \koo{0pt}{0pt}{\ULtrim}%
     \koo{\trimwidth}{0pt}{\URtrim}%
     \koo{0pt}{\trimheight}{\LLtrim}%
     \koo{\trimwidth}{\trimheight}{\LRtrim}
     }}

\def\CROPMARKS{\oddevenswitch
  \koo{-\auxbbb}{-\rhsink}{%
     \koo{0pt}{0pt}{\ULtrim}%
     \koo{\trimwidth}{0pt}{\URtrim}%
     \koo{0pt}{\trimheight}{\LLtrim}%
     \koo{\trimwidth}{\trimheight}{\LRtrim}
     }}

\def\CCROPMARKS{\oddevenswitch
 \hbox to0pt{\kern-\auxbbb\vbox to0bp{\kern-\rhsink\hbox to\trimwidth{%
 \koo{-\auxaaa}{0pt}{\VRHDW{\markwidth}{0pt}{\marklength}}%
 \koo{-\markwidth}{-\auxaaa}{\VRHDW{0pt}{\marklength}{\markwidth}}%
 \hfill
 \koo{\markdistance}{0pt}{\VRHDW{\markwidth}{0pt}{\marklength}}%
 \koo{0pt}{-\auxaaa}{\VRHDW{0pt}{\marklength}{\markwidth}}}%
 \nointerlineskip\vskip\trimheight
 \nointerlineskip\hbox to\trimwidth{%
 \koo{-\auxaaa}{0pt}{\VRHDW{0pt}{\markwidth}{\marklength}}%
 \koo{-\markwidth}{\markdistance}{\VRHDW{0pt}{\marklength}{\markwidth}}%
 \hfill
 \koo{\markdistance}{0pt}{\VRHDW{0pt}{\markwidth}{\marklength}}%
 \koo{0pt}{\markdistance}{\VRHDW{0pt}{\marklength}{\markwidth}}}\vss}\hss}}%

%\def\CROPMARKS{} %%%%%%%%% no cropmarks

%%%%%%%%%b-KOO
\long\def\koo#1#2#3{\vbox to0pt{\hsize0pt\kern #2\hbox to0pt{\kern
#1{#3}\hss}\vss}}
\long\def\zeroCC#1{\vbox to0pt{\vss\hbox to0pt{\hss #1\hss}\vss}}
\long\def\zeroLC#1{\vbox to0pt{\vss\hbox to0pt{\hss #1\hss}}}
\long\def\zeroUC#1{\vbox to0pt{\hbox to0pt{\hss #1\hss}\vss}}
\long\def\zeroLR#1{\vbox to0pt{\vss\hbox to0pt{\hss #1}}}
\long\def\zeroCR#1{\vbox to0pt{\vss\hbox to0pt{\hss #1}\vss}}
\long\def\zeroUR#1{\vbox to0pt{\hbox to0pt{\hss #1}\vss}}
\long\def\zeroLL#1{\vbox to0pt{\vss\hbox to0pt{#1\hss}}}
\long\def\zeroCL#1{\vbox to0pt{\vss\hbox to0pt{#1\hss}\vss}}
\long\def\zeroUL#1{\vbox to0pt{\hbox to0pt{#1\hss}\vss}}
\def\VRHDW#1#2#3{\vrule height #1 depth #2 width #3}
\def\HRHDW#1#2#3{\hrule height #1 depth #2 width #3}
\def\HD#1#2{\vrule height #1pt depth #2pt width 0pt\relax}
%%%%%%%%%e-KOO

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end_CROPMARKS

\newenvironment{reference}
               { \vskip12pt\centering{\smlc References\vspace*{-5.5pt}}
                          \fontsize{9}{11}\selectfont\list{}{
                         \topsep-18pt
                         \listparindent -18pt%
                         \leftmargin 18pt
                         \itemindent    \listparindent
                        \rightmargin0pt
                        \itemsep 0pt
                        \parsep0pt}%
                \item\relax}
               {\endlist}

\def\cropmark#1{
\let\crop=#1
\ifx N\crop
\def\CROPMARKSA{}
\def\CROPMARKS{}
\fi
}

% %%%%%%%%%%%%%%%%%%%%
% Standard theorem-like environments
% %%%%%%%%%%%%%%%%%%%%
\usepackage{dcolumn,amsthm}

\renewenvironment{proof}[1][Proof]{\noindent\textit{#1. } }{\hfill$\square$}

\newtheoremstyle{theorem}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{theorem}
\newtheorem{theorem}{\sc Theorem}[section]

\newtheoremstyle{lemma}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{lemma}
\newtheorem{lemma}{\sc Lemma}[section]

\newtheorem{acknowledgement}[theorem]{Acknowledgement}
\newtheorem{algorithm}[theorem]{Algorithm}
\newtheorem{axiom}[theorem]{Axiom}
\newtheorem{case}[theorem]{Case}
\newtheorem{claim}[theorem]{Claim}
\newtheorem{conclusion}[theorem]{Conclusion}
\newtheorem{condition}[theorem]{Condition}
\newtheorem{conjecture}[theorem]{Conjecture}
\newtheorem{criterion}[theorem]{Criterion}

\newtheoremstyle{example}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{example}
\newtheorem{example}[theorem]{\sc Example}

\newtheoremstyle{corollary}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{corollary}
\newtheorem{corollary}{\sc Corollary}[section]

\newtheoremstyle{definition}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{\sc Definition}

\newtheorem{exercise}[theorem]{Exercise}

\newtheorem{notation}[theorem]{Notation}
\newtheorem{problem}[theorem]{Problem}
\newtheorem{proposition}[theorem]{\sc Proposition}

\newtheoremstyle{remark}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{remark}
\newtheorem{remark}{\sc Remark}[section]
\newtheorem{solution}[theorem]{Solution}
\newtheorem{summary}[theorem]{Summary}

\newtheoremstyle{approximation}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{approximation}
\newtheorem{approximation}{\sc Approximation}

\newtheoremstyle{scheme}{6pt}{6pt}{\rm}{}{\sffamily}{ }{ }{}
\theoremstyle{scheme}
\newtheorem{scheme}{\sc Scheme}

% %%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%


\ifnum@bib
\usepackage[sort&compress,numbers]{natbib}
\def\@biblabel#1{{\bf #1.\ }}
\else
\usepackage{natbib}
\bibpunct{(}{)}{;}{a}{,}{,}
\def\@biblabel#1{}
\fi

\renewenvironment{thebibliography}[1]
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

\usepackage{times,amsmath}
\usepackage{latexsym,amssymb,lscape,multirow}
\usepackage{bm}
\let\geq=\geqslant
\let\leq=\leqslant
\let\ge=\geqslant
\let\le=\leqslant
\usepackage{ulem}
\normalem

\gridframe{N}
\cropmark{Y}
\jno{xxx000}

\renewcommand{\theequation}{\thesection.\arabic{equation}}
\numberwithin{equation}{section}

%\AtEndDocument{\label{lastpage}}
\AtBeginDocument{\label{FirstPage}}
\def\lpage{\pageref{LastPage}}
\def\fpage{\pageref{FirstPage}}

\def\received#1{%
\gdef\@received{Received on #1}}
\newcommand\revised[2][revised on]{%
\g@addto@macro\@revised{{; #1 #2}}}
\let\@revised\@empty
\newcommand\accepted[2][accepted on]{%
\g@addto@macro\@accepted{{; #1 #2}}}
\let\@accepted\@empty

\newcommand\monthname{January}
\ifnum\month=2 \renewcommand\monthname{February}\fi
\ifnum\month=3 \renewcommand\monthname{March}\fi
\ifnum\month=4 \renewcommand\monthname{April}\fi
\ifnum\month=5 \renewcommand\monthname{May}\fi
\ifnum\month=6 \renewcommand\monthname{June}\fi
\ifnum\month=7 \renewcommand\monthname{July}\fi
\ifnum\month=8 \renewcommand\monthname{August}\fi
\ifnum\month=9 \renewcommand\monthname{September}\fi
\ifnum\month=10 \renewcommand\monthname{October}\fi
\ifnum\month=11 \renewcommand\monthname{November}\fi
\ifnum\month=12 \renewcommand\monthname{December}\fi
\received{\number\day\space\monthname\space\number\year}

\def\shortauthorlist#1{\gdef\@shortauthorlist{\uppercase{#1}}}
\let\@shortauthorlist\@empty
\def\shorttitle#1{\gdef\@shorttitle{\uppercase{#1}}}
\let\@shorttitle\@empty

\pagestyle{headings}

\lefthyphenmin=3
\righthyphenmin=3

\def\name#1{\vskip5pt\par{{\sc #1}}}
\def\address#1{\par{\textit{#1}}}
\def\email#1{\par{\rm #1}}
\def\and{\par{\vskip4pt\sc and\par}}


\endinput
%%
%% End of file `comnet.cls'.
