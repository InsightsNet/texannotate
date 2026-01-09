%% This is file `spr-mp-nameyear-cnd.bst'
%%
%% Please submit bugs or your comments to vtex@vtex.lt
%%
%% Sorting entries is done by name and year fields!
%%
%% You are free to use this style file as you see fit, provided 
%% that you do not make changes to the file. 
%% If you DO make changes, you are required to rename this file.
%%
%% It may be distributed under the terms of the LaTeX Project Public
%% License, as described in lppl.txt in the base LaTeX distribution.
%% Either version 1.0 or, at your option, any later version.

% BibTeX programming: Linas Stonys, VTeX, Lithuania, lstonys@vtex.lt 


ENTRY
  { address
    author
    booktitle
    chapter
    doi
    edition
    editor
    howpublished
    institution
    isbn
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
    url
    xbook
    xarticle
    xbooklet
    xconference
    xinproceedings
    xincollection
    xinbook
    xmanual
    xproceedings
    xphdthesis
    xmastersthesis
    xmisc
    xunpublished
    xtechreport
    info
    options
    urldate
    eprint
  }
  {}
  { label extra.label sort.label short.list}

INTEGERS { output.state before.all mid.sentence after.sentence
           after.block after.authors between.elements bother
           Nisbn Nmonth slen set.settings tmp month.printed}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'after.authors :=
  #5 'between.elements :=
}

STRINGS { s t  element}
STRINGS { longest.label last.label list.string default.list}
STRINGS { v l f j b temp.str}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { " " * write$ newline$}
    { output.state after.block =
        { add.period$ write$
          newline$
         % "\newblock " write$
        }
        {
          output.state after.authors =
          { ": " * write$
            newline$
          }
          { output.state between.elements =
              { ", " * write$ newline$}
              { output.state before.all =
                   'write$
                  { add.period$ " " * write$ newline$}
                  	
                  	
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

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}
FUNCTION {fin.entry}
{
write$ newline$
}

FUNCTION {stupid.colon}
{ after.authors 'output.state := }


FUNCTION {insert.comma}
{ output.state before.all =
    'skip$
    { between.elements 'output.state := }
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


FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {sort.format.month}
{ 't :=
 	 t #1 #2 substring$ "01" =
 	 t	#1 #1 substring$ "1" =
 	 t	#2 #2 substring$ "" =
 	 and or
 	 { "January" }
    { t #1 #2 substring$ "02" =
			t	#1 #1 substring$ "2" =
			t	#2 #2 substring$ "" =
			and or
      { "February" }
      { t #1 #2 substring$ "03" =
 		    t #1 #1 substring$ "3" =
 		    t	#2 #2 substring$ "" =
 		    and or
        { "March" }
        { t #1 #2 substring$ "04" =
        	t #1 #1 substring$ "4" =
        	or
          { "April" }
          { t #1 #2 substring$ "05" =
           	t #1 #1 substring$ "5" =
           	or
            { "May" }
            { t #1 #2 substring$ "06" =
  	          t #1 #1 substring$ "6" =
  	          or
              { "June" }
              { t #1 #2 substring$ "07" =
              	t #1 #1 substring$ "7" =
              	or
                { "July" }
                { t #1 #2 substring$ "08" =
 		              t #1 #1 substring$ "8" =
 		              or
                  { "August" }
                  { t #1 #2 substring$ "09" =
                    t #1 #1 substring$ "9" =
                    or
                    { "September" }
                    { t #1 #2 substring$ "10" =
                      { "October" }
                      { t #1 #2 substring$ "11" =
                        { "November" }
                        { t #1 #2 substring$ "12" =
                          { "December" }
                          { t } % No match
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
    }
  if$
 
}

INTEGERS {sk}
FUNCTION {is.num}
{	chr.to.int$
 	duplicate$ "0" chr.to.int$ < not
	swap$ "9" chr.to.int$ > not and
}
FUNCTION {is.letter}
{ chr.to.int$
  duplicate$ "a" chr.to.int$  #1 - < not
  swap$ "z" chr.to.int$ #1 + > not and
}

FUNCTION {make.tag}
{ 't :=
  duplicate$ empty$
    { pop$ "" }
    { bother #0 =
    	{	t "volume" =
    			{"\textbf{"  swap$ * "}" * }
    			'skip$
    		if$
    	}
	    { "\b" t * "{" * swap$ * "}" * }
	  if$
    }
  if$
}



FUNCTION {springer.publisher}
{publisher #1 #8 substring$ "Springer" =
	{ "Springer"  }
  { publisher }
if$
}

FUNCTION {format.pub.address}
{ publisher empty$
	howpublished empty$
	and
    { address empty$
				'skip$
        {	insert.comma
            address
        	type$ "inproceedings" =
        		{"conflocation"}
        		{"location"}
		 	if$	
        	make.tag output
        }
      if$
    }
    { address empty$
        {	publisher empty$
		        {howpublished} 
		        {publisher} 
		    if$ 
		     "publisher" make.tag
		     #1 bother =
		        {", \blocation{???}" *  }
  				'skip$
		     if$
		     output   
        }
        {publisher empty$
		        {howpublished } 
		        {springer.publisher } 
		     if$ 
		      "publisher" make.tag output
					insert.comma
        	address "location" make.tag output
        }
      if$
    }
  if$
}
INTEGERS { nameptr namesleft numnames}
FUNCTION {mk.tag}
{ 'temp.str :=
  duplicate$ empty$
    { pop$ "" }
    { 
    	b "nothing" =
    		'skip$
			{"\b" temp.str * "{" * swap$ * "}" * }
		if$
	}
  if$
}

FUNCTION {space.after.dot}
{'j :=
	t 'f :=
	j 't := 
	s 'j :=
	"" 'l :=
	"" 's :=
%"orig=" t * top$
  { t empty$ not }
  {   
    t #1 #3 substring$ "{-}" =
	     {l  " {q}. " * 'l :=
	  	  t #4 global.max$ substring$ 't :=
	     }
   		 'skip$ 	
    if$

  	t #1 #1 substring$ 's :=
		  l  s * 'l := 

      s "." = 
		{ 

    	  	t #2 #1 substring$ " " =
    	      'skip$
		 	  {
		  	   l  " " * 'l := 
			   t #2 #4 substring$ "{\,}" =
		 	  		{
				  	  t #5 global.max$ substring$ 't :=
		 	  		}
    	     	  'skip$
      	  	   if$ 
		      } 
      	  	if$  
		} 
		'skip$
      if$

  	  t #2 global.max$ substring$ 't :=
    }
  while$
  f 't :=
  j 's :=
  l 
%"new="  l * top$ 
}

FUNCTION {fix.inits}{
	't :=
	 "" 'element :=
  	{ t empty$ not }
  	{  

	  t #1 #3 substring$ ".q." =
	     {element  ".-" * 'element :=
  	  	  t #3 global.max$ substring$ 't :=
	     }
	     {element  t #1 #1 substring$ * 'element :=}
	     %'skip$ 	
   	  if$
		
  	  t #2 global.max$ substring$ 't :=
    }
  while$
	element
}

FUNCTION {fix.snm}{
	't :=
	 "" 'element :=
  	{ t empty$ not }
  	{  

	  t #1 #3 substring$ "{-}" =
	     {element  "-" * 'element :=
  	  	  t #3 global.max$ substring$ 't :=
	     }
	     {element  t #1 #1 substring$ * 'element :=}
   	  if$
		
  	  t #2 global.max$ substring$ 't :=
    }
  while$
	element
}

FUNCTION {enbrace.dash}{
	't :=
	 "" 'element :=
  	{ t empty$ not }
  	{  
	  t #1 #1 substring$ "-" =
	    {element  "{-}" * 'element :=}
     	{element  t #1 #1 substring$ * 'element :=}
  	  if$
  	  t #2 global.max$ substring$ 't :=
    }
  while$
	element
}

FUNCTION {fix.name}{	

    enbrace.dash 's :=
	"" 'l :=
    "" 't :=

    #1 'nameptr :=
    s num.names$ 'numnames :=
    numnames 'namesleft :=
    { namesleft #0 > }
    {
      	s nameptr "{vv~}{ll}{, jj}" format.name$
      	s nameptr "{, ff}" format.name$ space.after.dot * 'l :=
%      	s nameptr "{vv~}{ll}{, jj}{, ff}" format.name$  'l :=
  		#1 nameptr = 
			{l 't :=}
			{t " and " * l * 't := }
		if$
      nameptr #1 + 'nameptr := 
      namesleft #1 - 'namesleft :=
    }
  while$
  t 
}

FUNCTION {name.separator}{
	namesleft #1 >
    	{", " * }
        'skip$
	if$
}

FUNCTION {format.author.editor}
{ 'b :=

    bother #1 =
    b "nothing" =
    or
    	'skip$
    	{"b" b * 'b :=}
	if$

   	b "editor"  =
   	b "beditor" =
   	b "nothing" =
   	or or
		{editor 's :=}
		{author 's :=}
	if$
	
 	%% apdoroju varda
    s fix.name 's :=
    

   "" 't :=	
 
	#1 'nameptr :=
  	s num.names$ 'numnames :=
  	numnames 'namesleft :=
  	
  	s numnames "{ll}" format.name$ 'l :=
  	l  "others" =
   	l  "{others}" =
   	l  "et al." =
   	l  "{et al.}" =
   	or or or
   		{#1 'tmp :=}
   		{#0 'tmp :=}
  	if$
  	
    { namesleft #0 > }
    {	s nameptr "{vv}" 	format.name$           "particle" mk.tag  'v := 
        s nameptr "{ll}" 	format.name$ fix.snm   "snm"      mk.tag  'l :=   
    	s nameptr "{f{.}.}" format.name$ fix.inits "inits"    mk.tag  'f := 
     	s nameptr "{jj}" 	format.name$           "suffix"   mk.tag  'j := 
		
		
   		namesleft #1 =
   		tmp #1 = 
   		and
   		{	b "bauthor" =
   		 	b "beditor" =
		   	or
		   		 {"et al."}
   				 {"\betal"}
				if$
  			#1 'tmp :=
		}
   		{

   			b "bauthor" =
   			b "beditor" =
   			or
	  			{"\oauthor{"}
	  			{
   					b "nothing" =
   						{""}
	  					{"\b" b * "{" *}
					if$
	  			}
			if$			

			v empty$
				'skip$
				{v * " " *}
			if$
			
		   	l empty$
			    'skip$
				{ l *} 		
			if$			

		   	f empty$
				'skip$
				{", " * f *} 		
			if$

		   	j empty$
			    'skip$
				{" "  * j *} 		
			if$

   			b "nothing" =
   				{""}
				{"}"}  
			if$
			
			* "" 't :=

		 } 
		if$

	  	name.separator

      	write$ 
      	
      namesleft #1 >
  	  b "nothing" = not
  	  and
		{namesleft #2 =
		 tmp #1 =
		 and
			'skip$
			'newline$
		 if$
		}
		'skip$
	  if$

      	nameptr #1 + 'nameptr := 
      	namesleft #1 - 'namesleft :=
    }
  while$
  
}
FUNCTION {format.editors}
{ editor empty$
    'skip$
    {
    	bother #0 =
			{author empty$
   		  		{"editor"}
   				{"nothing"}
   		 	if$
  			}
			{"editor"}
		if$  
	  	format.author.editor
      editor num.names$ #1 >
        { " (eds.)" }
        { " (ed.)" }
      if$
      write$
    }
  if$
}

FUNCTION {format.authors}
{ author empty$
    'skip$
    {"author"  format.author.editor}
  if$
}

FUNCTION {cite.author.editor3}% formuoja tris autorius
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #3 >
    { pop$ " \textit{et~al.}" * }
    { #3 =
        { s #3 "{vv~}{ll}{ jj}{ f}" format.name$ "others" =
            { " \textit{et~al.}"  * }
            { ", " * s #2 "{vv~}{ll}" format.name$ * 
             ", and " * s #3 "{vv~}{ll}" format.name$ *  
            }
          if$
        }
		    {s num.names$ #2 =
    		        {s #2 "{vv~}{ll}{ jj}{ f}" format.name$ "others" =
            				{ " \textit{et~al.}"  * }
     		    				{ " and " * s #2 "{vv~}{ll}" format.name$ * }
     		    			if$
     		    		}
     		    		'skip$
        	 if$
        }
      if$
    }
  if$
}
FUNCTION {cite.author.editor}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 =
        {s #2 "{vv~}{ll}{ jj}{ f}" format.name$ "others" =
			{ " et~al."  * }
			{ " and " * s #2 "{vv~}{ll}" format.name$ * }
     	 if$
     	}
     	'skip$
   	 if$
    }
  if$
}
FUNCTION {check.auth.edit.org}
{author empty$
		{
			editor empty$
					{
						organization empty$
								{""}
								{organization}
						if$		
					}
					{editor cite.author.editor}
			if$		
		}
		{author cite.author.editor}
 if$	
}

FUNCTION {check.year}
{year empty$
		{""}
		{year extra.label *}
	if$	
}

INTEGERS { multiresult char.num k int}
INTEGERS {str.length count return save.num1 save.num2}
FUNCTION {is.in.list}{
	'f :=
	%%%% issisaugoju originalius "s" ir "t"
	s 'j :=
	f 's :=
	t 'f :=  
  list.string text.length$ 'str.length :=
  list.string 't :=
%  s text.length$ 'slen :=
  int   'save.num1 :=
  count 'save.num2 :=
  #1 'int :=
  #1 'count :=
  #0 'return :=
    
    { count str.length = not 
      #0 str.length = not
      and
    }
    {
	   count #1 + 'count :=
	   t int #1 substring$ "," =
      	{
      	  t #1 int substring$ s "," * =
      	    {
		  	   #1 'return :=
  			   str.length 'count :=
			}
	    	'skip$
         if$
	        
	        int #1 + 'int :=
   		    t int global.max$ substring$ 't :=
				  #0 'int :=
      	}
      	'skip$
      if$	
      int #1 + 'int :=
%			"count=" count int.to.str$ * " slen=" * str.length int.to.str$ * top$
    }
  while$

  save.num1 'int   :=
  save.num2 'count :=
  
  #0 return =
  	{ s t =
		    {#1 'return :=}
		    'skip$
		  if$
  	}
  	'skip$
  if$
	%%%% grazinu originalius "s" ir "t"
	j 's :=
	f 't :=  
	
	return		
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem"
  "nameyear" is.in.list
     {
 	    "[\protect\citeauthoryear{" * write$
	   			check.auth.edit.org write$ 
	   	"}{" write$ 
	   			check.year write$ 
	   	"}]" 
    }
    'skip$
  if$
  "alpha" is.in.list
     {
 	    "[" * write$
  	  label write$
	    "]" 
    }
    'skip$
  if$

  "{" * write$  
  cite$ write$
  "}" write$

  newline$
  "" before.all 'output.state :=
}


FUNCTION {string.to.integer}
{ 't :=
    t text.length$ 'k :=
  #1 'char.num :=
      { t char.num #1 substring$ 's :=
	 	  s is.num
	 	  s "." =
	 	  or 
	 	  char.num k = not
	 	  and
	 	 	}
	 	 {char.num #1 + 'char.num :=}
  while$
  char.num #1 - 'char.num :=
  t #1 char.num substring$ 
  
%  "S" k * write$
}

 
FUNCTION {find.integer}
{ 't :=
  #0 'int :=
    { int not
      t empty$ not
      and
    }
    { t #1 #1 substring$ 's :=
    	s is.num 
        {#1 'int :=}
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  int 
}


FUNCTION {format.title2}
{ title empty$
    { "" }
    { 
    	type$ "article" =
    	type$ "incollection" =
    	type$ "inproceedings" =
    	or or
    		{title "t" change.case$}
    		{title}
    	if$	
    }
  if$
}

function{title.lowerwords}{
"a,an,and,of,the,for,in,to,over,from,on,or,so,than,that,this,as,but,with,by,at,down,up,upon,al,ale,aus,aux,d'Analyse,d'Analystes,d'Architecture,d'Etudes,d'Histoire,da,dans,de,degli,dei,del,"
"dell',dell'Accademia,dell'Istituto,dell'Universita,della,delle,dem,der,des,detta,di,die,din,dlia,do,du,e,eXpress,ed,ego,el,em,en,et,fur,i,iz,l'Academie,l'Age,l'Antiquite," *
"l'Approximation,l'Ecole,l'Histoire,l'I.S.U.P.,l'INSA,l'IREM,l'Indirizzo,l'Institut,l'Institute,l'UFR,l'Union,l'Universite,la,las,les,na,nella,per,po,si,sue,sur,ta,tes,und,van,voor,zu,zum,zur" *
}

FUNCTION {upercase.first.letters}{
	't :=
	"" 's :=
  #1 'int :=
  #1 'count :=
  list.string  'v :=
  "" 'b :=
  title.lowerwords 'list.string :=	
 %  		"title =" t * top$

  t text.length$ 'slen :=
  
    {count slen = not }
    {t int #1 substring$ " " =
      	{
	        int #1 - 'int :=
      	  t #1 int substring$ 'b :=
          
          %jei zodis ne sarase, jo pirmaja raide padarom didziaja
      	  b is.in.list not
      	  	{
      	  		b "u" change.case$ "t" change.case$ 'b :=
      	  	}
      	  	'skip$
      	  if$
      	  
	        int #1 + 'int :=

      	  s b " " *  * 's :=
	        int #1 + 'int :=
   		    t int global.max$ substring$ 't :=
				  #0 'int :=
      	}
      	'skip$
      if$	
      int #1 + 'int :=
			count #1 + 'count :=
%			"count=" count int.to.str$ * " slen=" * slen int.to.str$ * top$
    }
  while$
  v 'list.string :=	

  s t "u" change.case$ "t" change.case$  * %top$
		
}


FUNCTION {format.title}
{ title empty$
    { "" }
    { title  
      "article" type$ =
      type$ "techreport" =
      type$ "inbook" =
      type$ "inproceedings" =
      type$ "phdthesis" =
      type$ "mastersthesis" =
      or or or or or
    	 {"t" change.case$}
    	 {upercase.first.letters}
      if$
    }
  if$
}


FUNCTION {note.presented}
 {note #1 #9 substring$ "presented" = 
 	note #1 #9 substring$ "Presented" = 
 or}
 
FUNCTION {n.filter}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "," =
      t #1 #1 substring$ "\" =
      t #1 #1 substring$ "~" =
      or or
            {  "" *
                  t #2 global.max$ substring$ 't :=
            }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {byear}
{ duplicate$ empty$
    { pop$ "" }
    {'t :=
     t text.length$ 'sk :=
			#5 sk =
					{t #1 #4 substring$ 's :=
					 t #5 #1 substring$ 'longest.label :=
					 	longest.label is.num not	
							{s "year" make.tag  * longest.label * }
							{t "year" make.tag }
						if$
					}
					{t "year" make.tag 
  						"nameyear" is.in.list						
							{extra.label *}
							'skip$
						if$
					}
			if$
    }
  if$
}

FUNCTION {format.date}
{ year empty$
    { "" }
    {  year byear  }
  if$
}

FUNCTION {format.month}{ 
	month empty$
		{""}
		{month sort.format.month "confdate" make.tag}
	if$
}
FUNCTION {formatpatent.date}
{ year empty$
    'skip$
    { month empty$
       { year }
        {format.month " " * year *}
      if$
    }
  if$
}
FUNCTION {month.year.date}
{ year empty$
    {""}
    { month empty$
        {year byear}
        { format.month " " * year byear * }
      if$
      type$ "inproceedings" =
      	'skip$
      	{"(" swap$ * ")" * }
      if$
    }
  if$
}
FUNCTION {parens}
{ duplicate$ empty$
    { pop$ "" }
    { "(" swap$ * ")" * }
  if$
}


FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}
FUNCTION {format.volume}
{ volume empty$
    { "book" type$ =
    		{number empty$
    			{""}
    			{"vol. " number "seriesno" make.tag *}
    			if$
    		}
    		{""} 
      if$
    }
    {"vol. " volume "seriesno" make.tag *}
  if$
}
FUNCTION {format.volume2}
{ volume empty$
		{""} 
    {"vol. " volume "seriesno" make.tag *}
  if$
}

FUNCTION {format.art.vol}
{ 
 volume empty$
	{""}
	{volume n.filter "volume" make.tag}
  if$
	number empty$
    'skip$
    { "(" number "issue" make.tag * ")" * * }
  if$
}

FUNCTION {format.series}
{ series empty$
	'skip$ 
    {series "sertitle" make.tag}
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { "" 'v :=
			"" 'l :=    
			"" 'f :=    
    	edition "l" change.case$ 's :=
 				"1" s =
 				"first" s =  			
   			or
   				{
   					"1" 'v :=
						"st" 'l :=  
   				}
   				{
 						"2" s =
 						"second" s =  			
   					or
   						{
   							"2" 'v :=
								"nd" 'l :=  
   						}
   						{
 								"3" s =
 								"third" s =  			
   							or
   								{
   									"3" 'v :=
										"rd" 'l :=  
   								}
   								{
 										"4" s =
 										"fourth" s =  			
   									or
   										{
   											"4" 'v :=
												"th" 'l :=  
   										}
   										{
 												"5" s =
 												"fifth" s =  			
   											or
   												{
   													"5" 'v :=
														"th" 'l :=  
   												}
   												{
 														"6" s =
 														"sixth" s =  			
										   			or
   														{
   															"6" 'v :=
																"th" 'l :=  
										   				}
										   				{
												 				"7" s =
												 				"seventh" s =  			
												   			or
												   				{
												   					"7" 'v :=
																		"th" 'l :=  
												   				}
												   				{
														 				"8" s =
														 				"eighth" s =  			
														   			or
														   				{
														   					"8" 'v :=
																				"th" 'l :=  
														   				}
														   				{
																 				"9" s =
																 				"nineth" s =  			
																   			or
																   				{
																   					"9" 'v :=
																						"th" 'l :=  
																   				}
																   				{
   																						edition "t" change.case$ 'f :=
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
						   				}
						   			if$	 
				   				}
				   			if$	 
   						}
   					if$	 
   				}
   			if$	 
   		 #0 bother =		
   				{	f "" =
   						{ v l *	'f :=}
   						'skip$
   					if$
   				}
   				{	f "" =
   						{ "\bedition{" v * "}" * l *	'f :=}
   						{ "\bedition{" f * "}" *	'f :=}
   					if$
   				}
   		if$
   		f " edn." *
    }
  if$
}
FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { isbn "isbn" make.tag}	
  if$
}

INTEGERS {default.info}
function{options.add}{
	"article:opt,book:opt,booklet:opt,conference:opt,inproceedings:opt,incollection:opt,inbook:opt,proceedings:opt,manual:opt,"
	"techreport:opt,unpublished:opt,misc:opt,mastersthesis:opt,phdthesis:opt," *
	}

FUNCTION {add.to.defaults}{
	's :=
	options.add 't :=

	 default.list 'element :=
  	{ t empty$ not }
  	{  

	  t #1 #4 substring$ ":opt" =
	     {element  "." * s * 'element :=
  	  	  t #4 global.max$ substring$ 't :=
	     }
	     {element  t #1 #1 substring$ * 'element :=}
	     %'skip$ 	
   	  if$
		
  	  t #2 global.max$ substring$ 't :=
    }
  while$
	element 'default.list :=

}

FUNCTION {add.to.list}{
	'b :=
  	b is.in.list
  		'skip$
  		{list.string "," b * * 'list.string :=}
	if$

}
FUNCTION {assign.global.values2}{

	%%%%%%%%%% pradiniai nustatytmai: #1->ijungta, #0->isjungta  
  info empty$
    'skip$
    { info "1" =
      	{#1 'default.info :=} 
      	{#0 'default.info :=}
      if$
		}
	if$

  isbn empty$
    {"book.isbn" add.to.list}
    { isbn "1" =
      	{"isbn" add.to.defaults} 
      	'skip$
      if$
    }
  if$

  month empty$
  	{
  		"conference.month" add.to.list
  		"proceedings.month" add.to.list
  		"inproceedings.month" add.to.list
  		"incollection.month" add.to.list
  		"inbook.month" add.to.list
  	}
    { month "1" =
      	{"month" add.to.defaults} 
      	'skip$
      if$
    }
  if$

  urldate empty$
    'skip$
    { urldate "1" =
      	{"urldate" add.to.defaults} 
      	'skip$
      if$
    }
  if$

  %%%%%%%%%% pradiniai nustatytmai
	default.list "," * list.string * 'list.string :=
  	
	list.string  'default.list :=
%"final list = " list.string * top$   
%"final default = " default.list * top$   
}	
FUNCTION {process.list}{
    'bother :=
	'f :=
  "" 'l :=	
  default.list text.length$ 'str.length :=
  default.list 'b :=
%  s text.length$ 'slen :=
  int   'save.num1 :=
  count 'save.num2 :=
  #1 'int :=
  #1 'count :=
  #0 'return :=

    { count str.length = not 
      #0 str.length = not
      and
    }
    {
	   count #1 + 'count :=
	   b int #1 substring$ "," =
      	{
      	  b #1 int substring$ f "," * =
      	    {
      	      bother
      	      	{default.list #1 count #1 - int - substring$ 'l :=
      	      	 l 	default.list count global.max$ substring$ * 'l :=
      	      	}
      	      	'skip$
      	      if$	
%      	      "pavyko rasti = " f * top$
		  	   #1 'return :=
  			   str.length 'count :=
			}
	    	'skip$
         if$
	        
	        int #1 + 'int :=
   		    b int global.max$ substring$ 'b :=
				  #0 'int :=
      	}
      	'skip$
      if$	
      int #1 + 'int :=
%			"count=" count int.to.str$ * " slen=" * str.length int.to.str$ * top$
    }
  while$
  save.num1 'int   :=
  save.num2 'count :=

  
  l "" = 
	{bother not %% bother=0 - prideti f
		{f "," * default.list * 'default.list :=}
		'skip$
	 if$
	}
  	{
% "nerasti = " f * "  l=" * l * top$
      bother not
      return not
      and 
      	{
      		l "," * f * 'l :=
%  			l 'default.list :=
      	}
       	'skip$
      if$	
  	
  		l 'default.list :=
  	
  	}
  if$
		
}

FUNCTION {process.val2}{
	't :=
	"" 'j :=
	
 	duplicate$ empty$
    	{ pop$}
    	{ 's := 

    		{ s empty$ not }
    		{
    			s #1 #1 substring$ 'v :=

					 v is.letter
				  			{ j v * 'j :=  
				  			  %"raide="  v * top$
				  			} 
      						{v "=" =
      						   {
      							s #2 #1 substring$ "0" =
      							
      								{ t "." * j * #1 process.list  %%%%% #1 -- istrinti is saraso
%      								  j " = isjungtas" * top$
      									"" 'j :=	
      								}
      								{ t "." * j * #0 process.list  %%%%% #0 -- prideti prie saraso
%      								  j " = ijungtas" * top$
      									"" 'j :=	
      								}
      							if$
      						    }
      						    'skip$
      						 if$
      						}
						if$

      			s #2 global.max$ substring$ 's :=
			}
  			while$

    	}
  	if$

}

FUNCTION {reset.global.values2}{
%	options.default 'default.list :=

%"list middle=" default.list * top$

	xbook 			"book" process.val2
	xarticle 		"article" process.val2
	xbooklet 		"booklet" process.val2
	xconference 	"conference" process.val2
	xinproceedings 	"inproceedings" process.val2
	xincollection 	"incollection" process.val2
	xinbook 		"inbook" process.val2
	xmanual 		"manual" process.val2
	xproceedings 	"proceedings" process.val2
	xphdthesis 		"phdthesis" process.val2
	xmastersthesis 	"mastersthesis" process.val2
	xmisc 			"misc" process.val2
	xunpublished 	"unpublished" process.val2
	xtechreport 	"techreport" process.val2

%"list last=" default.list * top$
}



FUNCTION {make.info.line}{
	't :=
			"%(month=" 
    		t ".month" * is.in.list
				{"1"}
				{"0"}
			if$
    	
	    	* 
    		", isbn=" * 
    		t ".isbn" * is.in.list
				{"1"}
				{"0"}
			if$
			*
    		", urldate=" * 
    		t ".urldate" * is.in.list
				{"1"}
				{"0"}
			if$
			*
			")   %@" *
			t       
			*  write$ newline$
}

FUNCTION {p.info}{
%	options.default 'default.list :=

%"list middle=" default.list * top$

	"book" make.info.line
	"article" make.info.line
	"booklet" make.info.line
	"conference" make.info.line
	"inproceedings" make.info.line
	"incollection" make.info.line
	"inbook" make.info.line
	"manual" make.info.line
	"proceedings" make.info.line
	"phdthesis" make.info.line
	"mastersthesis" make.info.line
	"misc" make.info.line
	"unpublished" make.info.line
	"techreport" make.info.line

%"list last=" default.list * top$
}


FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
	"" 'l :=

    {t empty$ not}
    { t #1 #1 substring$  's :=
    	
      s is.num not
        { "" l = not
        		{t find.integer 
								{#1 'multiresult := }
								{#0 'multiresult := }
       		 		if$
       		 		"" 't :=
       			}
       			{
       			t #2 global.max$ substring$ 't :=
       			}
       		if$	
        }
        { l  s * 'l :=
        	t #2 global.max$ substring$ 't := 
        }
      if$
    }
  while$
  multiresult 
}
FUNCTION {clearpage}
{ 't :=
	"" 's :=
	"" 'l :=
	
    { t empty$ not }
    {
    	t #1 #1 substring$ 's :=
      s is.num not
				'skip$
        {	l  s * 'l := 	}
      if$
      t #2 global.max$ substring$ 't :=
		}
  while$
  l
       
}
FUNCTION {do.pages}
{'t :=
	"" 'j :=
	"" 'v :=
    {t empty$ not}
    { t #1 #1 substring$  's :=
      s is.num not
      s "," = not
      and
        { "" j = 
       			{
       				t #2 global.max$ substring$ 't :=
       			}
        		{t find.integer 
								{ t clearpage  'v := }
								'skip$
       		 		if$
       		 		"" 't := 
       			}
       		if$	
        }
        {	j  s * 'j :=
          	t #2 global.max$ substring$ 't := 
        }
      if$
    }
  while$
  j clearpage  'j :=
  j  "fpage" make.tag 
  "cnd" is.in.list
  	'skip$
  	{"--"  * v "lpage" make.tag *}
  if$
}


FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        {type$ "article" =
        	{""}
        	{"cnd" is.in.list
        	   {"p. "}
        	   {"pp. "}
        	  if$ 
        	} 
         if$	
        	pages do.pages *
        }
        {type$ "article" =
        	{""}
        	{"p. "} 
         if$	
        	pages clearpage "fpage" make.tag *
        }

      if$
    }
  if$
}

FUNCTION {replace.tilde}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "~" =
            {   { t #1 #1 substring$ "~" = }
                { "\texttildelow " *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}


FUNCTION {format.url}
{ url empty$
    'skip$
    { type$ "article" =
      	'skip$	
    	{#0 bother =
				    {"\url{" url replace.tilde * "}" * }
				    {"\burl{" url replace.tilde * "}" * }
		if$
		output	
		}
	  if$
   	  type$ "" =
   	  	{"unpublished"}
   	  	'type$
   	  if$
   	  %" " * cite$ * top$
   	  ".urldate" * is.in.list
  	  	{
  	   	 	 urldate empty$
  	   	 	 	'skip$
	 		 	{"Accessed " urldate * output}
	 		 if$
  	  	}
		'skip$
	  if$
	}	
  if$
}

FUNCTION {format.month.output}{
  publisher empty$
%  "cnd"  is.in.list 
%  or	
  	'skip$
  	{
   	  type$ ".month" * is.in.list
  	  	{
  	   	 	 insert.comma
	 		 format.month output
  	  	}
		'skip$
	  if$
	}
  if$
}

FUNCTION {publisher.month.pages}{
  publisher empty$ series empty$ and
   	{
      format.pub.address
   	  format.month.output

      pages empty$
        'skip$
   			{insert.comma}
  		if$  
     	format.pages output
   	
   	}
   	{
      pages empty$
   		   'skip$
    			{insert.comma}
    	if$  
      format.pages output
    	publisher empty$
   			'skip$
    		{new.sentence}
			if$
      format.pub.address
   	}
  if$
}

function{process.doi}{
	doi 't :=
    "" 'b :=
    #1 'int :=
% 	"doi =" t * top$

	t text.length$ 'slen :=
  
    {int slen = not }
    {t int #3 substring$ "10." =
      	{
      	  t int #1 - #1 substring$ 'b :=
 %     	  "[b=" b * "]" * top$
      	  b "" = 
      	  	{"a" 'b :=} % jei tuscias, priskiriu raide, kad is.num nemestu klaidos.
      	  	'skip$
      	  if$
      	  	
      	  b is.num not
      	  	{
     			t int slen int - #1 + substring$ 't :=
      	  		slen #1 - 'int := 
      	  	}
      	  	'skip$
      	  if$
      	  
      	}
      	'skip$
      if$	
      int #1 + 'int :=
    }
  while$
%  t top$
  t
}

FUNCTION {format.doi}
{ doi empty$
	{""}
	{ 
	 "nodoi" is.in.list
        {""}
		{"doi:\doiurl{" process.doi * "}" * }
	 if$
	}
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    {#1 bother =
     "cnd" is.in.list not
     and
    			{ editor empty$
      			  	{ "In: \bbtitle{???}"  output}
  		      		{ "In: " output write$ format.editors
        			  "\bbtitle{???}"  output 
      			  	}
  				  if$
	    		}
    			'skip$
    	if$
    }
    { editor empty$
        { "In: " booktitle "btitle" make.tag * output}
        { "In: " output write$ format.editors  "" %%% pushing empty string to the empty stack
        	 booktitle "btitle" make.tag  output 
        }
      if$
    }
    
  if$
}

FUNCTION {format.in.ed}
{ title empty$
   'skip$
    { editor empty$
        {  title "btitle" make.tag output}
       { author empty$
        {  format.editors
        		stupid.colon
        		format.date output
        		title "btitle" make.tag output
        }
        { "In: " output write$ format.editors  "" %%% pushing empty string to the empty stack
        	title "btitle" make.tag output
        }
        if$
   		 }
      if$
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

FUNCTION {patent.number}
{    number empty$
		 'skip$
    { number }
  if$
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
 
FUNCTION {format.inpres}
{ "l" change.case$ 't :=
      "in press: " #10
       "in press. " #10
        "in press " #9 t chop.word
      chop.word
     chop.word
  #1 global.max$ substring$
}

FUNCTION {bcomment.note}
{note empty$
'skip$
 {note format.inpres "comment" make.tag output}
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

FUNCTION {format.chapter.and.note}
{		note empty$ chapter empty$ organization empty$ and and
		'skip$
	{	chapter empty$
		"nenumeris" last.label =
		or
			{organization empty$
					{note "comment" make.tag output}
					{note empty$
							{organization "comment" make.tag output}
							{organization ". " * note * "comment" make.tag output}
					 if$
					}
			 if$
			}
			{note empty$
				{"Chap. "  chapter * "comment" make.tag output}
						{		type empty$
									{ "Chap. " }
									{ type "t" change.case$ "Section" = 
									 		{	"Sect. " }
											{ "Chap. " }
										if$	
									}
								if$
										chapter * ". " * note * "comment" make.tag  output
						}
					if$
				}
			if$
	}
	if$
		
}

FUNCTION {item.pabaiga}
{
  new.sentence
  type$ "unpublished" =
  		{	note empty$
  				'skip$
  				{note.presented
  						'skip$
  						{note output}
  				 if$		
  				}
  			if$	
  		}
			{
			  type$ "proceedings" =
						{author empty$ editor empty$ and
								'bcomment.note
					 			'format.chapter.and.note 
						 if$	
						}
			 			'format.chapter.and.note 
			 	if$		
			}
	if$
	list.string  'v :=
	default.list  'list.string :=

    type$ ".isbn" * is.in.list
    "cnd" is.in.list 
    or
	{
		 new.sentence 
  	 	format.isbn output
  	}
   	'skip$
	if$
	new.sentence
  	eprint empty$
  		'skip$
  		{"\arxivurl{" eprint * "}" * output}
  	if$ 
  	new.sentence
  	format.doi  output
  	new.sentence
  	format.url 
  	v 'list.string :=
  	fin.entry
}
FUNCTION {insert.element}
{	#0 bother =
  		{element "{botherref}" * write$ newline$}
  		{
			   type$ "article" =
						{element "{barticle}" * write$ newline$}
						'skip$
				 if$
				 type$ "book" =
		     type$ "proceedings" =
         type$ "manual" =
         type$ "booklet" =
         or or or 
					  {element "{bbook}" * write$ newline$}
						'skip$
				 if$
					
			   type$ "inbook" =
					  {	"nenumeris" last.label =
					  		{element "{bchapter}" * write$ newline$}
						  	{element "{bbook}" * write$ newline$}
					  	if$	
					  }
						'skip$
				 if$
			  
		 type$ "incollection" =
		 type$ "inproceedings" =
		 type$ "conference" =
		 or or
					  {element "{bchapter}" * write$ newline$}
						'skip$
				 if$

   		}
  if$
}
FUNCTION {end.element}
{ "\end" 'element :=
	item.pabaiga
  insert.element
  "\endbibitem" write$ newline$
}
FUNCTION {begin.element}
{ "\begin" 'element :=
  insert.element
  #0 'month.printed := 
  default.info
    {	
    	"%" 
    	type$ * " month= " *
    	type$ ".month" * is.in.list
			{"1"}
			{"0"}
		if$
    	
    	* 
    	", isbn=" * 
    	type$ ".isbn" * is.in.list
			{"1"}
			{"0"}
		if$

    	* 
    	", urldate=" * 
    	type$ ".urldate" * is.in.list
			{"1"}
			{"0"}
		if$
    	* write$ newline$
    }
		'skip$
	if$	
%  type$ top$
}
function {set.options}{
	options empty$
		'skip$
		{options 'list.string :=}
	if$	
}

FUNCTION {settings}
{
  set.settings not
		{
		 % assign.global.values
		  assign.global.values2
		 % reset.global.values
		  reset.global.values2
		  #1 'set.settings :=
		  	default.list 'list.string :=
			default.info
				'p.info
				'skip$
			if$
		}
		'skip$
	if$
}


FUNCTION {article}
{ output.bibitem
	author empty$
	institution empty$ 
	editor empty$
	and and
	journal empty$ 
  	year empty$ 
 	or or 
  	volume empty$ pages  empty$ 
  	doi empty$ and
   	or or
		{#0 'bother :=} 
		{#1 'bother :=} 
	if$	
	begin.element
  	author empty$
    	{ editor empty$
    		'skip$
     		{format.editors stupid.colon}
    	  if$
    	}
    	{ format.authors stupid.colon}
  	if$
	"cnd" is.in.list
	  {
	    journal empty$
				{format.title "atitle" make.tag "title" output.check}
 				{journal "jtitle" make.tag  output}
			if$
		}
		{
	    format.title "atitle" make.tag "title" output.check
		  journal empty$
				'skip$
    		{new.sentence journal "jtitle" make.tag  output}
			if$
		}
	if$	
  	format.art.vol output
  	pages empty$
    	'skip$
    	{insert.comma}
  	if$
  	format.pages output
  	format.date parens output
	end.element
}
FUNCTION {patent}
{ output.bibitem
	#0 'bother :=
	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
    format.title "title" output.check
    add.period$
	patent.number output
	insert.comma
  	formatpatent.date output
	end.element
}

FUNCTION { other } { patent }

FUNCTION {book}
{ output.bibitem
	author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  	year empty$ 
   	or or
		{#0 'bother :=} 
		{
			publisher empty$ address empty$ not and
				{#0 'bother :=} 
				{#1 'bother :=}
			if$
		} 
	if$	
	begin.element
  	author empty$
    	{ editor empty$
    		'skip$
     		{format.editors stupid.colon}
    	  if$
    	}
    	{ format.authors stupid.colon}
  	if$
  	format.title "btitle" make.tag "title" output.check
    	series empty$
         {
         	format.volume output
         	insert.comma 
         	format.edition output
         	format.month.output
         }
         {edition empty$
            'skip$
         	  'insert.comma
          if$
          format.edition output
         	format.month.output
          new.sentence
          format.series output
          insert.comma 
          format.volume output
         }
    if$ 
  	publisher.month.pages
  	format.date parens output
	end.element      
}

FUNCTION {booklet}
{output.bibitem
	author empty$
	title empty$ 
  	year empty$ 
 	howpublished empty$  
   	or or or
		{#0 'bother :=} 
		{#1 'bother :=} 
	if$	

	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
  	format.title "btitle" make.tag "title" output.check
  	new.sentence
  	format.pub.address
  	format.date parens output
	end.element
}
FUNCTION {misc}
{output.bibitem
 	#0 'bother :=
	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
  	format.date  output
  	format.title "btitle" make.tag "title" output.check
  	new.sentence
  	format.pub.address
	end.element
}

FUNCTION {inbook}
{ output.bibitem

  	author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  	year empty$ 
  	or or 
		{#0 'bother :=} 
		{
			publisher empty$ address empty$ not and
				{#0 'bother :=} 
				{#1 'bother :=}
			if$
		} 
	if$	

	chapter empty$
		{	"" 'last.label :=}
  		{	chapter string.to.integer empty$ author empty$ not and
				{	"nenumeris" 'last.label :=}
				{	"" 'last.label :=}
  			if$
  		}
  	if$
  
	begin.element
 	author empty$
  		'skip$
  		{format.authors stupid.colon}
  	if$ 
    "nenumeris" last.label =
		{chapter "ctitle" make.tag output
    		add.period$
    	}
  		'skip$
	if$
   	format.in.ed 
    series empty$
         {
          format.volume output
          insert.comma 
          format.edition output
          format.month.output
          new.sentence
         }
         {
          insert.comma
          format.edition output
          format.month.output
          new.sentence
          format.series output
          volume empty$
          	'skip$
           	'insert.comma
          if$  
          format.volume output
         }
    if$ 
  	publisher.month.pages
	publisher empty$ address empty$ edition empty$ series empty$ pages empty$ volume empty$ and and and and and
		'insert.comma
		'skip$
	if$
	format.date parens output
  	end.element
}
FUNCTION {incollection}
{ 	output.bibitem
  	author empty$
	institution empty$ 
	and
	booktitle empty$ 
	title empty$
  	year empty$ 
 	or or or
		{#0 'bother :=} 
		{
			publisher empty$ address empty$ not and
				{#0 'bother :=} 
				{#1 'bother :=}
			if$
		} 
	if$	
	begin.element
	author empty$
		'skip$	
		{format.authors stupid.colon}
	if$		 

	"cnd" is.in.list
		{
      		booktitle empty$ title empty$ not and
   	    	{
		      format.title "ctitle" make.tag "title" output.check
		      new.sentence
		    }
		    'skip$
	    if$		 
	  	}
	  	{
	    format.title "ctitle" make.tag "title" output.check  
      	title empty$
  	    	'skip$
   	    	{new.sentence}
      	if$
	  	}
	if$

  	format.in.ed.booktitle 
    series empty$
       {
          	format.volume output
          	insert.comma 
          	format.edition output
         	format.month.output
       }
       {
          edition empty$
        	'skip$
         	{insert.comma
         	 format.edition output
		    } 
          if$
          format.month.output		
 	      new.sentence 
          format.series output
          insert.comma
          format.volume output
       }
    if$ 
  	publisher.month.pages
	format.date parens output
	end.element
}

FUNCTION {inproceedings}
{ output.bibitem
	author empty$
	institution empty$ 
	and
	title empty$ 
	year empty$ 
 	or or
		{#0 'bother :=} 
		{#1 'bother :=}
	if$	
	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
	
	"cnd" is.in.list
	  {
        booktitle empty$ title empty$ not and
   	    	{
		      format.title "ctitle" make.tag "title" output.check
		      new.sentence
		    }
		    'skip$
	    if$		 
	  }
	  {
        format.title "ctitle" make.tag "title" output.check
 	    title empty$ booktitle empty$ not and
		    'skip$
			  {new.sentence}
	    if$
	  }
	if$
 
	format.in.ed.booktitle 
  	format.month.output
    series empty$
      	'skip$
      	{new.sentence format.series output}
    if$  
    insert.comma
  	format.volume output
  	publisher.month.pages
  
  	publisher empty$
  	editor empty$
  	pages empty$
  	and and
  		{insert.comma month.year.date output}
  		{format.date parens output}
  	if$  	
	end.element
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ 	output.bibitem
	author empty$
	organization empty$ 
	title empty$ 
  	year empty$ 
 	address  empty$ 
 	or or or or
		{#0 'bother :=} 
		{#1 'bother :=} 
	if$	
	begin.element

  	author empty$
    	{ organization empty$
        	'skip$
        	{ organization "publisher" make.tag output.nonnull
          	stupid.colon% add.period$
        	}
      	if$
    	}
    	{ format.authors stupid.colon}
  	if$
  	title empty$
  		'skip$
  		{format.title "btitle" make.tag output}
   	if$
  	edition empty$
    	{new.sentence}
 		{insert.comma}
	if$
  	format.edition output
  	edition empty$
		'skip$
    	{new.sentence}
	if$
   	author empty$ organization empty$
   	or
        'skip$
        { organization "publisher" make.tag output.nonnull
          insert.comma
        }
  	if$
  	address empty$
    	'skip$
     	{address "location" make.tag output}
  	if$
  	format.date parens output
	end.element
}


FUNCTION {phdthesis}
{output.bibitem
	#0 'bother :=
	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
  	format.title "title" output.check
  	new.sentence
  	type$ "mastersthesis"  =
  		{"Master's thesis" format.thesis.type output.nonnull}
  		{"PhD thesis" format.thesis.type output.nonnull}
  	if$		
  	school empty$
    	'skip$
     	'insert.comma 
  	if$
  	school "school" output.check
  	address empty$
    	'skip$
     	'insert.comma 
  	if$
  	address output
  	month.year.date output
	end.element
}
FUNCTION {mastersthesis}{phdthesis}


FUNCTION {proceedings}
{ output.bibitem
	author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  	year empty$ 
 	or or 
		{#0 'bother :=} 
		{
			publisher empty$ address empty$ not and
				{#0 'bother :=} 
				{#1 'bother :=}
			if$
		} 
	if$	

	begin.element
  	author empty$
   		{ editor empty$
   			{organization "institutionaled" make.tag "organization" output.check }
			{ format.editors }
  		  if$ 
  		}
    	{ format.authors }
  	if$
    stupid.colon
  	format.title "btitle" make.tag output
 	format.month.output
    series empty$
    	'skip$
        {new.sentence format.series output}
    if$
    volume empty$
        'skip$
        'insert.comma  
    if$  
    format.volume output
  	publisher.month.pages
	format.date parens output
	end.element
}

FUNCTION {techreport}
{output.bibitem
	#0 'bother :=
	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
  	format.title "title" output.check
  	new.sentence
  	format.tr.number output.nonnull
  	institution empty$
    	'skip$
     	'insert.comma 
  	if$
  	institution "institution" output.check
  	insert.comma 
  	address output
  	month.year.date  output
	end.element
}

FUNCTION {unpublished}
{output.bibitem
	#0 'bother :=

	begin.element
  	author empty$
 		'skip$
  		{format.authors stupid.colon}
  	if$
   	year empty$ author empty$ or
  		'skip$
  		{format.date output insert.comma}
  	if$
  	format.title "title" output.check
  	title empty$
  		'skip$
  		'new.sentence
  	if$
  	note empty$
    	'skip$
  		{	note.presented 
  				{note output}
    			'skip$
  			if$
  		}
  	if$
   	year empty$ not author empty$ and
  		{insert.comma year output}
  		'skip$
  	if$
	end.element
}

FUNCTION {default.type} { unpublished }

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

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { et.al.char.used }

FUNCTION {initialize.et.al.char.used}
{ #0 'et.al.char.used :=
}

%%%%% setting default options
FUNCTION {set.default.opt}
{"nameyear,cnd" 'list.string :=}

EXECUTE {set.default.opt}

FUNCTION {assign.opt}{
  % priskiriu options lauka, kad galeciau i(is)jungti "unsort"
  "settings" type$ =
  	{options empty$
		'skip$
  		{options 'list.string :=}
  	 if$
  	}
  	'skip$
  if$
}

ITERATE {assign.opt}
EXECUTE {initialize.et.al.char.used}

FUNCTION {alpha.format.lab.names}
{ 's :=
  s num.names$ 'numnames :=
  numnames #1 >
    { numnames #4 >
	{ #3 'namesleft := }
	{ numnames 'namesleft := }
      if$
      #1 'nameptr :=
      ""
	{ namesleft #0 > }
	{ nameptr numnames =
	    { s nameptr "{ff }{vv }{ll}{ jj}" format.name$ "others" =
		{ "+" *
		  #1 'et.al.char.used :=
		}
		{ s nameptr "{v{}}{l{}}" format.name$ * }
	      if$
	    }
	    { s nameptr "{v{}}{l{}}" format.name$ * }
	  if$
	  nameptr #1 + 'nameptr :=
	  namesleft #1 - 'namesleft :=
	}
      while$
      numnames #4 >
	{ "+" *
	  #1 'et.al.char.used :=
	}
	'skip$
      if$
    }
    { s #1 "{v{}}{l{}}" format.name$
      duplicate$ text.length$ #2 <
	{ pop$ s #1 "{ll}" format.name$ #3 text.prefix$ }
	'skip$
      if$
    }
  if$
}

FUNCTION {standart.format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " and " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}
FUNCTION {format.lab.names}{
	"alpha" is.in.list
		'alpha.format.lab.names
	  'standart.format.lab.names
	if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
	{ cite$ #1 #3 substring$ }
	{ key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
	{ key empty$
%	    { cite$ #1 #3 substring$ }
	    { "zzz" }
	    { key #3 text.prefix$ }
	  if$
	}
	{ editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
	{ organization empty$
%	    { cite$ #1 #3 substring$ }
	    { "zzz" }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
	{ organization empty$
%	    { cite$ #1 #3 substring$ }
	    { "zzz" }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
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
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list

  "alpha" is.in.list
  {
    duplicate$
    year field.or.null purify$ #-1 #2 substring$
    *
    'label :=
    year field.or.null purify$ #-1 #4 substring$
    *
    sortify 'sort.label :=
  }
  {
    "("
    *
    year duplicate$ empty$
    short.list key field.or.null = or
      { pop$ "" }
      'skip$
    if$
    *
    'label :=
    label 'sort.label :=
  } 
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * 
          "alpha" is.in.list
            'skip$
            {numnames int.to.str$ * "   " *}
          if$
        }
        'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = 
      t "others" = 
      and
        { "et al" * }
        { t sortify * }
      if$
		#3 numnames  <
		"alpha" is.in.list not
		and
  			{#0 'namesleft :=
  				 	" zzz   " *
  			}    
	      {
	     	  nameptr #1 + 'nameptr :=
  	    	namesleft #1 - 'namesleft :=
  	    }
  	  if$  	
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
          "zzz"
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
              "z"
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
              "z"
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
              "z"
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
{ calc.label
  sort.label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
 		{author empty$
   		'editor.organization.sort
      'author.organization.sort
     if$
    }
    { type$ "proceedings" =
      type$ "incollection" =
       or
    		{author empty$
        		'editor.organization.sort
            'author.organization.sort
        if$
        }
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
  #1 entry.max$ substring$ 'sort.label :=
  sort.label *
  #1 entry.max$ substring$ 'sort.key$ :=
  
  "settings" type$ =
  	{"aaa"}
  	{"unsort" is.in.list
    	{"bb"}
    	{"alpha" is.in.list
    		{sort.key$}
    		{sort.label}
      	if$  
   		}
  	 if$
  	}
  	if$
  'sort.key$ :=
}


ITERATE {presort}

SORT

INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'j :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
%  cite$ "  " * extra.label * " label=" * label * top$
}

FUNCTION {reverse.pass}
{ j "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'j :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {write.preambule}
{   "\begin{thebibliography}{" number.label int.to.str$ * "}" * write$ newline$
	"% BibTex style file: spr-mp.bst (nameyear,cnd), 2011-05-27" write$ newline$
	"\ifx \bisbn   \undefined \def \bisbn  #1{ISBN #1}\fi" write$ newline$
	"\ifx \binits  \undefined \def \binits#1{#1} \fi" write$ newline$
	"\ifx \bauthor  \undefined \def \bauthor#1{#1} \fi" write$ newline$
	"\ifx \batitle  \undefined \def \batitle#1{#1} \fi" write$ newline$
	"\ifx \bjtitle  \undefined \def \bjtitle#1{#1}\fi" write$ newline$ 
	"\ifx \bvolume  \undefined \def \bvolume#1{\textbf{#1}}\fi" write$ newline$
	"\ifx \byear  \undefined \def \byear#1{#1} \fi" write$ newline$
	"\ifx \bissue  \undefined \def \bissue#1{#1} \fi" write$ newline$
	"\ifx \bfpage  \undefined \def \bfpage#1{#1} \fi" write$ newline$
	"\ifx \blpage  \undefined \def \blpage #1{#1} \fi" write$ newline$
	"\ifx \burl  \undefined \def \burl#1{\textsf{#1}} \fi" write$ newline$
	"\ifx \doiurl  \undefined \def \doiurl#1{\textsf{#1}} \fi" write$ newline$
	"\ifx \betal  \undefined \def \betal{\textit{et al.}} \fi" write$ newline$
	"\ifx \binstitute  \undefined \def \binstitute#1{#1} \fi" write$ newline$
	"\ifx \binstitutionaled  \undefined \def \binstitutionaled#1{#1} \fi" write$ newline$
	"\ifx \bctitle  \undefined \def \bctitle#1{#1} \fi" write$ newline$
	"\ifx \beditor  \undefined \def \beditor#1{#1} \fi" write$ newline$
	"\ifx \bpublisher  \undefined \def \bpublisher#1{#1} \fi" write$ newline$
	"\ifx \bbtitle  \undefined \def \bbtitle#1{#1} \fi" write$ newline$
	"\ifx \bedition  \undefined \def \bedition#1{#1} \fi" write$ newline$
	"\ifx \bseriesno  \undefined \def \bseriesno#1{#1} \fi" write$ newline$
	"\ifx \blocation  \undefined \def \blocation#1{#1} \fi" write$ newline$
	"\ifx \bsertitle  \undefined \def \bsertitle#1{#1} \fi" write$ newline$
	"\ifx \bsnm \undefined \def \bsnm#1{#1} \fi" write$ newline$
	"\ifx \bsuffix \undefined \def \bsuffix#1{#1} \fi" write$ newline$
	"\ifx \bparticle \undefined \def \bparticle#1{#1} \fi" write$ newline$
	"\ifx \barticle \undefined \def \barticle#1{#1} \fi" write$ newline$
	
}


FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  write.preambule
  	"\ifx \bconfdate \undefined \def \bconfdate #1{#1} \fi" write$ newline$
  	"\ifx \botherref \undefined \def \botherref #1{#1} \fi" write$ newline$
  	"\ifx \url \undefined \def \url#1{\textsf{#1}} \fi" write$ newline$
	"\ifx \bchapter \undefined \def \bchapter#1{#1} \fi" write$ newline$
	"\ifx \bbook \undefined \def \bbook#1{#1} \fi" write$ newline$
	"\ifx \bcomment \undefined \def \bcomment#1{#1} \fi" write$ newline$
	"\ifx \oauthor \undefined \def \oauthor#1{#1} \fi" write$ newline$
	"\ifx \citeauthoryear \undefined \def \citeauthoryear#1{#1} \fi" write$ newline$
	"\ifx \endbibitem  \undefined \def \endbibitem {}\fi" write$ newline$
	"\ifx \bconflocation  \undefined \def \bconflocation#1{#1} \fi" write$ newline$
	"\ifx \arxivurl  \undefined \def \arxivurl#1{\textsf{#1}} \fi" write$ newline$
}
EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
 "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}




