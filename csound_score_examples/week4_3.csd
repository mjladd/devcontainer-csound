<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week4_3.orc and week4_3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

istart    =         cpspch(p5)               ; STARTING PITCH
ifin      =         cpspch(p5-1.00)          ; END PITCH OCTAVE DOWN
kgliss    line      istart,p3,ifin           ; LINE FROM 1200 TO 400
asig      oscil     p4,kgliss,1              ; OSCILLATOR

          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1                           ; A SINE WAVE

;      st      dur     amp        pitch

i1     0        2     10000       8.00  ; MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
