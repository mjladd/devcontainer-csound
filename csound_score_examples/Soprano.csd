<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Soprano.orc and Soprano.sco
; Original files preserved in same directory

sr     = 44100
kr     = 2205
ksmps  = 20
nchnls = 1


instr    1 ; Soprano Mk 1.

ileng    = abs(p3)
ilevl    = p4*.4
inote    = cpspch(p5)
ivowl1   = p6/4 + 1
ivowl2   = p7/4 + 1
ivibdel  = p8
iport    = p9
iseed    = frac(p2 + .123/inote)
iviblev  = inote/50 + 9

istied   tival

tigoto   tieinit
ibegp    = inote
iprev    = inote
goto     cont

tieinit:
ibegp    = iprev
iprev    = inote
cont:

kpitch   linseg  ibegp, iport, inote, ileng, inote       ; Pitch Env

ibegl     = (istied == 1 ? 1 : 0)
iendl     = (p3 < 0 ? 1 : 0)

kenv     linseg  ibegl, .25, 1, ileng-.5, 1, .25, iendl  ; Legato Amp Env

kn1      randi  25, 5, iseed ; 25% Vibrato Depth Randomiser
kn1      = (kn1 + 100)/100
kn2      randi  10, 7, iseed ; 10% Vibrato Rate Randomiser
kn2      = (kn2 + 100)/100
kn3      randi .25, 8, iseed ; 1/4% Pitch Randomiser
kn3      = (kn3 + 100)/100

k0       linseg  1, ileng-.25, 1, .25, 1.5               ; Vibrato Rate
k1       linseg  0, ivibdel, 1, ileng-ivibdel, 1         ; Vibrato Delay
k1       oscil  iviblev*kn1*k1*k0, 6*kn2*k0, 3           ; Vibrato LFO
;kenv     linseg  0, .25, 1, ileng-.35, 1, .1, 0         ; Non Legato Amp Env

kpitch   = kpitch*kn3 + k1

kn5      randi  40, 2
kn6      randi  50, 3.4
kn7      randi  60, 4.3
kn8      randi  70, 5.2
kn9      randi  80, 6.1

i1f1     table  ivowl1, 11, 1
i2f1     table  ivowl1, 12, 1
i3f1     table  ivowl1, 13, 1
i4f1     table  ivowl1, 14, 1
i5f1     table  ivowl1, 15, 1

i1f2     table  ivowl2, 11, 1
i2f2     table  ivowl2, 12, 1
i3f2     table  ivowl2, 13, 1
i4f2     table  ivowl2, 14, 1
i5f2     table  ivowl2, 15, 1

k1f      line  i1f1, ileng, i1f2
k2f      line  i2f1, ileng, i2f2
k3f      line  i3f1, ileng, i3f2
k4f      line  i4f1, ileng, i4f2
k5f      line  i5f1, ileng, i5f2

i1b1     table  ivowl1, 21, 1
i2b1     table  ivowl1, 22, 1
i3b1     table  ivowl1, 23, 1
i4b1     table  ivowl1, 24, 1
i5b1     table  ivowl1, 25, 1

i1b2     table  ivowl2, 21, 1
i2b2     table  ivowl2, 22, 1
i3b2     table  ivowl2, 23, 1
i4b2     table  ivowl2, 24, 1
i5b2     table  ivowl2, 25, 1

k1b      line  i1b1, ileng, i1b2
k2b      line  i2b1, ileng, i2b2
k3b      line  i3b1, ileng, i3b2
k4b      line  i4b1, ileng, i4b2
k5b      line  i5b1, ileng, i5b2

i2l1     table  ivowl1, 32, 1
i3l1     table  ivowl1, 33, 1
i4l1     table  ivowl1, 34, 1
i5l1     table  ivowl1, 35, 1

i2l2     table  ivowl2, 32, 1
i3l2     table  ivowl2, 33, 1
i4l2     table  ivowl2, 34, 1
i5l2     table  ivowl2, 35, 1

k2l      line  i2l1, ileng, i2l2
k3l      line  i3l1, ileng, i3l2
k4l      line  i4l1, ileng, i4l2
k5l      line  i5l1, ileng, i5l2

k1l      = 32000
k2l      = ampdb(90 - k2l)
k3l      = ampdb(90 - k3l)
k4l      = ampdb(90 - k4l)
k5l      = ampdb(90 - k5l)

a1       fof  k1l, kpitch, k1f + kn5, 0, k1b, .003, .02, .007, 1000, 1, 2, ileng
a2       fof  k2l, kpitch, k2f + kn6, 0, k2b, .003, .02, .007, 1000, 1, 2, ileng
a3       fof  k3l, kpitch, k3f + kn7, 0, k3b, .003, .02, .007, 1000, 1, 2, ileng
a4       fof  k4l, kpitch, k4f + kn8, 0, k4b, .003, .02, .007, 1000, 1, 2, ileng
a5       fof  k5l, kpitch, k5f + kn9, 0, k5b, .003, .02, .007, 1000, 1, 2, ileng

out      (a1 + a2 + a3 + a4 + a5)*kenv

endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1 ; Sine
f2 0 1024 19 .5 .5 270 .5 ; 1/4 Sine for FOF
f3 0 4096 10 8 1 .5 ; Distorted Sine for Vibrato

;f11 0 1024 -7  600 256  400 256  250 256  400 256  350 ; Bass Frequencies
;f12 0 1024 -7 1040 256 1620 256 1750 256  750 256  600
;f13 0 1024 -7 2250 256 2400 256 2600 256 2400 256 2400
;f14 0 1024 -7 2450 256 2800 256 3050 256 2600 256 2675
;f15 0 1024 -7 2750 256 3100 256 3340 256 2900 256 2950

;f21 0 1024 -7   60 256   40 256   60 256   40 256   40 ; Bass Bandwidths
;f22 0 1024 -7   70 256   80 256   90 256   80 256   80
;f23 0 1024 -7  110 256  100 256  100 256  100 256  100
;f24 0 1024 -7  120 256  120 256  120 256  120 256  120
;f25 0 1024 -7  130 256  120 256  120 256  120 256  120

;f31 0 1024 -7    0 256    0 256    0 256    0 256    0 ; Bass Levels (dB)
;f32 0 1024 -7   20 256   11 256   30 256   12 256    7
;f33 0 1024 -7   32 256   21 256   16 256    9 256    9
;f34 0 1024 -7   28 256   20 256   22 256   12 256    9
;f35 0 1024 -7   36 256   40 256   28 256   18 256   36

;f11 0 1024 -7  650 256  400 256  290 256  400 256  350 ; Tenor Frequencies
;f12 0 1024 -7 1080 256 1700 256 1870 256  800 256  600
;f13 0 1024 -7 2650 256 2600 256 2800 256 2600 256 2700
;f14 0 1024 -7 2900 256 3200 256 3250 256 2800 256 2900
;f15 0 1024 -7 3250 256 3580 256 3540 256 3000 256 3300

;f21 0 1024 -7   80 256   70 256   40 256   40 256   40 ; Tenor Bandwidths
;f22 0 1024 -7   90 256   80 256   90 256   80 256   60
;f23 0 1024 -7  120 256  100 256  100 256  100 256  100
;f24 0 1024 -7  130 256  120 256  120 256  120 256  120
;f25 0 1024 -7  140 256  120 256  120 256  120 256  120

;f31 0 1024 -7    0 256    0 256    0 256    0 256    0 ; Tenor Levels (dB)
;f32 0 1024 -7    6 256   14 256   15 256   10 256   20
;f33 0 1024 -7    7 256   12 256   18 256   12 256   17
;f34 0 1024 -7    8 256   14 256   20 256   12 256   14
;f35 0 1024 -7   22 256   20 256   30 256   26 256   26

;f11 0 1024 -7  800 256  400 256  350 256  450 256  325 ; Contralto Frequencies
;f12 0 1024 -7 1150 256 1600 256 1700 256  800 256  700
;f13 0 1024 -7 2800 256 2700 256 2700 256 2830 256 2530
;f14 0 1024 -7 3500 256 3300 256 3700 256 3500 256 3500
;f15 0 1024 -7 4950 256 4950 256 4950 256 4950 256 4950

;f21 0 1024 -7   80 256   60 256   50 256   70 256   50 ; Contralto Bandwidths
;f22 0 1024 -7   90 256   80 256  100 256   80 256   60
;f23 0 1024 -7  120 256  120 256  120 256  100 256  170
;f24 0 1024 -7  130 256  150 256  150 256  130 256  180
;f25 0 1024 -7  140 256  200 256  200 256  135 256  200

;f31 0 1024 -7    0 256    0 256    0 256    0 256    0 ; Contralto Levels (dB)
;f32 0 1024 -7    4 256   24 256   20 256    9 256   12
;f33 0 1024 -7   20 256   30 256   30 256   16 256   30
;f34 0 1024 -7   36 256   35 256   36 256   28 256   40
;f35 0 1024 -7   60 256   60 256   60 256   55 256   64

f11 0 1024 -7  800 256  350 256  270 256  450 256  325 ; Soprano Frequencies
f12 0 1024 -7 1150 256 2000 256 2140 256  800 256  700
f13 0 1024 -7 2900 256 2800 256 2950 256 2830 256 2700
f14 0 1024 -7 3900 256 2600 256 3900 256 3800 256 3800
f15 0 1024 -7 4950 256 4950 256 4950 256 4950 256 4950

f21 0 1024 -7   80 256   60 256   60 256   70 256   50 ; Soprano Bandwidths
f22 0 1024 -7   90 256  100 256   90 256   80 256   60
f23 0 1024 -7  120 256  120 256  100 256  100 256  170
f24 0 1024 -7  130 256  150 256  120 256  130 256  180
f25 0 1024 -7  140 256  200 256  120 256  135 256  200

f32 0 1024 -7    6 256   20 256   12 256   11 256   16 ; Soprano Levels (dB)
f33 0 1024 -7   32 256   15 256   26 256   22 256   35
f34 0 1024 -7   20 256   40 256   26 256   22 256   40
f35 0 1024 -7   50 256   56 256   44 256   50 256   60

;1=A 2=E 3=I 4=O 5=U

;     Strt  Leng  Levl  Pitch Vowl1 Vowl2 Delay Glide
i1    0.00 -0.50  1.00  09.00 2.00  1.00  2.00  0.25
i1    +    -1.50  .     09.05 1.00  0.75  .     .
i1    +    -0.25  .     09.03 0.75  1.00  .     0.125
i1    +     0.25  .     09.05 1.00  1.00  .     .
e

</CsScore>
</CsoundSynthesizer>
