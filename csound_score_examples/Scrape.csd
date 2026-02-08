<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Scrape.orc and Scrape.sco
; Original files preserved in same directory

sr		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	= 		1

;************************************** orchestra ; Scrape.orc
; Damian Keller. June 1997.
; Scraping floors. Gaussian noise is shaped by a sine function.


		instr 1
kamp 	= 		p4					; OVERALL AMPLITUDE.
idur 	= 		p3					; DURATION
; CONTROL
kramp	linseg 	1, idur, 0			; INTENSITY.
krate	linseg	2, idur, .2			; RATE OF SCRAPING

; SOURCE: GAUSSIAN NOISE.
a1		gauss_a kramp

; WINDOWED WITH SINE.
a2		oscili	1, krate, 1
a3		= 		a1 * a2 * kamp
    		out 		a3
		endin

</CsInstruments>
<CsScore>
;************************************** score *****************************************
; Scrape.sco

; sine weights control spectral regions.
f1 0 513 10 1

;       st  dur     amp
i1      0   10      30000

</CsScore>
</CsoundSynthesizer>
