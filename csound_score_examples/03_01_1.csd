<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 03_01_1.orc and 03_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     03_01_1.ORC
; timbre:    drum and snare drum
; synthesis: additive different units(03)
;            units: noise/inharm/fundamental (01)
; source:    #400  Drum and Snare-drum like Sounds, Risset(1969)
; coded:     jpg 8/93



instr 1; *****************************************************************
idur  =  p3
iamp7 =  p4
ifq1  =  p5
iamp2 =  p6
iamp4 =  p7
ifq5  =  p8
ifq7  =  p9

         a5     rand    iamp7, ifq7
         a5     oscili  a5, 1/idur, 52
         a5     oscili  a5, ifq5, 11

         a3     oscili  iamp4, 1/idur, 52
         a3     oscili  a3, ifq1, 13

         a1     oscili  iamp2, 1/idur, 51
         a1     oscili  a1, ifq1, 12

                out     (a1+a3+a5) * 12
endin


</CsInstruments>
<CsScore>
; ***********************************************************************
; ACCCI:     03_01_1.SCO
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveforms
f11  0  512  9   1  1  0
f12  0  512  9  10  1  0
f13  0  512  9  10  1  0  16  1  0  22  1  0  23  1  0

; envelopes
f51  0  513  5   256  512  1
f52  0  513  5  4096  512  1

; score ******************************************************************

; section 1                                 c-fq  1/2 bwdth
;   start  idur  iamp7  ifq1  iamp2  iamp4  ifq5  ifq7
i1    .4    .2    1000    20   800     300  4000  1500
i1    .8    .2
i1   1.1    .15
i1   1.2    .2
i1   1.6    .2
i1   1.9    .15
i1   2.0    .2
i1   2.4    .2
i1   2.8    .2
i1   3.1    .15
i1   3.2    .2
i1   3.6    .2
i1   3.9    .15
i1   4      .2
i1   4.4
i1   4.8
i1   5.2
i1   5.6
i1   6      .      1300


s
; section 2               the noise unit is inactive (iamp7=0)
;
;   start  idur  iamp7  ifq1  iamp2  iamp4  ifq5  ifq7
i1    .4    .3       0    12   1500    500   0   2.5
i1    .8    .2       .    16
i1   1.07   .2       .    12
i1   1.2    .2       .    16
i1   1.6    .3       .    12
i1   2.0    .25      .    14
i1   2.4    .23      .    15
i1   2.6    .27
i1   3.07   .23
i1   3.2
i1   3.6
i1   4


s
; section 3
;   start  idur  iamp7  ifq1  iamp2  iamp4  ifq5  ifq7
i1    .4    .15   1000    20   800     300  4000  1500
i1    .6    .20
i1   1.07
i1   1.2
i1   1.6
i1   2.0
i1   2.4    .25
i1   2.9    .15
i1   3
i1   3.1
i1   3.2    .20
i1   3.55   .15   700
i1   3.6    .20
i1   4      .15   800
i1   4.06
i1   4.13
i1   4.20
i1   4.27
i1   4.33
i1   4.40   .22  1200

e

</CsScore>
</CsoundSynthesizer>
