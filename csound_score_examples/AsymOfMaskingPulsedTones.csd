<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from AsymOfMaskingPulsedTones.orc and AsymOfMaskingPulsedTones.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;******************   ASYMMETRY OF MASKING BY PULSED TONES   ********************
; A PURE TONE MASKS TONES OF HIGHER FREQUENCY MORE EFFECTIVELY THAN TONES OF LOW-
; FREQUENCY. THIS MAYBE EXPLAINED BY REFERENCE TO THE SIMPLIFIED RESPONSE OF THE
; BASILAR MEMBTRANE FOR TWO PURE TONES A AND B.
; THIS DEMONSTRATION USES TONES OF 1200HZ AND 2000HZ, PRESENTED AS 200MS TONE
; BURSTS SEPARATED BY 100MS. THE TEST TONE, WHICH APPEARS EVERY OTHER PULSE, DE-
; CREASES IN 10 STEPS OF 5DB, EXCEPT THE FIRST STEP WHICH IS 15DB.



;                      MASKER
;    *******  *******  *******  *******
;    *     *  *     *  *     *  *     *
;*****     ****     ****     ****     *******
;              200MS        100MS



;                   TEST TONE
;             *******           *******
;             *     *           *     *
; *************     *************     *******
;              200MS



;*********************************   HEADER   *********************************


 instr         1

 iamp          =         ampdb(p4)
 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,p5,1
               outs      a1,a1
 endin





</CsInstruments>
<CsScore>


f1 0 512 10 1

;**********************   ASYMMETRY OF MASKING BY PULSED TONES   *****************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     1.0     .2     75      1200
    i1     1.3     .2     75      1200
    i1     1.3     .2     75      2000
    i1     1.6     .2     75      1200
    i1     1.9     .2     75      1200
    i1     1.9     .2     60      2000
    i1     2.2     .2     75      1200
    i1     2.5     .2     75      1200
    i1     2.5     .2     55      2000
    i1     2.8     .2     75      1200
    i1     3.1     .2     75      1200
    i1     3.1     .2     50      2000
    i1     3.4     .2     75      1200
    i1     3.7     .2     75      1200
    i1     3.7     .2     45      2000
    i1     4.0     .2     75      1200
    i1     4.3     .2     75      1200
    i1     4.3     .2     40      2000
    i1     4.6     .2     75      1200
    i1     4.9     .2     75      1200
    i1     4.9     .2     35      2000
    i1     5.2     .2     75      1200
    i1     5.5     .2     75      1200
    i1     5.5     .2     30      2000
    i1     5.8     .2     75      1200
    i1     6.1     .2     75      1200
    i1     6.1     .2     25      2000
    i1     6.4     .2     75      1200
    i1     6.7     .2     75      1200
    i1     6.7     .2     20      2000
    i1     7.0     .2     75      1200
    i1     7.3     .2     75      1200
    i1     7.3     .2     15      2000
    s
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     1.0     .2     75      2000
    i1     1.3     .2     75      2000
    i1     1.3     .2     75      1200
    i1     1.6     .2     75      2000
    i1     1.9     .2     75      2000
    i1     1.9     .2     60      1200
    i1     2.2     .2     75      2000
    i1     2.5     .2     75      2000
    i1     2.5     .2     55      1200
    i1     2.8     .2     75      2000
    i1     3.1     .2     75      2000
    i1     3.1     .2     50      1200
    i1     3.4     .2     75      2000
    i1     3.7     .2     75      2000
    i1     3.7     .2     45      1200
    i1     4.0     .2     75      2000
    i1     4.3     .2     75      2000
    i1     4.3     .2     40      1200
    i1     4.6     .2     75      2000
    i1     4.9     .2     75      2000
    i1     4.9     .2     35      1200
    i1     5.2     .2     75      2000
    i1     5.5     .2     75      2000
    i1     5.5     .2     30      1200
    i1     5.8     .2     75      2000
    i1     6.1     .2     75      2000
    i1     6.1     .2     25      1200
    i1     6.4     .2     75      2000
    i1     6.7     .2     75      2000
    i1     6.7     .2     20      1200
    i1     7.0     .2     75      2000
    i1     7.3     .2     75      2000
    i1     7.3     .2     15      1200
    e



</CsScore>
</CsoundSynthesizer>
