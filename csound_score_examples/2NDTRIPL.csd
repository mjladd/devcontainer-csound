<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 2NDTRIPL.ORC and 2NDTRIPL.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         44100
ksmps          =         1

;2NDTRIPLET.ORC
;FOR TEST OF SECOND TRIPLET (INSTR2, 12, 22)

;----------    INIT GLOBAL VARIABLES ---------
gkdur1         init      0    ;GRAIN CENTER DURATION
gkrdd1         init      0    ;GRAIN RANDOMIC DURATION RANGE
gkprt1         init      0    ;GRAIN RISE TIME
gkamp1         init      0    ;GLOBAL EVENT OVERALL AMPLITUDE
gkrd1          init      0    ;GRAIN RANDOMIC FREQUENCY RANGE
gkfreq1        init      0    ;GRAIN CENTER FREQUENCY
gkdel1         init      0    ;GRAIN CENTER DELAY
gkph1          init      0    ;FUNCTION TABLE INIT PHASE
gkran1         init      0    ;RANDOMIC FREQUENCY
gkrnd1         init      0    ;RANDOMIC DURATION
;---------------------------------------------------------------------------

instr          2              ;ACTUAL SOUND GENERATOR USING VALUES FROM INSTR 12

idur           =         p4/1000                  ;INIT DETERMINISTIC TRAPEZOID DURATION IN SECS
idel           =         p5/1000                  ;INIT TRAPEZOID DELAY IN SECS
irdd           =         p6/1000                  ;INIT RANDOMIC DURATION IN SECS
iprt           =         p7 + 0.1                 ;INIT RISE (DECAY) FACTOR ( PLUS A MAGIC.. )
ird            =         p8                       ;INIT RANDOM FREQUENCY DEVIATION
ifreq          =         p9                       ;INIT GRAIN CENTER FREQUENCY
iph            =         p10                      ;INIT TABLE PHASE
ifun           =         p11                      ;INIT AUDIO FUNCTION TABLE
irise          =         (idur + irdd)/iprt       ;    RISE TIME IS A FRACTION OF THE TRAPEZOID (FIG.1)
                                                  ;     DURATION.  EXAMPLE : IDUR = 40 MSEC
                                                  ;                    irdd = 5 msec
                                                  ;                      iprt = 4
                                                  ;                irise = (40 + 5 ) / 4 = 11.25 msec
isus           =         (idur + irdd) -( 2 * irise )       ;COMPUTE SUSTAIN TRAPEZOID TIME
gigrain        =         idur + irdd + idel                 ;COMPUTE TOTAL GRAIN DURATION
               goto      start                              ;JUMP TO SWITCH ON TIMER ACTIVITY
loop:
idur           =         i(gkdur1)                          ;THE ACTUAL IDUR VALUE IS "I-RATED" FROM THE FREE-
                                                            ;RUNNING FUNCTION GENERATOR THAT WORKS INSIDE AN
                                                            ;INDIPENDENT INSTRUMENT (INSTR 11 FOR INSTR 1) AND
idur           =         idur/1000                          ;CONVERTED FROM MSEC INTO SECS.
irdd           =         i(gkrnd1)                          ;THE SAME FOR IRDD
irdd           =         irdd/1000
idel           =         i(gkdel1)                          ;THE SAME FOR IDEL
idel           =         idel/1000
iprt           =         i(gkprt1)+0.1                      ;THE SAME FOR IPRT
ird            =         i(gkran1)                          ;THE SAME FOR IRD
ifreq          =         i(gkfreq1)                         ;THE SAME FOR IFREQ
iph            =         i(gkph1)                           ;THE SAME FOR IPH
     irise     =         (idur + irdd)/iprt
     isus      =         idur + irdd - (2 * irise)
     gigrain   =         idur + irdd + idel
               ;print    icount,gigrain,idur,irdd,idel      ;PRINT VALUES IF YOU WANT...

;++++++++++++ TIMER SECTION
start:         timout    0,gigrain,cont                     ;IF TIMER VALUE IS NOT ZERO
               ;goto     cont
               reinit    loop                               ;ELSE JUMP TO A REINIT SECTION
cont:     k1   linseg    0,irise,1,isus,1,irise,0,idel,0    ;GENERATE LINEAR GRAIN
                                                            ;ENVELOPE (SCALED TO 1 )
        k2     tablei    1023*k1,19                         ;SMOOTH ENVELOPE
     ga1       oscil     k2,ird + ifreq,ifun,iph            ;GENERATE SOUND
endin

instr          12                                           ;CONTROL FUNCTION GENERATOR
gkdur1         oscil1    0,1,p3,p4                          ;CONTROL FUNCTION GENERATOR FOR IDUR
gkdel1         oscil1    0,1,p3,p5                          ;                   idel
gkrdd1         oscil1    0,1,p3,p6                          ;                   irdd
gkprt1         oscil1    0,1,p3,p7                          ;                   iprt
gkrd1          oscil1    0,1,p3,p8                          ;                   ird
gkfreq1        oscil1    0,1,p3,p9                          ;                   ifreq
gkph1          oscil1    0,1,p3,p10                         ;                   iph
gkamp1         oscil1    0,1,p3,p11                         ;                   iamp
gkran1         rand      gkrd1/2                            ;FREQUENCY RANDOM GENERATOR
gkrnd1         rand      gkrdd1/2                           ;DURATION RANDOM GENERATOR
endin

instr          22                                           ;MIX-DELAY-RESCALE-OUT
iscale         =         p4                                 ;READ AMPLITUDE SCALE FACTOR
a1             =         ga1
a2             delay     a1, 0.003                          ;3ms DELAY --
a3             delay     a1, 0.007                          ;7ms      |
a4             delay     a1, 0.011                          ;11ms        |
a5             delay     a1, 0.015                          ;15ms         > ADJUST VALUES....
a6             delay     a1, 0.017                          ;17ms        |
a7             delay     a1, 0.023                          ;23ms        |
a8             delay     a1, 0.025                          ;25ms      --
as1            =         (a1+a2+a3+a4)/4                    ;PREMIX AND RESCALE FIRST FOUR PSEUDO VOICES
as2            =         (a5+a6+a7+a8)/4                    ;PREMIX AND RESCALE LAST  FOUR PSEUDO VOICES
               out       ( as1+as2 ) * iscale * gkamp1      ;MIXDOWN, FINAL RESCALE ,OVERALL ADJUST
                                                            ;AND OUTPUT SOUND SAMPLES.
               ;out      a1 * iscale *  gkamp1
endin

</CsInstruments>
<CsScore>
;2NDTRIPLET.SCO
;FOR TESTING SECOND TRIPLET (INSTR2, 12, 22)

;=====================================================================
;CONTROL FUNCTIONS
;DURATION (THE LARGER, THE MORE SPARSE, E.G. >50 MSEC.)
;f11 0 512 -7 20 256 50  256 20                   ;[see p4 of instr1]
f21 0 512 -7 10 256 100 256 10
;DELAY (THE SMALLER, THE MORE FUSED, DETACHED WHEN >50 MSEC.)
;f12 0 512 -7 10  256 10 256 10                   ;[see p5]
f22 0 512 -7 50 256 10 256 50
;*******************
;DURATION DEVIATION (DURATIONAL IRREGULARITY)
;f13 0 512 -7 10 512 5                            ;[see p6]
;f13 0 512 -7 20 512 1
;FINIT ERROR IN INSTR1 WHEN 100 IN P6: NEGATIVE TIME PERIOD, BUT SOUNDS O.K.
;f13 0 512 -7 100 256 1 256 100
;ERROR MESSAGES WHEN 200 IN P6, MUST BE INIT VALUE = 100
;f13 0 512 -7 100 256 200 50
f23 0 512 -7 50 512 1
;********************
;RISE TIME
f24 0 512 -7 2  512 2                             ;[SEE P7]
;FREQUENCY
;f15 0 512 -7 50  256 100 256 150                 ;[see p8]
f25 0 512 -7 30 256 300 256 50 ;p8=30
;FREQUENCY DEVIATION
;f16 0 512 -7 100 256 200 256 400                 ;[see p9]
f26 0 512 -7 50 100 100 412 400                   ;QUICKLY TO 100 HZ, THEN MORE SLOWLY TO 400 HZ
;PHASE
f27 0 512 -7 0 512 0                              ;[see p10]
;GLOBAL ENVELOPE
f28 0 512 7 0   64  1  384  1  64 0               ;[see p11]
;SMOOTHING FUNCTION ;SAME FUNCTION AS IN TRIPLET #1
;WHEN THIS FUNCTION IS ADJUSTED TO 29, 39, CHANGE TABLEI IN THE ORCHESTRA
f19 0 1025 8  0 256 0.1 256 0.5 256 0.9 257 1

;WAVEFORMS DETERMINE SOUND COLOR!
;f1 0 1024  10 1                                  ;the usual
f2 0 1024 10 1 .5 .3 .1                           ;"sine2". a little dull
;f1 0 1024 10 0 .01 1 0 5 0                       ;"sine3", [strong 3rd & 5th partial], silvery
;f1 0 1024 9 .25 1 90                             ;cosine, interesting dense sound

;SCORE PROPER

;p1 p2  p3   p4     p5     p6     p7     p8     p9     p10    p11
;         dur    del    rndd   prt    rndf   freq   phas   ifun
;i2  0   1    50    10     10      2     50    100     0      1
i2  0    3   100    50     50      2     30     50     0      2
;---------------------------------------------------------------------
;         dur_f  del_f  rndd_f prt_f    rndf_f    freq_f phas_f amp_f
i12 0   3    21     22     23     24    25      26     27     28
;---------------------------------------------------------------------
;AMPSCALE FOR SINE
i22 0   3    24000
;FOR COSINE
;i22 0 3 16000
e

</CsScore>
</CsoundSynthesizer>
