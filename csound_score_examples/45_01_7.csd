<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 45_01_7.orc and 45_01_7.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps =100
nchnls = 1

; ************************************************************************
; ACCCI:        45_01_7.ORC
; synthesis:    FOF (45)
;               Tutorial FOF(01)
;               rise of successive FOF granules(7)
; coded:        jpg 3/94


instr 1; *****************************************************************
idur   = p3

   kris line  .003, idur, .1        ; kris contour

   ;                            koct                        ifna    idur
   ;          xamp  xfund  xform  kband kris  kdur kdec iolaps  ifnb
   a1 fof     15000, 2,    300,  0,  0, kris, .5,  .1,   2,  1, 19, idur
      out     a1

endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     45_01_7.SCO
; coded:     jpg 3/94


; GEN functions **********************************************************
f1  0 4096  10  1
f19 0 1024  19 .5 .5 270 .5

; score ******************************************************************

;  istart idur

i1  0      10

e


</CsScore>
</CsoundSynthesizer>
