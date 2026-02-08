<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint11.orc and graint11.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	= 		1


		instr 1
ktri		oscil	10000, 1/p3, 3
a1		grain	ktri, 1000, 1000, 100, 100, .1, 1, 2, 1
a2		grain	ktri, 1000,  600 , 50,  80, .1, 1, 2, 1
a3		grain	ktri, 1000,  200 , 10, 130, .1, 1, 2, 1
a4		line		0, p3, 1
a5		pow		a4, 2
a6		vdelay	(a1+a2+a3), a5, 1.1
a7		reverb	a6, 1.5
		out		(a6*(a5-.1) + a7*(.9-a5-.1)/4)
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6
f3 0 1024 20 3

i1 0 5
e

</CsScore>
</CsoundSynthesizer>
