<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week12_3.orc and week12_3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

ist       =         cpspch(p5)               ; START PITCH
iend      =         cpspch(p5+1.00)          ; END PITCH
kpitch    line      ist,p3,iend              ; GLISS FROM START TO END
kenv      linseg    0,p3/2,p4,p3/2,0         ; UP-DOWN ENVELOPE
krand     randi     kpitch*.03,kr            ; A BAND OF FREQUENCIES
aindex    phasor    kpitch+krand             ; READ TABLE AT PITCH RATE
asig      table     aindex*1024,1            ; INDEX TABLE
          out       asig*kenv                ; OUTPUT SIGNAL

          endin

</CsInstruments>
<CsScore>
f1 0 1024 7 0 16 1 224 1 16 0 16 -1 224 -1 16 0 512 0   ; GEN 7 FUNCTION TABLE


;      st      dur     amp        pitch

i1     0        2     10000       8.00                  ; MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
