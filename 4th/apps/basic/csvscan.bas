' CSVSCAN - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

' This program analyzes a CSV file, lists the number of lines and columns
' and lists all columns with the maximum length of the fields found.
' The first line of the CSV file MUST contain a list of all fields involved.

' ==========
' Initialize
' ==========
                                       ' show usage when required
If Cmd (0) < 2 Then Print "Usage: csvscan [-cASCII] <file.csv>" : End
                                       ' has an option "-c" been given?
If (Cmd(0) = 3) * (Comp ("-c", Clip (Cmd(2), Len (Cmd(2))-2)) = 0) Then
   d = Val(Chop (Cmd(2),2))            ' if so, evaluate it
   f = Cmd(3)                          ' filename comes after it
Else
   d = Ord (";")                       ' default to a semi colon
   f = Cmd(2)
EndIf

a = Open (f, "r")                      ' now open the file
If a < 0 Then Print "Cannot open \q";Show (f);"\q" : End
                                       ' read the first line
' ========
' Scanning
' ========

If Read (a) = 0 Then Print "Cannot read \q";Show (f);"\q" : End
                                       ' read up to 80 columns
For c = 0 To 79
  t = Tok(d)                           ' parse the next field
While Len(t) > 0                       ' we're out of columns
  @(c) = t                             ' save column name in array
Next c                                 ' get the next column

r = 0                                  ' we've read no data rows
Do While Read(a)                       ' read the next row
  r = r + 1                            ' increment count of rows
  For x = 0 To c-1                     ' now read all the fields
    t = Tok(d)                         ' take care of embedded quotes
    If Peek (t, 0) = 34 Then t = Chop (Clip (t ,1), 1)
    If Comp ("", t) Then @(x+80) = @(x+80) + 1
    If Len (t) > @(x+160) Then @(x+160) = Len (t)
  Next x                               ' keep count of maximum length
Loop

Close a                                ' done, close the file

' =========
' Reporting
' =========
                                       ' now print the header
Print Show(f);": ";c;" columns, ";r;" rows"
Print

For x = 0 To c-1                       ' print all the fields
  Print "[";Using "__";x+1;"] ";Show(@(x));
  Print Tab(40);":";Using "____#";@(x+160);" ";
  Print Using "  (__#.##%)";((@(x+80)*10000)/r)
Next x                                 ' next field

