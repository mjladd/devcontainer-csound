<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FIG3_26.ORC and FIG3_26.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


;=======================================================================;
; FIG3_26         Drum Instrument based on Risset  (Dodge p. 93-94)     ;
;                 Coded by Thomas Dimeo                                 ;
;                 Brooklyn College Computer Music Studio                ;
;=======================================================================;
         instr      1
i1        =         1/p3
i2        =         cpspch(p5)
i3        =         p4/2
i4        =         p4/6
i5        =         p4/2.5

k1        oscili    i3,i1,2
a1        randi     k1,400
a1        oscili    a1,500,3
a2        oscili    i4,i1,2
a2        oscili    a2,i2/10,4
a3        oscili    i5,i1,1
a3        oscili    a3,i2,3
          out       a1+a2+a3
          endin

</CsInstruments>
<CsScore>
;=======================================================================;
; FIG3_26         Score for Drum Instrument based on Risset             ;
;=======================================================================;
; exponential decay 1
f1    0    512    5   1  512  .004
; exponential decay 2
f2    0    512    5   1  512  .00012
; sine
f3    0    512    9   1    1   0
; inharmonic
f4    0    512    9   10   1   0   16  1.5  0  22  2   0   23  1.5  0
;=======================================================================;
; FIG3_26             p4       p5                                       ;
;                     amp      pch                                      ;
;=======================================================================;
i1    0.00    0.25    24000    5.00
i1    0.25    0.25    24000    5.00
i1    0.50    0.25    24000    5.00
i1    0.75    0.25    24000    5.00
i1    1.00    0.25    24000    6.00
i1    1.25    0.25    24000    6.00
i1    1.50    0.25    24000    6.00
i1    1.75    0.25    24000    6.00
i1    2.00    0.25    24000    7.00
i1    2.25    0.25    24000    7.00
i1    2.50    0.25    24000    7.00
i1    2.75    0.25    24000    7.00
i1    3.00    0.25    24000    8.00
i1    3.25    0.25    24000    8.00
i1    3.50    0.25    24000    8.00
i1    3.75    0.25    24000    8.00
i1    4.00    0.25    24000    9.00
i1    4.25    0.25    24000    9.00
i1    4.50    0.25    24000    9.00
i1    4.75    0.25    24000    9.00
i1    5.00    0.25    24000   10.00
i1    5.25    0.25    24000   10.00
i1    5.50    0.25    24000   10.00
i1    5.75    0.25    24000   10.00
e

</CsScore>
</CsoundSynthesizer>
