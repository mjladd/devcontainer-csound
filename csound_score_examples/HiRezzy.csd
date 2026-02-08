<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from HiRezzy.orc and HiRezzy.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

; ORCHESTRA

;---------------------------------------------------------------------------
; SAW WITH MIKELSON REZZY FILTER
;---------------------------------------------------------------------------
          instr     15

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)*1.33
ifco      =         p6
ia2       =         1
krez      init      p7

kfco      expseg    100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100,.3*idur, .001*ifco+100
kamp      linseg    0, .002, iamp, .2, iamp*.8, p3-.222, iamp*.5, .02, 0

; axn     moogvco   ia2, ifqc, 1, 1
apulse    buzz      1,ifqc, sr/2/ifqc, 1     ; AVOID ALIASING
asaw      biquad     apulse, 1, 0, 0, 1, -.999, 0 ; BIQUAD USED AS A LEAKY INTEGRATOR

; SET UP FOR HIGH PASS VERSION OF REZZY.
kt        =         .75/sqrt(1+krez)
kc        =         sr/kfco/2/3.14159265
kq        =         krez/(1+sqrt(sqrt(1/kc)))
kb0       =         (kc/kq+kc*kc)*kt
kb1       =         (-kc/kq-2*kc*kc)*kt
kb2       =         kc*kc*kt
ka0       =         kc/kq+kc*kc
ka1       =         -kc/kq-2*kc*kc+1
ka2       =         kc*kc

ayn       biquad    asaw,  kb0, kb1, kb2, ka0, ka1, ka2 ; BIQUAD USED FOR HIGH PASS REZZY

          outs      ayn*kamp, ayn*kamp
          endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1                               ; Sine

;    Sta  Dur  Amp    Pitch  Fco   Rez
i15  0.0  2    40000  7.05   1000  10
i15  +    .    40000  6.03   2000  20
i15  .    .    40000  6.10   4000  40
i15  .    .    40000  7.05   8000  80

</CsScore>
</CsoundSynthesizer>
