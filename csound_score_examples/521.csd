<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 521.ORC and 521.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; FIG 5.21.orc

          instr 1
i1        =         1/p3
a1        rand      p5
k1        oscil     1.,i1,4
k1        =         k1*p4
k2        oscil     1.9,i1,1
k2        =         (k2+.1)*k1
a1        reson     a1,k1,k2,2,0
          out       a1
          endin

</CsInstruments>
<CsScore>
c fig5.21ns.scr
f 1 0 512 7 0 512 1
f 4 0 512 5 1 512 3
f 2 0 512 9 .5 1 0
  i1 0.000 10.000 880 13000
end of score

</CsScore>
</CsoundSynthesizer>
