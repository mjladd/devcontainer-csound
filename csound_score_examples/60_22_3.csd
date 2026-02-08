<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_22_3.orc and 60_22_3.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_22_3.ORC
; synthesis:  phase vocoder(60)
;             ktimpnt variable(22)
;             pointer control by LFO, santur1.pvc(3)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur    = p3
ifildur = 5   ; original audio file length

   ktimpnt   oscil  ifildur/20, .25, 1, .75
   ktimpnt   =      ktimpnt + ifildur/2
   aout      pvoc   ktimpnt, 1.0, "santur1.pvc"
             out    aout
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_22_3.SCO
; coded:   jpg 12/93


; GEN functions **********************************************************
f1  0  1024  10 1   ; sinus


; score ******************************************************************
;         idur

i1    0     5
e





</CsScore>
</CsoundSynthesizer>
