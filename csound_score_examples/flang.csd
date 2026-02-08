<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from flang.orc and flang.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


		instr 1
ims		=		4
idur	=		1/p4
a1		oscil	20000, idur, 1
k1		line	1, p3, 32
a2		oscil	ims, k1/p3, 2
a3		vdelay	a1, a2, ims
a4		vdelay	a3, a2, ims
a5		vdelay	a4, a2, ims
a6		vdelay	a5, a2, ims
		out		(a1+a3+a4+a5+a6)/2
		endin

		instr 2
ims		=		7
a1		rand	20000
k1		line	.1, p3, 16
a2		oscil	ims, k1/p3, 2
a3		vdelay	a1, a2, ims
a4		vdelay	a3, a2, ims
a5		vdelay	a4, a2, ims
a6		vdelay	a5, a2, ims
		out		(a1+a3+a4+a5+a6)/2
		endin

</CsInstruments>
<CsScore>
f1 0 65536 1 "noisloop.aif" 0.01 1 1
f2 0 1024 -8 .1 512 .9 512 .1

f0 1
f0 3
f0 5
f0 7
f0 9
f0 11
f0 13
f0 15
f0 17
f0 19

i2 0 20
i1 21 6 2
e

</CsScore>
</CsoundSynthesizer>
