%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         epl2.cls is a LaTeX document class for the EPLA journal         %%
%%                                                                         %%
%%                          %%  EPL  %%                                    %%
%%                                                                         %% 
%%                usage: \documentclass[options]{epl2}                     %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% marco 2006-10-25
%%
%% version: 1.0.a, 1.1
%%
%% modified and upgraded by Marco Bellacosa
%% contact: marco@sif.it, europhys@sif.it, http://www.sif.it
%%



%% mala 2006-05-31
%%
%% version: 0.0.a
%%
%% written from scratch by S. Frabetti
%% on behalf of the Italian Physical Society, http://www.sif.it/
%% based on article.cls 2001/04/21 v1.4e
%%

%%
%% identification
%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{epl2}[2006/05/31 v0.1 Europhysics Letters 2 class]


% $Id: epl2-authors.cls,v 1.10 2010/10/05 12:29:20 marco Exp $


%%
%% constants
%%
\def\epl@shortname{epl}
\def\epl@copyrighter{EPLA}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{REFERENCES}
\newcommand\indexname{Index}
\newcommand\figurename{Fig.}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}

%%
%% flags
%%
\newif\ifepl@cite\epl@citefalse
\newif\ifepl@bm\epl@bmfalse
\newif\ifepl@graphicx\epl@graphicxfalse
\newif\ifepl@figures\epl@figuresfalse
\newif\ifepl@reply\epl@replyfalse
\newif\ifepl@comment\epl@commentfalse
\newif\ifepl@noabstr\epl@noabstrfalse

%% [marco]
\newif\ifepl@dedication\epl@dedicationfalse

%%
%% styles support
%%
%% [marco]
\def\doublecol{doublecol}
\def\orcish{orcish}
\def\tight{tight}
\def\ugly{ugly}
\def\pretty{pretty}
\def\headleft{head-left}
\def\headcentre{head-centre}
\def\headclassic{head-classic}
\def\pageid{page-id}
\def\pageclassic{page-classic}

%% [marco]
\def\epl@stylemark{%
  \hbox to0pt{%
    \hskip0em
    \vbox to 0pt{%
     \vss
      \hbox{\sffamily\huge
	\textbf{epl draft} %
      }%
       \vskip6ex
    }%
    \hss
  }%
}
%%
%% options
%%

%% [marco]
\DeclareOption{doublecol}{\@twocolumntrue\let\epl@styleC\doublecol}
\DeclareOption{orcish}{\@twocolumnfalse\let\epl@styleC\orcish}
\DeclareOption{tight}{\@twocolumnfalse\let\epl@styleC\tight}
\DeclareOption{ugly}{\let\epl@styleA\ugly}
\DeclareOption{pretty}{\let\epl@styleA\pretty}
\DeclareOption{left}{\let\epl@styleB\headleft}
\DeclareOption{centre}{\let\epl@styleB\headcentre}
\DeclareOption{classic}{\let\epl@styleB\headclassic}
\DeclareOption{pageid}{\let\epl@stylepage\pageid}
\DeclareOption{pageclassic}{\let\epl@stylepage\pageclassic}
\DeclareOption{cite}{\epl@citetrue}
\DeclareOption{nocite}{\epl@citefalse}
\DeclareOption{bm}{\epl@bmtrue}
\DeclareOption{nobm}{\epl@bmfalse}
\DeclareOption{graphicx}{\epl@graphicxtrue}
\DeclareOption{nographicx}{\epl@graphicxfalse}
\DeclareOption{figures}{\epl@figurestrue\epl@graphicxtrue}
\DeclareOption{nofigures}{\epl@figuresfalse}
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
%\DeclareOption{onecolumn}{\@twocolumnfalse}
%\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{reply}{%
  \epl@replytrue
  \epl@noabstrtrue
}
\DeclareOption{comment}{%
  \epl@commenttrue
  \epl@noabstrtrue
}


\@twosidetrue\@mparswitchtrue % [mala] was option twoside
\ExecuteOptions{a4paper,draft,cite,bm,graphicx,tight,ugly,left,pageid}
\ProcessOptions

%%
%% modules
%%
\RequirePackage{color}
\newcommand{\revision}[1]{{\color{red}{#1}}}

\ifepl@graphicx
  \RequirePackage{graphicx}
\fi
\ifepl@bm
  \RequirePackage{bm}
\else
  \let\bm\mathbf
\fi
\ifepl@cite
  \RequirePackage{cite}%
  \renewcommand{\citeleft}{\bgroup\normalfont[}%
  \renewcommand{\citeright}{]\egroup}%
\fi

%%%
%%% from size10.clo
%%%

%%
%% font sizes
%%
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\newcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\footnotesize{%
   \@setfontsize\footnotesize\@viiipt{9.5}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}
\newcommand\Large{\@setfontsize\Large\@xivpt{18}}
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\newcommand\huge{\@setfontsize\huge\@xxpt{25}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

%%
%% misc parameters
%%
\if@twocolumn
  \setlength\parindent{1em}
\else
  \setlength\parindent{15\p@}
\fi
\setlength\smallskipamount{3\p@ \@plus 1\p@ \@minus 1\p@}
\setlength\medskipamount{6\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\bigskipamount{12\p@ \@plus 4\p@ \@minus 4\p@}
\setlength\headheight{12\p@}
\setlength\headsep   {24\p@}
\setlength\topskip   {10\p@}
\setlength\footskip{30\p@}
\setlength\maxdepth{.5\topskip}

%%
%% textwidth and textheight
%%
\ifx\epl@styleC\doublecol
  \setlength\textwidth{180mm}
  \setlength\textheight{56\baselineskip}
\fi
\ifx\epl@styleC\orcish
  \setlength\textwidth{180mm}
  \setlength\textheight{56\baselineskip}
\fi
\ifx\epl@styleC\tight
  \setlength\textwidth{140mm}
  \setlength\textheight{52\baselineskip}
\fi
\@settopoint\textwidth
\addtolength\textheight{\topskip}

%%
%% calculating marginpars parameters (and sidemargins?)
%%
\if@twocolumn
 \setlength\marginparsep {10\p@}
\else
  \setlength\marginparsep{11\p@}
\fi
\setlength\marginparpush{5\p@}
%
\setlength\@tempdima        {\paperwidth}
\addtolength\@tempdima      {-\textwidth}
\setlength\oddsidemargin    {.4\@tempdima}
\addtolength\oddsidemargin  {-1in}
\setlength\marginparwidth   {.6\@tempdima}
\addtolength\marginparwidth {-\marginparsep}
\addtolength\marginparwidth {-0.4in}
\ifdim \marginparwidth >2in
   \setlength\marginparwidth{2in}
\fi
\@settopoint\oddsidemargin
\@settopoint\marginparwidth
%
\setlength\evensidemargin  {\paperwidth}
\addtolength\evensidemargin{-2in}
\addtolength\evensidemargin{-\textwidth}
\addtolength\evensidemargin{-\oddsidemargin}
\@settopoint\evensidemargin
%
\setlength\topmargin{\paperheight}
\addtolength\topmargin{-2in}
\addtolength\topmargin{-\headheight}
\addtolength\topmargin{-\headsep}
\addtolength\topmargin{-\textheight}
\addtolength\topmargin{-\footskip}     % this might be wrong!
\addtolength\topmargin{-.5\topmargin}
\@settopoint\topmargin
%
\setlength\footnotesep{6.65\p@}
\setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep   {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
\def\@listi{\leftmargin\leftmargini
            \parsep 4\p@ \@plus2\p@ \@minus\p@
            \topsep 8\p@ \@plus2\p@ \@minus4\p@
            \itemsep4\p@ \@plus2\p@ \@minus\p@}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    4\p@ \@plus2\p@ \@minus\p@
              \parsep    2\p@ \@plus\p@  \@minus\p@
              \itemsep   \parsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    2\p@ \@plus\p@\@minus\p@
              \parsep    \z@
              \partopsep \p@ \@plus\z@ \@minus\p@
              \itemsep   \topsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}
%%/
%%/ end of size10.clo
%%/

%%
%% misc parameters
%%
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301

%%
%% stretching
%%
\newlength{\epl@stretchminskip}\setlength{\epl@stretchminskip}{1.5pt}
\newlength{\epl@stretchmedskip}\setlength{\epl@stretchmedskip}{3pt}
\newlength{\epl@stretchmaxskip}\setlength{\epl@stretchmaxskip}{6pt}
%
\newlength{\epl@stretchpretitle}
\newlength{\epl@stretchpreauthor}
\newlength{\epl@stretchpreinst}
\newlength{\epl@stretchpredates}
\newlength{\epl@stretchprepacs}
\newlength{\epl@stretchpreabst}
\newlength{\epl@stretchprerule}
\newlength{\epl@stretchpostrule}
%
\newcommand{\stretchpretitle}[1]{\epl@stretchpretitle=#1\epl@stretchmedskip}
\newcommand{\stretchpreauthor}[1]{\epl@stretchpreauthor=#1\epl@stretchmedskip}
\newcommand{\stretchpreinst}[1]{\epl@stretchpreinst=#1\epl@stretchmedskip}
%% BUG: 'predates' is quite unlucky
\newcommand{\stretchpredates}[1]{\epl@stretchpredates=#1\epl@stretchmedskip}
\newcommand{\stretchprepacs}[1]{\epl@stretchprepacs=#1\epl@stretchmedskip}
\newcommand{\stretchpreabst}[1]{\epl@stretchpreabst=#1\epl@stretchmedskip}
\newcommand{\stretchprerule}[1]{\epl@stretchprerule=#1\epl@stretchminskip}
\newcommand{\stretchpostrule}[1]{\epl@stretchpostrule=#1\epl@stretchmedskip}
%
\newcommand{\stretchfront}[1]{%
  \stretchpretitle{#1}%
  \stretchpreauthor{#1}%
  \stretchpreinst{#1}%
  \stretchpredates{#1}%
  \stretchprepacs{#1}%
  \stretchpreabst{#1}%
  \stretchprerule{#1}%
  \stretchpostrule{#1}%
}
%
\newlength{\epl@prebiblio}\setlength{\epl@prebiblio}{18pt plus4pt minus2pt}
\newlength{\epl@postbiblio}\setlength{\epl@postbiblio}{12pt plus2pt minus2pt}
%
\newcommand{\stretchprebib}[1]{%
  \addtolength{\epl@prebiblio}{#1\epl@stretchmedskip}%
}
\newcommand{\stretchpostbib}[1]{%
  \addtolength{\epl@postbiblio}{#1\epl@stretchmedskip}%
}
%
\newcommand{\stretchtail}[1]{%
  \stretchprebib{#1}%
  \stretchpostbib{#1}%
}
%
\newcommand{\stretchall}[1]{%
  \stretchfront{#1}%
  \stretchtail{#1}%
}
%%
%% floats parameters
%%
\setcounter{topnumber}{1}
\renewcommand\topfraction{.97}
\ifx\epl@styleC\doublecol
  \setcounter{bottomnumber}{0}
\else
  \setcounter{bottomnumber}{1}
\fi
\renewcommand\bottomfraction{.97}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.03}
\renewcommand\floatpagefraction{.88}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}

%%
%% pagestyles
%%
\def\epl@headrule{%
  \hbox to0pt{%
    \vbox to0pt{%
      \vskip6pt
      \hbox to\textwidth{\hrulefill}%
      \vss
    }%
    \hss
  }%
}
\def\ps@epl{%
  \def\@oddfoot{\hfil{\normalsize\thepage}\hfil}%
  \def\@evenfoot{\hfil{\normalsize\thepage}\hfil}%
  \ifx\epl@styleB\headleft
%% [marco]
    \def\@oddhead{\epl@headrule\hfil\epl@shorttitle}%
  \fi
  \ifx\epl@styleB\headcentre
    \def\@oddhead{\epl@headrule\epl@shorttitle}%
  \fi
  \ifx\epl@styleB\headclassic
    \def\@oddhead{\epl@headrule\epl@shortauthor\hfil\epl@shorttitle}%
  \fi
%% [marco]
  \def\@evenhead{\epl@headrule\epl@shortauthor\hfil}
  \ifepl@comment
  \def\@evenhead{\epl@headrule Comment \hfil}%
  \fi
  \ifepl@reply
  \def\@evenhead{\epl@headrule Reply \hfil}%
  \fi

  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}
\def\ps@eplfirst{%
  \def\@oddfoot{%
   \hfil{\normalsize\thepage}\hfil
  }%
  \def\@evenfoot{\hfil{\normalsize\thepage}\hfil}%
  \def\@oddhead{%
    \epl@stylemark
    \epl@headrule
    \hfil
    \ifx\epl@styleA\pretty
      {\sffamily\bfseries\large\epl@shortname}%
    \fi
  }
  \let\@evenhead\@oddhead
  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}
\def\ps@eplplain{%
  \def\@oddfoot{\hfil{\normalsize\thepage}\hfil}%
  \def\@evenfoot{\hfil{\normalsize\thepage}\hfil}%
  \let\@oddhead\@empty
  \let\@evenhead\@empty
  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}
\def\ps@eplempty{%
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
  \let\@oddhead\@empty
  \let\@evenhead\@empty
  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}

%%
%% banner
%%
\AtBeginDocument{\label{epl@firstpage}}
\AtEndDocument{\label{epl@lastpage}}
%%
\newcommand{\vol}[1]{\gdef\epl@vol{#1}}
\newcommand{\issue}[1]{\gdef\epl@issue{#1}}
\renewcommand{\year}[1]{\gdef\epl@year{#1}}
\newcommand{\firstpage}[1]{%
  \ifx\epl@stylepage\pageclassic
    \setcounter{page}{#1}%
    \let\epl@firstlastpp\epl@firstlastpp@proper
  \else
    \setcounter{page}{1}%
    \def\epl@firstlastpp{\epl@pgid}%
  \fi
}
\newcommand{\doi}[1]{\gdef\epl@doi{#1}}
\newcommand{\pgid}[1]{\gdef\epl@pgid{#1}}
%%
\newcommand{\received}[1]{\gdef\epl@receiveddate{#1}}
\newcommand{\accepted}[1]{\gdef\epl@accepteddate{#1}}
\newcommand{\acceptedinfinalform}[1]{\gdef\epl@accepteddate{in final form #1}}
\newcommand{\paperpub}[1]{\gdef\epl@paperpubdate{#1}}
\newcommand{\onlinepub}[1]{\gdef\epl@onlinepubdate{#1}}
%%

%
% dedication [marco]
%
\newcommand{\dedication}[1]{%
  \epl@dedicationtrue
  \def\epl@dedication{\epl@dedication@makeup{#1}}
}
\def\epl@dedication@makeup#1{%
  \begingroup
  \raggedleft
  \small
  \itshape
  #1
  \par
  \endgroup
}


\def\epl@vol{*** No volume ***}
\def\epl@issue{*** No issue ***}
\def\epl@year{*** No year ***}
\def\epl@firstpage{\pageref{epl@firstpage}}
\def\epl@lastpage{\pageref{epl@lastpage}}
\def\epl@firstlastpp{*** No first page ***}
\def\epl@firstlastpp@proper{%
  \xdef\epl@tmpa{\epl@firstpage}%
  \xdef\epl@tmpb{\epl@lastpage}%
  \ifx\epl@tmpa\epl@tmpb
    p.\ \epl@firstpage
  \else
    pp.\ \epl@firstpage--\epl@lastpage
  \fi
}
\def\epl@doi{*** No doi ***}
\def\epl@pgid{*** No pgid ***}
%%
\def\epl@receiveddate{*** No date ***}
\def\epl@accepteddate{*** No date ***}
\def\epl@paperpubdate{*** No date ***}
\def\epl@onlinepubdate{*** No date ***}
%%
\newcommand{\info}[5]{%
  \vol{#1}%
  \issue{#2}%
  \year{#3}%
  \firstpage{#4}%
  \paperpubdate{#5}%
}

%% [marco]
\def\epl@banner{%

\vskip30pt

    \ifepl@comment
    \raisebox{-10pt}[0pt][0pt]{%
    \large{\textit{Comment}}% 
    }
    \fi
    \ifepl@reply 
    \raisebox{-10pt}[0pt][0pt]{%
    \large{\textit{Reply}}% 
    }
    \fi

}

%%
%% title, shorttitle, subtitle
%%
\def\title#1{\gdef\epl@title{#1}\gdef\epl@shorttitle{\let\\\relax #1}}
\def\epl@title{*** Missing title ***}
\def\shorttitle#1{\gdef\epl@shorttitle{#1}}
\let\epl@shorttitle\epl@title
\def\subtitle#1{\gdef\epl@subtitle{#1}}
\let\epl@subtitle\@empty

%%
%% author, shortauthor
%%
\def\author#1{\gdef\epl@author{#1}\gdef\epl@shortauthor{#1}}
\def\epl@author{*** Missing author ***}
\def\shortauthor#1{\gdef\epl@shortauthor{#1}}
\let\epl@shortauthor\epl@author
\def\epl@author@intitle{%
  \setcounter{epl@cnt@and}{0}
  {\scshape\epl@author}\par
  \epl@writeaux@cnt@and{\theepl@cnt@and}%
}
%%
%% \etal
%%
\newcommand{\etal}{\unskip\ \emph{et al.}}

%%
%% \and
%%
\newcounter{epl@cnt@and}
\setcounter{epl@cnt@and}{0}
\newcounter{epl@cnt@and@aux}
\setcounter{epl@cnt@and@aux}{0}
\def\epl@and#1{\ifnum#1<\theepl@cnt@and@aux,\else{\normalfont\ and}\fi}
\def\epl@writeaux@cnt@and#1{%
  \protected@write\@auxout{}{%
    \string\setcounter{epl@cnt@and@aux}{#1}%
  }%
}
\renewcommand{\and}{%
  \unskip
  \stepcounter{epl@cnt@and}%
  \epl@and{\theepl@cnt@and}%
  \
}

%%
%% institute
%%
\newcommand{\institute}[1]{\gdef\epl@institute{#1}}
\def\epl@institute{*** Missing institute ***}
\def\epl@institute@makeup#1{%
  {\itshape #1}\par
}

%%
%% pacs
%%
\newlength{\epl@pacsindent}
\setlength{\epl@pacsindent}{7.4em}
\newcommand{\pacs}[2]{%
  \let\epl@pacsmissing\@empty
  \protected@xdef\epl@pacsset{\epl@pacsset\epl@pacs{#1}{#2}}%
}
\def\epl@pacsmissing{\hbox to\epl@pacsindent{*** Missing PACS ***\hss}\par}
\def\epl@pacsset{\epl@pacsmissing}
\def\epl@pacs#1#2{%
  \leavevmode\hbox to\epl@pacsindent{{\scriptsize PACS}\hskip0.6em\texttt{#1}\hfill\ --\ }#2\par
}
%%
%% abstract
%%
\def\abstract#1{\gdef\epl@abstract{#1}}
\def\epl@abstract{*** Missing author ***}

%%
%% \maketitle
%%
\newcommand\maketitle{\par
  \begingroup
    \parskip0pt
%% [marco]
    \def\mth##1{\boldmath\ensuremath{\mathsf{##1}}}
    \def\chem##1{\boldmath\ensuremath{\mathsf{##1}}} 
    \renewcommand\thefootnote{\@alph\c@footnote}%  
    \def\@makefnmark{\@textsuperscript{\normalfont(\@thefnmark)}}
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont(\@thefnmark)}}##1}%
    \let\footnote\thanks
    \def\inst##1{\unskip${}^{##1}$\hspace{0.5em}\ignorespaces}%
    \def\[##1]{\inst{##1}}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{eplfirst}%
    \@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\title\relax
  \global\let\epl@title\@empty
  \global\let\author\relax
  \global\let\epl@author\@empty
  \global\let\thanks\relax
  \global\let\@thanks\@empty
  \global\let\and\relax
  \global\let\institute\relax
  \global\let\epl@institute\@empty
  \global\let\inst\relax
  \global\let\[\relax
} %\maketitle

%%
%% \@maketitle
%%
\newlength{\epl@maketitle@smallskip}\setlength{\epl@maketitle@smallskip}{9pt}
\newlength{\epl@maketitle@medskip}\setlength{\epl@maketitle@medskip}{13pt}
\newlength{\epl@maketitle@bigskip}\setlength{\epl@maketitle@bigskip}{18pt}
%% [marco]
\newlength{\epl@dedication@skip}\setlength{\epl@dedication@skip}{1pc plus2pt minus1pt}

\def\@maketitle{%
  \newpage
%  \sloppy
  \parindent\z@
  \null
  %% BUG: next vskip a bit hacky...
  \vskip-4ex
  %% BUG: could not trace out the origin of an extra vspace
  %% in 'orcish' and 'tight' mode.  had to counterbalance it here
  \ifx\epl@styleC\doublecol\else
    \vskip-2.4ex
  \fi
  {\small\epl@banner\par}%
  \vskip\epl@maketitle@bigskip
  \vskip\epl@stretchpretitle
  {\sloppy\LARGE\sffamily\bfseries\epl@title\par}%
  {\sloppy\vskip6pt\large\sffamily\bfseries\epl@subtitle\par}%
  \vskip\epl@maketitle@bigskip
  \vskip\epl@stretchpreauthor
  {\scshape\epl@author@intitle\par}%
  \vskip\epl@maketitle@smallskip
  \vskip\epl@stretchpreinst
  {\itshape\epl@institute\par}%
  \vskip\epl@maketitle@smallskip
  \bgroup
    %% BUG: study \leftskip and \rightskip.
    %% and \leftmargin and \rightmargin..
    \ifx\epl@styleC\tight\else
      \addtolength\leftskip{4em}%
      \addtolength\hsize{-8em}%
    \fi
    \sloppy
    \vskip\epl@stretchpredates
    \bgroup

%% [marco]
%      received \epl@receiveddate; accepted \epl@accepteddate\par
%      published online \epl@onlinepubdate
     \quad
     \quad

      \ifx\epl@styleA\pretty; published \epl@paperpubdate\fi\par
    \egroup
    \vskip\epl@maketitle@smallskip
    \vskip\epl@stretchprepacs
    \bgroup
      \setlength\parindent{-\epl@pacsindent}%
      \addtolength\leftskip{\epl@pacsindent}%
      \small
      \epl@pacsset
    \egroup
    \ifepl@noabstr\else
    \vskip\epl@maketitle@smallskip
    \vskip\epl@stretchpreabst
    \bgroup
      \small
      \textbf{\abstractname}~\epl@dash
      \epl@abstract
      \par
    \egroup
    \fi

%% [marco 1.0]
   \ifepl@dedication
        \vspace{\epl@dedication@skip}
        \epl@dedication
      \fi

%% [marco]
   \bgroup
   \vskip10pt
   \hskip0pt 
   \hbox to0pt{\quad \hss}
   \egroup

  \egroup
  \vskip\epl@maketitle@medskip
  \vskip\epl@stretchprerule
  \hrule\@width\textwidth
  \vskip\epl@maketitle@bigskip
  \vskip\epl@stretchpostrule
}

%%
%% dash and dot in captions, sections, etc.
%%
\def\epl@dash{--}
\def\epl@dot{.}
\newcommand{\nodash}{\gdef\epl@dash{}}
\newcommand{\dash}{\gdef\epl@dash{--}}
\newcommand{\nodot}{\gdef\epl@dot{}}
\newcommand{\godot}{\gdef\epl@dot{.}}

%%
%% sectioning
%%
\newlength\epl@section@vskip
\setlength\epl@section@vskip{6pt plus2pt minus0pt}
\newlength\epl@section@hsep
\setlength\epl@section@hsep{10pt plus1pt minus0pt}
\newlength\epl@section@indent
\setlength\epl@section@indent{\parindent}
\newlength\epl@subsection@vskip
\setlength\epl@subsection@vskip{3pt plus1pt minus0pt}
\newlength\epl@subsection@hsep
\setlength\epl@subsection@hsep{10pt plus1pt minus0pt}
\newlength\epl@subsection@indent
\setlength\epl@subsection@indent{\parindent}
\setcounter{secnumdepth}{0}
\newcommand{\section}[1]{\epl@section{\epl@section@makeup{#1}}}
\def\epl@section{%
   \@startsection{section}{1}{\epl@section@indent}%
                 {\epl@section@vskip}%
                 {-\epl@section@hsep}%
                 {\normalfont\normalsize\bfseries}%
}
\def\epl@section@makeup#1{#1\epl@dot\godot\ \epl@dash\dash}
\newcommand{\subsection}[1]{\epl@subsection{\epl@subsection@makeup{#1}}}
\def\epl@subsection{%
   \@startsection{subsection}{1}{\epl@subsection@indent}%
                 {\epl@subsection@vskip}%
                 {-\epl@subsection@hsep}%
                 {\normalfont\normalsize\itshape}%
}
\def\epl@subsection@makeup#1{#1\epl@dot\godot\ }
\newcommand{\part}{\ClassError{epl}{No `part' sectioning allowed}}
\newcommand{\subsubsection}{\ClassError{epl}{No subsubsections allowed}}
\newcommand{\paragraph}{\ClassError{epl}{No paragraphs allowed}}
\newcommand{\subparagraph}{\ClassError{epl}{No subparagraphs allowed}}

%%
%% acknowledgments
%%
\newcommand{\acknowledgments}{%
  \par
  \vspace{\epl@acknowledgments@skip}%
  \centerline{$\ast\ast\ast$}%
  \nopagebreak
  \vspace{\epl@acknowledgments@skip}%
  \par
}
\let\acknowledgements\acknowledgments
\let\stars\acknowledgments
%%
%% acknowledgments shrinking/enlarging
%%
\newlength\epl@acknowledgments@skip
\setlength{\epl@acknowledgments@skip}{1pc plus2pt minus 2pt}
\newcommand{\shrinkacknowledgments}[1]{%
  \ifcase#1
    \or\addtolength{\epl@acknowledgments@skip}{-6pt}%
    \or\addtolength{\epl@acknowledgments@skip}{-12pt}%
    \else\ClassWarning{epl}{%
           Argument to \protect\shrinkacknowledgments\space must be 1 or 2%
         }%
  \fi
}
\newcommand{\enlargeacknowledgments}[1]{%
  \ifcase#1
    \or\addtolength{\epl@acknowledgments@skip}{6pt}%
    \or\addtolength{\epl@acknowledgments@skip}{12pt}%
    \else\ClassWarning{epl}{%
           Argument to \protect\enlargeacknowledgments\space must be 1 or 2%
         }%
  \fi
}
\let\shrinkacknowledgements\shrinkacknowledgments
\let\enlargeacknowledgements\enlargeacknowledgments

%%
%% lists
%%
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}

%%
%% verse, quotation, quote
%%
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}

%%
%% appendix
%%
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@Alph\c@section}}

%%
%% tabular and tabbing parameters
%%
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}

%%
%% misc (?) parameters
%%
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}

%%
%% equation counter [mala: why here?]
%%
\renewcommand \theequation {\@arabic\c@equation}

%% 
%% floating equations [marco]
%%
\newcounter{epl@eqnfloat}
\newcommand\inapp[1]{\global\in@pptrue
		     \def\in@pp@sect{#1}}
\newenvironment{eqnumber}[1]{%
  \setcounter{epl@eqnfloat}{\value{equation}}%
  \setcounter{equation}{#1}%
  \addtocounter{equation}{-1}%
  \ifin@pp\renewcommand\theequation{\in@pp@sect.\arabic{equation}}\global\in@ppfalse\fi%
}{%
  \setcounter{equation}{\value{epl@eqnfloat}}\par
}
\newenvironment{floatequation}{%
  \stepcounter{equation}%
  $$
}{
  $$
  \aftergroup\ignorespaces
}

\newenvironment{widetext}{%
                \begin{figure*}}{
                \rule{18cm}{0.4pt}
                \end{figure*}} 



%%
%% figures
%%
\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\newcounter{epl@figures}
\setcounter{epl@figures}{0}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}
\newenvironment{figure}{%
  \ifepl@figures
    \setcounter{epl@figures}{\thefigure}%
  \fi
  \@float{figure}%
}{%
  \end@float
}
\newenvironment{figure*}{%
  \ifepl@figures
    \setcounter{epl@figures}{\thefigure}%
  \fi
  \@dblfloat{figure}%
}{%
  \end@dblfloat
}

%%
%% figure files inclusion
%%
\newcommand{\onefigure}[2][]{%
  \stepcounter{epl@figures}%
  \hbox to\hsize{\hfill\includegraphics*[#1]{#2}\hfill}%
}
\newcommand{\twofigures}[3][]{%
  \hbox to\hsize{%
    \vbox{%
       \hbox{\includegraphics*[#1]{#2}}%
       \stepcounter{epl@figures}%
       \hbox{\small\figurename\ \theepl@figures}%
    }%
    \hfill
    \vbox{%
       \hbox{\includegraphics*[#1]{#3}}%
       \stepcounter{epl@figures}%
       \hbox{\small\figurename\ \theepl@figures}}%
    \hfill
  }%
}

%%
%% tables
%%
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}

%%
%% [marco]
%%

\newenvironment{largetable}{
               \begin{table*}
               \begin{center}}{
               \end{center}
               \end{table*}}

%%
%% captions
%%
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\small #1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    \small #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

%%
%% font commands
%%
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

%%
%% toc
%%
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\newcommand\tableofcontents{%
    \section*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    }

%%
%% ? sectioning low level ?
%%
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}
\newcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}

%%
%% list of figure, list of tables
%%
\newcommand\listoffigures{%
    \section*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure

%%
%% bibliography
%%
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newif\ifepl@gotand\epl@gotandfalse
\newenvironment{thebibliography}[1]{%
  \@startsection{section}{1}{0pt}{\epl@prebiblio}{\epl@postbiblio}%
  {\noindent\normalfont\small\refname}{}%
      \def\and{\unskip\global\epl@gotandtrue{\normalfont\ and\ }\ignorespaces}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}%
	    \parsep0pt
            \itemsep0pt
	    \small
      }%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty

%%
%% index
%%
\newif\if@restonecol
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \columnseprule \z@
                \columnsep 35\p@
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{eplplain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}

%%
%% footnotes
%%
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}

%%
%% twocolumn parameters [mala: why here?]
%%
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}

%%
%% titlepage macros (from various epl????.tex)
%%
\let\orgdivision\@iden
\let\orgname\@iden
\let\postcode\@iden
\let\street\@iden
\let\city\@iden
\let\country\@iden

%%
%% general macros (from epl.cls)
%%
\newcommand{\email}[1]{\texttt{#1}}
\newcommand{\upd}{\mathrm{d}}
\let\drm\upd
\newcommand{\ab}[1]{\mathrm{#1}}
\newcommand{\tx}[1]{{\mbox{#1}}}
\newcommand{\vect}[1]{\bm{#1}}
\newcommand{\tens}[1]{\mathsf{#1}}
\newcommand{\un}[1]{\ensuremath{\unskip\,\mathrm{#1}}}
\newcommand{\chem}[1]{\ensuremath{\mathrm{#1}}}
\newcommand{\mth}[1]{\ensuremath{#1}}
\newcommand{\acro}[1]{\textmd{#1}}

%%
%% bibliography macros (from epl.cls)
%%
\newif\ifepl@book\epl@bookfalse
\let\epl@org@bibitem\bibitem
\def\bibitem{\epl@bookfalse\epl@org@bibitem}

\newcommand{\Name}[1]{{\scshape #1},}
\newcommand{\Review}[1]{\epl@bookfalse{\itshape #1},}
\newcommand{\Vol}[1]{%
  \ifepl@book\unskip, Vol.~{\bfseries #1}\else{\bfseries #1}\fi
}
\newcommand{\Year}[1]{\ifepl@book#1\else(#1)\fi}
\newcommand{\Page}[1]{%
  \ifepl@book\unskip,\ {\normalfont p.~#1}\else{\normalfont #1}\fi
}
\newcommand{\Pages}[2]{%
  \ifepl@book\unskip,\ {\normalfont pp.~#1-#2}\else{\normalfont #1-#2}\fi
}
\newcommand{\Book}[1]{\epl@booktrue{\itshape #1}}
\newcommand{\Publ}[1]{\ifepl@book\unskip\ \fi{\normalfont(#1)}}
\newcommand{\Editor}[1]{%
  \epl@gotandfalse
  \ifepl@book\unskip,\ {\normalfont edited by}\ {\scshape #1}%
  \else
    {\scshape #1}\ {\normalfont (Editor\ifepl@gotand s\fi)},%
  \fi
}
\newcommand{\Section}[1]{%
  \ifepl@book\unskip,\ {\normalfont sect.~#1}\else{\normalfont sect.~#1}\fi
}
\let\And\and
\newcommand{\REVIEW}[4]{\Review{#1} \Vol{#2} \Year{#3} \Page{#4}}
\newcommand{\SAME}[3]{\Vol{#1} \Year{#2} \Page{#3}}

%%
%% lift-off
%%
\pagestyle{epl}
%% page numbering
%% [marco]
\pagenumbering{arabic}
\ifx\epl@stylepage\pageid
  \let\epl@orgthepage\thepage

%% [marco]
  \def\thepage{p-\epl@orgthepage}
\fi
%% /page
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi
\endinput
