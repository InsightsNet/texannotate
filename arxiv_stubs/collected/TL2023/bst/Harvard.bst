%%
%% This is file `bibgen.bst',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% merlin.mbs  (with options: `ay,har,harnm,nm-rvvc,nmlm,m6,x1,dt-beg,yr-com,yrp-per,note-yr,jttl-rm,vnum-sp,volp-com,pp-last,numser,ser-vol,ser-ed,jnm-x,btit-rm,bt-rm,pg-bk,pre-pub,isbn,issn,doi,edparc,in-col,pp,ed,abr,ednx,jabr,varand,and-xcom,xand,revdata,eprint,url,url-blk,bibinfo,nfss ')
%% *** My style file ***
%% Copyright 1994-2011 Patrick W Daly
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
 % \ProvidesFile{merlin.mbs}[2011/01/10 4.31 (PWD, AO, DPC)]
 %   For use with BibTeX version 0.99a or later
 %-------------------------------------------------------------------
 % This bibliography style file is intended for texts in ENGLISH
 % This is an author-year citation style bibliography. As such, it is
 % non-standard LaTeX, and requires a special package file to function properly.
 % Such a package is    natbib.sty   by Patrick W. Daly
 % or:                  harvard.sty  by Peter Williams and Thorsten Schnier
 % (needs natbib v5.3  or  harvard v2.0.3)
 % The form of the bibitem entries is
 %   \harvarditem[Jones et al.]{Jones, Baker, and Smith}{1990}{key}...
 %---------------------------------------------------------------------

ENTRY
  { address
    archive
    author
    booktitle
    chapter
    collaboration
    doi
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
    number
    numpages
    organization
    collab
    pages
    publisher
    school
    series
    title
    type
    commenturl
    url
    volume
    year
    opennote
    bknote
    endnote
    titlecomment
    pubmed
  }
  {}
  { label extra.label sort.label short.list long.label }
INTEGERS { output.state before.all mid.sentence after.sentence after.block }

STRINGS { urlprefix doiprefix eprintprefix pubmedprefix }

FUNCTION {init.web.variables}
{
 "\URLprefix "     'urlprefix :=
 "\DOIprefix"      'doiprefix :=
 "\ArXivprefix  "   'eprintprefix :=
 "\Pubmedprefix "  'pubmedprefix :=
}

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
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "" write$
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
FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

%%FUNCTION {empty.misc.check}
%%{ author empty$ title empty$ howpublished empty$
%%  month empty$ year empty$ note empty$
%%  and and and and and
%%    { "all relevant fields are empty in " cite$ * warning$ }
%%    'skip$
%%  if$
%%}

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
  new.block
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
FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
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
{ "\protect\BIBand{}"}

FUNCTION {bbl.etal}
{ "et al." }

FUNCTION {bbl.editors}
{ "Eds." }

FUNCTION {bbl.editor}
{ "Ed." }

FUNCTION {bbl.edby}
{ "edited by}" }

FUNCTION {bbl.edition}
{ "ed." }

FUNCTION {bbl.volume}
{ "\bibinfo{comment}{vol.}" }

FUNCTION {bbl.bvolume}
{ "\bibinfo{comment}{vol.}" }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "\bibinfo{comment}{no.}" }

FUNCTION {bbl.nr}
{ "no." }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.pages}
{ "pp." }

FUNCTION {bbl.bpages}
{ "" }

FUNCTION {bbl.page}
{ "p." }

FUNCTION {bbl.eidpp}
{ "pages" }

FUNCTION {bbl.chapter}
{ "chap." }

FUNCTION {bbl.btechrep}
{ "\bibinfo{comment}{Tech. Rep.}" }

FUNCTION {bbl.techrep}
{ "" }

FUNCTION {bbl.mthesis}
{ "Master's thesis" }

FUNCTION {bbl.phdthesis}
{ "\bibinfo{comment}{Ph.D. thesis}" }

FUNCTION {bbl.first}
{ "First" }

FUNCTION {bbl.second}
{ "Second" }

FUNCTION {bbl.third}
{ "Third" }

FUNCTION {bbl.fourth}
{ "Fourth" }

FUNCTION {bbl.fifth}
{ "Fifth" }

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

MACRO {acmcs} {"ACM Comput. Surv."}

MACRO {acta} {"Acta Inf."}

MACRO {cacm} {"Commun. ACM"}

MACRO {ibmjrd} {"IBM J. Res. Dev."}

MACRO {ibmsj} {"IBM Syst.~J."}

MACRO {ieeese} {"IEEE Trans. Software Eng."}

MACRO {ieeetc} {"IEEE Trans. Comput."}

MACRO {ieeetcad}
 {"IEEE Trans. Comput. Aid. Des."}

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
          "\bibinfo{" swap$ * "}{" * swap$ * "}" *
        }
      if$
    }
  if$
}

FUNCTION {print.url}
 {url duplicate$ empty$
   { pop$ "" }
   { new.sentence
     urlprefix "\bibinfo{url}{\url{" * swap$  * "}}" *
   }
   if$
 }

FUNCTION {print.doi}
 {doi duplicate$ empty$
   { pop$ "" }
   { new.sentence
     doiprefix "\bibinfo{doi}{\doi{" * swap$  * "}}" *
   }
   if$
 }

FUNCTION {format.eprint}
{ eprint duplicate$ empty$
    'skip$
    { "\eprint"
      archive empty$
        'skip$
        { "[" * archive * "]" * }
      if$
      "{" * swap$ * "}" *
    }
  if$
}
FUNCTION {print.eprint}
 {eprint duplicate$ empty$
   { pop$ "" }
   { new.sentence
     duplicate$ "\href{http://arxiv.org/abs/" swap$ * "}{\tt arXiv:" * swap$ * "}" *
   }
   if$
 }

FUNCTION {print.pubmed}
 {pubmed duplicate$ empty$
   { pop$ "" }
   { new.sentence
     pubmedprefix "\Pubmed{" * swap$  * "}" *
   }
   if$
 }

FUNCTION {format.url}
{
  url
  duplicate$ empty$
    { pop$ "" }
    { "\url{" swap$ * "}" * }
  if$
  "url" bibinfo.check
}

INTEGERS { nameptr namesleft numnames }


STRINGS  { bibinfo}

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
      "{vv~}{ll}{ jj}{ f{}}"
      format.name$
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
              " and " *
              t "others" =
                {
                  " " * bbl.etal *
                }
                { " " * t * }
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
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{ll~}{, jj}{ff.}{-vv}"
      format.name$
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          nameptr #6
          #1 + =
          numnames #1
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            {
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              "," *
              t "others" =
                {
                  *  bbl.etal *
                }
                { " " * t * }
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

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
  "key" bibinfo.check
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
      "," *
      " " *
      get.bbl.editor
   "(" swap$ * ")" *
      *
    }
  if$
}
FUNCTION {format.book.pages}
{ pages "pages" bibinfo.check
  duplicate$ empty$ 'skip$
    { " " * bbl.bpages * }
  if$
}
FUNCTION {format.isbn}
{ isbn "isbn" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      new.block
      "\bibinfo{comment}{ISBN} " swap$ *
    }
  if$
}

FUNCTION {format.issn}
{ issn "issn" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      new.block
      "ISSN " swap$ *
    }
  if$
}

FUNCTION {format.doi}
{ doi empty$
    { "" }
    {
      new.block
      "\bibinfo{doi}{\doi{" doi * "}}" *
    }
  if$
}

FUNCTION {format.opennote}
{
	opennote "opennote" bibinfo.check
	duplicate$ empty$ 'skip$
	{
	new.block
	"" swap$ *
	}
	if$
}

FUNCTION {format.endnote}
{ endnote
 	duplicate$ empty$ 'skip$
	{
	new.block
	"" swap$ *
	}
	if$
	"endnote" bibinfo.check
}

FUNCTION {format.titlecomment}
{ titlecomment
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "titlecomment" bibinfo.check
}

FUNCTION {format.commenturl}
{ commenturl
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "commenturl" bibinfo.check
}

FUNCTION {format.bknote}
{ bknote
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "bknote" bibinfo.check
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
  "" swap$ * "" *
}

FUNCTION {emphtitle}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {format.title}
{ title
  duplicate$ empty$ 'skip$
    { "t" change.case$ }
  if$
  "title" bibinfo.check
}

FUNCTION {format.publisher}
{ publisher
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "publisher" bibinfo.check
}

FUNCTION {format.address}
{ address
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "address" bibinfo.check
}

FUNCTION {format.institution}
{ institution
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "institution" bibinfo.check
}

FUNCTION {format.series}
{ series
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "series" bibinfo.check
}

FUNCTION {format.volume}
{ volume
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "volume" bibinfo.check
}

FUNCTION {format.month}
{ month
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "month" bibinfo.check
}

FUNCTION {format.type}
{ type
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "type" bibinfo.check
}

FUNCTION {format.number}
{ number
  duplicate$ empty$ 'skip$
    { "" write$}
  if$
  "number" bibinfo.check
}

FUNCTION {format.collab}
{ collab
  duplicate$ empty$ 'skip$
    { "" write$}
  if$
  "collab" bibinfo.check
}

FUNCTION {format.organization}
{ organization
  duplicate$ empty$ 'skip$
    { "" write$ }
  if$
  "organization" output.check
}

FUNCTION {format.full.names}
{'s :=
 "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}" format.name$
      't :=
      nameptr #1 >
        {
          nameptr #6
          #1 + =
          numnames #1
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            {
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                   *  bbl.etal  * 
                }
                {
                  " and "
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
}

FUNCTION {author.editor.key.full}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.full.names }
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {author.key.full}
{ author empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {editor.key.full}
{ editor empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { editor format.full.names }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.full
    { type$ "proceedings" =
        'editor.key.full
        'author.key.full
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "" long.label * "(" * write$
  year extra.label * ")]{" * write$
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
{ bbl.in capitalize
  ":" *
  " " * }

FUNCTION {format.date}
{ year "year" bibinfo.check duplicate$ empty$
    {
      "empty year in " cite$ * "; set to ????" * warning$
       pop$ "????"
    }
    'skip$
  if$
  extra.label *
  before.all 'output.state :=
  " (" swap$ * ")" *
  "" swap$ *
}


FUNCTION {format.btitle}
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
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
    { "" }
    { bbl.bvolume volume tie.or.space.prefix
      "volume" bibinfo.check * *
      duplicate$ empty$ 'pop$
        { ", " * swap$ * }
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
            { bbl.number }
            { bbl.number capitalize }
          if$
          number tie.or.space.prefix "number" bibinfo.check * *
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { bbl.in space.word *
              series "series" bibinfo.check *
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
          bbl.bpages swap$
          n.dashify
        }
        {
          bbl.pages swap$
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
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          ": " *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
        }
      if$
    }
  if$
}
FUNCTION {format.journal.eid}
{ eid "eid" bibinfo.check
  duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$ 'skip$
      {
          ", " *
      }
      if$
      swap$ *
      numpages empty$ 'skip$
        { bbl.eidpp numpages tie.or.space.prefix
          "numpages" bibinfo.check * *
          " (" swap$ * ")" * *
        }
      if$
    }
  if$
}
FUNCTION {format.vol.num.pages}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      " (" swap$ * ")" *
    }
  if$ *
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    { "" }
    { type empty$
        { bbl.chapter }
        { type "l" change.case$
          "type" bibinfo.check
        }
      if$
      chapter tie.or.space.prefix
      "chapter" bibinfo.check
      * *
    }
  if$
}

FUNCTION {format.booktitle}
{
  booktitle "booktitle" bibinfo.check
}
FUNCTION {format.in.ed.booktitle}
{ format.booktitle duplicate$ empty$ 'skip$
    {
      format.bvolume duplicate$ empty$ 'pop$
        { ", " swap$ * * }
      if$
      editor "editor" format.names.ed duplicate$ empty$ 'pop$
        {
          "," *
          " " *
          get.bbl.editor
          "(" swap$ * ") " *
          * swap$
          * }
      if$
      word.in swap$ *
    }
  if$
}
FUNCTION {format.thesis.type}
{ type duplicate$ empty$
    'pop$
    { swap$ pop$
      "type" bibinfo.check
      %%"t" change.case$ "type" bibinfo.check
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
  word.in
  " \cite{" * crossref * "}" *
}
FUNCTION {format.book.crossref}
{ volume duplicate$ empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      pop$ word.in
    }
    { bbl.bvolume
      capitalize
      swap$ tie.or.space.prefix "volume" bibinfo.check * * bbl.of space.word *
    }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.incoll.inproc.crossref}
{
  word.in
  " \cite{" * crossref * "}" *
}
FUNCTION {format.org.or.pub}
{ 't :=
  ""
  address empty$ t empty$ and
    'skip$
    {
      t empty$
        { address "address" bibinfo.check *
        }
        { t *
          address empty$
            'skip$
            { ", " * address "address" bibinfo.check * }
          if$
        }
      if$
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
{ "" write$ newline$
  "\bibtype{Article}%" write$
  output.bibitem
  format.authors output
  author format.key output
  format.organization.address output
  format.date output
  format.month output
  date.block
  format.title output
  new.block
  crossref missing$
  {
      journal
     emphtitle "journal" bibinfo.check
      "journal" output.check
      add.blank
      format.vol.num.pages output
 }
 { format.article.crossref output.nonnull
 }
  if$
  eid empty$
    { format.journal.pages }
    { format.journal.eid }
  if$
  format.issn output
  print.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.commenturl output
  format.url output
  format.endnote output
  format.type output
  fin.entry
}

FUNCTION {book}
{ "" write$ newline$
  "\bibtype{Book}%" write$
   output.bibitem
	format.opennote output
   author empty$
    { format.editors "author and editor" output.check
      editor format.key output
      add.blank
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.date "year" output.check
  format.month output
  date.block
  format.btitle "title" output.check
  format.edition "edition" output.check
  format.bknote "bknote" output.check
  format.titlecomment "titlecomment" output.check
  format.series "series" output.check
  format.volume "volume" output.check
  format.number "number" output.check
  format.publisher "publisher" output.check
  format.address "address" output.check
  new.block
  format.isbn output
  format.book.pages output
  format.doi output
  new.block
  format.note empty$
  { }
  { format.note "format" output.check }
  if$
  format.eprint output
  format.url output
  format.endnote output
  format.type output
  fin.entry
}

FUNCTION {booklet}
{ "" write$ newline$
  "\bibtype{Booklet}%" write$
  output.bibitem
  format.authors output
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.title "title" output.check
  new.block
  howpublished "howpublished" bibinfo.check output
  address "address" bibinfo.check output
  format.isbn output
  format.book.pages output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {inbook}
{ "" write$ newline$
  "\bibtype{inbook}%" write$
  output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.date "year" output.check
  format.month output
  date.block
  format.btitle "title" output.check
  crossref missing$
    {
      format.number.series output
      format.publisher.address output
      format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      new.sentence
    }
    {
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  crossref missing$
    { format.isbn output }
    'skip$
  if$
  format.pages "pages" output.check
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {incollection}
{ "" write$ newline$
  "\bibtype{incollection}%" write$
  output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
    }
  if$
  format.date "year" output.check
  format.month output
  format.title "title" output.check
  format.editors "editor" output.check
  format.booktitle "booktitle" output.check
  format.bknote "bknote" output.check
  format.series "series" output.check
  format.volume "volume" output.check
  format.publisher "publisher" output.check
  format.address "address" output.check
  format.pages "pages" output.check
  format.endnote "endnote" output.check
  format.url output
  format.type output
  fin.entry
}

FUNCTION {inproceedings}
{ "" write$ newline$
  "\bibtype{Inproceedings}%" write$
  output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
    }
  if$
  format.date "year" output.check
  format.month output
  format.title "title" output.check
  format.editors "editor" output.check
  format.booktitle "booktitle" output.check
  format.bknote "bknote" output.check
  format.series "series" output.check
  format.volume "volume" output.check
  format.number "number" output.check
  format.publisher "publisher" output.check
  format.address "address" output.check
  format.pages "pages" output.check
  format.endnote "endnote" output.check
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {conference} { inproceedings }
FUNCTION {manual}
{ "" write$ newline$
  "\bibtype{Manual}%" write$
  output.bibitem
  format.authors output
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.btitle "title" output.check
  organization address new.block.checkb
  organization "organization" bibinfo.check output
  address "address" bibinfo.check output
  format.edition output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {mastersthesis}
{ "" write$ newline$
  "\bibtype{Mastersthesis}%" write$
  output.bibitem
  format.authors "author" output.check
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.btitle
  "title" output.check
  new.block
  bbl.mthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {misc}
{ "" write$ newline$
  "\bibtype{Misc}%" write$
  output.bibitem
  format.authors output
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.title output
  new.block
  howpublished "howpublished" bibinfo.check output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {other}
{ "" write$ newline$
  "\bibtype{other}%" write$
  output.bibitem
  format.authors output
  format.date output
  format.month output
  format.title output
  format.publisher output
  format.address output
  howpublished "howpublished" bibinfo.check output
  format.doi output
  format.note output
  format.eprint output
  format.url output
  format.endnote output
  format.type output
  fin.entry
}

FUNCTION {patent}
{ "" write$ newline$
  "\bibtype{patent}%" write$
  output.bibitem
  format.authors output
  author format.key output
  new.block
  format.title output
  new.block
  howpublished "howpublished" bibinfo.check output
  format.date "year" bibinfo.check output
  format.month output
  new.block
  format.url output
  print.doi output
  print.eprint output
  print.pubmed output
  format.note output
  format.type output
  fin.entry
}

FUNCTION {patentapp}
{ "" write$ newline$
  "\bibtype{Patentapp}%" write$
  output.bibitem
  format.authors output
  author format.key output
  new.block
  format.title output
  new.block
  howpublished "howpublished" bibinfo.check output
  format.date "year" output.check
  format.month output
  new.block
  format.url output
  print.doi output
  print.eprint output
  print.pubmed output
  format.note output
  format.type output
  fin.entry
}

FUNCTION {phdthesis}
{ "" write$ newline$
  "\bibtype{Phdthesis}%" write$
  output.bibitem
  format.authors "author" output.check
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.btitle
  "title" output.check
  new.block
  bbl.phdthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {proceedings}
{ "" write$ newline$
  "\bibtype{Proceedings}%" write$
  output.bibitem
  format.editors output
  editor format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.btitle "title" output.check
  format.bvolume output
  new.sentence
  format.number.series output
  publisher empty$
    { format.organization.address output }
    { organization "organization" bibinfo.check output
      format.publisher.address output
    }
  if$
  format.isbn output
  format.issn output
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note output }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {techreport}
{ "" write$ newline$
  "\bibtype{Techreport}%" write$
  output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title
  "title" output.check
  new.sentence
  %format.type output
  %new.block
  format.tr.number output.nonnull
  institution "institution" bibinfo.warn output 
  address "address" bibinfo.check output
  format.date "year" output.check
  format.doi output
  new.sentence
  format.note output
  format.eprint output
  format.url output
  fin.entry
}

FUNCTION {unpublished}
{ "" write$ newline$
  "\bibtype{Unpublished}%" write$
  output.bibitem
  format.authors "author" output.check
  author format.key output
  format.date "year" output.check
  format.month output
  date.block
  format.title "title" output.check
  format.doi output
  new.block
  format.note empty$
  { }
  {format.note "note" output.check }
  if$
  format.eprint output
  format.url output
  format.type output
  fin.entry
}

FUNCTION {default.type} { misc }
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
FUNCTION {format.lab.names}
{ 's :=
  "" 't :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$
      " " * bbl.etal *
    }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            {
              " " * bbl.etal *
            }
            { " and " * s #2 "{vv~}{ll}" format.name$
              * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.label
        'author.key.label
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  ", "
  *
  year duplicate$ empty$
     { pop$ "????" }
     'skip$
  if$
  *
  'label :=
}

FUNCTION {calc.short.label}
{ calc.short.authors short.list
  'label :=
}
FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}"
      format.name$ 't :=
      nameptr #1 >
        {
          nameptr #6
          #1 + =
          numnames #1
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          "   "  *
          namesleft #1 = t "others" = and
            { "zzzzz" 't := }
            'skip$
          if$
          t sortify *
        }
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
FUNCTION {editor.sort}
{ editor empty$
    { key empty$
        { "to sort, need editor or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { editor sort.format.names }
  if$
}
FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.sort
        'author.sort
      if$
    }
  if$
  #1 entry.max$ substring$
  'sort.label :=
  sort.label
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
STRINGS { last.label next.extra }
INTEGERS { last.extra.num last.extra.num.extended last.extra.num.blank number.label }
FUNCTION {initialize.extra.label.stuff}
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
  "a" chr.to.int$ #1 - 'last.extra.num.blank :=
  last.extra.num.blank 'last.extra.num.extended :=
  #0 'number.label :=
}
FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num "z" chr.to.int$ >
       { "a" chr.to.int$ 'last.extra.num :=
         last.extra.num.extended #1 + 'last.extra.num.extended :=
       }
       'skip$
      if$
      last.extra.num.extended last.extra.num.blank >
        { last.extra.num.extended int.to.chr$
          last.extra.num int.to.chr$
          * 'extra.label := }
        { last.extra.num int.to.chr$ 'extra.label := }
      if$
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}
FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
}
EXECUTE {initialize.extra.label.stuff}
ITERATE {forward.pass}
REVERSE {reverse.pass}
FUNCTION {bib.sort.order}
{ %%sort.label
%%  "    "
%%  *
%%  year field.or.null sortify
%%  *
%%  "    "
%%  *
%%  title field.or.null
%%  sort.format.title
%%  *
%%  #1 entry.max$ substring$
%%  'sort.key$ :=
  calc.short.label
}
ITERATE {bib.sort.order}
SORT
FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography*}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\bibtype}[1]{}"
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
  "{\catcode`\|=0\catcode`\#=12\catcode`\@=11\catcode`\\=12" write$ newline$
  "|immediate|write|@auxout{\expandafter\ifx\csname natexlab\endcsname\relax\gdef\natexlab#1{#1}\fi}}"
  write$ newline$
  "\renewcommand{\url}[1]{{\tt #1}}"
  write$ newline$
  "\providecommand{\urlprefix}{URL }"
  write$ newline$
  "\expandafter\ifx\csname urlstyle\endcsname\relax"
  write$ newline$
  "  \providecommand{\doi}[1]{doi:\discretionary{}{}{}#1}\else"
  write$ newline$
  "  \providecommand{\doi}{doi:\discretionary{}{}{}\begingroup \urlstyle{rm}\Url}\fi"
  write$ newline$
  "\providecommand{\bibinfo}[2]{#2}"
  write$ newline$
  "\providecommand{\eprint}[2][]{\url{#2}}"
  write$ newline$

}
EXECUTE {begin.bib}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography*}" write$ newline$
}
EXECUTE {end.bib}
%% End of customized bst file
%%
%% End of file `bibgen.bst'.
