<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tubedistort.orc and tubedistort.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

; ORCHESTRA BEGINS HERE.


gasig          init      0

; PLUCK
instr          2

  iamp         =         p4*4
  ifqc         =         cpspch(p5)
  kamp         linseg    0, .002, p4, p3-.004, p4, .002, 0

  asin1        pluck     kamp, ifqc, ifqc, p6, p7
  gasig        =         gasig + asin1

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
asig           =         igaini*gasig/40000
; DISTORTION EFFECT USING WAVESHAPING.
aclip          tablei    asig,5,1,.5
; A LAZY "S" CURVE, USE TABLE 6 FOR INCREASED DISTORTION.
aclip          =         igainf*aclip*10000

; TUBE AMPLIFIERS SHOW A SHIFTED DUTY CYCLE WHICH I TRY TO EMULATE WITH
; A DELAY LINE.  THE SLOPE BIT IS JUST SOMETHING GOOFY I THOUGHT I WOULD ADD.
atemp          delayr    .1
adel1          deltapi   (1-iduty*asig)/3000 + (1+islope*(asig-aold))/3000
               delayw    aclip

               out       adel1*kamp

  gasig        =         0

endin

</CsInstruments>
<CsScore>
; SINE WAVE
f1 0 8192 10 1
; TRIANGLE WAVE
f2 0 8192 7  -1  4096 1 4096 -1

; DISTORTION TABLES
;----------------------------------------------------------------------
; HEAVY DISTORTION
;f5 0 8192   8 -.8 336 -.76 3000 -.7 1520 .7 3000 .76 336 .8
; SLIGHT DISTORTION
;f5 0 8192   8 -.8 336 -.78  800 -.7 5920 .7  800 .78 336 .8
; TUBE DISTORTION
; LIGHT
f5 0 8192 7 -.8 834 -.79 834 -.77 834 -.64 834 -.48 1520 .47 2000 .48 1336 .48
; HEAVY
;f5 0 8192 7 -.8 934 -.79 934 -.77 934 -.64 1034 -.48 520 .47 2300 .48 1536 .48

; TUBE AMP
;   Sta  Dur  PreGain PostGain  DutyOffset  SlopeShift
i10 0    1.5  2       1         1           0

; PLUCK
;   Sta  Dur  Amp   Fqc   Func  Meth
i2  0.0  1.6  4000  7.00   0     1
i2  0.2  1.4  3000  7.05   .     .
i2  0.4  1.2  2600  8.00   .     .
i2  0.6  1.0  3000  8.05   .     .
i2  0.8  0.8  4000  7.00   0     1
i2  1.0  0.6  3000  7.05   .     .
i2  1.2  0.4  2600  8.00   .     .
i2  1.4  0.2  3000  8.05   .     .

</CsScore>
</CsoundSynthesizer>
