<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_23_1.orc and 60_23_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_23_1.ORC
; synthesis:  phase vocoder(60)
;             kfmod variable(23)
;             transposition control by EXPON, santur1.pvc(1)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur    = p3
itarget = p4
ioct    =  octpch(p5)

   ktimpnt   line   0, idur, 5
   kfmod     expon  .1, idur, .1+itarget
   aout      pvoc   ktimpnt, cpsoct(ioct-.3*kfmod)/440, "santur1.pvc"
             out    aout/3
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_23_1.SCO
; coded:   jpg 12/93


; GEN functions **********************************************************
; carrier
f11   0 8193 10 1               ; sinus


; score ******************************************************************
;           idur  itarget     ipch
i1    0.0     5      3        10.00
i1    6.0     1      1         9.11
i1     +      .      .        10.00
i1     .      .      .        10.02
e




</CsScore>
</CsoundSynthesizer>
