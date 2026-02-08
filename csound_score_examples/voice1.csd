<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from voice1.orc and voice1.sco
; Original files preserved in same directory

sr	=  44100
kr	=  1378.125
ksmps	=  32
nchnls	=  2


/* mono output file name */

#define OUTFLNAME # "_tmp.dat" #

/* ------------------------------------------- */

/* parameters for spatialization */

#define SOUNDSPEED	# 340.0 #
#define EARDIST		# 0.18 #
#define DELAYOFFS1	# 0.02 #
#define AMPDIST0	# 10 #

/* ------------------------------------------- */

/* convert distance to delay time */

#define Dist2Delay(xdst)
# ((($xdst)/$SOUNDSPEED)+$DELAYOFFS1) #

/* convert distance to amplitude */

#define Dist2Amp(xdst)
# (1/(($xdst)+1/$AMPDIST0)) #

/* azimuth to LEFT channel amp. */

#define Azim2AmpL(xazim)
# abs(1.4142135*cos((($xazim)+1.570796)/2)) #

/* azimuth to RIGHT channel amp. */

#define Azim2AmpR(xazim)
# abs(1.4142135*sin((($xazim)+1.570796)/2)) #

/* ------------------------------------------- */

/* temp macro for filtering */

#define SpatFilter #

a_	butterlp	0.333*a_L_, 500
a_1_	butterlp	0.533*a_L_, 4000
a_2_	tone		0.134*a_L_, 12000
a_2_	=  a_ + a_1_ + a_2_

a_	butterlp	0.333*a_R_, 500
a_1_	butterlp	0.533*a_R_, 4000
a_3_	tone		0.134*a_R_, 12000
a_3_	=  a_ + a_1_ + a_3_

#

#define SpatStereo #

i_1_	wrap i_az_, -180, 180
i_1_	mirror i_1_*3.141593/180, \
		-1.570796, 1.570796

i_2_	limit i_d_, 0, $SOUNDSPEED*0.95

i_3_	=  i_2_*cos(i_1_)		/* Yd */
i_4_	=  i_2_*sin(i_1_) + $EARDIST/2	/* XdL */
i_5_	=  i_2_*sin(i_1_) - $EARDIST/2	/* XdR */
i_4_	=  sqrt(i_4_*i_4_+i_3_*i_3_)	/* dL */
i_5_	=  sqrt(i_5_*i_5_+i_3_*i_3_)	/* dR */

i_2_	=  $Dist2Amp(i_4_)	/* amp. / L */
i_3_	=  $Dist2Amp(i_5_)	/* amp. / R */
i_6_	=  $Azim2AmpL(i_1_)	/* high lvl. L */
i_7_	=  $Azim2AmpR(i_1_)	/* high lvl. R */

/* lock i-rate variables */

k_2_	samphold i_2_, -1, i_2_, 0
k_3_	samphold i_3_, -1, i_3_, 0
k_6_	samphold i_6_, -1, i_6_, 0
k_7_	samphold i_7_, -1, i_7_, 0

a_4_	=  a_

/* delay */

a_L_	delay a_*k_2_, \
	(int($Dist2Delay(i_4_)*sr+0.5)+0.01)/sr
a_R_	delay a_*k_3_, \
	(int($Dist2Delay(i_5_)*sr+0.5)+0.01)/sr

$SpatFilter

/* mix output */

a_L_	=  k_6_*a_L_ + (1-k_6_)*a_2_
a_R_	=  k_7_*a_R_ + (1-k_7_)*a_3_

a_	=  a_4_

#

/* ------------------------------------------- */

/* spatializer macro */

#define SPATMACRO # $SpatStereo #


/* convert MIDI note number to frequency */

#define MIDI2CPS(xmidikey)
# (440.0*exp(log(2.0)*(($xmidikey)-69.0)/12.0)) #

/* convert frequency to MIDI note number */

#define CPS2MIDI(xfreqcps)
# (12.0*(log(($xfreqcps)/440.0)/log(2.0))+69.0) #

/* convert velocity to amplitude */

#define VELOC2AMP(xvelocity)
# (0.0039+(($xvelocity)*($xvelocity))/16192.0) #

/* convert amplitude to velocity */

#define AMP2VELOC(xamplitude)
# (sqrt((($xamplitude)-0.0039)*16192.0)) #

/* generate ftables */

i_	=  0

loop_01:

i_cps_	=  $MIDI2CPS(i_)
i__	=  int(i_+256.5)
idummy	ftgen i__, 0, 16384, 11, \
		int(sr/(2*i_cps_)), 1, 1.0
	tableigpw i__
i_	=  int(i_+1.5)
	if (i_<127.5) igoto loop_01

/* ------------------------------------------- */

#define LP1FRQ # 10.0 #

	seed 0

ga0x	init 0

	instr 1

p3	=  p3 + 0.2

icps	=  $MIDI2CPS(p4)
iamp	=  $VELOC2AMP(p5)
iazm	=  p6
ielv	=  0
idst	=  1

ifnum	limit p4, 0, 127	/* ftable */
ifnum	=  int(ifnum+256.5)	/* number */

itrns	=  icps*(16384/sr)	/* transpose */

iovrlp	=  32		/* number of overlaps */

iamp	=  iamp*3500000/sqrt(icps)

/* ---- OSC 1 ------------------------------- */

iamp1	=  0.35		/* amplitude	      */
ifmd1	=  0.01*icps	/* fm depth	      */
iwsiz1	=  32.0/icps	/* window size        */
iffrq1	=  icps*1.0	/* filter freq        */
ifbwd1	=  icps*1.0	/* filter bandwidth   */

/* ---- OSC 2 ------------------------------- */

iamp2	=  1.0		/* amplitude	      */
ifmd2	=  0.01*icps	/* fm depth	      */
iwsiz2	=  32.0/icps	/* window size        */
iffrq2	=  800		/* filter freq        */
ifbwd2	=  80		/* filter bandwidth   */

/* ---- OSC 3 ------------------------------- */

iamp3	=  0.6		/* amplitude	      */
ifmd3	=  0.01*icps	/* fm depth	      */
iwsiz3	=  32.0/icps	/* window size        */
iffrq3	=  1150		/* filter freq        */
ifbwd3	=  90		/* filter bandwidth   */

/* ---- OSC 4 ------------------------------- */

iamp4	=  0.1		/* amplitude	      */
ifmd4	=  0.01*icps	/* fm depth	      */
iwsiz4	=  32.0/icps	/* window size        */
iffrq4	=  2800		/* filter freq        */
ifbwd4	=  120		/* filter bandwidth   */

/* ---- OSC 5 ------------------------------- */

iamp5	=  0.03		/* amplitude	      */
ifmd5	=  0.02*icps	/* fm depth	      */
iwsiz5	=  16.0/icps	/* window size        */
iffrq5	=  3500		/* filter freq        */
ifbwd5	=  130		/* filter bandwidth   */

/* ---- OSC 6 ------------------------------- */

iamp6	=  0.005	/* amplitude	      */
ifmd6	=  0.02*icps	/* fm depth	      */
iwsiz6	=  8.0/icps	/* window size        */
iffrq6	=  4950		/* filter freq        */
ifbwd6	=  140		/* filter bandwidth   */

/* ---- OSC 7 ------------------------------- */

iamp7	=  0.0035	/* amplitude	      */
ifmd7	=  0.02*icps	/* fm depth	      */
iwsiz7	=  4.0/icps	/* window size        */
iffrq7	=  12000	/* filter freq        */
ifbwd7	=  8000		/* filter bandwidth   */

/* ------------------------------------------ */

#define OSCILLATOR(nnum) #

aphs		unirand 1.0
atrns		trirand 1.0
atrns		=  ( (ifmd$nnum/icps)*atrns +	\
			1.0 )*itrns
idens$nnum	=  iovrlp/iwsiz$nnum
a$nnum		fog 1.0, idens$nnum, atrns,	\
			aphs, 0, 0, 0,		\
			iwsiz$nnum,		\
			iwsiz$nnum,		\
			64, ifnum, 1, 3600, 0, 0
a$nnum		butterbp a$nnum, iffrq$nnum,	\
			ifbwd$nnum
a$nnum		butterbp a$nnum, iffrq$nnum,	\
			ifbwd$nnum
a0		=  a0 + a$nnum*iamp$nnum

#

a0	=  0

$OSCILLATOR(1)
$OSCILLATOR(2)
$OSCILLATOR(3)
$OSCILLATOR(4)
$OSCILLATOR(5)
$OSCILLATOR(6)
$OSCILLATOR(7)

aamp	linseg 1, p3-0.2, 1, 0.1, 0, 1, 0
aamp	=  aamp*aamp
a0x	=  a0*iamp*aamp

ga0x	=  ga0x + a0x	/* send to output */

a_	=  a0x

i_az_	=  iazm
i_el_	=  ielv
i_d_	=  idst

$SPATMACRO

	outs a_L_, a_R_

	endin

	instr 90

	soundout ga0x, $OUTFLNAME, 6
ga0x	=  0

	endin



</CsInstruments>
<CsScore>

t 0 140.00			/* tempo */

i 1	0.0000	2.0000	60	127	-90
i 1	3.0000	2.0000	67	127	90

i 1	6.0000	4.0000	67	100	60
i 1	6.0000	4.0000	74	100	-60

i 1	12.000	4.0000	60	88	-30
i 1	12.000	4.0000	65	88	30
i 1	12.000	4.0000	67	88	-80
i 1	12.000	4.0000	74	88	80

i 1	18.000	4.0000	38	88	0
i 1	18.000	4.0000	57	80	90
i 1	18.000	4.0000	62	80	-90
i 1	18.000	4.0000	69	80	90
i 1	18.000	4.0000	74	88	40
i 1	18.000	4.0000	76	88	-40
i 1	18.000	4.0000	77	88	-90

#define x1(strt) #

i 1	[ $strt + 0.000 ]	0.1500	62 \
		120	-90
i 1	[ $strt + 0.240 ]	0.1500	62 \
		127	-90
i 1	[ $strt + 0.505 ]	0.3200	62 \
		124	0
i 1	[ $strt + 1.000 ]	0.1500	62 \
		120	90
i 1	[ $strt + 1.240 ]	0.1500	62 \
		127	90
i 1	[ $strt + 1.505 ]	0.3200	62 \
		124	0

#

#define x2(strt'note'p1'p2) #

i 1	[ $strt + 0.000 ]	0.1500 \
		$note	127	p1
i 1	[ $strt + 0.240 ]	0.1500 \
		$note	120	<
i 1	[ $strt + 0.490 ]	0.3200 \
		$note	126	<
i 1	[ $strt + 0.995 ]	0.3400 \
		$note	124	<
i 1	[ $strt + 1.500 ]	0.1250 \
		$note	127	<
i 1	[ $strt + 1.755 ]	0.1250 \
		$note	127	p2

#

$x1(24)
$x1(26)
$x1(28)
$x1(30)
$x1(32)
$x1(34)
$x1(36)
$x1(38)

$x2(24'69'-90'-45)
$x2(26'69'-45' 0)
$x2(28'67' 0'45)
$x2(30'67'45'90)

$x2(32'65'90'90)
$x2(34'65'90'90)
$x2(36'67'90'90)
$x2(38'67'90'90)

$x2(32'70'60'30)
$x2(34'70'30' 0)
$x2(36'72' 0'-40)
$x2(38'72'-40'-80)

i 90	0.0000	42.000

f 1 0 16384 20 3 1		/* window */
				/* function */
e



</CsScore>
</CsoundSynthesizer>
