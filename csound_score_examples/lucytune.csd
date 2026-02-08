<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from lucytune.orc and lucytune.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;------------------------------------------------------------------
; EXAMPLE OF LUCY TUNING
;------------------------------------------------------------------
          instr          1

p3        =         p3+p6
idur      =         p3
iamp      =         p4
ifqc      cps2pch   p5, -2

kamp      linseg    0, .02, 1, .05, .8, .1, .7, idur-.27, .5, .1, 0

aout1     foscil    kamp*iamp, ifqc,     1, 2, kamp*2, 1
aout2     foscil    kamp*iamp, ifqc*2, 1, 1, kamp*2, 1

;aout     pluck     kamp*iamp, ifqc, ifqc, 0, 1

          outs      aout1+aout2*.5, aout1+aout2*.5

          endin

</CsInstruments>
<CsScore>
;------------------------------------------------------------------------------
; LUCY TUNING EXAMPLE
;------------------------------------------------------------------------------
f1 0 8192 10 1

f2 0 16 -2 1 1.040360358 1.116641954 1.19851669 1.246889254 1.338314019 1.392328853 1.494417582 1.603991689 1.668729368 1.791084414 1.863373223 2

; LUCY TUNING A=440
;f2 0 16 -2 1.007841 1.048488 1.125388 1.170776? 1.256645 1.348813 1.403211 1.506129 1.566872? 1.749621? 1.877945

;   Sta  Dur  Amp    Pitch  Hold
i1  0    .5   5000   6.00   1.5
i1  0    .5   5000   7.00   1.5
i1  +    .    .      7.07   1.0
i1  .    .    .      8.00   0.5
i1  .    .    .      8.04   0.0
;   Sta  Dur  Amp    Pitch  Hold
i1  2    .5   5000   6.00   1.5
i1  2    .5   5000   7.00   1.5
i1  +    .    .      7.05   1.0
i1  .    .    .      7.09   0.5
i1  .    .    .      8.00   0.0
;   Sta  Dur  Amp    Pitch  Hold
i1  4    .5   5000   6.00   1.5
i1  4    .5   5000   7.00   1.5
i1  +    .    .      7.07   1.0
i1  .    .    .      8.00   0.5
i1  .    .    .      8.03   0.0
;   Sta  Dur  Amp    Pitch  Hold
i1  6    .5   5000   6.00   1.5
i1  6    .5   5000   7.00   1.5
i1  +    .    .      7.05   1.0
i1  .    .    .      7.10   0.0
i1  .    .    .      7.09   0.0


</CsScore>
</CsoundSynthesizer>
