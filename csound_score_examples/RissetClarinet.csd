<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RissetClarinet.orc and RissetClarinet.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


; RISSET'S WAVESHAPING CLARINET

          instr 1

i1        =         cpspch(p4)
i2        =         .64
          if        p3 > .75 igoto start
i2        =         p3-.085

start:
a1        linen     255,.085,p3,i2
a1        oscili    a1,i1,3
a1        tablei    a1+256,1
          out       p5*a1
          endin

</CsInstruments>
<CsScore>
f 1 0 512 7 -1 200 -.5 112 .5 200 1
f 3 0 512 9 1 1 0
f 0 2
s
  i1 0.000 0.750 7.04 20000
  i1 0.750 0.250 7.07 20000
  i1 1.000 1.000 8.00 20000
  i1 2.000 0.200 8.02 20000
  i1 2.200 0.200 8.04 20000
  i1 2.400 0.200 8.05 20000
  i1 2.600 0.200 9.00 20000
  i1 2.800 0.200 9.04 20000
  i1 3.000 0.250 9.05 20000
  i1 3.250 0.250 9.00 20000
  i1 3.500 0.250 8.05 20000
  i1 3.750 0.250 8.00 20000
  i1 4.000 1.000 7.04 20000
  i1 5.000 0.125 7.07 20000
  i1 5.125 0.125 8.00 20000
  i1 5.250 0.125 8.02 20000
  i1 5.375 0.125 8.04 20000
  i1 5.500 0.125 8.05 20000
  i1 5.625 0.125 9.00 20000
  i1 5.750 0.125 9.04 20000
  i1 5.875 0.125 9.05 20000
end of score

</CsScore>
</CsoundSynthesizer>
