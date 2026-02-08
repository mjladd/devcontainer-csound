<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from karplus3.orc and karplus3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; KARPLUS.ORC
;SIMPLE VERSIONS OF THE KARPLUS STRONG ALGORITHM


;THE KARPLUS-STRONG PLUCKED STRING

          instr     1
afeedback init      0
anoise    =         0
ilooptime =         1/cpspch(p4)
iamp      =         p5
krandenv  linseg    1, ilooptime, 1, 0, 0, p3-ilooptime, 0
anoise    rand      krandenv

a2        delay     afeedback+anoise,ilooptime
a3        delay1    a2
afeedback =         (a2+a3)*.5

          out       a2*iamp

          endin


          instr     2
afeedback init      0
anoise    =         0
ilooptime =         1/cpspch(p4)
iamp      =         p5
          timout    ilooptime, p3-ilooptime, skiprand
anoise    rand      1
skiprand:
adum      delayr    .2
a2        deltapi   ilooptime
          delayw    afeedback+anoise
a3        delay1    a2
afeedback =         (a2+a3)*.5

          out       a2*iamp

          endin


          instr     3


irevtime  =         10
ilooptime =         1/cpspch(p4)
          timout    ilooptime, p3-ilooptime, skiprand
asig      rand      p5
skiprand:
adel      init      0
adelin    init      0
adel      delay     adelin, ilooptime
aton      tone      adel, 10000
adelin    =         aton + asig
asig      =         0

          out       adel
          endin

</CsInstruments>
<CsScore>
; KARPLUS.SCO

i1 1 5 6.09 5000
i2 7 5 7.09 5000
i3 13 5 8.09 5000
f 0 15
e

</CsScore>
</CsoundSynthesizer>
