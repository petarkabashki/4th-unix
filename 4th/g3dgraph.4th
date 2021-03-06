\ After a program by Rasťo Barancík, BIT 12/92
\ Assumed to be in the public domain

include lib/graphics.4th               \ for SET_PIXEL
include lib/fp1.4th                    \ for FP support
include lib/zenfsin.4th                \ for FSIN
include lib/fpconst.4th                \ for PI
include lib/fexpflni.4th               \ for FEXP

255 floats array m

256 pic_width !                        \ this fills it up pretty nicely
192 pic_height !
color_image 255 whiteout blue
                                       \ translate coordinates
: plot fround f>s >r fround f>s 185 swap - r> set_pixel ;

pi 4 s>f f/ fcos                       ( a)
142 1 ?do
  fdup i s>f f*                        ( a e)
  i s>f 70 s>f f- fdup f*              ( a e c)
  142 1 ?do
     i s>f 70 s>f f- fdup f*           ( a e c d)
     fover f+ -1000 s>f f/ fexp 80 s>f f*
     frot fswap fover f+               ( a c e y1)
     fover i s>f f+                    ( a c e y1 x1)
     fover fover fround f>s floats m + f@ f<
     if fdrop fdrop else fover fover fround f>s floats m + f! plot then
     fswap                             ( a e c)
  loop fdrop fdrop
5 +loop fdrop

s" g3dgraph.ppm" save_image

