<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from SNDENV.ORC and SNDENV.SCO
; Original files preserved in same directory

sr        =         44100     ; SAMPLE RATE OF SOUND FILE
kr        =         4410      ; CONTROL RATE
ksmps     =         10
nchnls    =         1         ; MONO


          instr 1
k1        expon     p6, p3, p7               ; p6 = START CURVE, p7 = END CURVE
a1        soundin   p5, 0, 4                 ; p5 = SOUNDIN F#
a1        =         a1 * k1                  ; RAMP THE SOUNDIN
ascale    =         a1 * p4                  ; p4 = SCALING FACTOR
          display   k1, p3                   ; DRAW CURVE ON SCREEN
          out       ascale                   ; WRITE TO DISK
          endin

</CsInstruments>
<CsScore>
;SoundEnv.sco

f1 0 0 -1 "asleep.aiff" 0 4     ; 4 tells its a 16 bit opperation



;p1     p2      p3      p4          p5          p6              p7
;ins    start   dur     ampscale    sndfunc     slopestart      slopeend
i1      0       1       1           1           1               .001
i1      2       2       1           1           1               .0001
e

</CsScore>
</CsoundSynthesizer>
