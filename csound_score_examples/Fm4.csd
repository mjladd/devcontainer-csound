<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Fm4.orc and Fm4.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; ======================================================================== ;
;        Complex fm: 2 modulators modulating a single carrier              ;
; ======================================================================== ;
;      p4  = amplitude of output wave
;      p5  = carrier frequency specified in Hz
;      p6  = modulating frequency for mod #1 specified in Hz
;      p7  = modulating frequency for mod #2 specified in Hz
;      p8  = carrier envelope function
;      p9  = modulator #1 envelope function
;      p10 = modulator #2 envelope function
;      p11 = modulation index 1 for modulator 1 - the minimum modulation
;      p12 = modulation index 2 for modulator 1 - the peak modulation
;      p13 = modulation index 1 for modulator 2 - the minimum modulation
;      p14 = modulation index 2 for modulator 2 - the peak modulation
; ========================================================================;
		instr 1
i1 		= 		1/p3					; ONE CYCLE OF FUNCTION PER NOTE DUR
i2 		= 		p11 * p6                 ; DEVIATION FOR INDEX 1 OF MOD 1
i3 		= 		(p12-p11) * p6          	; DEVIATION FOR INDEX 2 OF MOD 1
i4 		= 		p13 * p7                	; DEVIATION FOR INDEX 1 OF MOD 2
i5 		= 		(p14-p13) * p7         	; DEVIATION FOR INDEX 2 OF MOD 2
ampcar  	oscil   	p4, i1, p8            	; AMPLITUDE ENVELOPE FOR THE CARRIER
ampmod1 	oscil   	i3, i1, p9            	; AMPLITUDE ENVELOPE FOR MODULATOR1
ampmod2 	oscil   	i5, i1, p10           	; AMPLITUDE ENVELOPE FOR MODULATOR2
amod1   	oscili  	ampmod1 + i2, p6, 1   	; MODULATING OSCILLATOR 1
amod2   	oscili  	ampmod2 + i4, p7, 1   	; MODULATING OSCILLATOR 2
amod    	=       	amod1 + amod2
asig    	oscili  	ampcar, p5 + amod, 1  	; CARRIER OSCILLATOR
		out     	asig
		endin

</CsInstruments>
<CsScore>
        ; Sine Wave
f1 0 8192 10 1
        ; ADSR Trumpet Envelope  - fig 1.11
f2 0 513 7 0 85.33 1 85.33 .75 85.33 .65  170.66 .50  85.33 0
        ; AR Woodwind Envelope for Carrier - fig 1.12
f3 0 513 7 0 100 1 392 .9 20 0
        ; Gated Woodwind Envelope for Modulator - fig 1.13
f4 0 513 7 0 100 1 412 1
        ; Exponential decaying envelope for bell-like timbres.
f5 0 513 5 1 512 .001
        ; Modification of Exponential envelope for drumlike sounds
f6 0 513 5 .7 16 .8 48 1 64 .8 128 .2 256 .001
        ; Modulator envelope for wood-drum sounds
f7 0 513 7 0 12 1 52 0 460 0
;  st  dur  amp     Fc    Fm1  Fm2 Ceg M1eg M2eg M1ndx1 M1ndx2 M2ndx1 M2ndx2

i1 0   .6   10000   440   440  220   2   2   2     0      4     2      6
i. 1    6
i. 8   .6     .     220   440  880   3   5   5     2      6     0      6
i. 9    6
s
i1 0   .6   10000   110   880   55   3   6   6     0      8     2     12
i. 1    6
i. 8   .6     .     220   440  110   6   7   7     2     22     5     16
i. 9    6
e

</CsScore>
</CsoundSynthesizer>
