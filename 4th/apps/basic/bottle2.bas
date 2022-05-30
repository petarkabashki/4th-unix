for n=99 to 2 step -1
  print n;" bottles of beer on the wall, ";n;" bottles of beer!"
  print "Take one down, pass it around, ";n-1;" bottle";
  print show(iif(n>2 , "s", ""));" of beer on the wall.\n"
next
 
print "One bottle of beer on the wall, one bottle of beer!"
print "Take one down, pass it around, no more bottles of beer on the wall.\n"

print "No more bottles of beer on the wall.  No more bottles of beer..."
print "Go to the store and buy some more...99 bottles of beer."
