<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from VirtualPitch.orc and VirtualPitch.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         1


;*****************************************   VIRTUAL PITCH   ****************************************

;  One of the most remarkable properties of the auditory system is its ability to extract pitch from
; complex tones. When the complex tone consists of a given number of harmonically related partials,
; the pitch corresponds to the 'missing fundamental'. This pitch is often referred to as "pitch of
; the missing fundamental", "virtual pitch", or "musical pitch".
; A complex tone consisting of 10 harmonics of 200Hz having equal amplitude will be presented to the l
; listener(s), first with all harmonics, then without the fundamental, then without the two lowest
; harmonics,etc. Does the pitch of the complex tone change?


;******************************************   HEADER   *********************************************


 instr         1

 iamp          =         ampdb(p4)
 ifunc         =         p6

 k1            linen     iamp,.02,p3,.02
 a1            oscili    k1,p5,ifunc
               out       a1
 endin

</CsInstruments>
<CsScore>

f1 0 512 10 .5 .5 .5 .5 .5 .5 .5 .5 .5 .5              ; FUNDAMENTAL WITH 9 HARMONICS
f2 0 512 10  0 .5 .5 .5 .5 .5 .5 .5 .5 .5              ; MISSING FUDAMENTAL
f3 0 512 10  0  0 .5 .5 .5 .5 .5 .5 .5 .5              ; MISSING FUDAMENTAL AND 2ND HARMONIC
f4 0 512 10  0  0   0 .5 .5 .5 .5 .5 .5 .5             ; MISSING FUNDAMENTAL AND 2ND AND 3RD
f5 0 512 10  0  0   0  0 .5 .5 .5 .5 .5 .5             ; MISSING FUNDAMENTAL AND 2ND - 4TH
f6 0 512 10  0  0   0  0  0 .5 .5 .5 .5 .5             ; MISSING FUNDAMENTAL AND 2ND - 5TH
f7 0 512 10  0  0   0  0  0  0 .5 .5 .5 .5             ; MISSING FUNDAMENTAL AND 2ND - 6TH
f8 0 512 10  0  0   0  0  0  0  0 .5 .5 .5             ; MISSING FUNDAMENTAL AND 2ND - 7TH
f9 0 512 10  0  0   0  0  0  0  0  0 .5 .5             ; MISSING FUNDAMENTAL AND 2ND - 8TH
f10 0 512 10  0  0  0  0  0  0  0  0  0 .5             ; MISSING FUNDAMENTAL AND 2ND - 9TH


;************************************   VIRTUAL PITCH   ****************************************
;   p1      p2      p3    p4       p5       p6
;  inst    strt    dur   iamp     freq     ifunc
    i1     1.00    .75    80      200       1
    i1     2.00    .75    80      200       2
    i1     3.00    .75    80      200       3
    i1     4.00    .75    80      200       4
    i1     5.00    .75    80      200       5
    i1     6.00    .75    80      200       6
    i1     7.00    .75    80      200       7
 endin

</CsScore>
</CsoundSynthesizer>
