<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 10_03_1.orc and 10_03_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        10_03_1.ORC
; timbre:       various controlled noise spectra
; synthesis:    Random Number Generation(10)
;               RANDH(03)
;               LINEN envelope(1)
; notes:        serves to produce input files for PLUCK
; coded:        jpg 10/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifr   = p5
irise = .4
idec  = .4

   k1    linen     iamp, irise, idur, idec
   a1    randh     k1, ifr
         out       a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     10_03_1.SCO
; coded:     jpg 10/93


; score ******************************************************************
;                 RANDH
;       idur  iampr    ifr
i1   0   1     8000  10000
i1   +   .      .     5000
i1   .   .      .     2500
i1   .   .      .     2000
i1   .   .      .     1000
i1   .   .      .      500
i1   .   .      .      250
i1   .   .      .      125
i1   .   .      .       50
i1   .   .      .       25

e


</CsScore>
</CsoundSynthesizer>
