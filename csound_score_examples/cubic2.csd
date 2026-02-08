<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from cubic2.orc and cubic2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1

aout      oscili    30000,p4,1
          out       aout
          endin

          instr     2

aout      oscil     30000,p4,2
          out       aout
          endin

</CsInstruments>
<CsScore>
f1 0 4 10 1
f2 0 32 8 0 2 1 2 0 2 -1 2 0 2 1 2 0 2 -1 2 0 2 1 2 0 2 -1 2 0 2 1 2 0 2 -1 2
i1 0 3 5512.5
i2 3.5 3 1378.125
e



</CsScore>
</CsoundSynthesizer>
