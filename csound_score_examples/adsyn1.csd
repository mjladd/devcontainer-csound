<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from adsyn1.orc and adsyn1.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


		instr	1
idur		=		p3
iamp		=		p4
ispeed1	=		p5
ispeed2	=		p6
ifrq1	=		p7
ifrq2	=		p8
ifrq3	=		p9
ianal	=		p10
kspeed	line		ispeed1, idur, ispeed2
kfreq	linseg	ifrq1, idur*.5, ifrq2, idur*.5, ifrq3
asig		adsyn	1, kfreq, kspeed, ianal
		out		asig
		endin

</CsInstruments>
<CsScore>
i1 0  3   1  1  2    1  .5  4  1
i1 4  3   2  1  .5   1  2  .5  1
i1 8  3  .2  1  2    1  .5  4  1
i1 8  3  .2  1  .5   1  2  .5  1
i1 8  3  .2  2  .5   8  .5  1  1
i1 12 150 1 .05 .05  1   1  1  1

</CsScore>
</CsoundSynthesizer>
