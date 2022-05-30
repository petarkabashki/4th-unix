\ 4tH library - Fast factorial - Copyright 2021 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[UNDEFINED] factorial [IF]
create (factorial)
  1 , 1 , 2 , 6 , 24 , 120 , 720 , 5040 , 40320 , 362880 , 3628800 ,
  39916800 , 479001600 ,

/cell 4 - [IF]                         \ 64bit version
20 constant max-factorial

  6227020800 , 87178291200 , 1307674368000 , 20922789888000 , 355687428096000 ,
  6402373705728000 , 121645100408832000 , 2432902008176640000 ,
[ELSE]

12 constant max-factorial              \ 32bit version
[THEN]

: factorial max-factorial min cells (factorial) + @c ;

[DEFINED] 4TH# [IF] hide (factorial) [THEN]
[THEN]

