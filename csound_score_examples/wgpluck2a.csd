<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from wgpluck2a.orc and wgpluck2a.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          instr 1

aout      wgpluck2  .1, 20000, 100, .1, p4
          out       aout
          endin

</CsInstruments>
<CsScore>
i1 0 6 .01
i1 + 6 .1
i1 + 5 .5
i1 + 4 .8
i1 + 3 .9
i1 + 2 .99

</CsScore>
</CsoundSynthesizer>
