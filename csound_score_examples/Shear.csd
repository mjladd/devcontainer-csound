<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Shear.orc and Shear.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Delays negative half of signal

ilevl    = p4*2    ; Output level
idelay   = p5/1000 ; Delay in ms
imix     = p6      ; Mix: 0=Neg 1=Pos

ain      soundin  "Sample1"

apos     limit  ain, 0, 32768
aneg     limit  ain, -32768, 0
adel     delay  aneg, idelay
amix     = apos*imix + adel*(1 - imix)
out      amix*ilevl

endin

</CsInstruments>
<CsScore>
;Delay in ms

;     Strt  Leng  Levl  Delay Balance+/-
i01   0.00  1.50  1.00  5.00  0.50
i01   2.00  .     .     .     0.75
i01   4.00  .     .     .     0.25
i01   6.00  .     .     50.0  0.50
e

</CsScore>
</CsoundSynthesizer>
