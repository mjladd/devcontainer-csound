<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from planet.orc and planet.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


               instr     1

idur           =         p3
iamp           =         p4
km1            =         p5
km2            =         p6
ksep           =         p7
ix             =         p8
iy             =         p9
iz             =         p10
ivx            =         p11
ivy            =         p12
ivz            =         p13
ih             =         p14
ifric          =         p15

kamp           linseg    0, .002, iamp, idur-.004, iamp, .002, 0

ax, ay, az planet km1, km2, ksep, ix, iy, iz, ivx, ivy, ivz, ih, ifric

               outs      ax*kamp, ay*kamp

               endin

</CsInstruments>
<CsScore>
;   Sta  Dur  Amp   M1  M2  Sep  X   Y  Z  VX  VY  VZ   h   Frict
i1  0    1    5000  .5  .35 2.2  0  .1  0  .5  .6  -.1  .5  -0.1
i1  +    .    .     .5  0   0    0  .1  0  .5  .6  -.1  .5   0.1
i1  .    .    .     .4  .3  2    0  .1  0  .5  .6  -.1  .5   0.0
i1  .    .    .     .3  .3  2    0  .1  0  .5  .6  -.1  .5   0.1
i1  .    .    .     .25 .3  2    0  .1  0  .5  .6  -.1  .5   1.0
i1  .    .    .     .2  .5  2    0  .1  0  .5  .6  -.1  .1   1.0


</CsScore>
</CsoundSynthesizer>
