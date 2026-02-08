<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from StereoPhaser.orc and StereoPhaser.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 2


instr    1 ; Pseudo 6-Stage Stereo Phaser using notch filters

ilevl    = p4*1.18                       ; Output level
iratel   = p5                            ; L LFO rate
irater   = p6                            ; R LFO rate
iph      = p7/360                        ; R LFO phase in degrees
iwave    = p8                            ; LFO waveform
iq       = p9                            ; Q

ain      soundin  "Sample2"

klfol    oscili  .40, iratel, iwave      ; L LFO
klfor    oscili  .40, irater, iwave, iph ; R LFO
klfo1    table  klfol + .40, 1, 1        ; Convert to exponential
klfo2    table  klfol + .50, 1, 1        ; Convert to exponential
klfo3    table  klfol + .60, 1, 1        ; Convert to exponential
klfo4    table  klfor + .40, 1, 1        ; Convert to exponential
klfo5    table  klfor + .50, 1, 1        ; Convert to exponential
klfo6    table  klfor + .60, 1, 1        ; Convert to exponential
anl      pareq  ain, klfo1, 0, iq, 0     ; L Notch 1
anl      pareq  anl, klfo2, 0, iq, 0     ; L Notch 2
anl      pareq  anl, klfo3, 0, iq, 0     ; L Notch 3
anr      pareq  ain, klfo4, 0, iq, 0     ; R Notch 1
anr      pareq  anr, klfo5, 0, iq, 0     ; R Notch 2
anr      pareq  anr, klfo6, 0, iq, 0     ; R Notch 3
outs     anl*ilevl, anr*ilevl            ; Level and output

endin

</CsInstruments>
<CsScore>
f1 0 8192 -5 50 8192 14500   ; Exponential curve

f2 0 8193 -7 0 4096 1 4096 0 ; Triangle
f3 0 8193 19 1 1 0 1         ; Sine
f4 0 8193 -7 0 8192 1        ; Ramp

;   Strt  Leng  Levl  RateL RateR Phase Wave  Q
i1  0.00  1.47  1.00  0.68  0.68  090   2     0.71
e

</CsScore>
</CsoundSynthesizer>
