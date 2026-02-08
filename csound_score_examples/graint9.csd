<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint9.orc and graint9.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
kamp		line		0, p3, 20000
agr		grain	30000, 0, 100, 500, 10, .05, 1, 2, 1
out		agr
		endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6

i1 0 3

</CsScore>
</CsoundSynthesizer>
