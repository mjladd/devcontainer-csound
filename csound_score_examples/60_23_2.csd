<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 60_23_2.orc and 60_23_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      60_23_2.ORC
; synthesis:  phase vocoder(60)
;             kfmod variable(23)
;             transposition control by LINSEG, speech1.pvc(2)
; coded:      jpg 12/93




instr 1; *****************************************************************
idur    = p3
ibeg    = p4
ifqsc   = cpspch(p5)/200    ; scale frequency down, towards unity
imid    = p6                ; assuming fundamental of 200 Hz...
iend    = p7

   ktimpnt   line   0, idur, 5.1
   kfmod     linseg ibeg, idur/2, imid, idur/2, iend
   aout      pvoc   ktimpnt, ifqsc*kfmod, "speech1.pvc"
             out    aout
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   60_23_2.SCO
; coded:   jpg 12/93


; score ******************************************************************
;           idur  ibeg    ipch  imid   iend
i1    0.0     5    .5     8.00   .4     .8
i1    +       .    .9     7.09  1.0     .7
e




</CsScore>
</CsoundSynthesizer>
