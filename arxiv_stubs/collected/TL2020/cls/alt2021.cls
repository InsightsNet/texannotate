\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{alt2021}[2020/08/30 v1.0 ALT 2021 Proceedings]
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

\jmlrvolume{vol 132}
\jmlryear{2021}
\jmlrproceedings{PMLR}{Proceedings of Machine Learning Research}

\ifanonsubmission
 \newcommand{\altauthor}[1]{}
 \author{author names withheld}
 \editor{Under Review for ALT 2021}
 \jmlrworkshop{32nd International Conference on Algorithmic Learning Theory}
 \renewcommand{\acks}[1]{}
\else
 \newcommand{\altauthor}[1]{\author{#1}}
 \iffinalsubmission
  \editors{Vitaly Feldman, Katrina Ligett and Sivan Sabato}
  \jmlrworkshop{32nd International Conference on Algorithmic Learning Theory}
 \fi
\fi



