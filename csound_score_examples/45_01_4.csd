<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 45_01_4.orc and 45_01_4.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps =100
nchnls = 2

; ************************************************************************
; ACCCI:        45_01_4.ORC
; synthesis:    FOF (45)
;               Tutorial FOF(01)
;               granular to timbre(4)
; coded:        jpg 3/94


instr 1; *****************************************************************
idur   = p3

   afq expseg 5, idur*.8, 200, idur*.2, 150   ; fund. frequency contour

   ;                            koct                        ifna    idur
   ;          xamp  xfund  xform  kband kris  kdur kdec iolaps ifnb
   a1 fof     15000, afq,  650, 0,  40, .003, .02, .007,  5, 1, 19, idur
      outs     a1,a1

endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     45_01_4.SCO
; coded:     jpg 3/94


; GEN functions **********************************************************
f1  0 4096  10  1
f19 0 1024  19 .5 .5 270 .5

; score ******************************************************************

;  istart idur

i1  0     10

e


</CsScore>
</CsoundSynthesizer>
