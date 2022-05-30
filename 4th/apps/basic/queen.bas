1 REM PRINT TAB(33);"QUEEN"
2 REM PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
3 PRINT:PRINT:PRINT
10 REM DIM S(64)
12 FOR J=0 TO 7
15 FOR I=1 TO 8 : @(I+(J*8))=91+(J*11)-10*I : NEXT I
20 NEXT J
22 INPUT "DO YOU WANT INSTRUCTIONS (1=yes, 0=no)? ";W
23 IF W=0 THEN GOTO 30
24 IF W=1 THEN GOTO 28
25 PRINT "PLEASE ANSWER 'YES' OR 'NO'."
26 GOTO 22
28 GOSUB 5000
29 GOTO 100
30 GOSUB 5160
90 REM     ERROR CHECKS
100 INPUT "WHERE WOULD YOU LIKE TO START? "; N
115 IF N=0 THEN GOTO 232
120 O=N/10 
130 Q=N-10*O
140 IF Q=1 THEN GOTO 200
150 IF Q=O THEN GOTO 200
160 PRINT "PLEASE READ THE DIRECTIONS AGAIN."
170 PRINT "YOU HAVE BEGUN ILLEGALLY."
175 PRINT
180 GOTO 100
200 GOSUB 2000
210 PRINT "COMPUTER MOVES TO SQUARE ";M
215 IF M=158 THEN GOTO 3400
230 INPUT "WHAT IS YOUR MOVE? ";N
231 IF N#0 THEN GOTO 239
232 PRINT
233 PRINT "IT LOOKS LIKE I HAVE WON BY FORFEIT."
234 PRINT
235 GOTO 4000
239 IF N<(M+1) THEN GOTO 3200
240 O=N/10
250 Q=N-10*O
260 P=Q-U
270 IF P#0 THEN GOTO 300
280 L=O-T
290 IF L<1 THEN GOTO 3200
295 GOTO 200
300 IF O-T#P THEN GOTO 320
310 GOTO 200
320 IF O-T#2*P THEN GOTO 3200
330 GOTO 200
1990 REM     LOCATE MOVE FOR COMPUTER
2000 IF N=41 THEN GOTO 2180
2010 IF N=44 THEN GOTO 2180
2020 IF N=73 THEN GOTO 2180
2030 IF N=75 THEN GOTO 2180
2040 IF N=126 THEN GOTO 2180
2050 IF N=127 THEN GOTO 2180
2060 IF N=158 THEN GOTO 3300
2065 C=0
2070 K=7
2080 U=Q
2090 T=O+K
2100 GOSUB 3500
2105 IF C=1 THEN GOTO 2160
2110 U=U+K
2120 GOSUB 3500
2125 IF C=1 THEN GOTO 2160
2130 T=T+K
2140 GOSUB 3500
2145 IF C=1 THEN GOTO 2160
2150 K=K-1 : IF K>0 THEN GOTO 2080
2155 GOTO 2180
2160 C=0
2170 RETURN
2180 GOSUB 3000
2190 RETURN
2990 REM     RANDOM MOVE
3000 Z=RND(10)
3010 IF Z>6 THEN GOTO 3110
3020 IF Z>3 THEN GOTO 3070
3030 U=Q
3040 T=O+1
3050 M=10*T+U
3060 RETURN
3070 U=Q+1
3080 T=O+2
3090 M=10*T+U
3100 RETURN
3110 U=Q+1
3120 T=O+1
3130 M=10*T+U
3140 RETURN
3190 REM     ILLEGAL MOVE MESSAGE
3200 PRINT
3210 PRINT "Y O U   C H E A T . . .  TRY AGAIN, ";
3220 GOTO 230
3290 REM     PLAYER WINS
3300 PRINT
3310 PRINT "C O N G R A T U L A T I O N S . . ."
3320 PRINT 
3330 PRINT "YOU HAVE WON--VERY WELL PLAYED."
3340 PRINT "IT LOOKS LIKE I HAVE MET MY MATCH."
3350 PRINT "THANKS FOR PLAYING---I CAN'T WIN ALL THE TIME."
3360 PRINT
3370 GOTO 4000
3390 REM     COMPUTER WINS
3400 PRINT
3410 PRINT "NICE TRY, BUT IT LOOKS LIKE I HAVE WON."
3420 PRINT "THANKS FOR PLAYING."
3430 PRINT
3440 GOTO 4000
3490 REM     TEST FOR COMPUTER MOVE
3500 M=10*T+U
3510 IF M=158 THEN GOTO 3570
3520 IF M=127 THEN GOTO 3570
3530 IF M=126 THEN GOTO 3570
3540 IF M=75 THEN GOTO 3570
3550 IF M=73 THEN GOTO 3570
3560 RETURN
3570 C=1
3580 GOTO 3560
3990 REM     ANOTHER GAME???
4000 INPUT "ANYONE ELSE CARE TO TRY (1=yes, 0=no)? "; W
4020 PRINT
4030 IF W=1 THEN GOTO 30
4040 IF W=0 THEN GOTO 4050
4042 PRINT "PLEASE ANSWER 'YES' OR 'NO'."
4045 GOTO 4000
4050 PRINT:PRINT "OK --- THANKS AGAIN."
4060 STOP
4990 REM     DIRECTIONS
5000 PRINT "WE ARE GOING TO PLAY A GAME BASED ON ONE OF THE CHESS"
5010 PRINT "MOVES.  OUR QUEEN WILL BE ABLE TO MOVE ONLY TO THE LEFT,"
5020 PRINT "DOWN, OR DIAGONALLY DOWN AND TO THE LEFT."
5030 PRINT
5040 PRINT "THE OBJECT OF THE GAME IS TO PLACE THE QUEEN IN THE LOWER"
5050 PRINT "LEFT HAND SQUARE BY ALTERNATING MOVES BETWEEN YOU AND THE"
5060 PRINT "COMPUTER.  THE FIRST ONE TO PLACE THE QUEEN THERE WINS."
5070 PRINT
5080 PRINT "YOU GO FIRST AND PLACE THE QUEEN IN ANY ONE OF THE SQUARES"
5090 PRINT "ON THE TOP ROW OR RIGHT HAND COLUMN."
5100 PRINT "THAT WILL BE YOUR FIRST MOVE."
5110 PRINT "WE ALTERNATE MOVES."
5120 PRINT "YOU MAY FORFEIT BY TYPING '0' AS YOUR MOVE."
5130 PRINT "BE SURE TO PRESS THE RETURN KEY AFTER EACH RESPONSE."
5140 PRINT
5150 PRINT
5160 PRINT
5170 FOR A=0 TO 7
5180 FOR B=1 TO 8
5185 I=8*A+B
5190 PRINT @(I),
5200 NEXT B
5210 PRINT
5220 PRINT
5230 PRINT
5240 NEXT A
5250 PRINT
5260 RETURN
9999 END