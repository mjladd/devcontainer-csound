<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from OctaveMatching.orc and OctaveMatching.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;****************************************   OCTAVE MATCHING   ****************************************
; EXPERIMENTS ON OCTAVE MATCHING USUALLY INDICATE A PREFERENCE FOR RATIOS THAT ARE GREATER THAN 2.0.
; THIS PREFERENCE FOR STRETCHED OCTAVES IS NOT WELL UNDERSTOOD. IT IS ONLY PARTLY RELATED TO OUR EXPER-
; IENCE WITH HEARING STRETCH-TUNED PIANOS. MORE LIKELY, IT IS RELATED TO THE PHENOMENON WE ENCOUNTERED
; IN "INFLUENCE OF MASKING NOISE ON PITCH"., ALTHOUGH IN THAT DEMONSTRATION THE TONES ARE PRESENTED AL-
; TERNATELY RATHER THAN SIMULTANEOUSLY.
; IN THIS DEMONSTRATION, A 500HZ TONE OF ONE SECOND DURATION ALTERNATES WITH ANOTHER TONE THAT VARIES
; FROM 985 TO 1035HZ IN STEPS OF 5HZ. WHICH ONE SOUNDS LIKE A CORRECT OCTAVE? MOST LISTENERS WILL PRO-
; BABLY SELECT A TONE SOMEWHERE AROUND 1010HZ.

;*******************************************   HEADER   **********************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.03,p3,.03
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin


</CsInstruments>
<CsScore>

f1 0 1024 10 1  0 .4 .1 .2                                       ;SIMPLE TONE



;*****************************************    OCTAVE MATCHING   **************************************

;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     1.0     1.0    80      500
    i1     2.5     1.0    80      985
    i1     4.0     1.0    80      500
    i1     5.5     1.0    80      990
    i1     7.0     1.0    80      500
    i1     8.5     1.0    80      995
    i1    10.0     1.0    80      500
    i1    11.5     1.0    80     1000
    i1    13.0     1.0    80      500
    i1    14.5     1.0    80     1005
    i1    16.0     1.0    80      500
    i1    17.5     1.0    80     1010
    i1    19.0     1.0    80      500
    i1    20.5     1.0    80     1015
    i1    22.0     1.0    80      500
    i1    23.5     1.0    80     1020
    i1    25.0     1.0    80      500
    i1    26.5     1.0    80     1025
    i1    28.0     1.0    80      500
    i1    29.5     1.0    80     1030
    i1    31.0     1.0    80      500
    i1    32.5     1.0    80     1035
    e


</CsScore>
</CsoundSynthesizer>
