<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FEMAHH.ORC and FEMAHH.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;**********************************************************************
; VOICES
; SYNTHESIS:    FOF(45)
;               SUMMED FOF GENERATORS(33)
; CODED:        3/27/96 HANS MIKELSON


          instr 1
; MALE AAAAAH
idur      =         p3
ifq       =         p4
k1        oscil     2, 4, 1                    ; vibrato
k2        linseg    0, idur*.5, 0, idur*.5, 1  ; octaviation coefficient

;
;                   xamp  xfund xform koct kband kris kdur kdec iolaps ifna ifnb   idur
;  BASE AMPLITUDE OF 20000

a1        fof       10000,ifq+k1,  370, k2, 200, .003, .017, .005,  2, 1,19, idur, 0, 1
a2        fof       5000,ifq+k1, 3200, k2, 200, .003, .017, .005, 2, 1,19, idur, 0, 1
a3        fof       4000,ifq+k1, 3730, k2, 200, .003, .017, .005, 2, 1,19, idur, 0, 1

a7        =         (a1 + a2 + a3) * p5 / 10

a8        tone      a7, 5000
          out       a7

          endin


</CsInstruments>
<CsScore>
;***********************************************************************
; ACCCI:     45_33_1.SC
; coded:     jpg 3/94
; GEN FUNCTIONS **********************************************************
t 0 240
f1  0 4096  10 1
f19 0 1024  19 .5 .5 270 .5
; SCORE******************************************************************

;  istart idur ifq  ivol (1-10)
i1  0     10   115  5

e

</CsScore>
</CsoundSynthesizer>
