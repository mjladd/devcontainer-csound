<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from xhome3.orc and xhome3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          instr     1

ifreq     =         cpspch(p4)                              ;p4 = note
ifreq1    =         ifreq * p5                              ;p5,p6,p7 = carrier ratio
ifreq2    =         ifreq * p6
ifreq3    =         ifreq * p7

kc1eg     oscil     p11, 1 / p3, 2      ;p11-p16 = op amplitude
kc2eg     oscil     p12, 1 / p3, 4
kc3eg     oscil     p13, 1 / p3, 6

km1eg     oscil     p14, 1 / p3, 3
km2eg     oscil     p15, 1 / p3, 5
km3eg     oscil     p16, 1 / p3, 7

am1       oscil     km1eg,    p8 * ifreq1, 1 ;p8,p9,p10 = c:m ratio
am2       oscil     km2eg,    p9 * ifreq2, 1
am3       oscil     km3eg,    p10 * ifreq3, 1

ac1       oscil     kc1eg,    ifreq1 + am1, 1
ac2       oscil     kc2eg,    ifreq2 + am2, 1
ac3       oscil     kc3eg,    ifreq3 + am3, 1

          out       ac1 + ac2 + ac3
          endin

</CsInstruments>
<CsScore>
t 0 120

                                             ;FUNCTIONS
f1 0 4096 10 1
f2 0 4096 7 0 40 1 750 .7 330 0
f3 0 4096 7 0 50 1 550 .7 220 0
f4 0 4096 7 0 50 1 800 .9 500 0
f5 0 4096 7 0 50 1 700 .9 500 0
f6 0 4096 7 0 50 1 800 .9 500 0
f7 0 4096 7 0 50 1 700 .9 500 0

                                             ;NOTE LIST

i1   0    1.7       9.00 1    1    1    12   1    1    950  800  950  890  950  850
i1   1.5  .7        8.07 1    1    1    12   1    1    950  800  950  890  950  850
i1   2    .7        8.06 1    1    1    12   1    1    950  800  950  890  950  850
i1   2.5  .7        8.07 1    1    1    12   1    1    950  800  950  890  950  850
i1   3    1.7       8.08 1    1    1    12   1    1    950  800  950  890  950  850
i1   4.5  1.7       8.07 1    1    1    12   1    1    950  800  950  890  950  850
i1   7.5  1.7       8.07 1    1    1    12   1    1    950  800  950  890  950  850
i1   9    1.7       9.00 1    1    1    12   1    1    950  800  950  890  950  850
i1   12   10        8.01 1    1    1    12   1    1    950  800  950  890  950  850

</CsScore>
</CsoundSynthesizer>
