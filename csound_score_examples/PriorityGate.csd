<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PriorityGate.orc and PriorityGate.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Gate - passes louder input

ilevl    = p4

ain1     soundin  "Marimba.aif"
ain2     soundin  "sing.aif"

kin1     downsamp  ain1
kin2     downsamp  ain2
kpos1    limit  kin1, 0, 32768
kneg1    limit  kin1,-32768, 0
kpos2    limit  kin2, 0, 32768
kneg2    limit  kin2,-32768, 0
kgate1   = (kpos1 > kpos2 ? kpos1 : kpos2)
kgate2   = (kneg1 < kneg2 ? kneg1 : kneg2)
kgate    = kgate1 + kgate2
agate    upsamp  kgate
out      agate*ilevl

endin

instr    2 ; Gate - passes quieter input

ilevl    = p4

ain1     soundin  "Marimba.aif"
ain2     soundin  "sing.aif"

kin1     downsamp  ain1
kin2     downsamp  ain2
kpos1    limit  kin1, 0, 32768
kneg1    limit  kin1,-32768, 0
kpos2    limit  kin2, 0, 32768
kneg2    limit  kin2,-32768, 0
kgate1   = (kpos1 < kpos2 ? kpos1 : kpos2)
kgate2   = (kneg1 > kneg2 ? kneg1 : kneg2)
kgate    = kgate1 + kgate2
agate    upsamp  kgate
out      agate*ilevl

endin

</CsInstruments>
<CsScore>
;Passes loudest input

;   Strt  Leng  Levl
i1  0.00  1.47  1.00

;Passes quietest input

;   Strt  Leng  Levl
i2  2.00  1.47  1.00
e

</CsScore>
</CsoundSynthesizer>
