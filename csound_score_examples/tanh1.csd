<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tanh1.orc and tanh1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;------------------------------------------------------------------------------
; MODIFIED HYPERBOLIC DISTORTION
; CODED BY HANS MIKELSON DECEMBER 1998
;------------------------------------------------------------------------------
          zakinit   50, 50

;------------------------------------------------------------------------------
; PLUCKED INSTRUMENT
;------------------------------------------------------------------------------
          instr   1

idur      =         p3                                                          ; Duration
iamp      =         p4                                                          ; Amplitude
ipch      =         cpspch(p5)                                                  ; Pitch
itab1     =         p6
ioutch    =         p7                                                          ; Out Channel

asig      pluck     iamp, ipch, ipch, itab1, 1                                  ; Generate a plucked tone
          zawm      asig, ioutch                                                ; Mix to the Zak channel

          endin

;------------------------------------------------------------------------------
; SINE WAVE
;------------------------------------------------------------------------------
          instr   2

idur      =         p3                                                          ; Duration
iamp      =         p4                                                          ; Amplitude
ifqc      =         cpspch(p5)                                                  ; Pitch
itab1     =         p6
ioutch    =         p7                                                          ; Out Channel

asig      oscil     iamp, ifqc, itab1                                           ; Generate a plucked tone
          zawm      asig, ioutch                                                ; Mix to the Zak channel

          endin

;------------------------------------------------------------------------------
; TANH DISTORTION
;------------------------------------------------------------------------------
          instr   11

idur      =         p3
kpregn    =         p4/8000                                                     ; Pregain/Overdrive
kpostg    =         p5*20000                                                    ; Postgain/Volume
ka1       =         p6/8000                                                     ; Shape 1 0=flat
ka2       =         p7/8000                                                     ; Shape 2
irect     =         p8                                                          ; Rectification
iinch     =         p9                                                          ; Input Channel
ioutch    =         p10                                                         ; Output Channel
ioutlvl   =         p11                                                         ; Output Level

kdclick   linseg    0, .002, 1, idur-.004, 1, .002, 0                           ; DeClick Envelope

asig      zar       iinch
krms      rms       asig, 10
asig      =         asig + irect*krms

koffs1    =         irect*krms*(p4/1000+(p6-.5)/8000)
koffs2    =         -irect*krms*(p4/1000+(p7-.5)/8000)
koffs3    =         irect*krms*p4/1000
koffs     =         (exp(koffs1)-exp(koffs2))/(exp(koffs3)+exp(-koffs3))


ax1       =         asig*(kpregn+ka1)                                           ; Precalculate a few values to save time
ax2       =         -asig*(kpregn+ka2)
ax3       =         asig*kpregn

aout      =         ((exp(ax1)-exp(ax2))/(exp(ax3)+exp(-ax3))-koffs)*kpostg     ; modified tanh distortion

          zaw       aout*kdclick, ioutch                                        ; Output the result
          outs      aout*kdclick*ioutlvl, aout*kdclick*ioutlvl                  ; Output the result

          endin

;------------------------------------------------------------------------------
; Clear Zak
;------------------------------------------------------------------------------
          instr     99
          zacl      0, 50
          zkcl      0, 50
          endin

</CsInstruments>
<CsScore>
;------------------------------------------------------------------------------
; MODIFIED HYPERBOLIC TANGENT DISTORTION
; CODED BY HANS MIKELSON DECEMBER 1998
;------------------------------------------------------------------------------
; PLUCK
;    Sta  Dur  Amp    Pitch  Table  OutCh
i1   0    1    15000  7.00   0      1
i1   0    1    15000  7.07   0      1
i1   1    1    15000  8.00   0      1
i1   1    .25  15000  7.05   0      1
i1   +    .25  15000  7.07   0      1
i1   .    .25  15000  7.10   0      1
i1   .    .25  15000  8.00   0      1
i1   2    1    15000  6.00   0      1
i1   2    1    15000  7.00   0      1

; DISTORTION
;    Sta  Dur  Overdrive  Gain  Shape1  Shape2  Rect  InCh  OutCh  Output
i11  0    3    2          .5    .2      0       0     1     2      1

; PLUCK
;    Sta  Dur  Amp    Pitch  Table  OutCh
i1   3    1    15000  7.00   0      1
i1   3    1    15000  7.07   0      1
i1   4    1    15000  8.00   0      1
i1   4    .25  15000  7.05   0      1
i1   +    .25  15000  7.07   0      1
i1   .    .25  15000  7.10   0      1
i1   .    .25  15000  8.00   0      1
i1   5    1    15000  6.00   0      1
i1   5    1    15000  7.00   0      1

; DISTORTION
;    Sta  Dur  Overdrive  Gain  Shape1  Shape2  Rect  InCh  OutCh  Output
i11  3    3    .5         1     0       0       0     1     2      1

; PLUCK
;    Sta  Dur  Amp    Pitch  Table  OutCh
i1   6    1    15000  7.00   0      1
i1   6    1    15000  7.07   0      1
i1   7    1    15000  8.00   0      1
i1   7    .25  15000  7.05   0      1
i1   +    .25  15000  7.07   0      1
i1   .    .25  15000  7.10   0      1
i1   .    .25  15000  8.00   0      1
i1   8    1    15000  6.00   0      1
i1   8    1    15000  7.00   0      1

; DISTORTION
;    Sta  Dur  Overdrive  Gain  Shape1  Shape2  Rect  InCh  OutCh  Output
i11  6    3    4          .5    0       .2      .5    1     2      1

; ZAK CLEAR
i99  0    9


</CsScore>
</CsoundSynthesizer>
