<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_10_1.orc and 20_10_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_10_1.ORC
; synthesis: FM(20),
;            FM with dynamic spectral evolution (10)
;            bell settings(1)
; source:    Chowning (1973)
; coded:     jpg 8/92


instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifenv  = 51                    ; bell settings:
ifdyn  = 52                    ; amp and index envelopes are exponential
ifq1   = cpspch(p5)*5          ; decreasing, N1:N2 is 5:7, imax=10
if1    = 1                     ; duration = 15 sec
ifq2   = cpspch(p5)*7
if2    = 1
imax   = 10

   aenv  oscili  iamp, 1/idur, ifenv             ; envelope

   adyn  oscili  ifq2*imax, 1/idur, ifdyn        ; dynamic
   amod  oscili  adyn, ifq2, if2                 ; modulator

   a1    oscili  aenv, ifq1+amod, if1            ; carrier
         out     a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_10_1.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
; carrier
f1  0  512  10  1

; envelopes
f51 0 513 5 1 513 .0001
f52 0 513 5 1 513 .001


; score ******************************************************************

;       idur iamp  ifq1
i1   0   15  8000  5.07
e



</CsScore>
</CsoundSynthesizer>
