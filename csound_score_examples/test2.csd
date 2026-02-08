<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from test2.orc and test2.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;---------------------------------------------------------------------------------
; A SET OF BAND LIMITED INSTRUMENTS WITH RESONANT FILTER
; BY HANS MIKELSON 11/20/97
; PARTIALLY DERIVED FROM CODE BY JOSEP Mª COMAJUNCOSAS-CSOUND & TIM STILSON-CCRMA
;---------------------------------------------------------------------------------
          zakinit   30, 30

;---------------------------------------------------------------------------------
; SAW WITH MIKELSON REZZY FILTER
;---------------------------------------------------------------------------------
          instr     10

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)*1.33
ifco      =         p6
ia2       =         1
krez      init      p7

kfco      expseg    100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100, .3*idur, .001*ifco+100
kamp      linseg    0, .002, iamp, .2, iamp*.8, p3-.222, iamp*.5, .02, 0

axn       vco       ia2, ifqc, 1, .5, 1, 1
ayn       rezzy     axn,  kfco, krez

          outs      ayn*kamp, ayn*kamp
          endin

;---------------------------------------------------------------------------------
; SAW WITH STILSON/SMITH/COMAJUNCOSAS MOOG FILTER
;---------------------------------------------------------------------------------
          instr     11

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
ifco      =         p6
krez      init      p7

kfco      linseg    100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100, .3*idur, .01*ifco+100

apulse1   buzz      1,ifqc, sr/2/ifqc, 1          ; AVOID ALIASING
asaw      integ     apulse1
ax        =         (asaw-.5)*2
ayn       moogvcf   ax, kfco, krez, 1

          outs      ayn*iamp, ayn*iamp
          endin

;---------------------------------------------------------------------------------
; SAW WITH CHAMBERLIN REZZY FILTER
;---------------------------------------------------------------------------------
          instr     14

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)
ifco      =         p6
krez      init      p7

kfco      expseg    100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100, .3*idur, .001*ifco+100

apulse1   buzz      1,ifqc, sr/2/ifqc, 1          ; AVOID ALIASING
asaw      integ     apulse1
axn       =         asaw-.5

kfcon     =         2*3.14159265*kfco/sr

kalpha    =         1-2*krez*cos(kfcon)*cos(kfcon)+krez*krez*cos(2*kfcon)
kbeta     =         krez*krez*sin(2*kfcon)-2*krez*cos(kfcon)*sin(kfcon)
kgama     =         1+cos(kfcon)
km1       =         kalpha*kgama+kbeta*sin(kfcon)
km2       =         kalpha*kgama-kbeta*sin(kfcon)
kden      =         sqrt(km1*km1+km2*km2)

kb0       =         1.5*(kalpha*kalpha+kbeta*kbeta)/kden
kb1       =         kb0
kb2       =         0

ka0       =         1
ka1       =         -2*krez*cos(kfcon)
ka2       =         krez*krez

ayn       biquad    axn, kb0, kb1, kb2, ka0, ka1, ka2

          outs      ayn*iamp/2, ayn*iamp/2
          endin


;---------------------------------------------------------------------------------
; SAW WITH MIKELSON REZZY FILTER
;---------------------------------------------------------------------------------
          instr     15

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)*1.33
ifco      =         p6
ia2       =         1
krez      init      p7

kfco      expseg    100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100, .3*idur, .001*ifco+100
kamp    linseg  0, .002, iamp, .2, iamp*.8, p3-.222, iamp*.5, .02, 0

; axn     moogvco   ia2, ifqc, 1, 1
apulse    buzz      1,ifqc, sr/2/ifqc, 1               ; AVOID ALIASING
asaw      biquad    apulse, 1, 0, 0, 1, -.999, 0       ; BIQUAD USED AS A LEAKY INTEGRATOR

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

ayn       biquad    asaw,  kb0, kb1, kb2, ka0, ka1, ka2     ; BIQUAD USED FOR HIGH PASS REZZY

          outs      ayn*kamp, ayn*kamp
          endin


</CsInstruments>
<CsScore>
f1 0 16384 10 1                               ; Sine

; SAW MIKELSON
;    Sta  Dur  Amp    Pitch  Fco   Rez
;i15  0.0  2    40000  7.05   1000  10
;i15  +    .    40000  6.03   2000  20
;i15  .    .    40000  6.10   4000  40
;i15  .    .    40000  7.05   8000  80

; SAW MOOG/SMITH/STILSON C
;    Sta  Dur  Amp    Pitch  Fco   Rez
i11  0.0  1.0  20000  6.00   1000  .7
i11  +    1.0  20000  6.03   2000  .8
i11  .    1.0  20000  6.10   3000  .98
i11  .    1.0  20000  7.05   4000  2

; SAW CHAMBERLIN BIQUAD
;    Sta  Dur  Amp    Pitch  Fco   Rez
;i14  8.0  1.0  20000  6.00   1000  .8
;i14  +    1.0  20000  6.03   2000  .95
;i14  .    1.0  20000  6.10   3000  .98
;i14  .    1.0  20000  7.05   4000  .99


</CsScore>
</CsoundSynthesizer>
