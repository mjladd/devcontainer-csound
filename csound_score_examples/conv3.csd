<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from conv3.orc and conv3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
inch      =         p4
irtime    =         p5
idel1     =         (int(irtime*kr)+1)/kr*2
asig      diskin    "hellorcb.aif", 1
awet      convolve  asig, "piano.con"
asig      delay     asig, idel1
          out       asig+awet*.005
          endin

          instr 2
inch      =         p4
irtime    =         p5
idel1     =         (int(irtime*kr)+1)/kr*2
asig      diskin    "hellorcb.aif", 1
awet      convolve  asig, "violin.con"
asig      delay     asig, idel1
          out       asig+awet*.005
          endin

          instr 3
inch      =         p4
irtime    =         p5
idel1     =         (int(irtime*kr)+1)/kr*2
asig      diskin    "hellorcb.aif", 1
awet      convolve  asig, "marimba.con"
asig      delay     asig, idel1
          out       asig*.5+awet*.005
          endin



</CsInstruments>
<CsScore>
; SCORE
f1 0 8192 10 1
;   Sta  Dur   InCh  IRTime
i1  0    4.1    1     1.05
s
i2  0   4.3     1     1.21
s
i3  0   4       1     1

</CsScore>
</CsoundSynthesizer>
