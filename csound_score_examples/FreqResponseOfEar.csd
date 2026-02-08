<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FreqResponseOfEar.orc and FreqResponseOfEar.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*********************************   FREQUENCY RESPONSE OF THE EAR   ***********************************
; ALTHOUGH SOUNDS WITH A GREATER SOUND PRESSURE LEVEL USUALLY SOUND LOUDER, THIS IS NOT ALWAYS THE CASE.
; THE SENSITIVITY OF THE EAR VARIES WITH THE FREQUENCY AND THE QUALITY OF THE SOUND. MANY YEARS AGO
; FLETCHER AND MUNSON (1933) DETERMINED CURVES OF EQUAL LOUDNESS FOR PURE TONES (THAT IS, TONES OF A
; SINGLE FREQUENCY). THESE CURVES OR SIMILAR CURVES CAN USUALLY BE FOUND IN ACOUSTIC TEXTBOOKS. THESE
; DEMONSTRATE THE RELATIVE INSENSITIVITY OF THE EAR TO LOW INTENSITY LEVELS. HEARING SENSITIVITY REACH-
; ES A MAXIMUM AROUND 4000HZ, WHICH IS NEAR THE FIRST RESONANCE FREQUENCY OF THE OUTER EAR CANAL, AND
; AGAIN PEAKS AROUND 13KHZ, THE FREQUENCY OF THE SECOND RESONANCE.
; IN THIS DEMONSTRATION, WE COMPARE THE THRESHOLDS OF AUDIBILITY (IN A ROOM) OF TONES HAVING FREQUEN-
; CIES OF 125, 250, 500, 1000, 2000, 4000, AND 8000HZ. THE TONES ARE 100MS IN LENGTH AND DECREASE IN 10
; STEPS OF -5DB.
; FIRST ADJUST THE LEVEL OF THE CALIBRATION TONE SO THAT IT IS JUST AUDIBLE.
;*****************************************   HEADER   *************************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin


</CsInstruments>
<CsScore>
f1 0 512 10 1                                                    ; Sine wave


;************************************  FREQUENCY RESPONSE OF THE EAR   *******************************

;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     10     30     1000                            ; CALIBRATION TONE
    s
;***************************************   -5dB DECRIMENTS   **************************************

;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60      125
    i1     1.4     .1     55      125
    i1     1.8     .1     50      125
    i1     2.2     .1     45      125
    i1     2.6     .1     40      125
    i1     3.0     .1     35      125
    i1     3.4     .1     30      125
    i1     3.8     .1     25      125
    i1     4.2     .1     20      125
    i1     4.6     .1     15      125
    i1     5.0     .1     10      125
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60      250
    i1     1.4     .1     55      250
    i1     1.8     .1     50      250
    i1     2.2     .1     45      250
    i1     2.6     .1     40      250
    i1     3.0     .1     35      250
    i1     3.4     .1     30      250
    i1     3.8     .1     25      250
    i1     4.2     .1     20      250
    i1     4.6     .1     15      250
    i1     5.0     .1     10      250
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60      500
    i1     1.4     .1     55      500
    i1     1.8     .1     50      500
    i1     2.2     .1     45      500
    i1     2.6     .1     40      500
    i1     3.0     .1     35      500
    i1     3.4     .1     30      500
    i1     3.8     .1     25      500
    i1     4.2     .1     20      500
    i1     4.6     .1     15      500
    i1     5.0     .1     10      500
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60     1000
    i1     1.4     .1     55     1000
    i1     1.8     .1     50     1000
    i1     2.2     .1     45     1000
    i1     2.6     .1     40     1000
    i1     3.0     .1     35     1000
    i1     3.4     .1     30     1000
    i1     3.8     .1     25     1000
    i1     4.2     .1     20     1000
    i1     4.6     .1     15     1000
    i1     5.0     .1     10     1000
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60     2000
    i1     1.4     .1     55     2000
    i1     1.8     .1     50     2000
    i1     2.2     .1     45     2000
    i1     2.6     .1     40     2000
    i1     3.0     .1     35     2000
    i1     3.4     .1     30     2000
    i1     3.8     .1     25     2000
    i1     4.2     .1     20     2000
    i1     4.6     .1     15     2000
    i1     5.0     .1     10     2000
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60     4000
    i1     1.4     .1     55     4000
    i1     1.8     .1     50     4000
    i1     2.2     .1     45     4000
    i1     2.6     .1     40     4000
    i1     3.0     .1     35     4000
    i1     3.4     .1     30     4000
    i1     3.8     .1     25     4000
    i1     4.2     .1     20     4000
    i1     4.6     .1     15     4000
    i1     5.0     .1     10     4000
    s
;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i1     1.0     .1     60     8000
    i1     1.4     .1     55     8000
    i1     1.8     .1     50     8000
    i1     2.2     .1     45     8000
    i1     2.6     .1     40     8000
    i1     3.0     .1     35     8000
    i1     3.4     .1     30     8000
    i1     3.8     .1     25     8000
    i1     4.2     .1     20     8000
    i1     4.6     .1     15     8000
    i1     5.0     .1     10     8000
    e

</CsScore>
</CsoundSynthesizer>
