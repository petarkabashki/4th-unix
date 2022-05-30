' "Weasel program" for uBasic, J.L. Bezemer 2020

' The weasel program or Dawkins' weasel is a thought experiment and a variety
' of computer simulations illustrating it. Their aim is to demonstrate that
' the process that drives evolutionary systems—random variation combined with
' non-random cumulative selection—is different from pure chance.

' The thought experiment was formulated by Richard Dawkins, and the first
' simulation written by him; various other implementations of the program have
' been written by others.

' https://en.wikipedia.org/wiki/Weasel_program 

T = Dup("METHINKS IT IS LIKE A WEASEL")
P = Dup("IU RFSGJABGOLYWF XSMFXNIABKT")
M = 5                 ' mutation rate, higher means faster
C = 100               ' generations per generation, higher means faster 
G = 0                 ' generation counter, don't change

DO
  F = 0
  I = 0
  FOR J = 1 TO C
    @(J) = Func (_FNmutate (P, M))
    H = Func (_FNfitness(T, @(J)))
    IF H > F THEN
      F = H
      I = J
    ENDIF
  NEXT
 
  P = @(I)
  PRINT G, Show(P)
  UNTIL Comp(P, T) = 0
  G = G +1
LOOP
END
 
_FNfitness PARAM(2)
  LOCAL (2)
  D@ = 0
  FOR C@ = 0 TO Len(A@)-1
    IF Peek(A@, C@) = Peek(B@, C@) THEN D@ = D@+1
  NEXT
RETURN ((D@*1000)/Len(A@))
 
_FNmutate PARAM(2)
  LOCAL(3)
  IF B@ > Rnd(10) THEN
    C@ = 64+Rnd(27)
    IF C@ = 64 THEN 
      C@ = 32
    ENDIF
    D@ = Rnd(Len(A@))
    E@ = Join(Clip(A@, Len(A@) - (D@)), Char(C@), Chop(A@, (D@+1)))
  ELSE
    E@ = A@
  ENDIF
RETURN (E@)

