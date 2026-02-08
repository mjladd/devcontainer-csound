<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week4_2.orc and week4_2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

kgliss    line      1200,p3,400              ; LINE FROM 1200 TO 400
asig      oscil     p4,kgliss,1              ; OSCILLATOR
          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1                      ; A SINE WAVE

;      st      dur     amp        pitch

i1     0        2     10000         0   ; PITCH TAKEN FROM KGLISS

</CsScore>
</CsoundSynthesizer>
