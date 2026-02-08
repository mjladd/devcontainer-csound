<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from bd16_01.orc and bd16_01.sco
; Original files preserved in same directory

sr	=  44100
kr	=  22050
ksmps	=  2
nchnls	=  1


/* ------------------------------------------------------------------------- */

	seed 0

	instr 1

imkey	=  p4		/* get note parameters from score file */
imvel	=  p5

icps	=  440.0*exp(log(2.0)*(imkey-69.0)/12.0)
iamp	=  0.0039+imvel*imvel/16192

/* ------------------------------------------------------------------------- */

ivol	table	 0,	64	/* output volume			*/
ibpm	table	 1,	64	/* tempo				*/

ifrqs	table	 2,	64	/* oscillator start frq. / note freq.	*/
ifrqe	table	 3,	64	/* oscillator end frequency / note frq.	*/
ifrqd	table	 4,	64	/* osc. freq. envelope speed		*/

iffr1s	table	 5,	64	/* lowpass filter start freq. 1 (Hz)	*/
iffr1d	table	 6,	64	/* lowpass filter freq. 1 decay speed	*/
iffr2s	table	 7,	64	/* lowpass filter start freq. 2 (Hz)	*/
iffr2d	table	 8,	64	/* lowpass filter freq. 2 decay speed	*/
iffr3s	table	 9,	64	/* LP filter start freq. 3 / note frq.	*/
iffr3d	table	10,	64	/* lowpass filter freq. 3 decay speed	*/
iffr4s	table	11,	64	/* LP filter start freq. 4 / note frq.	*/
iffr4d	table	12,	64	/* lowpass filter freq. 4 decay speed	*/

iEQ1fo	table	13,	64	/* EQ 1 frequency / osc. frequency	*/
iEQ1fn	table	14,	64	/* EQ 1 frequency / note frequency	*/
iEQ1fa	table	15,	64	/* EQ 1 frequency (Hz)			*/
iEQ1l	table	16,	64	/* EQ 1 level				*/
iEQ1q	table	17,	64	/* EQ 1 Q				*/
iEQ1m	table	18,	64	/* EQ 1 mode (0:peak,1:low,2:high)	*/

iEQ2fo	table	19,	64	/* EQ 2 frequency / osc. frequency	*/
iEQ2fn	table	20,	64	/* EQ 2 frequency / note frequency	*/
iEQ2fa	table	21,	64	/* EQ 2 frequency (Hz)			*/
iEQ2l	table	22,	64	/* EQ 2 level				*/
iEQ2q	table	23,	64	/* EQ 2 Q				*/
iEQ2m	table	24,	64	/* EQ 2 mode (0:peak,1:low,2:high)	*/

iEQ3fo	table	25,	64	/* EQ 3 frequency / osc. frequency	*/
iEQ3fn	table	26,	64	/* EQ 3 frequency / note frequency	*/
iEQ3fa	table	27,	64	/* EQ 3 frequency (Hz)			*/
iEQ3l	table	28,	64	/* EQ 3 level				*/
iEQ3q	table	29,	64	/* EQ 3 Q				*/
iEQ3m	table	30,	64	/* EQ 3 mode (0:peak,1:low,2:high)	*/

iEQ4fo	table	31,	64	/* EQ 4 frequency / osc. frequency	*/
iEQ4fn	table	32,	64	/* EQ 4 frequency / note frequency	*/
iEQ4fa	table	33,	64	/* EQ 4 frequency (Hz)			*/
iEQ4l	table	34,	64	/* EQ 4 level				*/
iEQ4q	table	35,	64	/* EQ 4 Q				*/
iEQ4m	table	36,	64	/* EQ 4 mode (0:peak,1:low,2:high)	*/

insmix	table	37,	64	/* noise mix				*/

iEQn1fo	table	38,	64	/* noise EQ 1 frequency / osc. freq.	*/
iEQn1fn	table	39,	64	/* noise EQ 1 frequency / note freq.	*/
iEQn1fa	table	40,	64	/* noise EQ 1 frequency (Hz)		*/
iEQn1l	table	41,	64	/* noise EQ 1 level			*/
iEQn1q	table	42,	64	/* noise EQ 1 Q				*/
iEQn1m	table	43,	64	/* noise EQ 1 mode (0:peak,1:lo,2:hi)	*/

iEQn2fo	table	44,	64	/* noise EQ 2 frequency / osc. freq.	*/
iEQn2fn	table	45,	64	/* noise EQ 2 frequency / note freq.	*/
iEQn2fa	table	46,	64	/* noise EQ 2 frequency (Hz)		*/
iEQn2l	table	47,	64	/* noise EQ 2 level			*/
iEQn2q	table	48,	64	/* noise EQ 2 Q				*/
iEQn2m	table	49,	64	/* noise EQ 2 mode (0:peak,1:lo,2:hi)	*/

/* ------------------------------------------------------------------------- */

p3	=  p3+0.15	/* increase note length */

ibtime	=  60/ibpm

kamp	linseg 1,p3-0.15,1,0.05,0,0.1,0		/* amp. envelope */
kamp	=  kamp*iamp*ivol

kcps	port ifrqe*icps,ibtime/ifrqd,ifrqs*icps	/* kcps = osc. frequency */
knumh	=  sr/(2*kcps)				/* knumh = num. of harmonics */

a_	buzz sr/(3.14159265*10),kcps,knumh,1,0		/* square oscillator */
a__	buzz sr/(3.14159265*10),kcps,knumh,1,0.5

a0	tone a_-a__,10

a_	unirand 2					/* noise generator */
a_	=  a_-1

a_	pareq a_,iEQn1fa+icps*iEQn1fn+kcps*iEQn1fo,iEQn1l,iEQn1q,iEQn1m
a_	pareq a_,iEQn2fa+icps*iEQn2fn+kcps*iEQn2fo,iEQn2l,iEQn2q,iEQn2m

a0	=  a0+insmix*a_

/* EQ */

a0	pareq a0,iEQ1fa+icps*iEQ1fn+kcps*iEQ1fo,iEQ1l,iEQ1q,iEQ1m
a0	pareq a0,iEQ2fa+icps*iEQ2fn+kcps*iEQ2fo,iEQ2l,iEQ2q,iEQ2m
a0	pareq a0,iEQ3fa+icps*iEQ3fn+kcps*iEQ3fo,iEQ3l,iEQ3q,iEQ3m
a0	pareq a0,iEQ4fa+icps*iEQ4fn+kcps*iEQ4fo,iEQ4l,iEQ4q,iEQ4m

kffr1	port 0,ibtime/iffr1d,iffr1s	/* LP filter freq. envelopes */
kffr2	port 0,ibtime/iffr2d,iffr2s
kffr3	port 0,ibtime/iffr3d,iffr3s*icps
kffr4	port 0,ibtime/iffr4d,iffr4s*icps

kffrq	=  kffr1+kffr2+kffr3+kffr4	/* kffrq = LP filter frequency */

a0	butterlp a0,kffrq		/* LP filter */

a_	=  a0*kamp			/* apply envelope */

	out a_

	endin



</CsInstruments>
<CsScore>

t 0 135.00	/* tempo */

i 1	0.0000	0.4000	33	120
i 1	1.0100	0.4000	33	112
i 1	2.0100	0.4000	33	124
i 1	3.0050	0.4000	33	112
i 1	4.0000	0.4000	33	116
i 1	5.0100	0.4000	33	112
i 1	6.0100	0.4000	33	120
i 1	6.9900	0.3000	33	120
i 1	7.5000	0.3000	33	116

i 1	8.0000	0.4000	33	120
i 1	9.0100	0.4000	33	112
i 1	10.010	0.4000	33	124
i 1	11.005	0.4000	33	112
i 1	12.000	0.4000	33	116
i 1	13.010	0.4000	33	112
i 1	14.010	0.4000	33	120
i 1	15.005	0.4000	33	112

/* ------------------------------------------------------------------------- */

f 64 0 64 -2	5500.0		/* output volume			*/
		135.0		/* tempo				*/

		5.3333		/* oscillator start frq. / note freq.	*/
		1.0		/* oscillator end frequency / note frq.	*/
		16.0		/* osc. freq. envelope speed		*/

		880		/* lowpass filter start freq. 1 (Hz)	*/
		128		/* lowpass filter freq. 1 decay speed	*/
		0		/* lowpass filter start freq. 2 (Hz)	*/
		1		/* lowpass filter freq. 2 decay speed	*/
		8		/* LP filter start freq. 3 / note frq.	*/
		8		/* lowpass filter freq. 3 decay speed	*/
		0		/* LP filter start freq. 4 / note frq.	*/
		1		/* lowpass filter freq. 4 decay speed	*/

		0.5		/* EQ 1 frequency / osc. frequency	*/
		0		/* EQ 1 frequency / note frequency	*/
		0		/* EQ 1 frequency (Hz)			*/
		0.25		/* EQ 1 level				*/
		0.7071		/* EQ 1 Q				*/
		1		/* EQ 1 mode (0:peak,1:low,2:high)	*/

		0.5		/* EQ 2 frequency / osc. frequency	*/
		0		/* EQ 2 frequency / note frequency	*/
		0		/* EQ 2 frequency (Hz)			*/
		0.25		/* EQ 2 level				*/
		0.7071		/* EQ 2 Q				*/
		1		/* EQ 2 mode (0:peak,1:low,2:high)	*/

		0.5		/* EQ 3 frequency / osc. frequency	*/
		0		/* EQ 3 frequency / note frequency	*/
		0		/* EQ 3 frequency (Hz)			*/
		4		/* EQ 3 level				*/
		2.0		/* EQ 3 Q				*/
		0		/* EQ 3 mode (0:peak,1:low,2:high)	*/

		0		/* EQ 4 frequency / osc. frequency	*/
		1.5		/* EQ 4 frequency / note frequency	*/
		0		/* EQ 4 frequency (Hz)			*/
		2.0		/* EQ 4 level				*/
		1.0		/* EQ 4 Q				*/
		0		/* EQ 4 mode (0:peak,1:low,2:high)	*/

		16.0		/* noise mix				*/

		0		/* noise EQ 1 frequency / osc. freq.	*/
		16		/* noise EQ 1 frequency / note freq.	*/
		0		/* noise EQ 1 frequency (Hz)		*/
		0.0625		/* noise EQ 1 level			*/
		0.7071		/* noise EQ 1 Q				*/
		1		/* noise EQ 1 mode (0:peak,1:lo,2:hi)	*/

		0		/* noise EQ 2 frequency / osc. freq.	*/
		16		/* noise EQ 2 frequency / note freq.	*/
		0		/* noise EQ 2 frequency (Hz)		*/
		0.0625		/* noise EQ 2 level			*/
		0.7071		/* noise EQ 2 Q				*/
		1		/* noise EQ 2 mode (0:peak,1:lo,2:hi)	*/

/* ------------------------------------------------------------------------- */

f 1 0 262144 10 1

e	/* end of score */



</CsScore>
</CsoundSynthesizer>
