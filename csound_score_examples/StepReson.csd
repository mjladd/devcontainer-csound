<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from StepReson.orc and StepReson.sco
; Original files preserved in same directory

sr      = 44100
kr      = 4410
ksmps   = 10
nchnls  = 1


instr     1 ; S&H with 'Reson' Filter

ilevl     = p4/200 ; Output level
ifreq     = p5     ; Base frequency
idpth     = p6/2   ; S&H depth
irate     = p7     ; S&H rate
iseed     = p8     ; Seed

k1        randh  idpth, irate, iseed
k1        = k1 + idpth
a1        soundin  "Sample1"
a2        reson  a1, ifreq + k1, (ifreq + k1)/16
out       a2*ilevl

endin

</CsInstruments>
<CsScore>
;   Strt  Leng  Levl  Freq  Depth Rate  Seed
i1  0.00  1.47  1.00  500   1000  10.85 0.50
e

</CsScore>
</CsoundSynthesizer>
