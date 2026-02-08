<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from comb1.orc and comb1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
iloop     =         1/p6
; itime   =         p5
kenv      linen     1,.05, p3, .1
a1        soundin   5
a2        comb      a1*p4*kenv, p5, iloop, 0
          out       a2
          endin

</CsInstruments>
<CsScore>
; Score to accompany:

;p1  p2   p3   p4   p5   p6

i1   0    1.5  .5   1          25       ;0.04
i1   +    .    .      .         50      ;0.02
i1    .   .    .      .         200        ;0.05
i1    .   .       .   .         500         ;0.002
i1    .   .       .   .         1000    ;0.001

e

</CsScore>
</CsoundSynthesizer>
