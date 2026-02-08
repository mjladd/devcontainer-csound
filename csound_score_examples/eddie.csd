<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from eddie.orc and eddie.sco
; Original files preserved in same directory

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       1


        instr 6
inote   =       cpspch( p4)
kamp    linen   .2, .1, p3, .1
a1      oscil   10000, inote - .5, 2
a2      oscil   10000, inote + .5, 2
a3      oscil   10000, inote / 2 , 2
kfreq   line    4000, 4.1, 100
afil    butterlp (a1 + a2 + a3), kfreq
afil2   butterbp afil, kfreq, 50
        out     kamp * (5 * afil2 + afil)
        endin

</CsInstruments>
<CsScore>
f2 0 1024 7 0 2 1 1022 0

i6      0   4   7.00
i6      0   4   6.00
i6      4   4   7.00
i6      4   4   6.00
i6      3   1.5 7.08
i6      3   1.5 8.00
i6      3   1.5 8.03
i6      4.5 1.5 7.10
i6      4.5 1.5 8.02
i6      4.5 1.5 8.05
i6      6   2   8.00
i6      6   3   8.04
i6      6   3   8.07


</CsScore>
</CsoundSynthesizer>
