n = 1 : t = 0

Do While( n < 11 )
  If(( n % 2 ) > 0) Then t = t+1
  n = n + 1                      ' add to total if n is odd
Loop                             ' (has remainder from division by 2)
Print "total odd numbers: " ; t  ' prints '5'

n = 1 : t = 0

Do Until( n > 10 )
  If(( n % 2 ) > 0) Then t = t+1
  n = n + 1                      ' add to total if n is odd
Loop                             ' (has remainder from division by 2)
Print "total odd numbers: " ; t  ' prints '5'

End