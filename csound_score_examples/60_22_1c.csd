<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_22_1c.orc and 60_22_1c.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_22_1C.ORC
; synthesis:  phase vocoder(60)
;             ktimpnt variable(22)
;             pointer control by LINE, snap1.pvc(1C)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur = p3

   ktimpnt   line   .71, idur, .75
   aout      pvoc   ktimpnt, 1.0, "snap1.pvc"
             out    aout
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_22_1C.SCO
; coded:   jpg 12/93


; score ******************************************************************
;         idur

i1   0    10      ; 10 s/.04 s   250 times larger

e





</CsScore>
</CsoundSynthesizer>
