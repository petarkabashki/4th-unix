\ Copyright 2005,2020 - J.L. Bezemer
\ Converts 4tH source files to Graphviz DOT sourcefiles
\ http://www.graphviz.org

\ -- INPUT FORMAT --
\ o Plain text files, certain block files
\ -- INPUT FORMAT --

\ -- BUGS & LIMITATIONS --
\ o EXECUTE is not evaluated
\ o INCLUDE files and conditional compilation are not evaluated
\ o Very long lines may not parsed correctly
\ o Case sensitivity might be a problem
\ o Only small embedded :NONAME definitions are parsed correctly
\ -- BUGS & LIMITATIONS --

include lib/replace.4th
include lib/row.4th
include lib/anscore.4th

            9 constant tab             \ TAB character
          256 constant #node           \ max. number of nodes
    width 1 + constant /node           \ size per nodes
          512 constant #edge           \ max. number of edges
    width 5 * constant /edge           \ size per edge
    width 2 * constant /expansion      \ size of expansion buffer

#node /node * string nodes             \ array for nodes
#edge /edge * string edges             \ array for edges
        /node string this-data         \ current data name
        /node string this-node         \ current node buffer
        /edge string this-edge         \ current edge buffer
   /expansion string expansion         \ expansion buffer

variable top-node                      \ top of node buffer
variable top-edge                      \ top of edge buffer

s| "| sconstant quote                  \ a double quote
bl value delimiter                     \ the delimiter
                                       \ array of escape sequences
create escapes
  ,| \| ,| \\|                         \ slashes
  ,| "| ,| \"|                         \ double quotes
  ,| '| ,| \'|                         \ single quotes
  NULL ,
                                       \ general definitions
: >edge /edge * edges + ;              ( n -- a)
: colon? this-node count dup 0> ;      ( -- a n f)
: clear-tabs tib count bounds do i c@ tab = if bl i c! then loop ;
                                       \ returns false when refill fails
: word>                                ( c -- a n f)
  to delimiter                         \ save delimiter
  begin
    delimiter parse-word dup           \ parse word
    if dup exit then                   \ if not zero, return true
    refill clear-tabs                  \ refill and clear tabs
  while                                \ as long as refill works
    2drop                              \ clear previously parsed string
  repeat false                         \ refill failed
;
                                       \ escape a quoted word
: escape-name                          ( a1 n1 -- a2 n2)
  expansion place expansion count      \ save temp string
  escapes >r                           \ save escape array address
  begin
    r@ @c dup NULL <>                  \ we didn't retrieve NULL?
  while
    count r@ cell+ @c count replaceall \ escape all defined
    r> cell+ cell+ >r                  \ increase pointer
  repeat
  drop r> drop                         \ clean up
;
                                       \ is edge unique?
: unique?                              ( -- f)
  true top-edge @ 0 ?do                \ loop till top of edge array
    drop this-edge count i >edge count compare
    dup 0= if leave then               \ if not unique return false
  loop
;
                                       \ edge definitions
: +edge! this-edge count 2dup top-edge @ >edge place 1 top-edge +! type cr ;
: edge! 0 this-edge c! ;               ( --)
: +edge this-edge +place ;             ( a n --)
: "> quote +edge ;                     ( --)
: ;> s" ;" +edge ;                     ( --)
: node> "> escape-name +edge "> ;      ( a n --)
: +edge? edge! node> s"  -> " +edge node> ;> unique? if +edge! then ;
                                       \ parser definitions
: word>> begin bl word> while 2over compare 0= until 2drop ;
: >>;] s" ;]" word>> ;                 ( --)
: next-word word> drop ;               ( c -- a n)
: discard next-word 2drop ;            ( c --)
: >) [char] ) discard ;                ( --)
: >| [char] | discard ;                ( --)
: >" [char] " discard ;                ( --)
: >] [char] ] discard ;                ( --)
: >; [char] ; discard ;                ( --)
: >bl bl discard ;                     ( --)
: >lf 0 discard ;                      ( --)
                                       \ node definitions
: >node /node * nodes + ;              ( n -- a)
: node@ >node count ;                  ( n1 -- a n2)
: +node! 2dup top-node @ >node place 1 top-node +! ;
: vector! bl next-word +node! 2drop ;  ( --)
: colon! bl next-word +node! this-node place ;
: does! this-data count +node! this-node place ;
: data! bl next-word this-data place ; ( --)
: semicolon! 0 this-node c! ;          ( --)
: recurse! colon? if 2dup +edge? else 2drop then ;
                                       ( --)
create parsing                         \ keywords and actions
  ," \"           ' >lf ,
  ," #!"          ' >lf ,
  ," ("           ' >) ,
  ," .("          ' >) ,
  ," .|"          ' >| ,
  ," ,|"          ' >| ,
  ," s|"          ' >| ,
  ," c|"          ' >| ,
  ," [needs"      ' >] ,
  ," :noname"     ' >; ,
  ," [:"          ' >>;] ,
  ," char"        ' >bl ,
  ," [char]"      ' >bl ,
  ," include"     ' >bl ,
  ," [defined]"   ' >bl ,
  ," [undefined]" ' >bl ,
  ," is"          ' >bl ,
  ," '"           ' >bl ,
  ," [']"         ' >bl ,
  ," :redo"       ' colon! ,
  ," :"           ' colon! ,
  ," does>"       ' does! ,
  ," string"      ' data! ,
  ," buffer:"     ' data! ,
  ," create"      ' data! ,
  ," array"       ' data! ,
  ," ;"           ' semicolon! ,
  ," defer"       ' vector! ,
  ," recurse"     ' recurse! ,
  ,| abort"|      ' >" ,
  ,| throw"|      ' >" ,
  ,| ,"|          ' >" ,
  ,| ."|          ' >" ,
  ,| s"|          ' >" ,
  ,| c"|          ' >" ,
  NULL ,
                                       \ is this a node?
: node?                                ( a1 n1 a2 n2 -- a1 n1 a2 n2)
  2swap top-node @ 0 ?do               \ scan all existing nodes
    2dup i node@ compare 0=            \ if node is found
    if 2over 2over 2swap +edge? leave then
  loop                                 \ make a new edge
;                                      \ delete above 
                                       ( a n --)
: edge-detect colon? if node? then 2drop 2drop ;
                                       \ when inside a definition,
: PreProcess                           \ make a new edge if node found
  0 dup top-node ! top-edge !
  ." digraph forth {" cr
  ." node [color=lightblue2, style=filled];" cr
  ." ratio=1.0;" cr
;
                                       \ required by 'convert.4th'
: Read-file bl word> ;
: PostProcess 2drop [char] } emit cr ;
: Usage abort" Usage: 4th2dot 4th-source dot-source" ;

: Process
  parsing 2 string-key row 
  if nip nip cell+ @c execute else drop edge-detect then
;

include lib/convert.4th
