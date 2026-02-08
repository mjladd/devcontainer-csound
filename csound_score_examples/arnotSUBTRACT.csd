<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from arnotSUBTRACT.ORC and arnotSUBTRACT.SCO
; Original files preserved in same directory

        sr          =         44100
        kr          =         4410
        ksmps       =         10
        nchnls      =         2

; JOHN M. ARNOTT II
; SUBTRACTIVE SYNTHESIS
; SIMPLE SUBTRACTIVE INSTRUMENT



        instr       1,2,3,4

        imincf      =         26.6
        ibwmin      =         .05
        ibwrange    =         .45
        iratio      =         2.828

        kgate       linen     p4,p6,p3,p7
        aw1         buzz      kgate,p5,5,2
        klin        linseg    ibwmin, 1/p3, ibwrange+ibwmin, 1, ibwrange+ibwmin
        ksum        =         ibwmin + klin

        kcf         =         p5
        kbw         =         kcf * ksum

        aw2         reson     aw1,kcf,kbw,1

        aleft       =         sqrt(p8)*aw2
        aright      =         sqrt(p9)*aw2
        outs        aleft,aright
        endin

</CsInstruments>
<CsScore>
f01     0       512     10      1
f02     0       8192    10      1
f03     0       512     5       1       512     .000001
;       start   dur     amp     pitch   rise    decay   leftfac rightfac
i01     0       6       15000   131     1       1       1       0
i01     1       4       15000   196     1       1       0       1
i01     2       3       15000   165     1       1       .5      .5
i01     3       3       15000   262     1       1       0       1
e

</CsScore>
</CsoundSynthesizer>
