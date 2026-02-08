<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from samphold.orc and samphold.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;============
;CASCONE.ORC
;============


;=====================
;REVERB INITIALIZATION
;=====================

garvbsig  init      0

;====================
;DELAY INITIALIZATION
;====================

gasig     init      0

;============================
;INSTRUMENT 4 - SAMPLE & HOLD
;============================

          instr     4

krt       =         p6                  ;KRT IS THE FRQ OF RANDH OUTPUT & CLK OSC
isd       =         p4                  ;ISD HOLDS THE VALUE OF THE SEED FOR RANDH
krnd      randh     1000,krt,isd        ;NOISE INPUT TO S&H
kclk      oscil     100,krt,14          ;f14 IS A DUTY CYCLE WAVE
ksh       samphold  krnd, kclk          ;S&H
a2        oscil     600, ksh,11
a3        oscil     a2,1/p3,10          ;F10=ADSR-A3 IS THE OUTPUT

kpan      oscil     1,.04,17

asig1     =         a3*kpan
asig2     =         a3*(1-kpan)

          outs      asig1,asig2


garvbsig  =         garvbsig+(a3*.2)

          endin

;========================
;INSTR 99 - GLOBAL REVERB
;========================

          instr     99

a1        reverb2   garvbsig,p4,p5
          outs      a1,a1

garvbsig  =         0

          endin


</CsInstruments>
<CsScore>
;============
;SAMPHOLD.SCO
;============
f10 0 512   7 0 50 1 50 .5 300 .5 112 0        ;ADSR
f11 0 2048  10 1                               ;SINEWAVE HI-RES
f14 0 512   7 1 17  1 0   0 495                ;PULSE FOR S&H CLK OSC
f17 0 1024  7   .5 256 1 256 .5 256 0 256 .5   ;TRIANGLE WITH OFFSET
;----------------------------------------------------------------------

;======
;REVERB
;======
;INST STRT DUR DLTIME
i99   0    20  2.6   .6

;=============
;SAMPLE & HOLD
;=============
;  STRT DUR ISEED AMP  CLK
i4 0   3   .3    2.5  7
i4 5   5   .456  9    8.5
i4 11   6   .334  7    10
i4 18  10  .625  2    7



</CsScore>
</CsoundSynthesizer>
