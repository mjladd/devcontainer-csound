<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Duck401.orc and Duck401.sco
; Original files preserved in same directory

sr	=  44100
kr	=  44100
ksmps	=  1
nchnls	=  1

ga1	init 0
gad1	init 0
ga2	init 0
gad2	init 0

#define INPUTFILE1 # "infile1.sf" #
#define INPUTFILE2 # "infile2.sf" #

	instr 1

iamp	table	8,64
idel	table	9,64
idel1	table	4,64
ad1	soundin $INPUTFILE1,idel
a1	soundin $INPUTFILE1,idel+idel1
gad1	=  gad1+ad1*iamp
ga1	=  ga1+a1*iamp

	endin

	instr 2

iamp	table	10,64
idel	table	11,64
idel1	table	4,64
ad2	soundin $INPUTFILE2,idel
a2	soundin $INPUTFILE2,idel+idel1
gad2	=  gad2+ad2*iamp
ga2	=  ga2+a2*iamp

	endin

	instr 90

iamp	table	0,64	; output gain
imax1	table	1,64	; threshold level (RMS)
icomp1	table	2,64	; compression ratio below thr. level
icomp2	table	3,64	; compression ratio above thr. level
iatt	table	5,64	; RMS envelope attack speed
idec	table	6,64	; RMS envelope decay speed
ifrq1	table	7,64	; lowpass filter freq.
iduck1	table	12,64	; duck level
imin1	table	13,64	; min. thr. level
imin1	=  imin1*32768
imax1	=  imax1*32768
icomp1	=  icomp1-1
icomp2	=  icomp2-1
klvl	init 0
klvlx	init 0

ad1	=  gad2
a1	=  ga2
ad2	=  gad1
a2	=  ga1
gad1	=  0
ga1	=  0
gad2	=  0
ga2	=  0

atmp	=  a2*a2*iduck1*iduck1
ktmp	downsamp atmp
atmp	tone atmp,(ktmp>klvlx ? iatt:idec)
atmp	butterlp atmp,ifrq1
klvlx	downsamp atmp
kmax1	=  imax1-sqrt(klvlx<0.25 ? 0.25:klvlx)
kmax1	=  (kmax1<imin1 ? imin1:kmax1)

atmp	=  a1*a1
ktmp	downsamp atmp
atmp	tone atmp,(ktmp>klvl ? iatt:idec)
atmp	butterlp atmp,ifrq1
klvl	downsamp atmp
ktmp	=  sqrt(klvl<0.25 ? 0.25:klvl)/kmax1
ktmp	=  (ktmp<1 ? exp(log(ktmp)*icomp1):exp(log(ktmp)*icomp2))

	out (ad1*ktmp+ad2)*iamp

	endin


</CsInstruments>
<CsScore>
t 0.00	120.000	; tempo

i 1	0.0000	10.000	; 1. input file
i 2	0.0000	10.000	; 2. input file (compressed)

i 90	0.0000	10.000	; total length in beats

;------------------------------------------------------------------------------
f 64 0 16 -2	1.0	; output gain			COMPRESSOR PARAMETERS
		0.5	; threshold level (RMS)
		1.0	; compression ratio below thr. level
		1.0	; compression ratio above thr. level
		0.02	; time diff. between envelope and audio signal (sec.)
		100	; RMS envelope attack speed
		100	; RMS envelope decay speed
		25	; envelope lowpass filter frequency (Hz)
		1.0	; 1. input file gain		INPUT FILE PARAMETERS
		0.000	; 1. input file start position (sec.)
		1.0	; 2. input file gain
		0.000	; 2. input file start position (sec.)
		1.0	; 1. file RMS level to 2. file threshold
		0.25	; min. thr. level of compressor of 2nd input file
;------------------------------------------------------------------------------

e	; END OF SCORE

</CsScore>
</CsoundSynthesizer>
