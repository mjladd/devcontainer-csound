<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Q1.orc and Q1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          instr     107
a1        oscil     p4, p5, p6
          out       a1
          endin

          instr     108
a1        foscil    p4, p5, p6, p7, p8, p9
          out       a1
          endin

          instr     109
a1        buzz      p4, p5, p6, p7
          out       a1
          endin

          instr     110
a1        pluck     p4, p5, p6, p7, p8
          out       a1
          endin

          instr     111
a1        grain     p4, p5, p6, p7, p8, p9, p10, p11, p12
          out       a1
          endin

          instr     112
a1        loscil    p4, p5, p6
          out       a1
          endin


</CsInstruments>
<CsScore>
f1  0 4096 10   1


i109      1         1          10000         110       40  1
i109      2.5       1          10000         138.6     40  1
i109      4         1        10000      163.3     40  1
i109      5.5       1          10000         220       40  1
i109      7         1          10000         277.2     40  1
i109      8.5       1          10000         326.6   40  1
i109    10           1          10000        440     40  1
i109    11.5     1        10000     554.4   40  1
i109    13       1        10000     653.2   40  1
i109    14.5     1        10000     880     40  1
i109    16       1        10000     1108.8  40  1
i109    17.5     1        10000     1306.4  40  1
i109    19       1        10000     1760    40  1

</CsScore>
</CsoundSynthesizer>
