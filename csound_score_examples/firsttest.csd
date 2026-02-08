<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from firsttest.orc and firsttest.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


; SIMPLE PLUCK WORKING ?
          instr 1
icps      =         p4
kcps      =         icps
aout      pluck     15000, kcps, icps, 0, 1
          outs      aout, aout
          endin

</CsInstruments>
<CsScore>
; simpletest.sco
; just draw a bunch of gen 10s and pluck for ten seconds
f1 0 1024 10 1
f2 0 1024 10 2
f3 0 1024 10 3
f4 0 1024 10 4
i1 0 10 100

</CsScore>
</CsoundSynthesizer>
