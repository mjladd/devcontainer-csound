<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from dem2.orc and dem2.sco
; Original files preserved in same directory

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       1



        instr 1             ; DISTORTION GUITAR (KS-WS)
ikfreq  cpsmidib
kfreq   cpsmidib
iveloc  veloc
kgate   linenr  iveloc/(128*3), 0, .1, .1

k1      oscil   .1, 6, 1
a1      pluck   2, kfreq/2 + k1, ikfreq/2, 0, 2, 3
a1      table   a1+.5, 3, 1
a1      butterlp    a1, 3000
ga1     =       a1*80000 * kgate
        endin

        instr 129
ga1     butterhp    ga1, 20
ab      =       ga1
a1      reverb2 ga1, 2.1, .2
out     a1/4 + ab
ga1         =       0
        endin

</CsInstruments>
<CsScore>
f0 30
f1 0 1024 10 1
f2 0 1025 -8 -.3 200 -.3 312 0 312 .3 200 .3
f3 0 1025 -7 -.5 200 -.5 312 0 312 .5 200 .5

i129 0 12

</CsScore>
</CsoundSynthesizer>
