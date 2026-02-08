<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from xincode.orc and xincode.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
k1 		= 		100
a1 		= 		100
a2		grain	k1, a1, a1, 0, 0, .001, 1, 1, .01
		out 		a2
		endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1

i1 0 1

</CsScore>
</CsoundSynthesizer>
