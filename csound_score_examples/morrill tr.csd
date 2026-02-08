<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from morrill tr.orc and morrill tr.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


		instr 1

iamp		=		10000
ifc1		=		250
ifc2		=		1500
ifm		=		250
imax		=		2.66
iratio	=		1.8 / 2.66
iatt3	=		.03
iatt4	=		.03
iatt5	=		.03
idec3	=		.15
idec4	=		.01
idec5	=		.3
irandev	=		.007
ifr		=		125
ivibwth	=		.007
ivibrate	=		7
iportdev	=		.03
iatt1	=		.6
iatt2	=		.06
idec1	=		.2
idec2	=		.01


kec1		oscil	iamp,1 / p3,2
kec2		oscil	iamp * .2,1 / p3,2
kem		oscil	imax * ifm,1 / p3,4
kev		oscil	ivibwth,1 / p3,5
kpd		oscil	iportdev,1 / p3,6

ke1		linen	1,iatt1,p3,idec1
ke2		linen	1,iatt2,p3,idec2
ke3		linen	1,iatt3,p3,idec3
ke4		linen	1,iatt4,p3,idec4
ke5		linen	1,iatt5,p3,idec5

kpd		=		(kpd * ke2) + 1
kvib		oscil	ke1 * kev,ivibrate,1
kv		=		1

am		oscil	ke4 * kem,ifm * kv,1
ac1		oscil	ke3 * kec1,(ifc1 * kv) + am,1
ac2		oscil	ke5 * kec2,(ifc2 * kv) + (am * iratio),1

		out 		ac1 + ac2
		endin

</CsInstruments>
<CsScore>
f1	0	1024	10	1
f2	0	1024	7	.7	124	1	200	.7	700 .7
f3	0	1024	7	.7	124	1	200	.7	700 .7
f4	0	1024	7	.7	124	1	300	.5	150	.7	450 .7
f5	0	1024	7	1	1024	1
f6	0	1024	7	1	1024	1

i1 1 3
e

</CsScore>
</CsoundSynthesizer>
