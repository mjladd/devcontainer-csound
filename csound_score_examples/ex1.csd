<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ex1.orc and ex1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
kpitcheg  linseg    1,p3/2,p6,p3/2,1
kenv      linen     p4, 1, p3, .25
asig1     oscil     kenv, p5*kpitcheg,1
asig2     oscil     kenv, (p5+10)*kpitcheg,1
asig3     oscil     kenv, (p5-10)*kpitcheg,1
amix      =         asig1 + asig2 + asig3
          out       amix
          endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
i1 0 5 3000 440 2
s
i1 0 5 3000 140 4
s
i1 0 5 3000 40 8
s
i1 0 5 3000 4444 -12
s
i1 0 5 3000 10 202
s
e

</CsScore>
</CsoundSynthesizer>
