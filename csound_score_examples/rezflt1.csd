<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from rezflt1.orc and rezflt1.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		44100
ksmps 	=		1
nchnls 	= 		1

;****************************************************************
; RESONANT LOW-PASS FILTER
; CODED: HANS MIKELSON 2/7/97
;****************************************************************



instr 	1 				; REZZY SYNTH BASED ON DIFF EQS

idur 	= 		p3
kamp 	linseg 	0, .01*p3, p4, .98*p3, p4, .01*p3, 0
ifqc 	= 		cpspch(p5)
ires 	= 		p7/1000

kfco 	linseg 	.1*p6, p3, p6
kres 	= 		ires

; THE DIFFERENCE EQUATION COEFFICIENTS
kb 		= 		1/kfco/kres
kk 		= 		10000/kfco

aynm1 	init 	0
aynm2 	init 	0

axn 		oscil 	kamp, ifqc, 3

; THE DIFFERENCE EQUATION: YN=((B+2K)YN-1 - KYN-2 + XN)/(1+B+K)

ayn		=		((kb+2*kk)*aynm1-kk*aynm2+axn)/(1+kb+kk)
aynm2 	= 		aynm1
aynm1 	= 		ayn

out 		ayn
endin

</CsInstruments>
<CsScore>
; ********************************************************* ; REZZY SAWTOOTH SYNTH
; CODED: HANS MIKELSON 2/7/97
;********************************************************** ; SAWTOOTH

f3   0    256  7    1    256  -1

; SCORE ***************************************************

t    0    300

;    IDUR      IAMP      IPCH      FILTER    CUT-OFF   RESONANCE
i1   0         2         6000      7.00      1000      5
i1   +         1         6000      7.03      1000      10
i1   .         .         6000      7.05      800       15
i1   .         .         6000      7.02      1000      20
i1   .         .         6000      8.00      1200      25
i1   .         .         6000      7.03      1000      30
i1   .         .         6000      7.05      500       60
i1   .         2         6000      7.00      1000      5
i1   .         1         6000      7.03      1000      10
i1   .         .         6000      7.05      800       15
i1   .         .         6000      7.02      1000      20
i1   .         .         6000      8.00      1200      25
i1   .         .         6000      7.03      1000      30
i1   .         .         6000      7.05      500       60
i1   0         8         6000      5.00      200       30
i1   +         .         6000      4.10      200       30
i1   .         .         6000      5.00      1000      100

e

</CsScore>
</CsoundSynthesizer>
