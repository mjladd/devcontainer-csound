<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FracAddress.orc and FracAddress.sco
; Original files preserved in same directory

sr		= 		44100
kr		= 		4410
ksmps	= 		10
nchnls	= 		1

;*************************************** orchestra *************************************
; FracAddress.orc
; Damian Keller. May 1997.
; Synthesis by fractional addressing.
; Reference: Hartmann, W.R. (1987) ÒDigital waveform generation by fractional
; addressingÓ. J. of Acoust. Soc. of America, 82(6), 1883-1891.
;***************************************************************************************


		instr 1

ipitch	=    	cpspch(p5)			; PITCH.
iamp 	= 		p4					; AMPLITUDE.
idur 	= 		p3					; DURATION.

; ADD IS AN OFFSET ON THE POINTER TO THE ADDRESSES IN ft1.
; SMALL AMOUNT OF NOISE WILL INTRODUCE CORRELATED NOISE.
; MOVING OFFSETS WILL GENERATE MOVING SPECTRA.

aline	line 	.5, idur, .001			; aline: FROM 0 TO .5 CONTROLS AMPLITUDE,
aindex	oscili	aline, ipitch, 1		; aindex CONTROLS FREQUENCY.
add		line 	.5, idur, .001
; ADD RAND		.01
asig		tablei	(add + aindex), 1, 1
		out		asig * iamp
		endin

</CsInstruments>
<CsScore>
;************************************** score *****************************************
; FracAddress.sco

f1	0 512 10 1			; SINE TABLE

;  time dur	amp	 	pitch
i1	0	5	10000	5.00
i1	5	5	8000	6.05
i1	10	10	5000	8.00

</CsScore>
</CsoundSynthesizer>
