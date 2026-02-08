<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from AM.ORC and AM.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

;*********************************************************;
;      AMPLITUDE MODULATION   ORCHESTRA
;                                                         ;
;     P3 = DURATION           P4 = AMPLITUDE              ;
;     P5 = PITCH IN CPS       P6 = RATE OF MODULATION     ;
;     P7 = MODULATION DEPTH % P8 = FUNCTION FOR MOD RATE  ;
;     P9 = FUNCTION FOR MOD DEPTH
;     P10 = FUNCTION FOR PORTAMENTO
;                                                         ;
;     FUNCTIONS                                           ;
;                                                         ;
;     F1 = SINE WAVE         F2 = LINEAR RISE             ;
;     F3 = LINEAR FALL       F4 = EXPONENTIAL RISE        ;
;     F5 = EXPONENTIAL FALL  F6 = SINE WAVE FOR BUZZ      ;
;     F7 = MODULATION RATES  F8 = MODULATION DEPTHS
;                                                         ;
;*********************************************************;


               instr     1
;  ******  PORTAMENTO  ******
     ipitch    =         (p5)
     idist     =         (sr*.4) - ipitch
     kchange   oscil1    0.0, idist, p3, p10
     kline     =         kchange + ipitch
;
; *****  AMPLITUDE MODULATION ******
     iampfac   =         (p4)*(p7)
     ktsamp    oscil1    0.41,iampfac,(p3),(p9)
     kstfrq    oscil1    0.38,(p6),(p3),(p8)
     ktrem     oscil     ktsamp,kstfrq,1
     kamp      =         (p4)+ktrem
;
; *****  MAIN INSTRUMENT DESIGN  ***********
     knh       =         int((sr*.42)/kline)
     asrce     buzz      kamp,kline,knh,6
     amain     reson     asrce,12000,8000,1
     asnd      balance   amain,asrce
     asig      envlpx    asnd,.1,p3,.01,2,1.001,.01
               out       asig
               endin


</CsInstruments>
<CsScore>
;AMPLITUDE MODULATION SCORE FILE
; SINE WAVE
f1 0.0 512 10 1
; LINEAR RISE
f2 0.0 513 7 0 513 1
; LINEAR FALL
f3 0.0 513 7 1 513 0
; EXPONENTIAL RISE
f4 0.0 513 5 .001 513 1
; EXPONENTIAL FALL
f5 0.0 513 5 1 513 .001
; FUNCTION FOR BUZZ UNIT
f6 0.0 8192 10 1
; FUNCTION FOR MODULATOR RATE
f7 0.0 513 5 .001 62 .9 150 .65 200 .97 51 .78 50 1
; FUNCTION FOR MODULATOR DEPTH
f8 0.0 513  5 .5 163 .39 200 .97 150 .61
;    FUNCTION FOR PORTAMENTO
f9 0.0 513 7 0 105 .4 31 .25 105 .65 31 .50 105 .90 31 .75 105 1

;      INSTRUMENT CARDS

i1 0.00 4.50 10000 8000 6000 0.3 7 8 9
s
i1 0.00 4.50 10000  3000 10000 0.3 7 8 9
i1 2.53 4.50 10000  8000 10000 1.0 7 8 9
i1 4.05 4.50 10000  9000 10000 0.3 7 8 9
i1 4.97 4.50 10000 10000 10000 1.0 7 8 9
s
i1 0.00 4.50 10000  4000 3200 1.0 7 8 9
s
i1 0.00 4.50 10000 1000 8000 1.0 7 8 9
e

</CsScore>
</CsoundSynthesizer>
