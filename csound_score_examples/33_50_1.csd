<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 33_50_1.orc and 33_50_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      33_50_1.ORC
; synthesis:  Amplitude Modulation(33)
;             "classical" AM(50)
; coded:      jpg 10/93


instr 1; *****************************************************************
idur  = p3
iamp  = p4/2  ; holding amplitude within range specified by p4
ifqc  = p5
ifc   = p6
imod  = p7    ; normalized modulation index
ifqm  = p8
ifm   = p9
ife   = 51

   amod   oscili  imod*iamp, ifqm, ifm      ; modulator
   a1     =       amod + iamp * (2-imod)    ; mix & scale

   aenv   oscili  a1, 1/idur, ife           ; envelope
   a2     oscili  aenv, ifqc, ifc           ; carrier

          out     a2
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     33_50_1.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
; carrier & modulator
f1 0 512 10 1  ; sinus

; envelope
f51 0 513  5     1   50     5000       462   1

; score ******************************************************************

;     idur iamp ifqc ifc imod  ifqm  ifm      ; increasing
i1  0   1  8000  400  1   0     100    1      ; modulation in steps of 0.2
i1  +   .  .     .    .   0.2   .      .      ; from 0 to 1
i1  .   .  .     .    .   0.4   .      .
i1  .   .  .     .    .   0.6   .      .
i1  .   .  .     .    .   0.8   .      .
i1  .   .  .     .    .   1     .      .

s

i1  0   1  8000  400  1   1     150    1      ; various modulators
i1  +   .  .     .    .   .     200    .
i1  .   .  .     .    .   .     300    .
i1  .   .  .     .    .   .     400    .
i1  .   .  .     .    .   .     800    .
i1  .   .  .     .    .   .    1200    .


e



</CsScore>
</CsoundSynthesizer>
