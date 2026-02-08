<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from LogDistort.orc and LogDistort.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Log function distortion

a1       soundin  "Piano.aif"
a2       = (a1 + 32767)/16384
a3       = log(a2)
out      a3*16384

endin

</CsInstruments>
<CsScore>
;   Strt  Leng
i1  0.00  1.47
e

</CsScore>
</CsoundSynthesizer>
