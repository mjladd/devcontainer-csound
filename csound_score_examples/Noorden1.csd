<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Noorden1.orc and Noorden1.sco
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
kamp      oscili    iamp, irate, ifun
asig      oscil     kamp, ifreq, 1
          out       asig
          endin

</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 7 0 103 1 50 1 103 0 256 0
f3 0 512 7 0 256 0 103 1 50 1 103 0
;ins  start  dur   amp   freq   rate  fun
i1      0    10    80    1000   5     2
i1      0    10    80    1059   5     3
endin

</CsScore>
</CsoundSynthesizer>
