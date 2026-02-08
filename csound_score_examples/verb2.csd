<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from verb2.orc and verb2.sco
; Original files preserved in same directory

sr		=		44100
kr		=		22050
ksmps	=		2
nchnls	=		2

		zakinit 	30,30

;----------------------------------------------------------------------------------
; NOISE CLICK FOR TESTING THE DECAY CURVE OF THE REVERB.
;----------------------------------------------------------------------------------
       	instr  1

idur   	=      	p3
iamp   	=      	p4
ioutch 	=      	p5
ifco   	=      	p6

kamp   	linseg 	0, .002, iamp, .002, 0, idur-.004, 0
aout   	rand   	kamp

afilt  	butterlp 	aout, ifco
       	zaw    	afilt, ioutch
       	outs   	aout, aout

       	endin

;----------------------------------------------------------------------------------
; DISK INPUT MONO
;----------------------------------------------------------------------------------
       	instr  2

iamp   	=      	p4
irate  	=      	p5
isndin 	=      	p6
ioutch 	=      	p7

ain    	diskin 	isndin, irate
       	zaw    	ain, ioutch
       	outs   	ain*iamp, ain*iamp

       	endin
;----------------------------------------------------------------------------------
; DISK INPUT STEREO
;----------------------------------------------------------------------------------
        	instr  3

iamp    	=      	p4
irate   	=      	p5
isndin  	=      	p6
ioutch1 	=     	p7
ioutch2 	=      	p8

ain1, ain2 diskin isndin, irate

        	zaw    	ain1, ioutch1
        	zaw    	ain2, ioutch2
        	outs   	ain1*iamp, ain2*iamp

        	endin

;----------------------------------------------------------------------------------
; BAND-LIMITED IMPULSE
;----------------------------------------------------------------------------------
       	instr  5

iamp   	=      	p4
ifqc   	=      	cpspch(p5)
ioutch 	=      	p6

apulse 	buzz    	1,ifqc, sr/2/ifqc, 1 				; AVOID ALIASING

       	zaw     	apulse*iamp, ioutch
       	outs    	apulse*iamp, apulse*iamp

       	endin

;----------------------------------------------------------------------------------
; HANS REVERB 1
;----------------------------------------------------------------------------------
        	instr  27

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk1  	=        	p6
ifdbk2  	=        	p7
ifdbk3  	=        	p8
ifdbk4  	=        	p9
ifco1   	=        	p10
ifco2   	=        	p11
ifco3   	=        	p12
ifco4   	=        	p13
itim1   	=        	p14/1000
itim2   	=        	p15/1000
itim3   	=        	p16/1000
itim4   	=        	p17/1000
ioutch  	=        	p18
ifchp   	=        	p19

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0
aflt4   	init     	0

asig    	zar      	iinch


adel1   	delay   	asig+ifdbk1*aflt1+ifdbk2*aflt2-ifdbk3*aflt3-ifdbk4*aflt4, itim1 	; LOOP 1
adel2   	delay   	asig-ifdbk1*aflt1+ifdbk2*aflt2-ifdbk3*aflt3+ifdbk4*aflt4, itim2 	; LOOP 2
adel3   	delay   	asig+ifdbk1*aflt1-ifdbk2*aflt2+ifdbk3*aflt3-ifdbk4*aflt4, itim3 	; LOOP 3
adel4   	delay   	asig-ifdbk1*aflt1-ifdbk2*aflt2+ifdbk3*aflt3+ifdbk4*aflt4, itim4 	; LOOP 4

aflt11  	butterlp 	adel1,  ifco1
aflt21  	butterlp 	adel2,  ifco2
aflt31  	butterlp 	adel3,  ifco3
aflt41  	butterlp 	adel4,  ifco4
aflt1   	butterhp 	aflt11, ifchp
aflt2   	butterhp 	aflt21, ifchp
aflt3   	butterhp 	aflt31, ifchp
aflt4   	butterhp 	aflt41, ifchp

aout    	=        	aflt1+aflt2+aflt3+aflt4 				; COMBINE OUTPUTS

        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; HANS REVERB 2
;----------------------------------------------------------------------------------
        	instr  28

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk1  	=        	p6
ifdbk2  	=        	p7
ifdbk3  	=        	p8
ifco1   	=        	p9
ifco2   	=        	p10
ifco3   	=        	p11
itim1   	=        	p12/1000
itim2   	=        	p13/1000
itim3   	=        	p14/1000
ioutch  	=       	 p15

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0

asig    	zar      	iinch

adel1   	delay   	asig+ifdbk1*aflt1-ifdbk2*aflt2-ifdbk3*aflt3, itim1 		; LOOP 1
adel2   	delay    	asig-ifdbk1*aflt1+ifdbk2*aflt2-ifdbk3*aflt3, itim2 		; LOOP 2
adel3   	delay    	asig-ifdbk1*aflt1-ifdbk2*aflt2+ifdbk3*aflt3, itim3 		; LOOP 3

aflt1   	butterlp 	adel1, ifco1
aflt2   	butterlp 	adel2, ifco2
aflt3   	butterlp 	adel3, ifco3

aout    	=        	aflt1+aflt2+aflt3 					; COMBINE OUTPUTS
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; HANS REVERB 3
;----------------------------------------------------------------------------------
        	instr  29

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk1  	=       	p6
ifdbk2  	=       	p7
ifco1   	=       	p8
ifco2   	=        	p9
itim1   	=        	p10/1000
itim2   	=        	p11/1000
ioutch  	=        	p12

aflt1   	init     	0
aflt2   	init     	0

asig    	zar      	iinch

adel1   	delay    	asig+aflt1*ifdbk1-aflt2*ifdbk2, itim1
adel2   	delay    	asig-aflt1*ifdbk1+aflt2*ifdbk2, itim2

aflt1   	butterlp 	adel1, ifco1
aflt2   	butterlp 	adel2, ifco2

aout    	=        	aflt1+aflt2
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; OUTPUT FOR REVERB
;----------------------------------------------------------------------------------
       	instr  90

idur   	=      	p3
igain  	=      	p4
iinch  	=      	p5

kdclik 	linseg 	0, .002, igain, idur-.004, igain, .002, 0

ain    	zar    	iinch
       	outs   	ain*kdclik, -ain*kdclik  ; INVERTING ONE SIDE MAKES THE SOUND
       	endin                           	; SEEM TO COME FROM ALL AROUND YOU.
                                       		; THIS MAY CAUSE SOME PROBLEMS WITH CERTAIN
                                       		; SURROUND SOUND SYSTEMS

;----------------------------------------------------------------------------------
; OUTPUT FOR REVERB
;----------------------------------------------------------------------------------
       	instr  91

idur   	=      	p3
igain  	=      	p4
iinch1 	=      	p5
iinch2 	=      	p6

kdclik 	linseg 	0, .002, igain, idur-.004, igain, .002, 0

ain1   	zar    	iinch1
ain2   	zar    	iinch2
       	outs   	ain1*kdclik, ain2*kdclik

       	endin

;----------------------------------------------------------------------------------
; MONO OUTPUT FOR REVERB
;----------------------------------------------------------------------------------
       	instr  92

idur   	=      	p3
igain  	=      	p4
iinch1 	=      	p5

kdclik 	linseg 	0, .002, igain, idur-.004, igain, .002, 0

ain1   	zar    	iinch1
       	outs  	ain1*kdclik, ain1*kdclik

       	endin

;----------------------------------------------------------------------------------
; CLEAR ZAK
;----------------------------------------------------------------------------------
       	instr   99
       	zacl    	0,30
       	endin


</CsInstruments>
<CsScore>
;----------------------------------------------------------------------
; MULTI-FEEDBACK REVERBS
; CODED SEPTEMBER 1998
; BY HANS MIKELSON
;----------------------------------------------------------------------

f1 0 8192 10 1

a0 0 47

;----------------------------------------------------------------------
; IMPULSE RESPONSE
;----------------------------------------------------------------------
;  Sta  Dur  Amp    OutCh  Fco
;i1 0    .1   30000  1      5000

;----------------------------------------------------------------------
; DRY SOUND
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 0    2.4  .8   1     11       1       2

;----------------------------------------------------------------------
; ECHO REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 5    2.4  .8   1     11       1       2
;    Sta  Dur   Amp  InCh  FdBack1  FdBack2  Fco1  Fco2  Time1  Time2  OutCh
i29  5.0  5.0   1    1     .45      .45      8070  6303  259    453    5
i29  5.0  5.0   1    2     .45      .45      8260  6703  241    451    6
;    Sta  Dur   Amp  InCh1  InCh2
i91  5.0  5.0   .5   5      6

;----------------------------------------------------------------------
; BATHROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 10   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 10.0  5.0  1    1     .28      .28      .28      .28      8010  6500  5140  4200  25     45     58     73     3      200
i27 10.0  5.0  1    2     .28      .28      .28      .28      8200  6530  5100  4220  22     41     53     77     4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 10.0  5.0   .4   3      4

;----------------------------------------------------------------------
; LIVE ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 15   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 15.0  5.0  1    1     .28      .28      .28      .28      8010  6500  5140  4200  45     73     104    163     3      200
i27 15.0  5.0  1    2     .28      .28      .28      .28      8200  6530  5100  4220  42     74     103    154     4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 15.0  5.0   .4   3      4

;----------------------------------------------------------------------
; MEDIUM ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 20   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 20.0  5.0  1    1     .25      .25      .25      .25      4010  3500  2140  1200  45     73     104    163     3      200
i27 20.0  5.0  1    2     .25      .25      .25      .25      4200  3530  2100  1220  42     74     103    154     4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 20.0  5.0   .4   3      4

;----------------------------------------------------------------------
; DEAD ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 25   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 25.0  5.0  1    1     .25      .25      .25      .25      2010  1500  840   400   45     73     104    163    3      100
i27 25.0  5.0  1    2     .25      .25      .25      .25      2200  1530  800   420   42     74     103    154    4      100
;    Sta  Dur   Amp  InCh1  InCh2
i91 25.0  5.0   .4   3      4

;----------------------------------------------------------------------
; LIVE LARGE ROOM REVERB
;----------------------------------------------------------------------
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3   30   2.4  .8   1     11       1       2
;    Sta  Dur   Amp  InCh  FdBack1  FdBack2  FdBack3  Fco1  Fco2  Fco3  Time1  Time2  Time3  OutCh
i28  30.0 5.0   1    1     .4       .4       .4       8070  6303  4083  68     154    273     3
i28  30.0 5.0   1    2     .4       .4       .4       8260  6703  4083  61     152    277     4
;    Sta  Dur   Amp  InCh1  InCh2
i91  30.0 5.0   .2   3      4

;----------------------------------------------------------------------
; DEAD LARGE ROOM REVERB
;----------------------------------------------------------------------
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3   35   2.4  .8   1     11       1       2
;    Sta  Dur   Amp  InCh  FdBack1  FdBack2  FdBack3  Fco1  Fco2  Fco3  Time1  Time2  Time3  OutCh
i28  35.0 5.0   1    1     .4       .4       .4       4070  2303  1083  68     154     273     3
i28  35.0 5.0   1    2     .4       .4       .4       4260  2703  1083  61     152     277     4
;    Sta  Dur   Amp  InCh1  InCh2
i91  35.0 5.0   .2   3      4

;----------------------------------------------------------------------
; CATHEDRAL REVERB
;----------------------------------------------------------------------
;    Sta   Dur  Amp   Rate  Soundin  OutCh1  OutCh2
i3   40    2.4  .8    1     11       1       2
;    Sta   Dur  Amp   InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27  40.0  7.0  1     1     .28      .28      .28      .28      8010  6500  4140  2200  75     163    294    493     3      200
i27  40.0  7.0  1     2     .28      .28      .28      .28      8200  6530  4100  2220  72     164    293    474     4      200
;    Sta   Dur   Amp  InCh  FdBack1  FdBack2  FdBack3  Fco1  Fco2  Fco3  Time1  Time2  Time3  OutCh
i28  40.0  7.0   1    3     .45      .47      .48      6070  4303  2083  68     204    373     5
i28  40.0  7.0   1    4     .45      .47      .48      6260  4703  2083  61     202    377     6
;    Sta   Dur   Amp  InCh1  InCh2
i91  40.0  7.0   .1   3      4
i91  40.0  7.0   .1   5      6

;----------------------------------------------------------------------
; SMOOTHIE
;----------------------------------------------------------------------
; IMPULSE RESPONSE
;  Sta  Dur  Amp    OutCh  Fco
i1 47   .1   30000  1      8000
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
;i3   47   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  FdBack4  Fco1  Fco2  Fco3  Fco4  Time1  Time2  Time3  Time4  OutCh  HPFco
i27  47.0 5.0  1    1     .20      .20      .20      .20      8010  6500  4140  3200  16     43     74     143    3      100
i27  47.0 5.0  1    1     .20      .20      .20      .20      8200  6530  4100  3220  13     54     69     144    4      100
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  Fco1  Fco2  Fco3  Time1  Time2  Time3  OutCh
i28  47.0 5.0  1    3     .38      .38      .38      6070  4303  3083  28     84     133    5
i28  47.0 5.0  1    4     .38      .38      .38      6260  4103  3083  31     92     127    6
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  FdBack3  Fco1  Fco2  Fco3  Time1  Time2  Time3  OutCh
i28  47.0 5.0  1    3     .38      .38      .38      4070  3303  2083  110    164    193    7
i28  47.0 5.0  1    4     .38      .38      .38      4260  3103  2083  105    172    187    8
;    Sta  Dur  Amp  InCh  FdBack1  FdBack2  Fco1  Fco2  Time1  Time2  OutCh
i29  47.0 5.0  1    5     .41      .41      1270  803   119    253    9
i29  47.0 5.0  1    6     .41      .41      1060  823   101    261    10
;    Sta  Dur  Amp  InCh1  InCh2
i91  47.0 5.0  .20  3      4
i91  47.0 5.0  .13  5      6
i91  47.0 5.0  .09  7      8
i91  47.0 5.0  .08  9      10



</CsScore>
</CsoundSynthesizer>
