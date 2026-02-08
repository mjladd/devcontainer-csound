<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from butter.orc and butter.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1
kfreq     linseg    0, p3/2, 5000, p3/2, 0
anois     rand      10000
afil      butterlp  anois, kfreq
          out       afil
          endin

          instr     2
kfreq     linseg    0, p3/2, 10000, p3/2, 0
anois     rand      10000
afil      butterhp  anois, kfreq
          out       afil
          endin

          instr     3
kfreq     oscil     1, 1/p3, 1
kband     =         100
anois     rand      10000
afil      butterbp  anois, kfreq, kband
          out       10*afil
          endin

          instr     4
kfreq     =         5000
kband     linseg    0, p3/2, sr/2, p3/2, 0
anois     rand      10000
afil      butterbr  anois, kfreq, kband
          out       afil
          endin

          instr     5
kfreq     oscil     1, 1/p3, 1
anois     rand      10000
afil      butterlp  anois, kfreq
afil2     butterbp  afil, kfreq, 50
          out       (10*afil2 + afil)
          endin

</CsInstruments>
<CsScore>
f1 0 1024 -7 0 125 3000 125 0 125 5000 125 200 125 7000 399 0

i1        0    4
s
i2        1    4
s
i3        1    4
s
i4        1    4
s
i5        1    4
e

</CsScore>
</CsoundSynthesizer>
