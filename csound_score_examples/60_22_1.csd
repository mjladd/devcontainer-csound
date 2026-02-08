<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_22_1.orc and 60_22_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_22_1.ORC
; synthesis:  phase vocoder(60)
;             ktimpnt variable(22)
;             pointer control by LINE, santur1.pvc(1)
; coded:      jpg 12/93



instr 1; *****************************************************************
idur = p3

   ktimpnt   line   0, idur, 5                ; original file is 5 seconds

   aout      pvoc   ktimpnt, 1.0, "santur1.pvc"
             out    aout
endin

instr 2; *****************************************************************
idur = p3

   ktimpnt   line   5, idur, 0                        ; play it backwards

   aout      pvoc   ktimpnt, 1.0, "santur1.pvc"
             out    aout
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_22_1.SCO
; coded:   jpg 12/93

; score ******************************************************************
;         idur
i1    0    5      ; original re-synthesized
i2    7    5      ; backwards
i1   15    15     ; blown up to 3 * original length
i1   35     2.5   ; compressed to 1/2 of original length
e

</CsScore>
</CsoundSynthesizer>
