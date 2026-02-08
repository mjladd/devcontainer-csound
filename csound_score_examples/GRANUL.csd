<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from GRANUL.ORC and GRANUL.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;----------------------------------------------------------------------------------
; YOUR BASIC GRANULAR SYNTHESIS
;----------------------------------------------------------------------------------
          instr      1

idur      =          p3
iamp      =          p4
ifqc      =          cpspch(p5)
igrtab    =          p6
iwintab   =          p7
ifrng     =          p8
idens     =          p9
ifade     =          p10
igdur     =          .2

kamp      linseg     0, ifade, 1, idur-2*ifade, 1, ifade, 0

;                   AMP  FQC   DENSE  AMPOFF PITCHOFF    GRDUR  GRTABLE   WINTABLE  MAXGRDUR
aoutl     grain     p4,  ifqc, idens, 100,   ifqc*ifrng, igdur, igrtab,   iwintab,  5
aoutr     grain     p4,  ifqc, idens, 100,   ifqc*ifrng, igdur, igrtab,   iwintab,  5

          outs      aoutl*kamp, aoutr*kamp

          endin

;----------------------------------------------------------------------------------
; GRANULAR SYNTHESIS V. 2
;----------------------------------------------------------------------------------
          instr      2

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
igrtab    =         p6
iwintab   =         p7
ifrngtab  =         p8
idens     =         p9
ifade     =         p10
ibndtab   =         p11
igdur     =         .2

kamp      linseg    0, ifade, 1, idur-2*ifade, 1, ifade, 0
kbend     oscil     1, 1/idur, ibndtab
kfrng     oscil     1, 1/idur, ifrngtab

;                   AMP  FQC         DENSE  AMPOFF PITCHOFF    GRDUR  GRTABLE   WINTABLE  MAXGRDUR
aoutl     grain     p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab,   iwintab,  5
aoutr     grain     p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab,   iwintab,  5

          outs      aoutl*kamp, aoutr*kamp

          endin

;----------------------------------------------------------------------------------
; YOUR BASIC GRANULAR SYNTHESIS
;----------------------------------------------------------------------------------
          instr      3

idur      =          p3
iamp      =          p4
ifqc      =          cpspch(p5)
igrtab    =          p6
iwintab   =          p7
ifrng     =          p8
idens     =          p9
ifade     =          p10
igdur     =          p11

kamp      linseg     0, ifade, 1, idur-2*ifade, 1, ifade, 0

;                   AMP  FQC   DENSE  AMPOFF PITCHOFF    GRDUR  GRTABLE   WINTABLE  MAXGRDUR
aoutl     grain     p4,  ifqc, idens, 100,   ifqc*ifrng, igdur, igrtab,   iwintab,  5
aoutr     grain     p4,  ifqc, idens, 100,   ifqc*ifrng, igdur, igrtab,   iwintab,  5

          outs      aoutl*kamp, aoutr*kamp

          endin

;----------------------------------------------------------------------------------
; BASIC GRANULAR SAMPLER SYNTHESIS
;----------------------------------------------------------------------------------
          instr      4

idur      =          p3
iamp      =          p4
ifqc      =          p5
igrtab    =          p6
iwintab   =          p7
ifrng     =          p8
idens     =          p9
ifade     =          p10
igdur     =          p11
iamprng   =          p12

kamp      linseg     0, ifade, 1, idur-2*ifade, 1, ifade, 0

;                   AMP  FQC   DENSE  AMPOFF       PITCHOFF    GRDUR  GRTABLE   WINTABLE  MAXGRDUR
aoutl     grain     p4,  ifqc, idens, 100*iamprng, ifqc*ifrng, igdur, igrtab,   iwintab,  5
aoutr     grain     p4,  ifqc, idens, 100*iamprng, ifqc*ifrng, igdur, igrtab,   iwintab,  5

          outs      aoutl*kamp, aoutr*kamp

          endin

</CsInstruments>
<CsScore>
;f1 0 65536 1 "hahaha.aif" 0 4 0
f2 0 1024  7 0 224 1 800 0
f3 0 8192  7 1 8192 -1
f5 0 1024 10 1 .3 .1 0 .2 .02 0 .1 .04
f6 0 1024 10 1 0 .5 0 .33 0 .25 0 .2 0 .167
f7 0 1024 10 1 0 .2 .2 .03 .12 .22 .11 .022 .0101 .0167
f4 0 1024  8 0 512 1 512 0

;  Start  Dur  Amp   Freq  GrTab  WinTab  FqcRng  Dens  Fade
i1   0.0  6.0  1400  9.00  7      4       .080    200   1.5
i1   4.0  4.0  1000  8.07  7      4       .150    200   2.5
i1   7.0  6.0  1700  9.05  7      4       .250    100   2.5


</CsScore>
</CsoundSynthesizer>
