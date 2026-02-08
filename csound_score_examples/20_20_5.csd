<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_20_5.orc and 20_20_5.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_20_5.ORC
; synthesis: FM(20),
;            double-carrier FM, dynamic spectral evolution (20)
;            trumpet (5)
; source:    Morrill(1977)
; coded:     jpg 10/93


instr 1; *****************************************************************
idur      = p3
iamp      = p4/1.2
ifq1      = p5
imax1     = p6
ifq2      = p7
imax2     = p8
ifqm      = ifq1
iratio    = imax2/imax1

ivibwidth = .007      ; vibrato generator
irandev   = .007
ifqr      = 125
ivibrate  = 7
iportdev  = .03

; vibrato signal

   kwidth  linseg   0, .6, ivibwidth, idur - .6 - .2, ivibwidth, .2, 0
   kv1     randi    irandev, ifqr
   kv2     oscili   kwidth, ivibrate, 1
   kv3     oscili   iportdev, 1/idur, 31
   kv      =        (1+kv1)*(1+kv2)*(1+kv3)

; double-carrier, single modulator instrument

   kdyn    linseg   0, .03, 1, idur - .03 - .01, .9, .01, 0
   amod    oscili   kdyn*ifqm*imax1, ifqm*kv, 1

   kamp1   linseg   0, .03, 1, idur - .03 - .15, .9, .15, 0
   a1      oscili   kamp1*iamp, amod+(ifq1*kv), 1

   kamp2   linseg   0, .03, 1, idur - .03 - .3, .9, .3, 0
   a2      oscili   kamp2*iamp*.2, (amod*iratio)+(ifq2*kv), 1

           out      a1+a2
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_20_5.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
; carriers
f1  0  512  10  1

; envelopes
f31 0  512  -7  -1 150 .1 110 0 252 0      ; portamento deviation function


; score ******************************************************************

;    idur iamp ifq1  imax1 ifq2  imax2

i1  0  1  8000  250   2.66  1500  1.8
i1  2  2  .      .     .     .     .

e


</CsScore>
</CsoundSynthesizer>
