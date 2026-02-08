<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from slidflut.orc and slidflut.sco
; Original files preserved in same directory

sr             =              44100
kr             =              44100
ksmps          =              1
nchnls         =              1

;*********************************************
; PHYSICAL MODELS   *
; CODED:  1/22/97 HANS MIKELSON    *
;*********************************************


;PERRY COOK'S SLIDE FLUTE

instr          2
aflute1        init           0

; FLOW SETUP

kenv1          linseg         0, .05, 1.1*p4, .1, .98*p4, p3-.15, .95*p4
kenv2          linseg         1, p3-.01, 1, .01, 0
aflow1         rand           kenv1
aflow1         =              aflow1/p4
asum1          =              aflow1*.0356 + kenv1/p4*1
asum2          =              asum1 + aflute1*.4

; EMBOUCHURE

ax             delayr         1/p5/4
delayw         asum2
apoly          =              ax - ax*ax*ax
asum3          =              apoly + aflute1*.4

avalue         tone           asum3, 8*p5

; BORE

aflute1        delayr         1/p5/2
delayw         avalue

out            avalue*p4*kenv2
endin

</CsInstruments>
<CsScore>
;    START     DUR  AMPLITUDE      PITCH
i2 	0		.4 		16000		220
i2 	.4		.2 		12000		258.3
i2 	.6		. 		13000		289.5
i2 	.8		. 		14000		328.9
i2 	1		. 		15000		440
i2 	1.2		. 		16000		289.5
i2 	1.4		. 		14000		328.9
i2 	1.6		.4 		16000		258.3
i2 	2		.2 		17000		516.6
i2 	2.2		. 		15000		440
i2 	2.4		. 		17000		386.4
i2 	2.6		. 		15000		440
i2 	2.8		. 		14000		289.5
i2 	3.		.4 		17000		328.9

</CsScore>
</CsoundSynthesizer>
