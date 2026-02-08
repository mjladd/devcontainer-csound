<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 10_01_1.orc and 10_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        10_01_1.ORC
; timbre:       various controlled noise spectra
; synthesis:    Random Number Generation(10)
;               RAND(01)
;               LINEN envelope(1)
; coded:        jpg 10/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4
irise = .4
idec  = .4

   k1    linen     iamp, irise, idur, idec
   a1    rand      k1
         out       a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     10_01_1.SCO
; coded:     jpg 10/93


; score ******************************************************************
;             RAND
;       idur  iamp
i1   0   4    8000

e

</CsScore>
</CsoundSynthesizer>
