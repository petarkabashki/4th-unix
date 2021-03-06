    REM
    REM --- Tiny BASIC Interpreter and Compiler Project
    REM --- Mugwump Demonstration Game
    REM
    REM --- Released as Public Domain by Damian Gareth Walker 2019
    REM --- Created: 13-Aug-2019
    REM

    REM --- Variables
    REM     C: axis diff between player guess and mugwump position
    REM     D: distance between player guess and mugwump position
    REM     G: mugwump column
    REM     H: mugwump row
    REM     M: moves taken
    REM     R: random number generator seed
    REM     X: player guess column
    REM     Y: player guess row

    REM --- Initialise the game
    LET G=RND(10)
    LET H=RND(10)
    LET M=0

    REM --- Input player guess
 10 PRINT "Where is the mugwump? Enter column then row."
    INPUT X : INPUT Y
    IF X>-1 THEN IF X<10 THEN IF Y>-1 THEN IF Y<10 THEN GOTO 20
    PRINT "That location is off the grid!"
    GOTO 10

    REM --- Process player guess
 20 LET M=M+1
    PRINT "The mugwump is..."
    LET D=0
    LET C=G-X
    GOSUB 60
    LET C=H-Y
    GOSUB 60
    IF D=0 THEN GOTO 40
    PRINT "...";D;" cells away."
    IF M>10 THEN GOTO 50
    PRINT "You have taken ";M;" turns so far."
    GOTO 10

    REM --- Player has won
 40 PRINT "...RIGHT HERE!"
    PRINT "You took ";M;" turns to find it."
    END

    REM --- Player has lost
 50 PRINT "You have taken too long over this. You lose!"
    END

    REM --- Helper subroutine to calculate distance from player to mugwump
    REM     Inputs: C - difference in rows or columns
    REM             D - running total distance
    REM     Output: D - running total distance, updated
 60 IF C<0 THEN LET C=-C
    LET D=D+C
    RETURN
