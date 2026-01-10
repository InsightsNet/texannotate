% \iffalse -*-tex-*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Id: jfsma.cls,v 1.3 2007/05/31 17:58:24 $
%
% Une classe de document pour les articles publies dans les actes des Journées
% Francophones sur les Systèmes Multi-Agents par les éditions Cépaduès.
%
% Quelques idees viennent de la feuille de style de LFA'02 et de celle de
% MFI'03 qui sont accessibles la : 
%
%    http://www.lirmm.fr/lfa02/Format/lfa02.sty
%    http://www.lifl.fr/mfi03/format/mfi03/mfi03.cls
%
% Copyright (c) 2007 Bruno BEAUFILS
% Les quolibets et autres insultes sont a envoyer a beaufils@lifl.fr
%
% Modifications par Gauthier Picard (picard@emse.fr) - 29/11/17
% Modifications mineures par Maxime Morge (maxime.morge@univ-lille.fr) - 03/11/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \fi

\def\fileversion{v1.5}
\def\filedate{2023/11/03}
\def\docdate{}

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{jfsma}[\filedate%
\space LaTeX2e document class^^J%
\space ==========(\fileversion\space B. BEAUFILS, CRIStAL, ULille)==========]


\newcommand{\wm}{}
\newif\if@final \@finaltrue
\DeclareOption{contribution}{\renewcommand{\wm}{Contribution originale}\@finalfalse}
  \DeclareOption{dissemination}{\renewcommand{\wm}{Contribution déjà publiée}\@finalfalse}
  \DeclareOption{sota}{\renewcommand{\wm}{État de l'art}\@finalfalse}
  \DeclareOption{demonstration}{\renewcommand{\wm}{Démonstration}\@finalfalse}
  \DeclareOption{final}{\renewcommand{\wm}{}\@finaltrue}
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{final}}
\ProcessOptions

\LoadClass{article}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[french]{babel}
\RequirePackage{graphicx}
\RequirePackage[hidelinks,breaklinks]{hyperref}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\thispagestyle{fancy}
\newcommand{\header}{\sf\textcolor{gray!50}{\@setfontsize\Huge\@xxpt{20}\selectfont\wm}}
\lhead{}
\chead{\header}
\rhead{}
\cfoot{
  \if@final
  \else
    \thepage
  \fi
}
\renewcommand{\headrulewidth}{0.0pt}
\setlength{\headheight}{18.02681pt}

%\newcommand{\header}{\vspace*{-1cm}\begin{center}\sf\textcolor{gray}{\scalebox{2}{\LARGE\selectfont\wm}}\end{center}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Format des pages
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{geometry}
%\geometry{paper=a4paper,top=28mm,text={17cm,24cm},hmargin={20mm,20mm}}
\geometry{paper=a4paper,top=28mm,text={17cm,24cm}}
% Double-colonne
\twocolumn

% Separateurs en mode double colonnes
\columnsep      .9cm

% Pas de decalage de paragraphe
\parindent      0em

% Espacement entre paragraphe
\parskip        8pt plus 2pt minus 1pt

% Toutes les pages ont la meme zone d'occupation
\flushbottom

% On reste *cool* sur la gestion des espaces
\sloppy

\let\old@maketitle\maketitle
\renewcommand{\maketitle}{\old@maketitle\thispagestyle{fancy}\pagestyle{fancy}%\thispageheading{\header}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Forme des listes ajouté le 03/11/2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
\RequirePackage{enumitem}%[shortlabels]
\setlist[itemize]{label=\textbullet,noitemsep,topsep=-\parskip,leftmargin=1em}
\setlist[enumerate]{noitemsep,topsep=-\parskip,leftmargin=1.5em}
% Remplace l'espacement des listes
% \leftmargini 2em 
% \leftmarginv .5em
% \leftmarginvi .5em
% \itemsep 0em

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Changement de polices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \renewcommand{\sfdefault}{phv}
% \renewcommand{\rmdefault}{ptm}
% \renewcommand{\ttdefault}{pcr}

\RequirePackage{newtxtext}

\renewcommand{\up}[1]{\textsuperscript{#1}}

\renewcommand{\encodingdefault}{T1}

\normalfont\selectfont

\renewcommand{\normalsize}{\@setfontsize\normalsize\@xiipt{12}
  \abovedisplayskip 10pt plus2pt minus5pt%
  \belowdisplayskip \abovedisplayskip%
  \abovedisplayshortskip \z@ plus3pt%
  \belowdisplayshortskip 6pt plus 3pt minus 3pt%
  \let\@listi\@listI%
}
\renewcommand{\small}{\@setfontsize\small\@xpt{10}}
\renewcommand{\large}{\@setfontsize\large\@xiipt{14}}
\renewcommand{\Large}{\@setfontsize\Large\@xivpt{16}}
\renewcommand{\LARGE}{\@setfontsize\LARGE\@xivpt{16}}
\renewcommand{\huge}{\@setfontsize\huge\@xviipt{18}}
\renewcommand{\Huge}{\@setfontsize\Huge\@xxpt{20}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sectionnement
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\section{%
  \@startsection{section}
                {1}%
                {\z@}%
                {-1ex plus -.2ex minus -.2ex}%
                {1ex plus .2ex}%
                {\Large\bf}%
}
\def\subsection{%
  \@startsection{subsection}%
                {2}%
                {\z@}%
                {-1ex plus -.2ex minus -.2ex}%
                {1ex plus .2ex}%
                {\large\bf}%
}
\renewcommand{\subsubsection}[1]{\paragraph*{\bf #1.}}
\def\paragraph{%
  \@startsection{paragraph}%
                {4}%
                {\z@}%
                {-1ex plus -.2ex minus -.2ex}%
                {-1em}%
                {\normalsize\bf}%
}
\def\subparagraph{%
  \@startsection{subparagraph}%
                {4}%
                {\parindent}%
                {-1ex plus -.2ex minus -.2ex}%
                {-1em}%
                {\normalsize\bf}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% Titre
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newsavebox{\@titre}
\newcommand{\titre}[1]{%
  \savebox{\@titre}%
          {{\Huge\bfseries\parbox{\textwidth}{\centering#1}}}
}

\newsavebox{\@auteurs}
\newcommand{\auteur}[2]{%
  \begin{lrbox}{\@auteurs}
    \usebox{\@auteurs}
    \begin{tabular}[t]{c}
      {\normalsize #1}\\
      {\small\sffamily #2}
    \end{tabular}
  \end{lrbox}
}

\newsavebox{\@auteursSuite}
\newcommand{\auteurSuite}[2]{%
  \begin{lrbox}{\@auteursSuite}
    \usebox{\@auteursSuite}
    \begin{tabular}[t]{c}
      {\normalsize #1}\\
      {\small\sffamily #2}
    \end{tabular}
  \end{lrbox}
}

\newsavebox{\@institutions}
\newif\ifplusieurs@institutions
\plusieurs@institutionsfalse
\newlength{\my@height}
\newlength{\my@depth}
%\newcommand{\institution}[1]{%
%  \begin{lrbox}{\@institutions}
%    \begin{tabular}[t]{c}
%      \ifplusieurs@institutions
%        \settoheight{\my@height}{\usebox{\@institutions}}
%        \settodepth{\my@depth}{\usebox{\@institutions}}
%        \addtolength{\my@depth}{.5em}
%        \raisebox{0pt}[\my@height][\my@depth]{\usebox{\@institutions}}\\
%      \fi
%      {
%      \small
%        \begin{tabular}[t]{c}
%          #1
%        \end{tabular}
%      }
%    \end{tabular}
%  \end{lrbox}
%  \plusieurs@institutionstrue
%}
\newcommand{\institution}[1]{%
  \begin{lrbox}{\@institutions}
    \begin{minipage}{\textwidth}
      \centering
      \ifplusieurs@institutions
        \settoheight{\my@height}{\usebox{\@institutions}}
        \settodepth{\my@depth}{\usebox{\@institutions}}
        \raisebox{0pt}[\my@height][\my@depth]{\usebox{\@institutions}}\\
      \fi
      {
      \small
        \parbox{\textwidth}{
          \centering
          #1
        }
      }
    \end{minipage}
  \end{lrbox}
  \plusieurs@institutionstrue
}

\renewcommand{\@maketitle}{%
  \begin{center}
    {\usebox{\@titre}\par}%
    \vskip 1em%
    {\usebox{\@auteurs}\par}%
    \vskip .5em%
    {\usebox{\@auteursSuite}\par}%
    \vskip .7em%
    {\usebox{\@institutions}}%
  \end{center}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resume et mots-cles
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{resume}%
{%
  \parskip 0pt plus .5pt minus .1pt\it%
  {\centering\textbf{R\'esum\'e}\par}
}
{\par}

\renewenvironment{abstract}%
{%
  \smallskip\parskip 0pt plus .5pt minus .1pt\it%
  {\centering\textbf{Abstract}\par}
}
{\par}

\newcommand{\motscles}[1]{%
  {\parskip 5pt plus .1pt minus .1pt\it\textbf{Mots-cl\'es~:} #1\par}}
\newcommand{\keywords}[1]{%
  {\parskip 5pt plus .1pt minus .1pt\it\textbf{Keywords:} #1\par}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
