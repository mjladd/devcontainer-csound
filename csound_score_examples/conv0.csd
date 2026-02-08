<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from conv0.orc and conv0.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr     1
adry      diskin    "speech1.aif", 1
awet      convolve  adry,"fiveEchos.con"
          out       awet
          endin


</CsInstruments>
<CsScore>
i1 0 60
e

</CsScore>
</CsoundSynthesizer>
