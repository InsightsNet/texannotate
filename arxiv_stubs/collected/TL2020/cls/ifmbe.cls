
\NeedsTeXFormat{LaTeX2e}
\def\ifmbe@version{1.0}
\def\ifmbe@filedate{2009/02/15}
\ProvidesClass{ifmbe}[\ifmbe@filedate\space v\ifmbe@version\space LaTeX2e document class]

% inform user
\typeout{^^J%
^^J++++++++++++++++++++++++++++++++++++++++++++++++++++++++
^^J+ document class IFMBE (\ifmbe@filedate) of Springer-Verlag +
^^J+ for the proceedings of the International Federation \space+
^^J+ for Medical and Biological Engineering \@spaces\@spaces\@spaces\space\space+
^^J++++++++++++++++++++++++++++++++++++++++++++++++++++++++
^^J}

\newif\ififmbe@abstract \ifmbe@abstractfalse
\newif\ififmbe@uppercase \ifmbe@uppercasetrue
\newif\ififmbe@oldcaption \ifmbe@oldcaptionfalse

\DeclareOption{abstract}{\ifmbe@abstracttrue}%
\DeclareOption{nouppercase}{\ifmbe@uppercasefalse} %
\DeclareOption{oldcaption}{\ifmbe@oldcaptiontrue} %
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}%

\ProcessOptions\relax

\LoadClass[10pt,twoside,a4paper,twocolumn,fleqn]{article}

\setlength\paperheight {277mm}
\setlength\paperwidth  {210mm}

\RequirePackage[noheadfoot, vmargin={25mm,40mm}, hmargin={19mm,14mm}]{geometry} %
\RequirePackage{times,mathptmx} %
\RequirePackage{fix2col,indentfirst} %
\RequirePackage{ifthen}
\usepackage{setspace}
\usepackage{array,multirow}

\ififmbe@oldcaption
      \RequirePackage[nooneline]{caption}
\else
      \RequirePackage[footnotesize,center,singlelinecheck=off]{caption}[2004/07/16] % requires version 3.0c
\fi

\usepackage{ifpdf}
\ifpdf
    \pdfinfo {
      /Title (CBEB MODEL 2020)
      /Subject ()
      /Author (Roberto L.A.P and Springer-Verlag)
      /Keywords ()
   }
\fi

\usepackage{graphicx} 
  
\columnsep6mm %
\parindent4mm %
\parsep\z@ %

\renewcommand\footnotesize{%
   \@setfontsize\small{8pt}\@ixpt
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \parsep 0\p@ \@plus1\p@ \@minus\p@
               \topsep 4\p@ \@plus2\p@ \@minus4\p@
               \itemsep0\p@}%
   \belowdisplayskip \abovedisplayskip
}
\def\@openbib@code{\footnotesize}

\frenchspacing %\loppy

\ififmbe@oldcaption
      \newcommand{\figurecaption}[1]{\abovecaptionskip10pt \belowcaptionskip\z@ \caption{#1}}
      \newcommand{\tablecaption}[1]{\abovecaptionskip\z@ \belowcaptionskip10pt \caption{#1}}
\else
      \abovecaptionskip 5pt \belowcaptionskip\z@ %
      \captionsetup[table]{position=top}
\fi


\pagestyle{empty}

\newcounter{ifmbe@asterisks}
\newcommand{\asterisks}[1]{\setcounter{ifmbe@asterisks}{#1}%
\whiledo{\value{ifmbe@asterisks}>0}{$^\ast$\addtocounter{ifmbe@asterisks}{-1}}}

\newcommand{\ifmbe@title}{}
\renewcommand{\title}[1]{\renewcommand{\ifmbe@title}{#1}}

\newcounter{ifmbe@temp}

\newcounter{ifmbe@affiliations}
\setcounter{ifmbe@affiliations}{0}

\newcommand{\affiliation}[2]{
      \stepcounter{ifmbe@affiliations}
      \expandafter\newcount\csname ifmbe@affiliationcounter#2\endcsname
      \csname ifmbe@affiliationcounter#2\endcsname=\value{ifmbe@affiliations}
      \expandafter\def\csname ifmbe@affiliation\alph{ifmbe@affiliations}%
      \endcsname{$^{\expandafter\the\csname ifmbe@affiliationcounter#2\endcsname}$ #1}
}

\newcommand{\ifmbe@processaffiliations}
{
      \newcommand{\ifmbe@affiliation}
      {
            \ifthenelse{\value{ifmbe@authors}>0}
            {
                  \setcounter{ifmbe@temp}{0}
                  \whiledo{\value{ifmbe@temp}<\value{ifmbe@affiliations}}
                  {
                        \stepcounter{ifmbe@temp}
                        \csname ifmbe@affiliation\alph{ifmbe@temp}\endcsname\linebreak
                  }
            }
            {
                  \ClassWarning{ifmbe}{No affiliations defined}
            }
      }
}

\newcounter{ifmbe@authors}
\setcounter{ifmbe@authors}{0}

\renewcommand{\author}[2]{
      \stepcounter{ifmbe@authors}
      \expandafter\def\csname ifmbe@author\alph{ifmbe@authors}\endcsname
      {#1$^{\expandafter\the\csname ifmbe@affiliationcounter#2\endcsname}$}
}

\newcommand{\ifmbe@processauthors}
{
\newcommand{\ifmbe@author}{
      \ifthenelse{\value{ifmbe@authors}>0}
            {\ifmbe@authora\setcounter{ifmbe@temp}{1}%
            \whiledo{\value{ifmbe@temp}<\value{ifmbe@authors}}{\stepcounter{ifmbe@temp}%
            \ifthenelse{\equal{\value{ifmbe@temp}}{\value{ifmbe@authors}}}{ and }{, }%
            \csname ifmbe@author\alph{ifmbe@temp}\endcsname}}
            {\ClassWarning{ifmbe}{No author names defined}}}
}

\newcommand{\ifmbe@email}{\ClassWarning{ifmbe}{No e-mail address defined}}
\newcommand{\email}[1]{\renewcommand{\ifmbe@email}{#1}}

\renewcommand{\maketitle}{
      \twocolumn[
            \begin{center}
                  \Large\bf
                  \ififmbe@uppercase\MakeUppercase{\ifmbe@title}\else\ifmbe@title\fi\\ % 14.4pt
                  \normalfont
                  \ififmbe@abstract
                        \vspace{60pt} % 5 more blank lines
                  \else
                        \ifmbe@processauthors
                        \vspace{8pt}
                        \large\ifmbe@author\\ % 12pt
                        \vspace{10pt} % 1 more blank line
                        \small\ifmbe@processaffiliations
                        \ifmbe@affiliation\\ % 12pt
                        %\ifmbe@email
                        %\vspace{12pt} % 1 more blank line
                  \fi
            \end{center}
      ]
}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\center \large \textsc}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\itshape}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\itshape}}


\renewenvironment{abstract}{\small \itshape Abstract---\bf}{}
\newenvironment{keywords}{\small \vspace{10pt} \itshape Keywords---\bf}{}


%% BEGIN IFAC

\newdimen\labelwidthi
\newdimen\labelwidthii
\newdimen\labelwidthiii
\newdimen\labelwidthiv

\def\normal@labelsep{0.5em}
\labelsep\normal@labelsep %


\settowidth{\labelwidthi}{(iii)} %
\settowidth{\labelwidthii}{(d)} %
\settowidth{\labelwidthiii}{(iii)} %
\settowidth{\labelwidthiv}{(M)} %

\leftmargini\labelwidthi %
% \advance\leftmargini\labelsep

\leftmarginii\labelwidthii %
\advance\leftmarginii\labelsep %

\leftmarginiii\labelwidthiii %
\advance\leftmarginiii\labelsep %

\leftmarginiv\labelwidthiv %
\advance\leftmarginiv\labelsep %

\def\setleftmargin#1#2{\settowidth{\@tempdima}{#2}\labelsep\normal@labelsep
  \csname labelwidth#1\endcsname\@tempdima
  \@tempdimb\@tempdima \advance\@tempdimb\labelsep
  \csname leftmargin#1\endcsname\@tempdimb}

% listI: \topsep changed from \z@ to 10pt

\def\@listI{\leftmargin\leftmargini
  \labelwidth\labelwidthi \labelsep\normal@labelsep
  \topsep10pt \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\labelwidthii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\labelwidthiii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiv{\leftmargin\leftmarginiv
  \labelwidth\labelwidthiv \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\let\@listi\@listI
\@listi
\def\left@label#1{{#1}\hss}
\def\right@label#1{\hss\llap{#1}}
\def\thick@label#1{\hspace\labelsep #1}
\newcount\@maxlistdepth
\@maxlistdepth=4
\def\labelitemi{$\bullet$}          \def\labelitemii{$\cdot$}
\def\labelenumi{\theenumi.}        \def\theenumi{\arabic{enumi}}
\def\labelenumii{(\alph{enumii})}   \def\theenumii{\theenumi\alph{enumii}}
\def\labelenumiii{(\roman{enumiii})}\def\theenumiii{\theenumii.\roman{enumiii}}
\def\labelenumiv{(\Alph{enumiv})}   \def\theenumiv{\theenumiii.\Alph{enumiv}}
\def\enumerate{%
  \ifnum \@enumdepth >\@maxlistdepth
    \@toodeep
  \else
    \advance\@enumdepth \@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
    \list{\csname label\@enumctr\endcsname}%
       {\usecounter{\@enumctr}
       \let\makelabel=\right@label}
  \fi}
\def\itemize{%
  \ifnum \@itemdepth >\@maxlistdepth
    \@toodeep
  \else
    \advance\@itemdepth \@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list{\csname\@itemitem\endcsname}%
       {\let\makelabel\right@label}
  \fi}

%% END IFAC

\renewcommand{\thesection}{\Roman{section}.\hspace{-3mm}}
\renewcommand{\thesubsection}{\Alph{subsection}.\hspace{-2mm}}
\def\tablename{\normalsize{T}\footnotesize{able}}
\def\figurename{\normalsize{F}\footnotesize{ig.}}

\def\@biblabel#1{#1.}

\bibliographystyle{ama}

\endinput
% end of file ifmbe.cls
