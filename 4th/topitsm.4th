\ 4tH TopITSM - Copyright 2012, 2021 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ >> ATTENTION! Read the manual before use! <<

\ - This program requires the following csv files:
\   . Either 'top-itil.csv' or 'top-cube.csv';
\   . 'top-edge.csv' - they can be found in the '/apps/topitsm' directory.
\ - Issue the following commands:
\   . load" top-edge.csv"
\   . import" top-itsm.csv"
\ - Create an .INI file and configure the external programs

include lib/dbmidx.4th                 \ for Database Management
include lib/system.4th                 \ for SYSTEM
include lib/interprt.4th               \ for INTERPRET
include lib/msxls2-w.4th               \ for MS Excel generation
include lib/csv-w.4th                  \ for CSV generation
include lib/rtf.4th                    \ for RTF generation
include lib/parsing.4th                \ for PARSE-CSV
include lib/csvfrom.4th                \ for CSV>
include lib/identify.4th               \ for >IDENTIFIER
include lib/inifile.4th                \ for INIFILE
\ include lib/anstools.4th               \ for .S

0 enum     document                    \ RTF fileformat
  enum     graph                       \ PDF fileformat
  constant sheet                       \ XLS fileformat

0 value Rep.Name                       \ pointer to Name index
0 value Rep.Class                      \ pointer to Class index
0 value Rep.Tool                       \ pointer to Tool index
0 value Rep.Dept                       \ pointer to Dept index
0 value Rep.Proc                       \ pointer to Process index
0 value Index                          \ generic index pointer

s" topitsm.dot" sconstant dotfile      \ default name for .DOT file
s" topitsm.xls" sconstant xlsfile      \ default name for .XLS file
s" topitsm.rtf" sconstant rtffile      \ default name for .RTF file
s"  "           sconstant sspace       \ string space

 64 string last-cluster                \ last cluster read
 64 string acroreader                  \ path to Acrobat Reader
 64 string graphviz                    \ path to Graphviz DOT
 64 string ms-word                     \ path to MS-Word
 64 string ms-excel                    \ path to MS-Excel
256 string cmd-buffer                  \ command buffer

struct
  32 +field Name                       \ name of the repository
 256 +field Description                \ description of the repository
  64 +field Label                      \ Graphviz label for repository
   8 +field Shape                      \ Graphviz shape for repository
  16 +field Fillcolor                  \ Graphviz fillcolor for repository
  16 +field Abbreviation               \ Abbreviation of repository
  16 +field Class                      \ which kind of repository
  16 +field Tooling                    \ currently used tooling for repository
   8 +field Department                 \ department accountable for repository
  64 +field Process                    \ process covering this repository
end-struct /Repository                 \ repository structure

/Repository buffer: (Repository)       \ allocate repository buffer

struct
  16 +field Left                       \ left side of connection
  16 +field Right                      \ right side of connection
   8 +field Color                      \ color for connection
  16 +field Entity                     \ label for connection
end-struct /Structure                  \ Graphviz structure structure

/Structure buffer: (Structure)         \ allocate structure buffer

1024 constant /mytib                   \ create large readbuffer
/mytib buffer: mytib                   \ for CSV file
                                       \ type a string
: write count type ;                   ( a --)
: Field> [char] ; parse-csv csv> ;     ( -- a n)
: get-executable refill if 0 parse else 0 dup then rot place ;
                                       \ read configuration
: get-pdf acroreader place ;           \ get Acro Reader equivalent
: get-dot graphviz   place ;           \ get Graphviz executable
: get-rtf ms-word    place ;           \ get MS-Word equivalent
: get-xls ms-excel   place ;           \ get MS-Excel equivalent

create TopITSMini
  ," applications" ," pdf" ' get-pdf ,
  ," applications" ," rtf" ' get-rtf ,
  ," applications" ," dot" ' get-dot ,
  ," applications" ," xls" ' get-xls ,
  NULL ,

: _class      Rep.Class to Index ;
: _department Rep.Dept  to Index ;
: _tooling    Rep.Tool  to Index ;
: _process    Rep.Proc  to Index ;
: normal      Rep.Name  to Index ;
                                       \ format options
: _document document ;                 \ constant for DOCUMENT
: _graph graph ;                       \ constant for GRAPH
: _sheet sheet ;                       \ constant for SHEET
                                       \ initialize the program
: initialize                           ( --)
  TopITSMini s" topitsm.ini" inifile abort" .INI file missing"
  mytib /mytib source!                 \ init read buffer
  (Repository) /Repository s" Repositories.dbm" db.declare to Repository
  (Structure)  /Structure  s" Structure.dbm"    db.declare to Structure
                                       \ declare tables to DBM
  Repository db.use                    \ open Repository table
                                       \ now load all indexes
  {char} s" Rep_Class.idx" idx.load abort" Cannot open 'Class' index"
  to Rep.Class
  {char} s" Rep_Dept.idx"  idx.load abort" Cannot open 'Dept' index"
  to Rep.Dept
  {char} s" Rep_Tool.idx"  idx.load abort" Cannot open 'Tool' index"
  to Rep.Tool
  {char} s" Rep_Name.idx"  idx.load abort" Cannot open 'Name' index"
  to Rep.Name
  {char} s" Rep_Proc.idx"  idx.load abort" Cannot open 'Process' index"
  to Rep.Proc
  normal
;                                      \ initialize sorting
                                       \ shutdown Repository table
: shutdown                             ( --)
  Rep.Name  idx.close abort" Cannot close 'Name' index"
  Rep.Class idx.close abort" Cannot close 'Class' index"
  Rep.Dept  idx.close abort" Cannot close 'Dept' index"
  Rep.Tool  idx.close abort" Cannot close 'Tool' index"
  Rep.Proc  idx.close abort" Cannot close 'Process' index"
  db.close                             \ close the database
;
                                       \ create Repository table
: createRepository                     ( --)
  s" Repositories.dbm" db.create       \ create new database
  Repository db.use                    \ use the database
                                       \ create indexes
  128 {char} db.key Name idx.init abort" Cannot create 'Name' index"
  to Rep.Name

  128 {char} db.key Class idx.init abort" Cannot create 'Class' index"
  to Rep.Class

  128 {char} db.key Department idx.init abort" Cannot create 'Dept' index"
  to Rep.Dept

  128 {char} db.key Tooling idx.init abort" Cannot create 'Tool' index"
  to Rep.Tool

  128 {char} db.key Process idx.init abort" Cannot create 'Process' index"
  to Rep.Proc
;
                                       \ reload the structure
: load-structure                       ( --)
  [char] " parse input open error?     \ open the file
  if ." Cannot open .CSV file; " 1 throw then
  dup use s" Structure.dbm" db.create
  Structure db.use                     \ use the database

  refill unless ." Cannot read .CSV file; " 1 throw then
                                       \ skip the field description
  begin
    refill                             \ read next CSV record
  while
    db.clear                           \ clear the DB buffer
      Field> db.buffer -> Left   place
      Field> db.buffer -> Right  place
      Field> db.buffer -> Color  place
      Field> db.buffer -> Entity place
    db.insert                          \ read fields and insert record
  repeat close Repository db.use
;
                                       \ read open CSV file in DB
: readCSV                              ( h -- h)
  refill unless ." Cannot read .CSV file; " 1 throw then
                                       \ skip the field description
  begin
    refill                             \ read next CSV record
  while
    db.clear                           \ clear the DB buffer
      Field> db.buffer -> Name         place
      Field> db.buffer -> Description  place
      Field> db.buffer -> Label        place
      Field> db.buffer -> Shape        place
      Field> db.buffer -> Fillcolor    place
      Field> db.buffer -> Abbreviation place
      Field> db.buffer -> Class        place
      Field> db.buffer -> Tooling      place
      Field> db.buffer -> Department   place
      Field> db.buffer -> Process      place
    db.insert                          \ read fields and insert record

    Rep.Name  idx.insert drop          \ update index, drop flag
    Rep.Class idx.insert drop          \ update index, drop flag
    Rep.Dept  idx.insert drop          \ update index, drop flag
    Rep.Tool  idx.insert drop          \ update index, drop flag
    Rep.Proc  idx.insert drop          \ update index, drop flag
  repeat

  Rep.Name  s" Rep_Name.idx"  idx.save  \ save 'name' index
  Rep.Class s" Rep_Class.idx" idx.save  \ save 'class' index
  Rep.Dept  s" Rep_Dept.idx"  idx.save  \ save 'dept' index
  Rep.Tool  s" Rep_Tool.idx"  idx.save  \ save 'tool' index
  Rep.Proc  s" Rep_Proc.idx"  idx.save  \ save 'process' index
;

: importCSV                            \ import a CSV file
  [char] " parse input open error?
  if ." Cannot open .CSV file" cr 1 throw then

  dup use shutdown createRepository readCSV close normal
;

: exportCSV                            ( --)
  [char] " parse -trailing CSVOpen throw
  s" Name"    CSVtype s" Description" CSVType s" Label"        CSVType
  s" Shape"   CSVType s" Fillcolor"   CSVType s" Abbreviation" CSVType
  s" Class"   CSVType s" Tooling"     CSVType s" Department"   CSVType
  s" Process" CSVType CSVcr db.first   \ now emit the Graphviz structure

  begin                                \ go to the first record (sequential)
    db.error except                    \ if no errors occurred
    db.buffer -> Name         count CSVtype
    db.buffer -> Description  count CSVtype
    db.buffer -> Label        count CSVtype
    db.buffer -> Shape        count CSVtype
    db.buffer -> Fillcolor    count CSVtype
    db.buffer -> Abbreviation count CSVtype
    db.buffer -> Class        count CSVtype
    db.buffer -> Tooling      count CSVtype
    db.buffer -> Department   count CSVtype
    db.buffer -> Process      count CSVtype CSVcr
    db.next                            \ get the next record
  repeat db.clear CSVclose
;
                                       \ several default commands
: _quit shutdown quit ;                \ close database and quit
: _+ + ;                               \ addition
: _- - ;                               \ subtraction
: _* * ;                               \ multiplication
: _/ / ;                               \ division
: _. . ;                               \ print TOS
: _swap swap ;                         \ swap items
: _drop drop ;                         \ drop item
: _over over ;                         \ copy 2OS
: _dup dup ;                           \ copy TOS
: _.( [char] ) parse type ;            \ print comment
: _( [char] ) parse 2drop ;            \ comment
: _cr cr ;                             \ print linefeed
                                       \ print a bracket
: .} [char] } emit cr ;                ( --)
: end-cluster last-cluster count nip if .} then cr ;
                                       \ end of cluster?
: launch-reader                        ( --)
  acroreader count cmd-buffer place    \ compose launch command
  sspace           cmd-buffer +place   \ for Acrobat Reader
  dotfile          cmd-buffer +place
  s" .pdf"         cmd-buffer +place   \ then launch it
                   cmd-buffer count system throw
;                                      \ throw error if needed

: launch-msword                        ( --)
  ms-word count cmd-buffer place       \ compose launch command
  sspace        cmd-buffer +place      \ for MS Word
  rtffile       cmd-buffer +place
                cmd-buffer count system throw
;                                      \ throw error if needed

: launch-msexcel                       ( --)
  ms-excel count cmd-buffer place      \ compose launch command
  sspace         cmd-buffer +place     \ for MS Excel
  xlsfile        cmd-buffer +place
                 cmd-buffer count system throw
;                                      \ throw error if needed
                                       \ compile a .DOT file
: compile-dot                          ( --)
  graphviz count cmd-buffer place      \ compose launch command
  s"  -Tpdf -O " cmd-buffer +place     \ for dot
  dotfile        cmd-buffer +place
                 cmd-buffer count system throw
;                                      \ then launch it, throw errors
                                       \ compose a Graphviz cluster
: cluster-header                       ( --)
  end-cluster 2dup last-cluster place  \ finish any previous cluster
  .| subgraph cluster_| >identifier type .|  {| cr
  .| label = "| last-cluster count type .| ";| cr
  .| color = forestgreen;| cr          \ emit a valid Graphviz cluster
  .| style=rounded;| cr
  .| bgcolor="#D3FFD3";| cr
  .| fontcolor = darkgreen;| cr
  .| fontsize = 24;| cr
  .| labeljust = left;| cr
;
                                       \ determine the start of a cluster
: begin-cluster                        ( --)
  Index idx.key db.buffer -> Name <>
  if                                   \ Not sorted on name?
    Index idx.key count dup            \ if not, is it filled?
    if                                 \ if so, does it equal previous cluster
      2dup last-cluster count compare if cluster-header else 2drop then
    else                               \ if not, begin new cluster
      2drop                            \ otherwise drop any stack items
    then
  then
;
                                       \ write a record of the repository
: write-repository                     ( --)
  db.buffer -> Abbreviation write s|  [shape=|     type
  db.buffer -> Shape        write s| , fillcolor=| type
  db.buffer -> Fillcolor    write s| , label="|    type
  db.buffer -> Label        write s| "];|          type cr
;                                      \ to Graphviz
                                       \ create a .DOT file
: create-graph                         ( --)
  0 dup last-cluster place             \ empty the last cluster
                                       \ open .DOT file for output
  dotfile output open error? throw dup use
  .| digraph relatie {| cr             \ write the Graphviz header
  .| splines=ortho;| cr                \ splines directive
  .| node [shape=oval, style=filled, fillcolor=lightblue2, fontname="Arial"];| cr
  .| edge [target="_blank", fontname="Arial", fontsize=9];| cr
  .| ratio=0.75;| cr cr                \ end of Graphviz header

  Index dup idx.first begin
    dup idx.error except
    begin-cluster write-repository     \ write cluster info and record
    dup idx.next
  repeat idx.clear end-cluster         \ finish any clusters

  Structure db.use db.first            \ now emit the Graphviz structure

  begin                                \ go to the first record (sequential)
    db.error except                    \ if no errors occurred
    db.buffer -> Left   write s|  -> |     type
    db.buffer -> Right  write s|  [color=| type
    db.buffer -> Color  write s| , taillabel="| type
    db.buffer -> Entity write s| ", headlabel="| type
    db.buffer -> Entity write s| "];| type cr
    db.next                            \ get the next record
  repeat
                                       \ close .DOT file, use Repository table
  .} close Repository db.use compile-dot
;
                                       \ save structure to CSV file
: save-structure                       ( --)
  [char] " parse -trailing CSVOpen throw
  s" Left" CSVtype s" Right" CSVType s" Color" CSVType s" Entity" CSVType
  CSVcr Structure db.use db.first      \ now emit the Graphviz structure

  begin                                \ go to the first record (sequential)
    db.error except                    \ if no errors occurred
    db.buffer -> Left   count CSVtype
    db.buffer -> Right  count CSVtype
    db.buffer -> Color  count CSVtype
    db.buffer -> Entity count CSVtype CSVcr
    db.next                            \ get the next record
  repeat
                                       \ close CSV file, use Repository table
  Repository db.use CSVclose
;
                                       \ create an .XLS sheet
: create-sheet                         ( --)
  xlsfile XLSOpen throw                \ open XLS sheet
  s" Name"    XLStype s" Description" XLSType s" Class"   XLSType
  s" Tooling" XLSType s" Department"  XLSType s" Process" XLSType XLScr
                                       \ write the header
  Index dup idx.first begin            \ use sorted index for Repository
    dup idx.error except
    db.buffer -> Name        count XLSType
    db.buffer -> Description count XLSType
    db.buffer -> Class       count XLSType
    db.buffer -> Tooling     count XLSType
    db.buffer -> Department  count XLSType
    db.buffer -> Process     count XLSType XLScr
    dup idx.next                       \ get the next record
  repeat idx.clear XLSclose            \ write spreadsheet and close
;

: create-document                      ( --)
  rtffile output open error? throw dup use
  %RTFarticle
  %beginRTF
  s" Hans Bezemer" s" Repository descriptions" false %RTFtitle
  %description begins                  \ begin descriptions
                                       \ write the header
  Index dup idx.first begin            \ use sorted index for Repository
    dup idx.error except
    db.buffer -> Name count db.buffer -> Description count %describe
    dup idx.next                       \ get the next record
  repeat idx.clear %cr

  %description ends                    \ end of descriptions
  %endRTF close                        \ write document and close
;
                                       \ standard help text
: help                                 ( --)
  cr
  ." Arithmetic operations:" cr
  ."   + - / * ." cr
  ." Stack operations:" cr
  ."   DROP SWAP OVER DUP" cr
  ." View options:" cr
  ."   CLASS DEPARTMENT TOOL PROCESS NORMAL" cr
  ." Document options:" cr
  ."   GRAPH SHEET DOCUMENT" cr
  ." Commands:" cr
  ."   <view> <document> GENERATE" cr
  ."   <view> <document> SHOW" cr
  ." Backup and restore:" cr
  .|   EXPORT" csv file"| cr
  .|   IMPORT" csv file"| cr
  .|   SAVE" csv file"| cr
  .|   LOAD" csv file"| cr
  ." Enter QUIT to quit. "
;
                                       \ display cmds for all formats
: show-document create-document launch-msword  ;
: show-graph    create-graph    launch-reader  ;
: show-sheet    create-sheet    launch-msexcel ;
                                       \ find and execute a format
: find-execute                         ( n --)
  2 num-key row if cell+ @c execute else drop ." No such format" cr then
  drop
;

create show
  document , ' show-document ,
  graph    , ' show-graph ,
  sheet    , ' show-sheet ,
  NULL ,
does> find-execute ;
                                       \ maps constants to generation routines
create generate
  document , ' create-document ,
  graph    , ' create-graph ,
  sheet    , ' create-sheet ,
  NULL ,
does> find-execute ;

create wordlist                        \ maps commands to execution semantics
  ," +"          ' _+ ,
  ," -"          ' _- ,
  ," *"          ' _* ,
  ," /"          ' _/ ,
  ," p"          ' _. ,
  ," ."          ' _. ,
  ," swap"       ' _swap ,
  ," drop"       ' _drop ,
  ," over"       ' _over ,
  ," dup"        ' _dup ,
  ," .("         ' _.( ,
  ," ("          ' _( ,
  ," cr"         ' _cr ,
  ," exit"       ' _quit ,
  ," quit"       ' _quit ,
  ," bye"        ' _quit ,
  ," help"       ' help ,
  ," class"      ' _class ,
  ," department" ' _department ,
  ," tool"       ' _tooling ,
  ," process"    ' _process ,
  ," normal"     ' normal ,
  ," sheet"      ' _sheet ,
  ," document"   ' _document ,
  ," graph"      ' _graph ,
  ," generate"   ' generate ,
  ," show"       ' show ,
  ,| export"|    ' exportCSV ,
  ,| import"|    ' importCSV ,
  ,| save"|      ' save-structure ,
  ,| load"|      ' load-structure ,
  NULL ,

wordlist to dictionary                 \ assign wordlist to dictionary
                                       \ The interpreter itself
: topitsm                              ( --)
  ." Initializing.." cr initialize
  ." Type 'help' for help. "           \ show help message
  begin                                \ show the prompt and get a command
    ." OK" cr refill drop              \ interpret and issue oops when needed
    ['] interpret catch if ." Oops " then
  again                                \ repeat command loop eternally
;

topitsm
