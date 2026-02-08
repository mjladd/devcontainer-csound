<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Function.orc and Function.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; Log function distortion

ain      soundin  "Sample2"

a2       = (ain + 32767)/16384 ; Scale and DC shift
alog     = log(a2)             ; Log function
out      alog*16384            ; Scale output

endin

instr    2 ; Polynominal function distortion

ain      soundin  "Sample1"

ain      = ain/32767           ; Scale input to +/-1
apoly    = ain - (ain*ain*ain) ; Polynominal function
out      apoly*85196           ; Scale output

endin

instr    3 ; x*2 - x^2 function (Even harmonic distortion)

ain      soundin  "Sample2"

ain      = ain/32767           ; Scale input to +/-1
apoly    = ain*2 - ain*ain     ; x*2 - x^2 function
out      apoly*32767/3         ; Scale output

endin

instr    4 ; x*3 - x^3 distortion (Compresses Signal)

ain      soundin  "Sample1"

ain      = ain/32767           ; Scale input to +/-1
apoly    = ain*3 - ain*ain*ain ; x*3 - x^3 function
out      apoly*16384           ; Scale output

endin

</CsInstruments>
<CsScore>
;     Strt  Leng
i01   0.00  1.50

;     Strt  Leng
i02   2.00  1.50

;     Strt  Leng
i03   4.00  1.50

;     Strt  Leng
i04   6.00  1.50
e

</CsScore>
</CsoundSynthesizer>
