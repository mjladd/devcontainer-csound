<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from nestedap.orc and nestedap.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2



          instr     5

insnd     =         p4

gasig     diskin    insnd, 1

          endin

          instr     10

imax      =          1
idel1     =          p4
igain1    =         p5
idel2     =         p6
igain2    =         p7
idel3     =         p8
igain3    =         p9
idel4     =         p10
igain4    =         p11
idel5     =         p12
igain5    =         p13
idel6     =         p14
igain6    =         p15

afdbk     init      0

aout1     nestedap  gasig+afdbk*.4, 3, imax, idel1, igain1, idel2, igain2, idel3, igain3
aout2     nestedap  aout1, 2, imax, idel4, igain4, idel5, igain5
aout      nestedap  aout2, 1, imax, idel6, igain6
afdbk     butterlp  aout, 1000

          outs      gasig+(aout+aout1)/2, gasig-(aout+aout1)/2
gasig     =         0


          endin

          instr     20

ksv       =         p4
krv       =         p5
kbv       =         p6

ax, ay, az lorenz ksv, krv, kbv, .01, .6, .6, .6, 1

          outs      ax*1000, ay*1000

          endin

          instr     30

iamp      =         p4
ifqc      =         cpspch(p5)

kfco      linseg    300, .1, 2000, .2, 700, p3-.3, 600

ax        vco       1, ifqc, 2, 1, 1, 2/ifqc
ay        moogvcf   ax, kfco, 2, 2

          outs      ay*iamp, ay*iamp

          endin



</CsInstruments>
<CsScore>
f1 0 8192 10 1

; DISKIN
;   Sta  Dur  Soundin
;i5  0    3    1

; REVERB
;   Sta  Dur  Del1 Gain1 Del2 Gain2  Del3 Gain3 Del4 Gain4 Del5 Gain5 Del6 Gain6
;i10 0    4    97   .11   23   .07    43   .09   72   .2    53   .2    119  .3

; LORENZ SYSTEM
;   Sta  Dur  S   R  V
;i20 0    1    10  28  2.667

; MOOGVCF WITH DISTORTION
i30  0   1   20000   7.00

</CsScore>
</CsoundSynthesizer>
