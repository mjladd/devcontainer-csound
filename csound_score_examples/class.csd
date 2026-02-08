<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from class.orc and class.sco
; Original files preserved in same directory

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       1


        instr 1

kenv    oscil   p4, 1 / p3, 2
kpenv   line    p6, p3, 1

a1      oscil   kenv,   p5 * kpenv, 1
        out     a1
        endin

        instr 2

ke1     linseg  0,p4,p5,p6,p7,p8,p9,p10,p11
ke2     expseg  p12,p13,p14,p15,p16

a1      oscil   ke1,ke2,1
        out     a1
        endin

</CsInstruments>
<CsScore>
f1  0   256 10  1
f2  0   256 5   1   256 .001

;i2 0   2   .25 10000   .25 8000    1   6000    .50 0   440 1   880 1   440
;e



i1  0   3 1000  440 2
i1  0   . .     440 0
i1  0   . .     440 .5
i1  0   . .     440 1.5
i1  0   . .     440 .3
i1  0   . .     440 1.3
e

</CsScore>
</CsoundSynthesizer>
