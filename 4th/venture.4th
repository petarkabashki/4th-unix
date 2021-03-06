\ Copyright 1983 by A. Clapman - Design and original ZX BASIC programming
\ Copyright 1996, 2015 by H. Bezemer - Structured design and 4tH programming

\ Permission is granted by the author to use and distribute this software
\ provided these copyright notices are preserved.

\ This file is part of the 4tH compiler package

\ http://www.xs4all.nl/~thebeez/4tH

\ Extract from a time-travellers diary discovered in the pyramid of
\ Ikhotep, pharoah of the ninth dynasty, on the planet Sirius B,
\ in the dog star system.

\ "I have been attempting to discover the secret of the pyramid for some
\ months now. It is the only way I will be able to escape this barren
\ planet. After my time-machine was destroyed by the warrior tribe I
\ found my way to this dusty monument after consulting a man they regard
\ as a wizard. He is in fact a fellow traveller in time and space exiled
\ by the Time Lords to this lost planet. He has decided to stay and
\ persue his black arts amoung the warrior folk. But he has told me of
\ a time gate which will lead me back to the main time lanes and freedom.
\ He said the gate was hidden within the pyramid. I have uncovered some
\ clues but not enough to lead me to the final solution. I can only keep
\ trying. But I feel that, for me at least, time is running out."

\ The diary was found next to a small pile of oddly shaped bones deep
\ within the heart of the pyramid.

\ Can you find your way out of the pyramid and off the barren planet?
\ You will find several rooms within the pyramid and several objects
\ within those rooms which must be collected to solve the riddle of the
\ ancient monument. The program uses the standard two word entry system
\ and adjectives should not be entered. To move simply type in the
\ direction you want to go, for example 'N' or 'north'. Other useful
\ words are TAKE, GET, THROW, DROP, INVENTORY.

\ *** Define the following for your system ***

true constant HARDTAB                  \ if true, 9 EMIT works

\ *** End of customization ***

[needs lib/row.4th]

HARDTAB [IF]
: tab 9 emit ;                         \ print a TAB
[ELSE]
: tab 4 spaces ;                       \ alternative "TAB"
[THEN]

0 constant _todo                       \ is still alive
1 constant _done                       \ is already dead
2 constant _seen                       \ dragon has seen you

1 string dragon?                       \ is dragon alive
1 string tree?                         \ is tree uncut
1 string door?                         \ is the door intact
1 string wall?                         \ is the wall closed
1 string helmet?                       \ is the helmet off
1 string power?                        \ is the power off
                                       \ objects
0 enum watch enum dragon enum generator enum tree      enum slab
  enum door  enum saw    enum mirror    enum reflector enum coin
  enum knife enum dagger enum helmet    enum axe

constant #objects                      \ number of objects

create objects                         \ map vocabulary to objects
  ," watch"     watch ,
  ," dragon"    dragon ,
  ," generator" generator ,
  ," tree"      tree ,
  ," slab"      slab ,
  ," door"      door ,
  ," saw"       saw ,
  ," mirror"    mirror ,
  ," reflector" reflector ,
  ," coin"      coin ,
  ," knife"     knife ,
  ," dagger"    dagger ,
  ," helmet"    helmet ,
  ," axe"       axe ,
  NULL ,

0  constant stays                      \ cannot be moved
1  constant moves                      \ can be moved

create attributes                      \ map attributes to objects
  ," wrist"                  moves ,
  ," magenta, firebreathing" stays ,
  ," mobile electricity"     moves ,
  ," Canadian Redwood"       stays ,
  ," granite"                moves ,
  ," thick wooden"           stays ,
  ," electric"               moves ,
  ," purple"                 moves ,
  ," green"                  moves ,
  ," 10 pence"               moves ,
  ," butter"                 moves ,
  ," razor sharp"            moves ,
  ," safety"                 moves ,
  ," sharp"                  moves ,
                                       \ locations
-1 enum _Exit_       enum _NoWhere_  enum _RoadWE_     enum _RoadBend_
   enum _ShackW_     enum _ShackE_   enum _RoadNS_     enum _RoadN_
   enum _Pyramid_    enum _Embalm_   enum _Recreation_ enum _ANKH_
   enum _Triangular_ enum _Oblong_   enum _Funeral_    enum _Treasure_
   enum _Cave_       constant _Garden_

_Exit_ constant _Person_               \ special location

create locations                       \ map locations to directions
  ," a road leading west and east. Two things are pointing to the west."
  _NoWhere_ , _NoWhere_ , _Exit_ , _RoadBend_ ,
  ," a bend in the road."
  _NoWhere_ , _RoadNS_ , _RoadWE_ , _NoWhere_ ,
  ," a small dark shack."
  _NoWhere_ , _NoWhere_ , _NoWhere_ , _RoadNS_ ,
  ," a small dark shack."
  _NoWhere_ , _NoWhere_ , _RoadNS_ , _Cave_ ,
  ," a road leading north and south. There are shacks either side."
  _RoadBend_ , _RoadN_ , _ShackW_ , _ShackE_ ,
  ," a road leading north. There is a pyramid south."
  _RoadNS_ , _Pyramid_ , _NoWhere_ , _NoWhere_ ,
  ," the entrance hall of the pyramid. There is a road north."
  _RoadN_ , _Oblong_ , _Embalm_ , _Recreation_ ,
  ," the embalming room."
  _NoWhere_ , _NoWhere_ , _ANKH_ , _Pyramid_ ,
  ," the recreation room. An exit to the garden is east."
  _NoWhere_ , _Funeral_ , _Pyramid_ , _Garden_ ,
  ," the room of ANKH."
  _NoWhere_ , _NoWhere_ , _NoWhere_ , _Embalm_ ,
  ," a small triangular room."
  _NoWhere_ , _NoWhere_ , _NoWhere_ , _Oblong_ ,
  ," a long oblong room."
  _Pyramid_ , _Treasure_ , _Triangular_ , _NoWhere_ ,
  ," the funeral parlour."
  _Recreation_ , _NoWhere_ , _NoWhere_ , _NoWhere_ ,
  ," the treasure room. It has been looted. There is a smashed door north."
  _Oblong_ , _NoWhere_ , _NoWhere_ , _NoWhere_ ,
  ," a small circular cave."
  _NoWhere_ , _NoWhere_ , _ShackE_ , _NoWhere_ ,
  ," a small garden."
  _NoWhere_ , _NoWhere_ , _Recreation_ , _NoWhere_ ,

#objects array map                     \ map of objects

create default
   _ShackW_ ,                          \ watch in west shack
   _ShackE_ ,                          \ dragon in east shack
   _RoadBend_ ,                        \ generator in bend of the road
   _Garden_ ,                          \ tree in the garden
   _Funeral_ ,                         \ slab in funeral parlor
   _Oblong_ ,                          \ door in oblong room
   _Triangular_ ,                      \ saw in triangular room
   _ANKH_ ,                            \ mirror in room of ANKH
   _Cave_ ,                            \ reflector in cave
   _Treasure_ ,                        \ coin in treasure room
   _RoadNS_ ,                          \ knife on north/south road
   _NoWhere_ ,                         \ dagger is nowhere
   _Pyramid_ ,                         \ helmet in pyramid
   _NoWhere_ ,                         \ axe is nowhere

: done! _done swap c! ;                \ set a flag
: undo! _todo swap c! ;                \ reset a flag
: right? swap c@ = ;                   \ check a flag

: where? map rot th ;    ( n -- a)     \ where is it?
: here? where? @ = ;     ( n1 n2 -- f) \ is it here?
: put!  where? ! ;       ( n1 n2 --)   \ put it here
: missing? _Person_ here? 0= ;         \ do we have a certain object on us

: initmap                              \ fills the map with values
  #objects 0
  do
    i default over th @c put!
  loop

  dragon? undo!                        \ reset flags
  tree?   undo!
  door?   undo!
  wall?   undo!
  helmet? undo!
  power?  undo!
;
                                       \ default warning
: CANNOT ." YOU CAN'T, IDIOT!!" CR CR ;
: DEAD ." YOU'RE DEAD!!" CR CR quit ;  \ exit game
: IDUNNO drop ." I don't know what a " type ."  is." CR CR ;
: OUTSIDE ." It isn't here!!" CR CR ;  \ not here!
: MISSING ." You aren't carrying it, stupid!!" CR CR ;
: object@ nip nip cell+ @c ;           ( a n1 x -- n2)
: decode bl parse-word rot 2 string-key row ;
                                       ( x -- a n x' f)
variable north
variable south
variable west
variable east

_RoadBend_ value where                 \ room where you are

: direction        ( a var -- a+1 )    \ fill direction variable
  swap cell+ dup @c rot !
;

: room             ( -- xt )           \ get address of room
  where 1- 5 cells * locations +
;

: display          ( a -- )            \ display a string
  @c count type
;

: status?          ( flag where val)   \ check status of special cases
  >r where =
  swap r> right?
  and
;

: seen? _seen status? ; ( flag where)  \ has the dragon seen me?
: done? _done status? ; ( flag where)  \ check special cases are done
: todo? _todo status? ; ( flag where)  \ check special cases to do

: noentry!                             \ keep locked until task is done
  todo?                                \ still to do?
  if _NoWhere_ swap ! else drop then   \ if so, don't allow access
;

: ?north                               \ going north ?
  north @ if ." North" tab then
;

: ?south                               \ going south ?
  south door? _Oblong_ noentry!
  south @ if ." South" tab then
;

: ?west                                \ going west ?
  west wall? _Embalm_ noentry!
  west @ if ." West" tab then
;

: ?east                                \ going east ?
  east dragon? _ShackE_ noentry!
  east @ if ." East" tab then
;

: showcontents                         \ prints the appropriate strings
  tab 2* dup attributes swap th display
  bl emit objects swap th display cr
;

: contents                             \ shows the contents of a room
  0 #objects 0
  do
    i where here?
    if 1+ i showcontents then
  loop
  0= if tab ." None" cr then
                                       \ all exceptions
  where _ShackE_ <>                    \ if we aren't in the shack
  dragon? _seen right? and             \ but the dragon has seen us
  if dragon? undo! then                \ ..we make him forget us

  dragon? _ShackE_ seen?
  if cr ." The dragon doesn't like you so he kills you." cr DEAD then

  dragon? _ShackE_ todo?
  if cr ." The dragon blocks a hole in the EAST wall." cr _seen dragon? c! then

  dragon? _ShackE_ done?
  if cr ." The dragon is dead." cr then

  tree? _Garden_ done?
  if cr ." The tree is lying on the ground." cr then
  
  tree? _Garden_ todo?
  if cr ." There is something glistening at the top of the tree." cr then

  wall? _Embalm_ todo?
  if cr ." There is a small slot on the west wall." cr then

  door? _Oblong_ done?
  if cr ." The door is smashed down." cr then
;

: ?lastroom                            \ when we're ended in the last room
  where _Exit_ =                       \ make sure we're there
  if
    ." LASER BOLTS FLASH OUT FROM THE KILLO-ZAP GUNS FIXED TO THE ROAD!" CR
                                       \ can't we reflect anything?
    mirror missing? reflector missing? and
    if
      ." FRIZZLE!!" CR
      DEAD
    then

    reflector missing?                 \ are we missing a reflector
    if
      ." THE LEFT RAY IS REFLECTED BY THE MIRROR. THE RIGHT ONE ISN'T!!" CR
      DEAD
    then

    mirror missing?                    \ are we missing a mirror
    if
      ." THE RIGHT RAY IS REFLECTED BY THE REFLECTOR. THE LEFT ONE ISN'T!!" CR
      DEAD
    then
                                       \ we got them both!
    ." BOTH THE RAYS ARE REFLECTED BY THE MIRROR AND THE REFLECTOR!!" CR
    ." YOU HAVE MANAGED TO ESCAPE ALIVE!!" CR CR
    quit
  then
;

: showroom                             \ describe a room
  ?lastroom                            \ are we in the last room?
  ." You are at "
  room dup display cr                  \ show location
  north direction                      \ fetch directions
  south direction
  west  direction
  east  direction
  drop
  ." Directions you may proceed in:" cr tab
  ?north ?south ?west ?east CR CR      \ show exits
  ." Things of interest here:" cr      \ show items
  contents
;

: do-move drop false ;                 \ skip this word
                                       \ go in some direction
: do-go                                ( direction -- )
  @ dup 0=                             ( n f )
  if drop CANNOT else to where then
;

: go-north                             \ go north
  north do-go
;

: go-south                             \ go south
  south do-go
;

: go-west                              \ go west
  west do-go
;

: go-east                              \ go east
  east do-go
;

: do-take                              \ take an object
  objects decode
  if                                   \ do we already have it?
    object@ dup _Person_ here?
    if drop ." YOU ARE ALREADY CARRYING IT!!" CR CR exit then
                                       \ do we have a watch?
    dup watch <> watch missing? and
    if drop ." YOU HAVEN'T GOT ANYTHING TO CARRY IT IN!!" CR CR exit then
                                       \ is it here?
    dup where here? 0=
    if drop OUTSIDE exit then
                                       \ can we move it?
    dup 2* 1+ attributes swap th @c stays =
    if drop CANNOT exit then

    dup 0=
    if                                 \ put the watch on
      ." YOU STRAP IT ON YOUR WRIST."
    else                               \ zoom it in your watch
      ." IT ZOOMS SAFELY INTO YOUR WATCH!"
    then

    cr cr                              \ now you carry it
    _Person_ put!
  else
    IDUNNO
  then
;

: do-drop                              \ drop object
  objects decode
  if
    object@ dup missing?               \ do we have it?
    if drop MISSING exit then
                                       \ drop it in the room
    dup where put!
                                       \ put your helmet off
    helmet =
    if helmet? undo! then
  else
    IDUNNO
  then
;

: do-saw                               \ saw tree
  objects decode
  if
    object@ tree <>                    \ saw a tree?
    tree? _done right?                 \ is tree cut?
    generator missing?                 \ do we have a generator?
    saw missing?                       \ do we have a saw?
    or or or

    if CANNOT exit then

    where _Garden_ <>                  \ are we in the garden?
    if OUTSIDE exit then

    power? _todo right?                \ do we have power?
    if ." The saw won't work without electricity!!" cr cr exit then

    helmet? _todo right?               \ are we wearing a helmet?
    if ." The  tree falls on your unprotected head. Crunch." cr cr DEAD then

    tree? done!                        \ now cut the tree
    ." The tree falls down on your safety helmet." cr
    ." An axe falls out of the top of the tree." cr cr
    axe where put!                     \ and show the axe

  else
    IDUNNO
  then
;

: do-smash                             \ smash door
  objects decode
  if
    object@ door <>                    \ do we smash a door?
    axe missing?                       \ do we have an axe?
    door? _done right?                 \ is the door smashed?
    or or

    if CANNOT exit then

    where _Oblong_ <>                  \ are we in the oblong room?
    if OUTSIDE exit then

    ." Chop chop smash smash.. The door has been smashed down." cr cr
    door? done!                        \ now smash the door
  else
    IDUNNO
  then
;

: do-wear                              \ wear helmet
  objects decode
  if                                   \ do we want to wear a helmet?
    object@ helmet <> if CANNOT exit then

    helmet missing?                    \ do we have a helmet?
    if MISSING exit then

    helmet? done!                      \ now put on the helmet
  else
    IDUNNO
  then
;

: do-connect                           \ connect generator
  objects decode
  if
    object@ dup dup                    \ do we connect a generator
    saw <> swap generator <> and       \ or a saw?
    if drop CANNOT exit then

    missing?                           \ do we have it?
    if MISSING exit then

    saw missing? generator missing? or \ do we miss anything?
    if CANNOT exit then

    power? done!                       \ ok, power is on!
  else
    IDUNNO
  then
;

: do-push                              \ push wall
  objects decode
  if
    object@ dup
    coin <>                            \ do we insert a coin?
    if drop CANNOT exit then

    dup missing?                       \ do we have it?
    if drop MISSING exit then

    where _Embalm_ <>                  \ are we in the embalming room?
    if
      drop ." I can't see anywhere to insert it!!"
    else
      _NoWhere_ put!                   \ coin disappears in slot
      ." The wall suddenly shakes and glides one side leaving a doorway west!!"
      wall? done!                      \ the wall is open!
    then

    cr cr
  else
    IDUNNO
  then
;

: do-file                              \ file knife
  objects decode
  if
    object@ dup knife <>               \ do we want to file a knife?
    if drop CANNOT exit then

    missing?                           \ do we have a knife?
    if MISSING exit then

    slab missing?                      \ do we have a slab?
    if
      ." You haven't got anything to sharpen it on!!"
    else
      ." The knife turns extra sharp!!"
      knife  _NoWhere_ put!            \ knife turns into
      dagger _Person_  put!            \ a dagger!
    then

    cr cr
  else
    IDUNNO
  then
;

: do-kill                              \ kill dragon
  objects decode
  if
    object@ dragon <>                  \ do we want to kill a dragon?
    dagger missing?                    \ is the dagger missing?
    or

    if CANNOT exit then

    where _ShackE_ <>                  \ are we in the east shack?
    if OUTSIDE exit then

    dragon? _done right?               \ is the dragon alive?
    if
      ." The poor thing is already dead."
    else
      dragon? done!                    \ now he is!
      ." Squelch. The dagger sinks to the hilt in the dragon." cr
      ." It's dead. Poor thing."
    then

    cr cr
  else
    IDUNNO
  then
;

: do-list                              \ shows the inventory
  ." You are carrying:" cr
  0 #objects 0
  do
    i _Person_ here?
    if cell+ i showcontents then
  loop
  0= if tab ." Nothing" cr then cr
;

: do-die                               \ end game quickly
  ." There is no easy way out of here!!" cr
  ." So you decide to commit suicide." cr
  DEAD
;

create actions                         \ map vocabulary to actions
  ," go"        ' do-move ,
  ," move"      ' do-move ,
  ," run"       ' do-move ,
  ," walk"      ' do-move ,
  ," north"     ' go-north ,
  ," n"         ' go-north ,
  ," south"     ' go-south ,
  ," s"         ' go-south ,
  ," west"      ' go-west ,
  ," w"         ' go-west ,
  ," east"      ' go-east ,
  ," e"         ' go-east ,
  ," get"       ' do-take ,
  ," take"      ' do-take ,
  ," steal"     ' do-take ,
  ," drop"      ' do-drop ,
  ," throw"     ' do-drop ,
  ," leave"     ' do-drop ,
  ," saw"       ' do-saw ,
  ," cut"       ' do-saw ,
  ," fell"      ' do-saw ,
  ," chop"      ' do-smash ,
  ," smash"     ' do-smash ,
  ," axe"       ' do-smash ,
  ," wear"      ' do-wear ,
  ," connect"   ' do-connect ,
  ," insert"    ' do-push ,
  ," push"      ' do-push ,
  ," sharpen"   ' do-file ,
  ," file"      ' do-file ,
  ," kill"      ' do-kill ,
  ," stab"      ' do-kill ,
  ," knife"     ' do-kill ,
  ," invent"    ' do-list ,
  ," objects"   ' do-list ,
  ," inventory" ' do-list ,
  ," list"      ' do-list ,
  ," die"       ' do-die ,
  ," exit"      ' do-die ,
  ," quit"      ' do-die ,
  NULL ,

: action                              \ decode & execute action
  actions decode                      ( a n x f)
  if object@ execute
  else drop ." I don't know" dup if ."  how to " then type [char] . emit cr cr
  then
;

: command                              \ input a command
  cr ." Command: " refill drop cr
  action
;

: venture                              \ main program
  initmap
  begin
    showroom
    command
  again
;

[DEFINED] 4TH# [IF] venture [THEN]
