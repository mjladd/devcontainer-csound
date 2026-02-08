<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from VOICES.ORC and VOICES.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         441
ksmps          =         100
nchnls         =         1

;**********************************************************************
; VOICES
; SUMMED FOF GENERATORS
; CODED: 3/1/97 HANS MIKELSON
;**********************************************************************


instr 1
; MALE VOICE
idur           =         p3
ifq            =         p4

k1             oscil     2, 4, 1                       ; VIBRATO
k2             linseg    0, idur*.9, 0, idur*.1, 1     ; OCTAVIATION COEFFICIENT

; MALE EEE
imeef1         =         270
imeef2         =         2290
imeef3         =         3010

; MALE I
imif1          =         390
imif2          =         1990
imif3          =         2550

; MALE AHH
imahhf1        =         55
imahhf2        =         120
imahhf3        =         200

; CONSONANT
kmf1           linseg    1800, .2, imahhf1, p3, imeef1
kmf2           linseg    1800, .2, imahhf2, p3, imeef2
kmf3           linseg    1800, .2, imahhf3, p3, imeef3

;         xamp  xfund   xform kband kris kdur  kdec           ifna   idur
   a1 fof 10000, ifq+k1, kmf1, k2,   200, .003, .017, .005, 10, 1,19, idur, 0, 1
   a2 fof  6845, ifq+k1, kmf2, k2,   200, .003, .017, .005, 20, 1,19, idur, 0, 1
   a3 fof  1845, ifq+k1, kmf3, k2,   200, .003, .017, .005, 20, 1,19, idur, 0, 1

   asum        =         (a1 + a2 + a3) * p5 / 10
   aout        butterlp  asum, 200
   out         aout

endin


</CsInstruments>
<CsScore>
;***********************************************************************; ACCCI:     45_33_1.SC
; CODED:     JPG 3/94
; GEN FUNCTIONS **********************************************************
t 0 240
f1  0 4096  10 1
f19 0 1024  19 .5 .5 270 .5
; SCORE******************************************************************

;  istart idur ifq  ivol (1-10)
i1  0     4    55    5
i1  2     6    240    5
i1  8     8    174.6  5
i1  10    6    440    3
i1  16    8    132.8  4
i1  20    4    174.6  4
i1  24    2    196    3
i1  26    2    132.8  4

e

</CsScore>
</CsoundSynthesizer>
