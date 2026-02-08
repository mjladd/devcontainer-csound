<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pow.orc and pow.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
iamp 	pow		10, 2
a1		oscil	iamp, 100, 2
a2		pow		a1, 2, 1
		out 		a2
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 7 0 512 1 512 0

i1 0 1

</CsScore>
</CsoundSynthesizer>
