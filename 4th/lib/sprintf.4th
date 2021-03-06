\ 4tH library - tiny SPRINTF - Copyright 2017 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ This tiny sprintf() implementation supports the following formats:

\ %{-}{width}d = print an integer in field {width}
\ %{-}{width}s = print a string in field {width}
\ %c           = print a character
\ %%           = print a percent character

\ {width} is optional, * is supported

[UNDEFINED] sprintf  [IF]
[UNDEFINED] .padding [IF] include lib/padding.4th [THEN]

defer    (pad)                         \ right or left aligned
variable (width)                       \ width of field
variable (cursor)                      \ current position
variable (origin)                      \ origin of buffer
                                       ( c --)
: (cursor1+!) (cursor) tuck @ c! 1 swap +! ;
: (cursor+!) (cursor) dup >r @ (width) @ (pad) r> +! drop ;
                                       ( a n --)
: (format)                             ( a1 n1 -- a2 n2)
  dup 0> if                            \ return on null string
    over swap 2>r c@ >r                \ save format and character
    r@ [char] % = if [char] % (cursor1+!) then
    r@ [char] d = if dup abs <# #s sign #> (cursor+!) then
    r@ [char] c = if (cursor1+!) then
    r@ [char] s = if (cursor+!) then
    r> [char] * = if (width) ! 2r> chop recurse else 2r> then
  then                                 \ recurse if width on command line
;

: (.field)                             ( x | - a1 n1 -- a2 n2)
  0 (width) ! ['] lpad is (pad)        \ start with a zero width
  2dup chop if c@ [char] - = if ['] rpad is (pad) chop then else drop then
  begin                                \ get alignment
    chop dup                           \ get width
  while                                \ is there any format string left?
    over c@ [char] 0 - dup max-n and 10 <
    if (width) @ 10 * + (width) ! else drop (format) exit then
  repeat                               \ get width or print format
;
                                       ( a n -- a n)
: (%?) over c@ [char] % = if (.field) else over c@ (cursor1+!) then ;

: sprintf                              ( x1 .. xi a1 n1 a2 -- a2 n3)
  dup (cursor) ! (origin) ! begin dup 0> while (%?) chop repeat 2drop
  (origin) @ (cursor) @ over -
;

[DEFINED] 4TH# [IF]
  hide (pad)
  hide (width)
  hide (origin)
  hide (cursor)
  hide (cursor1+!)
  hide (cursor+!)
  hide (format)
  hide (.field)
  hide (%?)
[THEN]
[THEN]

\ 80 string buffer -23 4 s" Hello" char !
\ s" This is %%char%c%%, string '%-6s' and number%*d"
\ buffer sprintf type cr depth .
