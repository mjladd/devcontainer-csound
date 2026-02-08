<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from steam.orc and steam.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          ; STEAM

          instr 1

asig      init      1
kvar      randi     3000,.7
kfreq     =         3190+kvar
afun      rand      1000,1000
asig      butterlp  afun+.9*asig,kfreq
          out       asig
          endin

</CsInstruments>
<CsScore>


i1   0    20
e

</CsScore>
</CsoundSynthesizer>
