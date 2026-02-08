<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_01_4.orc and 01_01_4.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      01_01_4.ORC
; synthesis:  simple(01)
;             basic instrument(01),
;             envelope through LINEN unit generator(4)
; coded:      jpg 10/93


instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifq    = p5
if1    = p6
irise  = p7
idec   = p8

   a2    linen    iamp, irise, idur, idec
   a1    oscili   a2, ifq, if1
         out      a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_01_4.SCO
; coded:     jpg 10/93

; GEN functions **********************************************************
; waveform
f1 0 512 10 1

; score ******************************************************************

;  start  idur  iamp    ifq  if1    irise idec
i1   0     1     8000   440   1      .2    .3
i1   2     1     .      .     .      .1    .1
i1   4     1     .      220   .      .05   .2
i1   6     1     .      .     .      .3    .4     ; string like

e

</CsScore>
</CsoundSynthesizer>
