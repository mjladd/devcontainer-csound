<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ex7.orc and ex7.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;-- ex7.orc

          instr     1
arand     rand      0.5,0.213
asig      table     0.5 + arand,1,1,0,0
          out       asig
          endin

</CsInstruments>
<CsScore>
;-- ex7.sco

f1 0 8193 21 8 1; Gaussian
f2 0 8193 21 8 100

i1 0 3

</CsScore>
</CsoundSynthesizer>
