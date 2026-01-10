%% 
%% This is an FXPAL Invention class (fxpal-invention)
%% 
%% Written by David A. Shamma.
%% 
%% Taken from an example file by Matthew Cooper and Scott Carter.
%% 
%% Fill it out and it will enforce the style (not the order...yet).
%%
%%
%% Example use (updated for better compatability with SyncTeX and
%% BibTeX:
%%
%% \documentclass{fxpal-invention}
%% \begin{document}
%% \invention{##-###}
%% %% Up to 5 authors will fit...just leave others blank
%% \authorA{Full Name 1}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% \authorB{Full Name 2}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% \authorC{Full Name 3}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% \authorD{Full Name 4}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% \authorE{Full Name 5}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% If you need MORE you can just add manually to the hidden tabular
%% %% \authorsExtra{
%% %% & \textbf{Full Name 6} & \textbf{Full Name 7}
%% %% & \textbf{Full Name 8} & \textbf{Full Name 9}
%% %% & \textbf{Full Name 10} & \tabularnewline
%% %% & PAL 0000 & PAL 0000 & PAL 0000
%% %% & PAL 0000 & PAL 0000 & \tabularnewline
%% %% & email@fxpal.com & email@fxpal.com & email@fxpal.com
%% %% & email@fxpal.com & email@fxpal.com & \tabularnewline
%% %% & +1-650-555-4800 & +1-650-555-4800 & +1-650-555-4800
%% %% & +1-650-555-4800 & +1-650-555-4800 & \tabularnewline
%% %% }
%%   \submittedby{}
%%   \proposaltitle{Our great idea}
%%   \proposaldescription{Little abstract}
%%   \manager{Full Name}{PAL ####}{email@fxpal.com}{+1-650-842-48##}
%%   \problem     # Omitted REQUIRED fields will print warning in PDF.
%%   \diagram     # OPTIONAL will print warning in log output.
%%   \concepts    # One OPTIONAL figure or drawing is recommended
%%   \evaluation  # OPTIONAL
%%   \related     # REQUIRED
%%   \differences # REQUIRED
%%   \disclosure  # OPTIONAL 
%%   \bibliographystyle{plain}
%%   \bibliography{bibfile}
%% \end{document}
%%
%% Example use (contained mode - DEPRECATED):
%%
%% \documentclass[contained]{fxpal-invention}
%% \begin{document}
%% \invention{##-###}
%% %% Up to 5 authors will fit...just leave others blank
%% \authorA{Full Name 1}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% \authorB{Full Name 2}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% \authorC{Full Name 3}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% \authorD{Full Name 4}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% \authorE{Full Name 5}{PAL 0000}{email@fxpal.com}{+1-650-555-4800}
%% %% If you need MORE you can just add manually to the hidden tabular
%% %% \authorsExtra{
%% %% & \textbf{Full Name 6} & \textbf{Full Name 7}
%% %% & \textbf{Full Name 8} & \textbf{Full Name 9}
%% %% & \textbf{Full Name 10} & \tabularnewline
%% %% & PAL 0000 & PAL 0000 & PAL 0000
%% %% & PAL 0000 & PAL 0000 & \tabularnewline
%% %% & email@fxpal.com & email@fxpal.com & email@fxpal.com
%% %% & email@fxpal.com & email@fxpal.com & \tabularnewline
%% %% & +1-650-555-4800 & +1-650-555-4800 & +1-650-555-4800
%% %% & +1-650-555-4800 & +1-650-555-4800 & \tabularnewline
%% %% }
%%   \submittedby{}
%%   \proposaltitle{Our great idea}
%%   \proposaldescription{Little abstract}
%%   \manager{Full Name}{PAL ####}{email@fxpal.com}{+1-650-842-48##}
%%   \problem{}     # Omitted REQUIRED fields will print warning in PDF.
%%   \diagram{}     # OPTIONAL will print warning in log output.
%%   \concepts{}    # One OPTIONAL figure or drawing is recommended
%%   \evaluation{}  # OPTIONAL
%%   \related{}     # REQUIRED
%%   \differences{} # REQUIRED
%%   \disclosure{}  # OPTIONAL (Will print "N/A" otherwise.)
%%   \bibliographystyle{plain}
%%   \nobibliography{bibfile_should_match_jobname}
%% \end{document}
%% 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fxpal-invention}[2017/07/18 FXPAL Invention Class]
\LoadClass[10pt,onecolumn]{article}

\RequirePackage{xcolor}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage[pdftex]{graphicx}
\RequirePackage{array}
\RequirePackage[colorlinks=false,pdfborderstyle={/S/U/W 1}]{hyperref}
\RequirePackage{multirow}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{palatino}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{url}
\RequirePackage{natbib}
\RequirePackage{bibentry}
\RequirePackage{comment}
\RequirePackage{forloop}

\geometry{letterpaper,tmargin=70pt,bmargin=180pt,footskip=30pt}
\definecolor{slcolor}{HTML}{882B21}

\DeclareOption{twocolumn}{\OptionNotUsed}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

%% Contained Flag
\newif\if@contained\@containedfalse
\DeclareOption{contained}{
  \@containedtrue
}

\newtoggle{verbose}
\toggletrue{verbose}
\DeclareOption{quiet}{
  \togglefalse{verbose}
}

\ProcessOptions\relax

\renewcommand{\headrulewidth}{0pt}%
\renewcommand{\footrulewidth}{1.4pt}%

\def\cC{I\!\!\!\!C}
\def\rR{I\!\!R}
\def\nN{N\!\!\!\!N}
\def\zZ{Z\!\!\!Z}
\def\argmax{\mathop{\rm argmax}}
\def\argmin{\mathop{\rm Arg Min}}
\def\trace{\mathop{\rm Tr}}
\newtheorem{algorithm}{Algorithm}
\def\QED{\mbox{\rule[0pt]{1.5ex}{1.5ex}}}

\newcommand{\invention}[1]{%
  \begin{flushleft}
    \textsf{\textbf{\huge FXPAL \ \ \ \ \ \ \ \ \ \ \ }}
    \textsf{\large Invention Proposal}
    \textsf{\textbf{\huge \hfill{} }}
    \textsf{\large FXPAL-IP-#1}
    \par
  \end{flushleft}
  {\large \par}
  \hrule
  \medskip{}
}


\newcounter{one}
\setcounter{one}{1}
\newcounter{authors}
\setcounter{authors}{1}
\newcounter{authorsplus}
\setcounter{authorsplus}{\the\numexpr\value{authors}+\value{one}}
\newcommand{\authorCount}[1]{
  \setcounter{authors}{#1}
  \setcounter{authorsplus}{\the\numexpr\value{authors}+\value{one}}
  % TODO: somewhere here set the footer nicely by adding 10pts per
  % author count
  % \setlength{\footskip}{\the\dimexpr 30 + 10\value{authors}\relax}
}
\newcommand{\authorAName}{}
\newcommand{\authorANumber}{}
\newcommand{\authorAEmail}{}
\newcommand{\authorAPhone}{}  
\newcommand{\authorBName}{}
\newcommand{\authorBNumber}{}
\newcommand{\authorBEmail}{}
\newcommand{\authorBPhone}{}  
\newcommand{\authorCName}{}
\newcommand{\authorCNumber}{}
\newcommand{\authorCEmail}{}
\newcommand{\authorCPhone}{}  
\newcommand{\authorDName}{}
\newcommand{\authorDNumber}{}
\newcommand{\authorDEmail}{}
\newcommand{\authorDPhone}{}  
\newcommand{\authorEName}{}
\newcommand{\authorENumber}{}
\newcommand{\authorEEmail}{}
\newcommand{\authorEPhone}{}  
\newcommand{\authorFName}{}
\newcommand{\authorFNumber}{}
\newcommand{\authorFEmail}{}
\newcommand{\authorFPhone}{}  

\newcommand{\authorA}[4]{%
  \renewcommand{\authorAName}{#1}
  \renewcommand{\authorANumber}{#2}
  \renewcommand{\authorAEmail}{#3}
  \renewcommand{\authorAPhone}{#4}  
}
\newcommand{\authorB}[4]{%
  \renewcommand{\authorBName}{#1}
  \renewcommand{\authorBNumber}{#2}
  \renewcommand{\authorBEmail}{#3}
  \renewcommand{\authorBPhone}{#4}  
}
\newcommand{\authorC}[4]{%
  \renewcommand{\authorCName}{#1}
  \renewcommand{\authorCNumber}{#2}
  \renewcommand{\authorCEmail}{#3}
  \renewcommand{\authorCPhone}{#4}  
}
\newcommand{\authorD}[4]{%
  \renewcommand{\authorDName}{#1}
  \renewcommand{\authorDNumber}{#2}
  \renewcommand{\authorDEmail}{#3}
  \renewcommand{\authorDPhone}{#4}  
}
\newcommand{\authorE}[4]{%
  \renewcommand{\authorEName}{#1}
  \renewcommand{\authorENumber}{#2}
  \renewcommand{\authorEEmail}{#3}
  \renewcommand{\authorEPhone}{#4}  
}

\newcommand{\authorsMore}[1]{}
\newcommand{\authorsExtra}[1]{%
  \renewcommand{\authorsMore}{%
    \\
    #1
  }
}

\newcommand{\submittedby}{%
  \begin{flushleft}
    \textsf{\textbf{Proposal Submitted By}}
    \par
  \end{flushleft}

  \begin{flushleft}    
    \small
    {\footnotesize \vspace*{\smallskipamount}}
    \begin{tabular}{>{\raggedright}p{0.09in}llllll}
      & \textbf{\authorAName{}} & \textbf{\authorBName{}}
      & \textbf{\authorCName{}} & \textbf{\authorDName{}}
      & \textbf{\authorEName{}} & \tabularnewline
      & \authorANumber{} & \authorBNumber{} & \authorCNumber{}
      & \authorDNumber{} & \authorENumber{} & \tabularnewline
      & \authorAEmail{} & \authorBEmail{} & \authorCEmail{}
      & \authorDEmail{} & \authorEEmail{} & \tabularnewline
      & \href{tel:\authorAPhone{}}{\authorAPhone{}}
      & \href{tel:\authorBPhone{}}{\authorBPhone{}}
      & \href{tel:\authorCPhone{}}{\authorCPhone{}}
      & \href{tel:\authorDPhone{}}{\authorDPhone}
      & \href{tel:\authorEPhone{}}{\authorEPhone}  & \tabularnewline
                                                     \authorsMore{}    
    \end{tabular}
    \par
  \end{flushleft}
  \normalsize    
}

\newcommand{\proposaltitle}[1]{%
  \begin{flushleft}
    {\footnotesize \vspace*{1em}
    }\textsf{\textbf{Proposal Title}}  
    \par
  \end{flushleft}

  \begin{flushleft}
    \textsf{\vspace*{\smallskipamount}
    } {\footnotesize }
    \begin{tabular}{>{\centering}p{0.09in}l}
      & \textbf{#1}\tabularnewline
    \end{tabular}
    \par\end{flushleft}{\footnotesize \par}
}

\newcommand{\proposaldescription}[1]{%
  \begin{flushleft}
    \textsf{\footnotesize \vspace*{1em}}
    \textsf{\textbf{Brief Description }}
    \par
  \end{flushleft}
  \begin{flushleft}
    \begin{tabular}{>{\centering}p{0.09in}>{\raggedright}p{4.95in}}
      & \noindent {\small #1}\tabularnewline
    \end{tabular}
    \par
  \end{flushleft}  
}

\newcommand{\manager}[4]{%
  \begin{flushleft}
    \textsf{\textbf{Manager}} 
    \par\end{flushleft}

  \begin{flushleft}
    \vspace*{\smallskipamount}
    \begin{tabular}{>{\raggedright}p{0.09in}llll}
      & {\bf #1}  \tabularnewline
      & {\small #2}  \tabularnewline
      & {\small \href{mailto:#3}{#3}}  \tabularnewline
      & {\small \href{tel:#4}{#4}}  \tabularnewline
    \end{tabular}
    \par\end{flushleft}
  \thispagestyle{fancy}
  \normalsize
}

\newcounter{LineCounter}
\newcommand{\myLTable}{%
  \small{
    \textsf{
      \begin{tabular}{p{4.25in} p{1.25in}}
        \textit{Witnessed and Understood by } \hrulefill & Date \hrulefill \\
        \forloop{LineCounter}{1}{\value{LineCounter} < \value{authorsplus}}
        {
        \\
        \theLineCounter . \textsf{Submitter Signature} \hrulefill
                                                         & Date \hrulefill \\   
        }
      \end{tabular}
    }
  }
  \setcounter{LineCounter}{0}
}

\lhead{} \chead{} \rhead{} 
\lfoot{
  \vspace{0.75pc}
  \myLTable{}
}
\cfoot{} \rfoot{}

\date{}
\makeatletter
\pagestyle{fancy}

%%%%%% CONTAINED MODE (Legacy) 
\if@contained
\ClassWarning{fxpal-invention}{Contained Mode! Sections must be
  wrapped in braces.}
\newcommand{\mc@problem}{%
  \ClassWarning{fxpal-invention}{\string\problem\space not used.}{%
    You must provide a \texttt{\string\problem} description.
  }
}
\newcommand{\problem}[1]{%
  \renewcommand{\mc@problem}{#1}%
}

\newcommand{\mc@diagram}{%
  \ClassWarning{fxpal-invention}{\string\diagram\space not used.}{%  
    It is \textbf{strongly} recommended that you provide a flowchart
    or \texttt{\string\diagram}.
  }
}
\newcommand{\diagram}[1]{%
  \renewcommand{\mc@diagram}{#1}%
}

\newcommand{\mc@evaluation}{%
  \ClassWarning{fxpal-invention}{\string\evaluation\space not used.}{%
    Evaluation section is optional.
  }
}
\newcommand{\evaluation}[1]{%
  \renewcommand{\mc@evaluation}{#1}%
}

\newcommand{\mc@concepts}{%
  \ClassWarning{fxpal-invention}{\string\concepts\space not used.}{%
    You must provide a \texttt{\string\concepts} description.
  }
}
\newcommand{\concepts}[1]{%
  \renewcommand{\mc@concepts}{#1}
}

\newcommand{\mc@related}{
  \ClassWarning{fxpal-invention}{\string\related\space not used.}{%
    You must provide a \texttt{\string\related} description.
  }
}
\newcommand{\related}[1]{%
  \renewcommand{\mc@related}{#1}
}

\newcommand{\mc@differences}{
  \ClassWarning{fxpal-invention}{\string\differences\space not used.}{%
    You must provide a \texttt{\string\differences} description.
  }
}
\newcommand{\differences}[1]{%
  \renewcommand{\mc@differences}{#1}
}

\newcommand{\mc@disclosure}{
  \ClassWarning{fxpal-invention}{No \string\disclosure\space used, saying N/A}{\textit{N/A}}
}
\newcommand{\disclosure}[1]{%
  \renewcommand{\mc@disclosure}{#1}
}

\let\addsec\section

\renewcommand{\section}[1][2]{%
  \ClassWarning{fxpal-invention}{You really shouldn't use \string\section}{}
}

\newcommand{\makedocument}{%
  \newpage  
  \addsec{Problem definition}
  \mc@problem

  \addsec{Flowchart or diagram}
  \mc@diagram
  
  \addsec{Key Invention Concepts}
  \ClassInfo{fxpal-invention}{It's a good idea for CONCEPTS to include 1 optional figure or drawing.}  
  \mc@concepts

  \addsec{Evaluation}
  \mc@evaluation
  
  \addsec{Closely related publications and patents}
  \mc@related

  \addsec{Differences and advantages over related work}
  \mc@differences

  \addsec{Past or planned disclosure dates}
  \mc@disclosure

  \IfFileExists{\jobname .bbl}
  {
    \renewcommand\section{\@startsection {section}{1}{\z@}%
      {-3.5ex \@plus -1ex \@minus -.2ex}%
      {-1em}%
      {\normalfont\Large\bfseries}}   
    \input{\jobname .bbl}
    \renewcommand{\section}[1][2]{%
      \ClassWarning{fxpal-invention}{Don't use \string\section}{}
    }

  }{}
  
  \let\makedocument\relax
}
\AtEndDocument{\makedocument}
\else
\ClassInfo{fxpal-invention}{Using section headers...Good for you.}

\newtoggle{problem}
\toggletrue{problem}
\newtoggle{diagram}
\toggletrue{diagram}
\newtoggle{evaluation}
\toggletrue{evaluation}
\newtoggle{concepts}
\toggletrue{concepts}
\newtoggle{related}
\toggletrue{related}
\newtoggle{differences}
\toggletrue{differences}
\newtoggle{disclosure}
\toggletrue{disclosure}

\newcommand{\problem}{%
  \togglefalse{problem}
  \section{Problem}
}

\newcommand{\diagram}{%
  \togglefalse{diagram}
  \section{Diagram}
}

\newcommand{\evaluation}{%
  \togglefalse{evaluation}
  \section{Evaluation}
}

\newcommand{\concepts}{%
  \togglefalse{concepts}
  \section{Concepts}
}

\newcommand{\related}{%
  \togglefalse{related}
  \section{Related}
}

\newcommand{\differences}{%
  \togglefalse{differences}
  \section{Differences}
}

\newcommand{\disclosure}{%
  \togglefalse{disclosure}
  \section{Disclosure}
}

\AtEndDocument{
  \ifboolexpr{togl{verbose}} { %
    \ifboolexpr{togl{problem} or togl{related} or togl{differences}} {%
      \section*{Issues}
      You must resolve the following issues with this IDF:
      \begin{itemize}    
        \ifboolexpr{togl{problem}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\problem\space not used}
          {\item You must provide a \texttt{\string\problem} section header.}
        }{}
        \ifboolexpr{togl{diagram}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\diagram\space not used}
        }{}
        \ifboolexpr{togl{evaluation}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\evaluation\space not used}
        }{}
        \ifboolexpr{togl{concepts}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\concepts\space not used}
        }{}
        \ifboolexpr{togl{related}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\related\space not used}
          {\item You must provide a \texttt{\string\related} section header.}
        }{}
        \ifboolexpr{togl{differences}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\differences\space not used}
          {\item You must provide a \texttt{\string\differences} section header.}
        }{}
        \ifboolexpr{togl{disclosure}}{%
          \ClassWarningNoLine{fxpal-invention}{\string\disclosure\space
            not used}
          {\item You should provide a \texttt{\string\disclosure}
            section with ``N/A'' if you don't have anything to disclose.}
        }{}
      \end{itemize}
      or you can use the \texttt{[quiet]} class option to hide this
      section.
    }{}
  }{}
}
