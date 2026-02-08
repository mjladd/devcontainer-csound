<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from TempIntegration.orc and TempIntegration.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;**************************************   TEMPORAL INTEGRATION   *************************************

; HOW DOES THE LOUDNESS OF AN IMPULSIVE SOUND COMPARE WITH THE LOUDNESS OF A STEADY SOUND AT THE SAME
; LEVEL? NUMEROUS EXPERIMENTS HAVE PRETTY WELL ESTABLISHED THAT THE EAR AVERAGES SOUND ENERGY OVER A-
; BOUT 0.2S (200MS), SO LOUDNESS GROWS WITH DURATION UP TO THIS VALUE. STATED ANOTHER WAY, LOUDNESS
; LEVEL INCREASES BY 10DB WHEN THE DURATION IS INCREASED BY A FACTOR OF 10. THE LOUDNESS LEVEL OF
; BROADBAND NOISE SEEMS TO DEPEND SOMEWHAT MORE STRONGLY ON STIMULUS DURATION THAN THE LOUDNESS LEVEL
; OF PURE TONES.
; IN THIS DEMONSTRATION, BURSTS OF BROADBAND NOISE HAVING DURATIONS OF 1000, 300,100, 30, 10, 3, AND
; 1MS ARE PRESENTED AT 8 DECREASING LEVELS (0,-16,-20,-24,-28,-32,-36,AND -40DB) IN THE PRESENCE OF
; A BROADBAND MASKING NOISE.

;***************************************   HEADER   **************************************************




 instr         1

 iamp          =         ampdb(p4)                     ;P4 = AMPLITUDE IN DB


 k1            linen     iamp,.01,p3,.01
 anoise        randi     k1, .998 * 10010              ;BROADBAND NOISE 20 - 20KHZ
 asig          oscil     anoise,anoise,1
               outs      asig,asig
 endin


</CsInstruments>
<CsScore>

f1 0 32768 10 1                                                                      ; SINE WAVE



;*************************************   TEMPORAL INTEGRATION   ************************************
;******************************************   1000ms   *********************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i1      1       50    56                                                         ; BROADBAND MASKING NOISE
    i1      5       1     80
    i1      6.5     1     64
    i1      8.0     1     60
    i1      9.5     1     56
    i1     11.0     1     52
    i1     12.5     1     48
    i1     14.0     1     44
    i1     15.5     1     40
 ;*****************************************   300ms   **********************************************
    i1     17.0     .3    80
    i1     17.8     .3    64
    i1     18.6     .3    60
    i1     19.4     .3    56
    i1     21.2     .3    52
    i1     22.0     .3    48
    i1     22.8     .3    44
    i1     23.6     .3    40
 ;****************************************   100ms   ***********************************************
    i1     24.4     .1    80
    i1     25.0     .1    64
    i1     25.6     .1    60
    i1     26.2     .1    56
    i1     26.8     .1    52
    i1     27.4     .1    48
    i1     28.0     .1    44
    i1     28.6     .1    40
 ;*****************************************   30ms   ***********************************************
    i1     29.2     .03   80
    i1     29.73    .03   64
    i1     30.26    .03   60
    i1     30.79    .03   56
    i1     31.32    .03   52
    i1     31.85    .03   48
    i1     32.38    .03   44
    i1     32.91    .03   40
 ;*****************************************   10ms   ************************************************
    i1     33.44    .01   80
    i1     33.95    .01   64
    i1     34.46    .01   60
    i1     34.97    .01   56
    i1     35.48    .01   52
    i1     35.99    .01   48
    i1     36.50    .01   44
    i1     37.01    .01   40
 ;******************************************   3ms   ************************************************
    i1     37.52    .003  80
    i1     38.023   .003  64
    i1     38.526   .003  60
    i1     39.029   .003  56
    i1     39.532   .003  52
    i1     40.035   .003  48
    i1     40.538   .003  44
    i1     41.041   .003  40
 ;******************************************   1ms   ************************************************
    i1     41.544   .001  80
    i1     42.045   .001  64
    i1     42.546   .001  60
    i1     43.047   .001  56
    i1     43.548   .001  52
    i1     44.049   .001  48
    i1     44.550   .001  44
    i1     45.051   .001  40
 e

</CsScore>
</CsoundSynthesizer>
