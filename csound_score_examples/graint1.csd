<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from graint1.orc and graint1.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
kamp		line		0, p3, 20000
agr		grain	kamp, 0, 1000, 0, 10, .005, 1, 2, 2
out		agr
		endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6

i1 0 3

</CsScore>
</CsoundSynthesizer>
