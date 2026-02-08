<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from oscilx.orc and oscilx.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


		instr 1
a1		oscilx	10000, 1000, 1, 10
		out		a1
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1

i1 0 1

</CsScore>
</CsoundSynthesizer>
