\ 4tH - Database joining tables demo - Copyright 2016 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ Attention! First run the CSV loader program "skysload.4th" in
\ the "demo" directory to create the skyscraper database!

\ Second, run the CSV loader program "ustaload.4th" in
\ the "demo" directory to create the US states database!

include lib/dbmidx.4th                 \ include database engine

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

Skyscraper /Skyscraper s" skyscrpr.dbm" db.declare to Sky
Sky db.use                             \ declare and use it
                                       \ open the 'City' index
{char} s" skycity.idx" idx.load abort" Cannot load 'City' index" to Sky.City

struct
  32 +field State                      \ US state name
   4 +field Abbr                       \ US state abbreviation
  16 +field Capital                    \ US state capital
  16 +field Population                 \ US state population
   8 +field Area                       \ US state area (km*km)
   8 +field Seats                      \ US state House seats
end-struct /UState

/UState buffer: UState                 \ allocate room for buffer

UState /UState  s" ustates.dbm" db.declare to US
US db.use                              \ declare and use it
                                       \ Open the 'Capital' index
{char} s" uscapitl.idx" idx.load abort" Cannot load 'Capital' index" to US.Capital

\ SELECT US.Capital, US.State, Skyscraper.Name, Skyscraper.Floors
\ FROM US INNER JOIN Skyscraper ON US.Capital = Skyscraper.City
\ ORDER BY US.Capital
                                       \ print the header
." Capital, State, Skyscraper, Floors" cr
." ----------------------------------" cr
US.Capital idx.first                   \ goto the first capital

begin                                  \ ** ENTER THE MAIN LOOP **
  US.Capital idx.error 0=              \ are we end-of-index?
while
  Sky db.use                           \ switch to the 'Skyscraper' table
  UState -> Capital count Sky.City dup idx.clear idx.find
                                       \ find capital using the 'City' index
  if                                   \ if we found it
    begin                              \ print fields from both tables
      UState -> Capital    count type ." , "
      UState -> State      count type ." , "
      Skyscraper -> Name   count type ." , "
      Skyscraper -> Floors count type cr
      Sky.City dup idx.next idx.error 0=
    while                              \ next record; are we end-of-index?
      UState -> Capital count Skyscraper -> City count compare
    until                              \ have we had all records
  then                                 \ for this capital

  US db.use                            \ switch back to 'US' table
  US.Capital idx.next                  \ get the next capital
repeat                                 \ ** END OF MAIN LOOP **

US db.use                              \ switch to 'US' table just to be sure
US.Capital idx.close abort" Cannot close 'Capital' index"
                                       \ close the index
Skyscraper db.use                      \ switch to 'Skyscraper' table
Sky.City idx.close abort" Cannot close 'City' index"
                                       \ close the index
db.close                               \ close the database
