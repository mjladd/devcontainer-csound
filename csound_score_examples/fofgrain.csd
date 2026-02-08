<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from fofgrain.orc and fofgrain.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


        instr 1
a1      fof     15000, 200, 650, 0, 40, .003, .02, .007, 5, 1, 2, p3

; a1    fof     15000, 100, 300, 0, 40, .003, .02, .007, 5, 1, 2, p3
        out     a1
        endin

        instr 2
a1      grain   15000, 650, 200, 0, 0, .02, 1, 3, .02, 1

; a1    grain   15000, 300, 100, 0, 0, .02, 1, 3, .02, 1
        out     a1
        endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 19 0.5 0.5 270 0.5
f3 0 1024 7  0 124 1 900 0

i1 0 .5
i2 .6 .5

</CsScore>
</CsoundSynthesizer>
