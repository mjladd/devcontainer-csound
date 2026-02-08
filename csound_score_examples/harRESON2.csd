<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from harRESON2.ORC and harRESON2.SCO
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
asig3          reson     asig,p11, p12, 1
               out       asig2 + asig3
endin

</CsInstruments>
<CsScore>
f1 0 1025 5 .01 1024 1
f2 0 1025 5 .01 512 1 512 .01
  i1 0.000 3.000 5 1.000 0.010 2 0 50 1500 2 2092.990
end of score

</CsScore>
</CsoundSynthesizer>
