<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FMFILT.ORC and FMFILT.SCO
; Original files preserved in same directory

          sr             =         44100
          kr             =         44100
          ksmps          =         1
          nchnls         =         1

;***************************************************************;
;         FM FILTER ORCHESTRA
;    P3  = DURATION
;       P4  = AMPLITUDE
;    P5  = PITCH IN PCH
;    P6  = STARTING MOD TO CAR RATIO
;    P7  = ENDING MOD TO CAR RATIO
;    P8  = FUNCTION NUMBER FOR RATIO CHANGE
;    P9  = STARTING INDEX LEVEL
;    P10 = ENDING INDEX LEVEL
;    P11 = FUNCTION NUMBER FOR RATIO CHANGE
;    P12 = STARTING CENTER FREQUENCY
;    P13 = ENDING CENTER FREQ
;    P14 = FUNCTION NUMBER FOR CF CHANGE
;    P15 = STARTING BAND WIDTH
;    P16 = ENDING BAND WIDTH
;    P17 = FUNCTION NUMBER FOR BW CHANGE
;**************************************************************;

          instr          1
          ipitch1        =         cpspch(p5)
          ipitch2        =         ipitch1 * 1.001
          ipitch3        =         ipitch1 * 0.998
          imodbase       =         (p6 <= p7 ? p6 : p7)
          imodmax        =         (p6 <= p7 ? p7 : p6)
          indxbase       =         (p9 <= p10 ? p9 : p10)
          indxmax        =         (p9 <= p10 ? p10 : p9)
          kmodchg        oscil1i   0.00,(imodmax - imodbase),p3,p8
          kmod           =         imodbase + kmodchg
          kndxchg        oscil1i   0.00,(indxmax - indxbase),p3,p11
          kndx           =         indxbase + kndxchg
          afm1           foscili   (p4*.45),ipitch1,1,kmod,kndx,1
          afm2           foscili   (p4*.35),ipitch2,1,kmod,kndx,1
          afm3           foscili   (p4*.32),ipitch3,1,kmod,kndx,1
          afmttl         =         afm1+afm2+afm3
          aosc1          oscil     (p4 *.45),ipitch1,1
          aosc2          oscil     (p4 *.35),ipitch2,1
          aosc3          oscil     (p4 *.32),ipitch3,1
          aoscttl        =         aosc1+aosc2+aosc3
          afm            =         afmttl - aoscttl
                    ;    print     ipitch1,ipitch2,ipitch3
                    ;    print     imodbase,imodmax,indxbase,indxmax
          icfbase        =         (p12 <= p13 ? p12 : p13)
          icfmax         =         (p12 <= p13 ? p13 : p12)
          kcfchg         oscil1i   0.00,(icfmax - icfbase),p3,p14
          kcf            =         icfbase + kcfchg
          ibwbase        =         (p15 <= p16 ? p15 : p16)
          ibwmax         =         (p15 <= p16 ? p16 : p15)
          kbwchg         oscil1i   0.00,(ibwmax - ibwbase),p3,p17
          kbw            =         ibwbase + kbwchg
          aflt1          reson     afm,kcf,kbw,1
          aflt2          reson     afm,(kcf*.9),(kbw*1.11),1
          abal           balance   (aflt1+aflt2),afm
          asig           envlpx    abal,.2,p3,(p3*.39),5,1,.01
                         out       asig
                         endin

</CsInstruments>
<CsScore>
;         FM FILTER SCORE                    ;
;*******************************************************;
;         FUNCTIONS
;
;    SINE WAVE
f1 0.0 512 10 1
;    EVERYTHING
f2 0.0 512 7 1 512 1
;    HALF
f3 0.0 512 7 .5 512 .5
;    LINEAR FALL
f4 0.0 513 7 1 512 0 1 0
;    LINEAR RISE
f5 0.0 513 7 0 512 1 1 1
;    FALL THEN RISE
f6 0.0 513 7 1 256 0 256 1 1 1
;    RISE THEN FALL
f7 0.0 513 7 0 256 1 256 0 1 0
;    ALL OVER THE PLACE
f8 0.0 513 7 .5 63 .95 50 0 50 .3 50 .85 50 .80 50 .03 50 1 50 .12 50 .10 50 .5
;    ALSO ALL OVER THE PLACE
f9 0.0 513 7 .5 63 .95 50 .02 50 .3 50 .85 50 .80 50 .06 50 .98 50 .03 50 .10 50 .5
;
;    INSTRUMENT CARDS
;
i1   0.00    5.00    7000 10.00    19    1    4     1    2   5    4000  12000  8    100    400    6
s
i1   0.00    5.00    7000  5.00    19    1    4     1    2   5    40    120    7    100    4000    5
e

</CsScore>
</CsoundSynthesizer>
