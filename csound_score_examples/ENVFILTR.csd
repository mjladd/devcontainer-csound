<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from ENVFILTR.ORC and ENVFILTR.SCO
; Original files preserved in same directory

sr 		= 		44100
kr  		=  		4410
ksmps 	=		10
nchnls 	= 		2

; ************************************************************************
; RESONANT LOW-PASS FILTER
;*************************************************************************


;******************************************************************
		instr 1

idur  	=      	p3
iamp  	=      	p4
kstep 	init   	0

loop1:
       	timout 	0, p5, cont1
kstep 	= 		frac((kstep + 1)/8)*8
reinit 	loop1

cont1:

kpch1 	table  	kstep, 20
kfqc  	=      	cpspch(kpch1)
axn   	oscil  	iamp, kfqc, 10
  		outs 	axn, axn

		endin


		instr 15   ; TABLE BASED REZZY SYNTH WITH ENVELOPED RESONANCE

idur     	=    	p3
iamp     	=    	p4
ifqc     	=    	cpspch(p5)
irez     	=    	p7
itabl1   	=    	p8
kvalley  	init 	0
kpeak    	init 	0
knewval  	init 	1
knewpk   	init 	1
ksaveval 	init 	0
ksavepk  	init 	0

; INITIALIZE YN-1 & YN-2 TO ZERO
kynm1      init 	0
kynm2      init 	0
ktynm1     init 	0
ktynm2     init 	0
kfrangenm1 init 	0
kfrangenm2 init 	0
knewrez    init 	0
kfsweep    init 	30
kstep      init 	0
knxtstp    init 	1

; FREQUENCY SWEEP
kfsweep 	expseg 	30, .5*p3, p6, .5*p3, 30

; SEQUENCER SECTION

loop1:

kdur  	table  	kstep, 21
kdur1  	=     	kdur/8

;     FREQUENCY ENVELOPE
;kfco 	 expseg 	 20, .1, i(kfsweep), p5-.1, 20
kfco 	expseg 	20, .1, i(kfsweep), i(kdur1)-.1, 20

;     AMPLITUDE ENVELOPE
;kaenv  	 linseg 	 0, .01, 1, p5-.02, 1, .01, 0
kaenv  	linseg 	0, .01, 1, i(kdur1)-.02, 1, .01, 0

;     PANNING
kpanleft  table 	kstep, 22
kpanright table 	kstep, 23
kpch1 	table  	kstep, 20
kfqc1 	=      	cpspch(kpch1)
kpch2 	table  	knxtstp, 20
kfqc2 	=      	cpspch(kpch2)
if 		(p9 = 0) 	goto skipslide
kfqc  	linseg 	i(kfqc1), i(kdur1)-.04, i(kfqc1), .04, i(kfqc2)
goto 	nxtslide

skipslide:
kfqc  	= 		kfqc1

nxtslide:

;		 timout 	 0, p5, cont1
		timout 	0, i(kdur1), cont1
kstep   	= 		frac((kstep + 1)/8)*8
knxtstp 	= 		frac((kstep + 1)/8)*8

reinit 	loop1
cont1:

; THIS RELATIONSHIP ATTEMPTS TO SEPARATE FREQ FROM RES.
ka1    	= 		100/irez/sqrt(kfco)-1
kta1   	= 		100/sqrt(kfco)-1
ka2    	= 		1000/kfco


; OSCILLATOR
kxn 		oscil 	iamp, kfqc, itabl1
;kxn2 	 oscil 	 1, kfqc/2, 2

;kxn  	 =     	 kxn1*kxn2;+iamp*kxn2/2


; REPLACE THE DIFFERENTIAL EQ. WITH A DIFFERENCE EQ.
kyn 		= 		((ka1+2*ka2)*kynm1-ka2*kynm2+kxn)/(1+ka1+ka2)
ktyn 	= 		((kta1+2*ka2)*ktynm1-ka2*ktynm2+kxn)/(1+kta1+ka2)

; THIS SECTION DETERMINES CURRENT PEAK AND VALLEY VALUES AND THE RANGE.
; AS LONG AS THE SIGNAL RISES IT UPDATES PEAK.  WHEN IF FALLS IT UPDATES VALLEY.

koldrez 	= 		knewrez
knewrez 	= 		kyn-ktyn

if 		(koldrez>=knewrez) goto next1
if 		(knewval != 1) goto next2
knewval 	= 		0
knewpk  	= 		1
kvalley 	= 		ksaveval
next2:
ksavepk 	= 		knewrez

next1:
if 		(koldrez<=knewrez) goto next 3
if 		(knewpk != 1) goto next4
knewpk  	= 		0
knewval 	= 		1
kpeak   	= 		ksavepk
next4:
ksaveval 	= 		knewrez

next3:
; THE CURRENT RANGE IS CALCULATED AND LOW PASS FILTERED.

krangen 	= 		abs(kpeak-kvalley)

kfrangen 	= 		((kta1+2*ka2)*kfrangenm1-ka2*kfrangenm2+krangen)/(1+kta1+ka2)

; THE FILTERED RANGE IS USED TO ENVELOPE THE RESONANCE THEN DISTORTION IS ADDED.
kclip1 	= 		knewrez*kfrangen/irez/120000000
kclip 	tablei 	kclip1, 7, 1, .5
kout 	= 		ktyn + kclip*40000

;kout 	 = 		 ktyn+knewrez*kfrangen/irez/100

; UPDATE EVERYTHING FOR THE NEXT PASS.
kynm2 	= 		kynm1
kynm1 	= 		kyn
ktynm2 	= 		ktynm1
ktynm1 	= 		ktyn
kfrangenm2 = 		kfrangenm1
kfrangenm1 = 		kfrangen

aout 	= 		kout
;  axn  = kxn
;  axn2  = kxn2

; AMP ENVELOPE AND OUTPUT

		outs 	kaenv*kpanleft*aout, kaenv*kpanright*aout

;  		outs kaenv*axn, kaenv*axn2*10000

		endin


</CsInstruments>
<CsScore>
; Instrument in the style of the TB303 with built in sequencer.

;f1  0  1024  10   1
;f2  0  1024   7  -1 512 -1   0  1 512  1
;f3  0   256   7   1 256 -1
;f4  0   256   7  -1 128  1 128 -1
;f5  0   256   7   1  64  1   0 -1  192 -1
;f6  0   256   7  -1 256  1
;f8  0   256   5  1  256  .01
;f9  0   256   7  1  128  -.2  0  -1  128  .2
f10 0  1024   8  1  256 .2  128 0 256 -.2 256  -1

; Distortion Table
;----------------------------------------------------------------------
f7 0 1024   8 -.8 42 -.78  200 -.74 200 -.7 140 .7  200 .74 200 .78 42 .8

; 8 Step Sequencer
;----------------------------------------------------------------------
; Step         1     2     3     4     5     6     7     8
; Pitch Table
f20  0   8  -2  7.00  7.00  7.00  7.00  7.05  7.00  7.00  7.00
f20  3   8  -2  7.00  8.00  7.00  8.00  7.05  8.00  7.05  8.00

; Dur Table
f21  0  8  -2  1     1     1     1     1     1     1     1

; Panning Amplitude Table  22=Left 23=Right
f22  0  8  -2  1     0     1     1     1     0     1     1
f23  0  8  -2  0     1     1     0     1     1     1     0

; Score
;----------------------------------------------------------------------
; Enveloped Distortion Filter
;        Dur  Amp     Dur   Fco   Res  Wave  Slide
i15  0   6   4000    .125   2000  50   10    1

</CsScore>
</CsoundSynthesizer>
