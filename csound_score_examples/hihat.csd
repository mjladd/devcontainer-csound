<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from hihat.orc and hihat.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2




garev1    init      0
garev2    init      0


          ; HIHAT

          instr 1
k1        linen     p4, 0, p3, .08
asig      rand      k1
a1        =         (1-p6)*asig
a2        =         p6*asig
          outs      a1*(1-p7), a2*(1-p7)

garev1    =         garev1 + a1*p7
garev2    =         garev2 + a2*p7
          endin


          ; REVERB

          instr 99
a1        reverb    garev1, p4
a2        reverb    garev2, p4+.03
          outs      a1, a2
garev1    =         0
garev2    =         0
          endin


</CsInstruments>
<CsScore>

;HIHAT SCORE

t	0	70
f0	0 	.5

s
t	0	70


i99     0       8       1
i1      0.5     .125    50      880     0.0     .5
i.      1.5     .       .       .       1.0     .
i.      2.5     .       .       .       0.0     .
i.      3.5     .       .       .       1.0     .
i.      4.5     .       .       .       0.0     .
i.      5.5     .       .       .       1.0     .
i.      6.5     .       .       .       0.0     .
i.      7.5     .5      .       .       1.0     .
e


</CsScore>
</CsoundSynthesizer>
