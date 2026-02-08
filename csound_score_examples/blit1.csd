<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from blit1.orc and blit1.sco
; Original files preserved in same directory

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls	=		2

;---------------------------------------------------------------------------------
; A SET OF BAND LIMITED INSTRUMENTS WITH RESONANT FILTER
; BY HANS MIKELSON 11/20/97
; PARTIALLY DERIVED FROM CODE BY JOSEP Mª COMAJUNCOSAS-CSOUND & TIM STILSON-CCRMA
;---------------------------------------------------------------------------------

		zakinit 	30, 30
gifqcadj	=		6600

;---------------------------------------------------------------------------------
; LOW FREQUENCY OSCILLATOR
       	instr    1

iamp   	=        p4
ilfo   	=        p5
iwave  	=        p6
ioutch 	=        p7

klfo   	oscil    iamp, ilfo, iwave
       	zkw      klfo, ioutch

	 	endin

;---------------------------------------------------------------------------------
; ENVELOPE
       	instr    2

idur   	=        p3
iamp   	=        p4
ishape 	=        p5
ioutch 	=        p6

kenv   	oscil    iamp, 1/idur, ishape
       	zkw      kenv, ioutch

       	endin

;---------------------------------------------------------------------------------
; OSCILLATOR SYNCH (BAND LIMITED IMPULSE TRAIN)
        	instr   10

idur    	=       p3
iamp    	=       p4*10
ifqc    	=       cpspch(p5)
iampenv 	=       p6
ifcotab 	=       p7
ireztab 	=       p8
ifcoch  	=       p9
irezch  	=       p10
ilfoch  	=       p11
ipanl   	=       sqrt(p12)
ipanr   	=       sqrt(1-p12)
krms    	init    0

kdclik 	linseg  0, .002, iamp, idur-.004, iamp, .002, 0
kamp   	oscil   kdclik, 1/idur, iampenv
kfcoe  	oscil   1, 1/idur, ifcotab
kreze  	oscil   1, 1/idur, ireztab
kfcoc  	zkr     ifcoch
krezc  	zkr     irezch
kfco   	=       kfcoe*kfcoc
krez   	=       kreze*krezc

klfo   	zkr     ilfoch
kfqc   	=       ifqc+klfo
kfco   	oscil   1, 1/idur, ifcotab
krez   	oscil   1, 1/idur, ireztab

apulse1 	buzz    1, ifqc, sr/2/ifqc, 1  ; Avoid aliasing
apulse2 	buzz    1, ifqc*1.02, sr/2/ifqc*1.02, 1  ; Avoid aliasing
asaw1dc 	integ   apulse1
asaw2dc 	integ   apulse2

aosyncdc 	integ   apulse1*abs(1-asaw2dc)+apulse2*abs(1-asaw1dc)
aosync   	=       aosyncdc             ; Remove DC offset
axn     	butterhp    aosync, 20

; RESONANT LOWPASS FILTER (4 POLE)
ka1    	=       gifqcadj/krez/kfco-1
ka2    	=       gifqcadj/kfco
kasq   	=       ka2*ka2
kb     	=       1+ka1+kasq

ayn    	nlfilt  axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   	nlfilt  ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

       	outs    kamp*ayn2*ipanl, kamp*ayn2*ipanr
       	endin

;---------------------------------------------------------------------------------
; OSCILLATOR SYNCH (BAND LIMITED IMPULSE TRAIN)
        instr   11

idur    	=       p3
iamp    	=       p4*10
ifqc    	=       cpspch(p5)
iampenv 	=       p6
ifcotab 	=       p7
ireztab 	=       p8
ifcoch  	=       p9
irezch  	=       p10
ilfoch  	=       p11
ipanl   	=       sqrt(p12)
ipanr   	=       sqrt(1-p12)
krms    	init    0

kdclik 	linseg   0, .002, iamp, idur-.004, iamp, .002, 0
kamp   	oscil    kdclik, 1/idur, iampenv
kfcoe  	oscil    1, 1/idur, ifcotab
kreze  	oscil    1, 1/idur, ireztab
kfcoc  	zkr      ifcoch
krezc  	zkr      irezch
kfco   	=        kfcoe*kfcoc
krez   	=        kreze*krezc

klfo   	zkr      ilfoch
kfqc   	=        ifqc+klfo
kfco   	oscil    1, 1/idur, ifcotab
krez   	oscil    1, 1/idur, ireztab

apulse1 	buzz    1, ifqc, sr/2/ifqc, 1  ; Avoid aliasing
apulse2 	buzz    1, ifqc*1.02, sr/2/ifqc*1.02, 1  ; Avoid aliasing
asaw1dc 	integ   apulse1
asaw2dc 	integ   apulse2

aosyncdc 	integ   apulse1*abs(1-asaw2dc)+apulse2*abs(1-asaw1dc)
aosync   	=       aosyncdc             ; Remove DC offset
axn     	butterhp    asaw1dc-.5, 20

; RESONANT LOWPASS FILTER (4 POLE)
ka1    	=        gifqcadj/krez/kfco-1
ka2    	=        gifqcadj/kfco
kasq   	=        ka2*ka2
kb     	=        1+ka1+kasq

ayn    	nlfilt   axn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1
ayn2   	nlfilt   ayn/kb, (ka1+2*kasq)/kb, -kasq/kb, 0, 0, 1

       	outs     kamp*ayn2*ipanl, kamp*ayn2*ipanr
       	endin


</CsInstruments>
<CsScore>
;---------------------------------------------------------------------------------
; TEMPLES OF TYRIA
;---------------------------------------------------------------------------------
f1 0 16384 10 1                               ; SINE

;---------------------------------------------------------------------------------
; PART 1 DEEP DRONE
;---------------------------------------------------------------------------------
f10 0 1024 -7 200 256 5000 256 1000 256 1000 256 200   ; FCO DEEP DRONE
f11 0 1024 -7 4 1024 6                      			; REZ DEEP DRONE
f12 0 1024  7 1 512 1 512 1                   		; ENVFCO
f13 0 1024  7 1  1024 1                       		; ENVREZ
f14 0 1024  7 0  64   1 256 .9 640 .8  64 0   		; AMP

; LFO
;  Sta  Dur   Amp  Fqc  Wave  LFOCh
i1 0.0  1.0   0.5  .5   1     2      ; Low Fqc

; ENVELOPE
;  Sta  Dur   Amp  Shape  OutKCh
i2 0.0  1.0   1    12     3
i2 0.0  1.0   1    13     4

; PWM
;   Sta   Dur  Amp    Pitch  AmpEnv  FcoEnv  RezEnv  FcoCh  RezCh  LFOCh  Pan
i11  0.0  1.0  4000  8.00   14      10      11      3      4      2      .7


</CsScore>
</CsoundSynthesizer>
