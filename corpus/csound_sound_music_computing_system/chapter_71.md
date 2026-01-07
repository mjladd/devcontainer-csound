# 1. We create a function table with N points holding a desired amplitude curve. Po-

1. We create a function table with N points holding a desired amplitude curve. Po-
sition 0 will be equivalent to 0 Hz and position N to sr
2 , the Nyquist frequency.
The size should be large enough to allow for the transition between passband and
stopband1 to be as steep as we like. The width of this transition region can be as
small as
sr
2N . For N = 1,024 and sr = 44,100, this is about 21.5 Hz. However,
with such small transitions, some ripples will occur at the edges of the transi-
tion, which might cause some ringing artefacts. Nevertheless, steep transitions
can still be constructed spanning a few table positions, if N is large enough. A
table implementing this can be created with GEN7, for instance. For a brickwall
(i.e. with a steep transition) low-pass curve, we would have
ifn ftgen
1,0,1024,7,1,102,1,10,0,912,0
In this case, the passband will be 10% of the spectrum, about 2,205 Hz, and the
transition will be 10 table points, or 1%.