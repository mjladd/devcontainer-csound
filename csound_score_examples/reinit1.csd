<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from reinit1.orc and reinit1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


instr     1

istep     init      0
ifqc      init      cpspch(p5)
kfqc      init      ifqc*(istep+1)/4

loop:

kampenv   linseg    0, .01, p4, .08, p4, .01, 0

          timout    0, .1, next1
istep     =         frac((istep + 1)/8)*8
kfqc      =         ifqc*(istep+1)/4
reinit    loop



next1:

aout      oscil     kampenv, kfqc, 1
          out       aout

endin

</CsInstruments>
<CsScore>
f1 0 8192      10        1    .5  .2  .1

i1 0 2         20000     8.00

</CsScore>
</CsoundSynthesizer>
