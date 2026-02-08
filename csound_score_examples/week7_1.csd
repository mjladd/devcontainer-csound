<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week7_1.orc and week7_1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

asig      rand      10000                    ; PRODUCE VALUES BETWEEN -10000 AND 1000
          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1              ; A SINE WAVE

;      st      dur     amp

i1     0        2       -

</CsScore>
</CsoundSynthesizer>
