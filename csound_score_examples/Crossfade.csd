<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Crossfade.orc and Crossfade.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 1


instr    1 ; Crossfades between 2 inputs at audio or LFO rates

ilevl    = p4 ; Output level
irate    = p5 ; Rate
itabl    = p6 ; Waveshape

ain1     soundin  "oboe.mf.C4B4.aiff"
ain2     soundin  "Marimba.aif"
aosc     oscili  1, irate, itabl
aout     = ain1*aosc + ain2*(1 - aosc)
out      aout*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1                        ; Sine
f2 0 8193 7 0 8192 1                  ; Linear Ramp
f3 0 8193 7 1 4080 1 16 0 4080 0 16 1 ; Switcher

;   Strt  Leng  Levl  Rate  Table
i1  0.00  1.47  1.00  8.00  3
i1  2.00  .     .     0.68  2
i1  4.00  .     .     500   1
e

</CsScore>
</CsoundSynthesizer>
