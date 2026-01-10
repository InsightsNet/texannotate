\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{clear2023}[2023/02/01 v1.0 CLeaR 2023 Proceedings]
\newcommand{\todo}{\color{red}}

\@ifundefined{ifanonsubmission}{
  \newif\ifanonsubmission
  \anonsubmissionfalse
}{}

\@ifundefined{iffinalsubmission}{
  \newif\iffinalsubmission
  \finalsubmissionfalse
}{}

\DeclareOption{anon}{\anonsubmissiontrue}
\DeclareOption{final}{\finalsubmissiontrue}
\ProcessOptions\relax

\LoadClass[pmlr]{jmlr}

\jmlrvolume{vol {TBD}}
\jmlryear{2023}
\jmlrproceedings{PMLR}{Proceedings of Machine Learning Research}

\ifanonsubmission
 \newcommand{\clearauthor}[1]{}
 \author{Author names withheld}
 \editor{Under Review for CLeaR 2023}
 \jmlrworkshop{2nd Conference on Causal Learning and Reasoning}
 \renewcommand{\acks}[1]{}
\else
 \newcommand{\clearauthor}[1]{\author{#1}}
 \iffinalsubmission
  \editors{Mihaela van der Schaar, Dominik Janzing and Cheng Zhang}
  \jmlrworkshop{2nd Conference on Causal Learning and Reasoning}
 \fi
\fi



