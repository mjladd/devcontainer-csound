<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from MaskingLevelDifferences.orc and MaskingLevelDifferences.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*************************************   MASKING LEVEL DIFFERENCES   ***********************************
; BINAURAL HEARING HELPS US TO RECEIVE AUDITORY SIGNALS IN NOISY ENVIRONMENTS. LICKLIDER (1948)
; DISCOVERED THE PHENOMENON CALLED "MASKING LEVEL DIFFERENCE" FOR SPEECH; HIRSH (1948) DEMONSTRATED
; IT FOR SINUSOIDAL SIGNALS, AS IN THE DEMONSTRATION.
; THE FIRST EXAMPLE IN THE DEMONSTRATION BEGINS BY PLAYING A 500HZ SIGNAL OF 100MS DURATION IN THE
; LEFT EAR. THEN THIS SIGNAL IS MASKED BY NOISE. THE STAIRCASE PROCEDURE IS USED, SO THAT YOU CAN
; COUNT THE LEVEL AT WHICH THE SIGNAL BECOMES INAUDIBLE. THE STAIRCASE CONTAINS 10 STEPS; THE FIRST
; STEP IS -10DB, AND THE REMAINING 9 STEPS ARE -3DB EACH.
; IN THE THIRD EXAMPLE, NOISE IS ADDED TO THE OTHER EAR. THE NOISE NOW APPEARS TO HAVE A DIFFERENT
; SPATIAL LOCATION (ALBEIT INSIDE THE HEAD) FROM THE SIGNAL, AND THE SIGNAL IS MUCH EASIER TO HEAR.
; IN THE FOURTH EXAMPLE, THE SIGNAL IS AGAIN MADE DIFFICULT TO HEAR BY ADDING A SIGNAL TO THE NOISE
; IN THE RIGHT EAR, SO THAT THE AUDITORY IMAGES OF THE SIGNAL AND NOISE AGAIN COINCIDE.
; THE FIFTH EXAMPLE DEMONSTRATES THEAT INVERTING THE SIGNAL AT ONE OF THE EARS PLACES THE NOISE AND
; SIGNAL IN DIFFERENT AUDITORY LOCATIONS. IN THIS CONFIGURATION, THE SIGNAL IS EASY TO HEAR.
; THE SIGNAL, WHICH IS SIMILAR TO NO. 11 IN THE "HARVARD TAPES" CAN BE SUMMARIZED,AS FOLLOWS: 1) S(L)
; 2) S(L)N(L); 3) S(L)N(L,R); 4) S(L,R)N(L,R); 5) S(L)$(R)N(L,R), WHERE S = SIGNAL, $ = SIGNAL OF
; REVERSED PHASE, N = NOISE, L = LEFT, R = RIGHT. THE SIGNAL IS MORE EASILY HEARD IN EXAMPLES 1, 3,
; AND 5. IN THE ORIGINAL HARVARD TAPES, THE DEMONSTRATION IS REPEATED AT 2000HZ, WHERE THE EFFECT HAS
; FADED, THUS DEMONSTRATING THE STRONG FREQUENCY DEPENDENCE OF MASKING LEVEL DIFFERENCE (HIRSH, 1948).
;*****************************************   HEADER   *************************************************




 instr         1

 iamp          =         ampdb(p4)                          ;P4 = AMPLITUDE IN DB
 ifunc         =         p5                                 ;P5 = FUNCTION
                                                            ;P6 = PANNING FUNCTION FOR SIGNAL

 k1            linen     iamp,.02,p3,.02
 a1            oscili    k1,500,p5
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin

 instr         2

 iamp          =         ampdb(p4)                          ;P4 = AMPLITUDE IN DB
                                                            ;P5 = PANNING FUNCTION FOR SIGNAL

 k1            linen      iamp,.01,p3,.01
 anoise        randi      k1, .998 * 10010                  ;NOISE WITH A BANDWIDTH FROM 20 - 20KHZ
 a1            oscil      anoise,anoise,1
 k2            oscili    1,p3,p5
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin






</CsInstruments>
<CsScore>
f1 0 512 10 1                                                    ; SINE WAVE
f2 0 512 7 1 512 1                                               ; PANNED RIGHT
f3 0 512 7 0 512 0                                               ; PANNED LEFT
f4 0 512 9 1 1 180                                               ; SIGNAL INVERTED

;************************************   MASKING LEVEL DIFFERNCES   ************************************
;******************************************   SIGNAL(L)   ********************************************
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i1     1.0     .1      70       1       3
    i1     1.5     .1      60       1       3
    i1     2.0     .1      57       1       3
    i1     2.5     .1      54       1       3
    i1     3.0     .1      51       1       3
    i1     3.5     .1      48       1       3
    i1     4.0     .1      45       1       3
    i1     4.5     .1      42       1       3
    i1     5.0     .1      39       1       3
    i1     5.5     .1      36       1       3
    i1     6.0     .1      33       1       3
s
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i1     3.0     .1      70       1       3
    i1     3.5     .1      60       1       3
    i1     4.0     .1      57       1       3
    i1     4.5     .1      54       1       3
    i1     5.0     .1      51       1       3
    i1     5.5     .1      48       1       3
    i1     6.0     .1      45       1       3
    i1     6.5     .1      42       1       3
    i1     7.0     .1      39       1       3
    i1     7.5     .1      36       1       3
    i1     8.0     .1      33       1       3
s

;**************************************   SIGNAL(L)NOISE(L)   ************************************
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i2     4.0    20.0     80       3
    i1     8.0     .1      70       1       3
    i1     8.5     .1      60       1       3
    i1     9.0     .1      57       1       3
    i1     9.5     .1      54       1       3
    i1    10.0     .1      51       1       3
    i1    10.5     .1      48       1       3
    i1    11.0     .1      45       1       3
    i1    11.5     .1      42       1       3
    i1    12.0     .1      39       1       3
    i1    12.5     .1      36       1       3
    i1    13.0     .1      33       1       3
    i1    16.0     .1      70       1       3
    i1    16.5     .1      60       1       3
    i1    17.0     .1      57       1       3
    i1    17.5     .1      54       1       3
    i1    18.0     .1      51       1       3
    i1    18.5     .1      48       1       3
    i1    19.0     .1      45       1       3
    i1    19.5     .1      42       1       3
    i1    20.0     .1      39       1       3
    i1    20.5     .1      36       1       3
    i1    21.0     .1      33       1       3
s
;************************************   SIGNAL(L)NOISE(L,R)   ************************************
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i2     4.0    20.0     80       3
    i2     4.0    20.0     80       2
    i1     8.0     .1      70       1       3
    i1     8.5     .1      60       1       3
    i1     9.0     .1      57       1       3
    i1     9.5     .1      54       1       3
    i1    10.0     .1      51       1       3
    i1    10.5     .1      48       1       3
    i1    11.0     .1      45       1       3
    i1    11.5     .1      42       1       3
    i1    12.0     .1      39       1       3
    i1    12.5     .1      36       1       3
    i1    13.0     .1      33       1       3
    i1    16.0     .1      70       1       3
    i1    16.5     .1      60       1       3
    i1    17.0     .1      57       1       3
    i1    17.5     .1      54       1       3
    i1    18.0     .1      51       1       3
    i1    18.5     .1      48       1       3
    i1    19.0     .1      45       1       3
    i1    19.5     .1      42       1       3
    i1    20.0     .1      39       1       3
    i1    20.5     .1      36       1       3
    i1    21.0     .1      33       1       3
s
;**********************************   SIGNAL(L,R)NOISE(L,R)   ************************************
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i2     4.0    20.0     80       3
    i2     4.0    20.0     80       2
    i1     8.0     .1      70       1       3
    i1     8.0     .1      70       1       2
    i1     8.5     .1      60       1       3
    i1     8.5     .1      60       1       2
    i1     9.0     .1      57       1       3
    i1     9.0     .1      57       1       2
    i1     9.5     .1      54       1       3
    i1     9.5     .1      54       1       2
    i1    10.0     .1      51       1       3
    i1    10.0     .1      51       1       2
    i1    10.5     .1      48       1       3
    i1    10.5     .1      48       1       2
    i1    11.0     .1      45       1       3
    i1    11.0     .1      45       1       2
    i1    11.5     .1      42       1       3
    i1    11.5     .1      42       1       2
    i1    12.0     .1      39       1       3
    i1    12.0     .1      39       1       2
    i1    12.5     .1      36       1       3
    i1    12.5     .1      36       1       2
    i1    13.0     .1      33       1       3
    i1    13.0     .1      33       1       2
    i1    16.0     .1      70       1       3
    i1    16.0     .1      70       1       2
    i1    16.5     .1      60       1       3
    i1    16.5     .1      60       1       2
    i1    17.0     .1      57       1       3
    i1    17.0     .1      57       1       2
    i1    17.5     .1      54       1       3
    i1    17.5     .1      54       1       2
    i1    18.0     .1      51       1       3
    i1    18.0     .1      51       1       2
    i1    18.5     .1      48       1       3
    i1    18.5     .1      48       1       2
    i1    19.0     .1      45       1       3
    i1    19.0     .1      45       1       2
    i1    19.5     .1      42       1       3
    i1    19.5     .1      42       1       2
    i1    20.0     .1      39       1       3
    i1    20.0     .1      39       1       2
    i1    20.5     .1      36       1       3
    i1    20.5     .1      36       1       2
    i1    21.0     .1      33       1       3
    i1    21.0     .1      33       1       2
s
;*******************************   SIGNAL(L)SIGNAL$(R)NOISE(L,R)   ************************************
;   p1      p2      p3      p4      p5      p6
;  inst    strt    dur     amp    ifunc   panfunc
    i2     4.0    20.0     80       3
    i2     4.0    20.0     80       2
    i1     8.0     .1      70       1       3
    i1     8.0     .1      70       4       2
    i1     8.5     .1      60       1       3
    i1     8.5     .1      60       4       2
    i1     9.0     .1      57       1       3
    i1     9.0     .1      57       4       2
    i1     9.5     .1      54       1       3
    i1     9.5     .1      54       4       2
    i1    10.0     .1      51       1       3
    i1    10.0     .1      51       4       2
    i1    10.5     .1      48       1       3
    i1    10.5     .1      48       4       2
    i1    11.0     .1      45       1       3
    i1    11.0     .1      45       4       2
    i1    11.5     .1      42       1       3
    i1    11.5     .1      42       4       2
    i1    12.0     .1      39       1       3
    i1    12.0     .1      39       4       2
    i1    12.5     .1      36       1       3
    i1    12.5     .1      36       4       2
    i1    13.0     .1      33       1       3
    i1    13.0     .1      33       4       2
    i1    16.0     .1      70       1       3
    i1    16.0     .1      70       4       2
    i1    16.5     .1      60       1       3
    i1    16.5     .1      60       4       2
    i1    17.0     .1      57       1       3
    i1    17.0     .1      57       4       2
    i1    17.5     .1      54       1       3
    i1    17.5     .1      54       4       2
    i1    18.0     .1      51       1       3
    i1    18.0     .1      51       4       2
    i1    18.5     .1      48       1       3
    i1    18.5     .1      48       4       2
    i1    19.0     .1      45       1       3
    i1    19.0     .1      45       4       2
    i1    19.5     .1      42       1       3
    i1    19.5     .1      42       4       2
    i1    20.0     .1      39       1       3
    i1    20.0     .1      39       4       2
    i1    20.5     .1      36       1       3
    i1    20.5     .1      36       4       2
    i1    21.0     .1      33       1       3
    i1    21.0     .1      33       4       2
    e

</CsScore>
</CsoundSynthesizer>
