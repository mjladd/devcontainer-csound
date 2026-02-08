<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tb305.orc and tb305.sco
; Original files preserved in same directory

sr             =         44100
kr             =         44100
ksmps          =         1
nchnls         =         2

;
;-------------------------------------------------------------------------
; TB WANNABE
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------

instr          15        ; TABLE BASED REZZY SYNTH WITH ENVELOPED RESONANCE
;-------------------------------------------------------------------------
; A WHOLE BUNCH OF INITIALIZATIONS.
;-------------------------------------------------------------------------

inumsteps      =         16
idur           =         p3
iamp           =         p4
itabl1         =         p5
iaccent        =         p6
ienvdepth      =         p7
ifdecay        =         p8
iadecay        =         p9
kvalley        init      0
kpeak          init      0
knewval        init      1
knewpk         init      1
ksaveval       init      0
ksavepk        init      0
kynm1          init      0
kynm2          init      0
ktynm1         init      0
ktynm2         init      0
kfrangenm1     init      0
kfrangenm2     init      0
knewrez        init      0
kfsweep        init      30
kstep          init      0
knxtstp        init      1

; LFO FREQUENCY SWEEP
;-------------------------------------------------------------------------
  kfsweep      oscil     1, 1/idur, 30
  krez         oscil     1, 1/idur, 31

; SEQUENCER SECTION
;-------------------------------------------------------------------------
  loop1:
;     READ THE DURATION FOR THE CURRENT STEP OF THE SEQUENCE.
      kdur          table     kstep, 21
      kdur1         =         kdur/6                   ; MAKE THE STEP SMALLER.

;     FREQUENCY ENVELOPE
      kfco          expseg    (1-ienvdepth)*i(kfsweep)+10, .01, i(kfsweep), ifdecay, (1-ienvdepth)*i(kfsweep)+10

;     AMPLITUDE ENVELOPE
      kaenv         expseg    .00001, .01, 1, i(kdur1)-.02, iadecay, .01, .00001

;     PANNING
      kpanleft      table     kstep, 22
      kpanright     table     kstep, 23

;     PITCH FOR THE STEP OF THE SEQUENCE.
      kpch1         table     kstep, 20
      kfqc1         =         cpspch(kpch1)

;     PITCH FOR THE NEXT STEP NEED FOR SLIDING TO THE NEXT STEP.
      kpch2         table     knxtstp, 20
      kfqc2         =         cpspch(kpch2)

;     IF THE SLIDE IS TURNED ON THEN SLIDE UP TO THE NEXT STEP OTHERWISE
;     DONT.
      kslide        table     knxtstp, 24

      if  (i(kslide) = 0)     goto skipslide
        kfqc        linseg    i(kfqc1), i(kdur1)-.06, i(kfqc1), .06, i(kfqc2)
        goto        nxtslide
      skipslide:
        kfqc        =         kfqc1
      nxtslide:

;     WHEN THE TIME RUNS OUT GO TO THE NEXT STEP OF THE SEQUENCE AND
;     REINITIALIZE THE ENVELOPES.
                    timout    0, i(kdur1), cont1
        kstep       =         frac((kstep + 1)/inumsteps)*inumsteps
        knxtstp     =         frac((kstep + 1)/inumsteps)*inumsteps

        reinit      loop1
  cont1:

; START WITH MY LOW PASS RESONANT FILTER.

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ. FROM RES.
    ka1             =         100/krez/sqrt(kfco)-1
    kta1            =         100/sqrt(kfco)-1
    ka2             =         1000/kfco

; OSCILLATOR
  kxn               oscil     iamp, kfqc, itabl1

; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
  kyn               =         ((ka1+2*ka2)*kynm1-ka2*kynm2+kxn)/(1+ka1+ka2)
  ktyn              =         ((kta1+2*ka2)*ktynm1-ka2*ktynm2+kxn)/(1+kta1+ka2)

; EXTRACT THE RESONANCE FROM THE FILTERED SIGNAL.
  koldrez           =         knewrez
  knewrez           =         kyn-ktyn

; THIS SECTION DETERMINES CURRENT PEAK AND VALLEY VALUES AND THE RANGE.
; AS LONG AS THE SIGNAL RISES IT TRACKS PEAK.  WHEN IT FALLS IT UPDATES
; PEAK AND TRACKS VALLEY.

  if      (koldrez>=knewrez)  goto next1
    if    (knewval != 1)      goto next2
      knewval       =         0
      knewpk        =         1
      kvalley       =         ksaveval
next2:
    ksavepk         =         knewrez

next1:
  if      (koldrez<=knewrez)  goto next 3
    if    (knewpk != 1)       goto next4
      knewpk        =         0
      knewval       =         1
      kpeak         =         ksavepk
next4:
    ksaveval        =         knewrez

next3:
; THE CURRENT RANGE IS CALCULATED AND LOW PASS FILTERED.
  krangen           =         abs(kpeak-kvalley)
  kfrangen          =         ((kta1+2*ka2)*kfrangenm1-ka2*kfrangenm2+krangen)/(1+kta1+ka2)

; THE FILTERED RANGE IS USED TO ENVELOPE THE RESONANCE THEN DISTORTION IS
;ADDED.
  kclip1            =         knewrez*kfrangen/krez/120000000
  kclip             tablei    kclip1, 7, 1, .5
  kout              =         ktyn + kclip*40000

; UPDATE EVERYTHING FOR THE NEXT PASS.
  kynm2             =         kynm1
  kynm1             =         kyn
  ktynm2            =         ktynm1
  ktynm1            =         ktyn
  kfrangenm2        =         kfrangenm1
  kfrangenm1        =         kfrangen

; CONVERT TO AUDIO RATES
  aout              =         kout

; AMP ENVELOPE, PAN AND OUTPUT
                    outs      kaenv*kpanleft*aout, kaenv*kpanright*aout

endin

</CsInstruments>
<CsScore>
; INSTRUMENT IN THE STYLE OF THE TB303 WITH BUILT IN SEQUENCER.

f10 0  1024   8  1  256 .2  128 0 256 -.2 256  -1

; DISTORTION TABLE
;----------------------------------------------------------------------
f7 0 1024   8 -.8 42 -.78  200 -.74 200 -.7 140 .7  200 .74 200 .78 42 .8

; 16 STEP SEQUENCER
;----------------------------------------------------------------------
; STEP          1     2     3     4     5     6     7     8     9     10    11    12    13    14    15    16
; PITCH TABLE
f20  0  16  -2  7.00  7.00  7.00  7.00  7.05  7.00  7.00  7.00  7.05  6.00  7.07  7.00  7.05  7.00  7.00  7.00
f20  4   8  -2  7.00  6.00  7.00  6.00  6.05  6.00  6.05  6.00  6.10  6.07  6.05  6.03  6.02  6.00  7.00  7.00

; DUR TABLE
f21  0 16  -2   .5    .5    .5    1     .5    1     1     .5    1     1     .5    .5    .5    .5    1     .5
f21  4 16  -2   .5    .5    .5    .5    .5    .5    1     .5    .5    .5    .5    .5    .5    1.5   1     2

; PANNING AMPLITUDE TABLE  22=LEFT 23=RIGHT
f22  0 16  -2   1     0     1     1     0     0     1     1    1     0     1     1     1     0     1     1
f23  0 16  -2   0     1     1     0     0     1     1     0    0     1     1     0     1     1     1     0

; SLIDE TABLE
f24  0  8  -2   0     0     0     1     0     0     0     1    0     0     0     0     1     0     0     0

; FREQUENCY SWEEP TABLE USED TO SIMULATE "REAL TIME" TWISTING OF THE KNOB.
f30  0  256  -7  50 128 2000 128 50
f30  1  256  -7  100 64 500 64 50 64 200 64 1000

; RESONANCE SWEEP TABLE USED TO SIMULATE "REAL TIME" TWISTING OF THE KNOB.
f31  0  256  -7  40 128 80 128 40

; SCORE
;----------------------------------------------------------------------
; ENVELOPED DISTORTION FILTER
;        Dur  Amp   Wave  Accent  EnvDepth  FreqDecay  AmpDecay
i15  0   4    6000  10    0       1         .1         .5
i15  +   4    6000  10    0       .99       .2         .2

</CsScore>
</CsoundSynthesizer>
