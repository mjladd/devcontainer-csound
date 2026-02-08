<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from harRESON.ORC and harRESON.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1


instr          1
k1             envlpx    p5,p6,p3,p7,1,.8,.01
k1             =         k1 * p5
asig           soundin   p4,p8
asig           =         k1 * asig
asig2          reson     asig,p9, p10, 1
out            asig2
endin

</CsInstruments>
<CsScore>
f1 0 1025 5 .01 1024 1
  i1 0.000 6.000 5 0.800 0.010 2 0 330 20
end of score

</CsScore>
</CsoundSynthesizer>
