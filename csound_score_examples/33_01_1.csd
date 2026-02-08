<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 33_01_1.orc and 33_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      33_01_1.ORC
; synthesis:  Amplitude Modulation(33)
;             ring modulation, multiplier(01)
; coded:      jpg 10/93


instr 1; *****************************************************************
idur  =  p3
iamp  =  p4
ifqc  =  p5
ifc   =  p6
ifqm  =  p7
ifm   =  p8
ife   =  31

   kenv  oscili   iamp, 1/idur, ife     ; envelope
   a1    oscili   kenv, ifqc, ifc       ; carrier is sinus or complex

   a2    oscili   1, ifqm, ifm          ; modulator

         out      a1*a2                 ; multiplier as ring modulator
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     33_01_1.SCO
; coded:     jpg 10/93


; GEN functions **********************************************************
; for both oscillators
f1 0 512 10 1              ; one sinus
f2 0 512 10 1 1 1          ; three harmonics

; envelope
f31 0  512 7  0 51 1 29 .9 120 .8 50 .6 50 .5 20 .3 30 .1 162 0

; score ******************************************************************

;    idur iamp  ifqc ifc   ifqm ifm
i1  0  1  8000  800  1      50  1  ;         750 (800) 850            Hz
i1  3  .  .     .    1     111  2  ; 467/578/689 (800) 911/1022/1133  Hz
i1  6  .  .     .    2     107  1  ; 693(800)807,1493(1600)1707, ...  Hz


e


</CsScore>
</CsoundSynthesizer>
