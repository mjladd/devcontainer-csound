<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Noorden8.orc and Noorden8.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1
iamp      =         ampdb(p4)
ifreq     =         p5
irate     =         p6
ifun      =         p7

krate     oscili    10, 1/p3, 3
kamp      oscili    iamp, irate + krate, ifun
kfreq     randh     59, p6 + krate
asig1     oscil     kamp, ifreq + kfreq, 1
asig      butterlp  asig1, 1800
          out       asig
          endin

</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 7 0 30 1 452 1 30 0
f3 0 512 7 0 512 1
;ins  start  dur  amp   freq   rate  fun
i1     0     10   80    1000    5     2
endin

</CsScore>
</CsoundSynthesizer>
