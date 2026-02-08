<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_01_2b.orc and 01_01_2b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     01_01_2B.ORC
; timbre:    plucked instrument
; synthesis: simple(01),
;            basic instrument(01)
; source:    #250 Reedy and Plucked Tones, Choral Effect, Risset(1969)
; coded:     jpg 8/93



instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifq1  =  p5
idec  =  p6
;                       ;xamp, irise,idur,idec,   ifn,   iatss,iatdec
         a1     envlpx   iamp,  .01,idur,idec,    51,     1  ,  .01
         a1     oscili   a1, ifq1, 11
                out      a1
endin




</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_01_2B.SCO
; source:    #250 Reedy and Plucked Tones, Choral Effect, Risset(1969)
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveforms
f11 0  1024  10  .4 .3 .35 .5 .1 .2 .15 0 .02 .05 .03;  complex waveform
                                                     ;  with 10 harmonics
; envelope
f51 0  513   5    .00195  512  1 ;   exponential increase over 512 points

; score ******************************************************************
;  start  idur  iamp  ifq1    idec
i1  1      .5   8000   486      2 ;   plucked sounds
i1  1.5    .25  .      615      1
i1  1.75   .25  .      648

i1  2     1     .      486      2
i1  2     1     .      615      1.5
i1  2     1     .      729

i1  2.5    .5   .     1944      .9
i1  2.75   .5   .     1728
i1  3      .25  .     1640      .5
i1  3.25   .25  .     1458
i1  3.5    .5   .     1640      1

i1  4      .9   .     1458      1
i1  4      .8   .     1230
i1  4      .9   .      731
e

</CsScore>
</CsoundSynthesizer>
