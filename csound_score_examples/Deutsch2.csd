<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Deutsch2.orc and Deutsch2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         44100
ksmps     =         1
nchnls    =         2



          instr 1
iamp      =         ampdb(p4)
ifreq1    =         p5
ifreq2    =         p6
ifun      =         p7
kamp      oscili    iamp, 1/p3, ifun
asig1     oscil     kamp, cpspch(p5), 1
asig2     oscil     kamp, cpspch(p6), 1
          outs      asig1, asig2
          endin

</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 5 .001 40 1 432 1 40 .001

;ins  start   dur   amp  freq1  freq2 fun
;------------------------------------------
i1      0    .25    80   8.00   9.00   2
i1      +     .     .    8.11   8.02   .
i1      +     .     .    8.04   8.09   .
i1      +     .     .    8.07   8.05   .
i1      +     .     .    8.05   8.07   .
i1      +     .     .    8.09   8.04   .
i1      +     .     .    8.02   8.11   .
i1      +     .     .    9.00   8.00   .
i1      +     .     .    8.00   9.00   .
i1      +     .     .    8.11   8.02   .
i1      +     .     .    8.04   8.09   .
i1      +     .     .    8.07   8.05   .
i1      +     .     .    8.05   8.07   .
i1      +     .     .    8.09   8.04   .
i1      +     .     .    8.02   8.11   .
i1      +     .     .    9.00   8.00   .
endin

</CsScore>
</CsoundSynthesizer>
