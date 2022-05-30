' Taken from http://physics.clarku.edu/sip/tutorials/True_BASIC.html
' Assumed to be in the Public Domain

' PROGRAM vector, illustrate use of the global array
a = 0
b = 3
c = 6

PROC _initial(a,b)
PROC _dot(a,b)
PROC _cross(a,b)
END

_initial PARAM(2)
    LET @(a@ + 1) = 2
    LET @(a@ + 2) = -3
    LET @(a@ + 3) = -4
    LET @(b@ + 1) = 6
    LET @(b@ + 2) = 5
    LET @(b@ + 3) = 1
RETURN

_dot PARAM(2)
    LOCAL(2)
    LET c@ = 0
    FOR d@ = 1 to 3
        LET c@ = c@ + @(a@ + d@)* @(b@ + d@)
    NEXT d@
    PRINT "Scalar product = "; c@
RETURN

_cross PARAM(2)
    LOCAL(3)
    FOR c@ = 1 to 3
        LET d@ = (c@ % 3) + 1
        LET e@ = (d@ % 3) + 1
        LET @(c + c@) = @(a@ + d@)*@(b@ + e@) - @(b@ + d@)*@(a@ + e@)
    NEXT c@
    PRINT
    PRINT "Three components of the vector product:"
    PRINT " x "," y "," z "
    FOR c@ = 1 to 3
        PRINT @(c + c@),
    NEXT c@
RETURN

