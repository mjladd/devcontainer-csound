<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Risset.orc and Risset.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10

; Eight Instruments
; from
; Jean-Claude Risset's
; Introductory Catalog of Computer Synthesized Sounds

; Translated from MusicV by:
; David Helm, NYU & Joseph DiMeo, Brooklyn College

; These instruments are diagramed and explained in
; Charles Dodge's "Computer Music" text.

; Additional Coding by Curtis Bahn, Brooklyn College

; Additional Coding by Russell Pinkston, University of Texas - Austin

; Selected from the
; Csound Anthology of Instruments, Orchestras, and Scores
; compiled and edited by Dr. Richard Boulanger
; Associate Professor
; Music Synthesis Department
; Berklee College of Music
; Boston, MA 02215


; RISSET'S FLUTE-LIKE
; #100
; CODED BY THOMAS DIMEO - BROOKLYN COLLEGE

		instr 1
		if		p12 = 12 igoto dc1
i1		=		.6
		goto	 start
dc1:
i1		=		.74
		goto		start
start:
k1	  	randi  	(p4*.01),p9
k1	   	=		k1 + p4
k2	   	oscil	k1,1/p11,p12
k2	   	=		k2 + i1
k3	   	oscil	k2,1/p6,p9
a1	   	oscili 	k3,p5,p10
		out		a1*10
		endin

		instr 2
k1	   	oscil	p4,1/p6,p7
k2	   	oscil	p5,1/p6,p8
a1	   	oscili 	k1,k2,1
		out		a1*10
		endin

; RISSET'S WAVESHAPING CLARINET
; CODED BY THOMAS DIMEO - BROOKLYN COLLEGE

		instr 3
i1	   	=		cpspch(p4)
i2	   	=		.64
		if		p3 >.75 igoto start
i2		=		p3 - .085
start:
a1	  	linen	255,.085,p3,i2
a1		oscili	a1,i1,1
a1		tablei	a1+256,2
		out	 	a1*p5
		endin

; ANOTHER OF RISSET'S WAVESHAPING INSTRUMENTS
; CODED BY THOMAS DIMEO - BROOKLYN COLLEGE

		instr 4
i1		=		1/p3
i2	   	=		cpspch(p4)
a1	   	oscili	p5,i1,2			    	; SCALING FACTOR CODE
a2	   	oscili	a1,i2,1
a3	   	linseg	1,.04,0,p3-.04,0
a4	   	oscili	a3,i2*.7071,1	    		; AUDIO CODE
									; INLINE CODE FOR TRANSFER FUNCTION:
; f(x)=1+.841x-.707x**2-.595x**3+.5x**4+.42x**5-.354x**6-.279x**7+.25x**8+.21x**9
a5	   	=		a4*a4
a6	   	=		a5*a4
a7	   	=		a5*a5
a8	   	=		a7*a4
a9	   	=		a6*a6
a10	   	=		a9*a4
a11	   	=		a10*a4
a12	   	=		a11*a4
a13	   	=		1+.841*a4-.707*a5-.595*a6+.5*a7+.42*a8-.354*a9-.297*a10+.25*a11+.21*a12
a14	   	=		a13*a2
		out	  	a14
		endin

; RISSET'S RING-MODULATION INSTRUMENT
; CODED BY THOMAS DIMEO - BROOKLYN COLLEGE

		instr 5
a1	  	expseg	.001,p7,1,p3-p7,.001
a1	   	oscili	 a1,p4,1
a2	   	oscili	 p5,p6,2
		out	   	a1*a2
		endin

; RISSET'S ADDITIVE BELL INSTRUMENT
; CODED BY CURTIS BAHN - BROOKLYN COLLEGE

instr 6
i1	   	=		p5					; p3 = DURATION
i2	   	=		p5*0.67	  			; p4 = FREQ IN Hz
i3		=		p5*1.35	    			; p5 = AMPLITUDE
i4	   	=		p5*1.80
i5	   	=		p5*2.67
i6	   	=		p5*1.67
i7	   	=		p5*1.46
i8	   	=		p5*1.33	    			; PEAK AMPS OF THE PARTIALS
i9	   	=		p5*1.33	     		; ARE A FUNCTION OF THE AMP
i10	   	=		p5*0.75	    			; OF THE LOWEST PARTIAL
i11	   	=		p5*1.33
i12	   	=		p3
i13	   	=		p3*.9
i14	   	=		p3*.65
i15	   	=		p3*.55	  			; DURATIONS OF THE PARTIALS ARE A FUNCTION OF
i16	   	=		p3*.325	   			; THE DURATION OF THE LOWEST PARTIAL
i17	   	=		p3*.35
i18	   	=		p3*.25
i19	   	=		p3*.2
i20	   	=		p3*.15
i21	   	=		p3*.1
i22	   	=		p3*.075
i23	   	=		p4*.56
i24	   	=		(p4*.56)+1
i25	   	=		p4*.92		 		; FREQUENCIES OF THE PARTIALS ARE A FUNCTION OF
i26	   	=		(p4*.92)+1.7 			; THE FREQUENCY OF THE FUNDAMENTAL
i27	   	=		p4*1.19
i28	   	=		p4*1.7
i29	   	=		p4*2
i30	   	=		p4*2.74
i31	   	=		p4*3
i32	   	=		p4*3.75
i33	   	=		p4*4.07

k1	   	oscil1	0,i1,i12,2
a1	   	oscili	k1,i23,1	 			; THE INSTRUMENT CONSISTS OF PAIRS OF oscil1/oscili
k2	   	oscil1	0,i2,i13,2  			; WHERE OSCIL1 PROVIDES THE ENVELOPE OF THE PARTIAL
a2	   	oscili	k1,i24,1	 			; AND OSCILI THE PARTIAL ITSELF
k3	   	oscil1	0,i3,i14,2
a3		oscili	k1,i25,1
k4	   	oscil1	0,i4,i15,2
a4	   	oscili	k1,i26,1
k5	   	oscil1	0,i5,i16,2
a5	   	oscili	k1,i27,1
k6	   	oscil1	0,i6,i17,2
a6	   	oscili	k1,i28,1
k7	   	oscil1	0,i7,i18,2
a7	   	oscili	k1,i29,1
k8	   	oscil1	0,i8,i19,2
a8	   	oscili	k1,i30,1
k9	   	oscil1	0,i9,i20,2
a9	   	oscili	k1,i31,1
k10	   	oscil1	0,i10,i21,2
a10	   	oscili	k1,i32,1
k11	   	oscil1	0,i11,i22,2
a11	   	oscili	k1,i33,1
		out	   	a1+a2+a3+a4+a5+a6+a7+a8+a9+a10+a11
		endin

; RISSET'S DRUM INSTRUMENT
; CODED BY THOMAS DIMEO - BROOKLYN COLLEGE

		instr 7
i1		=		p5*.3
i2		=		p4*.1
i3		=		1/p3
i4		=		p5*.8
i5		=		p4

a1 		randi 	p5,4000
a1 		oscil 	a1,i3,2
a1 		oscil 	a1,3000,

a2 		oscil 	i1,i3,2
a2 		oscil 	a2,i2,3

a3 		oscil 	i4,i3,4
a3 		oscil 	a3,i5,1

		out	  	a1+a2+a3
		endin

; RISSET'S ARPEGGIO INSTRUMENT
; CODED BY CURTIS BAHN - BROOKLYN COLLEGE

		instr 8
i1 		= 		p6					; INIT VALUES CORRESPOND TO FREQ.
i2 		= 		2*p6					; OFFSETS FOR OSCILLATORS BASED ON ORIGINAL p6
i3 		= 		3*p6
i4 		= 		4*p6

ampenv	linen   	p5,.01,p3,.02			; A SIMPLE ENVELOPE TO PREVENT CLICKING.

a1	 	oscili  	ampenv,p4,2
a2	 	oscili  	ampenv,p4+i1,2			; NINE OSCILLATORS WITH THE SAME AMP ENV
a3	 	oscili  	ampenv,p4+i2,2			; AND WAVEFORM, BUT SLIGHTLY DIFFERENT
a4	 	oscili  	ampenv,p4+i3,2			; FREQUENCIES TO CREATE THE BEATING EFFECT
a5	 	oscili  	ampenv,p4+i4,2
a6	 	oscili  	ampenv,p4-i1,2			; p4 = FREQ OF FUNDAMENTAL (Hz)
a7	 	oscili  	ampenv,p4-i2,2			; p5 = AMP
a8	 	oscili  	ampenv,p4-i3,2			; p6 = INITIAL OFFSET OF FREQ - .03 Hz
a9	 	oscili  	ampenv,p4-i4,2
		out	    	a1+a2+a3+a4+a5+a6+a7+a8+a9
		endin

</CsInstruments>
<CsScore>
                                      ; Waveforms: Instrument 1
f1 0 2048 10 1                        ; fundamental
f2 0 2048 10 1 .2 .08 .07             ; four harmonics
f3 0 2048 10 1 .4 .2 .1 .1 .05        ; six harmonics
                                      ; Amplitude Envelope Functions: Instrument 1
f4 0 512 7 0 1 0 49 .2 90 .6 40 .99 25 .9 45 .5 50 .25 50 .12 50 .06 50 .02 62 0
f5 0 512 7 0 1 0 49 .2 100 .6 50 .99 150 .2 162 0
f6 0 512 7 0 1 0 49 .2 200 .5 100 .2 162 0
f7 0 512 7 0 1 0 79 .5 60 .5 20 .99 120 .4 140 .6 92 0
                                      ; Amplitude Envelope Fynctions: Instrument 2
f8 0 512 7 0 1 0 149 .4 200 .99 50 .5 50 .24 62 0
                                      ; Pitch Envelope Functions: Instrument 2
f9 0 512 7 0 1 .895 511 .99
f10 0 512 7 0 1 .99 511 .99
                                      ; DC bias functions
f12 0 512 9 1 .26 0
f13 0 512 9 1 .3 0
; ================ "Flute-like" Score =============== ;
i2   .88   .12   1200   988   .12   8   10
i1  1       2     800  1109    2   20   60   5   2  .24   12
i2  1      .7     300  1107   .7    8   10
i1  3      .9     300   784   .9   30   50   4   2  .24   13
i2  4.5    .15   1200  1397   .2    4   10
i2  4.85   .15   1200   992   .15   8    9
i2  5.01   .7     300  1100   .7    8    9
i1  5.01    2    1200  1109    2   30   80   6   2  .24   13
i1  7      .2     400   784   .2   40   70   7   2  .24   13
i1  7.2    .3     300   698   .3   30   60   5   2  .24   13
i1  7.51    1     300   370    1   30   50   6   3  .24   13
i2  7.5    .5     150   368   .5    8    9
i1  8.5    .5     400   415   .5   50   60   5   3  .24   13
i1  9      .12    900  1396   .12  30   80   4   2  .24   13
i1  9.1   1.2     900  1568  1.2   30   90   4   2  .24   13
i1  10.25 1       900   277  1.08  40   60   7   3  .31   13
i2  10.25 1       200   275  1      6   10
i1  11.35  .36    500   329   .36  30   60   5   2  .28   13
i1  11.72  .36    800   528   .36  30   60   5   2  .28   13
i2  12.09  .2     950  2217   .2    6    9
i1  12.10  .15    700  1975   .15  40   90   5   1  .28   13
i1  12.25 2.5     999  2217  2.5   40   90   4   1  .28   13
s
f0  2
s
f2  0 512 7 -1 200 -.5 112 .5 200 1
i3   0.000   0.750    7.04   20000
i3   0.750   0.250    7.07   20000
i3   1.000   1.000    8.00   20000
i3   2.000   0.200    8.02   20000
i3   2.200   0.200    8.04   20000
i3   2.400   0.200    8.05   20000
i3   2.600   0.200    9.00   20000
i3   2.800   0.200    9.04   20000
i3   3.000   0.250    9.05   20000
i3   3.250   0.250    9.00   20000
i3   3.500   0.250    8.05   20000
i3   3.750   0.250    8.00   20000
i3   4.000   1.000    7.04   20000
i3   5.000   0.125    7.07   20000
i3   5.125   0.125    8.00   20000
i3   5.250   0.125    8.02   20000
i3   5.375   0.125    8.04   20000
i3   5.500   0.125    8.05   20000
i3   5.625   0.125    9.00   20000
i3   5.750   0.125    9.04   20000
i3   5.875   0.125    9.05   20000
s
f0  2
s
f2 0 512 7 0 16 .2 16 .38 16 .54 16 .68 16 .8 16 .9 16 .98 8 1 2 1 6 .96 64 .8313 32 .5704 80 .164 48 .0521 44 .0159 20 .0092 64 .005 32 0
  i4 0.000 0.750 6.00 20000
  i4 0.750 0.250 6.05 20000
  i4 1.000 1.000 7.00 20000
  i4 2.000 0.200 7.05 20000
  i4 2.200 0.200 8.00 20000
  i4 2.400 0.200 8.05 20000
  i4 2.600 0.200 9.00 20000
  i4 2.800 0.200 8.07 20000
  i4 3.000 2.000 8.00 20000
  i4 5.000 0.250 7.07 20000
  i4 5.250 0.250 7.00 20000
  i4 5.500 0.250 6.07 20000
  i4 5.750 0.250 6.00 20000
s
f0 2
s
f2 0 512 7 0 43 1 171 1 84 -1 171 -1 43 0
i5  0.000 0.150  424 20000 1000 0.010
i5  0.150 0.300  727 20000 1000 0.010
i5  0.450 0.300 1524 20000 2000 0.010
i5  0.750 0.600 1136 20000 2000 0.010
i5  1.350 0.600 1342 20000 2000 0.010
i5  1.950 3.600  424 20000 1000 2.300
i5  5.550 0.150  727 20000 1000 0.010
i5  5.700 0.300 1524 20000 2000 0.010
i5  6.000 0.300 1136 20000 2000 0.010
i5  6.300 0.600 1342 20000 2000 0.010
i5  6.900 0.600  424 20000 1000 0.010
i5  7.500 3.600  727 20000 1000 2.300
i5 11.100 0.150 1524 20000 2000 0.010
i5 11.250 0.300 1136 20000 2000 0.010
i5 11.550 0.300 1342 20000 2000 0.010
i5 11.850 0.600  424 20000 1000 0.010
i5 12.450 0.600  727 20000 1000 0.010
i5 13.050 3.600 1524 20000 2000 2.300
i5 16.650 0.150 1136 20000 2000 0.010
i5 16.800 0.300 1342 20000 2000 0.010
s
f0   2
s
f2 0 513 5 1024 512 1                  ; Amplitude envelope with extended guard point
;  st   dur    freq     amp
i6  1   4      633     2500
i.      +       .       211
i.      +       .       999
s
i6  1   4   633 1500
i6  1   4   211 1500
i6  1   4   999 1500
i6  1   4   80  1500
s
f0  2
s
f 2 0 512 5 4096 512 1
f 3 0 512 9 10 1 0 16 1.5 0 22 2 0 23 1.5 0
f 4 0 512 5 256 512 1
t0 60 10 120
i7  0.000 1.000  100 6000
i7  1.000 1.000  200 6000
i7  2.000 1.000  300 6000
i7  3.000 1.000  400 6000
i7  4.000 1.000  500 6000
i7  5.000 1.000  600 6000
i7  6.000 1.000  700 6000
i7  7.000 1.000  800 6000
i7  8.000 1.000  900 6000
i7  9.000 1.000 1000 6000
s
t0  480
i7  0.000 1.000 1000 6000
i7  1.000 1.000  900 6000
i7  2.000 1.000  800 6000
i7  3.000 1.000  700 6000
i7  4.000 1.000  600 6000
i7  5.000 1.000  500 6000
i7  6.000 1.000  400 6000
i7  7.000 1.000  300 6000
i7  8.000 1.000  200 6000
i7  9.000 1.000  100 6000
s
f0  2
s
f2 0 1024 10 1 0 0 0 .7 .7 .7 .7 .7 .7
;   st  dur frq  amp  offset
i8  1   10   96 2500   .03
i8  +    .   48 2500   .
i8  +    .  192 2500   .
e

</CsScore>
</CsoundSynthesizer>
