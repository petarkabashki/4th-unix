\ 4tH KJots to Gnote converter - Copyright 2020 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/parsexml.4th               \ for SEARCH-TAG
include lib/hash.4th                   \ for FNV1a
include lib/gmkiss.4th                 \ for KISS
include lib/time3339.4th               \ for RFC3339
include lib/argopen.4th                \ for ARG-OPEN
include lib/refills.4th                \ for >MARK
include lib/leading.4th                \ for -LEADING
include lib/istype.4th                 \ for IS-XML
include lib/asciixml.4th               \ for ASCII>XML
include lib/throw.4th                  \ for E.USER
include lib/cut.4th                    \ for >CUT
include lib/ulcase.4th                 \ for S>LOWER
\ include lib/anstools.4th               \ for .S
                                       \ GNote XML tags
s| <note version="0.3" xmlns:link="http://beatniksoftware.com/tomboy/link" | sconstant ng-note1
s| xmlns:size="http://beatniksoftware.com/tomboy/size" xmlns="http://beatniksoftware.com/tomboy">| sconstant ng-note2
s| <text xml:space="preserve"><note-content version="0.1">| sconstant ng-text
s| </note-content></text>| sconstant ng-/text
s| </note>| sconstant ng-/note

8196 constant /mytib                   \ size of custom TIB
/mytib buffer: mytib                   \ define custom TIB

1024 string title                      \ store note title
  48 string notename                   \ store note filename

/cell 4 - [IF]                         \ if 64bit environment
  [IGNORE] correct                     \ don't correct anything
[ELSE]                                 \ if 32bit environment
  : correct dup 0< if invert then ;    \ invert number when negative
[THEN]

\ GNote filenames
\ ===============
\ Format : xx-x-x-x-xxx.note           ( x = hhhh)
\ Example: 5833271e-6c7e-4d66-8553-9f3458c4c926.note
                                       ( n1 -- a n2)
: xx correct hex <# # # # # # # # # #> decimal ;
                                       \ filename components
: -x-x                                 ( n1 -- a n2) 
  correct hex <# # # # # [char] - hold # # # # [char] - hold #> decimal
;
                                       
: create-notename                      ( -- a n)
  kiss xx   notename place             \ first 8 random digits 
  kiss -x-x notename +place            \ second 8 random digits
  kiss -x-x notename +place            \ third 8 random digits
  title count fnv1a xx notename +place
  s" .note" notename +place            \ add hash from title + extension
  notename count s>lower               \ put filename on the stack
;
                                       \ write a Gnote header
: write-header                         ( --)
  ng-note1 type ng-note2 type cr
  ." <title>" title count type ." </title>" cr
  ng-text type
;
                                       \ write footer date lines
: write-dates                          ( --) 
  time tz rfc3339                      \ make RFC 3339 date line
  2dup ." <last-change-date>" type ." </last-change-date>" cr
  2dup ." <last-metadata-change-date>" type ." </last-metadata-change-date>" cr
  ." <create-date>" type ." </create-date>" cr
;                                      \ write all dates
                                       \ write GNote footer
: write-footer                         ( --)
  ng-/text type cr write-dates
  ." <cursor-position>1</cursor-position>" cr
  ." <width>450</width>" cr
  ." <height>360</height>" cr
  ." <x>0</x>" cr
  ." <y>0</y>" cr
  ." <open-on-startup>False</open-on-startup>" cr
  ng-/note type cr
;
                                       ( a n --)
: xml-type bounds ?do i c@ dup is-xml if ASCII>XML type else emit then loop ;
                                       \ write the contents of the note
: write-contents                       ( a n --)
  xml-type cr begin                    \ write first line, strip tag
    refill                             \ get the next line
  while                                \ parse and see if we're done
    0 parse s" ]]>" cut< >r xml-type cr r> ?exit
  repeat                               \ if so, strip the tag and exit
;
                                       \ write the note
: write-note                           ( a n --)
  create-notename output open error?   \ open the output file
  if                                   \ if error, then issue a message
    drop 2drop ." Cannot create note '" title count type ." '" cr
  else                                 \ if not, write the note
    dup use >r write-header write-contents write-footer r> close
  then                                 \ and close the file
;
                                       \ write the file
: write-file                           ( --)
  begin
    0 parse s" <![CDATA[" >cut         \ search for <![CDATA[ tag
  except                               \ if not, get the next line
    2drop refill 0= E.USER throw" Page doesn't contain any data"
  repeat write-note                    \ return false if no more file
;
                                       \ process an entire page
: process-page                         ( --)
  s" <Title>" find-tag compare E.USER throw" Page doesn't have a title"
  [char] < parse -leading -trailing title place
  s" <Text>" find-tag compare E.USER throw" Page doesn't contain any text"
  write-file                           \ if found, write the file
;
                                       \ find the next page
: find-pages                           ( --)
  begin                                \ find a <KJotsPage> tag
    s" <KJotsPage>" find-tag compare except
    >mark ['] process-page catch       \ find a <Title> tag and process
    if mark> else mark- then           \ catch "not found" errors
  repeat                               \ the KJots page
;

: kjots>gnote                          ( --)
  argn 1 = abort" Usage: kjots2gn <filename>"
  !mark kiss-randomize mytib /mytib source! input 1 arg-open find-pages close
;                                      \ set up for processing

kjots>gnote                            \ now convert it

