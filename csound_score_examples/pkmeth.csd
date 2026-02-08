<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pkmeth.orc and pkmeth.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
a1        pluck     p4,p5,p5,0,1,0,0         ; p4=AMP, p5=FREQ
          out       a1
          endin

          instr 2
a1        pluck     p4,p5,p5,0,2,p6,0        ; p4=AMP, p5=FREQ, p6=SMOOTHFAC
          out       a1
          endin

          instr 3
a1        pluck     p4,p5,p5,0,3,p6,0        ; p4=AMP, p5=FREQ, p6=GRAINFAC
          out       a1
          endin

          instr 4
a1        pluck     p4,p5,p5,0,4,p6,p7
          out       a1
          endin

          instr 5
a1        pluck     p4,p5,p5,0,5,p6,p7
          out       a1
          endin

          instr 6
a1        pluck     p4,p5,p5,0,6,0,0
          out       a1
          endin

</CsInstruments>
<CsScore>
i1 0 1 3000 80
i1 1 1 3000  160
i1 2 1  3000 240
i1 3 1  3000 320
i1 4 1 3000  400
i1 5 1 3000 480
i1 6 1 3000 540
i1 7 1 3000  620
i1 8 1  3000  700
i1 9 1 3000  780

i2 10 1 3000 80 1
i2 11 1   3000 160 1.1
i2 12 1   3000 240 1.2
i2 13 1   3000 320 1.3
i2 14 1        400 1.4
i2 15 1        480 1.5
i2 16 1        540 1.6
i2 17 1        620 1.7
i2 18 1        700 1.8
i2 19 1   3000 800 1.9
i2 20 1        900 2.
i2 21 1        240 3
i2 22 1        240 4
i2 23 1        240 5
i2 24 1        240 6
i2 25 1        240 7
i2 26 1        240 8
i2 27 1        240 9
i2 28 1        240 10
e

</CsScore>
</CsoundSynthesizer>
