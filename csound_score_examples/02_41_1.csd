<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_41_1.orc and 02_41_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     02_41_1.ORC
; timbre:    brass
; synthesis: additive, same building blocks units(02)
;            basic instrument with added random frequency variation(41)
; source:    #200 Brass-like Sounds through Independent Control of
;            Harmonics, Risset(1969) /i1 and 17/
; coded:     jpg 8/93


instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifq1  =  p5
irise =  p6            ; steep rise  (.5 to 3 ms)
idec  =  p7            ; steep decay (4 to 11 ms)
ifundr=  p8 * .06      ; 6% of fundamental

        afqr   randi   ifundr, 10
        aenv   linen   iamp, irise, idur, idec
        a1     oscili  aenv, ifq1 + afqr, 1
               out     a1 * 8
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:    02_41_1.SCO
; coded:    jpg 8/93


; GEN functions **********************************************************
; waveform
f1 0 1024 9 1 1 0                ; sinus with amplitude 1, start phase 0


;score *******************************************************************
; instr 1  idur  iamp ifq1    irise   idec   ifundr

i1  0      .17    200  554    .0006  .0112     554     ;*** first note ***
i1  0      .17    160 1108    .0006  .0088      .      ;*** 9 harmonics **
i1  0      .17    350 1662    .00096 .0068      .
i1  0      .15    310 2216    .00112 .0064      .
i1  0      .14    160 2770    .00192 .0052      .
i1  0      .14    200 3324    .00216 .0048      .
i1  0      .14     99 3878    .00256 .0048      .
i1  0      .14    200 4432    .0024  .0048      .
i1  0      .14     80 4986    .0028  .0048      .

i1  2      .15     50  293    .0008  .0112     293    ;*** second note ***
i1  2      .15     80  586    .0008  .0112      .     ;*** 14 harmonics **
i1  2      .15    100  879    .00096 .0068      .
i1  2      .15    175 1172    .00136 .0064      .
i1  2      .15    180 1465    .002   .0052      .
i1  2.01   .15    150 1758    .0024  .0048      .
i1  2.01   .15    100 2051    .0028  .0048      .
i1  2.01   .13     80 2344    .0028  .0048      .
i1  2.01   .14     50 2637    .0032  .008       .
i1  2.01   .14     80 2930    .0032  .008       .
i1  2.01   .14    140 3223    .0036  .008       .
i1  2.01   .13     90 3516    .0036  .008       .
i1  2.01   .13     45 3809    .0032  .008       .
i1  2.01   .13     25 4102    .0032  .0072      .

e


</CsScore>
</CsoundSynthesizer>
