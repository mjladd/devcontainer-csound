<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from pw.orc and pw.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;copyright 1998 Paul M. Winkler, zarmzarm@erols.com
;****++++
;**** Last modified: Wed Dec	9 20:32:30 1998
;****----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	   instr 1
;SIMULATED PULSE WIDTH MODULATION

;THIS WORKS! BUT P5 SHOULD BE HANDLED BETTER.
ipitch 	= 		cpspch (p4)
aindex   	phasor    ipitch

; MAKE THE WIDTH (P5) 'FEEL' A LITTLE NICER -- AN EXPONENTIAL CURVE FROM
; FTLEN/2 TO FTLEN, CONTROLLED BY A LINEAR PERCENTAGE (0 TO 100).
; THIS IS NOT GREAT: P5 LESS THAN ABOUT 10 IS TOO SMALL!

ilength 	= 		ftlen(1)
inum 	= 		p5 * p5 * .0001 ; normalize it to 0 - 1

; POW WOULD BE A BETTER SOLUTION, BUT IT'S BROKEN IN MY CSOUND VERSION?

irange 	= 		( ilength + ( inum * ilength )) * .5
aindex	= 		aindex * irange
print irange
; DISPLAY	  AINDEX, .1
		aout	  table		  aindex, 1;  use f1
		out aout
		  endin

		  instr 2
; Same thing, only pulse width is controlled by an envelope.
ipitch = cpspch (p4)
aindex   phasor    ipitch
ilength = ftlen(1)
krange   expseg  ilength * .5, p3 * .5, ilength, p3 * .5, ilength * .5
aindex = aindex * krange
aout	  table		  aindex, 1;  table 1
out aout
		  endin

</CsInstruments>
<CsScore>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;COPYRIGHT 1998 PAUL M. WINKLER, ZARMZARM@EROLS.COM
;****++++
;**** LAST MODIFIED: WED DEC  9 20:34:05 1998
;****----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

f1 0  512  -7   30000 256 30000 0 -30000 256 -30000 ;square wave, !normalized

;  AT DUR PCH    WIDTH

t 0 180
i1 0  1   6.00   100
i. +  .5  6.02   100
i. .  .    .     50
i. .  .   6.03   50
i. .  .   6.00   10
i. .  .   6.01   10
i. .  .   6.10   10
i. .  .   7.10   20
i. .  .   7.08   .
i. .  .   7.07   40
i. .  .   6.07   .
i. .  .   5.07   60
i. .  .   4.07   .
i. .  .   5.07   80
i. .  .   4.07   .
i. .  .   5.07   100
i. .  .   4.07    >
i. .  2   5.07   30

s
t 0 120
i2 1 3   5.00
i2 + 3   5.11
i2 . 3   6.10
i2 . 3   7.09
i2 . 3   8.08
i2 . 3   9.07
i2 . 3   10.06
i2 . 3   11.05     ; QUITE BAD ALIASING THERE!

</CsScore>
</CsoundSynthesizer>
