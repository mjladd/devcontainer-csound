<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from chirp.orc and chirp.sco
; Original files preserved in same directory

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       1


        instr   1
k1      line    0, p3, sr/2
a1      oscil   32000, k1, 1
        out     a1
        endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1

i1 0 1

</CsScore>
</CsoundSynthesizer>
