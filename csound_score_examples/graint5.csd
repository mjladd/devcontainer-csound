<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint5.orc and graint5.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
kdens	line		1, p3, 2000
agr		grain	5000, 0, 1000, 0, kdens, .005, 1, 2, 2
		out		agr
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6

i1 0 3

</CsScore>
</CsoundSynthesizer>
