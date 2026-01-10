% -*- TeX:UTF-8 -*-
%% KAIST Thesis Template for LaTeX
%%
%% @version      0.5
%% @releasedate  Apr 28th, 2007
%%
%% @author       Chae, Seugbyung 채승병
%%               mailto:chess@kaist.ac.kr
%%
%% @requirements
%%    current distribution of TeXLive
%%      + ko.TeX
%%
%% Karnes Kim, converted to ko.TeX version.
%%    2008/10/21
%%
%% Seokwoo Choi, modified according to the 2008 thesis format
%%    2008/12/29
%%
%% Jong Mun Lee, modified according to the 2010 thesis format
%% 2010/11/25
%% 본 수정은 대학원학생회와 교무팀의 지원으로 진행되었습니다.
%%
%% Jin Hyun Ahn, modified according to the 2016 thesis format
%% 2016/04/08
%% 교무팀의 지원을 받아 송익호 교수님 연구실에서 수정하였습니다.
%% 2016/11/24
%% Min H. Kim, Professor at School of Computing, revised this template to fix several bugs, including the MS degree title in School of Computing, English date formats, etc.

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{kaist-ucs}%
[2008/10/21 v0.4 Standard KAIST Thesis document class, ko.TeX version]

%% 옵션 설정을 위한 boolean 변수선언
\newif\if@isDoctor
\newif\if@isKorean
\newif\if@isFinal
\newif\if@PDFdoc\@PDFdocfalse
\newif\if@dvips\@dvipsfalse

%% 새 옵션 모음 - doctor|master, korean|english, final|draft
\DeclareOption{doctor} {\@isDoctortrue}
\DeclareOption{master} {\@isDoctorfalse}
\DeclareOption{korean} {\@isKoreantrue}
\DeclareOption{english} {\@isKoreanfalse}
\DeclareOption{final}  {\@isFinaltrue}
\DeclareOption{draft}  {\@isFinalfalse}
\DeclareOption{pdfdoc} {\@PDFdoctrue}
\DeclareOption{dvips}  {\@dvipstrue}

%% leqno,fleqn,openbib 옵션은 그대로 report 클래스에 전달
\DeclareOption{leqno}  {\PassOptionsToClass{leqno}  {report}}
\DeclareOption{fleqn}  {\PassOptionsToClass{fleqn}  {report}}
\DeclareOption{openbib}{\PassOptionsToClass{openbib}{report}}

\ExecuteOptions{doctor,korean,final}         % doctor,korean,final이 기본값
\ProcessOptions

%% 10pt,a4paper,onecolumn,oneside 옵션으로 report 클래스 불러오기
\LoadClass[10pt,a4paper,onecolumn,oneside]{report}



%%들여쓰기
\usepackage{indentfirst}
\setlength\parindent{2.0em}

\RequirePackage{ifthen}       % 추가 패키지 설정

%%%% Hangul-ucs preamble.......
\RequirePackage[nonfrench]{dhucs}
%\RequirePackage[default]{dhucs-interword}
\RequirePackage{ifpdf}
\ifpdf
\def\@drivername{pdftex}
\else
\def\@drivername{dvipdfmx}
\fi
\if@dvips
\def\@drivername{dvips}
\fi

%\ifpdf
%  \input glyphtounicode\pdfgentounicode=1
%\fi

\RequirePackage[\@drivername]{graphicx,xcolor}

\usepackage{color}
\definecolor{cyan}{cmyk}{1,0,0,0}
\definecolor{darkgreen}{rgb}{0,0.5,0}
\definecolor{orange}{rgb}{1,0.5,0}
\definecolor{magenta}{cmyk}{0,1,0,0}
\definecolor{darkyellow}{cmyk}{0,0,0.75,0}
\definecolor{darkred}{rgb}{0.4,0,0}
\definecolor{darkgreen}{rgb}{0,0.25,0}
\definecolor{darkblue}{rgb}{0,0,0.55}
\definecolor{darkcyan}{cmyk}{0.75,0,0,0}
\definecolor{darkmagenta}{cmyk}{0,0.75,0,0}
\definecolor{darkyellow}{cmyk}{0,0,0.75,0}

\if@PDFdoc
\RequirePackage[unicode,%
\@drivername=true,%
bookmarks=true,%
colorlinks=true,%
linkcolor=darkred,      %red
anchorcolor=black,      %black
citecolor=darkgreen,        %green
filecolor=darkmagenta,      %magenta
menucolor=darkred,      %red
urlcolor=darkcyan,          %cyan
]{hyperref}
\else
\RequirePackage[unicode,%
\@drivername=true,%
bookmarks=false,%
colorlinks=false,%
colorlinks=true,    %remove square
linkcolor=darkred,      %red
anchorcolor=black,      %black
citecolor=darkgreen,        %green
filecolor=darkmagenta,      %magenta
menucolor=darkred,      %red
urlcolor=darkcyan,          %cyan
]{hyperref}
\fi


%% for compatability to HLaTeX
\let\gt\sffamily
\DeclareTextFontCommand{\textgt}{\gt}
%%%% end of Hangul-ucs preamble

\AtBeginDocument{%                           % \begin{document}와 함께 실행
	\checkparameters                        % 문서 변수가 올바른지 점검
	\if@isFinal                             % final 옵션이 지정되어 있으면
	\makefrontcover \maketitle         % 앞표지, 속표지 생성
	\makeapproval                      % 제출승인서, 심사완료검인 생성
	\else \fi }
\AtEndDocument{}                             % \end{document}와 함께 실행

%% 편집용지 설정
\usepackage[left=25.4mm,right=25.4mm,top=30mm,bottom=25.4mm,a4paper]{geometry}


%% 줄간격 설정
%\renewcommand{\baselinestretch}{1.3}
\linespread{1.3}

%% 본문이 영어로 되어있는지 한글로 되어있는지 설정
\newcommand{\@korean}{korean}
\newcommand{\@english}{english}
\newcommand{\@textlang}{}                    % 텍스트 기본언어 변수선언
\if@isKorean                                 % korean 옵션이 지정되어 있으면
\let\@textlang\@korean                  % 텍스트 기본언어는 한글
\else                                        % english 옵션이 지정되어 있으면
\let\@textlang\@english                 % 텍스트 기본언어는 영문
\fi

%% KAIST 공식 영문명칭
\newcommand{\@kaist}{Korea Advanced Institute of Science and Technology}

%% pagestyle
\def\ps@kaist{\let\@mkboth\@gobbletwo
	\let\@oddhead\@empty
	\def\@oddfoot{\reset@font\hfil--\ \thepage\ --
		\hfil}%
	\let\@evenhead\@empty\let\@evenfoot\@oddfoot
}

\pagestyle{kaist}

%%
%% 문서 정보 변수 정의
%%

% @command title 논문 제목
% @options [default: (none)]
% - korean: 한글제목 | english: 영문제목
\renewcommand{\title}[2][korean] {%
	\ifthenelse{\equal{#1}{korean}}%
	{\newcommand{\@titleKor}{#2}}{}%
	\ifthenelse{\equal{#1}{english}}%
	{\newcommand{\@titleEng}{#2}}{}%
}
\@onlypreamble{\title}

% @command author 저자 이름
% @param family_name, given_name 성, 이름을 구분해서 입력
% @options [default: (none)]
% - korean: 한글이름 | chinese: 한문이름 | english: 영문이름
\renewcommand{\author}[3][korean] {%
	\ifthenelse{\equal{#1}{korean}}
	{\newcommand{\@authorKorFN}{#2}
		\newcommand{\@authorKorGN}{#3}
		\newcommand{\@authorKor}{#2\ #3}}{}%
	\ifthenelse{\equal{#1}{korean2}}
	{\newcommand{\@authorKorHN}{#2}
		\newcommand{\@authorKorIN}{#3}
		\newcommand{\@authorKorCont}{#2#3}}{}%
	\ifthenelse{\equal{#1}{chinese}}
	{\newcommand{\@authorChnFN}{#2}
		\newcommand{\@authorChnGN}{#3}
		\newcommand{\@authorChn}{#2\ #3}}{}%
	\ifthenelse{\equal{#1}{english}}
	{\newcommand{\@authorEngFN}{#2}
		\newcommand{\@authorEngGN}{#3}
		\newcommand{\@authorEng}{#2, #3}}{}%
}

\@onlypreamble{\author}

% @command advisor 지도교수 이름 (복수가능)
% @options [default: major]
% - major: 주 지도교수  | coopr: 부 지도교수 (공동지도교수 경우)
\newcommand{\advisor}[4][major]{%
	\ifthenelse{\equal{#1}{major}} {%       % 주 지도교수이면
		\newcommand{\@advisorMajorKor}{#2} % 한글이름 저장
		\newcommand{\@advisorMajorEng}{#3} % 영문이름 저장
		% nosign을 명시하지 않으면 주 지도교수가 서명한 것으로 간주
		\ifthenelse{\equal{#4}{nosign}}{}{%
			\newcommand{\@advisorSigned}{\@advisorMajorEng}} }{}%
	\ifthenelse{\equal{#1}{major2}} {%       % 주 지도교수이면
		\newcommand{\@advisorMajorKorCont}{#2} % 한글이름 저장
		\newcommand{\@advisorMajorEngCont}{#3} % 영문이름 저장
		% nosign을 명시하지 않으면 주 지도교수가 서명한 것으로 간주
		\ifthenelse{\equal{#4}{nosign}}{}{%
			\newcommand{\@advisorSignedCont}{\@advisorMajorEngCont}} }{}%
	\ifthenelse{\equal{#1}{coopr}} {%       % 부 지도교수이면
		\newcommand{\@advisorCooprKor}{#2} % 한글이름 저장
		\newcommand{\@advisorCooprEng}{#3} % 영문이름 저장
		% signed를 명시해야 부 지도교수가 서명한 것으로 간주
		\ifthenelse{\equal{#4}{signed}}{%
			\newcommand{\@advisorSigned}{\@advisorCooprEng}}{} }{}%
	\ifthenelse{\equal{#1}{coopr2}} {%       % 부 지도교수이면
		\newcommand{\@advisorCooprKorCont}{#2} % 한글이름 저장
		\newcommand{\@advisorCooprEngCont}{#3} % 영문이름 저장
		% signed를 명시해야 부 지도교수가 서명한 것으로 간주
		\ifthenelse{\equal{#4}{signed}}{%
			\newcommand{\@advisorSignedCont}{\@advisorCooprEngCont}}{} }{}%            
}
\@onlypreamble{\advisor}

%% 제출승인서에 들어가는 교수님 정보 명령
\newcommand{\advisorinfo}[1]{\newcommand{\@advisorinfo}{#1}}

% @command department 
%
\newcommand{\@degreeCode}{}          % 학위 영문코드
\newcommand{\@degreeName}{}          % 학위명
\newcommand{\@degreeversion}{}       % 학과 표현 종류
\newcommand{\@parentDeptNameKor}{}      % 학과/전공 첫째줄
\newcommand{\@childDeptNameKor}{}       % 학과/전공 둘째줄
\newcommand{\@parentDeptNameEng}{}      % 학과/전공 첫째줄
\newcommand{\@childDeptNameEng}{}       % 학과/전공 둘째줄
\newcommand{\@affFullNameKor}{}      % 학과/전공 한글이름
\newcommand{\@affFullNameEng}{}      % 학과/전공 영문이름
\newcommand{\@parentAcademNameEng}{} % 학문 영문이름 첫째줄
\newcommand{\@childAcademNameEng}{} % 학문 영문이름 둘째줄
\newcommand{\@appFullAcademName}{}
\newcommand{\@degreeField}{}
\newcommand{\@degreePrefix}{\ifthenelse{\boolean{@isDoctor}}{D}{M}}
\newcommand{\department}[3] {%
	\ifthenelse{\equal{#1}{PH}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{물리학과}
		\renewcommand{\@childDeptNameEng}{Department of Physics}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Physics}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{MAS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{수리과학과}
		\renewcommand{\@childDeptNameEng}{Department of Mathematical Sciences}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Mathematical Sciences}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{CH}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{화학과}
		\renewcommand{\@childDeptNameEng}{Department of Chemistry}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Chemistry}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{NST}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{나노과학기술대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Nanoscience abd Technology}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Nanoscience and Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{BS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{생명과학과}
		\renewcommand{\@childDeptNameEng}{Department of Biological Sciences}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Biological Sciences}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{MSE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{의과학대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Medical Science and Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Medical Science and Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{BM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{의과학 학제전공}
		\renewcommand{\@childDeptNameEng}{Biomedical Science and Engineering Interdisciplinary Program}
		\renewcommand{\@parentDeptNameKor}{의과학대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Medical Science and Engineering}
		\renewcommand{\@parentAcademNameEng}{Medical Science and Engineering}
		\renewcommand{\@childAcademNameEng}{Biomedical Science and Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{CE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{건설및환경공학과}
		\renewcommand{\@childDeptNameEng}{Department of Civil and Environmental Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Civil and Environmental Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ME}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@childDeptNameKor}{기계공학과}
		\renewcommand{\@childDeptNameEng}{Department of Mechanical Engineering}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Mechanical Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{AE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@childDeptNameKor}{항공우주공학과}
		\renewcommand{\@childDeptNameEng}{Department of Aerospace Engineering}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Aerospace Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{OSE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@parentDeptNameKor}{기계공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Mechanical Engineering}
		\renewcommand{\@childDeptNameKor}{해양시스템대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Ocean Systems Engineering}
		\renewcommand{\@parentAcademNameEng}{Mechanical Engineering}
		\renewcommand{\@childAcademNameEng}{Ocean Systems Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{BIS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{바이오및뇌공학과}
		\renewcommand{\@childDeptNameEng}{Department of Bio and Brain Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Bio and Brain Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ID}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{산업디자인학과}
		\renewcommand{\@childDeptNameEng}{Department of Industrial Design}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Industrial Design}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{CBE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{생명화학공학과}
		\renewcommand{\@childDeptNameEng}{Department of Chemical and Biomolecular Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Chemical and Biomolecular Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{MS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{신소재공학과}
		\renewcommand{\@childDeptNameEng}{Department of Materials Science and Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Materials Science and Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{NQE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{원자력 및 양자공학과}
		\renewcommand{\@childDeptNameEng}{Department of Nuclear and Quantum Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Nuclear and Quantum Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{EEW}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{EEWS 대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Energy, Environment, Water and Sustainability}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Energy, Environment, Water and Sustainability}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{GT}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{조천식녹색교통대학원}
		\renewcommand{\@childDeptNameEng}{The Cho Chun Shik Graduate School for Green Transportation}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Green Transportation}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}     
	\ifthenelse{\equal{#1}{PSE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{고분자 학제전공}
		\renewcommand{\@childDeptNameEng}{Polymer Science and Engineering Program}
		\renewcommand{\@parentDeptNameKor}{생명화학공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Chemical and Biomolecular Engineering}
		\renewcommand{\@parentAcademNameEng}{Chemical and Biomolecular Engineering}
		\renewcommand{\@childAcademNameEng}{Polymer Science and Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{SPE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{우주탐사공학 학제전공}
		\renewcommand{\@childDeptNameEng}{Space Exploration Engineering Program}
		\renewcommand{\@parentDeptNameKor}{항공우주공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Aerospace Engineering}
		\renewcommand{\@parentAcademNameEng}{Aerospace Engineering}
		\renewcommand{\@childAcademNameEng}{Space Exploration Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ENY}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{환경·에너지공학 학제전공}
		\renewcommand{\@childDeptNameEng}{Environmental and Energy Technology Program}
		\renewcommand{\@parentDeptNameKor}{건설및환경공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Civil and Environmental Engineering}
		\renewcommand{\@parentAcademNameEng}{Civil and Environmental Engineering}
		\renewcommand{\@childAcademNameEng}{Environmental and Energy Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{BTM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{기술경영학부}
		\renewcommand{\@childDeptNameEng}{School of Business and Technology Management}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Business and Technology Management}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IT}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{기술경영학부 (IT경영학)}
		\renewcommand{\@childDeptNameEng}{School of Business and Technology Management (IT Business)}
		\renewcommand{\@parentDeptNameKor}{기술경영학부}
		\renewcommand{\@parentDeptNameEng}{School of Business and Technology Management}
		\renewcommand{\@parentAcademNameEng}{Business and Technology Management}
		\renewcommand{\@childAcademNameEng}{IT Business}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ITP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{글로벌IT기술대학원프로그램}
		\renewcommand{\@childDeptNameEng}{Global Information and Telecommunication Technology Program}
		\renewcommand{\@parentDeptNameKor}{기술경영학부}
		\renewcommand{\@parentDeptNameEng}{School of Business and Technology Management}
		\renewcommand{\@parentAcademNameEng}{Business and Technology Management}
		\renewcommand{\@childAcademNameEng}{Global Information and Telecommunication Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ITM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{기술경영전문대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Innovation and Technology Management}
		\renewcommand{\@parentDeptNameKor}{기술경영학부}
		\renewcommand{\@parentDeptNameEng}{School of Business and Technology Management}
		\renewcommand{\@parentAcademNameEng}{Business and Technology Management}
		\renewcommand{\@childAcademNameEng}{Innovation and Technology Management}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{GCT}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{문화기술대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Culture Technology}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Culture Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{STP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{과학기술정책대학원}
		\renewcommand{\@childDeptNameEng}{Graduate Program of Science and Technology Policy}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Science and Technology Policy}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{GFS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{문술미래전략대학원}
		\renewcommand{\@childDeptNameEng}{Moon Soul Graduate School of Future Strategy}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Future Strategy}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{지식재산대학원프로그램}
		\renewcommand{\@childDeptNameEng}{Master of Intellectual Property}
		\renewcommand{\@parentDeptNameKor}{문술미래전략대학원}
		\renewcommand{\@parentDeptNameEng}{Moon Soul Graduate School of Future Strategy}
		\renewcommand{\@parentAcademNameEng}{Future Strategy}
		\renewcommand{\@childAcademNameEng}{Intellectual Property}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{SJ}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{과학저널리즘대학원프로그램}
		\renewcommand{\@childDeptNameEng}{Master of Science Journalism}
		\renewcommand{\@parentDeptNameKor}{문술미래전략대학원}
		\renewcommand{\@parentDeptNameEng}{Moon Soul Graduate School of Future Strategy}
		\renewcommand{\@parentAcademNameEng}{Future Strategy}
		\renewcommand{\@childAcademNameEng}{Science Journalism}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{FS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{미래전략대학원프로그램}
		\renewcommand{\@childDeptNameEng}{Graduate Program for Future Strategy}
		\renewcommand{\@parentDeptNameKor}{문술미래전략대학원}
		\renewcommand{\@parentDeptNameEng}{Moon Soul Graduate School of Future Strategy}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Future Strategy}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}                    
	\ifthenelse{\equal{#1}{EE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{전기및전자공학부}
		\renewcommand{\@childDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Electrical Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{STE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@parentDeptNameKor}{전기및전자공학부}
		\renewcommand{\@parentDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@childDeptNameKor}{반도체공학프로그램}
		\renewcommand{\@childDeptNameEng}{KAIST Education Program for Semiconductor Industry}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{CS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{전산학부}
		\renewcommand{\@childDeptNameEng}{School of Computing}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Computer Science}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{WST}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{웹사이언스대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Web Science Technology}
		\renewcommand{\@parentDeptNameKor}{전산학부}
		\renewcommand{\@parentDeptNameEng}{School of Computing}
		\renewcommand{\@parentAcademNameEng}{Computer Science}
		\renewcommand{\@childAcademNameEng}{Web Science Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}     
	\ifthenelse{\equal{#1}{IS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{정보보호대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Information Security}
		\renewcommand{\@parentDeptNameKor}{전산학부}
		\renewcommand{\@parentDeptNameEng}{School of Computing}
		\renewcommand{\@parentAcademNameEng}{Computer Science}
		\renewcommand{\@childAcademNameEng}{Information Security}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}  
	\ifthenelse{\equal{#1}{SEP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{소프트웨어대학원프로그램}
		\renewcommand{\@childDeptNameEng}{Software Graduate Program}
		\renewcommand{\@parentDeptNameKor}{전산학부}
		\renewcommand{\@parentDeptNameEng}{School of Computing}
		\renewcommand{\@parentAcademNameEng}{Computer Science}
		\renewcommand{\@childAcademNameEng}{Software}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{ICE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{정보통신공학과}
		\renewcommand{\@childDeptNameEng}{Department of Information and Communications Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Information and Communications Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{DMP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{디지털미디어프로그램}
		\renewcommand{\@childDeptNameEng}{Digital Media Program}
		\renewcommand{\@parentDeptNameKor}{정보통신공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Information and Communications Engineering}
		\renewcommand{\@parentAcademNameEng}{Information and Communications Engineering}
		\renewcommand{\@childAcademNameEng}{Digital Media}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{산업 및 시스템 공학과}
		\renewcommand{\@childDeptNameEng}{Department of Industrial and Systems Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Industrial and Systems Engineering }
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{KSE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{지식서비스공학대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Knowledge Service Engineering}
		\renewcommand{\@parentDeptNameKor}{산업 및 시스템 공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Industrial and Systems Engineering}
		\renewcommand{\@parentAcademNameEng}{Industrial and Systems Engineering}
		\renewcommand{\@childAcademNameEng}{Knowledge Service Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
        \ifthenelse{\equal{#1}{DS}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{데이터사이언스대학원}
		\renewcommand{\@childDeptNameEng}{Graduate School of Data Science}
		\renewcommand{\@parentDeptNameKor}{산업 및 시스템 공학과}
		\renewcommand{\@parentDeptNameEng}{Department of Industrial and Systems Engineering}
		\renewcommand{\@parentAcademNameEng}{Industrial and Systems Engineering}
		\renewcommand{\@childAcademNameEng}{Knowledge Service Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{RE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{로봇공학 학제전공}
		\renewcommand{\@childDeptNameEng}{Robotics Program}
		\renewcommand{\@parentDeptNameKor}{전기및전자공학부}
		\renewcommand{\@parentDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@parentAcademNameEng}{Electrical Engineering}
		\renewcommand{\@childAcademNameEng}{Robotics}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{PD}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{미래자동차 학제전공}
		\renewcommand{\@childDeptNameEng}{Division of Future Vehicle}
		\renewcommand{\@parentDeptNameKor}{전기및전자공학부}
		\renewcommand{\@parentDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@parentAcademNameEng}{Electrical Engineering}
		\renewcommand{\@childAcademNameEng}{Future Vehicle}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{STE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{반도체 학제전공}
		\renewcommand{\@childDeptNameEng}{Semiconductor Technology Educational Program}
		\renewcommand{\@parentDeptNameKor}{전기및전자공학부}
		\renewcommand{\@parentDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@parentAcademNameEng}{Electrical Engineering}
		\renewcommand{\@childAcademNameEng}{Semiconductor Technology}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{TE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{정보통신공학 학제전공}
		\renewcommand{\@childDeptNameEng}{Telecommunication Engineering Program}
		\renewcommand{\@parentDeptNameKor}{전기및전자공학부}
		\renewcommand{\@parentDeptNameEng}{School of Electrical Engineering}
		\renewcommand{\@parentAcademNameEng}{Electrical Engineering}
		\renewcommand{\@childAcademNameEng}{Telecommunication Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{MT}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{경영공학부}
		\renewcommand{\@childDeptNameEng}{School of Management Engineering}
		\renewcommand{\@parentDeptNameKor}{}
		\renewcommand{\@parentDeptNameEng}{}
		\renewcommand{\@parentAcademNameEng}{}
		\renewcommand{\@childAcademNameEng}{Management Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IMBA}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{IMBA}
		\renewcommand{\@childDeptNameEng}{IMBA}
		\renewcommand{\@parentDeptNameKor}{테크노경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Management}
		\renewcommand{\@parentAcademNameEng}{Management}
		\renewcommand{\@childAcademNameEng}{IMBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}     
	\ifthenelse{\equal{#1}{EM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{이그제큐티브MBA}
		\renewcommand{\@childDeptNameEng}{Executive MBA}
		\renewcommand{\@parentDeptNameKor}{테크노경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Management}
		\renewcommand{\@parentAcademNameEng}{Management}
		\renewcommand{\@childAcademNameEng}{Executive MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{SM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{사회적기업가MBA}
		\renewcommand{\@childDeptNameEng}{Social Enterpreneurship MBA}
		\renewcommand{\@parentDeptNameKor}{테크노경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Management}
		\renewcommand{\@parentAcademNameEng}{Management}
		\renewcommand{\@childAcademNameEng}{Social Enterpreneurship MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{PM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{프로페셔널MBA}
		\renewcommand{\@childDeptNameEng}{Professional MBA}
		\renewcommand{\@parentDeptNameKor}{테크노경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Management}
		\renewcommand{\@parentAcademNameEng}{Management}
		\renewcommand{\@childAcademNameEng}{Professional MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{TM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{테크노경영MBA}
		\renewcommand{\@childDeptNameEng}{Techno-MBA}
		\renewcommand{\@parentDeptNameKor}{테크노경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Management}
		\renewcommand{\@parentAcademNameEng}{Management}
		\renewcommand{\@childAcademNameEng}{Techno-MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{FIN}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{금융MBA}
		\renewcommand{\@childDeptNameEng}{Finance MBA}
		\renewcommand{\@parentDeptNameKor}{금융전문대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Finance}
		\renewcommand{\@parentAcademNameEng}{Finance}
		\renewcommand{\@childAcademNameEng}{Finance MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}          
	\ifthenelse{\equal{#1}{FE}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{금융공학프로그램}
		\renewcommand{\@childDeptNameEng}{Financial Engineering Program}
		\renewcommand{\@parentDeptNameKor}{금융전문대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Finance}
		\renewcommand{\@parentAcademNameEng}{Finance}
		\renewcommand{\@childAcademNameEng}{Financial Engineering}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{FEM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{금융이그제큐티브MBA}
		\renewcommand{\@childDeptNameEng}{Financial Executive MBA}
		\renewcommand{\@parentDeptNameKor}{금융전문대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Finance}
		\renewcommand{\@parentAcademNameEng}{Finance}
		\renewcommand{\@childAcademNameEng}{Financial Executive MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{GM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{녹색MBA}
		\renewcommand{\@childDeptNameEng}{Green MBA}
		\renewcommand{\@parentDeptNameKor}{녹색성장대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Green Growth}
		\renewcommand{\@parentAcademNameEng}{Green Growth}
		\renewcommand{\@childAcademNameEng}{Green MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{GBP}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{녹색경영정책프로그램}
		\renewcommand{\@childDeptNameEng}{Green Business and Policy Program}
		\renewcommand{\@parentDeptNameKor}{녹색성장대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Green Growth}
		\renewcommand{\@parentAcademNameEng}{Green Growth}
		\renewcommand{\@childAcademNameEng}{Green Business and Policy}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix #1}
		\renewcommand{\@childDeptNameKor}{정보경영프로그램}
		\renewcommand{\@childDeptNameEng}{Information Management Program}
		\renewcommand{\@parentDeptNameKor}{정보미디어경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Information and Media Management}
		\renewcommand{\@parentAcademNameEng}{Information and Media Management}
		\renewcommand{\@childAcademNameEng}{Information Management}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}
	\ifthenelse{\equal{#1}{IMM}}
	{\renewcommand{\@degreeCode}{\@degreePrefix MT}
		\renewcommand{\@childDeptNameKor}{정보미디어MBA}
		\renewcommand{\@childDeptNameEng}{Information and Media MBA}
		\renewcommand{\@parentDeptNameKor}{정보미디어경영대학원}
		\renewcommand{\@parentDeptNameEng}{Graduate School of Information and Media Management}
		\renewcommand{\@parentAcademNameEng}{Information and Media Management}
		\renewcommand{\@childAcademNameEng}{Information and Media MBA}
		\renewcommand{\@degreeField}{#2}
		\renewcommand{\@degreeversion}{#3}}{}                           
	
	\renewcommand{\@affFullNameKor}{%               % 학과/전공 한글이름
		\ifthenelse{\equal{\@parentDeptNameKor}{}}
		{\@childDeptNameKor}{%
			\ifthenelse{\equal{\@degreeversion}{a}}{\@parentDeptNameKor}{}%
			\ifthenelse{\equal{\@degreeversion}{b}}{\@parentDeptNameKor \ (\@childDeptNameKor)}{}%
			\ifthenelse{\equal{\@degreeversion}{c}}{\@childDeptNameKor}{}}
	}
	\renewcommand{\@affFullNameEng}{%               % 학과/전공 영문이름
		\ifthenelse{\equal{\@parentDeptNameEng}{}}
		{\@childDeptNameEng}{%
			\ifthenelse{\equal{\@degreeversion}{a}}{\@parentDeptNameEng}{}%
			\ifthenelse{\equal{\@degreeversion}{b}}{\@parentDeptNameEng \ (\@childDeptNameEng)}{}%
			\ifthenelse{\equal{\@degreeversion}{c}}{\@childDeptNameEng}{}}
	}
	\renewcommand{\@appFullAcademName}{%               % 학문 승인서용 영문이름
		\ifthenelse{\equal{\@parentAcademNameEng}{}}
		{\@childAcademNameEng}{%
			\ifthenelse{\equal{\@degreeversion}{a}}{\@parentAcademNameEng}{}%
			\ifthenelse{\equal{\@degreeversion}{b}}{\@parentAcademNameEng \ (\@childAcademNameEng)}{}%
			\ifthenelse{\equal{\@degreeversion}{c}}{\@childAcademNameEng}{}}
	}
	
	\renewcommand{\@degreeName}{%                       % 학위 영문이름
		\ifthenelse{\boolean{@isDoctor}}
		{Doctor of Philosophy} {%                 % 박사는 모두 Ph.D.
			\ifthenelse{\equal{\@degreeField}{science}}
			{Master of Science}{}%               % 이학석사는 M.S.
			\ifthenelse{\equal{\@degreeField}{engineering}}
%			{Master of Science in Engineering}{}%           % 공학석사는 M.E.
			{Master of Science}{}%           % 공학석사는 M.S.
			\ifthenelse{\equal{\@degreeField}{business}}
			{Master of Business Administration}{}% 경영학석사는 M.B.A.
		}
	}
}
\@onlypreamble{\department}

% @command studentid 학번
\newcommand{\studentid}[1]{\newcommand{\@studentID}{#1}}
\@onlypreamble{\studentid}

% @command referee 심사위원 (석사과정 3인, 박사과정 5인)
\newcommand{\referee}[2][1] {%
	\ifthenelse{\equal{#1}{1}}{\newcommand{\@refereeChief} {#2}} {}%
	\ifthenelse{\equal{#1}{2}}{\newcommand{\@refereeSecond}{#2}} {}%
	\ifthenelse{\equal{#1}{3}}{\newcommand{\@refereeThird} {#2}} {}%
	\ifthenelse{\equal{#1}{4}}{\newcommand{\@refereeFourth}{#2}} {}%
	\ifthenelse{\equal{#1}{5}}{\newcommand{\@refereeFifth} {#2}} {}%
}
\@onlypreamble{\referee}

% @command approvaldate 지도교수논문승인일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\approvaldate}[3] {%
	\newcommand{\@approvalYear}{#1}
	\newcommand{\@approvalMonth}{#2}
	\newcommand{\@approvalDay}{#3}
}
\@onlypreamble{\approvaldate}

% @command refereedate 심사위원논문심사일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\refereedate}[3] {%
	\newcommand{\@refereeYear}{#1}
	\newcommand{\@refereeMonth}{#2}
	\newcommand{\@refereeDay}{#3}
}
\@onlypreamble{\refereedate}

% @command gradyear 졸업년도
\newcommand{\gradyear}[1]{\newcommand{\@gradYear}{#1}}
\@onlypreamble{\gradyear}

%%
%% 필요한 정보 중에 누락된 것이 없는지 점검 --> 제작중. 아직 불완전. 그대로 놔둠
%%
\newcommand{\checkparameters}{%
	\@ifundefined{@titleKor}{%
		\ClassError{kaist}{The korean title is not found}{}}{}
	\@ifundefined{@titleEng}{%
		\ClassError{kaist}{The english title is not found}{}}{}
	\@ifundefined{@authorKor}{%
		\ClassError{kaist}{The korean name of the author is not found}{}}{}
	\@ifundefined{@authorChn}{%
		\ClassError{kaist}{The chinese name of the author is not found}{}}{}
	\@ifundefined{@authorEng}{%
		\ClassError{kaist}{The english name of the author is not found}{}}{}
	\@ifundefined{@advisorMajorKor}{%
		\ClassError{kaist}{The korean name of the major advisor is not found}{}}{}
	\@ifundefined{@advisorMajorEng}{%
		\ClassError{kaist}{The english name of the major advisor is not found}{}}{}
}

%%
%% 앞표지 생성
%% Don't change size of letters.
\newcommand{\makefrontcover}{%
	\renewcommand{\baselinestretch}{1.3}%
	\thispagestyle{empty} \noindent%
	\begin{minipage}[b][10mm][b]{\textwidth}
		\begin{center}
			\if@isDoctor
			\fontsize{17pt}{17pt}\selectfont{박 사 학 위 논 문}\\ \fontsize{15pt}{15pt}\selectfont{Ph.D. Dissertation}
			\else
			\fontsize{17pt}{17pt}\selectfont{석 사 학 위 논 문}\\ \fontsize{15pt}{15pt}\selectfont{Master's Thesis}
			\fi
		\end{center}
	\end{minipage}\\[40mm]
	\begin{minipage}[t][80mm][t]{\textwidth}
		\begin{center}
			\fontsize{21pt}{21pt}\selectfont  \@titleKor \\[21pt]
			\fontsize{18pt}{18pt}\selectfont  \@titleEng \\[18pt]
			\fontsize{18pt}{18pt}\selectfont \@gradYear 
		\end{center}
	\end{minipage}\\[40mm]
	\begin{minipage}[c][70mm][c]{\textwidth}
		\begin{center}
			\fontsize{20pt}{20pt}\selectfont
			\ifthenelse{\equal{\@authorChnFN}{}}
			{\@authorKor\  \hspace{0.5mm} \fontsize{18pt}{18pt}\selectfont  (\@authorEng) \\}
			{\@authorKor\  \hspace{0.5mm} \fontsize{18pt}{18pt}\selectfont   (\@authorChn\
				\@authorEng) \\}[25mm]
			\fontsize{20pt}{20pt}\selectfont 한 국 과 학 기 술 원 %%\\ \@affFullNameKor 
		\end{center}
	\end{minipage}\\[-5mm]
	\begin{minipage}[c][0mm][c]{\textwidth}
		\begin{center}
			%%\Large \@affFullNameEngCover\\ 
			\fontsize{18pt}{18pt}\selectfont \@kaist %% Don't write 'KAIST'. It must be full name.
		\end{center}
	\end{minipage} \newpage
	
}

%%
%% 속표지 생성
%%  Don't change size of letters.
\renewcommand{\maketitle}{%
	\thispagestyle{empty} \noindent 
	\renewcommand{\baselinestretch}{1.3}%
	%
	\begin{minipage}[b][12mm][b]{\textwidth}
		\begin{center}
			\if@isDoctor
			\fontsize{17pt}{17pt}\selectfont{박 사 학 위 논 문}
			\else 
			\fontsize{17pt}{17pt}\selectfont{석 사 학 위 논 문}
			\fi
		\end{center}
	\end{minipage}\\[30mm]
	\begin{minipage}[t][70mm][t]{\textwidth}
		\begin{center}
			\fontsize{21pt}{21pt}\selectfont  \@titleKor \\[38pt]
			\fontsize{18pt}{18pt}\selectfont \@gradYear 
		\end{center}
	\end{minipage}\\[40mm]
	\begin{minipage}[c][85mm][c]{\textwidth}
		\begin{center}
			\fontsize{20pt}{20pt}\selectfont
			\ifthenelse{\equal{\@authorKorFN}{}}
			{\@authorEng\ (\@authorChn) \\}
			{\@authorKor\ \\}[27mm]
			%\ifthenelse{\equal{\@authorKorFN}{}}
			%{\@authorEng\ (\@authorChn) \\}
			%{\@authorKor\   (\@authorChn\ \
			%\@authorEng) \\}[7mm]
			한 국 과 학 기 술 원 \\[7mm] \@affFullNameKor
		\end{center}
	\end{minipage} \newpage  
} 


%%
%% 학위논문 심사완료 검인서 및 제출승인서 생성
%%  Don't change size of letters.



\newcommand{\makeapproval}{%% 학위논문 심사완료 검인서
	\thispagestyle{empty} \noindent
	\begin{minipage}[c][80mm][c]{\textwidth}
		\begin{center}
			\fontsize{21pt}{21pt}\selectfont \@titleKor \\          % 학위논문 한글제목
		\end{center}
	\end{minipage}\\[-10mm]
	\begin{minipage}[c][0mm][c]{\textwidth}
		\begin{center}
			\fontsize{16pt}{16pt}\selectfont
			\ifthenelse{\equal{\@authorKorFN}{}}
			{\@authorEng}
			{\@authorKor}  % 저자 한글이름
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[c][60mm][c]{\textwidth}
		\begin{center}
			\fontsize{16pt}{16pt}\selectfont 위 논문은 한국과학기술원
			\ifthenelse{\boolean{@isDoctor}}{박사}{석사}학위논문으로\linebreak
			학위논문 심사위원회의 심사를 통과하였음
		\end{center}
	\end{minipage}\\[13mm]
	\begin{minipage}[t][20mm][b]{\textwidth}
		\begin{center}
			%\fontsize{16pt}{16pt}\selectfont \@refereeYear 년 \@refereeMonth 월 \@refereeDay 일 
			%\begin{flushright}
			
			\begin{tabular}{rcl}
				% 심사위원명단 \hspace*{15mm} \hspace*{15mm}
				\multicolumn{3}{c}{\fontsize{16pt}{16pt}\selectfont \@refereeYear 년 \@refereeMonth 월 \@refereeDay 일 }\mbox{\ }
				\@ifundefined{@refereeChief}{}
				{\\[30pt] \fontsize{16pt}{16pt}\selectfont심사위원장 & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont\@refereeChief} & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont (인)} }
				\@ifundefined{@refereeSecond}{}
				{\\[15pt] \fontsize{16pt}{16pt}\selectfont심 사 위 원   & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont\@refereeSecond} & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont (인)}}
				\@ifundefined{@refereeThird}{}
				{\\[15pt] \fontsize{16pt}{16pt}\selectfont심 사 위 원   & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont\@refereeThird} & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont (인)}}
				\@ifundefined{@refereeFourth}{}
				{\\[15pt] \fontsize{16pt}{16pt}\selectfont심 사 위 원   & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont\@refereeFourth} & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont (인)}}
				\@ifundefined{@refereeFifth}{}
				{\\[15pt] \fontsize{16pt}{16pt}\selectfont심 사 위 원   & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont\@refereeFifth} & \ \makebox[\width][r]{\fontsize{16pt}{16pt}\selectfont (인)}}
			\end{tabular}
			%\end{flushright} 
		\end{center}
	\end{minipage} 
	\newpage
	\renewcommand{\baselinestretch}{1.3}
	\hyphenation{institute department division program} % word division 방지
	\thispagestyle{empty} \noindent
	\begin{minipage}[c][30mm][c]{\textwidth}
		\begin{center}
			
			\fontsize{20pt}{20pt}\selectfont 
			\@titleEng
			
		\end{center}
	\end{minipage}\\[10mm]
	\begin{minipage}[c][3mm][c]{\textwidth}
		\begin{center}
			\fontsize{14pt}{14pt}\selectfont\@authorEngGN ~\@authorEngFN \\ 
		\end{center}
	\end{minipage}\\[10mm]
	\begin{minipage}[c][8mm][c]{\textwidth}
		\begin{center}
			\fontsize{14pt}{14pt}\selectfont
			\begin{tabular}{lcl}             % 학위논문 지도교수 영문이름
				\@ifundefined{@advisorCooprEng}
				% 단독지도교수이면 Advisor 하나만 출력
				{Advisor:&&\hspace{-0.8cm} \@advisorMajorEng}
				% 공동지도교수이면 Major,Co-Advisor 둘 다 출력
				{Major Advisor:&&\hspace{-0.8cm} \@advisorMajorEng \\
					Co-Advisor:&&\hspace{-0.8cm} \@advisorCooprEng}
			\end{tabular} \vfill
		\end{center}
	\end{minipage}\\[10mm]
	\begin{minipage}[t][45mm][t]{\textwidth}
		\fontsize{14pt}{14pt}\selectfont
		\hspace*{10mm}
		\begin{center}
			A dissertation submitted to the faculty of\\
			\@kaist\ in\\
			partial fulfillment of the requirements for the degree of\\
			\@degreeName in
			\@appFullAcademName
		\end{center}
	\end{minipage}\\[10mm]
	\mbox{} \hfill
	%\begin{minipage}[t][65mm][t]{.55\textwidth}
	%\linespread{1.4}
	\begin{minipage}[t][0mm][t]{\textwidth}
		\begin{center}
			\fontsize{14pt}{14pt}\selectfont \noindent
			Daejeon, Korea\\
%			\@approvalYear.~\@approvalMonth.~\@approvalDay.\\[24pt] % 제출승인일자 format: 2016.11.25
       \@dateUSenglish{\@approvalYear}{\@approvalMonth}{\@approvalDay} \\[24pt] % 제출승인일자 format: June 2, 2016
			Approved by \\
			% 단독 또는 주 지도교수가 서명하면 Major-,  부 지도교수가 서명하면 Co-
			%    \@ifundefined{@advisorCooprEng}{[Advisor]}%
			%            {\ifthenelse{\equal{\@advisorSigned}{\@advisorMajorEng}}%
			%                {[Major Advisor]}{[Co-Advisor]}} \\
			[0pt]
			\vspace*{18mm}
			
			\makebox[.5\textwidth][r]{\hrulefill}\\
			\fontsize{14pt}{14pt}\selectfont \@advisorSigned \\          % 제출승인서에 서명한 교수이름
			\fontsize{14pt}{14pt}\selectfont \@advisorinfo  % 제출승인서에 서명한 교수님 정보 
			\vspace*{20mm}
			\\
			\fontsize{12pt}{12pt}\selectfont The study was conducted in accordance with Code of Research Ethics\footnotemark[1].
		\end{center}
		
		
	\end{minipage}\\[0mm]
	
	% \end{minipage} 
	\footnotetext[1]{\fontsize{10pt}{10pt} Declaration of Ethical Conduct in Research: I, as a graduate student of Korea Advanced Institute of Science and Technology, hereby declare that I have not committed any act that may damage the credibility of my research.
		This includes, but is not limited to, falsification, thesis written by someone else, distortion of research findings, and plagiarism.
		I confirm that my thesis contains honest conclusions based on my own careful research under the guidance of my advisor.}
	\hfill \newpage
}


%%
%% 한글 초록과 영문 초록, 논문서지(Korean summary and abstract) 페이지 생성
%%  Don't change size of letters. 
\newcounter{pagemarker}                           % 페이지 번호 임시 저장용
\newcommand{\@lastPage}{\pageref{paperlastpagelabel}} % 총 페이지 수 계산용
\newcommand{\@lastRomanPage}{\pageref{paperlastromanpagelabel}} % 총 로마자 페이지 수 계산용

\newcommand{\thesisinfo}{
	\pagenumbering{gobble}
	\pagestyle{plain}%
	\newcommand{\@tempbreak}{}                   % \linebreak 명령 보관용
	\let\@tempbreak\linebreak
	\renewcommand{\linebreak}{\ }                % \linebreak -> 공백 대체
	\newlength{\@thesisinfowidth}
	\setlength{\@thesisinfowidth}{\textwidth}    % 논문정보박스 사이즈는
	\addtolength{\@thesisinfowidth}{-30mm}       % 텍스트 폭보다 30mm 작게 
	\noindent
	\parbox[t]{30mm}{\fontsize{14pt}{14pt} \textsf{\@degreeCode}}
	\raisebox{3pt}{\begin{minipage}[t]{\@thesisinfowidth}
			\fontsize{12pt}{12pt} \selectfont \sffamily
			\ifthenelse{\equal{\@authorKorFN}{}}
			{}
			{\@authorKorCont.}           % 저자 한글이름
			\@titleKor.                 % 학위논문 한글제목
			\@affFullNameKor .      % 학과/전공 한글이름
			\@gradYear 년.           % 졸업년도
			\@lastPage+\@lastRomanPage~쪽.                           % 총 페이지 수 -> 참고문헌 끝
			\@ifundefined{@advisorCooprEng}         % 공동지도교수 유무판정
			{지도교수: \@advisorMajorKorCont.} % 단독지도교수 한글이름
			{지도교수: \@advisorMajorKorCont, % 공동 주 지도교수 한글이름
				~\@advisorCooprKorCont.}         % 공동 부 지도교수 한글이름
			\ifthenelse{\boolean{@isKorean}}
			{(한글 논문)}{(영문 논문)} \\              % 본문이 영어인 경우 명시
			\@authorEngGN~\@authorEngFN.           % 저자 영문이름
			\@titleEng .                 % 학위논문 영문제목
			\@affFullNameEng .     % 학과/전공 영문이름
			\@gradYear .            % 졸업년도
			\@lastPage+\@lastRomanPage~pages.                           % 총 페이지 수 -> 참고문헌 끝
			\@ifundefined{@advisorCooprEng}         % 공동지도교수 유무판정
			{Advisor: \@advisorMajorEng.} % 단독지도교수 영문이름
			{Advisor: \@advisorMajorEng, % 공동 주 지도교수 영문이름
				~\@advisorCooprEng.}         % 공동 부 지도교수 영문이름
			\ifthenelse{\boolean{@isKorean}}
			{(Text in Korean)}{(Text in English)}               % 본문이 한글인 경우 명시
		\end{minipage}}\\[16pt] \if@PDFdoc\phantomsection\fi}
	
	%%
	%% 한글요약문 생성 - 영문논문의 경우만 해당
	%%
	\newenvironment{summary}{
		\noindent\underline{\textbf{초 록}} 
		% \setlength{\parindent}{0pt} 
		\\
	}{}
	
	\newcommand{\summarykorean}{%           % ver 0.1 요약문 생성 명령
		\renewcommand{\linebreak}{\ }      % 차후 버젼에서 삭제 예정
		\ifx\@textlang\@english
		\chapter*{요 약 문}
		\begin{center}
			\noindent\textsf{\Large \@titleKor} \\[6mm]
		\end{center}% \setlength{\parindent}{0\p@}
		\fi
	}{}
	
	%%
	%% 핵심 낱말 생성
	%%
	\newenvironment{Korkeyword}{\vspace*{3mm}
		\noindent \underline{\textbf{핵 심 낱 말}} }{}
	
	%%
	%% 논문초록 생성
	%%
	\renewenvironment{abstract}{\vspace*{9mm} 
		\noindent\underline{\textbf{Abstract}}    % 초록명 -> Abstract
		\\
	}{
}

%%
%% Keyword 생성
%%
\newenvironment{Engkeyword}{\vspace*{3mm}  
	\noindent\underline{\textbf{Keywords}}}
{\let\linebreak\@tempbreak          % \linebreak 명령 되돌리기
}






%%
%% 목차 일괄 생성
%%
\newcommand{\makecontents}{%        가    % TOC, LOT, LOF 생성
	\setcounter{pagemarker}{\value{page}}        % 마지막 페이지 번호를 저장
	\pagenumbering{roman}                        % 로마자 페이지 시작
	\tableofcontents
	\listoftables
	\listoffigures}




%%
%% 사사 및 이력서 생성
%%

\newcommand{\acknowledgment}[1][default]{%     % 사사
	\newcommand{\@acklang}{#1}
	\ifthenelse{\equal{\@acklang}{1}}
	{\chapter*{사 사} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{사 사}}{}                 % 본문과 사사가 둘 다 한글일 때
	\ifthenelse{\equal{\@acklang}{2}}
	{\chapter*{영 문 사 사} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{영 문 사 사}}{}         % 본문은 한글인데 사사가 영어일 때
	\ifthenelse{\equal{\@acklang}{3}}
	{\chapter*{Acknowledgment} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{Acknowledgments}}{}        % 본문과 사사가 둘 다 영어일 때 
	\ifthenelse{\equal{\@acklang}{4}}
	{\chapter*{Acknowledgments in Korean} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{Acknowledgments in Korean}}{}\noindent}         % 본문은 영어인데 사사가 한글일 때 

\newcommand{\curriculumvitae}[1][default]{%     % 약력
	\newcommand{\@ccvlang}{#1}
	\ifthenelse{\equal{\@ccvlang}{1}}
	{\chapter*{약 력} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{약 력}}{}                 % 본문과 약력이 둘 다 한글일 때
	
	\ifthenelse{\equal{\@ccvlang}{2}}
	{\chapter*{영 문 약 력} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{영 문 약 력}}{}         % 본문은 한글인데 약력이 영어일 때
	
	\ifthenelse{\equal{\@ccvlang}{3}}
	{\chapter*{Curriculum Vitae} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{Curriculum Vitae}}{}        % 본문과 약력이 둘 다 영어일 때 
	\ifthenelse{\equal{\@ccvlang}{4}}
	{\chapter*{Curriculum Vitae in Korean} \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{Curriculum Vitae in Korean}}{}}% 본문은 영어인데 약력이 한글일 때


%%
%% 이력서 내부 요소 생성
%%


\newenvironment{personaldata}{%            % 개인정보
	
	\begin{list}{}{%
			\setlength{\labelwidth}{70pt}
			\setlength{\leftmargin}{\labelwidth}
			\addtolength{\leftmargin}{\labelsep}
			\setlength{\parsep}{0pt}
			\renewcommand{\makelabel}[1]{\textgt{##1:\ }}}
		\newcommand{\name}[1]{%               % 이름
			\ifthenelse{\equal{\@ccvlang}{1}}
			{\def\@arg{[이\hfill름]}}{}
			\ifthenelse{\equal{\@ccvlang}{4}}
			{\def\@arg{[이\hfill름]}}{}
			\ifthenelse{\equal{\@ccvlang}{2}}
			{\def\@arg{[Name\hfill]}}{}
			\ifthenelse{\equal{\@ccvlang}{3}}
			{\def\@arg{[Name\hfill]}}{}
			\expandafter\item\@arg ##1}
		
		\newcommand{\dateofbirth}[3]{%        % 생년월일
			\ifthenelse{\equal{\@ccvlang}{1}}
			{\def\@arg{[생\hfill년\hfill월\hfill일]}
				\expandafter\item\@arg ##1년 ##2월 ##3일}{}
			\ifthenelse{\equal{\@ccvlang}{4}}
			{\def\@arg{[생\hfill년\hfill월\hfill일]}
				\expandafter\item\@arg ##1년 ##2월 ##3일}{}
			\ifthenelse{\equal{\@ccvlang}{2}}
			{\def\@arg{[Date of Birth\hfill]}    \expandafter\item\@arg \@dateUSenglish{##1}{##2}{##3}
			}{}
			\ifthenelse{\equal{\@ccvlang}{3}}
			{\def\@arg{[Date of Birth\hfill]}
				\expandafter\item\@arg \@dateUSenglish{##1}{##2}{##3}
			}{}
		}
		
		\newcommand{\birthplace}[1]{%         % 출생지
			\ifthenelse{\equal{\@ccvlang}{1}}
			{\def\@arg{[출\hfill생\hfill지]}}{}
			\ifthenelse{\equal{\@ccvlang}{4}}
			{\def\@arg{[출\hfill생\hfill지]}}{}
			\ifthenelse{\equal{\@ccvlang}{2}}
			{\def\@arg{[Birthplace\hfill]}}{}
			\ifthenelse{\equal{\@ccvlang}{3}}
			{\def\@arg{[Birthplace\hfill]}}{}
			\expandafter\item\@arg ##1}
		
		%%       \newcommand{\domicile}[1]{%           % 본적지
		%%\ifthenelse{\equal{\@ccvlang}{1}}
		%%            {\def\@arg{[본\hfill적\hfill지]}}{}
		%% \ifthenelse{\equal{\@ccvlang}{4}}
		%% {\def\@arg{[본\hfill적\hfill지]}}{}
		%%      \ifthenelse{\equal{\@ccvlang}{2}}
		%%   {\def\@arg{[Domicile\hfill]}}{}
		%%
		%%   \ifthenelse{\equal{\@ccvlang}{3}}
		%%       {\def\@arg{[Domicile\hfill]}}{}
		%%     \expandafter\item\@arg ##1}
		
		
		\newcommand{\address}[1]{%            % 주소지
			\ifthenelse{\equal{\@ccvlang}{1}}
			{\def\@arg{[주\hfill소]}}{}
			\ifthenelse{\equal{\@ccvlang}{4}}
			{\def\@arg{[주\hfill소]}}{}
			\ifthenelse{\equal{\@ccvlang}{2}}
			{\def\@arg{[Address\hfill]}}{}
			
			\ifthenelse{\equal{\@ccvlang}{3}}
			{\def\@arg{[Address\hfill]}}{}
			
			\expandafter\item\@arg ##1}
		
		\newcommand{\email}[1]{%              % E-mail
			
			\ifthenelse{\equal{\@ccvlang}{1}}
			{\def\@arg{[전\hfill자\hfill주\hfill소]}}{}
			\ifthenelse{\equal{\@ccvlang}{4}}
			{\def\@arg{[전\hfill자\hfill주\hfill소]}}{}
			\ifthenelse{\equal{\@ccvlang}{2}}
			{\def\@arg{[E-mail\hfill]}}{}
			
			\ifthenelse{\equal{\@ccvlang}{3}}
			{\def\@arg{[E-mail\hfill]}}{}
			\expandafter\item\@arg ##1}
		
		
		%이력서에 집어넣을 추가 필드가 필요하면 위를 참고하여 만들어 쓸 것.
		%\newcommand{(필드명령)}[1]{%
		%  \ifthenelse{\equal{\@ccvlang}{1}}
		%        {\def\@arg{[한글 필드 이름]}}{}
		%   \ifthenelse{\equal{\@ccvlang}{4}}
		%        {\def\@arg{[한글 필드 이름]}}{}
		%   \ifthenelse{\equal{\@ccvlang}{2}}
		%     {\def\@arg{[영어 필드 이름]}}{}
		%      
		%    \ifthenelse{\equal{\@ccvlang}{3}}
		%        {\def\@arg{[영어 필드 이름]}}{}
		%         \expandafter\item\@arg ##1}
	}{\end{list}}

\newenvironment{education}{%               % 학력
	
	\vspace*{5mm} \noindent
	
	\ifthenelse{\equal{\@ccvlang}{1}}{
		\begin{center}
			\makebox[2cm][s]{\textbf{\large 학 력}}
		\end{center}
	}{}
	\ifthenelse{\equal{\@ccvlang}{4}}{
		\begin{center}
			\makebox[2cm][s]{\textbf{\large 학 력}}
		\end{center}
	}{} 
	\ifthenelse{\equal{\@ccvlang}{2}}{
		\textbf{\large Educations}
	}{} 
	\ifthenelse{\equal{\@ccvlang}{3}}{
		\textbf{\large Educations}
	}{}  
	\begin{list}{}{%
			\setlength{\labelwidth}{95pt}
			\setlength{\leftmargin}{\labelwidth}
			\addtolength{\leftmargin}{\labelsep}
			\setlength{\parsep}{0pt}
			\renewcommand{\makelabel}[1]{\textgt{##1\hfill\ }}}
	}{\end{list}}

\newenvironment{career}{%                  % 경력
	
	\vspace*{5mm} \noindent
	
	\ifthenelse{\equal{\@ccvlang}{1}}
	{\begin{center}
			\makebox[2cm][s]{\textbf{\large 경 력}}
		\end{center}
	}{ }
	\ifthenelse{\equal{\@ccvlang}{4}}
	{\begin{center}
			\makebox[2cm][s]{\textbf{\large 경 력}}
		\end{center}
	}{ }
	\ifthenelse{\equal{\@ccvlang}{2}}
	{\textbf{\large Career}
	}{ }
	\ifthenelse{\equal{\@ccvlang}{3}}
	{\textbf{\large Career}
	}{ } 
	
	\begin{list}{}{%
			\setlength{\labelwidth}{95pt}
			\setlength{\leftmargin}{\labelwidth}
			\addtolength{\leftmargin}{\labelsep}
			\setlength{\parsep}{\z@}
			\renewcommand{\makelabel}[1]{\textgt{##1\hfill\ }}}
	}{\end{list}}

\newcounter{itemnum1}

\newenvironment{activity}{%                % 학회활동
  
        \vspace*{5mm} \noindent
        
\ifthenelse{\equal{\@ccvlang}{1}}
            {\begin{center}
                \makebox[2cm][s]{\textbf{\large 학 회 활 동}}
            \end{center}
        }{ }
       
\ifthenelse{\equal{\@ccvlang}{4}}
            {\begin{center}
                \makebox[2cm][s]{\textbf{\large 학 회 활 동}}
            \end{center}
        }{ } 
       
\ifthenelse{\equal{\@ccvlang}{2}}
           {\textbf{\large Academic Activities}
        }{ } 
       
\ifthenelse{\equal{\@ccvlang}{3}}
            {\textbf{\large Academic Activities}
        }{ }


 \begin{list}{}{%
            \usecounter{itemnum1}
            \setlength{\labelwidth}{1.5em}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{\z@}
            \renewcommand{\makelabel}{\textgt{\arabic{itemnum1}.\ }}}
    }{\end{list}}

\newcounter{itemnum2}

\newenvironment{publication}{%             % 연구업적
	
	\vspace*{5mm} \noindent
	
	\ifthenelse{\equal{\@ccvlang}{1}}{
		\begin{center}
			\makebox[2cm][s]{\textbf{\large 연 구 업 적}}
		\end{center}}
		{}
		
		\ifthenelse{\equal{\@ccvlang}{4}}{
			\begin{center}
				\makebox[2cm][s]{\textbf{\large 연 구 업 적}}
			\end{center}}
			{}
			
			\ifthenelse{\equal{\@ccvlang}{2}}{ \textbf{\large Publications}}
			{}
			
			\ifthenelse{\equal{\@ccvlang}{3}}{ \textbf{\large Publications}}
			{}
			
			
			\begin{list}{}{%
					\usecounter{itemnum2}
					\setlength{\labelwidth}{1.5em}
					\setlength{\leftmargin}{\labelwidth}
					\addtolength{\leftmargin}{\labelsep}
					\setlength{\parsep}{\z@}
					\renewcommand{\makelabel}{\textgt{\arabic{itemnum2}.\ }}}
			}{
		\end{list}}
		
		%%
		%% 헤딩 재설정
		%%
		\renewcommand{\contentsname}{
			\if@isKorean 차 례        \else Contents        \fi}
		\renewcommand{\listfigurename}{
			\if@isKorean 그림 차례 \else List of Figures \fi}
		\renewcommand{\listtablename}{
			\if@isKorean 표 차례    \else List of Tables  \fi}
		\renewcommand{\bibname}{%
			\if@isKorean 참 고 문 헌 \else Bibliography      \fi}
		\renewcommand{\abstractname}{
			\if@isKorean 논 문 초 록 \else Abstract      \fi}
		\renewcommand{\figurename}{
			\if@isKorean 그림 \else Figure      \fi}
		\renewcommand{\tablename}{
			\if@isKorean 표 \else Table      \fi}
		%%
		%% \part 재정의 - 아예 쓰지 못하게 막아버림. 이 명령을 호출하면 에러 발생.
		%%
		\renewcommand\part{%
			\secdef\@part\@spart}
		\def\@part[#1]#2{%
			\ClassError{kaist}{The use of \protect\part\space is prohibited.
				\MessageBreak Consider the use of \protect\chapter\space instead}{}
		}
		\def\@spart#1{%
			\ClassError{kaist}{The use of \protect\part\space is prohibited.
				\MessageBreak Consider the use of \protect\chapter\space instead}{}
		}
		
		
		%%
		%% \chapter 재정의 - report 클래스로부터 복사하여 일부 수정
		%%
		\renewcommand\chapter{%
			\if@openright\cleardoublepage\else\clearpage\fi
			%   \thispagestyle{plain}%
			\global\@topnum\z@
			\@afterindentfalse
			%   \if@isKorean \parindent\z@ \else \fi % <-- 추가할지 여부 고민중
			\secdef\@chapter\@schapter}
		\def\@chapter[#1]#2{%
			\ifnum \c@secnumdepth >\m@ne
			\refstepcounter{chapter}%
			\typeout{\@chapapp\space\thechapter.}%
			\addcontentsline{toc}{chapter}{%
				\if@isKorean
				\protect\numberline{제 \thechapter\ 장}#1
				\else
				\protect\numberline{Chapter \thechapter.}#1
				\fi
			}% <-- 목차에 나타나는 형식 - 변경사항
			\else
			\addcontentsline{toc}{chapter}{#1}%
			\fi
			\chaptermark{#1}%
			\addtocontents{lof}{\protect\addvspace{10\p@}}%
			\addtocontents{lot}{\protect\addvspace{10\p@}}%
			\if@twocolumn
			\@topnewpage[\@makechapterhead{#2}]%
			\else
			\@makechapterhead{#2}%
			\@afterheading%
			\fi
		}
		\def\@makechapterhead#1{% <-- 전체 변경
			\vspace*{10\p@}
			{\centering \parindent\z@ \fontsize{14pt}{14pt}\selectfont \bfseries
				\ifthenelse{\equal{\@textlang}{korean}}
				{제\hspace{1.4ex}\thechapter\hspace{1.4ex}장\hspace{2ex}}
				{Chapter\hspace{1.4ex}\thechapter.\hspace{1ex}}
				#1\par}
			\vspace*{20\p@}
		}
		\def\@schapter#1{%
			\if@twocolumn
			\@topnewpage[\@makeschapterhead{#1}]%
			\else
			\@makeschapterhead{#1}%
			\@afterheading
			\fi}
		\def\@makeschapterhead#1{% <-- 전체 변경
			\vspace*{10\p@}
			{\centering \parindent\z@ \fontsize{14pt}{14pt}\selectfont \bfseries #1\par}
			\vspace*{20\p@}
		}
		
		%%
		%% \tableofcontents 재정의 - report 클래스로부터 복사하여 일부 수정
		%%
		\renewcommand\tableofcontents{%
			\thispagestyle{plain}
			\if@twocolumn
			\@restonecoltrue\onecolumn
			\else
			\@restonecolfalse
			\fi
			\chapter*{\contentsname
				\@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
			\pagenumbering{roman}                         % roman 페이지번호로 복원
			\setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
			\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{content}{\contentsname} % 목차(TOC)에 추가
			\@starttoc{toc}%
			\if@restonecol\twocolumn\fi
			\newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
			\pagenumbering{arabic}                        % arabic 페이지번호로 재시작
		}
		
		%%
		%% \listoftables 재정의 - report 클래스로부터 복사하여 일부 수정
		%%
		\renewcommand\listoftables{%
			\thispagestyle{plain}
			\if@twocolumn
			\@restonecoltrue\onecolumn
			\else
			\@restonecolfalse
			\fi
			\chapter*{\listtablename}%
			\@mkboth{\MakeUppercase\listtablename}{\MakeUppercase\listtablename}%
			\pagenumbering{roman}                         % roman 페이지번호로 복원
			\setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
			\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{content}{\listtablename}% 목차(TOC)에 추가
			\@starttoc{lot}%
			\if@restonecol\twocolumn\fi
			\newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
			\pagenumbering{arabic}                        % arabic 페이지번호로 재시작
		}
		
		%%
		%% \listoffigures 재정의 - report 클래스로부터 복사하여 일부 수정
		%%
		\renewcommand\listoffigures{%
			\thispagestyle{plain}
			\if@twocolumn
			\@restonecoltrue\onecolumn
			\else
			\@restonecolfalse
			\fi
			\chapter*{\listfigurename}%
			\@mkboth{\MakeUppercase\listfigurename}{\MakeUppercase\listfigurename}%
			\pagenumbering{roman}                         % roman 페이지번호로 복원
			\setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
			\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{content}{\listfigurename}% 목차(TOC)에 추가
			\label{paperlastromanpagelabel}     % <-- 추가 부분: 마지막 페이지 위치 지정
			\@starttoc{lof}%
			\if@restonecol\twocolumn\fi
			\newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
			\pagenumbering{arabic}                        % arabic 페이지번호로 재시작
		}
		
		%%
		%% 목차에 나오는 형식 - report 클래스로부터 복사하여 일부 수정
		%%
		
		\newcommand{\l@content}{\large\bf\@dottedtocline{1}{0em}{0em}}
		
		\renewcommand*\l@chapter[2]{%
			\ifnum \c@tocdepth >\m@ne
			\addpenalty{-\@highpenalty}%
			\vskip 1.0em \@plus\p@
			\if@isKorean                     % <-- 변경 부분
			\setlength\@tempdima{5.0em} % korean  옵션일 때는 5.0em
			\else
			\setlength\@tempdima{6.5em} % english 옵션일 때는 1.5em
			\fi
			\begingroup
			\parindent \z@ \rightskip \@pnumwidth
			\parfillskip -\@pnumwidth
			\leavevmode \large \sffamily \bfseries
			\advance\leftskip\@tempdima
			\hskip -\leftskip
			#1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
			\penalty\@highpenalty
			\endgroup
			\fi}
		
		
		\if@isKorean % 한글이면 각종 치수를 변경
		\renewcommand*\l@section{\@dottedtocline{1}{2.7em}{2.3em}}
		\renewcommand*\l@subsection{\@dottedtocline{2}{5.0em}{3.2em}}
		\renewcommand*\l@subsubsection{\@dottedtocline{3}{8.2em}{4.1em}}
		\renewcommand*\l@paragraph{\@dottedtocline{4}{11.2em}{5em}}
		\renewcommand*\l@subparagraph{\@dottedtocline{5}{13.2em}{6em}}
		\else \fi     % 영문이면 가만히 내버려둠
		
		%%
		%% thebibliography 환경 재정의 - report 클래스로부터 복사하여 일부 수정
		%%
		\renewenvironment{thebibliography}[1]{%
			\chapter*{\bibname}%
			\@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
			\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{\bibname}%
			\list{\@biblabel{\@arabic\c@enumiv}}%
			{\settowidth\labelwidth{\@biblabel{#1}}%
				\leftmargin\labelwidth
				\advance\leftmargin\labelsep
				\@openbib@code
				\usecounter{enumiv}%
				\let\p@enumiv\@empty
				\renewcommand\theenumiv{\@arabic\c@enumiv}}%
			\sloppy
			\clubpenalty4000
			\@clubpenalty \clubpenalty
			\widowpenalty4000%
			\sfcode`\.\@m%
		}{  %% \label{paperlastpagelabel}    %  <-- 추가 부분: 마지막 페이지 위치 지정
		\def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
		\endlist
	}
	
	%%
	%% 한국식 날짜 표기 -> 영문식 날짜 표기
	%%
	\newcommand{\@dateUSenglish}[3]{%  % 미국식 날짜 표기
		\newcommand{\@year}{#1}%
		\newcommand{\@month}{#2}%
		\newcommand{\@day}{#3}%
		\ifcase\@month \or
		January \or February \or March \or April \or May \or June \or
		July \or August \or September \or October \or November \or December \fi
		\@day, \@year
	}
	\newcommand{\@dateBRenglish}[3]{%  % 영국식 날짜 표기
		\newcommand{\@year}{#1}%
		\newcommand{\@month}{#2}%
		\newcommand{\@day}{#3}%
		\@day\ifcase\@day \or
		st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or
		st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or
		st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or th\fi
		\space\ifcase\@month \or
		January\or February\or March\or April\or May\or June\or
		July\or August\or September\or October\or November\or December\fi,
		\@year
	}
