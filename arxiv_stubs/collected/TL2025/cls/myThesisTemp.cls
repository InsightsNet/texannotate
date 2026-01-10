    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% READ ME! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % 안녕하세요?
    % 이 템플릿은 본교 일반대학원 측에서 공지한 작성방법을 바탕으로 제작되었습니다.
    % 관련 규정은 본 프로젝트에 있는 pdf 파일을 참조해주세욧(작성법_Organizing_and_Formating_Thesis_Dissertation.pdf).
    % 근데 다른 분들이 학위논문을 준비하시는 시점에는 본교에서 공식 latex 템플릿을 제공하게 될 수 있으니 확인해보시길 권합니당.
    
    % 유의! 이 프로젝트의 컴파일러는 pdfLaTex 2014(legacy)로 설정해주세요.
    % 유의! 이 템플릿은 석사학위 영문판을 기준으로 제작되었으니 다른 경우에는 일부를 수정해서 사용해주세요.
    %
    % 2022년 10월 18일, 김선호
    % REFERENCE: https://github.com/KUNPL/KUThesis
    
\NeedsTeXFormat{LaTeX2e}[1995/12/01]    
\ProvidesClass{myThesisTemp}

%%%%%%%%%%%%%%%%% 이 부분만 수정하시면 될 거에용 %%%%%%%%%%%%%%%%%
\newcommand{\@thesisCategory}{Master's Thesis}      % 박사학위의 경우: Doctoral Dissertation
\newcommand{\@thesis}{thesis}                       % 박사학위의 경우: dissertation
\newcommand{\@degree}{Master of Science}        % 박사학위의 경우: Doctor of Philosophy
\def\numbCommittee{3}                     % 박사학위의 경우: 5 (심사위원 수)

\newcommand{\@titleSize}{21pt} % 표지 제목 크기, 논문 표지, 속표지, 심사완료검인서 등에서 논문 제목이 길거나 부제가 포함되는 경우 등, 필요한 경우 활자의 크기, 자간, 장평, 굵기 등은 적절한 수준에서 조절 가능합니다.
\newcommand{\@maintextSize}{12pt} % 국문 학위논문은 명조체, 고딕체 혹은 이와 유사한 서체, 영문 학위논문은 Times New Roman, Calibri 혹은 이와 유사한 서체를 사용하여 작성하며, 본문의 크기는 10-12 포인트로 한다.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{ifthen}
\RequirePackage[strict]{changepage}
\RequirePackage{emptypage}
\RequirePackage{graphicx,xcolor}
\RequirePackage[toc,page]{appendix}
\RequirePackage{amsmath,amssymb,amsfonts,empheq,textcomp,bm}
\RequirePackage{float}
\RequirePackage{bbm,scalerel,bbold,dsfont,mathtools,cases}
\RequirePackage{algorithm,algorithmic}
\RequirePackage[pagewise]{lineno}
\RequirePackage{fix-cm}
\RequirePackage[cjk]{kotex}
\RequirePackage[nomessages]{fp}
\RequirePackage{fancyhdr}
\RequirePackage{pdfpages}
\RequirePackage{multirow}
\RequirePackage{changepage}   % for the adjustwidth environment
\RequirePackage{dblfloatfix} % https://stackoverflow.com/questions/53167913/how-to-place-the-figure-at-the-bottom-of-page-in-latex
\RequirePackage{subfiles,cite}

%% OPTION
\newif\if@isPdfdoc
\newif\if@isAsym
\newif\if@isBookbinding

\DeclareOption{pdfdoc}       {\@isPdfdoctrue}
\DeclareOption{asym}         {\@isAsymtrue}
\DeclareOption{bookbinding}     {\@isBookbindingtrue}

%% leqno,fleqn,openbib
\DeclareOption{leqno}  {\PassOptionsToClass{leqno}  {report}}
\DeclareOption{fleqn}  {\PassOptionsToClass{fleqn}  {report}}
\DeclareOption{openbib}{\PassOptionsToClass{openbib}{report}}

%% DEFUALT SETTING
\@isAsymfalse
\@isBookbindingfalse
\ProcessOptions

%% IMPORT the REPORT CLASS
\LoadClass[\@maintextSize,onecolumn,oneside]{report}

%% Table of Contents: Table of contents, List of figures, List of tables
\usepackage{tocbibind}
\usepackage[linktocpage=true]{hyperref}
\usepackage{titlesec}
\usepackage{apptools}
\usepackage{listings}
\lstset{
  basicstyle=\ttfamily,
  columns=fullflexible,
  frame=single,
  breaklines=true,
  postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
}

%% PAPERSIZE: 4x6 배판 - 188x257 mm2
\if@isAsym
  \usepackage[inner = 25mm ,       outer = 15mm,
                top = 30mm,       bottom = 30mm,
         paperwidth = 188mm, paperheight = 257mm]{geometry}
\else
  \usepackage[inner = 25mm ,       outer = 25mm,
                top = 30mm,       bottom = 30mm,
         paperwidth = 188mm, paperheight = 257mm]{geometry}
\fi

%% INDENTATION STYLE
\usepackage{indentfirst}
\setlength\parindent{0em}

%% LENGTH between FIGURE and CAPTION
\setlength{\abovecaptionskip}{10pt} % 캡션 위 거리
\setlength{\belowcaptionskip}{0pt}  % 캡션 아래 거리
%% LINE SPACE in CAPTION
\RequirePackage{caption,setspace}
\captionsetup[table]{font={stretch=\@captionLineSpacing}}
\captionsetup[figure]{font={stretch=\@captionLineSpacing}}

%% BIBLIOGRPHY
\usepackage[square,numbers]{natbib}
\bibliographystyle{ieeetr}

%% for PDF FILE
\if@isPdfdoc
  \RequirePackage[unicode,%
       pageanchor=false,%
           pdftex=true,%
        bookmarks=true,%
       colorlinks=true%
    ]{hyperref}
\else
\fi

%%%%%%%%%%%%%%%%%%%%%%%% PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%
%% TITLE
\renewcommand{\title}[2] {
  \newcommand{\@titleEng}{#1}
  \newcommand{\@titleKor}{#2}
}
\@onlypreamble{\title}

%% AUTHOR
\renewcommand{\author}[4][english]{%
    \ifthenelse{\equal{#1}{english}}
        {\newcommand{\@authorEngFN}{#2}
         \newcommand{\@authorEngGN}{#3}
         \ifthenelse{\equal{#4}{}}{
           \newcommand{\@authorEng}{#3\ #2}
         }{
           \newcommand{\@authorEng}{#3\ #4\ #2}
         }}{}%
    \ifthenelse{\equal{#1}{korean}}
        {\newcommand{\@authorKor}{#2}
         }{}%
}
\@onlypreamble{\author}

%% ADVISOR(지도교수)
\newcommand{\advisor}[2]{%
  \newcommand{\@advisorMajorKor}{#1}  % 한글이름 저장
  \newcommand{\@advisorMajorEng}{#2}  % 영문이름 저장
}
\@onlypreamble{\advisor}

%% DEPARTMENT
\newcommand{\department}[2] {%
  \newcommand{\@deptEng}{#1}
  \newcommand{\@deptKor}{#2}
}
\@onlypreamble{\department}

%% REFEREE(심사위원): 석사과정 3인, 박사과정 5인
\newcommand{\committee}[2][1] {%
    \ifthenelse{\equal{#1}{1}}{\newcommand{\@committeeChair} {#2}} {}%
    \ifthenelse{\equal{#1}{2}}{\newcommand{\@committeeSecond}{#2}} {}%
    \ifthenelse{\equal{#1}{3}}{\newcommand{\@committeeThird} {#2}} {}%
    \ifthenelse{\equal{#1}{4}}{\newcommand{\@committeeFourth}{#2}} {}%
    \ifthenelse{\equal{#1}{5}}{\newcommand{\@committeeFifth} {#2}} {}%
}
\@onlypreamble{\committee}

%% DATE
\newcommand{\graduateDate}[2]{
  \newcommand{\@graduateYear}{#1}
  \newcommand{\@graduateMonth}{#2}
}
\@onlypreamble{\graduateDate}

%% SUBMISSION DATE
\newcommand{\submitDate}[2]{
  \newcommand{\@submitYear}{#1}
  \newcommand{\@submitMonth}{#2}
}
\@onlypreamble{\submitDate}

% APPROVAL DATE(인준일자)
\newcommand{\approvalDate}[3]{
  \newcommand{\@approvalYear}{#1}
  \newcommand{\@approvalMonth}{#2}
}
\@onlypreamble{\approvalDate}

%%%%%%%%%%%%%%%%%%%%%%%% PREAMBLE: 줄간격 %%%%%%%%%%%%%%%%%%%%%%%%

% @command abstractLineSpacing 초록 줄간격
\newcommand{\abstractLineSpacing}[1]{
  \FPeval{\@abstractLineRatio}{#1/100.0/1.236} 
}
\@onlypreamble{\abstractLineSpacing}

% @command krAbstractLineSpacing 국문초록 줄간격
\newcommand{\krAbstractLineSpacing}[1]{
  \FPeval{\@krAbstractLineRatio}{#1/100.0/1.236} 
}
\@onlypreamble{\krAbstractLineSpacing}

% @command TOCLineSpacing 목차 줄간격
\newcommand{\TOCLineSpacing}[1]{
  \FPeval{\@TOCLineRatio}{#1/100.0/1.236} 
}
\@onlypreamble{\TOCLineSpacing}

% @command contentLineSpacing 본문 줄간격
\newcommand{\contentLineSpacing}[1]{
  \FPeval{\@lineRatio}{#1/100.0/1.236} 
}
\@onlypreamble{\contentLineSpacing}

% chapter 제목 줄간격
\titleformat{\chapter}[display]{\normalfont\huge\bfseries}{\chaptertitlename\ \thechapter}{0pt}{\setstretch{1.3}\Huge}

% @command acknowledgementLineSpacing 감사의글 줄간격
\newcommand{\acknowledgementLineSpacing}[1]{
  \FPeval{\@acknowledgementLineRatio}{#1/100.0/1.236} 
}
\@onlypreamble{\acknowledgementLineSpacing}

% @command captionLineSpacing 캡션 줄간격
\newcommand{\captionLineSpacing}[1]{
  \FPeval{\@captionLineSpacing}{#1/100.0/1.236} 
}
\@onlypreamble{\captionLineSpacing}

%%%%%%%%%%%%%%%%%%%%%%%% COMMEND %%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@dateUSenglish}[2]{%  % 미국식 날짜 표기
    \newcommand{\@year}{#1}%
    \newcommand{\@month}{#2}%
    \ifcase\@month \or
        January \or February \or March \or April \or May \or June \or
        July \or August \or September \or October \or November \or December \fi
    \@year
}

\newcommand{\addContents}[1]{
  \setlength\parindent{5mm}
  \renewcommand{\baselinestretch}{\@lineRatio}
  \selectfont{\input{#1}}
  \setlength\parindent{0mm}
}

%%%%%%%%%%%%%%%%%%%%%%%% STRUCTURE %%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{dummy}
\AtBeginDocument{%                         % \begin{document}와 함께 실행
  \newgeometry{       left = 30mm,
                     right = 30mm,
                       top = 30mm,
                    bottom = 30mm}        % 여백 다른 페이지용 여백
  \makefrontcover                          % 앞표지 생성
  \maketitle                               % 속표지 생성
  \newgeometry{       left = 40mm,
                       right = 30mm,
                         top = 40mm,
                      bottom = 30mm}        % 여백 다른 페이지용 여백
  \makeapproval                          % 제출승인서, 심사완료검인 생성
  \restoregeometry                         % 여백 되돌림
  \refstepcounter{dummy}
  
  \pagenumbering{roman}                   % 페이지 번호는 초록부터 본문 전까지 작은 로마 숫자(Roman numerals, e.g., i, ii, iii, iv...)를 사용
  \setcounter{page}{1}                    
  \makeabstract                            % 초록
  
  \makededicationpage                   % 감사의 글
  
  \makepreface                          % 서문
  
  \makeacknowledgement                    % 사사
  
  \makecontents                         % 목차

  \pagenumbering{arabic}                % 본문의 서론부터 아라비아 숫자(Arabic numbers, e.g., 1, 2, 3...)를 사용
  \setcounter{page}{1}

  \renewcommand{\arraystretch}{1.3}
}

\AtEndDocument{                             % \end{document}와 함께 실행
  \bibliography{library.bib}
  \newpage
  \appendix
  \input{appendices.tex}
  \refstepcounter{dummy}
}

%%%%%%%%%%%%%%%%%%%%%%%% 세부 양식 %%%%%%%%%%%%%%%%%%%%%%%%

%%
%% 빈 페이지 생성(제본용의 경우)
%%
\newcommand{\emptypage}{
  \newpage
  \thispagestyle{empty}
  \hbox{ }
  \newpage
}

%%
%% 앞표지 생성
%%
  \newcommand{\makefrontcover}{%
      \newpage
      \renewcommand{\baselinestretch}{1.3}%
      \thispagestyle{empty}
      \begin{minipage}[t][12mm][t]{\textwidth} % [position][height][inner-pos]{width}
          \begin{center}
              \fontsize{16pt}{0pt}\selectfont\bf{\@thesisCategory}
          \end{center}
      \end{minipage}
      \\[30mm]
      %\hspace*{-15mm}
      \begin{minipage}[t][50mm][t]{\textwidth}
          \begin{center}
              \fontsize{\@titleSize}{28pt}\selectfont{\bf \@titleEng}
          \end{center}
      \end{minipage}\vfill
      \begin{minipage}[b][70mm][b]{\textwidth}
          \begin{center}
              \fontsize{16pt}{5pt}\selectfont{\bf \@authorEng}
              \\[5mm]
              \fontsize{16pt}{16pt}\selectfont{\bf Department of{\@deptEng}}
              \\[15mm]
              \fontsize{18pt}{0pt}\selectfont{\bf Graduate School}
              \\[5mm]
              \fontsize{18pt}{0pt}\selectfont{\bf Korea University}
              \\[10mm]
              \fontsize{14pt}{0pt}\selectfont{\bf
              \@dateUSenglish{\@graduateYear}{\@graduateMonth}}
          \end{center}
      \end{minipage}
      \if@isBookbinding
        \emptypage
      \fi
  }

%%
%% 속표지 생성
%%
% \newcommand{\signedScan}[1]{%
%   \newcommand{\@sigFile}{#1}
% }

\renewcommand{\maketitle}{%
    % \@ifundefined{@sigFile}
    {
        \newpage
        \renewcommand{\baselinestretch}{1.3}%
        \thispagestyle{empty}
        %\hspace*{-15mm}
        \begin{minipage}[t][16pt][t]{\textwidth}
          \begin{center}
            \fontsize{\@titleSize}{28pt}\selectfont{\@titleEng}
            \\[10mm]
            \fontsize{16pt}{16pt}\selectfont{by}
            \\[5mm]
            \fontsize{16pt}{16pt}\selectfont{\@authorEng}
            \\[5mm]
            \underline{\hspace{60mm}}
            \\[15mm]
            \fontsize{16pt}{16pt}\selectfont{under the supervision of Professor \@advisorMajorEng}
            \\[20mm]
            \fontsize{16pt}{16pt}\selectfont{A {\@thesis} submitted in partial fulfillment of the requirements for the degree of {\@degree}}
            \\[20mm]
            \fontsize{16pt}{16pt}\selectfont{Department of\@deptEng}
            \\[15mm]
            \fontsize{18pt}{0pt}\selectfont{Graduate School}
            \\[5mm]
            \fontsize{18pt}{0pt}\selectfont{Korea University}
            \\[10mm]
            \fontsize{14pt}{0pt}\selectfont{
            \@dateUSenglish{\@submitYear}{\@submitMonth}}        
          \end{center}
        \end{minipage}
    }{
        % \includepdf{\@sigFile}
    }
}

% %%
%% 학위논문 심사완료 검인서 생성
%%
% \newcommand{\approvalScan}[1]{%
%   \newcommand{\@scanFile}{#1}
% }

\def\PhDnumb{5}

\newcommand{\makeapproval}{%
%  \@ifundefined{@scanFile}
  {
    \newpage
    \thispagestyle{empty}
    \renewcommand{\baselinestretch}{1.3}
    \begin{minipage}[t][20mm][t]{\textwidth}
      \begin{center}
        \fontsize{16pt}{20pt}\selectfont{
            The {\@thesis} of {\@authorEng} has been approved\\
            by the {\@thesis} committee in partial fulfillment of\\
            the requirements for the degree of\\
            {\@degree}}
        \\[20mm]
        \fontsize{14pt}{0pt}\selectfont{\@dateUSenglish{\@approvalYear}{\@approvalMonth}}
        \\[30mm]
        \underline{\hspace{85mm}}
        \\[0mm]
        \fontsize{14pt}{16pt}\selectfont{Committee Chair: {\@committeeChair}}
        \\[10mm]
        \underline{\hspace{85mm}}
        \\[0mm]
        \fontsize{14pt}{16pt}\selectfont{Committee Member: {\@committeeSecond}}
        \\[10mm]        
        \underline{\hspace{85mm}}
        \\[0mm]
        \fontsize{14pt}{16pt}\selectfont{Committee Member: {\@committeeThird}}
        \ifx\numbCommittee\PhDnumb
            \\[10mm]        
            \underline{\hspace{85mm}}
            \\[0mm]
            \fontsize{14pt}{16pt}\selectfont{Committee Member: {\@committeeFourth}}
            \\[10mm]        
            \underline{\hspace{85mm}}
            \\[0mm]
            \fontsize{14pt}{16pt}\selectfont{Committee Member: {\@committeeFifth}}
        \fi
      \end{center}
    \end{minipage}
  }{
%    \includepdf{\@scanFile}
  }
}

%%
%% 영어 초록 페이지 생성
%%
\newcommand{\makeenabstract}{%
  \newpage
  %\thispagestyle{empty}
  \addcontentsline{toc}{chapter}{Abstract}
  %\pagenumbering{gobble}
  %\vspace*{\fill}
  \begin{center}
    \fontsize{16pt}{20pt}\selectfont{\@titleEng}
    \\[2em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{by \@authorEng}
    \\[1em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{Department of\@deptEng}
    \\[1em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{under the supervision of Professor {\@advisorMajorEng}}
    \\[3em]
    \fontsize{16pt}{16pt}\selectfont{\bf Abstract}
    \\[1em]
  \end{center}

  \setlength\parindent{5mm}
  \renewcommand{\baselinestretch}{\@abstractLineRatio}\selectfont
  \fontsize{\@maintextSize}{14pt}\selectfont{\indent\input{beginnings/enabstract}}
  \setlength\parindent{0mm}
  \vspace*{\fill}
}

%%
%% 한국어 초록 페이지 생성
%%
\newcommand{\makekrabstract}{%
  \newpage
  %\thispagestyle{empty}
  %\addcontentsline{toc}{chapter}{국문 초록}
  %\pagenumbering{gobble}
  %\vspace*{\fill}
  \begin{center}
    \fontsize{16pt}{20pt}\selectfont{\@titleKor}
    \\[2em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{\@authorKor}
    \\[1em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{\@deptKor}
    \\[1em]
    \fontsize{\@maintextSize}{\@maintextSize}\selectfont{지도교수: {\@advisorMajorKor}}
    \\[3em]
    \fontsize{16pt}{16pt}\selectfont{\bf 초록}
    \\[1em]
  \end{center}

  \setlength\parindent{5mm}
  \renewcommand{\baselinestretch}{\@abstractLineRatio}\selectfont
  \fontsize{\@maintextSize}{14pt}\selectfont{\indent\input{beginnings/krabstract}}
  \setlength\parindent{0mm}
  \vspace*{\fill}
}

%%
%% 초록 페이지 생성
%%
\newcommand{\makeabstract}{%
    \makeenabstract
    \makekrabstract
}

%%
%% 감사의 글 페이지 생성
%%
% \newcommand{\makededicationpage}{
%     \newpage
%     %\thispagestyle{empty}
%     \vspace*{\fill}
%     \setlength\parindent{5mm}
%     \renewcommand{\baselinestretch}{\@abstractLineRatio}\selectfont
%     \begin{center}
%         \fontsize{\@maintextSize}{14pt}\selectfont{\indent\input{beginnings/dedicationpage}}
%     \end{center}
%     \setlength\parindent{0mm}
%     \vspace*{\fill}
% }

%%
%% 서문 생성
%%
\newcommand{\makepreface}{
  \newpage
  %\thispagestyle{empty}
  \addcontentsline{toc}{chapter}{Preface}
  %\pagenumbering{gobble}
  %\vspace*{\fill}
  \begin{center}
    \fontsize{16pt}{16pt}\selectfont{\bf Preface}
    \\[2em]
  \end{center}

  \setlength\parindent{5mm}
  \renewcommand{\baselinestretch}{\@abstractLineRatio}\selectfont
  \fontsize{\@maintextSize}{14pt}\selectfont{\indent\input{beginnings/preface}}
  \setlength\parindent{0mm}
  \vspace*{\fill}   
}

%%
%% 사사 생성
%%
\newcommand{\makeacknowledgement}{%
  \newpage
  \addcontentsline{toc}{chapter}{Acknowledgement}
  \begin{center}
      \fontsize{16pt}{16pt}\selectfont{\bf Acknowledgement}
  \end{center}
  \vspace{5mm}

  \setlength\parindent{5mm}
  \renewcommand{\baselinestretch}{\@acknowledgementLineRatio}\selectfont
  \fontsize{11pt}{12pt}\selectfont{\indent\input{beginnings/acknowledgement}}
  \setlength\parindent{0mm}
}  

%%
%% 목차 일괄 생성
%%
\renewcommand{\bibname}{Bibliography}
\newcommand{\makecontents}{
  \renewcommand{\baselinestretch}{\@TOCLineRatio}\selectfont
  \tableofcontents
  \newpage\listoftables %% 표 목차
  \newpage\listoffigures %% 도식 목차
  \clearpage
  \if@isBookbinding
    \emptypage
  \fi  
}
