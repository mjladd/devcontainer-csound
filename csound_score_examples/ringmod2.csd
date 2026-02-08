<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ringmod2.orc and ringmod2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


;;; RING-MODULATION INSTRUMENT BASED ON RISSET
;;; FIGURE 3.30 FROM DODGE & JERSE, p.98



          instr     1
kamp1     linseg    0,p3/2,p4,p3/2,0
kfreq1    =         p5
asig1     oscil     kamp1,kfreq1,1
kamp2     =         p6
kfreq2    =         p7
asig2     oscil     kamp2,kfreq2,2
aout      =         asig1*asig2
          out       aout
          endin

</CsInstruments>
<CsScore>
;;; sample score for 3.30

f1 0 8192 10 1
f2 0 128 7 0 10 1 44 1 20 -1 44 -1 10 0

;inst start length kamp1 kfreq1 kamp2 kfreq2 ;p1 p2 p3 p4   p5   p6   p7

i1 0.00 2.745 25 395 23 272
i1 2.41 3.242 38 387 37 178
i1 6.07 5.702 52 363 24 268
i1 5.88 3.316 27 310 28 223
i1 8.85 5.094 27 372 23 572
i1 9.15 9.144 43 489 48 325

</CsScore>
</CsoundSynthesizer>
