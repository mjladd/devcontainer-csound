<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week10_6.orc and Week10_6.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

kenv      expon     1,p3,.0001                         ; EXPON ENVELOPE
asig      foscil    p4*kenv,cpspch(p5),1,1.414,2,1     ; AN FM BELL
adel      delay     asig,.5                            ; DELAY .5 SECONDS
          out       asig+adel

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1                          ; A SINE WAVE

;      st      dur     amp        pitch

i1     0        2     10000       8.00      ;  MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
