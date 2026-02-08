<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from comb2.orc and comb2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
; iloop   =         1/p6
; itime   =         p5
kenv      linen     1,.05,p3,.1
a1        soundin   5
a2        comb      a1*.8*p4*kenv, p5, p6, 0
          out       a1+a2
          endin

</CsInstruments>
<CsScore>
; Score to accompany:

;p1  p2   p3   p4   p5    p6
i1   0       8  1     2       .1
s
i1   0       8  1    2   .05
s
i1   0       8  1     2       .01
s
i1   0       8  1     2       .005
s
i1   0       8  1    2   .001
e


i1   0       8  1     15      1.5
s
i1   0       8  1     11    1.1
s
i1   0       8  1     9       .9
s
i1   0       8  1     7       .7
s
i1   0       8  1     5       .5
s
i1   0       8  1     3       .3
s
i1   0       8  1     1       .1
s
i1   0       8  1     .5      .05
s
i1   0       8  1     .1      .01
s
i1   0       8  1     .05     .005
s
i1   0       8  1     .01     .001
e
t 0 60 2.55 240
i1   0       2.2     .6    1       .1
i1   .15    .      .        <    <
i1   .30    .      .        <    <
i1   .45    .      .        <    <
i1   .6       .     .       <    <
i1   .75    .      .        <      <
i1   .90    .       .       <    <
i1   1.05 .        .        <      <
i1   1.2    .      .        <      <
i1   1.35 .         .       <      <
i1   1.5    .       .6     <     <
i1   1.65 .        >     <    <
i1   1.8    .      >       <       <
i1   1.95 .         >      <     <
i1   2.1    .      >    <     <
i1   2.25 .       .3       <       <
i1   2.4    .      .        <    <
i1   2.55 1.6  .      1    .005
e

</CsScore>
</CsoundSynthesizer>
