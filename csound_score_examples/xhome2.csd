<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from xhome2.orc and xhome2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


                                   ; TOOT1.ORC


          instr 1

ifreq     =         cpspch( p5)
imodrat   =         ifreq * 100 / 88

kenv      oscil     p4,       1 / p3 ,  2
kmen      oscil     p6,       1 / p3,        3
kpeg      oscil     p7,       1 / p3,        4
klfo      oscil     p10, p11,      1
kvib      oscil     p8,       p9 + kmen ,    1

a2mod     oscil     p14 * kmen, p13 * imodrat, 1
amod      oscil      kmen, imodrat + a2mod, 1
a1        oscil     kenv, ifreq + amod + kpeg + kvib, 1
a2        oscil     p12 * kenv, ifreq + amod + klfo + kpeg + kvib, 1
          out       a1 + a2
          endin
;p4=aamp p5=afreq p6=mamp p7=pamp p8=vamp p9=vfreq
;p10=champ p11=chfreq p12=chmix p13=m2amp

</CsInstruments>
<CsScore>


t 0 120

                                             ;FUNCTIONS
f1 0 4096 10 1
f2 0 1024 7 0 4 2 20 1 100 .7 500 .5 400 0
f3 0 1024 7 0 4 1.5 20 .8 200 .33 600 0 200 2
f4 0 1024 7 1 74 0 950 0
                                             ;NOTE LIST
;p1  p2   p3   p4        p5     p6  p7    p8 p9

i1   0    1.7  10000     9.00  10000  -200  5  2  5  6 1 1.2 .3
i1   1.5  .7   10000     8.07  10000  -200  5  2  5  6 1 1.2 .3
i1   2    .7   10000     8.06  10000  -200  5  2  5  6 1 1.2 .3
i1   2.5  .7   10000     8.07  10000  -200  5  2  5  6 1 1.2 .3
i1   3    1.7  10000     8.08  10000  -200  5  2  5  6 1 1.2 .3
i1   4.5  1.7  10000     8.07  10000  -200  5  2  5  6 1 1.2 .3
i1   7.5  1.7  10000     8.07  10000  -200  5  2  5  6 1 1.2 .3
i1   9    1.7  10000     9.00  10000  -200  5  2  5  6 1 1.2 .3
i1   12   10   10000     8.01  10000  -200  5  2  5  6 1 1.2 .3
e

</CsScore>
</CsoundSynthesizer>
