<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_01_3.orc and 01_01_3.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     01_01_3.ORC
; synthesis: simple(01),
;            basic instrument(01)
;            complex waveform created with GEN 10
;            envelope are line functions taken from GEN 07 tables
; source:    #300  Linear  and  Exponential  Decay  Experiments,
;            Risset(1969)
; coded:     jpg 8/93


instr  1; ****************************************************************
idur  =  p3
iamp  =  p4
ifq1  =  p5
if1   =  p6
if2   =  p7

   a2  oscili  iamp, 1/idur, if2   ;if2   chooses lin or exp decay
   a1  oscili  a2, ifq1, if1       ;if1   chooses waveform
       out     a1

endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_01_3.SCO
; source:    #300 Linear and Exponential Decay Experiments,
;            Risset(1969)
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveforms
f31 0  1024  7   0 128 10 256 10 256 -10 256 -10 128 0    ;ca. square wave
f11 0  1024 10   1 .5 .3  .2 .15 .12               ;six weighted sinusoids
f12 0  1024 10   1 .2 .05                        ;three weighted sinusoids

; envelopes
f32 0  8192   7  1      8192  0
f51 0  8193   5  8192   8192  1

; score ******************************************************************

;   start  idur  iamp  ifq1  if1   if2
i1    1     2    8000   440   11   32       ; middle
i1    4     .    .      .     .    51

i1    7     4    .      .     .    32       ; long
i1   12     .    .      .     .    51

i1   17     1    .      .     .    32       ; short
i1   19     .    .      .     .    51

i1   21     .51  .      .     .    32       ; shorter
i1   23     .    .      .     .    51
e

</CsScore>
</CsoundSynthesizer>
