<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from newcymbal.orc and newcymbal.sco
; Original files preserved in same directory

sr      =        44100                      ; Sample rate
kr      =        44100                      ; Kontrol rate
ksmps   =        1                          ; Samples/Kontrol period
nchnls  =        2                          ; Normal stereo

; Mikelson Cymbal ORCHESTRA

;---------------------------------------------------------
; Cymbal
;---------------------------------------------------------
       instr     17

idur   =         p3            ; Duration
iamp   =         p4/(1+sqrt(p3))*.3*sqrt(p8) ; Amplitude
ifqc   =         cpspch(p5)
ipanl  =         sqrt(p6)      ; Pan left
ipanr  =         sqrt(1-p6)    ; Pan right
iqfqc  =         p7            ; Primary resonance
iqq    =         p8            ; Resonance Q
iqact  =         p9*.02        ; Resonance accent
iotfqc =         p10           ; Overtone frequency
iotq   =         p10*.25       ; Overtone bandwidth
iotact =         .02           ; Overtone accent
ilpfco =         p10*1.25      ; Lowpass
iaact  =         p11*.001      ; Amplitude accent
ipbend =         p12
iptim  =         p13

adclck linseg    0, .002, 1, idur-.004, 1, .002, 0 ; Declick envelope
kamp   expseg    1, idur, iaact
kamp2  expseg    2, idur, iqact
kamp3  expseg    1, idur, iotact
kptch  expseg    ipbend, iptim, 1, idur-iptim, 1

arnd   rand      kamp2

asig1  vco       1, ifqc*kptch,     2, .5, 1, 2/ifqc     ; Genrate impulse
asig2  vco       1, ifqc*1.3*kptch, 2, .5, 1, 2/ifqc     ; Genrate impulse
;asig3  vco       1, ifqc*.573, 2, .5, 1, 2/ifqc     ; Genrate impulse
asig   =         (asig1*asig2*(1+arnd))*iamp*adclck*kamp

aout1  rezzy    asig, iqfqc, iqq, 1  ; Apply amp envelope and declick
aout2  butterbp aout1*kamp3, iotfqc, iotq   ; Apply amp envelope and declick
aout   butterlp aout1+aout2*4, ilpfco       ; Apply amp envelope and declick

       outs      aout*ipanl, aout*ipanr            ; Output the sound

       endin

</CsInstruments>
<CsScore>
; SCORE
f1 0 65536 10 1

;    Sta   Dur   Amp    Pitch  Pan  QFqc  QQ  QAcct  OTFqc  Accent PBend PBTime
i17  0.0   0.15  30000  10.00  .5   7000  15  1      14000  1      1.02  .05
i17  .5    0.15  30000  10.00  .5   .     .   .      .      .      .     .
i17  1     0.15  30000  10.00  .5   .     .   .      .      .      .     .
i17  1.5   0.15  30000  10.00  .5   .     .   .      .      .      .     .
i17  2     2.0   30000  10.00  .5   .     .   .      .      .      .     .
i17  +     2.0   30000  9.00   .5   .     .   .      .      .      .     .
s

;    Sta   Dur   Amp    Pitch  Pan  QFqc  QQ  QAcct  OTFqc
i17  0.0   0.15  20000  10.00  .5   7000  35  1      14000  1      1.02  .05
i17  .5    0.15  30000  10.00  .5   .     15  .      .      .      .     .
i17  1     0.15  30000  10.00  .5   .     5   .      .      .      .     .
i17  1.5   0.15  30000  10.00  .5   .     2   .      .      .      .     .
i17  2     1.0   25000  10.00  .5   .     25  .      .      .      .     .
i17  +     1.0   30000  10.00  .5   .     5   .      .      .      .     .
s

;    Sta   Dur   Amp    Pitch  Pan  QFqc  QQ  QAcct  OTFqc
i17  0.0   0.15  30000  6.00  .5   7000  15  1      14000  1      1.02  .05
i17  .5    0.15  30000  6.00  .5   6000  .   .      .      .      .     .
i17  1     0.15  30000  5.00  .5   5000  .   .      .      .      .     .
i17  1.5   0.15  30000  8.00  .5   8000  .   .      .      .      .     .
i17  2     2.0   30000  5.00  .5   5000  .   .      10000  10     .     .
i17  +     2.0   30000  4.00  .5   4000  .   .      .      .      .     .
i17  .     2.0   30000  3.00  .5   4000  15  .      .      .      .     .
i17  .     2.0   30000  4.00  .5   2000  .   100    5000   100    .     .
i17  .     2.0   20000  3.00  .5   4000  .   .      .      .      .     .
i17  .     2.0   30000  3.00  .5   2000  .   10     3000   10     .     .
i17  .     4.0   30000  3.00  .5   2000  .   .      .      .      .     .
i17  .     4.0   15000  2.00  .5   4500  .   20     10000   200   1.5   .5
s

;    Sta   Dur   Amp    Pitch  Pan  QFqc  QQ  QAcct  OTFqc
i17  0.0   0.15  30000  6.00  .5   7000  15  1      14000  1      1.02  .05
i17  .5    0.15  30000  6.00  .5   6000  .   .      .      .      .     .
i17  1     0.15  30000  5.00  .5   5000  .   .      .      .      .     .
i17  1.5   0.15  30000  8.00  .5   8000  .   .      .      .      .     .
i17  2     2.0   30000  9.00  .5   5000  .   .      .      .      .     .
i17  +     2.0   30000  9.00  .5   4000  .   .      .      .      .     .
i17  .     2.0   40000  10.00  .5  4000  15  10     .      10     .     .
i17  .     2.0   40000  10.00  .5  2000  15  1      .      1      .     .
i17  .     2.0   40000  10.00  .5  3000  15  10     .      10     .8    .2
i17  .     2.0   40000  11.00  .5  1500  15  .      .      .      1.04  .
s

;    Sta   Dur   Amp    Pitch  Pan  QFqc  QQ  QAcct   OTFqc
i17  0.0   0.15  30000  10.00  .5   8000  10  1      14000  1      1.02  .05
i17  +     0.15  30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.15  30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.15  30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.15  30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.15  30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     0.1   30000  10.00  .5   <     .   .      .      .      .     .
i17  .     1.0   30000  10.00  .5   6000  .   .      .      .      .     .

</CsScore>
</CsoundSynthesizer>
