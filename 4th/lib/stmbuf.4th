\ 4tH library - Circular string buffer - Copyright 2019 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[UNDEFINED] strstr+  [IF]
[UNDEFINED] /cbuffer [IF]
  1024 constant /cbuffer               \ size of cbuffer
[THEN]

/cbuffer buffer: cbuffer               \ allocate cbuffer
 
           cbuffer constant cb0        \ low memory cbuffer
cbuffer /cbuffer + constant cb^        \ high memory cbuffer

cb^ value cbp                          \ cbuffer pointer

: (sizeup) /cbuffer 1- min cbp over ;  ( n1 -- n2 a n2)
: (where) dup >r - dup cb0 < if drop cb^ r> - else r> drop then dup to cbp ;
: +str+ (sizeup) (where) swap cmove 0 cb^ char- c! cbp ;
: str+ (sizeup) 1+ (where) place cbp ; ( a1 n1 -- a2)
: (?wrap) cb0 < if cbp count cb^ to cbp str+ drop then ;
: strstr+ str+ over - (?wrap) +str+ ;  ( a1 n1 a2 n2 -- a3)

[DEFINED] 4TH# [IF]
  hide /cbuffer
  hide cbuffer
  hide cbp
  hide (sizeup)
  hide (where)
  hide (?wrap)
[THEN]
[THEN]

\ s" Jim Morrison" str+ . cr
\ s" Hello " s" world" concat+ . cr
