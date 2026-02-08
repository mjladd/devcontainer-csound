<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from river1.orc and river1.sco
; Original files preserved in same directory

sr 			= 		44100
kr 			= 		4410
ksmps 		= 		10
nchnls 		= 		1

;----------------------------------------------------------------------
; DOWN BY THE RIVER
; BY HANS MIKELSON
;----------------------------------------------------------------------


;P4 AMPS ARE HERE DOUBLED
; 			guitar
			instr 	1

ablock2 	init   	0
ablock3 	init   	0

kamp		linseg	0.0, 0.015, p4*2, p3-0.065, p4*2, 0.05, 0.0
ablk		pluck 	kamp, p5, p5, 0, 1

ablock2 	=      	ablk-ablock3+.99*ablock2    ;THIS IS A DC BLOCKING FILTER
ablock3 	=      	ablk                        ;USED TO PREVENT DRIFT AWAY FROM
asig    	=      	ablock2                     ;ZERO.

af1			reson	asig, 110, 80
af2			reson	asig, 220, 80
af3			reson	asig, 440, 80

abalnc		balance 0.8*af1+af2+0.4*af3+0.4*asig, asig

			out 	abalnc
			endin

; HAMMER/PULL
			instr 	2
kamp		linseg	0.0, 0.015, p4*2, p3-0.065, p4*2, 0.05, 0.0
kfreq		linseg	p5, p7*p3, p5, 0.005, p6, (1-p7)*p3-0.005, p6
asig		pluck 	kamp, kfreq, p5, 0, 1
af1			reson	asig, 110, 80
af2			reson	asig, 220, 100
af3			reson	asig, 440, 80
aout		balance 0.6*af1+af2+0.6*af3+0.4*asig, asig
			out 	aout
			endin

; HARMONICS
			instr 	3
kamp		linseg 	0.0, 0.015, p4*2, p3-0.035, p4*2, 0.02, 0.0
asig		pluck	kamp, p5, p5, 0, 6
			out 	asig
			endin


</CsInstruments>
<CsScore>
; DOWN BY THE RIVER
; BY HANS MIKELSON
;       Start       Dur         Volume      Pitch
i1      0           0.4         8000        61.735
i1      0.2         0.4         10000       246.94
i1      0.4         0.4         .           329.63
i1      0.6         0.4         .           103.83
i1      0.8         0.4         .           493.88
i1      1           0.4         .           329.63
i1      1.2         0.4         8000        61.735
i1      1.4         0.4         10000       123.47
i1      1.6         0.4         8000        61.735
i1      1.8         0.4         10000       246.94
i1      2           0.4         .           329.63
i1      2.2         0.4         .           103.83
i1      2.4         0.4         .           311.13
i1      2.6         0.4         .           246.94
i1      2.8         0.4         8000        61.735
i1      3           0.4         10000       329.63
i1      3.2         0.4         .           103.83
i1      3.4         0.4         .           311.13
i1      3.6         0.4         .           329.63
i1      3.8         0.4         .           103.83
i1      4           0.4         .           493.88
i1      4.2         0.4         .           369.99
i1      4.4         0.4         8000        61.735
i1      4.6         0.4         .           123.47
i1      4.8         0.4         .           61.735
i1      5           0.4         10000       415.3
i1      5.2         0.4         .           329.63
i1      5.4         0.4         8000        61.735
i1      5.6         0.4         .           123.47
i1      5.8         0.4         8000        61.735
i1      6           0.2         10000       246.94
i1      6.2         0.2         .           329.63

e

</CsScore>
</CsoundSynthesizer>
