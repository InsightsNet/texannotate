% iopart-num.bst -- BibTeX style for IOP journals (Harvard-like numeric style)
% M. A. Caprio
%
% DESCRIPTION
%
%   Further documenation may be found in iopart-num.pdf.
%
%   Available from CTAN as /biblio/bibtex/contrib/iopart-num.
%
% COPYRIGHT/LICENSE
%
%   Copyright 2009 M. A. Caprio
%
%   This work may be distributed and/or modified under the
%   conditions of the LaTeX Project Public License, either 
%   version 1.3 of this license or (at your option) any later 
%   version.  The latest version of this license is in
%     http://www.latex-project.org/lppl.txt
%   and version 1.3 or later is part of all distributions of 
%   LaTeX version 2005/12/01 or later.
%
%   This work has the LPPL maintenance status "maintained".
% 
%   The Current Maintainer of this work is the author.
%
%   The contents of this work are listed in the README file.
%
% HISTORY
% 
% Version 1.0 (2005/07/11)
%   Created using custom-bib (merlin.mbs), with following manual modifications:
%   -- remove trailing period from predefined volume, page, etc., abbreviations
%   -- provide command \newblock to fix incompatibility between natbib
%      and iopart (as of iopart version 1996/06/10) 
%   -- move edition after booktitle
%   -- add version identifier to generated output
%   -- for incollection and inproceedings, move volume from after publisher to before
%   -- for any series with number, number after series
% Version 2.0 (2006/12/21)
%   -- define section field for proper formatting of lettered journal sections 
%      (suggested by Chris Latham)
%   -- suppress printing of number for article, but provide issue field
%      for periodicals with issue-based page numbering (suggested by Chris Latham)
%   -- patch remove.dots to not strip "\." control sequence (bug reported by Kevin Bube)
%   -- define epilog field (undocumented)
%   -- delete predefined computer science journal names
%   -- bring book volume+number or series+number formatting into IOP form
%   -- for book, inbook, and proceedings with editors but no author, fix formating of editors
%   -- for incollection and inproceedings, put editors in correct location
%   -- for journal: use same page formatting even if volume missing
% Version 2.1 (2009/01/22)
%   -- for incollection and inproceedings: support title of chapter (not appropriate 
%      to inbook)
%   -- for book, proceedings, etc.: support volumetitle for multivolume book
%
% LIMITATIONS
%
% Still not in IOP form: 
%   -- for incollection and inproceedings, editors initials should preceed rather 
%      than follow last name
% Other:
%   -- hyphenated first names lose hyphen

%% This is file `iopart-num.bst',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% merlin.mbs  (with options: `seq-no,nm-rv,dt-beg,yr-blk,xmth,yrp-x,jtit-x,vol-bf,volp-blk,num-xser,jnm-x,add-pub,pub-par,pre-pub,isbn,issn,blk-com,com-blank,fin-bare,pp,ed,abr,ednx,mth-bare,ord,jabr,and-xcom,etal-it,revdata,eprint,url,url-blk')
%% ----------------------------------------
%% *** Institute of Physics (IOP) journals; Harvard-like numeric style ***
%% 
%% Copyright 1994-2002 Patrick W Daly
 % ===============================================================
 % IMPORTANT NOTICE:
 % This bibliographic style (bst) file has been generated from one or
 % more master bibliographic style (mbs) files, listed above.
 %
 % This generated file can be redistributed and/or modified under the terms
 % of the LaTeX Project Public License Distributed from CTAN
 % archives in directory macros/latex/base/lppl.txt; either
 % version 1 of the License, or any later version.
 % ===============================================================
 % Name and version information of the main mbs file:
 % \ProvidesFile{merlin.mbs}[2002/10/21 4.05 (PWD, AO, DPC)]
 %   For use with BibTeX version 0.99a or later
 %-------------------------------------------------------------------
 % This bibliography style file is intended for texts in ENGLISH
 % This is a numerical citation style, and as such is standard LaTeX.
 % It requires no extra package to interface to the main text.
 % The form of the \bibitem entries is
 %   \bibitem{key}...
 % Usage of \cite is as follows:
 %   \cite{key} ==>>          [#]
 %   \cite[chap. 2]{key} ==>> [#, chap. 2]
 % where # is a number determined by the ordering in the reference list.
 % The order in the reference list is that by which the works were originally
 %   cited in the text, or that in the database.
 %---------------------------------------------------------------------

ENTRY
  { address
    archive
    author
    booktitle
    chapter
    collaboration
    edition
    editor
    eid
    eprint
    howpublished
    institution
    isbn
    issn
    journal
    key
    month
    note
    number
    numpages
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    volume
    year
%mc
    issue
    section
    epilog
    volumetitle
    transjournal
    transsection
    transvolume
    transnumber
    transissue
    transpages
    transyear
  }
  {}
  { label }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}
FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}
FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mc utilities
%   require merlin.mbs logical operators and field.or.null
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hang -- {hang} suspends execution, for debugging purposes
%   Note that not all pending output may have been flushed.
FUNCTION {hang}
{
  {#1} {skip$} while$
}

% string.length -- {s string.length} returns the true character length of s
%   In contrast, text.length$ gives special treatment to LaTeX
%   accents ("special characters") and braces.
%   Example:   "" string.length     -> 0
%   Example:   "hello" string.length    -> 5

STRINGS {string.length.s }
INTEGERS {string.length.i }
FUNCTION {string.length}
{
 'string.length.s :=
 #0 'string.length.i :=
  {
    string.length.s #1 #1 substring$ "" = not
  }
  { 
   string.length.i #1 + 'string.length.i := 
   string.length.s #2 global.max$ substring$ 'string.length.s :=
  }
  while$
  string.length.i
}

% shared working variables for stripping functions
STRINGS { strip.s strip.t }
INTEGERS { strip.i }

% strip.leading -- {s t strip.leading} strips t from s if it appears
%   as an initial substring 
%   Example:   "abcdef" "abc" strip.leading   -> "def"
%   Example:   "abcdef" "xyz" strip.leading   -> "abcdef"

FUNCTION{strip.leading}
{
  'strip.t :=
  'strip.s :=
  strip.t string.length 'strip.i :=
  strip.s #1 strip.i substring$ strip.t =
    { strip.s strip.i #1 + global.max$ substring$ }
    { strip.s }
  if$
}

% strip.trailing -- {s t strip.trailing} strips t from s if it appears
%   as a terminal substring 
%   Example:   "abcdef" "def" strip.trailing  -> "abc"
%   Example:   "abcdef" "xyz" strip.trailing  -> "abcdef"
FUNCTION{strip.trailing}
{
  'strip.t :=
  'strip.s :=
  strip.t string.length 'strip.i :=
  strip.s #-1 strip.i substring$ strip.t =
    { strip.s #-1 strip.i - global.max$ substring$ }
    { strip.s }
  if$
}

% trim -- {s trim} strips any trailing whitespace from s
%   Example:   "abcdef  " trim  -> "abcdef"
STRINGS {trim.s trim.t}
FUNCTION{trim}
{
  'trim.s :=
  {
   trim.s #-1 #1 substring$ 'trim.t :=
   trim.t empty$ trim.t string.length #0 > and
  }
    { trim.s #-2 global.max$ substring$ 'trim.s := }
  while$
  trim.s
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


INTEGERS { output.state before.all mid.sentence after.sentence after.block }
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}
STRINGS { s t}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { " " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}
FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}
FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

%mc
FUNCTION {format.epilog}
{ epilog duplicate$ empty$
    { pop$ }
    { * }
  if$
}
%mc end


FUNCTION {fin.entry}
{   
%mc
format.epilog 
%mc end
  duplicate$ empty$
    'pop$
    'write$
  if$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}
FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}
FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}

FUNCTION {date.block}
{
  add.blank
}

STRINGS {z}
FUNCTION {remove.dots}
{ 'z :=
  ""
  { z empty$ not }
  {
%mc patch to preserve the control sequence \. if it appears in a name
   z #1 #2 substring$ "\." = 
      { 
        % process "\." sequence
        z #3 global.max$ substring$ 'z :=
        "\." * 
      }
      {    
        % process regular character
        z #1 #1 substring$
        z #2 global.max$ substring$ 'z :=
        duplicate$ "." = 'pop$
         { * }
        if$
      }
    if$
%mc
  }
  while$
}
FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}
FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}
FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}
FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}
FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}
FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "\/}" * }
  if$
}
FUNCTION {bolden}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}
FUNCTION {tie.or.space.prefix}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$
}

FUNCTION {capitalize}
{ "u" change.case$ "t" change.case$ }

FUNCTION {space.word}
{ " " swap$ * " " * }
 % Here are the language-specific definitions for explicit words.
 % Each function has a name bbl.xxx where xxx is the English word.
 % The language selected here is ENGLISH
FUNCTION {bbl.and}
{ "and"}

FUNCTION {bbl.etal}
{ "et~al." }

FUNCTION {bbl.editors}
{ "eds" }

FUNCTION {bbl.editor}
{ "ed" }

FUNCTION {bbl.edby}
{ "edited by" }

FUNCTION {bbl.edition}
{ "ed" }

FUNCTION {bbl.volume}
{ "vol" }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "no" }

FUNCTION {bbl.nr}
{ "no" }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.pages}
{ "pp" }

FUNCTION {bbl.page}
{ "p" }

FUNCTION {bbl.eidpp}
{ "pages" }

FUNCTION {bbl.chapter}
{ "chap" }

FUNCTION {bbl.techrep}
{ "Tech. Rep." }

FUNCTION {bbl.mthesis}
{ "Master's thesis" }

FUNCTION {bbl.phdthesis}
{ "Ph.D. thesis" }

FUNCTION {bbl.first}
{ "1st" }

FUNCTION {bbl.second}
{ "2nd" }

FUNCTION {bbl.third}
{ "3rd" }

FUNCTION {bbl.fourth}
{ "4th" }

FUNCTION {bbl.fifth}
{ "5th" }

FUNCTION {bbl.st}
{ "st" }

FUNCTION {bbl.nd}
{ "nd" }

FUNCTION {bbl.rd}
{ "rd" }

FUNCTION {bbl.th}
{ "th" }

MACRO {jan} {"Jan."}

MACRO {feb} {"Feb."}

MACRO {mar} {"Mar."}

MACRO {apr} {"Apr."}

MACRO {may} {"May"}

MACRO {jun} {"Jun."}

MACRO {jul} {"Jul."}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sep."}

MACRO {oct} {"Oct."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dec."}

FUNCTION {eng.ord}
{ duplicate$ "1" swap$ *
  #-2 #1 substring$ "1" =
     { bbl.th * }
     { duplicate$ #-1 #1 substring$
       duplicate$ "1" =
         { pop$ bbl.st * }
         { duplicate$ "2" =
             { pop$ bbl.nd * }
             { "3" =
                 { bbl.rd * }
                 { bbl.th * }
               if$
             }
           if$
          }
       if$
     }
   if$
}

FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}
FUNCTION {bibinfo.warn}
{ swap$
  duplicate$ missing$
    {
      swap$ "missing " swap$ * " in " * cite$ * warning$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ "empty " swap$ * " in " * cite$ * warning$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}
%% FUNCTION {format.eprint}
%% { eprint duplicate$ empty$
%%     'skip$
%%     { "\eprint"
%%       archive empty$
%%         'skip$
%%         { "[" * archive * "]" * }
%%       if$
%%       "{" * swap$ * "}" *
%%     }
%%   if$
%% }
FUNCTION {format.eprint}
{ eprint duplicate$ empty$
    'skip$
    { 
      "(\textit{Preprint} " 
      swap$
       "\eprint"
      archive empty$
        'skip$
        { "[" * archive * "]" * }
      if$
      "{" * swap$ * "}" *
      *
      ")"
      *
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { "\urlprefix\url{" url * "}" * }
  if$
}

STRINGS  { bibinfo}
INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}{ jj}{ f{~}}"
      format.name$
      remove.dots
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                  " " * bbl.etal emphasize *
                }
                {
                  bbl.and
                  space.word * t *
                }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}
FUNCTION {format.names.ed}
{
  'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{f{~}~}{vv~}{ll}{ jj}"
      format.name$
      remove.dots
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {

                  " " * bbl.etal emphasize *
                }
                {
                  bbl.and
                  space.word * t *
                }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}
FUNCTION {format.authors}
{ author "author" format.names
    duplicate$ empty$ 'skip$
    { collaboration "collaboration" bibinfo.check
      duplicate$ empty$ 'skip$
        { " (" swap$ * ")" * }
      if$
      *
    }
  if$
}
FUNCTION {get.bbl.editor}
{ editor num.names$ #1 > 'bbl.editors 'bbl.editor if$ }

FUNCTION {format.editors}
{ editor "editor" format.names duplicate$ empty$ 'skip$
    {
%%      "," *
%%      " " *
%%      get.bbl.editor
%%      *
%mc
      " " *
      "(" *
      get.bbl.editor
      *
      ")" *
%mc end
    }
  if$
}
%mc
FUNCTION {format.editors.inline}
{ editor "editor" format.names duplicate$ empty$ 'skip$
    {
      bbl.editor " " *
      swap$
      *
    }
  if$
}
%mc end

FUNCTION {format.isbn}
{ isbn "isbn" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      "ISBN " swap$ *
    }
  if$
}

FUNCTION {format.issn}
{ issn "issn" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      "ISSN " swap$ *
    }
  if$
}

FUNCTION {format.note}
{
 note empty$
    { "" }
    { note #1 #1 substring$
      duplicate$ "{" =
        'skip$
        { output.state mid.sentence =
          { "l" }
          { "u" }
        if$
        change.case$
        }
      if$
      note #2 global.max$ substring$ * "note" bibinfo.check
    }
  if$
}

FUNCTION {format.title}
{ title
  duplicate$ empty$ 'skip$
    { "t" change.case$ }
  if$
  "title" bibinfo.check
}
FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{
  't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {word.in}
{ bbl.in
  " " * }

FUNCTION {format.date}
{
  ""
  duplicate$ empty$
  year  "year"  bibinfo.check duplicate$ empty$
    { swap$ 'skip$
        { "there's a month but no year in " cite$ * warning$ }
      if$
      *
    }
    { swap$ 'skip$
        {
          swap$
          " " * swap$
        }
      if$
      *
      remove.dots
    }
  if$
  duplicate$ empty$
    'skip$
    {
      before.all 'output.state :=
    " " swap$ *
    }
  if$
}
FUNCTION {format.btitle}
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      emphasize
    }
  if$
}
FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}
FUNCTION {format.bvolume}
{ volume empty$
    % no volume: return blank
    { "" }
%%    { bbl.volume volume tie.or.space.prefix
%%      "volume" bibinfo.check * *
%%      series "series" bibinfo.check
%%      duplicate$ empty$ 'pop$
%%        { swap$ bbl.of space.word * swap$
%%         emphasize * }
%%      if$
%%      "volume and number" number either.or.check
%%    }
%mc
    {
      series "series" bibinfo.check
      empty$ 
        % no series: must be multivolume book
        {
          bbl.volume volume tie.or.space.prefix "volume" bibinfo.check * *
          volumetitle empty$
            'skip$
            % volumetitle: book volume has title
            { " " volumetitle "volumetitle" bibinfo.check emphasize * * }
          if$
        }
        % series: format as volume in series
        { 
          "(" 
          series "series" bibinfo.check emphasize *
          " " * bbl.volume * 
          volume tie.or.space.prefix "volume" bibinfo.check * 
          ")" * *
        }
      if$
      "volume and number" number either.or.check
    }
%mc end
  if$
}
FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { number "number" bibinfo.check }
        { 
          %% output.state mid.sentence =
          %%   { bbl.number }
          %%   { bbl.number capitalize }
          %% if$
          %% number tie.or.space.prefix "number" bibinfo.check * *
          %% bbl.in space.word *
          %% series "series" bibinfo.check *
          %% " " * bbl.number * 
          %% number tie.or.space.prefix "number" bibinfo.check * *
%mc
              "(" 
              series "series" bibinfo.check emphasize *
              " " * bbl.number * 
              number tie.or.space.prefix "number" bibinfo.check * 
              ")" *
              *
%mc end
        }
      if$
    }
      if$
    }
    { "" }
  if$
}


FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {extract.num}
{ duplicate$ 't :=
  "" 's :=
  { t empty$ not }
  { t #1 #1 substring$
    t #2 global.max$ substring$ 't :=
    duplicate$ is.num
      { s swap$ * 's := }
      { pop$ "" 't := }
    if$
  }
  while$
  s empty$
    'skip$
    { pop$ s }
  if$
}

FUNCTION {convert.edition}
{ extract.num "l" change.case$ 's :=
  s "first" = s "1" = or
    { bbl.first 't := }
    { s "second" = s "2" = or
        { bbl.second 't := }
        { s "third" = s "3" = or
            { bbl.third 't := }
            { s "fourth" = s "4" = or
                { bbl.fourth 't := }
                { s "fifth" = s "5" = or
                    { bbl.fifth 't := }
                    { s #1 #1 substring$ is.num
                        { s eng.ord 't := }
                        { edition 't := }
                      if$
                    }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
  t
}

FUNCTION {format.edition}
{ edition duplicate$ empty$ 'skip$
    {
      convert.edition
      output.state mid.sentence =
        { "l" }
        { "t" }
      if$ change.case$
      "edition" bibinfo.check
      " " * bbl.edition *
    }
  if$
}
INTEGERS { multiresult }
FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}
FUNCTION {format.pages}
{ pages duplicate$ empty$ 'skip$
    { duplicate$ multi.page.check
        {
          bbl.pages swap$
          n.dashify
        }
        {
          bbl.page swap$
        }
      if$
      tie.or.space.prefix
      "pages" bibinfo.check
      * *
    }
  if$
}
FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
%mc     { swap$ duplicate$ empty$
%mc         { pop$ pop$ format.pages }
%mc         {
%mc           " " *
%mc           swap$
%mc           n.dashify
%mc           "pages" bibinfo.check
%mc           *
%mc         }
%mc       if$
%mc     }
    { swap$
          " " *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
    }
  if$
}
FUNCTION {format.journal.eid}
{ eid "eid" bibinfo.check
  duplicate$ empty$ 'skip$
    { swap$ duplicate$ empty$ 'skip$
      {
          " " *
      }
      if$
      swap$
      numpages empty$ 'skip$
        { bbl.eidpp numpages tie.or.space.prefix
          "numpages" bibinfo.check * *
          " (" swap$ * ")" * *
        }
      if$
    }
  if$ *
}
FUNCTION {format.vol.num.pages}
{ volume field.or.null
%mc section handling
    section field.or.null strip.leading
    section field.or.null strip.trailing trim
%mc end
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  bolden
%mc  number "number" bibinfo.check duplicate$ empty$ 'skip$
  issue "issue" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
%mc        { "there's a number but no volume in " cite$ * warning$ }
        { "there's an issue but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      "(" swap$ * ")" *
    }
  if$ *
  eid empty$
    { format.journal.pages }
    { format.journal.eid }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { bbl.chapter }
        { type "l" change.case$
          "type" bibinfo.check
        }
      if$
      chapter tie.or.space.prefix
      "chapter" bibinfo.check
      * *
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.booktitle}
{
  booktitle "booktitle" bibinfo.check
  emphasize
}
%% FUNCTION {format.in.ed.booktitle}
%% { format.booktitle duplicate$ empty$ 'skip$
%%     {
%%       editor "editor" format.names.ed duplicate$ empty$ 'pop$
%%         {
%%           "," *
%%           " " *
%%           get.bbl.editor
%%           ", " *
%%           * swap$
%%           * }
%%       if$
%%       word.in swap$ *
%%     }
%%   if$
%% }
FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}
FUNCTION {format.thesis.type}
{ type duplicate$ empty$
    'pop$
    { swap$ pop$
      "t" change.case$ "type" bibinfo.check
    }
  if$
}
FUNCTION {format.tr.number}
{ number "number" bibinfo.check
  type duplicate$ empty$
    { pop$ bbl.techrep }
    'skip$
  if$
  "type" bibinfo.check
  swap$ duplicate$ empty$
    { pop$ "t" change.case$ }
    { tie.or.space.prefix * * }
  if$
}
FUNCTION {format.article.crossref}
{
  key duplicate$ empty$
    { pop$
      journal duplicate$ empty$
        { "need key or journal for " cite$ * " to crossref " * crossref * warning$ }
        { "journal" bibinfo.check emphasize word.in swap$ * }
      if$
    }
    { word.in swap$ * " " *}
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  "editor" bibinfo.check
  editor num.names$ duplicate$
  #2 >
    { pop$
      "editor" bibinfo.check
      " " * bbl.etal
      emphasize
      *
    }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            {
              "editor" bibinfo.check
              " " * bbl.etal
              emphasize
              *
            }
            {
             bbl.and space.word
              * editor #2 "{vv~}{ll}" format.name$
              "editor" bibinfo.check
              *
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume duplicate$ empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      pop$ word.in
    }
    { bbl.volume
      swap$ tie.or.space.prefix "volume" bibinfo.check * * bbl.of space.word *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { series emphasize * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.incoll.inproc.crossref}
{
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { format.booktitle duplicate$ empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
            }
            { word.in swap$ * }
          if$
        }
        { word.in key * " " *}
      if$
    }
    { word.in format.crossref.editor * " " *}
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.org.or.pub}
{ 't :=
  ""
  address empty$ t empty$ and
    'skip$
    {
      add.blank "(" *
      address "address" bibinfo.check *
      t empty$
        'skip$
        { address empty$
            'skip$
            { ": " * }
          if$
          t *
        }
      if$
      ")" *
    }
  if$
}
FUNCTION {format.publisher.address}
{ publisher "publisher" bibinfo.warn format.org.or.pub
}

FUNCTION {format.organization.address}
{ organization "organization" bibinfo.check format.org.or.pub
}



FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  crossref missing$
    {
%mc add section handling
%mc       journal
%mc       "journal" bibinfo.check
%mc       emphasize
%mc       "journal" output.check
%mc       add.blank
      journal
      "journal" bibinfo.check
      section field.or.null strip.trailing trim
      emphasize
      "journal" output.check
      add.blank
      section empty$
        { skip$ }
        { section * add.blank}
      if$
%mc end
      format.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  format.issn output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}
FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.date "year" output.check
  date.block
  format.btitle "title" output.check
  format.edition output
  crossref missing$
    { format.bvolume output
      format.number.series output
      format.publisher.address output
    }
    {
      format.book.crossref output.nonnull
    }
  if$
  %% format.edition output
  format.isbn output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}
FUNCTION {booklet}
{ output.bibitem
  format.authors output
  format.date output
  date.block
  format.title "title" output.check
  howpublished "howpublished" bibinfo.check output
  address "address" bibinfo.check output
  format.isbn output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.date "year" output.check
  date.block
  format.btitle "title" output.check
  crossref missing$
    {
      format.bvolume output
      format.publisher.address output
      %% format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      format.number.series output
    }
    {
      format.chapter.pages "chapter and pages" output.check
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  crossref missing$
    { format.isbn output }
    'skip$
  if$
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  format.title "title" output.check
  crossref missing$
    { 
      %% format.in.ed.booktitle "booktitle" output.check
%mc   
      format.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.editors.inline output
%mc end
      format.publisher.address output
      %% format.bvolume output
      %% format.number.series output
      format.chapter.pages output
      format.edition output
      format.isbn output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  format.note output
  format.eprint output
  format.url output
  fin.entry
}
FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  format.title "title" output.check
  crossref missing$
    { 

      %%format.in.ed.booktitle "booktitle" output.check
%mc   
      format.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.editors.inline output
%mc end
      publisher empty$
        { format.organization.address output }
        { organization "organization" bibinfo.check output
          format.publisher.address output
        }
      if$
      %% format.bvolume output
      %% format.number.series output
      format.pages output
      format.isbn output
      format.issn output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  format.note output
  format.eprint output
  format.url output
  fin.entry
}
FUNCTION {conference} { inproceedings }
FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization "organization" bibinfo.check
      duplicate$ empty$ 'pop$
        { output
          address "address" bibinfo.check output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  format.date output
  date.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
        {
          address "address" bibinfo.check output
        }
        'skip$
      if$
    }
    {
      organization "organization" bibinfo.check output
      address "address" bibinfo.check output
    }
  if$
  format.edition output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  format.btitle
  "title" output.check
  bbl.mthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  format.date output
  format.title output
  howpublished "howpublished" bibinfo.check output
  format.note output
  format.eprint output
  format.url output
  fin.entry
  empty.misc.check
}
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  format.btitle
  "title" output.check
  bbl.phdthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization "organization" bibinfo.check output
    }
    { format.editors output.nonnull }
  if$
  format.date "year" output.check
  date.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  editor empty$
    { publisher empty$
        'skip$
        {
          format.publisher.address output
        }
      if$
    }
    { publisher empty$
        {
          format.organization.address output }
        {
          organization "organization" bibinfo.check output
          format.publisher.address output
        }
      if$
     }
  if$
  format.isbn output
  format.issn output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  format.date "year" output.check
  date.block
  format.title
  "title" output.check
  format.tr.number output.nonnull
  institution "institution" bibinfo.warn output
  address "address" bibinfo.check output
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  format.date output
  date.block
  format.title "title" output.check
  format.note "note" output.check
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {default.type} { misc }
READ
STRINGS { longest.label }
INTEGERS { number.label longest.label.width }
FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}
FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}
EXECUTE {initialize.longest.label}
ITERATE {longest.label.pass}
FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\providecommand{\newblock}{}"
  write$ newline$
  "\begin{thebibliography}{"  longest.label  * "}" *
  write$ newline$
  "\expandafter\ifx\csname url\endcsname\relax"
  write$ newline$
  "  \def\url#1{{\tt #1}}\fi"
  write$ newline$
  "\expandafter\ifx\csname urlprefix\endcsname\relax\def\urlprefix{URL }\fi"
  write$ newline$
  "\providecommand{\eprint}[2][]{\url{#2}}"
  write$ newline$
  "% Bibliography created with iopart-num v2.1"
  write$ newline$
  "% /biblio/bibtex/contrib/iopart-num"
  write$ newline$
}
EXECUTE {begin.bib}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}
EXECUTE {end.bib}
%% End of customized bst file
%%
%% End of file `iopart-num.bst'.
