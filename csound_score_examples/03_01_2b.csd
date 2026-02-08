<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 03_01_2b.orc and 03_01_2b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

;************************************************************************
; ACCCI:     03_01_2B.ORC
; modified:  changed randi to rand: brighter noise quality
; timbre:    pitched noise instrument, drum like
; synthesis: additive different units(03)
;            units: noise/inharm/fundamental
; coded:     jpg 9/93



instr 1; *****************************************************************
idur  =  p3
iamp7 =  p4
ifq1  =  p5
iamp2 =  p4 * .8
ifq3  =  p5 * .1
iamp4 =  p4 * .3

         a5     rand    iamp7, 1500
         a5     oscili  a5, 1/idur, 52
         a5     oscili  a5, 4000, 1

         a3     oscili  iamp4, 1/idur, 52
         a3     oscili  a3, ifq3, 11

         a1     oscili  iamp2, 1/idur, 51
         a1     oscili  a1,    ifq1, 1

                out     a1+a3+a5
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     03_01_2B.SCO
; source:    risset2.sco,  M.I.T.(1993)
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveforms
f1   0  2048  10  1
f11  0   512   9  10 1  0  16  1.5  0  22  2  0  23  1.5  0

; envelopes
f51  0   513   5   256  512  1
f52  0   513   5  4096  512  1



; score ******************************************************************
t0  60 10 120

;  start  idur iamp7  ifq1
i1   0     1   6000   100
i1   +     .    .     200
i1   .     .    .     300
i1   .     .    .     400
i1   .     .    .     500
i1   .     .    .     600
i1   .     .    .     700
i1   .     .    .     800
i1   .     .    .     900
i1   .     .    .    1000
s

t0  480

i1   0     1   6000  1000
i1   +     .    .     900
i1   .     .    .     800
i1   .     .    .     700
i1   .     .    .     600
i1   .     .    .     500
i1   .     .    .     400
i1   .     .    .     300
i1   .     .    .     200
i1   .     .    .     100

e



</CsScore>
</CsoundSynthesizer>
