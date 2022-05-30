' Several familiar BASIC string functions in uBasic/4tH
' J.L. Bezemer 2019

a = Func (_Mid (Dup ("This is the end"), 1, 5))
b = Dup (a)
Print Show (b)
Print Func (_Search (Dup ("This is the end"), Dup ("the")))

End

_Left  Param (2): Return (Clip (a@, Len (a@) - b@))
_Right Param (2): Return (Chop (a@, Len (a@) - b@))
_Mid   Param (3): Return (Clip (Chop (a@, b@), Len (a@) - b@ - c@))

_Search Param (2)
  Local (1)
  For c@ = 0 to Len (a@) - Len (b@)
    If Comp(Clip(Chop(a@,c@),Len(a@)-c@-Len(b@)),b@)=0 Then Unloop : Return (c@)
  Next
Return (-1)

