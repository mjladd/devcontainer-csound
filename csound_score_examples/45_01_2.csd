<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 45_01_2.orc and 45_01_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps =100
nchnls = 1

; ************************************************************************
; ACCCI:        45_01_2.ORC
; synthesis:    FOF (45)
;               Tutorial FOF(01)
;               LINSEG envelope(2)
; coded:        jpg 3/94


instr 1; *****************************************************************
idur   = p3
ifq    = p4

   aenv  linseg  0, idur*.3, 20000, idur*.4, 15000, idur*.3, 0

   ;                            koct                       ifna     idur
   ;          xamp  xfund  xform  kband kris  kdur kdec iolaps ifnb
   a1 fof     aenv,  ifq,  650, 0,  40, .003, .02, .007,  5, 1, 19, idur
      out     a1

endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     45_01_2.SCO
; coded:     jpg 3/94


; GEN functions **********************************************************
f1  0 4096  10  1
f19 0 1024  19 .5 .5 270 .5

; score ******************************************************************

;  istart idur ifq

i1  0     3    200

e


</CsScore>
</CsoundSynthesizer>
