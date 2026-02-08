<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_22_1b.orc and 60_22_1b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_22_1B.ORC
; synthesis:  phase vocoder(60)
;             ktimpnt variable(22)
;             pointer control by LINSEG, speech1.pvc(1B)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur  = p3
ifmod = p4

ktimpnt linseg  0,idur/6,1.1,idur/6,1.2,idur/24,1.3,3*idur/24,1.6,idur/2,5

aout    pvoc    ktimpnt, ifmod, "speech1.pvc", 0
        out     aout
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_22_1B.SCO
; coded:   jpg 12/93


; score ******************************************************************
;         idur   ifmod

i1   0      5      1.0       ; long note

i1   6      3.8     .69

e


</CsScore>
</CsoundSynthesizer>
