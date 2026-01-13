
%%  -------------------------------------------------------------------
%%   BibTeX style file for JPSJ citation style for use with jpsj*.cls
%%   Ver 1.0, February 2009
%%                                                      by mkuwa (IPAP)
%%
%%   2008.9.5  beta-version 1.0
%%   2008.11.6 add MACRO for journal abbreviation
%%   2009.2.2  version 1.0 release
%%
%%   Special thanks to:
%%   Y. Otsuka (RIKEN), Morimichi (IMR, Tohoku Univ), KxY (IMS)
%%   T. Ohtsuki (Sophia Univ), T. Dazai (IPAP)
%%
%%   SUPPORT:
%%     Institute of Pure and Applied Physics
%%     online-support@ipap.jp
%%  -------------------------------------------------------------------


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

% add by mkuwa
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
          "\bibinfo{" swap$ * "}{" * swap$ * "}" *
        }
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

FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}
FUNCTION {add.colon}
{  ": " * before.all 'output.state :=
}
FUNCTION {add.comma}
{  ", " * before.all 'output.state :=
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
    { "{\em " swap$ * "}" * }
  if$
}

% mod by mkuwa
FUNCTION {bold}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bfseries " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
%    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
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
	{ " (eds)" * }
	{ " (ed)" * }
%	{ ", editors" * }
%	{ ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.editedby}
{ editor empty$
    { "" }
    { "ed. " editor format.names *}
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title }
%    { title "t" change.case$ }
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

% add by mkuwa
FUNCTION {format.year.brace}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	{ "(" year * ")" *}
	{ "(" year * ")" *}
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

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "Vol." volume tie.or.space.connect
%    { "volume" volume tie.or.space.connect
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
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
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
%   mod by mkuwa
    { output.state mid.sentence =
	{ add.blank edition "l" change.case$ " ed." * }
	{ add.blank edition "t" change.case$ " ed." * }
%	{ edition "l" change.case$ " edition" * }
%	{ edition "t" change.case$ " edition" * }
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

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pp." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }
%	{ "pages" pages n.dashify tie.or.space.connect }
%	{ "page" pages tie.or.space.connect }
      if$
    }
  if$
}

% add by mkuwa
FUNCTION {first.page}
{ 't :=
  ""
    {  t empty$ not t #1 #1 substring$ "-" = not and }
    { t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
  while$
}

% add by mkuwa
FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          " " *
          swap$
          first.page
%          "pages" bibinfo.check
          *
        }
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
	{ pop$ format.pages }
        { ":" * pages n.dashify * }
      if$
    }
  if$
}

% mod by mkuwa
FUNCTION {format.vol.year.pages}
{ volume bold field.or.null
add.comma
 pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
        {format.journal.pages}
%        { " " * pages n.dashify * }
      if$
    }
  if$
  year empty$
    'skip$
    { " (" year * ")" * *
      volume empty$
	{ "there's a year but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
 }

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "Chap." }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
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
    { editor empty$
	{ booktitle }
%	{ "In " booktitle emphasize * }
	{ "In " format.editors * ", " * booktitle emphasize * }
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

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
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
	{ "In {\em " journal * "\/}" * }
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
	    { "{\em " * series * "\/}" * }
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
	    { "In {\em " booktitle * "\/}" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}




FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
   add.comma
%  new.block
%% mod by kuwa 2008.8.15
%  format.title "title" output.check
%  new.block
  crossref missing$
    { 
      journal "journal" output.check            % mod by mkuwa
%      journal emphasize "journal" output.check
      add.blank
      format.vol.year.pages output
%      format.vol.num.pages output
%      format.date "year" output.check          % mod by mkuwa
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.btitle "title" output.check
      format.editedby "author and editor" output.check
    }
    { format.authors output.nonnull
      editor empty$
        { add.colon
          format.btitle "title" output.check
        }
        { add.colon "in" *
          format.btitle "title" output.check
          format.editedby "author and editor" output.check
        }
      if$
%      crossref missing$
%    { "author and editor" editor either.or.check }
%    'skip$
%      if$
    }
  if$
  add.blank  "(" *
  crossref missing$
    { 
%      format.bvolume output
%      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check ")" *
  format.edition output
  format.bvolume output
  format.number.series output
  format.chapter.pages output
  new.block
  note output
  fin.entry
}



%FUNCTION {book}
%{ output.bibitem
%  author empty$
%    { format.editors "author and editor" output.check }
%    { format.authors output.nonnull
%      crossref missing$
%	{ "author and editor" editor either.or.check }
%	'skip$
%      if$
%    }
%  if$
%  add.colon
%%  new.block
%  format.btitle "title" output.check
%  add.blank  "(" *
%  crossref missing$
%    { 
%%      format.bvolume output
%%      new.block
%      format.number.series output
%      new.sentence
%      publisher "publisher" output.check
%      address output
%    }
%    { new.block
%      format.book.crossref output.nonnull
%    }
%  if$
%  format.date "year" output.check ")" *
%  format.edition output
%  format.bvolume output
%  format.number.series output
%  format.chapter.pages output
%  new.block
%  note output
%  fin.entry
%}



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
  note output
  fin.entry
}

FUNCTION {inbook} {book}

%FUNCTION {inbook}
%{ output.bibitem
%  author empty$
%    { format.editors "author and editor" output.check }
%    { format.authors output.nonnull
%      crossref missing$
%	{ "author and editor" editor either.or.check }
%	'skip$
%      if$
%    }
%  if$
%  new.block
%  format.btitle "title" output.check
%  crossref missing$
%    { format.bvolume output
%      format.chapter.pages "chapter and pages" output.check
%      new.block
%      format.number.series output
%      new.sentence
%      publisher "publisher" output.check
%      address output
%    }
%    { format.chapter.pages "chapter and pages" output.check
%      new.block
%      format.book.crossref output.nonnull
%    }
%  if$
%  format.edition output
%  format.date "year" output.check
%  new.block
%  note output
%  fin.entry
%}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
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
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  add.colon
%  format.title "title" output.check
%  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
	  format.date "year" output.check
      format.pages output
%      address empty$
%	  { organization publisher new.sentence.checkb
%	    organization output
%	    publisher output
%	    format.date "year" output.check
%	  }
%	  { address output.nonnull
%	    format.date "year" output.check
%	    new.sentence
%	    organization output
%	    publisher output
%	  }
%      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings} { inproceedings }
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
  note output
  fin.entry
}


FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  add.colon
%  format.btitle "title" output.check
%  new.block
  "Master's Thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  add.blank
  format.year.brace "year" output.check
%  format.date "year" output.check
  new.block
  note output
  fin.entry
}


%FUNCTION {mastersthesis}
%{ output.bibitem
%  format.authors "author" output.check
%  new.block
%  format.title "title" output.check
%  new.block
%  "Master's thesis" format.thesis.type output.nonnull
%  school "school" output.check
%  address output
%  format.date "year" output.check
%  new.block
%  note output
%  fin.entry
%}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  add.colon
%  format.btitle "title" output.check
%  new.block
  "Dr. Thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  add.blank
  format.year.brace "year" output.check
%  format.date "year" output.check
  new.block
  note output
  fin.entry
}


%FUNCTION {proceedings}
%{ output.bibitem
%  editor empty$
%    { organization output }
%    { format.editors output.nonnull }
%  if$
%  new.block
%  format.btitle "title" output.check
%  format.bvolume output
%  format.number.series output
%  address empty$
%    { editor empty$
%	{ publisher new.sentence.checka }
%	{ organization publisher new.sentence.checkb
%	  organization output
%	}
%      if$
%      publisher output
%      format.date "year" output.check
%    }
%    { address output.nonnull
%      format.date "year" output.check
%      new.sentence
%      editor empty$
%	'skip$
%	{ organization output }
%      if$
%      publisher output
%    }
%  if$
%  new.block
%  note output
%  fin.entry
%}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  add.colon
  format.title "title" output.check
  add.blank
%  new.block
%  format.tr.number output.nonnull
%  institution "institution" output.check
%  address output
  format.year.brace "year" output.check
%  format.date "year" output.check
%  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  add.colon
%  new.block
%  format.title "title" output.check
%  add.blank
%  new.block
  note "note" output.check
  add.blank
  format.year.brace "year" output.check
%  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

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

%MACRO {acmcs} {"ACM Computing Surveys"}

%MACRO {acta} {"Acta Informatica"}

%MACRO {cacm} {"Communications of the ACM"}

%MACRO {ibmjrd} {"IBM Journal of Research and Development"}

%MACRO {ibmsj} {"IBM Systems Journal"}

%MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

%MACRO {ieeetc} {"IEEE Transactions on Computers"}

%MACRO {ieeetcad} {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

%MACRO {ipl} {"Information Processing Letters"}

%MACRO {jacm} {"Journal of the ACM"}

%MACRO {jcss} {"Journal of Computer and System Sciences"}

%MACRO {scp} {"Science of Computer Programming"}

%MACRO {sicomp} {"SIAM Journal on Computing"}

%MACRO {tocs} {"ACM Transactions on Computer Systems"}

%MACRO {tods} {"ACM Transactions on Database Systems"}

%MACRO {tog} {"ACM Transactions on Graphics"}

%MACRO {toms} {"ACM Transactions on Mathematical Software"}

%MACRO {toois} {"ACM Transactions on Office Information Systems"}

%MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

%MACRO {tcs} {"Theoretical Computer Science"}


%add aacros
MACRO {apex}{"Appl. Phys. Express"}
MACRO {jjap}{"Jpn. J. Appl. Phys."}
MACRO {or}{"Opt. Rev."}


%
MACRO {aa}{"Astron. \& Astrophys."}

MACRO {aasup}{"Astron. \& Astrophys. Suppl. Ser."}

MACRO {aj} {"Astron. J."}

MACRO {aph} {"Acta Phys."}

MACRO {advp} {"Adv. Phys."}

MACRO {ajp} {"Amer. J. Phys."}

MACRO {ajm} {"Amer. J. Math."}

MACRO {amsci} {"Amer. Sci."}

MACRO {anofd} {"Ann. Fluid Dyn."}

MACRO {am} {"Ann. Math."}

MACRO {ap} {"Ann. Phys. (NY)"}

MACRO {adp} {"Ann. Phys. (Leipzig)"}

MACRO {ao} {"Appl. Opt."}

MACRO {apl} {"Appl. Phys. Lett."}

MACRO {app} {"Astroparticle Phys."}

MACRO {apj} {"Astrophys. J."}

MACRO {apjsup} {"Astrophys. J. Suppl."}

MACRO {apss} {"Astrophys. Space Sci."}

MACRO {araa} {"Ann. Rev. Astron. Astrophys."}

MACRO {baas} {"Bull. Amer. Astron. Soc."}

MACRO {baps} {"Bull. Amer. Phys. Soc."}

MACRO {cmp} {"Comm. Math. Phys."}

MACRO {cpam} {"Commun. Pure Appl. Math."}

MACRO {cppcf} {"Comm. Plasma Phys. \& Controlled Fusion"}

MACRO {cpc} {"Comp. Phys. Comm."}

MACRO {cqg} {"Class. Quant. Grav."}

MACRO {cra} {"C. R. Acad. Sci. A"}

MACRO {fed} {"Fusion Eng. \& Design"}

MACRO {ft} {"Fusion Tech."}

MACRO {grg} {"Gen. Relativ. Gravit."}

MACRO {ieeens} {"IEEE Trans. Nucl. Sci."}

MACRO {ieeeps} {"IEEE Trans. Plasma Sci."}

MACRO {ijimw} {"Interntl. J. Infrared \& Millimeter Waves"}

MACRO {ip} {"Infrared Phys."}

MACRO {irp} {"Infrared Phys."}

MACRO {jap} {"J. Appl. Phys."}

MACRO {jasa} {"J. Acoust. Soc. America"}

MACRO {jcp} {"J. Comp. Phys."}

MACRO {jetp} {"Sov. Phys.--JETP"}

MACRO {jfe} {"J. Fusion Energy"}

MACRO {jfm} {"J. Fluid Mech."}

MACRO {jmp} {"J. Math. Phys."}

MACRO {jne} {"J. Nucl. Energy"}

MACRO {jnec} {"J. Nucl. Energy, C: Plasma Phys., Accelerators, Thermonucl. Res."}

MACRO {jnm} {"J. Nucl. Mat."}

MACRO {jpc} {"J. Phys. Chem."}

MACRO {jpp} {"J. Plasma Phys."}

MACRO {jpsj} {"J. Phys. Soc. Jpn"}

MACRO {jsi} {"J. Sci. Instrum."}

MACRO {jvst} {"J. Vac. Sci. \& Tech."}

MACRO {nat} {"Nature"}

MACRO {nature} {"Nature"}

MACRO {nedf} {"Nucl. Eng. \& Design/Fusion"}

MACRO {nf} {"Nucl. Fusion"}

MACRO {nim} {"Nucl. Inst. \& Meth."}

MACRO {nimpr} {"Nucl. Inst. \& Meth. in Phys. Res."}

MACRO {np} {"Nucl. Phys."}

MACRO {npb} {"Nucl. Phys. B"}

MACRO {nt/f} {"Nucl. Tech./Fusion"}

MACRO {npbpc} {"Nucl. Phys. B (Proc. Suppl.)"}

MACRO {inc} {"Nuovo Cimento"}

MACRO {nc} {"Nuovo Cimento"}

MACRO {pf} {"Phys. Fluids"}

MACRO {pfa} {"Phys. Fluids A: Fluid Dyn."}

MACRO {pfb} {"Phys. Fluids B: Plasma Phys."}

MACRO {pl} {"Phys. Lett."}

MACRO {pla} {"Phys. Lett. A"}

MACRO {plb} {"Phys. Lett. B"}

MACRO {prep} {"Phys. Rep."}

MACRO {pnas} {"Proc. Nat. Acad. Sci. USA"}

MACRO {pp} {"Phys. Plasmas"}

MACRO {ppcf} {"Plasma Phys. \& Controlled Fusion"}

MACRO {phitrsl} {"Philos. Trans. Roy. Soc. London"}

MACRO {prl} {"Phys. Rev. Lett."}

MACRO {pr} {"Phys. Rev."}

MACRO {physrev} {"Phys. Rev."}

MACRO {pra} {"Phys. Rev. A"}

MACRO {prb} {"Phys. Rev. B"}

MACRO {prc} {"Phys. Rev. C"}

MACRO {prd} {"Phys. Rev. D"}

MACRO {pre} {"Phys. Rev. E"}

MACRO {ps} {"Phys. Scripta"}

MACRO {procrsl} {"Proc. Roy. Soc. London"}

MACRO {rmp} {"Rev. Mod. Phys."}

MACRO {rsi} {"Rev. Sci. Inst."}

MACRO {science} {"Science"}

MACRO {sciam} {"Sci. Am."}

MACRO {sam} {"Stud. Appl. Math."}

MACRO {sjpp} {"Sov. J. Plasma Phys."}

MACRO {spd} {"Sov. Phys.--Doklady"}

MACRO {sptp} {"Sov. Phys.--Tech. Phys."}

MACRO {spu} {"Sov. Phys.--Uspeki"}

MACRO {st} {"Sky and Telesc."}



MACRO {aisr} {"Adv. Space Res."}

MACRO {ag} {"Ann. Geophys."}

MACRO {anigeo} {"Ann. Geofis."}

MACRO {angl} {"Ann. Glaciol."}

MACRO {andmet} {"Ann. d. Meteor."}

MACRO {andgeo} {"Ann. d. Geophys."}

MACRO {andphy} {"Ann. Phys.-Paris"}

MACRO {afmgb} {"Arch. Meteor. Geophys. Bioklimatol."}

MACRO {atph} {"Atm\'osphera"}

MACRO {aao} {"Atmos. Ocean"}

MACRO {ass}{"Astrophys. Space Sci."}

MACRO {atenv} {"Atmos. Environ."}

MACRO {aujag} {"Aust. J. Agr. Res."}

MACRO {aumet} {"Aust. Meteorol. Mag."}

MACRO {blmet} {"Bound.-Lay. Meteorol."}

MACRO {bams} {"Bull. Amer. Meteorol. Soc."}

MACRO {cch} {"Clim. Change"}

MACRO {cdyn} {"Clim. Dynam."}

MACRO {cbul} {"Climatol. Bull."}

MACRO {cap} {"Contrib. Atmos. Phys."}

MACRO {dsr} {"Deep-Sea Res."}

MACRO {dhz} {"Dtsch. Hydrogr. Z."}

MACRO {dao} {"Dynam. Atmos. Oceans"}

MACRO {eco} {"Ecology"}

MACRO {empl}{"Earth, Moon and Planets"}

MACRO {envres} {"Environ. Res."}

MACRO {envst} {"Environ. Sci. Technol."}

MACRO {ecms} {"Estuarine Coastal Mar. Sci."}

MACRO {expa}{"Exper. Astron."}

MACRO {geoint} {"Geofis. Int."}

MACRO {geopub} {"Geofys. Publ."}

MACRO {geogeo} {"Geol. Geofiz."}

MACRO {gafd} {"Geophys. Astrophys. Fluid Dyn."}

MACRO {gfd} {"Geophys. Fluid Dyn."}

MACRO {geomag} {"Geophys. Mag."}

MACRO {georl} {"Geophys. Res. Lett."}

MACRO {grl} {"Geophys. Res. Lett."}

MACRO {ga} {"Geophysica"}

MACRO {gs} {"Geophysics"}

MACRO {ieeetap} {"IEEE Trans. Antenn. Propag."}

MACRO {ijawp} {"Int. J. Air Water Pollut."}

MACRO {ijc} {"Int. J. Climatol."}

MACRO {ijrs} {"Int. J. Remote Sens."}

MACRO {jam} {"J. Appl. Meteorol."}

MACRO {jaot} {"J. Atmos. Ocean. Technol."}

MACRO {jatp} {"J. Atmos. Terr. Phys."}

MACRO {jce} {"J. Climate"}

MACRO {jcam} {"J. Climate Appl. Meteor."}

MACRO {jcm} {"J. Climate Meteor."}

MACRO {jcy} {"J. Climatol."}

MACRO {jgr} {"J. Geophys. Res."}

MACRO {jga} {"J. Glaciol."}

MACRO {jh} {"J. Hydrol."}

MACRO {jmr} {"J. Mar. Res."}

MACRO {jmrj} {"J. Meteor. Res. Japan"}

MACRO {jm} {"J. Meteor."}

MACRO {jpo} {"J. Phys. Oceanogr."}

MACRO {jra} {"J. Rech. Atmos."}

MACRO {jaes} {"J. Aeronaut. Sci."}

MACRO {japca} {"J. Air Pollut. Control Assoc."}

MACRO {jas} {"J. Atmos. Sci."}

MACRO {jmts} {"J. Mar. Technol. Soc."}

MACRO {jmsj} {"J. Meteorol. Soc. Japan"}

MACRO {josj} {"J. Oceanogr. Soc. Japan"}

MACRO {jwm} {"J. Wea. Mod."}

MACRO {lao} {"Limnol. Oceanogr."}

MACRO {mwl} {"Mar. Wea. Log"}

MACRO {mau} {"Mausam"}

MACRO {meteor} {"``Meteor'' Forschungsergeb."}

MACRO {map} {"Meteorol. Atmos. Phys."}

MACRO {metmag} {"Meteor. Mag."}

MACRO {metmon} {"Meteor. Monogr."}

MACRO {metrun} {"Meteor. Rundsch."}

MACRO {metzeit} {"Meteor. Z."}

MACRO {metgid} {"Meteor. Gidrol."}

MACRO {mwr} {"Mon. Weather Rev."}

MACRO {nwd} {"Natl. Weather Dig."}

MACRO {nzjmfr} {"New Zeal. J. Mar. Freshwater Res."}

MACRO {npg} {"Nonlin. Proc. Geophys."}

MACRO {om} {"Oceanogr. Meteorol."}

MACRO {ocac} {"Oceanol. Acta"}

MACRO {oceanus} {"Oceanus"}

MACRO {paleoc} {"Paleoceanography"}

MACRO {pce} {"Phys. Chem. Earth"}

MACRO {pmg} {"Pap. Meteor. Geophys."}

MACRO {ppom} {"Pap. Phys. Oceanogr. Meteor."}

MACRO {physzeit} {"Phys. Z."}

MACRO {pps} {"Planet. Space Sci."}

MACRO {pss} {"Planet. Space Sci."}

MACRO {pag} {"Pure Appl. Geophys."}

MACRO {qjrms} {"Quart. J. Roy. Meteorol. Soc."}

MACRO {quatres} {"Quat. Res."}

MACRO {rsci} {"Radio Sci."}

MACRO {rse} {"Remote Sens. Environ."}

MACRO {rgeo} {"Rev. Geophys."}

MACRO {rgsp} {"Rev. Geophys. Space Phys."}

MACRO {rdgeo} {"Rev. Geofis."}

MACRO {revmeta} {"Rev. Meteorol."}

MACRO {sgp}{"Surveys in Geophys."}

MACRO {sp} {"Solar Phys."}

MACRO {ssr} {"Space Sci. Rev."}

MACRO {tellus} {"Tellus"}

MACRO {tac} {"Theor. Appl. Climatol."}

MACRO {tagu} {"Trans. Am. Geophys. Union (EOS)"}

MACRO {wrr} {"Water Resour. Res."}

MACRO {weather} {"Weather"}

MACRO {wafc} {"Weather Forecast."}

MACRO {ww} {"Weatherwise"}

MACRO {wmob} {"WMO Bull."}

MACRO {zeitmet} {"Z. Meteorol."}


MACRO {appopt} {"Appl. Opt."}

MACRO {bell} {"Bell Syst. Tech. J."}

MACRO {ell} {"Electron. Lett."}

MACRO {jasp} {"J. Appl. Spectr."}

MACRO {jqe} {"IEEE J. Quantum Electron."}

MACRO {jlwt} {"J. Lightwave Technol."}

MACRO {jmo} {"J. Mod. Opt."}

MACRO {josa} {"J. Opt. Soc. America"}

MACRO {josaa} {"J. Opt. Soc. Amer.~A"}

MACRO {josab} {"J. Opt. Soc. Amer.~B"}

MACRO {jdp} {"J. Phys. (Paris)"}

MACRO {oc} {"Opt. Commun."}

MACRO {ol} {"Opt. Lett."}

MACRO {phtl} {"IEEE Photon. Technol. Lett."}

MACRO {pspie} {"Proc. Soc. Photo-Opt. Instrum. Eng."}

MACRO {sse} {"Solid-State Electron."}

MACRO {sjot} {"Sov. J. Opt. Technol."}

MACRO {sjqe} {"Sov. J. Quantum Electron."}

MACRO {sleb} {"Sov. Phys.--Leb. Inst. Rep."}

MACRO {stph} {"Sov. Phys.--Techn. Phys."}

MACRO {stphl} {"Sov. Techn. Phys. Lett."}

MACRO {vr} {"Vision Res."}

MACRO {zph} {"Z. f. Physik"}

MACRO {zphb} {"Z. f. Physik~B"}

MACRO {zphd} {"Z. f. Physik~D"}

MACRO {CLEO} {"CLEO"}

MACRO {ASSL} {"Adv. Sol.-State Lasers"}

MACRO {OSA}  {"OSA"}


MACRO {acmcs} {"ACM Comput. Surv."}

MACRO {acta} {"Acta Inf."}

MACRO {cacm} {"Commun. ACM"}

MACRO {ibmjrd} {"IBM J. Res. Dev."}

MACRO {ibmsj} {"IBM Syst.~J."}

MACRO {ieeese} {"IEEE Trans. Software Eng."}

MACRO {ieeetc} {"IEEE Trans. Comput."}

MACRO {ieeetcad} {"IEEE Trans. Comput. Aid. Des."}

MACRO {ipl} {"Inf. Process. Lett."}

MACRO {jacm} {"J.~ACM"}

MACRO {jcss} {"J.~Comput. Syst. Sci."}

MACRO {scp} {"Sci. Comput. Program."}

MACRO {sicomp} {"SIAM J. Comput."}

MACRO {tocs} {"ACM Trans. Comput. Syst."}

MACRO {tods} {"ACM Trans. Database Syst."}

MACRO {tog} {"ACM Trans. Graphic."}

MACRO {toms} {"ACM Trans. Math. Software"}

MACRO {toois} {"ACM Trans. Office Inf. Syst."}

MACRO {toplas} {"ACM Trans. Progr. Lang. Syst."}

MACRO {tcs} {"Theor. Comput. Sci."}




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
