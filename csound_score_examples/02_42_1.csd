<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_42_1.orc and 02_42_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:      02_42_1.ORC
; timbre:     stretched chord
; synthesis:  additive same units(02)
;             basic instrument with continuous pitch control(42)
; source:     #440  Variable Pitched Drums, Risset(1969)
; coded:      jpg 9/93


instr 1; *****************************************************************
idur  = p3
iamp1 = p4   ;
ifq1  = p5   ;
iamp2 = p6   ;amplitudes and frequencies
ifq2  = p7   ;of three parallel waveforms
iamp3 = p8   ;
ifq3  = p9   ;
ipcf  = p10;;;;;;;;;;;;;;pitch control function parameter
iatt1 = p11  ;
idec1 = p12  ;
iatt2 = p13  ;envelope
idec2 = p14  ;parameters
iatt3 = p15  ;
idec3 = p16  ;

; init time calculation of an extra input parameter for expseg
iseg1 = idur-(iatt1+idec1)
iseg2 = idur-(iatt2+idec2)
iseg3 = idur-(iatt3+idec3)
; getting the correct start value for the pitch control function
if ipcf > 1 igoto nopitchoscil
istartval = .9
goto start
nopitchoscil: istartval = 0
        goto start
start:
   apc  oscili   1, 1/idur, ipcf
   apc  =        istartval + apc      ; pitch control signal

   ae1  expseg   .00097,iatt1, .99,iseg1, .9,idec1, .00097       ; unit 1
   ae1  =        ae1 * iamp1
   a1   oscili   ae1, ifq1*apc, 11

   ae2  expseg   .0039,iatt2, .99,iseg2, .99,idec2, .0000000059   ; unit 2
   ae2  =        ae2 * iamp2
   a2   oscili   ae2, ifq2*apc, 12

   ae3  expseg   .0039,iatt3, .99,iseg3, .99,idec3,.00000000000009; unit 3
   ae3  =        ae3 * iamp3
   a3   oscili   ae3, ifq3*apc, 13
        outs      a1+a2+a3, a1+a2+a3
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     02_42_1.SCO
; coded:     jpg 9/93

; GEN functions **********************************************************
; waveforms
f11 0 512 9   1 1 0
f12 0 512 9   3 1 0 4 1 0 5 1 0 5 1 0
f13 0 512 9   8 1 0 9 1 0 10 1 0 11 1 0 12 1 0 15 1 0 17 1 0 18 1 0

; envelopes
f31 0 512 7 1 512 1    ;steady state
f32 0 512 7 .85 512 1  ;increasing freq -3rd
f33 0 512 7 1 512 .85  ;decreasing freq. -3rd
f1 0 512 10 .1         ;orc. + .9 !! up & down -3rd

; score ******************************************************************
f0 1
s

; constant pitch
;     dur  amp1  fq1  amp2 fq2  amp3 fq3 pcf att1 dec1 att2 dec2 att3 dec3
i1  0 1.63 10000 160  6000  75  3000  61  31 .01  1.6  .01  1.61 .01  1.61
i1  2 1.7  10000 160  6000  75  3000  61  31 .03  1.6  .01  1.65 .01  1.65
; rising a third
i1  4 1.63 10000 160  6000  75  3000  61  32 .01  1.6  .01  1.61 .01  1.61
i1  6 1.7  10000 160  6000  75  3000  61  32 .03  1.6  .01  1.65 .01  1.65
; oscil pitch between .9 and 1.1 times ifq's
i1  8 1.63 10000 160  6000  75  3000  61   1 .01  1.6  .01  1.61 .01  1.61
i1 10 1.7  10000 160  6000  75  3000  61   1 .03  1.6  .01  1.65 .01  1.65
; going down a third
i1 12 1.63 10000 160  6000  75  3000  61  33 .01  1.6  .01  1.61 .01  1.61
i1 14 1.7  10000 160  6000  75  3000  61  33 .03  1.6  .01  1.65 .01  1.65
; non-realistic parameters
i1 16 2    10000 160  6000  75  8000  61  33 .01  1.95 1.9   .1  .9    .8

e


</CsScore>
</CsoundSynthesizer>
