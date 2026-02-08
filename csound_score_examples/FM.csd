<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FM.orc and FM.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Audio FM Of Sample.

p3       = p3 + .1   ; Adjust length to compensate for delay
ilevl    = p4        ; Output level
idepth   = p5/1000   ; Convert depth to ms
ifreq1   = p6        ; Start mod freq
ifreq2   = p7        ; End mod freq
iwave    = p8        ; Modulation waveform
ifm      = p9/100000 ; Self-modulation

ain      soundin  "Sample1"

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
f01 0 8193 10 1                      ; Sine
f02 0 8193 7 0 2048 1 4096 -1 2048 0 ; Tri
f03 0 8193 7 1 4096 1 0 -1 4096 -1   ; Square
f04 0 8193 7 -1 8192 1               ; Ramp

;Max depth = 50ms

;     Strt  Leng  Levl  Depth Freq1 Freq2 Wave  Self-mod
i01   0.00  1.00  1.00  10.0  1.00  5000  01    0.00
i01   2.00  .     .     0.00  10.0  10.0  01    1.00
i01   4.00  .     .     25.0  0.10  9999  04    0.00
e

</CsScore>
</CsoundSynthesizer>
