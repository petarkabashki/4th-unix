\ Tiny CLI Spreadsheet - Copyright 2010,2013 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/zenfloat.4th               \ For F+, F-, etc.
include lib/zenans.4th                 \ For ANS FLOAT interface
include lib/fpin.4th                   \ For >FLOAT
include lib/fpout.4th                  \ For (F.) F.S
include lib/evaluate.4th               \ for EVALUATE
include lib/range.4th                  \ for WITHIN
include lib/allsheet.4th               \ for spreadsheet exports

   3 constant #decimals                \ maximum number of decimals
  12 constant #column                  \ number of columns
  32 constant #row                     \ number of rows
   6 constant max-x                    \ maximum number of columns to display
  16 constant max-y                    \ maximum number of rows to display
  12 constant /column                  \ size of column in characters
 128 constant /element                 \ maximum size of formula
true constant Multitask?               \ compile for multitasking version?
                                       \ supported file formats
0 enum csv enum xml enum ksp enum html constant fods

/column value length                   \ length when printing a string
  false value string?                  \ boolean to indicate string
      0 value depth'                   \ for saving stack depth
      0 value decimals                 \ number of decimals
      0 value x                        \ current column number
      0 value y                        \ current row number

#column #row * constant #elements      \ number of elements in sheet
#elements /element * constant /elements
                                       \ size of spreadsheet in memory
/elements buffer: element              \ allocate memory for spreadsheet
  does> rot #column * rot 0 max #row 1- min + /element * + ;
                                       \ return address of element ( r c -- a)
: val element count evaluate ;         ( a -- ..)
: clear depth depth' ?do drop loop false to string? ;
: .string parse length min 0 parse 2drop true dup to string? ;
: .error ." Cannot open " type cr ;    ( a n --)
                                       \ display control words
: << - 0 max ;                         ( v n1 -- n2) 
: >> over - >r + r> min ;              ( v n1 n2 -- n3)
: show? over + within ;                ( n1 n2 n3 -- f)
: x? x max-x show? ;                   ( n -- f)
: y? y max-y show? ;                   ( n -- f)
: xy? x? swap y? and ;                 ( n1 n2 -- f)
: ?row# dup y? if 2 .r space else drop then ;
: ?cr y? if cr then ;                  ( x --)
: (file?) open error? dup 0= >r if drop .error else nip nip then r> ;
: file? >r [char] " parse 2dup r> (file?) ;
                                       \ print formula of a cell
: .line                                ( row col --)
  over over element count dup          \ copy row/column
  if                                   \ is length greater than zero?
    2>r swap . [char] a + emit ."  = " 2r> type cr
  else                                 \ print the formula, otherwise
    2drop drop drop                    \ drop all values
  then
;
                                       \ print value of cell for export
: Cell.tk                              ( man exp | a n f --)
  string? if                           \ is it a string?
    drop TKtype                        \ then type it
  else                                 \ is it a number?
    depth 1- depth' - 0> if maxdigits (f.) TK# else pad 0 TKtype then
  then                                 \ construct number and type it
;
                                       \ print value of a cell
: .cell                                ( .. n --)
   string? if                          \ it is a string?
      swap >r over - 0 max r> if -rot type spaces else spaces type then
   else                                \ otherwise determine stack depth
      depth 1- depth' - 0> if decimals swap f.r else spaces then
   then                                \ and print the value or just spaces
;
                                       \ conditionally print a cell
: ?cell xy? if .cell else drop then ;  ( .. n y x --)
                                       \ print the header
: .header                              ( --)
  3 spaces x max-x bounds do /column 1- spaces i [char] A + emit loop cr
;
                                       \ ** all formula operations **
: _+ f+ ;                              \ addition
: _- f- ;                              \ subtraction
: _* f* ;                              \ multiplication
: _/ f/ ;                              \ division
: _" [char] " .string ;                \ print string left aligned
: _' [char] ' .string 0= ;             \ print string right aligned
: _a f>s 0 val ;                       \ calculate formula in column A
: _b f>s 1 val ;                       \ calculate formula in column B
: _c f>s 2 val ;                       \ calculate formula in column C
: _d f>s 3 val ;                       \ calculate formula in column D
: _e f>s 4 val ;                       \ calculate formula in column E
: _f f>s 5 val ;                       \ calculate formula in column F
: _g f>s 6 val ;                       \ calculate formula in column G
: _h f>s 7 val ;                       \ calculate formula in column H
: _i f>s 8 val ;                       \ calculate formula in column I
: _j f>s 9 val ;                       \ calculate formula in column J
: _k f>s 10 val ;                      \ calculate formula in column K
: _l f>s 11 val ;                      \ calculate formula in column L
                                       \ map words to strings
create calculation
  ," +" ' _+ ,
  ," -" ' _- ,
  ," *" ' _* ,
  ," /" ' _/ ,
  ," a" ' _a ,
  ," b" ' _b ,
  ," c" ' _c ,
  ," d" ' _d ,
  ," e" ' _e ,
  ," f" ' _f ,
  ," g" ' _g ,
  ," h" ' _h ,
  ," i" ' _i ,
  ," j" ' _j ,
  ," k" ' _k ,
  ," l" ' _l ,
  ,| "| ' _" ,
  ," '" ' _' ,
  null ,
                                       \ ** spreadsheet commands **
: a' f>s 0 element ;                   \ return address of column A
: b' f>s 1 element ;                   \ return address of column B
: c' f>s 2 element ;                   \ return address of column C
: d' f>s 3 element ;                   \ return address of column D
: e' f>s 4 element ;                   \ return address of column E
: f' f>s 5 element ;                   \ return address of column F
: g' f>s 6 element ;                   \ return address of column G
: h' f>s 7 element ;                   \ return address of column H
: i' f>s 8 element ;                   \ return address of column I
: j' f>s 9 element ;                   \ return address of column J
: k' f>s 10 element ;                  \ return address of column K
: l' f>s 11 element ;                  \ return address of column L
: _= 0 parse /element 1- min rot place ;
: _? count type cr ;                   ( a --)
: _clear depth . ." items removed " 0 to depth' clear ;
: _copy >r count r> place ;            ( a1 a2 --)
: _erase 0 over place ;                ( a --)
: _move over >r _copy r> _erase ;      ( a1 a2 --)
: _decimals f>s #decimals min 0 max to decimals ;
: _csv csv ;                           ( -- n)
: _xml xml ;                           ( -- n)
: _fods fods ;                         ( -- n)
: _ksp ksp ;                           ( -- n)
: _html html ;                         ( -- n)
: home 0 dup to x to y ;               ( --)
: left x max-x << to x ;               ( --)
: right x max-x #column >> to x ;      ( --)
: up y max-y << to y ;                 ( --)
: down y max-y #row >> to y ;          ( --)
: bye quit ;                           ( --)

Multitask? [IF]                        \ multitasking version
: _pause pause ;                       \ pause command
[THEN]
                                       \ load a .TCS file
: (load)                               ( h f | -f --)
  if                                   \ open file, if successful
    dup use                            \ USE file handle
    begin refill while ['] interpret catch if ." Bad formula" cr then repeat
    close                              \ evaluate commands
  then
;
                                       \ commands to load a .TCS file
: (boot) 2dup input (file?) (load) ;   ( a n --)
: load input file? (load) ;            ( --)
: boot to dictionary argn if argn 1 ?do i args (boot) loop then ;
                                       \ show the spreadsheet
: show                                 ( --)
  /column to length                    \ print no longer than column width
  calculation to dictionary            \ set dictionary to formula
  .header #row 0 do                    \ print header
    i ?row#                            \ print row number if needed
    #column 0 do depth to depth' j i val /column j i ?cell clear loop
    i ?cr                              \ print CR if needed
  loop                                 \ for each cell, evaluate formula
;                                      \ and calculate value
                                       \ determine printable range
: get-range                            ( -- #column #row)
  calculation to dictionary 0 dup      \ set dictionary to formula
  #row 0 do                            \ scan the entire spreadsheet
    #column 0 do depth to depth' j i val
      string? if                       \ if it is a string, print it
        drop 2drop drop i max j
      else                             \ if it is a number, print it
        depth 1- depth' - 0> if fdrop drop i max j then
      then clear                       \ remove any garbage from stack
    loop                               \ next column
  loop                                 \ next loop
;
                                       \ export to spreadsheet
: Export.tk                            ( n --)
  TKformat drop [char] " parse 2dup TKopen
  if                                   \ open file, if error
    .error                             \ display a message
  else                                 \ if successful
    2drop get-range                    \ determine printable range
    s" TinySpread" TKsheet             \ open sheet
    1+ 0 do                            \ print entire range
      dup 1+ 0 do depth to depth' j i val Cell.tk clear loop TKcr
    loop drop TKend TKclose            \ according to the chosen format
  then                                 \ calculate value and write to file
;
                                       ( --)
: export.csv CSV! Export.tk ;          \ export to .CSV
: export.ksp KSP! Export.tk ;          \ export to .KSP
: export.xml XML! Export.tk ;          \ export to .XML
: export.fods FODS! Export.tk ;        \ export to .FODS
: export.html HTML! Export.tk ;        \ export to .HTML

create export                          \ link words to formats
  csv  , ' export.csv ,                \ comma separated values
  xml  , ' export.xml ,                \ MS XML 2003
  ksp  , ' export.ksp ,                \ KOffice KSP
  fods , ' export.fods ,               \ OOo FODS
  html , ' export.html ,               \ HTML 4.01 Transitional
  null ,
does>
  /element to length                   \ print full length strings
  2 num-key row if                     \ search format
    nip cell+ @c execute               \ if found, execute  
  else                                 \ if not found,
    drop drop ." Unknown format" cr 0 parse 2drop
  then                                 \ issue error message and drop command
;                                      \ if found execute else error
                                       \ save a .TCS file
: save                                 ( --)
  output file? if                      \ open file, if successful
    dup use #row 0 do #column 0 do j i .line loop loop close
  then                                 \ write formula to file if not empty
;
                                       \ show help
: help                                 ( --)
  ." :: Commands" cr
  .|   Load sheet     : load" string"| cr
  .|   Save sheet     : save" string"| cr
  .|   Export sheet   : <format> export" string"| cr
  ."   Show sheet     : ." cr
  ."   Clear stack    : clear" cr
  ."   Show help      : help" cr
  ."   Goto topleft   : home" cr
  ."   Move left      : left" cr
  ."   Move right     : right" cr
  ."   Move up        : up" cr
  ."   Move down      : down" cr
  ."   Decimal places : <integer> decimals" cr
  ."   Enter formula  : <row> <column> = <formula>" cr
  ."   Copy formula   : <row> <column> <row> <column> copy" cr
  ."   Move formula   : <row> <column> <row> <column> move" cr
  ."   Erase formula  : <row> <column> erase" cr
  ."   Show formula   : <row> <column> ?" cr
Multitask? [IF]
  ."   Pause TCS      : pause" cr
[THEN]
  ."   Exit TCS       : exit" cr cr
  ." :: Formula" cr
  ."   <format>       : XML, FODS, KSP, HTML or CSV" cr
  ."   <row>          : positive integer" cr
  ."   <column>       : A, B, C etc." cr
  ."   <cell>         : <row> <column>" cr
  ."   <literal>      : any number" cr
  ."   <primitive>    : <literal> or <cell>" cr
  ."   <operator>     : +, -, * or /" cr
  ."   <term>         : <primitive> <primitive> <operator>" cr
  ."   <expression>   : <term> <term> <operator>" cr
  .|   <string>       : " string" or ' string'| cr
  ."   <formula>      : <string> or <expression>" cr
;
                                       \ map words to strings
create wordlist
 ," ."        ' show ,
 ," a"        ' a' ,
 ," b"        ' b' ,
 ," c"        ' c' ,
 ," d"        ' d' ,
 ," e"        ' e' ,
 ," f"        ' f' ,
 ," g"        ' g' ,
 ," h"        ' h' ,
 ," i"        ' i' ,
 ," j"        ' j' ,
 ," k"        ' k' ,
 ," l"        ' l' ,
 ," ="        ' _= ,
 ," ?"        ' _? ,
 ," xml"      ' _xml ,
 ," fods"     ' _fods ,
 ," ksp"      ' _ksp ,
 ," csv"      ' _csv ,
 ," html"     ' _html ,
 ,| save"|    ' save ,
 ,| load"|    ' load ,
 ,| export"|  ' export ,
 ," help"     ' help ,
 ," clear"    ' _clear ,
 ," copy"     ' _copy ,
 ," erase"    ' _erase ,
 ," move"     ' _move ,
 ," decimals" ' _decimals ,
 ," home"     ' home ,
 ," left"     ' left ,
 ," right"    ' right ,
 ," up"       ' up ,
 ," down"     ' down ,
 ," bye"      ' bye ,
 ," exit"     ' bye ,
 ," quit"     ' bye ,
Multitask? [IF]
 ," pause"    ' _pause ,               \ special words multitasking version
[THEN]
 null ,

: tcs
  wordlist boot                        \ boot any .TCS files if needed
  begin                                \ show the prompt and get a command
    wordlist to dictionary             \ set the correct dictionary
    ." OK" cr refill drop              \ interpret and issue oops when needed
    ['] interpret catch if ." Oops! " then
  again                                \ repeat command loop eternally
;

tcs
