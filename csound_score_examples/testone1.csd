<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from testone1.orc and testone1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 12
kph       phasor    100                      ;PHASES 0-1 100 TIMES/SECOND
ilength   =         ftlen(p4)
kph       =         kph*ilength
a1        table     kph, p4
k1        downsamp  a1
          out       a1*20000
          printks   "address=%6.4f\t value=%6.4f\n", .01, kph, k1, 0, 0
          display   a1, .01
          endin

</CsInstruments>
<CsScore>
f1  0   4096    10  1 ;sine
f2  0   1024    10  1 ;sine
f3  0   128     10  1 ;sine
f4  0   16      10  1 ;sine
f5  0   8       10  1 ;sine

i12   0     1   1
i12   2     1   2
i12   4     1   3
i12   6     1   4
i12   8     1   5

</CsScore>
</CsoundSynthesizer>
