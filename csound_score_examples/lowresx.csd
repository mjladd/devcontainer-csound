<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from lowresx.orc and lowresx.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1



          instr     1


a1        oscili    5000,p4,1
kenv      expseg    10,p3/2,500,p3/2,10
a1        lowresx    a1,kenv,p5,4
          out       a1
          endin




</CsInstruments>
<CsScore>
f1 0 2048 11 80 0 .9

i1 0 5 100 .5
i1 5 5 30 .8
i1 10 5 200 .4



</CsScore>
</CsoundSynthesizer>
