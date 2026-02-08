<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from terrain.orc and terrain.sco
; Original files preserved in same directory

sr        =         44100               ; SAMPLE RATE
kr        =         22050               ; CONTROL RATE
ksmps     =         2                   ; SR/KR
nchnls    =         2                   ; STEREO OUTPUT

;-----------------------------------------------------------
; TERRAIN MAPPING EXAMPLE
; CODED BY HANS MIKELSON
; JULY 15, 1998
;-----------------------------------------------------------

          zakinit   50, 50              ; INITIALIZE THE ZAK CHANNELS

;-----------------------------------------------------------
; Sine Modulation
;-----------------------------------------------------------
          instr     3

idur      =         p3                  ; DURATION
iamp      =         p4                  ; AMPLITUDE
ifqc      =         p5                  ; FREQUENCY
iphase    =         p6                  ; PHASE OFFSET
ioutch    =         p7                  ; OUTPUT CHANNEL

krad1     oscili    iamp, ifqc, 1, iphase    ; SINE WAVE OSCILLATOR
kout      =         krad1+2*iamp             ; MAKE IT POSITIVE
          zkw       kout, ioutch             ; SEND IT OUT ON THE K-CHANNEL

          endin

;-----------------------------------------------------------
; 4D
; w=sin^2*(sqrt(x^2+y^2+z^2))
;-----------------------------------------------------------
          instr     5

idur      =         p3                       ; DURATION
iamp      =         p4                       ; AMPLITUDE
ifqc      =         cpspch(p5)               ; CONVERT PITCH TO FREQUENCY
iwamp     =         p6                       ; AMPLITUDE OF THE W DIMENSION
ioutch1   =         p7                       ; OUTPUT AUDIO CHANNEL 1
ioutch2   =         p8                       ; OUTPUT AUDIO CHANNEL 2
ioutch3   =         p9                       ; OUTPUT AUDIO CHANNEL 3
ioutch4   =         p10                      ; OUTPUT AUDIO CHANNEL 4

kdclick   linseg    0, .02, iamp, idur-.04, iamp, .02, 0    ; DE-CLICK ENVELOPE
krminor   oscil     5, .2, 1                                ; MODULATE THE MINOR RADIUS
krminor   =         krminor+6                               ; MAKE IT POSITIVE
krmajor   =         krminor+1                               ; MAJOR RADIUS IS 1 BIGGER THAN MINOR

asin1     oscil     krminor, ifqc, 1                        ; MINOR CIRCLE Y COORDINATE
acos1     oscil     krminor, ifqc, 1, .25                   ; MINOR CIRCLE X COORDINATE
asin2     oscil     krmajor, ifqc/4, 1                      ; MAJOR CIRCLE Y COORDINATE
acos2     oscil     krmajor, ifqc/4, 1, .25                 ; MAJOR CIRCLE X COORDINATE

ax        =         asin1+acos2                   ; THIS ORBIT IS A SPIRAL ON
ay        =         acos1                         ; THE SURFACE OF A TORUS WHOSE
az        =         asin2                         ; RADIUS IS BEING MODULATED.

aw1       =         sin(sqrt(ax*ax+ay*ay+az*az))  ; COMPUTE THE SURFACE A BUMPY 4 DIMENSIONAL SURFACE
aw        =         aw1*aw1-.5                    ; REMOVE SOME DC OFFSET

          zawm      ax*kdclick, ioutch1           ; OUTPUT TO THE ZAK AUDIO CHANNELS
          zawm      ay*kdclick, ioutch2
          zawm      az*kdclick, ioutch3
          zawm      aw*kdclick*iwamp, ioutch4

          endin

;-----------------------------------------------------------
; Z=X-1/12*X^3-1/4*Y^2
; LEAD 1
;-----------------------------------------------------------
          instr     12

idur      =         p3                            ; DURATION
iamp      =         p4                            ; AMPLITUDE
ifqc      =         cpspch(p5)                    ; CONVERT PITCH TO FREQUENCY
imodch    =         p6                            ; CONTROL CHANNEL INPUT
ipetal    =         p7                            ; NUMBER OF PETALS ON THE ROSE CURVE
ioutch    =         p8                            ; OUTPUT AUDIO CHANNEL

kmod1     zkr       imodch                        ; READ CONTROL CHANNEL

kdclick   linseg    0, .002, iamp, idur-.004, iamp, .002, 0      ; DE-CLICK ENVELOPE
kpfade    linseg    0, .2, 0, .2, .01, idur-.4, .005             ; VIBRATO FADE
kplfo     oscil     kpfade, 6, 1                                 ; VIBRATO
kfqc      =         (1+kplfo)*ifqc                               ; MODULATE THE PITCH

arose     oscil     kmod1, ipetal*kfqc, 1                        ; ROSE CURVE
ax        oscil     arose, kfqc, 1                               ; CONVERT FROM POLAR TO
ay        oscil     arose, kfqc, 1, .25                          ; RECTANGULAR COORDINATES

az        =         ax-ax*ax*ax/12-ay*ay/4+.5                    ; COMPUTE THE SURFACE
adcblk    butterhp  az, 20                                       ; REMOVE THE DC COMPONENT

          zaw       adcblk*kdclick, ioutch                       ; OUTPUT TO A ZAK AUDIO CHANNEL

          endin

;-----------------------------------------------------------
; Z=-5*X/(X^2+Y^2+1)
; SQUARISH LEAD 2
;-----------------------------------------------------------
          instr     13

idur      =         p3                            ; DURATION
iamp      =         p4                            ; AMPLITUDE
ifqc      =         cpspch(p5)                    ; CONVERT PITCH TO FREQUENCY
imodch    =         p6                            ; CONTROL CHANNEL
ipetal    =         p7                            ; NUMBER OF PETALS ON THE ROSE CURVE
idetun    =         p8                            ; DETUNE AMOUNT

ifqc1     =         ifqc*(1+idetun)               ; ADD SOME CHORUSING
ifqc2     =         ifqc*(1-idetun*.9)            ; AND STEREO DETUNING

kmod1     zkr       imodch                        ; READ FROM THE MODULATION CONTROL CHANNEL
kdclick   linseg    0, .002, iamp, idur-.004, iamp, .002, 0      ; DE-CLICK ENVELOPE

arose     oscil     kmod1+1, ipetal*ifqc, 1       ; ROSE CURVE
ax        oscil     arose, ifqc, 1                ; CONVERT FROM POLAR TO
ay        oscil     arose, ifqc, 1, .25           ; RECTANGULAR COORDINATES
az        =         -5*ax/(ax*ax+ay*ay+1)         ; COMPUTE THE SURFACE FOR OSCILLATOR 1

arose1    oscil     kmod1+1, ipetal*ifqc1, 1      ; ROSE CURVE
ax1       oscil     arose1, ifqc1, 1              ; CONVERT FROM POLAR TO
ay1       oscil     arose1, ifqc1, 1, .25         ; RECTANGULAR COORDINATES
az1       =         -5*ax1/(ax1*ax1+ay1*ay1+1)    ; COMPUTE THE SURFACE FOR OSCILLATOR 2

arose2    oscil     kmod1+1, ipetal*ifqc2, 1      ; ROSE CURVE
ax2       oscil     arose2, ifqc2, 1              ; CONVERT FROM POLAR TO
ay2       oscil     arose2, ifqc2, 1, .25         ; RECTANGULAR COORDINATES
az2       =         -5*ax2/(ax2*ax2+ay2*ay2+1)    ; COMPUTE THE SURFACE FOR OSCILLATOR 3

adcblkl   butterhp  (az+az1)/2, 20                ; BLOCK DC
adcblkr   butterhp  (az+az2)/2, 20                ; BLOCK DC

          outs      adcblkl*kdclick, adcblkr*kdclick   ; OUTPUT STEREO

          endin

;-----------------------------------------------------------
; Z=-5*X/(X^2+Y^2+1)
; SQUARISH LEAD 2
;-----------------------------------------------------------
          instr     14

idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
imodch    =         p6                                 ; CONTROL CHANNEL
ipetal    =         p7                                 ; NUMBER OF PETALS ON THE ROSE CURVE
idetun    =         p8                                 ; DETUNE AMOUNT
ifade     =         p9                                 ; FADE IN AND OUT

ifqc1     =         ifqc*(1+idetun)                    ; ADD SOME CHORUSING
ifqc2     =         ifqc*(1-idetun*.9)                 ; AND STEREO DETUNING

kmod1     zkr       imodch                             ; READ FROM THE MODULATION CONTROL CHANNEL
kdclick   linseg    0, ifade, iamp, idur-2*ifade, iamp, ifade, 0  ; De-Click envelope

arose     oscil     kmod1+1, ipetal*ifqc, 1            ; ROSE CURVE
ax        oscil     arose, ifqc, 1                     ; CONVERT FROM POLAR TO
ay        oscil     arose, ifqc, 1, .25                ; RECTANGULAR COORDINATES
az        =         -5*ax/(ax*ax+ay*ay+1)              ; COMPUTE THE SURFACE FOR OSCILLATOR 1

arose1    oscil     kmod1+1, ipetal*ifqc1, 1           ; ROSE CURVE
ax1       oscil     arose1, ifqc1, 1                   ; CONVERT FROM POLAR TO
ay1       oscil     arose1, ifqc1, 1, .25              ; RECTANGULAR COORDINATES
az1       =         -5*ax1/(ax1*ax1+ay1*ay1+1)         ; COMPUTE THE SURFACE FOR OSCILLATOR 2

arose2    oscil     kmod1+1, ipetal*ifqc2, 1           ; ROSE CURVE
ax2       oscil     arose2, ifqc2, 1                   ; CONVERT FROM POLAR TO
ay2       oscil     arose2, ifqc2, 1, .25              ; RECTANGULAR COORDINATES
az2       =         -5*ax2/(ax2*ax2+ay2*ay2+1)         ; COMPUTE THE SURFACE FOR OSCILLATOR 3

adcblkl   butterhp  (az+az1)/2, 20                     ; BLOCK DC
adcblkr   butterhp  (az+az2)/2, 20                     ; BLOCK DC

          outs      adcblkl*kdclick, adcblkr*kdclick   ; OUTPUT STEREO

          endin

;-----------------------------------------------------------
; TERRAIN MAPPED BASS
; z=sqrt(x^4+y^4-x^2-y^2-x^2Y^2+1)
;-----------------------------------------------------------
          instr     19

idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
aamp1     init      iamp                               ; USED TO BALANCE THE SIGNAL
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
ikch1     =         p6                                 ; INPUT CONTROL 1
ikch2     =         p7                                 ; INPUT CONTROL 2
ibndtab   =         p8                                 ; PITCH BEND TABLE

kamp      linseg    0, .01, 2, .1, 1.5, idur-.21, 1, .1, 0       ; AMP ENVELOPE

krad1     zkr       ikch1                              ; READ IN RADIUS 1
krad2     zkr       ikch2                              ; READ IN RADIUS 2

kbend     oscil      1, 1/idur, ibndtab                 ; PITCH BEND
kfqc      =         kbend*ifqc                         ; ADJUST FREQUENCY BY PITCH BEND

asin1     oscil     krad1, kfqc, 1                     ; Y COMPONENT OF CIRCLE RADIUS 1
acos1     oscil     krad1, kfqc, 1, .25                ; X COMPONENT OF CIRCLE RADIUS 1
asin2     oscil     krad2, kfqc, 1, .5                 ; Y COMPONENT OF CIRCLE RADIUS 2
acos2     oscil     krad2, kfqc, 1, .75                ; X COMPONENT OF CIRCLE RADIUS 2

ax1       =         asin1+.35                          ; OFFSET THE CIRCLE CENTERS A BIT
ay1       =         acos1-.80                          ; SO THE WAVES ARE ASSYMMETRICAL.
ax2       =         asin2+.5
ay2       =         acos2-.20

axsq1     =         ax1*ax1                            ; COMPUTE X^2 AND Y^2 IN ADVANCE
aysq1     =         ay1*ay1                            ; TO SAVE TIME.
axsq2     =         ax2*ax2
aysq2     =         ay2*ay2

; COMPUTE THE SURFACE
az1       =         sqrt(axsq1*axsq1+aysq1*aysq1-axsq1-aysq1-axsq1*aysq1+1)
az2       =         sqrt(axsq2*axsq2+aysq2*aysq2-axsq2-aysq2-axsq2*aysq2+1)

abal1     balance   az1, aamp1                         ; BALANCE THE SIGNAL
abal2     balance   az2, aamp1                         ; BALANCE THE SIGNAL

aout1     butterhp  abal1, 10                          ; DC BLOCKING FILTER
aout2     butterhp  abal2, 10                          ; DC BLOCKING FILTER

          outs      aout1*kamp, aout2*kamp             ; STEREO OUTPUT

          endin

;-----------------------------------------------------------
; PULSAR
; z=sqrt((1-x^2)*((1-y)+y*cos(1/x)))
;-----------------------------------------------------------
          instr     8

idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         p5                                 ; FREQUENCY
imodch    =         p6                                 ; MODULATION CHANNEL
ipantab   =         p7                                 ; PANNER TABLE
iamptab   =         p8                                 ; FADER TABLE

kmod      zkr       imodch                             ; READ THE MODULATION
kpan      oscili    1, 1/idur, ipantab                 ; PANNER
kpanl     =         sqrt(kpan)                         ; PAN LEFT
kpanr     =         sqrt(1-kpan)                       ; PAN RIGHT
kamp      oscili    iamp, 1/idur, iamptab              ; AMPLITUDE FADER
ka        =         .01+kmod                           ; CARDIOID A
kb        =         .1+kmod*.2                         ; CARDIOID B

acardi    oscil     kb, ifqc, 1                        ; CARDIOID CURVE
ax1       oscil     ka+acardi, ifqc, 1                 ; CONVERT FROM POLAR TO
ax        =         ax1
ay        oscil     ka+acardi, ifqc, 1, .25            ; RECTANGULAR COORDINATES
az        =         sqrt((1-ax*ax)*((1-ay)+ay*cos(1/(ax*ax+.01))))-1       ; COMPUTE THE SURFACE

aout      butterhp  az, 20                             ; REMOVE DC
          outs      aout*kamp*kpanl, aout*kamp*kpanr   ; OUTPUT STEREO WITH PANNING AND FADING

          endin

;-----------------------------------------------------------
; 4 SPACE PLANAR ROTATIONS
;-----------------------------------------------------------
          instr     51

ifqc      =         p4                                 ; FREQUENCY
iphase    =         p5                                 ; PHASE OFFSET
iplane    =         p6                                 ; PLANE NUMBER
inx       =         p7                                 ; INPUT FOR X COORDINATE
iny       =         p8                                 ; INPUT FOR Y COORDINATE
inz       =         p9                                 ; INPUT FOR Z COORDINATE
inw       =         p10                                ; INPUT FOR W COORDINATE
ioutx     =         p11                                ; OUTPUT FOR X COORDINATE
iouty     =         p12                                ; OUTPUT FOR Y COORDINATE
ioutz     =         p13                                ; OUTPUT FOR Z COORDINATE
ioutw     =         p14                                ; OUTPUT FOR W COORDINATE

kcost     oscil     1, ifqc,   1, .25+iphase           ; COSINE
ksint     oscil     1, ifqc,   1, iphase               ; SINE

ax        zar       inx                                ; READ IN AUDIO CHANNELS X, Y, Z AND W
ay        zar       iny
az        zar       inz
aw        zar       inw

; ROTATION IN X-Y PLANE
  if (iplane!=1)    goto next1
    axr   =         ax*kcost + ay*ksint
    ayr   =         -ax*ksint + ay*kcost
    azr   =         az
    awr   =         aw
    goto  nextend

; ROTATION IN X-Z PLANE
next1:
  if (iplane!=2)    goto next2
    axr   =         ax*kcost + az*ksint
    ayr   =         ay
    azr   =         -ax*ksint + az*kcost
    awr   =         aw
    goto  nextend

; ROTATION IN Y-Z PLANE
next2:
  if (iplane!=3)    goto next3
    axr   =         ax
    ayr   =         ay*kcost + az*ksint
    azr   =         -ay*ksint + az*kcost
    awr   =         aw
    goto  nextend

; ROTATION IN X-W PLANE
next3:
  if (iplane!=4)    goto next4
    axr   =         ax*kcost + aw*ksint
    ayr   =         ay
    azr   =         az
    awr   =         -ax*ksint + aw*kcost
    goto   nextend

; ROTATION IN Y-W PLANE
next4:
  if (iplane!=5)    goto next5
    axr   =         ax
    ayr   =         ay*kcost + aw*ksint
    azr   =         az
    awr   =         -ay*ksint + aw*kcost
    goto  nextend

; ROTATION IN Z-W PLANE
next5:
  if (iplane!=6)    goto nextend
    axr   =         ax
    ayr   =         ay
    azr   =         az*kcost + aw*ksint
    awr   =         -az*ksint + aw*kcost

nextend:
          zaw       axr, ioutx                         ; Output audio X, Y, Z and W
          zaw       ayr, iouty
          zaw       azr, ioutz
          zaw       awr, ioutw

endin

;---------------------------------------------------------------------------
; Mixer Section
;---------------------------------------------------------------------------
          instr     95

idur      =         p3                                 ; Duration
iamp      =         p4                                 ; Amplitude
ifadtab   =         p5                                 ; Fader Table
iinch     =         p6                                 ; Input Channel
ipantab   =         p7                                 ; Panner Table

ain1      zar       iinch                              ; Read audio input channel

kamp      oscili    iamp, 1/idur, ifadtab              ; Fader
kpan      oscili    1, 1/idur, ipantab                 ; Panner
kpanl     =         sqrt(kpan)                         ; Pan Left
kpanr     =         sqrt(1-kpan)                       ; Pan Right
          outs      ain1*kamp*kpanl, ain1*kamp*kpanr   ; Output stereo with fader and panner

          endin

;---------------------------------------------------------------------------
; CLEAR AUDIO & CONTROL CHANNELS
;---------------------------------------------------------------------------
          instr     99

          zacl      0, 50                              ; CLEAR AUDIO CHANNELS 0 TO 30
          zkcl      0, 50                              ; CLEAR CONTROL CHANNELS 0 TO 30

          endin

</CsInstruments>
<CsScore>
;---------------------------------------------------------------------
; TERRAIN MAPPING
; COMPOSITION BY HANS MIKELSON FEBRUARY 1998
; ALL INSTRUMENTS IN THIS COMPOSITION WERE BASED ON TERRAIN MAPPING.
;---------------------------------------------------------------------

f1 0 8192 10 1                    ; Sine
f2 0 1024 -7 0 512 1 512 0        ; FadeIn/Out/PanRLR
f4 0 1024 -7 1 1024 1             ; Const 1

;a0 0 50
;a0 62 128

;---------------------------------------------------------------------
; Terrain Bass
;---------------------------------------------------------------------
; Radius Modulation
;   Sta  Dur  Amp  Fqc   Phase  OutKCh
i3  0.0 80.0  2.5  .5    0      1
i3  0.0 80.0  2.5  .6    .25    2

;    Sta  Dur  Amp    Pch   KCh1  KCh2  PBendTable
i19  0.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  8.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 16.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 24.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 32.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 40.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 48.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 56.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 64.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19 72.0  .5   9000   5.00  1     2     4
i19  +    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .5   .      5.07  .     .     .
i19  .    .25  .      5.00  .     .     .
;
i19  .    .5   9000   5.00  1     2     4
i19  .    .25  .      6.00  .     .     .
i19  .    .5   .      5.00  .     .     .
i19  .    .25  .      5.07  .     .     .
i19  .    .25  .      5.05  .     .     .
i19  .    .25  .      5.00  .     .     .

;--------------------------------------------------------
; Terrain Lead 1
;--------------------------------------------------------
; Sine oscillator
;   Sta   Dur   Amp  Fqc   Phase  OutKCh
i3  8.0   32.0  1    .5    0      3
; Terrain
;    Sta   Dur  Amp    Pitch  ModCh  Petals  OutCh
i12  8     2.0  3000   7.00   3      2.99    20
i12  +     .    .      7.02   .      .       .
i12  .     .    .      7.03   .      .       .
i12  .     1.75 .      7.02   .      .       .
i12  .     .25  .      6.10   .      .       .
;
i12  16    2.0  3000   7.00   .      .       .
i12  +     2.0  .      7.02   .      .       .
i12  .     .    .      7.03   .      .       .
i12  .     1.75 .      7.07   .      .       .
i12  .     .25  .      7.10   .      .       .
;
i12  24    2.0  3000   8.00   .      .       .
i12  +     .    .      7.10   .      .       .
i12  .     .    .      7.08   .      .       .
i12  .     .    .      7.07   .      .       .
; Mixer
f83 0 1024 -7 0 256 1 256 .5 256 .8 256 0 ; Pan
f70 0 1024 -7 .5 128 1 128 1 768 1 ; Pan
;    Sta  Dur  Amp  Fader  InCh   Panner
i95  8    32   1    70     20     83

; 2nd verse same as the first...
; Sine oscillator
;   Sta   Dur   Amp  Fqc   Phase  OutKCh
i3  48.0  32.0  1    .5    0      3
; Terrain
;    Sta   Dur  Amp    Pitch  ModKCh Petals
i12  48    2.0  3000   7.00   3      2.99
i12  +     .    .      7.02   .      .
i12  .     .    .      7.03   .      .
i12  .     1.75 .      7.02   .      .
i12  .     .25  .      6.10   .      .
;
i12  56    2.0  3000   7.00   .      .
i12  +     2.0  .      7.02   .      .
i12  .     .    .      7.03   .      .
i12  .     1.75 .      7.07   .      .
i12  .     .25  .      7.10   .      .
;
i12  64    2.0  3000   8.00   .      .
i12  +     .    .      7.10   .      .
i12  .     .    .      7.08   .      .
i12  .     1.75 .      7.07   .      .
i12  .     .25  .      6.10   .      .
;
i12  72    2.00 3000   7.00   3      2.99
i12  +     .    .      7.02   .      .
i12  .     .25  .      7.07   .      .
i12  .     3.75 .      7.00   .      .
; Mixer
f71 0 1024 -7 1 512 1 256 1 256 .5 ; Fade
;    Sta  Dur  Amp  Fader  InCh   Panner
i95  48   32   1    71     20     83

;--------------------------------------------------------
; Squarish lead with stereo detune
;--------------------------------------------------------
;    Sta  Dur   Amp  Fqc   Phase  OutKCh
i3   32   16.0  1    .5    0      4
;    Sta  Dur  Amp    Pitch  ModCh  Petals  Detune
i13  32   .50  2000   7.00   4      2.01    .005
i13  +    .75  .      8.00   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      8.05   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      8.07   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
;
i13  36   .50  2100   7.00   4      2.01    .005
i13  +    .75  .      8.00   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      8.09   4      2.01    .005
i13  .    .75  .      7.10   4      2.01    .005
;
i13  40   .50  2300   7.00   4      2.01    .005
i13  +    .75  .      8.00   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      8.05   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      8.07   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
;
i13  44   .50  2500   7.00   4      2.01    .005
i13  +    .75  .      8.00   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      7.05   4      2.01    .005
i13  .    .25  .      7.07   4      2.01    .005
i13  .    .50  .      8.00   4      2.01    .005
i13  .    .25  .      8.09   4      2.01    .005
i13  .    .75  .      7.10   4      2.01    .005

; Finale
;    Sta  Dur   Amp  Fqc   Phase  OutKCh
i3   80   24.0  1    .5    0      4
;    Sta  Dur   Amp    Pitch  ModCh  Petals  Detune
i13  80   .125  200    7.00   4      2.00    .001
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1000   6.03   .      2.15    .005
;
i13  82   .125  1100   7.00   4      2.15    .005
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     2000   6.03   .      2.2     .02
;
i13  84   .125  2000   7.00   4      2.25    .01
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     2100   6.03   .      2.5     .03
;
i13  86   .125  2000   7.00   4      3.00    .005
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1800   6.03   .      4.5     .05
;
i13  88   .125  1900   7.00   4      2.15    .005
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      1.01    <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      2.1     <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     2200   6.03   .      4.2     .2
;
i13  90   .125  2100   7.00   4      2.15    .005
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1600   6.03   .      4.2     .1
;
i13  92   .125  1500   7.00   4      3.71    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      3.98    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .01
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      2.00    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1000   6.03   .      4.15    .05
;
i13  94   .125  1000   7.00   4      3.71    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      4.98    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .05
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      3.70    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1800   6.03   .      3.15    .1
;
i13  96   .125  1700   7.00   4      3.01    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      2.28    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .01
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      2.50    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1500   6.03   .      3.15    .05
;
i13  98   .125  1400   7.00   4      3.71    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      2.98    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .05
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      2.70    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     1300   6.03   .      3.15    .1
;
i13  100  .125  1000   7.00   4      3.71    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      3.98    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .01
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      2.00    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     600    6.03   .      4.15    .05
;
i13  102  .125  500    7.00   4      3.71    .02
i13  +    .     <      8.00   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.03   .      <       <
i13  .    .     <      8.03   .      <       <
i13  .    .     <      7.07   .      4.98    <
i13  .    .     <      8.06   .      <       <
i13  .    .     <      7.05   .      <       <
i13  .    .     <      6.07   .      <       .05
i13  .    .     <      5.10   .      <       <
i13  .    .     <      8.05   .      <       <
i13  .    .     <      7.05   .      5.70    <
i13  .    .     <      8.10   .      <       <
i13  .    .     <      7.07   .      <       <
i13  .    .     <      5.10   .      <       <
i13  .    .     100    6.03   .      7.15    .2

;---------------------------------------------------------------------
; Deep Space Growl
;---------------------------------------------------------------------
f80 0 1024 -7 1 1024 1        ; PanL
f81 0 1024 -7 0 1024 0        ; PanR

;   Sta  Dur  Amp  Pch   WAmp  OutX  OutY  OutZ  OutW
i5  12   24   500  8.00  10    1     2     3     4
i5  40   24   400  8.07  10    1     2     3     4
; 4 Space Planar Rotation
; Plane: 1=X-Y, 2=X-Z, 3=Y-Z, 4=X-W, 5=Y-W, 6=Z-W
;    Sta  Dur  Fqc  Phase  Plane  InX  InY  InZ  InW  OutX  OutY  OutZ  OutW
i51  12   52   0.08 0      1      1    2    3    4    5     6     7     8
i51  12   52   0.15 0      6      5    6    7    8    9     10    11    12
i51  12   52   0.05 0      5      9    10   11   12   13    14    15    16
; Mixer
;    Sta  Dur  Amp  Fader  InCh   Panner
i95  12   52   1    2      14     80
i95  12   52   1    2      16     81

;---------------------------------------------------------------------
; Pulsar
;---------------------------------------------------------------------
;   Sta  Dur  Amp  Fqc   Phase  OutKCh
i3  50  12.0  .15  .25   0      5
i3  60  18.0  .15  .50   0      6
i3  64  24.0  .15  .25   0      7
;
f85 0 1024 -7 1 1024 0 ; PanLR
f86 0 1024 -7 0 1024 1 ; PanLR
f75 0 1024 -7 0 256 1 512 1 256 0 ; FadeInOut
;    Sta  Dur  Amp    Freq  ModKCh  Pan  Fader
i8   50  12.0  18000  4.0   5       85   75
i8   60  18.0  13000  8.0   6       86   75
i8   64  24.0  12000 32.0   7       85   75


;---------------------------------------------------------------------
; Clear Zak
;---------------------------------------------------------------------
;     Sta  Dur
i99   12   52


</CsScore>
</CsoundSynthesizer>
