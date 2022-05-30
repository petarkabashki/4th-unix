' uBasic demo - Text file viewer - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

If Cmd (0) < 2 Then Print "Usage: viewer <file.txt>" : End

a = Open (Cmd (2), "r")

If a < 0 Then Print "Cannot open \q";Show (Cmd (2));"\q" : End

Do While Read (a)
  t = Tok (0)
  Print Show (t)
loop

Close a

