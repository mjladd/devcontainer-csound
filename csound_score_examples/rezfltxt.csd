<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from rezfltxt.orc and rezfltxt.sco
; Original files preserved in same directory

sr             =         44100
kr             =         44100
ksmps          =         1
nchnls         =         1

; ************************************************************************
; RESONANT LOW-PASS FILTER INSTRUMENTS
;*************************************************************************
; 1. TABLE BASED REZZY SYNTH
; 2. TABLE BASED PWM REZZY SYNTH
; 3. TABLE BASED REZZY SYNTH WITH DISTORTION
; 4. NOISE BASED REZZY SYNTH
; 5. BUZZ  BASED REZZY SYNTH
; 6. FM BASED REZZY SYNTH
; 7. 4 POLE REZZY
; 8. 6 POLE FORMANT FILTER
; 9. MANDELBROTS SNOWFLAKE WAVEFORM WITH 4 POLE FILTER
;10. FLOWSNAKE WAVEFORM WITH 4 POLE FILTER
;*************************************************************************


;******************************************************************
instr 1   ; TABLE BASED REZZY SYNTH

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez      =         p7
itabl1    =         p8

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.02, 1, .01, 0

; FREQUENCY SWEEP
kfco      linseg    .1*p6, .5*p3, p6, .5*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; OSCILLATOR
  axn     oscil     iamp, ifqc, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)
  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;*************************************************************
instr 2   ; TABLE BASED PWM REZZY SYNTH

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez      =         p7
itabl1    =         p8

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.02, 1, .01, 0

; FREQUENCY SWEEP
kfco      linseg    .1*p6, .5*p3, p6, .5*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; PWM OSCILLATOR
  ksine   oscil     1.5,           ifqc/440,      1
  ksquare oscil     ifqc*ksine,    ifqc,          2
  axn     oscil     iamp,          ifqc+ksquare,  itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)
  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;******************************************************************
instr 3   ; TABLE BASED REZZY SYNTH WITH DISTORTION

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez      =         p7
itabl1    =         p8

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.02, 1, .01, 0

; FREQUENCY SWEEP
kfco      linseg    p6, .5*p3, .2*p6, .5*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; OSCILLATOR
  axn     oscil     iamp, ifqc, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)

  atemp   tone      axn, kfco
  aclip1  =         (ayn-atemp)/100000
  aclip   tablei    aclip1, 7, 1, .5
  aout    =         aclip*20000+atemp

  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  out     kaenv*aout

          endin

;************************************************
instr 4   ; NOISE BASED REZZY SYNTH

iamp      =         p4
irez      =         p6

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.02, 1, .01, 0

; FREQUENCY SWEEP
kfco      linseg    .1*p5, .5*p3, p5, .5*p3, .1*p5

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; NOISE SOURCE
  axn     rand      iamp

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)
  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;************************************************
instr 5   ; BUZZ BASED REZZY SYNTH

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez      =         p7
itabl1    =         p8

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.02, 1, .01, 0

; FREQUENCY SWEEP
kfco      linseg    .1*p6, .5*p3, p6, .5*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; BUZZ SOURCE
;               PITCH,  AMP, #PARTIALS, FUNCTION
  axn     buzz      iamp, ifqc,    itabl1,      1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)
  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

instr 6   ; FM BASED REZZY SYNTH

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez      =         p7
itabl1    =         p8

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.03, 1, .01, 0, .01, 0
kfmenv    linseg    .2, .2*p3, 2, .6*p3, .5, .2*p3, .2

; FREQUENCY SWEEP
kfco      linseg    .1*p6, .5*p3, p6, .5*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez/sqrt(kfco)-1
ka2       =         1000/kfco

; INITIALIZE YN-1 & YN-2 TO ZERO
aynm1     init      0
aynm2     init      0

; OSCILLATOR
  axn     foscil    iamp, ifqc, p9, p10, kfmenv, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn     =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2)
  aynm2   =         aynm1
  aynm1   =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;******************************************************************
instr 7   ; 4 POLE FILTER

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez1     =         p7
irez2     =         p9
itabl1    =         p10

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.03, 1, .01, 0, .01, 0

; FREQUENCY SWEEP
kfco1     linseg    .1*p6, .3*p3, p6, .7*p3, .1*p6
kfco2     linseg    .1*p8, .3*p3, p8, .7*p3, .1*p8

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez1/sqrt(kfco1)-1
ka2       =         1000/kfco1
kb1       =         100/irez2/sqrt(kfco2)-1
kb2       =         1000/kfco2

; INITIALIZE YN-1 TO YN-4 TO ZERO
ayn1m1    init      0
ayn1m2    init      0
ayn2m1    init      0
ayn2m2    init      0

; OSCILLATOR
  axn     oscil     iamp, ifqc, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn1    =         ((ka1+2*ka2)*ayn1m1-ka2*ayn1m2+axn)/(1+ka1+ka2)

  ayn1m2  =         ayn1m1
  ayn1m1  =         ayn1

  ayn     =         ((kb1+2*kb2)*ayn2m1-kb2*ayn2m2+ayn1)/(1+kb1+kb2)

  ayn2m2  =         ayn2m1
  ayn2m1  =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;******************************************************************
instr 8   ; 6 POLE FORMANT FILTER

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez1     =         p7
irez2     =         p9
irez3     =         p11
itabl1    =         p12

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.03, 1, .01, 0, .01, 0

; FREQUENCY SWEEP
kfco1     linseg    .1*p6,     .5*p3, p6,  .5*p3, .1*p6
kfco2     linseg    .1*p8,     .2*p3, p8,  .8*p3, .1*p8
kfco3     linseg    .1*p10, .8*p3, p10, .2*p3, .1*p10

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez1/sqrt(kfco1)-1
ka2       =         1000/kfco1
kb1       =         100/irez2/sqrt(kfco2)-1
kb2       =         1000/kfco2
kc1       =         100/irez3/sqrt(kfco3)-1
kc2       =         1000/kfco3

; INITIALIZE YN-1 TO YN-2 TO ZERO
ayn1m1    init      0
ayn1m2    init      0
ayn2m1    init      0
ayn2m2    init      0
ayn3m1    init      0
ayn3m2    init      0

; OSCILLATOR
  axn     oscil     iamp, ifqc, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn1    =         ((ka1+2*ka2)*ayn1m1-ka2*ayn1m2+axn)/(1+ka1+ka2)

  ayn1m2  =         ayn1m1
  ayn1m1  =         ayn1

  ayn2    =         ((kb1+2*kb2)*ayn2m1-kb2*ayn2m2+ayn1)/(1+kb1+kb2)

  ayn2m2  =         ayn2m1
  ayn2m1  =         ayn2

  ayn     =         ((kc1+2*kc2)*ayn3m1-kc2*ayn3m2+ayn2)/(1+kc1+kc2)

  ayn3m2  =         ayn3m1
  ayn3m1  =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;******************************************************************
instr 9   ; MANDELBROTS SNOWFLAKE 4 POLE FILTER

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez1     =         p7
irez2     =         p7
iamp2     =         p8
iamp3     =         p9

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.03, 1, .01, 0, .01, 0

; FREQUENCY SWEEP
kfcoe     expseg    .1*p6, .1*p3, p6, .9*p3, .01*p6
kfcoo     oscil     1,6,1

kfco1     =         kfcoe+(kfcoo+1)*kfcoe*.6
kfco2     =         kfco1

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez1/sqrt(kfco1)-1
ka2       =         1000/kfco1
kb1       =         100/irez2/sqrt(kfco2)-1
kb2       =         1000/kfco2

; INITIALIZE YN-1 TO YN-4 TO ZERO
ayn1m1    init      0
ayn1m2    init      0
ayn2m1    init      0
ayn2m2    init      0

; OSCILLATOR
  ax1     oscil     iamp,  ifqc, 6
  ax2     oscil     iamp2, ifqc*4, 6
  ax3     oscil     iamp3, ifqc/4, 6
  axn     =         ax1 + ax2 + ax3

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn1    =         ((ka1+2*ka2)*ayn1m1-ka2*ayn1m2+axn)/(1+ka1+ka2)

  ayn1m2  =         ayn1m1
  ayn1m1  =         ayn1

  ayn     =         ((kb1+2*kb2)*ayn2m1-kb2*ayn2m2+ayn1)/(1+kb1+kb2)

  ayn2m2  =         ayn2m1
  ayn2m1  =         ayn

; AMP ENVELOPE AND OUTPUT
  aout    =         ayn * kaenv
  out     aout

          endin

;******************************************************************
instr 10  ; FLOWSNAKE 4 POLE FILTER

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
irez1     =         p7
irez2     =         p7
iamp2     =         p8
iamp3     =         p9

; AMPLITUDE ENVELOPE
kaenv     linseg    0, .01, 1, p3-.03, 1, .01, 0, .01, 0

; FREQUENCY SWEEP
kfco1     linseg    .1*p6, .1*p3, p6, .9*p3, .1*p6
kfco2     linseg    .1*p6, .1*p3, p6, .9*p3, .1*p6

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1       =         100/irez1/sqrt(kfco1)-1
ka2       =         1000/kfco1
kb1       =         100/irez2/sqrt(kfco2)-1
kb2       =         1000/kfco2

; INITIALIZE YN-1 TO YN-4 TO ZERO
ayn1m1    init      0
ayn1m2    init      0
ayn2m1    init      0
ayn2m2    init      0

; OSCILLATOR
  ax1     oscil     iamp,  ifqc, 4
  ax2     oscil     iamp2, ifqc*2, 4
  ax3     oscil     iamp3, ifqc/2, 4
  axn     =         ax1 + ax2 + ax3

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  ayn1    =    ((ka1+2*ka2)*ayn1m1-ka2*ayn1m2+axn)/(1+ka1+ka2)

  ayn1m2  =    ayn1m1
  ayn1m1  =    ayn1

  ayn     =    ((kb1+2*kb2)*ayn2m1-kb2*ayn2m2+ayn1)/(1+kb1+kb2)

  ayn2m2  =    ayn2m1
  ayn2m1  =    ayn

; AMP ENVELOPE AND OUTPUT
  aout    =    ayn * kaenv
  out     aout

          endin

</CsInstruments>
<CsScore>
; ---------------------------------------------------------
; REZZY SYNTH
; CODED:  HANS MIKELSON 2/7/97
; ---------------------------------------------------------
; 1. TABLE BASED REZZY SYNTH
; 2. TABLE BASED PWM REZZY SYNTH
; 3. TABLE BASED REZZY SYNTH WITH DISTORTION
; 4. NOISE BASED REZZY SYNTH
; 5. BUZZ  BASED REZZY SYNTH
; 6. 4 POLE REZZY
;**********************************************************
; f1=SINE, f2=SQUARE, f3=SAWTOOTH, f4=TRIANGLE, f5=SQARE2
;**********************************************************
f1   0    1024   10   1
f2   0    256    7    -1      128  -1   0    1    128  1
f3   0    256    7    1       256  -1
f4   0    256    7    -1      128  1    128  -1
f5   0    256    7    1       64   1    0    -1   192  -1
f6   0    8192   7    0       2048 0    0    -1   2048 -1   0    1    2048          1  0  0 2048 0

; DISTORTION TABLE
f7   0    1024   8    -.8     42   -.78 400  -.7  140  .7   400  .78  42   .8

; SCORE ***************************************************

t    0    400

; PWM FILTER
;         DUR   AMP      PITCH     FILTER    CUT-OFF   RESONANCE      TABLE
i2        0     8        5000      8.05      100       20             2

; TABLE FILTER
;         DUR  AMP       PITCH     FILTER    CUT-OFF   RESONANCE      TABLE
i1        8    1         5000      8.02      90        30             3
i1        +    .         .         8.03      80        35             3
i1        .    .         .         8.00      70        40             3
i1        .    .         .         7.10      60        45             3

; DISTORTION FILTER
;         DUR  AMP       PITCH     FILTER    CUT-OFF   RESONANCE      TABLE
i3        12   1         5000      6.05      5         50             3
i3        +    .         <         6.02      <         .              3
i3        .    .         <         7.03      <         .              3
i3        .    .         <         6.05      <         .              3
i3        .    .         <         6.03      <         .              3
i3        .    .         <         6.03      <         .              3
i3        .    .         <         6.02      <         .              3
i3        .    .         8000      6.00      100       20             3

; FILTERED NOISE
i4        20   8         5000      100       100

; FILTERED BUZZ
i5        28   4         10000     8.03      100       20             10

; 4 POLE FILTER
;    START     DUR  AMP  PITCH     FCO1      REZ1      FCO2 REZ2  TABLE
i7   32        2    3000 8.00      70        20        50   10    3
i7   +         4    1800 8.03      60        22        60   12    2

</CsScore>
</CsoundSynthesizer>
