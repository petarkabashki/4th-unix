\ 4tH library - HTML generation - Copyright 2014, 2016 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[UNDEFINED] begins   [IF]
[UNDEFINED] utf8type [IF] include lib/utf8type.4th [THEN]
[UNDEFINED] row      [IF] include lib/row.4th      [THEN]

variable (row)                         \ type of table row
variable (section) 0 (section) !       \ keeps track of section nesting

  0 enum %enumerate                    \ for ordered list
    enum %itemize                      \ for onordered list
    enum %description                  \ for description list
    enum %quote                        \ for blockquotes
    enum %verse                        \ for blockquotes
    enum %listing                      \ for preformatted
    enum %table                        \ for tables
    enum %center                       \ for centered sections
    enum %paragraph                    \ for paragraphs
    enum %style                        \ for style
constant %tablefloat                   \ dummy, latex compatibility

create (blocktag)                      \ translates constants to tags
  %enumerate   ,  ," ol"
  %description ,  ," dl"
  %itemize     ,  ," ul"
  %quote       ,  ," blockquote"
  %verse       ,  ," blockquote"
  %listing     ,  ," pre"
  %table       ,  ," table"
  %center      ,  ," center"
  %style       ,  ," style"
  %paragraph   ,  ," p"
  NULL ,
does>                                  ( xt n --)
  2 num-key row if nip cell+ @c count rot execute cr else drop drop drop then
;
                                       \ some basic tag formatting
: (begins) ." <"  type ." >" ;         ( a n --)
: (ends)   ." </" type ." >" ;         ( a n --)
: (enclose) 2dup (begins) 2swap utf8type (ends) ;
: (embed) (enclose) space ;            ( a1 n1 a2 n2 --)
: begins ['] (begins) swap (blocktag) ;
: ends ['] (ends) swap (blocktag) ;    ( n --)

  0 enum (th-td)                       \ first cell TH, then TD
    enum (td-td)                       \ first cell TD, then TD
    enum (td-th)                       \ first cell TD, then TH
constant (th-th)                       \ first cell TH, then TH

1 cells constant (cell_1)              \ take first field
2 cells constant (cell+1)              \ take second field
                                       \ translate format to tags
create (.cell)
  (th-td) , ," th" ," td"
  (th-th) , ," th" ," th"
  (td-td) , ," td" ," td"
  (td-th) , ," td" ," th"
  NULL ,
does>                                  ( a1 n1 type format --)
  3 num-key row                        \ try to find the format
  if
    nip swap + @c count (enclose)      \ print the cell and its contents
  else                                 \ if format not found
    drop drop drop 2drop               \ forget the whole thing
  then
;
                                       \ initialize document
: %beginHTML                           ( --)
  .| <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" |
  .| "http://www.w3.org/TR/html4/loose.dtd">| cr
  .| <html>| cr
  .| <head>| cr
  .| <meta http-equiv="content-type" content="text/html; charset=utf-8">| cr
  .| <meta name="generator" |
  .| content="http://freecode.com/projects/4th/">| cr
;
                                       \ select stylesheet
: %styleSheet                          ( a n --)
  .| <link rel="stylesheet" href="| type .| " type="text/css">| cr
;
                                       \ print title and author
: %htmlTitle                           ( a1 n1 a2 n2 f --)
  drop 2swap .| <meta name="author" content="| utf8type .| ">| cr
  s" title" (embed) cr ." </head>" cr ." <body>" cr
;
                                       \ print a table row
: (.row)                               ( a1 n1 .. ax nx n2 n3 --)
  (row) ! 1- dup                       \ decrement index, reverse strings
  begin dup while 1- rot >r rot >r repeat
  drop -rot ." <tr>" (cell_1) (row) @ (.cell)
  begin dup while 1- r> r> (cell+1) (row) @ (.cell) repeat
  drop ." </tr>" cr                    \ print rest of strings, end row
;
                                       \ different forms of row
: %heads  (th-th) (.row) ;             ( a1 n1 .. ax nx n2 --)
: %cells  (td-td) (.row) ;             ( a1 n1 .. ax nx n2 --)
: %hcells (th-td) (.row) ;             ( a1 n1 .. ax nx n2 --)

create (tableSection)                  \ take care of section nesting
  ," h1"
  ," h2"
  ," h3"
  ," h4"
  ," h5"                               \ variable nested sectioning control
  ," h6"                               ( n1 -- a1 n2)
does> swap 5 min cells + @c count (enclose) cr ;
                                       \ a lot of public formatting words
: %subSection (section) @ (tableSection) 1 (section) +! ;
: %endSection -1 (section) +! ;        ( --)
: %endHTML ." </body>" cr ." </html>" cr ;
: %setStyle .| <div class="| type .| ">| cr ;
: %endStyle ." </div>" cr ;            ( --)
: %bold s" b" (embed) ;                ( a n --)
: %italic s" i" (embed) ;              ( a n --)
: %double s" q" (embed) ;              ( a n --)
: %link .| <a href="| type .| ">| utf8type ." </a>" space ;
: %caption s" caption" (enclose) cr ;  ( a n --)
: %typewriter s" tt" (embed) ;         ( a n --)
: %item s" li" (enclose) cr ;          ( a n --)
: %describe 2swap s" dt" (enclose) s" dd" (enclose) cr ;
: %line ." <hr>" cr ;                  ( --)
: %cr ." <br>" cr ;                    ( --)
: %print utf8type space ;              ( a n --)
: %layout 2drop ;                      ( a n --)

aka %double %single                    ( a n --)

[DEFINED] 4TH# [IF]
  hide (row)
  hide (section)
  hide (blocktag)
  hide (begins)
  hide (ends)
  hide (enclose)
  hide (embed)
  hide (th-td)
  hide (td-td)
  hide (td-th)
  hide (th-th)
  hide (cell_1)
  hide (cell+1)
  hide (.cell)
  hide (.row)
  hide (tableSection)
[THEN]
[THEN]
