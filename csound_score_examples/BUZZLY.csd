<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BUZZLY.ORC and BUZZLY.SCO
; Original files preserved in same directory

sr 		= 			44100
kr 		=			441
ksmps 	=			100
nchnls 	= 			1





		instr 1

;       LINEN   	AMP,   RISE, DUR, FALL
kfen1   linen   	1000, .5*p3, p3, .5*p3
kfen2	linen		2000, .5*p3, p3, .5*p3

;       BUZZ    	PITCH, AMP, #PARTIALS, FUNCTION
abuzz	buzz    	p5,    p4,  10,        1
ares1	reson   	abuzz, kfen1, 100
aton1	tone    	abuzz, kfen1
ares2	reson   	abuzz, kfen2, 200
aton2	tone    	abuzz, kfen2
afin	balance 	ares1+aton1+ares2+aton2, abuzz
		out			afin*1000
		endin

</CsInstruments>
<CsScore>
; score******************************************************************
f1  0 1024  10 1
;  istart idur ifq  ivol (1000-10000)
i1  0     2    220   20
i1  0     4    330   20
i1  4     2    280   10

e

</CsScore>
</CsoundSynthesizer>
