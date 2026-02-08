<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_42_1.orc and 01_42_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        01_42_1.ORC
; synthesis:    simple(01)
;               basic instrument with small scale FM for vibrato (42)
; source:       Dodge(1985)
; coded:        jpg 10/93


instr 1; *****************************************************************
idur   =  p3
iamp   =  p4
ifqc   =  p5
ifc    =  p6
iwidth =  p7
irate  =  p8
ifm    =  p9

    amod   oscili   iwidth, irate, ifm           ; LFO modulator
    amod   =        ifqc + amod
    aenv   linen    iamp, .1, idur, .1           ; prevent clicks
    a1     oscili   aenv, amod, ifc              ; carrier waveform
           out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_42_1.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
; waveform
f1 0 512 10 1       ; sinus


; score ******************************************************************

;  st idur  iamp  ifqc  ifc     iwidth  irate  ifm
i1  0   1   8000   800    1        8       5     1
i1  3   1   .      .      .       16       .     .
i1  6   1   .      .      .       24       .     .

i1  9   1   .      .      .        8       2     .
i1 12   1   .      .      .       16       .     .
i1 15   1   .      .      .       24       .     .

e


</CsScore>
</CsoundSynthesizer>
