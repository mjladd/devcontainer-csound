<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from gra.orc and gra.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


			instr 1

kgl1		oscil	cpspch(p4),1/p3,2
kv			randh	1,	10

a			fof		20000,kgl1+kv,650,1,40,.003,.01,.007,4,1,1,p3

			out 	a/2
			endin

</CsInstruments>
<CsScore>
f1	0	1024	10	1
f2	0	1024	8	.01	256	.3	256	1	356	1	156	.01

i1	0	10	7.11
i1	.	.	7.07
i1	.	.	7.04
i1	.	.	7.00
e

</CsScore>
</CsoundSynthesizer>
