<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Gates.orc and Gates.sco
; Original files preserved in same directory

sr       = 44100
kr       = 44100
ksmps    = 1
nchnls   = 1


instr    1 ; Gate - passes signal over threshold

ilevl    = p4       ; Level
ithresh  = p5*32768 ; Threshold

ain      soundin  "Sample1"

kin      downsamp  ain
kpos     limit  kin, 0, 32768
kneg     limit  kin,-32768, 0
kgate1   = (kpos > ithresh ? kpos : 0)
kgate2   = (kneg <-ithresh ? kneg : 0)
kgate    = kgate1 + kgate2
agate    upsamp  kgate
out      agate*ilevl

endin

instr    2 ; Gate - passes signal under threshold

ilevl    = p4/p5    ; Level scaled to compensate for clipping
ithresh  = p5*32768 ; Threshold

ain      soundin  "Sample2"

kin      downsamp  ain
kpos     limit  kin, 0, 32768
kneg     limit  kin,-32768, 0
kgate1   = (kpos < ithresh ? kpos : 0)
kgate2   = (kneg >-ithresh ? kneg : 0)
kgate    = kgate1 + kgate2
agate    upsamp  kgate
out      agate*ilevl

endin

instr    3 ; Gate - passes loudest input

ilevl    = p4 ; Output level

ain1     soundin  "Sample1"
ain2     soundin  "Sample2"

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

instr    4 ; Gate - passes quietest input

ilevl    = p4 ; Output level

ain1     soundin  "Sample1"
ain2     soundin  "Sample2"

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
;Passes signal over threshold
;     Strt  Leng  Levl  Thresh
i01   0.00  1.50  1.00  0.50

;Passes signal under threshold
;     Strt  Leng  Levl  Thresh
i02   2.00  1.50  1.00  0.25

;Passes loudest input
;     Strt  Leng  Levl
i03   4.00  1.50  1.00

;Passes quietest input
;     Strt  Leng  Levl
i04   6.00  1.50  1.00
e
</CsScore>
</CsoundSynthesizer>
