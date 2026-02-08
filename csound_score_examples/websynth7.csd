<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from websynth7.orc and websynth7.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10

gisine	=		1
gitri	=		2
gisaw	=		3
gisquare	=		4
gipulse	=		5

		instr 99
a1		=		0
a2 		=		0
a3		=		0
a4		=		0
k1		=		0
a5		=		0
a5		=		0
		endin

		instr 1
a1		oscil 	1.0,1202.872447283007205,gisine
a2		oscil	1.0,1143.00822414457798,gisquare
a3		oscil 	1.0 * (1+a2),99.405863471329212,gisquare
a4		oscil	1.0,1457.696915492415428,gisine
k1		oscil	1.0,0.009067947392818,gisaw
k1		=		246.3645+((3062.5840-246.3645)*((k1+1.)/2.))
a5		reson	a1*a3*a4, k1, k1*0.695172764733434, 1
a5		balance	a5,a1*a3*a4
a5		=		a5*.2
a5		reson	a5, k1, k1*0.192145924177021, 1
a5		balance	a5,a5
a5		=		a5*.2
		out		a5*30000.00
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
