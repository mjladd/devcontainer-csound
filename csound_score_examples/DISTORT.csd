<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from DISTORT.ORC and DISTORT.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1

iamp      =         p4
ifqc      =         cpspch(p5)
itab1     =         p6

asig      oscil     iamp, ifqc, itab1
aout      distort1  asig, 1, 1, .5, .5

          outs      aout

          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1

;  Sta  Dur  Amp    Fqc   Table
i1 0.0  1.0  10000  8.00  1


</CsScore>
</CsoundSynthesizer>
