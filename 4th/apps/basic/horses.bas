' uBasic - The Fastest Horses - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

' Pick the three FASTEST horses - no clocks allowed!
' Maximum 5 horses per race.

' We measure time - but we won't select them that way!
' It is there for you to check and for us to determine the position.

' See: https://www.youtube.com/watch?v=i-xqRDwpilM

                                       ' we will name our horses
Push Dup("Bella"), Dup("Alex"), Dup("Lilly"), Dup("Alexia"), Dup("Fancy")
Push Dup("Sugar"), Dup("Lady"), Dup("Tucker"), Dup("Dakota"), Dup("Cash")
Push Dup("Daisy"), Dup("Spirit"), Dup("Cisco"), Dup("Annie"), Dup("Buddy")
Push Dup("Whiskey"), Dup("Chance"), Dup("Blue"), Dup("Molly"), Dup("Ginger")
Push Dup("Gypsy"), Dup("Charlie"), Dup("Ranger"), Dup("Star"), Dup("Willow")

For x = 0 To 24
  @(x) = Pop()                         ' set a name
  @(x+25) = 0                          ' set a race
  @(x+50) = 0                          ' set a time
  @(x+75) = 0                          ' set a position
  @(x+100) = 0                         ' only for winners
Next

For x = 1 To 5                         ' we got five races
  For r = 1 Until r > 5                ' we got five horses
    If @(25 + Set(z, Rnd(25))) = 0 Then @(z+25) = r : r=r+1
  Next                                 ' assign them randomly
Next

For r = 1 To 5                         ' ok, let them run
  Print "This is race number ";r;"! Starting are:"
  For x = 0 To 24
    If @(x+25) = r Then                ' if horse is participating
       Print "* ";Show (@(x))          ' show its name
       @(x+50) = 4000 + Rnd(2000)      ' and decide its time
    EndIf
  Next

  Print: Proc _Race (r): Print
Next                                   ' next race
                                       ' ok, half final
Print "This is the half final! Starting are:"

For x = 0 To 24                        ' scan all horses
  If @(x+75) = 1 Then                  ' if horse is a winner
     @(x+100) = @(x+25)                ' save the old race for later
     @(x+25) = 6                       ' this horse is participating
     @(x+75) = 0                       ' but position is unknown
     Print "* ";Show (@(x))            ' show its name
  EndIf
Next

Print: Proc _Race (6): Print

For x = 0 To 24                        ' first three from half final
   If (@(x+25) = 6) * (@(x+75) < 4) Then
      If @(x+75) > 1 Then              ' position two or three?
        If @(x+75) = 2 Then            ' if second position in half final
            For y = 0 To 24            ' get the second position from 1st race
              If (@(x+100) = @(y+25)) * (@(y+75) = 2) Then
                @(y+25) = 7
                @(y+75) = 0
                Break
              EndIf
            Next
        EndIf
        @(x+25) = 7                    ' second and third position from
        @(x+75) = 0                    ' half final are in as well
      Else
        For y = 0 To 24                ' winner of the half final
          If (@(x+100) = @(y+25)) * ((@(y+75) = 2) + (@(y+75) = 3)) Then
             @(y+25) = 7               ' get second and third from 1st race
             @(y+75) = 0
          EndIf
        Next
      EndIf
   EndIf
Next
                                       ' let's see what we got
Print "This is the final! Starting are:"
For x = 0 To 24
  If @(x+25) = 7 Then Print "* ";Show (@(x))
Next

Print: Proc _Race (7): Print           ' evaluate the winner

For x = 0 To 24                        ' which are the fastest horses
  If (@(x+25) = 6) * (@(x+75) = 1) Then
     Print Show (@(x));Tab(8);"is the fastest horse"
  EndIf                                ' winner of the half final

  If (@(x+25) = 7) * (@(x+75) = 1) Then
     Print Show (@(x));Tab(8);"is the second fastest horse"
  EndIf                                ' winner of the final

  If (@(x+25) = 7) * (@(x+75) = 2) Then
     Print Show (@(x));Tab(8);"is the third fastest horse"
  EndIf                                ' 2nd place final
Next

End

_Race Param(1)                         ' input: the race
  Local(4)

  For b@ = 1 To 5                      ' determine all 5 positions
    c@ = 6000                          ' reset the time

    For d@ = 0 To 24                   ' test all horses
      If @(d@+25) = a@ Then            ' is a horse participating?
         If (@(d@+50) < c@) Then       ' is it faster than the time given?
            If @(d@+75) = 0 Then       ' is its position still open?
               c@ = @(d@+50)           ' then we found the fastest time
               e@ = d@                 ' and this is a candidate for that
            EndIf                      ' particular position
         EndIf
      EndIf
    Next

    @(e@+75) = b@                      ' definitely set the position
    Print b@;": ";Show (@(e@));Tab(10);Using " in ##.## secs";@(e@+50)
  Next
Return

