<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from rotorls.orc and rotorls.sco
; Original files preserved in same directory

sr              =           44100
kr              =           4410
ksmps           =           10
nchnls          =           2

;***************************************************
; TONE WHEEL ORGAN WITH ROTATING SPEAKER
;***************************************************


instr 1 ; ROTOR ORGAN #2

  gaorgan       init        0

  iphase        =           p2
  ikey          =           p6
  ifqc          =           cpspch(p5)

; THE LOWER TONE WHEELS HAVE INCREASED ODD HARMONIC CONTENT.
  iwheel1       =           ((ikey-12) > 12 ? 1:2)
  iwheel2       =           ((ikey+7)  > 12 ? 1:2)
  iwheel3       =           (ikey      > 12 ? 1:2)
  iwheel4       =           1

  kenv          linseg      0, .01, p4, p3-.02, p4, .01, 0

  asubfund      oscili      kenv*p7,  .5*ifqc,      iwheel1, iphase/(ikey-12)
  asub3rd       oscili      kenv*p8,  1.4983*ifqc,  iwheel2, iphase/(ikey+7)
  afund         oscili      kenv*p9,  ifqc,         iwheel3, iphase/ikey
  a2nd          oscili      kenv*p10, 2*ifqc,       iwheel4, iphase/(ikey+12)
  a3rd          oscili      kenv*p11, 2.9966*ifqc,  iwheel4, iphase/(ikey+19)
  a4th          oscili      kenv*p12, 4*ifqc,       iwheel4, iphase/(ikey+24)
  a5th          oscili      kenv*p13, 5.0397*ifqc,  iwheel4, iphase/(ikey+28)
  a6th          oscili      kenv*p14, 5.9932*ifqc,  iwheel4, iphase/(ikey+31)
  a8th          oscili      kenv*p15, 8*ifqc,       iwheel4, iphase/(ikey+36)

  gaorgan       =           gaorgan + asubfund + asub3rd + afund + a2nd + a3rd + a4th + a5th + a6th + a8th

                endin

;ROTATING SPEAKER
instr           3

; SPEAKER PHASE OFFSET
  ioff          =           p4

; PHASE SEPARATION BETWEEN RIGHT AND LEFT
  isep          =           .2

; GLOBAL INPUT FROM ORGAN
  asig          =           gaorgan

; DISTORTION EFFECT A LAZY "S" CURVE.  USE TABLE 6 FOR MORE DISTORTION.
  asig          =           asig/40000
  aclip         tablei      asig, 5, 1, .5
  aclip         =           aclip*16000

; DELAY BUFFER FOR ROTATING SPEAKER
  aleslie       delayr      .02, 1
                delayw      aclip

; ACCELERATION
  kenv          linseg      .8, 1, 8, 2, 8, 1, .8, 2, .8, 1, 8, 1, 8
  kenvlow       linseg      .7, 2, 7, 1, 7, 2, .7, 1, .7, 2, 7, 1, 7

; UPPER DOPPLER EFFECT
  koscl         oscil       1, kenv, 1, ioff
  koscr         oscil       1, kenv, 1, ioff + isep
  kdopl         =           .01-koscl*.0002
  kdopr         =           .012-koscr*.0002
  aleft         deltapi     kdopl
  aright        deltapi     kdopr

; LOWER EFFECT
  koscllow      oscil       1, kenvlow, 1, ioff
  koscrlow      oscil       1, kenvlow, 1, ioff + isep
  kdopllow      =           .01-koscllow*.0003
  kdoprlow      =           .012-koscrlow*.0003
  aleftlow      deltapi     kdopllow
  arightlow     deltapi     kdoprlow

; FILTER EFFECT
; DIVIDE        INTO        THREE FREQUENCY RANGES FOR DIRECTIONAL SOUND.

;  HIGH PASS
  alfhi         butterbp    aleft,   7000, 6000
  arfhi         butterbp    aright,  7000, 6000

;  BAND PASS
  alfmid        butterbp    aleft,   3000, 2000
  arfmid        butterbp    aright,  3000, 2000

;  LOW PASS
  alflow        butterlp    aleftlow,   1000
  arflow        butterlp    arightlow,  1000

  kflohi        oscil       1, kenv, 3, ioff
  kfrohi        oscil       1, kenv, 3, ioff + isep
  kflomid       oscil       1, kenv, 4, ioff
  kfromid       oscil       1, kenv, 4, ioff + isep

; AMPLITUDE EFFECT ON LOWER SPEAKER
  kalosc        =       koscllow * .4 + 1
  karosc        =       koscrlow * .4 + 1


  outs          alfhi*kflohi+alfmid*kflomid+alflow*kalosc, arfhi*kfrohi+arfmid*kfromid+arflow*karosc

  gaorgan       =       0

                endin


</CsInstruments>
<CsScore>
; ************************************************************************
; TONE WHEEL ORGAN WITH ROTATING SPEAKER REV. 2
; BY HANS MIKELSON 2/18/97
; ************************************************************************


; GEN FUNCTIONS **********************************************************
; SINE
f1      0       8192    10      1   .02     .01
f2      0       1024    10      1   0       .2      0       .1  0       .05     0   .02

; ROTATING SPEAKER FILTER ENVELOPES
f3      0       256     7       0   1       10      0       18  1       18      0   110     0
f4      0       256     7       0   80      .2      16      1   64      1       16  .2      80  0

; DISTORTION TABLE
f5      0       8192    8       -.8 336     -.78    800     -.7 5920    .7      800 .78     336 .8
f6      0       8192    8       -.8 336     -.76    3000    -.7 1520    .7      3000.76     336 .8

; SCORE ******************************************************************

t       0       200

;  TONE WHEEL ORGAN

;   Start   Dur     Amp     Pitch   Key     SubFund     Sub3rd  Fund    2nd 3rd 4th 5th 6th 8th
i1   0      6       200     8.04    28      8           8       8       8   3   2   1   0   4
i1   0      6       .       8.11    35      .           .       .       .   .   .   .   .   .
i1   0      6       .       9.02    38      .           .       .       .   .   .   .   .   .
i1   6      1       .       8.04    28      .           .       .       .   .   .   .   .   .
i1   6      1       .       8.09    33      .           .       .       .   .   .   .   .   .
i1   6      1       .       9.01    37      .           .       .       .   .   .   .   .   .
i1   7      1       .       8.04    28      .           .       .       .   .   .   .   .   .
i1   7      1       .       8.11    35      .           .       .       .   .   .   .   .   .
i1   7      1       .       9.02    38      .           .       .       .   .   .   .   .   .
i1   8      1       .       8.04    28      .           .       .       .   .   .   .   .   .
i1   8      1       .       8.09    33      .           .       .       .   .   .   .   .   .
i1   8      1       .       9.01    37      .           .       .       .   .   .   .   .   .
i1   9      8       .       8.04    28      .           .       .       .   .   .   .   .   .
i1   9      8       .       8.08    32      .           .       .       .   .   .   .   .   .
i1   9      8       .       8.11    35      .           .       .       .   .   .   .   .   .
i1   17     16      200     10.04   52      .           .       .       .   .   .   .   .   .

;   ROTATING SPEAKER
;   Start   Dur
;i3  0      33.2    .5
i3   0      33.2    .1

</CsScore>
</CsoundSynthesizer>
