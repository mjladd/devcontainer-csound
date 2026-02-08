<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 48REP.ORC and 48REP.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

; FIG 4.8.REP.ORC

instr          1
i1             =         1/p3
i2             =         cpspch(p4)
i3             =         i1*p6
i4             =         i3*p7

a1             oscil     p5,i1,2
a2             oscil     i4,i1,1
a2             oscili    a2,i3,3
a1             oscili    a1,i2+a2,3

out            a1

endin

</CsInstruments>
<CsScore>
c fig 4.8.rep.scr
f 1 0 512 5 1 512 .001
f 2 0 512 7 1 64 0 448 0
f 3 0 512 9 1 1 0
  i1 0.000 0.750 8.00 20000 1.400 10
  i1 0.750 0.250 8.00 20000 1.400 10
  i1 1.000 1.000 8.00 20000 1.400 10
  i1 2.000 0.250 8.00 20000 1.400 10
  i1 2.250 0.250 8.00 20000 1.400 10
  i1 2.500 0.250 8.00 20000 1.400 10
  i1 2.750 0.250 8.00 20000 1.400 10
  i1 3.000 2.000 8.00 20000 1.400 10
  i1 5.000 0.500 8.00 20000 1.400 10
  i1 5.500 0.500 8.00 20000 1.400 10
  i1 6.000 0.500 8.00 20000 1.400 10
  i1 6.500 0.750 8.00 20000 1.400 10
  i1 7.250 0.250 8.00 20000 1.400 10
end of score

</CsScore>
</CsoundSynthesizer>
