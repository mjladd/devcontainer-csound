<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_22_2.orc and 60_22_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_22_2.ORC
; synthesis:  phase vocoder(60)
;             ktimpnt variable(22)
;             pointer control by EXPON, santur1.pvc(2)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur    = p3
ifildur = 5

   ktimpnt   expon  .1, idur, ifildur
   aout      pvoc   ktimpnt, 1.0, "santur1.pvc"
             out    aout
endin


instr 2; *****************************************************************
idur    = p3
ifildur = 5

   ktimpnt   expon  ifildur, idur, .1
   aout      pvoc   ktimpnt, 1.0, "santur1.pvc"
             out    aout
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_22_2.SCO
; coded:   jpg 12/93


; score ******************************************************************
;         idur
i1    0     5  ; forward up
i2    5    10  ; and backwards down
e



</CsScore>
</CsoundSynthesizer>
