<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tootp2.orc and tootp2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



                                   ; toot1.orc

          instr     1
kenv      oscil     p4,  1 / p3 , 2                         ; p4=max, p3=note dur
kven      oscil     p6,  1 / p3,   3                        ; p6=max
kpen      line      p8, p3, p9                              ;p8,p9=start/stop line lvl
klfo      oscil     p10, p11, 1                             ;p10=chorus detune p11=chorus freq
amod      oscil      kven, p7 + kpen, 1                ; p7=modf
a1        oscil     kenv, p5 + kpen + amod, 1          ; p5=note freq
a2        oscil     p12 * kenv, p5 + kpen + amod + klfo, 1
          out       a1 + a2
          endin

</CsInstruments>
<CsScore>
;p3=notedur p4=noteamp p5=notefreq p6=modamp p7=modf
;p8,p9=line levels
                                             ;FUNCTIONS
f1 0 4096 10 1
f2 0 1024 7 0 4 2 20 1 100 .7 500 .5 400 0
f3 0 1024 7 0 4 1.5 20 .8 200 .33 600 0 200 2

                                             ;NOTE LIST
;p1 p2 p3 p4     p5   p6      p7   p8  p9
i1  0  3  10000  880  10000  1000  0  -100 5 10 1
i1  2  6  10000  550  10000  1000  0  -1000 5 6 1

e

</CsScore>
</CsoundSynthesizer>
