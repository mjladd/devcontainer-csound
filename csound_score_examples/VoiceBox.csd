<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from VoiceBox.orc and VoiceBox.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Random Vowel Reson Filter.

ilevl    = p4/550
irate    = p5
iseed    = p6

a0       soundin  "Sample1"

k1       randi  .5, irate, iseed
k1       = k1 + .5
k1f      table  k1, 11, 1
k2f      table  k1, 12, 1
k3f      table  k1, 13, 1
k4f      table  k1, 14, 1
k5f      table  k1, 15, 1
k1b      table  k1, 21, 1
k2b      table  k1, 22, 1
k3b      table  k1, 23, 1
k4b      table  k1, 24, 1
k5b      table  k1, 25, 1
a1       reson  a0, k1f, k1b
a2       reson  a0, k2f, k2b
a3       reson  a0, k3f, k3b
a4       reson  a0, k4f, k4b
a5       reson  a0, k5f, k5b
out      (a1 + a2 + a3 + a4 + a5)*ilevl

endin

</CsInstruments>
<CsScore>
;f11 0 1024 -7  600 256  400 256  250 256  400 256  350 ; Bass
;f12 0 1024 -7 1040 256 1620 256 1750 256  750 256  600
;f13 0 1024 -7 2250 256 2400 256 2600 256 2400 256 2400
;f14 0 1024 -7 2450 256 2800 256 3050 256 2600 256 2675
;f15 0 1024 -7 2750 256 3100 256 3340 256 2900 256 2950

;f21 0 1024 -7   60 256   40 256   60 256   40 256   40
;f22 0 1024 -7   70 256   80 256   90 256   80 256   80
;f23 0 1024 -7  110 256  100 256  100 256  100 256  100
;f24 0 1024 -7  120 256  120 256  120 256  120 256  120
;f25 0 1024 -7  130 256  120 256  120 256  120 256  120

f11 0 1024 -7  650 256  400 256  290 256  400 256  350 ; Tenor
f12 0 1024 -7 1080 256 1700 256 1870 256  800 256  600
f13 0 1024 -7 2650 256 2600 256 2800 256 2600 256 2700
f14 0 1024 -7 2900 256 3200 256 3250 256 2800 256 2900
f15 0 1024 -7 3250 256 3580 256 3540 256 3000 256 3300

f21 0 1024 -7   80 256   70 256   40 256   40 256   40
f22 0 1024 -7   90 256   80 256   90 256   80 256   60
f23 0 1024 -7  120 256  100 256  100 256  100 256  100
f24 0 1024 -7  130 256  120 256  120 256  120 256  120
f25 0 1024 -7  140 256  120 256  120 256  120 256  120

;   Strt  Leng  Levl  Rate  Seed
i1  0.00  1.47  0.80  2.75  0.88
e

</CsScore>
</CsoundSynthesizer>
