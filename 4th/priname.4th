\ 4tH - Is your name a prime? Copyright 2014 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/math.4th                   \ for SQRT

[char] a 1- negate +constant char>num  \ convert a charactor to a number
                                       \ print introduction
." The book 'THE CURIOUS INCIDENT OF THE DOG IN THE NIGHT-TIME'" cr
." tells how Jesus Christ, Sherlock Holmes and Doctor Watson" cr
." are prime numbers if their letters are replaced by numbers." cr cr
." If you enter your name (upper or lower case, or mixed)" cr
." the program will tell you if it is a prime number." cr cr
." What is your name? " refill drop
                                       \ add characters and determine prime
0 dup parse bounds ?do i c@ bl or dup bl = if drop else char>num + then loop
dup sqrt 1+ 2 ?do dup i mod 0= abort" Your name is not prime." loop drop
." Your name is a prime number!" cr
