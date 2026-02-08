<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Stop.orc and Stop.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Tape / Record stop simulator

ilevl    = p4*32767          ; Output level
idelay   = p5                ; Delay before stopping
itime    = p6                ; Stopping time
iaccel   = p7                ; Decceleration curve
ileng    = ftlen(1)/ftsr(1)  ; Sample1 length

kdclick  linseg  0, .001, 1, p5 + p6 - .101, 1, .1, 0
kstop    oscil1  idelay, 1, itime, iaccel ; Generate decceleration curve
kline    phasor  (1/ileng)*kstop          ; Index
ain      table3  kline, 1, 1              ; Index Sample table
out      ain*kdclick*ilevl                ; Level declick and output

endin

</CsInstruments>
<CsScore>
f1 0 32768 1 "Sample1" 0 4 0 ; Sample
f2 0 8193 7 1 8192 0                                              ; Linear
f3 0 8193 5 1 8192 .0001                                          ; Exponential
f4 0 8193 17 0 7 1024 6 2048 5 3072 4 4096 3 5120 2 6144 1 7168 0 ; Stepped
f5 0 8193 13 1 1 0 -1 0 0 0 0 0 0 0 -.1                           ; 'Curvy'

;   Strt  Leng  Levl  Delay Time  Curve
i1  0.00  1.47  1.00  0.47  1.00  2
e

</CsScore>
</CsoundSynthesizer>
