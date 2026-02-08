<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from COMPRESS.ORC and COMPRESS.SCO
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2


gasig 	init 	0

; PLUCK
		instr 1

ifqc 	=      	cpspch(p5)
kamp 	linseg 	0, .01, p4, p3-.02, p4, .01, 0

asig  	oscil 	kamp, ifqc, 1
gasig 	=     	gasig + asig

		endin

; PLUCK
		instr 2

ifqc 	=      	cpspch(p5)
kamp 	linseg 	0, .01, p4, p3-.02, p4, .01, 0

asin1 	pluck 	kamp, ifqc, ifqc, p6, p7
asig1 	butterhp 	asin1, 10
asig  	butterlp 	asig1, 5000
;  		out   	asig
gasig 	=     	gasig + asig

		endin

; COMPRESSOR
		instr 3

kamp  	rms 		gasig, p4

kampn 	=      	kamp/40000
kcomp 	tablei 	kampn,p5,1,.5
acomp 	=      	kcomp*gasig

        	outs    	p6*acomp, p6*acomp
gasig 	=       	0

		endin

; NOISE GATE
		instr 4

kamp  	rms 		gasig, p4

kampn 	=      	kamp/40000
kcomp 	tablei 	kampn,p5,1,.5
acomp 	=      	kcomp*gasig

        	outs    	p6*acomp, p6*acomp
gasig 	=       	0

		endin

; RING MODULATOR
		instr 5
       	outs 	gasig*gasig/2000000, gasig*gasig/2000000
		endin

</CsInstruments>
<CsScore>
; AN ATTEMPT AT EMULATING TUBE DISTORTION.

; SINE WAVE
f1 0 8192 10 1
; TRIANGLE WAVE
f2 0 8192 7  -1  256 1 256 -1 512 0 7168 0
; EXP WAVE
f3 0 8192 7  .001  4096 1 4096 .001

; COMPRESSION CURVE
f5 0 1025 7 1 512 1 513 .5

; COMPRESSOR
;  Sta Dur  Frqc  Table  PostGain
;i3 0   1.6  10    5      1

; RING MODULATOR
;  Sta Dur
i5 0   1.6

;i1 0   .5  20000 8.00

; PLUCK USE FUNC 2 FOR DISTORTION
;   Sta  Dur  Amp    Fqc   Func  Meth
i2  0.0  1.6  30000  7.00   0     1
i2  0.2  1.4  24000  7.05   .     .
i2  0.4  1.2  11000  8.00   .     .
i2  0.6  1.0  20000  8.05   .     .
i2  0.8  0.8  30000  7.00   .     .
i2  1.0  0.6  24000  7.05   .     .
i2  1.2  0.4  11000  8.00   .     .
i2  1.4  0.2  20000  8.05   .     .

</CsScore>
</CsoundSynthesizer>
