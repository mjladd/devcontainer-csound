<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from birds.orc and birds.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

; ORCHESTRA
          zakinit   30, 30

;---------------------------------------------------------------------------
; THE BIRDS
;---------------------------------------------------------------------------
          instr 42

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
iwrbfm    =         p6
iwrbrt    =         p7
iwrbam    =         p8
iwave     =         p9
ioutch    =         p10

iwbeg     =         (iwrbfm>0 ? 1+iwrbfm         : 1/(1-iwrbfm)) ; DETERMINE WHETHER TO
iwend     =         (iwrbfm>0 ? 1/(1+iwrbfm) : 1-iwrbfm) ; RAMP UP OR DOWN.

kamp      linseg    0, .01, iamp, idur-.02, iamp, .01, 0 ; DECLICK

; FREQUENCY MODULATION
krate     linseg    iwbeg, idur, iwend
kfmod     oscil     iwrbam*krate, iwrbrt*krate, 1
kfmod     =         1+kfmod
kfqc      =         kfmod*ifqc

aout      oscil     kamp*kfmod, kfqc, iwave

          zawm      aout, ioutch

          endin

;---------------------------------------------------------------------------
; MIXER
;---------------------------------------------------------------------------
          instr 100

idur      init      p3
iamp      init      p4
inch      init      p5
ipan      init      p6
ifader    init      p7
ioutch    init      p8

asig1     zar       inch                     ; READ INPUT CHANNEL 1

kfader    oscil     1, 1/idur, ifader
kpanner   oscil     1, 1/idur, ipan

kgl1      =         kfader*sqrt(kpanner)     ; LEFT GAIN
kgr1      =         kfader*sqrt(1-kpanner)   ; RIGHT GAIN

kdclick   linseg    0, .002, iamp, idur-.002, iamp, .002, 0  ; DECLICK

asigl     =         asig1*kgl1               ; SCALE AND SUM
asigr     =         asig1*kgr1

          outs      kdclick*asigl, kdclick*asigr ; OUTPUT STEREO PAIR
          zaw       kdclick*kfader*asig1, ioutch ; OUTPUT POSTFADER

          endin

;---------------------------------------------------------------------------
; CLEAR AUDIO & CONTROL CHANNELS
;---------------------------------------------------------------------------
          instr 110

          zacl      0, 30                    ; CLEAR AUDIO CHANNELS 0 TO 30
          zkcl      0, 30                    ; CLEAR CONTROL CHANNELS 0 TO 30

          endin

</CsInstruments>
<CsScore>
; SCORE
;  Sta   Dur
a0 0     20      ; advance

; Sine Wave
f1  0 16384  10 1
f2 0   8192   7  -1  4096 1 4096 -1 ; Triangle Wave 1

; Mixer Tables
; 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5
f3  0 1024 -7 0  1024 1           ; UpSaw/FadeIn/PanRL
f4  0 1024 -7 0  512 1 512 0      ; Tri/Pan RLR/Fade In&Out
f5  0 1024 -7 1  1024 0           ; DnSaw/FadeOut/PanLR
f6  0 1024 -7 1  1024 1           ; Const1/PanL
f7  0 1024 -7 .5 1024 .5          ; Const.5/PanC
f8  0 1024 -7 0  1024 0           ; Const0/PanR
f9  0 1024 -7 0  256 1  768 1      ; Voice Amp
f10 0 1024 -7 .5 256 .2 768 .8    ; Voice Pan CRL
f11 0 1024 -7 .5 256 .8 768 .2    ; Voice Pan CLR
f12 0 1024 -7 0  256 1  512 1 256 0 ; FadeIn-Hold-FadeOut
f13 0 1024  7 1  1024 -1            ; DownSaw2
f19 0  1024  19 .5 .5 270 .5

;---------------------------------------------------------------------------
; The Birds
;---------------------------------------------------------------------------
f42  0 16384  10 1 0  0   0   .1
f43  0 16384  10 1 0 .33 0 .2 0 .14 0 .11
;   Sta   Dur   Amp   Pitch  WarbFM  WarbRate  WarbAM  Wave  OutCh
i42 20.0  1.5    600  11.00   1.2    12        .20     1     4
i42 23.0  0.5   1200  11.09  -2.9    74        .50     .     .
i42 25.2  1.0   1400  12.05   2.1    20        .04     .     .
i42 27.0  1.0   1000  11.04   1.1    14        .18     .     .
i42 29.4  1.2   3000  10.09   1.2    34        .38     .     .
i42 30.5  0.5   1400  12.00  -2.7    82        .52     .     .
i42 31.2  0.5   1200  12.00  -2.5    30        .80     .     .
i42 33.2  1.0   4400  12.01   2.1    20        .04     .     .
i42 34.5  0.5   3200  12.02  -2.5    80        .48     .     .
i42 35.2  0.7   2200  11.08  -1.2    10        .80     .     .
i42 36.0  1.0   1000  11.02   2.1    16        .38     .     .
i42 37.6  1.5   3600  11.03   1.2    12        .20     .     .
i42 38.0  1.0   2000  11.07   1.1    14        .18     .     .
;
i42 24.3  0.7   800   11.02   .2     60        .52     43    5
i42 24.7  1.5   1000  11.04   .5     15        .28     .     .
i42 28.2  1.2   1200  10.11  -2.5    6         .49     .     .
i42 32.3  0.7   1400  11.02   .2     60        .52     .     .
i42 33.7  1.5   2000  11.04   .8     15        .28     .     .
i42 34.2  1.0   3200  12.00  -1.5    80        .49     .     .
i42 35.8  0.4   1400  11.04   .4     50        .32     .     .
i42 36.2  1.2   3200  10.08  -.5     8         .29     .     .
i42 36.5  0.3   4200  11.00   2.2    4.1       .74     .     .
i42 +     0.3   2300  11.00   2.3    4.2       .76     .     .
i42 .     0.3   3400  11.01   2.4    4.3       .78     .     .
i42 .     0.3   2500  11.01   2.5    4.4       .80     .     .
i42 36.9  0.3   1200  11.09   1.3    74        .40     .     .
i42 37.2  1.2   3600  11.00  -1.1    12        .20     .     .
i42 38.2  1.7   3200  11.04  -.8     42        .60     .     .
i42 38.7  0.7   1700  12.02   1.5    62        .29     .     .
; Mixer 3=FadeIn, 5=FadeOut, 6=Const1, 7=Const.5, 8=Const0
;    Sta  Dur   Amp  Ch  Pan  Fader  OutCh
i100 20.0 20.0  2    4   3    4      20
i100 20.0 20.0  2    5   5    11     20

;---------------------------------------------------------------------------
; Clear ZAK
;---------------------------------------------------------------------------
; Clear Channels
i110 0  40

</CsScore>
</CsoundSynthesizer>
