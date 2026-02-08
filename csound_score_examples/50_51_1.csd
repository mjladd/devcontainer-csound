<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 50_51_1.orc and 50_51_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     50_51_1.ORC
; synthesis: subtractive synthesis(50)
;            spectrum proportional to amplitude(51)
; source:    Dodge (1985)
; coded:     jpg 11/93




instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifq    = cpspch(p5)
irise  = .2
idec   = .2
inmh    = sr/2/ifq
iscale = .1

   kenv    linen  iamp, irise, idur, idec
   abuzz   gbuzz  kenv, ifq, inmh, 1, .9, 5
   a1      reson  abuzz, 0, kenv * iscale, 2
           out    a1

endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     50_51_1.SCO
; coded:     jpg 11/93

; GEN functions **********************************************************
; envelopes
f5  0   8192  11   1


; score ******************************************************************
t 0 80

;    start idur  iamp   ipch
i1    0     1    4000   7.00
i1    +     .    6000   .
i1    .     .    8000   .
i1    .     .    8000   7.04
i1    .     .    8000   7.07
i1    .     .    .      .
i1    .     .    7000   7.04
i1    .     .    4000   7.00

e



</CsScore>
</CsoundSynthesizer>
