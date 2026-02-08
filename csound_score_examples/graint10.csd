<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint10.orc and graint10.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
iflen 	= 		1.3113
agr		grain	2000, 30000, 1/iflen, 2/iflen, 40, .1, 1, 2, 1
		out 		agr
		endin

</CsInstruments>
<CsScore>
f1 0 32768 1 5 0 1 1
;f1 0 0 1 4 0 1 1
f2 0 1024 20 6

i1 0 3
e

</CsScore>
</CsoundSynthesizer>
