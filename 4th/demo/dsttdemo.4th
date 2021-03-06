\ Tiny Dynamic Strings Demo - Copyright 2020 J.L. Bezemer
include lib/dstringt.4th

struct
  field: a
  field: b
  field: c
  field: d
  field: e
end-struct /dstring                    \ define all dynamic strings
                                       \ allocate array and initialize it
/dstring array $ latest /dstring ds.build

s" Hello world" $ a ds.place           \ initialize dstring A
$ a ds.count type cr                   \ print dstring A
s" #Hello world" $ b ds.place          \ initialize dstring A
$ b ds.count type cr                   \ print dstring B
 
s" Hello" $ c ds.place                 \ initialize dstring C
s"  world!" $ c ds+place               \ append to dstring C

$ c ds.count chop $ c ds.place         \ CHOP a character from dstring C
$ c ds.count type cr                   \ print dstring B

ds.destroy                             \ destroy *all* dstrings

variable my$ latest ds.init            \ define a dstring and
                                       \ initialize it
s" This is the" my$ ds.place           \ now place a string in it
my$ ds.count type cr                   \ print the string
s"  End." my$ ds+place                 \ append a string to it
my$ ds.count type cr                   \ print it again
my$ ds.count my$ ds+place              \ append itself to it
my$ ds.count type cr                   \ print it again

my$ ds.free depth .                    \ finally free the dstring


