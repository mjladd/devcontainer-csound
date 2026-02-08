<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RndHarm.orc and RndHarm.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Random Harmonic Sequence Generator

ilevl    = p4*32767   ; Output level
ipitch   = cpspch(p5) ; Pitch
irate    = p6         ; Rate
itabl    = p7         ; Envelope shape
idet     = p8         ; Detune

iseed    = rnd(1)                           ; Generate random seed value
krnd     randh  16, irate, iseed            ; Generate random steps
krnd     = int(krnd + 17)                   ; Quantise steps
kscale   = (32 - krnd)/32                   ; Reduce level of high harmonics
kenv     oscil  kscale, irate, itabl        ; Generate envelope table
aosc     oscil  kenv, ipitch*krnd + idet, 1 ; Generate pitches
out      aosc*ilevl                         ; Level and output

endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1 ; Sine
; Envelope shapes
f2 0 1024 5 1 1024 .001        ; Exponential decay
f3 0 1024 7 1 1024 0           ; Linear decay
f4 0 1024 20 2                 ; Hanning
f5 0 1024 20 6                 ; Gaussian
f6 0 1024 7 0 12 1 1000 1 12 0 ; Level

;   Strt  Leng  Levl  Pitch Rate  Shape Detune
i1  0.00  4.00  0.25  10.00 8.00  4     0.00
i1  .     .     .     10.00 12.0  .     ~
i1  .     .     .     10.00 16.0  .     ~
i1  .     .     .     10.00 24.0  .     ~
i1  .     .     .     10.00 32.0  .     ~
i1  .     .     .     10.00 48.0  .     2.00
e

</CsScore>
</CsoundSynthesizer>
