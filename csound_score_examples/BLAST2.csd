<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BLAST2.ORC and BLAST2.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

;4-13-89 TEST OF CPS PITCH CONVERSION

instr 1
a1             pluck     p4,cpspch(p5),cpspch(p5),0,1,0,0        ;P4=AMP, P5=FREQ
out            a1
endin

instr          2
k1             linseg    p5,p3*.4,p5,p3*.6,p5*.9
a1             pluck     p4,cpspch(p5),cpspch(p5),0,1,0,0
out            a1
endin

instr          3
k1             randi     3,5  ;trem freq from rand
k2             oscili    20,k1,2  ;trem oscili w/rand freq - #2 f unit
k3             linseg    p4*.1,p3*.7,p4,p3*.3,p4*.90             ;AMP SEG
k4             linseg    p5*1.02,p3*.05,p5*.96,p3*.95,p5         ;FREQ SEG
a1             oscili    k3,k4+k2,1
out            a1
endin

</CsInstruments>
<CsScore>

;blast2.sco

f 1 0 4097 9 1 1 0 ; 3 1.3603 0  5 1.6176 0  7 1.1176 0  9 1.2058 0  11 1.0735 0  13 1.1103 0  15 1.0235 0 ; 17 .0367 0 18 .0073 0 19 .0029 0 20 .0058 0 21 .0044 0
f 2 0 4097 9 1 1 0



i2 0 2 4000 2.90
i2 . . .    2.91
i2 . . .    2.92
i2 . . .    2.93
i2 0 2 .    2.94
i2 0 2 .    2.95
i2 0 2 .    2.96
i2 0 2 .    2.97
i2 . . .    2.98
i2 0 2 .    2.99

i2 1.9  .2  4000 2.905
i2 .    .   .    2.915
i2 .    .   .    2.925
i2 .    .   .    2.935
i2 1.90 .2  .    2.945
i2 1.90 .2  .    2.955
i2 1.90 .2  .    2.965
i2 .    .   .    2.975
i2 .    .   .    2.985
i2 1.90 .2  .    2.995

i2 2 2 4000 2.80
i2 . . .    2.81
i2 . . .    2.82
i2 . . .    2.83
i2 2 2 .    2.84
i2 2 2 .    2.85
i2 2 2 .    2.86
i2 2 2 .    2.87
i2 . . .    2.88
i2 2 2 .    2.89

i2 3.9  .2  4000 2.905
i2 .    .   .    2.915
i2 .    .   .    2.925
i2 .    .   .    2.935
i2 .    .2  .    2.945
i2 .    .2  .    2.955
i2 .    .2  .    2.965
i2 .    .   .    2.975
i2 .    .   .    2.985
i2 1.90 .2  .    2.995

i2 4   2 4000 3.70
i2 .   . .    3.71
i2 .   . .    3.72
i2 .   . .    3.73
i2 .   2 .    3.74
i2 .   2 .    3.75
i2 .   2 .    3.76
i2 .   2 .    3.77
i2 .   . .    3.78
i2 4   2 .    3.79

i2 5.9  .2  4000 2.905
i2 .    .   .    2.915
i2 .    .   .    2.925
i2 .    .   .    2.935
i2 .    .2  .    2.945
i2 .    .2  .    2.955
i2 .    .2  .    2.965
i2 .    .   .    2.975
i2 .    .   .    2.985
i2 5.90 .2  .    2.995



i2 6 2 4000 2.90
i2 . . .    2.91
i2 . . .    2.92
i2 . . .    2.93
i2 . 2 .    2.94
i2 . 2 .    2.95
i2 . 2 .    2.96
i2 . 2 .    2.97
i2 . . .    2.98
i2 . 2 .    2.99

i2 7.6  5 4000 1.90
i2 .    . .    1.91
i2 .    . .    1.92
i2 .    . .    1.93
i2 .    . .    1.94
i2 .    . .    1.95
i2 .    . .    1.96
i2 .    . .    1.97
i2 .    . .    1.98
i2 7.60 5 .    1.99
e

</CsScore>
</CsoundSynthesizer>
