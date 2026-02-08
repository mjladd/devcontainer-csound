<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BLAST1.ORC and BLAST1.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1


instr          1
a1             pluck     p4,cpspch(p5),cpspch(p5),0,1,0,0        ;P4=AMP, P5=FREQ
out            a1
endin

instr 2
k1             linseg    p5,p3.4,p5,p3.6,p5*.9
a1             pluck     p4,cpspch(p5),cpspch(p5),0,1,0,0
out            a1
endin

instr 3
k1             randi     3,5  ;trem freq from rand
k2             oscili    20,k1,2  ;trem oscili w/rand freq - #2 f unit
k3             linseg    p4*.1,p3*.7,p4,p3*.3,p4*.90                  ;AMP SEG
k4             linseg    p5*1.02,p3*.05,p5*.96,p3*.95,p5              ;FREQ SEG
a1             oscili    k3,k4+k2,1
out            a1
endin


</CsInstruments>
<CsScore>
f 1 0 4097 9 1 1 0 ; 3 1.3603 0  5 1.6176 0  7 1.1176 0  9 1.2058 0  11 1.0735 0  13 1.1103 0  15 1.0235 0 ; 17 .0367 0 18 .0073 0 19 .0029 0 20 .0058 0 21 .0044 0
f 2 0 4097 9 1 1 0

i2 0 22  4000 3.060
i2 . . .      3.061
i2 . . .      3.062
i2 . . .      3.063
i2 . . .      3.064
i2 . . .      3.065
i2 . . .      3.066
i2 . . .      3.067
i2 . . .      3.068
i2 . 22 .     3.069
e

</CsScore>
</CsoundSynthesizer>
