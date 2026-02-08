<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from king1.orc and king1.sco
; Original files preserved in same directory

sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2

;ORC CODE OF AN ECLECTIC INSTRUMENT I CALL THE SHBASHRINGER

		instr 1
ipitch	=		cpspch(p4)
iloud	=		(ipitch<440?10000:14000)
kvib 	line 	ipitch*.02,p3,ipitch* -0.02
kias		=		ipitch*kvib
klate 	line 	1,p3,10000
kline 	line 	iloud,p3,1
krise1 	line 	1,p3,2500
krise2 	line 	2500,p3,1
irise	=		(p3>1?p3/3:p3/6)
idur		=		p3/3
idec		=		(p3>2?p3/3:p3/6)
kamp		=		(p3>1?8000:6000)
klamp     linen 	kamp, irise, idur, idec
a1  		oscil 	klamp/4,kias,1 ;reed
a2  		oscil 	klamp/4, kias,2 ;string
a3  		pluck     kline,ipitch/2,ipitch/3,3,3,0
a4 	     pluck 	kline*.5,ipitch*.33,ipitch*.24,0,4,0,4
a5  		pluck 	klate,ipitch,ipitch*.5,0,4,1,4
a6  		fof 		krise1,a4,84,0,25,.003,.02,.007,500,2,4,p3,.5,2;deceased choir boy 1
a7  		fof	     krise2,a5,110,0,55,.003,.02,.007,500,2,4,p3,.5,2;deceased choir boy 2
aleft	=		a7+a5+a3+a1
aright	=		a6+a4+a2
		outs	 	aleft,aright
		endin

</CsInstruments>
<CsScore>
;SCO CODE FOR A PROPER TEST DRIVE
f1 0 2048 10 1 1 1 1 1 .9 .8 .7 .6 .5 .4 .3 .2 .1
f2 0 4096 10 1 0 .5 0 .35 0 .17 0 .09 0 .045 0
f3 0 2048 10 1 .5 .7 .5 .6 .5 .5 .5 .4 .5 .3 .5 .2
f4 0 2048	 7 0 0 1 128 2 256 3 512

i1 0 1 8.00
i1 0 1 7.00
i1 0 .25 6.00
i1 .25 .25 6.04
i1 .5 .25 6.07
i1 .75 .25 6.04
i1 1 .25 5.00
i1 1.25 .25 5.04
i1 1.50 .25 5.07
i1 1.75 .25 5.04
i1 2 . 4.00
i1 2.25 . 4.04
i1 2.50 . 4.07
i1 2.75 . 4.04
i1 1 .5 8.04
i1 1 .5 6.11
i1 1.5 2 8.02
i1 1.5 2 6.07
i1 3.5 4 8.09
i1 3.53 3.97 6.02
i1 3.5 .25 9.09
i1 3.75 . 9.11
i1 4 . 10.00
i1 4.25 . 10.04
i1 4.50 . 10.07
i1 4.75 . 10.09
i1 5	 2  11.00
e

</CsScore>
</CsoundSynthesizer>
