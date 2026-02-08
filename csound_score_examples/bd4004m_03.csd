<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from bd4004m_03.orc and bd4004m_03.sco
; Original files preserved in same directory

sr	=  44100
kr	=  44100
ksmps	=  1
nchnls	=  1


/* convert MIDI note number to frequency */

#define MIDI2CPS(xmidikey) # (440.0*exp(log(2.0)*(($xmidikey)-69.0)/12.0)) #

/* convert frequency to MIDI note number */

#define CPS2MIDI(xfreqcps) # (12.0*(log(($xfreqcps)/440.0)/log(2.0))+69.0) #

/* convert velocity to amplitude */

#define VELOC2AMP(xvelocity) # (0.0039+(($xvelocity)*($xvelocity))/16192.0) #

/* convert amplitude to velocity */

#define AMP2VELOC(xamplitude) # (sqrt((($xamplitude)-0.0039)*16192.0)) #

	seed 0

	instr 1

	kgoto start01

/*-------------------------------------------------------------------------- */

ivol	table 0,64	/* volume					*/
ibpm	table 1,64	/* tempo					*/
irel	table 2,64	/* release time (sec.)				*/
idel	table 3,64	/* delay time					*/
imod0	table 4,64	/* random mod. of delay (sec.)			*/
imod1	table 5,64	/* rnd. mod. of velocity			*/
if01	table 6,64	/* oscillator start frequency (rel.)		*/
ifd1	table 7,64	/* frequency envelope decay speed		*/
ibw01	table 8,64	/* OSC1 BP bandwidth (rel.)			*/
ihp1	table 9,64	/* OSC1 HP frequency (rel.)			*/
iapf1	table 10,64	/* OSC1 allpass filter start freq. (rel.)	*/
iapf2	table 11,64	/* OSC1 allpass filter end freq.		*/
iapdx	table 12,64	/* OSC1 allpass filter envelope speed		*/
ifr3	table 13,64	/* OSC2 HP1 frequency / base frq.		*/
imx3	table 14,64	/* OSC2 HP1 mix					*/
ifr4	table 15,64	/* OSC2 output HP frq. / base freq.		*/
imx2	table 16,64	/* OSC2 output gain				*/
ihp2	table 17,64	/* output HP (OSC1+OSC2) frq. (rel. to note f.)	*/
ibw02	table 18,64	/* output HP resonance				*/
ifr1	table 19,64	/* output LP start freq. 1 (rel.)		*/
ifdx1	table 20,64	/* output LP freq. 1 envelope decay speed	*/
ifr2	table 21,64	/* output LP start freq. 2			*/
ifdx2	table 22,64	/* output LP freq. 2 envelope decay speed	*/
ifxBP1	table 23,64	/* noise BP start frequency (Hz)		*/
ifxBP2	table 24,64	/* noise BP end frequency			*/
ibw1	table 25,64	/* noise BP bandwidth/freq.			*/
ifxLP1	table 26,64	/* noise LP start frequency (Hz)		*/
ifxLP2	table 27,64	/* noise LP end frequency			*/
ifxd	table 28,64	/* noise filter envelope speed			*/
iattn1	table 29,64	/* noise attack time (sec.)			*/
idecn1	table 30,64	/* noise decay speed				*/
imxn	table 31,64	/* noise mix					*/

/*-------------------------------------------------------------------------- */

i001	=  1/65536			/*				*/
imkey	=  p4				/* MIDI key number		*/
imvel	=  p5				/* MIDI velocity		*/
ivel	=  $VELOC2AMP(imvel)		/* convert velocity		*/
im0	unirand 2			/*				*/
im1	unirand 2			/*				*/
ivel	=  ivel*(1+(im1-1)*imod1)	/* randomized velocity		*/
idel	=  idel+((im0-1)*imod0)		/* randomized delay		*/
ibtime	=  60/ibpm			/* beat time			*/
i002	=  exp(log(i001)*(idel+irel+16/kr)/irel)
ivol	=  ivel*ivol

icps	=  $MIDI2CPS(imkey)		/* base freq.	*/
ifmax	=  sr*0.48			/* max. allowed freq.	*/
ihp2	=  ihp2*icps
ibw02x	=  ihp2/ibw02
ifxLP2	=  ifxLP2-ifxLP1
ifxBP2	=  ifxBP2-ifxBP1
iapf2	=  iapf2-iapf1

ixtime	=  (irel+idel+16/kr)

p3	=  p3+ixtime				/* increase note length */

start01:

kenvn1	expseg 1,ibtime/idecn1,0.5			/* noise generator */
kenvn2	linseg 0,iattn1,1,1,1
aenvn	interp kenvn1*kenvn2
kenvn3	expseg 1,ibtime/ifxd,0.5
kenvn3	=  (1-kenvn3)
kfxBPf	=  ifxBP1+(kenvn3*ifxBP2)
a1l	unirand 2
a1l	butterbp imxn*32768*(a1l-1)*aenvn,kfxBPf,kfxBPf*ibw1
a1l	butterlp a1l,ifxLP1+(ifxLP2*kenvn3)

kamp1	expseg 1,p3-ixtime,1,ixtime,i002		/* envelopes */
kfrq1   expseg 1,ibtime/ifd1,0.5
kfrq	=  icps*(1+kfrq1*(if01-1))	/* kfrq  = osc. frequency */
kapfr	expseg 1,ibtime/iapdx,0.5	/* kapfr = allpass filter frequency */
kapfr	=  kfrq*(iapf1+iapf2*(1-kapfr))
kfrx1	expseg 1,ibtime/ifdx1,0.5
kfrx2	expseg 1,ibtime/ifdx2,0.5
kfrx	=  kfrq*(kfrx1*ifr1+kfrx2*ifr2)
kfrx	=  (kfrx>ifmax ? ifmax : kfrx)	/* kfrx  = LP filter frequency */

knumh	=  sr/(2*kfrq)			/* oscillator */
a1	buzz sr/(10*3.14159265), kfrq, knumh, 256, 0
a2	buzz sr/(10*3.14159265), kfrq, knumh, 256, 0.5
a1	tone (a1-a2)*16384, 10
a2	=  a1					/* a1 = a2 = osc. signal */

a1	butterhp a1,kfrq*ihp1				/* filters */
a1      butterbp a1,kfrq,kfrq*ibw01
a1x	tone a1,kapfr
a1	=  2*a1x-a1
a3      butterhp a2,kfrq*ifr3
a2	=  a2+a3*imx3
a2	butterhp a2,kfrq*ifr4
a0x	=  a2*imx2+a1
atmp	butterbp a0x*ibw02,ihp2,ibw02x
a0x 	butterhp a0x+atmp,ihp2
a0x	butterlp a0x,kfrx

a0y	delay (a0x+a1l)*ivol*kamp1,idel

	out  a0y

	endin



</CsInstruments>
<CsScore>

t 0.00	180.000		/* tempo	*/

#define rhytm1(STIME) #

i 1	[$STIME+0.0000]		0.4250	33	127
i 1	[$STIME+0.9900]		0.4250	33	124
i 1	[$STIME+1.9800]		0.4250	33	120
i 1	[$STIME+2.9700]		0.4250	33	116

i 1	[$STIME+4.0000]		0.4250	33	124
i 1	[$STIME+4.9900]		0.4250	33	120
i 1	[$STIME+5.9850]		0.4250	33	118
i 1	[$STIME+6.9800]		0.4250	33	116

#

$rhytm1(0)
$rhytm1(8)

/* ------------------------------------------------------------------------- */

f 64 0 32 -2	0.27		/* volume				*/
		180		/* tempo				*/

		0.1667		/* release time (sec.)			*/
		0.01		/* delay time				*/
		0.0025		/* random mod. of delay (sec.)		*/
		0.005		/* rnd. mod. of velocity		*/

		5.3333		/* oscillator start frequency (rel.)	*/
		14.0		/* frequency envelope decay speed	*/
		0.7		/* OSC1 BP bandwidth (rel.)		*/
		0.0625		/* OSC1 HP frequency (rel.)		*/
		0.03125		/* OSC1 allp. filter start freq. (rel.)	*/
		1.0		/* OSC1 allpass filter end freq.	*/
		16		/* OSC1 allpass filter envelope speed	*/
		8		/* OSC2 HP1 frequency (rel.)		*/
		-2.0		/* OSC2 HP1 mix				*/
		0.7		/* OSC2 output HP frq. (rel.)		*/
		-2.0		/* OSC2 output gain			*/
		1.333		/* output HP frq. (rel. to note f.)	*/
		2.0		/* output HP resonance			*/
		4		/* output LP start freq. 1 (rel.)	*/
		0.5		/* output LP freq. env. 1 decay speed	*/
		4		/* output LP start freq. 2		*/
		0.5		/* output LP freq. env. 2 decay speed	*/

		7040		/* noise BP start frequency (Hz)	*/
		7040		/* noise BP end frequency		*/
		2		/* noise BP bandwidth/freq.		*/
		3520		/* noise LP start frequency (Hz)	*/
		55		/* noise LP end frequency		*/
		12		/* noise filter envelope speed		*/
		0.01		/* noise attack time (sec.)		*/
		3		/* noise decay speed			*/
		0.5		/* noise mix				*/

/*-------------------------------------------------------------------------- */

f 256 0 262144 10 1

e	/* end of score */



</CsScore>
</CsoundSynthesizer>
