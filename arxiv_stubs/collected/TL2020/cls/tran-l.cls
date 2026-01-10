%%% ====================================================================
%%% @LaTeX-file{
%%%    filename  = "tran-l.cls",
%%%    version   = "1.2c",
%%%    date      = "1997/02/02",
%%%    time      = "13:16:09 EST",
%%%    checksum  = "31680 40 149 1473",
%%%    author    = "Michael Downes",
%%%    address   = "American Mathematical Society, PO Box 6248,
%%%                       Providence, RI 02940, USA",
%%%    email     = "tech-support@ams.org (Internet)",
%%%    supported = "yes",
%%%    abstract  = "This is a LaTeX documentclass for the Transactions
%%%                 of the American Mathematical Society.",
%%%    docstring = "The checksum field above contains a CRC-16 checksum
%%%                 as the first value, followed by the equivalent of
%%%                 the standard UNIX wc (word count) utility output
%%%                 of lines, words, and characters.  This is produced
%%%                 by Robert Solovay's checksum utility.",
%%% }
%%% ====================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tran-l}
              [1997/02/02 v1.2c TRAN Author Class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ProcessOptions\relax

\LoadClass{amsart}[1996/10/24]

\def\publname{TRANSACTIONS OF THE\newline
  AMERICAN MATHEMATICAL SOCIETY}

\def\ISSN{0002-9947}

\copyrightinfo{2017}%            % copyright year
  {American Mathematical Society}% copyright holder

\endinput
