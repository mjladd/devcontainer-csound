<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from grainex.orc and grainex.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		1


instr 1
kamp		linseg	0, p3/2, 30000, p3/2, 0
agrain	grain	kamp, 0, 1000, 0, 10, .005, 1, 2, .005
		out		agrain
		endin

instr 2
kfreq	linseg	0, p3/2, 10000, p3/2, 0
agrain	grain	30000, 0, kfreq, 0, 100, .005, 1, 2, .005
		out		agrain
		endin

instr 3
kpoff	linseg	0, p3/2, 2000, p3/2, 0
agrain	grain	30000, 0, 1000, kpoff, 5, .05, 1, 2, .005
		out		agrain
		endin

instr 4
kdns		line		0, p3, 2000
agrain	grain	3000, 0, 1000, 0, kdns, .05, 1, 2, .005
		out		agrain
		endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 20 6
f3 0 32768 1 1 .01 1 1

i1 0 2
e
i2 0 2
s
i3 0 2
s
i4 0 2
e

</CsScore>
</CsoundSynthesizer>
