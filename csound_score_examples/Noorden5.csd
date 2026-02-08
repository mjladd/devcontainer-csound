<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Noorden5.orc and Noorden5.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1

iamp      =         ampdb(p4)
ifreq     =         p5
irate     =         p6
ifun      =         p7
ifun2     =         p8

kamp      oscili    iamp, irate, ifun
asig      oscil     kamp, ifreq, ifun2
          out       asig
          endin

</CsInstruments>
<CsScore>
f1 0 256 10 1
f2 0 512 5 .001 103 1 50 1 103 .001 256 .001
f3 0 512 5 .001 256 .001 103 1 50 1 103 .001
f4 0 512 10 3 4 5 6 7 8 9 10 11 12
;ins  start  dur  amp   freq   rate  fun fun2
i1     0     10   80    200     5     2   1
i1     0     10   80    200     5     3   4
endin

</CsScore>
</CsoundSynthesizer>
