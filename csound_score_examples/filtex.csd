<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from filtex.orc and filtex.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10


		instr 1

a1		oscil	10000, 440, 1
;a1		rand		20000
keg		linseg	0, 1, 1100, 1, 0

a2		tone		a1, keg
a3		reson	a2, keg, 10

		out		a3/100

		endin

		instr 2

a1		oscil	10000, 440, 1
;a1		rand		20000
keg		linseg	0, 1, 1100, 1, 0, 1, 0

a2		butterlp	a1, keg
a3		butterbp	a2, keg, 10

		out		a3*5

		endin

</CsInstruments>
<CsScore>
f1 0 1024 7 -1 24 1 1000 -1

i1 0 3
i2 4 3

</CsScore>
</CsoundSynthesizer>
