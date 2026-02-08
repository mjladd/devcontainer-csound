<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from EnvFilter.orc and EnvFilter.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Moog VCF With Envelope Follower.

ilevl    = p4 ; Output level
idepth   = p5 ; Sweep depth
irez     = p6 ; Resonance

ain      soundin  "Marimba.aif"
a2       follow  ain, .025
a3       butterlp  a2, 25
avcf     moogvcf  ain, (a3/8)*idepth, irez, 32768

out      avcf*ilevl

endin

</CsInstruments>
<CsScore>
;   Strt  Leng  Levl  Depth Rez
i1  0.00  1.47  1.00  1.00  0.91
e

</CsScore>
</CsoundSynthesizer>
