<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from cookFM.orc and cookFM.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Audio FM Of Sample.

p3       = p3 + .1   ; Adjust length to compensate for delay
ilevl    = p4        ; Output level
idepth   = p5/1000   ; Convert depth to ms
ifreq1   = p6        ; Start mod freq
ifreq2   = p7        ; End mod freq
iwave    = p8        ; Modulation waveform
ifm      = p9/100000 ; Self-modulation

ain      soundin  "Piano.aif"

ksweep   expseg  ifreq1, p3, ifreq2
afm1     oscili  idepth, ksweep, iwave
afm2     = ain*ifm
ax       delayr  .1
aout     deltapi .05 + afm1 + afm2
         delayw  ain
out      aout*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1                      ; Sine
f2 0 8193 7 0 2048 1 4096 -1 2048 0 ; Tri
f3 0 8193 7 1 4096 1 0 -1 4096 -1   ; Square
f4 0 8193 7 -1 8192 1               ; Ramp

;Max depth = 50ms

;   Strt  Leng  Levl  Depth Freq1 Freq2 Wave  Auto-Mod
i1  0.00  1.47  1.00  10.0  1.00  5000  2     0.00
e

</CsScore>
</CsoundSynthesizer>
