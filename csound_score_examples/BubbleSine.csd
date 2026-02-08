<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BubbleSine.orc and BubbleSine.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1

;*********************************** orchestra ****************************************
; BubbleSine.orc
; Damian Keller. June 1997.
; White noise controls phase through sine table. Bubble-like sound.
;**************************************************************************************

		instr 1
kamp 	= 		p4 					; AMPLITUDE
kfreq	= 		p5 					; TIME PERIOD: RATE.
krise	= 		.02					; FREQUENCY RANGE.

kdamp	linseg 	1, p3, 0

; INDEX.
aindex 	phasor 	kfreq * kdamp
aindex1	= 		aindex * ftlen(2)

; CONTROL.
a1		tablei 	aindex1, 2			; f 2 IS A WHITE NOISE TABLE.
a2		= 		a1 * (kamp * krise)

; SOUND.
a3		oscili	kamp, a2, 1			; a2: PHASE THROUGH SINE FUNCTION.

		out 		a3
		endin

</CsInstruments>
<CsScore>
;**************************************** score ****************************************
; BubbleSine.sco

f1 	0 513 10 1			; SINE
f2	0 513 21 1 1		; WHITE NOISE

i1	0 	5	30000	.5

</CsScore>
</CsoundSynthesizer>
