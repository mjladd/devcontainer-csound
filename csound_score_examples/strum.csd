<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from strum.orc and strum.sco
; Original files preserved in same directory

sr             =              44100
kr             =              22050
ksmps          =              2
nchnls         =              2

; ORCHESTRA
; THIS INSTRUMENT IS DESIGNED FOR STRUMMING CHORDS.
; CODED BY HANS MIKELSON 11/15/97


; STRUMMER INSTRUMENT
               instr          1

idur           =              p3                       ; DURATION
iamp           =              p4                       ; AMPLITUDE
iroot          =              p5                       ; ROOT OF THE CHORD
ichord         =              p6                       ; THE TYPE OF CHORD
iwave          =              p7                       ; WAVE FORM
ireps          =              p8                       ; NUMBER OF STRUMS
ienv           =              p9                       ; ENVELOPE SHAPE
iphase         =              1-p10                    ; TIME BETWEEN INDIVIDUAL PICKS
itemper        =              p11                      ; TEMPERAMENT
icarr          =              1                        ; CARRIER
imodu          =              3                        ; MODULATOR

; FIRST NOTE OF THE CHORD
kamp1          oscil          1, ireps/idur, ienv      ; USED FOR ENVELOPE
ichd1          table          0, ichord                ; READ THE CHORD TABLE
ifqc1          cps2pch        iroot+ichd1/100, 12      ; COMPUTE THE FREQUENCY
;                Amp    Fqc    Car    Mod    Index    Wave
asig1          foscil         kamp1, ifqc1, icarr, imodu, kamp1*4, iwave   ; USE A SIMPLE FM TONE

; SECOND NOTE OF THE CHORD
kamp2          oscil          1, ireps/idur, ienv, iphase
ichd2          table          1, ichord
ifqc2          cps2pch        iroot+ichd2/100, 12
asig2          foscil         kamp2, ifqc2, icarr, imodu, kamp2*4, iwave

; THIRD NOTE OF THE CHORD
kamp3          oscil          1, ireps/idur, ienv, iphase*2
ichd3          table          2, ichord
ifqc3          cps2pch        iroot+ichd3/100, 12
asig3          foscil         kamp3, ifqc3, icarr, imodu, kamp3*4, iwave

; FOURTH NOTE OF THE CHORD
kamp4          oscil          1, ireps/idur, ienv, iphase*3
ichd4          table          3, ichord
ifqc4          cps2pch        iroot+ichd4/100, 12
asig4          foscil         kamp4, ifqc4, icarr, imodu, kamp4*4, iwave

; SUM AND OUTPUT THE HAPPY RESULT
aout           =              asig1+asig2+asig3+asig4
               outs           aout*iamp, aout*iamp

               endin

; EQUAL TEMPERAMENT TEST
               instr          2

idur           =              p3
iamp           =              p4
ipch           =              p5
iwave          =              p6
ienv           =              p7
itemper        =              p8
icarr          =              1
imodu          =              3

kamp1          oscil          1, 1/idur, ienv
ifqc1          cps2pch        ipch, -4

;                Amp    Fqc    Car    Mod    Index    Wave
asig1          foscil         kamp1, ifqc1, icarr, imodu, kamp1*4, iwave

aout           =              asig1
               outs           aout*iamp, aout*iamp

               endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 1024 7  1 1024 -1
f3 0 1024 7 0 16 1 368 .6 512 .4 128 0

; TEMPERAMENTS I CANT FIGURE OUT HOW TO GET THE TEMPERAMENTS TO WORK.
f4 0 16 -2 1.000 1.067 1.121 1.196 1.273 1.344 1.422 1.496 1.600 1.703 1.798 1.903 2.000 ; WERKMEISTER III
f5 0 16 -2 1.000 1.059 1.122 1.189 1.260 1.335 1.414 1.498 1.587 1.682 1.782 1.888 2.000 ; EQUAL
f6 0 16 -2 1.000 2.000 3.000 4.000 1.260 1.335 1.414 1.498 1.587 1.682 1.782 1.888 2.000 ; EQUAL

; CHORDS
f10 0 4 -2  0  4  7 12      ; MAJOR
f11 0 4 -2  0  3  7 12      ; MINOR
f12 0 4 -2  0  5  7 12      ; SUS4
f13 0 4 -2  0  2  7 12      ; SUS2
f14 0 4 -2  0  4  7 10      ; 7TH
f15 0 4 -2  0  3  7 10      ; MINOR7TH
f16 0 4 -2  0  3  7 11      ; MIN/MAJ7TH
f17 0 4 -2  0  4  7 11      ; MAJ7TH
f18 0 4 -2  0  4  7  9      ; MAJOR6TH
f19 0 4 -2  0  3  7  9      ; MINOR6TH
f20 0 4 -2  0  4 10 14      ; 9TH
f21 0 4 -2  0  4 10 17      ; 11TH
f22 0 4 -2  0  4 10 21      ; 13TH
f23 0 4 -2  0  3  6 12      ;

;6/9:            0  4  7  9 14
;MIN9TH:         0  3  7 10 14
;MIN11TH:        0  3  7 10 17
;MIN13TH:        0  3  7 10 21
;MAJ9TH:         0  4  7 11 14
;MAJ11TH:        0  4  7 11 17
;MAJ13TH:        0  4  7 11 21
;ADD2:           0  2  4  7

;   STA  DUR  AMP   ROOT  CHORD  WAVE  REPEAT  ENV  PHASE  TEMPERAMENT
i1  0    1.6  8000  7.02  10     1     2       3    .20    4
i1  +    1.6  .     7.04  11     .     2       .    .      .
i1  .    0.8  .     6.09  10     .     1       .    .      .
i1  .    1.6  .     7.07  10     .     2       .    .10    .
i1  .    1.6  .     7.02  10     .     1       .    .20    .
;
i1  .    0.8  .     7.02  10     .     1       .    .05    .
i1  .    0.8  .     7.02  11     .     1       .    .05    .
i1  .    0.8  .     7.02  12     .     1       .    .00    .
i1  .    0.8  .     7.02  13     .     1       .    .00    .
i1  .    0.8  .     7.02  23     .     1       .    .05    .
i1  .    1.6  .     7.02  10     .     1       .    .10    .

;   STA  DUR  AMP   PITCH  WAVE  ENV  TEMPERAMENT
;i2  0    .2   8000  7.00   1     3    4
;i2  +    .    .     7.01   .     .    .
;i2  .    .    .     7.02   .     .    .
;i2  .    .    .     7.03   .     .    .
;i2  .    .    .     7.04   .     .    .
;i2  .    .    .     7.05   .     .    .
;i2  .    .    .     7.06   .     .    .
;i2  .    .    .     7.07   .     .    .
;i2  .    .    .     7.08   .     .    .
;i2  .    .    .     7.09   .     .    .
;i2  .    .    .     7.10   .     .    .
;i2  .    .    .     7.11   .     .    .
;i2  .    .    .     7.12   .     .    .

</CsScore>
</CsoundSynthesizer>
