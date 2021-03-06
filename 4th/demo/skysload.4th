\ 4tH demo - Skyscraper DB loader - Copyright 2014,2015 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ This DB uses data from:
\ https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world

\ The resulting CSV file is very plain, so we don't need the overhead of
\ loading extensive CSV support. It can be found in the "/apps/data" directory.

include lib/dbmidx.4th

struct
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

: Field> [char] ; parse ;              \ helper word to read the fields

." Creating skyscraper database.." cr

s" skyscrpr.dbm" db.create             \ create the DB file
Skyscraper /Skyscraper s" skyscrpr.dbm" db.declare to Sky
Sky db.use                             \ declare and use it

512 {cell} db.key Height_ft idx.init abort" Cannot create 'Height' index"
to Sky.Height

512 {char} db.key Name idx.init abort" Cannot create 'Name' index"
to Sky.Name

512 {cell} db.key Rank idx.init abort" Cannot create 'Rank' index"
to Sky.Rank

512 {char} db.key City idx.init abort" Cannot create 'City' index"
to Sky.City

512 {char} db.key Country idx.init abort" Cannot create 'Country' index"
to Sky.Country

512 {cell} db.key Floors idx.init abort" Cannot create 'Floors' index"
to Sky.Floors

512 {cell} db.key Built idx.init abort" Cannot create 'Built' index"
to Sky.Built

s" skyscrpr.csv" input open            \ open the CSV file and abort on error
error? abort" Cannot open 'skyscrpr.csv'"
dup use                                \ everything OK, now use it
                                       \ skip the field description
refill 0= abort" Cannot read 'skyscrpr.csv'"

begin
  refill                               \ read next CSV record
while
  db.clear                             \ clear the DB buffer
    Field> db.buffer -> Rank      place
    Field> db.buffer -> Name      place
    Field> db.buffer -> City      place
    Field> db.buffer -> Country   place
    Field> db.buffer -> Height_m  place
    Field> db.buffer -> Height_ft place
    Field> db.buffer -> Floors    place
    Field> db.buffer -> Built     place
  db.insert                            \ read fields and insert record

  Sky.Name    idx.insert drop          \ update index, drop flag
  Sky.Height  idx.insert drop          \ update index, drop flag
  Sky.City    idx.insert drop          \ update index, drop flag
  Sky.Country idx.insert drop          \ update index, drop flag
  Sky.Rank    idx.insert drop          \ update index, drop flag
  Sky.Floors  idx.insert drop          \ update index, drop flag
  Sky.Built   idx.insert drop          \ update index, drop flag
repeat
                                       \ save 'names' index
Sky.Name dup s" skyname.idx"  idx.save
idx.close abort" Cannot close 'Name' index"
                                       \ save 'height' index
Sky.Height dup s" skyheigh.idx" idx.save
idx.close  abort" Cannot close 'Height' index"
                                       \ save 'city' index
Sky.City  dup s" skycity.idx" idx.save
idx.close  abort" Cannot close 'City' index"
                                       \ save 'country' index
Sky.Country dup s" skycount.idx" idx.save
idx.close  abort" Cannot close 'Country' index"
                                       \ save 'rank' index
Sky.Rank dup s" skyrank.idx" idx.save
idx.close  abort" Cannot close 'Rank' index"
                                       \ save 'floor' index
Sky.Floors dup s" skyfloor.idx" idx.save
idx.close  abort" Cannot close 'Floors' index"
                                       \ save 'built' index
Sky.Built dup s" skybuilt.idx" idx.save
idx.close  abort" Cannot close 'Built' index"

db.close                               \ close the database
close                                  \ close the CSV file

." Skyscraper database successfully created.." cr