<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from cannon.orc and cannon.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


instr 5
     a1   linrand   20000
     out  a1
endin

instr 4
     a1   trirand   20000
     out  a1
endin

instr 3
     a1   gauss     20000
     out  a1
endin

instr 2
     a1   weibull   250, .5
     out  a1
endin

instr 1
     a1   betarand 20000, .5, .5
     out  a1
endin

</CsInstruments>
<CsScore>
f1 0 1024 21 1
f2 0 1024 21 2 1
f3 0 1024 21 3 1
f4 0 1024 21 4 1
f5 0 1024 21 5 1
f6 0 1024 21 6 1
f7 0 1024 21 7 1
f8 0 1024 21 8 1
f9 0 1024 21 9 1 1 2
f10 0 1024 21 10 1 2
f11 0 1024 21 11 1

i1 0 2
s
i2 1 2
s
i3 1 2
s
i4 1 2
s
i5 1 2
e

</CsScore>
</CsoundSynthesizer>
