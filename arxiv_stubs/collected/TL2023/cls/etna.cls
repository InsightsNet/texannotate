% ETNA style file etna.cls
%
% Version Jan 2017 Final 
% Copyright 2017  Stefan  Kindermann/ETNA 
% This file may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either
% version 1.2 of this license or (at your option) any later
% version. The latest version of this license is in:
%
%    http://www.latex-project.org/lppl.txt
%
% and version 1.2 or later is part of all distributions of
% LaTeX version 1999/12/01 or later.


\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{etna}[2017/01/16  LaTeX document class]


\LoadClassWithOptions{article}              
\let \@textbottom \relax      

\@twosidetrue 
\@mparswitchtrue
\@twocolumnfalse


   \renewcommand{\normalsize}{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 10pt \@plus 2pt \@minus 5pt
   \abovedisplayshortskip \abovedisplayskip   
   \belowdisplayshortskip \belowdisplayskip    
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
   
   \renewcommand{\footnotesize}{%
   \@setfontsize\footnotesize\@viiipt{9.5}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \abovedisplayskip     
   \belowdisplayshortskip \belowdisplayskip     
   \def\@listi{\leftmargin\leftmargini
               \topsep 0pt                                      
               \parsep 0pt                                      
               \itemsep 0pt}%
   \belowdisplayskip \abovedisplayskip
}

\setlength\parindent{18pt}          
\setlength\headheight{10pt}        
\setlength\headsep{15pt}           
\setlength\footskip{15pt}             
\setlength\@maxdepth\maxdepth   
\setlength\textwidth{370pt}             
\setlength\textheight{596pt}        

\setlength\oddsidemargin{36pt}     
\setlength\evensidemargin{36pt}    
\setlength\marginparwidth{90pt}    

\if@compatibility
 \else
  \@settopoint\oddsidemargin                     
  \@settopoint\marginparwidth                     
\fi


\setlength\topmargin{0pt}                            
\skip\footins 13pt \@plus 4pt \@minus 2pt    
\setlength\partopsep{0pt}                             
                                                                     
\def\@listI{\leftmargin\leftmargini
            \parsep 0pt
            \topsep 0pt
            \itemsep 0pt}
\let\@listi\@listI
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    0pt
              \parsep     0pt
              \itemsep   0pt}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    0pt
              \parsep     0pt
              \partopsep 0pt
              \itemsep     0pt}


\renewcommand\topfraction{.9}                    
\renewcommand\bottomfraction{.2}              
\renewcommand\textfraction{.1}                   
\renewcommand\floatpagefraction{.9}            

\setlength{\floatsep}{6mm}
\setlength{\textfloatsep}{6mm}
\setlength{\intextsep}{6mm}


\setlength\leftmargini  {36pt}                  
\setlength\leftmargin{\leftmargini}         


    \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\rlap{\thepage}\hfil\upshape\footnotesize\MakeUppercase\leftmark\hfil}%          %!
      \def\@oddhead{\hbox{}\hfil{\upshape\footnotesize\MakeUppercase\rightmark}\hfil\llap{\thepage}}% %!
      \let\@mkboth\markboth
      \def\sectionmark##1{%
        \markboth {\uppercase{%
           \ifnum \c@secnumdepth >\z@
            \thesection\quad\fi
            ##1}}{}}%
      \def\subsectionmark##1{%
        \markright {%
          \ifnum \c@secnumdepth >\@ne
            \thesubsection\quad\fi
            ##1}}}
            
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\rlap{\thepage}\hfil\upshape\footnotesize\MakeUppercase\leftmark\hfil}%          %!
    \def\@oddhead{\hbox{}\hfil{\upshape\footnotesize\MakeUppercase\rightmark}\hfil\llap{\thepage}}% %!
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }

\renewcommand\maketitle{\par
  \begingroup
      \renewcommand\thefootnote{\@fnsymbol\c@footnote}%  
    \def\@makefnmark{\hbox to\z@{$\m@th^{\@thefnmark}$\hss}}%  
    \long\def\@makefntext##1{\parindent .25in\noindent                   
            \hb@xt@.25in{%                                                                   
            \hss$\m@th^{\@thefnmark}$}##1}%                                  
    \if@twocolumn                              
      \ifnum \col@number=\@ne            
        \@maketitle                                
      \else                                        
        \twocolumn[\@maketitle]%
      \fi
    \else
      \global\@topnum\z@   
      \@maketitle                                   
    \fi                                                   
    \thispagestyle{plain}\@thanks         
  \endgroup                                          
  \setcounter{footnote}{0}%               
  \let\maketitle\relax                             
  \let\@maketitle\relax                         
  \gdef\@thanks{}
  \gdef\@author{}
  \gdef\@title{}
  \let\thanks\relax%
  }        
\newif\if@tempswb
\def\@maketitle{%
  \null
  \begin{center}%
   {\bfseries\expandafter\@mthx\@title\thanks\relax\par}
    \vskip 5pt%
    {\footnotesize
      \spaceskip=1.5\fontdimen2\the\font
            \@tempswafalse \expandafter\xgoo\@author\and\relax}
  \end{center}%
  \par
  \vskip 8pt}
  
\def\@mthx#1\thanks{\uppercase{#1} \futurelet \tempt \@mthxXX}
\def\@mthxXX{\ifx \tempt\relax \else\@mthxYY \fi}
\def\@mthxYY#1\thanks\relax{\unskip\thanks{#1}\mbox{\hspace{3pt}}}  
  

\def\goo#1{\@tempswafalse \@tempswbfalse \xgoo#1\and\relax}
\def\xgoo#1\and{\def\tempw{\@mthx#1\thanks\relax}\futurelet \tempp \xxgoo}
 
\def\xxgoo{\ifx \tempp\relax
\if@tempswa   
   \if@tempswb {\scriptsize , AND }\tempw  
                \else {\scriptsize \ AND }\tempw%
   \fi
\else 
    \tempw%
\fi
\else
   \if@tempswa, \@tempswbtrue \fi%
\tempw\unskip\@tempswatrue \expandafter \xgoo
\fi
}


\renewcommand\thesection       {\arabic{section}}
\renewcommand\thesubsection    {\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection {\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph     {\thesubsubsection.\arabic{paragraph}}
\renewcommand\thesubparagraph  {\theparagraph.\arabic{subparagraph}}



\def\@seccntformatdot#1{\csname the#1\endcsname.\hskip 0.5em}


\def\@sect#1#2#3#4#5#6[#7]#8{\ifnum #2>\c@secnumdepth
     \def\@svsec{}\else 
     \refstepcounter{#1}\edef\@svsec{\@seccntformatdot{#1}\relax}%
     %In sim %{\csname the#1\endcsname.\hskip 0.5em }
     \fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@ 
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty \@M #8\@@par}
        \endgroup
       \csname #1mark\endcsname{#7}%
       \addcontentsline{toc}{#1}{%
             \ifnum #2>\c@secnumdepth \else
                      \protect\numberline{\csname the#1\endcsname}\fi#7}
              \else
                       \def\@svsechd{%
                       #6\hskip #3\@svsec #8.\csname #1mark\endcsname
                      {#7}\addcontentsline{toc}{#1}{%
                      \ifnum #2>\c@secnumdepth 
                          \else
                             \protect\numberline{\csname the#1\endcsname}
                           \fi
                       #7}}
                  \fi
     \@xsect{#5}}
     

\def\@ssect#1#2#3#4#5{%
\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M #5.\par}
     \endgroup
   \else \def\@svsechd{#4\hskip #1\relax #5.}\fi
    \@xsect{#3}}



\renewcommand\section{\@startsection{section}{1}{18pt}%
                                   {1.3ex \@plus .5ex \@minus .2ex}%              
                                   {-.5em \@plus -.1em}%                                   
                                   {\reset@font\normalsize\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{18pt}%
                                     {1.3ex\@plus .5ex \@minus .2ex}%
                                     {-.5em \@plus -.1em}%
                                     {\reset@font\normalsize\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{18pt}%
                                     {1.3ex\@plus .5ex \@minus .2ex}%
                                     {-.5em \@plus -.1em}%
                                     {\reset@font\normalsize\bfseries}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{18pt}%
                                    {\parskip}%                                                    
                                    {-.5em plus -.1em}%                                     
                                    {\reset@font\normalsize\itshape}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {\parskip}%
                                       {-.5em plus -.1em}%
                                      {\reset@font\normalsize\itshape}}

\renewcommand\p@enumiii{\theenumi\theenumii} 
\renewcommand\labelitemi{$\m@th\bullet$}
\renewcommand\labelitemii{\normalfont\bfseries --}
\renewcommand\labelitemiii{$\m@th\ast$}
\renewcommand\labelitemiv{$\m@th\cdot$}

\newenvironment{@abs}[1]{%
       \vspace{4pt}\footnotesize  \parindent 15pt {\bfseries #1. }\ignorespaces
     }
     {\par\vspace{7pt}}

\renewenvironment{abstract}{\begin{@abs}{\abstractname}}{\end{@abs}}
\newenvironment{keywords}{\begin{@abs}{\keywordsname}}{\end{@abs}}
\newenvironment{AMS}{\begin{@abs}{\AMSname}}{\end{@abs}}


\newcommand\keywordsname{Key words}
\newcommand\AMSname{AMS subject classifications}



\newif\if@endproofset
 \@endproofsetfalse

 \def\@begintheorem#1#2{\par\bgroup{\scshape #1\ #2. }\itshape\ignorespaces}
\def\@opargbegintheorem#1#2#3{\par\bgroup%
   {\scshape #1\ #2\ ({\upshape #3}). }\it\ignorespaces}
\def\@endtheorem{\egroup\ignorespacesafterend}
\def\proof{\par{\textit{Proof.}}\ignorespaces\global\@endproofsetfalse}

\def\endproofsign{\vbox{\hrule height0.6pt\hbox{%
   \vrule height1.3ex width0.6pt\hskip0.8ex
   \vrule width0.6pt}\hrule height0.6pt
  }}

\def\endproof{%
\if@endproofset
\else 
\hspace{2em plus 0pt minus 1.5em}\endproofsign
\fi}  
\def\endproofhere{%
\global\@endproofsettrue
\hskip 2em plus 0em minus 1.5em
\endproofsign
}
\def\flushrightendproof{%
\hfill \break \hspace*{\fill}  \endproofhere
}


  \newtheorem{theorem}{Theorem}[section]
  \newtheorem{lemma}[theorem]{Lemma}
  \newtheorem{corollary}[theorem]{Corollary}
  \newtheorem{proposition}[theorem]{Proposition}
  \newtheorem{definition}[theorem]{Definition}

\AtBeginDocument{
\def\remark{\@ifnextchar[%
{\@exheadrem}
{{\refstepcounter{theorem}\@begintheorem{Remark}{\thetheorem}\upshape\ignorespaces}}       % \upshape 
}
\def\@exheadrem[#1]{\refstepcounter{theorem}\@opargbegintheorem{Remark}{\thetheorem}{#1}\upshape\ignorespaces}
\def\endremark{\endtheorem} %

\def\example{\@ifnextchar[%
{\@exheadex}
{{\refstepcounter{theorem}\@begintheorem{Example}{\thetheorem}\upshape\ignorespaces}}     % \upshape 
}
\def\@exheadex[#1]{\refstepcounter{theorem}\@opargbegintheorem{Example}{\thetheorem}{#1}\upshape\ignorespaces}
\def\endexample{\endtheorem}


\def\@begintheoremrm#1#2{\par\bgroup{\scshape #1\ #2. }\upshape\ignorespaces}             % \upshape 
\def\@opargbegintheoremrm#1#2#3{\par\bgroup%                                                        % \upshape 
   {\scshape #1\ #2\ ({\upshape #3}). }\upshape\ignorespaces}
}    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Fixup.STY 
% 
% FROM FIXUP.STY
% We now redefine the eqnarray environment to correct the space around
% the operator.   Any changes to the definition in LaTeX itself
% will cause the `Warning: unable...'
% message to appear.  If this happens it will be necessary to update the
% definition of  \@tempb below and incorperate the changes into
% the new definitions of \eqnarray.
 
 
% This is the current definition of \eqnarray for the fleqn document style
% latex.ltx
 
\def\@tempb{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
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
\ifx\eqnarray\@tempb    % Try the default eqnarray environment
  \def\eqnarray{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne \hfil$\displaystyle{{}##{}}$\hfil
      &\global\@eqcnt\tw@ $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
         \tabskip\z@skip
      \cr
}
\else    \typeout{Warning: Unable to fix unknown version of \string\eqnarray.}
\fi
 
\def\@tempb{}

 
\def\const{\mathop{\operator@font const}\nolimits}
\def\diag{\mathop{\operator@font diag}\nolimits}
\def\grad{\mathop{\operator@font grad}\nolimits}
\def\Range{\mathop{\operator@font Range}\nolimits}
\def\rank{\mathop{\operator@font rank}\nolimits}
\def\supp{\mathop{\operator@font supp}\nolimits}



\renewcommand\appendix{%
\renewcommand{\section}{%
\secdef\@apA\@sapA}%          
 \setcounter{section}{0}%
 \setcounter{subsection}{0}%
 \renewcommand\thesection{\Alph{section}}}


\newcommand\@apA[2][?]{%
\refstepcounter{section}%
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\reset@font\normalsize\bfseries\appendixname\ \thesection. #2.}}

\newcommand\@sapA[1]{%
\refstepcounter{section}
{\vskip 1.3ex \@plus .5ex \@minus .2ex
\reset@font\normalsize\bfseries\appendixname\ \thesection.}}


\let\Appendix\appendix    
 
\renewcommand\figurename{Fig.}              
\setlength\belowcaptionskip{5pt}              
\def\@Figstring{figure}

 
\long\def\@makecaption#1#2{%
    \footnotesize
    \setlength{\parindent}{1.5pc}
  \ifx\@captype\@Figstring                     
    \vskip\abovecaptionskip
    \setbox\@tempboxa\hbox{{\normalfont\scshape #1}. {\normalfont\itshape #2}}% 
    \ifdim \wd\@tempboxa >\hsize                                        
      {\normalfont\scshape #1}. {\normalfont\itshape #2}\par
    \else
      \global\@minipagefalse                                     
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%        
    \fi
  \else                                             
    \hbox to\hsize{\hfil{\normalfont\scshape #1}\hfil}%
    \setbox\@tempboxa\hbox{{\normalfont\itshape #2}}%
    \ifdim \wd\@tempboxa >\hsize
      {\normalfont\itshape #2}\par
    \else
     \global\@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
    \vskip\belowcaptionskip
  \fi}

\bibindent=16pt
\renewenvironment{thebibliography}[1]
     {\setlength{\parskip}{0mm}                     
\par\addvspace{18pt} 
\@beginparpenalty=10000
    {\centering \footnotesize\uppercase\expandafter{\refname}\par \nobreak \addvspace{11pt} \nobreak \par}
     \@mkboth{\uppercase\expandafter{\refname}}{\uppercase\expandafter{\refname}}    
      \list{\@biblabel{\arabic{enumi}}}%                     
           {\settowidth\labelwidth{\@biblabel{#1}}%      
            \leftmargin\labelwidth                                      
            \advance\leftmargin\labelsep
              \advance\leftmargin\bibindent
              \itemindent -\bibindent
              \listparindent \itemindent
              \parsep \z@
            \usecounter{enumi}%
            \let\p@enumi\@empty
             \renewcommand\theenumiv{\@arabic\c@enumiv}}               
      \sloppy
      \clubpenalty4000
      \widowpenalty4000%
      \sfcode`\.=\@m\relax                               
      \footnotesize}                                        
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\renewcommand\newblock{}          


\newcommand\sameauthor{\leavevmode\vrule height 2pt depth -1.6pt width 23pt}


\renewcommand\footnoterule{%
  \kern-3pt  \hrule width 36pt
  \kern 2.6pt}
  
  
\long\def\@makefntext#1{%
    \parindent 18pt\noindent
    \hb@xt@18pt{\hss\@makefnmark}#1}
   


     \@addtoreset{equation}{section}   
     \renewcommand{\theequation}{\thesection.\arabic{equation}}  
    \@addtoreset{figure}{section}
    \renewcommand{\thefigure}{\thesection.\arabic{figure}}
    \@addtoreset{table}{section}
    \renewcommand{\thetable}{\thesection.\arabic{table}}
    \@addtoreset{theorem}{section}
    \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}


\def\@publyear{20xx}
\def\@publvol{XX}
\def\@publfirstpage{1}
\def\@publlastpage{yy}
\def\@publcopyrightyear{\@publyear}
\def\@publisssn{1068--9613}


\def\@Etnarefother{%
    \bfseries\scriptsize\upshape\centering
     \href{http://www.kent.edu}{\color{black}{Kent State University} and }\\
       \bfseries\scriptsize\upshape\centering
      \href{http://www.ricam.oeaw.ac.at}{\color{black}{Johann\,Radon\,Institute\,(RICAM)}}\\
      }
\def\@Etnareftitle{\bfseries\scriptsize\upshape\centering \hypersetup{urlcolor=[rgb]{0.5,0.5,0.5}}
     \href{http://www.kent.edu}{Kent State University} and\\
       \bfseries\scriptsize\upshape\centering  \hypersetup{urlcolor=[rgb]{0.5,0.5,0.5}}
      \href{http://www.ricam.oeaw.ac.at}{Johann\,Radon\,Institute\,(RICAM)}\\
      }
\def\@ETNAathead{\bfseries\normalsize\upshape\centering
     \href{http://etna.ricam.oeaw.ac.at}{\color{black}{ETNA}}
     }
      
      
\def\@Stamppage{{}%
\setlength{\fboxrule}{1pt} 
\fbox{\begin{minipage}{1.43in} 
      \@ETNAathead \\[0.ex] 
      \@Etnarefother
   \end{minipage}}%
   }
   
\def\@Stamppagetitle{{}%
\setlength{\fboxrule}{1pt} 
\fbox{\begin{minipage}{1.43in} 
      \@ETNAathead \\[0.ex] 
     \@Etnareftitle
   \end{minipage}}%
   }   
   
\def\@Stamptitle{
  \begin{minipage}{2.5in}\bfseries\scriptsize\upshape%
    Electronic Transactions on Numerical Analysis.\\[2pt]
    Volume~\@publvol, pp.~\@publfirstpage--\@publlastpage, \@publyear.\\[2pt]
    Copyright {\mdseries\textcopyright}~\@publcopyrightyear, Kent State University.\\[2pt]
    ISSN~\@publisssn.%
\end{minipage}%
}

\RequirePackage[T1]{fontenc}
%\renewcommand{\rmdefault}{ptm} 
%\renewcommand{\ttdefault}{pcr}
\usepackage{times} % There is still no alternative to that


\def\@firstpagehead{\begin{picture}(0,0) \put(256,35){\@Stamppagetitle}  \put(0,35){\@Stamptitle}\end{picture}}
\def\@otherpagehead{\begin{picture}(0,0) \put(256,35){\@Stamppage}\end{picture}}

 
 \renewcommand{\ps@plain}{\let\@mkboth\@gobbletwo%
   \renewcommand{\@oddhead}{\@firstpagehead}
  \renewcommand{\@evenhead}{\@firstpagehead}
  \renewcommand{\@evenfoot}{\hfil\footnotesize\textrm{\thepage}\hfil}%
  \renewcommand{\@oddfoot}{\@evenfoot}}

\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\@otherpagehead
    \rlap{\thepage}\hfil\upshape\footnotesize\MakeUppercase\leftmark\hfil}%          %!
    \def\@oddhead{% 
    \@otherpagehead
    \hbox{}\hfil{\upshape\footnotesize\MakeUppercase\rightmark}\hfil\llap{\thepage}
    }% %!
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }



\RequirePackage{microtype}
\RequirePackage[
colorlinks=true,
linkcolor=red,
filecolor=green,
citecolor=red,
hypertexnames=false,
bookmarks=false
]
{hyperref}



\newcommand\setbibdata[4]{%
\def\@publfirstpage{#1}
\def\@publlastpage{#2}
\def\@publvol{#3}
\def\@publyear{#4}
\addtocounter{page}{\@publfirstpage}
\addtocounter{page}{-1}
}


\def\shorttitle#1{\gdef\@shorttitle{#1}}
\def\@shorttitle{Running Title Required}
\def\shortauthor#1{\gdef\@shortauthor{#1}}
\def\@shortauthor{Author's Names}

\AtBeginDocument{\markboth{\@shortauthor}{\@shorttitle}\pagestyle{myheadings}}

\clubpenalty=9000
\widowpenalty=9000
\relpenalty=5000


\onecolumn
\endinput