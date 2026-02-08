<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from mixer-10_stereo.orc and mixer-10_stereo.sco
; Original files preserved in same directory

sr = 44100
kr = 4410
ksmps = 10
nchnls = 1


/* ------------- mixer v1.2 orchestra file (stereo version) ---------------- */

sr	=  44100
kr	=  1378.125
ksmps	=  32
nchnls	=  2

/* ------------------------------------------------------------------------- */

gaxL	init 0
gaxR	init 0

	instr 1

iftnum	=  int(p4+100.5)	/* ftable number			*/
ivol2	=  p5			/* note amplitude			*/
ipnum	=  int(p6+0.5)		/* part number				*/

/* ------------------------------------------------------------------------- */

ivol	table  0, iftnum	/* volume				*/
iskptim	table  1, iftnum	/* skip time				*/
idloffs	table  2, iftnum	/* delay offset				*/

iEQx	table  3, iftnum	/* EQ enable/disable			*/
iEQ1f	table  4, iftnum	/* EQ 1 frequency			*/
iEQ1l	table  5, iftnum	/* EQ 1 level				*/
iEQ1q	table  6, iftnum	/* EQ 1 Q				*/
iEQ1m	table  7, iftnum	/* EQ 1 mode				*/
iEQ2f	table  8, iftnum	/* EQ 2 frequency			*/
iEQ2l	table  9, iftnum	/* EQ 2 level				*/
iEQ2q	table 10, iftnum	/* EQ 2 Q				*/
iEQ2m	table 11, iftnum	/* EQ 2 mode				*/

iflnum	table int(12.5+ipnum), iftnum	/* file number			*/

ilnth	table  1, 1		/* output file length			*/
idelx	table  2, 1		/* output file delay			*/

/* ------------------------------------------------------------------------- */

ivol	=  ivol * ivol2

iEQ1m	=  int(iEQ1m+0.5)
iEQ2m	=  int(iEQ2m+0.5)

iflnum	=  int(iflnum+0.5)

idel	=  idelx - idloffs			/* delay time		*/
iflen	filelen iflnum
p3	=  idel + (iflen - iskptim) + 0.1	/* note length		*/
i_time	times
i_time	=  ((p3 + i_time) > ilnth ? (ilnth - i_time) : p3)
i_time	limit i_time, 1.0, 3600.0
p3	=  i_time

/* ------------------------------------------------------------------------- */

aL, aR	soundin iflnum, iskptim

	if (iEQx<0.5) goto cont1	/* skip EQ if disabled */

aL	pareq aL, iEQ1f, iEQ1l, iEQ1q, iEQ1m
aL	pareq aL, iEQ2f, iEQ2l, iEQ2q, iEQ2m
aR	pareq aR, iEQ1f, iEQ1l, iEQ1q, iEQ1m
aR	pareq aR, iEQ2f, iEQ2l, iEQ2q, iEQ2m

cont1:

a0L	delay aL*ivol, idel
a0R	delay aR*ivol, idel

gaxL	=  gaxL + a0L
gaxR	=  gaxR + a0R

	endin

/* ------------------------------------------------------------------------- */

	instr 90		/* output instrument		*/

/* ------------------------------------------------------------------------- */

ivol	table  0, 1	/* volume				*/
ilnth	table  1, 1	/* output file length			*/

iEQx	table  3, 1	/* EQ enable/disable			*/
iEQ1f	table  4, 1	/* EQ 1 frequency			*/
iEQ1l	table  5, 1	/* EQ 1 level				*/
iEQ1q	table  6, 1	/* EQ 1 Q				*/
iEQ1m	table  7, 1	/* EQ 1 mode				*/
iEQ2f	table  8, 1	/* EQ 2 frequency			*/
iEQ2l	table  9, 1	/* EQ 2 level				*/
iEQ2q	table 10, 1	/* EQ 2 Q				*/
iEQ2m	table 11, 1	/* EQ 2 mode				*/

/* ------------------------------------------------------------------------- */

p3	=  ilnth

iEQ1m	=  int(iEQ1m+0.5)
iEQ2m	=  int(iEQ2m+0.5)

aL	=  gaxL
aR	=  gaxR

gaxL	=  0
gaxR	=  0

	if (iEQx<0.5) goto cont1	/* skip EQ if disabled */

aL	pareq aL, iEQ1f, iEQ1l, iEQ1q, iEQ1m
aL	pareq aL, iEQ2f, iEQ2l, iEQ2q, iEQ2m
aR	pareq aR, iEQ1f, iEQ1l, iEQ1q, iEQ1m
aR	pareq aR, iEQ2f, iEQ2l, iEQ2q, iEQ2m

cont1:

k_env	init int(p3*kr + 0.5)		/* output envelope */
k_env	=  int(k_env - 0.5)
kenv	limit k_env - (0.1*kr), 0.0, 0.1*kr
aenv	interp (kenv / (0.1*kr)) - 1.0
aenv	=  aenv + 1.0

	outs aL * ivol * aenv, aR * ivol * aenv

	endin



</CsInstruments>
<CsScore>

/* score file for mixer v1.2 */

t 0.00	134.00		/* tempo */

/* p1	=  instrument number (1)		*/
/* p2	=  start time in beats			*/
/* p3	=  duration in beats (ignored)		*/
/* p4	=  track number = (ftable number) - 100	*/
/* p5	=  volume				*/
/* p6	=  part number				*/

;include "part-1.sco"
;include "part-2.sco"
;include "part-3.sco"
#include "part-4.sco"
#include "part-5.sco"

#include "part-10.sco"

;PART01(   0)
;PART02(  64)
;PART03( 128)
$PART04(   0)
$PART05(  64)
;PART05( 224)

;PART10(   0)

/* ------------------------------------------------------------------------- */

f 1 0 16 -2	1.0		/* volume				*/
		62.0		/* output file length in seconds	*/
		1.0		/* output file delay in seconds		*/
		0		/* 0/1 : disable/enable EQ		*/
		1000		/* EQ 1 frequency			*/
		1.0		/* EQ 1 level				*/
		0.7071		/* EQ 1 Q				*/
		0		/* EQ 1 mode (0/1/2 : peak/low/high)	*/
		1000		/* EQ 2 frequency			*/
		1.0		/* EQ 2 level				*/
		0.7071		/* EQ 2 Q				*/
		0		/* EQ 2 mode (0/1/2 : peak/low/high)	*/

/* ------------------------------------------------------------------------- */

/* tnum: table number		*/
/* vol:  volume			*/
/* del:  delay offset		*/
/* fnum: file number list	*/

#define TABLE1(tnum'vol'del'fnum) #

f $tnum 0 32 -2	$vol		/* volume				*/
		0.0		/* skip time in seconds			*/
		$del		/* delay offset in seconds		*/
		0		/* 0/1 : disable/enable EQ		*/
		1000	1.0	/* EQ 1 frequency, level		*/
		0.7071	0	/* EQ 1 Q, mode				*/
		1000	1.0	/* EQ 2 frequency, level		*/
		0.7071	0	/* EQ 2 Q, mode				*/
		$fnum		/* list of file numbers (max. 20)	*/

#

/* drum_06, drum_06_1 .. drum_06_6 */

$TABLE1(100'2.52'0.02'0 1 2 3 4 5 40)

/* organ1 */

$TABLE1(101'1.05'0.025'6 25)

/* bass_0301 */

$TABLE1(102'1.68'0.03'7 22 24)

/* synth_12_1 */

$TABLE1(103'0.84'0.05'8)

/* crash_1 .. crash_6 */

$TABLE1(104'0.42'0.025'9 10 11 12 13 14)

/* ohh_10, ohh_11 */

$TABLE1(105'0.504'0.025'15 16)

/* chh_10, chh_11 */

$TABLE1(106'0.3528'0.025'17 18)

/* tamb_1, tamb_2 */

$TABLE1(107'0.588'0.025'19 20)

/* clap_1 */

$TABLE1(108'2.1'0.025'21)

/* ohh2_10 */

$TABLE1(109'1.05'0.025'23)

/* hit1_1 .. hit1_4 */

$TABLE1(110'2.8'0.032'26 27 28 29)

/* aaah1 */

$TABLE1(111'0.084'0.022'30 41)

/* bsln1 */

$TABLE1(112'1.68'0.02'31)

/* revcym */

$TABLE1(113'0.42'0.025'32 33 34 35)

/* snare */

$TABLE1(114'0.504'0.025'36 37 38 39)

/* aaah2_1 */

$TABLE1(115'0.126'0.025'42)

/* bsln2 */

$TABLE1(116'3.36'0.022'43)

/* ------------------------------------------------------------------------- */

i 90	0.000	1.0	/* output instr. */

e	/* END OF SCORE */



</CsScore>
</CsoundSynthesizer>
