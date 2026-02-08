<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 03_05_1.orc and 03_05_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     03_05_1.ORC
; timbre:    drum, metallic
; synthesis: additive different units(03)
;            units: noise/inharm/inharm(05)
; source:    #410 Percussive Drum-like Sounds, Risset(1969)
; coded:     jpg 9/93


instr 1; *****************************************************************
idur = p3
iamp = p4/3
ifq  = p5
if1  = p6
if2  = p7

   a3     oscili  iamp, 1/idur, 52
   a3     rand    a3, 400
   a3     oscili  a3, 500, 11

   a2     oscili  iamp, 1/idur, 52
   a2     oscili  a2, ifq, if2

   a1     oscili  iamp, 1/idur, 51
   a1     oscili  a1, ifq, if1

          out     (a1+a2+a3) * 6

endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     03_05_1.SCO
; coded:     jpg 9/93

; GEN functions **********************************************************
; waveforms
f11  0   512   9  1  1  0
f12  0   512   9  10 1 0  16 1.5 0  22 2.  0  23 1.5 0
f13  0   512   9  25 1 0  29  .5 0  32  .2 0
f14  0   512   9  16 1 0  20 1.  0  22 1   0  34 2   0  38 1 0   47 1 0
f15  0   512   9  50 2 0  53 1   0  65 1   0  70 1   0  77 1 0  100 1 0

; envelopes
f51  0   513   5  4096 512 1 ; equals '1 512 .00024' after normalization
f52  0   513   5   128 512 1 ; equals '1 512 .0078'

; score ******************************************************************
;        idur    iamp   ifq  if1  if2
i1   1    0.8    1500    5    13   12
i1   2    2.0
i1   5    4

i1  10     .8    1500    5    15   14
i1  11    2.0
i1  14.5  4

s 2

i1   1    0.8    1500   15    13   12
i1   2    2.0
i1   5    4.0

e

</CsScore>
</CsoundSynthesizer>
