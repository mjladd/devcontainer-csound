<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from eq1.orc and eq1.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2

;----------------------------------------------------------------
; BIQUADRATIC EQUALIZER FILTER
; CODED BY HANS MIKELSON NOVEMBER 1998
;----------------------------------------------------------------

;----------------------------------------------------------------
; PARAMETRIC EQUALIZER OPCODE
;----------------------------------------------------------------
	   	instr 15

ifc	   	=	    	p4		    			; CENTER / SHELF
iq	   	=	    	p5		    			; QUALITY FACTOR SQRT(.5) IS MAXIMUM SLOPE WITH NO RESONANCE PEAK FOR SHELF
iv	   	=	    	ampdb(p6)	    			; GAIN/CUT IN dB
imode   	=	    	p7

kfc	   	linseg	ifc*2, p3, ifc/2

asig	   	rand  	5000				    	; RANDOM NUMBER SOURCE FOR TESTING

aout	   	pareq 	asig, kfc, iv, iq, imode
	   	outs  	aout, aout			; OUTPUT THE RESULTS

		endin

</CsInstruments>
<CsScore>
;   Sta  Dur  Fcenter  Q           Boost/Cut(dB)  Mode
i15 0    1    10000     .2          12             1
;i15 +    .    5000    .2          12             1
;i15 .    .    1000    .707       -12             2
;i15 .    .    5000    .1         -12             0


</CsScore>
</CsoundSynthesizer>
