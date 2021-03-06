\ Scientific calculator: RPN or "FORTRAN/BASIC" style.
\ The latter by using Wil Baden's OPG Formula Translator.
 
include lib/zenfloat.4th 
include lib/zenans.4th 
include lib/fpin.4th 
include lib/fpout.4th 
include lib/zenfalog.4th 
include lib/zenfsqrt.4th 
include lib/zenfsin.4th 
include lib/zenfasin.4th 
include lib/evaluate.4th
include lib/opgftran.4th 
 
40 constant right-margin
                                           ( n -- a )
8 floats array myvar does> swap floats + ;
 
\ Variables for the calculator 
: x  0 ; 
: y  1 ; 
: z  2 ; 
: a  3 ; 
: b  4 ; 
: c  5 ; 
: k  6 ; 
: t  7 ; 
 
: _! myvar f! ; 
: _@ myvar f@ ; 
 
: _+ f+ ; 
: _- f- ; 
: _* f* ; 
: _/ f/ ; 
: _^ f** ; 
 
: _swap 2swap ; 
: _drop 2drop ; 
: _over 2over ; 
: _dup 2dup ; 
 
: _.  f.  space ; 
: _.( [char] ) parse type ; 
: _( [char] ) parse 2drop ; 
: _ftran [char] ; parse ftran type ; 
 
: _let [char] ; parse ftran evaluate ;
 
: _cr cr ; 
: _quit quit ; 
 
: help ( -- )  cr 
  ." == Scientific calculator ==" cr
  ." Arithmetic operations:" cr 
  ."   + - / * ^ " cr 
  ." Stack operations:" cr 
  ."   DROP SWAP OVER DUP" cr 
  ." Variables:" cr 
  ."   x y z  a b c  k t" cr 
  ." Functions:" cr 
  ."   ln log exp alog sqrt sin cos tan asin acos atan" cr 
  ." Formula Translator:" cr 
  ."   LET   <<fortran eq>>: do the calculation" cr
  ."   FTRAN <<fortran eq>>: show the RPN code" cr 
  ." Other words" cr 
  ."    @ ! cr . .(  help bye" cr
  ." Examples:" cr 
  ."   2 7 /" cr 
  ."   let 2/7" cr 
  ."   let x=2; let y=7; let z=x/y; let z; z @ . cr" cr
  ."   let y=ln(1.5);  .( y=)  y @  . cr"   cr cr 
; 
 
create wordlist 
  ," +"          ' _+ , 
  ," -"          ' _- , 
  ," *"          ' _* , 
  ," /"          ' _/ , 
  ," !"          ' _! , 
  ," ^"          ' _^ , 
  ," **"         ' _^ ,
  ," exp"        ' fexp  , 
  ," ln"         ' fln   , 
  ," log"        ' flog  , 
  ," alog"       ' falog , 
  ," sqrt"       ' fsqrt , 
  ," sin"        ' fsin  , 
  ," cos"        ' fcos  , 
  ," tan"        ' ftan  , 
  ," asin"       ' fasin , 
  ," acos"       ' facos , 
  ," atan"       ' fatan , 
  ," @"          ' _@ , 
  ," x"          ' x , 
  ," y"          ' y , 
  ," z"          ' z , 
  ," a"          ' a , 
  ," b"          ' b , 
  ," c"          ' c , 
  ," swap"       ' _swap , 
  ," drop"       ' _drop , 
  ," over"       ' _over , 
  ," dup"        ' _dup , 
  ," .("         ' _.( , 
  ," ("          ' _( , 
  ," cr"         ' _cr , 
  ," ."          ' _. , 
  ," exit"       ' _quit , 
  ," quit"       ' _quit , 
  ," bye"        ' _quit , 
  ," help"       ' help , 
  ," let"        ' _let , 
  ," ftran"      ' _ftran , 
  NULL , 
 
wordlist to dictionary                \ assign wordlist to dictionary 
 

\ The interpreter itself 
: fcalc 
  help
  single-math
  begin                               \ show the prompt and get a command 
     depth 1 > if 
        fdup                          \ duplicate value on stack
        cr right-margin spaces ." Stack_Top> " f. space
     then                             \ show the running tally
    ." OK" cr refill drop             \ interpret and issue oops when needed 
    ['] interpret catch if ." Oops " then 
  again                               \ repeat command loop eternally 
; 
 
fcalc 
