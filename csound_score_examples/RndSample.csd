<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RndSample.orc and RndSample.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; '2D' random Sample indexer

ilevl    = p4*32767 ; Level
iratex   = p5       ; X rate
iratey   = p6       ; Y rate

iseed    = rnd(1)                       ; Generate random seed value
krndx    randi  .5, iratex              ; X random index
krndy    randi  .5, iratey              ; Y random index
ax       table3  .5 + krndx, 1, 1, 0, 1 ; X indexing
ay       table3  .5 + krndy, 2, 1, 0, 1 ; Y indexing
out      ax*ay*ilevl                    ; Output

endin

</CsInstruments>
<CsScore>
f1 0 524288 1 "monks.1" 0 4 0 ; X Sample1
f2 0 65536 1 "Marimba.aif" 0 4 0 ; Y Sample1

;   Strt  Leng  Levl  RateX RateY
i1  0.00  8.00  1.00  0.75  1.11
e


</CsScore>
</CsoundSynthesizer>
