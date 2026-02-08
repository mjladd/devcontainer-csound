<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week6_1.orc and Week6_1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

amod      oscil     p4*.2,cpspch(p5),1            ; MODULATOR
asig      oscil     p4*.8,cpspch(p5)+amod,1       ; CARRIER

          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1                          ; A SINE WAVE

;      st      dur     amp        pitch

i1     0        2     10000       8.00      ; MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
