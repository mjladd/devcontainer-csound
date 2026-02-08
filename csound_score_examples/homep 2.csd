<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from homep 2.orc and homep 2.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	= 		1

							; TOOT1.ORC

		instr 1
kenv 	oscil	p4,	1 / p3 , 2				; p4    = MAX,                 p3 = NOTE DUR
kven 	oscil	p6,	1 / p3,	3				; p6    = MAX
kvib 	oscil  	kven, p7, 1					; p6    = VIB DEPTH,           p7 = VIB SPEED
kpen 	line		p8, p3, p9					; p8,p9 = START/STOP LINE lvl
a1 		oscil	kenv, p5 + kpen + kvib, 1		; p5    = NOTE FREQ
    		out    	a1
		endin

</CsInstruments>
<CsScore>
;p3 = notedur   p4 = noteamp   p5 = notefreq   p6 = vibamp   p7 = vibspeed
;p8,p9 = line levels

									;FUNCTIONS
f1 0 4096 10 1
f2 0 1024 7 0 124 1 500 .9 400 0
f3 0 1024 7 0 124 1 500 0 400 1

									;NOTE LIST
i1 0 6 10000 440 5000 10 0 -1000

e

</CsScore>
</CsoundSynthesizer>
