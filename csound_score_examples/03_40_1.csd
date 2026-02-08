<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 03_40_1.orc and 03_40_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      03_40_1.ORC
; timbre:     chaotic sinusoid field
; synthesis:  additive with different units:
;             units: various continuous pitch control functions applied
;             to sinus or complex wave.
; source:     #510   Siren-like Glissandi, Risset(1969)
; coded:      jpg 9/93


instr 1; *****************************************************************
iamp1  = p4  ; unit 1
ifq1   = p5
irate1 = p6
 iampr  = p7  ; unit 2
 ifqr   = p8
 ifq2   = p9
 irate2 = p10
iamp3  = p11  ; unit 3
ifq3   = p12
irate3 = p13
 iamp4  = p14  ; unit 4
 ifq4   = p15
 irate4 = p16

   a1   oscili   ifq1, irate1, 31           ; unit 1
   a1   oscili   iamp1, a1, 11

   a99  randi    iampr, ifqr                ; unit 2
   a2   oscili   ifq2, irate2, 32
   a2   oscili   a99, a2, 11

   a3   oscili   ifq3, irate3, 33           ; unit 3
   a3   oscili   iamp3, a3, 12

   a4   oscili   ifq4, irate4, 34           ; unit 4
   a4   oscili   iamp4, a4, 11

   a5   =        a1+a2+a3+a4
        out      a5*10
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:      03_40_1.SCO
; coded:      jpg 9/93

; GEN functions **********************************************************
; waveforms
f11  0  512  9  1 1 0
f12  0  512  9  21 1 0  29 1 0  39 1 0
; envelopes
f31  0  512  7  .99   25 .99  206 .318 50 .318 206 .99 25 .99
f32  0  512  7  .377 256 .99  256 .377
f33  0  512  7   .5   15 .5   226 .9   30 .9   226 .5  15 .5
f34  0  512  7  .333   8 .333 240 .999 16 .999 240 .333 8 .333

; score ******************************************************************
;       unit 1          unit 2              unit 3          unit 4
;       amp1 fq1 rate1  ampr fqr fq2 rate2  amp3 fq3 rate3  amp4 fq4 rate4
i1 0 24 450  880 .12    400  200 1660 .17     12 200 .05      70 2400 .33

e

</CsScore>
</CsoundSynthesizer>
