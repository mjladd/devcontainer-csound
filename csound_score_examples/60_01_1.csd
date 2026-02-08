<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_01_1.orc and 60_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_01_1.ORC
; synthesis:  phase vocoder(60)
;             testfiles(01)
;             4 partials, 1 second(1)
; coded:      jpg 8/93


instr 1; *****************************************************************
iamp  = p4
ifq   = p5

   a1    oscil    iamp, ifq, 11
         out      a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_01_1.SCO
; coded:   jpg 8/93


; GEN functions **********************************************************
; carrier
f11   0 2048 10 1 1 1 1              ; 4 partials


; score ******************************************************************

;     idur  iamp   ifq
i1  0   1   8000  1000
e


</CsScore>
</CsoundSynthesizer>
