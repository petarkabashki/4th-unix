\ 4tH library - Fractional arithmatic extensions - Copyright 2021 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[UNDEFINED] vexp  [IF]
[UNDEFINED] v/    [IF] include lib/fraction.4th [THEN]
[UNDEFINED] (sin) [IF] include lib/math.4th     [THEN]
[UNDEFINED] isqrt [IF] include lib/isqrt.4th    [THEN]
[UNDEFINED] fxexp [IF] include lib/fxexpln.4th  [THEN]
                                       ( fn1 -- exp[fn1])
PI*10K +1 * 10K / constant vpi         \ pi in fraction form

: vexp v>s dup 0< >r abs *fx 10K */ fxexp *fx r> if swap then v/ ;
: vln v>s *fx 10K */ fxln *fx v/ ;     ( fn1 -- ln[fn1])
: vround v>s dup 0< >r abs 10K 10 / / 5 + 10 / 10K * r> if negate then s>v ;
: vsin v>s (sin) s>v ;
: vcos v>s (cos) s>v ;
: vtan v>s (tan) s>v ;
: vsqrt v>s 10K * isqrt s>v ;
                                       ( fn1 -- fn2)
\ 40000 s>v vexp v. 100000 s>v vexp v. -20000 s>v vexp v.
\ -40000 s>v vexp v. cr depth .
[THEN]

