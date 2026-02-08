<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from CHORUS.ORC and CHORUS.SCO
; Original files preserved in same directory

sr		=		44100
kr		=		22050
ksmps	=		2
nchnls	=		2

;---------------------------------------------------------------------------
; CHORUS EFFECTS
;---------------------------------------------------------------------------


		zakinit 	30, 30

;---------------------------------------------------------------------------
; PLUCK PHYSICAL MODEL
;---------------------------------------------------------------------------
       	instr  2

iamp   	=      	p4          ; AMPLITUDE
ifqc   	=      	cpspch(p5)  ; CONVERT TO FREQUENCY
itab1  	=      	p6          ; INITIAL TABLE
imeth  	=      	p7          ; DECAY METHOD
ioutch 	=      	p8          ; OUTPUT CHANNEL

aplk   	pluck  	iamp, ifqc, ifqc, itab1, imeth       ; PLUCK WAVEGUIDE MODEL
       	zawm   	aplk, ioutch                         ; WRITE TO OUTPUT
       	endin

;---------------------------------------------------------------------------
; LFO
;---------------------------------------------------------------------------
          instr   7
iamp      init    	p4
ifqc      init    	p5
itab1     init    	p6
iphase    init    	p7
ioffset   init    	p8
iout      init    	p9

koscil    oscil   	iamp, ifqc, itab1, iphase  		  ;TABLE OSCILLATOR
kout      =       	koscil+ioffset

          zkw     	kout, iout           			  ;SEND TO OUTPUT CHANNEL

          endin

;---------------------------------------------------------------------------
;LORENZ ATTRACTOR
;---------------------------------------------------------------------------
        	instr  8

iamp    	init   	p4/40
kx      	init   	p5
ky      	init   	p6
kz      	init   	p7
is      	init   	p8
ir      	init   	p9
ib      	init   	p10
ih      	init   	p11/10000
ioutch  	init   	p12
ioffset 	init   	p13

kxnew   	=      	kx+ih*is*(ky-kx)
kynew   	=      	ky+ih*(-kx*kz+ir*kx-ky)
kznew   	=      	kz+ih*(kx*ky-ib*kz)

kx      	=      	kxnew
ky      	=      	kynew
kz      	=      	kznew

		printk   .5, kx
		printk   .5, ky
		printk   .5, kz

        	zkw    	kx*iamp+ioffset, ioutch
        	endin

;---------------------------------------------------------------------------
; CHORUS
;---------------------------------------------------------------------------
         instr   35

imixch   	=       	p4             		; MIX OF CHORUSED SIGNAL
imix     	=       	1-imixch       		; MIX OF DIRECT SIGNAL
izin     	=       	p5            			; INPUT CHANNEL
izout    	=       	p6            			; OUTPUT CHANNEL
ikin     	=       	p7            			; INPUT K CHANNEL

asig     	zar     	izin           		; READ INPUT CHANNEL
kinsig   	zkr     	ikin           		; READ K INPUT

adel1    	vdelay  	asig, kinsig, 100      	; VARIABLE DELAY TAP
aout     	=       	adel1*imixch+asig*imix 	; MIX DIRECT AND CHORUSED SIGNALS

;aout     =       	kinsig*500
         	zaw     	aout, izout            	; WRITE TO OUTPUT CHANNEL

         	endin

;---------------------------------------------------------------------------
; MIXER SECTION
;---------------------------------------------------------------------------
          instr 100

asig1     zar   	p4             		; READ INPUT CHANNEL 1
igl1      init  	p5*sqrt(p6)    		; LEFT GAIN
igr1      init  	p5*sqrt(1-p6)  		; RIGHT GAIN

kdclick   linseg  	0, .001, 1, p3-.002, 1, .001, 0  ; DECLICK

asigl     =     	asig1*igl1       		; SCALE AND SUM
asigr     =     	asig1*igr1

          outs  	kdclick*asigl, kdclick*asigr   ; OUTPUT STEREO PAIR

          endin

;---------------------------------------------------------------------------
; CLEAR AUDIO & CONTROL CHANNELS
;---------------------------------------------------------------------------
          instr 	110

          zacl  	0, 30          		; CLEAR AUDIO CHANNELS 0 TO 30
          zkcl  	0, 30          		; CLEAR CONTROL CHANNELS 0 TO 30

          endin


</CsInstruments>
<CsScore>
;---------------------------------------------------------------------------
; WAVEFORMS
;---------------------------------------------------------------------------
; SINE WAVE
f1 0 8192 10 1
; TRIANGLE WAVE
f2 0 8192 7  -1  4096 1 4096 -1
; TRIANGLE WAVE
f4 0 8192 7 0 4096 1 4096 0

; PLUCK
;   Sta  Dur  Amp    Fqc   Func  Meth  OutCh
i2  0.0  1.6  16000  7.00   0     1    1
i2  0.2  1.4  12000  7.05   .     .    .
i2  0.4  1.2  10400  8.00   .     .    .
i2  0.6  1.0  12000  8.05   .     .    .
i2  0.8  0.8  16000  7.00   .     .    .
i2  1.0  0.6  12000  7.05   .     .    .
i2  1.2  0.4  10400  8.00   .     .    .
i2  1.4  0.2  12000  8.05   .     .    .
;
i2  1.6  1.6  16000  7.00   0     1    1
i2  1.8  1.4  12000  7.07   .     .    .
i2  2.0  1.2  10400  8.03   .     .    .
i2  2.2  1.0  12000  8.00   .     .    .
i2  2.4  0.8  16000  7.05   .     .    .
i2  2.6  0.6  12000  7.05   .     .    .
i2  2.8  0.4  10400  8.07   .     .    .
i2  3.0  0.2  12000  8.00   .     .    .
;
i2  3.2  1.6  16000  7.00   0     1    1
i2  3.4  1.4  12000  7.05   .     .    .
i2  3.6  1.2  10400  8.00   .     .    .
i2  3.8  1.0  12000  8.05   .     .    .
i2  4.0  0.8  16000  7.00   .     .    .
i2  4.2  0.6  12000  7.05   .     .    .
i2  4.4  0.4  10400  8.00   .     .    .
i2  4.6  0.2  12000  8.05   .     .    .
;
i2  4.8  1.6  16000  7.07   0     1    1
i2  5.0  1.4  12000  7.03   .     .    .
i2  5.2  1.2  10400  8.05   .     .    .
i2  5.4  1.0  12000  7.00   .     .    .
i2  5.6  0.8  16000  7.05   .     .    .
i2  5.8  0.6  12000  7.03   .     .    .
i2  6.0  0.4  10400  7.10   .     .    .
i2  6.2  0.2  12000  8.00   .     .    .

; LFO
;   Sta  Dur  Amp  Fqc  Table  Phase  Offset  OutKCh
;i7  0    1.6  3    .6   1      0      25      1
;i7  0    1.6  3    .6   1      .25    26      2

; LORENZ OSCILLATOR
;   Sta  Dur  Amp   X    Y    Z     S    R   B      h(rate)  OutKCh Offset
i8  0    6.4  2.5   7.8  1.1  33.4  10   28  2.667  .5       1      25
i8  0    6.4  2.5  14.1 20.7  26.6  10   28  2.667  .5       2      26
i8  0    6.4  2.5  14.0 20.2  26.4  10   28  2.667  .5       3      26
i8  0    6.4  2.5  -6.3 -12.4  8.2  10   28  2.667  .5       4      26

; CHORUS
;   Sta  Dur  Mix  InCh  OutCh  InKCh
i35 0    6.4  .5   1     2      1
i35 0    6.4  .5   1     3      2
i35 0    6.4  1    2     4      3
i35 0    6.4  1    3     5      4

; MIXER
;    Sta Dur  Ch  Gain  Pan
i100 0   6.4  2   1     1
i100 0   6.4  3   1     0
i100 0   6.4  4   1     1
i100 0   6.4  4   1     0

i110 0   6.4


</CsScore>
</CsoundSynthesizer>
