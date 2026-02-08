<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from noise3.orc and noise3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;GIVEN: THERE EXIST TRADE-OFFS WHEN FILTERING NOISE IN AN EFFORT TO MAKE USABLE
;SOUNDS.
;THAT DOES NOT MEAN IT CAN'T BE FUN.
;NEARLY ANY VARIABLE EFFECTS OUTPUT (AMPLITUDE).
;I FIND THIS TALK OF NOISE CARVING ARTISTICALLY FASCINATING.


          instr 1

kamp      linen     .01,.01,p3,.2
kpass     line      p4,p3,p5
arand     rand      10000
afilter   reson     arand,kpass,0.048
asculpt   =         kamp*afilter
amold     envlpx    .00005,.03,p3,.06,1,.5,.01,0.8
          outs      asculpt*amold,asculpt*amold
          endin


</CsInstruments>
<CsScore>
;SCORE FILE ONE...SIX TONES

f1 0 32 -2 1 2 3 2 2 2 1 1 1 1 1 1 1 1
t 0 150
;I START DUR BEGIN  END
i1 0    .72  400    375
i1 1    .72  330    300
i1 2    .72  205    200
i1 3    .72  144    140
i1 4    .72  100     90
i1 5    .72  74      75


;SCORE FILE TWO...RHYTHMIC CONFIGURATION

s
t 0 150
;I START DUR BEGIN END
i1 0     .72 144   140
i1 0.24  .72 74     75
i1 .75   .72 205   200
i1 1.5   .72 144   140
i1 1.44  .72 74     75
i1 2.25  .72 440   375
i1 2.15  .72 330   300
i1 3     .72 144   140
i1 3.05  .72 74     75
i1 4     .72 100    90
i1 5     .72 144   140
i1 5.06  .72 74     75



</CsScore>
</CsoundSynthesizer>
