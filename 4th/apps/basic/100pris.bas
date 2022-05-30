10 rem 100 prisoners
20 rem set arrays
30 rem dr = drawers containing card values
40 rem ig = a list of numbers 1 through 100, shuffled to become the
41 rem guess sequence for each inmate - method 1
50 rem initialize drawers with own card in each drawer
60 for i=1 to 100: @(i)=i:next

1000 input "how many trials for each method: ";a
1010 for m=1 to 2: @(m+210)=0: @(m+220)=0
1015 for n=1 to a
1020 gosub 1000+(m*1000)
1025 rem p = number of inmates who passed
1030 if p=100 then @(m+210)=@(m+210)+1
1040 if p<100 then @(m+220)=@(m+220)+1
1045 next n
1055 next m

1060 print "Results:":print
1070 print "Out of ";a;" trials, the results are as follows...":print
1072 print "1. Random Guessing:"
1073 print "   ";@(211);" successes"
1074 print "   ";@(221);" failures"
1075 print "   ";using "?.##";(10000*@(211))/a;"% success rate.":print
1077 print "2. Chained Number Picking:"
1078 print "   ";@(212);" successes"
1079 print "   ";@(222);" failures"
1080 print "   ";using "?.##";(10000*@(212))/a;"% success rate.":print
1100 print: k=ask("Again? ")
1110 if comp(k, "yes")*comp(k, "no") then 1100
1120 if comp(k, "yes")=0 then 1000
1500 end

2000 rem random guessing method
2005 for x=1 to 100: @(x+100)=x: next: p=0: gosub 4000
2007 i=1
2010 for x=1 to 100: t=@(x+100): b=rnd(100)+1: @(x+100)=@(b+100): @(b+100)=t: next
2015 for g=1 to 50
2020 if @(@(g+100))=i then
2030 p=p+1: i=i+1
2040 if i>100 then
2050 unloop: return
2060 else
2070 unloop: goto 2010
2080 endif
2090 endif
2100 next g
2110 return

3000 rem chained method
3005 p=0: gosub 4000
3007 rem iterate through each inmate
3010 i=1
3015 d=i: for g=1 to 50
3020 c=@(d)
3030 if c=i then
3040 p=p+1: i=i+1
3050 if i>100 then
3060 unloop: return
3070 else
3080 unloop: goto 3015
3090 endif
3100 endif
3110 if c#i then d=c
3120 next g: return

4000 rem shuffle the drawer cards randomly
4020 for i=1 to 100
4030 r=rnd(100)+1: t=@(i): @(i)=@(r): @(r)=t: next
4040 return

