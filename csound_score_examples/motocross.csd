<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from motocross.orc and motocross.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2

;HANS MIKELSON
;------------------------------------------------------------------
; ORCHESTRA
;------------------------------------------------------------------
; INDUSTRIAL LOOPS
;------------------------------------------------------------------
        	instr      4
idur    	=          p3
iamp    	=          p4*2
ifqc    	=          cpspch(p5)
iplstab 	=          p6
irattab 	=          p7
iratrat 	=          p8
ipantab 	=          p9
imixtab 	=          p10
ilptab  	=          p11
kpan    	oscil      1, 1/idur, ipantab             	; PANNING
kmix    	oscil      1, 1/idur, imixtab             	; FADING
kloop   	oscil      1, 1/idur, ilptab              	; LOOPING
;kfc    	 expseg     .1, idur/2, 4, idur/2, .1     	; FQC CENTER
loop1:
kprate  	oscil      1, iratrat/kloop, irattab      	; PULSE RATE
kamp    	oscil      iamp, kprate, iplstab          	; AMPLITUDE PULSE
asig    	rand       kamp                           	; NOISE SOURCE
;aflt   	 butterbp   asig, ifqc*kfc, ifqc*kfc/4     	; BAND FILTER
aflt    	butterbp   asig, ifqc, ifqc/4             	; BAND FILTER
aout    	balance    aflt, asig                     	; BRING LEVEL BACK UP
											; WHEN THE TIME RUNS OUT REINITIALIZE
        	timout     0, i(kloop), cont1
        	reinit     loop1
cont1:
        	outs       aout*sqrt(kpan)*kmix, aout*sqrt(1-kpan)*kmix ; OUTPUT PAN & FADE
        	endin

</CsInstruments>
<CsScore>
; SCORE
f1 0 8192 10 1 ; SINE
; PULSE TABLES
f12 0 1024   7  0 512 1 512 0
; RATE TABLES
f25  0 1024  -5  5000 1024  100
; PAN TABLES
f31  0 1024  7  1  1024  0
; MIX TABLES
f41  0 1024  5  .01 128 1 768 1 128 .01
; LOOP TABLES
f50  0 1024 -5  .41 50 .021 206 .35 56 .012 200 .28 56 .016 200 .085 56 .02 200 .32
; GENERATE INDUSTRIAL LOOPS
;   STA  DUR  AMP   PITCH  PULSTAB  RTTAB  RTRT  PANTAB  MIXTAB  LOOP
i4  0    32   6000  8.00   12       25     1     31      41      50

</CsScore>
</CsoundSynthesizer>
