<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from tanh2.orc and tanh2.sco
; Original files preserved in same directory

sr             =              44100
kr             =              4410
ksmps          =              10
nchnls         =              2

;------------------------------------------------------------------------------
; MODIFIED HYPERBOLIC DISTORTION
; CODED BY HANS MIKELSON DECEMBER 1998
;------------------------------------------------------------------------------
               zakinit        50, 50

;------------------------------------------------------------------------------
; PLUCKED INSTRUMENT
;------------------------------------------------------------------------------
               instr          1

idur           =              p3                            ; DURATION
iamp           =              p4                            ; AMPLITUDE
ipch           =              cpspch(p5)                    ; PITCH
itab1          =              p6
ioutch         =              p7                            ; OUT CHANNEL

asig           pluck          iamp, ipch, ipch, itab1, 1    ; GENERATE A PLUCKED TONE
               zawm           asig, ioutch                  ; MIX TO THE ZAK CHANNEL

               endin

;------------------------------------------------------------------------------
; SINE WAVE
;------------------------------------------------------------------------------
               instr          2

idur           =              p3                                 ; DURATION
iamp           =              p4                                 ; AMPLITUDE
ifqc           =              cpspch(p5)                         ; PITCH
itab1          =              p6
ioutch         =              p7                                 ; OUT CHANNEL

asig           oscil          iamp, ifqc, itab1                  ; GENERATE A PLUCKED TONE
               zawm           asig, ioutch                       ; MIX TO THE ZAK CHANNEL

               endin

;------------------------------------------------------------------------------
; TANH DISTORTION
;------------------------------------------------------------------------------
               instr          11

idur           =              p3
kpregn         =              p4/8000                            ; PREGAIN/OVERDRIVE
kpostg         =              p5*20000                           ; POSTGAIN/VOLUME
ka1            =              p6/8000                            ; SHAPE 1 0=FLAT
ka2            =              p7/8000                            ; SHAPE 2
irect          =              p8                                 ; RECTIFICATION
iinch          =              p9                                 ; INPUT CHANNEL
ioutch         =              p10                                ; OUTPUT CHANNEL
ioutlvl        =              p11                                ; OUTPUT LEVEL

kdclick        linseg         0, .002, 1, idur-.004, 1, .002, 0  ; DECLICK ENVELOPE

asig           zar            iinch
krms           rms            asig, 10
asig           =              asig + irect*krms

koffs1         =              irect*krms*(p4/1000+(p6-.5)/8000)
koffs2         =              -irect*krms*(p4/1000+(p7-.5)/8000)
koffs3         =              irect*krms*p4/1000
koffs          =              (exp(koffs1)-exp(koffs2))/(exp(koffs3)+exp(-koffs3))


ax1            =              asig*(kpregn+ka1)   ; PRECALCULATE A FEW VALUES TO SAVE TIME
ax2            =              -asig*(kpregn+ka2)
ax3            =              asig*kpregn

aout           =              ((exp(ax1)-exp(ax2))/(exp(ax3)+exp(-ax3))-koffs)*kpostg                                        ; MODIFIED TANH DISTORTION

               zaw            aout*kdclick, ioutch                         ; OUTPUT THE RESULT
               outs           aout*kdclick*ioutlvl, aout*kdclick*ioutlvl   ; OUTPUT THE RESULT

               endin

;------------------------------------------------------------------------------
; CLEAR ZAK
;------------------------------------------------------------------------------
               instr          99
               zacl           0, 50
               zkcl           0, 50
               endin


</CsInstruments>
<CsScore>
;------------------------------------------------------------------------------
; MODIFIED HYPERBOLIC TANGENT DISTORTION
; CODED BY HANS MIKELSON OCTOBER 1998
;------------------------------------------------------------------------------
f1 0 8192 10 1
f2 0 8192 11 20

; PLUCK
;    Sta   Dur  Amp    Pitch  Table  OutCh
i1   0.0   .18  10000  6.00   0      1
i1   0.0   .    .      7.07   .      .
i1   0.2   .    .      6.00   .      .
i1   0.2   .    .      7.07   .      .
;
i1   1.6   .    .      6.00   .      .
i1   1.6   .    .      7.07   .      .
i1   1.8   .    .      6.00   .      .
i1   1.8   .    .      7.07   .      .
;
i1   3.2   .    .      6.00   .      .
i1   3.2   .    .      7.07   .      .
i1   3.4   .    .      6.00   .      .
i1   3.4   .    .      7.07   .      .
;
i1   4.8   .    .      6.00   .      .
i1   4.8   .    .      7.07   .      .
i1   5.0   .    .      6.00   .      .
i1   5.0   .    .      7.07   .      .
;
i1   6.4   .    .      6.00   .      .
i1   6.4   .    .      7.07   .      .
i1   6.6   .    .      6.00   .      .
i1   6.6   .    .      7.07   .      .
;
i1   8.0   .    .      6.00   .      .
i1   8.0   .    .      7.07   .      .
i1   8.2   .    .      6.00   .      .
i1   8.2   .    .      7.07   .      .
;
i1   9.6   .    .      6.00   .      .
i1   9.6   .    .      7.07   .      .
i1   9.8   .    .      6.00   .      .
i1   9.8   .    .      7.07   .      .
;
i1  11.2   .    .      6.00   .      .
i1  11.2   .    .      7.07   .      .
i1  11.4   .    .      6.00   .      .
i1  11.4   .    .      7.07   .      .
;
i1  12.8   .    .      6.00   .      .
i1  12.8   .    .      7.07   .      .
i1  13.0   .    .      6.00   .      .
i1  13.0   .    .      7.07   .      .
;
i1  14.4   .    .      6.00   .      .
i1  14.4   .    .      7.07   .      .
i1  14.6   .    .      6.00   .      .
i1  14.6   .    .      7.07   .      .

; DISTORTION
;    Sta  Dur   Overdrive  Gain  Shape1  Shape2  Rect  InCh  OutCh  Output
i11  0    16.0  4          .2    0       0       0     1     2      1

; PLUCK
;    Sta   Dur  Amp    Pitch  Table  OutCh
i1   3.2   .2   10000  7.00   0      3
i1   +     .    <      7.07   .      .
i1   .     .    <      8.05   .      .
i1   .     .    <      6.03   .      .
i1   .     .    <      7.03   .      .
i1   .     .    <      7.07   .      .
i1   .     .    <      6.07   .      .
i1   .     .    20000  7.10   .      .
;
i1   6.4   .2   10000  7.00   0      3
i1   +     .    <      7.07   .      .
i1   .     .    <      8.05   .      .
i1   .     .    <      6.03   .      .
i1   .     .    <      7.03   .      .
i1   .     .    <      7.07   .      .
i1   .     .    <      6.07   .      .
i1   .     .    20000  7.10   .      .
;
i1   9.6   .2   10000  7.00   0      3
i1   +     .    <      7.09   .      .
i1   .     .    <      8.07   .      .
i1   .     .    <      6.03   .      .
i1   .     .    <      7.05   .      .
i1   .     .    <      7.10   .      .
i1   .     .    <      6.06   .      .
i1   .     .    20000  7.10   .      .
;
i1  12.8   .2   10000  7.00   0      3
i1   +     .    <      7.09   .      .
i1   .     .    <      8.07   .      .
i1   .     .    <      6.03   .      .
i1   .     .    <      7.05   .      .
i1   .     .    <      7.10   .      .
i1   .     .    <      6.06   .      .
i1   .     .    20000  7.10   .      .

; DISTORTION
;    Sta  Dur   Overdrive  Gain  Shape1  Shape2  Rect  InCh  OutCh  Output
i11  3.2  12.8  2          .2    0       0       0     3     4      1


; ZAK CLEAR
i99  0    16


</CsScore>
</CsoundSynthesizer>
