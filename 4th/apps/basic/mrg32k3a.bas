' This is a 32-bit combined multiple recursive generator with two components
' of order 3.

' MRG32k3a combined generator meets the requirements for modern RNGs,
' such as good multidimensional uniformity, or a long period. Optimization
' for various architectures makes it competitive with the other VS BRNGSs
' in terms of speed.

@(0) = 0                               ' First generator
@(1) = 1403580
@(2) = -810728
m = SHL(1, 32) - 209

@(3) = 527612                          ' Second generator
@(4) = 0
@(5) = -1370589
n = SHL(1, 32) - 22853

Proc  _Seed(1234567)
Print FUNC(_NextInt)
Print FUNC(_NextInt)
Print FUNC(_NextInt)
Print FUNC(_NextInt)
Print FUNC(_NextInt)
End

_Mod Param(2)
  Local(1)
  c@ = a@ % b@
  If c@ < 0 Then
     If b@ < 0 Then
       Return (c@-b@)
     Else
       Return (c@+b@)
     Endif
  EndIf
Return (c@)

_Seed Param(1)                         ' seed the PRNG
  @(6) = a@
  @(7) = 0
  @(8) = 0

  @(9)  = a@
  @(10) = 0
  @(11) = 0
Return

_NextInt                               ' get the next random integer value
  Local(3)

  a@ = FUNC(_Mod((@(0) * @(6) + @(1) *  @(7) + @(2) *  @(8)), m))
  b@ = FUNC(_Mod((@(3) * @(9) + @(4) * @(10) + @(5) * @(11)), n))
  c@ = FUNC(_Mod(a@ - b@, m))

  ' keep last three values of the first generator
  @(8) = @(7)
  @(7) = @(6)
  @(6) = a@

  ' keep last three values of the second generator
  @(11) = @(10)
  @(10) = @(9)
  @(9)  = b@

Return (c@ + 1)

