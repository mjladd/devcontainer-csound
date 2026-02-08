<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_01_7.orc and 02_01_7.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     02_01_7.ORC
; synthesis: additive with same units via parallel score file calls(02),
;            basic instrument(01)
;            experiments (7)
; source:    #300  Linear  and  Exponential  Decay  Experiments,
;            Risset(1969)
; coded:     jpg 8/93



instr  1; ****************************************************************
idur  =  p3
ifq1  =  p4
if1   =  p5
iamp  =  p6
if2   =  p7

   a2  oscili iamp, 1/idur, if2    ; if2 chooses lin or exp decay
   a1  oscili a2, ifq1, if1        ; if1 chooses waveform
       out    a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     02_01_7.SCO
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveform
f31 0  1024  7   0 128 10 256 10 256 -10 256 -10 128 0    ;ca. square wave
f11 0  1024 10   1 .5 .3  .2 .15 .12               ;six weighted sinusoids
f12 0  1024 10   1 .2 .05                        ;three weighted sinusoids

; envelopes
f32 0  512   7  .99 512 0
f51 0  513   5  256   512  1


; dependency harmonic content and decay time is compared
; alternating straight 440 frequency with beats, i.e. slightly detuned


; score ******************************************************************

;   start  idur  ifq1  if1  iamp   if2

i1    0      .1   440   31  10000   51      ; section 1
i1    0     1.8   .     11   3500
i1    0     3     .     12   2000

i1    4      .1   443   31  10000   51      ; section 2
i1    4     1.8   440   11   3500
i1    4     3     441   12   2000



i1    8      .1   440   12  10000   51      ; section 3
i1    8     1.8   .     11   3500
i1    8     3     .     31   2000

i1   12      .1   443   12  10000   51      ; section 4
i1   12     1.8   440   11   3500
i1   12     3     441   31   2000



i1   16      .1   440   31  10000   51      ; section 5
i1   16     1     .     11   3500
i1   16     3.8   .     12   2000

i1   20      .1   448   31  10000   51      ; section 6
i1   20     1     440   11   3500
i1   20     3.8   444   12   2000

e



</CsScore>
</CsoundSynthesizer>
