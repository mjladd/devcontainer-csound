<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from week3_1.orc and week3_1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

ivar      =         10000                    ; ivar SET TO 10000
icps      =         cpspch(p5)               ; icps SET TO CPS VALUE OF PITCH
ivib      =         icps*.01                 ; ivib (VIBRATO SPEED) IS SET TO 1/100 OF CPS
kenv      linseg    1,p3,0                   ; RAMP FROM 1 TO 0 IN DURATION p3
kenv      =         kenv*ivar                ; SCALE THE AMPLITUDE OF THE ENVELOPE
asig      oscil     kenv,icps,1              ; SINE WAVE OSCILATOR
          out       asig                     ; OUTPUT

          endin

</CsInstruments>
<CsScore>
f1     0    512     10      1               ; FUNCTION TABLE (GEN 10) TO GENERATE A SIMPLE SINE WAVE


;      st      dur     --      pitch

i1     0        2       0      8.00         ; MIDDLE C PLAYED FOR 2 SECONDS

</CsScore>
</CsoundSynthesizer>
