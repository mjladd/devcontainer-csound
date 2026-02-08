<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PNO1.ORC and PNO1.SCO
; Original files preserved in same directory

     sr             =         44100
     kr             =         4410
     ksmps          =         10
     nchnls         =         1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         BASIC KOTO ORCHESTRA FILE                              ;
;                                                                ;
;         P3 = DURATION        P4 = AMPLITUDE                    ;
;         P5 = PITCH IN PCH    P6 = PITCH BEND IN OCT.DECIMAL    ;
;                                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                    instr     1
     ihz            =         cpspch(p5)
     ihz2           =         ihz * 2.0006
     ihz3           =         ihz * 1.9999
     ihz4           =         ihz * 1.0005
     ihz5           =         ihz * .9998
     koct           init      octcps(ihz)
     koct2          init      octcps(ihz2)
     koct3          init      octcps(ihz3)
     koct4          init      octcps(ihz4)
     koct5          init      octcps(ihz5)
        kbend       oscil1i   0.00,p6,p3,4        ;    /* p6 in oct.decimal */
        khz         =         cpsoct(koct+kbend)
        khz2        =         cpsoct(koct2+kbend)
        khz3        =         cpsoct(koct3+kbend)
        khz4        =         cpsoct(koct4+kbend)
        khz5        =         cpsoct(koct5+kbend)
     ibuf           =         (p5 < 7.00 ? ihz : ihz/2)
     aplk1          pluck     (p4*.62),khz,ibuf,6,4,1, 1.003
                    timout    0.0,.002,continue
koto2:    aplk2     pluck     (p4*.52),khz2,ibuf,6,3,1
                    timout    0.0,.004,continue
koto3:    aplk3     pluck     (p4*.52),khz3,ibuf,6,3,1
                    timout    0.0,.005,continue
koto4:    aplk4     pluck     (p4*.62),khz4,ibuf,6,4,1, 1.001
                    timout    0.0,.007,continue
koto5:    aplk5     pluck     (p4*.62),khz5,ibuf,6,4,1, 1.001
continue:
     asignal        =         aplk1+aplk2+aplk3+aplk4+aplk5
     asig           envlpx    asignal,.06,p3,(p3*.1),7,.66,.008
                    out       asig
                    endin

</CsInstruments>
<CsScore>
;        PIANO SCORE FILE
;
;       SINE WAVE
f1 0.0 512 10 1
;       LINEAR RISE
f2 0.0 513 7  0 513 1
;       LINEAR FALL
f3 0.0 513 7  1 513 0
;       EXPONENTIAL RISE
f4 0.0 513 5 .001 513 1
;       EXPONENTIAL RISE
f5 0.0 513 5 1 513 .001
;    BUZZ-LIKE WAVE
f6 0.0 512 10 1 .5  .33  .25  .20  .167 .143
;    ATTACK FUNCTION
f7 0.0 513  8  0 100  0  28  0  200 1 185  1
;
;       INSTRUMENT CARDS
;
i1 0.00 5.0 18000 6.109  0.00
s
f0 1
s
i1 0.02 5.0 5500  9.110  0.00
i1 0.01 5.0 5500 10.080  0.00
i1 0.09 5.0 5500 10.090  0.00
i1 0.07 5.0 5500 11.010  0.00
i1 0.06 5.0 5500 11.020  0.00
i1 0.04 5.0 5500 11.060  0.00
i1 0.02 5.0 2500 10.110  0.00
i1 0.01 5.0 2500 11.080  0.00
i1 0.09 5.0 2500 11.090  0.00
i1 0.07 5.0 2500 12.010  0.00
i1 0.06 5.0 2500 12.020  0.00
i1 0.04 5.0 2500 12.060  0.00
s
e

</CsScore>
</CsoundSynthesizer>
