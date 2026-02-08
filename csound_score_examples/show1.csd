<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from show1.orc and show1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     101
kamp      linen     p4, .7, p3, .05
kvib      oscil     2.75, 15, 1
a1        oscil     kamp, cpspch(p5)+kvib,1
          out       a1
          endin



</CsInstruments>
<CsScore>
f 1 0 4096 10 1
f 2 0 4096 10 1 0 .1 0 .04 0 .02 0 .01

i101      0     2.5      25000     8.05
i101      2.5  2.5  25000     8.13
i101      5     2.5      25000     8.12

</CsScore>
</CsoundSynthesizer>
