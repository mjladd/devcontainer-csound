<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Guitar FX.orc and Guitar FX.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;---------------------------------------------------------------------------
; A MULTI-EFFECTS SYSTEM
;---------------------------------------------------------------------------
; THIS ORCHESTRA IS DESIGNED AS A MULTI EFFECTS UNIT AND MIXER.
; IT CAN BE USED AS A GUITAR SIMULATOR USING THE PLUCK ALGORITHM OR TO
; TO PROCESS EXISTING DIGITAL AUDIO FILES.

;  1. SIMPLE SINE WAVE
;  2. PLUCK
;  3. MONO SAMPLER
;  4. NOISE
; 10. COMPRESSOR
; 11. TUBE AMP DISTORTION
; 15. WAH-WAH:WELL THIS ONE BASICALLY SUCKS.
; 16. TALK-BOX
; 20. VIBRATO
; 21. TREMELO
; 22. PITCH SHIFTER
; 23. PANNER
; 30. STEREO FLANGER
; 31. CROSS FEEDBACK FLANGER
; 35. CHORUS
; 40. DELAY
; 45. REVERB

; NOT YET IMPLEMENTED.
; *NOISE GATE, *ECHO CHAMBER, *EXCITER, *ENHANCER, *EQUALIZER

; THE ONES WITH A STAR ARE NOT YET IMPLEMENTED. THOSE WITH A . ARE CLOSE.
; APPERENTLY IT'S ALSO ABOUT TIME I LEARNED ROBIN WHITTLE'S ZAK OPCODES
; SINCE THIS APPLICATION IS A NATURAL FOR THEM.


; INITIALIZE EFFECTS SENDS AND RETURNS
;---------------------------------------------------------------------------

zakinit 30, 30

; THESE ARE FOR THE REVERB

gifeed    init      .5
gilp1     init      1/10
gilp2     init      1/23
gilp3     init      1/41
giroll    init      3000

; SOUND SOURCES
;---------------------------------------------------------------------------

; SIMPLE SIN WAVE GENERATOR

          instr 1

iamp      init      p4
ifqc      init      p5
izout     init      p6
kamp      linseg    0, .002, p4, p3-.004, p4, .002, 0

asin1     oscil kamp, ifqc, 1
          zawm      asin1, izout

          endin

; PLUCK PHYSICAL MODEL

          instr 2

iamp      =         p4*4
ifqc      =         cpspch(p5)
izout     init      p8
kamp      linseg    0, .002, p4, p3-.004, p4, .002, 0

aplk      pluck     kamp, ifqc, ifqc, p6, p7
          zawm      aplk, izout

          endin

; SAMPLER MONO

          instr 3

izout     init      p9
asamp     loscil    p4, p5, p6, 440, 1, p7, p8
          zawm      asamp, izout

          endin

; NOISE

          instr 4

iamp      init      p4
izout     init      p5
kamp      linseg    0, .002, p4, p3-.004, p4, .002, 0

arnd1     rand      kamp
afilt     tone      arnd1, 1000
          zawm      afilt, izout

          endin

; EFFECTS SECTION
;---------------------------------------------------------------------------

; COMPRESSOR
          instr 10

ifqc      =         p4
itab      =         p5
ipregain  =         p6
ipostgain =         p7
iinch     =         p8
ioutch    =         p9

; FIND THE RMS ENERGY AND USE A TABLE TO RESCALE THE INPUT.

asig      zar       iinch
kamp      rms       asig*ipregain, ifqc
kampn     =         kamp/40000
kcomp     tablei    kampn,itab,1,.5
acomp     =         kcomp*asig*ipostgain
          zaw       acomp, ioutch

          endin

; TUBE AMP

          instr 11

asig      init      0
kamp      linseg    0, .002, 1, p3-.004, 1, .002, 0
igaini    =         p4
igainf    =         p5
iduty     =         p6
islope    =         p7
izin      =         p8
izout     =         p9

asigin    zar       izin
aold      =         asig
asig      =         igaini*asigin/40000 ; Distortion effect using waveshaping
aclip     tablei    asig,5,1,.5
aclip     =         igainf*aclip*10000

; TUBE AMPLIFIERS SHOW A SHIFTED DUTY CYCLE WHICH I TRY TO EMULATE WITH
; A DELAY LINE. THE SLOPE BIT IS JUST SOMETHING GOOFY I THOUGHT I WOULD ADD.

atemp     delayr    .1
adel1     deltapi   (2-iduty*asig)/1500 + islope*(asig-aold)/300
delayw    aclip

          zaw       adel1, izout

          endin

; FEEDBACKER

		instr 12

ifqc      =    	p4
ifeedbk   =    	p5
iinch     =    	p6
ioutch    =    	p7
aout      init 	0

asig  	zar 		iinch

aout  	delayr 	1/ifqc
        	delayw 	asig+(1+ifeedbk/10000)*aout

        	zaw 		aout, ioutch

		endin



; LOW PASS RESONANT FILTER

		instr 15

idur    	=		p3
itab1   	=   		p4   ; CUT-OFF FREQUENCY
itab2   	=   		p5   ; RESONANCE
ilpmix  	=   		p6   ; LOW-PASS SIGNAL MULTIPLIER
irzmix  	=   		p7   ; RESONANCE SIGNAL MULTIPLIER
izin    	=   		p8
izout   	=   		p9

kfco    	oscil  	1,1/idur,itab1
kfcort  	=      	sqrt(kfco)
krezo    	oscil 	1,1/idur,itab2
krez    	=      	krezo*kfco/500

; AMPLITUDE ENVELOPE

kamp    	linseg 	0, .002, 1, p3-.004, 1, .002, 0

; INPUT TO THE FILTER

axn     	zar 		izin
axn     	=   		axn/5

; 2 POLE RESONANT LOWPASS FILTER

ka1 		= 		1000/krez/kfco-1
ka2 		= 		100000/kfco/kfco
kb  		= 		1+ka1+ka2
ay1 		nlfilt 	axn/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1
ay 		nlfilt 	ay1/kb, (ka1+2*ka2)/kb, -ka2/kb, 0, 0, 1

; 4 POLE RESONANT LOWPASS FILTER (SECOND VERSE SAME AS THE FIRST!)

ka1lp 	= 		1000/kfco-1
ka2lp 	= 		100000/kfco/kfco
kblp  	= 		1+ka1lp+ka2lp
ay1lp 	nlfilt 	axn/kblp, (ka1lp+2*ka2lp)/kblp, -ka2lp/kblp, 0, 0, 1
aylp  	nlfilt 	ay1lp/kblp, (ka1lp+2*ka2lp)/kblp, -ka2lp/kblp, 0, 0, 1

ayrez 	= 		ay - aylp    ; EXTRACT THE RESONANCE PART.
ayrz  	= 		ayrez/kfco   ; ADJUST IT FOR FCO.  MY OTHER FILTER WOULD OSCILLATE
                       		   ; FOR THE SAME NUMBER OF CYCLES NO MATTER WHAT THE
                       		   ; FREQUENCY WAS.  WITH THIS ONE I ATTEMPT TO MAKE IT
                       		   ; OSCILLATE THE SAME AMOUNT OF TIME NO MATTER WHAT
                       		   ; FREQUENCY.

ay2    	= 		aylp*10*ilpmix + ayrz*500*irzmix ; YOU CAN MIX THE AMOUNT OF
                                             	   ; RESONANCE INDEPENDENTLY.
          zaw     	ay2, izout
		endin

; TALK-BOX

          instr 16

izin      =         p4
izout     =         p5

ksweep    linseg    .5, 1, 6, .5, .5, .2, .4

kform1    oscil     1, ksweep, 10
kform2    oscil     1, ksweep, 11
kform3    oscil     1, ksweep, 12
kform4    oscil     1, ksweep, 13

asig      zar       izin

ares1     reson     asig, kform1, 100
ares2     reson     asig, kform2, 150
ares3     reson     asig, kform3, 300
ares4     reson     asig, kform4, 500

aresbal1  balance   ares1, asig
aresbal2  balance   ares2, asig
aresbal3  balance   ares3, asig
aresbal4  balance   ares4, asig

          zaw       (aresbal1*25.4+aresbal2*22.5+aresbal3*9.2+aresbal4*7.9)/40, izout

          endin

; VIBRATO

          instr 20

iamp      =         p4/1000
ifqc      =         p5
itab1     =         p6
imax      =         p7/1000
izinl     =         p8
izinr     =         p9
izoutl    =         p10
izoutr    =         p11

asigl     zar       izinl
asigr     zar       izinr

kosc      oscil     iamp, ifqc, itab1

atmpl     delayr    imax
aoutl     deltapi   kosc+imax/2
delayw    asigl

atmpr     delayr    imax
aoutr     deltapi   kosc+imax/2
delayw    asigr

          zaw       aoutl, izoutl
          zaw       aoutr, izoutr
          endin

; TREMELO

          instr 21

iamp      =         p4
ifqc      =         p5
itab1     =         p6
izinl     =         p7
izinr     =         p8
izoutl    =         p9
izoutr    =         p10

asigl     zar       izinl
asigr     zar       izinr

kosc      oscil     iamp, ifqc, itab1

aoutl     =         asigl*(kosc+1)
aoutr     =         asigr*(kosc+1)

          zaw       aoutl, izoutl
          zaw       aoutr, izoutr
          endin

; PITCH SHIFTER

          instr 22

ifqc      =         p4
itab1     =         p5
ifn2      =         p6
izout     =         p7

;              Amp Timwrp ReSamp Fn1 Beg WinSz RndWin OvrLap Fn2 Mode
awrp, acmp sndwarp 1, 1, ifqc, itab1, 0, 2000, 400, 10, ifn2, 0
aout      balance   awrp, acmp

          zaw       aout, izout
          endin

; PANNER

          instr 23

iamp      =         p4
ifqc      =         p5
itab1     =         p6
izin      =         p7
izoutl    =         p8
izoutr    =         p9

asig      zar       izin

kosc      oscil     iamp, ifqc, itab1
kpanl     =         (kosc+1)/2
kpanr     =         1-kpanl

aoutl     =         asig*kpanl
aoutr     =         asig*kpanr

          zaw       aoutl, izoutl
          zaw       aoutr, izoutr
          endin

; STEREO FLANGER

          instr 30

kamp      linseg    0, .002, 1, p3-.004, 1, .002, 0
irate     =         p4
idepth    =         p5/10000
iwave     =         p6
ifdbk     =         p7
imix      =         p8
ideloff   =         p9/10000
izin      init      p10
izoutl    init      p11
izoutr    init      p12
adel1     init      0
adel2     init      0

aflngin   zar       izin

; SPLIT THE INPUT SIGNAL AND DELAY ONE PORTION.
; MODULATE THE DELAY BY ABOUT .001 SEC. AND ADD THE SIGNALS TOGETHER AGAIN.
; FEED THIS BACK INTO THE SIGNAL PATH AGAIN.

asig1     =         aflngin + ifdbk*adel1
asig2     =         aflngin + ifdbk*adel2

aosc1     oscil     idepth, irate, iwave
aosc1     =         aosc1+idepth+ideloff/2

aosc2     oscil     idepth, irate, iwave, .25
aosc2     =         aosc2+idepth+ideloff/2

atemp     delayr    2*idepth+ideloff
adel1     deltapi   aosc1
delayw    asig1

atemp     delayr    2*idepth+ideloff
adel2     deltapi   aosc2
delayw    asig2

          zaw       adel1, izoutl
          zaw       adel2, izoutr

          endin

; CROSS FEEDBACK FLANGER

          instr 31

kamp      linseg    0, .002, 1, p3-.004, 1, .002, 0
irate     =         p4
idepth    =         p5/10000
iwave     =         p6
ifdbk     =         p7
imix      =         p8
ideloff   =         p9/10000
izin      init      p10
izoutl    init      p11
izoutr    init      p12
adel1     init      0
adel2     init      0


aflngin   zar       izin

asig1     =         aflngin + ifdbk*adel2
asig2     =         aflngin + ifdbk*adel1

aosc1     oscil     idepth, irate, iwave
aosc1     =         aosc1+idepth+ideloff/2

aosc2     oscil     idepth, irate, iwave, .25
aosc2     =         aosc2+idepth+ideloff/2

atemp     delayr    2*idepth+ideloff
adel1     deltapi   aosc1
delayw    asig1

atemp     delayr    2*idepth+ideloff
adel2     deltapi   aosc2
delayw    asig2

          zaw       adel1, izoutl
          zaw       adel2, izoutr

          endin

; CHORUS

          instr 35

kamp      linseg    0, .002, 1, p3-.004, 1, .002, 0
irate     =         p4
idepth    =         p5/1000
iwave     =         p6
imix      =         p7
ideloff   =         p8/1000
izin      init      p9
izoutl    init      p10
izoutr    init      p11
adel1     init      0
adel2     init      0

asig1     zar       izin
asig2     zar       izin

aosc1     oscil     idepth, irate, iwave
aosc1     =         aosc1+idepth+ideloff/2

aosc2     oscil     idepth, irate, iwave, .25
aosc2     =         aosc2+idepth+ideloff/2

atemp     delayr    2*idepth+ideloff
adel1     deltapi   aosc1
delayw    asig1

atemp     delayr    2*idepth+ideloff
adel2     deltapi   aosc2
delayw    asig2

          zaw       adel1, izoutl
          zaw       adel2, izoutr

          endin

; DELAY
          instr 40

itime     =         p4
ifeedbk   =         p5
izinl     =         p6
izinr     =         p7
izoutl    =         p8
izoutr    =         p9

asigl     zar       izinl
asigr     zar       izinr

aoutl     delayr    itime
          delayw    asigl+ifeedbk*aoutl
aoutr     delayr itime
          delayw    asigr+ifeedbk*aoutr

          zaw aoutl, izoutl
          zaw aoutr, izoutr
          endin

; ONE OF ERIC LYON'S REVERB'S
;i1 0 dur file skip gain %orig inputdur atk

          instr 45
inputdur  =         p6
iatk      =         p7
idk       =         .01
idecay    =         .01

;DATA FOR OUTPUT ENVELOPE

ioutsust  =         p3-idecay
idur      =         inputdur-(iatk+idk)
isust     =         p3-(iatk+idur+idk)
iorig     =         p5
irev      =         1.0-p5
izin1     init      p8
izin2     init      p9
izoutl    init      p10
izoutr    init      p11

igain     =         p6
kclean    linseg    0,iatk,igain,idur,igain,idk,0,isust,0
kout      linseg    1,ioutsust,1,idecay,0
; ain1,ain2 soundin ifile,iskip
ain1      zar       izin1
ain2      zar       izin2
ain1      =         ain1*kclean
ain2      =         ain2*kclean
ajunk     alpass    ain1,1.7,.1
aleft     alpass    ajunk,1.01,.07
ajunk     alpass    ain2,1.5,.2
aright    alpass    ajunk,1.33,.05
kdel1     randi     .01,1,.666
kdel1     =         kdel1 + .1
addl1     delayr    .3
afeed1    deltapi   kdel1
afeed1    =         afeed1 + gifeed*aleft
          delayw    aleft

kdel2     randi     .01,.95,.777
kdel2     =         kdel2 + .1
addl2     delayr    .3
afeed2    deltapi   kdel2
afeed2    =         afeed2 + gifeed*aright
          delayw    aright

;GLOBAL REVERB

aglobin   =         (afeed1+afeed2)*.05
atap1     comb      aglobin,3.3,gilp1
atap2     comb      aglobin,3.3,gilp2
atap3     comb      aglobin,3.3,gilp3

aglobrev  alpass    atap1+atap2+atap3,2.6,.085
aglobrev  tone      aglobrev,giroll

kdel3     randi     .003,1,.888
kdel3     =         kdel3 + .05
addl3     delayr    .2
agr1      deltapi   kdel3
          delayw aglobrev

kdel4     randi     .003,1,.999
kdel4     =         kdel4 + .05
addl4     delayr    .2
agr2      deltapi   kdel4
          delayw    aglobrev

arevl     =         agr1+afeed1
arevr     =         agr2+afeed2
aoutl     =         (ain1*iorig)+(arevl*irev)
aoutr     =         (ain2*iorig)+(arevr*irev)

          zaw  aoutl*kout, izoutl
          zaw  aoutr*kout, izoutr

          endin

; MIXER SECTION
;---------------------------------------------------------------------------
; Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan

; MIXER

          instr 100

asig1     zar       p4
igl1      init      p5*p6
igr1      init      p5*(1-p6)
asig2     zar       p7
igl2      init      p8*p9
igr2      init      p8*(1-p9)
asig3     zar       p10
igl3      init      p11*p12
igr3      init      p11*(1-p12)
asig4     zar       p13
igl4      init      p14*p15
igr4      init      p14*(1-p15)

asigl     =         asig1*igl1 + asig2*igl2 + asig3*igl3 + asig4*igl4
asigr     =         asig1*igr1 + asig2*igr2 + asig3*igr3 + asig4*igr4

          outs      asigl, asigr
          zacl 0, 30

          endin

</CsInstruments>
<CsScore>
;---------------------------------------------------------------------------
; A MULTI-EFFECTS SYSTEM
;---------------------------------------------------------------------------
; 1. SIMPLE SINE WAVE
; 2. PLUCK
; 3. MONO SAMPLER
; 4. NOISE
; 10. COMPRESSOR
; 11. TUBE AMP DISTORTION
; 15. WAH-WAH: THIS ONE SUCKS BUT THE TALK-BOX MAKES A PRETTY GOOD WAH-WAH.
; 16. TALK-BOX
; 20. VIBRATO
; 21. TREMELO
; 22. PITCH SHIFTER
; 23. PANNER
; 30. STEREO FLANGER
; 31. CROSS FEEDBACK FLANGER
; 35. CHORUS
; 40. DELAY
; 45. REVERB

;---------------------------------------------------------------------------
; WAVEFORMS
;---------------------------------------------------------------------------
; SINE WAVE
f1 0 8192 10 1
; TRIANGLE WAVE
f2 0 8192 7 -1 4096 1 4096 -1
; SAMPLE
;f3 0 0 1 "harp.wav" 0 4 0
; TRIANGLE WAVE
f4 0 8192 7 0 4096 1 4096 0

; DISTORTION TABLES
; HEAVY DISTORTION
;f5 0 8192 8 -.8 336 -.76 3000 -.7 1520 .7 3000 .76 336 .8
; SLIGHT DISTORTION
;f5 0 8192 8 -.8 336 -.78 800 -.7 5920 .7 800 .78 336 .8
; TUBE DISTORTION
;f5 0 8192 7 -.8 834 -.79 834 -.77 834 -.64 834 -.48 1520 .47 2000 .48 1336 .48
f5 0 8192 7 -.8 934 -.79 934 -.77 934 -.64 1034 -.48 520 .47 2300 .48 1536 .48

; WAH-WAH
f7 0 1024 -7 100 512 10000 512 100

; PITCH SHIFT WINDOW SHAPE (1/2 SINE)
f8 0 16384 9 .5 1 0

; FORMANTS
; AHH/OOOH
f10 0 1024 -7 722 256 722 256 266 256 266 256 722
f11 0 1024 -7 1216 256 1216 256 1292 256 1292 256 1216
f12 0 1024 -7 2433 256 2433 256 2281 256 2281 256 2433
f13 0 1024 -7 3193 256 3193 256 3421 256 3421 256 3193

; SAMPLE
;     Sta Dur   Amp   Fqc Table Begin End(n-1) OutCh
;i3   0   21.6  10000 440 3     0     4     74670 1

; SINE WAVE
;i1 0 1 10000 1000
;i1 1 1 10000 500

; PITCH SHIFTER THIS HAS NOT BEEN TESTED.
;   Sta Dur Fqc Wave WinFun OutCh
;i19 0  1.6 2   3    8      1

; NOISE
;   Sta Dur Amp
;i4 0   4   5000

; WAH-WAH
;   Sta Dur Frqc Table InChL InChR OutChL OutChR
;i15 0 1.6  2       7   2       2   3       3

; VIBRATO
;   Sta Dur Amp Fqc Table MaxDelay InChL InChR OutChL OutChR
;i20 0 2.5  1   5   1       3       1       1   2       2

; TREMELO
;   Sta Dur Amp Fqc Table InChL InChR OutChL OutChR
;i21 0  2.5 .5   5   1    1     1     2      2

;---------------------------------------------------------------------------
; PLAIN PLUCK
;---------------------------------------------------------------------------
;  Sta Dur Amp  Fqc Func Meth OutCh
i2 0.0 1.6 4000 7.00 0      1 1
i2 0.2 1.4 3000 7.05 .      . .
i2 0.4 1.2 2600 8.00 .      . .
i2 0.6 1.0 3000 8.05 .      . .
i2 0.8 0.8 4000 7.00 .      . .
i2 1.0 0.6 3000 7.05 .      . .
i2 1.2 0.4 2600 8.00 .      . .
i2 1.4 0.2 3000 8.05 .      . .

; MIXER
;   Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 0  2   1   4    1   1   4    0   3   2    1   4    2   0

;---------------------------------------------------------------------------
; PLUCK WITH HEAVY DISTORTION
;---------------------------------------------------------------------------
i2 2.0 1.6 4000 7.00 0  1 1
i2 2.2 1.4 3000 7.05 .  . .
i2 2.4 1.2 2600 8.00 .  . .
i2 2.6 1.0 3000 8.05 .  . .
i2 2.8 0.8 4000 7.00 .  . .
i2 3.0 0.6 3000 7.05 .  . .
i2 3.2 0.4 2600 8.00 .  . .
i2 3.4 0.2 3000 8.05 .  . .

; TUBE AMP
;  Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 2  1.6 2        1       1           1           1   2

; MIXER
;  Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 2 2    2   1   1   2   1    0   3   2    1   4   2    0

;---------------------------------------------------------------------------
; PLUCK WITH DISTORTION & FLANGING
;---------------------------------------------------------------------------
i2 4.0 1.6 4000 7.00 0  1 1
i2 4.2 1.4 3000 7.05 .  . .
i2 4.4 1.2 2600 8.00 .  . .
i2 4.6 1.0 3000 8.05 .  . .
i2 4.8 0.8 4000 7.00 .  . .
i2 5.0 0.6 3000 7.05 .  . .
i2 5.2 0.4 2600 8.00 .  . .
i2 5.4 0.2 3000 8.05 .  . .

; TUBE AMP
; Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 4 1.6 2       1        1          1           1   2

; FLANGER
; Sta Dur Rate Depth Wave Feedbk Mix DelayOff InCh OutChL OutChR
;   (1-40)
i30 4 1.61 .5   20   1   .8      1   10        2    3     4

; MIXER
;  Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 4 2    3  .5   1    4   .5  0    3   0   1    4   0      0

;---------------------------------------------------------------------------
; DISTORTION & CHORUS
;---------------------------------------------------------------------------
i2 6.0 1.6 4000 7.00 0  1 1
i2 6.2 1.4 3000 7.05 .  . .
i2 6.4 1.2 2600 8.00 .  . .
i2 6.6 1.0 3000 8.05 .  . .
i2 6.8 0.8 4000 7.00 .  . .
i2 7.0 0.6 3000 7.05 .  . .
i2 7.2 0.4 2600 8.00 .  . .
i2 7.4 0.2 3000 8.05 .  . .

; TUBE AMP
;  Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 6  1.6 2        1       1           1         1    2

; CHORUS
; Sta Dur Rate Depth Wave Mix DelayOff InCh OutChL OutChR
;   (.1-2)
i35 6 1.61 1    1    1    1     30      2   3      4

; MIXER
;   Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 6  2   3   1    1   4   1    0   3   0    1   4   0    0

;---------------------------------------------------------------------------
; DISTORTION & TALK-BOX
;---------------------------------------------------------------------------
i2 8.0 1.6 4000 7.07 0  1 1
i2 8.4 1.2 3000 7.00 .  . .
i2 8.8 .8 2600 9.05 .   . .
i2 9.2 .4 3000 9.00 .   . .

; TUBE AMP
;  Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 8  1.6 2       1        1          1          1    2

; TALK BOX
; Sta Dur InCh OutCh
i16 8 1.6  2    3

; MIXER
;   Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 8  2   3   1    1   3   1    0   3   0    1   4   0    0

;---------------------------------------------------------------------------
; DIGITAL DELAY WITH MODERATE DISTORTION
;---------------------------------------------------------------------------
i2 10.0 1.6 4000 7.07 0 1 1
i2 10.4 1.2 3000 7.00 . . .
i2 10.8 .8 2600 9.05 .  . .
i2 11.2 .4 3000 9.00 .  . .

; TUBE DISTORTION
f5 10 8192 7 -.8 834 -.79 834 -.77 834 -.64 834 -.48 1520 .47 2000 .48 1336 .48

; TUBE AMP
;   Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 10 1.6  2       1        .2         0          1    2

; DELAY
;  Sta Dur Time Feedbk InChL InChR OutChL OutChR
i40 10 3   .2   .5      2     2     3     3

; MIXER
;   Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 10 3   2   1    1   2   1    0   3   1    1   3   1    0

;---------------------------------------------------------------------------
; COMPRESSION & AUTO PAN
;---------------------------------------------------------------------------
i2 13.0 1.6 4000 7.07 0 1 1
i2 13.4 1.2 3000 7.00 . . .
i2 13.8 .8 2600 9.05 .  . .
i2 14.2 .4 3000 9.00 .  . .

; COMPRESSION CURVE
f6 13 1025 7 1 256 1 256 .1 256 .1 257 .1

; COMPRESSOR
;   Sta Dur RespFrqc Table PreGain PostGain InCh OutCh
i10 13 1.6  100      6      1      20       1    2

; TUBE DISTORTION
f5 13 8192 7 -.8 834 -.79 834 -.77 834 -.64 834 -.48 1520 .47 2000 .48 1336 .48

; TUBE AMP
;  Sta Dur PreGain PostGain DutyOffset SlopeShift InCh OutCh
i11 13 1.6 2        1       .2          0           2   3

; PANNER
;  Sta Dur Amp Fqc Table InCh OutChL OutChR
i23 13 1.6 1    5   1    3    4      5

; REVERB
;  Sta Dur gain %orig inputdur atk InCh1 InCh2 OutChL OutChR
i45 13 3    1   .5    1.61     .2   4     5    6      7

; MIXER
;   Sta Dur Ch1 Gain Pan Ch2 Gain Pan Ch3 Gain Pan Ch4 Gain Pan
i100 13 3   4   1    1   5   1    0   6   1    1   7   1    0

;---------------------------------------------------------------------------
; REZ FILTER
;---------------------------------------------------------------------------
i2  16.0  1.6  4000  7.07   0     1    1
i2  16.4  1.2  3000  7.00   .     .    .
i2  16.8   .8  2600  9.05   .     .    .
i2  17.2   .4  3000  9.00   .     .    .

; COMPRESSION CURVE
f6 16 1025 7 1 256 1 256 .1 256 .1 257 .1

; COMPRESSOR
;    Sta  Dur  RespFrqc  Table  PreGain PostGain  InCh  OutCh
i10  16   1.6  100       6      1       20        1     2

; TUBE AMP
; TUBE DISTORTION
f5 16 8192 7 -.8 934 -.79 934 -.77 934 -.64 1034 -.48 520 .47 2300 .48 1536 .48
;   Sta  Dur  PreGain PostGain  DutyOffset  SlopeShift  InCh  OutCh
i11 16   1.6  2       1         .5          .2          2     3

; RESONANT FILTER
; f3=Fco, f4=Rez
f20 16 8192 -5 10 1024 90 1024 400 2048 300 4096 20
f21 16 8192 -7 40 1024 60  1024 40  2048 40  4096 30
;   Sta  Dur  Table1  Table2  LPMix  RzMix  InCh  OutCh
i15 16   1.6  20      21      1      1      3     4

; MIXER
;    Sta Dur  Ch1  Gain  Pan  Ch2  Gain  Pan  Ch3  Gain  Pan  Ch4  Gain  Pan
i100 16  1.6  4    1     1    4    1     0    6    0     1    7    0     0


</CsScore>
</CsoundSynthesizer>
