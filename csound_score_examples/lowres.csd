<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from lowres.orc and lowres.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          instr     1


a1        oscili    10000,p4,1
kenv      expseg    10,p3/2,500,p3/2,10
a1        lowres     a1,kenv,p5
          out       a1
          endin




</CsInstruments>
<CsScore>
f1 0 2048 11 80 0 .9

i1 0 5 100 2
i1 5 5 30 15
i1 10 5 200 7



</CsScore>
</CsoundSynthesizer>
