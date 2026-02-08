<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from neworbits.orc and neworbits.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

; ORCHESTRA

; ORBITS TRACED ON COMPLEX 3D SURFACES
; z=sin^2*(sqrt(x^2+y^2))
          instr 1

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

kdclick   linseg    0, .002, iamp, idur-.004, iamp, .002, 0

krsize    linseg    .5, idur*.5, 5, idur*.5, .5 ; SWEEPS BOTH RADIUS SIZE AND CIRCLE CENTER
krad0     oscil     krsize, 1, 1
krad1     =         krad0+6                  ; MAKE A POSITIVE RADIUS.

ax0       oscil     krad1, ifqc, 1, .25      ; COSINE
ax        =         ax0+krsize
ay0       oscil     krad1, ifqc, 1           ; SINE
ay        =         ay0-krsize

az1       =         sin(sqrt(ax*ax+ay*ay))   ; COMPUTE THE SURFACE
az        =         az1*az1-.5

          outs      az*kdclick, az*kdclick

          endin

; z=ln(x^2+y^2)
          instr 2

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

kdclick   linseg    0, .002, iamp, idur-.004, iamp, .002, 0

krsize    linseg    .5, idur*.5, 5, idur*.5, .5
krad0     oscil     krsize, 1, 1
krad1     =         krad0+6

ax0       oscil     krad1, ifqc, 1, .25      ; COSINE
ax        =         ax0+krsize
ay0       oscil     krad1, ifqc, 1           ; SINE
ay        =         ay0-krsize

az        =         log(ax*ax+ay*ay)-4

          outs      az*kdclick, az*kdclick

          endin

; z=-5*x/(x^2+y^2+1)
          instr 3

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

kdclick   linseg    0, .002, iamp, idur-.004, iamp, .002, 0

krsize    linseg    .5, idur*.5, 5, idur*.5, .5
krad0     oscil     krsize, 1, 1
krad1     =         krad0+6

ax0       oscil     krad1, ifqc, 1, .25      ; COSINE
ax        =         ax0+krsize
ay0       oscil     krad1, ifqc, 1           ; SINE
ay        =         ay0-krsize

az        =         -5*ax/(ax*ax+ay*ay+1)

          outs      az*kdclick, az*kdclick

          endin

</CsInstruments>
<CsScore>
; SCORE
f1 0 8192 10 1

;   Sta  Dur  Amp    Pch
i1  0    2    20000  8.00
i2  2    2    1000   8.00
i3  4    2    5000   8.00

</CsScore>
</CsoundSynthesizer>
