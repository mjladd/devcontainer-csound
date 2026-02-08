<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Dynamics.orc and Dynamics.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Dynamics processor

ilevl    = p4                          ; Output level
ishape   = p5                          ; Level curve
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
kdyn     tablei  kenv/32767, ishape, 1 ; Waveshape dynamics
aout     = ain*(32767/kenv)            ; Remove dynamics from input
out      aout*kdyn*ilevl               ; Level, process and output

endin

</CsInstruments>
<CsScore>
f01 0 4097 7 0 1024 .5 2048 .95 1024 1 ; Compress - medium
f02 0 4097 9 .25 1 0                   ; Compress - sine curve
f03 0 4097 7 0 1024 .95 3072 1         ; Compress - severe
f04 0 4097 7 0 1024 0 0 1 3072 1       ; Gate 1/4
f05 0 4097 7 0 2048 0 0 1 2048 1       ; Gate 1/2
f06 0 4097 -7 0 3584 1 512 1           ; Limit 7/8
f07 0 4097 -7 0 3072 1 1024 1          ; Limit 3/4
f08 0 4097 7 0 24 .25 1000 .25 3072 1  ; Detail lift
f09 0 4097 7 0 96 1 4000 0             ; Invert
f10 0 65 21 1                          ; Random
f11 0 4097 10 0 0 0 0 0 0 1            ; Granular

;     Strt  Leng  Levl  Curve
i01   0.00  1.47  0.99  03
e
</CsScore>
</CsoundSynthesizer>
