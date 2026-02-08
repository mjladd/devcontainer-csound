<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from popcornfractal.orc and popcornfractal.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; MIKELSON POPCORN FRACTAL SR MUST EQUAL KR


          instr     2

idur      =         p3                  ; DURATION
iamp      =         p4                  ; AMPLITUDE
ifqc      =         cpspch(p5)          ; PITCH TO FREQUENCY
ifade     =         p6                  ; FADE IN AND OUT
ih        =         .004                ; DELTA T
axn       init      1                   ; INITIAL X VALUE
ayn       init      -.5                 ; INITIAL Y VALUE

aamp      linseg    0, ifade, iamp, idur-2*ifade, iamp, ifade, 0 ; Amp envelope

; Popcorn fractal
axnp1     =         axn - ih*sin(ayn + tan(3*ayn))
aynp1     =         ayn - ih*sin(axn + tan(3*axn))
axn       =         axnp1
ayn       =         aynp1

arnd      rand      2                   ; GENERATE NOISE

aenv1     linseg    200, idur, 1000     ; FREQUENCY RAMP
aenv2     linseg    40, idur, 400       ; FREQUENCY MODULATION RAMP

aoutr     rezzy     arnd, aenv1+ayn*aenv2, 50 ; FILTER NOISE AND SWEEP FREQUENCY

          outs      aoutr*aamp, aoutr*aamp  ; OUTPUT

          endin

</CsInstruments>
<CsScore>


; SCORE
f1 0 65536 10 1 ; NOT USED SINE WAVE

;   STA  DUR  AMP      PITCH  FADE
i2  0    60   9000      6.00  2

</CsScore>
</CsoundSynthesizer>
