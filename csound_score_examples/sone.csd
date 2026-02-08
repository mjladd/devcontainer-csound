<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from sone.orc and sone.sco
; Original files preserved in same directory

sr		=		44100
kr		=		441
ksmps	=		100
nchnls	=		2

;-------SONETEST.ORC---------------------------


		instr 1

ifq		=		cpspch(p4+4)
isones	=		p5
asones	expseg	.1, .1, isones, p3-.11, isones, .01, .1
ares1	pow		asones/ifq, 3, 1
ires2	pow		10, -12
adb		=		10 * ((log((ares1) / ires2)) /log(10))
ampenv	=		ampdb(adb)
amp		=		ampenv
asig	oscili	amp, ifq, 1

		outs	asig, asig

		endin

</CsInstruments>
<CsScore>
;------------sonetest.sco-------------------------------

f1 0 1024 10 1

;	sones --- !According to the equation these should sound equally loud!
i1 0 1 1.00 2.816
i1 1.5 1 2.00
i1 3 1 3.00
i1 4.5 1 4.00
i1 6 1 5.00
i1 7.5 1 6.00
i1 9 1 7.00
i1 10 1 8.00
e

</CsScore>
</CsoundSynthesizer>
