% BibTeX bibliography style `newuser'
	% UNabbreviated style with urls, better handling of series
	% hacked from standard style `abbrv' version 0.99a
	% by David Eppstein, Univ. of California, Irvine,
	% http://www.ics.uci.edu/~eppstein/, eppstein@ics.uci.edu, 6 Nov 1996

%----------------------------------------------------------------------
%  Hacked further by Jeff Erickson <jeffe@uiuc.edu> as follows:
%
%  1. Sort names by LastvonFMiddle, not vonLastFirstMiddle
%     (eg: "M. de Berg" < "M. Bern" = "Marshall Bern")
%     HOWEVER, this is not a universal rule, as standards vary  
%     between countries and languages.  To sort by vonLast, put the
%     entire last name in braces in the BibTeX file.  For example:
%     “Mark de Berg” is correctly sorted just before Bern, but
%     “Vin {de Silva}” is correctly sorted just before Dehn.
%
%  2. Surround URLs with angle brackets as per MLA guidelines
%
%  3. In inproceedings, incollection, and (unfortunately) book, treat
%     "volume" as a synonym for "number", to accommodate geom.bib
%
%  4. Use "\emph{...}" everywhere instead of "{\em ...}"
%----------------------------------------------------------------------
%  Hacked even more by Jeff Erickson <jeffe@uiuc.edu> (Oct 2001):
%
%  Typeset inproceeding and incollection like article:
%
%	A. Nauthor and A. Nother Author.  This is the title of the
%	paper, which is repeated many times in the paper itself.
%	\emph{Proc. 43rd Annu. Sympos. Comput. Gardening}, 13--666,
%	2013.  Lecture Notes Comput. Jihad 9102, Taleban Publishers,
%	Jalalabad, Afghanistan.  <http://www.koran.af/gardening>.
%
%  Ignore months in articles and proceedings.
%----------------------------------------------------------------------
%  Dec 2010: Added arxiv field for arXiv IDs; automatically adds link
%  to corresponding page at arxiv.org.  The url field is ignored if the
%  arxiv field is nonempty (reverted Jan 2014).  Removed (unused)
%  eprint field.  Cite unpublished arxiv preprints as @misc, with
%  howpublished = "Preprint".
%
%  Need to add eprint, archivePrefix, and primaryClass fields, per the
%  standard described in http://arxiv.org/hypertex/bibstyles, but with
%  support for hyperlinking to arxiv.org.
%
%    archivePrefix = "arXiv",
%    eprint        = "0707.3168",
%    primaryClass  = "hep-th",
%----------------------------------------------------------------------
%  Jun 2011: Modified “newabuser” to “newuser”: Don’t abbreviate names.
%----------------------------------------------------------------------
%  Feb 2012: Accommodate both number and volume for multi-volume works
%  that are part of a longer series (volume = position within work;
%  number = position within series).
%----------------------------------------------------------------------
%  Jan 2014: Support both raw URLs and arXiv IDs.
%  Don’t put arXiv URLs into the URL field.
%----------------------------------------------------------------------
ENTRY
  { address
    arxiv
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
    url
    volume
    year
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
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

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
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
    { "\emph{" swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { numnames #2 >
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

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ ", editors" * }
	{ ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

%
%  New <jge>: "arxiv" field contains the raw ArXiv identifier, used both
%  as text and as suffix for hypertext URL.
%
FUNCTION {format.arxiv}
{ arxiv empty$
    { "" }
    { new.block "arXiv:\href{http://arxiv.org/abs/" arxiv * "}{" * arxiv * "}" *}
  if$
}

%
%  New -- DE
%  Surround with angle brackets as per MLA style guidelines. <jge>
%
FUNCTION {format.url}
{ url empty$
    { "" }
    { new.block "\burl{" url *  "}" * }
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
	{ month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

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

% change "volume" to "vol." and ignore series -- DE
% FUNCTION {format.bvolume}
% { volume empty$
%     { "" }
%     { "volume" volume tie.or.space.connect
%       series empty$
% 	'skip$
% 	{ " of " * series emphasize * }
%       if$
%       "volume and number" number either.or.check
%    }
%   if$
% }
FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "vol." volume tie.or.space.connect }
  if$
}

% Rearrange to be "Series #" instead of "number # in Series", ignore vol. -- DE
% FUNCTION {format.number.series}
% { volume empty$
%     { number empty$
% 	{ series field.or.null }
% 	{ output.state mid.sentence =
% 	    { "number" }
% 	    { "Number" }
% 	  if$
% 	  number tie.or.space.connect
% 	  series empty$
% 	    { "there's a number but no series in " cite$ * warning$ }
% 	    { " in " * series * }
% 	  if$
% 	}
%       if$
%     }
%     { "" }
%   if$
% }
FUNCTION {format.number.series}
{ number empty$
      { series field.or.null }
      { series empty$
	  { "no." number tie.or.space.connect }
	  { series number tie.or.space.connect }
	if$
      }
    if$
}

%
% Treat "volume" and "number" synonymously to accomodate geombib's bugs.
% (It should only do this if series is present!)
% Warn if both are present. <jge>
%
FUNCTION {format.volnum.series}
{ number empty$
    { volume empty$
        { series field.or.null }
        { "Missing number; using volume instead in " cite$ * warning$ 
	  series empty$
	    { "vol." volume tie.or.space.connect }
	    { series volume tie.or.space.connect }
 	  if$
        }
      if$
    }
    { volume empty$
        'skip$
        { "Using number and ignoring volume in " cite$ * warning$ }
      if$
      series empty$
        { "no." number tie.or.space.connect }
        { series number tie.or.space.connect }
      if$
    }
    if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " edition" * }
	{ edition "t" change.case$ " edition" * }
      if$
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

% abbreviate pages -- DE
%FUNCTION {format.pages}
%{ pages empty$
%    { "" }
%    { pages multi.page.check
%	{ "pages" pages n.dashify tie.or.space.connect }
%	{ "page" pages tie.or.space.connect }
%      if$
%    }
%  if$
%}
FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pp." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {short.format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ pages n.dashify }
	{ "p." pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ short.format.pages }
	{ ":" * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'short.format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * short.format.pages * }
      if$
    }
  if$
}

% Flush editors and "In" -- DE
%
% FUNCTION {format.in.ed.booktitle}
% { booktitle empty$
%     { "" }
%     { editor empty$
% 	{ "In " booktitle emphasize * }
% 	{ "In " format.editors * ", " * booktitle emphasize * }
%       if$
%     }
%   if$
% }
%
FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { booktitle emphasize }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

% abbreviate tech. rep. -- DE
FUNCTION {format.tr.number}
{ type empty$
%    { "Technical Report" }
    { "Tech. Rep." }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}


FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In \emph{" journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
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
    { "Volume" volume tie.or.space.connect
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
	    { "\emph{" * series * "\/}" * }
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
	    { "In \emph{" booktitle * "\/}" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

% output volume and pages similar to incollection, but w/o the "vol." -- DE
% 
% FUNCTION {article}
% { output.bibitem
%   format.authors "author" output.check
%   new.block
%   format.title "title" output.check
%   new.block
%   crossref missing$
%     { journal emphasize "journal" output.check
%       format.vol.num.pages output
%       format.date "year" output.check
%     }
%     { format.article.crossref output.nonnull
%       format.pages outpu
%     }
%   if$
%   new.block
%   note output
%   fin.entry
% }
%
FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { journal emphasize format.vol.num.pages tie.or.space.connect output
      publisher empty$
	'skip$
	{ new.sentence
          publisher "publisher" output.check }
      if$
      year "year" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.url output
  new.block
  format.arxiv output
  new.block
  note output
  fin.entry
}

% Make volume a synonym for number for geom.bib (grumble)
% Put edition immediately after title!		 <jge>
%
% FUNCTION {book}
% { output.bibitem
%   author empty$
%     { format.editors "author and editor" output.check }
%     { format.authors output.nonnull
%       crossref missing$
% 	{ "author and editor" editor either.or.check }
% 	'skip$
%       if$
%     }
%   if$
%   new.block
%   format.btitle "title" output.check
%   crossref missing$
%     { format.bvolume output
%       new.block
%       format.number.series output
%       new.sentence
%       publisher "publisher" output.check
%       address output
%     }
%     { new.block
%       format.book.crossref output.nonnull
%     }
%   if$
%   format.edition output
%   format.date "year" output.check
%   format.url output
%   new.block
%   note output
%   fin.entry
% }

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  format.edition output
  crossref missing$
    { 
      new.block
      format.volnum.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  year "year" output.check
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

% Make same as incollection -- DE
% FUNCTION {inbook}
% { output.bibitem
%   author empty$
%     { format.editors "author and editor" output.check }
%     { format.authors output.nonnull
%       crossref missing$
% 	{ "author and editor" editor either.or.check }
% 	'skip$
%       if$
%     }
%   if$
%   new.block
%   format.btitle "title" output.check
%   crossref missing$
%     { format.bvolume output
%       format.chapter.pages "chapter and pages" output.check
%       new.block
%       format.number.series output
%       new.sentence
%       publisher "publisher" output.check
%       address output
%     }
%     { format.chapter.pages "chapter and pages" output.check
%       new.block
%       format.book.crossref output.nonnull
%     }
%   if$
%   format.edition output
%   format.date "year" output.check
%   format.url output
%   new.block
%   note output
%   fin.entry
% }

% move format.edition from after address to after title.
% move format.number.series from after bvolume to after publisher.
% allow empty publisher.
% flush address. -- DE
%
% For geombib, treat "volume" as synonymous with "number".  (Sigh.)
% Move format.volnum.series back before publisher.  <jge>
% 
% FUNCTION {incollection}
% { output.bibitem
%   format.authors "author" output.check
%   new.block
%   format.title "title" output.check
%   new.block
%   crossref missing$
%     { format.in.ed.booktitle "booktitle" output.check
%       format.bvolume output
%       format.number.series output
%       format.chapter.pages output
%       new.sentence
%       publisher "publisher" output.check
%       address output
%       format.edition output
%       format.date "year" output.check
%     }
%     { format.incoll.inproc.crossref output.nonnull
%       format.chapter.pages output
%     }
%   if$
%   format.url output
%   new.block
%   note output
%   fin.entry
% }
%
FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { series empty$
      { format.in.ed.booktitle "booktitle" output.check
        format.edition output
        format.bvolume output
        format.chapter.pages output
        year "year" output.check
        new.sentence
        publisher output	   % "publisher" output.check
      }
      { format.in.ed.booktitle "booktitle" output.check
        format.edition output
        format.chapter.pages output
        year "year" output.check
        new.sentence
        format.volnum.series output
        publisher output	   % "publisher" output.check
      }
    if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}
FUNCTION {inbook} {incollection}

% make inproceedings same as incollection
% (flush address meaning conf.loc -- I think it should always mean publisher's
% address, which in this abbreviated style should be omitted entirely.) -- DE
%
%
% FUNCTION {inproceedings}
% { output.bibitem
%   format.authors "author" output.check
%   new.block
%   format.title "title" output.check
%   new.block
%   crossref missing$
%     { format.in.ed.booktitle "booktitle" output.check
%       format.bvolume output
%       format.number.series output
%       format.pages output
%       address empty$
% 	{ organization publisher new.sentence.checkb
% 	  organization output
% 	  publisher output
% 	  format.date "year" output.check
% 	}
% 	{ address output.nonnull
% 	  format.date "year" output.check
% 	  new.sentence
% 	  organization output
% 	  publisher output
% 	}
%       if$
%     }
%     { format.incoll.inproc.crossref output.nonnull
%       format.pages output
%     }
%   if$
%   format.url output
%   new.block
%   note output
%   fin.entry
% }

FUNCTION {inproceedings} { incollection }

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
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
  new.block
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
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
  empty.misc.check
}


% Put periods in "Ph.D." -- DE
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "Ph.D. thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      year "year" output.check
    }
    { address output.nonnull
      year "year" output.check
      new.sentence
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

% Flush institution address (and add url) -- DE
%
% FUNCTION {techreport}
% { output.bibitem
%   format.authors "author" output.check
%   new.block
%   format.title "title" output.check
%   new.block
%   format.tr.number output.nonnull
%   institution "institution" output.check
%   address output
%   format.date "year" output.check
%   new.block
%   note output
%   fin.entry
% }
%
FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  format.date "year" output.check
  new.block
  format.url output
  new.block
  format.arxiv output
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.url output
  new.block
  format.arxiv output
  note "note" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Jan."}
MACRO {feb} {"Feb."}
MACRO {mar} {"Mar."}
MACRO {apr} {"Apr."}
MACRO {may} {"May"}
MACRO {jun} {"June"}
MACRO {jul} {"July"}
MACRO {aug} {"Aug."}
MACRO {sep} {"Sept."}
MACRO {oct} {"Oct."}
MACRO {nov} {"Nov."}
MACRO {dec} {"Dec."}

MACRO {acmcs} {"ACM Comput. Surv."}
MACRO {acta} {"Acta Inf."}
MACRO {cacm} {"Commun. ACM"}
MACRO {ibmjrd} {"IBM J. Res. Dev."}
MACRO {ibmsj} {"IBM Syst.~J."}
MACRO {ieeese} {"IEEE Trans. Softw. Eng."}
MACRO {ieeetc} {"IEEE Trans. Comput."}
MACRO {ieeetcad} {"IEEE Trans. Comput.-Aided Design Integrated Circuits"}
MACRO {ipl} {"Inf. Process. Lett."}
MACRO {jacm} {"J.~ACM"}
MACRO {jcss} {"J.~Comput. Syst. Sci."}
MACRO {scp} {"Sci. Comput. Programming"}
MACRO {sicomp} {"SIAM J. Comput."}
MACRO {tocs} {"ACM Trans. Comput. Syst."}
MACRO {tods} {"ACM Trans. Database Syst."}
MACRO {tog} {"ACM Trans. Gr."}
MACRO {toms} {"ACM Trans. Math. Softw."}
MACRO {toois} {"ACM Trans. Office Inf. Syst."}
MACRO {toplas} {"ACM Trans. Prog. Lang. Syst."}
MACRO {tcs} {"Theoretical Comput. Sci."}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

% Sort by Last von First Jr., not von Last First Jr. <jge>
% (vlf is American sorting rules; lvf is European)
FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{ll{ }}{vv{ }}{ff{ }}{jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et al" * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
	{ key empty$
	    { "to sort, need author, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
	{ key empty$
	    { "to sort, need editor, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.organization.sort
	{ type$ "manual" =
	    'author.organization.sort
	    'author.sort
	  if$
	}
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

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
  "\def\burl#1{$\langle$\url{#1}$\rangle$}" write$ newline$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
