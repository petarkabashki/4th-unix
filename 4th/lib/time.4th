\ Collected Algorithms from ACM, Volume 1 Algorithms 1-220,
\ 1980; Association for Computing Machinery Inc., New York,
\ ISBN 0-89791-017-6

\ (c) Copyright 1994 Everett F. Carter.  Permission is granted by the
\ author to use this software for any application provided this
\ copyright notice is preserved.
\ (c) Copyright 2008,2016 Hans L. Bezemer, 4tH version

[UNDEFINED] today [IF]
VARIABLE da                            \ temporary variable day
VARIABLE mo                            \ temporary variable month
VARIABLE yr                            \ temporary variable year

86400 CONSTANT s/day                   \ seconds per day
 3600 CONSTANT s/hour                  \ seconds per hour
   60 CONSTANT s/min                   \ seconds per minute

[UNDEFINED] tz [IF]
1 3600 * +CONSTANT tz                  \ Middle European Timezone
[THEN]

\ In Excel, the day after 1900-Feb-28 is 1900-Feb-29.  In reality, the day
\ after 1900-Feb-28  was 1900-Mar-1 .  This is not a "bug".  Indeed, it is
\ by design.  Excel works this way because it was truly a bug in Lotus 123.
\ When Excel was introduced, 123 has nearly the entire market for spreadsheet
\ software.  Microsoft decided to continue Lotus' bug, in order to fully 
\ compatible. 

 2415019 +constant xls>jday            \ valid for 1900-03-01 onwards
-2415019 +constant jday>xls            \ valid for 1900-03-01 onwards

: JDAY ( d m y -- jd)                  \ day, month, year to Julian date
  swap dup 2 > if 3 - swap else 9 + swap 1- then rot >r swap >r 100 /mod >r
  1461 * 4 / r> 146097 * 4 / + r> 153 * 2 + 5 / + r> + 1721119 +
;

: JDATE ( jd -- d m y)                 \ Julian date to day, month, year
  1721119 - 4 * 1- dup 146097 / dup yr ! 146097 * - 4 / 4 * 3 + 1461 /mod
  swap 4 + 4 / 5 * 3 - 153 /mod mo ! 5 + 5 / da ! yr @ 100 * + yr !
  mo @ 10 < if 3 mo +! else -9 mo +! 1 yr +! then da @ mo @ yr @
;
                                       \ POSIX conversions
: POSIX>JDAY s/day / 2440588 + ;       ( n1 -- n2)
: POSIX>TIME s/day mod s/hour /mod >r s/min /mod r> ;
: DMYSMH>POSIX s/hour * swap s/min * + + >r jday 2440588 - s/day * r> + ;
: WEEKDAY jday 7 mod ;                 ( d m y -- n)
                                       \ quick access to current date/time
: TODAY time tz posix>jday jdate ;     ( -- d m y)
: NOW time tz posix>time ;             ( -- s m h)

[DEFINED] 4TH# [IF]
  hide da
  hide mo
  hide yr
[THEN]
[THEN]