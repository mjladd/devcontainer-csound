<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_44_1.orc and 02_44_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      02_44_1.ORC
; synthesis:  additive, same building blocks(02)
;             basic instrument with continuous pitch and amp control(44)
; source:     #514   Part 2 of Endless Glissando, Risset(1969)
; notes:      Prior to running this, the table controlling the amplitudes
;             (bell-shaped function) needs to be created: 88_01_1.TAB
; coded:      jpg 9/93


instr 1; *****************************************************************
idur = p3
ifq  = p4
iamp = p5

   a11   oscili   iamp,1/idur,71, 0    ; f71 reads soundfile with gen01
   a22   oscili   ifq,1/idur,51, 0
   a1    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .1
   a22   oscili   ifq,1/idur,51, .1
   a2    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .2
   a22   oscili   ifq,1/idur,51, .2
   a3    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .3
   a22   oscili   ifq,1/idur,51, .3
   a4    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .4
   a22   oscili   ifq,1/idur,51, .4
   a5    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .5
   a22   oscili   ifq,1/idur,51, .5
   a6    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .6
   a22   oscili   ifq,1/idur,51, .6
   a7    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .7
   a22   oscili   ifq,1/idur,51, .7
   a8    oscili   a11, a22, 11

   a11   oscili   iamp,1/idur,71, .8
   a22   oscili   ifq,1/idur,51, .8
   a9    oscili   a11, a22,11

   a11   oscili   iamp,1/idur,71, .9
   a22   oscili   ifq,1/idur,51, .9
   a10   oscili   a11, a22,11

   a1    =        a1+a2+a3+a4+a5+a6+a7+a8+a9+a10
   a33   linseg   0, p3*.01,1, p3*.95,1, p3*.04, 0   ; envelope
         out      a1*a33
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:      02_44_1.SCO
; coded:      jpg 9/93

; GEN functions **********************************************************
; carrier
f11  0  513  9  1 1 0

; bell shaped control function         ; "named" soundfiles for GEN 01 are
f71  0  513  1  "Sflib/88_01_1.TAB" 0 0 0     ; possible since Csound 1992
                ; Using an earlier Csound version, one needs to adapt
                ; this to fit the soundin.x mechanism.

; exponential envelope
f51  0  513  5  1024 512 1             ; post-normalized

; score ******************************************************************
;     idur  ifq   iamp
i1  1 120   3900  10000
e

</CsScore>
</CsoundSynthesizer>
