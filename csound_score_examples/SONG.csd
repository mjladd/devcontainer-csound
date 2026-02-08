<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from SONG.ORC and SONG.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1

; RISSET "SONG" #420

instr          1

i1             =         1/p3

i2             =         p4
i3             =         p4 * 1.146
i4             =         p4 * 1.6
i5             =         p4 * 2.52           ; SPECTRUM POINTS
i6             =         p4 * 1.42
i7             =         p4 * 2.79
i8             =         p4 * 3.385

k1             oscil     p5, i1, 1
k2             oscil     p6, i1, 1
k3             oscil     p7, i1, 1
k4             oscil     p8, i1, 1
k5             oscil     p9, i1, 1
k6             oscil     p10, i1, 1
k7             oscil     p11, i1, 1

a1             oscili    k1, i2, 2
a2             oscili    k2, i3, 2
a3             oscili    k3, i4, 2
a4             oscili    k4, i4, 2
a5             oscili    k5, i6, 2
a6             oscili    k6, i7, 2
a7             oscili    k7, i8, 2

out            a1 + a2 + a3 + a4 + a5 + a6 + a7
endin

</CsInstruments>
<CsScore>
; Risset "song" #420

f1 0 513 5 1 512 .0078
f2 0 512 9 1 1 0

f0 1
s
i1 0 2.5 125 3000 2500 2000 3000 1000 1500 1000
i1 .  .   50
i1 .  .  210
i1 .  .  290
end

</CsScore>
</CsoundSynthesizer>
