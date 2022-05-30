10 INPUT "Enter month: ", M
11 INPUT "Enter day  : ", D
12 INPUT "Enter year : ", Y
15 GOSUB 1000
20 PRINT SHOW(CHOP(CLIP("SunMonTueWedThuFriSat",(6-Q)*3),Q*3)), Q
30 END
1000 IF (M<3) THEN Y=Y-1:M=M+12
1020 Q=((13*M+3)/5+D+Y+Y/4-Y/100+Y/400+1) % 7
1030 RETURN
