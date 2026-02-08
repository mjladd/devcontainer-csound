<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from eflw.orc and eflw.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	=		1


		instr 1
k1		line		0, p3, 30000
a1		oscil	k1, 1/1.3113, 2
;a1		oscil	k1, 1000, 3
ak1		follow	a1, .02
ak1		tone		ak1, 10
a2		oscil	ak1, 1000, 3
		out		a2
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 32768 1 1 0 1 1
f3 0 1024 7 -.5 24 .5 1000 -.5

i1 0 2

</CsScore>
</CsoundSynthesizer>
