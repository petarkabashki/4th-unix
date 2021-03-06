\ Paint program for bitmap ppm images in 4tH 
\ David Johnson, Aug. 2017 
\ Uses an xrow ycol plotting scheme. 
\     
\ ============================================================================ 
\ Example 1: Pixel editing - fix glare on eyeglass frame. 
\   file portrait.ppm 
\   250 210 xy  show    move to position of interest 
\   267 t 12 m l        type line 267, move 12 columns over, show cursor 
\   match sk .xxxx      pixel to pencolor. Skip 1 then overwrite next 4 pixel 
\   n -4 m sk xxxx      next line, move back 4 columns, overwrite 4 pixels 
\   n -4 m sk xxxx      do the same on the next line 
\   save portrt2.ppm    save the edited image. 
\   quit
\ ============================================================================ 
\ Example 2: Modify an ppm file 
\   file portrait.ppm            Load the picture 
\   shrink shrink                Reduce the image by 4x (2x 2x) 
\   grayscale info               Convert the image to grayscale 
\   117 width  40 height         Define the viewing/drawing frame 
\   50 0 xy show                 Move the viewing frame 
\   80 t 3 m                     type line 80 and move cursor 
\   l                            show current editing line and cursor 
\   vtext Hans                   Write "HANS" on the image 
\   show                         display text version of image 
\   save Hans.ppm               Save the modified image 
\   quit                         Bye 
\ ============================================================================ 
\ Example 3: Ascii art!
\   file wldchild.ppm 
\   hshrink                      reduce height only (correct aspect ratio!!) 
\   shrink shrink                reduce the image by 4x 
\   info                         report the new image size 
\   150 width 59 height          set viewing frame size to image size 
\   enhance                      use enchaned ascii colors (2-palettes) 
\   txtsave wldchild.txt         Save the viewing frame in ascii format 
\   quit 
\ =========================================================================== 
\ Example 4 Sketch a simple drawing 
\   120 120 new_image 
\   20 20 xy 
\   100 20 blue line  100 100 cyan line  20 100 green line  20 20 red line 
\   60 60 xy  40 magenta circle   20 40 black ellipse 
\   20 30 xy show 
\   save sketch.ppm 
\   quit 
\ ===========================================================================  


include lib/interprt.4th 
include lib/row.4th 
include lib/anstools.4th   \ for .s in the calculator 
include lib/graphics.4th 
include lib/gpic2txt.4th 
include lib/gaspect.4th 
include lib/gshrink.4th 
include lib/gcol2gry.4th 
include lib/gbanner.4th 
include lib/gcircle.4th 
include lib/gellipse.4th 
 
variable hreduce    1 hreduce !   \ times image is shrunk 
variable wreduce    1 wreduce ! 
 
variable iwidth       \ image width 
variable iheight      \ image height 
1 value draw?         \ Note if the brush or pen on the canvas! 
 
variable start_x     variable start_y     \ viewing frame 
variable cursor_x    variable cursor_y    \ cursor for user 
 
81 string gfile       \ graphics file 
256 string paint$     \ sketch line editor string 
 
90 constant default_width    \ Assuming standard text display 
30 constant default_height 
 
\ ==setup==
: view_from ( x y -- )        \ define the viewing frame 
     2dup 
     start_y !   start_x ! 
     cursor_y !  cursor_x ! ; 
 
: defaults ( -- ) 
    0 0 view_from 
    1 hreduce !  1 wreduce ! 
    false hi-contrast? ; 
 
: gcls ( -- )  255 whiteout  black ; 
 
: new_color ( width height -- )   \ set new color image 
    color_image  pic_width !   pic_height !  gcls ; 
 
: new_grayscale ( width height -- )  \ net new grayscale image 
    grayscale_image pic_width !  pic_height !  gcls ; 
 
: get_string ( -- a n) 
  0 parse-word dup 0=                 \ parse the filename 
  if 1 throw then ;           \ if no filename throw exception 
 
: info ( -- ) 
   ."  Current file: " gfile count type cr 
   space c/pixel 1 = if ." grayscale" else ." color" then 
   space ." image size (wh): " pic_width @   wreduce @  /  . 
                         pic_height @   hreduce @  /  .  cr 
   ."  Display width  " iwidth @ . cr 
   ."  Display height " iheight @ . cr 
   ."  Cursor xy = " cursor_x @ . space cursor_y @ . cr ; 
 
\ ==file I/O stuff ==
: getfile ( --  ) 
         defaults 
         get_string 2dup gfile place get_image 
         image_comment$ count type cr 
         info ; 
 
: isave ( -- )   \ save as ppm-bitmap using current size. 
   get_string 
   0 0                              ( rx1 cy1 ) 
   pic_height @  hreduce @  /     ( rx2 ) 
   pic_width @   wreduce @  /     ( cy2 ) 
   crop ; 
 
: icrop ( -- )   \ save window as ppm-bitmap 
   get_string 
   start_y @  start_x @  swap  2dup 
   iwidth @ +  pic_width @ min 
   swap iheight @ +   pic_height @ min 
   swap  crop ; 
 
                         \ Restore the original image 
: reload ( -- ) defaults  gfile count get_image ; 
 
: show ( -- ) 
    start_x @ dup iheight @ +  swap do 
      i 4 .r space 
      i start_y @ dup iwidth @ +   show_line cr 
    loop cr ; 
 
: saveit ( -- )   \ save current ascii image display 
  get_string 
  output open error?        \ value for file 
  abort" File could not be opened"    \ save handle 
  dup use                   \ redirect input to file 
  start_y @ dup iwidth @ +   start_x @ dup iheight @ + 
  show_image close ; 
 
\ ==image modification==
: ginvert ( -- )  false normal-view? ; 
: gnormal ( -- )  true  normal-view? ; 
: enhanced-image ( -- ) true hi-contrast? ; 
: regular-image ( -- ) false hi-contrast? ; 
 
\ Reduce bitmap image size by 2 
: shrinkit ( -- ) 
     start_x @  start_y @  swap 2/  swap 2/  view_from 
     hreduce @  2*  hreduce ! 
     wreduce @  2*  wreduce ! 
     shrink ; 
 
: ghshrink ( -- ) 
     start_x @  start_y @  swap 2/ swap   view_from 
     hreduce @ 2* hreduce ! 
     hshrink ; 
 
: gwshrink ( -- ) 
     start_x @  start_y @  swap  swap 2/  view_from 
     wreduce @ 2* wreduce ! 
     wshrink ; 
 
\ ==curosr movement==
: +xy ( nx ny -- )  \ shift upper left corner of viewing frame 
     >r start_x @  start_y @  >r +    0 max 
     r> r> +  0 max view_from ; 
 
: gright ( n -- ) 0 swap +xy ; 
: gleft ( n -- )  negate 0 swap +xy ; 
: gup ( n -- )    negate 0  +xy ; 
: gdown ( n -- )  0  +xy ; 
 
\ ==image line editor==
: line_ ( n -- )   \ show the current line of ascii image 
     dup cursor_x ! 
     dup  4 .r space 
     start_y @ dup iwidth @ +   show_line cr ; 
 
: lline_ ( -- )  cursor_x @  line_ 
        5 spaces cursor_y @ start_y @ - spaces char ^ emit 
        space ." y= " cursor_y @ . cr ; 
 
: _t ( n -- ) start_y @  cursor_y !  line_ ; 
: <down> ( -- )  1 cursor_x +! ; 
: <up>   ( -- )  -1 cursor_x +! ; 
: <move> ( n -- )  cursor_y +! ; 
 
: plot ( -- ) cursor_x @ cursor_y @  set_pixel ; 
: cmatch ( -- ) cursor_x @  cursor_y @  pixel@  intensity! ; 
 
\ Draw the picture capturing the cursor and editing 
\ the keystrokes in a single string. 
 
: <right> ( -- ) 1 cursor_y +! ; 
: right ( -- )  plot <right> ; 
: _b ( -- ) black right ; 
: _z ( -- ) blue right ; 
: _c ( -- ) cyan right ; 
: _r ( -- ) red right ; 
: _m ( -- ) magenta right ; 
: _y ( -- ) yellow right ; 
: _g ( -- ) green right ; 
: _w ( -- ) white right ; 
 
 create paint_keys 
  char . ,    ' <right> ,  
  char x ,    ' right , 
  char b ,    ' _b , 
  char z ,    ' _z , 
  char c ,    ' _c , 
  char r ,    ' _r , 
  char m ,    ' _m , 
  char y ,    ' _y , 
  char g ,    ' _g , 
  char w ,    ' _w , 
  null , 
 
: do_keys (  c -- ) 
       paint_keys 2 num-key  row if 
        cell+ @c execute 
      then drop ; 
 
: sketch ( -- )    \ cursor placement remains
     get_string paint$ place 
     paint$ count 
     0 do 
        paint$ i +  c@ do_keys 
     loop drop ; 

                   \ cursor to start of line
: draw ( -- ) start_y @  cursor_y ! sketch ; 

\ ==drawing primatives==
: _line ( x2 y2 -- )   2dup  cursor_x @ cursor_y @ 
     2swap  line   cursor_y !  cursor_x ! ; 
: _circle ( r -- )   >r cursor_x @  cursor_y @ r> circle ; 
: _ellipse ( a b -- )  >r >r cursor_x @  cursor_y @  r> r> ellipse ; 
 
: plot_text ( -- )               \ Plot the text from user 
     cursor_x @  cursor_y @  get_string gbanner ; 
 
: htext ( -- ) text_up horizontal plot_text ;  \ horizontal text 
: vtext ( -- )  text_down vertical plot_text ; \ verical text 
 
 
\ Change the viewing frame 
: width_ ( n -- ) iwidth ! ; 
: height_ ( n -- ) iheight ! ; 
 
\ Calculator executables 
: bye abort ; 
: dot . ; 
: .s_  .s ; 
: dup_ dup ; 
: rot_ rot ; 
: swap_ swap ; 
: plus_ + ; 
: minus_ - ; 
: times_ * ; 
: divide_ / ; 
 
\ ===HELP=========== 
 : i/o-help ( -- ) cr 
  ." new_image     ( width height )  setup new color image" cr 
  ." new_grayscale ( width height )  setup new grayscale image" cr 
  ." file    ( text ) load graphics image: file test.ppm" cr 
  ." txtsave ( text ) save ascii art image: txtsave face.txt" cr 
  ." save    ( text ) save bitmap image: save postcard.ppm" cr 
  ." crop    ( text ) save current bitmap view: crop tt.ppm" cr 
  ." reload  ( -- ) reset defaults and reload image" cr 
  ." info    ( -- ) list current conditions" cr 
  ." quit q bye ( -- ) see you!" cr cr ; 
 
: view-help ( -- ) cr 
  ." show    ( -- )  show ascii image in current window" cr 
  ." height  ( n -- ) set height of current window" cr 
  ." width   ( n -- ) set width of current window" cr 
  ." invert  ( -- ) show image in negative format (for black backgroud)" cr 
  ." normal  ( -- ) show image in normal format (for white background)" cr 
  ." enhance ( -- ) show ascii image in enhanced format" cr 
  ." regular ( -- ) show ascii image in normal format" cr 
  ." xy    ( row col -- ) move current viewing window to xy" cr 
  ." right ( n -- ) move viewing window right" cr 
  ." left  ( n-- ) move viewing window left" cr 
  ." up    ( n -- ) move viewing window up" cr 
  ." down  ( n -- ) move viewing window down" cr cr ; 
 
: imodify-help ( -- ) cr 
 ." shrink    ( -- )  reduce bitmap image size by factor of 2" cr 
 ." hshrink   ( -- )  reduce image only by height" cr 
 ." wshrink   ( -- )  reduce image only by width" cr 
 ." grayscale ( -- )  convert image to a grayscale bitmap" cr 
 ." canvas    ( -- )  fill background with current pen color" cr 
 ." cls       ( -- )  set background to white and set pen to back" cr cr ; 
 
: pixel-help ( -- ) cr 
  ." match ( -- ) set pen color to pixel color at cursor" cr 
  ." plot  ( -- ) set pixel at cursor to pen color" cr 
  ." pen@  ( -- pixel_set ) get pixel color at cursor" cr 
  ." pen!  ( pixel_set -- ) set pixel at cursor" cr cr ; 
 
: cursor-help ( -- ) cr 
  ." t ( n -- ) type and set bitmap row-n" cr 
  ." l ( -- ) type/list current bitmap row with cursor" cr 
  ." n ( -- ) move to next row on the bitmap" cr 
  ." b ( -- ) move back a row on the bitmap" cr 
  ." m ( n -- ) move cursor right or left by n columns" cr cr ; 
 
  : paint-help ( -- ) cr 
  ." line ( x2 y2 -- )  draw line from cursor to x2 y2" cr 
  ." circle ( radius -- ) draw circle at cursor position" cr 
  ." ellipse ( a b -- ) draw ellipse at cursor position" cr 
  ." htext ( text ) draw horizontal text at cursor" cr 
  ." vtext ( text ) draw vertical text at cusor" cr cr 
  ." Sketch (sk) and Draw (dr) text consists of:" cr 
  ."  .=move right  x=set pixel to pen color and move right" cr 
  ."  b z c r m g y w = blk blue cyan magenta green yellow white" cr cr
  ." sk ( text ) sketch and do not reset cursor" cr 
  ." dr ( text ) home cursor left then draw" cr 
  ."   Example: dr xxxrrrr...ggg" cr cr ; 
 
: color-help ( -- ) cr 
  ." black ( -- )  set pen color to black" cr 
  ." Other default colors: " 
  ."   blue cyan red green magenta yellow white" cr cr ; 
 
 : calculator-help ( -- ) cr 
  ." rot  swap dup  + - * / . .s " cr cr ; 
 
: help ( -- ) cr 
   ." Try one of the following:" cr 
   ."   i/o-help  view-help  imodify-help pixel-help" cr 
   ."   cursor-help  paint-help color-help calculator-help " cr cr ; 
 \  ====HELP END ====== 
 

\ Dictionary 
create wordset 
  ," quit"    ' bye , 
  ," q"       ' bye , 
  ," bye"     ' bye , 
  ," .s"      ' .s_  , 
  ," ."       ' dot  , 
  ," dup"     ' dup_ , 
  ," rot"     ' rot_ , 
  ," swap"    ' swap_ , 
  ," +"       ' plus_ , 
  ," -"       ' minus_ , 
  ," *"       ' times_ , 
  ," /"       ' divide_ , 
  ," file"    ' getfile , 
  ," txtsave" ' saveit , 
  ," save"    ' isave , 
  ," crop"    ' icrop , 
  ," info"    ' info , 
  ," reload"  ' reload , 
  ," show"    ' show , 
  ," invert"  ' ginvert , 
  ," normal"  ' gnormal , 
  ," enhance" ' enhanced-image , 
  ," regular" ' regular-image , 
  ," shrink"  ' shrinkit , 
  ," hshrink" ' ghshrink , 
  ," wshrink" ' gwshrink , 
  ," right"   ' gright , 
  ," left"    ' gleft , 
  ," up"      ' gup , 
  ," down"    ' gdown , 
  ," width"   ' width_ , 
  ," height"  ' height_ , 
  ," t"       ' _t , 
  ," l"       ' lline_ , 
  ," n"       ' <down> , 
  ," b"       ' <up> , 
  ," m"       ' <move> , 
  ," plot"    ' plot , 
  ," pen@"    ' intensity@ , 
  ," pen!"    ' intensity! , 
  ," match"   ' cmatch , 
  ," sk"      ' sketch , 
  ," dr"      ' draw , 
  ," canvas"  ' background , 
  ," black"   ' black , 
  ," blue"    ' blue , 
  ," cyan"    ' cyan , 
  ," red"     ' red , 
  ," green"   ' green , 
  ," magenta" ' magenta , 
  ," yellow"  ' yellow , 
  ," white"   ' white , 
  ," line"    ' _line , 
  ," circle"  ' _circle , 
  ," ellipse" ' _ellipse , 
  ," cls"     ' gcls , 
  ," xy"      ' view_from , 
  ," htext"   ' htext , 
  ," vtext"   ' vtext , 
  ," grayscale" ' image>grayscale , 
  ," new_image"     ' new_color , 
  ," new_grayscale" ' new_grayscale , 
  ," help"          ' help , 
  ," i/o-help"      ' i/o-help , 
  ," view-help"     ' view-help , 
  ," imodify-help"  ' imodify-help , 
  ," pixel-help"    ' pixel-help , 
  ," cursor-help"   ' cursor-help , 
  ," paint-help"    ' paint-help , 
  ," color-help"    ' color-help , 
  ," calculator-help" ' calculator-help , 
   NULL , 
wordset to dictionary                  \ assign to dictionary 
 
 : initialize ( -- )  \ file specified or assume a small color image 
    argn 1 > 
    if  1 args 2dup  gfile place  get_image 
    else  color_image s" none.ppm"  gfile place 
          ppm_width 2/  pic_width !  
          ppm_height 2/  pic_height !  gcls 
    then 
    default_width iwidth ! 
    default_height iheight ! ; 
 
\ Must define the 'NotFound' for interprt.4th 
:noname 2drop ." Not found!" cr ; is NotFound 
 
: title ( -- )
  cr ." == ASCII PPM/PMG PAINT PROGRAM ==" cr 
   ."    Maximum image size is "  ppm_width .  ppm_height . cr 
   ."    help  = paint commands" cr cr info cr ; 
 
: ipaint ( -- )
  initialize defaults title 
  begin                                \ show the prompt and get a command 
    ." >" 
    refill drop              \ interpret and issue oops when needed 
    ['] interpret catch if ." Oops " then 
  again ;                              \ repeat command loop eternally 
 
ipaint 
