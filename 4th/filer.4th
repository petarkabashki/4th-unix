\ FILER - Copyright 2006,2017 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

[pragma] ignorenumbers

include lib/interprt.4th
include lib/ansblock.4th
include lib/padding.4th

\ ENTER    Finds the first free record, then moves four strings delimited
\          by commas into the surname, given, job and phone fields
\          of that record.
\          Usage: ENTER lastname,firstname,job,phone
\ REMOVE   Erases the current record.
\ CHANGE   Changes the contents of the given field in the current record.
\          Usage: CHANGE field-name new-contents
\ GET      Prints the contents of the given type of field from the current
\          record.
\          Usage: GET field-name
\ FIND     Finds the record in which there is a match between the contents
\          of the given field and the given string.
\          Usage: FIND field-name string
\ ANOTHER  Beginning with the next record after the current one, and using
\          KIND to determine type of field, attempts to find a match on WHAT.
\          If successful, types the name; otherwise nothing.
\ ALL      Beginning at the top of the file, uses KIND to determine type of
\          field and finds all matches on WHAT. Types the full name(s).
\ FULLNAME Types the current full name.

       1 constant oops                 \ general error
16 chars constant /column              \ size of any field
  char , constant ','                  \ ASCII character ,
  char - constant '-'                  \ ASCII character -

struct                                 \ field structure
  /column +field surname               \ field surname
  /column +field given                 \ field given name
  /column +field job                   \ field job
  /column +field phone                 \ field telephone
end-struct entry

variable chapter                       \ screen number
variable verse                         \ record number
variable window                        \ address of screen buffer

/column 1+ string what                 \ temporary string search argument
c/l l/scr * entry / 1- constant max-verses
0 value kind                           \ temporary field

:noname oops throw ; is NotFound       ( --)

create fields                          \ phonebook fields
  ," surname" ' surname ,
  ," given"   ' given ,
  ," job"     ' job ,
  ," phone"   ' phone ,
  NULL ,                               \ search fields and return offset 
does>
  bl parse rot 2 string-key row
  if nip nip cell+ @c dup to kind else drop notfound then
;

: select save-buffers dup chapter ! block window ! 0 verse ! ;
: that! /column min what /column srpad 2drop ;
: field! >r that! what r> /column cmove ;
: parse, ',' parse ;                   ( -- a n)
: top 0 select ;                       ( --)
: this window @ verse @ entry * + ;    ( -- a)
: next verse @ max-verses = if chapter @ 1+ select else 1 verse +! then ;
: what? top 0 parse that! ;            ( --)
: .field /column -trailing type ;      ( a --)
: field? this fields + ;               ( -- a)

: _remove this entry '-' fill update ; ( --)
: _get field? .field cr ;              ( --)
: _bye save-buffers quit ;             ( --)
: _change field? 0 parse rot field! update ; 
: _fullname this given .field space this surname .field cr ;

: entry?                               ( -- f)
  this entry bounds                    \ setup record addresses
  begin 2dup > while dup c@ bl = while char+ repeat <>
;

: _enter                               ( --)
  top begin entry? while next repeat   \ find empty entry
  parse, this surname field! parse, this given field!
  parse, this job field! parse, this phone field! update
;
                                       \ search for WHAT
: search                               ( a1 -- a2)
  begin                                \ compare strings
    dup chars this + /column what count compare
  while                                \ not found?
    entry? if next else exit then      \ continue if not empty
  repeat _fullname                     \ print fullname
;

: _another kind next search drop ;     ( --)
: _find fields what? search drop ;     ( --)
: _all kind top begin search entry? while next repeat drop ;

create wordlist                        \ commands
  ," enter"    ' _enter ,
  ," remove"   ' _remove ,
  ," change"   ' _change ,
  ," get"      ' _get ,
  ," fullname" ' _fullname ,
  ," find"     ' _find ,
  ," another"  ' _another ,
  ," all"      ' _all ,
  ," bye"      ' _bye ,
  NULL ,

wordlist to dictionary

: phonebook                            ( --)
  begin
    ." OK" cr refill drop ['] interpret catch
    if ." Oops! " then
  again
;

: setup argn 2 < abort" Usage: filer phonebook.scr" 1 args open-blockfile top ;

setup phonebook
