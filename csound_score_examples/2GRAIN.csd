<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 2GRAIN.ORC and 2GRAIN.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         44100
ksmps          =         1

;2GRAIN.ORC
;ORCH FOR 2 TRULY INDEPENDENT VOICES OF GRANULAR SYNTHESIS (1-2, 11-12, 21-22)
;MONO
;NOTE: .ORC DOES NOT NEED TO BE CHANGED, EXCEPT IF SMOOTHING FUNCTION
;      F19 DIFFERS BETWEEN INSTRUMENTS [SEE END OF INSTR1,2,3,....]
;      ALL CRUCIAL CHANGES HAPPEN IN .SCO

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

instr          1
idur           =         p4/1000        ;INIT DETERMINISTIC TRAPEZOID DURATION IN SECS
idel           =         p5/1000        ;INIT TRAPEZOID DELAY IN SECS
irdd           =         p6/1000        ;INIT RANDOMIC DURATION IN SECS
iprt           =         p7 + 0.1       ;INIT RISE (DECAY) FACTOR ( PLUS A MAGIC.. )
ird            =         p8             ;INIT RANDOM FREQUENCY DEVIATION
ifreq          =         p9             ;INIT GRAIN CENTER FREQUENCY
iph            =         p10            ;INIT TABLE PHASE
ifun           =         p11            ;INIT AUDIO FUNCTION TABLE
;
irise          =         (idur + irdd)/iprt  ;    RISE TIME IS A FRACTION OF THE TRAPEZOID (FIG.1)
                                             ;     DURATION.  EXAMPLE : IDUR = 40 MSEC
                                             ;                    irdd = 5 msec
                                             ;                      iprt = 4
                                             ;                irise = (40 + 5 ) / 4 = 11.25 msec
isus           =         (idur + irdd) -( 2 * irise )            ;COMPUTE SUSTAIN TRAPEZOID TIME
gigrain        =         idur + irdd + idel                      ;COMPUTE TOTAL GRAIN DURATION
goto           start                                             ;JUMP TO SWITCH ON TIMER ACTIVITY
;
loop:
idur           =         i(gkdur1)                               ;THE ACTUAL IDUR VALUE IS "I-RATED" FROM THE FREE-
                                                                 ;RUNNING FUNCTION GENERATOR THAT WORKS INSIDE AN
                                                                 ;INDIPENDENT INSTRUMENT (INSTR 11 FOR INSTR 1) AND
idur           =         idur/1000                               ;CONVERTED FROM MSEC INTO SECS.
irdd           =         i(gkrnd1)                               ;THE SAME FOR IRDD
irdd           =         irdd/1000
idel           =         i(gkdel1)                               ;THE SAME FOR IDEL
idel           =         idel/1000
iprt           =         i(gkprt1)+0.1                           ;THE SAME FOR IPRT
ird            =         i(gkran1)                               ;THE SAME FOR IRD
ifreq          =         i(gkfreq1)                              ;THE SAME FOR IFREQ
iph            =         i(gkph1)                                ;THE SAME FOR IPH
     irise     =         (idur + irdd)/iprt
     isus      =         idur + irdd - (2 * irise)
     gigrain   =         idur + irdd + idel
               ;print    gigrain,idur,irdd,idel                  ;PRINT VALUES IF YOU WANT...
               ;icount   not defined
start:         timout    0,gigrain,cont                          ;IF TIMER VALUE IS NOT ZERO
               ;goto     cont
               reinit    loop                                    ;ELSE JUMP TO A REINIT SECTION
cont:     k1   linseg    0,irise,1,isus,1,irise,0,idel,0         ;GENERATE LINEAR GRAIN
                                                                 ;ENVELOPE (SCALED TO 1 )
     k2        tablei    1023*k1,19                              ;SMOOTH ENVELOPE
     ga1       oscil     k2,ird + ifreq,ifun,iph                 ;GENERATE SOUND
endin

instr          11
gkdur1         oscil1    0,1,p3,p4                               ;CONTROL FUNCTION GENERATOR FOR IDUR
gkdel1         oscil1    0,1,p3,p5                               ;                   IDEL
gkrdd1         oscil1    0,1,p3,p6                               ;                   IRDD
gkprt1         oscil1    0,1,p3,p7                               ;                   IPRT
gkrd1          oscil1    0,1,p3,p8                               ;                   IRD
gkfreq1        oscil1    0,1,p3,p9                               ;                   IFREQ
gkph1          oscil1    0,1,p3,p10                              ;                   IPH
gkamp1         oscil1    0,1,p3,p11                              ;                   IAMP
gkran1         rand      gkrd1/2                                 ;FREQUENCY RANDOM GENERATOR
gkrnd1         rand      gkrdd1/2                                ;DURATION RANDOM GENERATOR
endin

instr          21
iscale         =         p4                                      ;READ AMPLITUDE SCALE FACTOR
a1             =         ga1
a2             delay     a1, 0.003                               ;3ms DELAY --
a3             delay     a1, 0.007                               ;7ms      |
a4             delay     a1, 0.011                               ;11ms        |
a5             delay     a1, 0.015                               ;15ms         > ADJUST VALUES....
a6             delay     a1, 0.017                               ;17ms        |
a7             delay     a1, 0.023                               ;23ms        |
a8             delay     a1, 0.025                               ;25ms      --
as1            =         (a1+a2+a3+a4)/4                         ;PREMIX AND RESCALE FIRST FOUR PSEUDO VOICES
as2            =         (a5+a6+a7+a8)/4                         ;PREMIX AND RESCALE LAST  FOUR PSEUDO VOICES
               out       ( as1+as2 ) * iscale * gkamp1           ;MIXDOWN, FINAL RESCALE ,OVERALL ADJUST
                                                                 ;AND OUTPUT SOUND SAMPLES.
               ;out      a1 * iscale *  gkamp1
endin

;*****************************************************************************
;BEGIN OF SECOND INSTRUMENT TRIPLET
;*****************************************************************************

instr          2                                                 ;ACTUAL SOUND GENERATOR USING VALUES FROM INSTR 12
idur           =         p4/1000                                 ;INIT DETERMINISTIC TRAPEZOID DURATION IN SECS
idel           =         p5/1000                                 ;INIT TRAPEZOID DELAY IN SECS
irdd           =         p6/1000                                 ;INIT RANDOMIC DURATION IN SECS
iprt           =         p7 + 0.1                                ;INIT RISE (DECAY) FACTOR ( PLUS A MAGIC.. )
ird            =         p8                                      ;INIT RANDOM FREQUENCY DEVIATION
ifreq          =         p9                                      ;INIT GRAIN CENTER FREQUENCY
iph            =         p10                                     ;INIT TABLE PHASE
ifun           =         p11                                     ;INIT AUDIO FUNCTION TABLE
irise          =         (idur + irdd)/iprt                      ;    RISE TIME IS A FRACTION OF THE TRAPEZOID (FIG.1)
                                                                 ;     DURATION.  EXAMPLE : IDUR = 40 MSEC
                                                                 ;                    irdd = 5 msec
                                                                 ;                      iprt = 4
                                                                 ;                irise = (40 + 5 ) / 4 = 11.25 msec
isus           =         (idur + irdd) -( 2 * irise )            ;COMPUTE SUSTAIN TRAPEZOID TIME
gigrain        =         idur + irdd + idel                      ;COMPUTE TOTAL GRAIN DURATION
               goto      start                                   ;JUMP TO SWITCH ON TIMER ACTIVITY
loop:
idur           =         i(gkdur1)                               ;THE ACTUAL IDUR VALUE IS "I-RATED" FROM THE FREE-
                                                                 ;RUNNING FUNCTION GENERATOR THAT WORKS INSIDE AN
                                                                 ;INDIPENDENT INSTRUMENT (INSTR 11 FOR INSTR 1) AND
idur           =         idur/1000                               ;CONVERTED FROM MSEC INTO SECS.
irdd           =         i(gkrnd1)                               ;THE SAME FOR IRDD
irdd           =         irdd/1000
idel           =         i(gkdel1)                               ;THE SAME FOR IDEL
idel           =         idel/1000
iprt           =         i(gkprt1)+0.1                           ;THE SAME FOR IPRT
ird            =         i(gkran1)                               ;THE SAME FOR IRD
ifreq          =         i(gkfreq1)                              ;THE SAME FOR IFREQ
iph            =         i(gkph1)                                ;THE SAME FOR IPH
     irise     =         (idur + irdd)/iprt
     isus      =         idur + irdd - (2 * irise)
     gigrain   =         idur + irdd + idel
               ;print    icount,gigrain,idur,irdd,idel           ;PRINT VALUES IF YOU WANT...

;++++++++++++ TIMER SECTION
start:         timout    0,gigrain,cont                          ;IF TIMER VALUE IS NOT ZERO
                                                                 ;GOTO CONT
               reinit    loop                                    ;ELSE JUMP TO A REINIT SECTION
cont:     k1   linseg    0,irise,1,isus,1,irise,0,idel,0         ;GENERATE LINEAR GRAIN
                                                                 ;ENVELOPE (SCALED TO 1 )
        k2     tablei    1023*k1,19                              ;SMOOTH ENVELOPE
                                                                 ;ANYTHING BUT F19 IS A CHANGE
     ga1       oscil     k2,ird + ifreq,ifun,iph                 ;GENERATE SOUND
;+++++++++++
endin

instr          12                                                ;CONTROL FUNCTION GENERATOR
gkdur1         oscil1    0,1,p3,p4                               ;CONTROL FUNCTION GENERATOR FOR IDUR
gkdel1         oscil1    0,1,p3,p5                               ;                   idel
gkrdd1         oscil1    0,1,p3,p6                               ;                   irdd
gkprt1         oscil1    0,1,p3,p7                               ;                   iprt
gkrd1          oscil1    0,1,p3,p8                               ;                   ird
gkfreq1        oscil1    0,1,p3,p9                               ;                   ifreq
gkph1          oscil1    0,1,p3,p10                              ;                   iph
gkamp1         oscil1    0,1,p3,p11                              ;                   iamp
gkran1         rand      gkrd1/2                                 ;FREQUENCY RANDOM GENERATOR
gkrnd1         rand      gkrdd1/2                                ;DURATION RANDOM GENERATOR
endin

instr          22                                                ;MIX-DELAY-RESCALE-OUT
iscale         =         p4                                      ;READ AMPLITUDE SCALE FACTOR
a1             =         ga1
a2             delay     a1, 0.003                               ;3ms DELAY --
a3             delay     a1, 0.007                               ;7ms      |
a4             delay     a1, 0.011                               ;11ms        |
a5             delay     a1, 0.015                               ;15ms         > ADJUST VALUES....
a6             delay     a1, 0.017                               ;17ms        |
a7             delay     a1, 0.023                               ;23ms        |
a8             delay     a1, 0.025                               ;25ms      --
as1            =         (a1+a2+a3+a4)/4                         ;PREMIX AND RESCALE FIRST FOUR PSEUDO VOICES
as2            =         (a5+a6+a7+a8)/4                         ;PREMIX AND RESCALE LAST  FOUR PSEUDO VOICES
               out       ( as1+as2 ) * iscale * gkamp1           ;MIXDOWN, FINAL RESCALE ,OVERALL ADJUST
                                                                 ;AND OUTPUT SOUND SAMPLES.
               ;out      a1 * iscale *  gkamp1
endin

</CsInstruments>
<CsScore>
;2GRAIN.SCO
;FOR 2 TRULY INDEPENDENT VOICES OF GRANULAR SYNTHESIS
;P3=3 SEC.
;NOTE: ORCH NEED NOT BE CHANGED, EXCEPT IF SMOOTHING FUNCTION (F19)
;FOR TABLEI (INSTR1,2,3,.....) IS DIFFERENT FOR ADDITIONAL TRIPLETS
;ALL CRUCIAL CHANGES BETWEEN TRIPLETS [EXCEPT FOR F19]
;TAKE PLACE IN THE MAIN INSTRUMENT [INSTR1,2,3] FOR EACH TRIPLET.

;=====================================================================
;CONTROL FUNCTIONS
;EACH TRIPLET HAS 1 SET OF FUNCTIONS CORRESPONDING TO THE P-FIELDS
;OF THE CORRESPONDING INSTRUMENT: F11-18 [#1], 21-28 [#2],....
;THERE WILL BE AN FINIT ERROR IF THEY ARE NOT ALIGNED
;
;DURATION (THE LARGER, THE MORE SPARSE, E.G. >50 MSEC.)
f11 0 512 -7 20 256 50  256 20                 «  ;[see p4 of instr1]
;f11 0 512 -7 10 256 100 256 10
f21 0 512 -7 10 256 100 256 10
;DELAY (THE SMALLER, THE MORE FUSED, DETACHED WHEN >50 MSEC.)
;f12 0 512 -7 10  256 10 256 10                   ;[see p5]
f12 0 512 -7 10 256 10 256 10
f22 0 512 -7 50 256 10 256 50
;*******************
;DURATION DEVIATION (durational irregularity)
;f13 0 512 -7 10 512 5                            ;[see p6]
;f13 0 512 -7 20 512 1
;f13 0 512 -7 100 256 1 256 100
;f13 0 512 -7 100 256 200 50
f13 0 512 -7 10 512 5
f23 0 512 -7 50 512 1
;********************
;RISE/DECAY time
f14 0 512 -7 2  512 2                             ;[see p7]
f24 0 512 -7 5  512 5
;CENTER FREQUENCY
f15 0 512 -7 50  256 100 256 150                  ;[see p8]
;f15 0 512 -7 30 256 300 256 50 ;p8=30
;f25 0 512 -7 30 256 300 256 50
f25 0 512 -7 30 256 100 256 30
;DEVIATION FROM CENTER FREQUENCY
f16 0 512 -7 100 256 200 256 400                  ;[see p9]
;f26 0 512 -7 50 100 100 412 400                  ;QUICKLY TO 100 HZ, THEN MORE SLOWLY TO 400 HZ
f26 0 512 -7  50 100 100 412 50
;PHASE
f17 0 512 -7 0 512 0                              ;[see p10]
f27 0 512 -7 180 512 180
;GLOBAL ENVELOPE
f18 0 512 7 0   64  1  384  1  64 0               ;[see p11]
f28 0 512 7 0   128 .5 256 1 128 0
;SMOOTHING FUNCTION
f19 0 1025 8  0 256 0.1 256 0.5 256 0.9 257 1     ;CAN BE USED IN BOTH TRIPLETS
;NOT A SUCCESS WHEN COMBINED WITH f19 ...
;f29 0 1025 8  1 256 .75 256 .9 256 .45 257 .1
;
;WAVEFORMS DETERMINE SOUND COLOR!
f1 0 1024  10 1 ;the usual
;f1 0 1024  10 0 1
;f1 0 1024 10 1 .5 .3 .1                          ;"SINE2". A LITTLE DULL
;f2 0 1024 10 0 .01 1 0 5 0                       ;"SINE3", [STRONG 3RD & 5TH PARTIAL], SILVERY
;f2 0 1024 9 .25 1 90                             ;COSINE, INTERESTING DENSE SOUND; REDUCE AMPSCALE
f2 0 1024 10 .7 .353 .54 .22 0                    ;30% OF THE WAY BETWEEN SINE2/SINE3

;SCORE FOR 2 TRIPLETS (1-2, 11-12, 21-22)
;DIFFERENT WAVEFORMS UNDER P11, SAME SMOOTHING F19
;
;p1 p2  p3   p4     p5     p6     p7     p8     p9     p10    p11
;            dur    del    rndd   prt    rndf   freq   phas   ifun
;            dur    del    durdev rise   cf     cfdev         waveform
i1  0   3    50      10     10      2     50    100     0      1      ;ALTERED SINE
;I2 IS MORE SPARSE, MORE DETACHED, HAS A LARGER DURATION DEVIATION,
;A LOWER FREQUENCY BOTTOM, A DIFFERENT FREQ. DEVIATION, AND DIFFERENT PHASE,
;AS WELL AS A DIFFERENT WAVEFORM
i2  0   3    100     50     50      2     30    50      180    2      ;HYBRID SINE2/3
;---------------------------------------------------------------------
;functions 11-18 belong to i1 (first triplet), 21-28 to i2 (second triplet)
;
;         dur_f  del_f  rndd_f prt_f    rndf_f    freq_f phas_f amp_f
;            dur_f  del_f  dev_f  ris_f cf_f    dev_f  phas_f amp_f
i11 0   3    11     12     13     14    15      16     17     18
i12 0   3    21     22     23     24    25      26     27     28
;---------------------------------------------------------------------
;
;AMPSCALE [DEPENDS ON WAVEFORM;
;MAY EXCEED 24K FOR ALL TRIPLETS,--EXPERIMENT!]

;FIRST TRIPLET
i21 0   3    16000
;COSINE  USES LOWER AMPSCALE TO AVOID SAMPLES OUT OF RANGE
;i21 0   3    16000
;SECOND TRIPLET [COSINE]
i22 0   3    16000
e

</CsScore>
</CsoundSynthesizer>
