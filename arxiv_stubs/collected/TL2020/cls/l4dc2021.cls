\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{l4dc2021}[2020/10/04 v2.0 L4DC 2021 Proceedings]

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

\jmlrvolume{vol xxx}
\jmlryear{2021}
\jmlrproceedings{PMLR}{Proceedings of Machine Learning Research}

 \iffinalsubmission
  \editors{Ali Jadbabaie, John Lygeros, George J. Pappas, Pablo A. Parrilo, Benjamin Recht, Claire J. Tomlin, Melanie N. Zeilinger}
  \jmlrworkshop{3rd Annual Conference on Learning for Dynamics and Control}
\fi




