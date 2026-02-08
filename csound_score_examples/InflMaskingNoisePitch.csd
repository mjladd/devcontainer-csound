<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from InflMaskingNoisePitch.orc and InflMaskingNoisePitch.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;******************   INFLUENCE OF MASKING NOISE ON PITCH   *******************
; THE PITCH OF A TONE IS INFLUENCED  BY THE PRESENCE OF MASKING NOISE OR ANOTH-
; ER TONE NEAR TO IT IN FREQUENCY. IF THE INTERFERING TONE HAS A LOWER FREQUENCY
; AN UPWARD SHIFT IN THE TEST TONE IS ALWAYS OBSERVED. IF THE INYTERFERING TONE
; HAS A HIGHER FREQUENCY, A DOWNWARD SHIFT IS OBSERVED, AT LEAST AT LOW FRE-
; QUENCY (< 300HZ). SIMILARLY, A BAND OF INTERFERING NOISE PRODUCES AN UPWARD
; SHIFT IN A TEST TONE IF THE FREQUENCY OF THE NOISE IS LOWER.
; IN THIS DEMONSTRATION, A 1000HZ TONE, 500MS IN DURATION AND PARTIALLY MASKED
; BY NOISE LOW-PASS FILTERED AT 900HZ, ALTERNATES WITH AN IDENTICAL TONE, PRE-
; SENTED WITHOUT MASKING NOISE. THE TONE PARTIALLY MASKED BY NOISE OF LOWER FRE-
; QUENCY APPEARS SLIGHTLY HIGHER IN PITCH (DO YOU AGREE?). WHEN THE NOISE IS
; TURNED OFF, IT IS CLEAR THAT THE TWO TONES WERE IDENTICAL.

;*****************************   HEADER   *************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin



 instr         2

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifc           =         p5                       ;P5 = FREQUENCY


 k1            linen     iamp,.01,p3,.01
 anoise        randi     k1, .5 * ifc             ; NOISE WITH A BANDWIDTH FROM 400HZ - 1200HZ
 a1            oscil     anoise, ifc, 1
               outs      a1,a1
 endin


</CsInstruments>
<CsScore>

f1 0 512 10 1                                               ; SINE WAVE






;*********************************   INFLUENCE OF MASKING NOISE ON PITCH   **************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     1.0     .5     85      1000
    i1     2.0     .5     85      1000
    i2     2.0     .5     80       800
    i1     3.0     .5     85      1000
    i1     4.0     .5     85      1000
    i2     4.0     .5     80       800
    i1     5.0     .5     85      1000
    i1     6.0     .5     85      1000
    i2     6.0     .5     80       800
    i1     7.0     .5     85      1000
    i1     8.0     .5     85      1000
    i2     8.0     .5     80       800
    i1     9.0     .5     85      1000
    i1    10.0     .5     85      1000
    i2    10.0     .5     80       800
    i1    11.0     .5     85      1000
    i1    12.0     .5     85      1000
    i2    12.0     .5     80       800
    i1    13.0     .5     85      1000
    i1    14.0     .5     85      1000
    i1    15.0     .5     85      1000
    i1    16.0     .5     85      1000
    i1    17.0     .5     85      1000
 e

</CsScore>
</CsoundSynthesizer>
