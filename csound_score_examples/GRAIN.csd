<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from GRAIN.ORC and GRAIN.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         44100
ksmps          =         1

;GSC8.ORC
;
;EFFECTIVE MULTIPLE AND TRULY INDEPENDENT VOICES CAN BE OBTAINED ADDING
;TRIPLETS OF CSOUND INSTRUMENTS.
;
;--------------   ORCHESTRA HEADER   ----------
;NOTE 0):FOR A BETTER QUALITY LET KSMPS = 1
;
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
;
instr          1
;NOTE 1):
;ONE INDEPENDENT VOICE ( 8 PSEUDO VOICES ) CONSISTS OF 3 INTRUMENTS WORKING
;IN PARALLEL MODE.( INSTR 1 ; INSTR 11; INSTR 21 )
;
;NOTE2:
;EACH GRAIN IS INTENDED AS THE SUM OF TWO PARTS: A TRAPEZOID AND A DELAY.
;THE TRAPEZOID DURATION IS THE SUM OF A DETERMINISTIC (CENTER) VALUE PLUS (OR
;MINUS) A RANDOM TIME QUANTITY . THE RISE AND DECAY TIME ARE TWO
;EQUAL QUANTITIES THAT ARE A FRACTIONAL PART OF THIS SUM (SEE FIG. 1)
;
;
;         -------------
;             .                .
;           .            ._________________________    fig. 1
;
;        <--  idur + irdd --><--------- idel ---------->
;
;WARNING : P4,P5 AND P6 MUST BE EXPRESSED INTO THE SCORE FILE IN MSECS.!!!!!
;========
idur           =         p4/1000        ;INIT DETERMINISTIC TRAPEZOID DURATION IN SECS
idel           =         p5/1000        ;INIT TRAPEZOID DELAY IN SECS
irdd           =         p6/1000        ;INIT RANDOMIC DURATION IN SECS
iprt           =         p7 + 0.1       ;INIT RISE (DECAY) FACTOR ( PLUS A MAGIC.. )
ird            =         p8             ;INIT RANDOM FREQUENCY DEVIATION
ifreq          =         p9             ;INIT GRAIN CENTER FREQUENCY
iph            =         p10            ;INIT TABLE PHASE
ifun           =         p11            ;INIT AUDIO FUNCTION TABLE
;
;    FIRST INITIALIZATION
;       --------------------
irise          =         (idur + irdd)/iprt  ;    RISE TIME IS A FRACTION OF THE TRAPEZOID (FIG.1)
                                             ;     DURATION.  EXAMPLE : IDUR = 40 MSEC
                                             ;                    irdd = 5 msec
                                             ;                      iprt = 4
                                             ;                irise = (40 + 5 ) / 4 = 11.25 msec


isus           =         (idur + irdd) -( 2 * irise )       ;COMPUTE SUSTAIN TRAPEZOID TIME

gigrain        =         idur + irdd + idel                 ;COMPUTE TOTAL GRAIN DURATION

goto           start                                        ;JUMP TO SWITCH ON TIMER ACTIVITY
;
;    REINITIALIZATION (ACTIVE WHEN TIMER REACHES ZERO)
;       -------------------------------------------------
loop:
idur           =         i(gkdur1)                          ;THE ACTUAL IDUR VALUE IS "I-RATED" FROM THE FREE-
                                                            ;RUNNING FUNCTION GENERATOR THAT WORKS INSIDE AN
                                                            ;INDIPENDENT INSTRUMENT (INSTR 11 FOR INSTR 1) AND
idur           =         idur/1000                          ;converted from msec into secs.
irdd           =         i(gkrnd1)                          ;The same for irdd
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

;---------- TIMER SECTION & INTERRUPT SIMULATION ----------
;
;THE TIMOUT STATEMENT WORKS AS AN INTERRUPT GENERATOR. THE TIMER IS LOADED
;WITH THE CURRENT GRAIN DURATION AND DECREMENTED UNTIL ZERO VALUE.
;
start:         timout    0,gigrain,cont                     ;If timer value is not zero
               ;goto     cont
               reinit    loop                               ;ELSE JUMP TO A REINIT SECTION
;
cont:     k1   linseg    0,irise,1,isus,1,irise,0,idel,0    ;GENERATE LINEAR GRAIN
                                                            ;envelope (scaled to 1 )
     k2        tablei    1023*k1,19                         ;SMOOTH ENVELOPE
     ga1       oscil     k2,ird + ifreq,ifun,iph            ;GENERATE SOUND
endin
;
;**********************************************************************
;**********************************************************************
;>>>>>>>>>>>>>>>>   CONTROL FUNCTION GENERATOR UNIT    <<<<<<<<<<<<
instr          11
;NOTE: ALL THE GLOBAL G-VARIABLES ARE TRANSMITTED TO THE INSTR 1!!
;
gkdur1         oscil1    0,1,p3,p4                          ;CONTROL FUNCTION GENERATOR FOR IDUR
gkdel1         oscil1    0,1,p3,p5                          ;                   idel
gkrdd1         oscil1    0,1,p3,p6                          ;                   irdd
gkprt1         oscil1    0,1,p3,p7                          ;                   iprt
gkrd1          oscil1    0,1,p3,p8                          ;                   ird
gkfreq1        oscil1    0,1,p3,p9                          ;                   ifreq
gkph1          oscil1    0,1,p3,p10                         ;                   iph
;
gkamp1         oscil1    0,1,p3,p11                         ;                   iamp
;
gkran1         rand      gkrd1/2                            ;FREQUENCY RANDOM GENERATOR
gkrnd1         rand      gkrdd1/2                           ;DURATION RANDOM GENERATOR
endin
;**********************************************************************
;**********************************************************************
;>>>>>>>>>>>>>>>>>     MIX / DELAY / RESCALE & OUT UNIT    <<<<<<<<<<<<

instr          21
iscale         =         p4                                 ;READ AMPLITUDE SCALE FACTOR
a1             =         ga1
a2             delay     a1, 0.003                          ;3ms delay --
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
;*************************************************************************
;*************************************************************************
;BEGIN OF SECOND INSTRUMENT TRIPLET
;
instr          2                                            ;ACTUAL SOUND GENERATOR USING VALUES FROM INSTR 12
;========
idur           =         p4/1000                            ;INIT DETERMINISTIC TRAPEZOID DURATION IN SECS
idel           =         p5/1000                            ;INIT TRAPEZOID DELAY IN SECS
irdd           =         p6/1000                            ;INIT RANDOMIC DURATION IN SECS
iprt           =         p7 + 0.1                           ;INIT RISE (DECAY) FACTOR ( PLUS A MAGIC.. )
ird            =         p8                                 ;INIT RANDOM FREQUENCY DEVIATION
ifreq          =         p9                                 ;INIT GRAIN CENTER FREQUENCY
iph            =         p10                                ;INIT TABLE PHASE
ifun           =         p11                                ;INIT AUDIO FUNCTION TABLE
irise          =         (idur + irdd)/iprt                 ;    RISE TIME IS A FRACTION OF THE TRAPEZOID (FIG.1)
                                                            ;     DURATION.  EXAMPLE : IDUR = 40 MSEC
                                                            ;                    irdd = 5 msec
                                                            ;                      iprt = 4
                                                            ;                irise = (40 + 5 ) / 4 = 11.25 msec
isus           =         (idur + irdd) -( 2 * irise )       ;COMPUTE SUSTAIN TRAPEZOID TIME
gigrain        =         idur + irdd + idel                 ;COMPUTE TOTAL GRAIN DURATION
goto           start                                        ;JUMP TO SWITCH ON TIMER ACTIVITY
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
     k2        tablei    1023*k1,19                         ;SMOOTH ENVELOPE
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
;GRAIN.SCO
;CHANGING P-FIELDS IN INSTR1, AND CORRESPONDING FUNCTIONS
;p3=3 sec.
;==========================================================================
;*************************
;ONE VOICE EQUALS THREE RELATED INSTRUMENTS
;P-FIELDS IN INSTR 1 MUST MATCH INIT VALUES IN FUNCTIONS 11-18
;P-FIELDS IN INSTR11 LIST THE INIT VALUES CORRESPONDING TO INSTR1
;P-FIELDS IN INSTR21 DEFINE THE AMPSCALE
;
;THERE ARE 8 MAJOR PARAMETERS (F11-18: GEN07; F19: GEN08; F1: GEN10)
;1. DURATION (P4, P6, FN 11, 13, INSTR1), WHICH IS SPARSE/DENSE
;2. DELAY (P5, FN 12 INSTR1). WHICH IS FUSED/DETACHED
;3. FREQUENCY (P8, P9, FN 15, 16, INSTR1)
;4. RISE/DECAY (P7, FN. 14, INSTR1)
;5. GLOBAL ENVELOPE (P11, F18, INSTR1)
;6. SMOOTHING FUNCTION (F19, GEN08)
;7. PHASE (P10, F17 INSTR1, A CONSTANT (=0)
;8. F1, A SINE (OR OTHER) WAVE
;
;P-FIELDS OF INSTR1 AND CORRESPONDING FUNCTIONS HAVE THIS MEANING:
;P4/F11 =DETERMINISTIC DURATION IN SECONDS (TYPICALLY 50/1000, I.E. .05)
;P5/F12 =DELAY IN SECONDS (TYPICALLY 10/1000, I.E. .01)
;P6/F13 =RANDOM DURATION IN SECONDS (TYPICALLY 10/1000)
;P7/F14 =RISE/DECAY FACTOR, TYPICALLY 2.0 + SOME MAGIC, E.G., .1
;P8/F15 =RANDOM FREQUENCY DEVIATION (TYPICALLY 50 HZ)
;P9/F16 =CENTER FREQUENCY (TYPICALLY 100 HZ); INIT VALUE FOR F16
;P10/F17=TABLE PHASE (TYPICALLY CONSTANT=0)
;P11/F18=FUNCTION TABLE (TYPICIALLY SINE TONE)
;
;F1     FOR SINE TONE (GEN10)
;F11/P4    DURATION FN., 20-50 MSEC [P4=50, INSTR1]
;F12/P5    DELAY FN., 10 MSEC. [P5=10]
;F13/P6    DURATION DEVIATION FN., 10-5 MSEC. [P6=10]
;F14/P7    RISE FN, I.E., CONSTANT RISE TIME, E.G. 2 (MSEC.) [P7=2]
;F15/P8    FREQUENCY DEVIATION FN., 50 => 150 (HZ) [P8=50]
;F16/P9    FREQUENCY FN. (2 OCTAVES: 50 => 100 => 150) ? [P9=100]
;F17/P10   PHASE FN., CONSTANT=0 [P10=0]
;F18/P11   GLOBAL ENVELOPE FN., [NO GUARD POINT] BETWEEN 0 AND 1 [P11=1; FN.#]
;F19    SMOOTHING FUNCTION WITH GUARD POINT (GEN08)
;
;=====================================================================
;CONTROL FUNCTIONS
;DURATION (THE LARGER, THE MORE SPARSE, E.G. >50 MSEC.)
;f11 0 512 -7 20 256 50  256 20                   ;[see p4 of instr1]
f11 0 512 -7 10 256 100 256 10
;DELAY (THE SMALLER, THE MORE FUSED, DETACHED WHEN >50 MSEC.)
;f12 0 512 -7 10  256 10 256 10                   ;[see p5]
f12 0 512 -7 50 256 10 256 50
;*******************
;DURATION DEVIATION (DURATIONAL IRREGULARITY)
;f13 0 512 -7 10 512 5                            ;[see p6]
;f13 0 512 -7 20 512 1
;FINIT ERROR IN INSTR1 WHEN 100 IN P6: NEGATIVE TIME PERIOD, BUT SOUNDS O.K.
;f13 0 512 -7 100 256 1 256 100
;ERROR MESSAGES WHEN 200 IN P6, MUST BE INIT VALUE = 100
;f13 0 512 -7 100 256 200 50
f13 0 512 -7 50 512 1
;********************
;RISE TIME
f14 0 512 -7 2  512 2                             ;[see p7]
;FREQUENCY
;f15 0 512 -7 50  256 100 256 150                 ;[see p8]
f15 0 512 -7 30 256 300 256 50 ;p8=30
;FREQUENCY DEVIATION
;f16 0 512 -7 100 256 200 256 400                 ;[see p9]
f16 0 512 -7 50 100 100 412 400                   ;QUICKLY TO 100 HZ, THEN MORE SLOWLY TO 400 HZ
;PHASE
f17 0 512 -7 0 512 0                              ;[see p10]
;GLOBAL ENVELOPE
f18 0 512 7 0   64  1  384  1  64 0               ;[see p11]
;SMOOTHING FUNCTION
f19 0 1025 8  0 256 0.1 256 0.5 256 0.9 257 1
;WAVEFORMS DETERMINE SOUND COLOR!
;f1 0 1024  10 1                                  ;THE USUAL
f1 0 1024 10 1 .5 .3 .1                           ;"SINE2". A LITTLE DULL
;f1 0 1024 10 0 .01 1 0 5 0                       ;"SINE3", [STRONG 3RD & 5TH PARTIAL], SILVERY
;f1 0 1024 9 .25 1 90                             ;COSINE, INTERESTING DENSE SOUND
;SCORE PROPER

;p1 p2  p3   p4     p5     p6     p7     p8     p9     p10    p11
;         dur    del    rndd   prt    rndf   freq   phas   ifun
;i1  0   1    50      10     10      2     50    100     0      1
i1  0    3    100      50    50      2     30    50     0      1
;---------------------------------------------------------------------
;         dur_f  del_f  rndd_f prt_f    rndf_f    freq_f phas_f amp_f
i11 0   3    11     12     13     14    15      16     17     18
;---------------------------------------------------------------------
;        AMPSCALE
i21 0   3    24000
;FOR COSINE
;i21 0 3 16000
e

</CsScore>
</CsoundSynthesizer>
