<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RndInvert.orc and RndInvert.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Random wavecycle invert

ilevl    = p4                        ; Output level
inv      = p5*2 - 1                  ; % Inverted

ain      soundin  "monks.1"

kin      downsamp  ain               ; Convert input to kr
krand    rand  1                     ; Generate random signal
kzero    trigger  kin, 0, 0          ; Detect zero crossings
if       kzero = 0 goto output       ; Do nothing if not zero
if       krand + inv < 0 goto invert ; Goto invert if random < 0
ainvert  = 1                         ; Don't invert wavecycle
goto     output
invert:
ainvert  = -1                        ; Invert wavecycle
output:
out      ain*ainvert*ilevl           ; Output, invert and level

endin

</CsInstruments>
<CsScore>
;Invert: 0=0% 1=100% (50% is maximum effect)

;   Strt  Leng  Levl  Invert
i1  0.00  1.47  1.00  0.50
e

</CsScore>
</CsoundSynthesizer>
