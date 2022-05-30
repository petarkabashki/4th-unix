' uBasic/4tH - Magic 8 ball - Copyright 2021 J.L. Bezemer
' You can redistribute this file and/or modify it under
' the terms of the GNU General Public License

Push Dup("It is certain"), Dup("It is decidedly so"), Dup("Without a doubt")
Push Dup("Yes, definitely"), Dup("You may rely on it")
Push Dup("As I see it, yes"), Dup("Most likely"), Dup("Outlook good")
Push Dup("Signs point to yes"), Dup("Yes"), Dup("Reply hazy, try again")
Push Dup("Ask again later"), Dup("Better not tell you now")
Push Dup("Cannot predict now"), Dup("Concentrate and ask again")
Push Dup("Don't bet on it"), Dup("My reply is no"), Dup("My sources say no")
Push Dup("Outlook not so good"), Dup("Very doubtful")
                                       ' read the replies
For x = 0 to Used() - 1 : @(x) = Pop() : Next
Print "Please enter your question or a blank line to quit.\n"
                                       ' now show the prompt
Do
  r = Ask("? : ")                      ' ask a question
Until Len(r)=0                         ' check for empty line
  Print Show(@(Rnd(x)));"\n"           ' show the reply
Loop

