\ 4tH demo - Skyscraper DB query - Copyright 2015 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ Attention! First run the CSV loader program "skysload.4th" in
\ the "demo" directory to create the skyscraper database!

[pragma] ignorenumbers                 ( it's not a calculator)
include lib/interprt.4th               \ for INTERPRET
include lib/dbmidx.4th                 \ for IDX.LOAD
\ include lib/anstools.4th               \ for .S

struct                                 \ skyscraper database buffer
   8 +field Rank                       \ world rank (2014)
  64 +field Name                       \ name of the building
  32 +field City                       \ city location of building
  16 +field Country                    \ country of this city
   8 +field Height_m                   \ height in meters
   8 +field Height_ft                  \ height in feet
   8 +field Floors                     \ number of floors
   8 +field Built                      \ year building was constructed
end-struct /Skyscraper

/Skyscraper buffer: Skyscraper         \ allocate room for buffer
                                       \ all indexes
variable Sky.Rank                      \ rank index
variable Sky.Name                      \ name index
variable Sky.City                      \ city index
variable Sky.Country                   \ country index
variable Sky.Height                    \ height index
variable Sky.Floors                    \ floors index
variable Sky.Built                     \ built index
                                       \ errors (throw)
 -1 enum SYSERR                        \ system error
    enum NOERRS                        \ no errors
    enum NUMEXP                        \ number expected
    enum STREXP                        \ string expected
constant NOIDX                         \ not an index

create Oops                            ( n1 -- )
  ," System failure "                  \ All 4tH signals
  ,""                                  \ no errors
  ," Number expected "                 \ number expected
  ," String expected "                 \ string expected
  ," Not an index "                    \ this is not an index
does> swap -1 max 1+ cells + @c count type ." OK" cr ;
                                       ( -- +n)
: number? bl parse-word number error? if NUMEXP throw then abs ;
: string? 0 parse dup 0= if STREXP throw then ;
                                       ( -- a n)
create index?                          ( -- ix)
  ," rank"    ' Sky.Rank ,
  ," name"    ' Sky.Name ,
  ," city"    ' Sky.City ,
  ," country" ' Sky.Country ,
  ," height"  ' Sky.Height ,
  ," floors"  ' Sky.Floors ,
  ," built"   ' Sky.Built ,
  NULL ,
does>                                  \ search for index name
  bl parse-word rot 2 string-key row 2nip
  if cell+ @c >body @ else drop NOIDX throw then
;                                      \ calculate address and fetch
                                       \ print a record
: .record                              ( --)
  ." Rank   : " db.buffer -> Rank count type cr
  ." Name   : " db.buffer -> Name count type cr
  ." City   : " db.buffer -> City count type cr
  ." Country: " db.buffer -> Country count type cr
  ." Height : " db.buffer -> Height_ft count type ."  ft" cr
  9 spaces db.buffer -> Height_m count type ."  m" cr
  ." Floors : " db.buffer -> Floors count type cr
  ." Built  : " db.buffer -> Built count type cr cr
;
                                       \ print n records
: Moving                               ( ix xt n --)
  0 ?do over over execute over idx.error if leave else .record then loop drop
  idx.clear
;
                                       ( n ix xt -- n-1 ix) 
: Start over swap execute dup idx.error 0= if .record then swap 1- swap ;
: Forwards ['] idx.next rot Moving ;   ( n ix --)
: Backwards ['] idx.previous rot Moving ;
: Next number? index? cr dup idx.follow Forwards ;
: Previous number? index? cr dup idx.follow Backwards ;
: _First number? index? cr ['] idx.first Start Forwards ;
: _Last number? index? cr ['] idx.last Start Backwards ;
: Find index? string? rot idx.find if .record else ." Not found " then ;
                                       ( --)
: Help                                 ( --)
  cr ." Available commands:" cr
  ."   FIRST number field" cr
  ."   LAST number field" cr
  ."   FIND field value" cr
  ."   NEXT number field" cr
  ."   PREVIOUS number field" cr
  ."   EXIT" cr
  ."   HELP" cr cr
  ." Available fields:" cr
  ."   Rank, Name, City, Country, Height, Floors, Built" cr
;
                                       \ close indexes and quit 
: bye                                  ( --)
  Sky.Name @ idx.close abort" Cannot close 'Name' index"
  Sky.Height @ idx.close abort" Cannot close 'Height' index"
  Sky.City @ idx.close abort" Cannot close 'City' index"
  Sky.Country @ idx.close abort" Cannot close 'Country' index"
  Sky.Rank @ idx.close abort" Cannot close 'Rank' index"
  Sky.Floors @ idx.close abort" Cannot close 'Floors' index"
  Sky.Built @ idx.close abort" Cannot close 'Built' index"
  db.close abort                       \ close the database
;
                                       \ map commands to words
create wordlist
  ," first"     ' _first ,
  ," last"      ' _last ,
  ," find"      ' find ,
  ," previous"  ' previous ,
  ," next"      ' next ,
  ," exit"      ' bye ,
  ," quit"      ' bye ,
  ," bye"       ' bye ,
  ," help"      ' help ,
  NULL ,

wordlist to dictionary                 \ assign to dictionary
                                       \ open database and all indexes
: init                                 ( --)
  Skyscraper /Skyscraper s" skyscrpr.dbm" db.declare to Sky
  Sky db.use                           \ declare and use it

  {cell} s" skyheigh.idx" idx.load abort" Cannot load 'Height' index"
  Sky.Height !

  {char} s" skyname.idx" idx.load abort" Cannot load 'Name' index"
  Sky.Name !

  {cell} s" skyrank.idx" idx.load abort" Cannot load 'Rank' index"
  Sky.Rank !

  {char} s" skycity.idx" idx.load abort" Cannot load 'City' index"
  Sky.City !

  {char} s" skycount.idx" idx.load abort" Cannot load 'Country' index"
  Sky.Country !

  {cell} s" skyfloor.idx" idx.load abort" Cannot load 'Floors' index"
  Sky.Floors !

  {cell} s" skybuilt.idx" idx.load abort" Cannot load 'Built' index"
  Sky.Built ! ." Ready - type 'HELP' for instructions" cr
;
                                       \ The interpreter itself
: query                                ( --)
  init begin                           \ show the prompt and get a command
    refill drop ['] interpret catch Oops
  again                                \ repeat command loop eternally
;

query                                  \ Ok, the fun starts here!
