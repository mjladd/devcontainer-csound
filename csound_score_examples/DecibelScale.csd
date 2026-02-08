<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from DecibelScale.orc and DecibelScale.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;**************************************   THE DECIBEL SCALE   *************************************

; IN THIS DEMONSTRATION, WE HEAR BROADBAND NOISE REDUCED IN STEPS OF 6, 3, AND 1DB IN ORDER TO OB-
; TAIN A FEELING FOR THE DECIBEL SCALE.
; BROADBAND NOISE IS REDUCED IN 10 STEPS OF 6 DECIBELS. THEN BROADBAND NOISE IS REDUCED IN 15 STEPS
; OF 3 DECIBELS. AND FINALLY, BROADBAND NOISE IS REDUCED IN STEPS OF 1 DECIBEL.
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

f1 0 32768 10 1                                                            ; SINE WAVE




;*************************************   THE DECIBEL SCALE   ****************************************
;************************************   6 DECIBEL DECRIMENTS   **************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i1     1.0     1.0    80
    i1     3.0     1.0    74
    i1     5.0     1.0    68
    i1     7.0     1.0    62
    i1     9.0     1.0    56
    i1    11.0     1.0    50
    i1    13.0     1.0    44
    i1    15.0     1.0    38
    i1    17.0     1.0    32
    i1    19.0     1.0    26
    i1    21.0     1.0    20
    s
;************************************   3 DECIBEL DECRIMNETS   ***************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i1     1.0     1.0    80
    i1     3.0     1.0    77
    i1     5.0     1.0    74
    i1     7.0     1.0    71
    i1     9.0     1.0    68
    i1    11.0     1.0    65
    i1    13.0     1.0    62
    i1    15.0     1.0    58
    i1    17.0     1.0    55
    i1    19.0     1.0    52
    i1    21.0     1.0    49
    i1    23.0     1.0    46
    i1    25.0     1.0    43
    i1    27.0     1.0    40
    i1    29.0     1.0    37
    i1    31.0     1.0    34
    s
;************************************   1 DECIBEL DECRIMNETS   ***************************************
;   p1      p2      p3     p4
;  inst    strt    dur    amp
    i1     1.0     1.0    80
    i1     3.0     1.0    79
    i1     5.0     1.0    78
    i1     7.0     1.0    77
    i1     9.0     1.0    76
    i1    11.0     1.0    75
    i1    13.0     1.0    74
    i1    15.0     1.0    73
    i1    17.0     1.0    72
    i1    19.0     1.0    71
    i1    21.0     1.0    70
    i1    23.0     1.0    69
    i1    25.0     1.0    68
    i1    27.0     1.0    67
    i1    29.0     1.0    66
    i1    31.0     1.0    65
    i1    33.0     1.0    64
    i1    35.0     1.0    63
    i1    37.0     1.0    62
    i1    39.0     1.0    61
    i1    41.0     1.0    60
    i1    43.0     1.0    59
    e


</CsScore>
</CsoundSynthesizer>
