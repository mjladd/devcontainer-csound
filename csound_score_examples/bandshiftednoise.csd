<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from bandshiftednoise.orc and bandshiftednoise.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

		instr 3799
kenv		linseg	0, p3 * .5, 1, p3 * .5, 0 ; UP-DOWN RAMP ENVELOPE
kran 	randh 	50, kr				 ; PRODUCE VALUES BETWEEN -50 AND 50
kcent 	line 	1000, p3, 200			 ; RAMPCENTRE FREQENCY 1000 TO 200
kran 	=  		kran + kcent			 ; SHIFT RAND VALUES TO BASE FREQUENCY
asig 	oscil 	kenv * p4, kran, 1		 ; GENERATE A BAND OF NOISE
		out 		asig

		endin

</CsInstruments>
<CsScore>
f1      0 512 10 1				; A SINE WAVE

;       st      dur     amp

i3799    0      2       10000

</CsScore>
</CsoundSynthesizer>
