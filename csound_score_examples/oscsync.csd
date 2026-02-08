<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from oscsync.orc and oscsync.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2


;---------------------------------------------------------------
; VCO WITH SYNC
;---------------------------------------------------------------
		instr     11

idur		=	    	p3		  		; DURATION
iamp		=	    	p4		  		; AMPLITUDE
ifqc		=	    	cpspch(p5)	  	; FREQUENCY
ifqc2	=	    	ifqc*p6	  		; FREQUENCY OF PSEUDO SYNCHED OSCILLATOR WRT BASE FREQUENCY
ifco		=	    	p7*ifqc/500  		; FILTER CUT-OFF FREQUENCY BASED, HIGHER PITCHES GET A HIGHER CUT OFF

krez		init    	p8		  		; KREZ IS NOT CHANGING
kfco		expseg  	100+.01*ifco, .2*idur, ifco+100, .5*idur, ifco*.1+100, .3*idur, .001*ifco+100 	; FILTER ENVELOPE
kamp		linseg  	0, .01*idur, iamp, .2*idur, .8*iamp, .49*idur, .5*iamp, .2*idur, 0		  	; AMP ENVELOPE

asaw2	init    	0

apulse1	buzz    	1, ifqc, sr/2/ifqc, 1		; BAND-LIMITED IMPULSE TRAIN
apulse2	buzz    	1, ifqc2, sr/2/ifqc2, 1		; BAND-LIMITED IMPULSE TRAIN

asaw		integ   	apulse1					; INTEGRATE THE PULSE FOR A SQUARE WAVE

aamp1	oscili  	1, ifqc,  3				; TURN ON THE GATE IN SYNC WITH THE IMPULSES
aamp2	oscili  	1, ifqc2, 3

asaw2	=	   	(apulse1 + apulse2*aamp2*(1-aamp1))*(1.2-asaw2) + (1-ifqc/sr)*asaw2
asaw3	=	   	1-asaw2								; BASICALLY DON'T ADD TWO IMPULSES

aout		rezzy   	asaw3, kfco, krez

		outs    	aout*kamp, aout*kamp

		endin


</CsInstruments>
<CsScore>
f1 0 16384 10 1                          ; SINE
f3 0 1024  -7 1 12 1 0 0 1000 0 0 1 12 1 ; PULSE: WIDER PULSES MAKE SOFTER SYNCS.

; SYNTH WITH SYNC
;   STA  DUR  AMP   PITCH  SYNCFQC  FCO   REZ
i11 0    .5   20000 8.00   1.498   5000  20
i11 +    .    .     7.07   .        .     .
i11 .    .    .     8.05   .        .     .
i11 .    .    .     9.00   .        .     .


</CsScore>
</CsoundSynthesizer>
