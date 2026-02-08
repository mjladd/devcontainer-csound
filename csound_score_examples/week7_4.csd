<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week7_4.orc and week7_4.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

kenv      linseg    0,p3*.5,1,p3*.5,0        ; UP-DOWN RAMP ENVELOPE
kran      randh     50,kr                    ; PRODUCE VALUES BETWEEN -50 AND 50
kran      =         kran+200                 ; SHIFT VALUES TO CENTRE OF 200
asig      oscil     kenv*p4,kran,1           ; GENERATE A BAND OF NOISE
          out       asig

          endin

</CsInstruments>
<CsScore>
f1      0 512 10 1              ; A SINE WAVE

;      st      dur     amp

i1     0        2     10000

</CsScore>
</CsoundSynthesizer>
