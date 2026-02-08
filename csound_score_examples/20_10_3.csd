<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_10_3.orc and 20_10_3.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_10_3.ORC
; synthesis: FM(20),
;            FM with dynamic spectral evolution (10)
;            brass settings(3)
; coded:     jpg 8/92


instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifenv  = 31                    ; brass settings:
ifdyn  = 31                    ; amp and index envelope see flow chart
ifq1   = cpspch(p5)            ; N1:N2 is 1:1, imax=5
if1    = 1                     ; duration ca. .6 sec
ifq2   = cpspch(p5)
if2    = 1
imax   = 5

   aenv  oscili   iamp, 1/idur, ifenv             ; envelope

   adyn  oscili   ifq2*imax, 1/idur, ifdyn        ; dynamic
   amod  oscili   adyn, ifq2, if2                 ; modulator

   a1    oscili   aenv, ifq1+amod, if1            ; carrier
         out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_10_3.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
; carriers
f1  0  512  10  1

; envelopes
f31 0 513 7 0 80 1  80 .85  290 .8 63 0      ; amplitude & index envelope


; score ******************************************************************

;    idur  iamp   pch
i1  0 .6  20000  8.00    ; scale in brass...
i1  +  .  .      8.02
i1  .  .  .      8.04
i1  .  .  .      8.05
i1  .  .  .      8.07
i1  .  .  .      8.09
i1  .  .  .      8.11
i1  .  .  .      9.00

e


</CsScore>
</CsoundSynthesizer>
