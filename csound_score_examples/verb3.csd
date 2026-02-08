<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from verb3.orc and verb3.sco
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
ioutch1 	=      	p7
ioutch2 	=      	p8

ain1, ain2 diskin isndin, irate

        	zaw    	ain1, ioutch1
        	zaw    	ain2, ioutch2
        	outs   	ain1*iamp, ain2*iamp

        	endin

;----------------------------------------------------------------------------------
; NOISE CLICK FOR TESTING THE DECAY CURVE OF THE REVERB.
;----------------------------------------------------------------------------------
       	instr  4

idur   	=      	p3
iamp   	=      	p4
ioutch 	=      	p5
ifco   	=      	p6

kamp   	linseg 	0, .002, iamp, .002, 0, idur-.004, 0
aout   	rand   	kamp

       	zaw    	aout, ioutch
       	outs   	aout, aout

       	endin

;----------------------------------------------------------------------------------
; BAND-LIMITED IMPULSE
;----------------------------------------------------------------------------------
       	instr  5

iamp   	=      	p4
ifqc   	=      	cpspch(p5)
ioutch 	=      	p6

apulse 	buzz    	1,ifqc, sr/2/ifqc, 1     		 	; AVOID ALIASING

       	zaw     	apulse*iamp, ioutch
       	outs    	apulse*iamp, apulse*iamp

       	endin

;----------------------------------------------------------------------------------
; 4 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  27

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/4
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
ifco3   	=        	p7*p9/(p9+p11*(1-p8))
ifco4   	=        	p7*p9/(p9+p12*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
itim3   	=        	p11/1000
itim4   	=        	p12/1000
ioutch  	=        	p13
ifchp   	=        	p14

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0
aflt4   	init     	0

asig    	zar      	iinch


adel1   	delay   	asig+( aflt1+aflt2-aflt3-aflt4)*ifdbk, itim1 ; Loop 1
adel2   	delay   	asig+(-aflt1+aflt2-aflt3+aflt4)*ifdbk, itim2 ; Loop 2
adel3   	delay  	asig+( aflt1-aflt2+aflt3-aflt4)*ifdbk, itim3 ; Loop 3
adel4   	delay   	asig+(-aflt1-aflt2+aflt3+aflt4)*ifdbk, itim4 ; Loop 4

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
; 3 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  28

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/3
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
ifco3   	=        	p7*p9/(p9+p11*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
itim3   	=        	p11/1000
ioutch  	=        	p12

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0

asig    	zar      	iinch

adel1   	delay    	asig+( aflt1-aflt2-aflt3)*ifdbk, itim1 ; Loop 1
adel2   	delay    	asig+(-aflt1+aflt2-aflt3)*ifdbk, itim2 ; Loop 2
adel3   	delay    	asig+(-aflt1-aflt2+aflt3)*ifdbk, itim3 ; Loop 3

aflt1   	butterlp 	adel1, ifco1
aflt2   	butterlp 	adel2, ifco2
aflt3   	butterlp 	adel3, ifco3

aout    	=        	aflt1+aflt2+aflt3 				; COMBINE OUTPUTS
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 2 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  29

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/2
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
ioutch  	=       	p11

aflt1   	init     	0
aflt2   	init     	0

asig    	zar      	iinch

adel1   	delay    	asig+(aflt1-aflt2)*ifdbk, itim1
adel2   	delay    	asig+(aflt2-aflt1)*ifdbk, itim2

aflt1   	butterlp 	adel1, ifco1
aflt2   	butterlp 	adel2, ifco2

aout    	=        	aflt1+aflt2
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 3 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  34

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/3
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
ifco3   	=        	p7*p9/(p9+p11*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
itim3   	=        	p11/1000
ioutch  	=       	p12
ifchp   	=       	p13

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0

asig    	zar      	iinch

adel1   	delay    	asig+( aflt1-aflt2-aflt3)*ifdbk, itim1 ; Loop 1
adel2   	delay    	asig+(-aflt1+aflt2-aflt3)*ifdbk, itim2 ; Loop 2
adel3   	delay    	asig+(-aflt1-aflt2+aflt3)*ifdbk, itim3 ; Loop 3

aflt11  	butterlp 	adel1, ifco1
aflt21  	butterlp 	adel2, ifco2
aflt31  	butterlp 	adel3, ifco3
aflt1   	butterlp 	aflt11, ifchp
aflt2   	butterlp 	aflt21, ifchp
aflt3   	butterlp 	aflt31, ifchp

aout    	=        	aflt1+aflt2+aflt3 					; COMBINE OUTPUTS
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 2 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  35

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/2
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
ioutch  	=       	p11
ifchp   	=        	p12

aflt1   	init     	0
aflt2   	init     	0

asig    	zar      	iinch

adel1   	delay    	asig+(aflt1-aflt2)*ifdbk, itim1
adel2   	delay    	asig+(aflt2-aflt1)*ifdbk, itim2

aflt11  	butterlp 	adel1, ifco1
aflt21  	butterlp 	adel2, ifco2
aflt1   	butterhp 	aflt11, ifchp
aflt2   	butterhp 	aflt21, ifchp

aout    	=        	aflt1+aflt2
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 4 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        instr  36

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/4
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
ifco3   	=        	p7*p9/(p9+p11*(1-p8))
ifco4   	=        	p7*p9/(p9+p12*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
itim3   	=        	p11/1000
itim4   	=        	p12/1000
ioutch  	=        	p13
ifchp   	=        	p14

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0
aflt4   	init     	0

;asig    	zar      	iinch
asig1   	zar      	iinch
asig    	reverb2  	asig1, .5, 1

adel1   	delay   	asig+( aflt1+aflt2-aflt3-aflt4)*ifdbk, itim1 ; Loop 1
adel2   	delay   	asig+(-aflt1+aflt2-aflt3+aflt4)*ifdbk, itim2 ; Loop 2
adel3   	delay   	asig+( aflt1-aflt2+aflt3-aflt4)*ifdbk, itim3 ; Loop 3
adel4   	delay   	asig+(-aflt1-aflt2+aflt3+aflt4)*ifdbk, itim4 ; Loop 4

; FC, VOL, Q
aflt1   	pareq     adel1,  ifco1, .5, .4, 2
aflt2   	pareq     adel2,  ifco2, .5, .4, 2
aflt3   	pareq     adel3,  ifco3, .5, .4, 2
aflt4   	pareq     adel4,  ifco4, .5, .4, 2

;arvb    	reverb2  	aflt1+aflt2+aflt3+aflt4, .5, .5
;aout    	butterhp 	arvb, 140 ; Combine outputs
aout    	butterhp 	aflt1+aflt2+aflt3+aflt4, 140 				; COMBINE OUTPUTS

        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 3 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  37

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/3
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
ifco3   	=        	p7*p9/(p9+p11*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
itim3   	=        	p11/1000
ioutch  	=        	p12

aflt1   	init     	0
aflt2   	init     	0
aflt3   	init     	0

asig1   	zar      	iinch
asig    	reverb2  	asig1, .5, 1
;asig    	zar      	iinch

adel1   	delay    	asig+( aflt1-aflt2-aflt3)*ifdbk, itim1 ; Loop 1
adel2   	delay    	asig+(-aflt1+aflt2-aflt3)*ifdbk, itim2 ; Loop 2
adel3   	delay    	asig+(-aflt1-aflt2+aflt3)*ifdbk, itim3 ; Loop 3

aflt1   	pareq     adel1, ifco1, .5, .4, 2
aflt2  	pareq     adel2, ifco2, .5, .4, 2
aflt3   	pareq     adel3, ifco3, .5, .4, 2

;arvb    	reverb2  	aflt1+aflt2+aflt3, .5, .5
aout    	butterhp 	aflt1+aflt2+aflt3, 140 				; COMBINE OUTPUTS
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; 2 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
        	instr  38

idur    	=        	p3
iamp    	=        	p4
iinch   	=        	p5
ifdbk   	=        	p6/2
ifco1   	=        	p7
ifco2   	=        	p7*p9/(p9+p10*(1-p8))
itim1   	=        	p9/1000
itim2   	=        	p10/1000
ioutch  	=        	p11

aflt1   	init     	0
aflt2   	init     	0

asig1   	zar      	iinch
asig    	reverb2  	asig1, .5, 1
;asig    	zar      	iinch

adel1   	delay    	asig+(aflt1-aflt2)*ifdbk, itim1
adel2   	delay    	asig+(aflt2-aflt1)*ifdbk, itim2

aflt1   	pareq     adel1, ifco1, .5, .4, 2
aflt2   	pareq     adel2, ifco2, .5, .4, 2

;aout    	butterhp 	arvb, 140 						; COMBINE OUTPUTS
aout    	butterhp 	aflt1+aflt2, 140
        	zaw      	aout, ioutch

        	endin

;----------------------------------------------------------------------------------
; Output For Mono Reverb
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
; OUTPUT FOR STEREO REVERB
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

a0 0  47
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
;    Sta  Dur   Amp  InCh  FdBack  Fco   Fadj   Time1  Time2  OutCh
i29  5.0  5.0   1    1     .45     8070  .8     259    453    5
i29  5.0  5.0   1    2     .45     8070  .8     241    451    6
;    Sta  Dur   Amp  InCh1  InCh2
i91  5.0  5.0   .5   5      6

;----------------------------------------------------------------------
; BATHROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 10   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack   Fco   Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 10.0  5.0  1    1     1.1      8000  .8    25     45     58     73     3      200
i27 10.0  5.0  1    2     1.1      8000  .8    22     41     53     77     4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 10.0  5.0   .4   3      4

;----------------------------------------------------------------------
; LIVE ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 15   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack   Fco   Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 15.0  5.0  1    1     1.1      8010  .8    45     73     104    163    3      200
i27 15.0  5.0  1    2     1.1      8200  .8    42     74     103    154    4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 15.0  5.0   .4   3      4

;----------------------------------------------------------------------
; MEDIUM ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 20   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack   Fco1  Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 20.0  5.0  1    1     1.0      4010  .8    45     73     104    163    3      200
i27 20.0  5.0  1    2     1.0      4200  .8    42     74     103    154    4      200
;    Sta  Dur   Amp  InCh1  InCh2
i91 20.0  5.0   .4   3      4

;----------------------------------------------------------------------
; DEAD ROOM REVERB
;----------------------------------------------------------------------
;  Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3 25   2.4  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack   Fco   Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27 25.0  5.0  1    1     .25      2010  .8    45     73     104    163    3      100
i27 25.0  5.0  1    2     .25      2200  .8    42     74     103    154    4      100
;    Sta  Dur   Amp  InCh1  InCh2
i91 25.0  5.0   .4   3      4

;----------------------------------------------------------------------
; LIVE LARGE ROOM REVERB
;----------------------------------------------------------------------
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3   30   2.4  .8   1     11       1       2
;    Sta  Dur   Amp  InCh  FdBack   Fco   Fadj  Time1  Time2  Time3  OutCh
i28  30.0 5.0   1    1     1.2      8070  .8    68     154    273    3
i28  30.0 5.0   1    2     1.2      8260  .8    61     152    277    4
;    Sta  Dur   Amp  InCh1  InCh2
i91  30.0 5.0   .2   3      4

;----------------------------------------------------------------------
; DEAD LARGE ROOM REVERB
;----------------------------------------------------------------------
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3   35   2.4  .8   1     11       1       2
;    Sta  Dur   Amp  InCh  FdBack   Fco   Fadj  Time1  Time2  Time3  OutCh
i28  35.0 5.0   1    1     1.2      4070  .8    68     154     273   3
i28  35.0 5.0   1    2     1.2      4260  .8    61     152     277   4
;    Sta  Dur   Amp  InCh1  InCh2
i91  35.0 5.0   .2   3      4

;----------------------------------------------------------------------
; CATHEDRAL REVERB
;----------------------------------------------------------------------
;    Sta   Dur  Amp   Rate  Soundin  OutCh1  OutCh2
i3   40    2.4  .8    1     11       1       2
;    Sta   Dur  Amp   InCh  FdBack   Fco1  Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27  40.0  7.0  1     1     1.1      8010  .8    75     163    294    493    3      200
i27  40.0  7.0  1     2     1.1      8200  .8    72     164    293    474    4      200
;    Sta   Dur   Amp  InCh  FdBack1  Fco   Fadj  Time1  Time2  Time3  OutCh
i28  40.0  7.0   1    3     1.2      6070  .8    68    204    373     5
i28  40.0  7.0   1    4     1.2      6260  .8    61    202    377     6
;    Sta   Dur   Amp  InCh1  InCh2
i91  40.0  7.0   .1   3      4
i91  40.0  7.0   .1   5      6

;----------------------------------------------------------------------
; CAVEMAN
;----------------------------------------------------------------------
; IMPULSE RESPONSE
;  Sta  Dur  Amp    OutCh  Fco
;i1 47   .1   30000  1      8000
;    Sta  Dur  Amp  Rate  Soundin  OutCh1  OutCh2
i3   47   2.5  .8   1     11       1       2
;    Sta  Dur  Amp  InCh  FdBack  Fco   Fadj  Time1  Time2  Time3  Time4  OutCh  HPFco
i27  47.0 5.0  1    1     0.7     8000  .6    19     68     234    590    3      400
i27  47.0 5.0  1    1     0.7     8000  .6    25     71     229    594    4      400
;    Sta  Dur  Amp  InCh  FdBack  Fco   Fadj  Time1  Time2  Time3  OutCh  FcHP
i34  47.0 5.0  1    3     0.5     6000  .7    48     207    353    5      1000
i34  47.0 5.0  1    4     0.5     6000  .7    52     202    337    6      1000
;    Sta  Dur  Amp  InCh  FdBack  Fco   Fadj Time1  Time2  Time3  OutCh  FcHP
i34  47.0 5.0  1    3     0.8     8200  .9   110    174    453    7      1300
i34  47.0 5.0  1    4     0.8     8200  .9   105    182    417    8      1300
;    Sta  Dur  Amp  InCh  FdBack  Fco   Fadj  Time1  Time2  OutCh  FcHP
i35  47.0 5.0  1    5     0.8     8800  .8    143    353    9      1800
i35  47.0 5.0  1    6     0.8     8800  .8    131    321    10     1800
;    Sta  Dur  Amp  InCh1  InCh2
i91  47.0 5.0  .25  3      4
i91  47.0 5.0  .26  5      6
i91  47.0 5.0  .22  7      8
i91  47.0 5.0  .35  9      10



</CsScore>
</CsoundSynthesizer>
