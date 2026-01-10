%%%%%%%%%%%%%%%%%          gtpart.cls       %%%%%%%%%%%%%%%%%%
%
%  Format file for articles written in LaTeX for publication in 

%   and uses Times fonts where possible.  It is for use from 2006
%   onwards.  It is common to GT, AGT and GTM, uses MSP metadata
%   format and duplicates as far as practicable MSP style.    
%
%                                      Colin Rourke, December 2006 
%
%  For full instructions see gtpartdoc.pdf (available from the same
%   directory as this file).
%
%      (gtart.cls v1.6 -- hyperref + times + MSP metadata) 
%
%%  Check for fairly recent version of latex2e :
%
\NeedsTeXFormat{LaTeX2e}[1994/12/01]
%
\LoadClass[11pt]{article}  
\usepackage{amsthm,amssymb} 
\usepackage[leqno]{amsmath}
\newif\ifmicrotype
\DeclareOption{microtype}{\microtypetrue} 
\ProcessOptions\relax
\AtBeginDocument{%
  \def\tempaa{\thesection.\arabic{equation}}%
  \ifx\theequation\tempaa
     \def\theequation{\thesection\hbox{--}\arabic{equation}}%
  \fi
  \ifmicrotype
     \RequirePackage{microtype}%
     \DeclareMicrotypeAlias{mnt}{ptm}%
  \fi
  \DeclareMathSizes{10}   {10}   {7}{6}% from msp.cls
  \DeclareMathSizes{10.95}{10.95}{8}{6}% from msp.cls
}
%
%  Times fonts and Times math symbols 
%
\renewcommand{\sfdefault}{cmr}
\DeclareFontFamily{OT1}{ptm}{}
\DeclareFontShape{OT1}{ptm}{m}{n} { <-> ptmr}{}
\DeclareFontShape{OT1}{ptm}{m}{it}{ <-> ptmri}{}
\DeclareFontShape{OT1}{ptm}{m}{sl}{ <->ptmro}{}
\DeclareFontShape{OT1}{ptm}{m}{sc}{ <-> ptmrc}{}
\DeclareFontShape{OT1}{ptm}{b}{n} { <-> ptmb}{}
\DeclareFontShape{OT1}{ptm}{b}{it}{ <-> ptmbi}{}     
\DeclareFontShape{OT1}{ptm}{bx}{n} {<->ssub * ptm/b/n}{}
\DeclareFontShape{OT1}{ptm}{bx}{it}{<->ssub * ptm/b/it}{}
\def\rmdefault{ptm}
\DeclareSymbolFont{bold}{OT1}{ptm}{b}{n}
\DeclareMathAlphabet{\mathbf}{OT1}{ptm}{b}{n}  
\DeclareMathAlphabet{\mathrm}{OT1}{ptm}{m}{n}
\let\bBB=\mathbb 
\let\Bbb=\mathbb  
%
\DeclareFontFamily{OT1}{psy}{}      
\DeclareFontShape{OT1}{psy}{m}{n}{ <-> s * [0.9] psyr}{}
%
\DeclareFontFamily{OMS}{ptm}{}     
\DeclareFontShape{OMS}{ptm}{m}{n}{ <8> <9> <10> gen * cmsy }{}
\DeclareFontFamily{OMS}{cmtt}{}     
\DeclareFontShape{OMS}{cmtt}{m}{n}{ <8> <9> <10> gen * cmsy }{}

\SetSymbolFont{operators}{normal}{OT1}{ptm}{m}{n}   
\SetSymbolFont{operators}{bold}{OT1}{ptm}{b}{n}     
%
\DeclareSymbolFont{emsy}{OT1}{ptm}{m}{it}
\DeclareSymbolFont{emsr}{OT1}{ptm}{m}{n}
\DeclareSymbolFont{emcmr}{OT1}{cmr}{m}{n}   
\DeclareSymbolFont{emsymb}{OT1}{psy}{m}{n}  
%
\DeclareMathSymbol a{\mathalpha}{emsy}{"61}
\DeclareMathSymbol b{\mathalpha}{emsy}{"62}
\DeclareMathSymbol c{\mathalpha}{emsy}{"63}
\DeclareMathSymbol d{\mathalpha}{emsy}{"64}
\DeclareMathSymbol e{\mathalpha}{emsy}{"65}
\DeclareMathSymbol f{\mathalpha}{emsy}{"66}
\DeclareMathSymbol g{\mathalpha}{emsy}{"67}
\DeclareMathSymbol h{\mathalpha}{emsy}{"68}
\DeclareMathSymbol i{\mathalpha}{emsy}{"69}
\DeclareMathSymbol j{\mathalpha}{emsy}{"6A}
\DeclareMathSymbol k{\mathalpha}{emsy}{"6B}
\DeclareMathSymbol l{\mathalpha}{emsy}{"6C}
\DeclareMathSymbol m{\mathalpha}{emsy}{"6D}
\DeclareMathSymbol n{\mathalpha}{emsy}{"6E}
\DeclareMathSymbol o{\mathalpha}{emsy}{"6F}
\DeclareMathSymbol p{\mathalpha}{emsy}{"70}
\DeclareMathSymbol q{\mathalpha}{emsy}{"71}
\DeclareMathSymbol r{\mathalpha}{emsy}{"72}
\DeclareMathSymbol s{\mathalpha}{emsy}{"73}
\DeclareMathSymbol t{\mathalpha}{emsy}{"74}
\DeclareMathSymbol u{\mathalpha}{emsy}{"75}
\DeclareMathSymbol v{\mathalpha}{emsy}{"76}
\DeclareMathSymbol w{\mathalpha}{emsy}{"77}
\DeclareMathSymbol x{\mathalpha}{emsy}{"78}
\DeclareMathSymbol y{\mathalpha}{emsy}{"79}
\DeclareMathSymbol z{\mathalpha}{emsy}{"7A}
\DeclareMathSymbol A{\mathalpha}{emsy}{"41}
\DeclareMathSymbol B{\mathalpha}{emsy}{"42}
\DeclareMathSymbol C{\mathalpha}{emsy}{"43}
\DeclareMathSymbol D{\mathalpha}{emsy}{"44}
\DeclareMathSymbol E{\mathalpha}{emsy}{"45}
\DeclareMathSymbol F{\mathalpha}{emsy}{"46}
\DeclareMathSymbol G{\mathalpha}{emsy}{"47}
\DeclareMathSymbol H{\mathalpha}{emsy}{"48}
\DeclareMathSymbol I{\mathalpha}{emsy}{"49}
\DeclareMathSymbol J{\mathalpha}{emsy}{"4A}
\DeclareMathSymbol K{\mathalpha}{emsy}{"4B}
\DeclareMathSymbol L{\mathalpha}{emsy}{"4C}
\DeclareMathSymbol M{\mathalpha}{emsy}{"4D}
\DeclareMathSymbol N{\mathalpha}{emsy}{"4E}
\DeclareMathSymbol O{\mathalpha}{emsy}{"4F}
\DeclareMathSymbol P{\mathalpha}{emsy}{"50}
\DeclareMathSymbol Q{\mathalpha}{emsy}{"51}
\DeclareMathSymbol R{\mathalpha}{emsy}{"52}
\DeclareMathSymbol S{\mathalpha}{emsy}{"53}
\DeclareMathSymbol T{\mathalpha}{emsy}{"54}
\DeclareMathSymbol U{\mathalpha}{emsy}{"55}
\DeclareMathSymbol V{\mathalpha}{emsy}{"56}
\DeclareMathSymbol W{\mathalpha}{emsy}{"57}
\DeclareMathSymbol X{\mathalpha}{emsy}{"58}
\DeclareMathSymbol Y{\mathalpha}{emsy}{"59}
\DeclareMathSymbol Z{\mathalpha}{emsy}{"5A}
\DeclareMathSymbol{\bullet}{\mathalpha}{emsymb}{"B7}
\DeclareMathSymbol{\regis}{\mathalpha}{emsymb}{"D2}
\def\Bullet{\leavevmode\unkern{$\m@th\bullet$}\kern.32em\ignorespaces}
\def\Regis{\leavevmode\raise.5ex\hbox{$\m@th\regis$}}
\DeclareMathSymbol +{\mathbin}{emcmr}{`+}
\DeclareMathSymbol ={\mathrel}{emcmr}{`=}  
\DeclareMathSymbol{\Gamma}{\mathalpha}{emcmr}{"00}
\DeclareMathSymbol{\Delta}{\mathalpha}{emcmr}{"01}
\DeclareMathSymbol{\Theta}{\mathalpha}{emcmr}{"02}
\DeclareMathSymbol{\Lambda}{\mathalpha}{emcmr}{"03}
\DeclareMathSymbol{\Xi}{\mathalpha}{emcmr}{"04}
\DeclareMathSymbol{\Pi}{\mathalpha}{emcmr}{"05}
\DeclareMathSymbol{\Sigma}{\mathalpha}{emcmr}{"06}
\DeclareMathSymbol{\Upsilon}{\mathalpha}{emcmr}{"07}
\DeclareMathSymbol{\Phi}{\mathalpha}{emcmr}{"08}
\DeclareMathSymbol{\Psi}{\mathalpha}{emcmr}{"09}
\DeclareMathSymbol{\Omega}{\mathalpha}{emcmr}{"0A}
\DeclareMathSizes{7.6}{8}{6}{5}
%
%    some accents and useful symbols (from L'Ensiegnment class file)
%
\def\`#1{{\accent"12 #1}}            % grave accent
\def\H#1{{\accent"CD #1}}            % double acute accent
\chardef\J="11                  
\def\j{{\sf\J}}                      % j without dot 
\chardef\AA="C8                      % Angstrom
\chardef\gbp="A3                     % pound sign           
\chardef\TIL="81                     % tilde on line
\chardef\endash="B1                
\chardef\emdash="D0                
\chardef\pourmille="BD               % %sign
\chardef\aoben="E3                   % ^a
\chardef\ooben="EB                   % ^o
\def\S{\leavevmode\unkern{\char"A7}\kern.1em\ignorespaces} 
%\def\D#1{{\accent"C7 #1}}            % overdot
\DeclareMathAccent{\dot}{\mathalpha}{operators}{"C7} % ditto math mode
%
% double diamond brackets, usage:  \og TEXTE \fg   or   {\og}TEXTE{\fg}
%
\def\og{{\char"AB}\kern.15em}
\def\fg{\relax\ifhmode\unskip\kern.15em\fi{\char"BB}}
%
% Polish cedilla:
%
\def\cedpol#1{\setbox0=\hbox{#1}\ifdim\ht0=1ex \accent"CE #1%
  \else{\ooalign{\hidewidth\char"CE\hidewidth\crcr\unhbox0}}\fi}
%
%  endgame (MUST COME BEFORE hyperref)
%
\AtEndDocument{{\small\parskip 0pt\vskip11pt minus 5pt\relax
{\sl \def\\{\futurelet\next\nocommawithnl}\def\nocommawithnl
  {\ifx\next\newline\else\unskip,\space\ignorespaces\fi}
  \theaddress\par}
{\rightskip0pt plus .4\hsize
{\def\tempab{}\tt\def~{\lower3.5pt\hbox{\char'176}}\def\_{\char'137}%
\ifx\theemail\tempab\else
  \vskip5pt minus 3pt\theemail\par\fi
  \ifx\theurl\tempab\else
  \vskip5pt minus 3pt\theurl\par\fi}
  \vskip11pt minus 5pt
  \def\tempab{}\ifx\receiveddate\tempab\else Received:\qua\receiveddate\fi
  \ifx\reviseddate\tempab\else\qquad Revised:\qua \reviseddate\fi\par}}}
%
%  hyperref stuff
%
\usepackage{hyperref}  
\hypersetup{%
  bookmarksnumbered=true,%
  bookmarks=true,%
  colorlinks=true,%
  linkcolor=blue,%
  citecolor=blue,%
  filecolor=blue,%
  menucolor=blue,%
  pagecolor=blue,%
  urlcolor=blue,%
  pdfnewwindow=true,%
  pdfstartview=FitBH}
%
%   \arxiv and \MR are for use in the biblio eg:
%   \arxiv{math.GT/0102334}  \MR{2002j:32027}
%
\def\arxiv#1{\relax\ifhmode\unskip\qua\fi
    \href{http://arxiv.org/abs/#1}%
{\tt arXiv:\penalty -100\unskip#1}}    
\let\arXiv\arxiv
\def\MR#1{\relax\ifhmode\unskip\qua\fi
    \href{http://www.ams.org/mathscinet-getitem?mr=#1}{MR#1}}
%
\def\xox#1{\csname xx#1\endcsname} %%% used by 
\let\xxarXiv\arxiv\let\xxMR\MR     %%% gtart.bst
\def\xxZBL#1{}
\def\xxJFM#1{}
\def\@url#1{{\tt\def~{\lower3.5pt\hbox{\char'176}}\def\_{\char'137}#1}}
\let\fullref\autoref
%
%  \autoref is very crude.  It uses counters to distinguish environments
%  so that if say {lemma} uses the {theorem} counter, then autrorefs
%  which should come out Lemma X.Y in fact come out Theorem X.Y.  To
%  correct this give each its own counter eg:
%                 \newtheorem{theorem}{Theorem}[section]
%                 \newtheorem{lemma}{Lemma}[section]
%  and then equate the counters by commands like:
%                 \makeatletter
%                   \let\c@lemma\c@theorem
%                  \makeatother
%
%  To work correctly the environment name must have a corrresponding 
%  \XXXautorefname defined.  The following command does the job:
%
\def\makeautorefname#1#2{\expandafter\def\csname#1autorefname\endcsname{#2}}
%
%  Some standard autorefnames.  If the environment name for an autoref 
%  you need is not listed below, add a similar line to your TeX file:
%  
\makeautorefname{equation}{Equation}%
\makeautorefname{footnote}{footnote}%
\makeautorefname{item}{item}%
\makeautorefname{figure}{Figure}%
\makeautorefname{table}{Table}%
\makeautorefname{part}{Part}%
\makeautorefname{appendix}{Appendix}%
\makeautorefname{chapter}{Chapter}%
\makeautorefname{section}{Section}%
\makeautorefname{subsection}{Section}%
\makeautorefname{subsubsection}{Section}%
\makeautorefname{paragraph}{Paragraph}%
\makeautorefname{subparagraph}{Paragraph}%
\makeautorefname{theorem}{Theorem}%
\makeautorefname{theo}{Theorem}%
\makeautorefname{thm}{Theorem}%
\makeautorefname{addendum}{Addendum}%
\makeautorefname{addend}{Addendum}%
\makeautorefname{add}{Addendum}%
\makeautorefname{maintheorem}{Main theorem}%
\makeautorefname{mainthm}{Main theorem}%
\makeautorefname{corollary}{Corollary}%
\makeautorefname{corol}{Corollary}%
\makeautorefname{coro}{Corollary}%
\makeautorefname{cor}{Corollary}%
\makeautorefname{lemma}{Lemma}%
\makeautorefname{lemm}{Lemma}%
\makeautorefname{lem}{Lemma}%
\makeautorefname{sublemma}{Sublemma}%
\makeautorefname{sublem}{Sublemma}%
\makeautorefname{subl}{Sublemma}%
\makeautorefname{proposition}{Proposition}%
\makeautorefname{proposit}{Proposition}%
\makeautorefname{propos}{Proposition}%
\makeautorefname{propo}{Proposition}%
\makeautorefname{prop}{Proposition}%
\makeautorefname{property}{Property}
\makeautorefname{proper}{Property}
\makeautorefname{scholium}{Scholium}%
\makeautorefname{step}{Step}%
\makeautorefname{conjecture}{Conjecture}%
\makeautorefname{conject}{Conjecture}%
\makeautorefname{conj}{Conjecture}%
\makeautorefname{question}{Question}
\makeautorefname{questn}{Question}
\makeautorefname{quest}{Question}
\makeautorefname{ques}{Question}
\makeautorefname{qn}{Question}
\makeautorefname{definition}{Definition}%
\makeautorefname{defin}{Definition}%
\makeautorefname{defi}{Definition}%
\makeautorefname{def}{Definition}%
\makeautorefname{dfn}{Definition}%
\makeautorefname{notation}{Notation}
\makeautorefname{nota}{Notation}
\makeautorefname{notn}{Notation}
\makeautorefname{remark}{Remark}%
\makeautorefname{rema}{Remark}%
\makeautorefname{rem}{Remark}%
\makeautorefname{rmk}{Remark}%
\makeautorefname{rk}{Remark}%
\makeautorefname{remarks}{Remarks}%
\makeautorefname{rems}{Remarks}%
\makeautorefname{rmks}{Remarks}%
\makeautorefname{rks}{Remarks}%
\makeautorefname{example}{Example}%
\makeautorefname{examp}{Example}%
\makeautorefname{exmp}{Example}%
\makeautorefname{exam}{Example}%
\makeautorefname{exa}{Example}%
\makeautorefname{algorithm}{Algorith}%
\makeautorefname{algo}{Algorith}%
\makeautorefname{alg}{Algorith}%
\makeautorefname{axiom}{Axiom}%
\makeautorefname{axi}{Axiom}%
\makeautorefname{ax}{Axiom}%
\makeautorefname{case}{Case}%
\makeautorefname{claim}{Claim}%
\makeautorefname{clm}{Claim}%
\makeautorefname{assumption}{Assumption}%
\makeautorefname{assumpt}{Assumption}%
\makeautorefname{conclusion}{Conclusion}%
\makeautorefname{concl}{Conclusion}%
\makeautorefname{conc}{Conclusion}%
\makeautorefname{condition}{Condition}%
\makeautorefname{condit}{Condition}%
\makeautorefname{cond}{Condition}%
\makeautorefname{construction}{Construction}%
\makeautorefname{construct}{Construction}%
\makeautorefname{const}{Construction}%
\makeautorefname{cons}{Construction}%
\makeautorefname{criterion}{Criterion}%
\makeautorefname{criter}{Criterion}%
\makeautorefname{crit}{Criterion}%
\makeautorefname{exercise}{Exercise}%
\makeautorefname{exer}{Exercise}%
\makeautorefname{exe}{Exercise}%
\makeautorefname{problem}{Problem}%
\makeautorefname{problm}{Problem}%
\makeautorefname{probm}{Problem}%
\makeautorefname{prob}{Problem}%
\makeautorefname{solution}{Solution}%
\makeautorefname{soln}{Solution}%
\makeautorefname{sol}{Solution}%
\makeautorefname{summary}{Summary}%
\makeautorefname{summ}{Summary}%
\makeautorefname{sum}{Summary}%
\makeautorefname{operation}{Operation}%
\makeautorefname{oper}{Operation}%
\makeautorefname{observation}{Observation}%
\makeautorefname{observn}{Observation}%
\makeautorefname{obser}{Observation}%
\makeautorefname{obs}{Observation}%
\makeautorefname{ob}{Observation}%
\makeautorefname{convention}{Convention}%
\makeautorefname{convent}{Convention}%
\makeautorefname{conv}{Convention}%
\makeautorefname{cvn}{Convention}%
\makeautorefname{warning}{Warning}%
\makeautorefname{warn}{Warning}%
\makeautorefname{note}{Note}%
\makeautorefname{fact}{Fact}%
%
%                  *** End of hyperref stuff ***
%
%  Basic layout :
%
%  get print centerpage:
%
\headsep 23pt
\footskip 35pt
\hoffset -4truemm
\voffset 12.5truemm
%
\newskip\stdskip                      % standard vertical space
\stdskip=6.6pt plus3.3pt minus3.3pt    
%
\setlength{\textheight}{7.5in}          
\setlength{\textwidth}{5.2in}         
\flushbottom                           
\setlength{\parindent}{0pt}            
\setlength{\parskip}{\stdskip}
\setlength{\medskipamount}{\stdskip}
\setlength{\mathsurround}{0.8pt}     
\setlength{\labelsep}{0.75em} 
\newcommand{\stdspace}{\hskip 0.75em plus 0.15em \ignorespaces}
\let\qua\stdspace  %  useful abbreviation 
\renewcommand{\baselinestretch}{1.05}  %   open up a tad to match msp
%
%  Some style commands (\ppar is for principal paragraph breaks, \sh is
%  for subheadings and \rk for remarks etc -- see also theorem style 
%  below ) :
%
\newcommand{\ppar}{\par\goodbreak\medskip} 
\newcommand{\sh}[1]{\penalty-800\ppar{\bf #1}\par\medskip\nobreak}
\newcommand{\rk}[1]{\ppar{\bf #1}\stdspace}    
%
%
%   Theorem style.  There are two recommended styles :
%
%   plain : for theorems, corollaries etc with heading bold
%   and left justified, optional note bracketed in roman type
%   and statement in slanted type.
%
%   definition : (alias remark)  for definitions, remarks etc with
%   heading bold and left justified, optional note unbracketed in 
%   slanted type and statement in roman type.
%   
%
%  Redefine the amsthm styles plain, definition and remark to GTP style:
%
\newtheoremstyle{plain}{13.2pt plus6.6pt minus6.6pt}{6.6pt plus3.3pt minus3.3pt}%
{\sl}{}{\bf}{}{0.75em}{\thmname{#1}\thmnote{\rm\stdspace(#3)}}
%
\newtheoremstyle{definition}{13.2pt plus6.6pt minus6.6pt}{6.6pt plus3.3pt minus3.3pt}%
{\rm}{}{\bf}{}{0.75em}{\thmname{#1}\thmnote{\rm\stdspace(#3)}}
%
\newtheoremstyle{remark}{13.2pt plus6.6pt minus6.6pt}{6.6pt plus3.3pt minus3.3pt}%
{\rm}{}{\bf}{}{0.75em}{\thmname{#1}\thmnote{\rm\stdspace(#3)}}
%
%  Default theorem style :
\theoremstyle{plain}               
%
%  adapt the amsthm proof environment to GTP style 
%
\newenvironment{Proof}[1][\proofname.]{\par
  \pushQED{\qed}%
  \normalfont \topsep\stdskip
  \trivlist
  \item[\hskip\labelsep
        \bf#1]\ignorespaces
}{%
  \popQED\endtrivlist\@endpefalse
}
%                 Knuth's \square macro :
%
\def\sqr#1#2{{\vcenter{\vbox{\hrule  height.#2pt
	\hbox{\vrule width.#2pt height#1pt \kern#1pt \vrule width.#2pt}
	\hrule height.#2pt}}}}
%
\def\sq{\sqr55}           %    A small square for end-of-proofs. 
\def\qedsymbol{$\sqr55$}  %   (Define other size squares by varing the
%                         %   the two numbers.)
%
%  some useful abbreviations :
%
\newcommand{\co}{\mskip0.5mu\colon\thinspace}   % Colon for maps.
\newcommand{\np}{\newpage}            %  Forced page break (new page).
\newcommand{\nl}{\hfil\break}         %  New line.
\newcommand{\cl}{\centerline}         %  Centerline
%
%  metadata items:
%
%  title
%
\def\title{\@ifnextchar[\doubletitle\singletitle}
 \def\doubletitle[#1]#2{\def\thetitle{#2}\def\theshorttitle{#1}}
 \def\singletitle#1{\def\thetitle{#1}\def\theshorttitle{#1}}
%
%  author(s)
%
\def\author{\@ifnextchar[\doubleauthor\singleauthor}
\def\doubleauthor[#1]#2{\edef\previousauthors{\theauthors}
 \ifx\theauthors\relax\def\theauthors{#2}\else
 \def\theauthors{\previousauthors\par#2}\fi
 \edef\previousrootauthors{\rootauthors}
 \ifx\rootauthors\relax
     \ifx\lastauthor\relax\def\lastauthor{#1}\def\theshortauthors{#1}
     \else\edef\rootauthors{\lastauthor}\def\lastauthor{#1}
          \def\theshortauthors{\rootauthors\ and #1}\fi
 \else\edef\rootauthors{\previousrootauthors, \lastauthor}
      \def\lastauthor{#1}\def\theshortauthors{\rootauthors\ and #1}\fi}
\def\singleauthor#1{\doubleauthor[#1]{#1}}
%
%  address
%
\def\address#1{{\let\\\relax\let\newline\par\xdef\previousaddresses{\theaddress}}
 \ifx\theaddress\relax\def\theaddress{#1}\else
 \def\theaddress{\previousaddresses\par\vskip 3pt minus 2pt\par#1}\fi}
%
%  email
%
\def\email#1{{\let\_\relax\let~\relax\let\href\relax
              \xdef\previousemails{\theemail}}%
            \def\tempab{}\def\tempba{#1}\ifx\tempab\tempba\else
            \ifx\theemail\tempab{}\def\theemail{\href{mailto:#1}{#1}}\else
            \gdef\theemail{\previousemails, \href{mailto:#1}{#1}}\fi\fi}
%
%  url    %%% needs linking
%
\def\urladdr#1{{\let\_\relax\let~\relax\let\href\relax\xdef\previousurls{\theurl}}
            \def\tempab{}\def\tempba{#1}\ifx\tempab\tempba\else
            \ifx\theurl\tempab\def\theurl{\href{#1}{#1}}\else
            \def\theurl{\previousurls, \href{#1}{#1}}\fi\fi}
%
%  main abstract
%
\long\def\abstract#1\end%
{\long\gdef\theabstract{#1}\end}
\let\endabstract\relax
%
%  other abstracts (used just for publication)
%
\newenvironment{asciiabstract}{\eatabstract}{}%
\newenvironment{webabstract}{\eatabstract}{}%
\newenvironment{htmlabstract}{\eatabstract}{}%
\newenvironment{mathmlabstract}{\eatabstract}{}%
\long\def\eatabstract#1\end{\end}
%
%  subject class (from msp.cls--simplified)
%
\def\subject#1#2#3{%
  \def\@tempa{#1}\def\@tempb{primary}%
  \ifx\@tempa\@tempb            %%%% primary class
      \ifx\@primclass\relax
        \def\@primclass{#3}%
      \else
        \edef\old@primclass{\@primclass}\def\@primclass{\old@primclass, #3}%
      \fi
  \else\ifx\@secclass\relax%       everything not marked primary is taken
         \def\@secclass{#3}%       to be secondary
       \else
         \edef\old@secclass{\@secclass}\def\@secclass{\old@secclass, #3}%
       \fi
  \fi
}
\def\@message#1{\immediate\write16{#1}}
\def\subjclass#1{\@message{ }
     \@message{\string\subjclass\space is not supported; use
      \string\subject}\@message{You can use an
      arbitrary number of commands of the form}
      \@message{\string\subject{primary}{MSC2000}{99X88},}
      \@message{\string\subject{secondary}{MSC2000}{77X66}... etc.}
       \@message{ }} 
%
%  keywords (only used for publication)
%
\def\keyword#1{\relax}
\def\keywords#1{\@message{ }\@message{\string\keywords\space not supported; use
      \string\keyword}\@message{You can use an
      arbitrary number of commands of the form}
      \@message{\string\keyword{keyword},}
      \@message{\string\keyword{key phrase}... etc.}\@message{ }} 
%
%  dedicatory and thanks
%
\def\dedicatory#1{\def\thededicatory{#1}\@message{ }
\@message{Dedications are only permitted in exceptional cases.}
\@message{Please consult the managing editors before adding a dedication.}
\@message{Thanks etc should be given as acknowledgements at the end} 
\@message{of your introduction or at the end of the paper.}
\@message{ }\relax}
%
\def\thanks#1{\@message{ }
\@message{Thanks should not appear on the title page.}
\@message{Please give thanks as acknowledgements at the end of your 
introduction}\@message{or at the end of the paper.}
\@message{ }\relax}
%
%
%  set metadata items to \relax to initialise macros :
%
\let\thetitle\relax\let\theauthors\relax
\let\theaddress\relax\let\theemail\relax\let\theurl\relax
\let\theabstract\relax\let\theshorttitle\relax
\let\theshortauthors\relax\let\rootauthors\relax
\let\lastauthor\relax\let\@primclass\relax
\let\@secclass\relax\let\thededicatory\relax
\def\theemail{}\def\theurl{}
%
%   metadata items used just for publication
%
\def\givenname#1{\relax}
\def\surname#1{\relax}
\def\doi#1{\relax}
\def\MR#1{\relax}
\def\Zbl#1{\relax}
\def\issuenumber#1{\relax}
\def\publishedonline#1{\relax}
\def\proposed#1{\relax}
\def\seconded#1{\relax}
\def\corresponding#1{\relax}
\def\editor#1{\relax}
\def\version#1{\relax}
\def\arxivreference#1{\relax}
\def\arxivpassword#1{\relax}
%
%   metadata items used in running heads etc 
%
\def\volumenumber#1{\relax}
\def\volumename#1{\relax}
\def\publicationyear#1{\relax}
\def\papernumber#1{\relax}
\def\startpage#1{\relax}
\def\endpage#1{\relax}
\def\received#1{\def\receiveddate{#1}}
\def\revised#1{\def\reviseddate{#1}}
\let\reviseddate\relax
\def\accepted#1{\def\accepteddate{#1}}
\def\published#1{\relax}
%
%  defaults for mockup
%
\newif\ifmockup
\AtBeginDocument{\ifmockup
\def\thevolumenumber{XX}
\def\thepublicationyear{20XX}
\def\publisheddate{XX Xxxember 20XX}
\def\thestartpage{1001}
\def\theendpage{999}\else
\def\thestartpage{1}\fi}
\received{}
\revised{}
\def\thedoi{10.2140/\stitle.\thepublicationyear.\thevolumenumber.\thestartpage}
\def\theshortdoi{10.2140/\stitle}
%
% start of definition of \maketitle
%
\long\def\maketitle{
\count0=\thestartpage\ 
\vglue 10pt plus 3pt minus 3pt %% top space
%
% title :
%
{\parskip=0pt\leftskip 0pt plus 1fil{\def\\{\par\smallskip}\Large
\bf\thetitle}\par\vskip 3pt}  

\medskip
%
% authors :
%
{\parskip=0pt\leftskip 0pt plus 1fil{\sc\theauthors}
\par}
 
\vglue 20pt plus 3pt minus 3pt
%
% abstract :
% 
{\small\leftskip 25pt\rightskip 25pt\parskip 4pt plus 2pt
\theabstract
%
%  msc classes :
%
\vglue 7pt plus 2pt
\href{http://www.ams.org/mathscinet/search/mscdoc.html?code=\ifx\@primclass\relax\@secclass\else\@primclass\ifx\@secclass\relax\else,(\@secclass)\fi\fi}{{\ifx\@primclass\relax\@secclass\else\@primclass\ifx\@secclass\relax\else; \@secclass\fi\fi}}
%
%  dedicatory
%
  \ifx\thededicatory\relax\else
  \vglue 7ptplus 2pt\it\thededicatory\fi\par\medskip}}
%
%  end of definition of \maketitle
%
%  journal titles in GTP style
%
\def\gt{{\mathsurround=0pt\it $\cal G\mskip-2mu$eometry \&\ 
$\cal T\!\!$opology}}                %  The journal title in recommended style
\def\gtm{{\mathsurround=0pt\it $\cal G\mskip-2mu$eometry \&\ 
$\cal T\!\!$opology $\cal M\mskip-1mu$onographs}}  %  for monographs
\def\agt{{\mathsurround=0pt\it$\cal A\mskip-.7mu$lgebraic \&\ 
$\cal G\mskip-2mu$eometric $\cal T\!\!$opology}}  % AGT
\def\jtitle{\gt} %default
\def\stitle{gt} %default
\def\gtart{\mockuptrue}
\def\agtart{\def\jtitle{\agt}  %%% sets AGT as the journal title
\def\stitle{agt}\mockuptrue} 
\def\gtmonart{\def\jtitle{\gtm} %%% sets GTM as the journal title
\def\stitle{gtm}\mockuptrue}
%
%  headline and footline
%
\def\@oddhead{{\small\it\ifnum\count0=\thestartpage 
\ifmockup\jtitle\ \thevolumenumber\ (\thepublicationyear)
\thestartpage--\theendpage
\hfill {\bf\number\count0}\fi\else\ifodd\count0
\def\\{\unskip\space}\ifx\theshorttitle\relax \thetitle \else\theshorttitle\fi\hfill
{\bf\number\count0}\else{\bf\number\count0}
\hfill\ifx\theshortauthors\relax 
\theauthors\else\theshortauthors\fi\fi\fi}}
\let\@evenhead\@oddhead
\def\@oddfoot{{\ifmockup\small\it\ifnum\count0=\thestartpage 
{\it Published: \publisheddate}\hfil
                       \rm\href{http://dx.doi.org/\theshortdoi}{DOI: \thedoi}
\else \jtitle\ \thevolumenumber\ (\thepublicationyear)\hfill\fi\fi}}
\let\@evenfoot\@oddfoot
%
%   hacks to get various items of style correct :
%
%   set footnotes in 10pt type:
%
\let\@footnote@\footnote
\def\footnote#1{\@footnote@{\small #1}}
\let\fnote\footnote    % useful abbreviation for \footnote
%
%  set captions in 10pt type  (hack of excerpt from hyperref.sty) :
%
\long\def\@caption#1[#2]#3{%
  \hyper@makecurrent{\@captype}%
  \par\addcontentsline{\csname ext@#1\endcsname}{#1}{%
    \protect\numberline{\csname the#1\endcsname}{\ignorespaces #2}%
  }%
  \begingroup
    \@parboxrestore
    \if@minipage
      \@setminipage
    \fi
    \small
    \@makecaption{\csname fnum@#1\endcsname}{%
      \ignorespaces
      \ifHy@nesting
        \hyper@@anchor{\@currentHref}{#3}%
      \else
        \Hy@raisedlink{\hyper@@anchor{\@currentHref}{\relax}}#3%
      \fi
    }%
    \par
  \endgroup
}
%
%  command to suppress the colon in captions (hack from article.cls) :
%
\def\nocolon{%
\long\def\@makecaption##1##2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{##1##2}%
  \ifdim \wd\@tempboxa >\hsize
    ##1##2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}}
%
%  automate colon suppression
%
\let\oldcaption\caption
\def\caption{\@ifnextchar[\doublecaption\singlecaption}
\def\doublecaption[#1]#2{\oldcaption[#1]{#2}}
\def\singlecaption#1{\def\tempab{}\def\tempba{#1}\ifx\tempab\tempba
\nocolon\oldcaption{#1}\else\oldcaption{#1}\fi}
%
%  set displayskips to correct values :
%
\AtBeginDocument{\setlength{\abovedisplayskip}{\stdskip}
\setlength{\belowdisplayskip}{\stdskip}}  
%
%  get the biblio style correct (10pt with small gaps):
%
\let\@thebibliography@\thebibliography
\def\thebibliography#1 {\@thebibliography@{999}\small\parskip0pt 
plus2pt\relax\addcontentsline{toc}{section}{Bibliography}}
%
%
%  Get item spacing reasonable :
%
\let\@itemize@\itemize
\def\itemize{\@itemize@\parskip 0pt\relax}
\def\@listi{\leftmargin28.5pt\parsep 0pt\topsep 0pt 
 \itemsep4pt plus3pt minus2pt}
\let\@listI\@listi
\@listi
%
%  get enumeration labels to use \rm
%
\renewcommand{\labelenumi}{{\rm (\theenumi)}}
\renewcommand{\labelenumii}{{\rm (\theenumii)}}
\renewcommand{\labelenumiii}{{\rm (\theenumiii)}}

%  and spacing to match \itemize 
%
\let\@enumerate@\enumerate
\def\enumerate{\@enumerate@\parskip 0pt\relax}
%
%  misc definitions for comptibility with amsthm, msp.cls etc
%
\def\bysame{\leavevmode\hbox to3em{\hrulefill}\thinspace}
\def\figdir{figs}
\def\makeop#1{\expandafter\def\csname #1\endcsname{\mathop{\mathrm{#1}}\nolimits}}
\let\wtilde\widetilde
\let\wwtilde\widetilde
\let\what\widehat
\let\wwhat\widehat
\let\wbar\bar
\let\wwbar\overline
\let\proved\qedhere
%\def\Q{\mathbb{Q}}
%\def\R{\mathbb{R}}
%\def\C{\mathbb{C}}
%\def\N{\mathbb{N}}
%\def\Z{\mathbb{Z}}
\let\disablesubscriptcorrection\relax
\newenvironment{nopartheorem}{}{}
\def\half{\tfrac12}
%
% From the old style file
%

% we want period after the sectioning title numbers (and shorten the usual \quad
% between the number and the text to half an em)
\def\@seccntformat#1{\csname the#1\endcsname.\hskip0.5em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to get our numbered paragraphs, we define modified versions of
% \@startsection and \@ssect

\def\my@startsection#1#2#3#4{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #1\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \my@sect{#1}{#2}{#3}{#4}%
  }

\def\my@sect#1#2#3#4#5{%
  \refstepcounter{paragraph}%
  \protected@edef\@svsec{\theparagraph\relax}%
  \@tempskipa #2\relax
    \def\@svsechd{#3{\hskip \z@\relax\@svsec.#5}\csname #1mark\endcsname{#4}}%
  \@xsect{#2}}

% This is set up so that if we don't use subsection, we get paragraphs
% numbered as sections.paragraph, but as soon as we start a subsection, paragraphs
% will start being numbered withing subsections, and the first subsection will numbered
% one more than the preceding paragraph.

% this works if the first thing after a \section is a \subsection, or if
% there are some \paragraph's after the \section, and only then there comes a \subsection.

% If the second situation ever happens in a document, \tableofcontents will look rather funny
% because the first subsection of a section will be numbered something higher than 1. Urghhhh
% FIXME

\def\outside@subsection{%
  \@newctr{paragraph}[section]%
  \renewcommand\theparagraph{\thesection.\arabic{paragraph}}%
  }
\def\inside@subsection{%
  \setcounter{subsection}{\value{paragraph}}%
  \@newctr{paragraph}[subsection]%
  \renewcommand\theparagraph{\thesubsection.\arabic{paragraph}}%
  \let\inside@subsection\relax
  }
  
\def\pref@font{\normalfont\normalsize\bfseries}
\def\spaceafternumberinparagraphs{.25em}

\def\paragraph{\@ifnextchar[{\@paragraphx}{\@paragraph}}

\newif\if@tocparagraph
\@tocparagraphtrue

\def\@paragraphx[#1]{\my@startsection%
                                    {1.25ex \@plus1ex \@minus.2ex}%
                                    {-1ex}%
                                    {\pref@font}%
				    {\hskip\spaceafternumberinparagraphs\relax}{\hskip1ex#1}%
			\if@tocparagraph\addcontentsline{toc}{paragraph}{#1}\fi\@tocparagraphtrue}
\def\@paragraph{\my@startsection%
                                    {1.25ex \@plus1ex \@minus.2ex}%
                                    {-1ex}%
                                    {\pref@font}%
				    {\hskip\spaceafternumberinparagraphs\relax}{}}

\renewcommand*\l@paragraph{\@dottedtocline{2}{2em}{3.2em}}

% to be used when referencing paragraphs
\def\pref{%
  \@ifstar{\@ifnextchar[{\@prefx{}}{\@pref{}}}%
  	  {\@ifnextchar[{\@prefx{\pref@font}}{\@pref{\pref@font}}}%
  }

\def\@prefx#1[#2]#3{{#1\ref{#3}.\ref{#3:#1}}}%
\def\@pref#1#2{{#1\ref{#2}}}%

\outside@subsection

%

\def\statementfontshape{\slshape}

\def\pr@claim#1{%
  \par
  \addpenalty\@secpenalty
  \addvspace{1.25ex \@plus1ex \@minus.2ex}%
  \noindent{\pref@font #1}\hskip\spaceafternumeberinparagraphs
  }

\def\newmytheorem#1#2{%
\newenvironment{#1}{\@tocparagraphfalse\paragraph[#2]\statementfontshape}{\vspace{-1em}\normalfont}%
}

\newmytheorem{Theorem}{Theorem.}
\newmytheorem{Proposition}{Proposition.}
\newmytheorem{Lemma}{Lemma.}
\newmytheorem{Corollary}{Corollary.}
\newmytheorem{Definition}{Definition.}
\newmytheorem{Conjecture}{Conjecture.}

%Double brackets for power series
% Type \power{blah} to get [[blah]]
\newsavebox{\sembox}
\newlength{\semwidth}
\newlength{\boxwidth}

\newcommand{\series}[1]{%
\sbox{\sembox}{\ensuremath{#1}}%
\settowidth{\semwidth}{\usebox{\sembox}}%
\sbox{\sembox}{\ensuremath{\left[\usebox{\sembox}\right]}}%
\settowidth{\boxwidth}{\usebox{\sembox}}%
\addtolength{\boxwidth}{-\semwidth}%
\!\left[\hspace{-0.3\boxwidth}%
\usebox{\sembox}%
\hspace{-0.3\boxwidth}\right]\!\hspace{.06667em}%
}

%Double brackets for Laurent series
% Type \laurent{blah} to get ((blah))
\newsavebox{\lbox}
\newlength{\lwidth}
\newlength{\lboxwidth}

\newcommand{\laurent}[1]{%
\sbox{\lbox}{\ensuremath{#1}}%
\settowidth{\lwidth}{\usebox{\lbox}}%
\sbox{\lbox}{\ensuremath{\left(\usebox{\lbox}\right)}}%
\settowidth{\lboxwidth}{\usebox{\lbox}}%
\addtolength{\lboxwidth}{-\lwidth}%
\!\left(\hspace{-0.3\lboxwidth}%
\usebox{\lbox}%
\hspace{-0.3\lboxwidth}\right)\!\hspace{.06667em}%
}


%Double brackets for divided power series
% Type \laurent{blah} to get ((blah))
%\newsavebox{\lbox}
%\newlength{\lwidth}
%\newlength{\lboxwidth}

\newcommand{\divided}[1]{%
\sbox{\lbox}{\ensuremath{#1}}%
\settowidth{\lwidth}{\usebox{\lbox}}%
\sbox{\lbox}{\ensuremath{\langle \usebox{\lbox}\rangle}}%
\settowidth{\lboxwidth}{\usebox{\lbox}}%
\addtolength{\lboxwidth}{-\lwidth}%
\!\langle \hspace{-0.3\lboxwidth}%
\usebox{\lbox}%
\hspace{-0.3\lboxwidth}\rangle\!\hspace{.06667em}%
}

  
%

\def\eqalign#1{%
 \null\,\vcenter{\openup\jot\m@th
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      \crcr#1\crcr}}\,}
\def\eqalignbot#1{%
 \null\,\vbox{\openup\jot\m@th
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      \crcr#1\crcr}}\,}
\def\eqaligntop#1{%
 \null\,\vtop{\openup\jot\m@th
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      \crcr#1\crcr}}\,}
\def\eqalignn#1{%
 \null\,\vcenter{\openup\jot\m@th
  \ialign{\strut\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil
      &\hfil$\displaystyle{##}$&$\displaystyle{{}##}$\hfil\crcr#1\crcr}}\,}
\endinput
%
% History of gtart.cls:
% Version 1.1:  14 December 97   
% Version 1.2:  (update for AGT) 18 October 00
% Version 1.3:  \gtart, \makegtmontitle and \gtmonart added 5.01.01
% Version 1.4:  hyperef version (new file name: gtart_h.cls 15.02.04)
% Version 1.5:  hyperef+times+MSP m-data (new file name: gtpart.cls 20.12.06) 
% Version 1.6:  bug-fix for hyperref 6.75 (26.11.07)


