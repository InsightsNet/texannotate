% ------------------------------------------------------------------------
%
%  Defines style/format of references built using bibtex
%
%  Modified version of utcaps.bst from the University of Texas
%
%  2011/01/04: Add URL processing from APS revtex bib style
%  2005/06/30: Added arXiv: for arXiv references. Added doi as another form of eprint archive (only for articles so far).
%              See http://www.crossref.org/ and http://www.doi.org/hb.html for information on doi's (Digital Object Identifiers). G. Alverson.
%  2005/05/12: re-adapted for the UT style (http://golem.ph.utexas.edu/~distler/TeXstuff/utcaps.bst) from the unsrt style. G. Alverson.
%  2003/04/28: Original version for use at CERN/CMS. L. Taylor.
%
% ------------------------------------------------------------------------
% UT Physics bibliographic style, ver. 1.8a. Based on:
%
%X     IEEE Transactions bibliography style (29-Jan-88 version)
%X       numeric labels, order-of-reference, IEEE abbreviations,
%X       quotes around article titles, commas separate all fields
%X       except after book titles and before "notes".  Otherwise,
%X       much like the "plain" family, from which this is adapted.
%X
%X       History
%X       9/30/85    (HWT)    Original version, by Howard Trickey.
%X       1/29/88    (OP&HWT) Updated for BibTeX version 0.99a, Oren Patashnik;
%X       THIS `ieeetr' VERSION DOES NOT WORK WITH BIBTEX 0.98i.
%
%  Modifications: 1 added hypertex support and "archive" and "eprint" fields.
%                 2 parentheses around dates, and no "pp." for article entries
%                 3 "publisher, address" instead of "address: publisher"
%                 4 added "report" field for article entries.
%                 5 particle physics-oriented abbreviations, rather than ieee.
%                 6 added "collaboration" field, as per
%                    Jonathan Flynn' suggestion. SPIRES now supports this field.
%                 7 Improved output of Proceedings entries
%
%    Modified by Jacques Distler, 11/99
%           History: ver 1.0  9/96
%                    ver 1.1 10/96 - added "collaboration" field
%                    ver 1.2  7/97 - added a "\providecommand{\href}[2]{#2}"
%                                    to handle case where \href is not defined
%                    ver 1.3 12/97 - fixed lousy-looking proceedings output.
%                    ver 1.4  1/98 - fixed format.number, address in
%                                    proceedings entries
%                    ver 1.5  3/99 - added (nonprinting) CITATION field for
%                                    SLAC internal use
%                    ver 1.6  4/99 - Fix to ensure %%CITATION output not broken
%                                    across lines. Added new.sentence to ensure
%                                    previous output properly terminated.
%                                    (Moral: test before you release.)
%                    ver 1.7 10/99 - "et.~al." should be "et al." Morons!
%                    ver 1.8 11/99 - Changed the Web URL to the more portable
%                                    arXiv.org. The "archive" field functions as
%                                    a true base-URL. This is NOT A
%                                    BACKWARDS-COMPATIBLE change!
%                   ver 1.8a 12/99 - MACROs for arXiv and cogprints
%                                    BaseURL's defined.
%
% HyperTeX Wizardry:
%
% The following are equivalent:
%   archive  =  arXiv
%   eprint   = "hep-th/9605023"
% and
%   eprint   = "hep-th/9605023"
% both produce
%    \href{http://arXiv.org/abs/hep-th/9605023}{{\tt hep-th/9605023}}
% in the bibliographic output at the appropriate point. More generally,
% if the archive field is present, we produce a URL of the form
% "archive/eprint" as the first argument of the \href. If absent, the base
% URL defaults to "http://arXiv.org/abs"
% If you are using a hypertex macropackage, like hyperref.sty, this command
% will create a link to the eprint at Los Alamos (or wherever).
%
% The bibtex output produced by SPIRES, while far from perfect, is pretty
% suitable for use with this style. Indeed, this style was designed with
% SPIRES in mind.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    archive
    eprint
    doi
    isbn
    url
    report
    collaboration
    SLACcitation
  }
  {}
  { label  extra.label sort.label short.list }

INTEGERS { output.state before.all mid.sentence after.quote after.sentence
        after.quoted.block after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.quote :=
  #3 'after.sentence :=
  #4 'after.quoted.block :=
  #5 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.quote =
    { " " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
        'write$
        { output.state after.quoted.block =
            { write$
              newline$
              "\newblock " write$
            }
            { add.period$ " " * write$ }
          if$
        }
          if$
        }
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
FUNCTION {output.nopunct}
{
  write$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}


FUNCTION {blank.sep}
{ after.quote 'output.state :=
}

FUNCTION {fin.entry}
{ output.state after.quoted.block =
    'skip$
    'add.period$
  if$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { output.state after.quote =
    { after.quoted.block 'output.state := }
    { after.block 'output.state := }
      if$
    }
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

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\textit{ " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  { namesleft #0 > }
  {
    namesleft #4 >
    {
      s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      t * " {et~al.}"
      #0 'namesleft :=
    }
    {
      s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
      {
        namesleft #1 >
        {
          nameptr #4 =
          { ", " * t * "{ et~al.}" *}
          { ", " * t * }
          if$
        }
        {
          t "others" =
          { " {et~al.}" * }
          {
            nameptr #2 =
            { " and " * t * }
            { ", and " * t *}
            if$
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
    if$
  }
  while$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}



FUNCTION {format.eprint}
{ eprint empty$
     { ""}
     { archive empty$
          {"\href{http://www.arXiv.org/abs/" eprint * "}" *
             "{\texttt{arXiv:" * eprint * "}}" *}
          {"\href{" archive *  "/" * eprint * "}" *
             "{\texttt{" * eprint * "}}" *}
       if$
     }
     if$
}

FUNCTION {format.doi}
{ doi empty$
     { ""}
     {"\href{http://dx.doi.org/" doi * "}{\doi{" * doi * "}}" *}
     if$
}

FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { "ISBN~" isbn * }
  if$
}

FUNCTION {format.report}
{ report empty$
     { ""}
     { report}
     if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
    { ", eds." * }
    { ", ed." * }
      if$
    }
  if$
}

FUNCTION {format.title}
{title
  duplicate$ empty$ 'skip$
    { "t" change.case$
    "''," *
    "``" swap$
    *}
  if$
}



FUNCTION {format.full.names}
{'s :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
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
}

FUNCTION {author.editor.full}
{ author empty$
    { editor empty$
        { "" }
        { editor format.full.names }
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {author.full}
{ author empty$
    { "" }
    { author format.full.names }
  if$
}

FUNCTION {editor.full}
{ editor empty$
    { "" }
    { editor format.full.names }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.full
    { type$ "proceedings" =
        'editor.full
        'author.full
      if$
    }
  if$
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

FUNCTION {format.title.p}
{ title empty$
    { "" }
    { "``" title * "''." * }
  if$
}

FUNCTION {n.dashify}
{ 't :=
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

FUNCTION {format.date}
{ year empty$
    { month empty$
    { "" }
    { "there's a month but no year in " cite$ * warning$
      month
    }
      if$
    }
    { month empty$
    'year
    { month ", " * year * }
      if$
    }
  if$
}

FUNCTION {format.date.paren}
{ year empty$
    { month empty$
    { "" }
    { "there's a month but no year in " cite$ * warning$
      month
    }
      if$
    }
    { month empty$
    {"(" year * ")" *}
    {"(" month * ", " * year * ")" *}
      if$
    }
  if$
}

FUNCTION {format.collaboration}
{ collaboration empty$
    { "" }
    { "{" collaboration * "}" * " Collaboration" * }
  if$
}

FUNCTION {format.SLACcitation}
{ SLACcitation empty$
  {""}
   { newline$ SLACcitation output "" newline$ }
  if$
}

FUNCTION {format.btitle}
{ "``" title * "''" * }            %---------------- Modified (LT) was:   { title emphasize }

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect   %---------------- Modified (GA) was: "vol.~" volume *
      series empty$
    'skip$
    { " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
    { series field.or.null }
    { output.state mid.sentence =
        { "number" }                            %---------------- Modified (GA) was: "no.~", etc
        { "Number" }
      if$
      number tie.or.space.connect               %---------------- Modified (GA) was: number *
      series empty$
        { "there's a number but no series in " cite$ * warning$ }
        { " in " * series * }
      if$
    }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition "l" change.case$ " edition" * }%---------------- Modified (GA) was: "~ed." *
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
{ pages empty$
    { "" }
    { pages multi.page.check
    { "pp.~" pages n.dashify * }
    { "p.~" pages * }
      if$
    }
  if$
}

FUNCTION {format.pages.nopp}
{ pages empty$
    { "" }
    { pages multi.page.check
    { pages n.dashify  }
    { pages }
      if$
    }
  if$
}


FUNCTION {format.volume}
{ volume empty$
    { "" }
    { "\textbf{ " volume * "}" * }
  if$
}

FUNCTION {format.number}
{ number empty$
    { "" }
    { "no.~" number * "," *}
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
    { "ch.~" chapter * }
    { type "l" change.case$ chapter tie.or.space.connect }
      if$
      pages empty$
    'skip$
    { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { "in " booktitle emphasize *
      editor empty$
    'skip$
    { ", " * format.editors *  }
      if$
    }
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      output.state after.block =
    { type "t" change.case$ }
    { type "l" change.case$ }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" } %---------------- Modified (GA) was: Tech. Rep.
    'type
  if$
  number empty$
    { "l" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.paddress}
{ address empty$
    { "" }
    { "(" address * ")" * }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
    { "need key or journal for " cite$ * " to crossref " * crossref *
      warning$
      ""
    }
    { "in \textit{ " journal * "\/}" * }
      if$
    }
    { "in " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " {et.~al.}" * }
    { #2 <
    'skip$
    { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
        { " {et.~al.}" * }
        { " and " * editor #2 "{vv~}{ll}" format.name$ * }
      if$
    }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect %---------------- Modified (GA) was: "Vol.~" volume *
      " of " *
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
        { "\textit{ " * series * "\/}" * }
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
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
    { booktitle empty$
        { "need editor, key, or booktitle for " cite$ * " to crossref " *
          crossref * warning$
          ""
        }
        { "in \textit{" booktitle * "\/}" * }
      if$
    }
    { "in " key * }
      if$
    }
    { "in " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.url}
{
  url duplicate$ empty$
    { pop$ "" }
    {
      "\url "
      "{" * swap$ * "}" *
    }
  if$
}
FUNCTION {href.command}
{
  "\href "
}
FUNCTION {noop.command}
{
  "\hrefCMSnoop "
}
FUNCTION {link.tag.open}
{
  doi duplicate$ empty$
    {
      pop$
      url duplicate$ empty$
        {
          pop$ "" noop.command
        }{
          href.command
        }
      if$
    }
    {
      pop$ "" noop.command
    }
  if$
  "{" * swap$ * "}{" *
}
FUNCTION {link.tag.shut}
{
  "}"
}
FUNCTION {link.open}
{
  link.tag.open output.nopunct
}
FUNCTION {link.shut}
{
  link.tag.shut *
}
FUNCTION {add.doi}
{
  link.tag.open swap$ * link.tag.shut *
}
FUNCTION {article}
{ output.bibitem
  format.collaboration output
  collaboration empty$
    {
      format.authors "author" output.check
    }
   {}
  if$
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  crossref missing$
    {  journal missing$
       {}
       { journal emphasize "journal" output.check
         blank.sep
         format.volume output
         blank.sep
         format.date.paren "year"  output.check
         month empty$
           { format.number output }
           'skip$
         if$
         blank.sep
         format.pages.nopp output
       }
       if$
       report missing$
         { format.doi output format.eprint output }
         { blank.sep format.report output format.doi output format.eprint output }
       if$
    }
    { format.article.crossref output.nonnull
      format.pages output
      format.doi output
      format.eprint output
    }
  if$
  new.sentence
  note output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  format.collaboration output
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
    { "author and editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  note output
  new.sentence
  format.doi output
  format.isbn output
  format.SLACcitation output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.collaboration output
  format.authors output
  title empty$
    { "empty title in " cite$ * warning$
      howpublished new.sentence.checka
    }
    { howpublished empty$ not
      address empty$ month empty$ year empty$ and and
      or
    { format.title.p output.nonnull }
    { format.title output.nonnull }
      if$
      blank.sep
    }
  if$
  howpublished output
  address output
  format.date output
  new.block
  note output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  format.collaboration output
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
    { "author and editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  link.open
  format.btitle "title" output.check
  link.shut
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.block
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  format.eprint output
  new.block
  note output
  new.sentence
  format.doi output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.collaboration output
  format.authors "author" output.check
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.block
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  format.eprint output
  new.block
  note output
  new.sentence
  format.doi output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.collaboration output
  format.authors "author" output.check
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      organization output
      new.block
      publisher output
      address output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.eprint output
  new.block
  note output
  new.sentence
  format.doi output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.collaboration output
  author empty$
    { organization empty$
    'skip$
    { organization output.nonnull
      address output
    }
      if$
    }
    { format.authors output.nonnull }
  if$
  format.btitle "title" output.check
  author empty$
    { organization empty$
    { address new.block.checka
      address output
    }
    'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  format.eprint output
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.collaboration output
  format.authors output
  link.open
  title empty$
    { howpublished new.sentence.checka }
    { howpublished empty$ not
      month empty$ year empty$ and
      or
    { format.title.p output.nonnull }
    { format.title output.nonnull }
      if$
      blank.sep
    }
  if$
  link.shut
  howpublished output
  format.date output
  new.block
  note output
  new.sentence
  format.doi output
  format.url output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  link.open
  format.btitle "title" output.check
  link.shut
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  format.eprint output
  new.block
  note output
  new.sentence
  format.doi output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  link.open
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  link.shut
  editor empty$
    'skip$
    { organization output }
  if$
  new.block
  publisher output
  address output
  format.date.paren "year" output.check
  new.block
  format.eprint output
  note output
  new.sentence
  format.doi output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  collaboration empty$
    {
      format.authors "author" output.check
    }
    {
      format.collaboration output
   }
  if$
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  format.tr.number output.nonnull
  institution output
  address output
  format.date "year" output.check
  new.block
  new.sentence
  format.doi output
  format.eprint output
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.collaboration output
  collaboration empty$
    {
      format.authors "author" output.check
    }
   {}
  if$
  link.open
  format.title "title" output.check
  link.shut
  blank.sep
  format.date "year" output.check
  new.sentence
  format.eprint output
  new.sentence
  note output
  new.sentence
  format.SLACcitation output
  fin.entry
}

FUNCTION {default.type} { misc }
%---------------- Modified (GA) was: short month names, only HEP journals, not Computing

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {cmp} {"Comm. Math. Phys."}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ijmp} {"Int. J. Mod. Phys."}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {jinst} {"Journal of Instrumentation"}

MACRO {mpl} {"Mod. Phys. Lett."}

MACRO {nim} {"Nucl. Instrum. and Methods"}

MACRO {nup} {"Nucl. Phys."}

MACRO {pl} {"Phys. Lett."}

MACRO {pr} {"Phys. Rev."}

MACRO {prl} {"Phys. Rev. Lett."}

MACRO {rmp} {"Rev. Mod. Phys."}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tcs} {"Theoretical Computer Science"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {arXiv}     {"http://arXiv.org/abs"}

MACRO {cogprints} {"http://cogprints.soton.ac.uk/abs"}

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
  "\providecommand{\href}[2]{#2}"
  "\begingroup\raggedright\begin{thebibliography}{" * longest.label  *
  "}%" * write$ newline$
  "\makeatletter" write$ newline$
  "\providecommand{" noop.command "}[0]{\@secondoftwo}%" * * write$ newline$
  "\makeatother" write$ newline$
  "\providecommand{\doi}{\texttt{doi:}\begingroup \urlstyle{tt}\Url}" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}\endgroup" write$ newline$
}

EXECUTE {end.bib}
