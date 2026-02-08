<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from HARMDIST.ORC and HARMDIST.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         22050
ksmps     =         2
nchnls    =         2


; HARMONIC DISTORTION
          instr     2

iamp      =         p4
ifqc      =         cpspch(p5)
itabf     =         p6
itab1     =         p7
itab2     =         p8
itab3     =         p9
itab4     =         p10
ifrms     =         40

kamp      linseg    0, .1*p3, iamp, .7*p3, iamp/2, .2*p3, 0

aoscf     oscil     kamp, ifqc, 1
aosc1     oscil     kamp, ifqc*2, 1
aosc2     oscil     kamp, ifqc*3, 1
aosc3     oscil     kamp, ifqc*4, 1
aosc4     oscil     kamp, ifqc*5, 1


krms      rms       aosc1, ifrms
kndx      =         krms/16000

ksclf     tablei    kndx, itabf, 1
kscl1     tablei    kndx, itab1, 1
kscl2     tablei    kndx, itab2, 1
kscl3     tablei    kndx, itab3, 1
kscl4     tablei    kndx, itab4, 1
aoutl     =         aoscf*ksclf+aosc1*kscl1+aosc2*kscl2+aosc3*kscl3+aosc4*kscl4
aoutr     =         aoscf*ksclf+aosc1*kscl1+aosc2*kscl2+aosc3*kscl3+aosc4*kscl4

          outs      aoutl, aoutr

          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
; FUNDAMENTAL
f2 0 8193 -8 1 2048 1 2048 .3 2048 0  2049  0
; FIRST HARMONIC
f3 0 8193 -8 0 4096 .7 2048 .2  2049  0
; SECOND HARMONIC
f4 0 8193 -8 0 4096 .1 3072 .6  1025  0
; THIRD HARMONIC
f5 0 8193 -8 0 4096 .01 3072 .05  512 .5 256 .05 257  0
; FOURTH HARMONIC
f6 0 8193 -8 0 4096 .05 3072 .01  512 .02 256 .4 257  0

;   Sta  Dur  Amp     Pitch  Fund  First  Second  Third  Fourth
i2  0.0  1    20000   9.00   2     3      4       5      6
i2  0.5  1    20000   8.05   .     .      .       .      .
i2  1.0  1    20000   7.07   .     .      .       .      .
i2  1.5  1    20000   6.00   .     .      .       .      .

</CsScore>
</CsoundSynthesizer>
