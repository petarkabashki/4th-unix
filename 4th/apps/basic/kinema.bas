10 REM PRINT TAB(33);"KINEMA"
20 REM PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT: PRINT: PRINT
100 PRINT
105 PRINT
106 Q=0
110 V=RND(35)+5
111 PRINT "A BALL IS THROWN UPWARDS AT ";V;" METERS PER SECOND."
112 PRINT
115 A=((V^2)*5/100)
116 PRINT "HOW HIGH WILL IT GO (IN METERS)";
117 GOSUB 500
120 A=V/5
122 PRINT "HOW LONG UNTIL IT RETURNS (IN SECONDS)";
124 GOSUB 500
130 T=1+2*V*RND(1000)/10000
132 A=V-10*T
134 PRINT "WHAT WILL ITS VELOCITY BE AFTER ";T;" SECONDS";
136 GOSUB 500
140 PRINT
150 PRINT Q;" RIGHT OUT OF 3."
160 IF Q<2 THEN GOTO 100
170 PRINT "NOT BAD."
180 GOTO 100
500 INPUT G : IF A=0 THEN A=1
501 P=(((G-A)*100))/A : IF P<0 THEN P=-P
502 IF P<15 THEN GOTO 510
504 PRINT "NOT EVEN CLOSE...."
506 GOTO 512
510 PRINT "CLOSE ENOUGH."
511 Q=Q+1
512 PRINT "CORRECT ANSWER IS ";A
520 PRINT
530 RETURN
999 END