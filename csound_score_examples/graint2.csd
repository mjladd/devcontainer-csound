<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint2.orc and graint2.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
agr		grain	2000, 20000, 1000, 0, 4, .05, 1, 2, 1s
		out		agr
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6

i1 0 3

</CsScore>
</CsoundSynthesizer>
