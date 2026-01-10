%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mgggarticle}[2014/08/16 Example class]

%%Preliminary definitions, needed by the options
\LoadClass{article}

%%This parts handles the options passed to the class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\RequirePackage{xcolor}
\RequirePackage{titling}
\RequirePackage{fancyhdr}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[tabular, light]{sourcesanspro}
\RequirePackage{PlayfairDisplay}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{hyperref}
\RequirePackage[default,light,bold]{sourceserifpro}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{mdframed}
\RequirePackage{caption}
\RequirePackage{setspace}
\RequirePackage[T1]{fontenc}
\RequirePackage{enumitem}
\RequirePackage[some, top]{background}


% Variables
\newcommand{\@version}{0.0}
\newcommand{\version}[1]{\renewcommand{\@version}{#1}}


% Lists
\setlist[itemize]{leftmargin=\parindent}

% Colors
\definecolor{mgggblue}{HTML}{0099cd}
\definecolor{mgggdarkblue}{HTML}{006b9c}
\newcommand{\headlinecolor}{\color{mgggblue}}
\definecolor{mgggdarkgray}{HTML}{666666}
\definecolor{mggggray}{HTML}{777777}
\definecolor{mggglightgray}{HTML}{f9f9f9}

% Links
\hypersetup{
    colorlinks=true,
    linkcolor=mgggdarkblue,
    urlcolor=mgggdarkblue,
    citecolor=mgggdarkblue
}

% Graphics path
\graphicspath{ {./} }

% Margins
\geometry{letterpaper, total={6in, 8.5in}}

% Fonts
% \renewcommand*\rmdefault{cm}
% \renewcommand*\rmdefault{
% \renewcommand*\familydefault{\sfdefault}

% Title color
\pretitle{\begin{center}\normalsize\color{mgggdarkblue}\begingroup\bfseries\playfair}
\posttitle{\endgroup\par\end{center}\vskip 0.1em}
%\pretitle{\begin{adjustwidth}{-2cm}%{-2cm}\normalsize\color{mgggdarkblue}\begingroup\bfseries\playfa%ir}
%\posttitle{\endgroup\end{adjustwidth}\vskip 0.1em}

% Header
\newcommand{\headertextcolor}{\color{mggggray}}
\newcommand{\headertext}{\sffamily\headertextcolor}

% Usual page style

\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}}
\lhead{\raisebox{-0.25\height}{\includegraphics[height=18pt]{logo/anp.png}}}
\chead{}
\rhead{{\headertext\rightmark}}
\lfoot{}
\lfoot{}
\cfoot{}
\rfoot{{\headertext\thepage}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
% \addtolength{\headwidth}{\marginparsep}
% \addtolength{\headwidth}{\marginparwidth}
% \fancyhfoffset[L,R]{0.4\marginparsep+0.4\marginparwidth}
\fancyhfoffset[L,R]{3.5in - .5\textwidth}
\setlength{\footskip}{30pt}
\setlength{\headheight}{30pt}
 \renewcommand{\headrule}{\hbox to\headwidth{%
    \headertextcolor\leaders\hrule height \headrulewidth\hfill}} 


% Title page style

\fancypagestyle{plain}{%
\chead{}
\lhead{}
\rhead{}
\lfoot{{\headertext Version {\@version} \hspace{.5em} | \hspace{.5em} \thedate}}
\cfoot{}
\rfoot{}
\renewcommand{\headrulewidth}{0pt}
\setlength{\headheight}{12pt}
}


\fancypagestyle{decoratedsection}{%
\renewcommand{\headrulewidth}{0pt}
\chead{}
\lhead{}
\rhead{}
\lfoot{}
\cfoot{}
\rfoot{\headertext\thepage}
\setlength{\headheight}{0pt}
}

% Headings
\newcommand{\sectionnumberfont}{\sffamily\color{mgggdarkblue}}
\titleformat{\section}{\Large\playfair\bfseries}{{\sectionnumberfont\thesection}}{1em}{}
\titleformat{\subsection}{\large\playfair}{{\sectionnumberfont\thesubsection}}{1em}{}
% \titleformat{\chapter}{\Huge\playfair\bfseries}{{\sectionnumberfont\thechapter}}{1em}{}
% \titleformat{\paragraph}[runin]{\bfseries}{}{}{}

\mdfdefinestyle{decoratedsection}{%
    backgroundcolor=mggglightgray,
    topline=true,
    bottomline=true,
    rightline=false,
    leftline=false,
    innertopmargin=1em,
    innerbottommargin=1em,
    innerrightmargin=1.5in,
    innerleftmargin=1.5in,
    leftmargin=-1.5in,
    rightmargin=-1.5in,
    linecolor=mgggdarkblue,
    linewidth=0.4pt
}

\newcommand\decoratedsection[1]{%
    \newpage
    \thispagestyle{decoratedsection}
    \begin{mdframed}[style=decoratedsection]
    \section{#1}
    % \noindent {\color{mgggdarkblue} \rule{\textwidth}{1.2pt}}
    \end{mdframed}
    \vskip 1em
}


% Sans-serif option:
% \titleformat{\section}{\Large\sffamily}{\thesection.}{.5em}{}
% \titleformat{\subsection}{\large\sffamily}{\thesubsection.}{.5em}{}

% Table of Contents
% \newcommand{\toccolor}{\color{mgggdarkblue}}
% \renewcommand{\cfttoctitlefont}{\Large\sffamily}
% % \renewcommand{\cftchapfont}{\sffamily\toccolor}
% % \renewcommand{\cftchappagefont}{\sffamily\toccolor}
% \renewcommand{\cftsecfont}{\sffamily\toccolor}
% \renewcommand{\cftsubsecfont}{\sffamily\toccolor}
% \renewcommand{\cftsubsubsecfont}{\sffamily\toccolor}
% \renewcommand{\cftsecpagefont}{\sffamily\toccolor}
% \renewcommand{\cftsubsecpagefont}{\sffamily\toccolor}
% \renewcommand{\cftsubsubsecpagefont}{\sffamily\toccolor}
% \setlength{\cftaftertoctitleskip}{1em}
% \setlength{\cftbeforetoctitleskip}{1.5em}
\newcommand{\toccolor}{\color{black}}
\renewcommand{\cfttoctitlefont}{\Large\sffamily}

% 设置目录各级标题字体为黑色无衬线
\renewcommand{\cftsecfont}{\sffamily\color{black}}
\renewcommand{\cftsubsecfont}{\sffamily\color{black}}
\renewcommand{\cftsubsubsecfont}{\sffamily\color{black}}

% 设置对应页码字体也为黑色无衬线
\renewcommand{\cftsecpagefont}{\sffamily\color{black}}
\renewcommand{\cftsubsecpagefont}{\sffamily\color{black}}
\renewcommand{\cftsubsubsecpagefont}{\sffamily\color{black}}

% 控制 TOC 标题的上下间距
\setlength{\cftaftertoctitleskip}{1em}
\setlength{\cftbeforetoctitleskip}{1.5em}

% Line spacing
\setlength{\parskip}{0.5em}
\linespread{1.1}

% Abstract
\mdfdefinestyle{abstract}{%
    backgroundcolor=mggglightgray,
    hidealllines=true,
    innertopmargin=1em,
    innerbottommargin=1em,
    innerrightmargin=1em,
    innerleftmargin=1em
    leftmargin=.2\textwidth
    rightmargin=.2\textwidth
}
\renewenvironment{abstract}{%
    \begin{mdframed}[style=abstract]
    {\sffamily\Large Abstract}
    \par\noindent\ignorespaces
}{\ignorespacesafterend\end{mdframed}}

% Footnotes
\renewcommand{\footnoterule}{%
    \vskip 1.5em
    \kern -3pt
    {\color{mgggdarkgray} \hrule width \textwidth height 0.4pt}
    \kern 2.6pt
}
\setlength{\footnotesep}{1em}


% Title
\newcommand{\authorfont}{\sffamily\large\color{mgggdarkgray}}
\renewcommand{\maketitle}{%
% \BgThispage
\begin{center}
\vskip 1.5em
{\noindent\huge\playfair\bfseries\color{mgggdarkblue}\@title}
\vskip 1.5em
\includegraphics[width=3in]{logo/agentic-web3_logo.png}
\vskip 1.5em
{\authorfont \@author}
\end{center}
\vskip 1.5em
}


% Captions
\captionsetup{%
    format=plain,
    labelfont={sf, bf, color=mgggdarkblue},
    labelsep=period,
    % textfont={color=mgggdarkgray},
    margin=0.5em
}

% Contributors
\newenvironment{contributors}{%
    \vskip 1em
    \begin{mdframed}[style=abstract]
    {\sffamily\Large Contributors}
    \par\noindent\ignorespaces
}{\ignorespacesafterend\end{mdframed}}
