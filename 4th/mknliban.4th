\ 4tH - Dutch IBAN converter - Copyright 2015 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ NOTE: This program is just a PROOF OF CONCEPT. The results may or MAY NOT
\       BE ACCURATE. By using this program you explicitly accept each and
\       every responsibility for its use, its behavior, the results and the
\       use of these results. Only Dutch account numbers are converted, but
\       this is just a description of its functionality and NOT a warranty
\       in any kind, shape or form.

include lib/yesorno.4th                \ for YES/NO?
include lib/enter.4th                  \ for ENTER
include lib/row.4th                    \ for ROW
include lib/range.4th                  \ for BETWEEN
include lib/cstring.4th                \ for C/STRING
include lib/triple.4th                 \ for TU*

char A 10 - negate +constant c>u       \ convert character to IBAN digit
88529281 constant 97^4                 \ first stage modulus
4 constant /Bank                       \ maximum bank code length

/Bank 1+ string Bankcode               \ buffer for bank code (clobbering)

create Bank                            \ list of all Dutch banks
  ," ABNA" ," ABN AMRO BANK N.V."
  ," AEGO" ," AEGON BANK N.V."
  ," ANAA" ," ALLIANZ NEDERLAND ASSET MANAGEMENT"
  ," ANDL" ," ANADOLUBANK NEDERLAND N.V."
  ," ARBN" ," ACHMEA RETAIL BANK N.V."
  ," ARSN" ," ARGENTA SPAARBANK N.V."
  ," ARTE" ," GE ARTESIA BANK"
  ," ASNB" ," ASN BANK"
  ," ATBA" ," AMSTERDAM TRADE BANK N.V."
  ," BBRU" ," ING BELGIE N.V., BREDA BRANCH"
  ," BCDM" ," BANQUE CHAABI DU MAROC"
  ," BCIT" ," INTESA SANPAOLO S.P.A."
  ," BICK" ," BINCKBANK N.V."
  ," BINK" ," BINCKBANK N.V. PROF"
  ," BKCH" ," BANK OF CHINA"
  ," BKMG" ," BANK MENDES GANS N.V."
  ," BLGW" ," BLG WONEN"
  ," BMEU" ," BMCE EUROSERVICES"
  ," BNGH" ," N.V. BANK NEDERLANDSE GEMEENTEN"
  ," BNPA" ," BNP PARIBAS S.A. THE NETH. BRANCH"
  ," BOFA" ," BANK OF AMERICA N.A."
  ," BOFS" ," BANK OF SCOTLAND PCC AMSTERDAM BRANCH"
  ," BOTK" ," BANK OF TOKYO-MITSUBISHI UFJ"
  ," BUNQ" ," BUNQ"
  ," CHAS" ," JPMORGAN CHASE"
  ," CITC" ," CITCO BANK NEDERLAND"
  ," CITI" ," CITIBANK INTERNATIONAL PLC."
  ," COBA" ," COMMERZBANK AG"
  ," DEUT" ," DEUTSCHE BANK"
  ," DHBN" ," DEMIR-HALK BANK (NEDERLAND) N.V."
  ," DLBK" ," DELTA LLOYD BANK N.V."
  ," DNIB" ," NIBC BANK N.V."
  ," FBHL" ," CREDIT EUROPE BANK N.V"
  ," FLOR" ," DE NEDERLANDSCHE BANK N.V."
  ," FRBK" ," FRIESLAND BANK N.V."
  ," FRGH" ," FRIESCH GRONINGSE HYPOTHEEK BANK"
  ," FTSB" ," FORTIS BANK NEDERLAND N.V."
  ," FVLB" ," F.VAN LANSCHOT BANKIERS N.V."
  ," GILL" ," THEODOOR GILISSEN N.V."
  ," HAND" ," (SVENSKA) HANDELSBANKEN AB"
  ," HHBA" ," HOF HOORNEMAN BANKIERS"
  ," HSBC" ," HSBC BANK PLC."
  ," ICBK" ," INDUSTRIAL AND COMMERCIAL BANK OF CHINA"
  ," INGB" ," ING BANK N.V."
  ," INSI" ," INSINGER DE BEAUFORT N.V."
  ," ISBK" ," ISBANK"
  ," KABA" ," YAPI KREDI BANK NEDERLAND N.V."
  ," KASA" ," KAS BANK N.V."
  ," KNAB" ," KNAB"
  ," KOEX" ," KOREA EXCHANGE BANK"
  ," KRED" ," KBC BANK NEDERLAND N.V."
  ," LOCY" ," LOMBARD ODIER DARIER HENTSCH & CIE"
  ," LOYD" ," LLOYDS TSB BANK PLC."
  ," LPLN" ," LEASEPLAN CORPORATION N.V."
  ," MHCB" ," MIZUHO CORPORATE BANK NEDERLAND N.V."
  ," NNBA" ," NATIONALE-NEDERLANDEN BANK N.V."
  ," NWAB" ," NEDERLANDSE WATERSCHAPSBANK N.V."
  ," RABO" ," RABOBANK GROEP"
  ," RBOS" ," ROYAL BANK OF SCOTLAND"
  ," RBRB" ," REGIOBANK"
  ," SNSB" ," SNS BANK N.V."
  ," SOGE" ," SOCIETE GENERALE"
  ," STAL" ," STAALBANKIERS N.V."
  ," TEBU" ," THE ECONOMY BANK N.V."
  ," TRIO" ," TRIODOS BANK N.V."
  ," UBSW" ," UBS BANK (NETHERLANDS) B.V."
  ," UGBI" ," GARANTIBANK INTERNATIONAL N.V."
  ," VOWA" ," VOLKSWAGEN BANK"
  ," ZWLB" ," ZWITSERLEVENBANK"
  NULL ,

here Bank - 2 / constant #Bank         \ number of banks listed
                                       \ show list of all the banks
: showBanks                            ( --)
  Bank 0 begin                         \ as long as there are entries
    over over 2* cells + dup @c NULL <>
  while                                \ display 22 more banks
    over 1+ 2 .r ." ) " dup @c count type 4 spaces cell+ @c count type cr
    1+ dup 22 mod 0= if s" Continue" yes/no? 0= if drop drop exit then then
  repeat drop drop                     \ we have listed all banks
;
                                       \ interactively enter a bank
: enterBank                            ( -- a n)
  showBanks                            \ show all banks
  begin ." Select bank#: " enter dup 1 #Bank between 0= while drop repeat
  1- 2* cells Bank + @c count          \ until a valid one is selected
;
                                       \ perform "eleven-test" on accounts
: chkAccount                           ( a1 n1 -- n2 f)
  dup 9 = if                           \ if proper length
    over 0 9 over ?do over i chars + c@ [char] 0 - 9 i - * + loop nip 11 mod
    if exit then                       \ perform the "eleven test"
  then number error?                   \ convert to a number
;
                                       \ enter a valid account number
: enterAccount                         ( -- n)
  begin ." Enter account#: " refill drop 0 parse chkAccount 0= until
;                                      \ show the IBAN number
                                       ( u1 u2 a n --)
: .IBAN ." NL" rot <# # # #> type type <# 10 0 do # loop #> type cr ;
: u>t 0 dup ;                          ( u -- t)
                                       \ convert bank to unsigned number
: cvtBank                              ( a n -- t)
  c/string c>u 1000000 * >r            \ get first digit and shift
  c/string c>u 10000 * >r              \ get second digit and shift
  c/string c>u 100 * >r                \ get third digit and shift
  drop c@ c>u r> + r> + r> +           \ combine all digits to number
  u>t 100000 tu* 100000 tu*            \ make triple and shift left
;
                                       \ calculate the checksum number
: calcCheck                            ( u1 a n -- u1 u2)
  rot >r cvtBank r> u>t t+ 1000000 tu* 232100 u>t t+
  97^4 ut/mod 2drop 97 mod 98 swap -   \ assemble and mod 97 in 2 steps
;
                                       \ show the disclaimer
: disclaimer                           ( --)
  ." This program is just a PROOF OF CONCEPT. The results may or MAY NOT" cr
  ." BE ACCURATE. By using this program you explicitly accept each and" cr
  ." every responsibility for its use, its behavior, the results and the" cr
  ." use of these results. Only DUTCH account numbers are converted, but" cr
  ." this is just a description of its functionality and NOT a warranty" cr
  ." in any kind, shape or form." cr cr
  s" Have you read this disclaimer and do you agree" yes/no? 0= if abort then
;
                                       \ convert interactively
: showIBAN                             ( --)
  disclaimer enterBank 2>r enterAccount dup 2r@ calcCheck
  cr ." Your IBAN: " 2r> .IBAN
;
                                       \ convert in batch
: batchIBAN                            ( a1 n1 a2 n2 --)
  /Bank min Bankcode place Bankcode count
  Bank 2 string-key row                \ check if it is a valid bank
  if                                   \ if it is a valid bank
    @c count 2>r 2drop chkAccount if   \ convert it and check account
      drop 2r> 2drop ." Bad account#" cr
    else                               \ if it's not a valid account abort
      dup 2r@ calcCheck 2r> .IBAN      \ if account is valid, convert
    then
  else                                 \ if it's an unknown bank abort
    drop 2drop 2drop ." Unknown bank" cr
  then
;
                                       \ select batch or interactive mode
argn 3 < if showIBAN else 2 args 1 args batchIBAN then