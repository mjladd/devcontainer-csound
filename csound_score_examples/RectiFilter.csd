<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RectiFilter.orc and RectiFilter.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; lowpass (+)Signal, highpass (-)Signal (Unusual distortion)

ilevl    = p4 ; Output level
ifreq    = p5 ; Crossover frequency in Hz

ain      soundin  "Sample1"

aflt1    butterlp  ain, ifreq
aflt2    butterhp  ain, ifreq

apos     limit  aflt1, 0, 32768
aneg     limit  aflt2,-32768, 0

amix     = apos + aneg

out      amix*ilevl

endin

</CsInstruments>
<CsScore>
;     Strt  Leng  Levl  Freq(Hz)
i1    0.00  1.50  1.00  1000
e

</CsScore>
</CsoundSynthesizer>
