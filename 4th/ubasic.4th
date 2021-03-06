\ Small Basic by Herbert Schildt, 1988
\ Debugged, optimized, enhanced and converted to 4tH
\ J.L. Bezemer, 2009-2021

include lib/istype.4th                 \ for IS-ALPHA
include lib/row.4th                    \ for ROW
include lib/enter.4th                  \ for ENTER
include lib/choose.4th                 \ for CHOOSE
include lib/stack.4th                  \ for STACK
include lib/escape.4th                 \ for S>ESCAPE
include lib/ctos.4th                   \ for C>S
include lib/hash.4th                   \ for FNV1a
include lib/picture.4th                \ for PICTURE
include lib/bsearch.4th                \ for BSEARCH
include lib/dstrarrt.4th               \ for DS.BUILD
include lib/range.4th                  \ for WITHIN
include lib/power.4th                  \ for **
\ include lib/anstools.4th

   16 constant #for                    \ maximum nesting of FORs
   32 constant #gosub                  \ maximum nesting of GOSUBs
   64 constant #user                   \ maximum number of stack elements
  768 constant #label                  \ maximum number of labels
   26 constant #var                    \ maximum number of global variables
  256 constant #element                \ maximum number of array elements
  512 constant #local                  \ maximum number of local variables
16384 constant /program                \ maximum size of a uBASIC program
    4 constant /for                    \ maximum size of a FOR stack frame
                                       \ character constants
  8 constant /tab                      \ size of a tab
 10 constant lf                        \ ASCII of lf
  9 constant tab                       \ ASCII of tab
 13 constant <cr>                      \ ASCII of cr
  0 constant <null>                    \ ASCII of \0

      #user 1+ array dstack            \ user stack
     #gosub 1+ array gstack            \ GOSUB stack
#for /for * 1+ array fstack            \ FOR stack

#local array local                     \ locals stack
local #local cells + value frame       \ pointer to current frame

#element array element                 \ single array of uBasic

variable prog                          \ pointer to current execution

96 string  token                       \ holding current token
 1 string  token_type                  \ holding current token type
 1 string  tok                         \ holding current keyword type

/program buffer: program               \ program source buffer
   /hold buffer: picture$              \ picture buffer

#var array variables                   \ internal variables
 0 value pos                           \ position on screen
                                       \ label structure
struct
  field: name                          \ name of label
  field: location                      \ location of label
end-struct /label
                                       \ label table
#label /label * array label_table does> swap /label * + ;
                                       \ index the label table
16 string (search-key) does> >r r@ place r> ;
                                       \ temp. storage for binary search
[: swap 2* cells + @c ;] is get-key    \ key-retrieval function
[: >r count r> count compare ;] is b-compare

defer level2                           \ define level2
defer .number                          \ defer number generating routine
defer function                         \ defer FUNC() semantics
defer get_var,                         \ defer SET() component
                                       \ ** token types **
  0 enum {NONE}                        \ undetermined
    enum {DELIMITER}                   \ is a delimiter
    enum {VARIABLE}                    \ is a variable
    enum {NUMBER}                      \ is a number
    enum {KEYWORD}                     \ is a keyword
constant {QUOTE}                       \ is a quoted string
                                       \ ** keyword types **
  0 enum 'NOOP'                        \ dummy entry
    enum 'PRINT'                       \ PRINT
    enum 'WRITE'                       \ WRITE
    enum 'CLOSE'                       \ CLOSE
    enum 'REM'                         \ REM
    enum 'LET'                         \ LET
    enum 'INPUT'                       \ INPUT
    enum 'PUSH'                        \ PUSH
    enum 'GOTO'                        \ GOTO
    enum 'GOSUB'                       \ GOSUB
    enum 'RETURN'                      \ RETURN
    enum 'IF'                          \ IF
    enum 'ELSE'                        \ ELSE
    enum 'FOR'                         \ FOR
    enum 'NEXT'                        \ NEXT
    enum 'CONTINUE'                    \ CONTINUE
    enum 'BREAK'                       \ BREAK
    enum 'WHILE'                       \ WHILE
    enum 'UNTIL'                       \ UNTIL
    enum 'UNLOOP'                      \ UNLOOP
    enum 'LOCAL'                       \ LOCAL
    enum 'PARAM'                       \ PARAM
    enum 'END'                         \ END
    enum 'FINISHED'                    \ End of program
    enum 'THEN'                        \ THEN
    enum 'ENDIF'                       \ ENDIF
    enum 'TO'                          \ TO
    enum 'STEP'                        \ STEP
    enum 'EOS'                         \ End of statement
    enum 'EOL'                         \ End of line
    enum 'USING'                       \ USING
    enum 'TAB'                         \ TAB()
    enum 'CHR'                         \ CHR()
    enum 'SHOW'                        \ SHOW()
    enum 'POP'                         \ POP()
    enum 'TOS'                         \ TOS()
    enum 'RND'                         \ RND()
    enum 'ABS'                         \ ABS()
    enum 'SGN'                         \ SGN()
    enum 'ORD'                         \ ORD()
    enum 'AND'                         \ AND()
    enum 'OR'                          \ OR()
    enum 'XOR'                         \ XOR()
    enum 'NOT'                         \ NOT()
    enum 'SHL'                         \ SHL()
    enum 'FUNC'                        \ FUNC()
    enum 'TIME'                        \ TIME()
    enum 'LEN'                         \ LEN()
    enum 'VAL'                         \ VAL()
    enum 'STR'                         \ STR()
    enum 'CHAR'                        \ CHAR()
    enum 'PEEK'                        \ PEEK()
    enum 'CLIP'                        \ CLIP()
    enum 'CHOP'                        \ CHOP()
    enum 'COMP'                        \ COMP()
    enum 'JOIN'                        \ JOIN()
    enum 'DUP'                         \ DUP()
    enum 'ASK'                         \ ASK()
    enum 'FREE'                        \ FREE()
    enum 'NAME'                        \ NAME()
    enum 'LINE'                        \ LINE()
    enum 'USED'                        \ USED()
    enum 'OPEN'                        \ OPEN()
    enum 'READ'                        \ READ()
    enum 'TOK'                         \ TOK()
    enum 'HERE'                        \ HERE()
    enum 'SET'                         \ SET()
    enum 'MAX'                         \ MAX()
    enum 'MIN'                         \ MIN()
    enum 'IIF'                         \ IIF()
constant 'CMD'                         \ CMD()
                                       \ ** mapping tokens to keywords **
create keyword?                        \ this table must be SORTED!
  ," abs"      'ABS' ,
  ," and"      'AND' ,
  ," ask"      'ASK' ,
  ," break"    'BREAK' ,
  ," char"     'CHAR' ,
  ," chop"     'CHOP' ,
  ," chr"      'CHR' ,
  ," clip"     'CLIP' ,
  ," close"    'CLOSE' ,
  ," cmd"      'CMD' ,
  ," comp"     'COMP' ,
  ," continue" 'CONTINUE' ,
  ," do"       'FOR' ,
  ," dup"      'DUP' ,
  ," else"     'ELSE' ,
  ," end"      'END' ,
  ," endif"    'ENDIF' ,
  ," for"      'FOR' ,
  ," free"     'FREE' ,
  ," func"     'FUNC' ,
  ," gosub"    'GOSUB' ,
  ," goto"     'GOTO' ,
  ," here"     'HERE' ,
  ," if"       'IF' ,
  ," iif"      'IIF' ,
  ," input"    'INPUT' ,
  ," join"     'JOIN' ,
  ," len"      'LEN' ,
  ," let"      'LET' ,
  ," line"     'LINE' ,
  ," local"    'LOCAL' ,
  ," loop"     'NEXT' ,
  ," max"      'MAX' ,
  ," min"      'MIN' ,
  ," name"     'NAME' ,
  ," next"     'NEXT' ,
  ," not"      'NOT' ,
  ," open"     'OPEN' ,
  ," or"       'OR' ,
  ," ord"      'ORD' ,
  ," param"    'PARAM' ,
  ," peek"     'PEEK' ,
  ," pop"      'POP' ,
  ," print"    'PRINT' ,
  ," proc"     'GOSUB' ,
  ," push"     'PUSH' ,
  ," read"     'READ' ,
  ," rem"      'REM' ,
  ," return"   'RETURN' ,
  ," rnd"      'RND' ,
  ," set"      'SET' ,
  ," sgn"      'SGN' ,
  ," shl"      'SHL' ,
  ," show"     'SHOW' ,
  ," step"     'STEP' ,
  ," stop"     'END' ,
  ," str"      'STR' ,
  ," tab"      'TAB' ,
  ," then"     'THEN' ,
  ," time"     'TIME' ,
  ," to"       'TO' ,
  ," tok"      'TOK' ,
  ," tos"      'TOS' ,
  ," unloop"   'UNLOOP' ,
  ," until"    'UNTIL' ,
  ," used"     'USED' ,
  ," using"    'USING' ,
  ," val"      'VAL' ,
  ," while"    'WHILE' ,
  ," write"    'WRITE' ,
  ," xor"      'XOR' ,
  here keyword? - 2 / constant #keywords

:redo keyword?                         ( a1 n1 -- n2 f)
  >r (search-key) r@ #keywords bsearch r> over
  if rot 2* 1+ cells + @c swap ;then drop
;
                                       \ ** error constants **
  1 enum E.FINISHED                    \ program finished
    enum E.NOFOR                       \ previous FOR expected
    enum E.ASGMTEXP                    \ assignment expected
    enum E.MANYLBL                     \ too many labels
    enum E.DUPLBL                      \ duplicate label
    enum E.UDEFLBL                     \ undefined label
    enum E.BIGNUM                      \ integer out of range
    enum E.NOGOSUB                     \ previous GOSUB expected
    enum E.NESTFOR                     \ FOR nesting too deep
    enum E.NESTSUB                     \ GOSUB nesting too deep
    enum E.KEYEXP                      \ keyword expected
    enum E.MISSING                     \ delimiter expected
    enum E.SYNTAX                      \ syntax error
    enum E.EXPREXP                     \ expression expected
    enum E.STREXP                      \ string expected
    enum E.NOTVAR                      \ not a variable
    enum E.NOTFUNC                     \ not a function
    enum E.NOTSTR                      \ not a string
    enum E.MANYSTR                     \ too many strings
    enum E.STEMPTY                     \ stack empty
    enum E.STFULL                      \ stack full
    enum E.MANYLOC                     \ too many locals
    enum E.NOSCOPE                     \ out of scope
constant E.MEMLEAK                     \ memory leak detected
                                       ( n -- a n)
:token (number) dup abs <# #s sign #> ;
:token (picture) picture$ count picture (number) is .number ;
                                       \ determine error line and position
: line#                                ( -- n1 n2)
  program 0 dup >r                     \ initialize loop
  begin
    r@ #label <                        \ are we within range?
  while
    r@ label_table -> name @           \ label entry not empty?
  while
    r@ label_table -> location @ prog @ <
  while                                \ did program stop at this line?
    drop drop                          \ drop label and location
    r@ label_table -> location @       \ get new location
    r@ label_table -> name @           \ get new label
    r> 1+ >r                           \ increment index
  repeat
  r> drop prog @ rot - swap            ( position line)
;
                                       \ ** error messages **
create .error                          ( --)
  ," System failure"
  ," OK"
  ," NEXT, CONTINUE or BREAK without FOR"
  ," Assignment expected"
  ," Too many labels"
  ," Duplicate label"
  ," Undefined label"
  ," Number too big"
  ," RETURN without GOSUB"
  ," Too many nested FOR loops"
  ," Too many nested GOSUBs"
  ," ENDIF or NEXT expected"
  ," Delimiter expected"
  ," Nonsense in BASIC"
  ," Expression expected"
  ," String expected"
  ," Not a variable"
  ," Not a function"
  ," Not a string"
  ," Too many strings"
  ," Stack empty"
  ," Stack full"
  ," Too many locals"
  ," Out of scope"
  ," Memory leak detected"
does>                                  \ format message number
  over 0 max cells + @c cr count rot dup 0>
  if 1- 36 base ! . decimal else drop then
  type ." , " line# 0 .r [char] : emit 1- . cr
;                                      \ determine line and position

: arith                                \ map operators to words
  case
    [char] < of < ;endof               \ less-than operands
    [char] > of > ;endof               \ greater-than operands
    [char] = of = ;endof               \ compare operands
    [char] # of <> ;endof              \ not equal operands
    [char] - of - ;endof               \ subtract operands
    [char] + of + ;endof               \ add operands
    [char] * of * ;endof               \ multiply operands
    [char] / of / ;endof               \ divide operands
    [char] % of mod ;endof             \ modula operands
    [char] ^ of 0 max ** ;endof        \ exponent operands
  endcase
;

\ -- string GC begins --
256 constant #str                      \ number of strings

#str array strings                     \ dynamic strings located here
#str array freeMap                     \ freelist string space

variable #free                         \ free string space slots left
variable nextFree                      \ next slot free
                                       \ tests a string and decodes address
: string?                              ( n -- a f)
  dup highbit and if lowbits and dup strings dup #str th within ;then false
;
                                       \ makes a brand new freemap
: init_freemap                         ( --)
  #str 0 do strings i th freeMap i th ! loop #str #free ! freeMap nextFree !
;                                      \ everything is on the freemap again
                                       \ takes a valid pointer off the freemap
: used?                                ( n --)
  string? if strings - freeMap + (error) swap ! -1 #free +! ;then drop
;
                                       \ scans all globals for strings
: map_globals                          ( --)
  variables #var   cells bounds ?do i @ used? 1 cells +loop
  element #element cells bounds ?do i @ used? 1 cells +loop
  dstack dup @ cell+ swap cell+ ?do i @ used? 1 cells +loop
;
                                       \ scans the entire local vars stack
: map_locals                           ( --)
  frame dup @                          \ get starting values
  begin                                \ test an entire frams
    dup rot cell+ ?do i @ used? 1 cells +loop
    dup local #local cells + <         \ not the last frame?
  while
    dup @                              \ get the next frame
  repeat drop                          \ get rid of the frame pointer
;
                                       \ compact the freemap after GC
: compact_freemap                      ( --)
  freeMap dup #str cells bounds
  do i @ 0< unless i @ over ! cell+ then 1 cells +loop drop
;
                                       \ test all vars, get rid of garbage
: remap init_freemap map_locals map_globals compact_freemap ;

: (+string)                            ( a1 n1 -- ds)
  #free @ if                           \ clip the string, store it
    nextFree @ @ dup >r ds.place r> -1 #free +! 1 cells nextFree +!
  ;then remap #free @ if recurse ;then E.MANYSTR throw
;                                      \ no space? get rid of garbage

: +string (+string) highbit or ;       ( a n -- ds)
: +string+ 2swap (+string) dup >r ds+place r> highbit or ;
                                       ( a1 n1 a2 n2 -- ds)
\ -- string GC ends --

offset delims
  1  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \  0 -  7
  0  c, 1  c, 1  c, 0  c, 0  c, 1  c, 0  c, 0  c,  \  8 - 15
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 16 - 23
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 24 - 31
  1  c, 0  c, 0  c, 1  c, 0  c, 1  c, 0  c, 1  c,  \ 32 - 39
  1  c, 1  c, 1  c, 1  c, 1  c, 1  c, 0  c, 1  c,  \ 40 - 47
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 48 - 55
  0  c, 0  c, 1  c, 1  c, 1  c, 1  c, 1  c, 0  c,  \ 56 - 63
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 64 - 71
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 72 - 79
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 0  c,  \ 80 - 87
  0  c, 0  c, 0  c, 0  c, 0  c, 0  c, 1  c,        \ 88 - 94 (^)
\ EQUALS ;,+-<>/*%^=()#:' bl tab lf <cr> <null>
                                       ( c -- f)
: isdelim dup [char] ^ > if >zero ;then delims ;
: iswhite dup dup bl = swap tab = rot <cr> = or or ;
: skipwhite prog @ begin dup c@ iswhite while char+ repeat prog ! ;
: token_type= token_type c@ = ;        ( -- f)
: tok@ tok c@ ;                        ( -- n)
: stoken token count ;                 ( -- a n)
: ctoken token c@ ;                    ( -- c)
: putback stoken negate prog +! drop ; ( --)
: copy>character token c! 0 token char+ c! tok c! 1 prog +! {DELIMITER} ;
: done? tok@ dup 'EOL' = over 'FINISHED' = rot 'EOS' = or or ;

: number?                              ( -- n2)
  stoken over c@ is-digit              \ is it a number or a label?
  if number error? if E.BIGNUM throw then ;then chop fnv1a
;

: find_eol                             ( --)
  prog @ begin dup c@ while dup c@ lf <> while char+ repeat
  dup c@ if char+ then prog !
;
                                       \ using the FOR and GOSUB stacks
: fpush                                ( tar loc step var --)
  fstack adepth #for /for * <          \ stack within range?
  if /for 0 do fstack >a loop ;then E.NESTFOR throw
;

: fpop                                 ( -- tar loc step var)
  fstack adepth 0>                     \ stack within range?
  if /for 0 do fstack a> loop ;then E.NOFOR throw
;

: fscrap /for 0 do drop loop ;         ( tar loc step var --)
                                       \ make a local variable frame
: make_frame                           ( --)
  frame local > if frame dup cell- tuck ! to frame ;then E.MANYLOC throw
;
                                       ( n --)
: gpush gstack adepth #gosub < if gstack >a ;then E.NESTSUB throw ;
: gpop  gstack adepth 0> if gstack a> ;then E.NOGOSUB throw ;
                                       \ main parser routines
: copy>delimiter                       ( --)
  0 token prog @                       \ setup pointers and terminator
  begin                                \ start scanning
    dup c@ dup isdelim                 \ stop when a delimiter is found
  except                               \ if not, copy and increment pointers
    rot tuck c! char+ swap char+
  repeat drop prog ! c!                \ save values, terminate token
;

: =quote                               \ quoted string routine
  0 token prog 1 over +! @             \ setup pointers and terminator
  begin                                \ skip the first quote
    dup c@ dup [char] " <>             \ stop when a quote is found
  while
    lf = if E.MISSING throw then       \ error when EOL is found
    over over c@ swap c!               \ if not, copy character
    char+ swap char+ swap              \ and increment pointers
  repeat                               \ get next character
  drop char+ prog ! c! {QUOTE}         \ skip final quote, terminate token
;                                      \ and signal the type of token found
                                       ( -- n)
: =: 'EOS' [char] : copy>character ;
: =rem 'EOL' [char] ' copy>character find_eol ;
: =lf 'EOL' lf copy>character ;
: =null 0 token c! 'FINISHED' tok c! {DELIMITER} ;
: =delim 0 token prog @ c@ over c! char+ c! 1 prog +! {DELIMITER} ;
: =digit copy>delimiter {NUMBER} ;     ( -- n)
: =array copy>delimiter {VARIABLE} ;   ( -- n)

offset delimiters                      \ precalculated responses
  0 c, 0 c, 0 c, 1 c, 0 c, 1 c, 0 c, 0 c,  \ 32 - 39
  1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 0 c, 1 c,  \ 40 - 47
  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,  \ 48 - 55
  0 c, 0 c, 0 c, 1 c, 1 c, 1 c, 1 c, 0 c,  \ 56 - 63
  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,  \ 64 - 71
  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,  \ 72 - 79
  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,  \ 80 - 87
  0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 1 c,       \ 88 - 94

: bnf                                  ( c -- c n)
  dup is-digit if =digit ;then         \ filter out digits
  dup bl 1- > over [char] ^ 1+ < and   \ filter out delimiters
  if dup bl - delimiters if =delim ;then then
                                       \ consult the table
  dup case                             \ now take care of the rest
           0 of =null  ;endof
          lf of =lf    ;endof
    [char] : of =:     ;endof
    [char] " of =quote ;endof
    [char] _ of =digit ;endof
    [char] @ of =array ;endof
    [char] ' of =rem   ;endof
    {NONE} swap
  endcase
;

: get_token                            ( --)
  'NOOP' tok c! skipwhite              \ skip all leading white space
  prog @ c@ bnf dup {NONE} =           \ not found in the table above?
  if                                   \ if so,
    swap is-alpha                      \ is it an alpha character?
    if                                 \ if so,
      drop copy>delimiter              \ copy all upto the delimiter
      stoken keyword?                  \ see if it is a keyword or var
      if tok c! {KEYWORD} else drop {VARIABLE} then
    else                               \ is it a variable or command
      0 token c!                       \ terminate whatever is in the token
    then
  else                                 \ if found in the table
    nip                                \ drop the character
  then token_type c!                   \ update the token_type
;
                                       ( --)
: label_init #label 0 ?do 0 i label_table -> name ! loop ;

: get_next_label                       ( n1 -- n2)
  >r 0                                 \ setup counter, save string
  begin
     dup dup #label <                  \ table full?
  while                                \ entry empty?
     drop dup label_table -> name @ dup
  while                                \ label already defined?
     r@ = if E.DUPLBL throw then 1+
  repeat
  drop r> drop                         \ cleanup, save label table pointer
  dup #label = if E.MANYLBL throw then
;                                      \ table full, exit

: scan_labels                          ( --)
  label_init prog @                    \ save prog and init labels
  begin                                \ see if the next token is a number
    get_token {NUMBER} token_type=
    if                                 \ if so, add it to the label table
      number? dup get_next_label dup >r
      label_table -> name ! prog @ r>
      label_table -> location !
    then                               \ we don't need the rest of the line
    tok@ dup 'EOL' <> if find_eol then
    'FINISHED' =                       \ are we finished yet?
  until prog !                         \ if so, restore prog
;

: get_label                            ( n1 -- n2 f)
  >r 0 begin                           \ setup counter, save string
    dup #label <                       \ within range?
  while                                \ compare labels
    dup label_table -> name @ r@ <>    \ get the name of the label
  while                                \ if found, exit loop
    1+                                 \ next entry
  repeat r> drop                       \ discard the string
  dup #label <                         \ is it a valid label?
;
                                       ( n f -- a)
: find_label get_label if label_table -> location @ ;then E.UDEFLBL throw ;

: ctoken> get_token ctoken ;           ( -- c)
: get, ctoken> [char] , <> if E.MISSING throw then ;
: get_exp 0 ctoken> if level2 putback ;then E.EXPREXP throw ;
: paren? ctoken [char] ( = {DELIMITER} token_type= and ;
: exp,exp get_exp get, get_exp ;
: string@ string? if ds.count ;then E.NOTSTR throw ;

: string>                              ( -- addr)
  get_token {QUOTE} token_type= if stoken +string ;then putback get_exp
;

: get_str string> string@ ;            ( -- a n)
: get_str, get_str get, ;

: get_push                             ( --)
  get_exp dstack adepth #user < if dstack >a ;then E.STFULL throw
;

: exec_function                        ( xt -- ?)
  get_token paren?                     \ starting parenthesis?
  if execute ctoken> [char] ) = {DELIMITER} token_type= and ?exit then
  E.MISSING throw
;
                                       \ function list
: (shift) exp,exp shift ;              ( -- n)
: (and)   exp,exp and ;                ( -- n)
: (or)    exp,exp or ;                 ( -- n)
: (xor)   exp,exp xor ;                ( -- n)
: (max)   exp,exp max ;                ( -- n)
: (min)   exp,exp min ;                ( -- n)
: (pop) dstack adepth 0> if dstack a> ;then E.STEMPTY throw ;
: (tos) dstack adepth 0> if dstack a@ ;then E.STEMPTY throw ;
: (function) function ;                ( -- n)
: (time) time ;                        ( -- n)
: (random) get_exp choose ;            ( -- n)
: (not) get_exp invert ;               ( -- n)
: (abs) get_exp abs ;                  ( -- n)
: (sgn) get_exp dup 0> swap 0< - ;     ( -- n)
: (len) get_str nip ;                  ( -- n)
: (val) get_str number ;               ( -- n)
: (str) get_exp (number) execute +string ;
: (char) get_exp c>s +string ;         ( -- addr)
: (peek) get_str, 1- get_exp 0 max min chars + c@ ;
: (clip) get_str, get_exp 0 max over min - +string ;
: (chop) get_str, get_exp 0 max over min /string +string ;
: (comp) get_str, get_str compare ;    ( -- n)
: (name) get_str fnv1a ;               ( -- n)
: (line) get_exp get_label nip ;       ( -- f)
: (used) dstack adepth ;               ( -- n)
: (free) get_exp if remap then #free @ ;
: (read) cin >r get_exp use refill  r> use ;
: (here) >in @ ;                       ( -- n)
: (tok) get_exp parse +string ;        ( -- addr)
: (set) get_var, string> dup rot ! ;   ( -- n)
: (iif) get_exp get, string> get, string> swap rot if swap then drop ;
aka string> (dup)                      ( -- addr)
                                       \ otherwise you'd miss it in this list
: (join)                               ( -- addr)
  get_str, get_str +string+
  begin ctoken> [char] , = while string@ get_str +string+ repeat putback
;

: (ask)                                ( -- addr)
  get_token {QUOTE} token_type=
  if stoken type refill drop 0 parse +string ;then E.STREXP throw
;

: (ord)                                ( -- n)
  get_token stoken 1 = {QUOTE} token_type= and if c@ ;then
  E.STREXP throw                       \ check length and type
;                                      \ if not ok throw syntax error

: (open) get_str, (ord)                ( -- h)
  case                                 \ we got a string and a character
    [char] w of output endof           \ must be an 'r' or a 'w'
    [char] r of input endof
    E.SYNTAX throw                     \ if not, it is a syntax error
  endcase open                         \ open file and return handle
;

: (cmd)                                ( -- n|addr)
  get_exp dup 0> over argn < and if args +string ;then drop argn 1-
;                                      \ return argument or #arguments

: unknown-function E.NOTFUNC throw ;   \ if not, it's not a function
                                       \ *MUST BE* in "keyword types" order
create function?                       ( -- n)
  ' unknown-function ,                 \ not a function
  ' (pop) ,                            \ pop value from stack
  ' (tos) ,                            \ get top of stack
  ' (random) ,                         \ random value
  ' (abs) ,                            \ absolute value
  ' (sgn) ,                            \ leave sign
  ' (ord) ,                            \ get ASCII value
  ' (and) ,                            \ binary AND
  ' (or) ,                             \ binary OR
  ' (xor) ,                            \ binary XOR
  ' (not) ,                            \ binary NOT
  ' (shift) ,                          \ binary SHIFT left
  ' (function) ,                       \ user defined function
  ' (time) ,                           \ epoch time
  ' (len) ,                            \ length of a string
  ' (val) ,                            \ numeric value of a string
  ' (str) ,                            \ convert number to string
  ' (char) ,                           \ address of a ASCII value
  ' (peek) ,                           \ ASCII value at address
  ' (clip) ,                           \ address with chars< removed
  ' (chop) ,                           \ address with >chars removed
  ' (comp) ,                           \ result of string comparison
  ' (join) ,                           \ address of joined strings
  ' (dup) ,                            \ copy a string
  ' (ask) ,                            \ address of entered string
  ' (free) ,                           \ free strings left
  ' (name) ,                           \ convert string to name
  ' (line) ,                           \ is it a valid linenumber
  ' (used) ,                           \ items used on user stack
  ' (open) ,                           \ open a file
  ' (read) ,                           \ read a line
  ' (tok) ,                            \ tokenize a line
  ' (here) ,                           \ current position in input buffer
  ' (set) ,                            \ assign a value to a variable
  ' (max) ,                            \ return the largest value
  ' (min) ,                            \ return the smallest value
  ' (iif) ,                            \ return one of two arguments
  ' (cmd) ,                            \ get a command line argument
  ' unknown-function ,                 \ not a function
does> tok@ 'POP' 1- max 'CMD' 1+ min 'POP' 1- - cells + @c exec_function ;

: (array)                              ( -- v)
  get_exp dup -1 > over #element < and
  if cells element + ;then E.NOTVAR throw
;                                      \ check if in bounds

: get_global                           ( a -- v)
  c@ dup is-alpha                      \ if it is alphabetic
  if bl or [char] a - cells variables + ;then
  [char] @ = if ['] (array) exec_function ;then E.NOTVAR throw
;                                      \ either an array or variable
                                       \ otherwise it is not a variable
: get_local                            ( a -- v)
  dup c@ swap char+ c@ [char] @ = over is-alpha and
  if                                   \ check for local identifier
    bl or [char] a - cells frame @ cell- dup frame - >r over r> <
    if swap - ;then                    \ if so, calculate address
  then E.NOTVAR throw                  \ otherwise it is not a local
;

create get_var                         ( a n -- v)
  1 , ' get_global ,                   \ global variable
  2 , ' get_local  ,                   \ local variable
  NULL ,
does>                                  \ drop length, not needed
  2 num-key row if nip cell+ @c execute ;then E.NOTVAR throw
;                                      \ we need this one for SET()
                                       ( -- v)
:noname get_token stoken get_var get, ; is get_var,
                                       ( a1 n1 -- n2)
: skip_var get_token {VARIABLE} token_type= 0= if putback then ;
: var= stoken get_var ctoken> [char] = = ;
: get_step tok@ 'STEP' = if drop get_exp ;then putback ;
                                       \ assing value to variable
: assignment                           ( --)
  get_token var= if get_exp swap ! ;then
  putback ctoken> [char] : = ctoken> [char] = = and if string> swap ! ;then
  E.ASGMTEXP throw                     \ first try =, then :=
;                                      \ if all fails, throw an exception
                                       \ skip until a matching NEXT
: skip_next                            ( --)
  1 begin                              \ initialize level 1
    get_token tok@ >r                  \ get next token
    r@ 'FINISHED' = if E.KEYEXP throw then
    r@ 'REM' = if find_eol then        \ skip any comments
    r@ 'FOR'  = if 1+ then             \ if FOR, increment level
    r> 'NEXT' = if 1- then dup 0=      \ matching NEXT found?
  until drop skip_var                  \ skip any variable
;
                                       \ skip until a matching ENDIF or ELSE
: skip_endif                           ( --)
  1 begin                              \ initialize level 1
    get_token tok@ >r                  \ get next token
    r@ 'FINISHED' = if E.KEYEXP throw then
    r@ 'REM' = if find_eol then        \ skip any comments
    r@ 'IF'  = if 1+ then              \ if IF, increment level
    r@ 'ELSE' = over 1 = and if 1- then
    r> 'ENDIF' = if 1- then dup 0=     \ matching ELSE or ENDIF found?
  until drop
;

: exec_tab                             ( n1 -- n2)
  [: get_exp 0 max swap over over < if cr dup xor then over swap - spaces ;]
  exec_function                        \ execution semantics for TAB()
;

: exec_using                           ( --)
  get_token {QUOTE} token_type=        \ expect a quoted string
  if                                   \ if so, setup picture buffer
    stoken /hold 1- min picture$ place (picture) is .number
  else                                 \ print routine is (picture)
    E.STREXP throw                     \ otherwise it is a string error
  then
;                                      \ print character by ASCII value
                                       ( n1 -- n2)
: exec_chr [: get_exp emit 1+ ;] exec_function ;
: exec_show [: get_exp string@ tuck type + ;] exec_function ;
                                       \ embedded print functions
create expression?                     ( ..n1 n2 -- .. n1+n3 f)
  'TAB'   , ' exec_tab   ,             \ TAB()
  'CHR'   , ' exec_chr   ,             \ CHR()
  'USING' , ' exec_using ,             \ USING ""
  'SHOW'  , ' exec_show   ,            \ SHOW()
  NULL ,
does>
  2 num-key row if nip cell+ @c execute false else drop drop true then
;                                      \ not found, syntax error
                                       \ core printing engine
: print                                ( n1 -- n2)
  true begin                           \ setup position and delimiter flag
    get_token done?                    \ if we're not finished
  except                               \ single PRINT always prints CR
    drop tok@ expression?              \ is it an expression?
    if
      {QUOTE} token_type=              \ it is a quoted string?
      if stoken s>escape else putback get_exp .number then tuck type +
    then                               \ if not, it must be an expression
    ctoken> >r r@ [char] , =           \ are we dealing with a comma?
    if /tab over over mod - dup spaces + then
    r@ [char] , <> r> [char] ; <> and dup
  until                                \ no ; or , there is more coming
                                       \ issue a linefeed if needed
  done? if if >zero cr then ;then E.SYNTAX throw
;                                      \ trailing chars means syntax error
                                       \ expand current local variable frame
: exec_local                           ( --)
  [: get_exp 0 max 27 frame dup @ - + min negate cells frame + dup local <
  if E.MANYLOC throw else frame @ over ! to frame then ;]
  exec_function                        \ execution semantics for LOCALS()
;
                                       \ if true, check for plain linenumber
: exec_if                              ( --)
  get_exp get_token tok@ 'THEN' = if get_token then
  if {NUMBER} token_type= if number? find_label prog ! ;then putback ;then
  done? if skip_endif ;then find_eol   \ if false, check for multi-line IF
;                                      \ if so, skip until ENDIF, else EOL

: exec_for                             ( --)
  get_token {VARIABLE} token_type=     \ FOR x= form?
  if                                   \ at least an initialization
    var= if                            ( v f -- v)
      get_exp over !                   \ get value and save in variable
      get_token tok@ 'TO' =            \ get the TO keyword, if found
      if                               \ abort if no iterations left
        get_exp get_token 1 get_step >r over @ over r@ 0< if swap then >
        if r> drop drop drop skip_next ;then
      else                             \ TO missing? Only initialize variable
        0 get_step dup >r 0< if (error) else max-n then
      then prog @ rot r>               \ STEP keyword used?
    else                               \ if so, accept any value else assume 0
      E.ASGMTEXP throw                 \ no assignment found, throw error
    then
  else                                 \ no init, probably a DO
    putback 0 prog @ (error) false     \ create fake FOR stack frame:
  then swap fpush                      \ dummy location FALSE-flag DO-flag
;                                      \ push the FOR frame

: exec_next                            ( --)
  fpop dup 0<                          \ fake FOR frame (DO)?
  if                                   \ if so, don't waste any time
    >r dup >r                          \ set up for next iteration
  else                                 \ if true FOR frame, increment variable
    over over +! >r >r over r'@ @ r@ 0< if swap then <
  then                                 \ compare value and limit
                                       \ if loop ended, drop frame and
  if r> r> fscrap skip_var ;then       \ ignore any variable - if not, jump
  dup prog ! r> r> fpush               \ and push frame again
;

: exec_input                           ( --)
  get_token {QUOTE} token_type=        \ keyword followed by string?
  if                                   \ if so, type it and get variable
    stoken type ctoken> dup [char] , = swap [char] ; = or
    if get_token else E.MISSING throw then
  else                                 \ no separator, then delimiter error
    ." ? "                             \ print only a question mark
  then enter stoken get_var !          \ get value, store it in the variable
;

: exec_push                            ( --)
  begin get_push ctoken> [char] , <> until putback
;                                      \ push values on stack while comma

: exec_return                          ( --)
  get_token paren? putback if ['] get_push exec_function then
  gpop prog ! frame dup local #local 1- cells + >
  if E.NOSCOPE throw ;then @ to frame
;                                      \ return from GOSUB, destroy locals

: exec_gosub                           ( --)
  get_exp find_label                   \ try to find the label
  get_token paren? putback if ['] exec_push exec_function then
  prog dup @ gpush ! make_frame        \ push optional values, create locals
;

: exec_param                           ( --)
  frame exec_local frame               \ allocate locals, save pointers
  begin over over > while cell+ (pop) over ! repeat drop drop
;                                      \ pop values from the stack

: exec_continue fstack adepth exec_next fstack adepth > if skip_next then ;
: exec_print pos print to pos ;        \ take care of line position
: exec_write cout >r get_exp get, use 0 print drop r> use ;
: exec_close get_exp close ;           \ close the file
: exec_unloop fpop fscrap ;
: exec_goto get_exp find_label prog ! ;
: exec_break exec_unloop skip_next ;
: exec_while get_exp 0= if exec_break then ;
: exec_until get_exp if exec_break then ;
: bye depth if E.MEMLEAK else E.FINISHED then throw ;
: unary [char] - = if negate then ;    ( n1 c -- n2)
: variable? stoken get_var @ ;         ( -- n)
                                       \ resolve a primitive
create primitive                       ( n1 -- n2)
  {VARIABLE} , ' variable? ,
  {KEYWORD}  , ' function? ,           \ it can only be a function
  {NUMBER}   , ' number?   ,
  NULL ,
does>
  2 num-key row if nip cell+ @c execute get_token ;then E.SYNTAX throw
;

: level7                               ( n1 -- n2)
  paren? if                            \ parenthesis found?
    get_token level2 ctoken [char] ) = \ evaluate and get next parenthesis
    if get_token ;then E.MISSING throw \ error if no parenthesis found
  ;then drop token_type c@ primitive   \ must be a primitive
;
                                       \ resolve unary -
: level6                               ( n1 -- n2)
  {DELIMITER} token_type= ctoken dup [char] + = swap [char] - = or and
  if ctoken get_token else 0 then >r level7 r> dup if unary ;then drop
;                                      \ resolve power
                                       ( n1 -- n2)
: level5 level6 ctoken [char] ^ = if get_token 0 level5 [char] ^ arith then ;
                                       \ resolve div, mul and mod
: level4                               ( n1 -- n2)
  level5 0 begin                       \ setup loop
    ctoken dup [char] * = over [char] / = or over [char] % = or
  while                                \ repeat until all word done
    >r get_token level5 tuck r> arith swap
  repeat drop drop                     \ drop operator and 'hold' value
;
                                       \ resolve addition and substraction
: level3                               ( n1 -- n2)
  level4 0 begin                       \ setup loop
    ctoken dup [char] + = over [char] - = or
  while                                \ repeat until all word done
    >r get_token level4 tuck r> arith swap
  repeat drop drop                     \ drop operator and 'hold' value
;
                                       \ resolve logical operators
:noname                                ( n1 -- n2)
  level3 0 begin                       \ setup loop
    ctoken dup [char] # = over [char] = = or
    over [char] < = or over [char] > = or
  while                                \ repeat until all word done
    >r get_token level3 tuck r> arith swap
  repeat drop drop                     \ drop operator and 'hold' value
; is level2                            \ we've finally defined it!
                                       \ map tokens to words
: load_program                         ( a1 n1 a2 n2 --)
  input open error? abort" File loading error"
  >r r@ use 2dup accept r> close       \ signal loading error
  tuck = abort" Out of memory" >string \ signal memory full
;
                                       \ if not listed, ignore
: ignore ;                             ( --)

create keyword                         \ *MUST BE* in "keyword types" order!
  ' ignore ,                           \ invalid keyword, ignore
  ' exec_print ,                       \ PRINT
  ' exec_write ,                       \ WRITE
  ' exec_close ,                       \ CLOSE
  ' find_eol ,                         \ REM
  ' assignment ,                       \ LET
  ' exec_input ,                       \ INPUT
  ' exec_push ,                        \ PUSH
  ' exec_goto ,                        \ GOTO
  ' exec_gosub ,                       \ GOSUB
  ' exec_return ,                      \ RETURN
  ' exec_if ,                          \ IF
  ' skip_endif ,                       \ ELSE
  ' exec_for ,                         \ FOR
  ' exec_next ,                        \ NEXT
  ' exec_continue ,                    \ CONTINUE
  ' exec_break ,                       \ BREAK
  ' exec_while ,                       \ WHILE
  ' exec_until ,                       \ UNTIL
  ' exec_unloop ,                      \ UNLOOP
  ' exec_local ,                       \ LOCAL
  ' exec_param ,                       \ PARAM
  ' bye ,                              \ END
  ' bye ,                              \ End of program
  ' ignore ,                           \ invalid keyword, ignore
does> swap 'NOOP' max 'FINISHED' 1+ min cells + @c execute ;
                                       \ if not listed, ignore
: interpret                            ( --)
  get_token {VARIABLE} token_type=     \ if it's a variable, assign it
  if putback assignment ;then tok@ keyword
;                                      \ else assume it is a keyword

:noname                                \ execution semantics for FUNC()
  exec_gosub gstack a@ >r begin interpret r@ prog @ = until r> drop (pop)
; is function                          \ until returned, pop value

: initialize                           ( --)
  randomize (number) is .number        \ set up randomizer and number printer
  dstack stack gstack stack fstack stack make_frame
  strings #str ds.build init_freemap
;                                      \ stack, local vars and strings

: ubasic                               ( --)
  argn 2 < abort" Usage: ubasic source-file <arguments>"
  program /program 1 args load_program \ load program, init stacks, locals
  initialize program prog ! ['] scan_labels catch dup
  unless begin drop ['] interpret catch dup until then ds.destroy .error
;                                      \ enter interpretation loop

ubasic

