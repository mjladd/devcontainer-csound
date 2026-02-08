<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 43_01_3.orc and 43_01_3.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        43_01_3.ORC
; synthesis:    (g)buzz(43)
;               basic instrument(01)
;               EXPSEG envelope(3)
; coded:        jpg 10/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = p5
inmh   = p6

   aenv    expseg  .1, 1/10*idur,iamp, 9/10*idur, .1
   asrc    buzz    aenv, ifqc, inmh, 1
           out     asrc
endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     43_01_3.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
f1 0 8193 10 1


; score ******************************************************************

;       idur   iamp   ifqc    inh
i1   0    2    8000    125      5
i1   +    .    .       .       10
i1   .    .    .       .       15
i1   .    .    .       .       20
i1   .    .    .       .       40
e

</CsScore>
</CsoundSynthesizer>
