<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from TestTone.orc and TestTone.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Sine/Triangle/Square Sweep Oscillator

ilevl    = ampdb(90 + p4) ; Level in dB (0dB = Peak-.3dB)
ifreq1   = p5             ; Sweep start
ifreq2   = p6             ; Sweep end
imode    = p7             ; Sweep mode: 0=Exp, 1=Lin
iwave    = p8             ; Waveform

if       imode = 1 goto lin
asweep   expseg  ifreq1, p3, ifreq2
goto     osc
lin:
asweep   linseg  ifreq1, p3, ifreq2
goto     osc
osc:
aosc     oscil3  ilevl, asweep, iwave
out      aosc

endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1                      ; Sine
f2 0 8193 7 0 2048 1 4096 -1 2048 0 ; Triangle
f3 0 257 7 1 128 1 0 -1 128 -1      ; Square

;0dB=Maximum Level
;Sweep: 0=Exp 1=Lin

;     Strt  Leng  dB    Freq1 Freq2 Sweep Wave
i1    0.00  1.00  0     20    20000 0     1
e

</CsScore>
</CsoundSynthesizer>
