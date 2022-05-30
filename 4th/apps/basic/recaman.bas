' uBasic/4tH - Recaman's sequence - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

a = 0                                  ' the first one is free ;-)
Print "First 15 numbers:"

For i = 1 Step 1                       ' start loop
  If i<16 Then Print a,                ' print first 15 numbers
  b = Iif ((a-i<1) + (Func(_Peek(Max(0, a-i)))), a+i, a-i)
  If Func(_Peek(b)) Then Print "\nFirst repetition: ";b : Break
  Proc _Set(Set(a, b))                 ' set bit in bitmap
Next
End                                    ' terminate program
                                       ' bitmap functions
_Set  Param(1) : Let @(a@/32) = Func(_Poke(a@/32, a@%32)) : Return
_Poke Param(2) : Return (Or(@(a@), Shl(1, b@)))
_Peek Param(1) : Return (And(@(a@/32), Shl(1, a@%32))>0)
