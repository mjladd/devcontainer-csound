<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Wierd1.orc and Wierd1.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Reads and writes same table - quantisation hell!

ilevl    = p4*32767   ; Output level
ipitch   = cpspch(p5) ; Pitch
iofset   = p6         ; ?

a1       oscil 1, ipitch + iofset, 1
a2       phasor  ipitch
         tablew  a1, a2, 1, 1, 0, 2
a3       table  a1, 1, 1, 0, 1
out      a3*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 1025 10 1 ; Sine

;   Strt  Leng  Levl  Pitch Offset
i1  0.00  8.00  1.00  06.00 0.125
e

</CsScore>
</CsoundSynthesizer>
