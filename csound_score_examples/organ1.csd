<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from organ1.orc and organ1.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

;***************************************************
; TONE WHEEL ORGAN WITH ROTATING SPEAKER
; MIKELSON
;***************************************************


; TONE WHEEL ORGAN
          instr     1

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

asrc      oscili    iamp,ifqc,2                        ; ORGAN SOURCE
kenv      linseg    0, .01, 1, idur-.02, 1, .01, 0     ; ENVELOPE
gasig1    =         asrc*kenv

          endin

; TONE WHEEL ORGAN
          instr     2

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

asrc      oscili    iamp,ifqc,2                        ; ORGAN SOURCE
kenv      linseg    0, .01, 1, idur-.02, 1, .01, 0     ; ENVELOPE
gasig2    =         asrc*kenv

          endin

; TONE WHEEL ORGAN

          instr     3

idur      =         p3
iamp      =         p4
ifqc      =         cpspch(p5)

asrc      oscili    iamp,ifqc,2                        ; ORGAN SOURCE
kenv      linseg    0, .01, 1, idur-.02, 1, .01, 0     ; ENVELOPE
gasig3    =         asrc*kenv

          endin

;ROTATING SPEAKER
          instr     4

isep      =         .2

asig      =         gasig1 +gasig2 + gasig3

; DISTORTION EFFECT
asig      =         asig/40000
aclip     tablei    asig, 5, 1, .5
aclip     =         aclip*30000

aleslie   delayr    .02, 1
delayw    aclip

; ACCELERATION
kenv      linseg    p4, p3+.02, p5

; DOPPLER EFFECT
koscl     oscil     1, kenv, 1, 0
koscr     oscil     1, kenv, 1, isep
kdopl     =         .01-koscl*.0002
kdopr     =         .012-koscr*.0002
aleft     deltapi   kdopl
aright    deltapi   kdopr

; FILTER EFFECT
; DIVIDE INTO THREE FREQUENCY RANGES FOR DIRECTIONAL SOUND.

; HIGH PASS
alfhi     atone     aleft, 8000
arfhi     atone     aright, 8000
alfhi     tone      alfhi, 12000
arfhi     tone      arfhi, 12000

; BAND PASS
alfmid    atone     aleft, 4000
arfmid    atone     aright, 4000
alfmid    tone      alfmid, 8000
arfmid    tone      arfmid, 8000

; LOW PASS
alflow    tone      aleft, 4000
arflow    tone      aright, 4000

kflohi    oscil     1, kenv, 3, 0
kfrohi    oscil     1, kenv, 3, isep
kflomid   oscil     1, kenv, 4, 0
kfromid   oscil     1, kenv, 4, isep

; AMPLITUDE EFFECT
kalosc    =         koscl * .1 + 1
karosc    =         koscr * .1 + 1


          outs      alfhi*kflohi+alfmid*kflomid+alflow*kalosc,arfhi*kfrohi+arfmid*kfromid+arflow*karosc
          endin

</CsInstruments>
<CsScore>
; ***********************************************
; TONE WHEEL ORGAN WITH ROTATING SPEAKER
; BY HANS MIKELSON 2/12/97
; ***********************************************
; GEN FUNCTIONS *********************************
; SINUS
f1 0 1024 10 1

;TONE WHEEL ORGAN	DRAWBARS
;	SUBFUND FUND SUB 3RD 2ND HARM 3RD HARM 4TH HARM 5TH HARM 6TH HARM	8TH HARM
f2 0 8192 10 8 8	8	4	0	5 0 3	0 0	0 0	0 0 0 8

; LELIE FILTER ENVELOPES
f3 0 256 7 0 110 .3 18 1 18 .3 110 0
f4 0 256 7 0 80 .5 16 1 64 1 16 .5 80 0

; Distortion Table
f5 0 1024 8 -.8 42 -.78 100 -.7 740 .7 100 .78 42 .8

; SCORE ******************************************************************

t 0 600

; TONE WHEEL ORGAN
; START DUR AMP PITCH
i1 0 18 6000 7.04
i2 0 18 6000 7.11
i3 0 18 6000 8.02
i1 18 3 6000 7.04
i2 18 3 6000 7.09
i3 18 3 6000 8.01
i1 21 3 6000 7.04
i2 21 3 6000 7.11
i3 21 3 6000 8.02
i1 24 3 6000 7.04
i2 24 3 6000 7.09
i3 24 3 6000 8.01
i1 27 24 6000 7.04
i2 27 24 6000 7.08
i3 27 24 6000 7.11

; ROTATING SPEAKER
; START DUR    SPEEDI SPEEDF
i4 0 18	.8	8
i4 + 9	8	.8
i4 . 24.1 .8	8

</CsScore>
</CsoundSynthesizer>
