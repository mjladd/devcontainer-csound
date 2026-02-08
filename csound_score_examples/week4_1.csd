<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week4_1.orc and week4_1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

k1        expseg    .0001,.01,1,.01,.5,p3-.02,.001     ; DECAYING EXPSEG
k2        linseg    1,.02,1,p3-.02,2.5                 ; RISING LINSEG
k3        =         k1*k2
asig      oscil     k3*p4,cpspch(p5),1                 ; AMP ARGUMENT MULTIPLIED BY MAX AMPLITUDE (p4)

          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1                          ; A SINE WAVE

;      st      dur     amp        pitch

i1     0        2     10000       8.00      ; MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
