%% 
%% Archivo de clases de la Revista Mexicana de Física
%% Derechos reservados
%%
%% Ultima modificación: Lunes, Octubre 8, 2007  11:20
%%
%% --------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rmf} [2006/10/30 version 2.0 alfa]
%%
%% --------------------------------------------------------------
%% Declaraciones peeliminares
%%
\LoadClass[letter]{article} %% Cargo la clase base
\RequirePackage{amsmath}    %% Paquete matematico de la AMS
\RequirePackage{multicol}   %% Paquete para varias columnas
%%
%% Caja de texto
\textwidth =42pc
\textheight=56\baselineskip
\setlength\columnsep{18\p@}
\setlength\columnseprule{0\p@}
\oddsidemargin =-0.1in
\evensidemargin=-0.4in
\topmargin=0pt
\voffset=-0.5in
\headsep= 1pc
\floatsep=20pt
\topsep=3pt
%%
%% --------------------------------------------------------------
%% Opciones
%%
%% Por el momento no pienso agregar opciones, pues el formato
%% será uno sólo y no quiero que cambie.
%%
%% --------------------------------------------------------------
%% Mas declaraciones
%%
%% Funciones trigonométricas
\DeclareMathOperator{\sen}{sen} %% funcion seno en español
%%
\newcommand*\rmfcaptionstyle{%
  \captionstyle{indent}%
  \renewcommand\captionfont{\small}%
  \renewcommand\captionlabelfont{\scshape}%
  \setcaptionmargin{0pt}%
  \setlength\captionindent{0pt}%
  \renewcommand\captionlabeldelim{.}%
  \onelinecaptionstrue}
%%
\def\@authoraddress{}  
\def\@title{}
\def\and{\par\vspace*{5pt}} 
\def\title#1{\gdef\@title{{\centering\ignorespaces#1\vskip\baselineskip\par}}}
\def\author#1{\expandafter\def\expandafter\@authoraddress\expandafter
             {\@authoraddress{\lineskip0pt\normalsize\centering\ignorespaces#1\par}}}
\def\address#1{\expandafter\def\expandafter\@authoraddress\expandafter
{\@authoraddress{\itshape\normalsize\centering\ignorespaces#1\vskip0.5\baselineskip\par}}}
%%
%% Definition of PACS and recibido
%% and keybords and descriptores, added 17.12.97.
\def\pacs#1{\vskip1\baselineskip\par{\raggedright{\small PACS: #1}}%
            \vskip1.5\baselineskip\ignorespaces}
\def\keys#1{\vskip0.5\baselineskip\par{\raggedright{\small{\it Keywords:} #1}}%
            \vskip0.5\baselineskip\ignorespaces}
\def\descript#1{\vskip0.5\baselineskip\par{\raggedright{
\small{\it Descriptores:} #1}}%
            \vskip0\baselineskip\ignorespaces}
\def\recibido#1#2{\par%
\centerline{\small Recibido el\ #1;\ aceptado el\ #2}\par%
\vskip1.25\baselineskip\ignorespaces}
%%
%% Resumen
\newenvironment{resumen}{%
\small\vskip0.5\baselineskip\columnwidth42pc\hsize\columnwidth%
\parindent0pt\vspace{\z@}}
%% Abstract
\renewenvironment{abstract}{%
\small\vskip0.5\baselineskip\columnwidth42pc\hsize\columnwidth%
\parindent0pt\vspace{\z@}}{}

