<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 43_01_2.orc and 43_01_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        43_01_2.ORC
; synthesis:    (g)buzz(43)
;               basic instrument(01)
;               EXPON envelope(2)
; coded:        jpg 10/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = p5
inmh   = int(sr/2/ifqc)

   aenv    expon   iamp, idur, .0001
   asrc    buzz    aenv, ifqc, inmh, 1
           out     asrc
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     43_01_2.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
f1 0 8193 10 1


; score ******************************************************************

;       idur  iamp  ifqc
i1   0   1    8000    55
i1   +   .    .      110
i1   .   .    .      440
i1   .   .    .     1760
i1   .   .    .     3520
i1   .   .    .     7040

e

</CsScore>
</CsoundSynthesizer>
