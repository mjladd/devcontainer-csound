<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from orbit.orc and orbit.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;*****************************************************************
; Orchestra
; Planetary Orbit Instrument
; Coded: 3/6/97 by Hans Mikelson
;*****************************************************************


          instr 1

; AMPLITUDE ENVELOPE
kampenv   linseg    0, .1, p4, p3-.2, p4, .1, 0

; PLANET POSITION (X, Y, Z) & VELOCITY (VX, VY, VZ)
kx        init      0
ky        init      .1
kz        init      0
kvx       init      .5
kvy       init      .6
kvz       init      -.1

; STAR 1 MASS & X, Y, Z
imass1    init      p5
is1x      init      0
is1y      init      0
is1z      init      p7

; STAR 2 MASS & X, Y, Z
imass2    init      p6
is2x      init      0
is2y      init      0
is2z      init      -p7

; CALCULATE DISTANCE TO STAR 1
kdx       =         is1x-kx
kdy       =         is1y-ky
kdz       =         is1z-kz
ksqradius =         kdx*kdx+kdy*kdy+kdz*kdz+1
kradius   =         sqrt(ksqradius)

; DETERMINE ACCELERATION DUE TO STAR 1 (AX, AY, AZ)
kax       =         imass1/ksqradius*kdx/kradius
kay       =         imass1/ksqradius*kdy/kradius
kaz       =         imass1/ksqradius*kdz/kradius

; CALCULATE DISTANCE TO STAR 2
kdx       =         is2x-kx
kdy       =         is2y-ky
kdz       =         is2z-kz
ksqradius =         kdx*kdx+kdy*kdy+kdz*kdz+1
kradius   =         sqrt(ksqradius)

; DETERMINE ACCELERATION DUE TO STAR 2 (AX, AY, AZ)
kax       =         kax+imass2/ksqradius*kdx/kradius
kay       =         kay+imass2/ksqradius*kdy/kradius
kaz       =         kaz+imass2/ksqradius*kdz/kradius

; UPDATE THE VELOCITY
kvx       =         kvx+kax
kvy       =         kvy+kay
kvz       =         kvz+kaz

; UPDATE THE POSITION
kx        =         kx+kvx
ky        =         ky+kvy
kz        =         kz+kvz

; PAN X & Y COORDINATES TO SEPARATE CHANNELS
aoutx     =         kx*kampenv
aouty     =         ky*kampenv
          outs      aoutx, aouty

          endin

</CsInstruments>
<CsScore>
:***************************************************************
; Score
;***************************************************************

t 0 400

; Planetary orbit in a binary star system
; Start Dur Amplitude Mass1 Mass2 Separation
i1 0 8    2000 .4 .34    1.1
i1 6 4    1000 .5 .6     2
i1 7 4    6000 .5 .5     1
i1 10     4    3000 .4 .4     1.2

</CsScore>
</CsoundSynthesizer>
