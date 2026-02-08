<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from VCO-Ramp.orc and VCO-Ramp.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Variable ramp VCO

ilevl    = p4*32767   ; Output level
ifreq    = cpspch(p5) ; Pitch
ishape   = p6         ; Ramp shape

aramp    oscili  1, ifreq, 1
aramp1   limit  aramp, 0, ishape
aramp2   limit  aramp, ishape, 1
aramp3   = aramp1*(1/ishape) - (aramp2 - ishape)*1/(1 - ishape)
aout     = (aramp3 - .5)*2
out      aout*ilevl

endin
</CsInstruments>
<CsScore>
f01 0 8193 -7 0 8192 1 ; Ramp

;     Strt  Leng  Levl  Pitch Shape
i01   0.00  1.00  1.00  06.00 0.25
i01   +     .     .     .     0.50
i01   +     .     .     .     0.75
i01   +     .     .     .     0.999
e
</CsScore>
</CsoundSynthesizer>
