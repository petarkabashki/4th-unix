\ 4tH library - floating point SPRINTF - Copyright 2017 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ This is an almost full implementation of the C sprintf() function.
\ Only the 'AaEFGnpX' specifiers, the length (except %ld) and some FP features
\ are not supported. For further details consult:
\       http://www.cplusplus.com/reference/cstdio/printf/

\ ***
\ *** This word requires either fp2.4th or fp4.4th (which includes fpout.4th)
\ ***

[UNDEFINED] sprintf  [IF]
[UNDEFINED] FDP      [IF] [ABORT] [THEN]
[UNDEFINED] .padding [IF] include lib/padding.4th [THEN]

 1 constant (FLAG#)                    \ the pre/postfix flag
 2 constant (FLAG0)                    \ the 'pad with zero' flag
 4 constant (FLAG-)                    \ the 'align left or right' flag
 8 constant (FLAG+)                    \ the 'always add sign' flag
16 constant (FLAG_)                    \ the 'use space for +' flag

defer (fill)                           \ right or left aligned

1 buffer: (flags)                      \ all flags

variable (width)                       \ width of field
variable (precision)                   \ precision of field
variable (cursor)                      \ current position
variable (origin)                      \ origin of buffer

:token :decimal; decimal ;             ( --)
: (flag!) (flags) dup >r c@ or r> c! ; ( a n f -- a+1 n-1)
: (flag?) (flags) c@ and 0<> ;         ( n -- f)
                                       \ get width or precision
: (@number)                            ( a1 n1 -- a2 n2 n3)
  0 >r begin                           \ save accumulator
    2dup                               \ still something to parse?
  while                                \ is it a digit?
    c@ [char] 0 - dup max-n and 10 <   \ if so, shift left and add
  while                                \ chop the digit from string
    r> 10 * + >r chop                  \ lose the pointer and
  repeat drop r>                       \ return the figure
;
                                       \ get width of precision
: (@size)                              ( a1 n1 -- a1+i n1-i n2)
  2dup if c@ [char] * =  if chop rot else (@number) then else dup xor then
;
                                       \ evaluate the # flag for integers
: (flag#?)                             ( --)
  (FLAG#) (flag?) if                   \ is the flag set?
    base @ 8 = if [char] 0 dhold then  \ add a zero when octal
    base @ 16 = if [char] x dhold [char] 0 dhold then
  then                                 \ add a zero and 'x' for hex
;
                                       ( c --)
: (cursor1+!) (cursor) tuck @ c! 1 swap +! ;
                                       \ save a 
: (cursor+!)                           ( a n --)
  (cursor) dup >r @ (width) @          \ get width
  (FLAG0) (flag?) if [char] 0 else bl then (fill) r> +! drop
;                                      \ pad with zeros or blanks
                                       \ sign picture
: (sign?)                              ( n3 n1 n2 - n1 n2)
  (FLAG+) (flag?) if                   \ always add a sign?
    rot 0< if [char] - else [char] + then
  else                                 \ use ' ' instead of '+'?
    (FLAG_) (flag?) if rot 0< if [char] - else bl then else dsign exit then
  then dhold                           \ use normal sign instead
;
                                       \ double number picture
: (#s)                                 ( n1 -- n2)
  (precision) @ dup                    \ get precision
  if 0 ?do d# loop begin dup while d# repeat else drop d#s then
;                                      \ select number generator
                                       \ print a number
: (.number) dup -rot dabs <d# (#s) (flag#?) (sign?) d#> (cursor+!) ;
: (.float) (FLAG#) (flag?) FDP ! (precision) @ swap execute (cursor+!) ;
: (.radix) base @ >r execute (.number) r> base ! ;
                                       ( f xt --)
: (@format)                            ( a1 n1 -- a2 n2)
  (FLAG-) (flag?) if ['] rfill else ['] lfill then is (fill)
  dup 0> if                            \ return on null string
    over swap 2>r c@ >r                \ save format and character
    r@ [char] % = if [char] % (cursor1+!) then
    r@ [char] c = if (cursor1+!) then
    r@ [char] s = if (precision) @ dup if min else drop then (cursor+!) then
    r@ [char] e = if ['] (fs.) (.float) then
    r@ [char] f = if ['] (f.) (.float) then
    r@ [char] g = if ['] (g.) (.float) then
    r@ [char] d = if dup 0< negate :decimal; (.radix) then
    r@ [char] u = if u>d  :decimal;  (.radix)  then
    r@ [char] o = if u>d [: octal ;] (.radix)  then
    r@ [char] x = if u>d [: hex ;]   (.radix)  then
    r> [char] l = if 2r> chop 2>r :decimal; (.radix) then
    2r>                                \ select printing routine
  then
;
                                       \ get all flags
: (@flags)                             ( a1 n1 -- a+i n-i)
  0 dup (flags) c! begin               \ no flags selected
    >r 2dup                            ( a1 n1 a1 n1)
  while                                \ is there any string left
    c@ >r                              \ save character
    r@ [char] - = if (FLAG-) (flag!) then
    r@ [char] # = if (FLAG#) (flag!) then
    r@ [char] + = if (FLAG+) (flag!) then
    r@ [char] 0 = if (FLAG0) (flag!) then
    r> bl = if (FLAG_) (flag!) then
    (flags) c@ dup r> >                ( a1 n1 n2 f)
  while                                \ until all flags have been read
    >r chop r>                         \ if flag, chop it off the string
  repeat drop                          \ drop superfluous item from stack
;
                                       \ print a field 
: (.field)                             ( a1 n1 -- a+i n-i)
  chop (@flags) (@size) (width) !      \ get flags, width and precision
  2dup if c@ [char] . = if chop (@size) else 0 then else dup xor then
  (precision) ! (@format)              \ now get the specifier
;
                                       ( a1 n1 -- a+i n-i)
: (%?) over c@ [char] % = if (.field) else over c@ (cursor1+!) then ;

: sprintf                              ( x1 .. xi a1 n1 a2 -- a2 n3)
  dup (cursor) ! (origin) ! begin dup 0> while (%?) chop repeat 2drop
  (origin) @ (cursor) @ over -         \ calculate the length
;

[DEFINED] 4TH# [IF]
  hide (FLAG#)
  hide (FLAG0)
  hide (FLAG-)
  hide (FLAG+)
  hide (FLAG_)
  hide (fill)
  hide (flags)
  hide (width)
  hide (precision)
  hide (cursor)
  hide (origin)
  hide :decimal;
  hide (flag!)
  hide (flag?)
  hide (@number)
  hide (@size)
  hide (flag#?)
  hide (cursor1+!)
  hide (cursor+!)
  hide (sign?)
  hide (#s)
  hide (.number)
  hide (.float)
  hide (.radix)
  hide (@format)
  hide (@flags)
  hide (.field)
  hide (%?)
[THEN]
[THEN]

\ fclear
\ 80 string buffer s" -3.14159e" s>float 10 1234567 u>d s" Hello" char !
\ s" This is %%char%c%%, string '%-.4s', double %#10.8ld and float %#*.2e!"
\ buffer sprintf type cr depth .