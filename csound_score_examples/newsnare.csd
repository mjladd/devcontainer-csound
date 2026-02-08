<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from newsnare.orc and newsnare.sco
; Original files preserved in same directory

sr      =        44100                      ; Sample rate
kr      =        44100                      ; Kontrol rate
ksmps   =        1                          ; Samples/Kontrol period
nchnls  =        2                          ; Normal stereo


;---------------------------------------------------------
; Electric Snare
;---------------------------------------------------------
       instr     25

idur   =         p3            ; Duration
iamp   =         p4            ; Amplitude
ifqc   =         cpspch(p5)    ; Pitch to frequency
ipanl  =         sqrt(p6)      ; Pan left
ipanr  =         sqrt(1-p6)    ; Pan right
irez   =         .9+p7*.1      ; Tone
ispdec =         p8            ; Spring decay
ispton =         p9            ; Spring tone
ispmix =         p10           ; Spring mix
ispq   =         p11           ; Spring Q

kdclk  linseg    1, idur-.002, 1, .002, 0                ; Declick envelope
aamp   linseg    1, .2/ifqc, 1, .2/ifqc, 0, idur-.002, 0 ; An amplitude pulse
aampr  expseg    .1, .002, 1, .2*ispdec, .005            ; Noise envelope

arnd   rand      1, .5, 1                     ; High quality noise
arnd    =        (arnd-.5)*2*aampr            ; Make it positive and negative

ahp1    rezzy    arnd, 2700*ispton, 5*ispq, 1 ; High pass rezzy based at 2700
ahp2    butterbp arnd, 2000*ispton, 500/ispq  ; Generate an undertone
ahp3    butterbp arnd, 5400*ispton, 500/ispq  ; Generate an overtone
ahp     pareq    ahp1+ahp2*.7+ahp3*.3, 15000, .1, .707, 2 ; Attenuate the highs a bit

aosc1   vco      1, 400, 2, 1, 1, 1 ; Use a pulse of the vco to stimulate the filters
aosc    =        -aosc1*aamp        ; Multiply by the envelope pulse
aosc2   butterlp aosc, 12000        ; Lowpass at 12K to take the edge off

asig1   moogvcf  aosc,    ifqc, .9*irez      ; Moof filter with high resonance for basic drum tone
asig2   moogvcf  aosc*.5, ifqc*2.1, .75*irez ; Sweeten with an overtone

; Mix drum tones, pulse and noise signal & declick
aout   =         (asig1+asig2+aosc2*.1+ahp*ispmix)*iamp*kdclk*2

       outs      aout*ipanl, aout*ipanr              ; Output the sound

       endin

</CsInstruments>
<CsScore>
f1 0 65536 10 1

; Electric Snare
;    Sta     Dur  Amp    Pitch  Pan  HitQ  SprDec SprTone SprMix SprQ
i25  0.000   .25  25000  7.02   .5   1.3   1      1       1      1
i25  +       .    .      .      .    .     .5     2       .      .
i25  .       .    .      .      .    .     2      .5      .      .
i25  .       .    .      .      .    .     1      1       .      2
i25  .       .    .      .      .    .     .      .       .      0.5
i25  .       .    .      .      .    .     .      .       .      1.5
i25  .       .    .      .      .    .     2      .5      .      1
i25  .       .    .      .      .    .     1      1       .      .
i25  .       .    .      .      .    .     .      .       .      .
i25  .       .    .      7.00   .    1.5   .      .       .      .
s
;    Sta     Dur   Amp    Pitch  Pan  HitQ  SprDec SprTone SprMix SprQ
i25  0.000   .125  25000  7.02   0    1.3   .5     1       .8     1
i25  +       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .0625 .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .0625 .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .     .      .      <    .     .      .       .      .
i25  .       .25   .      .      1    1.5   2      .       .8     .

</CsScore>
</CsoundSynthesizer>
