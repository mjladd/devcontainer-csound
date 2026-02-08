<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from SampleHold.orc and SampleHold.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Audio rate Sample1 & Hold

ilevel   = p4 ; Output level
irate1   = p5 ; Start S&H rate
irate2   = p6 ; End S&H rate

krate    line  irate1, p3, irate2
ain      soundin  "Sample1"
agate    oscil  1, krate, 1
ash      samphold  ain, agate

out      ash*ilevel

endin

</CsInstruments>
<CsScore>
f1 0 128 -7 1 8 1 0 0 120 0 ; Spike for trigger

;   Strt  Leng  Levl  Rate1 Rate2
i1  0.00  1.47  1.00  5000  250
e

</CsScore>
</CsoundSynthesizer>
