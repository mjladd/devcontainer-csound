<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from atonex.orc and atonex.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1


a1        oscili    30000,p4,1
kenv      expseg    p4,p3/2,3000,p3/2,p4
a1        atonex    a1,kenv,8
          out       a1
          endin





</CsInstruments>
<CsScore>
f1 0 2048 11 80 0 1

i1 0 5 100
i1 5 5 80
i1 10 5 440




</CsScore>
</CsoundSynthesizer>
