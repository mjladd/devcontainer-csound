<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from TUBEAMP3.ORC and TUBEAMP3.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         22050
ksmps          =         2
nchnls         =         1


gasig          init      0

; SIMPLE SIN
instr          1

  iamp         init      p4
  ifqc         init      p5
  kamp         linseg    0, .01, p4, p3-.02, p4, .01, 0

  asin1        oscil     kamp, ifqc, 1
;              out       asin1
  gasig        =         gasig + asin1

endin

; PLUCK
instr          2

  ifqc         =         cpspch(p5)
  kamp         linseg    0, .01, p4, p3-.02, p4/2, .01, 0

  asin1        pluck     kamp, ifqc, ifqc, p6, p7
  asig1        butterhp  asin1, 10
  asig         butterlp  asig1, 5000
;  out         asig
  gasig        =         gasig + asig

endin

; TUBE AMP
instr          10

asig           init      0
kamp           linseg    0, .002, 1, p3-.004, 1, .002, 0
igaini         =         p4
igainf         =         p5
iduty          =         p6
islope         =         p7

aold           =         asig
asig           =         igaini*gasig/40000       ; DISTORTION EFFECT USING WAVESHAPING.
aclip          tablei    asig,5,1,.5              ; A LAZY "S" CURVE, USE TABLE 6 FOR INCREASED
;aclip         =         asig
aclip          =         igainf*aclip*10000       ; DISTORTION.

; TUBE AMPLIFIERS SHOW A SHIFTED DUTY CYCLE WHICH I TRY TO EMULATE WITH
; A DELAY LINE.  THE SLOPE BIT IS JUST SOMETHING GOOFY I THOUGHT I WOULD ADD.
atemp          delayr    .1
adel1          deltapi   (1-iduty*asig)/1500 + (1+islope*(asig-aold))/1500
               delayw    aclip

               out       adel1*kamp

  gasig        =         0

endin


</CsInstruments>
<CsScore>
; AN ATTEMPT AT EMULATING TUBE DISTORTION.

; SINE WAVE
f1 0 8192 10 1
; TRIANGLE WAVE
f2 0 8192 7  -1  256 1 256 -1 512 0 7168 0
; EXP WAVE
f3 0 8192 7  .001  4096 1 4096 .001

; DISTORTION TABLES
;----------------------------------------------------------------------
; HEAVY DISTORTION
;f5 0 8192   8 -.8 336 -.76 3000 -.7 1520 .7 3000 .76 336 .8
; SLIGHT DISTORTION
;f5 0 8192   8 -.8 336 -.78  800 -.7 5920 .7  800 .78 336 .8
; TUBE DISTORTION
; LIGHT
;f5 0 8192 7 -.8 834 -.79 834 -.77 834 -.64 834 -.48 1520 .47 2000 .48 1336 .48
; HEAVY
f5 0 8192 7 -.8 934 -.79 934 -.77 934 -.64 1034 -.48 520 .47 2300 .48 1536 .48

;   Sta  Dur  Amp    Fqc
;i1  0    .4   5000   1000
;i1  .2   .2   5000   1500

; TUBE AMP
;   Sta  Dur  PreGain PostGain  DutyOffset  SlopeShift
i10 0    3.2  2       2         2           10



; PLUCK USE FUNC 2 FOR DISTORTION
;   Sta  Dur  Amp   Fqc   Func  Meth
i2  0.0  1.6  8000  7.00   0     1
i2  0.2  1.4  6000  7.05   .     .
i2  0.4  1.2  5200  8.00   .     .
i2  0.6  1.0  6000  8.05   .     .
i2  0.8  0.8  8000  7.00   .     .
i2  1.0  0.6  6000  7.05   .     .
i2  1.2  0.4  5200  8.00   .     .
i2  1.4  0.2  6000  8.05   .     .

i2  1.6  0.8  8000  9.00   .     .
i2  2.4  0.8  8000  8.10   .     .

;i2  1.6  1.6  2200  8.07   .     .
;i2  1.8  1.4  6000  8.05   .     .
;i2  2.0  1.2  4000  8.00   .     .
;i2  2.2  1.0  3000  7.05   .     .
;i2  2.4  0.8  2200  8.07   .     .
;i2  2.6  0.6  6000  8.05   .     .
;i2  2.8  0.4  4000  8.00   .     .
;i2  3.0  0.2  3000  7.05   .     .

;i2  3.2  1.6  2500  7.00   .     .
;i2  3.21 1.8  3000  7.05   .     .

;i2  1.8  1.6  2600  8.00   .     .
;i2  1.8  1.6  3000  8.05   .     .
;i2  2.0  1.4  2200  8.07   .     .
;i2  2.2  2    6000  8.05   .     .
;i2  2.4  1.8  4000  8.00   .     .
;i2  2.6  1.6  3000  7.05   .     .
;i2  2.8  1.4  2500  7.00   .     .

;i2  3.0  1.8  3000  7.05   .     .
;i2  3.2  1.6  2600  8.00   .     .
;i2  3.4  1.6  3000  8.05   .     .
;i2  3.6  1.4  2200  8.07   .     .
;i2  3.8  2    6000  8.05   .     .
;i2  4.0  1.8  4000  8.00   .     .
;i2  4.2  1.6  3000  7.05   .     .
;i2  4.4  1.4  2500  7.00   .     .

; PLUCK
;   Sta  Dur  Amp   Fqc   Func  Meth
;i2  4.0  2    4000  250   2     1
;i2  4.2  1.8  3000  375   .     1
;i2  4.4  1.6  2600  500   .     1
;i2  4.6  1.4  2200  1000  .     1
;i2  6    2    6000  250   .     1
;i2  6.05 1.95 4000  375   .     1
;i2  6.1  1.9  3000  500   .     1
;i2  6.15 1.85 2500  1000  .     1

; PLUCK
;   Sta   Dur  Amp   Fqc   Func  Meth
;i2  8.0   2    2000  250   2     1
;i2  8.2   1.8  1500  375   .     1
;i2  8.4   1.6  1300  500   .     1
;i2  8.6   1.4  1100  1000  .     1
;i2  10    2    3000  250   .     1
;i2  10.05 1.95 2000  375   .     1
;i2  10.1  1.9  1500  500   .     1
;i2  10.15 1.85 1250  1000  .     1


</CsScore>
</CsoundSynthesizer>
