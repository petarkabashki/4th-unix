\ include lib/oyelsort.4th
\ include lib/binssort.4th
\ include lib/hea2sort.4th
\ include lib/intrsort.4th
\ include lib/qsort.4th
\ include lib/com2sort.4th
\ include lib/shelsort.4th
\ include lib/circsort.4th
\ include lib/cir2sort.4th
\ include lib/bitosort.4th
\ include lib/timsort.4th
include lib/mergsort.4th

include lib/minstd.4th

:noname < ; is precedes

100000 constant /size
/size array example

: array! /size 0 do random example i th ! loop ;
: .array /size 0 do example i th ? loop cr ;
: ?array /size 0 do example dup @ swap i th @ > if ." No" cr leave then loop ;
: array\! /size 0 do /size i - example i th ! loop ;

: test array! example /size sort ?array ;

randomize
test