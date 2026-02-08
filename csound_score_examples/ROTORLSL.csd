<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ROTORLSL.ORC and ROTORLSL.SCO
; Original files preserved in same directory

sr     = 44100
kr     = 2205
ksmps  = 20
nchnls = 2

;------------------------------------------------------------------------
; Tone Wheel Organ with Rotating Speaker
;------------------------------------------------------------------------


; Shaft
         instr 5
gkphase  oscil 1, p4, 7
         endin



;------------------------------------------------------------------------
; Global Rotorspeed/Drawbar Initialization
;------------------------------------------------------------------------

         instr 1
gispeedf   init p4
gksubfund  init p5
gksub3rd   init p6
gkfund     init p7
gk2nd      init p8
gk3rd      init p9
gk4th      init p10
gk5th      init p11
gk6th      init p12
gk8th      init p13
         endin

;------------------------------------------------------------------------
; This instrument acts as the foot switch controlling rotor speeds.
;------------------------------------------------------------------------
         instr 2

gispeedi init   gispeedf    ;Save old speed
gispeedf init   p4          ;update new speed

gkenv    linseg gispeedi*.8,1,gispeedf*.8,.01,gispeedf*.8 ;High freq. rotor acceleration
gkenvlow linseg gispeedi*.7,2,gispeedf*.7,.01,gispeedf*.7 ;Low freq. rotor acceleration

         endin

;------------------------------------------------------------------------
; Tone Wheel Organ
;------------------------------------------------------------------------
         instr 3

gaorgan  init  0                       ;Global send to speaker
;iphase   init  p2                      ;Continuous phase change based on p2
ikey     init  12*int(p5-6)+100*(p5-6) ;Keyboard key pressed.
ifqc     init  cpspch(p5)              ;Convert to cycles/sec.
iwheel1  init  ((ikey-12) > 12 ? 1:2)  ;The lower 12 tone wheels have
iwheel2  init  ((ikey+7)  > 12 ? 1:2)  ;increased odd harmonic content.
iwheel3  init  (ikey      > 12 ? 1:2)
iwheel4  init  1

;------------------------------------------------------------------------
kenv     linseg 0,.01,p4,p3-.02,p4,.01,0 ;Amplitude envelope.

;------------------------------------------------------------------------
asubfund oscil  gksubfund, .5*ifqc,      iwheel1, i(gkphase)/(ikey-12)  ;The organ tone is
asub3rd  oscil  gksub3rd,  1.4983*ifqc,  iwheel2, i(gkphase)/(ikey+7)   ;made from adding
afund    oscil  gkfund,    ifqc,         iwheel3, i(gkphase)/ikey       ;the weighted output
a2nd     oscil  gk2nd,     2*ifqc,       iwheel4, i(gkphase)/(ikey+12)  ;of 9 equal temperament
a3rd     oscil  gk3rd,     2.9966*ifqc,  iwheel4, i(gkphase)/(ikey+19)  ;tone wheels.
a4th     oscil  gk4th,     4*ifqc,       iwheel4, i(gkphase)/(ikey+24)
a5th     oscil  gk5th,     5.0397*ifqc,  iwheel4, i(gkphase)/(ikey+28)
a6th     oscil  gk6th,     5.9932*ifqc,  iwheel4, i(gkphase)/(ikey+31)
a8th     oscil  gk8th,     8*ifqc,       iwheel4, i(gkphase)/(ikey+36)

gaorgan  =      gaorgan+kenv*(asubfund+asub3rd+afund+a2nd+a3rd+a4th+a5th+a6th+a8th)

         endin

;------------------------------------------------------------------------
;Rotating Speaker
;------------------------------------------------------------------------
         instr  4

iofff     init   p4
isep     init   p5             ;Phase separation between right and left
iradius  init   .00025         ;Radius of the rotating horn.
iradlow  init   .00035         ;Radius of the rotating scoop.
ideleng  init   .02            ;Length of delay line.

;------------------------------------------------------------------------
asig     =      gaorgan        ;Global input from organ

;------------------------------------------------------------------------
asig     =      asig/40000     ;Distortion effect using waveshaping.
aclip    tablei asig,5,1,.5    ;A lazy "S" curve, use table 6 for increased
aclip    =      aclip*16000    ;distortion.

;------------------------------------------------------------------------
aleslie delayr  ideleng,1      ;Put "clipped" signal into a delay line.
        delayw  aclip

;------------------------------------------------------------------------
koscl   oscil   1,gkenv,1,iofff            ;Doppler effect is the result
koscr   oscil   1,gkenv,1,iofff+isep       ;of delay taps oscillating
kdopl   =       ideleng/2-koscl*iradius   ;through the delay line.  Left
kdopr   =       ideleng/2-koscr*iradius   ;and right are slightly out of phase
aleft   deltapi kdopl                     ;to simulate separation between ears
aright  deltapi kdopr                     ;or microphones

;------------------------------------------------------------------------
koscllow  oscil   1,gkenvlow,1,iofff           ;Doppler effect for the
koscrlow  oscil   1,gkenvlow,1,iofff+isep      ;lower frequencies.
kdopllow  =       ideleng/2-koscllow*iradlow
kdoprlow  =       ideleng/2-koscrlow*iradlow
aleftlow  deltapi kdopllow
arightlow deltapi kdoprlow

;------------------------------------------------------------------------
alfhi     butterbp aleft,5000,4000     ;Divide the frequency into three
arfhi     butterbp aright,5000,4000    ;groups and modulate each with a
alfmid    butterbp aleft,2000,1500     ;different width pulse to account
arfmid    butterbp aright,2000,1500    ;for different  dispersion
alflow    butterlp aleftlow,500        ;of different frequencies.
arflow    butterlp arightlow,500

kflohi    oscil    1,gkenv,3,iofff
kfrohi    oscil    1,gkenv,3,iofff+isep
kflomid   oscil    1,gkenv,4,iofff
kfromid   oscil    1,gkenv,4,iofff+isep

;------------------------------------------------------------------------
; Amplitude Effect on Lower Speaker
kalosc    = koscllow*.4+1
karosc    = koscrlow*.4+1

; Add all frequency ranges and output the result.
outs alfhi*kflohi+2*alfmid*kflomid+alflow*kalosc, arfhi*kfrohi+2*arfmid*kfromid+arflow*karosc

gaorgan = 0

endin


</CsInstruments>
<CsScore>
; ************************************************************************
; TONE WHEEL ORGAN WITH ROTATING SPEAKER REV. 3
; BY HANS MIKELSON 6/1/97
; ************************************************************************


; GEN FUNCTIONS **********************************************************
; SINE
f1  0   8192  10   1 .02 .01
f2  0   8192  10   1 0 .2 0 .1 0 .05 0 .02

; ROTATING SPEAKER FILTER ENVELOPES
; DEFLECTORS REMOVED
;f3   0    1024   8  .2    440 .4 72 1 72 .4  440 .2
;f4   0    1024   8  .4    320 .6 64 1 256 1   64  .6 320 .4
; WITH DEFLECTORS
f3   0    1024   8  .95 24 .85 24 1 24 .85 24 1 24 .85 248 .9  72 .8 72 1 72 .8  72 .9 248 .85 24 1 24 .85 24 1 24 .85 24 .95
f4   0    1024   8  .95 48 .85 96 .75 240 .8 64 1 128 1 64 .8 240 .75 96 .85 48 .95

; DISTORTION TABLES
; SLIGHT DISTORTION
f5 0 8192   8 -.8 336 -.78  800 -.7 5920 .7  800 .78 336 .8
; HEAVY DISTORTION
;f5 0 8192   8 -.8 336 -.76 3000 -.7 1520 .7 3000 .76 336 .8

; CENTRAL SHAFT TABLE
f7 0 256    7  0  256  1

; Score ******************************************************************

t 0 200

;  TONE WHEEL ORGAN
; INITIALIZES GLOBAL VARIABLES AND DRAWBARS.
;       Speed SubFund Sub3rd Fund 2nd 3rd 4th 5th 6th 8th
i1 0  1 1      8       8     8    8   3   2   1   0   4
i1 17 1 1      8       4     8    3   1   1   0   .   3

; ROTOR ORGAN CENTRAL SHAFT
;   Start Dur Frqc
i5  0     52  1

; ROTATING SPEAKER START/STOP
;ins  sta  dur  speed
i2    0    6     1
i2    +    6     10
i2    .    12    1
i2    .    6     10
i2    35.7 6     1

;  Start Dur   Amp   Pitch
i3   0    6    200    8.04
i3   0    6    .      8.11
i3   0    6    .      9.02
i3   6    1    .      8.04
i3   6    1    .      8.11
i3   6    1    .      9.04
i3   7    1    .      8.04
i3   7    1    .      8.11
i3   7    1    .      9.02
i3   8    1    .      8.04
i3   8    1    .      8.09
i3   8    1    .      9.01
i3   9    8    .      8.04
i3   9    8    .      8.08
i3   9    8    .      8.11
i3   17   16   200   10.04
i3   33     .2   200   10.02
i3   33.1   .2   200   10.00
i3   33.2   .2   200   9.11
i3   33.3   .2   200   9.09
i3   33.4   .2   200   9.07
i3   33.5   .2   200   9.05
i3   33.6   .2   200   9.04
i3   33.7   .2   200   9.02
i3   33.8   .2   200   9.00
i3   33.9   .2   200   8.11
i3   34.0   .2   200   8.09
i3   34.1   .2   200   8.07
i3   34.2   .2   200   8.05
i3   34.3   .2   200   8.04
i3   34.4   .2   200   8.02
i3   34.5   .2   200   8.00
i3   34.6   .2   200   7.11
i3   34.7   .2   200   7.09
i3   34.8   .2   200   7.07
i3   34.9   .2   200   7.05
i3   35.0   .2   200   7.04
i3   35.1   .2   200   7.02
i3   35.2   .2   200   7.00
i3   35.3   .2   200   6.11
i3   35.4   .2   200   6.09
i3   35.5   .2   200   6.07
i3   35.6   .2   200   6.05
i3   35.7   16.3   200   6.04

;   ROTATING SPEAKER
;   Start  Dur  Offset  Sep
i4    0    52.2  .5     .1

</CsScore>
</CsoundSynthesizer>
