%%% This is a version of cj.bst v1.1 2003-08-18, modified
%%% to produce "Author et al." when the author list exceeds ten items.
%%% The modification is a patch found in
%%% https://tex.stackexchange.com/questions/26575/bibtex-how-to-reduce-long-author-lists-to-firstauthor-et-al

%%% Andrea Domenici andrea.domenici@unipi.it

% cj.bst v1.1 2003-08-18
% Antonio Vallecillo (av@lcc.uma.es)
% Revision History:
%     v1.1 - First version (2003-08-18)
%
%======================================================================
% EXAMPLES OF USE and NOTES ON "cj.bst"
%
% The following examples of BibTeX entries can be used for producing 
% references of journal articles, books, chapters, conferences, 
% and technical documents: 
%
% -- journal article
% @ARTICLE{CAN01,
%   author =       {Carlos Canal and Lidia Fuentes and Ernesto Pimentel
%                   and Jos\'e M. Troya and Antonio Vallecillo},
%   title =        {Extending {CORBA} Interfaces with Protocols},
%   journal =      cj,
%   year =         2001,
%   volume =       44,
%   number =       5,
%   pages =        {448--462},
% }
%
% -- book
% @BOOK{Sowa2000,
%   author =       {John F. Sowa},
%   title =        {Knowledge Representation},
%   publisher =    {Brooks/Cole},
%   year =         2000,
%   address =      {Pacific Grove, CA},
% }
%
% -- chapter
% @Incollection{SZY00,
%   author =       {Clemens Szyperski},
%   booktitle =    {Foundations of Component-Based Systems},
%   title =        {Components and the Way Ahead},
%   editor =       {Gary T. Leavens and Murali Sitaraman},
%   publisher =    {Cambridge University Press},
%   year =         2000,
%   address = {Cambrigde, UK},
% }
%
% -- conference paper
% @Inproceedings{cda-wordgraphs:97,
%     author = {M. Crochemore and R. Verin},
%     year = 1997,
%     title = {Direct construction of compact directed acyclic word graphs},
%     booktitle = {Proc. of CPM 97},
%     month = {12-14 August},
%     address = {Cambridge, MA},
%     pages = {192--211},
%     publisher = {Springer-Verlag, Berlin},
% }
%
% -- technical document/standard
% @MANUAL {Z.500,
%     author = {{ITU-T}},
%     organization = {International Telecommunications Union},
%     title = {Framework on formal methods in conformance testing},
%     year = 1997,
%     address = {Geneva, Switzerland},
%     note = {ITU-T Recommendation X.500},
%     number = {ITU-T X.500},
% }
%
% Using the "cj.bst" style they produce, respectively:
%
% \bibitem{CAN01}
% Canal, C., Fuentes, L., Pimentel, E., Troya, J.~M., and 
%   Vallecillo, A. (2001)
%   Extending {CORBA} interfaces with protocols.
% \newblock {\em The Computer Journal}, {\bf  44}, 448--462.
% 
% \bibitem{Sowa2000}
% Sowa, J.~F. (2000) {\em Knowledge Representation}. 
%   Brooks/Cole,  Pacific Grove, CA.
% 
% \bibitem{SZY00}
% Szyperski, C. (2000) Components and the way ahead.
% \newblock In Leavens, G.~T. and Sitaraman, M. (eds.), 
%   {\em Foundations of Component-Based Systems}. 
%   Cambridge University Press,  Cambrigde, UK.
% 
% \bibitem{cda-wordgraphs:97}
% Crochemore, M. and Verin, R. (1997) Direct construction of 
%   compact directed acyclic word graphs.
% \newblock {\em Proc. of CPM 97},  Cambridge, MA,  12-14 August,  
%   pp. 192--211. Springer-Verlag, Berlin.
% 
% \bibitem{Z.500}
% ITU-T X.500 (1997) {\em Framework on formal methods in conformance testing}.
% \newblock International Telecommunications Union.
% \newblock Geneva, Switzerland.
% 
% NOTES: 
% - In the "book", "Incollection", and "Technical Report" items, 
%   the "address" field contains the publisher location.
% - In the "Inproceedings" and "conference" BibTeX items, the "address"
%   field contains the conference location, so the publisher location
%   should be included in the "publisher" field. 
% - In "Inproceedings" and "conference" BibTeX items, the "month" field
%   should also contain the days of the conference, as indicated in the 
%   example above.
% - In the "Manual" BibTeX item, the "number" field should contain the
%   number of the technical document being referenced. This field will
%   be used as main index for the entry in the bibliography produced.
% - A warning is generated if any of the fields shown for these examples 
%   is missing.
% - Some literals are avaliable for the most common journals and 
%   editorials, as indicated by the following list of BibTeX macros 
%======================================================================

% Literals for MONTHS

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

% Literals for JOURNALS

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {cj} {"The Computer Journal"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ist} {"Information and Software Technology"}

MACRO {ieeec} {"IEEE Computer"}

MACRO {ieees} {"IEEE Software"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {jss} {"Journal of Systems and Software"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {spe} {"Software--Practice and Experience"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

% Literals for EDITORIALS

MACRO {ACMP} {"ACM Press"}

MACRO {ADDISON} {"Addison-Wesley"}

MACRO {ADDISON-BOSTON} {"Addison-Wesley, Boston"}

MACRO {CUP} {"Cambridge University Press"}

MACRO {CUP-UK} {"Cambridge University Press, Cambridge, England"}

MACRO {IEEE-CSP} {"IEEE Computer Society Press"}

MACRO {ICP} {"Imperial College Press"}

MACRO {ICP-UK} {"Imperial College Press, UK"}

MACRO {KAP} {"Kluwer Academic Publishers"}

MACRO {MIT} {"MIT Press"}

MACRO {NH} {"North-Holland"}

MACRO {OUP} {"Oxford University Press"}

MACRO {OUP-UK} {"Oxford University Press, UK"}

MACRO {PRENTICE} {"Prentice Hall"}

MACRO {SPRINGER} {"Springer-Verlag"}

MACRO {SPRINGER-BERLIN} {"Springer-Verlag, Berlin"}

MACRO {SPRINGER-HEIDELBERG} {"Springer-Verlag, Heidelberg"}

MACRO {SPRINGER-NY} {"Springer-Verlag, NY"}

% Literals for SERIES

MACRO {LNCS} {"Lecture Notes in Computer Science"}

MACRO {LNAI} {"LNAI"}

MACRO {ENTCS} {"Electronic Notes in Theoretical Computer Science"}

%=================================================================
%% Start of the cj.bst code

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

INTEGERS { output.state before.all mid.sentence after.sentence after.block
           doblank }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=

  #0 'doblank := % put a blank in output.nonnul if not zero
}

STRINGS { s t }

FUNCTION {between}
{ % what to do between output items
   doblank #0 =
   {" " * write$}
   {write$}
   if$
}

% from plain.bst (add periods after title, but also adds 
% commas in other places)
FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
%    { ", " * write$ }
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
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names} % needs a total rewrite using 'and' function
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    {
      s nameptr "{vv }{ll}{, f.}{, jj}"  format.name$ 't :=  % de Geuzaine, C., jr
%     s nameptr "{vv }{ll}{ f.}{, jj}"  format.name$ 't :=  % de Geuzaine C., jr
%     s nameptr "{ff }{vv }{ll}{, jj}"  format.name$ 't :=  % Christophe de Geuzaine, jr
%     s nameptr "{f. }{vv }{ll}{, jj}"  format.name$ 't :=  % C. de Geuzaine, jr
%     s nameptr "{vv }{ll}{, ff}{, jj}" format.name$ 't :=  % de Geuzaine, Christophe, jr
%     s nameptr "{vv }{ll}{, ff}{, jj}" format.name$ 't :=  % de Geuzaine, Christophe, jr
      nameptr #1 >
%    { namesleft #1 >
%        { ", " * t * }
%        { numnames #2 >
{
          nameptr #1
          #1 + =
          numnames #10
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
              numnames #2 >
        { "," * }
        'skip$
          if$
          t "others" =
        { " et al." * } 
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
{
 editor empty$
    { "" }
    {  editor format.names
       editor num.names$ #1 >
       { " (eds.)" * }
       { " (ed.)" * }
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

FUNCTION {format.address}
{ address empty$
    { "" }
    { ", " * address }
    if$
}

FUNCTION {format.note}
{ note empty$
    { "" }
    { new.block 
      note }
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
        {"(" year ")" * * } 
%       { month " " * year * }
        {"(" year ")" * * } 
        if$
    }
    if$
}

FUNCTION {format.month}
{ month empty$
   { "" }
   { ", " * month }
   if$ 
}


FUNCTION {format.btitle}
{ title %emphasize 
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
    { series empty$ 
        { "" } 
%        { ", Vol. " * "{\bf " * volume "} of " * series * }  %% No "vol."
         { ", " * series ", " * "{\bf" * volume "}" * * }
    if$
    "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.chapter}
{ chapter empty$
    { "" }
    { ", chapter" * chapter %tie.or.space.connect 
    }
  if$
}


FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { ", " * series ", " * "{\bf" * number "}" * * }
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
    { output.state mid.sentence =
       { ", " * edition "l" change.case$ " edition" * } 
       { ", " * edition "t" change.case$ " edition" * } 
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
        { ", " * "pp." pages n.dashify tie.or.space.connect }
        { "" pages tie.or.space.connect } 
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume empty$
  {  "empty volume in " cite$ * warning$
     ", {\bf ?}" 
  }
  {  ", {\bf " * volume "}" * field.or.null 
  }
  if$
  number empty$
    'skip$
    'skip$
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
       { ", " * pages n.dashify * } 
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "chapter" }
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
%    { "In " booktitle emphasize *} 
    { booktitle emphasize } 
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

FUNCTION {format.tr.type} 
{  type empty$
    { "Technical Report" }
    'type
  if$
}

FUNCTION {format.tr.number} %% old way
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
        { "In " booktitle * } 
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
  http://format.date "year" output.check 
  format.title "title"  output.check 
  new.block
  crossref missing$
    { journal emphasize "journal" output.check
      format.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  format.note output
  fin.entry
}

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
  http://format.date "year" output.check 
  #1 'doblank := % remove blanks
  format.btitle emphasize "title" output.check
  format.edition output
  crossref missing$
    { format.bvolume output
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      format.address "address" output.check
    }
    { new.block 
      format.book.crossref output.nonnull
    }
  if$
  format.note output 
  fin.entry
  #0 'doblank := % blanks again TDS
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  http://format.date "year" output.check 
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  format.address output
  format.note output 
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
    }
  if$
  http://format.date "year" output.check
  format.btitle "title" output.check
  new.sentence
  format.in.ed.booktitle output
  new.sentence 
  crossref missing$
    { publisher output
      format.address "address" output.check
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
%  format.edition output
   format.note output
   fin.entry
}


FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  http://format.date "year" output.check 
  format.title "title" output.check 
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.address "address" output.check
      format.month "month" output.check  
      format.bvolume output
      format.number.series output
      format.pages "pages" output.check 
      new.sentence
      organization publisher new.sentence.checkb
          organization output
          publisher "publisher" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter output
      format.pages output
    }
  if$
  format.note output
  fin.entry
}

FUNCTION {incollection}
%% same as "inproceedings, but without pages
%% and the address means the publisher location, and therefore goes at the end.
%% Useful for book chapters.
%%
{ output.bibitem
  format.authors "author" output.check
  http://format.date "year" output.check 
  format.title "title" output.check 
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.chapter output
      format.month output  
      format.bvolume output
      format.number.series output
%%    format.chapter.pages "pages" output.check 
      format.pages output
      new.sentence
      organization publisher new.sentence.checkb
      organization output
      publisher "publisher" output.check
      format.address "address" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter output
      format.pages output
    }
  if$
  format.note output
  fin.entry
}

FUNCTION {conference} { incollection }

FUNCTION {manual}
{ output.bibitem
  number empty$
  { % original output
    "empty number in " cite$ * warning$
    author empty$
      { organization empty$
          'skip$
          { organization output.nonnull
              address "address" output.check
          }
          if$
      }
      { format.authors output.nonnull }
    if$
    http://format.date "year" output.check
    format.btitle emphasize "title" output.check
    format.edition output
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
        new.block
        address "address" output.check
      }
    if$
    format.note output
  }
  { % if number is not empty
  number output
  http://format.date "year" output.check
  format.btitle emphasize "title" output.check
  format.edition output
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
      new.block
      address "address" output.check
    }
  if$
  }
  if$
  fin.entry
}


FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  http://format.date "year" output.check
  format.title "title" output.check
  new.block
  "Master's thesis." format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.note output
  fin.entry
}

FUNCTION {masterthesis} { mastersthesis }

FUNCTION {misc}
{ output.bibitem
  format.authors output
  http://format.date output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  http://format.date "year" output.check
  format.btitle "title" output.check
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { format.editors "editor" output.check
      organization output 
    }
    { format.editors output.nonnull }
  if$
  http://format.date "year" output.check
  format.btitle emphasize "title" output.check
  format.address "address" output.check
  format.month "month" output.check  
  format.bvolume output
  format.number.series output
  new.sentence
  organization publisher new.sentence.checkb
  organization output
  publisher "publisher" output.check
  format.note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  author empty$
  { number "number" output.check
    http://format.date "year" output.check
    format.title "title" output.check
    add.period$
    format.tr.type output
  }
  { format.authors "author" output.check
    http://format.date "year" output.check
    format.title "title" output.check
    add.period$
    format.tr.number "number" output.check %output.nonnull
%   format.tr.type output
  }
  if$
  add.period$
  institution "institution" output.check
  format.address "address" output.check
  format.note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  http://format.date "year" output.check
  format.title "title" output.check
  new.block
  format.note "note" output.check
  fin.entry
}

FUNCTION {default.type} { misc }



READ

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{99}" 
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

