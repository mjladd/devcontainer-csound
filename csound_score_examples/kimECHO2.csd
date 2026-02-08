<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from kimECHO2.ORC and kimECHO2.SCO
; Original files preserved in same directory

        sr          =         44100
        kr          =         4410
        ksmps       =         10
        nchnls      =         2

;HAEYON KIM     5/15 1989
;BEESORT ORCHESTRA
;ECHO ORCHESTRA
;PLUCK+ECHO INSTRUMENT
;***************************************************************;
;p3=dur(sec),p4=pch,p5=amp,p6=pch bend(oct),p7=roughness factor ;
;p8=panning factor,p9=loop# per sec,p10=reverb  time            ;
;***************************************************************;

                    instr     1,2,3,4,5
        iamp        =         (p5*5000/127)+500        ;ACTUAL540-5500/SCORE1-127
        irvt        =         p10
        ilpt        =         1/p9
        ifreq       =         cpspch(p4)
        ishft1      =         ifreq*0.9999
        ishft2      =         ifreq*0.5555
        ishft3      =         ifreq*1.0009
        koctf       init      octcps(ifreq)
        kocts1      init      octcps(ishft1)
        kocts2      init      octcps(ishft2)
        kocts3      init      octcps(ishft3)
        kshape      oscil1    .17,p6,p3,4
        kfreq       =         cpsoct(koctf+kshape)
        kshft1      =         cpsoct(kocts1+kshape)
        kshft2      =         cpsoct(kocts2+kshape)
        kshft3      =         cpsoct(kocts3+kshape)

          if       (p8 != 0)  igoto panning

        ilfac       =         .707
        irfac       =         .707

                    igoto     perform

panning:

        ilfac       =         sqrt(p8)
        irfac       =         sqrt(1-p8)

perform:

        ating       pluck     iamp*.3,kfreq, ifreq, 5,1
        ating1      pluck     iamp*.3,kshft1,ishft1,13,1
        ating2      pluck     iamp*.3,kshft2,ishft2,5,3,p7
        ating3      pluck     iamp*.3,kshft3,ishft3,14,3,p7

continue:

        asum        =         ating+ating1+ating2+ating3
        acomb       comb      asum,irvt,ilpt
        asig        envlpx    acomb,.0001,p3,p3*.1,2,.888,.009
                    outs      asig*ilfac,asig*irfac
                    endin


</CsInstruments>
<CsScore>
;HAEYON KIM     5/15 1989
;BEESORT SCORE
; SINE WAVE
f01     0       512    10       1
; RAMP
f02     0       513     7       0       512     1
; EXPONENTIAL RISE
f03     0       513     5       1           512     .004
f04     0       513     5       .001       512     1
f05     0       513     9       10        1     0       16      1.5     0
; GEN1 DRAW WAVES
f06     0       32768     -1      1       0  4  0
f07     0       32768     -1      2       0  4  0
f08     0       32768     -1      6       0  4  0
f09     0       32768     -1      7      0   4  0
f10     0       32768     -1      5       0  4  0
; REVERSE PYRAMID
f11     0       513     7       1       256     0       256     1
; TRIANGULAR WAVE
f12     0       512     10      1   0  .111   0  .04    0  .02    0  .012
; SAWTOOTH WAVE
f13     0       512     10      1  .9  .8   .7   .6   .5  .4   .3   .2   .1
; SQUARE WAVE
f14     0       512     10      1   0   .3   0   .2    0  .14    0 .111
; NARROW PULSE
f15     0       512     10      1 1  1   1 .7 .5 .3 .1
; EXPONENTIAL RISE AND DECAY
f16     0       513     5       .1      32      1       480     .01
; EXPONENTIAL RISE AND DECAY
f17     0       513     5       .0001    256     1       256     .0001
;***************************************************************;
;p3=dur(sec),p4=pch,p5=amp,p6=pch bend(oct),p7=roughness factor ;
;p8=panning,p9=loop# per second,p10=reverb  time                ;
;***************************************************************;
;SCORE (INSTR 1,2,3,4,5 )
;p1  p2   p3   p4   p5   p6   p7   p8   p9   p10

i1     0.00    0.5  7.00 100  0.00 0.01 0.002     10   2
i1     0.25    0.5  7.06
i1     0.37    0.5  7.05
i1     0.62    0.5  7.06
i1     0.75    0.5  7.05 .    .    .    0.888     5    1
i1     1.00    0.5  7.00
i1     1.25    0.5  7.06
i1     1.37    0.5  7.05
i1     1.62    0.5  7.06 .    -0.22     0.03 0.002     .    .
i1     1.75    0.5  7.05
i1     2.00    0.5  7.02
i1     2.25    0.5  7.09 50   0.10 0.05 0.888     5    2
i1     2.50    0.5  7.08
i1     2.75    0.5  7.07 .    .    .    0.002     .    1
i1     3.00    0.5  7.06
e


</CsScore>
</CsoundSynthesizer>
