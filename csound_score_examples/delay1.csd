<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from DELAY1.ORC and DELAY1.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1


               instr     1
     ipitch    =         cpspch(p5)
     idlt      =         1/ipitch
     arnd      rand      p4
     apop      envlpx    arnd,.002,.005,.002,2,1,.01
     asig      init      0
     adelay    delay     (apop+asig),idlt
     afilter   reson     adelay,ipitch,(ipitch*.1),1
     abal      balance   afilter,arnd
     asig      envlpx    abal,.03,p3,.1,2,.15,.01
               out       asig
               endin


</CsInstruments>
<CsScore>
f1   0    512  10   1
f2   0    513  5    0.001     512  1    1    1
i1   0    5    4000 8.00e

</CsScore>
</CsoundSynthesizer>
