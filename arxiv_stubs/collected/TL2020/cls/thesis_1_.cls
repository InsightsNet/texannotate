%% File: thesis.cls
%%
%% Author:
%% Dieter Schmitt
%% Max Planck Institute for Solar System Research
%% Max-Planck-Str. 2
%% D-37191 Katlenburg-Lindau
%% Germany
%%
%% Email: schmitt@mps.mpg.de
%%
%% For producing a PhD thesis for digital print and online publishing
%%
%% Modified according to the latest requirments by the Göttingen University: February 2014 by B. Beeck
%%
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\def\MyProvidesClass#1 [#2 #3 #4]
  {\ProvidesClass{#1}[#2 #3 #4]%
   \def\clsname{#1}\def\clsdate{#2}\def\clsversion{#3}\def\clsinfo{#4}}
\MyProvidesClass{thesis} [2014/02/18 2.2 (BB)]
%%
%% Version 1.2 (12 Jul 2005): change of Braunschweig title page, vec-->vect, ...
%% Version 1.3 (01 Oct 2006): change of Braunschweig title page, txfonts, pdfoutput
%% Version 1.4 (22 Dec 2006): options nottoc,notlof,notlot added to tocbibind
%% Version 1.5 (17 Apr 2007): change of Braunschweig title page
%% Version 1.6 (12 Oct 2007): Copernicus Publications and copyright
%% Version 1.7 (05 Mar 2008): change of copyright
%% Version 1.8 (22 Jul 2008): change of description
%% Version 1.9 (02 Dec 2009): change of Bibliografische Information on page 2
%% Version 2.0 (22 Mar 2010): uni-edition, amsmath
%% Version 2.1 (13 Aug 2010): Gauss title page
%% Version 2.2 (18 Feb 2014): Modifications for new requirements of Uni Gö
\newif\if@goe
\newif\if@bs
\newif\if@goeorbs
\newif\if@gauss
\newif\if@sub
\newif\if@acc
\newif\if@print
\newif\if@file
\newif\if@fem
\newif\if@german
\newif\if@hyper
\newif\if@addref
\DeclareOption{goettingen}{\@goetrue\@goeorbstrue\@subtrue}
\DeclareOption{gauss}{\@goetrue\@goeorbstrue\@subtrue\@gausstrue}
\DeclareOption{braunschweig}{\@bstrue\@goeorbstrue\@subtrue}
\DeclareOption{submitted}{\@subtrue}
\DeclareOption{additionalreferee}{\@addreftrue}
\DeclareOption{accepted}{\@acctrue\@subfalse}
\DeclareOption{print}{\@printtrue\@subfalse}
\DeclareOption{file}{\@filetrue\@subfalse}
\DeclareOption{female}{\@femtrue}
\DeclareOption{german}{\@germantrue}
\DeclareOption{hyper}{\@hypertrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\LoadClass[12pt]{book}
%%
\ifx\pdfoutput\undefined\else
   \setlength{\pdfpageheight}{29.7cm}
   \setlength{\pdfpagewidth}{21.0cm}
\fi
\setlength{\paperheight}{29.7cm}
\setlength{\paperwidth}{21.0cm}
\setlength{\textheight}{23.5cm}
\setlength{\textwidth}{15.0cm}
\setlength{\headheight}{2.0cm}
\setlength{\headsep}{0.8cm}
\setlength{\topskip}{12pt}
\setlength{\footskip}{30pt}
\setlength{\oddsidemargin}{0.46cm}
\setlength{\evensidemargin}{0.46cm}
\setlength{\topmargin}{-2.0cm}
%%
\ifx\pdfoutput\undefined
  \IfFileExists{graphicx.sty}{\RequirePackage[dvips]{graphicx}% LaTeX
    \DeclareGraphicsExtensions{.eps,.ps}}{}
   \IfFileExists{color.sty}{\RequirePackage{color}}{}
\else%
   \ifnum\pdfoutput=0
      \IfFileExists{graphicx.sty}{\RequirePackage[dvips]{graphicx}% LaTeX
      \DeclareGraphicsExtensions{.eps,.ps}}{}
      \IfFileExists{color.sty}{\RequirePackage{color}}{}
   \else
      \IfFileExists{graphicx.sty}{\RequirePackage[pdftex]{graphicx}% pdfLaTeX
      \DeclareGraphicsExtensions{.pdf,.png,.jpg}}{}
      \IfFileExists{color.sty}{\RequirePackage[pdftex]{color}}{}
      \pdfinfo{/Creator (thesis.cls version \clsversion)}
   \fi
\fi
%%
\IfFileExists{amsmath.sty}{\RequirePackage{amsmath}}{}
\IfFileExists{amssymb.sty}{\RequirePackage{amssymb}}{}
\IfFileExists{txfonts.sty}{\RequirePackage{txfonts}}{}
\IfFileExists{natbib.sty}{\RequirePackage{natbib}}{}
\bibpunct{(}{)}{,}{a}{}{,}
%\setlength{\bibsep}{0pt}
\IfFileExists{fancyhdr.sty}{\RequirePackage{fancyhdr}}{}
\IfFileExists{tocbibind.sty}{\RequirePackage[nottoc,notlof,notlot]{tocbibind}}{}
\IfFileExists{fontenc.sty}{\RequirePackage[T1]{fontenc}}{}
\IfFileExists{url.sty}{\RequirePackage{url}}{}
\IfFileExists{ifthen.sty}{\RequirePackage{ifthen}}{}
\IfFileExists{array.sty}{\RequirePackage{array}}{}
\IfFileExists{multicol.sty}{\RequirePackage{multicol}}{}
%%
\if@german
   \IfFileExists{german.sty}{\RequirePackage{german}}{}
   \def\captionsgerman{%
      \def\acknowname{Danksagung}%
      \def\refname{Literaturverzeichnis}%
      \def\abstractname{Zusammenfassung}%
%     \def\appendixname{Anhang}%
      \def\figurename{Abbildung}%
      \def\tablename{Tabelle}}
   \selectlanguage{german}
\else
   \def\captionsenglish{%
      \def\acknowname{Acknowledgement}%
      \def\refname{References}%
      \def\abstractname{Abstract}%
%     \def\appendixname{Appendix}%
      \def\figurename{Figure}%
      \def\tablename{Table}}
\fi
%%
\if@hyper\IfFileExists{hyperref.sty}{\RequirePackage{hyperref}}{}\fi
%%
\DeclareRobustCommand*{\vect}[1]{\ensuremath{%
\mathchoice{\mbox{\boldmath$\displaystyle#1$}}
           {\mbox{\boldmath$\textstyle#1$}}
           {\mbox{\boldmath$\scriptstyle#1$}}
           {\mbox{\boldmath$\scriptscriptstyle#1$}}}}
%%
\DeclareRobustCommand*{\chem}[1]{\ensuremath{\mathrm{#1}}}
\DeclareRobustCommand*{\unit}[1]{\def~{\,}\ensuremath{\mathrm{#1}}}
%%
\setcounter{topnumber}{2}
\def\topfraction{1.}
\setcounter{bottomnumber}{1}
\def\bottomfraction{1.}
\setcounter{totalnumber}{3}
\def\textfraction{0.}
\def\floatpagefraction{.7}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
%%
%\sloppy\clubpenalty4000\widowpenalty4000
%%
\def\town#1{\def\@town{#1}}               \def\@town{???}
\def\thesisadvisorycommitteea#1{\def\@taca{#1}}           \def\@taca{???}
\def\thesisadvisorycommitteeb#1{\def\@tacb{#1}}           \def\@tacb{???}
\def\thesisadvisorycommitteec#1{\def\@tacc{#1}}           \def\@tacc{???}
\def\instthesisadvisorycommitteea#1{\def\@insttaca{#1}}           \def\@insttaca{???}
\def\instthesisadvisorycommitteeb#1{\def\@insttacb{#1}}           \def\@insttacb{???}
\def\instthesisadvisorycommitteec#1{\def\@insttacc{#1}}           \def\@insttacc{???}
\def\refereea#1{\def\@refa{#1}}           \def\@refa{???}
\def\refereeb#1{\def\@refb{#1}}           \def\@refb{???}
\def\refereec#1{\def\@refc{#1}}           \def\@refc{???}
\def\commissiona#1{\def\@refd{#1}}           \def\@refd{???}
\def\commissionb#1{\def\@refe{#1}}           \def\@refe{???}
\def\commissionc#1{\def\@reff{#1}}           \def\@reff{???}
\def\commissiond#1{\def\@refg{#1}}           \def\@refg{???}
\def\instrefereea#1{\def\@instrefa{#1}}           \def\@instrefa{???}
\def\instrefereeb#1{\def\@instrefb{#1}}           \def\@instrefb{???}
\def\instrefereec#1{\def\@instrefc{#1}}           \def\@instrefc{???}
\def\instcommissiona#1{\def\@instrefd{#1}}           \def\@instrefd{???}
\def\instcommissionb#1{\def\@instrefe{#1}}           \def\@instrefe{???}
\def\instcommissionc#1{\def\@instreff{#1}}           \def\@instreff{???}
\def\instcommissiond#1{\def\@instrefg{#1}}           \def\@instrefg{???}
\def\submitteddate#1{\def\@subdate{#1}}   \def\@subdate{???}
\def\submittedyear#1{\def\@subyear{#1}}   \def\@subyear{\number\year}
\def\examinationdate#1{\def\@exdate{#1}}  \def\@exdate{???}
\def\publicationyear#1{\def\@pubyear{#1}} \def\@pubyear{\number\year}
\def\isbn#1{\def\@isbn{#1}}               \def\@isbn{???}
%%
\def\maketitle{%
\begin{titlepage}
\if@goe
%   \newgeometry{left=1.5cm,right=1.5cm}
   \vspace*{15mm}
   \begin{center}
   {\Huge\bfseries\@title\par}
   \vspace{25mm}
   {\large Dissertation\\[1mm]
   \if@gauss zur Erlangung des mathematisch-naturwissenschaftlichen Doktorgrades\else zur Erlangung des Doktorgrades\fi\\[7mm]
   \if@gauss ``Doctor rerum naturalium''\else der Mathematisch-Naturwissenschaftlichen Fakult\"aten\fi\\[7mm]
   \if@gauss der Georg-August-Universit\"at G\"ottingen\else der Georg-August-Universit\"at zu G\"ottingen\fi\\[10mm]
 	im Promotionsprogramm PROPHYS \\[3mm]
 	der Georg-August University School of Science (GAUSS)\\[28mm]  
   vorgelegt von\\[3mm]
   {\Large\bfseries\@author}\\[3mm]
   aus \@town
   \par\vspace{30mm}
   G\"ottingen, \space\@subyear}
% -------------------------------------------------------------------------------   
   \end{center}
%   \restoregeometry
\fi
\if@bs
   \if@sub
      \vspace*{5mm}
      \begin{center}
      {\Huge\bfseries\@title\par}
      \vspace{20mm}
      {\large Der Fakult\"at f\"ur Elektrotechnik, Informationstechnik, Physik\\[1mm]
      der Technischen Universit\"at Carolo-Wilhelmina zu Braunschweig\\[5mm]
      zur Erlangung des Grades \if@fem einer \else eines \fi \if@fem Doktorin \else Doktors \fi \\[1mm]
      der Naturwissenschaften (Dr. rer. nat.)\\[5mm]
      eingereichte Dissertation
      \vspace{10mm}
      von \@author\\[1mm]
      aus \@town\par}
      \end{center}
      \vspace{20mm}
      {\large 1. Referentin oder Referent: \@refa\\[1mm]
      2. Referentin oder Referent:\\[20mm]
      eingereicht am:\\[5mm]
      Disputation am:\\[20mm]
      Braunschweig,\par}
   \fi
   \if@acc
      \noindent
      \vspace*{5mm}
      \begin{center}
      {\Huge\bfseries\@title\par}
      \vspace{20mm}
      {\large Von der Fakult\"at f\"ur Elektrotechnik, Informationstechnik, Physik\\[1mm]
      der Technischen Universit\"at Carolo-Wilhelmina zu Braunschweig\\[5mm]
      zur Erlangung des Grades \if@fem einer \else eines \fi \if@fem Doktorin \else \\[1mm] Doktors \fi der Naturwissenschaften (Dr. rer. nat.)\\[10mm]
      genehmigte Dissertation}
      \end{center}
      \par\vspace{20mm}
      {\large von \@author\\[5mm]
      aus \@town\\[5mm]
      eingereicht am: \@subdate\\[5mm]
      Disputation am: \@exdate\\[5mm]
      1. Referentin oder Referent: \@refa\\[1mm]
      2. Referentin oder Referent: \@refb\\[5mm]
      Druckjahr: \@pubyear\par}
   \fi
   \if@print
      \noindent
      \vspace*{5mm}
      \begin{center}
      {\Huge\bfseries\@title\par}
      \vspace{20mm}
      {\large Von der Fakult\"at f\"ur Elektrotechnik, Informationstechnik, Physik\\[1mm]
      der Technischen Universit\"at Carolo-Wilhelmina zu Braunschweig\\[5mm]
      zur Erlangung des Grades \if@fem einer \else eines \fi \if@fem Doktorin \else \\[1mm] Doktors \fi der Naturwissenschaften (Dr. rer. nat.)\\[10mm]
      genehmigte Dissertation}
      \end{center}
      \vfill
      {\large von \@author\\[5mm]
      aus \@town\\[5mm]
      eingereicht am: \@subdate\\[5mm]
      Disputation am: \@exdate\\[5mm]
      1. Referentin oder Referent: \@refa\\[1mm]
      2. Referentin oder Referent: \@refb\\[10mm]
      Druckjahr: \@pubyear\par}
   \fi
\fi
\if@goeorbs\else\IfFileExists{firstpage.tex}{\include{firstpage}}
   {Please provide file firstpage.tex}\fi
\end{titlepage}
\newpage % second page
\thispagestyle{empty}
\if@goe
  \noindent
     \underline{Betreuungsausschuss} \\[6mm]
			 \@taca \\[1mm]
			 \@insttaca\\[6mm]
			 \@tacb \\[1mm]
			 \@insttacb \\[6mm]
			 \@tacc \\[1mm] 
			\@insttacc \\[10mm]
       \noindent
			 \underline{Mitglieder der Pr\"ufungskommision} \\[6mm]
			 Referent:  \@refa \\[1mm]
			 \@instrefa \\[6mm]
			 Korreferent: \@refb \\[1mm] 
			 \if@addref
			   \@instrefb \\[6mm]
                           2. Korreferent: \@refc \\[1mm] 
			   \@instrefc \\[10mm]
                         \else
                           \@instrefb \\[10mm]
                         \fi
	     \noindent
			 Weitere Mitglieder der Pr\"ufungskommission: \\[6mm]
			 \@refd \\[1mm] 
			 \@instrefd \\[6mm]
			 \@refe \\[1mm] 
			 \@instrefe \\[6mm]
			 \@reff \\[1mm] 
			 \@instreff \\[6mm]
			 \@refg \\[1mm] 
                         \if@addref
			   \@instrefg \\[11mm]
                         \else
                           \@instrefg \\[22mm]
                         \fi
                         
		\noindent
			Tag der m\"undlichen Pr\"ufung: \if@print\@exdate\fi%\par}
% -------------------------------------------------------------------------------
\vfill
   \if@print
   \newpage
   \thispagestyle{empty}
      \noindent {\large {\bfseries Bibliografische Information der Deutschen 
      Nationalbibliothek}\\[3mm]
      Die Deutsche Nationalbibliothek verzeichnet diese Publikation in der \\
      Deutschen Nationalbibliografie; detaillierte bibliografische Daten \\
      sind im Internet \"uber {\tt http://dnb.d-nb.de} abrufbar.
      \vfill 
      \noindent ISBN \@isbn\\[5mm]
      uni-edition GmbH \@pubyear\\[1mm]
      http://www.uni-edition.de\\[1mm]
      \copyright\ \@author\\[4mm]
      \includegraphics[width=25mm]{cc_by}\\
      \vskip-15.8mm\hskip22mm\parbox[b]{100mm}{This work is distributed under a \\
      Creative Commons Attribution 3.0 License}\\[5mm]
      Printed in Germany\par}
   \fi
   \if@file
      \IfFileExists{secondpage.tex}{\include{secondpage}}
      {Please provide file secondpage.tex}
   \fi
\fi
\if@bs
   \if@sub
      \null
   \fi
   \if@acc
      \vspace*{150mm}
      \noindent {\large 1. Referentin oder Referent: \@refa\\[1mm]
      2. Referentin oder Referent: \@refb\\[1mm]
      eingereicht am: \@subdate\\[1mm]
      m\"undliche Pr\"ufung (Disputation) am: \@exdate\par}
   \fi
   \if@file
      \IfFileExists{secondpage.tex}{\include{secondpage}}
      {Please provide file secondpage.tex}
   \fi  
   % -------------------------------------------------------------------------------
   \vfill
   \if@print
   \newpage
   \thispagestyle{empty}
      \noindent {\large {\bfseries Bibliografische Information der Deutschen 
      Nationalbibliothek}\\[3mm]
      Die Deutsche Nationalbibliothek verzeichnet diese Publikation in der \\
      Deutschen Nationalbibliografie; detaillierte bibliografische Daten \\
      sind im Internet \"uber {\tt http://dnb.d-nb.de} abrufbar.\par
      \vspace*{90mm}\noindent
      Dissertation an der Technischen Universit\"at Braunschweig,\\[1mm]
      Fakult\"at f\"ur Elektrotechnik, Informationstechnik, Physik\par
      \vfill
      \noindent ISBN \@isbn\\[5mm]
      uni-edition GmbH \@pubyear\\[1mm]
      http://www.uni-edition.de\\[1mm]
      \copyright\ \@author\\[4mm]
      \includegraphics[width=25mm]{cc_by}\\
      \vskip-15.8mm\hskip22mm\parbox[b]{100mm}{This work is distributed under a \\
      Creative Commons Attribution 3.0 License}\\[5mm]
      Printed in Germany\par}
   \fi
   \if@file
      \IfFileExists{secondpage.tex}{\include{secondpage}}
      {Please provide file secondpage.tex}
   \fi
\fi
\if@goeorbs\else\IfFileExists{secondpage.tex}{\include{secondpage}}
{Please provide file secondpage.tex}\fi
} % end of maketitle definition
%%
\newenvironment{cfig}{\begin{figure}[t]\begin{center}}{\end{center}\end{figure}}
%%
\def\chaptername{}
\def\appendixname{}
%%
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter\hskip2ex #1}
   {\thechapter\hskip2ex #1}}
\renewcommand{\sectionmark}[1]{\markright{\thesection\hskip2ex #1}}
\fancyhf{}
\fancyhead[LE]{\nouppercase{\leftmark}}
\fancyhead[RO]{\nouppercase{\rightmark}}
\fancyfoot[LE,RO]{\thepage}
\renewcommand{\footrulewidth}{0pt}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[LE,RO]{\thepage}%
   \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}}
%%
% avoids headings on otherwise empty pages before a new chapter
\def\cleardoublepage{\clearpage\if@twoside\ifodd\c@page\else
   \hbox{}\thispagestyle{empty}\newpage
   \if@twocolumn\hbox{}\newpage\fi\fi\fi}
%%
%\def\@schapter#1{\addcontentsline{toc}{chapter}{#1} % for toc
%   \@mkboth{#1}{#1}                                 % headings
%   \if@twocolumn\@topnewpage[\@makeschapterhead{#1}]
%   \else\@makeschapterhead{#1}\@afterheading\fi}
%
% problem: adds also toc to toc
%%
\def\@makechapterhead#1{\vspace*{50\p@}{\parindent\z@\raggedright
   \normalfont\interlinepenalty\@M\Huge\bfseries{%
   \@hangfrom{\hskip\z@\relax\thechapter\hskip2ex}#1\@@par}
   \par\nobreak\vskip40\p@}}
%%
\newcommand*\sun{\ensuremath{\odot}}
\newcommand*\degr{\ensuremath{^\circ}}
\newcommand*\arcmin{\ensuremath{^\prime}}
\newcommand*\arcsec{\ensuremath{^{\prime\prime}}}
\def\utw{\ensuremath{\smash{\rlap{\lower5pt\hbox{$\sim$}}}}}
\def\udtw{\ensuremath{\smash{\rlap{\lower6pt\hbox{$\approx$}}}}}
\newcommand*\fd{\ensuremath{\overset{\text{d}}{.}}}
\newcommand*\fh{\ensuremath{\overset{\text{h}}{.}}}
\newcommand*\fm{\ensuremath{\overset{\text{m}}{.}}}
\newcommand*\fs{\ensuremath{\overset{\text{s}}{.}}}
\newcommand*\fdg{\ensuremath{\overset{\circ}{.}}}
\newcommand*\farcm{\ensuremath{\overset{\prime}{.}}}
\newcommand*\farcs{\ensuremath{\overset{\prime\prime}{.}}}
\newcommand*\fp{\ensuremath{\overset{\scriptscriptstyle\text{p}}{.}}}
\newcommand*\cor{\ensuremath{\mathrel{\widehat{=}}}}
\newcommand*\aa@centerstack[2]{%
  \ensuremath{%
    \mathrel{%
      \mathchoice{%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\displaystyle##$\hfil\cr#1\cr#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\textstyle##$\hfil\cr#1\cr#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\scriptstyle##$\hfil\cr#1\cr#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\scriptscriptstyle##$\hfil\cr#1\cr#2\cr}%
        }%
      }%
    }%
  }%
}
\newcommand*\la{\aa@centerstack{<}{\sim}}
\newcommand*\ga{\aa@centerstack{>}{\sim}}
\newcommand*\sol{\aa@centerstack{\sim}{<}}
\newcommand*\sog{\aa@centerstack{\sim}{>}}
\newcommand*\lse{\aa@centerstack{<}{\simeq}}
\newcommand*\gse{\aa@centerstack{>}{\simeq}}
\newcommand*\aa@centerstackskip[6]{%
  \ensuremath{%
    \mathrel{%
      \mathchoice{%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\displaystyle##$\hfil\cr
            #1\cr\noalign{\vskip#3}#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\textstyle##$\hfil\cr
            #1\cr\noalign{\vskip#4}#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\scriptstyle##$\hfil\cr
            #1\cr\noalign{\vskip#5}#2\cr}%
        }%
      }
      {%
        \vcenter{%
          \offinterlineskip
          \halign{\hfil$\scriptscriptstyle##$\hfil\cr
            #1\cr\noalign{\vskip#6}#2\cr}%
        }%
      }%
    }%
  }%
}
\newcommand*\grole{\aa@centerstackskip{>}{<}{-1.5\p@}{-1.5\p@}{-1\p@}{-.5\p@}}
\newcommand*\leogr{\aa@centerstackskip{<}{>}{-1.5\p@}{-1.5\p@}{-1\p@}{-.5\p@}}
\newcommand*\loa{\aa@centerstack{<}{\approx}}
\newcommand*\goa{\aa@centerstack{>}{\approx}}
\newcommand*\diameter{%
  \ensuremath{%
    \mathchoice{%
      \ooalign{%
        \hfil\hbox{$\displaystyle/$}\hfil\crcr
        {\hbox{$\displaystyle\mathchar"20D$}}%
      }%
    }
    {%
      \ooalign{%
        \hfil\hbox{$\textstyle/$}\hfil\crcr
        {\hbox{$\textstyle\mathchar"20D$}}%
      }%
    }
    {%
      \ooalign{%
        \hfil\hbox{$\scriptstyle/$}\hfil\crcr
        {\hbox{$\scriptstyle\mathchar"20D$}}%
      }%
    }
    {%
      \ooalign{%
        \hfil\hbox{$\scriptscriptstyle/$}\hfil\crcr
        {\hbox{$\scriptscriptstyle\mathchar"20D$}}%
      }%
    }%
  }%
}
\let\olddiameter\diameter
\newcommand*\getsto{\aa@centerstack{\gets}{\to}}
\newcommand*\lid{\aa@centerstackskip{<}{=}{1.2\p@}{1.2\p@}{1\p@}{0.9\p@}}
\newcommand*\gid{\aa@centerstackskip{>}{=}{1.2\p@}{1.2\p@}{1\p@}{0.9\p@}}
\newcommand*\bbbone{%
  \ensuremath{%
    \mathchoice{\mathrm 1\mskip-4mu l}
               {\mathrm 1\mskip-4mu l}
               {\mathrm 1\mskip-4.5mu l}
               {\mathrm 1\mskip-5mu l}%
  }%
}

\newcommand*\aap{A\&A}
\let\astap=\aap
\newcommand*\aapr{A\&A~Rev.}
\newcommand*\aaps{A\&AS}
\newcommand*\actaa{Acta Astron.}
\newcommand*\aj{AJ}
\newcommand*\ao{Appl.~Opt.}
\let\applopt\ao
\newcommand*\apj{ApJ}
\newcommand*\apjl{ApJ}
\let\apjlett\apjl
\newcommand*\apjs{ApJS}
\let\apjsupp\apjs
\newcommand*\aplett{Astrophys.~Lett.}
\newcommand*\apspr{Astrophys.~Space~Phys.~Res.}
\newcommand*\apss{Ap\&SS}
\newcommand*\araa{ARA\&A}
\newcommand*\azh{AZh}
\newcommand*\baas{BAAS}
\newcommand*\bac{Bull. astr. Inst. Czechosl.}
\newcommand*\bain{Bull.~Astron.~Inst.~Netherlands}
\newcommand*\caa{Chinese Astron. Astrophys.}
\newcommand*\cjaa{Chinese J. Astron. Astrophys.}
\newcommand*\fcp{Fund.~Cosmic~Phys.}
\newcommand*\gca{Geochim.~Cosmochim.~Acta}
\newcommand*\grl{Geophys.~Res.~Lett.}
\newcommand*\iaucirc{IAU~Circ.}
\newcommand*\icarus{Icarus}
\newcommand*\jcap{J. Cosmology Astropart. Phys.}
\newcommand*\jcp{J.~Chem.~Phys.}
\newcommand*\jgr{J.~Geophys.~Res.}
\newcommand*\jqsrt{J.~Quant.~Spec.~Radiat.~Transf.}
\newcommand*\jrasc{JRASC}
\newcommand*\memras{MmRAS}
\newcommand*\memsai{Mem.~Soc.~Astron.~Italiana}
\newcommand*\mnras{MNRAS}
\newcommand*\na{New A}
\newcommand*\nar{New A Rev.}
\newcommand*\nat{Nature}
\newcommand*\nphysa{Nucl.~Phys.~A}
\newcommand*\pasa{PASA}
\newcommand*\pasj{PASJ}
\newcommand*\pasp{PASP}
\newcommand*\physrep{Phys.~Rep.}
\newcommand*\physscr{Phys.~Scr}
\newcommand*\planss{Planet.~Space~Sci.}
\newcommand*\pra{Phys.~Rev.~A}
\newcommand*\prb{Phys.~Rev.~B}
\newcommand*\prc{Phys.~Rev.~C}
\newcommand*\prd{Phys.~Rev.~D}
\newcommand*\pre{Phys.~Rev.~E}
\newcommand*\prl{Phys.~Rev.~Lett.}
\newcommand*\procspie{Proc.~SPIE}
\newcommand*\qjras{QJRAS}
\newcommand*\rmxaa{Rev. Mexicana Astron. Astrofis.}
\newcommand*\skytel{S\&T}
\newcommand*\solphys{Sol.~Phys.}
\newcommand*\sovast{Soviet~Ast.}
\newcommand*\ssr{Space~Sci.~Rev.}
\newcommand*\zap{ZAp}
%% End of file `thesis.cls'.