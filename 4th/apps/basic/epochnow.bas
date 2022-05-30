' Copyright (C) 2010-2019 Oryx Embedded SARL. All rights reserved.

' This program is free software; you can redistribute it and/or
' modify it under the terms of the GNU General Public License
' as published by the Free Software Foundation; either version 2
' of the License, or (at your option) any later version.

' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.

' You should have received a copy of the GNU General Public License
' along with this program; if not, write to the Free Software Foundation,
' Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

' @author Oryx Embedded SARL (www.oryx-embedded.com)
' @version 1.9.2
' https://www.oryx-embedded.com/doc/date__time_8c_source.html
 
@(0) = Dup ("Monday")
@(1) = Dup ("Tuesday")
@(2) = Dup ("Wednesday")
@(3) = Dup ("Thursday")
@(4) = Dup ("Friday")
@(5) = Dup ("Saturday")
@(6) = Dup ("Sunday")

@(7) = Dup ("January")
@(8) = Dup ("February")
@(9) = Dup ("March")
@(10) = Dup ("April")
@(11) = Dup ("May")
@(12) = Dup ("June")
@(13) = Dup ("July")
@(14) = Dup ("August")
@(15) = Dup ("September")
@(16) = Dup ("October")
@(17) = Dup ("November")
@(18) = Dup ("December")

Proc _convertUnixTimeToDate (Time())
End

_computeDayOfWeek Param(3)
   Local (3)
 
   ' January and February are counted as months 13 and 14 of the previous year
   If (b@ < 3) Then
      b@ = b@ + 12
      a@ = a@ - 1
   EndIf
 
   ' e@ is the century
   e@ = a@ / 100
   ' f@ the year of the century
   f@ = a@ % 100
 
   ' Compute H using Zeller's congruence
   d@ = c@ + (26 * (b@ + 1) / 10) + f@ + (f@ / 4) + (5 * e@) + (e@ / 4);
 
   ' Return the day of the week
Return (@((d@ + 5) % 7))


_convertUnixTimeToDate Param(1)
   Local(10)

   if a@ < 0 then a@ = 0               ' Negative Unix time values are not supported
   b@ = a@ % 60                        ' These are the seconds
   a@ = a@ /60
   c@ = a@ % 60                        ' These are the minutes 
   a@ = a@ / 60 
   d@ = a@ % 24                        ' This is the hour
   a@ = a@ / 24

   e@ = ((4 * a@ + 102032) / 146097 + 15)
   f@ = (a@ + 2442113 + e@ - (e@ / 4))
   g@ = (20 * f@ - 2442) / 7305        ' This is the year
   h@ = f@ - 365 * g@ - (g@ / 4)
   i@ = h@ * 1000 / 30601              ' This is the month
   j@ = h@ - i@ * 30 - i@ * 601 / 1000 ' This is the day

   If (i@ < 14) Then
      g@ = g@ - 4716
      i@ = i@ - 1
   Else
      g@ = g@ - 4715
      i@ = i@ - 13
   EndIf

   k@ = Func(_computeDayOfWeek (g@, i@, j@))

   Print "That's ";Show (k@);", ";Show (@(i@ + 6));" ";j@;" ";g@;
   Print " - ";d@;":";Using "##";c@;":";Using "##";b@ 
Return
    

