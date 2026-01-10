%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2014 River Valley Technologies Ltd, UK.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\hpl@fileversion{v1.1.0}
\def\hpl@filedate{2014/04/04} % YY/MM//DD
\def\hpl@docVer{v1.1.0}       % YY/MM//DD

\newif\ifdoc\docfalse

\ProvidesClass{hpl}[\hpl@filedate; \hpl@fileversion]
\DeclareOption{draft}{\setlength\overfullrule{5\p@}}
\DeclareOption{final}{\setlength\overfullrule{0\p@}}
\DeclareOption{doc}{\global\doctrue}

\ExecuteOptions{final}
\ProcessOptions
\LoadClass[twocolumn,twoside]{article}


\RequirePackage[numbers,super,sort&compress]{natbib}
\RequirePackage{ifthen}
\RequirePackage{xspace}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{amsbsy}
%\RequirePackage[mtbold]{mathtime}
\RequirePackage{geometry}
%\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
%\RequirePackage[switch,displaymath,mathlines]{lineno}
\RequirePackage{upgreek}
\RequirePackage{textcomp}
\RequirePackage{morefloats}
\RequirePackage{stfloats}
\RequirePackage{xcolor}
\RequirePackage{url}
\RequirePackage{txfonts}

\DeclareSymbolFont{operators}   {OT1}{cmr} {m}{n}
\DeclareSymbolFont{letters}     {OML}{cmm} {m}{it}
\DeclareSymbolFont{symbols}     {OMS}{cmsy}{m}{n}
%\RequirePackage[mtbold]{mathtime}

%\RequirePackage{hyperref}
\urlstyle{rm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Font sizes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewcommand\normalsize{% Body of main text.
   \@setfontsize\normalsize{10}{12.25}%
   \abovedisplayskip \baselineskip%
   \abovedisplayshortskip .5\baselineskip%
   \belowdisplayskip \abovedisplayskip
   \belowdisplayshortskip \abovedisplayshortskip
   \let\@listi\@listI}
\normalsize
\renewcommand\small{%
   \@setfontsize\small{9}{10}
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 5\p@ \@plus3\p@ \@minus3\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 6\p@ \@plus2\p@ \@minus2\p@
               \parsep 3\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize{8}{9.5}
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 3\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 6\p@ \@plus2\p@ \@minus2\p@
               \parsep 3\p@ \@plus2\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Page geometry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\geometry{
  paperwidth=209.6mm,
  paperheight=279.4mm,
  textwidth=500pt,
  textheight=667pt,
  columnsep=18pt,
%  twocolumn,
  top=60pt,
  left=56pt,
  headheight=12pt,
  headsep=14pt,
  footskip=25pt,
}

%\skip\footins=12\p@
%\setlength\footnotesep{7\p@}

\def\footnoterule{%
  \ifdoc\else\kern-3\p@ \hrule \@width \columnwidth \kern 2.6\p@\fi%
}

% Author
\newcounter{hpl@tmpCtr}
\newcounter{hpl@auCtr}


\def\hpl@author{\stepcounter{hpl@auCtr}%
  \@ifnextchar[{\hpl@opt@author}{\hpl@norm@author}}

\def\hpl@opt@author[#1]#2{\expandafter\gdef\csname 
  hpl@@author\thehpl@auCtr\endcsname{\ignorespaces#2\textsuperscript{#1}}}

\def\hpl@norm@author#1{\expandafter\gdef\csname 
  hpl@@author\thehpl@auCtr\endcsname{#1}}

\let\author\hpl@author

\def\hpl@author@sep{%
  \ifnum\thehpl@tmpCtr=1\relax\else%
  \ifnum\count@hpl@auCtr=\thehpl@tmpCtr%
  \ifnum\count@hpl@auCtr=2\else\unskip,\fi\space%
  and\space\else\unskip,\space\fi\fi}

\def\hpl@printAuthors{\edef\count@hpl@auCtr{\thehpl@auCtr}%
 \setcounter{hpl@tmpCtr}{0}%
 \fontsize{10}{12.5}\selectfont%
 \whiledo{\count@hpl@auCtr>\thehpl@tmpCtr}
  {\stepcounter{hpl@tmpCtr}%
  \hpl@author@sep\csname hpl@@author\thehpl@tmpCtr\endcsname}}

% Address

\def\hpl@printAddress{}

\long\def\hpl@address{\@ifnextchar[{\hpl@opt@address}{\hpl@norm@address}}

\long\def\hpl@opt@address[#1]#2{\g@addto@macro\hpl@printAddress{\par\textsuperscript{#1}\textit{#2}}}

\long\def\hpl@norm@address#1{\g@addto@macro\hpl@printAddress{%
  \fontsize{8}{9.2}\selectfont\par\textit{#1}}}

\let\address\hpl@address

% Correspondence
\def\hpl@corresp{}
\def\corresp#1{\unskip\g@addto@macro\hpl@corresp{Correspondence to:
 #1}\ignorespaces}

\def\email#1{Email: #1}

%%% Ppage stlyes
% Title page
\def\ps@plain{
 \def\@oddhead{\ifdoc\else\itshape\small Article submitted to: High Power Laser 
   Science and Engineering, \textup{\the\year}\hfill \today\fi}
 \let\@evenhead\@oddhed
 \def\@oddfoot{\footnotesize\hfill\thepage\hfill}
 \let\@evenfoot\@oddfoot
 }

% Other pages
\def\ps@otherpages{
 \gdef\@oddhead{\itshape\small\hpl@shorttitle\hfill\textup{\thepage}}
 \gdef\@evenhead{\thepage\hfill\itshape\small\hpl@shortauthor}
 \def\@evenfoot{}\def\@oddfoot{}
 }


\renewcommand\maketitle{\par
  \begingroup
%    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
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
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \insert\footins{\footnotesize\hpl@corresp}
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
  \pagestyle{otherpages}
}


%% Maketitle
\def\@maketitle{%
  \newpage
  \null
%  \vskip 2em%
  \vskip -12pt%
  \begin{flushleft}%
  \let \footnote \thanks
  \noindent%
  \ifdoc
    \rule{\textwidth}{.4pt}
  \else
    \rule{499pt}{.4pt}
  \fi
  \par
    {\vspace{6.3\p@}\raggedright\fontsize{18}{21}\bfseries\boldmath\selectfont
    \ifdoc\else\rightskip 68pt plus 20pt\fi
    \@title \par}%
    \rightskip 68pt plus 20pt
  \vspace{35.5pt}%
  \noindent
  \ifdoc
    \textbf{Revision History}\par\vskip 3pt
    %\hbox to \textwidth{\hfill version: \hpl@docVer}\par
    Version: \hpl@docVer\quad$|$\quad April 05, 2014\quad$|$\quad First release\par
    \rule{\textwidth}{.4pt}\par
  \else
    \rule{499pt}{.4pt}\par
  \fi  
  \par\vspace{4.5pt}%
  \hpl@printAuthors
  \par\vspace{4pt}%
  \hpl@printAddress
  \par%
  \vskip 2.5em%
  \hpl@printAbstract
  \hpl@printKeywords
  \end{flushleft}%
  \par
%  \vskip 1.5em
  %\thispagestyle{title}
  }

%%%% Abstract
\newbox\hpl@absbox
\renewenvironment{abstract}{%
  \global\setbox\hpl@absbox=\vbox\bgroup\hsize\dimexpr(\textwidth-68pt)%
  \vspace{4pt}\fontsize{9}{11}\selectfont%
  \noindent\textbf{\abstractname}\\}{\egroup}

\def\hpl@printAbstract{\unvbox\hpl@absbox}

\def\hpl@printKeywords{}
\DeclareRobustCommand\keywords[1]{%
  \def\hpl@printKeywords{\par\vskip.5\baselineskip%
    {\small{\textbf{Keywords:}} #1}
     \par
     \vspace{\baselineskip}
    }}


%% Sectioning

\def\@seccntformat#1{\csname the#1\endcsname.\hskip.7em}
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {1ex \@plus.2ex}%
  {\normalfont\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-3.25ex\@plus -1ex \@minus -.2ex}%
  {1ex \@plus .2ex}%
  {\normalfont\itshape}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-3.25ex\@plus -1ex \@minus -.2ex}%
  {-1.5ex \@plus .2ex}%
  {\normalfont\itshape\normalsize}}

\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
 {2.25ex \@plus1ex \@minus.2ex}%
 {-1em}%
 {\normalfont\normalsize\bfseries}}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
 {3.25ex \@plus1ex \@minus .2ex}%
 {-1em}%
 {\normalfont\normalsize\bfseries}}


\def\etal{\textit{et~al.}\xspace}

%% Running heads
\def\hpl@shorttitle{\ifdoc\else Missing short title!!\fi}
\def\hpl@shortauthor{\ifdoc\else Missing short authors!!\fi}
\def\shorttitle#1{\gdef\hpl@shorttitle{#1}}
\def\shortauthor#1{\gdef\hpl@shortauthor{#1}}


%% Math
%\thinmuskip=3mu
%\medmuskip=4mu plus 2mu minus 4mu
%\thickmuskip=5mu plus 3mu minus 1mu
\def\defaultscriptratio{.65}
\def\defaultscriptscriptratio{.5}
%% 
\let\Gamma\varGamma
\let\Delta\varDelta
\let\Theta\varTheta
\let\Lambda\varLambda
\let\Xi\varXi
\let\Pi\varPi
\let\Sigma\varSigma
\let\Upsilon\varUpsilon
\let\Phi\varPhi
\let\Psi\varPsi
\let\Omega\varOmega

% Other parameters
\parindent=9pt
\parskip=0pt
\hyphenpenalty=9999
\tolerance=1000
\emergencystretch=5pt
\lineskiplimit=-5pt

% Lists
\def\labelenumi{(\arabic{enumi})}
\def\theenumi{(\arabic{enumi})}
\def\enumerate{%
  \ifnum \@enumdepth >\thr@@\@toodeep\else
    \advance\@enumdepth\@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
      \expandafter
      \list
        \csname label\@enumctr\endcsname
        {\usecounter\@enumctr\def\makelabel##1{\hss\llap{##1}}
        \itemsep -3pt
        }%
  \fi}
\let\endenumerate =\endlist

% Floats
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\footnotesize\textbf{#1.} #2}%
  \ifdim \wd\@tempboxa >\hsize
    \footnotesize\textbf{#1.} #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

% Appendix
\renewcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@Alph\c@section}}

% Bibliography
\renewcommand{\bibnumfmt}[1]{\hfill#1.}
\bibpunct{[}{]}{,}{s}{}{\textsuperscript{,}}
\bibsep=0pc

% Quotes
\renewenvironment{quote}
               {\list{}{\rightmargin0pt}%
                \item\relax}
               {\endlist}

% Table footnote
\def\tabfn#1{\textsuperscript{#1}}
\def\tabnote{\@ifnextchar[\@tabnote{\@tabnote[]}}
\def\@tabnote[#1]#2{\strut\par\raggedright\footnotesize%
  \textsuperscript{#1}#2}

% Miscellaneous
\def\ack{\section*{Acknowledgement}}
\def\acks{\section*{Acknowledgements}}


