\ 4tH Demo application - (c) 1995,2015 J.L. Bezemer

[needs lib/menu.4th]
[needs lib/totime.4th]

: sec s>time type space ;
: to_secs [char] : parse-word number * ;

: EnterTime
  cr ." Enter time as 'hh:mm:ss': " refill drop
  3600 to_secs 60 to_secs 1 to_secs + +
;

: Show depth 2 < if drop else cr over swap execute cr then ;
: Seconds ." Seconds: " . ;
: Times ." Time: " sec ;
: EnterSecs cr ." Enter number of seconds: " enter ;
: AddEntries depth 1 > if + then ;
: ShowSecs ' Seconds Show ;
: ShowTime ' Times Show ;
: DoExit quit ;

create Menu
  ," MENU"
  ," Enter time"               ' EnterTime ,
  ," Enter seconds"            ' EnterSecs ,
  ," Add previous two entries" ' AddEntries ,
  ," Show number of seconds"   ' ShowSecs ,
  ," Show time"                ' ShowTime ,
  ," Exit"                     ' DoExit ,
  NULL ,

Menu MainMenu
RunMenu
