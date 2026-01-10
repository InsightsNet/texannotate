\def\sci@fileversion{2.04}
\def\sci@filedate{2016/09/13}
\def\@journal{Sci. China-Phys. Mech. Astron.}
\def\@issn{1674-7348}
\def\@copyright{\copyright~Science China Press and Springer-Verlag Berlin Heidelberg 2017}
\def\@website{\url{phys.scichina.com}~~~~\url{link.springer.com}}

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{SCIS}[\sci@filedate, \sci@fileversion]

\LoadClass[twoside]{article}%twocolumn,
%% math packages
\RequirePackage{amsmath,amsthm,amsfonts,amssymb,bm,times,txfonts,upgreek,multicol,mathrsfs,pifont,amscd,latexsym,geometry,color,fancyhdr}
%% graphics packages,multitoc
\RequirePackage{graphicx,picins,cases,appendix}%,appendix%multitoc%minitoc
%% other packages
\RequirePackage{algorithm,algorithmic,tabularx,url,float,booktabs}
%% check pdfTeX mode
\RequirePackage{ifpdf}
\RequirePackage{fancyhdr,lastpage}
\usepackage{placeins} %%(11月注释：图表浮动宏包)
\usepackage{threeparttable}
\usepackage{floatflt}%floatflt提供了 floatingfigure 和 floatingtable 两个环境,可将浮动图形或表格放置于文字段落的旁边
\usepackage{rotating}% sidewayfigure 和 sidewaystable 环境来使图形或表格横排%rotcaption
%\usepackage{flafter}
%\usepackage{stfloats}



%\RequirePackage[citebordercolor={1 1 1},linkbordercolor={1 1 1},menubordercolor={1 1 1},pagebordercolor={1 1 1},urlbordercolor={1 1 1}]{hyperref}
%\RequirePackage[hyperindex=true,pdfstartview=FitH,breakline=true,CJKbookmarks=blue,bookmarksnumbered=blue,bookmarksopen=blue,colorlinks,pdfborder=001,linkcolor=blue,anchorcolor=blue,citecolor=blue,urlcolor=blue]{hyperref}
\RequirePackage[dvipdfm,hyperindex=true,colorlinks=true,linkcolor=blue,breaklinks,urlcolor=blue,citecolor=blue]{hyperref}
%dvipdfm,dvi转PDF
%\RequirePackage{breakurl,url}
\urlstyle{same}%定义url字体和正文相同
\RequirePackage{cuted,flushend}%双栏情况使用的通栏标题和末尾对齐
\usepackage{balance}
\usepackage{titletoc}
%-------------------------- Page layout ------------------------------
\textwidth=178truemm
\textheight=228truemm
\topmargin=-47.5pt
\headsep=5truemm
\oddsidemargin=-20pt
\evensidemargin=-20pt
\parindent=0pt
\footskip=0mm
\flushend
\columnsep 0.7cm
\renewcommand{\baselinestretch}{1.06}
\renewcommand{\arraystretch}{1.2}
\newcommand{\sanhao}{\fontsize{18pt}{\baselineskip}\selectfont}
\newcommand{\xiaosanhao}{\fontsize{15pt}{2\baselineskip}\selectfont}
\newcommand{\xiaosihao}{\fontsize{12pt}{\baselineskip}\selectfont}
\newcommand{\wuhao}{\fontsize{10pt}{\baselineskip}\selectfont}
\newcommand{\bahao}{\fontsize{8pt}{\baselineskip}\selectfont}
\newcommand{\qihao}{\fontsize{7pt}{\baselineskip}\selectfont}
\newcommand{\jiuhao}{\fontsize{9pt}{0.8\baselineskip}\selectfont}
\newcommand{\shihao}{\fontsize{6pt}{0.8\baselineskip}\selectfont}
\newcommand{\sihao}{\fontsize{11pt}{\baselineskip}\selectfont}


\def\letter{Letter to the Editor}%LETTER
\def\editornote{Erratum}%Editor's Note
\def\highlight{Highlight}%HIGHLIGHT
\def\insight{Comments}%INSIGHT
\def\invitedreview{Invited Review}%INSIGHT
\def\newsviews{News \& Views}%INSIGHT
\def\supplementary{Supplementary File}
\def\blank{ }
\def\lastpage{\pageref{LastPage}}
\def\firstpage{\pageref{FirstPage}}
%-------------------- Article Information ----------------------------
%%\def\ArticleType#1#2{
%%    \def\article{#1}
%%    \ifx\article\editornote
%%        \begin{picture}(0,0)
%%            {#2}
%%        \end{picture}
%%    \else
%%        \begin{picture}(0,0)
%%            \rm
%%            \put(0,-30){\makebox[160truemm][l]{\bf {\sanhao\raisebox{2pt}{.}}~#1~{\sanhao\raisebox{1.5pt}{.}}}}
%%            \put(0,-43){\makebox[160truemm][l]{{~#2~}}}
%%            %{#2}
%%        \end{picture}
%%    \fi
%%}

%%\renewcommand\tableofcontents{%
%%    %%\if@twocolumn
%%%%      \@restonecoltrue\onecolumn
%%%%    \else
%%%%      \@restonecolfalse
%%%%    \fi
%%    %%\section*{\contentsname
%%%%        \@mkboth{%
%%%%           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
%%%%    \vskip -1em \begin{singlespace}      % singlespacing
%%    \@starttoc{toc}%
%%    \if@restonecol\twocolumn\fi
%%   % \end{singlespace}
%%    }
\let\@ArticleType\@empty \def\ArticleType#1{\def\@ArticleType{#1}}
\let\@SpecialTopic\@empty \def\SpecialTopic#1{\def\@SpecialTopic{#1}}
\let\@Year\@empty \def\Year#1{\def\@Year{#1}}
\let\@Month\@empty \def\Month#1{\def\@Month{#1}}
\let\@Vol\@empty \def\Vol#1{\def\@Vol{#1}}
\let\@No\@empty \def\No#1{\def\@No{#1}}
\let\@AuthorMark\@empty \def\AuthorMark#1{\def\@AuthorMark{#1}}
\let\@AuthorCitation\@empty \def\AuthorCitation#1{\def\@AuthorCitation{#1}}
\let\@BeginPage\@empty \def\BeginPage#1{\def\@BeginPage{#1}}
\let\@EndPage\@empty \def\EndPage#1{\def\@EndPage{#1}}
\let\@DOI\@empty \def\DOI#1{\def\@DOI{#1}}
\let\@ArtNo\@empty \def\ArtNo#1{\def\@ArtNo{#1}}
\let\@ReceiveDate\@empty \def\ReceiveDate#1{\def\@ReceiveDate{#1}}
\let\@AcceptDate\@empty \def\AcceptDate#1{\def\@AcceptDate{#1}}
\let\@OnlineDate\@empty \def\OnlineDate#1{\def\@OnlineDate{#1}}
%\let\@PublishedOnlineDay\@empty \def\PublishedOnlineDay#1{\def\@PublishedOnlineDay{#1}}
%\let\@Correspondingauthor\@empty \def\Correspondingauthor#1{\def\@Correspondingauthor{#1}}
\let\@abstract\@empty \renewcommand\abstract[1]{\def\@abstract{#1}}
\let\@keywords\@empty \def\keywords#1{\def\@keywords{#1}}
\let\@PACS\@empty \def\PACS#1{\def\@PACS{#1}}
\let\@Emails\@empty \def\Emails#1{\def\@Emails{#1}}
\let\@contributions\@empty \def\contributions#1{\def\@contributions{#1}}
%\let\@statement\@empty \def\statement#1{\def\@statement{#1}}%interest
\let\@InterestConflict\@empty \def\InterestConflict#1{\def\@InterestConflict{#1}}
\let\@ensubject\@empty \def\ensubject#1{\def\@ensubject{#1}}
\let\@subject\@empty \def\subject#1{\def\@subject{#1}}

\titlecontents{section}[.8em]{\vspace{1\baselineskip}\bfseries}{\thecontentslabel\quad}{}{%
                \hfill\@ArtNo-\thecontentspage}
\titlecontents{subsection}[2.2em]{\vspace{.2\baselineskip}\normalsize}{\thecontentslabel\quad}{}{%
                \hspace{.5em}\dotfill~~\@ArtNo-\thecontentspage}%
\titlecontents{subsubsection}[4.6em]{\vspace{.2\baselineskip}\normalsize}{\thecontentslabel\quad}{}{%\contentslabel{3em}
                \hspace{.5em}\dotfill~~\@ArtNo-\thecontentspage}

%-------------------------- Title ------------------------------------
\let\@title\@empty 
\renewcommand\title[3][]{
  \renewcommand{\baselinestretch}{0.9}
  \renewcommand{\today}{\number\year-\number\month-\number\day}
  \baselineskip 9pt
  \vspace{-7mm}
  \begin{picture}(0,0)
    {\rm
       \put(190.4,20){\xiaosanhao\bfseries{\textcolor[rgb]{0.52,0.52,0.52}{SCIENCE CHINA}}}
         \put(152.5,3){\xiaosanhao\sf{Physics, Mechanics \& Astronomy}}
    \put(0,-4){\thicklines\line(1,0){509.5}}
% \put(0,0){\makebox[178truemm][r]{\href{https://crossmark.crossref.org/dialog/?doi=\@DOI&domain=pdf&date_stamp=\@OnlineDate}{\includegraphics{Print-CrossMark.eps}}}} 
   \put(0,0){\makebox[178truemm][r]{{\includegraphics{Print-CrossMark.eps}}}}
   
   		   	   \ifx\@OnlineDate\empty
				\put(0,-1){\makebox[178truemm][r]{\href{https://crossmark.crossref.org/dialog/?doi=\@DOI&domain=pdf&date_stamp=\today}{\textcolor[rgb]{1.0,1.0,1.0}{\tiny Print-CrossMark}}}} 
				\else
				\put(0,-1){\makebox[178truemm][r]{\href{https://crossmark.crossref.org/dialog/?doi=\@DOI&domain=pdf&date_stamp=\@OnlineDate}{\textcolor[rgb]{1.0,1.0,1.0}{\tiny Print-CrossMark}}}} 
				\fi

     \put(0,-19){\makebox[178truemm][r]{\vbox{\hbox{\footnotesize \@Month~\@Year~~Vol.\,\@Vol~~No.\,\@No: \@ArtNo}}}}
    \put(0,-29){\makebox[178truemm][r]{\vbox{\hbox{\footnotesize  doi:~{\href{https://doi.org/\@DOI}{\@DOI}}}}}}
    }
    \put(0,-662){\makebox[20truemm][l]{\qihao\sf \@copyright}}
    \put(0,-662){\makebox[178truemm][r]{\qihao\sf \@website}}
  \end{picture}

  \vskip 8true mm
  \def\@title{#2}
  \def\@titlehead{#1}
  \def\@titlecitation{#3}
  \ifx\@titlehead\@empty\def\@titlehead{#2}\fi
  \ifx\@titlecitation\@empty\def\@titlecitation{#2}\fi
}


\let\@author\@empty
\let\@authoremail\@empty
\let\@onlyoneauthor\@empty
\let\@onlyoneemail\@empty
\let\@authorcite\@empty
\renewcommand*{\author}[3][]{%
  \ifx\@author\@empty
    \def\@author{#2\@authornote{#1}{#3}}
    \let\@authortemp\@author
  \else
    \let\@author\@authortemp
    \def\@onlyoneauthor{No}
    \expandafter\def\expandafter\@author\expandafter
      {\@author,~{and}~#2\@authornote{#1}{#3}}
    \expandafter\def\expandafter\@authortemp\expandafter
      {\@authortemp,~#2\@authornote{#1}{#3}}
  \fi
  
  \ifx\@AuthorCitation\@empty
    \ifx\@authorcite\@empty \def\@authorcite{#2}
    \else \expandafter\def\expandafter\@authorcite\expandafter{\@authorcite, #2}
    \fi
  \fi
  
  \ifx\@AuthorMark\@empty
    \def\@AuthorMark{#2}
  \fi
    
   \ifx#3\@empty
  \else
      \ifx\@authoremail\@empty
        \def\@authoremail{{\color{blue}#3}}
        \def\@authoremailtemp{#2, email: {\color{blue}#3}}
      \else
        \def\@onlyoneemail{No}
        \let\@authoremail\@authoremailtemp
        \expandafter\def\expandafter\@authoremail\expandafter{\@authoremail; #2, email: {\color{blue}#3}}%
        \expandafter\def\expandafter\@authoremailtemp\expandafter{\@authoremailtemp;  {\color{blue}#3}}
   
 
      \fi
  \fi
  

}

\def\@authornote#1#2{%
  \def\SCAE@author@address{#1}%
  \def\SCAE@author@footnote{#2}%
  
  \ifx\SCAE@author@address\@empty
  \else \textsuperscript{#1}\hspace{-1.2mm}
  \fi
  
  \ifx\SCAE@author@footnote\@empty
  \else
    %%\ifx\@onlyoneauthor\@empty
%%    \else 
    \textsuperscript{\raisebox{-0.1pt}[0mm][0mm]{*}}%
    %\fi
  \fi

}


\def\@address{}
\newcommand*{\address}[2][]{%
  \ifx \@address\@empty
    \def\@address{\@addressline{#1}{#2}}
  \else
    \expandafter\def\expandafter\@address\expandafter
      {\@address;\tabularnewline\@addressline{#1}{#2}}
  \fi}
\def\@addressline#1#2{\@addresscr\hb@xt@1ex{\textsuperscript{\rm#1}\hss}#2}
\def\@addresscr{\def\\{\tabularnewline\@addresscr\hbox to1ex{}\ignorespaces}}

\def\@foundation{}
\newcommand*{\foundation}[1]{
  \def\SCAE@foundation{#1}
  \ifx\SCAE@foundation\@empty
  \else  
    \def\@foundation{\footnotetext{#1}}
  \fi
}


\renewcommand\maketitle{
\begingroup
\renewcommand\thefootnote{\fnsymbol{footnote}}
\let\footnote\thanks
\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}%
\long\def\@makefntext##1{\noindent\@textsuperscript{\normalfont\@thefnmark}##1}%
\@maketitle%首页通栏脚注
%\begin{strip}\@maketitle\end{strip}首页单栏脚注
\thispagestyle{empty}\@thanks
\long\def\@makefntext##1{\noindent##1}%
\@foundation
\endgroup
\renewcommand\thefootnote{\arabic{footnote}}
\setcounter{footnote}{0}
  

  
\setlength{\textwidth}{17.8cm}
\setlength{\textheight}{23.6cm}
\ifx\@ArticleType\letter \renewcommand{\baselinestretch}{1.06}
\else 
    \ifx\@ArticleType\highlight \renewcommand{\baselinestretch}{1.06}
    \else
        \ifx\@ArticleType\insight \renewcommand{\baselinestretch}{1.06}
        %\else \renewcommand{\baselinestretch}{1.1}
       % \ifx\@ArticleType\invitedreview \renewcommand{\baselinestretch}{1.06}
        \else \renewcommand{\baselinestretch}{1.1}
        \ifx\@ArticleType\newsviews \renewcommand{\baselinestretch}{1.06}
        \else \renewcommand{\baselinestretch}{1.1}
        \fi
       % \fi
        \fi
    \fi
\fi
\baselineskip 12.11pt
\parindent=10.8pt


\wuhao
\vspace{5mm}



%\renewcommand\theequation{{\color{blue}\arabic{equation}}}%公式颜色black
%\@addtoreset{equation}{section}


\def\@eqnnum{{\normalfont \color{blue} (\theequation)}}
%\renewcommand\thetable{\Alph{table}\arabic{Table}}
}

\long\def\@makefntext#1{\parindent 12pt \indent\hbox{\hss{\@thefnmark)\ }}#1}
\def\@makefnmark{\hbox\textsuperscript{\@thefnmark)}}


\def\@maketitle{
    \ifx\@ArticleType\editornote
        \begin{picture}(0,0)
            \put(0,-1){\@SpecialTopic}
        \end{picture}
    \else
        \begin{picture}(0,0)
            \rm
            \put(0,11){\makebox[178truemm][l]{\bf {\sanhao\raisebox{2pt}{.}}~{\sihao\@ArticleType}~{\sanhao\raisebox{1.5pt}{.}}}}
            \put(0,-1){\@SpecialTopic}
        \end{picture}
    \fi



\noindent
\vskip 21mm
\begin{center}\LARGE\bfseries \@title \end{center}
  
\ifx\@ArticleType\editornote
\else
    \vskip 0.5 true cm
    \renewcommand{\baselinestretch}{1.1}
    \baselineskip 12pt
    \vspace{-9mm}
    \begin{center}\xiaosihao{
            \rm
            \begin{tabular}{@{}c@{}}
                \@author
                \setcounter{footnote}{-1}
                \ifx\@onlyoneemail\@empty
                   % \footnote{*{\thinspace}Corresponding author (email:~{\color{blue}\@authoremail})}
                \else 
                    %\footnote{*{\thinspace}Corresponding authors (\color{blue}\@authoremail)}
                \fi
            \end{tabular}
        }\end{center}
  
       %% \ifx\@contributions\@empty
%%      \else
%%          \setcounter{footnote}{-1}
%%          \footnote{\dag{\thinspace}\@contributions}
%%      \fi
      
      
      
    \vskip 0.1 true cm
    \renewcommand{\baselinestretch}{0.9}
    \baselineskip 9pt
    \vspace{-4.5mm}
    \begin{center}\bahao{\it
        \begin{tabular}[t]{@{}c@{}}
            \@address
        \end{tabular}
    }\end{center}
      
    \ifx\@ArticleType\supplementary
    \else
        \vspace{-4mm}
        \begin{center}\bahao{
              \ifx\@OnlineDate\@empty{Received \@ReceiveDate; accepted \@AcceptDate}
              \else{Received \@ReceiveDate; accepted \@AcceptDate; published online \@OnlineDate}
              \fi
        }\end{center}
    \fi
      
    \ifx\@ArticleType\letter
    \else
        \ifx\@ArticleType\highlight
        \else
          \ifx\@ArticleType\insight
          %\else
          %\ifx\@ArticleType\invitedreview
           \else
          \ifx\@ArticleType\newsviews
          \else
            \ifx\@ArticleType\supplementary
            \else
              \renewcommand{\baselinestretch}{1.05}
              \baselineskip 15pt
              \vspace{-10mm}\hspace{6.3mm}
              \begin{center}\rule{16.3cm}{0.4pt}\end{center}
              \vspace{-2.3mm}
              \begin{center}\parbox{16.3cm}{
                \jiuhao\noindent\ignorespaces\@abstract}
              \end{center}
              \vspace{-2.6mm}
              \begin{center}\parbox{16.3cm}{
                \jiuhao\noindent\bf\ignorespaces\@keywords}
              \end{center}
              \vspace{-6.0mm}
          \begin{center}\parbox{16.3cm}{
            \jiuhao\noindent\textbf{PACS number(s):}\quad\ignorespaces\@PACS}
            \end{center}\vspace{-1.8mm}
                \fi
              \fi
            \fi
          \fi
        %\fi
      \fi
      
      \ifx\@ArticleType\supplementary
      \else
          \renewcommand{\baselinestretch}{1.2}{
          \ifx\@AuthorCitation\@empty \def\@AuthorCitation{\@authorcite} \fi
          \hspace{6.3mm}
          \scriptsize
          \begin{tabular}{lp{0.825\textwidth}}
        \hline\vspace*{-2.5mm}\\
                       \noindent{\bf Citation:}\!\!\!\!& \@AuthorCitation, \@titlecitation, \@journal\ {\bf \@Vol}, \@ArtNo~(\@Year),
        \makeatletter doi: {\href{https://doi.org/\@DOI}{\@DOI}}\makeatother\vspace{1mm}\\
        \hline
    \end{tabular}}
      \fi
  \fi
  \vspace{3mm}
}


\def\Authorfootnote{\linebreak\vspace*{-8mm}
\begin{flushleft}\renewcommand{\baselinestretch}{0.7}\noindent\rule{2.5cm}{0.4pt}\\[0.1mm]
\qihao
        \ifx\@onlyoneemail\@empty
     {*Corresponding author (email:~\@authoremail)}\\\noindent
     \else 
     {*Corresponding authors (\@authoremail)}\\\noindent
      \fi
%*{\thinspace}Corresponding authors (\@authoremail)\\\noindent
   
    \ifx\@contributions\@empty
    \else \noindent\dag{\thinspace}\@contributions\\\noindent
    \fi
\end{flushleft}
%%\ifx\@interest\@empty
%%\else \noindent\dag\dag{\thinspace}\@interest
%%\fi}
}
 



%----------------------- Running heads ---------------------------------
\def\ps@myheadings{\global\let\@oddfoot\@empty\global\let\@evenfoot\@empty
    \def\@evenhead{\vbox{\hbox to \textwidth{
        \qihao
        %\thepage
        \rm\hbox to 0.01cm{} \hfill{
            \ifx \@onlyoneauthor\@empty 
                \@AuthorMark\emph{\ \ \ \@journal}
            \else
                \@AuthorMark\emph{,~et al.\ \ \ \@journal}
            \fi
            {~~~~\@Month ~(\@Year) ~~~Vol.~\@Vol ~~~ No.~\@No~}
        }\hfill\textsf{\jiuhao\@ArtNo-\thepage}
    }}}
    
    \def\@oddhead{\vbox{\hbox to \textwidth{
        \qihao\rm\hbox to 0.01cm{} \hfill{
            \ifx \@onlyoneauthor\@empty 
                \@AuthorMark\emph{\ \ \ \@journal}
            \else
                \@AuthorMark\emph{,~et al.\ \ \ \@journal}
            \fi
            {~~~~\@Month ~(\@Year) ~~~Vol.~\@Vol ~~~ No.~\@No~}
        }\hfill\textsf{\jiuhao\@ArtNo-\thepage}
       %\thepage
    }}}

    \let\@oddfoot\@empty  \let\@evenfoot\@empty
}
\pagestyle{myheadings}


%---------------------- Acknowledgements -------------------------------
\let\@Acknowledgements\@empty \def\Acknowledgements#1{\def\@Acknowledgements{#1}}
\let\@Supplements\@empty \def\Supplements#1{\def\@Supplements{#1}}

%-------------------------- Sections ----------------------------------
%%\renewcommand\section{
%%    \@startsection{section}{1}{\z@}%
%%    {-4.5ex \@plus -1ex \@minus -.2ex}%
%%    {2.5ex \@plus.1ex}%
%%    {\normalfont\xiaosihao\bfseries}}
%%
%%\renewcommand\subsection{
%%    \@startsection{subsection}{2}{\z@}%
%%    {-2ex\@plus -2ex \@minus -.1ex}%
%%    {2ex \@plus .2ex}%
%%    {\normalfont\normalsize\bfseries}}
%%
%%\renewcommand\subsubsection[1]{
%%    \@startsection{subsubsection}{3}{\z@}%
%%    {-3ex\@plus -1ex \@minus -.1ex}%
%%    {1ex \@plus .1ex}%
%%    {\normalfont\normalsize}{\it#1}}

\usepackage{titlesec}
\titleformat{\section}[block]{\normalfont\xiaosihao\bfseries}{\thesection}{0.63em}{ }[]
\titleformat{\subsection}[block]{\normalfont\normalsize\bfseries}{\thesubsection}{0.6em}{ }[ ]
\titleformat{\subsubsection}[block]{\normalfont\normalsize\it}{\thesubsubsection}{0.5em}{ }[ ]
%\titleformat{\section}[block]{first}{label}{0pt}{\ifsectionstar{#1}{\bf #1}}[trailer]


%\titleformat{\section}[block]{\vspace{-2mm}\normalfont\xiaosihao\bfseries}{\thesection}{0.63em}{ }[ ]

%%{% something like Bringhurst  
%%\titleformat{\chapter}[display]%
%%    {\relax}{\mbox{}\oldmarginpar{\vspace*{-3\baselineskip}\color{halfgray}\chapterNumber\thechapter}}{0pt}%
%%    {\raggedright\spacedallcaps}[\normalsize\vspace*{.8\baselineskip}\titlerule]% 
%%}


\def\sec#1{\vspace{7mm}\noindent{{\xiaosihao\rm\bfseries{#1}}}\vspace{4mm}}% 定义一级章节
\def\subsec#1{\vspace{5mm}\noindent{\normalsize\bfseries#1}\vspace{2mm}} %定义二级章节
\def\subsubsec#1{\vspace{4mm}\noindent{\it #1}\vspace{1mm}}%定义三级章节

\newcommand\deareditor{
    {\normalfont\normalsize\bfseries\noindent Dear editor,\par}
}

\newcommand\lettersection[1]{{\it #1}. }
\columnsep 0.7cm  %两栏之间的距离



\let\oldappendix\appendix
\renewenvironment{appendix}{
    \oldappendix
    \setcounter{section}{0}
    %\def\@eqnnum{{\normalfont \color{red} (\theequation)}}
     \def\thesection{Appendix \Alph{section}}%
     %\def\thesubsection{\Alph{section}}%\Alph{section}
     %\renewcommand{\thesection}{\Alph{section}\arabic{section}}
    \renewcommand{\thesubsection}{\Alph{section}.\arabic{subsection}}
    
    \renewcommand{\theequation}{{\color{blue}\alph{section}\arabic{equation}}}%公式颜色
    \renewcommand{\thefigure}{\Alph{section}\arabic{figure}}
    \renewcommand{\thetable}{\Alph{section}\arabic{table}}
    \renewcommand{\thealgorithm}{\Alph{section}\arabic{algorithm}}
    \renewcommand{\theassumption}{\Alph{section}.\arabic{assumption}}
\renewcommand{\thecorollary}{\Alph{section}.\arabic{corollary}}
\renewcommand{\thedefinition}{\Alph{section}.\arabic{definition}}
\renewcommand{\theexample}{\Alph{section}.\arabic{example}}
\renewcommand{\thelemma}{\Alph{section}.\arabic{lemma}}
\renewcommand{\theproblem}{\Alph{section}.\arabic{problem}}
\renewcommand{\theproposition}{\Alph{section}.\arabic{proposition}}
\renewcommand{\theremark}{\Alph{section}.\arabic{remark}}
\renewcommand{\thetheorem}{\Alph{section}.\arabic{theorem}}

    \renewcommand{\section}{
        \setcounter{equation}{0}
        \setcounter{table}{0}
        \setcounter{figure}{0}
        \setcounter{algorithm}{0}
        \setcounter{assumption}{0}
        \setcounter{corollary}{0}
        \setcounter{definition}{0}
        \setcounter{example}{0}
        \setcounter{lemma}{0}
        \setcounter{problem}{0}
        \setcounter{proposition}{0}
        \setcounter{remark}{0}
        \setcounter{theorem}{0}

        \@startsection{section}{1}{\z@}%
        {-4.5ex \@plus -1ex \@minus -.2ex}%
        {1ex \@plus .2ex}%
        {\normalfont\xiaosihao\bfseries}
    }
    \renewcommand{\baselinestretch}{1.08} \baselineskip 13.2pt
    %\footnotesize\renewcommand{\baselinestretch}{1.06}
%\renewcommand{\arraystretch}{1.2}
}

%-------------------------- Bibliography ------------------------------
\usepackage{cite}%使多个参文中间用--连接
\def\@biblabel#1{#1~}
\renewenvironment{thebibliography}[1]{
    \ifx\@Acknowledgements\@empty\else
    \vskip 3mm\renewcommand{\baselinestretch}{1.08} \baselineskip 10pt
    {\bahao\noindent{\it\@Acknowledgements}}
    \fi
    
    
    \ifx\@InterestConflict\@empty\else
    {\vskip 3mm\jiuhao\noindent{\textbf{Conflict of interest}\quad\@InterestConflict}}
    \fi
    
    
    \ifx\@Supplements\@empty\else
        \vskip 6mm
        {\jiuhao\noindent\textbf{Supporting Information}\vspace{2mm}\\{
        \ifx\@Supplements\blank\else{\@Supplements~ }\fi
        }}
    \fi
    
    \section*{%\normalsize\refname
        \@mkboth{\jiuhao\refname}{\jiuhao\refname}}%
    \vspace{-9mm}
    \list{\@biblabel{\@arabic\c@enumiv}}{
        \settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}
    }
    \itemsep 0ex \parskip 0ex
    \footnotesize\sloppy
}
\renewcommand{\UrlFont}{\selectfont} %使用\url{}使参文中的url自动断行



\RequirePackage{cleveref}%图表序号多个1－3
  
  %\PackageInfo{cleveref}{loaded `english' language definitions}
  \AtBeginDocument{
\renewcommand{\crefrangeconjunction}{-}%连续数字1－3
%\renewcommand{\crefpairconjunction}{-}%数字1和2

\renewcommand{\crefpairconjunction}{ {\color{black}and}~}
      \renewcommand{\creflastconjunction}{ {\color{black}and}~}%
      \renewcommand{\crefpairgroupconjunction}{ {\color{black}and}~}%
      \renewcommand{\creflastgroupconjunction}{{\color{black}, and}~}%
      
\crefname{table}{\color{blue}Table}{\color{blue}Tables}%%%表格序号颜色black
\crefname{figure}{\color{blue}Figure}{\color{blue}Figures}%%%图题字颜色black
\crefname{equation}{\color{blue}eq.}{\color{blue}eqs.}%公式序号题字颜色black
\Crefname{equation}{\color{blue}Eq.}{\color{blue}Eqs.}
\crefname{section}{\color{blue}sect.}{\color{blue}sects.}%小标题字颜色black
 }
 



%-------------------------- Figures and tables ------------------------


%----------------------------------图表相关-----------------------------

%\usepackage{flushend}%%(11月注释：双栏对齐宏包，此处不起作用)
%\usepackage{balance}%%(11月注释：双栏对齐宏包，此处不起作用)
\usepackage{booktabs}%%(11月注释：表格宏包，可调整表格中的线宽)
\usepackage{caption2}%%(11月注释：标题宏包)
\renewcommand{\captionlabeldelim}{~~~}%%(11月注释：定义标题编号与标题间空三格)
\captionstyle{normal} %%(11月注释：标题两边对齐，最后一行左对齐)
\renewcommand{\captionfont}{\footnotesize}%%(11月注释：小号标题)
\renewcommand{\captionlabelfont}{\footnotesize \bfseries\color{blue}}%%(11月注释：小号黑体标题编号)
 %\setbeamercolor{math text}{fg=red}
 %\setbeamercolor{math text inlined}{fg=black}
%%\usepackage{caption}%%(11月注释：标题宏包，可调整标题字体字号)
%%\DeclareCaptionLabelSeparator{twospace}{~~}%%(11月注释：定义标题编号与标题间空两格)
%%\captionsetup{labelsep=twospace}%%(11月注释：标题编号与标题间空两格)
\captionsetup{singlelinecheck=off} %%图题左齐标志  



\setlength{\floatsep}{12pt plus 2pt minus 2pt}%页面顶部/底部的浮动对象间的垂直距离, 缺省为12pt plus 2pt minus 2pt
\setlength{\textfloatsep}{12pt plus 2pt minus 2pt}%页顶部/底部的浮动对象与文本间垂直距离, 缺省20pt plus 2pt minus 4pt
\setlength{\intextsep}{12pt plus 2pt minus 2pt}%页中浮动对象与上下方文本间垂直距离, 缺省12pt plus 2pt minus 2pt
\setlength{\belowrulesep}{0pt}%横线和其下文字的间距
\setlength{\aboverulesep}{0pt}%横线和其上文字的间距



%%\setlength{\doublerulesep}{0.4pt}
%%\newcommand\Times{\fontfamily{ptm}\selectfont}
%%\newcommand{\picsize}{\fontsize{8pt}{0.4\baselineskip}\selectfont}
%%\usepackage[bf,footnotesize,labelsep=quad]{caption}
%%\usepackage[labelfont={rm,md,up}]{subfig}
%%\captionsetup[subfloat]{labelformat=simple,captionskip=0pt}
%%\captionsetup[table]{aboveskip=1mmf}
%%\captionsetup[figure]{aboveskip=3mm}
%%\captionsetup[algorithm]{font=footnotesize}
%%\renewcommand{\thesubfigure}{{\picsize\Times(\alph{subfigure})}} %这两行定义子图在正文引用时的label形式
%%\renewcommand{\thesubtable}{{\picsize(\alph{subtable})}} %子表label的字体仍和正文相同

%----------------------- Math ---------------------------------
\def\leq{\leqslant}
\def\geq{\geqslant}
\def\le{\leqslant}
\def\ge{\geqslant}
\abovedisplayskip=11pt plus 0pt minus 6pt 
\belowdisplayskip=11pt plus 0pt minus 6pt 
\newcommand{\set}[1]{\ensuremath{\left\{ #1 \right\}}}%
\newcommand{\Set}[2]{\ensuremath{\left\{ #1 \left| \right. #2 \right\}}}%
\newcommand{\abs}[1]{\ensuremath{\left| #1 \right|}}%
\newcommand{\map}[3]{\ensuremath{#1 : #2 \rightarrow #3}}%
\newcommand{\C}[1]{\ensuremath{\mathcal{#1}}}%
\newcommand{\restrict}[2]{\ensuremath{#1 \left|_{#2}\right.}}%
\newcommand{\NN}{\mathbb{N}^0}
\newcommand{\PN}{\mathbb{N}}
\newcommand{\syn}{\mathbf{S}}
\newcommand{\Syn}{\mathbf{M}}
\allowdisplaybreaks
\setlength{\arraycolsep}{2.0pt}

%--------------------------------- Theorems ---------------------------------
\def\proof{\noindent{\it Proof.}\quad}
\def\th#1{\noindent{\bf #1}\quad}%The common style. 通用形式
\renewcommand{\qedsymbol}{}
\newtheoremstyle{newdefinition}%
    {2pt}% Space above
    {2pt}% Space below
    {\normalfont}% Body font
    {}% Indent amount
    {\bfseries}% Theorem head font
    {.}% Punctuation after theorem head
    {10pt plus 1pt minus 1pt}% Space after theorem head
    {}% Theorem head spec (can be left empty, meaning `normal')
\theoremstyle{newdefinition}%
\newtheorem{assumption}{Assumption}
\newtheorem{corollary}{Corollary}
\newtheorem{definition}{Definition}
\newtheorem{example}{Example}
\newtheorem{lemma}{Lemma}
\newtheorem{problem}{Problem}
\newtheorem{proposition}{Proposition}
\newtheorem{remark}{Remark}
\newtheorem{theorem}{Theorem}

\iffalse
\makeatletter
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 9\p@ \@plus4\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip  \abovedisplayskip
   \let\@listi\@listI}
\makeatother
\fi

\let\citedash\relax
\makeatletter \providecommand{\citedash}{\hbox{-}\penalty\@m}

%%%%参考文献引用括号颜色\color{black}
\def\@cite#1#2{{\color{blue}[{#1\if@tempswa , #2\fi}]}}
%\def\@cite#1#2{\textsuperscript{\color{blue}\![{#1\if@tempswa , #2\fi}]}}%上角

%%%%公式序号颜色\color{black}
 
\let\reftagform@=\tagform@
\def\tagform@#1{\maketag@@@{\textcolor{blue}{(\ignorespaces{#1}\unskip\@@italiccorr)}}}


\makeatother

%--------------------------------- list ---------------------------------
\renewenvironment{itemize}{
\begin{list}{$\bullet$}{
\labelwidth=4em
\labelsep=0.5em
\leftmargin=0em
\rightmargin=0em
\parsep=\parskip
\itemsep=0em
\topsep=0em
\itemindent=2.1em
}
}{\end{list}}


\endinput

