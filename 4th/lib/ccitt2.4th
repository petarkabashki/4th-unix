\ 4tH library - CCITT-2/ITA-2/Murray code - Copyright 2020 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[UNDEFINED] >ccitt2  [IF]
[UNDEFINED] is-upper [IF] include lib/istype.4th [THEN]
\ include lib/anstools.4th

27 constant figs                       ( -- cmd)
31 constant ltrs                       ( -- cmd)
 1 constant >cmd                       ( -- cmd 1)

create (ltrs)                          \ letters CCITT2 table
   3 128 * char A + ,
  25 128 * char B + ,
  14 128 * char C + ,
   9 128 * char D + ,
   1 128 * char E + ,
  13 128 * char F + ,
  26 128 * char G + ,
  20 128 * char H + ,
   6 128 * char I + ,
  11 128 * char J + ,
  15 128 * char K + ,
  18 128 * char L + ,
  28 128 * char M + ,
  12 128 * char N + ,
  24 128 * char O + ,
  22 128 * char P + ,
  23 128 * char Q + ,
  10 128 * char R + ,
   5 128 * char S + ,
  16 128 * char T + ,
   7 128 * char U + ,
  30 128 * char V + ,
  19 128 * char W + ,
  29 128 * char X + ,
  21 128 * char Y + ,
  17 128 * char Z + ,
   2 128 * 10 + ,                      \ LF
   4 128 * bl + ,                      \ SP
   8 128 * 13 + ,                      \ CR
              0 ,

create (figs)                          \ figures CCITT2 table
   3 128 * char - + ,
  25 128 * char ? + ,
  14 128 * char : + ,
   9 128 * char $ + ,
   1 128 * char 3 + ,
  13 128 * char ! + ,
  26 128 * char & + ,
  20 128 * char # + ,
   6 128 * char 8 + ,
  11 128 * char 4 + ,
  15 128 * char ( + ,
  18 128 * char ) + ,
  28 128 * char . + ,
  12 128 * char , + ,
  24 128 * char 9 + ,
  22 128 * char 0 + ,
  23 128 * char 1 + ,
  10 128 * char ' + ,
   5 128 * 7 + ,                       \ BEL
  16 128 * char 5 + ,
   7 128 * char 7 + ,
  30 128 * char ; + ,
  19 128 * char 2 + ,
  29 128 * char / + ,
  21 128 * char 6 + ,
  17 128 * char " + ,
   2 128 * 10 + ,                      \ LF
   4 128 * bl + ,                      \ SP
   8 128 * 13 + ,                      \ CR
              0 ,

(ltrs) value (curr)                    \ start off with letters as standard
                                       \ shift the tables on command
: (cmd)                                ( c --)
  dup figs = if drop (figs) to (curr) ;then ltrs = if (ltrs) to (curr) then
;
                                       \ does character require table shift?
: (+cmd)                               ( c1 -- -f c1 | c2 +f c1)
  dup is-white over 7 <> and if false swap ;then
  dup is-upper if
  (curr) (ltrs) = if false swap else ltrs dup (cmd) true rot then ;then
  (curr) (figs) = if false swap else figs dup (cmd) true rot then
;
                                       \ convert CCITT2 to ASCII
: ccitt2>                              ( c1 -- c2)
  (curr) >r                            \ save current table on the stack
  begin r@ @c dup while over over 128 / = except drop r> cell+ >r repeat
  rdrop dup if nip 128 mod else drop (cmd) 0 then
;                                      \ returns zero when no ASCII equivalent
                                       \ convert ASCII to CCITT2
: >ccitt2                              ( c1 -- c2 c3 2|c2 1|0)
  (curr) >r (+cmd) (curr) >r           \ add command if required and lookup
  begin r@ @c dup while over over 128 mod = except drop r> cell+ >r repeat
  rdrop nip dup if 128 / swap if swap 2 else 1 then rdrop ;then
  drop if drop then 0 r> to (curr)     \ cannot convert ASCII character   
;
                                       \ emulate punch tape
\ .ccitt2                              ( c1 .. cn n --)
\ ccitty2-type                         ( a n --)
\ ccitt-init                           ( --)

: (punch) dup 16 and if [char] o emit else space then 2* ;
: .ccitt2 0 ?do (punch) (punch) (punch) ." :" (punch) (punch) cr drop loop ;
: ccitt2-type bounds ?do i c@ >ccitt2 .ccitt2 loop ;
: ccitt2-init ltrs >cmd .ccitt2 ltrs >cmd .ccitt2 ;

\ s" THIS IS THE END IN 1971! MR. MOJO RISIN'" ccitt2-type
\ s" THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG." ccitt2-type.

[DEFINED] 4TH# [IF]
  hide (ltrs)
  hide (figs)
  hide (curr)
  hide (cmd)
  hide (+cmd)
  hide (punch)
[THEN]
[THEN]
