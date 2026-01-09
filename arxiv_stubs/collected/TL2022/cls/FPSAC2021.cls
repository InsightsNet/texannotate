% Copyright 2018 Nicholas Beaton

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{FPSAC2021}[2020/09/02 FPSAC 2021 Proceedings class]

\newif \if@submission
\global \@submissionfalse
\DeclareOption{submission}{
  \global \@submissiontrue
}

\newif \if@revision
\global \@revisionfalse
\DeclareOption{revision}{
  \global \@submissiontrue
  \global \@revisiontrue
}

\newif \if@finalversion
\DeclareOption{finalversion}{
  \global \@submissiontrue
  \global \@revisiontrue
  \global \@finalversiontrue
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

\LoadClass[letterpaper,12pt]{article}

\RequirePackage{calc}
\RequirePackage[top=1in,bottom=1in,left=1in,right=1in,includehead]{geometry}
\RequirePackage[dvipsnames,table]{xcolor}
\RequirePackage[colorlinks=true,citecolor=RoyalBlue,linkcolor=Red,breaklinks=true]{hyperref}
\RequirePackage{lastpage}

\RequirePackage{amsmath,amsthm,amssymb}
\RequirePackage{graphicx}
\RequirePackage{caption}

\RequirePackage[sc]{mathpazo}
\linespread{1.05}
\RequirePackage[T1]{fontenc}

\RequirePackage[capitalize,nameinlink,noabbrev]{cleveref}

% \setlength \textheight{56pc}
% \setlength \textwidth{35pc}
% \setlength \headsep{30\p@}
% \setlength \footskip{10\p@}
% \setlength \oddsidemargin{10\p@}
% \setlength \evensidemargin{21\p@}
% \setlength \textfloatsep{13\p@ \@plus 2\p@ \@minus 4\p@}
% \setlength \dbltextfloatsep{13\p@ \@plus 2\p@ \@minus 4\p@}
% \setlength \parskip{\z@ \@plus 1\p@}
% \setlength \parindent{10\p@}
% \setlength \topsep{4\p@ \@plus 2\p@ \@minus 1\p@}

\numberwithin{equation}{section}

\def\@title{\relax}
\def\@titlehead{\relax}
% pulling the title information from source
\def \title{\@ifnextchar[{\@gettitletwo}{\@gettitleone}}
\def \@gettitleone#1{\@gettitletwo[#1]{#1}}
\def \@gettitletwo[#1]#2{{
  \gdef \@title{#2}
  \def \\{\unskip \space \ignorespaces}
  \gdef \@titlehead{#1}
}}

\newif \if@marksrequired
\newcommand \addressmark[1]{%
  \if@marksrequired%
    $^{#1}$%
  \fi%
}
\global \@marksrequiredfalse
\gdef \and{\unskip \space \@authorand \space \ignorespaces}
\gdef \@authorand{and}


\def\@author{\relax}
\def\@authorhead{\relax}
% pulling the author information from source
\def \author{\@ifnextchar[{\@getauthortwo}{\@getauthorone}}
\def \@getauthorone#1{\@getauthortwo[#1]{#1}}
\def \@getauthortwo[#1]#2{{
  \gdef \@author{#2}
  \def \\{\unskip \space \ignorespaces}
  \gdef \@authorhead{#1}
}}

\def\@address{\relax}
% pulling address information from source
\def \address{\@getaddress}
\def \@getaddress#1{{
  \gdef \@address{#1}
}}

\newif \if@keywordsgiven
\@keywordsgivenfalse
\def\@keywords{\relax}
% pulling keywords information from source
\def \keywords{\@getkeywords}
\def \@getkeywords#1{{
  \global \@keywordsgiventrue
  \gdef \@keywords{#1}
}}

\def \@received{\relax}
\newcommand \received[1]{
  \gdef\@received{Received #1}
}
\def \@revised{\relax}
\newcommand \revised[1]{
  \gdef\@revised{revised #1}
}
\def \@accepted{\relax}
\newcommand \accepted[1]{
  \def\@accepted{accepted #1}
}

\newif \if@abstractgiven
\@abstractgivenfalse
\def \@abstract{\relax}
\long\def \abstract#1{
  \global \@abstractgiventrue
  \long\gdef \@abstract{#1}
}

\newif \if@resumegiven
\@resumegivenfalse
\def \@resume{\relax}
\long\def \resume#1{
  \global \@resumegiventrue
  \long\gdef \@resume{#1}
}

\def \@resumetitle{\relax}
\long\gdef \@resumetitle{Abstract}
\long\def \resumetitle#1{
  \long\gdef \@resumetitle{#1}
}

\def \@articlenumber{YY}
\def \articlenumber#1{\gdef \@articlenumber{#1}}

%%%%%%% BIBLATEX STUFF %%%%%%%

%\RequirePackage[maxbibnames=99,backend=bibtex,sorting=nyt]{biblatex}
%\renewbibmacro{in:}{. In:}
%\DeclareFieldFormat[misc]{title}{\mkbibquote{#1}}
%\renewcommand*{\bibfont}{\small}
%\DeclareFieldFormat[article]{volume}{\mkbibbold{#1}}
%\DeclareFieldFormat{url}{\textsc{url}: \href{#1}{#1}}
%\DeclareFieldFormat{doi}{\textsc{doi}: \href{http://dx.doi.org/#1}{#1}}
%\DeclareFieldFormat{eprint:arxiv}{arXiv:\href{https://arxiv.org/abs/#1}{#1}}

%%%%%%%%%%%%%%


\let \pagenumber=\@gobble

\AtBeginDocument{\gdef \@thefirstpage{\thepage}}

\long \gdef \@firsthead{\parbox{\textwidth}{\footnotesize \textit{S\'eminaire Lotharingien de Combinatoire} XX (2021) \hfill \textit{Proceedings of the 33$^\text{rd}$ Conference on Formal Power} \newline Article \#\@articlenumber, \pageref*{LastPage} pp. \hfill \textit{Series and Algebraic Combinatorics (Ramat Gan)}}}


\def \ps@first{
  \def \@evenhead{\normalfont \@firsthead \hss}
  \def \@oddhead{\normalfont \@firsthead \hss }
}

\global \@twosidetrue

\def \ps@journal{
  \let \@mkboth \@gobbletwo
  \def \@evenhead{
    \def \thanks####1{\relax}%
    \small \thepage \hfill \textit{\@authorhead}
  }
  \def \@oddfoot{}
  \def \@oddhead{
    \small \textit{\@titlehead} \hfill \thepage
  }
  \def \@evenfoot{}
}

\renewcommand \maketitle{
  \thispagestyle{first}
  \renewcommand \thefootnote{\fnsymbol{footnote}}
  \@maketitle
  \@thanks
  \renewcommand\thefootnote{\arabic{footnote}}

  \@makeabstract
  \setcounter{footnote}{0}
}

\newcommand \printkeywords{
  \small \noindent \textbf{Keywords:} \@keywords \par
}

\newenvironment{titlesp}{
  \list{}{
    \leftmargin 0pt
  }\item[]
}{\endlist}

\newenvironment{abstractsp}{
  \list{}{
    \leftmargin 25pt
    \rightmargin 25pt
  }\item[]
}{\endlist}

\def \@maketitle{
  \begin{titlesp}
    \begingroup
    \hypersetup{hidelinks=true}
    \@marksrequiredtrue
    \null % this is a very annoying way to add space before the title
    \vspace{-19\p@}
    {\centering \hyphenpenalty=\@M \LARGE \@title \par}
    \vspace{12\p@}
    {\centering \large \@author \par}
    \vspace{6\p@}
%    {\centering \small \itshape \@address \par}
    \begin{abstractsp} {\small \itshape \@address \par} \end{abstractsp}
%    {\small \itshape \@address \par}
%    \vspace{6\p@}
%    \if@submission{\small{\@received}}\fi%
%    \if@revision{\small{; \@revised}}\fi%
%    \if@finalversion{\small{; \@accepted}}\fi%
%    \if@submission{\small{.}\vspace{0\p@}}\fi
    % \hrule \@height 1\p@
    \endgroup
  \end{titlesp}
}

\def \@makeabstract{
  \begin{abstractsp}
    \vspace{-10\p@}
    \bgroup
    \small
    \if@abstractgiven{\noindent{\textbf{Abstract.} \@abstract \par}}\fi
    \if@resumegiven{\noindent{\textbf{\@resumetitle.} \@resume \par}}\fi
    \if@keywordsgiven{\printkeywords}\fi
    \egroup
  \end{abstractsp}
  % \vspace{8\p@}
  % \hrule \@height 1\p@
}

\pagestyle{journal}

\newlength{\capsize}
%\setlength{\capsize}{\textwidth-50pt}

\long \def \@makecaption#1#2{%
%\newlength{\capsize}
\setlength{\capsize}{\textwidth-50pt}
  \sbox\@tempboxa{#2}
  \ifdim \wd\@tempboxa = 0pt
    \def \thistype{#1}
  \else
    \def \thistype{#1:}
  \fi
  \vskip \abovecaptionskip%
  \small%
  \sbox \@tempboxa{\textbf{\thistype} #2}%
  \ifdim \wd \@tempboxa > \capsize%
    \begin{center}
    \begin{minipage}{\capsize}
      \textbf{\thistype} #2 \par
    \end{minipage}
    \end{center}
  \else%
    \global \@minipagefalse%
    \hb@xt@ \hsize{\hfil \box\@tempboxa \hfil}%
  \fi%
  \vskip \belowcaptionskip%
}

\newcommand \acknowledgments{\section*{Acknowledgments}}
\newcommand \acknowledgements{\section*{Acknowledgements}}
\newcommand \noabstract{\printkeywords}


\endinput
% end of file
