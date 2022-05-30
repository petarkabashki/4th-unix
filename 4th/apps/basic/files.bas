' uBasic demo - Skyscraper DB viewer - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

' This DB uses data from:
' https://en.wikipedia.org/wiki/List_of_tallest_buildings_in_the_world

' The resulting CSV file is very plain, so we don't need the overhead of
' extensive CSV support. It can be found in the "/apps/data" directory.

if set(a, open ("ustates.csv", "r")) < 0 then
  print "Cannot open \qustates.csv\q"  ' open file a for reading
  end                                  ' abort on file opening errors
endif

if set(b, open ("ustates.txt", "w")) < 0 then
  print "Cannot open \qustates.txt\q"  ' open file a for writing
  end                                  ' abort on file opening errors
endif

if read (a) = 0 then                   ' read the header line
  print "Unexpected end of file"       ' if it fails, write the error
  close a                              ' close the files
  close b : end                        ' and terminate
endif

for c = 0 step 1                       ' don't know number of columns
  p = here()                           ' get input buffer position
  y = tok (ord (";"))                  ' parse the first field
until p = here()                       ' until buffer position doesn't change
  write b, show (y)                    ' write it out
next c

close b                                ' close the file
                                       ' reopen it in read mode
if set(b, open ("ustates.txt", "r")) < 0 then
  print "Cannot open \qustates.txt\q"  ' open file a for writing
  end                                  ' abort on file opening errors
endif
                                       ' write the CSV header
e = read(b)                            ' read the line
if e then                              ' if successfully read
  print show (tok(0)); tab (21);       ' print the line
  e = read(b)                          ' now read the next line
  if e then                            ' etc. etc.
    print show (clip (tok(0), 8)); tab (26);
    e = read(b)
    if e then
      print show (tok(0)); tab (45);
      e = read(b)
      if e then
        print show (tok(0)); tab (56);
        e = read(b)
        if e then
          print show (tok(0)); tab (65);
          e = read(b)
          if e then
            print show (chop (tok(0), 6));
          endif
        endif
      endif
    endif
  endif
endif

print : close b                        ' close the file

do while read (a)                      ' as long as not EOF
  for x = 0 to c-1                     ' parse the six fields
    @(x) = tok (ord (";"))             ' and assign them to the array
  next x

  print show (@(0));                   ' now print all the fields
  print tab (21); show (@(1));
  print tab (26); show (@(2));
  print tab (45); show (@(3));
  print tab (56); show (@(4));
  print tab (65); show (@(5))
loop

close a                                ' close the input file
end                                    ' program terminated

