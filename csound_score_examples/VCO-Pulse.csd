<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from VCO-Pulse.orc and VCO-Pulse.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Variable Pulse VCO

ilevl    = p4*32767   ; Output level
ifreq    = cpspch(p5) ; Pitch
ishape   = p6         ; Pulsewidth

asaw     oscili  1, ifreq, 1
asaw1    limit  asaw, 0, ishape
asaw2    limit  asaw, ishape, 1
aramp    = asaw1*(.5/ishape) + (asaw2 - ishape)*(.5/(1 - ishape))
apulse   table  aramp, 2, 1
out      apulse*ilevl

endin
</CsInstruments>
<CsScore>
f01 0 8193 -7 0 8192 1             ; Ramp
f02 0 4096 7 1 2048 1 0 -1 2048 -1 ; Square

;     Strt  Leng  Levl  Pitch Pulsewidth
i01   0.00  1.00  1.00  06.00 0.25
i01   +     .     .     .     0.50
i01   +     .     .     .     0.75
i01   +     .     .     .     0.999
e
</CsScore>
</CsoundSynthesizer>
