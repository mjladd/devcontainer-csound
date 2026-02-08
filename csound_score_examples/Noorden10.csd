<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Noorden10.orc and Noorden10.sco
; Original files preserved in same directory

sr = 44100
kr = 44100
ksmps  = 1
nchnls = 1

instr 1
iamp = ampdb(p4)
ifreq = p5
ifun = p6
kamp oscili iamp, 1/p3, ifun
asig oscil  kamp, ifreq, 1
 out asig
  endin
</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 7 0 30 1 452 1 30 0
;ins  start  dur   amp   freq   fun
i1      0     .1    80   1059    2
i1      +     .      .   1000    .
i1      1    .045    .    440    .
i1      +     .      .    466    .
i1      2     .      .   1271    .
i1      +     .      .   1200    .
endin
</CsScore>
</CsoundSynthesizer>
