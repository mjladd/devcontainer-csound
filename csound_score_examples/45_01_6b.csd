<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 45_01_6b.orc and 45_01_6b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps =100
nchnls = 1

; *****************************************************************************
; ACCCI:        45_01_6B.ORC
; synthesis:    FOF (45)
;               Tutorial FOF(01)
;               smooth variation of formant(6B)
;               ifmode = 1.
; coded:        jpg 3/94


instr 1; **********************************************************************
idur   = p3

   aform line 400, idur, 800

   ;                            koct                       ifna  idur ifmode
   ;          xamp  xfund  xform  kband kris kdur kdec iolaps ifnb  iphs
   a1 fof     15000,   5,  aform,0,  1, .003, .5,  .1,  3,  1,19,idur,0, 1
      out     a1

endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     45_01_6B.SCO
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
