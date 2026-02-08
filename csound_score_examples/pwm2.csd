<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pwm2.orc and pwm2.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; COPYRIGHT 1998 PAUL M. WINKLER, ZARMZARM@EROLS.COM
; LAST MODIFIED: MON DEC 14 03:52:13 1998
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


gkLFO          init      0
gkamp          init      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WE SIMULATE A SQUARE WAVE BY OVERDRIVING A TABLE INDEX,
; AND SIMULATE PWM BY VARYING AN OFFSET TO THE INDEX.
; ALIASING IS REDUCED BY MAKING THE AMOUNT OF OVERDRIVE
; INVERSELY PROPORTIONAL TO PITCH.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

               instr 5
ipitch         =         cpspch(p4)
ianti_alias    =         10                            ; RECOMMENDED RANGE IS 4 TO ABOUT 30
isquareness    =         sr/(ipitch * ianti_alias)

; INFINITE isquareness YIELDS A SQUARE WAVE
; isquareness < 1  YIELDS A SINE

knarrowness    =         gkLFO * isquareness
aindex         oscil     isquareness, ipitch, 1        ; SINE WAVE INDEX
aindex         =         aindex + knarrowness
aout           table     aindex, 5, 1, 0               ; f5 SHOULD BE STRAIGHT LINE +- 1
aout           dcblock   aout
kamp           adsr     .01, .02, .5, .2
kamp           =         kamp*32000*gkamp
               out       aout*kamp
               endin

               instr 98                                ; GLOBAL FADES - P4 IS RISE AND DECAY TIME
gkamp          expseg    0.005, p4, 1, (p3 - (p4 * 2)), 1, p4, 0.005
               endin

               instr 99                                ; GLOBAL LFO
klfo           linseg    p4, p3, p5                    ; RAMP FROM P4 TO P5
gkLFO          oscil     0.5, klfo, 1                  ; USE F1
gkLFO          =         gkLFO + 0.5                   ; RANGE FROM 0 TO 1
               endin

</CsInstruments>
<CsScore>
t  0 120

; LFO WAVE SHAPE ... IT'S WEIGHTED TOWARD THE TOP
; I SHOULD FIGURE OUT HOW TO MAKE THE MODULATION RESPOND
; BETTER TO A LINEAR CONTROL SIGNAL!

f1 0 512  7  1 128 .5 128 -1 128 .5 128 1

; STRAIGHT LINE FOR INSTR 5

f5 0 512 -7 -1 512 1

; SET UP LFO AND FADES

i 98 0 32 1.0
i 99 0 32 0.3 .6

; BASS_1, TRACK 0, NOW AT 0

i 5 0.0 0.5 6.00
i 5 0.5 0.5 6.01
i 5 1.0 0.5 6.02
i 5 1.5 0.5 7.00
i 5 2.0 0.5 6.00
i 5 2.5 0.5 7.00
i 5 3.0 0.5 6.01
i 5 3.5 0.5 6.02
i 5 4.0 0.5 6.05
i 5 4.5 0.5 6.00
i 5 5.0 0.5 5.09
i 5 5.5 0.5 6.02
i 5 6.0 0.5 6.05
i 5 6.5 0.5 6.04
i 5 7.0 0.5 6.03
i 5 7.5 0.5 6.00

; BASS_1, TRACK 0, NOW AT 8

i 5  8.0 0.5 8.0
i 5  8.5 0.5 8.01
i 5  9.0 0.5 8.02
i 5  9.5 0.5 9.0
i 5 10.0 0.5 8
i 5 10.5 0.5 9
i 5 11.0 0.5 8.01
i 5 11.5 0.5 8.02
i 5 12.0 0.5 8.05
i 5 12.5 0.5 8
i 5 13.0 0.5 7.09
i 5 13.5 0.5 8.02
i 5 14.0 0.5 8.05
i 5 14.5 0.5 8.04
i 5 15.0 0.5 8.03
i 5 15.5 0.5 8

; BASS_1, TRACK 0, NOW AT 16

i 5 16.0 0.5 5
i 5 16.5 0.5 5.01
i 5 17.0 0.5 5.02
i 5 17.5 0.5 6
i 5 18.0 0.5 5
i 5 18.5 0.5 6
i 5 19.0 0.5 5.01
i 5 19.5 0.5 5.02
i 5 20.0 0.5 5.05
i 5 20.5 0.5 5
i 5 21.0 0.5 4.09
i 5 21.5 0.5 5.02
i 5 22.0 0.5 5.05
i 5 22.5 0.5 5.04
i 5 23.0 0.5 5.03
i 5 23.5 0.5 5

; BASS_1, TRACK 0, NOW AT 24

i 5 24.0 0.5 11
i 5 24.5 0.5 11.01
i 5 25.0 0.5 11.02
i 5 25.5 0.5 12
i 5 26.0 0.5 11
i 5 26.5 0.5 12
i 5 27.0 0.5 11.01
i 5 27.5 0.5 11.02
i 5 28.0 0.5 11.05
i 5 28.5 0.5 11
i 5 29.0 0.5 10.09
i 5 29.5 0.5 11.02
i 5 30.0 0.5 11.05
i 5 30.5 0.5 11.04
i 5 31.0 0.5 11.03
i 5 31.5 0.5 11

e

</CsScore>
</CsoundSynthesizer>
