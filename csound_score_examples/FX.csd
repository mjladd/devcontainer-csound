<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FX.orc and FX.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


;CROSS CHORUS (WORKS GOOD)


          instr     101

idur      =         p3
iamp      =         p4
ifrq      =         p5
ifun      =         p6
iatt      =         P7
irel      =         p8

kenv      oscil     p4,1/p3,6
kup       line      1*0.99, idur, 1*1.01
kdown     line      1*1.01, idur, 1*0.99
asig3     oscil     kenv, ifrq*kup, ifun               ; DETUNED FROM FLAT TO SHARP
asig2     oscil     kenv, ifrq*kdown, ifun             ; DETUNED FROM SHARP TO FLAT
asig1     oscil     kenv, ifrq, ifun ; real note
amix      =         asig1 + asig2 +asig3

          out       amix

          display   kenv, idur
          endin

;FOR SOME REASON IT MAKES THE COMPUTER CRASH BIG TIME.

          instr     102

idur      =         p3
iamp      =         ampdb(p4)
ifrq      =         cpspch(p5)
ifun      =         p6
iatt      =         p7
irel      =         p8
iattfun   =         p9
icar      =         p10
imod      =         p11
index1    =         p12
index2    =         p13
kenv      oscil     p4,1/p3,6                          ; ENVELOPE
kmodswp   expon     index1, i dur, index2              ; INDEX OF MOD SWEEP IN FOSCIL OPCODE
kbuzswp   expon     20 ,idur, 1                        ; MOD OF NUMBER OF HARMONICS IN THE BUZZ OPCODE
asig3     foscil    kenv, ifrq, p10, p11, kmodswp, ifun
asig2     buzz      kenv, ifrq*0.99, kbuzswp+1, ifun
asig1     pluck     kenv, ifrq*0.5, ifrq, 0, 1

amix      =         asig1 + asig2 + asig3
          out       amix
          dispfft   amix, 0.25, 1024
          endin

</CsInstruments>
<CsScore>
f 1  0  4096  10  1; SINE

f 2  0  4096  10  1  0.5  .3333333  .25  .2  .1666666  .1428571  .125  .1111111  .1  .090909  .0833333  .076923  .0714285  .0666666
                                         .0625  .0588235  .0555555  .0526315  .05  .047619  .0454545  .0434782  .0416666 ; SAWTOOTH
f 3  0  8192  20  2   1

f 6  0  1024  7  0  10  1  1000  1  14  0                    ;LINEAR AR ENVELOPE

f 7  0  1024  7  0  128  1  128  .6  512  .6  256  0         ;LINEAR ADSR ENVELOPE

f 8  0  1024  5  .001  256  1  192  .5  256  .5  64  .001    ;EXPONENTIAL ADSR


; p1   p2   p3   p4      p5      p6       p7     p8     p9     p10     p11    p12    p13
;==========================================================================================
i 101   0   5   10000    440      2       .5      2

;i 102   6   10   10000    440     1       .5      2     0.5     1      0.5    0.5     8

</CsScore>
</CsoundSynthesizer>
