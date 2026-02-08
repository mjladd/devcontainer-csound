<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from WVSHP.ORC and WVSHP.SCO
; Original files preserved in same directory

          sr        =         44100
          kr        =         4410
          ksmps     =         10
          nchnls    =         1




          instr     1
;
;   SIMPLE WAVESHAPING EXAMPLE.
;
;   P3 - DURATION.
;   P4 - AMPLITUDE, BETWEEN 0 (OFF) AND 1 (FULL SCALE).
;   P5 - PITCH (8.00 = MIDDLE C)
;
          inot      =         cpspch(p5)
          k1        linen     p4*0.5, p3, p3, 0
          k2        linen     p4*0.5, 0, p3, p3
          k3        linen     20000, .1, p3,3
          a1        oscili    k1, inot, 2
          a2        tablei    a1, 1, 1, .5
          a4        oscili    k2, inot, 2
          a5        tablei    a4, 4, 1, .5

          a3        oscili    1,inot/4, 3
          out       (a2+a5) * a3 *k3

          endin

</CsInstruments>
<CsScore>
f1 0 1025 13 1 1 0 1 0 1 0 1 0 1 0
f2 0 8193 10 1
f3 0 8193 9 1 1 90
f4 0 1025 13 1 1 0 0 1 0 1 0 1 0 1
;1111111111111111111111111


i1     0.0 8 .95  8.00

</CsScore>
</CsoundSynthesizer>
