<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pan1.orc and pan1.sco
; Original files preserved in same directory

nchnls         =         2


garvb          init      0

               instr     3
iamp           =         p4
icps           =         p5
icar           =         p6
imod           =         p7
indx           =         p8
irvb           =         p9
ipan           =         p10
afm            foscili   iamp, icps, icar, imod, indx, 11
asig           oscil     afm, 1/p3, 18
               outs      asig*ipan, asig*(1-ipan)
garvb          =         garvb+(asig*irvb)
               endin

               instr     4
iamp           =         p4
icps           =         p5
icar           =         p6
imod           =         p7
indx           =         p8
irvb           =         p9
ipan           =         p10
afm            foscili   iamp, icps, icar, imod, indx, 11
asig           oscil     afm, 1/p3, 18
irtl           =         sqrt(ipan)                         ;SQRT PANNING TECHNIQUE
irtr           =         sqrt(1-ipan)                       ;PG 247,FIG.7.20 DODGE/JERSE BOOK
               outs      asig*irtl, asig*irtr
garvb          =         garvb+(asig*irvb)
               endin

               instr     5
iamp           =         p4
icps           =         p5
icar           =         p6
imod           =         p7
indx           =         p8
irvb           =         p9
ipan           =         p10
afm            foscili   iamp, icps, icar, imod, indx, 11
asig           oscil     afm, 1/p3, 18
irtl           =         sqrt(2)/2*cos(ipan)+sin(ipan)      ;CONSTANT POWER PANNING
irtr           =         sqrt(2)/2*cos(ipan)-sin(ipan)      ;FROM C.ROADS "CM TUTORIAL" PP460
          outs asig*irtl, asig*irtr
garvb     =              garvb+(asig*irvb)
          endin

          instr          99
          asig           nreverb garvb, p4, p5
          outs           asig, asig
garvb     =              0
          endin

</CsInstruments>
<CsScore>
f 11 0 2048 10 1
f 18 0 1024  5 .01 100 1 412 .01

;===========================
;p1  p2   p3   p4   p5
;instr    strt dur  rvbtime   hfdif
i99  0        8      3.3 .1
;==============================================
;    FM INSTR
;==============================================
;ins strt dur  amp       frq       car       mod       index     rvb       kpan
i3        1         .1   20000     100       1         1         1         .1        0
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         500       .         20        20        .         1
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         <         .         <         <         .         <
i3        +         .    .         100       .         1         1         .         0
s
;===========================
;p1  p2   p3   p4   p5
;instr    strt dur  rvbtime   hfdif
i99  0        8      3.3 .1
;ins strt dur  frq  car       mod       kpan kndx kamp rvbsnd
i4        1         .1   20000     100       1         1         1         .1        0
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         500       .         20        20        .         1
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         <         .         <         <         .         <
i4        +         .    .         100       .         1         1         .         0
s
;===========================
;p1  p2   p3   p4   p5
;instr    strt dur  rvbtime   hfdif
i99  0        8      3.3 .1
;ins strt dur  frq  car       mod       kpan kndx kamp rvbsnd
i5        1         .1   20000     100       1         1         1         .1        0
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         500       .         20        20        .         1
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         <         .         <         <         .         <
i5        +         .    .         100       .         1         1         .         0

</CsScore>
</CsoundSynthesizer>
