<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from panster.orc and panster.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2


;JEAN-MICHEL DARREMONT
;   GBUZZST.ORC


;p4 = AMP TAB
;p5 = FREQ TAB
;p6 = NB HARMONICS
;p7 = LOWEST HARMONIC
;p8 = HARMONICS AMP RATE FACTOR TAB (1 => EQUAL RATE FOR ALL HARMONICS)
;f9 = COSINE TAB
;f3 = PAN TAB
;f10= REV TAB

          instr     1

itabamp   =         4
itabfreq  =         5
itabharmamprate =   8


kamp      oscil1i   0,p4,p3,itabamp
kfreq     oscil1i   0,p5,p3,itabfreq
knbharm   =         p6
klowharm  =         p7

kharmamprate oscil1i 0,p8,p3,itabharmamprate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kpan      oscil1i    0,1,p3,3 ;p3=dur, pantab=3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

idel      =         .005
kdclic    linseg     0, idel,1, p3-(100*idel),1,idel,0

asig      gbuzz     kamp, kfreq, knbharm, klowharm, kharmamprate, 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          outs      asig*kdclic*kpan, asig*kdclic*(1-kpan)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          endin

</CsInstruments>
<CsScore>
;JEAN-MICHEL DARREMONT
;;SCORE
;AMP
f 4 0 1024 7
10000 1024 10000

;FREQ
f 5 0 1024 7
115.0 51 105.5941 51 105.0 52 105.495 51 106.3861 51 107.4752 51 108.0693 51
109.1584 52 111.7327 51 113.2178 51 113.7129 51 113.8119 51 113.7129 52
109.8515 51 109.4554 51 109.4554 51 110.0495 51 112.3267 52 113.6139 51
114.604 51 115.0

;HARMONICS DECREASE RATE
f 8 0 1024 7
0 51 40 51 139 52 267 51 495 51 554 51 554 51 515 52 129 51 119 51 129 51 178
51 327 52 584 51 693 51 752 51 861 51 950 52 1000 51 941 51 0

;COSINUS WAVE
f 9 0 16385 11
1 1
;PAN TABLE
f 3 0 4096 7
1.0 205 0.9604 205 0.8614 204 0.7327 205 0.505 205 0.4455 205 0.4455 205
0.4851 204 0.8713 205 0.8812 205 0.8713 205 0.8218 205 0.6733 204 0.4158 205
0.3069 205 0.2475 205 0.1386 205 0.0495 204 0.0 205 0.0594 205 1.0

;p1 p2 p3 p4 p5 p6 p7 p8
i 1 0 10 3000 64 128 1 0.95
i 1 0 10 3000 64.032 128 1 0.95
i 1 0 10 3000 64.064 128 1 0.95
i 1 0 10 3000 64.096 128 1 0.95
i 1 0 10 3000 64.128 128 1 0.95
e

</CsScore>
</CsoundSynthesizer>
