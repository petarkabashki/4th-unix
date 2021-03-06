\ 4tH library - GAMMA - Copyright 2013, 2020 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License
\ include lib/zenfloat.4th

[UNDEFINED] gamma [IF]
[UNDEFINED] fsqrt [IF] include lib/zenfsqrt.4th [THEN]
[UNDEFINED] f**   [IF] include lib/zenfalog.4th [THEN]

\ Cristinel Mortici writes in: "A substantially improvement of the Stirling
\ formula", to appear in: Applied Mathematics Letters.
\ Received date: 30 August 2009.

\ n! ~ sqrt(2*pi*n)(n/e + 1/(12*e*n))^n

\ This algorithm gives about 7 good digits, but becomes more
\ inaccurate close to zero. Therefore, the formula:

\          G (x + n)
\ G (x) =  ---------
\          (x*(x+1)*(x+2)*..(x+n-1))

\ shifts the value returned into the more accurate domain.

8 constant (gamma-shift)

: (mortici)                            ( f1 -- f2)
  -1 s>f f+ 1 s>f
  2over 271828183 -8 f* 12 s>f f* f/
  2over 271828183 -8 f/ f+
  2over f** 2swap
  628318530 -8 f* fsqrt f*             \ 2*pi
;

: gamma                                ( f1 -- f2)
  2dup f0< >r 2dup f0= r> or E.FPERR throw" Gamma less or equal to zero"
  2dup (gamma-shift) s>f f+ (mortici) 2swap
  1 s>f (gamma-shift) 0 do 2over i s>f f+ f* loop 2nip f/
;

[DEFINED] 4TH# [IF]
  hide (gamma-shift)
  hide (mortici)
[THEN]
[THEN]
