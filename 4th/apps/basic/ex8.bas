rem Command line arguments demonstration
rem Any number within the valid range returns the appropriate argument
rem Any number outside this range returns the number of arguments, like CMD(0)

for x = 1 to cmd(0)
  print cmd(0), x, show(cmd(x))
next x
