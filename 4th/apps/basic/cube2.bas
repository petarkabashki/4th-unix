10 REM PRINT TAB(34);"CUBE"
20 REM PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 REM PRINT : PRINT : PRINT
100 INPUT "DO YOU WANT TO SEE THE INSTRUCTIONS? (YES--1,NO--0); ";A
120 IF A=0 THEN GOTO 370
130 PRINT "THIS IS A GAME IN WHICH YOU WILL BE PLAYING AGAINST THE"
140 PRINT "RANDOM DECISION OF THE COMPUTER. THE FIELD OF PLAY IS A"
150 PRINT "CUBE OF SIDE 3. ANY OF THE 27 LOCATIONS CAN BE DESIGNATED"
160 PRINT "BY INPUTING THREE NUMBERS SUCH AS 2,3,1. AT THE START,"
170 PRINT "YOU ARE AUTOMATICALLY AT LOCATION 1,1,1. THE OBJECT OF"
180 PRINT "THE GAME IS TO GET TO LOCATION 3,3,3. ONE MINOR DETAIL:"
190 PRINT "THE COMPUTER WILL PICK, AT RANDOM, 5 LOCATIONS AT WHICH"
200 PRINT "IT WILL PLANT LAND MINES. IF YOU HIT ONE OF THESE LOCATIONS"
210 PRINT "YOU LOSE. ONE OTHER DETAIL: YOU MAY MOVE ONLY ONE SPACE "
220 PRINT "IN ONE DIRECTION EACH MOVE. FOR  EXAMPLE: FROM 1,1,2 YOU"
230 PRINT "MAY MOVE TO 2,1,2 OR 1,1,3. YOU MAY NOT CHANGE"
240 PRINT "TWO OF THE NUMBERS ON THE SAME MOVE. IF YOU MAKE AN ILLEGAL"
250 PRINT "MOVE, YOU LOSE AND THE COMPUTER TAKES THE MONEY YOU MAY"
260 PRINT "HAVE BET ON THAT ROUND."
270 PRINT
280 PRINT
290 PRINT "ALL YES OR NO QUESTIONS WILL BE ANSWERED BY A 1 FOR YES"
300 PRINT "OR A 0 (ZERO) FOR NO."
310 PRINT
320 PRINT "WHEN STATING THE AMOUNT OF A WAGER, PRINT ONLY THE NUMBER"
330 PRINT "OF DOLLARS (EXAMPLE: 250)  YOU ARE AUTOMATICALLY STARTED WITH"
340 PRINT "500 DOLLARS IN YOUR ACCOUNT."
350 PRINT
360 PRINT "GOOD LUCK!"
370 LET U=500
380 LET A=RND(3)
390 IF A#0 THEN GOTO 410
400 LET A=3
410 LET B=RND(3)
420 IF B#0 THEN GOTO 440
430 LET B=2
440 LET C=RND(3)
450 IF C#0 THEN GOTO 470
460 LET C=3
470 LET D=RND(3)
480 IF D#0 THEN GOTO 500
490 LET D=1
500 LET E=RND(3)
510 IF E#0 THEN GOTO 530
520 LET E=3
530 LET F=RND(3)
540 IF F#0 THEN GOTO 560
550 LET F=3
560 LET G=RND(3)
570 IF G#0 THEN GOTO 590
580 LET G=3
590 LET H=RND(3)
600 IF H#0 THEN GOTO 620
610 LET H=3
620 LET I=RND(3)
630 IF I#0 THEN GOTO 650
640 LET I=2
650 LET J=RND(3)
660 IF J#0 THEN GOTO 680
670 LET J=3
680 LET K=RND(3)
690 IF K#0 THEN GOTO 710
700 LET K=2
710 LET L=RND(3)
720 IF L#0 THEN GOTO 740
730 LET L=3
740 LET M=RND(3)
750 IF M#0 THEN GOTO 770
760 LET M=3
770 LET N=RND(3)
780 IF N#0 THEN GOTO 800
790 LET N=1
800 LET O=RND(3)
810 IF O #0 THEN GOTO 830
820 LET O=3
830 INPUT "WANT TO MAKE A WAGER? ";Z
850 IF Z=0 THEN GOTO 920
860 INPUT "HOW MUCH? ";@(0)
870 IF U<@(0) THEN GOTO 1522
880 LET W=1
890 LET X=1
900 LET Y=1
910 PRINT
920 PRINT "IT'S YOUR MOVE:  ";
930 INPUT P
933 INPUT Q
934 INPUT R
940 IF P>W+1 THEN GOTO 1030
950 IF P=W+1 THEN GOTO 1000
960 IF Q>X+1 THEN GOTO 1030
970 IF Q=(X+1) THEN GOTO 1010
980 IF R >(Y+1)  THEN GOTO 1030
990 GOTO 1050
1000 IF Q>X THEN GOTO 1030
1010 IF R>Y THEN GOTO 1030
1020 GOTO 1050
1030 PRINT:PRINT "ILLEGAL MOVE. YOU LOSE."
1040 GOTO 1440
1050 LET W=P
1060 LET X=Q
1070 LET Y=R
1080 IF P=3 THEN GOTO 1100
1090 GOTO 1130
1100 IF  Q=3 THEN GOTO 1120
1110 GOTO 1130
1120 IF R=3 THEN GOTO 1530
1130 IF P=A THEN GOTO 1150
1140 GOTO 1180
1150 IF Q=B THEN GOTO 1170
1160 GOTO 1180
1170 IF R=C THEN GOTO 1400
1180 IF P=D THEN GOTO 1200
1190 GOTO 1230
1200 IF Q=E THEN GOTO 1220
1210 GOTO 1230
1220 IF  R=F THEN GOTO 1400
1230 IF P=G THEN GOTO 1250
1240 GOTO 1280
1250 IF Q=H THEN GOTO 1270
1260 GOTO 1280
1270 IF R=I THEN GOTO 1400
1280 IF P=J THEN GOTO 1300
1290 GOTO 1330
1300 IF Q=K THEN GOTO 1320
1310 GOTO 1330
1320 IF R=L THEN GOTO 1440
1330 IF P=M THEN GOTO 1350
1340 GOTO 1380
1350 IF Q=N THEN GOTO 1370
1360 GOTO 1380
1370 IF R=O THEN GOTO 1400
1380 PRINT "NEXT MOVE: ";
1390 GOTO 930 
1400 PRINT "******BANG******"
1410 PRINT "YOU LOSE!"
1420 PRINT
1430 PRINT
1440 IF   Z=0 THEN GOTO 1580
1450 PRINT 
1460 LET V=U-@(0)
1470 IF V>0 THEN GOTO 1500
1480 PRINT "YOU BUST."
1490 GOTO 1610
1500 PRINT " YOU NOW HAVE "; V; " DOLLARS."
1510 LET U=V
1520 GOTO 1580
1522 PRINT "TRIED TO FOOL ME; BET AGAIN";
1525 GOTO 870
1530 PRINT "CONGRATULATIONS!"
1540 IF Z=0 THEN GOTO 1580
1550 LET V=U+@(0)
1560 PRINT "YOU NOW HAVE "; V;" DOLLARS."
1570 LET U=V
1580 PRINT "DO YOU WANT TO TRY AGAIN ";
1590 INPUT S
1600 IF S=1 THEN GOTO 380
1610 PRINT "TOUGH LUCK!"
1620 PRINT
1630 PRINT "GOODBYE."
1640 END