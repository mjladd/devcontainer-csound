<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from bgoscil.orc and bgoscil.sco
; Original files preserved in same directory

sr        =         44100     ; SAMPLE RATE
kr        =         4410      ; CONTROL RATE
ksmps     =         10        ; NUMBER OF SAMPLES PER CONTROL PERIOD
nchnls    =         2         ; NUMBER OF CHANNELS

;---------------------------------------------------------------
; BEGINNERS OSCILLATOR DEMO
; BY HANS MIKELSON MARCH 1999
;---------------------------------------------------------------
;---------------------------------------------------------------
; OSCIL 1
; STEREO DETUNED OSCILATORS WITH VIBRATO
;---------------------------------------------------------------
          instr     1
idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
itable    =         p6                                 ; WAVEFORM NUMBER
ienv      =         p7                                 ; ENVELOPE SHAPE NUMBER
klfo      oscil     .01, 6, 1                          ; LOW FREQUENCY OSCILLATOR FOR VIBRATO
asigl     oscil     iamp, ifqc*0.999*(1+klfo), itable  ; LEFT SIGNAL
asigr     oscil     iamp, ifqc*1.001*(1+klfo), itable  ; RIGHT SIGNAL
kenv      oscili    1, 1/idur, ienv                    ; GENERATE THE ENVELOPE
          outs      asigl*kenv, asigr*kenv             ; SHAPE THE SIGNAL WITH THE ENVELOPE BEFORE OUTPUT
                    endin
;---------------------------------------------------------------
; SCI FI 1
;---------------------------------------------------------------
          instr     2
idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
itable    =         p6                                 ; WAVEFORM NUMBER
ienv      =         p7                                 ; ENVELOPE SHAPE NUMBER
klfo      oscil     .5, 3, 2                           ; LOW FREQUENCY OSCILLATOR FOR FREQUENCY SWEEP
asigl     oscil     iamp, ifqc*0.998*(1+klfo), itable  ; LEFT AUDIO SIGNAL
asigr     oscil     iamp, ifqc*1.002*(1+klfo), itable  ; RIGHT AUDIO SIGNAL
kenv      oscili    1, 1/idur, ienv                    ; GENERATE THE ENVELOPE
          outs      asigl*kenv, asigr*kenv             ; SHAPE THE SIGNAL WITH THE ENVELOPE BEFORE OUTPUT
          endin
;---------------------------------------------------------------
; SCI FI 2
;---------------------------------------------------------------
          instr     3
idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
itable    =         p6                                 ; WAVEFORM NUMBER
ienv      =         p7                                 ; ENVELOPE SHAPE NUMBER
klfo      oscil     .1, 4, 3                           ; LOW FREQUENCY OSCILLATOR FOR PITCH WARBLE
asigl     oscil     iamp, ifqc*0.998*(1+klfo), itable  ; LEFT AUDIO SIGNAL
asigr     oscil     iamp, ifqc*1.002*(1+klfo), itable  ; RIGHT AUDIO SIGNAL
kenv      oscili    1, 1/idur, ienv                    ; GENERATE THE ENVELOPE
          outs      asigl*kenv, asigr*kenv             ; SHAPE THE SIGNAL WITH THE ENVELOPE BEFORE OUTPUT
          endin
;---------------------------------------------------------------
; AUTO PANNING
;---------------------------------------------------------------
          instr     4
idur      =         p3                                 ; DURATION
iamp      =         p4                                 ; AMPLITUDE
ifqc      =         cpspch(p5)                         ; CONVERT PITCH TO FREQUENCY
itable    =         p6                                 ; WAVEFORM NUMBER
ienv      =         p7                                 ; ENVELOPE SHAPE NUMBER
klfo      oscil     .2, 8, 2                           ; LOW FREQUENCY OSCILLATOR FOR PITCH SWEEP
klfo2     oscil     .5, 2, 3                           ; LOW FREQUENCY OSCILLATOR FOR AUTOPANNING
asigl     oscil     iamp, ifqc*0.998*(1+klfo), itable  ; LEFT AUDIO SIGNAL
asigr     oscil     iamp, ifqc*1.002*(1+klfo), itable  ; RIGHT AUDIO SIGNAL
kenv      oscili    1, 1/idur, ienv                    ; GENERATE THE ENVELOPE
          outs      asigl*kenv*(klfo2+.4), asigr*kenv*(.4-klfo2) ; SHAPE WITH THE ENVELOPE AND PAN
          endin

</CsInstruments>
<CsScore>
;-------------------------------------------------------------------------
; BEGINNERS OSCILLATOR DEMO
; BY HANS MIKELSON MARCH 1999
;-------------------------------------------------------------------------
f1 0 16384 10 1                                    ; SINE WAVE
f2 0 16384 10 1 .5 .333333 .25 .2 .166667 .142857 .125 .111111 .1 .090909 .083333 .076923   ; BANDLIMITED SAWTOOTH WAVE
f3 0 16384 10 1 0  .333333 0   .2 0       .142857 0    .111111 0  .090909 0       .076923   ; BANDLIMITED SQUARE WAVE
f4 0 16384 7  1 16385 -1                           ; ARITHMETIC SAWTOOTH WAVE
f5 0 16384 7  1 8192   1 0 -1 8192 -1              ; ARITHMETIC SQUARE WAVE
f6 0 1025  7  0 128 1 128 .8 256 .6 256 .6 257 0   ; ADSR TYPE ENVELOPE
f7 0 1025  7  0 13 1 1000 1 12 0                   ; SIMPLE ENVELOPE
; DETUNED BAND-LIMITED OSCILATORS WITH VIBRATO
;    Sta  Dur  Amp    Pitch  Table  Env
i1   0    .5   20000  8.00   1      6
i1   +    .5   .      8.03   1      .
i1   .    .5   .      8.05   1      .
i1   .    .5   .      8.00   1      .
i1   .    .5   .      7.00   2      .
i1   .    .5   .      8.00   2      .
i1   .    1    .      7.07   2      .
i1   .    .5   .      7.00   3      .
i1   .    .5   .      8.03   3      .
i1   .    .5   .      8.05   3      .
i1   .    .5   .      8.00   3      .
i1   .    .5   .      7.00   2      .
i1   .    .5   .      7.07   2      .
i1   .    1    .      7.00   2      .
; ALGEBRAIC SAW AND SQUARE WAVES
;    Sta  Dur  Amp    Pitch  Table  Env
i1   9    1    .      7.00   4      .
i1   +    .    .      8.00   4      .
i1   .    .    .      7.00   5      .
i1   .    .    .      8.00   5      .
; Sci Fi sound;    Sta  Dur  Amp    Pitch  Table  Env
i2  14    2    20000  8.00   2      7
i3  16    2    20000  7.07   3      7
; Panning sound effect
i4  18    2    20000  7.07   2      7

</CsScore>
</CsoundSynthesizer>
