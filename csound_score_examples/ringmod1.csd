<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ringmod1.orc and ringmod1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


;;; GENERATION OF NOISE BANDS BY RING MODULATION
;;; FIGURE 3.25 FROM DODGE & JERSE, p.92



          instr     1
kramp     linseg    0,p3/2,p4,p3/2,0
krcps     =         p5*.05
kamp      randi     kramp,krcps
kfreq     =         p5
aosc      oscil     kamp,kfreq,1
aout      =         aosc
          out       aout
          endin

</CsInstruments>
<CsScore>
;;; score for 3.25

f1 0 8192 10 1
;p1 p2 p3 p4 p5
;inst start length amp freq
i1 0.00 1.00 15000 300

</CsScore>
</CsoundSynthesizer>
