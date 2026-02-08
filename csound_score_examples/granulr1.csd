<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from granulr1.orc and granulr1.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2


		instr 1
ifqc=p5
kdnsenv 	linseg	10, p3/2, 100, p3/2, 10
kdurenv 	linseg  	.04, p3/2, .4,  p3/2, .04
kampenv 	linseg  	0, .002, 1, p3-.004, 1, .002, 0

 krand1 	rand 	30
kdens 	= 		kdnsenv + krand1/3

;				XAMP  XPITCH  XDENS  KAMPOFF  KPITCHOFF  KGDUR	   IGFN  IWFN	IMGDUR
aoutl 	grain	p4,	 ifqc,  kdens,	 200,	210,	   kdurenv,	p6,	 2,	   1
aoutr 	grain	p4,	 ifqc,  kdens,	 200,	190,	   kdurenv,	p6,	 2,	   1
		outs 	aoutl*kampenv, aoutr*kampenv
		endin

</CsInstruments>
<CsScore>
f1 0 8192 10 1
f2 0 8192 20 1
f3 0 8192  7 1 8192 -1

;  Start  Dur  Amp   Pitch  Table
i1   0    8    3000  440    1
i1   0    8    2000  1100   1
i1   4    8    4000  220    3
i1   4    8    4000  1220   3
i1   8    8    4000  1260   3
i1   8    8    4000  60    1

</CsScore>
</CsoundSynthesizer>
