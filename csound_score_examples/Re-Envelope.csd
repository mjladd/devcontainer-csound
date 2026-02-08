<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Re-Envelope.orc and Re-Envelope.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Replaces natural envelope with new shape

ilevl    = p4                          ; Output level
ishape   = p5                          ; Envelope shape
inumbr   = p6                          ; Number of envelope repeats
kenv     init 0                        ; Initialize output
kslope   init 0                        ; Initialize slope

ain      soundin  "Sample1"

kin      downsamp  ain                 ; Convert to kr
kin      mirror  kin, 0, 32767         ; Full wave rectify
if       kin > kenv goto up            ; See if input exceeds output...
kslope   = kslope + .1                 ; Increment slope
kenv     = kenv - kslope               ; Ramp down
goto     out
up:
kslope   = 0                           ; Reset slope
kenv     = kin                         ; Ramp up
out:
kenv1    oscili  1, inumbr/p3, ishape  ; Envelope
aout     = ain*(32767/kenv)            ; De-envelope
out      aout*ilevl*kenv1              ; Re-envelope, level and output

endin
</CsInstruments>
<CsScore>
f01 0 1025 7 1 1024 1            ; De-Envelope
f02 0 1025 7 1 1024 0            ; Linear fade out
f03 0 1025 7 0 1024 1            ; Linear fade in
f04 0 1025 7 0 512 1 512 0       ; Linear fade in/out
f05 0 1025 5 1 1024 .001         ; Exponential fade out
f06 0 1025 5 .001 1024 1         ; Exponential fade in
f07 0 1025 5 .001 512 1 512 .001 ; Exponential fade in/out
f08 0 1025 9 .5 1 0              ; 1/2 Sine
f09 0 17 21 1                    ; Random 1
f10 0 65 21 1                    ; Random 2

;     Strt  Leng  Levl  Shape Repeat
i01   0.00  1.50  1.00  03    01
i01   2.00  .     .     02    .
i01   4.00  .     .     05    08
i01   6.00  .     .     08    01
i01   8.00  .     .     09    .
e
</CsScore>
</CsoundSynthesizer>
