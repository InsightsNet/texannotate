% !TEX encoding = UTF-8 Unicode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  This file provides the asmeconf LaTeX class for formatting conference papers according to 
%%  ASME conference requirements as represented on ASME's conference web pages in 2022.
%%
%%  This file's version and date:
	\def\versionno{1.34}
	\def\versiondate{2022/12/30\space}
%%
%%  Author: John H. Lienhard, V
%%          Department of Mechanical Engineering
%%          Massachusetts Institute of Technology
%%          Cambridge, MA 02139-4307 USA
%%
%%  This LaTeX template was designed to approach the following aims:
%%
%%          1. Match ASME's current layout and font specifications
%%          2. With amseconf.bst, match ASME's reference formats including DOI & URL (replaces asmems4.bst)
%%          3. Provide hyperref compatibility for hyperlinks, pdf bookmarks, and metadata
%%          4. Set author names in either the traditional grid or the more recent inline style
%%          5. Support citations, footnotes, and bold face, sans serif math in section headings
%%			6. Provide line numbers for editing and review
%%			7. Support balancing length of columns on last page
%%			8. Provide copyright footer for federal employees and contractors
%%			9. Support the archival PDF/A standards 1b, 2b, 2u, 3b, and 3u
%%		   10. Enable various math and text features from the newtxmath and newtxtext packages
%%		   11. Support inclusion of passages in languages other than English
%%
%%  This class is compatible with either pdfLaTeX or LuaLaTeX. FontSpec may be loaded as an option (to 
%%  access language-specific fonts), but the class does not support unicode-math. 
%%
%%	Use an up-to-date LaTeX distribution: for pdfLaTeX, TeX Live 2016 or later; for LuaLaTeX, TeX Live 2021 or later.
%%  A complete LaTeX installation is also recommended: asmeconf loads ~30 packages, in addition to LaTeX core packages.
%%	All packages required by the class are in TeXLive and CTAN (https://ctan.org/). 
%%
%%  Commands for entering conference headers and author names are specific to this class.
%%  See asmeconf-template.tex for details.
%%
%%  The \section[]{} command's optional argument is changed to better support pdf bookmarks, 
%%  and \section* is modified similarly.
%%
%%  The class defines abstract (with keywords), abstract* (no keywords), and nomenclature environments. 
%%  The latter has an optional argument to control the space between the entries and the definitions.
%%
% =========================================================
%%
%% LICENSE:
%%
%% Copyright (c) 2022 John H. Lienhard
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
%% associated documentation files (the "Software"), to deal in the Software without restriction, 
%% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
%% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
%% subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in all copies or 
%% substantial portions of the Software.
%%
%% The software is provided "as is", without warranty of any kind, express or implied, including but 
%% not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. 
%% In no event shall the authors or copyright holders be liable for any claim, damages or other liability, 
%% whether in an action of contract, tort or otherwise, arising from, out of or in connection with the 
%% software or the use or other dealings in the software.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{asmeconf}[\versiondate ASME Conference Paper LaTeX Template (JHL)]

\LoadClass[twoside,twocolumn,10pt]{article}
% Even/odd page layout is not used in ASME's specs, although the papers are printed in two-sided format.

\ifdefined\NewDocumentCommand\else
  \RequirePackage{xparse} % enable older installations to access features recently moved into LaTeX kernel
\fi

\RequirePackage{etoolbox}
\RequirePackage{ifthen}

%%%%%%%%%%%%%  Test compatibility of older distributions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\providecommand\IfFormatAtLeastTF{\@ifl@t@r\fmtversion}% compare version to date

\IfFormatAtLeastTF{2017/04/15}{%
	\ClassInfo{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions 2020 or later are strongly recommended for best results}
	}{%
	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion.  Formats dated 2020 or later are recommended for the asmeconf class. Older formats may generate errors}{Please UPDATE your LaTeX distribution to obtain best results. TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  You can try to click past the errors for now.}%
}
	
\DeclareDocumentCommand\LogNote{m}{%   
	\IfFormatAtLeastTF{2021/11/01}{% 
		\ClassNoteNoLine{asmeconf}{#1}%
		}{%
	    \ClassWarningNoLine{asmeconf}{#1}%
	}
}

%% provide iftex command \ifpdftex for those still running old distributions
\IfFormatAtLeastTF{2019/11/07}{% 
	\RequirePackage{iftex}% check whether pdftex or another engine is used
	}{% 
    \LogNote{The asmeconf class requires the missing package iftex---trying a work-around.}
	% Code copied from iftex package written by the LaTeX3 Project (used under LPPL).
    % \csname and \let construct useful for hiding \ifzzz tokens from outer level \if tests.
    \def\IFTEX@let#1#2{%
      \expandafter\let\csname if#1\expandafter\endcsname
      \csname if#2\endcsname}
    % pdftex (including in dvi mode)
    \begingroup\expandafter\expandafter\expandafter\endgroup
    \expandafter\ifx\csname pdftexversion\endcsname\relax
      \IFTEX@let{pdftex}{false}
    \else
      \IFTEX@let{pdftex}{true}
    \fi
    \IFTEX@let{PDFTeX}{pdftex}
}

%%%%%%%%%%%%%% Options for the class %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=asmeconf,
  prefix=asmeconf@,
  family=pdfaopt,
  prefix=pdafopt@,
  setkeys=\kvsetkeys,
}

%%% set key [colorlinks] to have colored hyperlinks, rather than black links (use a key with new pdfmanagement, 2021/12/01)
\define@key{asmeconf}{colorlinks}[colorlinks]{%
  \PassOptionsToPackage{#1}{hyperref}%
}

%%% for mathalfa, we may now pass options in this format:  mathalfa=cal=euler, mathalfa=frak=boondox
\define@key{asmeconf}{mathalfa}{%
  \PassOptionsToPackage{#1}{mathalfa}%
}

%%% set key [nodefaultsups] to obtain newtx superiors font for footnotes.
\newboolean{DefaultSups}\setboolean{DefaultSups}{true}
\define@key{asmeconf}{nodefaultsups}[false]{%
      \setboolean{DefaultSups}{#1}
}

%%% Use these switches to load other alphabets for Cyrillic, Greek, Japanese, and Vietnamese text
\newif\ifac@cyrillic\ac@cyrillicfalse
\newif\ifac@greek\ac@greekfalse
\newif\ifac@japanese\ac@japanesefalse
\newif\ifac@vietnamese\ac@vietnamesefalse
\newif\ifac@mainset\ac@mainsetfalse

\providecommand\ac@TtwoA{}
\providecommand\ac@LGR{}
\providecommand\ac@Tfive{}

%%% Test whether main language is from a group that use the Cyrillic alphabet
\NewDocumentCommand\@FindCyr{>{\SplitList{;}}m}{\ProcessList{#1}{\@FlagCyr}}
\providecommand{\ac@main}{\relax}
\NewDocumentCommand\@FlagCyr{m}{%
	\ifthenelse{\equal{#1}{\ac@main}}{\ac@cyrillictrue\def\ac@TtwoA{T2A}}{\relax}% comparing strings
}

\define@key{asmeconf}{main}[english]{%
	  \PassOptionsToPackage{main=#1,#1}{babel}% added #1 resolves conflict of russianb.ldf & ukrainianb.ldf under "main=".
	  \ac@mainsettrue
	  \ifthenelse{\equal{#1}{english}}{%
			\PassOptionsToPackage{pdflang=en}{hyperref}}{%
			\LogNote{Selecting #1 as the primary language}%
			\ifthenelse{\equal{#1}{greek}}{%
				\ac@greektrue
				\def\ac@LGR{LGR}%
			}{\relax}%
			\ifthenelse{\equal{#1}{vietnamese}}{%
				\ac@vietnamesetrue
				\def\ac@Tfive{T5}%
				\RequirePackage[vietnamese=nohyphenation]{hyphsubst}% Eliminates babel warning
			}{\relax}%				
			\def\ac@main{#1}%
			\@FindCyr{russian;belarusian;bulgarian;macedonian;serbianc;ukrainian}
	  }%
}
\define@key{asmeconf}{vietnamese}[]{%
	\RequirePackage[vietnamese=nohyphenation]{hyphsubst}% using key, not option, to allow loading package w/o babel warning.
	\PassOptionsToPackage{vietnamese}{babel}%
	\ac@vietnamesetrue
	\def\ac@Tfive{T5}%
}

%%% only main= is actually needed, but keeping these legacy commands for backward compatibility
\define@key{asmeconf}{lang}[english]{%  deprecated option
	  \PassOptionsToPackage{main=#1,#1}{babel}%
      \PassOptionsToPackage{pdflang=en}{hyperref}
	  \ac@mainsettrue%
	  \ifthenelse{\equal{#1}{english}}{%
			\relax}{%
			\LogNote{Selecting #1 as the primary language}%
	  }%
}
\define@key{asmeconf}{lang-second}[english]{% deprecated option
      \PassOptionsToPackage{#1}{babel}%
}
\define@key{asmeconf}{lang-third}[english]{%  deprecated option
      \PassOptionsToPackage{#1}{babel}%
}

\DeclareDefaultOption{}% suppress warning about unused mathalfa option, 2021/06/15
\ProcessKeyvalOptions{asmeconf}

%% if main language was not chosen explicitly, default to English
\ifac@mainset\relax\else
	\PassOptionsToPackage{main=english}{babel}%
	\PassOptionsToPackage{pdflang=en}{hyperref}
	\ClassInfo{asmeconf}{Selecting English as the primary language, since main= not set}%
\fi

%% Turn off these keys now that we're done with them
\def\@KeyFamily{asmeconf}
\NewDocumentCommand\ac@DisableOption{m}{%
  \DisableKeyvalOption[%
    action=ignore,%
    class=asmeconf%
  ]{#1}{\@KeyFamily}%
}
\NewDocumentCommand\@DisableKeys{>{\SplitList{;}}m}{\ProcessList{#1}{\ac@DisableOption}}

\@DisableKeys{main;lang;nodefaultsups;mathalfa;lang-second;lang-third;vietnamese}


%%%%%%%%%%%%%   More Language options  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% option to use fontspec [fontspec] (for complex language-specific fonts)
\newif\ifac@fontspec\ac@fontspecfalse
\newif\iffontspecloaded\fontspecloadedfalse% so user can test in .tex file
\DeclareOption{fontspec}{%
	\ifpdftex
		\ClassWarningNoLine{asmeconf}{fontspec option requires LuaLaTeX, will be ignored under pdfLaTeX}%
	\else
        \IfFormatAtLeastTF{2020/10/01}{%
        	\ClassInfo{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions after 2020 are needed with [fontspec] for language support}
    		\ac@fontspectrue
    		\fontspecloadedtrue
    	    \def\ssztwo{}% for Inconsolatazi4; default uses slashed zero, +ss02 uses regular zero
    	    \def\MonoNotMono{WordSpace={1,1.33,1.67}}% for Inconsolatazi4; default allows word spacing (is not mono)	
        	}{%
        	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion.  LaTeX installations dated 2020/10/01 or later are needed for the [fontspec] option. Option [fontspec] will be ignored. Language support will be minimal}{Please UPDATE your LaTeX distribution to obtain best results. TeX Live is available for download at no charge: \string https://www.tug.org/texlive/}%
        }
	\fi
}

\DeclareOption{japanese}{% mainly to control loading of fontspec options
	\ifac@fontspec	
		\PassOptionsToPackage{japanese}{babel}%
		\ac@japanesetrue
	\else
		\ClassWarningNoLine{asmeconf}{japanese option is supported only with the [fontspec] option + LuaLaTeX. It will be ignored}%
	\fi
}

\DeclareOption{greek}{%
	\PassOptionsToPackage{greek}{babel}%
	\ac@greektrue
	\def\ac@LGR{LGR}%
}

%% Cyrillic languages
\NewDocumentCommand\@CyrOptions{>{\SplitList{;}}m}{\ProcessList{#1}{\@CyrOptSet}}
\NewDocumentCommand\@CyrOptSet{m}{%
	\DeclareOption{#1}{%
		\PassOptionsToPackage{#1}{babel}%
		\ac@cyrillictrue
		\def\ac@TtwoA{T2A}%
	}
}
\@CyrOptions{russian;belarusian;bulgarian;macedonian;serbianc;ukrainian}

% Several languages do not have .ldf files to load. Babel will call these on demand.
%
\DeclareOption{arabic}{\ClassError{asmeconf}{Do not specify "arabic" as a class option}{Instead, give the option [bidi=basic] and specify "arabic" when you call the language within your document.}}
%
\DeclareOption{bengali}{\ClassError{asmeconf}{Do not specify "bengali" as a class option}{Babel does not have an ldf file for Bengali. Instead, specify "bengali" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{chinese-simplified}{\ClassError{asmeconf}{Do not specify "chinese-simplified" as class option}{Babel does not have an ldf file for simplified Chinese. Instead, specify "chinese-simplified" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{chinese-traditional}{\ClassError{asmeconf}{Do not specify "chinese-traditional" as class option}{Babel does not have an ldf file for traditional Chinese. Instead, specify "chinese-traditional" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{chinese}{\ClassError{asmeconf}{Do not specify "chinese" as a class option}{Instead, specify either "chinese-simplified" or "chinese-traditional" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{hindi}{\ClassError{asmeconf}{Do not specify "hindi" as a class option}{Babel does not have an ldf file for Hindi. Instead, specify "hindi" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{marathi}{\ClassError{asmeconf}{Do not specify "marathi" as a class option}{Babel does not have an ldf file for Marathi. Instead, specify "marathi" when you call the language within your document. No class option is needed.}}
%
\DeclareOption{korean}{\ClassError{asmeconf}{Do not specify "korean" as class option}{Babel does not have an ldf file for Korean. Instead, specify "korean"when you call the language within your document. No class option is needed.}}
%
\DeclareOption{tamil}{\ClassError{asmeconf}{Do not specify "tamil" as a class option}{Babel does not have an ldf file for Tamil. Instead, specify "tamil" when you call the language within your document. No class option is needed.}}


%%%%%%%   PDF/A Compliance Options  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifac@setpdfa\ac@setpdfafalse
\newif\ifac@pdfaone\ac@pdfaonefalse

\ifpdftex %% PDF/A compliance has only been configured for pdflatex
%
	%%% set key [pdfa] to activate pdf/a compliance (default is pdf/A-3u)
	\define@key{pdfaopt}{pdf-a}[true]{%
	  \IfFormatAtLeastTF{2018/12/01}{%
	  	\ClassInfo{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions 2019 or later are necessary with the [pdf-a] option}
	  	}{%
	  	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion.  Formats dated 2018/12/01 or later are necessary for the [pdf-a] option. Older formats may generate errors}{Please UPDATE your LaTeX distribution to obtain best results. TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  Meanwhile, you can remove the [pdf-a] option and try again}%
	  }
      \ac@setpdfatrue
      \PassOptionsToPackage{pdfa,pdfapart=3,pdfaconformance=u}{hyperref}% note: hyperref takes these options if hyperxmp is loaded
	}
	%%% to select part 1, 2 or 3 
	\define@key{pdfaopt}{pdfapart}[3]{%
      \PassOptionsToPackage{pdfapart=#1}{hyperref}%
	  \ifthenelse{\equal{#1}{1}}{\ac@pdfaonetrue}{\relax}%
	}
	%%% to select conformance b or u.  NB: a is not possible with pdfLaTeX, and u is not possible with 1.
	\define@key{pdfaopt}{pdfaconformance}[u]{%
      \PassOptionsToPackage{pdfaconformance=#1}{hyperref}%
	}
\else
	\define@key{pdfaopt}{pdf-a}[true]{%
      \ac@setpdfatrue
    }
\fi

\ProcessKeyvalOptions{pdfaopt}%

%% Done with these keys, so we can now disable them
\def\@KeyFamily{pdfaopt}
\@DisableKeys{pdf-a;pdfapart;pdfaconformance}


%%%%%%%%%  Miscellaneous options  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% option to balance column height on last page [balance] 
\newif\ifac@balance\ac@balancefalse
\DeclareOption{balance}{%
	\ac@balancetrue
	\LogNote{Loading flushend package to balance column height on last page}%
}

%%% option to obtain line numbers [lineno] 
\newif\ifac@lineno\ac@linenofalse
\DeclareOption{lineno}{\ac@linenotrue}

%% option to omit ASME footer [nofoot]
\newif\ifac@nofoot\ac@nofootfalse
\DeclareOption{nofoot}{\ac@nofoottrue}


%%% option [contractor] to obtain government contractor copyright notice.
\newif\ifac@contractor\ac@contractorfalse
\DeclareOption{contractor}{\ac@contractortrue}

%%% option [govt] to obtain government employee copyright notice.
\newif\ifac@govt\ac@govtfalse
\DeclareOption{govt}{\ac@govttrue}

%% option to convert inline author data to a grid of authors
\newboolean{grid}\setboolean{grid}{false}
\DeclareOption{grid}{%
	\setboolean{grid}{true}%
	\LogNote{Selected option for a grid of author blocks}%
}
%% option to directly use grid of authors
\newboolean{Oldauthors}\setboolean{Oldauthors}{false}
\DeclareOption{authorgrid}{%
	\setboolean{Oldauthors}{true}%
	\LogNote{Selected option for a grid of author blocks}%
}
\DeclareOption{oldauthors}{%% deprecated, but retained for backward compatibility
	\setboolean{Oldauthors}{true}%
	\LogNote{Selected option for a grid of author blocks}%
}

%% option for slightly larger small capitals font, via newtxtext
\DeclareOption{largesc}{%
	\ifac@fontspec
		\ClassWarningNoLine{asmeconf}{largesc option is not available under fontspec, will be ignored}%
	\else
		\PassOptionsToPackage{largesc=true}{newtxtext}% largesc is a boolean key in newtxtext
	\fi
}

%% Disable newtxtext osf option, which is not appropriate for documents in this class
\DeclareOption{osf}{%
	\PassOptionsToPackage{lining}{newtxtext}%
}

%% option to hyphenate the typewriter font [hyphenate] and to issue a warning when that's done.
\DeclareOption{hyphenate}{%
	\ifac@fontspec
		\ClassWarningNoLine{asmeconf}{hyphenate option is not supported by fontspec, will be ignored}%
	\else
		\PassOptionsToPackage{hyphenate}{inconsolata}% hyphenate is a key via xkeyval in inconsolata
		\LogNote{Allowing hyphenation of typewriter font}%
	\fi
}
%% option for monospacing in typewriter font [mono].
\DeclareOption{mono}{%
	\ifac@fontspec
		\def\MonoNotMono{}%
	\else
		\PassOptionsToPackage{mono}{inconsolata}% mono is a key via xkeyval in inconsolata
	\fi
}
%% option for unslashed zero typewriter font [var0].
\DeclareOption{var0}{%
	\ifac@fontspec
		\def\ssztwo{+ss02}% stylistic alternate for regular zero
	\else
		\PassOptionsToPackage{var0}{inconsolata}% var0 is a key via xkeyval in inconsolata
	\fi
}

\ifthenelse{\boolean{DefaultSups}}{%
		\ifac@fontspec\relax\else
			\PassOptionsToPackage{defaultsups=true}{newtxtext}% defaultsups is a boolean key in newtxtext
		\fi}{\relax}

%% Suppress warnings about unused global options
\DeclareOption*{}

\ProcessOptions \relax

%%%%%%%%%%%%%  Geometry, bibliography, graphics, colors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[letterpaper, left=0.5in, right=0.5in, top=0.5in, bottom = 1.in, footskip=0.5in, columnsep=0.38in]{geometry}
% conforms to ASME required margins
\setlength\parindent{0.25in}

\RequirePackage[sort&compress,numbers]{natbib} 
\setlength\bibsep{1pt plus 1pt minus 1pt}

\RequirePackage{graphicx} 
\ifpdftex\def\MyColorOption{fixpdftex}\else\ifluatex\def\MyColorOption{luatex}\else\def\MyColorOption{}\fi\fi
\RequirePackage[hyperref,\MyColorOption,dvipsnames,svgnames,x11names]{xcolor}

%%%%%%%%%%%%  Table related %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{booktabs}
\RequirePackage{array} 

\RequirePackage{dcolumn}% alignment on decimal places 
\newcolumntype{d}[1]{D{.}{.}{#1}}% NB: This conflicts with babel's Spanish language option which makes "." an active character.
								 % To use "," separator, put this command in your preamble: \newcolumntype{d}[1]{D{,}{,}{#1}}

%%%%%%%%%%%%  PDF/A compliance related  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifpdftex % moved fontenc 2021/01/31
	\ifac@pdfaone
		\pdfminorversion=4 % for pdf/a-1 need version 4, not 7
	\else
  		\pdfminorversion=7 % this selection is not essential.
	\fi
	\RequirePackage[\ac@TtwoA,\ac@LGR,\ac@Tfive,T1]{fontenc}% T2A - Cyrillic (w/o babel warning); LGR - Greek; T5 - Vietnamese; put T1 last 22/03/10
  	\RequirePackage[utf8]{inputenc} % for backward compatibility with pre-2018 LaTeX distributions
\else
	\ifluatex
		\ifac@setpdfa\ClassWarningNoLine{asmeconf}{pdf-a option requires pdfLaTeX engine. Under LuaLaTeX, use %
			\protect\DocumentMetadata{pdfstandard=A-3b} before \protect\documentclass[..]{asmeconf}}%
		\fi
    	\directlua{
            if pdf.getminorversion() \string~= 7 then
              if (status.pdf_gone and status.pdf_gone > 0)
              or (status.pdf_ptr and status.pdf_ptr > 0) then
                tex.error("PDF version cannot be changed anymore")
              else
                pdf.setminorversion(7)
              end
            end
        }
	\else 
  		\ClassError{asmeconf}{Please use either pdfLaTeX or LuaLaTeX}{This class has NOT been configured to support other engines, and the results will be unpredictable. Your best course of action is to exit and rerun using either pdfLaTeX or LuaLaTeX.}%
	\fi
\fi

%%%%%%%%%  Caption related  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Needs to come before babel messes with captions, to keep uppercase text. 2021/12/25

\ifx\AddToNoCaseChangeList\@undefined % updated July 3, see https://github.com/John02139/asmeconf/issues/5 
	\RequirePackage{textcase} %% Allows uppercase titles and captions without errors from math and citations
	\typeout{Asmeconf is loading textcase package.}
\else
	\NewCommandCopy{\MakeTextUppercase}{\MakeUppercase}
\fi

\RequirePackage[labelfont={sf,bf},hypcap=false]{caption}
\RequirePackage[hypcap=false,list=true]{subcaption}

\DeclareCaptionLabelFormat{uppercase}{\MakeTextUppercase{#1} #2}
\DeclareCaptionTextFormat{boldmath}{\mathversion{sansbold}#1}
\captionsetup[figure]{labelformat=uppercase, labelfont={sf,bf,small},textfont={sf,bf,small},textformat=boldmath,labelsep=colon}
\captionsetup[table]{labelformat=uppercase, labelfont={sf,bf,small},textfont={sf,bf,small},textformat=boldmath,labelsep=colon,skip=0.5\baselineskip} %name=TABLE,

%% This construction avoids a failure of hyperref in relation to uppercase caption
%% Discussion: https://tex.stackexchange.com/questions/375695/maketextuppercase-inside-table-captions
\AtBeginDocument{
   \let\scaption\caption
   \renewcommand*{\caption}[2][\shortcaption]{\def\shortcaption{#2}\scaption[#1]{\MakeTextUppercase{#2}}}
}

%%%%%%%%%%%%  Font related  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{mathtools}% loads and extends amsmath

%\def\BabelCaseHack{} %see https://github.com/latex3/babel/issues/193; using this will affect Medieval Latin and a few other languages. 
% Babel update has corrected this issue 24 October 2022.
\RequirePackage[]{babel} 

\ifpdftex
    \RequirePackage[helvratio=.91]{newtxtext}% rescaled 22/03/10
    \RequirePackage[varqu,varl,scale=1.05]{inconsolata}% sans typewriter font % rescaled 22/03/10
    \RequirePackage[]{newtxmath}
\else
    \ifac@fontspec
        \RequirePackage[varqu,varl]{inconsolata}  % typewriter font for math 
        \renewcommand\rmdefault{ntxtlf}           % roman font for math
		\RequirePackage[T1]{fontenc} 			  % qhv is not TU encoded, 2021/12/24
	        \DeclareFontFamily{T1}{\sfdefault}{}  % sf for math
	        \DeclareFontShape{T1}{\sfdefault}{m}{n}{<-> s*[0.94] ec-qhvr}{} %% see t1qhv.fd; 0.9-->0.94 2022/01/15
        \RequirePackage[]{newtxmath}			  % newtxmath still handles mathematics        
        \RequirePackage[no-math]{fontspec}
        \defaultfontfeatures{Ligatures=TeX,}
%        
        \setmainfont{TeXGyreTermesX}[% Presumes these are system fonts! Available at: http://www.gust.org.pl/projects/e-foundry/tex-gyre
 			WordSpace = {1,1.4,1},%% This stretch matches newtxtext a little better. 1.4
        	Extension = .otf,
        	UprightFont = *-Regular,
        	ItalicFont = *-Italic,
        	BoldFont = *-Bold,
        	BoldItalicFont = *-BoldItalic,
			Numbers = Lining,
			]
        \setsansfont{texgyreheros}[% Presumes these are system fonts! Available at: http://www.gust.org.pl/projects/e-foundry/tex-gyre
 			WordSpace = {1,1.4,1},
			Extension = .otf,
        	UprightFont = *-regular,
        	ItalicFont = *-italic,
        	BoldFont = *-bold,
        	BoldItalicFont = *-bolditalic,
			Numbers = Lining,
        	Scale=0.91,% same as for newtx; former value 0.9 too small 2022/01/15
			]        
       \setmonofont{Inconsolatazi4}[% This otf font ships with the LaTeX Inconsolata package (it's in TeX Live)
            \MonoNotMono,% match newtxtext if we enable wordspacing
            Scale=1.05,% rescaled from 1, 22/03/10
            Extension = .otf,
            UprightFont = *-Regular,
            ItalicFont = *-Regular,% has no italic face
            BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
            RawFeature = {+ss01,\ssztwo,+ss03},
            ]          
%    
        % For many languages, using babel commands helps font loading. 
        % Noto fonts are available at https://github.com/googlefonts
    	\def\Noto@scale{0.92}
	   	\def\Ara@scale{0.91}% For the serif font only
    	\def\NotoBan@scale{0.92}% 1.} should probably stay consistent within the Noto family.
    	\def\NotoDev@scale{0.92}% 1.} should probably stay consistent within the Noto family.
    	\def\NotoTam@scale{0.92}
		\def\Noto@color{black}	
%
        \babelprovide[import, language=Default]{arabic}
        \babelfont [arabic]{rm}[Scale=\Ara@scale,
	 		 Renderer=HarfBuzz,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% don't use italic face, I am told
			 BoldFont = *-Bold,%
        	 BoldItalicFont = *-Bold,% don't use italic face, I am told
			 ]{Amiri}% NotoNaskhArabic}% Some readers prefer Amiri font
        \babelfont [arabic]{sf}[Scale=\Noto@scale,
	 		 Renderer=HarfBuzz,
             Extension =.ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% font has no italic face
			 BoldFont = *-SemiBold,% I'm told that legibility better than Bold
        	 BoldItalicFont = *-SemiBold,% font has no italic face
			 ]{NotoSansArabic}%DejaVuSans}%NotoKufiArabic}% .otf,%
        \babelfont [arabic]{tt}[%
	 		 Renderer=HarfBuzz,
             Extension =.ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-SemiBold,% I'm told that legibility is better than Bold
        	 BoldItalicFont = *-SemiBold,% has no italic face
			 ]{NotoSansArabic}%same as above!
        \providecommand\arabicabstractname{ملخص}% NB: utf-8
%
        \babelprovide[import,language=Default,script=Bangla]{bengali}
        \babelfont [bengali]{rm}[%
	 		 Renderer=HarfBuzz,
             Scale=\NotoBan@scale,% same as Devanagari
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
        ]{NotoSerifBengali}
        \babelfont [bengali]{sf}[%
	 		 Renderer=HarfBuzz,
             Scale=\NotoBan@scale,
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
        ]{NotoSansBengali}
        \babelfont [bengali]{tt}[
	 		 Renderer=HarfBuzz,
			 Scale=\NotoBan@scale,
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansBengali}		
%
        % Cyrillic languages
		\NewDocumentCommand\@LoadBabelCyr{>{\SplitList{;}}m}{\ProcessList{#1}{\@CyrillicBabel}}
		\NewDocumentCommand\@CyrillicBabel{m}{%
        	\babelprovide[import,language=Default,script=Cyrillic]{#1}
            \babelfont [#1]{rm}[%
            	Scale=\Noto@scale,
    			Color=\Noto@color,
    			Extension = .ttf,
                UprightFont = *-Regular,
                ItalicFont = *-Italic,
                BoldFont = *-Bold, 
            	BoldItalicFont = *-BoldItalic,%
            ]{NotoSerif}
            \babelfont [#1]{sf}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,
   				Extension = .ttf,
                UprightFont = *-Regular,
                ItalicFont = *-Italic,
                BoldFont = *-Bold, 
            	BoldItalicFont = *-BoldItalic,%
			]{NotoSans}
            \babelfont [#1]{tt}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,
				Extension = .ttf,
				UprightFont = *-Regular,
    			ItalicFont = *-Regular,% has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
			]{NotoSansMono}
		}
		\@LoadBabelCyr{russian;belarusian;bulgarian;macedonian;serbian-cyrillic;ukrainian}% serbianc has no .ini under fontspec
		\setlocalecaption{serbian-cyrillic}{abstract}{Сажетак}% NB: utf-8
%
        % Devanagari languages
        \newfontscript{Devanagari}{deva}% HarfBuzz has some problems in Hindi, see babel manual Sect. 1.13 (main issue is ra)
		\NewDocumentCommand\@LoadBabelDev{>{\SplitList{;}}m}{\ProcessList{#1}{\@DevBabel}}
		\NewDocumentCommand\@DevBabel{m}{%
        	\babelprovide[import,language=Default]{#1}
            \babelfont [#1]{rm}[%
%		 		 Renderer=HarfBuzz,% works for Marathi, throws errors in Hindi...
                 Scale=\NotoDev@scale,
                 Color=\Noto@color,
                 Extension = .ttf,
    			 UprightFont = *-Regular,
    			 ItalicFont = *-Regular,% has no italic face
    			 BoldFont = *-Bold, 
            	 BoldItalicFont = *-Bold,% has no italic face
             ]{NotoSerifDevanagari}
            \babelfont [#1]{sf}[%
%		 		 Renderer=HarfBuzz,% works for Marathi, throws errors in Hindi...
                 Scale=\NotoDev@scale,
                 Color=\Noto@color,
                 Extension = .ttf,
    			 UprightFont = *-Regular,
    			 ItalicFont = *-Regular,% has no italic face
    			 BoldFont = *-Bold, 
            	 BoldItalicFont = *-Bold,% has no italic face
             ]{NotoSansDevanagari}
            \babelfont [#1]{tt}[
%		 		 Renderer=HarfBuzz,% works for Marathi, throws errors in Hindi...
                 Scale=\NotoDev@scale,
                 Color=\Noto@color,
                 Extension = .ttf,
    			 UprightFont = *-Regular,
    			 ItalicFont = *-Regular,% has no italic face
    			 BoldFont = *-Bold, 
            	 BoldItalicFont = *-Bold,% has no italic face
			 ]{NotoSansDevanagari}		
		}
		\@LoadBabelDev{hindi;marathi;kashmiri;nepali;sanskrit}
		% No .ldf files for these languages, but they do have .ini files. Nepali: no abstractname
%
		% Greek
		\babelprovide[import,language=Default]{greek}
        \babelfont [greek]{rm}[%
        	Scale=\Noto@scale,
			WordSpace={1.1},% increase word spacing slightly
			Color=\Noto@color,
			Extension = .ttf,
            UprightFont = *-Regular,
            ItalicFont = *-Italic,
            BoldFont = *-Bold, 
        	BoldItalicFont = *-BoldItalic,%
		]{NotoSerif}
        \babelfont [greek]{sf}[%
        	Scale=\Noto@scale,
			WordSpace={1.1},% increase word spacing slightly
			Color=\Noto@color,
			Extension = .ttf,
            UprightFont = *-Regular,
            ItalicFont = *-Italic,
            BoldFont = *-Bold, 
        	BoldItalicFont = *-BoldItalic,%
		]{NotoSans}
        \babelfont [greek]{tt}[%
            Scale=\Noto@scale,
			Color=\Noto@color,
			Extension = .ttf,
			UprightFont = *-Regular,
    		ItalicFont = *-Regular,% has no italic face
    		BoldFont = *-Bold, 
            BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansMono}
%      
        % Japanese
        \ifac@japanese
        	\RequirePackage[match]{luatexja-fontspec}% japanese typesets *much* better with this loaded
            \setmainjfont{NotoSerifCJKjp}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,
%    			Extension = .otf,
    			UprightFont = *-Regular,
    			ItalicFont = *-Regular,% has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
			]
            \setsansjfont{NotoSansCJKjp}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,
%    			Extension = .ttc,
    			UprightFont = *-Regular,
    			ItalicFont = *-Regular,%  has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
			]
            \setmonojfont{NotoSansMonoCJKjp}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,	
    			UprightFont = *-Regular,
    			ItalicFont = *-Regular,%  has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
			]
            \ltjsetparameter{jacharrange={-1, -2, +3, -4, -5, +6, +7, +8}}% this prevents luatexja from breaking Russian and Greek.
            % see: https://tex.stackexchange.com/questions/222320/russian-in-document-with-japanese-as-main-language-lualatex-ltjsarticle
    		% Need at least one of the following to load the Japanese dictionary.
    		\babelfont [japanese]{rm}[%
    			Scale=\Noto@scale,
    			Color=\Noto@color,
    			Extension = .otf,
    			UprightFont = *-Regular,
    			ItalicFont = *-Regular,% has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
    			]{NotoSerifCJKjp}% Scale estimated
        	\babelfont [japanese]{sf}[%
            	Scale=\Noto@scale,
    			Color=\Noto@color,
 %   			Extension = .ttc,
    			UprightFont = *-Regular,
    			ItalicFont = *-Regular,%  has no italic face
    			BoldFont = *-Bold, 
            	BoldItalicFont = *-Bold,% has no italic face
			]{NotoSansCJKjp}
            \babelfont [japanese]{tt}[%
            	Scale=\Noto@scale,
				Color=\Noto@color,
%				Extension = .ttc,
				UprightFont = *-Regular,
				ItalicFont = *-Regular,%  has no italic face
				BoldFont = *-Bold, 
        		BoldItalicFont = *-Bold,% has no italic face
			]{NotoSansMonoCJKjp}% renders same as Sans!
		\fi
		% Note: \japaneseabstractname is not defined if japanese is not called as a package option.
				
		% Korean
		\babelprovide[import,language=Default]{korean}
        \babelfont [korean]{rm}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
			Extension = .otf,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
        ]{NotoSerifCJKkr}
        \babelfont [korean]{sf}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
			Extension = .ttc,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansCJK}
        \babelfont [korean]{tt}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
%			Extension = .ttc,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansMonoCJKkr}
        \renewcommand\koreanabstractname{초록}% NB: utf-8

		% Simplified Chinese
		\babelprovide[import,language=Default]{chinese-simplified}
        \babelfont [chinese-simplified]{rm}[%
        	Scale=\Noto@scale,
        	Color=\Noto@color,
        	Extension = .otf,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSerifCJKsc}
        \babelfont [chinese-simplified]{sf}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
			Extension = .ttc,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansCJK}
        \babelfont [chinese-simplified]{tt}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
%			Extension = .ttc,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansMonoCJKsc}
%
		% Traditional Chinese (includes characters for Cantonese also)
		\babelprovide[import,language=Default]{chinese-traditional}
        \babelfont [chinese-tradiational]{rm}[%
        	Scale=\Noto@scale,
        	Color=\Noto@color,
        	Extension = .otf,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSerifCJKtc}
        \babelfont [chinese-traditional]{sf}[%
        	Scale=\Noto@scale,
			Color=\Noto@color,
			Extension = .ttc,
			UprightFont = *-Regular,
			ItalicFont = *-Regular,%  has no italic face
			BoldFont = *-Bold, 
        	BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansCJK}
        \babelfont [chinese-traditional]{tt}[Scale=\Noto@scale,Color=\Noto@color]{NotoSansMonoCJKtc}
%
        \babelprovide[import,language=Default]{tamil}
        \babelfont [tamil]{rm}[%
	 		 Renderer=HarfBuzz,
             Scale=\NotoTam@scale,
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
        ]{NotoSerifTamil}
        \babelfont [tamil]{sf}[%
	 		 Renderer=HarfBuzz,
             Scale=\NotoTam@scale,
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
        ]{NotoSansTamil}
        \babelfont [tamil]{tt}[
	 		 Renderer=HarfBuzz,
			 Scale=\NotoTam@scale,
             Color=\Noto@color,
             Extension = .ttf,
			 UprightFont = *-Regular,
			 ItalicFont = *-Regular,% has no italic face
			 BoldFont = *-Bold, 
        	 BoldItalicFont = *-Bold,% has no italic face
		]{NotoSansTamil}		
%
	\babelprovide[import, captions/abstract = Muhtasari, language = Default]{swahili}
%	
    \else % use lualatex without font support for other languages (easier set-up and still enables luacode for numerics)
    	  % extensive edits 2022/03/14
		\renewcommand*\rmdefault{ntxtlf}          % roman font for math
		\RequirePackage[T1]{fontenc} 			  % qhv and zi4 are not TU encoded, 2021/12/24
	    	\DeclareFontFamily{T1}{\sfdefault}{}  % sf for math
	    	\DeclareFontShape{T1}{\sfdefault}{m}{n}{<-> s*[0.94] ec-qhvr}{} %% see t1qhv.fd; 0.9-->0.94 2022/01/15
	    	\DeclareFontFamily{T1}{zi4}{}% typewriter (Inconsolata)
	    	\DeclareFontShape{T1}{zi4}{m}{n}{<-> s*[1.05] t1-zi4r-5}{}% with options varl and var qu
	    	\DeclareFontShape{T1}{zi4}{b}{n}{<-> s*[1.05] t1-zi4b-5}{} 
	    	\DeclareFontShape{T1}{zi4}{bx}{n}{<-> s*[1.05] t1-zi4b-5}{} 
		\RequirePackage[]{newtxmath} % options will be as passed from newtx
		\RequirePackage[type1text,nofontspec,helvratio=0.91]{newtxtext}% will lose some accented characters this way ... better to use fontspec
		\@ifpackagelater{newtxtext}{2022/02/28}{\relax}{%
			\ClassWarning{asmeconf}{Your copy of the newtxtext package is older than 2022/02/28, so you will see error messages about unknown options 'type1text' and 'nofontspec'. You can click through these for now, but I recommend you update your LaTeX installation for best results.}
		}
		\providecommand*{\DeclareFontFamilySubstitution}[3]{\relax}% folks with old latex formats will get a different typewriter font...
		\AtBeginDocument{%
			\DeclareFontFamilySubstitution{T1}{\ttdefault}{zi4}
		}
	\fi
\fi

\RequirePackage[]{mathalfa}% load optional fonts for Calligraphy, Script, Fraktur. Key format: mathalfa=cal=euler (etc.)
\RequirePackage{bm}%   		 load after all math to give further access to bold math

%% option not to use latex default superscripts; if fontspec loaded, use the superiors package.
\ifthenelse{\boolean{DefaultSups}}{\relax}{%
	\ifac@fontspec
		\RequirePackage{superiors}% must come after text font is loaded			
	\else
		\relax
	\fi
}

%% override \textsu if using default superiors
\ifthenelse{\boolean{DefaultSups}}{\let\textsu\textsuperscript}{\relax}

%% Ensure that the current font is used for equation tags, not \normalfont as set by amsmath
\def\maketag@@@#1{\hbox{\m@th#1}}

% The article class calls \sloppy in two-column mode (\tolerance 9999, \emergencystretch 3em)
% The following adjustments affect line breaking; the values below are intended to produce
% fewer lines with large spaces, without creating the problems of using \fussy in two-column mode.
\tolerance 2500
\emergencystretch 3em 

\RequirePackage{metalogo,hologo}% Access various LaTeX logos if needed

%% font size selection  
%% ASME's specs differ slightly from latex standard article-10 class 

\renewcommand\LARGE{\@setfontsize\LARGE{16}{19.2}}              %{18}{21.6}}  updated 2019/7/7 to match new ASME spec.  
                                                                % ...default is 17.28/22 ... used for paper#
\renewcommand\large{\@setfontsize\large{11}{13.6}}              % default is 12/14 ... used for headings

%\renewcommand\Large{\@setfontsize\Large{14.4}{18}}             % same as default
%\renewcommand\normalsize{\@setfontsize\normalsize{10}{12}}     % same as default
%\renewcommand\small{\@setfontsize\small{9}{11}}                % same as default
%\renewcommand\footnotesize{\@setfontsize\footnotesize{8}{9.5}} % same as default


%% This provides sans-serif italic and sans-serif bold italic math.
%% These fonts are for use in the figure captions and section headings. 
%% Use \mathbf{..}, \mathversion{bold}, or \bm{..} elsewhere.
\DeclareMathVersion{sansbold}
\SetSymbolFont{letters}{sansbold}{OML}{ntxsfmi}{b}{it}
\SetSymbolFont{lettersA}{sansbold}{U}{ntxsfmia}{b}{it}
\IfFormatAtLeastTF{2016/01/05}{%
	\SetSymbolFont{symbols}{sansbold}{LMS}{ntxsy}{b}{n}
	}{\relax}
\SetSymbolFont{largesymbols}{sansbold}{LMX}{ntxexx}{b}{n}%  added 25 Jan 2021
\SetSymbolFont{largesymbolsTXA}{sansbold}{U}{ntxexa}{b}{n}% added 25 Jan 2021
\SetSymbolFont{operators}{sansbold}{\encodingdefault}{\sfdefault}{\bfdefault}{n}
\SetMathAlphabet{\mathsf}{sansbold}{\encodingdefault}{\sfdefault}{b}{n}% changed from it, 2021/01/31: \mathsf is upright.


% Nice solution from DPC to prevent aux file errors (due to active characters from babel) when switching from pdflatex to lualatex.
\ifx\directlua\undefined
	\AtBeginDocument{\immediate\write\@auxout{\detokenize{%
	 \ifx\directlua\undefined\else\endinput\fi}}}
\fi


%%%%%%%%  Footers and Footnotes  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{fancyhdr}
\pagestyle{fancy}

\AtBeginDocument{\edef\@EncodingMain{\encodingdefault}}
\NewDocumentCommand\@SetFont{}{\fontencoding\@EncodingMain\selectfont}

\fancyfoot{}
\fancyhead{}
\fancyfoot[CE,CO]{\@SetFont\thepage}% force encoding so that passages in some languages won't switch footer font from the main font.
\fancyfoot[RO,RE]{\@SetFont Copyright~\textcopyright~\the\year\ by ASME}
\renewcommand{\headrulewidth}{0pt} 
\renewcommand{\footrulewidth}{0pt}

\ifac@govt
	\newgeometry{left=0.5in, right=0.5in, top=0.5in, bottom = 1.in, footskip = 0.3in, columnsep = 0.38in}
	\fancyfoot[RO,RE]{}
	\fancyfoot[CE,CO]{\@SetFont\thepage\\[1ex]\small This material is declared a work of the U.\ S.~Government and is not subject to copyright protection in the United States.\\Approved for public release; distribution is unlimited.}
\fi

\ifac@contractor
	\newgeometry{left=0.5in, right=0.5in, top=0.5in, bottom = 1.in, footskip = 0.3in, columnsep = 0.38in}
	\fancyfoot[RO,RE]{}
	\fancyfoot[CE,CO]{\@SetFont\thepage\\[1ex]\footnotesize The United States Government retains, and by accepting the article for publication, the publisher acknowledges that the United States Government retains, a non-exclusive, paid-up, irrevocable, worldwide license to publish or reproduce the published form of this work, or allow others to do so, for United States Government purposes.}
\fi

\ifac@nofoot
		\fancyfoot[RO,RE]{}
\fi
%%%%%% footnotes %%%%%%%

\RequirePackage{fnpos}
\makeFNbottom
\makeFNbelow

\setlength{\skip\footins}{\baselineskip}% <=== per ASME, 1 extra line

\renewcommand{\footnoterule}{%
  \kern -3pt
  \hrule width 0.5in height 0.4pt
  \kern 2pt
}

%% reduce indentation of footnotes
\RenewDocumentCommand\@makefntext{m}{%
  \noindent\makebox[2ex][r]{\@makefnmark}#1}% <== To discourage hyphenation, do \hyphenpenalty=300\exhyphenpenalty=300 before #1

  
%%%%%%%%%  Section headings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wish to accommodate hyperref

\RequirePackage[raggedright,indentafter]{titlesec}

%% ASME specifies 10 pt headings
\titleformat{\section}{\mathversion{sansbold}\bfseries\sffamily\raggedright}{\thesection .}{0.5em}{\MakeTextUppercase}

\titleformat{\subsection}{\mathversion{sansbold}\bfseries\sffamily\raggedright}{\thesubsection}{0.5em}{}
\titleformat{\subsubsection}[runin]{\mathversion{sansbold}\bfseries\sffamily}{\thesubsubsection}{0.5em}{}[.\hspace*{0.5em}]

\titlespacing\section{0pt}{12pt plus 4pt minus 2pt}{1pt plus 1pt minus 1pt} % from 2 pt 2 pt 1 pt, 2019/7/7
\titlespacing\subsection{0pt}{12pt plus 4pt minus 2pt}{0pt plus 2pt minus 1pt}
\titlespacing\subsubsection{\parindent}{6pt plus 3pt minus 2pt}{0pt plus 2pt minus 1pt} % from 12 4 3, 2019/7/7

%%  Special handling of the appendices            
%%  Assumes that appendices are the last content in paper 
\RenewDocumentCommand{\appendix}{}{%
    \setcounter{section}{0}
    \pdfbookmark[0]{\appendicesname}{appendices}
    \renewcommand\thesection{\Alph{section}}
    \titleformat{\section}{\mathversion{sansbold}\bfseries\sffamily\raggedright}{\MakeTextUppercase{\appendixname}\ \thesection.}{0.5em}{\MakeTextUppercase}
}

%% This patches titlesec's unprotected re-definition of \footnote.  See discussion here: https://github.com/jbezos/titlesec/issues/48 
%% Without this patch, recent versions of LaTeX will require \protect\footnote in section headings.
\patchcmd{\ttl@select}{\def\footnote}{\protected\def\footnote}{\typeout{Asmeconf.sty patched titlesec to have protected def of footnote}}{}


%%%%%%%%%%  Hyperref, bookmarks, and PDF/A  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\if@asme@pdfmanagement% Thanks to Ulrike Fischer

% New 2021/07/23, don't implement yet
% \IfPDFManagementActiveTF{\@asme@pdfmanagementtrue}{\@asme@pdfmanagementfalse}

\ExplSyntaxOn
    \IfFormatAtLeastTF{2020/02/02}{%
        \bool_if:nTF
          {
            \bool_lazy_and_p:nn
              {\cs_if_exist_p:N \pdfmanagement_if_active_p:}
              { \pdfmanagement_if_active_p: }
          }
          {
            \@asme@pdfmanagementtrue
          }
          {
            \@asme@pdfmanagementfalse
          }
     }{\@asme@pdfmanagementfalse}
\ExplSyntaxOff

\ifpdftex
    %%% to assist with unicode glyph mapping, following M. Sharpe's recommendation in the newtx documentation.
    \IfFormatAtLeastTF{2020/10/01}{\relax}{%
    	\pdfgentounicode=1  							%% enable CMaps; has moved into the latex kernel Oct 2020
    	\input glyphtounicode.tex 						%% lists of mappings; has moved into the latex kernel Oct 2020
    }
    \InputIfFileExists{glyphtounicode-cmr.tex}{}{} 	%% additional mappings
    \InputIfFileExists{glyphtounicode-ntx.tex}{}{} 	%% additional mappings
    
    \ifac@setpdfa
    %%%% the pdfmanagement options are experimental, from Ulrike Fischer 2021/06/12
        \if@asme@pdfmanagement
        	\ClassInfo{asmeconf}{pdfmanagement is defined. Class file will not load a color profile}
        \else
        	\ClassInfo{asmeconf}{NOTE: pdfmanagement not defined. Class file will load a color profile}%
            %%% a fairly generic RGB color profile, aimed at on-screen rendering (not print production)
            	\immediate\pdfobj stream attr{/N 3} file{sRGB.icc}
            	\pdfcatalog{%
            	   /OutputIntents [
            	    <<
            	      /Type /OutputIntent
            	      /S /GTS_PDFA1
            	      /DestOutputProfile \the\pdflastobj\space 0 R
            	      /OutputConditionIdentifier (sRGB)
            	      /Info (sRGB)
            	    >>
            	   ]
            	 }%
        \fi
    \fi
\fi

\RequirePackage{hyperxmp}% improve transfer of metadata to pdf 

% Patch bug in hyperxmp, unless a more recent version is used.
\ifdefined\hyxmp@no@bad@parts% \hyxmp@no@bad@parts is not def'd in TeX Live 2019 or older
    \@ifpackagelater{hyperxmp}{2022/09/14}{% no new version at present, still 2020/11/22 
        \relax
    	}{%
        \newcount\hypxmp@tempcnt
        \define@key{Hyp}{pdfapart}{%
          \afterassignment\hyxmp@no@bad@parts\hypxmp@tempcnt=0#1\relax
          \hyxmp@pdfstringdef\@pdfapart{\the\hypxmp@tempcnt}%
        }
    }
\else
	\relax
\fi

\RequirePackage[psdextra]{hyperref} % recent kernel transition suggests providing most hyperref options via \hypersetup, 
									% but setting psdextra here (for additional math support in bookmarks) 2021/12/01
\hypersetup{%
    unicode,        % Unicode encoded PDF strings
	pdfborder={0 0 0},% 
	bookmarksnumbered=true,%
	bookmarksopen=true,
	bookmarksopenlevel=1,%
	linkcolor=blue, %
	citecolor=blue, % 
	urlcolor=blue,  %
	filecolor=red,  % added 2021/12/02, to make certain broken links more apparent
	pdfnewwindow=true,%
	pdfpagelayout=SinglePage, %TwoPageRight,% changed this 2020/12/08
	pdfdisplaydoctitle=true%
%	colorlinks=true,% <=== set true to get colored type, but do so via package options in .tex file
}
	
\urlstyle{same}     		  % don't switch to typewriter font for urls
\RequirePackage{doi}          % supports the nasty characters in some doi's
\renewcommand{\doitext}{DOI } % change to this from default value, {doi:}, per ASME specification
\RequirePackage{bookmark}     % improves handling of pdf bookmarks

\providecommand*{\toclevel@subfigure}{1}% <== to address unknown bookmark level of subfigure. 2021/12/24

\providecommand\hrefurl[2]{\href{#1}{#2}}% to address certain issues around URL recognition with new pdf management code, 2021/12/02

%%% ==> recent and evolving development of \pdfstring removes all robust commands from bookmarks, so
%%%		the following interventions may become unnecessary over time (2021/12/01).

%% Since \bm may be useful in headings, this fix will reduce frequency with which
%%    alternate pdfstrings must be given in revised section command as \section[pdfstring]{texstring}
\pdfstringdefDisableCommands{%
    \def\bm#1#{\relax}%
}

%% Let's disable \( and \) in pdf bookmarks, 2020/02/28
\pdfstringdefDisableCommands{%
    \def\({\relax}%
    \def\){\relax}%
}

%% Let's also make sure \NoCaseChange in section headings won't break pdf bookmarks
\pdfstringdefDisableCommands{%
      \let\NoCaseChange\relax%
}

%% Let's just remove citations from pdf bookmarks
\pdfstringdefDisableCommands{%
    \def\cite{\@gobble}%
}

%% Let's make sure footnotes in section headings don't break pdf bookmarks.
\robustify{\footnote}
% \patchcmd{\section}{\sectionmark}{\let\footnote\@gobble\sectionmark}{}{}% <== not really needed in this context, 2020/02/28
\pdfstringdefDisableCommands{%
  \def\footnote#1{}%
}


%% Let's also add \footnote to the \TextUppercase exception list, so that footnote text won't be capitalized
%% if given in section headings. Ditto for \eqref
%
\ifx\AddToNoCaseChangeList\@undefined % updated July 3, see https://github.com/John02139/asmeconf/issues/5 
	\patchcmd{\@uclcnotmath}{\@nonchangecase\ref}{\@nonchangecase\ref\@nonchangecase\footnote}{\typeout{Asmeconf patched textcase nonchangecase to include footnote.}}{}
	\patchcmd{\@uclcnotmath}{\@nonchangecase\ref}{\@nonchangecase\ref\@nonchangecase\eqref}{\typeout{Asmeconf patched textcase nonchangecase to include eqref.}}{} %% corrected 2020/01/24
\else
    \AddToNoCaseChangeList{\eqref \footnote}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Create an optional argument for unnumbered sections and set pdf bookmark (thru \addcontentsline).
%%% The optional argument will manually set the pdf bookmark for that section; can be used to avoid hyperref 
%%%     errors when macros are in section titles.
%%% There should not be errors for $, \cite, \ref, \eqref, \label, \footnote, \NoCaseChange, or \bm with current constructions.
\let\svsection\section
\RenewDocumentCommand{\section}{s o m}{%
	    \IfBooleanTF {#1}
		{\svsection*{#3}\phantomsection%
					{\IfNoValueTF {#2}
					{\addcontentsline{toc}{section}{#3}}
					{\addcontentsline{toc}{section}{#2}}% removed trailing space 2020/02/28
					}%
		}%
		{\IfNoValueTF {#2}
			{\svsection{#3}}
			{\svsection[#2]{#3}}%
		}%
}

%%%%%%%%%%%%%  Line numbering and balancing columns on last page  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Allow line numbering in AMS math environments.
%%% postdisplaypenalty adjusted to avoid extra line number at end, see discussion here: https://tex.stackexchange.com/a/461192/ 
%%% multline has some additional problem that puts an extra line number above it.

\NewDocumentCommand{\@losepostpenalty}{}{\patchcmd{\linenomathWithnumbers}{\advance\postdisplaypenalty\linenopenalty}{}{}{}}

\NewDocumentCommand{\@FixAMSMath}{m}{%
	\AtBeginEnvironment{#1}{\@losepostpenalty\linenomath}%
	\AtEndEnvironment{#1}{\endlinenomath}%
	\AtBeginEnvironment{#1*}{\@losepostpenalty\linenomath}%
	\AtEndEnvironment{#1*}{\endlinenomath}%
}

\NewDocumentCommand{\@FixAll}{>{\SplitList{;}}m}{\ProcessList{#1}{\@FixAMSMath}}

%%% Adjustments when lineno option is used
\ifac@lineno%
    \RequirePackage[switch,mathlines]{lineno}    
    \renewcommand{\linenumberfont}{\normalfont\footnotesize\color{red}} 
    \AtBeginDocument{\linenumbers}
    \ClassWarningNoLine{asmeconf}{Package lineno loaded, so final column balancing is disabled}
	\@FixAll{align;alignat;gather;flalign;multline}
    \else
    \ifac@balance\RequirePackage{flushend}\fi % flushend is NOT compatible with lineno
\fi
%%% Enable dropping lineno option without trashing .aux file
\providecommand{\@LN@col}[1]{\relax}
\providecommand{\@LN}[2]{\relax}


%%%%%%%%%%%%%  Define special environments  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Introduce some special section and other names %%%%%%%%%%%

\providecommand{\nomname}{Nomenclature}  
\providecommand{\keywordname}{Keywords}
\providecommand{\appendicesname}{APPENDICES}
\providecommand{\JAwords}{Joint first authors}
\providecommand{\CAwords}{Corresponding author}

%%   Abstract environment  %%%%%%%%%%%%%%%%%%
%%   \keywords command should be given someplace before the \end{abstract} command.

\providecommand{\@keywords}{\relax}

% \ifblank is from etoolbox
\NewDocumentCommand{\keywords}{m}{%
	\ifblank{#1}{\def\@keywords{\relax}}{
	    \long\def\@keywords{\par\smallskip\noindent{\bfseries\sffamily \keywordname: #1}}%
	}
}

\DeclareDocumentEnvironment{abstract}{}{% Overwrites existing abstract environment
	\section*{\abstractname}\itshape
	}
	{\upshape\@keywords
}
\NewDocumentEnvironment{abstract*}{}{% Abstract with no keywords (same as using empty \keywords{} with first abstract)
	\section*{\abstractname}\itshape
	}
	{\ignorespacesafterend
}

%%   Nomenclature environment  %%%%%%%%%%%%%%%%%%
%%

\newlength\nomenwidth
\newlength\savitemsep

%% ==> xparse "g" argument used in this version of \entry is deprecated; so have phased out this version, 2021/12/01
%% If second argument of \entry is omitted, will produce an italicized heading (e.g. "Greek letters")
%\NewDocumentCommand\entry{m g}{%
% \IfNoValueTF{#2}{%
% 			 \itemsep3\p@ plus 1\p@ minus 1\p@%
%             \goodbreak\item[\itshape#1\hfill]\setlength\itemsep\savitemsep\@itempenalty=1000%
%             }{%
%             \item[#1\hfill]#2%
%             \@itempenalty=-\@lowpenalty%
%             }%
%}

\NewDocumentCommand\entry{m m}{%
 \ifblank{#2}{%
			 \ClassWarningNoLine{asmeconf}{The command \protect\entry requires two arguments. To obtain a subheading, use \protect\EntryHeading}
 			 \itemsep3\p@ plus 1\p@ minus 1\p@%
             \goodbreak\item[\itshape#1\hfill]\setlength\itemsep\savitemsep\@itempenalty=1000%
             }{%
             \item[#1\hfill]#2%
             \@itempenalty=-\@lowpenalty%
             }%
}

%% A separate command command for nomenclature subheadings 
\NewDocumentCommand\EntryHeading{m}{%
	\itemsep3\p@ plus 1\p@ minus 1\p@%
    \goodbreak\item[\itshape#1\hfill]\setlength\itemsep\savitemsep\@itempenalty=1000%
}

%%   Increase first optional argument to a dimension > 2em if wide entries cause undesired misalignment of columns. 
%%   Second optional argument can be used to rename the environment, e.g., to List of Symbols.
\NewDocumentEnvironment{nomenclature}{O{2em} O{\nomname}}{%
        \setlength\columnsep{2em} 
        \setlength{\nomenwidth}{#1}
        \section*{#2}
        \raggedright
        \begin{list}{}{%
             \setlength{\itemsep}{0pt}%
             \setlength{\parsep}{\itemsep}%
             \setlength{\labelsep}{1em}%
             \setlength{\labelwidth}{\nomenwidth}%
             \setlength{\leftmargin}{\labelwidth}%
             \addtolength{\leftmargin}{\labelsep}%
			 \setlength\savitemsep\itemsep%
        }%
}{\end{list}\ignorespacesafterend} 
       

%%%%%%%%%%%%%%%%%  Headers and Title  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewDocumentCommand\ConfName{m}{\long\gdef\@ConfName{#1}}
\providecommand\@ConfName{\hbox{ }}

\NewDocumentCommand\ConfAcronym{m}{\gdef\@ConfAcronym{#1}}
\providecommand\@ConfAcronym{\hbox{ }}

\NewDocumentCommand\ConfDate{m}{\gdef\@ConfDate{#1,\space}}
\providecommand\@ConfDate{\space}

\NewDocumentCommand\ConfCity{m}{\gdef\@ConfCity{#1}}
\providecommand\@ConfCity{\hbox{ }}

\NewDocumentCommand\HeaderConfName{}{%
	\parbox{\linewidth}{%
		\raggedleft\bfseries\sffamily%
		\@ConfName\par%
		\MakeTextUppercase{\@ConfAcronym}\par
		\@ConfDate\@ConfCity%
    }%
}

\NewDocumentCommand\PaperNo{m}{\gdef\@PaperNo{#1}}
\providecommand\@PaperNo{\protect\phantom{NO.}}

\NewDocumentCommand\paperno{}{%
	\vspace*{2\baselineskip}
	\parbox{\linewidth}{\raggedleft\bfseries\sffamily\LARGE%
		\MakeTextUppercase{\@PaperNo}%
    }%
}

\NewDocumentCommand\PaperTitle{m}{\gdef\@PaperTitle{#1}}
\providecommand\@PaperTitle{\hbox{ }}

\NewDocumentCommand\papertitle{}{%
\vspace*{3\baselineskip}
\parbox{\linewidth}{\mathversion{sansbold}\centering{\bfseries\sffamily\large%
\MakeTextUppercase{\@PaperTitle}\par}%%% <=== extra \par to make font leading stick. See adjustment in \MakeTitle
     }%
}

%%%%%%%%%%%   Author and affiliation block  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{xcoffins}

%% To maintain compatibility with newtxtext superiors option, if used, save the definition (inline author style resets it)
\let\savethefootnote\thefootnote
\let\savemakefnmark\@makefnmark

%% Flag for joint first authors (two or more)
\newif\ifac@JA\ac@JAfalse

\NewDocumentCommand{\JointFirstAuthor}{}{%
	\global\ac@JAtrue%
  	$\bm{^\dagger}$%
}
%% Flag for corresponding author (expecting just one, but if two enter both email addresses and flag both authors)
\newif\ifac@CA\ac@CAfalse

\NewDocumentCommand\CorrespondingAuthor{m}{% Revised this command 2020/12/29, to make the CA email mandatory but possibly empty
   \ignorespaces$\bm{^\ast}$%
   \global\ac@CAtrue%
   \ifblank{#1}{%
         \gdef\@CAsep{\relax}%
         \gdef\@CAemail{\relax}%
         }{%
         \gdef\@CAsep{:\space}%
         \gdef\@CAemail{#1}%
   }%
}

%%%% option to use the traditional grid layout of authors or the inline style

\ifthenelse{\boolean{grid}\or\boolean{Oldauthors}}{% This command works better than \if... in this context.

	%%%%%%%%%%%%%%%%%%%%  Gridded author layout  %%%%%%%%%%%%%%%%%%%%%%%%%

    \NewCoffin{\authorblock}
    
    %% Allows for up to fifteen author groups... if you need more authors, the edits should be obvious
    %% You can put multiple authors above a single affiliation to reduce number of author blocks needed.
    \NewCoffin{\firstrowauthorblock}
    \NewCoffin{\secondrowauthorblock}
    \NewCoffin{\thirdrowauthorblock}
    \NewCoffin{\fourthrowauthorblock}
    \NewCoffin{\fifthrowauthorblock}
    \AtBeginDocument{% corrected 2021/12/01
        \SetHorizontalCoffin\firstrowauthorblock{}
        \SetHorizontalCoffin\secondrowauthorblock{}
        \SetHorizontalCoffin\thirdrowauthorblock{}
        \SetHorizontalCoffin\fourthrowauthorblock{}
        \SetHorizontalCoffin\fifthrowauthorblock{}
    }
    
    \newcounter{authorno}
    \setcounter{authorno}{0}
    
    \newlength{\coffinsep}% horizontal space between coffins
    \setlength{\coffinsep}{0.03\textwidth}

	\ifthenelse{\boolean{grid}}{%
        \newcounter{authorcnt}
        \setcounter{authorcnt}{0}
         
        \NewDocumentCommand\SetAffiliation{mm}{\expandafter\xdef\csname af@#1\endcsname{#2}}% defines \af@#1 as Affiliation #2
        
        \AtBeginDocument{% error control, when no author or empty \affil is given
        	\SetAffiliation{-1}{Missing author name!\\Or extra comma!}
        	\SetAffiliation{99}{Missing affiliation tag!!}
        	\SetAffiliation{100}{Missing number in affiliation!!}
        }
               
        \NewDocumentCommand\SetAuthors{>{\SplitList{,}}m}{\ProcessList{#1}{\@TagAutAff}}
             
        \NewDocumentCommand\@AuthNo{m}{%
        		\ifblank{#1}{%
        			\expandafter\xdef\csname aut@\theauthorcnt\endcsname{}%
        			\expandafter\xdef\csname autaffil@\theauthorcnt\endcsname{-1}
        			\ClassWarning{asmeconf}{Missing author name, check for extra comma}%
        			}{\expandafter\xdef\csname aut@\theauthorcnt\endcsname{#1}%
        		}%
        }% defines \aut@authorcnt as Name #1
        
        \NewExpandableDocumentCommand\affil{m}{%
        	\ifblank{#1}{%
        		  \expandafter\xdef\csname autaffil@\theauthorcnt\endcsname{100}%
        		}{\expandafter\xdef\csname autaffil@\theauthorcnt\endcsname{#1}%
        	}%
        }% defines \autaffil@authorcnt as #1 (unique association)
        
        \NewDocumentCommand\@TagAutAff{m}{%
            \addtocounter{authorcnt}{1}%
        	\@AuthNo{#1}%
        }
        \NewDocumentCommand\@SetAuthorBlock{}{%
            \whiledo{\value{authorno}<\value{authorcnt}}{% starting with authorno = 0 ensures we reach authorcnt with +1
                \addtocounter{authorno}{1}%
            	\SetVerticalCoffin{\authorblock}{0.3\textwidth}{%
            	\centering\sffamily%
            	\textbf{\ignorespaces\csname aut@\theauthorno\endcsname\ignorespaces}\\
				\ifcsname autaffil@\theauthorno\endcsname% in case the \affil command has been omitted
            		\csname af@\csname autaffil@\theauthorno\endcsname\endcsname
				\else
					\csname af@99\endcsname
				\fi
            	\par}
                \ifnum\value{authorno}=1
                     \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t]
                 \else
                    \ifnum\value{authorno}=2
                       \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                    \else
                      \ifnum\value{authorno}=3
                         \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                      \fi
                    \fi 
                \fi
                \ifnum\value{authorno}=4
                   \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t]
                \else
                   \ifnum\value{authorno}=5
                        \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                   \else
                        \ifnum\value{authorno}=6
                           \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                        \fi
                   \fi 
                \fi
                \ifnum\value{authorno}=7
                   \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t]	
                \else
                   \ifnum\value{authorno}=8
                        \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                   \else
                        \ifnum\value{authorno}=9
                           \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                        \fi
                   \fi 
                \fi
                \ifnum\value{authorno}=10
                   \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t]	
                \else
                   \ifnum\value{authorno}=11
                        \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                   \else
                        \ifnum\value{authorno}=12
                           \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                        \fi
                   \fi 
                \fi
                \ifnum\value{authorno}=13
                   \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t]	
                \else
                   \ifnum\value{authorno}=14
                        \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                   \else
                        \ifnum\value{authorno}=15
                           \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                        \fi
                   \fi 
                \fi
                \ifnum\value{authorno}>15
                	\ClassWarningNoLine{asmeconf}{The class is programmed for up to 15 author blocks. If some of your authors are at the same institution, %
        			you may put more than one name above a single address.  If you need more than 15 author blocks, try using the in-line author style %
        			instead of the [grid] option}
        		\fi
        	}% end whiledo
		}
	}{% end ifthen for grid, now do else for Oldauthors
        \NewDocumentCommand\SetAuthorBlock{mm}{%
           \addtocounter{authorno}{1}%
           \SetVerticalCoffin{\authorblock}{0.3\textwidth}{%
           \centering\sffamily%
           \textbf{\ignorespaces#1\ignorespaces}\\
           #2%
        	}
            \ifnum\value{authorno}=1
                 \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t]
             \else
                \ifnum\value{authorno}=2
                   \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                \else
                  \ifnum\value{authorno}=3
                     \JoinCoffins\firstrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                  \fi
                \fi 
            \fi
            \ifnum\value{authorno}=4
               \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t]
            \else
               \ifnum\value{authorno}=5
                    \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
               \else
                    \ifnum\value{authorno}=6
                       \JoinCoffins\secondrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                    \fi
               \fi 
            \fi
            \ifnum\value{authorno}=7
               \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t]	
            \else
               \ifnum\value{authorno}=8
                    \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
               \else
                    \ifnum\value{authorno}=9
                       \JoinCoffins\thirdrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                    \fi
               \fi 
            \fi
            \ifnum\value{authorno}=10
               \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t]	
            \else
               \ifnum\value{authorno}=11
                    \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
               \else
                    \ifnum\value{authorno}=12
                       \JoinCoffins\fourthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                    \fi
               \fi 
            \fi
            \ifnum\value{authorno}=13
               \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t]	
            \else
               \ifnum\value{authorno}=14
                    \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
               \else
                    \ifnum\value{authorno}=15
                       \JoinCoffins\fifthrowauthorblock[r,t]\authorblock[l,t](\coffinsep,0pt)
                    \fi
               \fi 
            \fi
            \ifnum\value{authorno}>15
            	\ClassWarningNoLine{asmeconf}{The class is programmed for up to 15 author blocks. If some of your authors are at the same institution, %
    			you may put more than one name above a single address.  If you need more than 15 author blocks, try using the in-line author style %
    			instead of the [authorgrid] option}
    		\fi
        }
     
        % Changed to follow syntax of the inline style, which is much easier to use! 2020/12/29  
        %    % allow for NO email address to be given by omitting second argument
        %    \NewDocumentCommand{\CorrespondingAuthor}{m g}{%
        %       \global\ac@CAtrue%
        %       \IfNoValueTF{#2}{%
        %             \gdef\@CAsep{\relax}%
        %             \gdef\@CAemail{\relax}%
        %             }{%
        %             \gdef\@CAsep{:\space}%
        %             \gdef\@CAemail{#2}%
        %             }%
        %       \ignorespaces#1\ignorespaces$\bm{^\ast}$%\footnotemark[1]%
        %   }
    
    	%%% to deal with sequential notes as, e.g., "1,*", or "1,2,*" %%%%%%%%%%
    	% 	bug fixed 2020/12/29
        \newcommand\nextToken\relax
        
        \newcommand\isOthernote{%
            \ifx\CorrespondingAuthor\nextToken\textsuperscript{\sffamily\bfseries,}%
            \else%
                \ifx\JointFirstAuthor\nextToken\textsuperscript{\sffamily\bfseries,}%
                \fi%
            \fi%
            \ignorespaces% 
        }
        
        \let\oldCorrespondingAuthor\CorrespondingAuthor
        \renewcommand\CorrespondingAuthor[1]{%
            \oldCorrespondingAuthor{#1}\futurelet\nextToken\isOthernote}
            
        \let\oldJointFirstAuthor\JointFirstAuthor
        \renewcommand\JointFirstAuthor{%
            \oldJointFirstAuthor\futurelet\nextToken\isOthernote}
        
        \let\oldfootnote\footnote
        \renewcommand\footnote[1]{%
            \oldfootnote{#1}\futurelet\nextToken\isOtherfnote}
            
        \newcommand\isOtherfnote{%
            \ifx\footnote\nextToken\textsu{\mdseries,}%
            \fi%
        }
    }%end ifthenelse
           
    \NewDocumentCommand\ConstructAuthorBlock{}{%
        \ifnum\value{authorno}>3
           \JoinCoffins\firstrowauthorblock[hc,b]\secondrowauthorblock[hc,t](0pt, -1.5\baselineskip)     
        \fi
        \ifnum\value{authorno}>6
           \JoinCoffins\firstrowauthorblock[hc,b]\thirdrowauthorblock[hc,t](0pt, -1.5\baselineskip)  
        \fi
        \ifnum\value{authorno}>9
           \JoinCoffins\firstrowauthorblock[hc,b]\fourthrowauthorblock[hc,t](0pt, -1.5\baselineskip)  
        \fi
        \ifnum\value{authorno}>12
           \JoinCoffins\firstrowauthorblock[hc,b]\fifthrowauthorblock[hc,t](0pt, -1.5\baselineskip)  
        \fi
        \centerline{\TypesetCoffin\firstrowauthorblock}%% in this instance, \centerline is better than \centering
    }
%%% otherwise use the new compact layout of authors
}{%  i.e., this begins "else"

	%%%%%%%%%%%%%%%%%%%%%%   New author layout (inline)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \NewCoffin{\AuthorBlock}
    \NewCoffin{\AffiliationBlock}
    \NewCoffin{\AffiliationsBlock}
    \AtBeginDocument{\SetHorizontalCoffin\AffiliationsBlock{}}% corrected 2021/12/01
        
	%% NB: \parbox width to \textwidth (full page) not \linewidth (single column)
    \NewDocumentCommand\SetAuthors{m}{%
         \SetHorizontalCoffin\AuthorBlock{%
         \parbox{\textwidth}{\centering\sffamily\bfseries\ignorespaces#1\ignorespaces}%
         }
    }
    
    \def\@makefnmark{\hbox{\@textsuperscript{\sffamily\@thefnmark}}}%
    
    \NewDocumentCommand\SetAffiliation{mm}{%
       \SetVerticalCoffin\AffiliationBlock{\textwidth}{%
       \ifblank{#1}{%
       		\centering\sffamily#2\ignorespaces}{% empty argument for one author or one affiliation, where affiliation need not be tagged
          	\centering\sffamily\footnotemark[#1]#2\ignorespaces}%
       }
       \JoinCoffins\AffiliationsBlock[hc,b]\AffiliationBlock[hc,t](0pt,-1pt) 
    }
            
	%%% Affiliation mark
    \NewDocumentCommand{\affil}{m}{%
    	\ifblank{#1}{%
			\ClassWarning{asmeconf}{Empty affiliation tag}%
			\@gobble% 9 Dec 2021, addresses modification for commas
        }{\bfseries\footnotemark[#1]}%
    }
          
	%%% to deal with sequential notes as, e.g., "1,*", or "1,2,*" %%%%%%%%%%
    \let\oldaffil\affil
    \newcommand\nextToken\relax
    
    \renewcommand\affil[1]{%
        \oldaffil{#1}\futurelet\nextToken\isOthernote}
    
    \newcommand\isOthernote{%
        \ifx\CorrespondingAuthor\nextToken\textsuperscript{\sffamily\bfseries,}%
        \else%
            \ifx\JointFirstAuthor\nextToken\textsuperscript{\sffamily\bfseries,}%
            \else
                \ifx\affil\nextToken\textsuperscript{\sffamily\bfseries,}%
                \fi%
            \fi%
        \fi%
        \ignorespaces% 
    }
    
    \let\oldCorrespondingAuthor\CorrespondingAuthor
    \renewcommand\CorrespondingAuthor[1]{%
        \oldCorrespondingAuthor{#1}\futurelet\nextToken\isOthernote}
        
    \let\oldJointFirstAuthor\JointFirstAuthor
    \renewcommand\JointFirstAuthor{%
        \oldJointFirstAuthor\futurelet\nextToken\isOthernote}
    
    \let\oldfootnote\footnote
    \renewcommand\footnote[1]{%
        \oldfootnote{#1}\futurelet\nextToken\isOtherfnote}
        
    \newcommand\isOtherfnote{%
        \ifx\footnote\nextToken\textsu{\mdseries,}%
        \fi%
    }    
%%%    
    \NewDocumentCommand\SetAuthorBlock{}{%
       \let\savethefootnote\thefootnote
       \JoinCoffins\AuthorBlock[hc,b]\AffiliationsBlock[hc,t](0pt,-\baselineskip)
       \centerline{\TypesetCoffin\AuthorBlock}
    }
} %% end ifthenelse for Oldauthors

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Make the title and author section
\NewDocumentCommand\MakeTitlePage{}{%
    \twocolumn[
       \begin{@twocolumnfalse}
          \HeaderConfName  
          \paperno 
          \papertitle
          \vspace*{2\baselineskip}
          \ifthenelse{\boolean{Oldauthors}}{%
             \ConstructAuthorBlock}{%
             \ifthenelse{\boolean{grid}}{%
             \@SetAuthorBlock\ConstructAuthorBlock}{%
             \SetAuthorBlock}}
          \vspace*{3\baselineskip} 
       \end{@twocolumnfalse} 
    ]
    \let\@makefnmark\savemakefnmark
    \renewcommand*{\thefootnote}{\fnsymbol{footnote}}
    \ifac@JA
        \ifDefaultSups\relax\else\ifac@fontspec\def\f@@tn@te{blub}\fi\fi% https://tex.stackexchange.com/a/565263/46356
        \footnotetext[2]{\JAwords}
    \fi
    \ifac@CA
        \footnotetext[1]{\CAwords\@CAsep\@CAemail}
    \fi
    \ifDefaultSups\relax\else
    	\ifac@fontspec\def\f@@tn@te{footnote}\fi
    \fi
    \let\thefootnote\savethefootnote
}

%%%%%%%%%%

%% Provide compatibility with titling commands from standard LaTeX article class
\RenewDocumentCommand{\maketitle}{}{\MakeTitlePage}
\RenewDocumentCommand{\title}{}{\PaperTitle}

\RenewDocumentCommand{\thanks}{m}{\relax}% disabling this standard command (inconsistent with this format)

%% Produces an unmarked footnote about the version date, to replace "date"
%% This tool is for editing and should not be used in the final draft

%% This version provides working hyperlink, but throws warning; also, \gdef -->\def. 2021/12/09
%\NewDocumentCommand\versionfootnote{m}{\def\@thefnmark{}\@footnotetext{#1}}

%% A hyperlink in this footnote will not function, since NoHyper is used to suppress 'missing anchor' warning
\NewDocumentCommand\versionfootnote{m}{\def\@thefnmark{}\begin{NoHyper}\@footnotetext{#1}\end{NoHyper}}

\RenewDocumentCommand{\date}{m}{\versionfootnote{#1}}% if one wants to use \date this same way; fixed bug 2021/01/14


%%%%%%%%%%%%%%  Sans serif upright greek and sans mathversion  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Provide sans-serif *upright* Greek letters, following a suggestion by Michael Sharpe (March 2019).
%% Following Sharpe's newtxsf implementation of the STIX fonts, under the LaTeX Project Public License.
%% (Note that \mathversion{sansbold} provides sans-serif *italic* Greek letters.) Various edits 2021/01/25

\DeclareSymbolFont{lettersAB}{U}{ntxsfmia}{m}{it}
\SetSymbolFont{lettersAB}{normal}{U}{ntxsfmia}{m}{it}
\SetSymbolFont{lettersAB}{bold}{U}{ntxsfmia}{b}{it}
\SetSymbolFont{lettersAB}{sansbold}{U}{ntxsfmia}{b}{it}% added 2021/01/25, to get this bold in captions, etc.
\DeclareFontSubstitution{U}{ntxsfmia}{m}{it}

\DeclareMathSymbol{\sfGamma}{\mathalpha}{lettersAB}{0}% adjust to avoid overwriting newtxmath commands, 2021/01/25
\DeclareMathSymbol{\sfDelta}{\mathalpha}{lettersAB}{1}
\DeclareMathSymbol{\sfTheta}{\mathalpha}{lettersAB}{2}
\DeclareMathSymbol{\sfLambda}{\mathalpha}{lettersAB}{3}
\DeclareMathSymbol{\sfXi}{\mathalpha}{lettersAB}{4}
\DeclareMathSymbol{\sfPi}{\mathalpha}{lettersAB}{5}

\DeclareMathSymbol{\sfSigma}{\mathalpha}{lettersAB}{6}
\DeclareMathSymbol{\sfUpsilon}{\mathalpha}{lettersAB}{7}
\DeclareMathSymbol{\sfPhi}{\mathalpha}{lettersAB}{8}
\DeclareMathSymbol{\sfPsi}{\mathalpha}{lettersAB}{9}
\DeclareMathSymbol{\sfOmega}{\mathalpha}{lettersAB}{10}

\DeclareMathSymbol{\sfalpha}{\mathalpha}{lettersAB}{11}
\DeclareMathSymbol{\sfbeta}{\mathalpha}{lettersAB}{12}
\DeclareMathSymbol{\sfgamma}{\mathalpha}{lettersAB}{13}
\DeclareMathSymbol{\sfdelta}{\mathalpha}{lettersAB}{14}
\DeclareMathSymbol{\sfepsilon}{\mathalpha}{lettersAB}{15}

\DeclareMathSymbol{\sfzeta}{\mathalpha}{lettersAB}{16}
\DeclareMathSymbol{\sfeta}{\mathalpha}{lettersAB}{17}
\DeclareMathSymbol{\sftheta}{\mathalpha}{lettersAB}{18}
\DeclareMathSymbol{\sfiota}{\mathalpha}{lettersAB}{19}
\DeclareMathSymbol{\sfkappa}{\mathalpha}{lettersAB}{20}

\DeclareMathSymbol{\sflambda}{\mathalpha}{lettersAB}{21}
\DeclareMathSymbol{\sfmu}{\mathalpha}{lettersAB}{22}
\DeclareMathSymbol{\sfnu}{\mathalpha}{lettersAB}{23}
\DeclareMathSymbol{\sfxi}{\mathalpha}{lettersAB}{24}
\DeclareMathSymbol{\sfpi}{\mathalpha}{lettersAB}{25}

\DeclareMathSymbol{\sfrho}{\mathalpha}{lettersAB}{26}
\DeclareMathSymbol{\sfsigma}{\mathalpha}{lettersAB}{27}
\DeclareMathSymbol{\sftau}{\mathalpha}{lettersAB}{28}
\DeclareMathSymbol{\sfupsilon}{\mathalpha}{lettersAB}{29}
\DeclareMathSymbol{\sfphi}{\mathalpha}{lettersAB}{30}

\DeclareMathSymbol{\sfchi}{\mathalpha}{lettersAB}{31}
\DeclareMathSymbol{\sfpsi}{\mathalpha}{lettersAB}{32}
\DeclareMathSymbol{\sfomega}{\mathalpha}{lettersAB}{33}
\DeclareMathSymbol{\sfvarepsilon}{\mathalpha}{lettersAB}{34}
\DeclareMathSymbol{\sfvartheta}{\mathalpha}{lettersAB}{35}

\DeclareMathSymbol{\sfvarpi}{\mathord}{lettersAB}{36}% added these 2021/01/25
\DeclareMathSymbol{\sfvarrho}{\mathord}{lettersAB}{37}
\DeclareMathSymbol{\sfvarsigma}{\mathord}{lettersAB}{38}
\DeclareMathSymbol{\sfvarphi}{\mathord}{lettersAB}{39}
\DeclareMathSymbol{\sfitvarkappa}{\mathalpha}{lettersAB}{40}
\DeclareMathSymbol{\sfvarkappa}{\mathalpha}{lettersAB}{40}
\DeclareMathSymbol{\sfitnabla}{\mathalpha}{lettersAB}{42}
\DeclareMathSymbol{\sfnabla}{\mathalpha}{lettersAB}{43}
\DeclareMathSymbol{\sfhslash}{\mathalpha}{lettersAB}{52}% this is not upright
\DeclareMathSymbol{\sfhbar}{\mathalpha}{lettersAB}{53}%   this is not upright

\DeclareMathAccent{\grave}{\mathord}{lettersAB}{254}% added these after bug report 2021/01/24
\DeclareMathAccent{\acute}{\mathord}{lettersAB}{255}
\DeclareMathAccent{\check}{\mathord}{lettersAB}{186}
\DeclareMathAccent{\breve}{\mathord}{lettersAB}{187}
\DeclareMathAccent{\bar}{\mathord}{lettersAB}{221}
\DeclareMathAccent{\mathring}{\mathord}{lettersAB}{222}
\DeclareMathAccent{\hat}{\mathord}{lettersAB}{223}
\DeclareMathAccent{\dot}{\mathord}{lettersAB}{224}
\DeclareMathAccent{\tilde}{\mathord}{lettersAB}{219}

%%% sans math version, potential value with PGFPlots, e.g., not for use in main text. 2021/01/25 %%%
\DeclareMathVersion{sans}
\SetSymbolFont{letters}{sans}{OML}{ntxsfmi}{m}{it}
\SetSymbolFont{lettersA}{sans}{U}{ntxsfmia}{m}{it}
\SetSymbolFont{lettersAB}{sans}{U}{ntxsfmia}{m}{it}
\IfFormatAtLeastTF{2016/01/05}{%
	\SetSymbolFont{symbols}{sans}{LMS}{ntxsy}{m}{n}
	}{\relax}
\SetSymbolFont{largesymbols}{sans}{LMX}{ntxexx}{m}{n}
\SetSymbolFont{largesymbolsTXA}{sans}{U}{ntxexa}{m}{n}
\SetSymbolFont{operators}{sans}{\encodingdefault}{\sfdefault}{m}{n}
\SetMathAlphabet{\mathsf}{sans}{\encodingdefault}{\sfdefault}{m}{n}% make upright 2021/01/31.

%%%%%%%%%%%%%%%%%%  Times-like fonts for specific languages  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifpdftex % Under lualatex, babel has problems with the following approach. Use [fontspec] option instead.
	% Several modifications made in response to newtx v1.71, 2022/03/14
	\ifac@vietnamese
%
	\IfFormatAtLeastTF{2020/02/02}{\relax}{%
	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions 2020 are necessary to use the fonts of the [vietnamese] option with pdflatex}{Please UPDATE your LaTeX distribution: TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  Alternatively, delete the class option [vietnamese].}%
	}
%
		\AtBeginDocument{%
			\let\babel@aux\@gobbletwo % eliminate warnings about missing .fd. Brute force approach, revisit later. 2022/03/14
			\DeclareFontFamilySubstitution{T5}{\rmdefault}{qtm}  % new in 02/20/2020 format of LaTeX!  Need to test.
			\DeclareFontFamilySubstitution{T5}{\ttdefault}{qcr}
		}
		% 2021/12/24 removed substitute font package
		% Vietnamese is in T5 encoding, can use Tex Gyre Termes font (qtm); 
    	% qhv = Heros (helvetica). We get the right font w/o loading this.        	
    	% qcr = Cursor (monospaced) is poor match to inconsolata; qhv (the sf font) matches better, but isn't monospaced.
%
    	% From TeX Gyre Termes and Cursor .fd files by B. Jackowski and J. M. Nowacki, released under the GUST license
        \begingroup
        \nfss@catcodes
%        
        \def\qtm@scale{s*[0.97]}
        \DeclareFontFamily{T5}{qtm}{}% not adjusting wordspacing
        \DeclareFontShape{T5}{qtm}{b}{sc}{<-> \qtm@scale t5-qtmb-sc}{}
        \DeclareFontShape{T5}{qtm}{b}{n}{<-> \qtm@scale t5-qtmb}{}
        \DeclareFontShape{T5}{qtm}{b}{scit}{<-> \qtm@scale t5-qtmbi-sc}{}
        \DeclareFontShape{T5}{qtm}{b}{it}{<-> \qtm@scale t5-qtmbi}{}
        \DeclareFontShape{T5}{qtm}{m}{sc}{<-> \qtm@scale t5-qtmr-sc}{}
        \DeclareFontShape{T5}{qtm}{m}{n}{<-> \qtm@scale t5-qtmr}{}
        \DeclareFontShape{T5}{qtm}{m}{scit}{<-> \qtm@scale t5-qtmri-sc}{}
        \DeclareFontShape{T5}{qtm}{m}{it}{<-> \qtm@scale t5-qtmri}{}
        \DeclareFontShape{T5}{qtm}{bx}{sc}{<->ssub * qtm/b/sc}{}
        \DeclareFontShape{T5}{qtm}{bx}{n}{<->ssub * qtm/b/n}{}
        \DeclareFontShape{T5}{qtm}{bx}{scit}{<->ssub * qtm/b/scit}{}
        \DeclareFontShape{T5}{qtm}{bx}{it}{<->ssub * qtm/b/it}{}
        \DeclareFontShape{T5}{qtm}{b}{sl}{<->sub * qtm/b/it}{}
        \DeclareFontShape{T5}{qtm}{m}{sl}{<->sub * qtm/m/it}{}
        \DeclareFontShape{T5}{qtm}{b}{scsl}{<->sub * qtm/b/scit}{}
        \DeclareFontShape{T5}{qtm}{m}{scsl}{<->sub * qtm/m/scit}{}
%                
        \def\qcr@scale{s*[0.95]}
        \DeclareFontFamily{T5}{qcr}{}% not adjusting wordspacing
        \DeclareFontShape{T5}{qcr}{b}{sc}{<-> \qcr@scale t5-qcrb-sc}{}
        \DeclareFontShape{T5}{qcr}{b}{n}{<-> \qcr@scale t5-qcrb}{}
        \DeclareFontShape{T5}{qcr}{b}{scit}{<-> \qcr@scale t5-qcrbi-sc}{}
        \DeclareFontShape{T5}{qcr}{b}{it}{<-> \qcr@scale t5-qcrbi}{}
        \DeclareFontShape{T5}{qcr}{m}{sc}{<-> \qcr@scale t5-qcrr-sc}{}
        \DeclareFontShape{T5}{qcr}{m}{n}{<-> \qcr@scale t5-qcrr}{}
        \DeclareFontShape{T5}{qcr}{m}{scit}{<-> \qcr@scale t5-qcrri-sc}{}
        \DeclareFontShape{T5}{qcr}{m}{it}{<-> \qcr@scale t5-qcrri}{}
        \DeclareFontShape{T5}{qcr}{bx}{sc}{<->ssub * qcr/b/sc}{}
        \DeclareFontShape{T5}{qcr}{bx}{n}{<->ssub * qcr/b/n}{}
        \DeclareFontShape{T5}{qcr}{bx}{scit}{<->ssub * qcr/b/scit}{}
        \DeclareFontShape{T5}{qcr}{bx}{it}{<->ssub * qcr/b/it}{}
        \DeclareFontShape{T5}{qcr}{b}{sl}{<->sub * qcr/b/it}{}
        \DeclareFontShape{T5}{qcr}{m}{sl}{<->sub * qcr/m/it}{}
        \DeclareFontShape{T5}{qcr}{b}{scsl}{<->sub * qcr/b/scit}{}
        \DeclareFontShape{T5}{qcr}{m}{scsl}{<->sub * qcr/m/scit}{}
    	\endgroup
    \fi

    \ifac@greek
%
	\IfFormatAtLeastTF{2020/02/02}{\relax}{%
	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions 2020 are necessary to use the fonts of the [greek] option with pdflatex}{Please UPDATE your LaTeX distribution: TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  Alternatively, delete the class option [greek].}%
	}
%
    	\AtBeginDocument{%
			\let\babel@aux\@gobbletwo % eliminate warnings about missing .fd. Brute force approach, revisit later. 2022/03/14
    		\DeclareFontFamilySubstitution{LGR}{\familydefault}{artemisia} % scale these
    		\DeclareFontFamilySubstitution{LGR}{\sfdefault}{maksf}%kerkis
    		\DeclareFontFamilySubstitution{LGR}{\ttdefault}{DejaVuSansMono-TLF}
    	}	
%        %% Based on Artemisia fd files by A. Tsolomitis and ideas from substitutefont package by G. Milde, both LaTeX Public License.
        \begingroup
        \nfss@catcodes
%        
        \def\artemisiasc@scaled{s*[0.95]}
        \def\artemisia@scaled{s*[0.93]}
        \DeclareFontFamily{LGR}{artemisia}{%
        	\fontdimen2\font=.25em
    		\fontdimen3\font=.2em
    		\fontdimen4\font=.1em
    		}% adjusted word spacing to match newtxtext... this is tighter.
        \DeclareFontShape{LGR}{artemisia}{m}{n}{<->  \artemisia@scaled gartemisiarg6a}{}
        \DeclareFontShape{LGR}{artemisia}{m}{it}{<-> \artemisia@scaled gartemisiai6a}{}
        \DeclareFontShape{LGR}{artemisia}{b}{n}{<->  \artemisia@scaled gartemisiab6a}{}
        \DeclareFontShape{LGR}{artemisia}{b}{it}{<-> \artemisia@scaled gartemisiabi6a}{}
        \DeclareFontShape{LGR}{artemisia}{m}{sl}{<-> \artemisia@scaled gartemisiao6a}{}
        \DeclareFontShape{LGR}{artemisia}{b}{sl}{<-> \artemisia@scaled gartemisiabo6a}{}
        \DeclareFontShape{LGR}{artemisia}{m}{sc}{<-> \artemisiasc@scaled gartemisiasc6a}{}
        \DeclareFontShape{LGR}{artemisia}{m}{sco}{<->\artemisiasc@scaled gartemisiasco6a}{}
%        
        %% nextx names oblique sc as both scit and scsl. ("largesc" option of newtx is different font, not a scaling.) 
        \DeclareFontShape{LGR}{artemisia}{m}{scsl}{<->\artemisiasc@scaled gartemisiasco6a}{}% sco
        \DeclareFontShape{LGR}{artemisia}{m}{scit}{<->\artemisiasc@scaled gartemisiasco6a}{}% sco
%        
        \DeclareFontShape{LGR}{artemisia}{bx}{n}{<-> \artemisia@scaled gartemisiab6a}{}
        \DeclareFontShape{LGR}{artemisia}{bx}{it}{<->\artemisia@scaled gartemisiabi6a}{}
        \DeclareFontShape{LGR}{artemisia}{bx}{sl}{<->\artemisia@scaled gartemisiabo6a}{}
%        
%        % Sans Serif Greek font Kerkis
%        % Based on Kerkis fd file, by Antonis Tsolomitis, under the LaTeX Project Public License
        \def\kerkissf@scaled{s*[0.95]}
        \DeclareFontFamily{LGR}{maksf}{}% not adjusting wordspacing
        \DeclareFontShape{LGR}{maksf}{m}{n}{<-> \kerkissf@scaled gksf7t}{}
        \DeclareFontShape{LGR}{maksf}{m}{it}{<->\kerkissf@scaled gksfi7t}{}  
        \DeclareFontShape{LGR}{maksf}{m}{sl}{<->\kerkissf@scaled gksfi7t}{}
        \DeclareFontShape{LGR}{maksf}{m}{sc}{<->\kerkissf@scaled gksfsc7t}{}
        \DeclareFontShape{LGR}{maksf}{b}{n}{ <->\kerkissf@scaled gksfb7t}{}  
        \DeclareFontShape{LGR}{maksf}{b}{it}{<->\kerkissf@scaled gksfbi7t}{}
        \DeclareFontShape{LGR}{maksf}{b}{sl}{<->\kerkissf@scaled gksfbi7t}{}  
%        
        \DeclareFontShape{LGR}{maksf}{bx}{n}{  <-> \kerkissf@scaled gksfb7t}{}
        \DeclareFontShape{LGR}{maksf}{bx}{it}{ <-> \kerkissf@scaled gksfbi7t}{}
        \DeclareFontShape{LGR}{maksf}{bx}{sl}{ <-> \kerkissf@scaled gksfbi7t}{}
%    
%        %% Greek monospaced font, DejaVuSansMono
%        %% Based on DejaVu fd files by Pavel Farar, under the LaTeX Project Public License
        \def\DejaVuSansMono@@scale{s*[0.85]}%
        \DeclareFontFamily{LGR}{DejaVuSansMono-TLF}{}% not adjusting wordspacing
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{b}{it}{<-> \DejaVuSansMono@@scale DejaVuSansMono-BoldOblique-tlf-lgr}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{b}{n}{ <-> \DejaVuSansMono@@scale DejaVuSansMono-Bold-tlf-lgr}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{m}{it}{<-> \DejaVuSansMono@@scale DejaVuSansMono-Oblique-tlf-lgr}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{m}{n}{ <-> \DejaVuSansMono@@scale DejaVuSansMono-tlf-lgr}{}
        
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{m}{sl}{<-> \DejaVuSansMono@@scale DejaVuSansMono-TLF/m/it}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{b}{sl}{<-> \DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
        
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{bx}{sl}{<->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{bx}{it}{<->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
        \DeclareFontShape{LGR}{DejaVuSansMono-TLF}{bx}{n}{ <->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/n}{}
%
    	\endgroup
    \fi

    \ifac@cyrillic
%
	\IfFormatAtLeastTF{2020/02/02}{\relax}{%
	\ClassError{asmeconf}{Your LaTeX format is dated \fmtversion. LaTeX distributions 2020 are necessary to use the fonts of the cyrillic language option with pdflatex, e.g., [russian]}{Please UPDATE your LaTeX distribution: TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  Alternatively, delete the class option calling a cyrillic-alphabet language.}%
	}
%
	\AtBeginDocument{%
		\let\babel@aux\@gobbletwo % eliminate warnings about missing .fd. Brute force approach, revisit later. 2022/03/14
		\DeclareFontFamilySubstitution{T2A}{\familydefault}{PTSerif-TLF}
		\DeclareFontFamilySubstitution{T2A}{\sfdefault}{PTSans-TLF}
%		\DeclareFontFamilySubstitution{T2A}{\ttdefault}{DejaVuSansMono-TLF} % if one prefers an SF monospace font
		\DeclareFontFamilySubstitution{T2A}{\ttdefault}{PTMono} 
	}
       %% Paratype fonts for cyrillic, maintained by Pavel Farar, under Latex Project Public License
        \begingroup
        \nfss@catcodes
%        
        \def\PTSerif@@scale{s*[0.95]}% had had 0.94...
        \DeclareFontFamily{T2A}{PTSerif-TLF}{}% not adjusting wordspacing, since it matches newtxtext as is
        \DeclareFontShape{T2A}{PTSerif-TLF}{m}{n}{ <->\PTSerif@@scale PTSerif-Regular-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{m}{it}{<->\PTSerif@@scale PTSerif-Italic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{b}{n}{ <->\PTSerif@@scale PTSerif-Bold-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{b}{it}{<->\PTSerif@@scale PTSerif-BoldItalic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{m}{ui}{<->\PTSerif@@scale PTSerif-UprightItalic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{m}{sl}{<->\PTSerif@@scale PTSerif-Slanted-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{b}{ui}{<->\PTSerif@@scale PTSerif-BoldUprightItalic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{b}{sl}{<->\PTSerif@@scale PTSerif-BoldSlanted-tlf-t2a}{}
%        
        \DeclareFontShape{T2A}{PTSerif-TLF}{bx}{n}{<->ssub * PTSerif-TLF/b/n}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{bx}{it}{<->ssub * PTSerif-TLF/b/it}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{bx}{ui}{<->ssub * PTSerif-TLF/b/ui}{}
        \DeclareFontShape{T2A}{PTSerif-TLF}{bx}{sl}{<->ssub * PTSerif-TLF/b/sl}{}
%        
        \def\PTSans@@scale{s*[0.94]}%
        \DeclareFontFamily{T2A}{PTSans-TLF}{}% not adjusting wordspacing
        \DeclareFontShape{T2A}{PTSans-TLF}{b}{it}{<->\PTSans@@scale PTSans-BoldItalic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{b}{n}{<-> \PTSans@@scale PTSans-Bold-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{m}{it}{<->\PTSans@@scale PTSans-Italic-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{m}{n}{<-> \PTSans@@scale PTSans-Regular-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{c}{n}{<-> \PTSans@@scale PTSans-Narrow-tlf-t2a}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{bc}{n}{<->\PTSans@@scale PTSans-NarrowBold-tlf-t2a}{}
%        
        \DeclareFontShape{T2A}{PTSans-TLF}{m}{sl}{<->ssub * PTSans-TLF/m/it}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{b}{sl}{<->ssub * PTSans-TLF/b/it}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{bx}{sl}{<->ssub * PTSans-TLF/b/it}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{bx}{it}{<->ssub * PTSans-TLF/b/it}{}
        \DeclareFontShape{T2A}{PTSans-TLF}{bx}{n}{<->ssub * PTSans-TLF/b/n}{}
%
%        %% the tt cyrillic is slightly larger than the latin characters.    
         \def\PTMono@@scale{s*[0.92]}%
         \DeclareFontFamily{T2A}{PTMono}{}% not adjusting wordspacing
         \DeclareFontShape{T2A}{PTMono}{m}{n}{<-> \PTMono@@scale PTMono-Regular-tlf-t2a}{}
         \DeclareFontShape{T2A}{PTMono}{b}{n}{<-> \PTMono@@scale PTMono-Bold-tlf-t2a}{}
         \DeclareFontShape{T2A}{PTMono}{m}{sl}{<->\PTMono@@scale PTMono-Slanted-tlf-t2a}{}
         \DeclareFontShape{T2A}{PTMono}{b}{sl}{<->\PTMono@@scale PTMono-BoldSlanted-tlf-t2a}{}
         \DeclareFontShape{T2A}{PTMono}{m}{it}{<->\PTMono@@scale PTMono-Slanted-tlf-t2a}{}
         \DeclareFontShape{T2A}{PTMono}{b}{it}{<->\PTMono@@scale PTMono-BoldSlanted-tlf-t2a}{}
        
         \DeclareFontShape{T2A}{PTMono}{bx}{n}{<->ssub * PTMono-TLF/b/n}{}
         \DeclareFontShape{T2A}{PTMono}{bx}{sl}{<->ssub * PTMono-TLF/b/sl}{}
%
        \def\DejaVuSansMono@@scale{s*[0.85]}%
        \DeclareFontFamily{T2A}{DejaVuSansMono-TLF}{}% not adjusting wordspacing
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{b}{it}{<-> \DejaVuSansMono@@scale DejaVuSansMono-BoldOblique-tlf-t2a}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{b}{n}{ <-> \DejaVuSansMono@@scale DejaVuSansMono-Bold-tlf-t2a}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{m}{it}{<-> \DejaVuSansMono@@scale DejaVuSansMono-Oblique-tlf-t2a}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{m}{n}{ <-> \DejaVuSansMono@@scale DejaVuSansMono-tlf-t2a}{}
%        
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{m}{sl}{<-> \DejaVuSansMono@@scale DejaVuSansMono-TLF/m/it}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{b}{sl}{<-> \DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
%        
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{bx}{sl}{<->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{bx}{it}{<->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/it}{}
        \DeclareFontShape{T2A}{DejaVuSansMono-TLF}{bx}{n}{ <->\DejaVuSansMono@@scale DejaVuSansMono-TLF/b/n}{}
%   
        \endgroup 
    \fi
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput
%%
%% End of file `asmeconf.cls'.

