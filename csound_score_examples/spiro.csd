<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from spiro.orc and spiro.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2

;****************************************************************
; INSTRUMENT SECTION


instr 3                            ; HYPOCYCLOID OR SPIROGRAPH CURVE
                                   ; THIS SET OF PARAMETRIC EQUATIONS DEFINES THE PATH TRACED
                                   ; BY A POINT ON A CIRCLE OF RADIUS B ROTATING INSIDE A
                                   ; CIRCLE OF RADIUS A.

;kphi          init      0

ifqc           =         cpspch(p5)     ; ROOT FREQUENCY
ia             =         p6             ; RADIUS A
ib             =         p7             ; RADIUS B

; AMP ENVELOPE
kampenv        linseg    0, .1, p4, p3-.2, p4, .1, 0        ; AMP ENVELOPE
kptchenv       linseg    .1, .2*p3, 1, .8*p3, 1             ; PITCH ENVELOPE
kvibenv        linseg    0, .3*p3, 0, .2*p3, 1, .5*p3, 1    ; VIBRATO ENVELOPE
kvibr          oscil     20, 8, 1                           ; VIBRATO
kfqc           =         ifqc*kptchenv+kvibr*kvibenv        ; FREQUENCY

; X EQUATION
acos1          oscil     ia-ib, kfqc, 1, .25
acos2          oscil     ib, (ia-ib)/ib*kfqc, 1, .25
ax             =         acos1 + acos2

; Y EQUATION
asin1          oscil     ia-ib, kfqc, 1
asin2          oscil     ib, (ia-ib)/ib*kfqc, 1
ay             =         asin1 - asin2

               outs      kampenv*ax, kampenv*ay

endin

</CsInstruments>
<CsScore>
;**************************************************************
; SCORE
f1 0 8192 10 1

t 0 100

;   Start Dur  Amp    Frqc   A    B
i3   0     6  1000    8.00   10   2
i3   4     4  1500    7.11   5.6  .4
i3   +     4  2000    8.05   2    8.5
i3   .     2  4000    8.02   4    5
i3   .     2  4000    8.02   5    .5

</CsScore>
</CsoundSynthesizer>
