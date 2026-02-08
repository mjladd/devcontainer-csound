<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 10_02_2.orc and 10_02_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        10_02_2.ORC
; timbre:       noise spectra, control bandwidth(ifqr), center freq(ifq1)
; synthesis:    Random Number Generation(10)
;               RANDI(02)
;               LINEN envelope on RANDI ring modulates an oscillator (2)
; source:       Dodge(1985), p.92
; coded:        jpg 8/92


instr 1; *****************************************************************
idur = p3
iamp = p4
ifq1 = p5
if1  = p6
ifqr = p7
irise = .2
idec  = .3

   kenv  linen    iamp, irise, idur, idec      ; envelope
   kran  randi    kenv, ifqr                   ; random numbers
   a1    oscili   kran, ifq1, if1              ; applied to amplitude slot
         out      a1

endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     10_02_2.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
f1  0  512  10  1       ;sinus


; score ******************************************************************

;    idur  iamp   ifq1  if1 ifqr ;control of pitched-ness in % can be added

i1  0  1   8000  400    1   80
i1  2  1   .     .      .   40
i1  4  1   .     .      .   20

e


</CsScore>
</CsoundSynthesizer>
