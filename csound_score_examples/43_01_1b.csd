<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 43_01_1b.orc and 43_01_1b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        43_01_1B.ORC
; synthesis:    (g)buzz(43)
;               basic instrument(01)
;               LINEN envelope, constant inh(1B)
; coded:        jpg 10/93




instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = p5
inmh   = 10

   aenv    linen   iamp, .2, idur, .2
   asrc    buzz    aenv, ifqc, inmh, 1
           out     asrc
endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     43_01_1B.SCO
; coded:     jpg 10/93
; notice the foldover in the last note, due to constant inh parameter..


; GEN functions **********************************************************
f1 0 8193 10 1


; score ******************************************************************

;     idur  iamp  ifqc
i1 0   2    8000   55
i1 +   .    .     110
i1 .   .    .     440
i1 .   .    .    1760
i1 .   .    .    3520
i1 .   .    .    7040
i1 .   .    .   14080
e


</CsScore>
</CsoundSynthesizer>
