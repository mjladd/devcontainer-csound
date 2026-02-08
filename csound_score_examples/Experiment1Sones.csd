<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Experiment1Sones.orc and Experiment1Sones.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2

;**************************************   DOUBLING OF LOUDNESS  ***************************************
; THE "SONE" IS DEFINED AS THE LOUDNESS OF A 1000HZ TONE AT 40DB( A LOUDNESS LEVEL OF 40 PHONS). FOR
; LOUDNESS LEVELS OF 40 PHONS OR GREATER, THE RELATIONSHIP BETWEEN LOUDNESS S IN SONES AND LOUDNESS
; LEVEL L(S) IN PHONS RECOMMENDED BY THE INTERNATIONAL STANDARDS ORGANIZATION (ISO) IS S = 2 RAISED TO
; {L(S) - 40}/10. AN EQUIVALENT EXPRESSION FOR LOUDNESS S THAT AVOIDS THE USE OF L(S) IS S = CP RAISED
; TO THE 0.6, WHERE P IS THE SOUND PRESSURE AND C DEPENDS ON THE FREQUENCY. THE ABOVE EQUATIONS ARE
; BASED ON THE WORK OF S.S. STEVENS, WHICH INDICATED A DOUBLING OF LOUDNESS FOR A 10DB INCREASES IN
; SOUND PRESSURE LEVEL. SOME INVESTIGATORS, HOWEVER, HAVE FOUND A DOUBLING OF LOUDNESS FOR A 6DB IN-
; CREASE IN SOUND PRESSURE LEVEL (WARREN, 1970). THIS SUGGESTS THE USE OF THE FORMULA IN WHICH LOUDNESS
; IS PROPORTIONAL TO SOUND PRESSURE (HOWES, 1974): SS = K{P - P(0)}, WHERE P IS THE SOUND PRESSURE AND
; P(0) IS THE PRESSURE AT SOME THRESHOLD LEVEL.
; THIS CONTROVERSY ACTUATED ME TO CONDUCT MY OWN EXPERIMENT, EVALUATE THE RESULTS, AND DRAW MY "OWN"
; CONCLUSIONS. WHAT IS PRESENTED TO THE LISTENER IS NOISE AND 5000HZ TONE PAIRS AT VARIED DECIBEL
; LEVELS. THE FIRST TONE WILL REMAIN AT A CONSTANT OF 70DB, WHILE THE SECOND OF THE TONE PAIR WILL VARY
; FROM +6DB - +15DB. THE TONES ARE .3 SECONDS EACH. A CALIBRATION TONE OF 7 SECONDS IS PROVIDED BEFORE
; EACH SECTION WITH NOISE AND 5000HZ.
;*****************************************   HEADER   *************************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin

 instr         2

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB


 k1            linen     iamp,.01,p3,.01
 anoise        randi     k1, .998 * 10010         ;BROADBAND NOISE 20 - 20KHZ
 asig          oscil     anoise,anoise,1
               outs      asig,asig
 endin


</CsInstruments>
<CsScore>
f1 0 512 10 1                                                    ; SINE WAVE


;*************************************   BROADBAND NOISE   *********************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i2     1.0      7     70                                     ; CALIBRATION NOISE
  s
;***************************************   6DB - 15DB ACCRETION   **************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i2     1.0     .3     70
    i2     1.40    .3     76
  s
    i2     1.0     .3     70
    i2     1.40    .3     76.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     77
  s
    i2     1.0     .3     70
    i2     1.40    .3     77.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     78
  s
    i2     1.0     .3     70
    i2     1.40    .3     78.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     79
  s
    i2     1.0     .3     70
    i2     1.40    .3     79.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     80
  s
    i2     1.0     .3     70
    i2     1.40    .3     80.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     81
  s
    i2     1.0     .3     70
    i2     1.40    .3     81.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     82
  s
    i2     1.0     .3     70
    i2     1.40    .3     82.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     83
  s
    i2     1.0     .3     70
    i2     1.40    .3     83.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     84
  s
    i2     1.0     .3     70
    i2     1.40    .3     84.5
  s
    i2     1.0     .3     70
    i2     1.40    .3     85
  s

;*****************************************   5000Hz   ********************************************
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0      7     70      5000                           ; CALIBRATION TONE
  s
;***************************************   6DB - 15DB ACCRETION   **************************************
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     76      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     76.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     77      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     77.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     78      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     78.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     79      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     79.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     80      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     80.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     81      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     81.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     82      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     82.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     83      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     83.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     84      5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     84.5    5000
  s
    i1     1.0     .3     70      5000
    i1     1.40    .3     85      5000
  e

</CsScore>
</CsoundSynthesizer>
