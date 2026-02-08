<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_20_4.orc and 20_20_4.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_20_4.ORC
; synthesis: FM(20),
;            double-carrier FM, dynamic spectral evolution (20)
;            synthesizing a formant region (1)
; source:    Chowning(1973)
; notes:     I am using the brass settings of 20_10_3.ORC
; coded:     jpg 10/93


instr 1; *****************************************************************
idur   = p3
iamp   = p4/2
ifenv  = 31                    ; brass settings:
ifdyn  = 31                    ; amp and index envelope as 20_10_3
ifq1   = p5
ifqmod = p5
imax1  = p6
imax2  = p7
imin   = 2
iform  = 2100                   ; fixed formant region at about 2100 Hz
ifq2   = int((iform/ifq1) + .5)*ifq1       ; make formant p5 dependent

   kenv  oscili   iamp, 1/idur, ifenv                   ; envelope

   kdyn  oscili   ifq2*(imax2-imin), 1/idur, ifdyn      ; index
   kdyn  =        (ifq2*imin)+kdyn                      ; add minimum value
   amod  oscili   kdyn, ifqmod, 1                       ; modulator

   a1    oscili   kenv, ifq1+amod, 1                    ; carrier 1
   a2    oscili   kenv*2, ifq2+(amod*(imax2/imax1)),1   ; carrier 2
         out      a1+a2

endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_20_4.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
; carriers
f1  0  512  10  1

; envelopes
f31 0 513 7 0 85 1  85 .75  258 .59 85 0      ; amplitude & index envelope

; score ******************************************************************

;    idur iamp   ifq1 imax1 imax2
i1  0  1  8000    300   3    1.5
i1  2  1  .       200   .    .
i1  4  1  .       400   .    .
e


</CsScore>
</CsoundSynthesizer>
