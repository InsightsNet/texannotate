%%% ====================================================================
%%% @LaTeX-file{
%%%    filename  = "pspum-l.cls",
%%%    version   = "1.2c",
%%%    date      = "1996/11/18",
%%%    time      = "12:27:38 EST",
%%%    checksum  = "26514 36 141 1351",
%%%    author    = "Michael Downes",
%%%    address   = "American Mathematical Society, PO Box 6248,
%%%                       Providence, RI 02940, USA",
%%%    email     = "tech-support@ams.org (Internet)",
%%%    supported = "yes",
%%%    abstract  = "This is a LaTeX documentclass for the AMS Proceedings
%%%                 of Symposia in Pure Mathematics.",
%%%    docstring = "The checksum field above contains a CRC-16 checksum
%%%                 as the first value, followed by the equivalent of
%%%                 the standard UNIX wc (word count) utility output
%%%                 of lines, words, and characters.  This is produced
%%%                 by Robert Solovay's checksum utility.",
%%% }
%%% ====================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pspum-l}
              [1996/11/18 v1.2c PSPUM Author Class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsproc}}
\ProcessOptions

\LoadClass{amsproc}[1996/10/24]

\def\publname{Proceedings of Symposia in Pure Mathematics}

\def\ISSN{0082-0717}

\endinput
