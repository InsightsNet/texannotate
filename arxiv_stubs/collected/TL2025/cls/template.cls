% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A new style for FAIR pre-prints
% Author: dlp@meta.com
% Version: 1.1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Class declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fairmeta}
\LoadClassWithOptions{article}

% Layout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[top=2.25cm, bottom=2.5cm, left=2.5cm, right=2.5cm, columnsep=0.65cm]{geometry}
\RequirePackage{microtype}
\RequirePackage{placeins}
\RequirePackage{hyphenat}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage[latin, english]{babel}
\RequirePackage{lipsum}
\RequirePackage{etoolbox}
\RequirePackage[colorlinks=true, allcolors=LARGBlue]{hyperref}


\DisableLigatures[f]{family=sf*} 

% Graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}
% \RequirePackage{subcaption}

% Tables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{booktabs}
\RequirePackage{nicematrix}
\RequirePackage{multirow}
\RequirePackage{bm}
\newcommand{\nm}[1]{#1}

% Colorful stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[most]{tcolorbox}
\RequirePackage{xcolor}
\definecolor{metablue}{HTML}{E2EFEF}
\definecolor{metafg}{HTML}{1C2B33}
\definecolor{metabg}{HTML}{F2FFFE}
\definecolor{metagreen}{HTML}{2E8B57} % SeaGreen
\definecolor{LightBlue}{HTML}{F3F9FE}    % 浅黄色
\definecolor{LARGBlue}{HTML}{4381BA}


% References %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}
% \hypersetup{
%   colorlinks,
%   linkcolor=metablue,
%   citecolor=metagreen,
%   urlcolor=metablue
% }

\RequirePackage[round,authoryear]{natbib}
\def\bibfont{\small}

% Section and caption format %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{titlesec}
\titleformat*{\paragraph}{\bfseries}
\titleformat*{\section}{\Large\sffamily\bfseries}
\titleformat*{\subsection}{\large\sffamily\bfseries}
\titleformat*{\subsubsection}{\normalsize\sffamily\bfseries}
\DeclareTextFontCommand{\textbf}{\bfseries\sffamily}

\RequirePackage{caption}
\DeclareCaptionLabelSeparator{custom}{}
\DeclareCaptionFormat{custom}{{\sffamily\textbf{#1 #2}} #3}
\captionsetup{singlelinecheck=false,format=custom,labelsep=custom,font=small}
\captionsetup[sub]{singlelinecheck=true,format=custom,labelsep=custom,font=small}

% Meta custom fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% http://c.caignaert.free.fr/Install-ttf-Font.pdf

\renewcommand*\ttdefault{cmvtt}
\RequirePackage[T1]{fontenc}

% \pdfmapline{+optimistic < assets/Optimistic.ttf <T1-WGL4.enc}
% \renewcommand{\sfdefault}{optimistic}

\DeclareFontFamily{T1}{optimistic}{}
\DeclareFontShape{T1}{optimistic}{m}{n}{<-> s * [0.88] assets/optimistic}{}
\DeclareFontShape{T1}{optimistic}{b}{n}{<-> s * [0.88] assets/optimistic}{}
\pdfmapline{+optimistic < assets/Optimistic.ttf <T1-WGL4.enc}
\renewcommand{\sfdefault}{optimistic}

% Authors, affiliations, infos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\addtolist[5][]{
  \begingroup
    \if\relax#3\relax\def\sep{}\else\def\sep{#5}\fi
    \let\protect\@unexpandable@protect 
    \xdef#3{\expandafter{#3}\sep #4[#1]{#2}}%
  \endgroup
}

\newcommand\authorlist{}
\newcommand\authorformat[2][]{{\sffamily \bfseries #2$^{#1}$}}
\renewcommand\author[2][]{\addtolist[#1]{#2}{\authorlist}{\authorformat}{, }}

\newcommand\affiliationlist{}
\newcommand\affiliationformat[2][]{{\normalsize $^{#1}$#2}}
\newcommand\affiliation[2][]{\addtolist[#1]{#2}{\affiliationlist}{\affiliationformat}{, }}

\newcommand\contributionlist{}
\newcommand\contributionformat[2][]{{\small $^{#1}$#2}}
\newcommand\contribution[2][]{\addtolist[#1]{#2}{\contributionlist}{\contributionformat}{, }}

\newcommand\metadatalist{}
\newcommand\metadataformat[2][]{{\small {\sffamily \bfseries #1:} #2}}
\newcommand\metadata[2][]{\addtolist[#1]{#2}{\metadatalist}{\metadataformat}{\par}}

\renewcommand{\abstract}[1]{\def\abstractlist{{\color{metafg} #1}}}
\newcommand{\email}[1]{\href{mailto:#1}{\texttt{#1}}}

\renewcommand\date[1]{\metadata[\faCalendar\ Date]{#1}}
% \renewcommand\code[1]{\metadata[Code]{#1}}
\newcommand\correspondence[1]{\metadata[Correspondence]{#1}}

% \renewcommand{\title}[1]{\newcommand{\titlelist}{{\LARGE\sffamily\bfseries #1}}}
% \renewcommand{\title}[1]{\newcommand{\titlelist}{{\LARGE\sffamily\bfseries\color{LARGBlue} #1}}}
\renewcommand{\title}[1]{%
  \newcommand{\titlelist}{{%
    \centering
    \LARGE\sffamily\bfseries\color{LARGBlue} #1%
  }}%
}

\newcommand{\beginappendix}{\appendix{\huge\sffamily Appendix\par}}

% Titlebox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\mymaketitle}{%
  \tcbset{enhanced,frame hidden}
  \tcbset{left=0.6cm}
  \tcbset{right=0.6cm}
  \tcbset{top=0.5cm}
  \tcbset{bottom=0.5cm}
  \tcbset{arc=10pt}
  \tcbset{colback=LightBlue}
  \tcbset{before skip=0pt}
  \tcbset{grow to left by=1.5pt}
  \tcbset{grow to right by=1.5pt}
  \tcbset{overlay={\node[
    anchor=south east,
    at= (frame.south east),
    xshift=-0.5cm,
    yshift=0.5cm] {};}}
  % 
  \begin{tcolorbox}
    \setlength{\parindent}{0cm}
    \setlength{\parskip}{0.5cm}
    {
      \setlength{\parskip}{0cm}
      \centering
      \nohyphens
      %
      {
        \setstretch{1.618}
        \titlelist\par
      }
      \vskip 0.3cm
      %
      \authorlist\par
      \vskip 0.3cm
      %
      \affiliationlist\par
      %
      \contributionlist\par
    }
    %
    \abstractlist\par
    
    \vskip -0.5cm
    
    {
      \setlength{\parskip}{0cm}
      \ifdefempty{\metadatalist}{\vspace*{0.65cm}}{\metadatalist\par}
    }
  \end{tcolorbox}
  \tcbset{reset}
  \FloatBarrier
}



% \newcommand{\mymaketitle}{%
%   \tcbset{enhanced,frame hidden}
%   \tcbset{left=0.5cm}
%   \tcbset{right=0.5cm}
%   \tcbset{top=0.5cm}
%   \tcbset{bottom=0.5cm}
%   \tcbset{arc=10pt}
%   \tcbset{colback=LightBlue}
%   \tcbset{before skip=0pt}
%   \tcbset{grow to left by=1.5pt}
%   \tcbset{grow to right by=1.5pt}
%   \tcbset{overlay={\node[
%     anchor=south east,
%     at= (frame.south east),
%     xshift=-0.5cm,
%     yshift=0.5cm] {};}}
%   % 
%   \begin{tcolorbox}
%     \setlength{\parindent}{0cm}
%     \setlength{\parskip}{0.5cm}
%     {
%       \setlength{\parskip}{0cm}
%       \raggedright
%       \nohyphens
%       %
%       {
%         \setstretch{1.618}
%         \titlelist\par
%       }
%       \vskip 0.2cm
%       %
%       \authorlist\par
%       \vskip 0.2cm
%       %
%       \affiliationlist\par
%       %
%       \contributionlist\par
%     }
%     %
%     \abstractlist\par
    
%     \vskip -0.5cm
    
%     {
%       \setlength{\parskip}{0cm}
%       \ifdefempty{\metadatalist}{\vspace*{0.65cm}}{\metadatalist\par}
%     }
%   \end{tcolorbox}
%   \tcbset{reset}
%   \FloatBarrier
% }

\if@twocolumn%
\renewcommand{\maketitle}{
\twocolumn[%
  \mymaketitle
  \vskip 0.38cm
]
}%
\else%
\renewcommand{\maketitle}{
  \mymaketitle
}%
\fi


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A new style for FAIR pre-prints
% Author: dlp@meta.com
% Version: 1.1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Class declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{fairmeta}
% \LoadClassWithOptions{article}

% % Layout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \RequirePackage[top=2.25cm, bottom=2.5cm, left=2.5cm, right=2.5cm, columnsep=0.65cm]{geometry}
% \RequirePackage{microtype}
% \RequirePackage{placeins}
% \RequirePackage{hyphenat}
% \RequirePackage{setspace}
% \RequirePackage{parskip}
% \RequirePackage[latin, english]{babel}
% \RequirePackage{lipsum}
% \RequirePackage{etoolbox}

% \DisableLigatures[f]{family=sf*} 

% % Graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \RequirePackage{graphicx}
% % \RequirePackage{subcaption}

% % Tables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \RequirePackage{booktabs}
% \RequirePackage{nicematrix}
% \RequirePackage{multirow}
% \RequirePackage{bm}
% \newcommand{\nm}[1]{#1}

% Colorful stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[most]{tcolorbox}
\RequirePackage{xcolor}
\definecolor{metablue}{HTML}{E2EFEF}
\definecolor{metafg}{HTML}{1C2B33}
\definecolor{metabg}{HTML}{F2FFFE}
\definecolor{metagreen}{HTML}{2E8B57} % SeaGreen
\definecolor{CalGoldHex}{HTML}{fff7e8}
\definecolor{TinaCrimson}{HTML}{DC143C} % Renamed from Crimson

% References %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}
% \hypersetup{
%   colorlinks,
%   linkcolor=metablue,
%   citecolor=metagreen,
%   urlcolor=metablue
% }

\RequirePackage[round,authoryear]{natbib}
\def\bibfont{\small}

% Section and caption format %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{titlesec}
\titleformat*{\paragraph}{\bfseries}
\titleformat*{\section}{\Large\sffamily\bfseries}
\titleformat*{\subsection}{\large\sffamily\bfseries}
\titleformat*{\subsubsection}{\normalsize\sffamily\bfseries}
\DeclareTextFontCommand{\textbf}{\bfseries\sffamily}

\RequirePackage{caption}
\DeclareCaptionLabelSeparator{custom}{}
\DeclareCaptionFormat{custom}{{\sffamily\textbf{#1 #2}} #3}
\captionsetup{singlelinecheck=false,format=custom,labelsep=custom,font=small}
\captionsetup[sub]{singlelinecheck=true,format=custom,labelsep=custom,font=small}

% Meta custom fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% http://c.caignaert.free.fr/Install-ttf-Font.pdf

\renewcommand*\ttdefault{cmvtt}
\RequirePackage[T1]{fontenc}

% \pdfmapline{+optimistic < assets/Optimistic.ttf <T1-WGL4.enc}
% \renewcommand{\sfdefault}{optimistic}

\DeclareFontFamily{T1}{optimistic}{}
\DeclareFontShape{T1}{optimistic}{m}{n}{<-> s * [0.88] assets/optimistic}{}
\DeclareFontShape{T1}{optimistic}{b}{n}{<-> s * [0.88] assets/optimistic}{}
\pdfmapline{+optimistic < assets/Optimistic.ttf <T1-WGL4.enc}
\renewcommand{\sfdefault}{optimistic}

% Authors, affiliations, infos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\addtolist[5][]{
  \begingroup
    \if\relax#3\relax\def\sep{}\else\def\sep{#5}\fi
    \let\protect\@unexpandable@protect 
    \xdef#3{\expandafter{#3}\sep #4[#1]{#2}}%
  \endgroup
}

% \newcommand\authorlist{}
% \newcommand\authorformat[2][]{{\sffamily \bfseries #2$^{#1}$}}
% \renewcommand\author[2][]{\addtolist[#1]{#2}{\authorlist}{\authorformat}{, }}

% \newcommand\affiliationlist{}
% \newcommand\affiliationformat[2][]{{\normalsize $^{#1}$#2}}
% \newcommand\affiliation[2][]{\addtolist[#1]{#2}{\affiliationlist}{\affiliationformat}{, }}

% \newcommand\contributionlist{}
% \newcommand\contributionformat[2][]{{\small $^{#1}$#2}}
% \newcommand\contribution[2][]{\addtolist[#1]{#2}{\contributionlist}{\contributionformat}{, }}

% \newcommand\metadatalist{}
% \newcommand\metadataformat[2][]{{\small {\sffamily \bfseries #1:} #2}}
% \newcommand\metadata[2][]{\addtolist[#1]{#2}{\metadatalist}{\metadataformat}{\par}}

% \renewcommand{\abstract}[1]{\def\abstractlist{{\color{metafg} #1}}}
% \newcommand{\email}[1]{\href{mailto:#1}{\texttt{#1}}}

% \renewcommand\date[1]{\metadata[\faCalendar\ Date]{#1}}
% % \renewcommand\code[1]{\metadata[Code]{#1}}
% \newcommand\correspondence[1]{\metadata[Correspondence]{#1}}

% \renewcommand{\title}[1]{\newcommand{\titlelist}{{\LARGE\sffamily\bfseries\color{TinaCrimson} #1}}}

% \newcommand{\beginappendix}{\appendix{\huge\sffamily Appendix\par}}

% Titlebox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% \newcommand{\mymaketitle}{%
%   \tcbset{enhanced,frame hidden}
%   \tcbset{left=0.5cm}
%   \tcbset{right=0.5cm}
%   \tcbset{top=0.5cm}
%   \tcbset{bottom=0.5cm}
%   \tcbset{arc=10pt}
%   \tcbset{colback=CalGoldHex}
%   \tcbset{before skip=0pt}
%   \tcbset{grow to left by=1.5pt}
%   \tcbset{grow to right by=1.5pt}
%   \tcbset{overlay={\node[
%     anchor=south east,
%     at= (frame.south east),
%     xshift=-0.5cm,
%     yshift=0.5cm] {};}}
%   % 
%   \begin{tcolorbox}
%     \setlength{\parindent}{0cm}
%     \setlength{\parskip}{0.5cm}
%     {
%       \setlength{\parskip}{0cm}
%       \raggedright
%       \nohyphens
%       %
%       {
%         \setstretch{1.618}
%         \titlelist\par
%       }
%       \vskip 0.2cm
%       %
%       \authorlist\par
%       \vskip 0.2cm
%       %
%       \affiliationlist\par
%       %
%       \contributionlist\par
%     }
%     %
%     \abstractlist\par
%     %
%     \vskip 0.5cm
%     %
%     {
%       \setlength{\parskip}{0cm}
%       \ifdefempty{\metadatalist}{\vspace*{0.65cm}}{\metadatalist\par}
%     }
%   \end{tcolorbox}
%   \tcbset{reset}
%   \FloatBarrier
% }

% \if@twocolumn%
% \renewcommand{\maketitle}{
% \twocolumn[%
%   \mymaketitle
%   \vskip 0.38cm
% ]
% }%
% \else%
% \renewcommand{\maketitle}{
%   \mymaketitle
% }%
% \fi


%%%%%%%%%
%
% Style file used by UC Berkeley RAIL folks.
% This is an edited version of the Google DeepMind tech report template, used under CC Licence, obtained from tex sources of Google DeepMind arxiv papers. There are several changes including font sizes, abstract formatting, title formatting, figure formatting, colors, and math fonts which are allowed per the license.
% 
%
% Use it in the following way, with the full set of option possible:
% \documentclass[11pt, a4paper, twocolumn, logo, copyright, nonumbering, 
% internal]{berkeley} 
%
% Options:
%    - 11pt: Sets the normal font size of the text. Can be only 10, 11, 12pt.
%    - a4paper: Paper size. Usually would not adjust.
%    - twocolumn: Makes the paper into two column mode; single column by default.
%    - logo: Adds the BAIR logo to the top left. No logo included if left out.
%    - copyright: Add a copyright statement to the first page of the paper in the left footnote
%    - nonumbering: Uses unnumbered sections.
%    - internal: for internal only docs that should not be shared externally. 
%           Can only use techreportnumber with this option.
%
% Date of Paper
%   The report is by default given the curren date in the top right. If you want to fix the 
%   date: add the date to your preamble with your own date as follows:
%   \renewcommand{\today}{1 January 2000}
%
% Confidentiality
%   Change the confidentiality statement for internal docs by adding this in the preable 
%   \renewcommand{\internal}{Confidential.}
%   
% ----------------
% Licence: This template is released under the Creative Commons licence 
% Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
%
%
% Known issues:
%   - Package todonotes does not work in the abstract
%
% Version history: 
% v0.1 - Jan 2024: Obtained from arxiv papers
% v0.2 - Feb 2024: revised some details
% %%%%%%%%%%%%%%%


% \NeedsTeXFormat{LaTeX2e}

% % Palatino font %%%%---- to switch to computer modern font, comment next three lines, and line 126
% \RequirePackage{tgpagella} % text only
% \RequirePackage{mathpazo}  % math & text
% \RequirePackage{inconsolata} % for tt font



% %%======== Pckage options and base class ========
% \RequirePackage{tcolorbox}
% \RequirePackage{xifthen}
% \newboolean{nonumbering}
% \newboolean{logo}
% \newboolean{address}
% \newboolean{copyright}
% \newboolean{internal}
% \DeclareOption{nonumbering}{\setboolean{nonumbering}{true}}
% \DeclareOption{logo}{\setboolean{logo}{false}}
% \DeclareOption{address}{\setboolean{address}{true}}
% \DeclareOption{copyright}{\setboolean{copyright}{true}}
% \DeclareOption{internal}{\setboolean{internal}{true}}
% \DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
% \ProcessOptions
% \LoadClass{extarticle}

% %%======== Packages Required ========
% % Fonts and language
% \AtEndOfClass{\RequirePackage[tracking=smallcaps]{microtype}}
% \RequirePackage[utf8]{inputenc}
% \RequirePackage[english]{babel}
% \RequirePackage{amsthm, amsmath, amsfonts, amssymb}
% \RequirePackage{cmap}
% \RequirePackage[T1]{fontenc}
% \RequirePackage{url}
% \RequirePackage{pifont}
% \RequirePackage{textcomp} % For copyright symbol styling
% \RequirePackage[overload]{textcase}
% %\RequirePackage{balance}
% %% *Graphics, tables and other formatting
% \RequirePackage{graphicx}
% \RequirePackage{colortbl}

% \RequirePackage{booktabs}
% \RequirePackage{changepage}
% \RequirePackage{enumitem} % For reducing bullet list item separation
% \RequirePackage{tabularx}
% \RequirePackage{datetime}
% % Headers and footers
% \RequirePackage{fancyhdr}  % custom headers/footers
% \RequirePackage{lastpage}  % Number of pages in the document
% % Lists and their spacing
% \RequirePackage{enumitem}
% \setlist[itemize]{noitemsep}
% \setlist[enumerate]{noitemsep}
% % % Title, Abstract, Bibliography
% \RequirePackage[explicit]{titlesec}
% \RequirePackage{bibentry}
% \RequirePackage{mdframed}
% \RequirePackage{caption}
% \RequirePackage{needspace}

% % \RequirePackage[svgnames]{xcolor}
% \definecolor{TinaCrimson}{HTML}{DC143C} % Renamed from Crimson
% % \definecolor{TinaCrimson}{HTML}{2A5487} % YaleBlue
% % \definecolor{YaleBlue}{HTML}{2A5487}
% % \RequirePackage[dvipsnames]{xcolor}
% % \definecolor{Crimson}{HTML}{990000}

% \definecolor{CalGoldHex}{HTML}{fff7e8}
% % \definecolor{CalGoldHex}{HTML}{FFF5E1}
% \definecolor{IronGrey}{HTML}{6D6E71}
% \definecolor{YaleBlue}{HTML}{2A5487}
% \definecolor{LARGBlue}{HTML}{4381BA}
% \definecolor{LightBlue}{HTML}{F3F9FE}    % 浅黄色
% \definecolor{DarkBlue}{HTML}{326A9D}     % 深黄色/金色


% \RequirePackage[colorlinks=true, allcolors=LARGBlue]{hyperref}

% %%======== Can use any of these fonts ========
% % \RequirePackage{charter}
% % \RequirePackage[scaled]{helvet}
% % \RequirePackage{bookman}
% % \RequirePackage{times}
% % \RequirePackage[default]{opensans} %fosfamily
% %\usepackage{antpolt}
% % Math fonts
% % \RequirePackage{mathpazo} % Palatino
% %\usepackage{euler} % for math fints

% % Use Bitstream Charter as the main font. Does not include a typewriter font.
% \RequirePackage{XCharter} %%%%---- to switch to computer modern font, comment this line, and lines 47-49
% % \RequirePackage[xcharter,bigdelims,vvarbb]{newtxmath}
% % \RequirePackage{libertine}
% % \RequirePackage{libertinust1math}
% % \RequirePackage[p]{zlmtt} % for teletype, lmodern's typewriter font


% % Use the typewriter font from lmodern, scaled up to match Charter's xheight.
% % You may wish to add the "p" option to use the proportional font instead of
% % the monospaced one, which might look nicer in cases where you do not need
% % aligned columns
% \RequirePackage[scaled=1.1]{zlmtt}
% % \RequirePackage{libertine}
% % \RequirePackage{libertinust1math}

% %%======== Margins and column spacing ========
% \RequirePackage[left=1.9cm,%
% right=1.9cm,%
% top=3cm,%
% bottom=2.5cm,%
% headheight=40pt,%
% headsep=20pt,%
% %showframe, % for testing
% letterpaper]{geometry}%
% \setlength{\columnsep}{15pt} % Distance between the two columns of text
% %\setlength{\parindent}{0pt}
% \setlength{\parskip}{0.5\baselineskip}

% %% *Custom font sizes and styles
% \newcommand{\watermarkfont}{\color{black50}\normalfont\fontsize{10}{12}\selectfont}
% \newcommand{\headerfont}{\color{LARGBlue}\normalfont\sffamily\fontsize{8}{10}\selectfont}
% % \newcommand{\titlefont}{\color{TinaCrimson}\normalfont\bfseries\fontsize{21}{23}\selectfont} %%%%---- title font/color
% % \newcommand{\titlefont}{\centering\color{LARGBlue}\normalfont\bfseries\fontsize{18}{20}\selectfont} %%%%---- title font/color
% \newcommand{\titlefont}{\centering\color{LARGBlue}\normalfont\fontsize{18}{22}\selectfont} %%%%---- title font/color
% \newcommand{\datesfont}{\normalfont\sffamily\itshape\fontsize{8}{10}\selectfont}
% \newcommand\urlheaderfont{\color{LARGBlue}\fontsize{8}{10}\selectfont}
% \newcommand{\absfont}{\linespread{1.1}\fontsize{10}{12}\color{black}\selectfont}
% \newcommand{\keywordstitlefont}{\bfseries\linespread{1.2}\fontsize{8}{10}\selectfont}
% \newcommand{\keywordsfont}{\itshape\linespread{1.2}\fontsize{11}{12}\selectfont}
% \newcommand{\copyrightfont}{\normalfont\fontsize{7}{9}\selectfont}
% \newcommand{\footerfont}{\color{black}\normalfont\fontsize{8}{10}\selectfont}
% \newcommand{\subjectfont}{\color{white}\bfseries\fontsize{10}{12}\selectfont}
% \newcommand{\headingfont}{\color{LARGBlue}\bfseries\fontsize{13}{14}\selectfont}

% \newcommand{\keywords}[1]{\def\@keywords{#1}}
% \newtoks\correspondingauthor
% \newtoks\paperurl
% \newtoks\reportnumber

% % Dates and Times for footer
% %\newdateformat{monthyeardate}{\THEDAY{ }\monthname[\THEMONTH] \THEYEAR}
% % ISO-8601 date format
% \newdateformat{monthyeardate}{\THEYEAR-\THEMONTH-\THEDAY}
% \setcounter{secnumdepth}{3}
% \ifthenelse{\boolean{nonumbering}}{\setcounter{secnumdepth}{0}}{}

% %%========  Author and affiliation ========
% \RequirePackage{authblk}
% \setcounter{Maxaffil}{0}
% \setlength{\affilsep}{0.2em}
% \renewcommand\Authfont{\centering\normalfont\bfseries\fontsize{10}{14}\selectfont}
% \renewcommand\Affilfont{\centering\normalfont\fontsize{10}{20}\selectfont}
% \makeatletter
% \renewcommand\AB@affilsepx{, \protect\Affilfont}
% \makeatother
% \renewcommand\Authands{, and }

% \newcommand{\internalonly}{}
% \newcommand{\copyrightext}{\footerfont \textcopyright\, \the\year{} }


% %%======== Header and Footer Content ========
% %
% % Header and Footer for the first page
% \pagestyle{fancy}   % Enables the custom headers/footers
% \fancypagestyle{firststyle}{
% 	\fancyhead[L]{
% 		\ifthenelse{\boolean{logo}}{
% 			% \includegraphics[width=90pt]{assets/berkeley_logo}
% 	 }{}
% }
% \fancyhead[R]{
% 	\ifdefined\paperurl
% 	\if\relax\the\paperurl\relax \else
% 		\href{\the\paperurl}{\urlheaderfont \itshape \the\paperurl}\\ \fi
% 	\else \fi
% 	{}
% }
% \fancyhead[C]{}
% \renewcommand{\headrulewidth}{0pt}
% \renewcommand{\footrulewidth}{1pt}
% %
% \fancyfoot[L]{
% 	\ifdefined\correspondingauthor
% 	\if\relax\the\correspondingauthor\relax
% 	\else \footerfont\itshape  {Corresponding author(s): \the\correspondingauthor \\} \fi
% 	\else \fi
%     \ifthenelse{\boolean{internal}}{\footerfont \internalonly \\}{\footerfont\bfseries\relax}
% 	\ifthenelse{\boolean{address}}{
% 		\itshape\footerfont UC Berkeley, Berkeley, California \\}{}
% 	\ifthenelse{\boolean{copyright}}{\copyrightext}{}
% }
% \fancyfoot[R]{
% 	\ifthenelse{\boolean{internal}}{
% 	\ifdefined\reportnumber
% 	\if\relax\the\reportnumber\relax
% 	\else \footerfont\itshape  {\footerfont \bfseries \the\reportnumber} \fi
% 	\else \fi
% 	}{\footerfont\bfseries\relax}
% }
% \fancyfoot[C]{\footerfont\bfseries\relax}}



% % Header and Footer for pages from 2 onwards
% \renewcommand{\footrulewidth}{0pt}
% \fancyhead[L,R]{}
% \makeatletter
% \newcommand\runningtitle[1]{\renewcommand\@runningtitle{#1}}
% \newcommand\@runningtitle{}
% \fancyhead[C]{\footerfont \@runningtitle} %%%%---- Running title
% \makeatother
% \fancyfoot[C]{}
% \fancyfoot[L]{
% 	\ifthenelse{\boolean{internal}}{\footerfont \internalonly\newline
% 		\ifdefined\reportnumber
% 		\if\relax\the\reportnumber\relax
% 		\else \footerfont {} \fi
% 		\else \fi}{\footerfont\bfseries\relax}
% }
% \fancyfoot[R]{\footerfont \thepage}

% % Header and footer rules (coloured).
% \renewcommand{\headrulewidth}{1pt}
% % \renewcommand{\footrulewidth}{1pt}
% \let\DefaultHeadRule\headrule
% \let\DefaultFootRule\footrule
% \renewcommand{\headrule}{\color{black}\DefaultHeadRule}
% \renewcommand{\footrule}{\textcolor{black}{\DefaultFootRule}}

% \tcbset{
%     titlebox/.style={
%         colback=LightBlue, % Background color of the box
%         colframe=LightBlue, % Border color of the box
%         boxrule=0.5mm, % Border thickness
%         arc=2mm,       % Rounded corners
%         auto outer arc,
%         left=5mm,      % Left padding
%         right=5mm,     % Right padding
%         top=5mm,       % Top padding
%         bottom=5mm,    % Bottom padding
%     }
% }


% % \tcbset{
% %     titlebox/.style={
% %         colback=LightBlue,  
% %         colframe=DarkBlue,  
% %         boxrule=0.5mm, % Border thickness
% %         arc=0mm,       % Rounded corners
% %         auto outer arc,
% %         leftrule=0pt,
% %         rightrule=0pt,
% %         left=5mm,      % Left padding
% %         right=5mm,     % Right padding
% %         top=5mm,       % Top padding
% %         bottom=5mm,    % Bottom padding
% %     }
% % }
% \renewenvironment{abstract}
% {\par\noindent\\  \ignorespaces}
% {\par\bigskip}


% %%========  Bibliography using bibtex ========


% \addto{\captionsenglish}{\renewcommand{\refname}{References}}
% \newcommand{\citeas}[1]{\Needspace*{8\baselineskip}\noindent\bibentry{#1}}
% % Uncomment the next line if you want the  numbered refs to be "1." instead of "[1]".
% %\makeatletter \renewcommand\@biblabel[1]{#1.} \makeatother

% %%======== Abstract and section formatting ========


% \def\xabstract{abstract}
% \long\def\abstract#1\end#2{\def\two{#2}\ifx\two\xabstract
% 	\long\gdef\theabstract{\ignorespaces#1}
% 	\def\go{\end{abstract}}\else
% \typeout{^^J^^J PLEASE DO NOT USE ANY \string\begin\space \string\end^^J
% 	COMMANDS WITHIN ABSTRACT^^J^^J}#1\end{#2}
% \gdef\theabstract{\vskip12pt BADLY FORMED ABSTRACT: PLEASE DO
% NOT USE {\tt\string\begin...\string\end} COMMANDS WITHIN
% THE ABSTRACT\vskip12pt}\let\go\relax\fi
% \go}

% % Define an environment with abstract content and styling
% \makeatletter
% \newcommand{\abscontent}{
% 	\noindent
% 	\parbox{\dimexpr\linewidth}{\absfont \theabstract}
% 	\@ifundefined{@keywords}{}{
% 		\vskip1em \noindent \keywordsfont  Keywords: \@keywords}
% }

% \newcommand{\HorRule}{\color{black}\rule{\textwidth}{1pt}} %

% \if@twocolumn%
% \renewcommand{\maketitle}{
% 	\twocolumn[
% 	\begin{adjustwidth}{0pt}{24pt}
% 		\begin{center}
% 			{
%                     % % \vskip-0.5cm
%                     % \HorRule
%                     \vskip5pt
% 				{\raggedright \titlefont
% 				\@title\par}%
% 				\vskip11pt
% 				{\raggedright \@author\par}
% 				\vskip-5pt%
%                     \HorRule
%                     \vskip10pt%
% 			}%
% 		\end{center}
% 	\end{adjustwidth}
% 		\abscontent
% 	\vskip20pt%
% 	]
% 	\thispagestyle{firststyle}
% }%
% \else% \@twocolumnfalse
% \renewcommand{\maketitle}
% {
% \vphantom{a}
% \vspace{-15mm}
% \begin{tcolorbox}[titlebox]
% \bgroup\setlength{\parindent}{0pt}
% 	\begin{adjustwidth}{0pt}{24pt}
% 		\begin{center}
% 			{
%                     \centering
%                     % \vskip-100pt
%                     % \HorRule
%                     \vskip5pt
% 				{\raggedright \titlefont \@title\par}% %%%%---- title definition
% 				\vskip11pt
% 				{\raggedright \@author\par}
%                     \vskip15pt%
% 			}%
% 		\end{center}
% 	\end{adjustwidth}
% 	\egroup
% 	{%
% 		{\abscontent}
% 	}%
% 	\thispagestyle{firststyle}
%  \end{tcolorbox}
% }%
% \fi
% \makeatother

% \titleformat{\section}
% {\large\bfseries\headingfont}
% {\thesection.}
% {0.5em}
% %{\MakeUppercase{#1}}[]
% {#1}
% []

% \titleformat{name=\section,numberless}
% {\large\bfseries\headingfont}
% {}
% {0em}
% %{\MakeUppercase{#1}}[]
% {#1}
% []
% \titleformat{\subsection}
% {\bfseries}
% {\thesubsection.}
% {0.5em}
% {#1}
% []
% \titleformat{\subsubsection}% [runin] If want to have inline for the subsubsect
% {\bfseries\itshape}
% {\thesubsubsection.}
% {0.5em}
% {#1}
% []


% \titlespacing*{\section}{0pc}{3ex plus4pt minus3pt}{5pt}
% %\titlespacing*{\section}{0pc}{1ex }{\baselineskip}
% \titlespacing*{\subsection}{0pc}{2.5ex plus3pt minus2pt}{2pt}
% \titlespacing*{\subsubsection}{0pc}{2ex plus2.5pt minus1.5pt}{2pt}
% %\titlespacing*{\paragraph}{0pc}{2ex plus2pt minus1pt}{0pt}

% %%======== Captions in tables and figures ========
% \DeclareCaptionLabelSeparator{pipe}{:~}% or $\vert$
% \captionsetup{labelfont={}, %{bf,sf},%
% labelsep=space,%
% figurename=\textbf{Figure},%
% labelsep=pipe,
% singlelinecheck=off,%
% %justification=centering
% }

