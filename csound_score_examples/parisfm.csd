<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from parisfm.orc and parisfm.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


        instr 1
a1      oscil   1000, 500, p4
a2      oscil   20000, 500 + a1, p4
        out     a2
        endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 7 -1 512 1 512 -1
f3 0 1024 20 2
f4 0 1024 8 0 256 1 512 -1 256 0
f5 0 1024 8 1 512 -1 512 1
f6 0 1024 7 0 256 1 256 0 256 -1 256 0

i1 0 1 1    ;sine waves
i1 + 1 2    ;triangle waves
i1 + 1 3    ;hanning window??!
i1 + 1 4    ;sineish spline
i1 + 1 5    ;cosineish spline
i1 + 1 6    ;segmented sine ( 4 parts)

</CsScore>
</CsoundSynthesizer>
