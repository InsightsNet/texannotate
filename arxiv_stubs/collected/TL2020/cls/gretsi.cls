\message{Classe LaTeX du GRETSI}
\ProvidesClass{gretsi}[2008/12/15 v1.2]
\NeedsTeXFormat{LaTeX2e}
\LoadClass{article}


\newif\ifCLASSOPTIONresume       \CLASSOPTIONresumefalse
\newif\ifCLASSOPTIONfinal       \CLASSOPTIONfinaltrue

\DeclareOption{resume}{\CLASSOPTIONresumetrue\CLASSOPTIONfinalfalse}
\DeclareOption{final}{\CLASSOPTIONfinaltrue\CLASSOPTIONresumefalse}

\ExecuteOptions{final}
% overrride these defaults per user requests
\ProcessOptions



%
% OPTIONS POUR LE TEXTE EN FRANCAIS
%
\AtBeginDocument{%
   \@ifpackageloaded{french}{%
      \newenvironment{texteenanglais}{\english}{\endenglish}%
      \newcommand{\legende}[1]{\caption{\emph{#1}}}
	  \newcommand{\entreguill}[1]{\leftguillemets{}#1\rightguillemets{}}
      \renewcommand{\captionseparator}{:}
      \let\@trivlistORI\@trivlist
      \def\bbl@frenchlistspacing{%
         \def\@trivlist{%
		    \setlength{\itemsep}{0.4ex plus 0.2ex minus 0.2ex}%
            \setlength{\parsep}{0.4ex plus 0.2ex minus 0.2ex}%
            \setlength{\topsep}{0.8ex plus 0.4ex minus 0.4ex}%
            \setlength{\partopsep}{0.4ex plus 0.2ex minus 0.2ex}%
            \addtolength{\topsep}{-\parskip}%
            \addtolength{\partopsep}{\parskip}%
            \@trivlistORI%
         }
      }%
      \bbl@frenchlistspacing%
   }{%
      \@ifpackageloaded{babel}{%
         \selectlanguage{french}
         \newenvironment{texteenanglais}{\selectlanguage{english}}{%
            \selectlanguage{french}}%
         \newcommand{\legende}[1]{\caption{#1}}
     	 \newcommand{\entreguill}[1]{\og{}#1\fg{}}

      }{%
         \newenvironment{texteenanglais}{}{}%
         \newcommand{\legende}[1]{\caption{#1}}
         \def\figurename{{\scshape Fig.}}%
         \def\tablename{{\scshape Tab.}}%
		 \newcommand{\entreguill}[1]{``#1''}
         \let\@trivlistORI\@trivlist
         \def\bbl@frenchlistspacing{%
            \def\@trivlist{%
			   \setlength{\itemsep}{0.4ex plus 0.2ex minus 0.2ex}%
               \setlength{\parsep}{0.4ex plus 0.2ex minus 0.2ex}%
               \setlength{\topsep}{0.8ex plus 0.4ex minus 0.4ex}%
               \setlength{\partopsep}{0.4ex plus 0.2ex minus 0.2ex}%
               \addtolength{\topsep}{-\parskip}%
               \addtolength{\partopsep}{\parskip}%
               \@trivlistORI%
		    }%
         }%
         \bbl@frenchlistspacing%
      }%
   }%
}%
%
% SPECIFICATIONS DE FORMAT DE PAGE
%
\pagestyle{empty}
\setlength{\voffset       }{-1 in}
\setlength{\hoffset       }{-1 in}
\setlength{\oddsidemargin }{ 14mm}
\setlength{\evensidemargin}{ 14mm}
\setlength{\textwidth     }{182mm}
\setlength{\topmargin     }{ 14mm}
\setlength{\headheight    }{  0mm}
\setlength{\headsep       }{  7mm}
\setlength{\topskip       }{  5mm}
\setlength{\textheight    }{235mm}
\setlength{\footskip      }{ 12mm}
\setlength{\columnsep     }{  6mm}
\setlength{\parskip       }{  0ex}
\setlength{\parindent     }{  1em}
\flushbottom
\normalsize
\AtBeginDocument{%
   \setlength{\floatsep}       {5mm}
   \setlength{\textfloatsep}   {3mm}
   \setlength{\intextsep}      {3mm}
   \setlength{\dblfloatsep}    {\floatsep}
   \setlength{\dbltextfloatsep}{\textfloatsep}
   \addtolength{\abovedisplayskip}{-3pt}
   \addtolength{\abovedisplayshortskip}{-3pt}
   \addtolength{\belowdisplayshortskip}{-0pt}
   \addtolength{\belowdisplayskip}{-3pt}
}
%
% RESUMES FRANCAIS ET ANGLAIS
%
\newif\if@resfra\@resfrafalse
\long\def\resumefrancais#1{%
   \@resfratrue%
   \long\gdef\@resumefrancais{%
      \setlength{\parindent}{1em}#1%
   }%
}
\long\def\@resumefrancais{}
\long\def\resumeanglais#1{%
   \long\gdef\@resumeanglais{%
      \begin{texteenanglais}%
		 \setlength{\parindent}{1em}#1%
	  \end{texteenanglais}%
   }%
}
\long\def\@resumeanglais{}
\newcommand{\frenchabstract}{\resumefrancais}
\newcommand{\englishabstract}{\resumeanglais}
%
% QUESTION DES RESUMES
%
\long\def\themes#1{%
   \long\gdef\@themes{%
      \setlength{\parindent}{1em}#1%
   }%
}
\long\def\@themes{}
\long\def\probleme#1{%
   \long\gdef\@probleme{%
      \setlength{\parindent}{1em}#1%
   }%
}
\long\def\@probleme{}
\long\def\originalite#1{%
   \long\gdef\@originalite{%
      \setlength{\parindent}{1em}#1%
   }%
}
\long\def\@originalite{}
\long\def\resultats#1{%
   \long\gdef\@resultats{%
      \setlength{\parindent}{1em}#1%
   }%
}
\long\def\@resultats{}
%
% PREMIERE PAGE
%
%\DeclareRobustCommand*{\aff}[1]{\leavevmode\raise1ex\hbox{\footnotesize #1}}
\newcommand{\aff}[1]{\textsuperscript{\footnotesize #1}}
\newcommand{\auteur}{\author}
\newcommand{\titre}{\title}
%\newcommand{\coord}[3]{ #1 \textsc{#2}\aff{#3}}
\newcommand{\coord}[3]{#1 \textsc{#2}\aff{#3}}
\newcommand{\affil}[2]{\\[5pt]\aff{#1}#2}
\long\def\adresse#1{\long\gdef\@adresse{#1}}
\long\def\@adresse{Adresse du ou des auteurs}
\long\def\email#1{\long\gdef\@email{#1}}
\long\def\@email{Adresse electronique}
\def\date#1{}
\gdef\@date{}
\newcommand{\address}{\adresse}
\def\maketitle{%
   \par%
   \begingroup%
      \def\thefootnote{\@fnsymbol\c@footnote}%
      \def\@makefnmark{%
	     \rlap{\@textsuperscript{\normalfont\@thefnmark}}%
      }%
      \long\def\@makefntext##1{%
         \parindent 1em%
         \noindent%
         \hb@xt@1.8em{%
            \hss\@textsuperscript{\normalfont\@thefnmark}%
         }##1%
      }%
	\ifCLASSOPTIONfinal
     \twocolumn[\@maketitlegretsi]%
	\fi
	\ifCLASSOPTIONresume
	 \@maketitlegretsiresume
	\fi
     \thispagestyle{empty}%
	 \@thanks%
   \endgroup%
   \setcounter{footnote}{0}%
   \let\maketitlegretsi\relax%
   \let\@maketitlegretsi\relax%
   \let\maketitlegretsiresume\relax%
   \let\@maketitlegretsiresume\relax%
   \gdef\@thanks{}%
   \gdef\@author{}%
   \gdef\@title{}%
   \gdef\@adresse{}%
   \gdef\@email{}%
   \let\thanks\relax%
}
\def\@maketitlegretsi{%
  \newpage%
  \null%
  \begin{center}%
     {\LARGE \textbf{\@title}\par}%
     \vskip 0.5cm%
     {\@author\par}%
     %\vskip 0.5cm%
	 \begin{tabular}{c}%
        \@adresse%
	 \end{tabular}
     \vskip 0.1cm%
     \texttt{\@email}%
     \vskip 1cm%
  \end{center}%
  \if@resfra%
     \textbf{R\'esum\'e -- }{\small \@resumefrancais \par}%
     \vskip 0.5 cm%
  \fi%
  \textbf{Abstract -- }{\small \@resumeanglais \par}%
  \par%
  \vskip 1.0cm%
}
\def\@maketitlegretsiresume{%
  \newpage%
  \null%
  \begin{center}%
     {\LARGE \textbf{\@title}\par}%
     \vskip 0.5cm%
     {\@author\par}%
     %\vskip 0.5cm%
	 \begin{tabular}{c}%
        \@adresse%
	 \end{tabular}
     \vskip 0.1cm%
     \texttt{\@email}%
     \vskip 1cm%
  \end{center}%
  \textbf{Th\`eme -- }{\small \@themes \par}%
  \vskip 0.5cm%
  \noindent \textbf{Probl\`eme trait\'e -- }{\small \@probleme \par}%
  \vskip 0.5cm%
  \noindent \textbf{Originalit\'e -- }{\small \@originalite \par}%
  \vskip 0.5cm%
  \noindent \textbf{R\'esultats -- }{\small \@resultats \par}%
  \par%
  \vskip 1.0cm%
}
\endinput
