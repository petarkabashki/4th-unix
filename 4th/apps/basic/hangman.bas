10 PRINT TAB(32);"HANGMAN"
20 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
25 PRINT:PRINT:PRINT
40 GOSUB 700
50 M=0: IF P THEN 100
60 PRINT "YOU DID ALL THE WORDS!!": END
100 Q=RND(P): T=0: N=DUP("")
170 PRINT "HERE ARE THE LETTERS YOU USED:"
175 IF LEN(N)>0 THEN PRINT CHR(PEEK(N,0));
180 FOR I=1 TO LEN(N)-1: PRINT ", ";CHR(PEEK(N,I));: NEXT I : PRINT
190 GOSUB 840
210 G = ASK("WHAT IS YOUR GUESS? "): IF LEN(G)=0 THEN 210
215 R=0: G=AND(PEEK(G,0), 95)
220 FOR I=0 TO LEN(N)-1
230 IF G = PEEK(N,I) THEN UNLOOP: PRINT "YOU GUESSED THAT LETTER BEFORE!": GOTO 170
240 NEXT I
250 N=JOIN(N, CHAR(G)): T=T+1
260 FOR I=0 TO LEN(@(Q))-1: IF PEEK(@(Q),I)=G THEN R=R+1
270 NEXT I: IF R>0 THEN 300
290 M=M+1: GOTO 400
300 GOSUB 840: IF B<LEN(@(Q)) THEN 320
310 GOTO 390
320 B = ASK ("WHAT IS YOUR GUESS FOR THE WORD? "): A=DUP("")
330 FOR I=0 TO LEN(B)-1: A=JOIN(A, CHAR(AND(PEEK(B, I), 95))): NEXT I
340 IF COMP(A, @(Q)) = 0 THEN 360
350 PRINT "WRONG. TRY ANOTHER LETTER.": PRINT: GOTO 170
360 PRINT "RIGHT!! IT TOOK YOU " ;T;" GUESSES!"
365 P=P-1: @(Q) = @(P)
370 W = ASK("WANT ANOTHER WORD? ") : IF COMP(W, "yes") = 0 THEN 50
380 PRINT: PRINT "IT'S BEEN FUN!  BYE FOR NOW.": GOTO 999
390 PRINT "YOU FOUND THE WORD!": GOTO 370
400 PRINT:PRINT "SORRY, THAT LETTER ISN'T IN THE WORD."
410 GOTO 410+M*5
415 PRINT "FIRST, WE DRAW A HEAD": GOTO 470
420 PRINT "NOW WE DRAW A BODY.": GOTO 470
425 PRINT "NEXT WE DRAW AN ARM.": GOTO 470
430 PRINT "THIS TIME IT'S THE OTHER ARM.": GOTO 470
435 PRINT "NOW, LET'S DRAW THE RIGHT LEG.": GOTO 470
440 PRINT "THIS TIME WE DRAW THE LEFT LEG.": GOTO 470
445 PRINT "NOW WE PUT UP A HAND.": GOTO 470
450 PRINT "NEXT THE OTHER HAND.": GOTO 470
455 PRINT "NOW WE DRAW ONE FOOT": GOTO 470
460 PRINT "HERE'S THE OTHER FOOT -- YOU'RE HUNG!!"
470 PRINT: GOTO 470+M*10
480 REM --- HEAD
484 LET Z=DUP("7X@1X5 1X@1X4 3-@1X3 1(1.1 1.1)@") : GOSUB 1000
488 LET Z=DUP("1X4 3-@1X@1X@1X@1X@1X@1X@1X@"): GOSUB 1000 : GOTO 590
490 REM -- HEAD + BODY
492 LET Z=DUP("7X@1X5 1X@1X4 3-@1X3 1(1.1 1.1)@") : GOSUB 1000
495 LET Z=DUP("1X4 3-@1X5 1X@1X5 1X@1X5 1X@"): GOSUB 1000
497 LET Z=DUP("1X5 1X@1X@1X@1X@" ): GOSUB 1000 : GOTO 590
500 REM --- HEAD, BODY + LEFT ARM
502 LET Z=DUP("7X@1X5 1X@1X4 3-@1X1 1\1 1(1.1 1.1)@") : GOSUB 1000
505 LET Z=DUP("1X2 1\1 3-@1X3 1\1 1X@1X4 1\1X@1X5 1X@"): GOSUB 1000
507 LET Z=DUP("1X5 1X@1X@1X@1X@" ): GOSUB 1000 : GOTO 590
510 REM --- HEAD, BODY + BOTH ARMS
512 LET Z=DUP("7X@1X5 1X@1X4 3-@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
515 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
517 LET Z=DUP("1X5 1X@1X@1X@1X@" ): GOSUB 1000 : GOTO 590
520 REM --- HEAD, BODY, BOTH ARMS + LEFT LEG
522 LET Z=DUP("7X@1X5 1X@1X4 3-@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
525 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
527 LET Z=DUP("1X5 1X@1X4 1/@1X3 1/@1X@" ): GOSUB 1000 : GOTO 590
530 REM --- HEAD, BODY, BOTH ARMS + BOTH LEGS
532 LET Z=DUP("7X@1X5 1X@1X4 3-@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
535 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
537 LET Z=DUP("1X5 1X@1X4 1/1 1\@1X3 1/3 1\@1X@" ): GOSUB 1000 : GOTO 590
540 REM --- HEAD, BODY, ARMS, LEGS + RIGHT HAND
542 LET Z=DUP("7X@1X5 1X@1X4 3-2 1\@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
545 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
547 LET Z=DUP("1X5 1X@1X4 1/1 1\@1X3 1/3 1\@1X@" ): GOSUB 1000 : GOTO 590
550 REM --- HEAD, BODY, ARMS, LEGS + BOTH HANDS
552 LET Z=DUP("7X@1X5 1X@1X1 1/2 3-2 1\@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
555 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
557 LET Z=DUP("1X5 1X@1X4 1/1 1\@1X3 1/3 1\@1X@" ): GOSUB 1000 : GOTO 590
560 REM --- HEAD, BODY, ARMS, LEGS, HANDS + RIGHT FOOT
562 LET Z=DUP("7X@1X5 1X@1X1 1/2 3-2 1\@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
565 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
567 LET Z=DUP("1X5 1X@1X4 1/1 1\@1X3 1/3 1\@1X8 1\1-@" ): GOSUB 1000 : GOTO 590
570 REM --- HEAD, BODY, ARMS LEGS, HANDS + BOTH FEET
573 LET Z=DUP("7X@1X5 1X@1X1 1/2 3-2 1\@1X1 1\1 1(1.1 1.1)1 1/@") : GOSUB 1000
575 LET Z=DUP("1X2 1\1 3-1 1/@1X3 1\1 1X1 1/@1X4 1\1X1/@1X5 1X@"): GOSUB 1000
577 LET Z=DUP("1X5 1X@1X4 1/1 1\@1X3 1/3 1\@1X1 1-1/5 1\1-@" ): GOSUB 1000 : GOTO 590
590 PRINT: PRINT: IF M#10 THEN 170
600 PRINT "SORRY, YOU LOSE. THE WORD WAS \q";SHOW(@(Q));"\q"
610 PRINT "YOU MISSED THAT ONE. DO YOU ";: GOTO 370
700 PUSH DUP("GUM"), DUP("SIN"), DUP("FOR"), DUP("CRY"), DUP("LUG")
710 PUSH DUP("UGLY"), DUP("EACH"), DUP("FROM"), DUP("WORK"), DUP("TALK")
720 PUSH DUP("PIZZA"), DUP("THING"), DUP("FEIGN"), DUP("FIEND"), DUP("ELBOW")
730 PUSH DUP("BUDGET"), DUP("SPIRIT"), DUP("QUAINT"), DUP("MAIDEN")
740 PUSH DUP("EXAMPLE"), DUP("TENSION"), DUP("QUININE"), DUP("KIDNEY")
750 PUSH DUP("TRIANGLE"), DUP("KANGAROO"), DUP("MAHOGANY"), DUP("SERGEANT")
760 PUSH DUP("MOUSTACHE"), DUP("DANGEROUS"), DUP("SCIENTIST")
770 PUSH DUP("MAGISTRATE"), DUP("ERRONEOUSLY"), DUP("LOUDSPEAKER")
780 PUSH DUP("MATRIMONIAL"), DUP("PARASYMPATHOMIMETIC"), DUP("THIGMOTROPISM")
790 PUSH DUP("BYE"), DUP("FLY"), DUP("WITH"), DUP("SELF"), DUP("FAULT")
800 PUSH DUP("ESCORT"), DUP("PICKAX"), DUP("REPLICA"), DUP("SLEEPER")
810 PUSH DUP("SEQUENCE"), DUP("DIFFERENT"), DUP("QUIESCENT"), DUP("DIRTY")
820 PUSH DUP("PHYTOTOXIC")
830 P = USED(): FOR I = 0 TO P-1: @(I)=POP(): NEXT I: RETURN
840 PRINT: B=0: FOR I=0 TO LEN(@(Q))-1: F=0: FOR J=0 TO LEN(N)-1
850 IF PEEK(@(Q),I) = PEEK(N,J) THEN PRINT CHR(PEEK(N,J)); : F=1 : B=B+1
860 NEXT J: IF F=0 THEN PRINT "-";
870 NEXT I: PRINT: PRINT: RETURN
990 PRINT "BYE NOW"
999 END
1000 LOCAL(4) : FOR A@ = 0 TO LEN(Z)-1
1010 IF PEEK(Z, A@) = ORD("@") THEN
1020 PRINT
1030 ELSE
1040 LET B@=(PEEK(Z, A@))-ORD("0")
1050 LET A@=A@+1
1060 LET C@=PEEK(Z, A@)
1070 FOR D@=1 TO B@ : PRINT CHR(C@); : NEXT D@
1080 ENDIF
1090 NEXT A@
1100 RETURN
