<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FOG.ORC and FOG.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr  1

insnd     =         10
ibas      =         sr/ftlen(insnd)
kfund     =         38
kform     =         ibas

kphs      line      0, p3, 1
kgliss    line      0, p3, .5

kdur      =         2.5/kfund
kris      =         kdur/2.1
kdec      =         kris
iolaps    =         20
a1        fof2      23000, kfund, kform, 0, 0, kris, kdur, kdec, iolaps, insnd, 7, p3, kphs, kgliss
          out       a1

          endin

          instr   2

p3        =         1
iamp      =         p4
ifqc      =         cpspch(p5)

a1        vibes     iamp, ifqc, .5, .561, 1, 6, .05, 1, .1

          out       a1
          endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
;f7 0 8192 7 0 8192 1
;f10 0 131072 1 "neopren.wav" 0 0 1

;i1 0 8

i2 0 .2 20000 7.00
i2 + .  .     7.03
i2 . .  .     7.04
i2 . .  .     7.05
i2 . .  .     7.07
i2 . .  .     7.06


</CsScore>
</CsoundSynthesizer>
