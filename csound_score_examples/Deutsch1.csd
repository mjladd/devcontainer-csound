<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Deutsch1.orc and Deutsch1.sco
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
asig1     oscil     kamp, ifreq1, 1
asig2     oscil     kamp, ifreq2, 1
          outs      asig1, asig2
          endin

</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 7 0 30 1 452 1 30 0

;ins  start  dur   amp  freq1  freq2  fun
;------------------------------------------
i1      0    .25   80   800    400      2
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
i1      +         .      .     800    400
i1      +         .      .     400    800
endin

</CsScore>
</CsoundSynthesizer>
