<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from granproc.orc and granproc.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
idur      =         1/1.45
a1        grain     10000, idur, 15, 0, idur/2,1, 1, 2, 1
          out       a1
          endin

</CsInstruments>
<CsScore>
f1 0 32768 1 5 .01 1 1
f2 0 1024 20 2
f0 .25
f0 .5
f0 1
f0 1.5
f0 2
f0 2.5
f0 3
f0 3.5

i1 0 4

</CsScore>
</CsoundSynthesizer>
