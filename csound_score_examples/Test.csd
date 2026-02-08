<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Test.orc and Test.sco
; Original files preserved in same directory

sr       = 44100
kr       = 44100
ksmps    = 1
nchnls   = 1


instr    1 ; Test Tone Generator

ilevl1   = ampdb(90 + p4) ; Level start (dB: 0dB=Peak)
ilevl2   = ampdb(90 + p5) ; Level end (dB: 0dB=Peak)
ifreq1   = p6             ; Frequency sweep start
ifreq2   = p7             ; Frequency sweep end
imode    = p8             ; Sweep mode: 0=Exp 1=Lin
iwave    = p9             ; Waveform

alevl    line  ilevl1, p3, ilevl2
aexp     expon  ifreq1, p3, ifreq2
alin     line   ifreq1, p3, ifreq2
asweep   = (imode > 0 ? alin : aexp)
aosc     oscil3  alevl, asweep, iwave
out      aosc

endin

</CsInstruments>
<CsScore>
f01 0 8193 10 1                      ; Sine
f02 0 8193 7 0 2048 1 4096 -1 2048 0 ; Triangle
f03 0 257 7 1 128 1 0 -1 128 -1      ; Square

;Level: 0dB=Maximum
;Mode: 0=Exp 1=Lin

;     Strt  Leng  Levl1 Levl2 Freq1 Freq2 Mode  Wave
i01   0.00  1.50  0    -90    440   440   0     1
e
</CsScore>
</CsoundSynthesizer>
