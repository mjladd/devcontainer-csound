<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pluckvoice.orc and pluckvoice.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
;ar       repluck   iplk, xam, icps, kpick, krefl, axcite
a1        diskin    "hellorcb.aif", 1
asig      repluck    p6, p4, cpspch(p5), p7, p8, a1
          out       asig
          endin

</CsInstruments>
<CsScore>

 i1  0 6 5000 3.00 .1   .1 .5
s
 i1  0 5 4000 4.00 .1   .1 .5
 i1  1 5 4000 6.07 .2   .4 .3
 i1  2 5 4000 5.09 .5   .3 .1
 i1  3 5 4000 7.11 .4   .8 .2
s

 i1  0 5 4000 5.00 .1   .1 .5
 i1  1 5 4000 7.09 .2   .4 .3
 i1  2 4 4000 6.04 .5   .3 .1
 i1  3 4 4000 8.07 .4   .8 .2

</CsScore>
</CsoundSynthesizer>
