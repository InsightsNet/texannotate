\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{clear2024}[2024/02/01 v1.0 CLeaR 2024 Proceedings]
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

% \jmlrvolume{vol 236} % 236
% \jmlryear{2024}
% \jmlrproceedings{PMLR}{Proceedings of Machine Learning Research}

\ifanonsubmission
 % \newcommand{\clearauthor}[1]{\author{#1}}
 \newcommand{\clearauthor}[1]{}
 \author{Author names withheld}
 \editor{Under Review for CLeaR 2024}
 % \editor{}
 \jmlrworkshop{3rd Conference on Causal Learning and Reasoning}
 % \jmlrworkshop{}
 \renewcommand{\acks}[1]{}
\else
 \newcommand{\clearauthor}[1]{\author{#1}}
 \iffinalsubmission
  % \editors{Francesco Locatello and Vanessa Didelez}
  % \jmlrworkshop{3rd Conference on Causal Learning and Reasoning}
 \fi
\fi
