10 PRINT TAB(30);"ROCKET"
20 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT:PRINT:PRINT
70 PRINT "LUNAR LANDING SIMULATION"
80 PRINT "----- ------- ----------": PRINT
100 C=ASK("DO YOU WANT INSTRUCTIONS (YES OR NO)? ")
110 IF PEEK(C, 0) = ORD("n") THEN 390
160 PRINT
200 PRINT "YOU ARE LANDING ON THE MOON AND AND HAVE TAKEN OVER MANUAL"
210 PRINT "CONTROL 1000 FEET ABOVE A GOOD LANDING SPOT. YOU HAVE A DOWN-"
220 PRINT "WARD VELOCITY OF 50 FEET/SEC. 150 UNITS OF FUEL REMAIN."
225 PRINT
230 PRINT "HERE ARE THE RULES THAT GOVERN YOUR APOLLO SPACE-CRAFT:": PRINT
240 PRINT "(1) AFTER EACH SECOND THE HEIGHT, VELOCITY, AND REMAINING FUEL"
250 PRINT "    WILL BE REPORTED VIA DIGBY YOUR ON-BOARD COMPUTER."
260 PRINT "(2) AFTER THE REPORT A '?' WILL APPEAR. ENTER THE NUMBER"
270 PRINT "    OF UNITS OF FUEL YOU WISH TO BURN DURING THE NEXT"
280 PRINT "    SECOND. EACH UNIT OF FUEL WILL SLOW YOUR DESCENT BY"
290 PRINT "    1 FOOT/SEC."
310 PRINT "(3) THE MAXIMUM THRUST OF YOUR ENGINE IS 30 FEET/SEC/SEC"
320 PRINT "    OR 30 UNITS OF FUEL PER SECOND."
330 PRINT "(4) WHEN YOU CONTACT THE LUNAR SURFACE. YOUR DESCENT ENGINE"
340 PRINT "    WILL AUTOMATICALLY SHUT DOWN AND YOU WILL BE GIVEN A"
350 PRINT "    REPORT OF YOUR LANDING SPEED AND REMAINING FUEL."
360 PRINT "(5) IF YOU RUN OUT OF FUEL THE '?' WILL NO LONGER APPEAR"
370 PRINT "    BUT YOUR SECOND BY SECOND REPORT WILL CONTINUE UNTIL"
380 PRINT "    YOU CONTACT THE LUNAR SURFACE.":PRINT
390 PRINT "BEGINNING LANDING PROCEDURE..........":PRINT
400 PRINT "G O O D  L U C K ! ! !"
420 PRINT:PRINT
430 PRINT "SEC  FEET      SPEED     FUEL     PLOT OF DISTANCE"
450 PRINT
455 T=0:H=1000:V=50:F=150
490 PRINT T;TAB(6);H;TAB(16);V;TAB(26);F;TAB(35);"I";TAB(H/13);"*"
500 INPUT B
510 IF B<0 THEN 650
520 IF B>30 THEN B=30
530 IF B>F THEN B=F
540 W=V-B+5
560 F=F-B
570 H=H-(V+W)/2-(T%2)
580 IF H<1 THEN 670
590 T=T+1
600 V=W
610 IF F>0 THEN 490
615 IF B=0 THEN 640
620 PRINT "**** OUT OF FUEL ****"
640 PRINT T;TAB(6);H;TAB(16);V;TAB(26);F;TAB(35);"I";TAB(H/13);"*"
650 B=0
660 GOTO 540
670 PRINT "***** CONTACT *****"
680 H=H+(W+V)/2
690 IF B=5 THEN 720
700 D=(-V*(10^2)+FUNC(_SQR(V*V+H*(10-2*B),2)))/((5-B)*(10^2))
710 GOTO 730
720 D=H/V
730 W=V+(5-B)*D
760 PRINT "TOUCHDOWN AT ";T+D;" SECONDS."
770 PRINT "LANDING VELOCITY = ";W;" FEET/SEC."
780 PRINT F;" UNITS OF FUEL REMAINING."
790 IF W#0 THEN 810
800 PRINT "CONGRATULATIONS! A PERFECT LANDING!!"
805 PRINT "YOUR LICENSE WILL BE RENEWED.......LATER."
810 IF ABS(W)<2 THEN 840
820 PRINT "***** SORRY, BUT YOU BLEW IT!!!!"
830 PRINT "APPROPRIATE CONDOLENCES WILL BE SENT TO YOUR NEXT OF KIN."
840 PRINT:PRINT:PRINT
850 C=ASK("ANOTHER MISSION? ")
860 IF PEEK(C, 0) = ORD("y") THEN 390
870 PRINT: PRINT "CONTROL OUT.": PRINT
999 END
' ".. And now for something completely different.."
_SQR Param (2)                         ' This is an integer SQR subroutine.
  Local (1)                            ' A@ holds 10, B@ holds 4, now comes C@
  b@ = (10^(b@*2)) * a@                ' Output is scaled by 10^B@).
  a@ = b@
  Do
    c@ = (a@ + (b@ / a@))/2
  Until (Abs(a@ - c@) < 2)
    a@ = c@
  Loop
Return (c@)
