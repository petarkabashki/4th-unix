\ 4tH library - Fractional arithmatic - Copyright 1982, Leo Brodie
\ 4tH version - 2006,2021 J.L. Bezemer

[UNDEFINED] 10K [IF] [needs lib/constant.4th] [THEN]
[UNDEFINED] '?' [IF] [needs lib/chars.4th]    [THEN]

[UNDEFINED] v. [IF]
16384 constant +1

aka + v+
aka - v-

: v* * +1 / ;
: v/ >r +1 * r> / ;
: v>s 10K v* ;
: s>v +1 * 10K / ;
: v. v>s dup abs <# # # # # '.' hold #s sign #> type space ;
                                       \ split fraction
: (/v) +1 1- over over invert and -rot and ;
: /v dup 0< if abs (/v) negate swap negate ;then (/v) swap ;
                                       ( v1 -- v2 v3)
[DEFINED] 4th# [IF] hide (/v) [THEN]
[THEN]

\ Combinations
\ ============
\ v v  v*  v
\ v c  v*  c
\ c v  v*  c
\ v v  v/  v
\ c c  v/  v
\ c v  v/  c
\ v v  v+  v
\ v v  v-  v

\ v = fractional value
\ c = cell value
