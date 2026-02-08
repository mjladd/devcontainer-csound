<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_10_4.orc and 20_10_4.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_10_4.ORC
; synthesis: FM(20),
;            FM with dynamic spectral evolution (10)
;            clarinet settings(3)
; source:    Chowning (1973)
; coded:     jpg 8/92


instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifenv  = 51                    ; clarinet settings:
ifdyn  = 52                    ; amp and index envelope see flow chart
ifq1   = cpspch(p5)*3          ; N1:N2 is 3:2, imax=5
if1    = 1                     ; duration ca. .5 sec
ifq2   = cpspch(p5)*2
if2    = 1
imax   = p6
imin   = 2

   aenv  oscili   iamp, 1/idur, ifenv                ; envelope

   adyn  oscili   ifq2*(imax-imin), 1/idur, ifdyn    ; index
   adyn  =        (ifq2*imin)+adyn                   ; add minimum value
   amod  oscili   adyn, ifq2, if2                    ; modulator

   a1    oscili   aenv, ifq1+amod, if1               ; carrier
         out      a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_10_4.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
; carriers
f1  0  512  10  1

; envelopes
f51 0 1024  5  .0001 200 1 674 1 150 .0001       ; amplitude envelope
f52 0 1024  5  1 1024 .0001                      ; index envelope


; score ******************************************************************

;    idur iamp   pch imax
i1  0 .5  8000   8.00   4        ; scale by clarinet
i1  +  .  .      8.02   .
i1  .  .  .      8.04   .
i1  .  .  .      8.05   .
i1  .  .  .      8.07   .
i1  .  .  .      8.09   .
i1  .  .  .      8.11   .
i1  .  .  .      9.00   .

e


</CsScore>
</CsoundSynthesizer>
