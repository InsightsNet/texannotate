%%
%% This is file `Uzhgorod-Mathematical-Paper',
%% generated with the docstrip utility.
%%
%% Uzhgorod-Mathematical author's package
%%
%% Scientific Review of Uzhgorod University paper style
%%
%% Mathematical and Informatic series
%%
%% Alexander Tylyshchak
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Uzhgorod-Mathematical-Paper-2024}[2024/12/17 Scientific Review of Uzhgorod University paper class (Mathematical series)]

\newcommand\makeump@expert{}
\newcommand\makeexpert{}
\DeclareOption{expert}{\renewcommand\makeump@expert\makeexpert%
                       \evensidemargin=\oddsidemargin\PassOptionsToClass{draft}{article}}
\ProcessOptions
\LoadClass[twoside,12pt]{article}

\oddsidemargin=0mm
\evensidemargin=0mm

\newcommand{\@downmark}{{\selectlanguage{ukrainian}\IeC{\CYRN}\IeC{\cyra}\IeC{\cyru}\IeC{\cyrk}. 
\IeC{\cyrv}i\IeC{\cyrs}\IeC{\cyrn}\IeC{\cyri}\IeC{\cyrk}
\IeC{\CYRU}\IeC{\cyrzh}\IeC{\cyrg}\IeC{\cyro}\IeC{\cyrr}\IeC{\cyro}\IeC{\cyrd}.
\IeC{\cyru}\IeC{\cyrn}-\IeC{\cyrt}\IeC{\cyru}, \@umpyear, \IeC{\cyrt}\IeC{\cyro}\IeC{\cyrm} \@umpnumber, \symbol{157} \@umpsubnumber}}
%\renewcommand{\@oddhead}{{\footnotesize\rm \rightmark\hfil\thepage}}
%\renewcommand{\@oddfoot}{{\footnotesize\@downmark\hfill ISSN \@umpissn}}
%\renewcommand{\@evenhead}{{\footnotesize\rm \thepage\hfil\leftmark}}%
%\renewcommand{\@evenfoot}{{\footnotesize ISSN \@umpissn\hfill\@downmark}}%
%\newcommand{\@evenchapterfoot}{{\footnotesize ISSN \@umpissn\hfill\@downmark}}%

\RequirePackage[T1,T2A]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[english,ukrainian]{babel}
\RequirePackage{amsmath,amsfonts,amssymb,amsthm,graphicx,amscd,latexsym,fancyhdr,cite,wrapfig,array}
\RequirePackage[dvipsnames,table]{xcolor}
\RequirePackage[mathcal]{euscript}
\RequirePackage[all]{xy}
\RequirePackage{cmap}
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{enumitem}



\pagestyle{fancy}
\fancyhead{}\fancyfoot{}
\fancyhead[RO]{\footnotesize\UMPpdfrender{\thepage}}
\fancyhead[LO]{\footnotesize\rm \UMPpdfrender{\rightmark}}
\fancyhead[LE]{\footnotesize\UMPpdfrender{\thepage}}
\fancyhead[RE]{\footnotesize\rm \UMPpdfrender{\leftmark}}
\fancyfoot[RO]{\footnotesize\rm \protect\raisebox{0pt}{\UMPpdfrender{ISSN \@umpissn}}}
\fancyfoot[LO]{\footnotesize\UMPpdfrender{\@downmark}}
\fancyfoot[LE]{\footnotesize\rm \protect\raisebox{0pt}{\UMPpdfrender{ISSN \@umpissn}}}
\fancyfoot[RE]{\footnotesize\UMPpdfrender{\@downmark}}
\headwidth=150mm

%\renewcommand{\headrulewidth}{0.5pt}
\newcommand{\UMPpdfrender}[1]{{#1}}% Shchob zhyrnishe drukuvav
\newcommand{\UMPpdfrenderNoArg}{}% Shchob zhyrnishe drukuvav, bez argumenta
\renewcommand{\thepage}{\UMPpdfrender{\arabic{page}}}

\headsep=1mm
\footskip=10mm
\oddsidemargin=5mm
\evensidemargin=5mm
\topmargin=-15mm
\textwidth=150mm
\textheight=240mm
\hfuzz=1.5pt
\parindent=1.5em
\looseness=-1
\topsep=0pt
\itemsep=0pt
\partopsep=0pt
\parskip=0pt
\renewcommand{\@listI}{%
\leftmargin=22pt
\rightmargin=0pt
\labelsep=5pt
\labelwidth=18pt
\itemindent=5pt
\listparindent=0pt
\topsep=5pt plus 2pt minus 4pt
\partopsep=0pt plus 1pt minus 1pt
\parsep=0pt plus 1pt
\itemsep=\parsep}

%\topmargin=-15mm
%\textwidth=160mm
%\textheight=247mm
%\hfuzz=1.5pt
%\parindent=1.5em
%\looseness=-1
%\topsep=0pt
%\itemsep=0pt
%\partopsep=0pt
%\parskip=0pt



\newcounter{ump@nnumber}
\def\umpnumber#1{\gdef\@umpnumber{#1}%
                 \setcounter{ump@nnumber}{#1}}
\def\@umpnumber{\my@message{Umpnumber not given}}
\newcommand\numberump{\@umpnumber}
\newcommand\prenumberump{\addtocounter{ump@nnumber}{-1}%
                         \arabic{ump@nnumber}%
                         \addtocounter{ump@nnumber}{1}}
\newcommand\postnumberump{\addtocounter{ump@nnumber}{1}%
                         \arabic{ump@nnumber}%
                         \addtocounter{ump@nnumber}{-1}}

\newcounter{ump@nsubnumber}
\def\umpsubnumber#1{\gdef\@umpsubnumber{#1}%
                 \setcounter{ump@nsubnumber}{#1}}
\def\@umpsubnumber{\my@message{Umpsubnumber not given}}
\newcommand\subnumberump{\@umpsubnumber}

\newcounter{ump@nyear}
\def\umpyear#1{\gdef\@umpyear{#1}%
                 \setcounter{ump@nyear}{#1}}
\def\@umpyear{\my@message{Umpyear not given}}
\newcommand\yearump{\@umpyear}
\newcommand\preyearump{\addtocounter{ump@nyear}{-1}%
                         \arabic{ump@nyear}%
                         \addtocounter{ump@nyear}{1}}
\newcommand\postyearump{\addtocounter{ump@nyear}{1}%
                         \arabic{ump@nyear}%
                         \addtocounter{ump@nyear}{-1}}

%\uccode`і=`І
%\uccode`І=`І
%\uccode`ї=`Ї
%\uccode`Ї=`Ї
%\uccode`є=`Є
%\uccode`Є=`Є
%\uccode`ґ=`Ґ
%\uccode`Ґ=`Ґ

\def\umpdoi#1{\gdef\@umpdoi{#1}}
\def\@umpdoi{\my@message{UmpDOI not given}}

\def\umpissnprint#1{\gdef\@umpissnprint{#1}}
\def\@umpissnprint{\my@message{UmpISSNprint not given}}
\newcommand\issnumpprint{\@umpissnprint}%

\def\umpissnonline#1{\gdef\@umpissnonline{#1}}
\def\@umpissnonline{\my@message{UmpISSNonline not given}}
\newcommand\issnumponline{\@umpissnonline}%

\newcommand\@umpissn{\@umpissnprint\ (print), \@umpissnonline\ (online)}%
\newcommand\issnump{\@umpissn}%

\def\udk#1{\gdef\@udk{#1}}
\def\@udk{}

\def\titlephoto#1{\gdef\@titlephoto{#1}}
\def\@titlephoto{}

\def\title#1{\gdef\@title{#1}\gdef\title@ua{#1}\gdef\capital@title{\MakeUppercase{#1}}}
\def\@title{}

\def\orcid#1{\gdef\@orcid{#1}\gdef\orcid@eng{#1}}
\def\@orcid{}

\def\shorttitle#1{\gdef\@shorttitle{#1}}
\def\@shorttitle{}

\def\capitaltitle#1{\gdef\@capitaltitle{#1}}
\def\@capitaltitle{}%{\my@message{Capitaltitle not given}}

\def\capitaltitleeng#1{\gdef\@capitaltitleeng{#1}}
\def\@capitaltitleeng{}%{\my@message{Capitaltitle not given}}

\def\titleeng#1{\gdef\@titleeng{#1}\gdef\title@eng{#1}\gdef\capital@titleeng{\MakeUppercase{#1}}}
\def\@titleeng{}


\newenvironment{breakablealgorithm}
  {% \begin{breakablealgorithm}
  \bigskip
   \begin{center}
     \refstepcounter{algorithm}% New algorithm
     \hrule height.8pt depth0pt \kern2pt% \@fs@pre for \@fs@ruled
     \renewcommand{\caption}[2][\relax]{% Make a new \caption
       {\raggedright\textbf{\ALG@name~\thealgorithm} ##2\par}%
       \ifx\relax##1\relax % #1 is \relax
         \addcontentsline{loa}{algorithm}{\protect\numberline{\thealgorithm}##2}%
       \else % #1 is not \relax
         \addcontentsline{loa}{algorithm}{\protect\numberline{\thealgorithm}##1}%
       \fi
       \kern2pt\hrule\kern2pt
     }
  }{% \end{breakablealgorithm}
     \kern2pt\hrule\relax% \@fs@post for \@fs@ruled
   \end{center}
   \bigskip
  }


\newcounter{umpchapter}
\newcounter{umpsuperchapter}
\newcounter{chapterump}[umpsuperchapter]
\newcounter{ump@eng@contens}
\@addtoreset{equation}{umpchapter}
\@addtoreset{paragraph}{umpchapter}
\@addtoreset{figure}{umpchapter}
\@addtoreset{table}{umpchapter}

\newcounter{author@number}
\newcounter{author@current}
\newcounter{author@chapter}

\def\author#1{%
  \stepcounter{author@number}
  \expandafter\gdef\csname author@\roman{umpchapter}@\roman{author@number}\endcsname {#1}
  \ifx\@empty\@authors
    \gdef\@authors{#1}%
    \gdef\n@authors{#1}%
  \else
    \ifnum\c@author@number=2 \g@addto@macro\n@authors{\textsuperscript{1}}\fi%
    \g@addto@macro\@authors{, #1}%
    \g@addto@macro\n@authors{, #1}%
    \ifnum\c@author@number=2 \g@addto@macro\n@authors{\textsuperscript{2}}\fi%
    \ifnum\c@author@number=3 \g@addto@macro\n@authors{\textsuperscript{3}}\fi%
    \ifnum\c@author@number=4 \g@addto@macro\n@authors{\textsuperscript{4}}\fi%
    \ifnum\c@author@number=5 \g@addto@macro\n@authors{\textsuperscript{5}}\fi%
    \ifnum\c@author@number=6 \g@addto@macro\n@authors{\textsuperscript{6}}\fi%
    \ifnum\c@author@number=7 \g@addto@macro\n@authors{\textsuperscript{7}}\fi%
    \ifnum\c@author@number=8 \g@addto@macro\n@authors{\textsuperscript{8}}\fi%
  \fi%
 }%
\def\clear@authors{%
\setcounter{author@current}{0}
\loop%
\ifnum\c@author@current<8%
\refstepcounter{author@current}%
\expandafter\gdef\csname institution@\roman{umpchapter}@\roman{author@current}\endcsname {\my@message{Institution not given}}
%\expandafter\gdef\csname pos@\roman{umpchapter}@\roman{author@current}\endcsname{\my@message{Position not given}}
%\expandafter\gdef\csname academ@\roman{umpchapter}@\roman{author@current}\endcsname{\my@message{Academic Title not given}}
\expandafter\gdef\csname mail@\roman{umpchapter}@\roman{author@current}\endcsname {\my@message{Mail not given}}
%\expandafter\gdef\csname orcid@\roman{umpchapter}@\roman{author@current}\endcsname {\my@message{ORCID not given}}
\repeat%
\gdef\@authors{}\gdef\n@authors{}\setcounter{author@number}{0}}
\clear@authors

\def\institution#1{\expandafter\gdef\csname institution@\roman{umpchapter}@\roman{author@number}\endcsname {#1} }%
\def\position#1{\expandafter\gdef\csname pos@\roman{umpchapter}@\roman{author@number}\endcsname{#1}}%
\def\academictitle#1{\expandafter\gdef\csname academ@\roman{umpchapter}@\roman{author@number}\endcsname{#1}}%
\def\mail#1{\expandafter\gdef\csname mail@\roman{umpchapter}@\roman{author@number}\endcsname {\texttt{#1}} }%
\def\orcid#1{\expandafter\gdef\csname orcid@\roman{umpchapter}@\roman{author@number}\endcsname {\texttt{#1}} }%

\def\shortauthor#1{\gdef\@shortauthor{#1}\gdef\author@ua{#1}}
\def\@shortauthor{}

\def\capitalauthor#1{\gdef\@capitalauthor{#1}}
\def\@capitalauthor{}

\def\authorr#1{}

\def\authoreng#1{\gdef\@authoreng{#1}\gdef\author@eng{#1}}
\def\@authoreng{}

\def\received#1{\gdef\@received{#1}}
\def\@received{}

\def\prorector#1{\gdef\@prorector{#1}}
\def\@prorector{Височанський~Ю.~М.}

\newcommand{\inform}{\protect\makebox[2em][c]{{\it Рец.}:}%
\fbox{\protect\makebox[5em][l]{\protect\rule{0em}{0.8em}}}.
\protect\makebox[3em][c]{{\it Екс.}:$\Box$}.
\fbox{\protect\makebox[3.3em][r]{{\bf\ref{lastpage\theumpchapter}}{ \it ст.}:}%
\protect\makebox[3em][c]{\pageref{firstpage\theumpchapter}--\pageref{lastpage\theumpchapter}}}
}


\newlength\umpcontensparskip
\umpcontensparskip=0.055em plus 0.05em minus 0.15em

\newcommand{\engautor@a}{}

\newcounter{ump@engcontens}% Рахівник записів дла англійського змісту
\newcommand{\engcontensline}{No given}
\newcommand{\emptycont}{%
\addcontentsline{toc}{subsection}{%
\protect\refstepcounter{ump@engcontens}
\global\def\string\engcontensline\roman{ump@eng@contens}{ \protect\parbox[b]{0.92\textwidth}{%
\hangindent=2em\noindent\protect\makebox[0em][r]{\ifnum\c@chapterump=0\relax\else\thechapterump.~\fi}{\it\@authoreng} \@titleeng\dotfill%
}\hfill\vspace{1\umpcontensparskip}\pageref{firstpage\theumpchapter}%
}%
\global\def\string\engauthor\roman{ump@eng@contens}{\@authoreng}%
\global\def\string\engtitle\roman{ump@eng@contens}{\@titleeng}%
\rm\protect\makebox[0em][r]{\ifnum\c@chapterump=0\relax\else\thechapterump.~\fi}%
\foreignlanguage{ukrainian}{{\it \@shortauthor} \@title \vspace{\umpcontensparskip}}}}

\newcommand{\addtocont}{\emptycont}

\newcommand{\fullcont}{\addtocontents{toc}{%
\noindent\rm\protect\makebox[0em][r]{\thechapterump.~}%
\protect\makebox[22em][l]{\bf \@shortauthor}\inform}
\addcontentsline{toc}{subsection}{%
\protect\rule{26pt}{0pt}\@title }}


\newcounter{ump@engcontensnum}
\newcommand{\umpenglishtableofcontens}{%
\thispagestyle{empty}
\selectlanguage{english}\centerline{\bf\Large CONTENTS}\par
\vspace{0.5em}
\setcounter{ump@engcontensnum}{\value{ump@engcontens}}
\setcounter{ump@engcontens}{0}
\loop%
\ifnum\c@ump@engcontens<\c@ump@engcontensnum%
\refstepcounter{ump@engcontens}%
\csname engcontensline\roman{ump@engcontens}\endcsname
%\parbox[b]{0.92\textwidth}{\hangindent=2em\noindent\makebox[0em][r]{\theump@engcontens.~}\engcontensline\dotfill}\hfill%
%\vspace{1\umpcontensparskip}\pageref{firstpage\theump@engcontens}
\par%
\repeat
}

\newcounter{expert@paper}
\newcommand{\bg@expert@paper}{\setcounter{expert@paper}{-\value{page}}%
                              \addtocounter{expert@paper}{1}}
\newcommand{\vw@expert@paper}{\addtocounter{umpchapter}{1}%
                              \ref{lastpage\theumpchapter}%
                              \addtocounter{umpchapter}{-1}}
\newcommand{\ed@expert@paper}{\addtocounter{expert@paper}{\value{page}}%
                              \addtocounter{expert@paper}{-1}%
                              \refstepcounter{expert@paper}%
                              \label{lastpage\theumpchapter}}



\renewcommand{\makeexpert}{%
{\newpage\selectlanguage{ukrainian}%
\thispagestyle{empty}%
\addtocounter{page}{-1}
{\selectlanguage{ukrainian}
Ця сторінка тільки для перевірки інформації про статтю обсягом \vw@expert@paper{}~c.,
які слідують далі.\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
УДК
наприклад,\par
{\noindent 512.547.25}}}\par
{\noindent \bf \@udk}\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Імена авторів,
наприклад,\par
{\noindent
С.~Д.~Берман, П.~М.~Гудивок, А.~В.~Ройтер}}}\par
{\noindent \bf \@authors}\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Заклад,
наприклад,\par
{\noindent\normalfont ДВНЗ <<Ужгородський національний  університет>>, Інститут  математики НАН України}}}
\par\noindent\setcounter{author@chapter}{\value{umpchapter}}%
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\csname institution@\roman{author@chapter}@\roman{author@current}\endcsname\ifnum\c@author@current<\c@author@number, \fi
\repeat

\noindent\fbox{\parbox{0.98\textwidth}{\small
Посада,
наприклад,\par
{\noindent\normalfont доцент кафедри алгебри, старший науковий співробітник}}}
\par\noindent\setcounter{author@chapter}{\value{umpchapter}}%
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\csname pos@\roman{author@chapter}@\roman{author@current}\endcsname\ifnum\c@author@current<\c@author@number, \fi
\repeat

\noindent\fbox{\parbox{0.98\textwidth}{\small
Академічне звання,
наприклад,\par
{\noindent\normalfont доктор фізико-математичних наук}}}
\par\noindent\setcounter{author@chapter}{\value{umpchapter}}%
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\csname academ@\roman{author@chapter}@\roman{author@current}\endcsname\ifnum\c@author@current<\c@author@number,\\\fi
\repeat

\noindent\fbox{\parbox{0.98\textwidth}{\small
Електронна адреса,
наприклад,\par
{\noindent\normalfont \texttt{bermansd@ukr.net}, \texttt{gudivokpm@gmail.com}, \texttt{roiterav@imath.kiev.ua}}}}
\par\noindent\setcounter{author@chapter}{\value{umpchapter}}%
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\csname mail@\roman{author@chapter}@\roman{author@current}\endcsname\ifnum\c@author@current<\c@author@number, \fi
\repeat
\par

\noindent\fbox{\parbox{0.98\textwidth}{\small
Відкритий ідентифікатор дослідника ORCID,
наприклад,\par
{\noindent\normalfont \texttt{0000-1111-2222-3333}}}}
\par\noindent\setcounter{author@chapter}{\value{umpchapter}}%
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\csname orcid@\roman{author@chapter}@\roman{author@current}\endcsname\ifnum\c@author@current<\c@author@number, \fi
\repeat


\noindent\fbox{\parbox{0.98\textwidth}{\small
Імена авторів для змісту,
наприклад,\par
Берман~С.~Д., Гудивок~П.~М., Ройтер~А.~В.}}\par
\noindent\@shortauthor\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Імена авторів для колонтитулів,
наприклад,\par
С.~Д.~БЕРМАН, П.~М.~ГУДИВОК, А.~В.~РОЙТЕР}}\par
\noindent\@capitalauthor\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Імена авторів англійською мовою для змісту,
наприклад,\par
Berman~S.~D., Gudivok~P.~M., Roiter~A.~V.}}\par
\noindent\@authoreng\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Назва статті для змісту,
наприклад,\par
Зображення скінченних груп та матричні задачі}}\par
\noindent\@title\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Назва статті для колонтитулів,
наприклад,\par
ЗОБРАЖЕННЯ СКІНЧЕННИХ ГРУП \ldots}}\par
\noindent\@shorttitle\par
\noindent\fbox{\parbox{0.98\textwidth}{\small
Назва статті,
наприклад,\par
ЗОБРАЖЕННЯ СКІНЧЕННИХ ГРУП ТА МАТРИЧНІ ЗАДАЧІ}}\par
\begin{flushleft}
{\bf \noindent
\righthyphenmin=15
\@capitaltitle}\par
\end{flushleft}
\noindent\fbox{\parbox{0.98\textwidth}{\small
Назва статті англійською мовою для змісту,
наприклад,\par
Representations of finite groups and matrix tasks}}\par
\noindent\@titleeng\par
%\noindent\fbox{\parbox{0.98\textwidth}{\small
%Назва статті англійською мовою,
%наприклад,\par
%REPRESENTATIONS OF FINITE GROUPS AND MATRIX TASKS}}\par
%\begin{flushleft}
%{\bf \noindent
%\righthyphenmin=15
%\@capitaltitleeng}\par
%\end{flushleft}
\newpage%
}}}


\def\l@current{\csname l@\languagename\endcsname}
\newcommand\ump@l[3]{%
   \ifnum\l@current=\l@english   #1\fi%
   \ifnum\l@current=\l@ukrainian #2\fi%
   \ifnum\l@current=\l@russian   #3\fi}

\newcommand\my@message[1]{{\LARGE\bf ?#1? }
\PackageWarning{ump-paper}{ #1 et page \thepage}}

\def\@receivedword{\bf No word}

\newcommand\title@generator{%
\gdef\l@currenttitle{\csname l@\languagename\endcsname}%
\ifnum \c@umpchapter<1\relax
\else\ump@received\fi
   \ifnum\l@currenttitle=\l@english
   \gdef\@receivedword{\selectlanguage{english}Recived}\fi%
   \ifnum\l@currenttitle=\l@ukrainian
   \gdef\@receivedword{\selectlanguage{ukrainian}Одержано}\fi%
   \ifnum\l@currenttitle=\l@russian
   \gdef\@receivedword{\selectlanguage{russian}Получено}\fi%
\ifx\@titlephoto\@empty\gdef\@titlephoto{\my@message{TitlePhoto not given}}\fi
\ifx\@udk\@empty\gdef\@udk{\my@message{Udk not given}}\fi
\ifx\@umpdoi\@empty\gdef\@umpdoi{\my@message{UmpDOI not given}}\fi
\ifx\@title\@empty\gdef\@title{\my@message{Title not given}}\fi
\ifx\@authors\@empty\gdef\@authors{\my@message{Author not given}}\fi
\ifx\@orcid\@empty\gdef\@orcid{\my@message{ORCID not given}}\fi
\ifx\@shorttitle\@empty\gdef\@shorttitle{\my@message{Shorttitle not given}}\fi
\ifx\@capitaltitle\@empty\gdef\@capitaltitle{\capital@title}\fi
\ifx\@capitaltitleeng\@empty\gdef\@capitaltitleeng{\capital@titleeng}\fi
\ifx\@titleeng\@empty\gdef\@titleeng{\my@message{Titleeng not given}}\fi
\ifx\@shortauthor\@empty\gdef\@shortauthor{\my@message{Shortauthor not given}}\fi
\ifx\@capitalauthor\@empty\gdef\@capitalauthor{\my@message{Capitalauthor not given}}\fi
\ifx\@authoreng\@empty\gdef\@authoreng{\my@message{Authoreng not given}}\fi
\makeump@expert%
}

\newcommand\makesmalltitle{%
\title@generator%
\newpage\normalfont\normalsize
\bg@expert@paper%
\rule{0pt}{10pt}\par
\begin{center}
\@titlephoto\\
\end{center}
\refstepcounter{ump@eng@contens}
\refstepcounter{umpchapter}
%\refstepcounter{chapterump}
\label{firstpage\theumpchapter}
\addtocont
\markboth{\@capitalauthor}{\@shorttitle}
%\setcounter{author@chapter}{\value{umpchapter}}
%\addtocounter{author@chapter}{-1}
%\setcounter{author@current}{0}
%\loop%
%\ifnum\c@author@current<\c@author@number%
%\refstepcounter{author@current}%
%\gdef\pos@ion{\hfuzz\csname pos@\roman{author@chapter}@\roman{author@current}\endcsname}
%\csname author@\roman{author@chapter}@\roman{author@current}\endcsname%
% (\csname institution@\roman{author@chapter}@\roman{author@current}\endcsname)%
%\par
%\ifnum\c@author@current<\c@author@number\medskip\fi
%\repeat
\bigskip
\begin{center}
{\bf \noindent
\righthyphenmin=15
\ump@l{\@capitaltitleeng}
{\@capitaltitle}{\@capitaltitle}
}\bigskip\par
\end{center}
\righthyphenmin=2
\normalfont\normalsize\par
}

\newcommand\makesmallauthors{%
\medskip\par%
\begin{flushleft}
\addtocounter{author@chapter}{-1}%
\setcounter{author@current}{0}%
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
{\bf \csname author@\roman{author@chapter}@\roman{author@current}\endcsname}
(\csname institution@\roman{author@chapter}@\roman{author@current}\endcsname)\ifnum\c@author@current<\c@author@number\par \fi
\repeat
\end{flushleft}\medskip\par
\title@clear
}

\renewcommand\maketitle{%
\title@generator%
\newpage\renewcommand\@evenfoot\@evenchapterfoot%
\addvspace{20pt}\normalfont\normalsize
\bg@expert@paper%
\refstepcounter{ump@eng@contens}
\refstepcounter{umpchapter}
\refstepcounter{chapterump}
\begin{flushleft}
\label{firstpage\theumpchapter}
\addtocont
\markboth{\@capitalauthor}{\@shorttitle}
\noindent
\righthyphenmin=15\ump@l{UDC}{УДК}{УДК} \@udk
\par
\righthyphenmin=15\ump@l{DOI}{DOI}{DOI} \texttt{https://doi.org/\@umpdoi.\@umpyear.\@umpnumber(\@umpsubnumber).\pageref{firstpage\theumpchapter}-\pageref{lastpage\theumpchapter}}
\bigskip\par
{\noindent \bf \n@authors}\par\medskip
{\footnotesize
\setcounter{author@chapter}{\value{umpchapter}}
\addtocounter{author@chapter}{-1}
\setcounter{author@current}{0}
\loop%
\ifnum\c@author@current<\c@author@number%
\refstepcounter{author@current}%
\gdef\pos@ion{\hfuzz\csname pos@\roman{author@chapter}@\roman{author@current}\endcsname}
\ifnum\c@author@number>1 \textsuperscript{\theauthor@current} \fi%
\csname institution@\roman{author@chapter}@\roman{author@current}\endcsname%
\ifcsname pos@\roman{author@chapter}@\roman{author@current}\endcsname,\par\fi% Реакція на пусту посаду
\csname pos@\roman{author@chapter}@\roman{author@current}\endcsname%
\ifcsname academ@\roman{author@chapter}@\roman{author@current}\endcsname,\par\fi% Реакція на пусте звання
\csname academ@\roman{author@chapter}@\roman{author@current}\endcsname\par
\csname mail@\roman{author@chapter}@\roman{author@current}\endcsname\par
ORCID:  \texttt{https://orcid.org/\csname orcid@\roman{author@chapter}@\roman{author@current}\endcsname}\par
\ifnum\c@author@current<\c@author@number\medskip\fi
\repeat
}
\end{flushleft}
\bigskip
\begin{center}
{\bf \noindent
\righthyphenmin=15
\ump@l{\@capitaltitleeng}
{\@capitaltitle}{\@capitaltitle}
}\par
\end{center}
\righthyphenmin=2
\normalfont\normalsize\bigskip\par
\title@clear
}

% Центроване вирівнювання комірок в таблиці
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}% центрування по вертикалі
\newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}% центрування по горизонталі та вертикалі

\newcommand{\smallindent}{\hangindent=0.5cm \hangafter=-1 \noindent}
\newcommand\title@clear{%
\gdef\umpmaketitle{%
\medskip\noindent\ump@l{{\bf \author@eng} \title@eng.}
{{\bf \author@ua} \title@ua.}
{{\bf \author@ua} \title@ua.}
\par\medskip
}%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Bortosh
\gdef\@udk{}
\gdef\@title{}
\gdef\@shorttitle{}
\gdef\@capitaltitle{}
\gdef\@capitaltitleeng{}
\gdef\@titleeng{}
\clear@authors
\gdef\@orcid{}
\gdef\@shortauthor{}
\gdef\@capitalauthor{}
\gdef\@authoreng{}
}

 \renewenvironment{abstract}
     {\par\leftskip=0.04\textwidth\rightskip=0.04\textwidth\parindent\z@\footnotesize}
     {\par\bigskip}

\newtheorem{theorem}{\UMPpdfrenderNoArg\ump@l{Theorem}{Теорема}{Теорема}}
\@addtoreset{theorem}{umpchapter}
%\renewcommand\thetheorem
%{\ifnum \c@section>\z@ \thesection.\fi \@arabic\c@theorem}
\newtheorem{definition}{\UMPpdfrenderNoArg\ump@l{Definition}{Означення}{Определение}}
\@addtoreset{definition}{umpchapter}
\newtheorem{proposition}{\UMPpdfrenderNoArg\ump@l{Proposition}{Припущення}{Предположение}}
\@addtoreset{proposition}{umpchapter}
\newtheorem{statement}{\UMPpdfrenderNoArg\ump@l{Statement}{Твердження}{Утверждение}}
\@addtoreset{statement}{umpchapter}
\newtheorem{lemma}{\UMPpdfrenderNoArg\ump@l{Lemma}{Лема}{Лемма}}
\@addtoreset{lemma}{umpchapter}
\newtheorem{corollary}{\UMPpdfrenderNoArg\ump@l{Corollary}{Наслідок}{Следствие}}
\@addtoreset{corollary}{umpchapter}
\newtheorem{example}{\UMPpdfrenderNoArg\ump@l{Example}{Приклад}{Пример}}
\@addtoreset{example}{umpchapter}
\newtheorem{remark}{\UMPpdfrenderNoArg\ump@l{Remark}{Зауваження}{Замечание}}
\@addtoreset{remark}{umpchapter}


\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{3}
\@addtoreset{paragraph}{umpchapter}
\@addtoreset{subparagraph}{umpchapter}
\renewcommand\theparagraph{\@arabic\c@paragraph}
\renewcommand\thesubparagraph{\theparagraph.\@arabic\c@subparagraph}
%\renewcommand\paragraph{\@startsection{paragraph}{4}{\parindent}%
%                                    {1.1ex \@plus.2ex \@minus.1ex}%
%                                    {-1em}%
%                                    {\normalfont\normalsize\bfseries}}
%\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
%                                       {1.1ex \@plus.2ex \@minus.1ex}%
%                                       {-1em}%
%                                      {\normalfont\normalsize\bfseries}}
\def\paragraph#1{{\refstepcounter{paragraph}\normalfont\normalsize\bfseries\theparagraph. #1. }}%
\def\subparagraph#1{{\refstepcounter{subparagraph}\normalfont\normalsize\bfseries\thesubparagraph. #1. }}%
%\def{\paragraph*}#1{\par{\refstepcounter{paragraph}\normalfont\normalsize\bfseries\theparagraph. #1. }}%
%\def{\subparagraph*}#1{\par{\refstepcounter{subparagraph}\normalfont\normalsize\bfseries\thesubparagraph. #1. }}%


\renewcommand{\proof}{\indent%
\textit{\textbf{\proofname. }}\ignorespaces}

\newcommand{\keywords}{\par\vspace{2mm}
\textbf{\ump@l{Keywords}{Ключові слова}{Ключевые слова}:} \ignorespaces}

% \@addtoreset{section}{umpchapter}
% \renewcommand\section[1]{\addvspace{0.5em}\refstepcounter{section}{\bf \thesection. #1.}}
% \renewcommand\subsection[1]{\addvspace{0.5em}\refstepcounter{subsection}{\bf \thesubsection. #1.}}
% \renewcommand\thesubsection{\thesection.\arabic{subsection}}



\renewcommand{\labelenumi}{\theenumi{\rm)}}
\renewcommand{\@biblabel}[1]{#1.}
\def\thebibliography#1{
\smallskip{\bf\ump@l{References}{Список використаної літератури}{Список использованной литературы}}\vspace{-0.2cm}\par
\footnotesize \list
  {\@biblabel{\UMPpdfrender{\arabic{enumiv}}}}{\settowidth\labelwidth{\@biblabel{#1}}%
    \topsep=0pt
    \parsep=0pt
    \partopsep=10pt
    \itemsep=0pt
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \def\theenumiv{\arabic{enumiv}}}%
    \def\newblock{\hskip .11em plus.33em minus.07em}%
    \sloppy\clubpenalty4000\widowpenalty4000
    \sfcode`\.=1000\relax}
    \def\@chapapp{}

\newcommand\ump@received{%
\begin{flushright}
\footnotesize\@receivedword{} \@received%
\ed@expert@paper
\end{flushright}%
}
\newcommand{\umplastreceived}
{\addtocounter{umpchapter}{-1}%
\refstepcounter{umpchapter}%
\label{LastChapter}%
\ump@received\refstepcounter{umpchapter}}

\newcommand{\@short}[1]{\centerline{\bf #1}}
\newcommand{\short}
{\selectlanguage{ukrainian}
\addtocontents{toc}{\protect\@short{Короткі повідомлення}}
}

\newcommand{\umpsuperchapter}[2]
{\foreignlanguage{ukrainian}{
\refstepcounter{ump@eng@contens}
\refstepcounter{umpsuperchapter}
\gdef\@evenchapterfoot{\UMPpdfrender{\selectlanguage{ukrainian}\footnotesize #1\hfill}}
%\gdef\@evenfoot\@evenchapterfoot
\addtocontents{toc}{
\protect\refstepcounter{ump@engcontens}
\global\def\string\engcontensline\roman{ump@eng@contens}{\@short{#2}\protect\medskip}%
\protect\@short{#1}}}
}

%\ifx\pdfoutput\undefined % We're not running pdftex
%\RequirePackage[hypertex]{hyperref}
%\else
%\usepackage{pslatex}
%\RequirePackage[colorlinks,hyperindex,plainpages=false]{hyperref}
%\RequirePackage{hyperref}
%\def\pdfBorderAttrs{/Border [0 0 0] } % No border arround Links
%\fi

 \let\thm@indent\indent
 \thm@notefont{\normalfont}
 \renewcommand\thm@space@setup{%
   \thm@preskip=0.20cm plus 0.05cm minus 0.05cm
   \thm@postskip=\thm@preskip}

\def\@contnfont{\normalfont}
\def\@conttfont{\normalfont}
\def\ump@captionname{}
\def\ump@captionbreak{}
\newlength\ump@cappreskip
\newlength\ump@cappostskip
\ump@cappreskip=0.20cm plus 0.05cm minus 0.05cm
\ump@cappostskip=\ump@cappreskip
\def\fnum@figure{%
   \global\def\@contnfont{\normalfont}%
   \global\def\@conttfont{\normalfont}%
   \global\def\ump@captionbreak{. }%
   \global\def\ump@captionname{%
   \ump@l{Figure}{Рис.}{Рис.} \thefigure}%
   }
\def\fnum@table{%
   \global\def\@contnfont{\normalfont\itshape}%
   \global\def\@conttfont{\normalfont}%
   \global\def\ump@captionbreak{.\\}%
   \global\def\ump@captionname{\hfill%
   \ump@l{Table}{Таблиця}{Таблица} \thetable}%
   }
\def\ump@prepare#1{\refstepcounter{#1}{\csname fnum@#1\endcsname}}
\renewcommand{\caption}[1]{%
\UMPpdfrenderNoArg
\ump@prepare\@captype%
\vspace{\ump@cappreskip}%
\begin{center}
\@contnfont\ump@captionname%
\if!#1!\else{\protect\ump@captionbreak}\fi\@conttfont#1%
\end{center}%
\vspace{\ump@cappostskip}%
}


\newcommand{\umpreceivedword}[1]{\gdef\@receivedword{#1}}


\AtEndDocument{\ed@expert@paper}

\endinput
