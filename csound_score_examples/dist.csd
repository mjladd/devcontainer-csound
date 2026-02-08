<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from dist.orc and dist.sco
; Original files preserved in same directory

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       1


        instr 1
igain   =       1.5
ims     =       100

ag1     oscil   igain, 1/9.05, 1
ag2     table   ag1+igain/2, 2, 1
a1      butterlp ag2*30000, sr/4
        out     a1
        endin

</CsInstruments>
<CsScore>
f1 0 131072 1 7 0 1 1
f2 0 4096 -8  -0.490000 1326 -0.340000 754 0.000000 546 0.300000 1470 0.600000

i1 0 10

</CsScore>
</CsoundSynthesizer>
