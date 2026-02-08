<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pulse2.orc and pulse2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; pulse 2

          instr 1             ; PWM RU94
; p4      =         Pitch p5 = PulseWidth in % p6 = PWMmodDepth +/- p6% ;;
; p7      =         pwmlfoFreq               ;;p8 = LFOwaveForm F#

apwm      oscil     p6*10, p7,p8             ; =lfo
asaw      oscil     1000,p4,1                ; f#1 MUST BE SAW
asqr      table     asaw+(p5*10)+500+apwm,2,0,0,1
                                             ; f#2 = 0-1500:0, 1500-2048:+1

          out       asqr*10000               ; OUTPUT SCALING
          endin

</CsInstruments>
<CsScore>
; test Score,
f1 0 2048 7 1 2048 0                            ;Sawtooth
f2 0 4096 7 0 1500 0 0 1 2596 1         ;'Comparator function'
f3 0 4096 10 1                                          ; Sine for lfo

;i st   dur Hz PW PWM lfoFrq lfoWave
i1 0.0  2       55 50 48        .5              3;
i1 2.0  2       55 25 23        3               3;
i1 4.0  2       55  2 5         2               3;
i1 6.0  2       55  1 2         1               3;
e; end of score

</CsScore>
</CsoundSynthesizer>
