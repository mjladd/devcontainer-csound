<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_10_2.orc and 20_10_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_10_2.ORC
; synthesis: FM(20),
;            FM with dynamic spectral evolution (10)
;            wood-drum settings(2)
; source:    Chowning(1973)
; coded:     jpg 8/92

instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifenv  = 51                    ; wood drum settings:
ifdyn  = 31                    ; amp and index envelopes see flow chart
ifq1   = cpspch(p5)*16         ; N1:N2 is 80:55 = 16:11, imax=25
if1    = 1                     ; duration = .2 sec
ifq2   = cpspch(p5)*11
if2    = 1
imax   = 25

   aenv  oscili   iamp, 1/idur, ifenv             ; envelope

   adyn  oscili   ifq2*imax, 1/idur, ifdyn        ; dynamic
   amod  oscili   adyn, ifq2, if2                 ; modulator

   a1    oscili   aenv, ifq1+amod, if1            ; carrier
         out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_10_2.SCO
; coded:     jpg 8/92

; GEN functions **********************************************************
; carriers
f1  0  512  10  1
; envelopes
f31 0 512 7   1 64 0  448 0                ; index envelope
f51 0 513 5  .8 113 1   10   1 390 .0001   ; amplitude envelope

; score ******************************************************************
;    idur  iamp   pch
i1  0 .2   8000   3.00    ; scale in wood drum...
i1  +  .   .      3.02
i1  .  .   .      3.04
i1  .  .   .      3.05
i1  .  .   .      3.07
i1  .  .   .      3.09
i1  .  .   .      3.11
i1  .  .   .      4.00
s
i1  2 .2   8000   2.00    ; an octave lower
i1  +  .   .      2.02
i1  .  .   .      2.04
i1  .  .   .      2.05
i1  .  .   .      2.07
i1  .  .   .      2.09
i1  .  .   .      2.11
i1  .  .   .      3.00
e

</CsScore>
</CsoundSynthesizer>
