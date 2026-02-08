<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from TOKBOX.ORC and TOKBOX.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1


               instr     1

  ifqc         =         cpspch(p5)
  itab         =         p6

  kampenv      linseg    0, .02, p4, p3-.04, p4, .02, 0
  ksweep       linseg    .5, 1, 6, .5, .5, .2, .4

  kform1       oscil     1, ksweep, 10
  kform2       oscil     1, ksweep, 11
  kform3       oscil     1, ksweep, 12
  kform4       oscil     1, ksweep, 13

  asig         oscil     kampenv, ifqc, itab

  ares1        reson     asig, kform1, 100
  ares2        reson     asig, kform2, 150
  ares3        reson     asig, kform3, 300
  ares4        reson     asig, kform4, 500

  aresbal1     balance   ares1, asig
  aresbal2     balance   ares2, asig
  aresbal3     balance   ares3, asig
  aresbal4     balance   ares4, asig

               out       aresbal1*25.4+aresbal2*22.5+aresbal3*9.2+aresbal4*7.9

endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 1024 7  1 64 1 0 -1 960 -1

; FORMANTS
; AHH/OOOH
f10 0 1024 -7 722  256 722  256 266  256 266  256 722
f11 0 1024 -7 1216 256 1216 256 1292 256 1292 256 1216
f12 0 1024 -7 2433 256 2433 256 2281 256 2281 256 2433
f13 0 1024 -7 3193 256 3193 256 3421 256 3421 256 3193

i1 0 2 100  8.00 2
i1 0 2 100  8.05 2
i1 0 2 100  9.00 2

i1 2 2 100  7.00 2
i1 2 2 100  7.05 2
i1 2 2 100  8.00 2

</CsScore>
</CsoundSynthesizer>
