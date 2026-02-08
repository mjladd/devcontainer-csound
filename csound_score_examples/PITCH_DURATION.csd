<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PITCH_DURATION.orc and PITCH_DURATION.sco
; Original files preserved in same directory

 sr            =         44100
 kr            =         4410
 ksmps         =         10
 nchnls        =         1


;*************************************    PITCH AND DURATION     ***********************************

; SINE WAVES WILL BE PRESENTED AT 3 DIFFERENT FREQUENCIES TO THE LISTENER(S) IN ORDER TO ILLUSTRATE
; THE RELATIONSHIP BETWEEN PITCH SALIENCE AND DURATION. THE FREQUENCIES ARE AS FOLLOWS: 300HZ,
; 1000HZ, AND 3000HZ. EACH TONE WILL BE PRESENTED IN BURSTS OF 1, 2, 4, 8, 16, 32, 64, AND 128 PER-
; IODS. YOU SHOULD PERCEIVE A CHANGE FROM A CLICK TO A TONE.


;******************************************   HEADER   *********************************************




 instr         1

 idel          =         p6                       ;P4 = AMPLITUDE IN DB
 irel          =         p7                       ;P5 = FREQUENCY
 isus          =         p3 - (idel + irel)       ;P6 = ATTACK OF ENVELOPE
 iamp          =         ampdb(p4)                ;P7 = RELEASE OF ENVELOPE

 k1            linen     iamp,p6,p3,p7
 a1            oscili    k1,p5,1
               out a1
 endin


</CsInstruments>
<CsScore>


f1 0 32768 10 1                                                  ; SINE WAVE






;*************************************  PITCH AND DURATION  ****************************************
;   p1      p2      p3    p4       p5       p6      p7
;  inst    strt    dur    amp     freq     atk     rel
    i1    1.00    .003    66       300      0       0
    i1    1.253   .006    66       300      0       0
    i1    1.509   .013    66       300      0       0
    i1    1.772   .024    66       300      0       0
    i1    2.046   .053    66       300      0       0
    i1    2.349   .106    66       300      0       0
    i1    2.705   .213    66       300      0       0
    i1    3.168   .426    66       300      0       0
s
;   p1      p2      p3    p4       p5       p6      p7
;  inst    strt    dur    amp     freq     atk     rel
    i1    1.00    .001    70      1000      0       0
    i1    1.253   .002    70      1000      0       0
    i1    1.509   .004    70      1000      0       0
    i1    1.772   .008    70      1000      0       0
    i1    2.046   .016    70      1000      0       0
    i1    2.349   .032    70      1000      0       0
    i1    2.705   .064    70      1000      0       0
    i1    3.168   .128    70      1000      0       0
s
;   p1      p2      p3     p4       p5       p6      p7
;  inst    strt    dur     amp     freq     atk     rel
    i1    1.00    .0003    63      3000      0       0
    i1    1.253   .0006    63      3000      0       0
    i1    1.509   .0013    63      3000      0       0
    i1    1.772   .0024    63      3000      0       0
    i1    2.046   .0053    63      3000      0       0
    i1    2.349   .0106    63      3000      0       0
    i1    2.705   .0213    63      3000      0       0
    i1    3.168   .0426    63      3000      0       0
endin

</CsScore>
</CsoundSynthesizer>
