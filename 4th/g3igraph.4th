\ After a program by Rasťo Barancík, BIT 12/92
\ Assumed to be in the public domain

include lib/graphics.4th               \ for SET_PIXEL
include lib/fractext.4th                   \ for VEXP, VROUND
include lib/math.4th                   \ for (COS)

255 cells array m

256 pic_width !                        \ this fills it up pretty nicely
192 pic_height !
color_image 255 whiteout blue
                                       \ translate coordinates
: *s>v 10K * s>v ;                     \ convert and scale
: v>s* vround v>s 10K / ;              \ round and convert
: plot v>s* >r v>s* 185 swap - r> set_pixel ;
                                       \ plot a pixel
pi*10k 4 / (cos) s>v                   ( a)
142 1 ?do
  dup i *s>v v*                        ( a e)
  i *s>v 70 *s>v - dup v*              ( a e c)
  142 1 ?do
     i *s>v 70 *s>v - dup v*           ( a e c d)
     over + -1000 *s>v v/ vexp 80 *s>v v*
     rot swap over +                   ( a c e y1)
     over i *s>v +                     ( a c e y1 x1)
     over over v>s* cells m + @ <
     if drop drop else over over v>s* cells m + ! plot then
     swap                              ( a e c)
  loop drop drop
5 +loop drop

s" g3igraph.ppm" save_image

