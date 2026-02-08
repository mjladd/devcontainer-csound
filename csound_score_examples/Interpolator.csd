<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Interpolator.orc and Interpolator.sco
; Original files preserved in same directory

sr     = 44100
kr     = 441
ksmps  = 100
nchnls = 1


instr    1 ; Sample1 interpolator - Set kr to rate wanted

ilevl    = p4 ; Output level

ain      soundin  "Piano.aif"
kin      downsamp  ain
aout     interp  kin
out      aout*ilevl

endin

</CsInstruments>
<CsScore>
;     Strt  Leng  Levl
i1    0.00  1.47  1.00
e

</CsScore>
</CsoundSynthesizer>
