<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Masking.orc and Masking.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*******************************    BACKWARD AND FORWARD MASKING   *********************************

; MASKING CAN OCCUR EVEN WHEN THE TONE AND THE MASKER ARE NOT SIMULTANEOUS. FORWARD MASKING REFERS
; TO THE MASKING OF A TONE BY A SOUND THAT ENDS A SHORT TIME (UP TO ABOUT 10 OR 30 MS) BEFORE THE
; TONE BEGINS. FORWARD MASKING SUGGESTS THAT RECENTY STIMULATED SENSORS ARE NOT AS SENSITIVE AS FULLY
; RESTED SENSORS. BACKWARD MASKING REFERS TO THE MASKING OF A TONE BY A SOUND THAT BEGINS A FEW MIL-
; LISECONDS AFTER THE TONE HAS ENDED. A TONE CAN BE MASKED BY NOISE THAT BEGINS UP TO 10MS LATER, AL-
; THOUGH THE AMOUNT OF MASKING DECREASES AS THE TIME INTERVAL INCREASES. BACKWARD MASKING APPARENTLY
; OCCURS AT HIGHER CENTERS OF PROCESSING IN THE NERVOUS SYSTEM WHERE THE NEURAL CORRELATES OF THE
; LATER-OCCURING STIMULUS OF GREATER INTENSITY OVERTAKE AND INTERFERE WITH THOSE OF THE WEAKER STI-
; MULUS.
; A 10 MS SINUSOIDAL TONE OF 2000HZ WILL BE PRESENTED TO THE LISTENER(S) IN 10 DECREASING STEPS OF
; -4DB WITHOUT A MASKER. NEXT THE 2000HZ SIGNAL IS FOLLOWED AFTER A TIME GAP (T) BY 250MS BURSTS OF
; NOISE (1900 - 2100). THE TIME GAP (T) IS SUCCESSIVELY 100MS, 20MS, AND 0.

;****************************************   HEADER   ************************************************





 instr         1

 iamp          =         ampdb(p4)                     ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                            ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin



 instr         2

 iamp          =         ampdb(p4)                     ;P4 = AMPLITUDE IN DB
 ifc           =         p5                            ;P5 = FREQUENCY


 k1            linen     iamp,.02,p3,.02
 anoise        randi     k1, .2 * ifc                  ; NOISE WITH A BANDWIDTH FROM 1600HZ - 2400HZ
 a1            oscil     anoise, ifc, 1
               outs      a1,a1
 endin








</CsInstruments>
<CsScore>

f1 0 32768 10 1                                             ; SINE WAVE






;*********************************   BACKWARD/FORWARD MASKING   **************************************

;******************************  2000HZ AT -4DB DECREASING STEPS  ************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     1.0    .01     86      2000
    i1     1.6    .01     82      2000
    i1     2.2    .01     78      2000
    i1     2.8    .01     74      2000
    i1     3.4    .01     70      2000
    i1     4.0    .01     66      2000
    i1     4.6    .01     62      2000
    i1     5.2    .01     58      2000
    i1     5.8    .01     54      2000
    i1     6.4    .01     50      2000
s

;***************************************  BACKWARD MASKING   ***************************************

;*******************************  2000HZ WITH MASKING AT 100 MS  ***********************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i1     1.25    .01    86      2000
    i2     1.36    .25    86      2000
    i2     2.00    .25    86      2000
    i1     2.25    .01    82      2000
    i2     2.36    .25    86      2000
    i2     3.00    .25    86      2000
    i1     3.25    .01    78      2000
    i2     3.36    .25    86      2000
    i2     4.00    .25    86      2000
    i1     4.25    .01    74      2000
    i2     4.36    .25    86      2000
    i2     5.00    .25    86      2000
    i1     5.25    .01    70      2000
    i2     5.36    .25    86      2000
    i2     6.00    .25    86      2000
    i1     6.25    .01    66      2000
    i2     6.36    .25    86      2000
    i2     7.00    .25    86      2000
    i1     7.25    .01    62      2000
    i2     7.36    .25    86      2000
    i2     8.00    .25    86      2000
    i1     8.25    .01    58      2000
    i2     8.36    .25    86      2000
    i2     9.00    .25    86      2000
    i1     9.25    .01    54      2000
    i2     9.36    .25    86      2000
    i2    10.00    .25    86      2000
    i1    10.25    .01    50      2000
    i2    10.36    .25    86      2000
s

;*****************************  2000HZ WITH MASKING AT 20 MS  **************************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i1     1.25    .01    86      2000
    i2     1.28    .25    86      2000
    i2     2.00    .25    86      2000
    i1     2.25    .01    82      2000
    i2     2.28    .25    86      2000
    i2     3.00    .25    86      2000
    i1     3.25    .01    78      2000
    i2     3.28    .25    86      2000
    i2     4.00    .25    86      2000
    i1     4.25    .01    74      2000
    i2     4.28    .25    86      2000
    i2     5.00    .25    86      2000
    i1     5.25    .01    70      2000
    i2     5.28    .25    86      2000
    i2     6.00    .25    86      2000
    i1     6.25    .01    66      2000
    i2     6.28    .25    86      2000
    i2     7.00    .25    86      2000
    i1     7.25    .01    62      2000
    i2     7.28    .25    86      2000
    i2     8.00    .25    86      2000
    i1     8.25    .01    58      2000
    i2     8.28    .25    86      2000
    i2     9.00    .25    86      2000
    i1     9.25    .01    54      2000
    i2     9.28    .25    86      2000
    i2    10.00    .25    86      2000
    i1    10.25    .01    50      2000
    i2    10.28    .25    86      2000
s

;*****************************  2000HZ WITH MASKING AT 0 MS  ***************************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i1     1.25    .01    86      2000
    i2     1.26    .25    86      2000
    i2     2.00    .25    86      2000
    i1     2.25    .01    82      2000
    i2     2.26    .25    86      2000
    i2     3.00    .25    86      2000
    i1     3.25    .01    78      2000
    i2     3.26    .25    86      2000
    i2     4.00    .25    86      2000
    i1     4.25    .01    74      2000
    i2     4.26    .25    86      2000
    i2     5.00    .25    86      2000
    i1     5.25    .01    70      2000
    i2     5.26    .25    86      2000
    i2     6.00    .25    86      2000
    i1     6.25    .01    66      2000
    i2     6.26    .25    86      2000
    i2     7.00    .25    86      2000
    i1     7.25    .01    62      2000
    i2     7.26    .25    86      2000
    i2     8.00    .25    86      2000
    i1     8.25    .01    58      2000
    i2     8.26    .25    86      2000
    i2     9.00    .25    86      2000
    i1     9.25    .01    54      2000
    i2     9.26    .25    86      2000
    i2    10.00    .25    86      2000
    i1    10.25    .01    50      2000
    i2    10.26    .25    86      2000
s

;***************************************   FORWARD MASKING   ****************************************

;*****************************  2000HZ WITH MASKING AT 100 MS  ***************************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i2     1.45    .25    86      2000
    i1     1.80    .01    86      2000
    i2     2.00    .25    86      2000
    i2     2.45    .25    86      2000
    i1     2.80    .01    82      2000
    i2     3.00    .25    86      2000
    i2     3.45    .25    86      2000
    i1     3.80    .01    78      2000
    i2     4.00    .25    86      2000
    i2     4.45    .25    86      2000
    i1     4.80    .01    74      2000
    i2     5.00    .25    86      2000
    i2     5.45    .25    86      2000
    i1     5.80    .01    70      2000
    i2     6.00    .25    86      2000
    i2     6.45    .25    86      2000
    i1     6.80    .01    66      2000
    i2     7.00    .25    86      2000
    i2     7.45    .25    86      2000
    i1     7.80    .01    62      2000
    i2     8.00    .25    86      2000
    i2     8.45    .25    86      2000
    i1     8.80    .01    58      2000
    i2     9.00    .25    86      2000
    i2     9.45    .25    86      2000
    i1     9.80    .01    54      2000
    i2    10.00    .25    86      2000
    i2    10.45    .25    86      2000
    i1    10.80    .01    50      2000

s

;*****************************  2000HZ WITH MASKING AT 20 MS  ***************************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i2     1.45    .25    86      2000
    i1     1.72    .01    86      2000
    i2     2.00    .25    86      2000
    i2     2.45    .25    86      2000
    i1     2.72    .01    82      2000
    i2     3.00    .25    86      2000
    i2     3.45    .25    86      2000
    i1     3.72    .01    78      2000
    i2     4.00    .25    86      2000
    i2     4.45    .25    86      2000
    i1     4.72    .01    74      2000
    i2     5.00    .25    86      2000
    i2     5.45    .25    86      2000
    i1     5.72    .01    70      2000
    i2     6.00    .25    86      2000
    i2     6.45    .25    86      2000
    i1     6.72    .01    66      2000
    i2     7.00    .25    86      2000
    i2     7.45    .25    86      2000
    i1     7.72    .01    62      2000
    i2     8.00    .25    86      2000
    i2     8.45    .25    86      2000
    i1     8.72    .01    58      2000
    i2     9.00    .25    86      2000
    i2     9.45    .25    86      2000
    i1     9.72    .01    54      2000
    i2    10.00    .25    86      2000
    i2    10.45    .25    86      2000
    i1    10.72    .01    50      2000

s

;*****************************  2000HZ WITH MASKING AT 0 MS  ***************************************
;   p1      p2      p3    p4       p5
;  inst    strt    isus   amp     ifc
    i2     1.00    .25    86      2000
    i2     1.45    .25    86      2000
    i1     1.70    .01    86      2000
    i2     2.00    .25    86      2000
    i2     2.45    .25    86      2000
    i1     2.70    .01    82      2000
    i2     3.00    .25    86      2000
    i2     3.45    .25    86      2000
    i1     3.70    .01    78      2000
    i2     4.00    .25    86      2000
    i2     4.45    .25    86      2000
    i1     4.70    .01    74      2000
    i2     5.00    .25    86      2000
    i2     5.45    .25    86      2000
    i1     5.70    .01    70      2000
    i2     6.00    .25    86      2000
    i2     6.45    .25    86      2000
    i1     6.70    .01    66      2000
    i2     7.00    .25    86      2000
    i2     7.45    .25    86      2000
    i1     7.70    .01    62      2000
    i2     8.00    .25    86      2000
    i2     8.45    .25    86      2000
    i1     8.70    .01    58      2000
    i2     9.00    .25    86      2000
    i2     9.45    .25    86      2000
    i1     9.70    .01    54      2000
    i2    10.00    .25    86      2000
    i2    10.45    .25    86      2000
    i1    10.70    .01    50      2000
e






























</CsScore>
</CsoundSynthesizer>
