\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{WileyMSP-template}

\LoadClass{article}
\RequirePackage{ragged2e}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage[margin=0.5in]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{gensymb}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\RaggedRight

\renewcommand{\maketitle}{
\huge
\@title
\medskip
\global\@topnum\z@
   }
   
 \renewenvironment{author} {
 \large
 \emph
  }
 

\newcommand{\keywords}[1]{
\medskip
Keywords: \textit{#1}
}

\newcommand{\dedication}[1]{
\medskip
\textit{#1}
}

\newenvironment{affiliations}{
\medskip
\large
}

\renewenvironment{abstract}{
\small
\medskip\medskip
}

\newcommand{\threesubsection}[1]{
\medskip
\textit{#1}: 
}


  




  
  
  





