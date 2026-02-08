<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from websynth5.orc and websynth5.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10

gisine	=		1
gitri	=		2
gisaw	=		3
gisquare 	=		4
gipulse	=		5

		instr 99
a1		=		0
a2		=		0
a3		=		0
a4		=		0
a5		=		0
a6		=		0
a7		=		0
		endin

		instr 1
k1		randh		1.0, 0.776266812952235, 0.9458
k1		=		183.2048+((518.9897-183.2048)*((k1+1.)/2.))
a1		oscil	1.0,k1,gitri
a2		oscil 	1.0,280.254603698849678,gisquare
a3		oscil	1. * (1+a2),938.620902188122272,gisquare
a4		oscil 	1.0,280.254603698849678,gisquare
a5		oscil 	1.0 * (1+a4),938.620902188122272,gisquare
a6		oscil 	1.0,15.149003965221345,gisine
a7		=		a6 * (a1+a3+a5)*.2
		out		a7*30000.00
		endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1 ; sine
f2 0 8192 10 1 0 .111 0 .04 0 .02 0 ; triangle
f3 0 8192 10 1 .5 .333 .25 .2 .166 .142 .125 ; saw
f4 0 8192 10 1 0 .333 0 .2 0 .142 0 .111; square
f5 0 8192 10 1 1 1 1 1 1 1 1 1 1 1 1 1; pulse

i1 0 10.0000

</CsScore>
</CsoundSynthesizer>
