' uBasic/4tH Damm algorithm - Copyright 2020 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

' See also: http://rosettacode.org/wiki/Damm_algorithm

' The Damm algorithm is a checksum algorithm which detects all single digit
' errors and adjacent transposition errors. 

Push 0, 3, 1, 7, 5, 9, 8, 6, 4, 2: i = FUNC(_Data(0))
Push 7, 0, 9, 2, 1, 5, 4, 8, 6, 3: i = FUNC(_Data(i))
Push 4, 2, 0, 6, 8, 7, 1, 3, 5, 9: i = FUNC(_Data(i))
Push 1, 7, 5, 0, 9, 8, 3, 4, 2, 6: i = FUNC(_Data(i))
Push 6, 1, 2, 3, 0, 4, 5, 9, 7, 8: i = FUNC(_Data(i))
Push 3, 6, 7, 4, 2, 0, 9, 5, 8, 1: i = FUNC(_Data(i))
Push 5, 8, 6, 9, 7, 2, 0, 1, 3, 4: i = FUNC(_Data(i))
Push 8, 9, 4, 5, 3, 6, 2, 0, 1, 7: i = FUNC(_Data(i))
Push 9, 4, 3, 8, 6, 1, 7, 2, 0, 5: i = FUNC(_Data(i))
Push 2, 5, 8, 1, 4, 3, 6, 7, 9, 0: i = FUNC(_Data(i))
                                       ' Read the table
Push 112949, 112946, 5727, 5724        ' Put numbers on the stack

For i = 1 To Used()                    ' Read up to the number of stack items
  Print Using "______"; Tos();" is ";  ' Print the header
  If FUNC(_Damm (Str(Pop()))) Then Print "in";
  Print "valid"                        ' invalid only if Damm() returns TRUE
Next                                   ' Next stack item

End

_Data Param (1)                        ' Reads data in reverse order,
  Local (2)                            ' starting with A@
  
  c@ = a@ + Used()                     ' Calculate next offset

  For b@ = c@-1 To a@ Step -1          ' Now place the elements 
    @(b@) = Pop()                      ' that are retrieved from the stack
  Next b@                              ' Next item

Return (c@)                            ' Return new offset


_Damm Param (1)                        ' Perform the Damm algorithm
  Local (2)                            

  c@ = 0                               ' Reset the flag
  For b@ = 0 To Len(a@) - 1            ' Check all characters in the string
    c@ = @(c@*10 + peek(a@, b@) - ord("0"))
  Next                                 ' Next character

Return (c@)                            ' Return Flag

