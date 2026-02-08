<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WEB3.ORC and WEB3.SCO
; Original files preserved in same directory

sr                  =         44100
kr                  =         4410
ksmps               =         10
nchnls              =         2

;HOWARD FREDRICS
;4:02PM  2/13/1989
;MUS329J

;====================================================================;
;                       WEBERN ORCHESTRA
;====================================================================;


;=========================================================================;
;                 SIMPLE GATING INSTRUMENT WITH CHORUS                    ;
;                                                                         ;
; P4=AMP      P5=PCH1       P6=PCH2       P7=RISEFAC      P8=DECFAC       ;
; P9=OFN1    P10=OFN2      P11=GATEFN    P12=BEATHZ      P13=GATEHZ       ;
;=========================================================================;
                    instr     5,6,7,8

   igatehz          =         (p13 == 0 ? 1/p3 : p13)            ;DEFAULT TO ONCE PER NOTE
   ihalfamp         =         p4/2
   ipitch1          =         cpspch(p5)
   ipitch2          =         cpspch(p6)
   ibeatfreq        =         p12
   idetune2         =         ipitch2 + ibeatfreq

   kgate            oscili    1,igatehz,p11                      ;P11 HAS GATING CONTROL FN#
   kenvlp           linen     1,p3*p7,p3,p3*p8                   ;P7,P8 ARE RISE, DECAY FACS

   asig1            oscili    p4,ipitch1,p9                      ;SOUND ONE
   astraight2       oscili    ihalfamp,ipitch2,p10               ;STRAIGHT SOUND TWO
   adetune2         oscili    ihalfamp,idetune2,p10              ;DETUNED SOUND TWO
   asig2            =         astraight2 + adetune2              ;SOUND TWO

   aout1            =         asig1 * kgate
   aout2            =         asig2 * (1-kgate)
   aoutsig          =         (aout1 + aout2) * kenvlp           ;OUTPUT THE SUM

                    outs      aoutsig,aoutsig
                    endin
;==========================================================================;
;               BASIC FM INSTRUMENT WITH VARIABLE VIBRATO                  ;
;                                                                          ;
;  P4=AMP       P5=PCH(FUND)    P6=VIBDEL       P7=VIBRATE      P8=VIBWTH  ;
;  P9=RISE      P10=DECAY       P11=MAX INDEX   P12=CAR FAC     P13=MODFAC ;
;  P14=INDEX RISE  P15=INDEX DECAY  P16=LEFT CHANNL FACTOR P17=ORIGINAL P3 ;
;  P18=VIBFN       P20=IRISEFN      P21=INRISEFN                           ;
;==========================================================================;
                    instr     9,10
;------------------------------------------------;INITIALIZATION BLOCK:
        kpitch      init      cpspch (p5)

        itempo      =         p3/p17                             ;RATIO SECONDS/BEATS
        idelay      =         p6 * itempo                        ;CONVERT BEATS TO SECS
        irise       =         p9 * itempo
        idecay      =         p10 * itempo
        indxris     =         (p14 == 0 ? irise : p14 * itempo)
        indxdec     =         (p15 == 0 ? idecay : p15 * itempo)
        ivibfn      =         p18
        irisefn     =         p20
        inrisefn    =         (p21 == 0 ? irisefn : p21)
          if       (p16 != 0) igoto panning                      ;IF A PANFAC, USE IT, ELSE
        ilfac       =         .707                               ;DEFAULT IS MONO (SQRT(.5))
        irfac       =         .707
                    igoto     perform
panning:
        ilfac       =         sqrt(p16)
        irfac       =         sqrt(1-p16)
;------------------------------------------------     ;PERFORMANCE BLOCK:
perform:
if       (p7 == 0 || p8 == 0) goto continue
        kontrol     oscil1    idelay,1,.2,2                      ;VIB CONTROL
        kvib        oscili    p8*kontrol,p7*kontrol,ivibfn       ;VIBRATO UNIT
        kpitch      =         cpsoct(octpch(p5)+kvib)            ;VARYING FUND PITCH IN HZ
continue:
        kamp        envlpx    p4,irise,p3,idecay,irisefn,1,.01   ;IRISEFN FOR SHAPE OF CELLO
        kindex      envlpx    p11,indxris,p3,indxdec,inrisefn,1,.01

        asig        foscili   kamp/3,kpitch,p12,p13,kindex,1     ;P12=CARFAC,P13=MODFAC
                    outs      asig*ilfac,asig*irfac
                    endin

</CsInstruments>
<CsScore>
; SAMPLE SCORE #3
; TEMPO = 25 BEATS/MIN
t00     25
; SIMPLE SINE FUNCTION
f01     0       512    10       1
; RAMP
f02     0       513     7       0       512     1
; EXPONENTIAL RISE
;f03     0       513     5       .001    512     1
; QUARTER SINE WAVE IN 128 LOCS + EXTENDED GUARD POINT
;f04     0       129     9       .25     1       0
; QUARTER COSINE
;f05     0       129     9       .25     1       90
; TRIANGULAR WAVE
;f06     0       512     10      1   0 .111   0  .04    0  .02    0 .012
; SAWTOOTH WAVE
f07     0       512     10      1  .5   .3 .25   .2 .167  .14 .125 .111
; SQUARE WAVE
f08     0       512     10      1   0   .3   0   .2    0  .14    0 .111
; NARROW PULSE
f09     0       512     10      1 1  1   1 .7 .5 .3 .1
; EXPONENTIAL RISE AND DECAY
f10     0       513     5       .1      128      1      384     .01
; REVERSE PYRAMID
;f11     0       513     7       1       256     0       256     1
; TRILL SQUARE
f12     0       513     7       0       1       .01     1       1       254     1       1       .01     2       0
;CELLO EXPONENTIAL RISE FOR AMP
f13     0       513     5       .001    51      1       102     .2      359     1
;CELLO EXPONENTIAL RISE FOR INDEX
f14     0       513     5       .001    102      1       102     .6      308     1
;CELLO INV EXPONENTIAL RISE FOR AMP
f15     0       513     5       .001    51      1       308     .2      153     .01
;BELL EXPONENTIAL RISE FOR AMP
f16     0       513     5       .001    25      1       77      .6      210     .6      100 .7 100 .4
;BELL EXPONENTIAL RISE FOR AMP
f17     0       513     5       .001    25      1       77      .4      210     .4      150 .5  50 .2


;==========================================================================;
;               BASIC FM INSTRUMENT WITH VARIABLE VIBRATO                  ;
;                                                                          ;
;  P4=AMP       P5=PCH(FUND)    P6=VIBDEL       P7=VIBRATE      P8=VIBWTH  ;
;  P9=RISE     P10=DECAY       P11=MAX INDEX   P12=CAR FAC     P13=MOD FAC ;
; P14=INDEX RISE  P15=INDEX DECAY  P16=LEFT CHANNEL FACTOR P17=ORIGINAL P3 P18=VIBFN;
;  P20=IRISEFN P21=INRISEFN
;==========================================================================;
; CELLO LINE
;p1     p2      p3   p4      p5   p6 p7 p8   p9  p10 p11 p12 p13 p14 p15 p16 p17  p18 p19  p20  p21
i09     0       2.05 18000   6.03 .2 8 .083 1.9 .1   4   3   1   0   0  .8  np19  12  0    13   14
i09     2       1.4  25000   8.00 .5 3 .005  .15 .2  1   .   .   .   .  .4  np19   1 pp3    2    2
i09     3.34     .76 18000   6.11 .2 4 .02   .6 .1   3   1   1   .25 .3 .7  np19   .  .    13   14
i09     4       1.5  16000   6.10 .5 4 .02   .4 .    .   .   .   .   .  .8  np19   .  .    .    .
i09     9       3    20000   8.05 1  5 .015 1.5 1.5  5   3   1   .1  .1 .2  np19   .  .     2   14
i09     15      .5   12000   8.09 .1 0 .    .4  .1   1   .   .   .45 .05 .4 np19   .  .    .    .
i09     16.5    1    13500   9.02 .  . .    .4  .1   1.5 4   1   .   .   .3 np19   .  .    .    .
i09     18      3    12000  10.01 1  3 .005 .08 .5    3   .   .   .1 2.1 .2 3      .  .    15   14
;-------------------------------------------------------------------------------------------------
;PIANO (BELLS) CHORDS
;p1     p2      p3   p4      p5   p6 p7 p8   p9  p10 p11 p12 p13 p14 p15 p16 p17  p18 p19  p20  p21
i10     3.5     2.5   9000   7.02 .1 0  0   1.5    .5  8   1   1.4 .5  1  .2  np19  1   0    16   17
i10     3.5     2.7  10000   6.01 .  .  .   .    .   .   .    .  .   .  .3  np19  .   pp3  .    .
i10     .       2.9  10500   5.05 .  .  .   .    .   .   .    .  .   .  .   np19  .   .    .    .
i10     8.66    3.33 12000   7.03 .  .  .   2    .3  9   .    .  .   .  .2  np19  .   pp3  .    .
i10     8.66    3.5  13000   5.04 .  .  .    .    .   .   .    .  .   .  .3  np19  .   .    .    .
i10     13.33   3.66  9000   6.11 .  2  .005 .5   .5  8   .    .  .   .  .2  np19  .   .    .    .
i10     13.33   3.75  9500   6.06 .  .  .    .   .   .   .    .  .   .  .3
i10     13.33   3.8  10000   6.00 .  .  .    .   .   .   .    .  .   .  .   .
i10     13.33   3.9  10500   5.10 .  .  .    .   .   .   .    .  .   .  .   3.9   .   .    .    .
;-------------------------------------------------------------------------------------------------
;PIANO LYRIC VOICE
;                 SIMPLE GATING INSTRUMENT WITH CHORUS
;
; P4=AMP      P5=PCH1       P6=PCH2       P7=RISEFAC      P8=DECFAC
; P9=OFN1    P10=OFN2      P11=GATEFN    P12=BEATHZ      P13=GATEHZ
;=========================================================================
;p1     p2      p3      p4      p5      p6      p7  p8 p9 p10 p11 p12 p13
i05     5.66   1.7      16000   7.06   7.06    .2  .3   8   9  10   1   .5
i05     7.33    .7      18000   6.08   6.08    .1  .5   9   8  .    2   1.3
i05     8      4        19000   7.07   7.07    .05 2    8   7  .    3   .25
e

</CsScore>
</CsoundSynthesizer>
