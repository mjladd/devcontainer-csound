<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WEBFIN.ORC and WEBFIN.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; CELLO INSRUMENT

          instr 1
iamp      =         p5
ifreq     =         cpspch(p4)
iarand    =         .009
ifrand    =         3
ifvib     =         3
ilfac     =         sqrt(p9)
irfac     =         sqrt(1-p9)
iat       =         p6*2.1
idec      =         p7*2.1
aresig    =         0

krand     randi     iarand, ifrand, -1
kvib      oscil     krand, ifvib, 1
acelsig   foscili   iamp, ifreq*(1+kvib), p10, p11, p12, 1
asig1     envlpx    acelsig, iat, p3-p13-.1, idec, 2, p8, .01
          if        (p13=0)goto continue
aresig    reverb    asig1, p13
continue:
          outs      (asig1*ilfac)+(aresig*.5), (asig1*irfac)+(aresig*.5)

          endin

; CELLO TRILL INSRUMENT

          instr 2
iamp      =         p5
ifreq     =         cpspch(p4)
ilfac     =         sqrt(p9)
irfac     =         sqrt(1-p9)
iat       =         p6*2.1
idec      =         p7*2.1
ihnote    =         cpspch(p4+.02)
itrate    =         6
ktrill    init      0

          timout    0, .2, notrill
ktrill    oscil     ihnote-ifreq, itrate, 6
notrill:
acetsig   foscili   iamp, ifreq+ktrill, p10, p11, p12, 1
atsig1    envlpx    acetsig, iat, p3, idec, 2, p8, .01
          outs      atsig1*ilfac, atsig1*irfac

          endin

; PIANO INSTRUMENT (TREBLE)

          instr 3
ifamp     =         .3
ivibamp   =         .3
iamp      =         (1- ivibamp)- ifamp
ifreq     =         cpspch(p4)
ifunc     =         4
iarand    =         .0075
ifreqrand =         15
ifreqvib  =         p8
ifrise    =         .02
iat       =         .01
idec      =         p6*2.1

kfgate    oscil1i   0, ifamp, ifrise, 8
kgate     envlpx    p5, iat, p3, idec, 3, p7, .01
krand     randi     iarand, ifreqrand, -1
kvib      oscil     krand+1, ifreqvib+krand, 1
aform     oscili    kfgate, ifreq*2, 9
avibpt    oscili    ivibamp*kvib, ifreq, ifunc
apiano1   oscili    iamp, ifreq, ifunc
          outs      (avibpt+apiano1)*kgate+(aform*p5), (apiano1*kgate)*.1
          endin

; PIANO INSTRUMENT (BASS)

          instr 4
ifamp     =         .3
ivibamp   =         .2
iamp      =         (1- ivibamp)- ifamp
ifreq     =         cpspch(p4)
ifunc     =         5
iarand    =         .01
ifreqrand =         15
ifreqvib  =         p8
ifrise    =         .02
iat       =         .01
idec      =         p6*2.1

kfgate    oscil1i   0, ifamp, ifrise, 8
kgate     envlpx    p5, iat, p3, idec, 3, p7, .01
krand     randi     iarand, ifreqrand, -1
kvib      oscil     krand+.2, ifreqvib+krand, 1
aform     oscili    kfgate, ifreq, 7
avibpb    oscili    ivibamp*kvib, ifreq, ifunc
apiano2   oscili    iamp, ifreq, ifunc

          outs      (apiano2*kgate)*.1, (avibpb+apiano2)*kgate+(aform*p5)

          endin

</CsInstruments>
<CsScore>

f01     0       513     10      1
f02     0       129     6       0       64      .5      128     1
f03     0       129     9       .4      1       0
f04     0       512     10      1       .8      .4      1       0       .1      0       1       0       0       0       0       0       0       0       1
f05     0       512     10      1       .1      .4      .1      .2      .3      .4      .3      .2      .1
f06     0       128     7       0       59      0       4       1       59      1       4       0
f07     0       512     10      0       0       .4      0       0       .2      0       .1      .2      .3      .4      .5      .6      .7      .8      .9
f08     0       129     9       .5      1       0
f09     0       512     10      0       .2      1       .2      0       .5      0       .1      .2      .3      .4      .5

t0      25

f0      0       1

i02     1       2.01    6.03    1000    .1      .01     7       .1      2       3       1       0
i01     2.95    2.043   8.00    7000    .05     .03     .2      .2      3       5       7       .6
i01     4.283   1.018   6.11    4000    .05     .03     .5      .3      2       3       2       .2
i01     4.95    1.75    6.10    2000    .05     1       1       .4      1       2       1       .1
i01     10      3       8.05    3000    1.4     1.4     1       .5      4       5       3       0
i01     16      1.8     8.09    2000    .45     .02     1       .6      3       4.0001  3       1
i01     17.5    2.1     9.02    1500    .9      .02     1       .7      2       3.001   2       2
i01     19      8.1     10.01   1000    .3      4       1       .8      1       2.01    1       3

i03     3.5     2.5     7.02    8000    .5      .6      4
i03     6.666   1.667   7.06    .       .       .       4.5
i03     8.333   .667    6.08    10000   .       .       3
i03     9       4       7.07    12000   .       .       5
i03     9.666   3.334   7.03    12000   .       .       4.3
i03     14.333  3.667   6.11    8000    .       .       3
i03     14.333  3.667   6.06    8000    .       .       2.7

i04     3.5     2.5     6.01    8000    .5      .7      3
i04     3.5     2.5     5.05    .       .       .       2.9
i04     9.666   3.334   5.04    12000   .       .       2.7
i04     14.333  3.667   6.00    8000    .       .       2.9
i04     14.333  3.667   5.10    .       .       .       2.8

e



</CsScore>
</CsoundSynthesizer>
