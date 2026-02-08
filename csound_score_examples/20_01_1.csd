<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 20_01_1.orc and 20_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     20_01_1.ORC
; synthesis: FM(20),
;            simple FM (01), basic design(1)
; source:    Chowning (1973)
; coded:     jpg 8/92

instr 1; *****************************************************************
idur      = p3
iamp      = p4
ifq1      = p5
if1       = 1
imax      = p6
ifq2      = p7
if2       = 1
    amod    oscili    imax*ifq2, ifq2, if2     ; modulator
    aenv    linen     iamp, .1, idur, .1       ; prevent clicks
    a1      oscili    aenv, ifq1+amod, if1     ; carrier
            out       a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     20_01_1.SCO
; coded:     jpg 8/92

; GEN functions **********************************************************
; carrier
f1 0 512 10 1

; score ******************************************************************
;      idur iamp   ifq1  imax  ifq2                             c:m = 1:1
i1   1   1  8000   200    1     200
i1   +   .  .      .      2     .
i1   .   .  .      .      3     .
i1   .   .  .      .      4     .
i1   .   .  .      .      5     .

s
; section 2
;      idur iamp   ifq1  imax  ifq2                             c:m = 1:2
i1   1   1  8000   200    1     400
i1   +   .  .      .      2     .
i1   .   .  .      .      3     .
i1   .   .  .      .      4     .
i1   .   .  .      .      5     .
s
; section 3
;      idur iamp   ifq1  imax  ifq2                             c:m = 1:3
i1   1   1  8000   200    1     600
i1   +   .  .      .      2     .
i1   .   .  .      .      3     .
i1   .   .  .      .      4     .
i1   .   .  .      .      5     .
s
; section 4
;      idur iamp   ifq1  imax  ifq2          c:m = 1:1, 1:2, 1:3, 1:4, 1:5
i1   1   1  8000   200    1     200
i1   +   .  .      .      .     400
i1   .   .  .      .      .     600
i1   .   .  .      .      .     800
i1   .   .  .      .      .    1000
e
</CsScore>
</CsoundSynthesizer>
