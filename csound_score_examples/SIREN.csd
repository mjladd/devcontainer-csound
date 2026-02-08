<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from SIREN.ORC and SIREN.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; Risset Siren #510


          instr 1

i1        =         1/p6
i2        =         1/p10
i3        =         1/p12
i4        =         1/p16
a1        =         0
k1        oscil     p5, i1, 5
a1        oscili    a1 + p4, k1, 1
a1        =         a1

k2        randi     p7, p8
k3        oscil     p9, i2, 6
a2        oscili    k2, k3, 1

k4        oscil     p11, i3, 7
a3        oscili    p13, k4, 2

k5        oscil     p15, i4, 8
a4        oscili    p14, k5, 1

a5        =         a1 + a2 + a3 + a4

          out       a5 * 10
          endin

</CsInstruments>
<CsScore>
; Risset Siren #510

f1 0 512 9 1 1 0
f2 0 512 9 21 1 0 29 1 0 39 1 0
f5 0 512 7 .99 25 .99 206 .318 50 .318 206 .99 25 .99
f6 0 512 7 .377 256 .99 256 .377
f7 0 512 7 .5 15 .5 226 .9 30 .9 226 .5 15 .5
f8 0 512 7 .333 240 .999 16 .999 240 .333 8 .333

f0 1
s

i1 0 24 450 880 8 400 200 1660 6 200 20 12 70 2400 3
end

</CsScore>
</CsoundSynthesizer>
