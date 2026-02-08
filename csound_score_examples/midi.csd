<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from midi.orc and midi.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


		instr 1
icps		cpsmidi
kvol		midictrl	1, 0, 32000

a1		oscil	kvol, icps, 1
;a1		tone		a1, 4000
out		a1
		endin

</CsInstruments>
<CsScore>
f0 20
f1 0 1024 7 0 24 1 1000 -1
;f1 0 1024 10 1
;f1 0 32768 1 2 0 4 0
e

</CsScore>
</CsoundSynthesizer>
