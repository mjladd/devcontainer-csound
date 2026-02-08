<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from gran2.orc and gran2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;----------------------------------------------------------------------------------
; GRANULAR SYNTHESIS v. 2
;----------------------------------------------------------------------------------
          instr     2
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
;                   AMP  FQC         DENSE  AMPOFF PITCHOFF    GRDUR  GRTABLE WINTABLE  MAXGRDUR
aoutl     grain     p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab, iwintab,  5
aoutr     grain     p4,  ifqc*kbend, idens, 100,   ifqc*kfrng, igdur, igrtab, iwintab,  5
          outs      aoutl*kamp, aoutr*kamp
          endin

</CsInstruments>
<CsScore>
; SCORE
f2 0 1024  7 0 224 1 800 0
f3 0 8192  7 1 8192 -1
f4 0 1024  7 0 512 1 512 0
f5 0 1024 10 1 .3 .1 0 .2 .02 0 .1 .04
f6 0 1024 10 1 0 .5 0 .33 0 .25 0 .2 0 .167
f7 0 1024 10 1 .5 .333 .24 .2 .1667 .14286 .1111 .1 .09091 .08333
; FREQUENCY RANGE TABLE
f10 0 1024  -7 .21  512 .01 512 .001
f11 0 1024  -7 .31  512 .01 512 .001
f12 0 1024  -7 .21  512 .01 512 .001
; PITCH BEND TABLE
f20 0 1024  -7 8     512 .99  512 1.00
f21 0 1024  -7 .125  512 1.01 512 1.00
f22 0 1024  -7 .5    512 1.02 512 1.00
;  Start  Dur   Amp    Freq  GrTab  WinTab  FqcRng  Dens  Fade  PBend
i2   0.0  6.4   1500   6.00  7      4       10      100   .01   20
i2   0.0  6.4   1500   8.00  7      4       11      100   .01   21
i2   0.0  6.4   1500  10.00  7      4       12      100   .01   22
i2   0.0  6.4   1500   6.07  7      4       10      100   .01   20
i2   0.0  6.4   1500   8.07  7      4       11      100   .01   21
e
i2   0.0  6.4   1500  10.07  7      4       12      100   .01   22

</CsScore>
</CsoundSynthesizer>
