' Tiny RPN calculator, 2019, 2021 Hans Bezemer
' This is mainly a demo for the NAME() and LINE() functions

' Valid commands:
'   print, add, div, mod, min, mul, drop, over, swap, neg, exit, quit,
'   depth, free

' NOTE: Exhausting the stack will stop execution

' E.g.
'   23 45 add print
'   67 dup mul print

e = val ("Error")                      ' store error value in e

do                                     ' do forever
  a = ask ("Ok ")                      ' get a line of commands
  for x = 0 to len (a) - 1             ' process until end of line
    for y = x to len (a) - 1           ' skip any leading spaces
      while peek (a, y) = ord(" ")
    next

    t = dup ("")                       ' start with an empty token

    for z = y to len (a) - 1           ' start after leading spaces
      until peek (a, z) = ord(" ")     ' until we find another space
      t = join (t, char (peek (a, z))) ' add character to token
    next

    if val (t) > e then                ' if this is a number
      push val (t)                     ' push its value
    else                               ' if it isn't a number, it SHOULD be
      l = name (t)                     ' convert it to a line number
      if line (l) then                 ' if it's a valid line number
        gosub l                        ' it's a command, so call it
      else                             ' otherwise show a message
        print show (t);"?"
      endif
    endif

    x = z                              ' get a new token after this
  next                                 ' get a whole new line of commands
loop
end

_exit end                              ' like BYE, exits the program
_quit end                              ' below: ., DUP, NEGATE, +, -, /, MOD,
_print param (1) : print a@ : return   '        *, DROP, OVER, SWAP, DEPTH,
_dup param (1) : push a@, a@ : return  '        FREE
_neg param (1) : push -a@ : return
_add param (2) : push (a@ + b@) : return
_min param (2) : push (a@ - b@) : return
_div param (2) : push (a@ / b@) : return
_mod param (2) : push (a@ % b@) : return
_mul param (2) : push (a@ * b@) : return
_drop param (1) : return
_over param (2) : push a@, b@, a@ : return
_swap param (2) : push b@, a@ : return
_depth push used () : return
_free push free (0) : return


