<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from hvyguit3.orc and hvyguit3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;------------------------------------------------------------------------------
; Modified Hyperbolic Distortion
; Coded by Hans Mikelson October 1998
;------------------------------------------------------------------------------
          zakinit   50, 50


;------------------------------------------------------------------------------
; PLUCKED INSTRUMENT
;------------------------------------------------------------------------------
        instr   1

idur    =       p3                                                    ; Duration
iamp    =       p4                                                    ; Amplitude
ipch    =       cpspch(p5)                                            ; Pitch
itab1   =       p6
ioutch  =       p7                                                    ; Out Channel

asig    pluck   iamp, ipch, ipch, itab1, 1                            ; Generate a plucked tone
        zawm    asig, ioutch                                          ; Mix to the Zak channel

        endin

;------------------------------------------------------------------------------
; SINE WAVE
;------------------------------------------------------------------------------
        instr   2

idur    =       p3                                                    ; Duration
iamp    =       p4                                                    ; Amplitude
ifqc    =       cpspch(p5)                                            ; Pitch
itab1   =       p6
ioutch  =       p7                                                    ; Out Channel

asig    oscil   iamp, ifqc, itab1                                     ; Generate a plucked tone
        zawm    asig, ioutch                                          ; Mix to the Zak channel

        endin

;------------------------------------------------------------------------------
; DISTORTION
;------------------------------------------------------------------------------
         instr   10

idur     =       p3
kpregn   =       p4/1000                                              ; Pregain/Overdrive
kpostg   =       p5*20000                                             ; Postgain/Volume
ka1      =       (p6-.5)/8000                                         ; Shape 1 0=flat
ka2      =       (p7-.5)/8000                                         ; Shape 2
iinch    =       p8                                                   ; Input Channel
ioutch   =       p9                                                   ; Output Channel
ioutlvl  =       p10                                                  ; Output Level

kdclick  linseg  0, .002, 1, idur-.004, 1, .002, 0                    ; DeClick Envelope

asig     zar     iinch

ax1      =       asig*(kpregn+ka1)                                    ; Precalculate a few values to save time
ax2      =      -asig*(kpregn+ka2)
ax3      =       asig*kpregn

aout     =       (exp(ax1)-exp(ax2))/(exp(ax3)+exp(-ax3))*kpostg      ; modified tanh distortion

         zaw      aout*kdclick, ioutch                                ; Output the result
         outs     aout*kdclick*ioutlvl, aout*kdclick*ioutlvl          ; Output the result

         endin

;------------------------------------------------------------------------------
; DISTORTION 2
;------------------------------------------------------------------------------
         instr   11

idur     =       p3
kpregn   =       p4/8000                                              ; Pregain/Overdrive
kpostg   =       p5*20000                                             ; Postgain/Volume
ka1      =       p6/8000                                              ; Shape 1 0=flat
ka2      =       p7/8000                                              ; Shape 2
irect    =       p8                                                   ; Rectification
iinch    =       p9                                                   ; Input Channel
ioutch   =       p10                                                  ; Output Channel
ioutlvl  =       p11                                                  ; Output Level

kdclick linseg  0, .002, 1, idur-.004, 1, .002, 0                     ; DeClick Envelope

asig     zar     iinch
krms     rms     asig, 10
asig     =       asig + irect*krms

koffs1   =       irect*krms*(p4/1000+(p6-.5)/8000)
koffs2   =      -irect*krms*(p4/1000+(p7-.5)/8000)
koffs3   =       irect*krms*p4/1000
koffs    =       (exp(koffs1)-exp(koffs2))/(exp(koffs3)+exp(-koffs3))


ax1      =       asig*(kpregn+ka1)                                    ; Precalculate a few values to save time
ax2      =      -asig*(kpregn+ka2)
ax3      =       asig*kpregn

aout     =       ((exp(ax1)-exp(ax2))/(exp(ax3)+exp(-ax3))-koffs)*kpostg ; modified tanh distortion

         zaw      aout*kdclick, ioutch                                ; Output the result
         outs     aout*kdclick*ioutlvl, aout*kdclick*ioutlvl          ; Output the result

         endin

;------------------------------------------------------------------------------
; DISTORTION 3
;------------------------------------------------------------------------------
         instr   12

idur     =       p3
kpregn   =       p4                                              ; Pregain/Overdrive
kpostg   =       p5                                              ; Postgain/Volume
ka1      =       p6                                              ; Shape 1 0=flat
ka2      =       p7                                              ; Shape 2
iinch    =       p8                                              ; Input Channel
ioutch   =       p9                                              ; Output Channel
ioutlvl  =       p10                                             ; Output Level

kdclick linseg  0, .002, 1, idur-.004, 1, .002, 0                ; DeClick Envelope

asig     zar     iinch

aout     distort1 asig, kpregn, kpostg, ka1, ka2                 ; modified tanh distortion

         zaw      aout*kdclick, ioutch                           ; Output the result
         outs     aout*kdclick*ioutlvl, aout*kdclick*ioutlvl     ; Output the result

         endin

;---------------------------------------------------------------------------
; Wah-Wah
;---------------------------------------------------------------------------
         instr   16

irate    =       p4                ; Auto Wah Rate
idepth   =       p5                ; Low Pass Depth
ilow     =       p6                ; Minimum Frequency
ifmix    =       p7/1000           ; Formant Mix
itab1    =       p8                ; Wave form table
izin     =       p9                ; Input Channel

kosc1    oscil   .5, irate, itab1, .25        ; Oscilator
kosc2    =       kosc1 + .5                   ; Rescale for 0-1
kosc3    =       kosc2                        ; Formant Depth 0-1

klopass  =       idepth*kosc2+ilow            ; Low pass filter range
kform1   =       430*kosc2 + 300              ; Formant 1 range
kamp1    =       ampdb(-2*kosc3 + 59)*ifmix   ; Formant 1 level
kform2   =       220*kosc2 + 870              ; Formant 2 range
kamp2    =       ampdb(-14*kosc3 + 55)*ifmix  ; Formant 2 level
kform3   =       200*kosc2 + 2240             ; Formant 3 range
kamp3    =       ampdb(-15*kosc3 + 32)*ifmix  ; Formant 3 level

asig     zar       izin                       ; Read input channel

afilt    butterlp asig, klopass               ; Low pass filter

ares1    reson    afilt, kform1, kform1/8     ; Compute some formants
ares2    reson    afilt, kform2, kform1/8     ; to add character to the
ares3    reson    afilt, kform3, kform1/8     ; sound

aresbal1 balance  ares1, afilt                ; Adjust formant levels
aresbal2 balance  ares2, afilt
aresbal3 balance  ares3, afilt

aout     =         afilt+kamp1*aresbal1+kamp2*aresbal2+kamp3*aresbal3

         outs      aout, aout

         endin

;------------------------------------------------------------------------------
; Clear Zak
;------------------------------------------------------------------------------
         instr   99
         zacl    0, 50
         zkcl    0, 50
         endin

</CsInstruments>
<CsScore>
;------------------------------------------------------------------------------
; MODIFIED HYPERBOLIC TANGENT DISTORTION
; CODED BY HANS MIKELSON OCTOBER 1998
;------------------------------------------------------------------------------
f1 0 8192 10 1
f2 0 8192 11 20

; SINE
;    Sta  Dur  Amp    Pitch  Table  OutCh
;i2   0    1    25000  7.00   1      1

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
