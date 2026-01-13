%%%%%  
%%%%% ***   This .bst produces the reference format for ASME conference papers.       									***
%%%%% ***   Follows the examples given on ASME's conference web pages in early 2022.        							***
%%%%% ***   https://www.asme.org/publications-submissions/proceedings/author-guidelines/elements-of-a-paper/references  ***
%%%%% ***   The examples given by ASME do *not* cover all possibilities               									***
%%%%%
%%%%%  This file is version 1.15 dated 2022/12/30
%%%%%
%%%%%       Author: John H. Lienhard V
%%%%%               Department of Mechanical Engineering
%%%%%               Massachusetts Institute of Technology
%%%%%               Cambridge, MA 02139-4307 USA
%%%%%
%%%%%  The source files used are described below. The resultant bst has been edited to improve
%%%%%  conformance to ASME specifications. Two new fields have been introduced for ASME 
%%%%%  conference papers:
%%%%%
%%%%%       venue     = {city of conference},
%%%%%       eventdate = {month, day[s] on which conference was held}, %% called confmonth in version 1.0
%%%%%
%%%%%  This approach leaves the address field as publisher's address,
%%%%%  and it leaves the notes field open for other uses.
%%%%%
%%%%% Added fields: eventdate, urldate, urltype, venue 
%%%%% Added: @online{...} for web publications (and aliased it to @www and @electronic)
%%%%% Added: urlprefix = {}, format.web.urldate, bbl.urldate; urltype field changes "accessed" to something else. 
%%%%% Added: venue and eventdate to @inproceedings
%%%%%
%%%%%
%%%%% Edits in version 1.15, 2022/12/30
%%%%%		Add macro "jhmt" for "ASME J. Heat Mass Transfer"
%%%%%
%%%%% Edits in version 1.14, 2022/09/13
%%%%%		Add code to format.journal.pages to deal with empty pages
%%%%%
%%%%% Edits in version 1.13, 2021/12/02
%%%%%		Switched remaining http:// prefixes to https://
%%%%%		Replace \href{}{} in \eprint by \url
%%%%%
%%%%% Edits in version 1.12, 2021/01/04: 
%%%%% 		Added fields: version={}, format.version, to @book, @inbook, @online, @manual; 
%%%%%					  versiontype = {}, with bbl.version, changes "Version" to other
%%%%%
%%%%% Edits in version 1.11, 2020/04/14: 
%%%%%		correct error in journal eid code.
%%%%%		remove comma between Vol. and No. in article, per ASME style
%%%%%		capitalize "Thesis", per ASME style
%%%%%		insert "." after techreport number, per ASME style
%%%%%		edits to @inbook, @proceedings, @incollection related to chapter and series.
%%%%%		make punctuation after "(ed.)" consistent across entries.
%%%%%		adjust block breaks in @online.
%%%%%		allow for venue and eventdate in @proceedings
%%%%%		add macros for ASME journal titles. add hdl as an equivalent to hndl archive macro.
%%%%%       add numpages functionality for eid: "eid (numpages pages)"
%%%%%		remove "doi" field from @online (since doi is a digital object identifier, not a web page).
%%%%%		add "urldate" to eprint format, for optional use.
%%%%%		warn in @online not to use both eprint and url, and warn if neither is given.
%%%%%       remove series and add volume to @inproceedings.
%%%%%
%%%%%  Feel free to edit this file to suit your own needs, but please make note of changes in this header.
%%%%%
%%=========================================================
%% LICENSE:
%% This file is a derivative work from the generated file, as envisioned by the LaTeX Project Public License.
%%
%% Copyright (c) 2020 John Lienhard
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
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
%% NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
%% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
%% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
%% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This is file `asmeconf.bst',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% merlin.mbs  (with options: `seq-no,nm-revf,ed-rev,jnrlst,dt-jnl,yr-par,xmth,yrp-col,tit-qq,atit-u,thtit-a,vnum-nr,volp-blk,jdt-pc,jwdpg,pp-last,jwdvol,num-xser,numser,jnm-x,pre-pub,doi,edparc,in-x,pp,ed,abr,ednx,ord,and-xcom,etal-xc,revdata,eprint,url,url-blk,em-it,nfss,')
%% ----------------------------------------
%% ***   This .bst produces the reference format for ASME conference papers.       ***
%%
%% Copyright 1994-2011 Patrick W Daly
%%
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
 % \ProvidesFile{merlin.mbs}[2011/11/18 4.33 (PWD, AO, DPC)]
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
    doi
    edition
    editor
    eid
    eprint
    eventdate
    howpublished
    institution
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
    urldate
    urltype
    venue 
    version
    versiontype  
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
STRINGS { s t}
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
FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}

FUNCTION {date.block}
{
  ":" *
  add.blank
}

FUNCTION {conf.date.block}
{ pages empty$
'skip$
  {
    ":" *
    add.blank
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
FUNCTION {non.stop}
{ duplicate$
   "}" * add.period$
   #-1 #1 substring$ "." =
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
    { "\textit{" swap$ * "}" * }
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
{ "eds." }

FUNCTION {bbl.editor}
{ "ed." }

FUNCTION {bbl.edby}
{ "edited by" }

FUNCTION {bbl.edition}
{ "ed." }

FUNCTION {bbl.volume}
{ "Vol." }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "No." }

FUNCTION {bbl.nr}
{ "No." }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.paperno}
{ "" }

FUNCTION {bbl.pages}
{ "pp." }

FUNCTION {bbl.page}
{ "p." }

FUNCTION {bbl.eidpp}
{ "pages" }

FUNCTION {bbl.chapter}
{ "Chap." }

FUNCTION {bbl.techrep}
{ "Technical Report" }

FUNCTION {bbl.mthesis}
{ "Master's Thesis" }

FUNCTION {bbl.phdthesis}
{ "Ph.D. Thesis" }

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

FUNCTION {bbl.urldate}
 { "Accessed" }
 
FUNCTION {bbl.version}
 { "Version" }

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

MACRO {arxiv} {"https://arxiv.org/abs/"}

MACRO {googlebooks} {"https://books.google.com/books?id="}

MACRO {hdl}  {"https://hdl.handle.net/"}
MACRO {hndl} {"https://hdl.handle.net/"}

MACRO {jstor} {"https://www.jstor.org/stable/"}

MACRO {oclc} {"https://www.worldcat.org/oclc/"}

MACRO {pubmed} {"https://www.ncbi.nlm.nih.gov/pubmed/"}


MACRO {amr} {"Appl. Mech. Rev."}

MACRO {lds} {"ASME Letters Dynamic Systems"}

MACRO {jru} {"ASME J. Risk Uncertainty"}

MACRO {jsbc} {"ASME J. Sustainable Bldg. and Cities"}

MACRO {jam} {"ASME J. Appl. Mech."}

MACRO {jbe} {"ASME J. Biomed. Eng."}

MACRO {jcnd} {"ASME J. Comput. Nonlin. Dyn."}

MACRO {jcise} {"ASME J. Comput. Inf. Sci. Eng."}

MACRO {jds} {"J. Dyn. Syst.-T. ASME"}

MACRO {jep} {"ASME J. Electron. Packag."}

MACRO {jert} {"ASME J. Energy Resour."}

MACRO {jegtp} {"ASME J. Eng. Gas Turbines Power"}

MACRO {jem} {"ASME J. Eng. Mater."}

MACRO {jfe} {"ASME J. Fluids Eng."}

MACRO {jfcst} {"ASME J. Fuel Cell Sci. Tech."}

MACRO {jht} {"ASME J. Heat Transfer"}

MACRO {jhmt} {"ASME J. Heat Mass Transfer"}

MACRO {jmse} {"ASME J. Manuf. Sci. E."}

MACRO {jmd} {"ASME J. Mech. Des."}

MACRO {jmr} {"ASME J. Mech. Robot."}

MACRO {jmdv} {"ASME J. Med. Devices"}

MACRO {jmnm} {"ASME J. Micro Nano-Manuf."}

MACRO {jnem} {"ASME J. Nanotech Eng. Med."}

MACRO {joma} {"ASME J. Offshore Mech. Arct."}

MACRO {jpv} {"ASME J. Press. Vess."}

MACRO {jse} {"ASME J. Sol. Energy"}

MACRO {jtsea} {"ASME J. Therm. Sci. Eng. Appl."}

MACRO {jtb} {"ASME J. Tribol."}

MACRO {jtm} {"ASME J. Turbomach."}

MACRO {jva} {"ASME J. Vib. Acoust."}


MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}
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

FUNCTION {format.web.urldate}
{ urldate empty$
  {""}
  {urldate "urldate" bibinfo.check
  urltype duplicate$ empty$
    { pop$ bbl.urldate }
    'skip$
  if$
  "urltype" bibinfo.check
  swap$ duplicate$ empty$
    { pop$ "t" change.case$ }
    { tie.or.space.prefix * * }
  if$
  ", " *
  }
  if$
}

FUNCTION {format.eprint}
{ eprint duplicate$ empty$
    'skip$
    { "\eprint"
      archive empty$
         { "there's an eprint but no archive in " cite$ * warning$ }
        { "[" * archive * "]" * }
      if$
      "{" * swap$ * "}" *
      format.web.urldate swap$ *
    }
  if$
}

FUNCTION {format.version}
{ version empty$
 {""}
{version "version" bibinfo.check
  versiontype duplicate$ empty$
    { pop$ bbl.version }
    'skip$
  if$
  "versiontype" bibinfo.check
  swap$ duplicate$ empty$
    { pop$ "t" change.case$ }
    { tie.or.space.prefix * * }
  if$
}
if$
}

FUNCTION {format.url}
{
  url
  duplicate$ empty$
    { pop$ "" }
    { "\urlprefix\url{" swap$ * "}" * 
    format.web.urldate swap$ *
    }
  if$
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
      "{vv~}{ll}{, ff}{, jj}"
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
              t "others" =
                {
                  " " * bbl.etal *
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
  format.names
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
      " " *
      get.bbl.editor
   "(" swap$ * ")" *
      *
    }
  if$
}

FUNCTION {format.doi}
{ doi empty$
    { "" }
    {
      new.block
      "\doi{" doi * "}" *
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
          { "t" }
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
  "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
      "\enquote{" swap$ *
      add.period$ "}" *
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
{ "" }

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
    }
  if$
  duplicate$ empty$
    'skip$
    {
      before.all 'output.state :=
    " (" swap$ * ")" *
    }
  if$
}
FUNCTION{format.year}
{ year "year" bibinfo.check duplicate$ empty$
    {  "empty year in " cite$ *
       warning$
    }
    {
  "(" swap$ * ")" *
    }
  if$
}

FUNCTION{format.thesis.year}
{ year "year" bibinfo.check duplicate$ empty$
    {  "empty year in " cite$ *
       warning$
    }
    {
    }
  if$
}

FUNCTION{format.techrep.year}
{ year "year" bibinfo.check duplicate$ empty$
    {  "empty year in " cite$ *
       warning$
    }
    {
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
    { "" }
    { bbl.volume volume tie.or.space.prefix
      "volume" bibinfo.check * *
      series "series" bibinfo.check
      duplicate$ empty$ 'pop$
        { swap$ bbl.of space.word * swap$
          emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.paper.number}
{ number "number" bibinfo.check
  type duplicate$ empty$
    { pop$ bbl.paperno }
    'skip$
  if$
  "type" bibinfo.check
  swap$ duplicate$ empty$
    { pop$ "t" change.case$ }
    { tie.or.space.prefix * * }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { number "number" bibinfo.check }
            { output.state mid.sentence =
                { bbl.number }
                { bbl.number capitalize }
              if$
              number tie.or.space.prefix "number" bibinfo.check * *
              bbl.in space.word *
              series emphasize "series" bibinfo.check *
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
{ pages duplicate$ empty$   
       { "empty pages in " cite$ * warning$ }
       'skip$
     if$
     duplicate$ empty$ 
      {  pop$
          " " *
          format.year *
      }
     { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          " " *
          format.year * ": " *
          swap$
          n.dashify
          pages multi.page.check
            'bbl.pages
            'bbl.page
          if$
          swap$ tie.or.space.prefix
          "pages" bibinfo.check
          * *
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
          " " *
          format.year * ": " *
          swap$
          * 
	      numpages empty$ 'skip$
	        { numpages bbl.eidpp tie.or.space.prefix
	          "numpages" bibinfo.check  * *
	          " (" swap$ * ")" * *
	        }
	      if$
        }
      if$
      }
   if$
}
FUNCTION {format.vol.num.pages}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      bbl.volume swap$ tie.or.space.prefix
      "volume" bibinfo.check
      * *
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      " " bbl.nr * number tie.or.space.prefix pop$ * swap$ *
    }
  if$ *
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
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
      * *
    }
  if$
}

FUNCTION {format.booktitle}
{
  booktitle "booktitle" bibinfo.check
  emphasize
}
FUNCTION {format.in.ed.booktitle}
{ format.booktitle duplicate$ empty$ 'skip$
    {
      editor "editor" format.names.ed duplicate$ empty$ 'pop$
        {
          "" *
          " " *
          get.bbl.editor
          "(" swap$ * "). " *
          * swap$
          * }
      if$
      word.in swap$ *
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
    { pop$ bbl.techrep " " * bbl.nr * }
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
      *
    }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            {
              "editor" bibinfo.check
              " " * bbl.etal
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
      capitalize
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
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    {
      journal
      "journal" bibinfo.check
      emphasize
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
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
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
  new.block
  format.btitle "title" output.check
  format.edition output
  format.version output
  new.block
  crossref missing$
    { format.bvolume output
      new.block
      new.sentence
      format.number.series output
      format.publisher.address output
    }
    {
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  new.block
  howpublished "howpublished" bibinfo.check output
  address "address" bibinfo.check output
  format.date output
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
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
  new.block
  format.btitle "title" output.check
  format.edition output
  format.version output
  new.block
  crossref missing$
    {
      format.number.series output
      format.number.series output
      new.block
      new.sentence
      format.publisher.address output
      new.block
      new.sentence
    }
    {
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
  date.block
  format.chapter.pages "chapter and pages" output.check
  new.block
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.edition output
	  new.block
      format.number.series output
      format.bvolume output
      new.sentence
      format.publisher.address output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  format.date "year" output.check
  conf.date.block
  format.chapter.pages "pages" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
	  volume empty$ 'skip$
	    { bbl.volume volume tie.or.space.prefix
	      "volume" bibinfo.check * * output
	    }
	  if$
      new.sentence
      format.paper.number output
      conf.date.block
      format.pages "pages" output.check
      new.sentence
      venue output
      eventdate output
 	  format.thesis.year "year" output.check
	  new.sentence
      publisher empty$
        { format.organization.address output }
        { organization "organization" bibinfo.check output
          format.publisher.address output
        }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
    }
  if$
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
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
  new.block
  format.btitle "title" output.check
  format.edition output
  format.version output
  new.block
  author empty$
    { organization empty$
        {
          address new.block.checka
          address "address" bibinfo.check output
        }
        'skip$
      if$
    }
    {
      organization address new.block.checkb
      organization "organization" bibinfo.check output
      address "address" bibinfo.check output
    }
  if$
  format.date output
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title
  "title" output.check
  new.block
  bbl.mthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  new.block
  format.thesis.year "year" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished "howpublished" bibinfo.check output
  format.date output
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
  empty.misc.check
}

FUNCTION {online}
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
  new.block
  format.title
  "title" output.check
  new.block
  format.version output
  new.block
  organization "organization" bibinfo.warn output
  address "address" bibinfo.check output  
  format.date "year" output.check
  new.block
  url empty$
     { eprint empty$
         { "missing url and eprint in" cite$ * warning$ }
         { format.eprint output }
       if$
     }
     { "url and eprint" eprint either.or.check     
       format.url "url" bibinfo.warn output
     }
   if$
  new.block
  format.note output
  fin.entry
}

FUNCTION {electronic} { online }

FUNCTION {www} { online }


FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title
  "title" output.check
  new.block
  bbl.phdthesis format.thesis.type output.nonnull
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  new.block
  format.thesis.year "year" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization "organization" bibinfo.check output
    }
    { format.editors output.nonnull 
    }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  new.block
  venue "venue" output.check
  eventdate "eventdate" output.check
  new.block
  editor empty$
    { publisher empty$
        {  format.number.series output }
        {
          new.sentence
          format.number.series output
          format.publisher.address output
        }
      if$
    }
    { publisher empty$
        {
          new.sentence
          format.number.series output
          format.organization.address output }
        {
          new.sentence
          format.number.series output
          organization "organization" bibinfo.check output
          format.publisher.address output
        }
      if$
     }
  if$
  format.date "year" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title
  "title" output.check
  new.block
  format.tr.number output.nonnull
  new.block
  institution "institution" bibinfo.warn output
  address "address" bibinfo.check output
  new.block
  format.techrep.year "year" output.check
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  format.date output
  format.doi output
  new.block
  format.eprint output
  format.url output
  new.block
  format.note "note" output.check
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
  "\begin{thebibliography}{"  longest.label  * "}" *
  write$ newline$
  "\newcommand{\enquote}[1]{``#1''}"
  write$ newline$
  "\providecommand{\url}[1]{\texttt{#1}}"
  write$ newline$
  "\providecommand{\urlprefix}{URL }"
  write$ newline$
  "\expandafter\ifx\csname urlstyle\endcsname\relax"
  write$ newline$
  "  \providecommand{\doi}[1]{DOI \discretionary{}{}{}#1}\else"
  write$ newline$
  "  \providecommand{\doi}{DOI \discretionary{}{}{}\begingroup \urlstyle{rm}\Url}\fi"
  write$ newline$
 "\providecommand{\eprint}[2][]{\urlprefix\url{#1#2}}"
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
%% End of file `asmeconf.bst'.
