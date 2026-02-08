<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_01_2c.orc and 01_01_2c.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     01_01_2C.ORC
; timbre:    reed-like: choral effect
; synthesis: simple(01),
;            basic instrument(01), chorus(2C)
; source:    #250 Reedy Tones, Choral Effect Risset(1969)
; coded:     jpg 8/93


instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifq1  =  p5
if2   =  p6

         a2     oscili   iamp, 1/idur, if2
         a1     oscili   a2,   ifq1,   11     ; 11 = weighted complex
                out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_01_2C.SCO
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveforms
f11 0  1024  10  .4 .3 .35 .5 .1 .2 .15 0 .02 .05 .03;  complex waveform
                                                     ;  with 10 harmonics
; envelopes
f31 0  512   7  0 86  1    85 .8  85  .6 85 .7 85 .6 86 0   ; smooth: reed

; score ******************************************************************

;  3 voices choral effect

;   start  idur  iamp  ifq1  if2

i1   1.0    .5  12000   486   31
i1   1.03   .5   5000   492
i1   1.08   .5   3000   473

i1   1.5    .25 12000   615
i1   1.53   .25  5000   610
i1   1.58   .25  3000   629

i1   1.75   .25 12000   648
i1   1.78   .25  5000   660
i1   1.83   .25  3000   625

i1   2      .5  12000   729
i1   2.03   .5   5000   719
i1   2.08   .5   3000   741

i1   2.5    .25 12000   972
i1   2.53   .25  5000   990
i1   2.58   .25  3000   950

i1   2.75   .25 12000   890
i1   2.78   .25  5000   880
i1   2.83   .25  3000   884

i1   3      .25 12000   820
i1   3.03   .25  5000   830
i1   3.08   .25  3000   809

i1   3.25   .25 12000   820
i1   3.28   .25  5000   835
i1   3.33   .25  3000   807

i1   3.5    .5  12000   820
i1   3.53   .5   5000   848
i1   3.58   .5   3000   800

i1   4     2    12000   729
i1   4.03  1.99  5000   722

i1   4.08  1.92  3000   743
e

</CsScore>
</CsoundSynthesizer>
