%%
%% This is file `agh-wi.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% agh-wi.dtx  (with options: `class')
%% ----------------------------------------------------------------
%% agh-wi --- Diploma thesis template for students of the Pracaulty of Computer Science of the AGH University of Krakow
%% email: polak[aT]agh[DoT]edu[DoT]pl
%% GitHub: https://github.com/polaksta
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% ----------------------------------------------------------------
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\fileversion{1.3.2}
\def\filedate{2024/06/13}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{agh-wi}[\filedate\space v\fileversion\space Diploma thesis at WI AGH Kraków, Poland]

\typeout{..................................................................}
\typeout{You are using the 'agh-wi' class created by Stanisław Polak}
\typeout{Version: \fileversion, \filedate}
\typeout{..................................................................}
\newif\ifenglish
\newif\ifprint
\def\fieldOfStudy{Data Science}
\DeclareOption{english}{\englishtrue}
\DeclareOption{print}{\printtrue}
\DeclareOption{ds}{\def\fieldOfStudy{Data Science}}
\DeclareOption{umisi}{\def\fieldOfStudy{Informatyka --- Uczenie Maszynowe i Sztuczna Inteligencja}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessOptions\relax
\LoadClass[appendixprefix=true, numbers=enddot]{scrbook}
\RequirePackage{tikz}
\RequirePackage{scrlayer-scrpage}
\ifprint
    \KOMAoptions{fontsize=12pt, DIV=14, BCOR=2cm, automark, headsepline, footsepline, plainfootsepline,toc=listof, toc=bib}
\else
    \KOMAoptions{fontsize=12pt, DIV=14, automark, headsepline, footsepline, plainfootsepline, toc=listof, toc=bib}
\fi
\ifenglish
    \RequirePackage[main=english,polish]{babel}
\else
    \RequirePackage[main=polish,english]{babel}
\fi
\RequirePackage{indentfirst}
\AtBeginDocument{
    \@ifpackageloaded{hyperref}{
        \ifprint
            \hypersetup{hidelinks}
        \else
            \hypersetup{
                colorlinks=true,
linktocpage=true,
                linkcolor=blue,
                filecolor=magenta,
                urlcolor=cyan
            }
        \fi
    }{}
    % \@ifpackageloaded{algorithm2e}{
        % \ifenglish\else
        %     \renewcommand{\listalgorithmcfname}{Lista algorytmów}%
        %     \renewcommand{\algorithmcfname}{Algorytm}%
        % \fi
    % }{}
    % \@ifpackageloaded{minted}{
    %     \@ifpackagewith{minted}{newfloat}{
            % \ifenglish\else
            %     \SetupFloatingEnvironment{listing}{name=Kod źródłowy}
            %     \SetupFloatingEnvironment{listing}{listname=Lista kodów źródłowych}
            % \fi
            % \setminted{
            %     linenos,
            %     frame=single
            % }
    %     }
    %     {
    %         \@latex@error{The 'minted' package must be loaded with the 'newfloat' option}\@ehc
    %     }
    % }{}
    % \@ifpackageloaded{listings}{
    %     \lstset{
    %         showstringspaces=false,
    %         numbers=left,
    %         stepnumber=1,
    %         numbersep=5pt,
    %         showspaces=false,
    %         showtabs=false,
    %         frame=single,
    %         tabsize=2,
    %         captionpos=t,
    %         breaklines=true,
    %         breakatwhitespace=false,
    %         keywordstyle=\ttfamily\color{blue},
    %         identifierstyle=\ttfamily\color{violet}\bfseries,
    %         commentstyle=\color{brown},
    %         stringstyle=\ttfamily,
    %         inputencoding=utf8,
    %         literate={ą}{{\k{a}}}1
    %                  {Ą}{{\k{A}}}1
    %                  {ę}{{\k{e}}}1
    %                  {Ę}{{\k{E}}}1
    %                  {ó}{{\'o}}1
    %                  {Ó}{{\'O}}1
    %                  {ś}{{\'s}}1
    %                  {Ś}{{\'S}}1
    %                  {ł}{{\l{}}}1
    %                  {Ł}{{\L{}}}1
    %                  {ż}{{\.z}}1
    %                  {Ż}{{\.Z}}1
    %                  {ź}{{\'z}}1
    %                  {Ź}{{\'Z}}1
    %                  {ć}{{\'c}}1
    %                  {Ć}{{\'C}}1
    %                  {ń}{{\'n}}1
    %                  {Ń}{{\'N}}1
    % }
    % \ifenglish
    %     \renewcommand{\lstlistlistingname}{List of Listings}
    % \else
    %     \renewcommand{\lstlistingname}{Kod źródłowy}%
    %     \renewcommand{\lstlistlistingname}{Lista kodów źródłowych}
    % \fi
    % }{}
}
\definecolor{AGH@black}{RGB}{30,30,30}
\definecolor{AGH@red}{RGB}{167,25,48}
\definecolor{AGH@green}{RGB}{0,105,60}

\def\@titlePL{\@latex@error{No \noexpand\titlePL given}\@ehc}
\def\@titleEN{\@latex@error{No \noexpand\titleEN given}\@ehc}
\def\@author{\@latex@error{No \noexpand\author given}\@ehc}
\def\@supervisor{\@latex@error{No \noexpand\supervisor given}\@ehc}
\def\@cosupervisor{\@latex@error{No \noexpand\cosupervisor given}\@ehc}

\ifenglish
    \title{\@titleEN}
\else
    \title{\@titlePL}
\fi
\def\logoscale {1.000000}
\tikzset {
    % AGH logo
    logoAGH/.pic= {
            \begin{tikzpicture}[y=1cm, x=1cm, yscale=\logoscale,xscale=\logoscale, every node/.append style={scale=\logoscale}, inner sep=0pt, outer sep=0pt]
                \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(0.0, 6.288)}]
                    \begin{scope}[shift={(-0.425\textwidth,10)}]
                        \path[fill=AGH@black,nonzero rule] (7.2964, -4.8072) -- (7.184, -4.8072) -- (7.2394, -4.9752) -- (7.2964, -4.8072) -- cycle(7.3638, -4.6082) -- (7.5038, -4.6082).. controls (7.5038, -4.6082) and (7.3489, -5.044) .. (7.3488, -5.0441).. controls (7.3314, -5.0931) and (7.2939, -5.1006) .. (7.2818, -5.1006) -- (7.1465, -5.1006).. controls (7.1673, -5.0837) and (7.1745, -5.0726) .. (7.1745, -5.0556).. controls (7.1745, -5.0453) and (7.1722, -5.0374) .. (7.1609, -5.004) -- (7.0269, -4.6082) -- (7.1184, -4.6082) -- (7.1589, -4.731) -- (7.3222, -4.731) -- (7.3638, -4.6082) -- cycle;
                        \path[fill=AGH@black,nonzero rule] (7.9315, -4.678) -- (7.9315, -4.8351).. controls (7.9315, -4.8651) and (7.9251, -4.8805) .. (7.9038, -4.8995) -- (8.0049, -4.8995).. controls (8.0362, -4.8995) and (8.0629, -4.8742) .. (8.0629, -4.8422) -- (8.0629, -4.6193).. controls (8.0135, -4.6048) and (7.9634, -4.5968) .. (7.9177, -4.5968).. controls (7.7427, -4.5968) and (7.6317, -4.6989) .. (7.6317, -4.8499).. controls (7.6317, -4.9974) and (7.7429, -5.1123) .. (7.9201, -5.1123).. controls (7.9604, -5.1123) and (7.9987, -5.1052) .. (8.0335, -5.0927) -- (8.0335, -4.9941).. controls (8.0023, -5.0146) and (7.963, -5.0269) .. (7.9201, -5.0269).. controls (7.8351, -5.0269) and (7.7682, -4.9683) .. (7.7682, -4.8601).. controls (7.7682, -4.7454) and (7.8189, -4.6751) .. (7.9003, -4.6751).. controls (7.9105, -4.6751) and (7.9206, -4.6758) .. (7.9315, -4.678);
                        \path[fill=AGH@black,nonzero rule] (8.4136, -5.037).. controls (8.4136, -5.0722) and (8.3858, -5.1006) .. (8.3517, -5.1006) -- (8.2537, -5.1006).. controls (8.275, -5.0817) and (8.2814, -5.0662) .. (8.2814, -5.0362) -- (8.2814, -4.6082) -- (8.4136, -4.6082) -- (8.4136, -4.8153) -- (8.5639, -4.8153) -- (8.5639, -4.6082) -- (8.6957, -4.6082) -- (8.6957, -5.0992) -- (8.5639, -5.0992) -- (8.5639, -4.8988) -- (8.4136, -4.8988) -- (8.4136, -5.037) -- cycle;
                        \path[fill=AGH@red,nonzero rule] (8.217, -5.4289).. controls (8.3264, -5.5041) and (8.4221, -5.6204) .. (8.4221, -5.8666) -- (8.4221, -7.3439) -- (8.5315, -7.3439) -- (8.5315, -5.8666).. controls (8.5315, -5.5931) and (8.3948, -5.4836) .. (8.217, -5.4289);
                        \path[fill=AGH@red,nonzero rule] (8.3059, -5.4289).. controls (8.4085, -5.4768) and (8.5863, -5.5657) .. (8.5863, -5.8666) -- (8.5863, -7.3439) -- (8.6957, -7.3439) -- (8.6957, -5.8666).. controls (8.6957, -5.4973) and (8.4085, -5.4426) .. (8.3059, -5.4289);
                        \path[fill=AGH@red,nonzero rule] (8.1486, -5.4289).. controls (8.2302, -5.511) and (8.258, -5.6751) .. (8.258, -5.894) -- (8.258, -7.3439) -- (8.3674, -7.3439) -- (8.3674, -5.8666).. controls (8.3674, -5.6211) and (8.2853, -5.4973) .. (8.1486, -5.4289);
                        \path[fill=AGH@black,nonzero rule] (7.6151, -7.8363).. controls (7.7246, -7.7611) and (7.8203, -7.6448) .. (7.8203, -7.3986) -- (7.8203, -5.7025) -- (7.9297, -5.7025) -- (7.9297, -7.3986).. controls (7.9297, -7.6722) and (7.7929, -7.7816) .. (7.6151, -7.8363);
                        \path[fill=AGH@black,nonzero rule] (7.7041, -7.8363).. controls (7.8067, -7.7885) and (7.9845, -7.6996) .. (7.9845, -7.3986) -- (7.9845, -5.7025) -- (8.0939, -5.7025) -- (8.0939, -7.3986).. controls (8.0939, -7.7679) and (7.8067, -7.8227) .. (7.7041, -7.8363);
                        \path[fill=AGH@black,nonzero rule] (7.5467, -7.8363).. controls (7.6284, -7.7543) and (7.6561, -7.5901) .. (7.6561, -7.3713) -- (7.6561, -5.7025) -- (7.7656, -5.7025) -- (7.7656, -7.3986).. controls (7.7656, -7.6441) and (7.6835, -7.7679) .. (7.5467, -7.8363);
                        \path[fill=AGH@green,nonzero rule] (7.5331, -5.4289).. controls (7.4236, -5.5041) and (7.3279, -5.6204) .. (7.3279, -5.8666) -- (7.3279, -7.3439) -- (7.2184, -7.3439) -- (7.2184, -5.8666).. controls (7.2184, -5.5931) and (7.3552, -5.4836) .. (7.5331, -5.4289);
                        \path[fill=AGH@green,nonzero rule] (7.4441, -5.4289).. controls (7.3415, -5.4768) and (7.1637, -5.5657) .. (7.1637, -5.8666) -- (7.1637, -7.3439) -- (7.0542, -7.3439) -- (7.0542, -5.8666).. controls (7.0542, -5.4973) and (7.3415, -5.4426) .. (7.4441, -5.4289);
                        \path[fill=AGH@green,nonzero rule] (7.6015, -5.4289).. controls (7.5198, -5.511) and (7.492, -5.6751) .. (7.492, -5.894) -- (7.492, -7.3439) -- (7.3826, -7.3439) -- (7.3826, -5.8666).. controls (7.3826, -5.6211) and (7.4647, -5.4973) .. (7.6015, -5.4289);
                    \end{scope}
                \end{scope}
            \end{tikzpicture}
        }
}
\newcommand{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand{\cosupervisor}[1]{\gdef\@cosupervisor{#1}}
\newcommand{\titlePL}[1]{\gdef\@titlePL{#1}}
\newcommand{\titleEN}[1]{\gdef\@titleEN{#1}}
\renewcommand\maketitle{
    \KOMAoptions{twoside = false}
    \begin{titlepage}
        \centering
        \tikz[overlay,transform shape,transform canvas,x=0.80pt,y=0.80pt,yscale=-1.000000]
        \path pic {logoAGH};\par
        \vspace*{3\baselineskip}%
        {    \bfseries\large
            Akademia Górniczo-Hutnicza
            im. Stanisława Staszica
            w Krakowie
        }\par
        \vspace*{\baselineskip}%
        {
            \large Faculty of Computer Science
        }\par
        \vspace*{3\baselineskip}%
        {
            \scshape\Large Master's thesis
        }\par
        \vspace*{3\baselineskip}%
        {\sffamily\Large\bfseries \@title}\par%
        \vspace*{\baselineskip}%
        \ifenglish
        {\selectlanguage{polish}\sffamily\small\bfseries \@titlePL}\par%
        \else
        {\selectlanguage{english}\sffamily\small\bfseries \@titleEN}\par%
        \fi
        \vfill
        \par
        \begin{tabular}{ll}
            Author:         & {\bfseries
            \begin{tabular}[t]{c}
                        \@author
                    \end{tabular}}        \\[0.8mm]
            Field of study:      & {\bfseries
            \begin{tabular}[t]{c}
                        \fieldOfStudy
                    \end{tabular}}        \\[0.8mm]
            Supervisor: & {\bfseries
            \begin{tabular}[t]{c}
                        \@supervisor
                    \end{tabular}}        \\[0.8mm]
            Co-supervisor: & {\bfseries
            \begin{tabular}[t]{c}
                        \@cosupervisor
                    \end{tabular}}        \\[0.8mm]
        \end{tabular}
        \par
        \vspace*{3\baselineskip}%
        \centering Kraków, \the\year
    \end{titlepage}%
    \KOMAoptions{twoside = true}
}
\newenvironment{abstractPL}{%
    \titlepage
    \null\vfil
    \@beginparpenalty\@lowpenalty
    \begin{center}%
        \bfseries Streszczenie
        \@endparpenalty\@M
    \end{center}}%
{\par\vfil\null\endtitlepage}
\newenvironment{abstractEN}{%
    \titlepage
    \null\vfil
    \@beginparpenalty\@lowpenalty
    \begin{center}%
        \bfseries Abstract
        \@endparpenalty\@M
    \end{center}}%
{\par\vfil\null\endtitlepage}
\newcommand*{\tocchapapp}{}
\newcommand*{\appendixmore}{
    \addtocontents{\csname ext@toc\endcsname}{
        \string\DeclareTOCStyleEntry[numwidth+=5em,
            entrynumberformat=\string\appendixprefixformat]{chapter}{chapter}
    }
}
\newcommand*{\appendixprefixformat}[1]{\appendixname\space#1}
%% 
%% Copyright (C) 2024 by Stanisław Polak <polak[aT]agh[DoT]edu[DoT]pl>
%% 
%% This work may be distributed and/or modified under the conditions of the LaTeX
%% Project Public License (LPPL), either version 1.3c of this license or (at your
%% option) any later version. The latest version of this license is in the file:
%% 
%% http://www.latex-project.org/lppl.txt
%% 
%% This work is "maintained" (as per LPPL maintenance status) by
%% Stanisław Polak.
%% This work consists of the file
%% agh-wi.dtx
%% and the derived files
%% agh-wi.ins,
%% agh-wi.cls,
%% agh-wi.pdf,
%% bibliography.bib, and
%% example.tex.
%% 
%%
%% End of file `agh-wi.cls'.