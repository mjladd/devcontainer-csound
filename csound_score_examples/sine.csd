<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from sine.orc and sine.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;*******************************************************
;;         basic orchestra file
;;
;;         p3 = duration        p4 = amplitude
;;         p5 = pitch in pch
;;
;;*******************************************************;
instr     1
asig      oscili    p4,cpspch(p5),1
          out       asig
          endin

</CsInstruments>
<CsScore>
f1 0.0 512 10 1
i1 0.0 1.0 10000 8.09
e

</CsScore>
</CsoundSynthesizer>
