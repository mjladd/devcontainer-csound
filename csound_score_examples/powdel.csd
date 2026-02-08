<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from powdel.orc and powdel.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
is 		= 		p4
ak1		linseg	0, p3/is, 1, p3/is, 0
ak2		pow		ak1, 2
a1		oscil	20000, 1000, 1
a2		vdelay	a1, ak2, 1.1
		out		a2
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1

i1 0 2 .5

</CsScore>
</CsoundSynthesizer>
