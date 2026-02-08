<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from JND.orc and JND.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*********************************   FREQUENCY DIFFERENCE LIMEN   ************************************

; THE ABILITY TO DISTINGUISH BETWEEN TWO NEARLY EQUAL STIMULI IS OFTEN CHARACTERIZED BY A "DIFFERENCE
; LIMEN " OR "JUST NOTICEABLE DIFFERENCE"(JND). TWO STIMULI CANNOT BE DISTINGUISHED FROM ONE ANOTHER
; IF THEY DIFFER BY LESS THAN JND. THE JND FOR PITCH HAS BEEN FOUND TO DEPEND ON THE FREQUENCY, THE
; SOUND LEVEL, THE DURATION OF THE TONE, AND THE SUDDENNESS OF THE FREQUENCY CHANGE. TYPICALLY, IT
; IS FOUND TO BE ABOUT 1/30 OF THE CRITICAL BANDWIDTH AT THE SAME FREQUENCY.
; IN THIS DEMONSTRATION, 10 GROUPS OF 4 TONE PAIRS ARE PRESENTED. FOR EACH PAIR, THE SECOND TONE MAY
; BE HIGHER (A) OR LOWER (B) THAN THE FIRST TONE. PAIRS ARE PRESENTED IN RANDOM ORDER WITHIN EACH
; GROUP, AND THEFREQUENCY DIFFERENCE DECREASES BY 1 HZ IN SUCCESSIVE GROUPTHE TONES, 500MS LONG ARE
; SEPARATED BY 250MS. FOLLOWING IS THE ORDER OF PAIRS WITHIN EACH GROUP, WHERE A REPRESENTS (F,F+ *F),
; B REPRESENTS (F+ *F,F) AND F EQUALS 1000HZ.


;  GROUP     *F (HZ)      KEY
;   1         10         A,B,A,A
;   2          9         A,B,B,B
;   3          8         B,A,A,B
;   4          7         B,A,A,B
;   5          6         A,B,A,B
;   6          5         A,B,A,A
;   7          4         B,B,A,A
;   8          3         A,B,A,B
;   9          2         B,B,B,A
;  10          1         B,A,A,B

;********************************************   HEADER   *********************************************



 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin


</CsInstruments>
<CsScore>

f1 0 1024 10 1  0 .4 .1 .2                        ;SIMPLE TONE

;*******************************   JND SC   *************************************

;******************************   GROUP 1   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     0.00    .5     76     1000
    i1      .75    .5     76     1010
    i1     2.00    .5     76     1010
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1000
    i1     4.75    .5     76     1010
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1010
s

;******************************   GROUP 2   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1000
    i1     2.75    .5     76     1009
    i1     4.00    .5     76     1009
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1009
    i1     6.75    .5     76     1000
    i1     8.00    .5     76     1009
    i1     8.75    .5     76     1000
s

;******************************   GROUP 3   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1008
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1000
    i1     4.75    .5     76     1008
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1008
    i1     8.00    .5     76     1008
    i1     8.75    .5     76     1000
s

;******************************   GROUP 4   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1007
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1000
    i1     4.75    .5     76     1007
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1007
    i1     8.00    .5     76     1007
    i1     8.75    .5     76     1000
s

;******************************   GROUP 5   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1000
    i1     2.75    .5     76     1006
    i1     4.00    .5     76     1006
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1006
    i1     8.00    .5     76     1006
    i1     8.75    .5     76     1000
s

;******************************   GROUP 6   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1000
    i1     2.75    .5     76     1005
    i1     4.00    .5     76     1005
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1005
    i1     8.00    .5     76     1000
    i1     8.75    .5     76     1005
s

;******************************   GROUP 7   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1004
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1004
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1004
    i1     8.00    .5     76     1000
    i1     8.75    .5     76     1004
s

;******************************   GROUP 8   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1000
    i1     2.75    .5     76     1003
    i1     4.00    .5     76     1003
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1003
    i1     8.00    .5     76     1003
    i1     8.75    .5     76     1000
s

;******************************   GROUP 9   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1002
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1002
    i1     4.75    .5     76     1000
    i1     6.00    .5     76     1002
    i1     6.75    .5     76     1000
    i1     8.00    .5     76     1000
    i1     8.75    .5     76     1002
s

;******************************   GROUP 10   *************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     freq
    i1     2.00    .5     76     1001
    i1     2.75    .5     76     1000
    i1     4.00    .5     76     1000
    i1     4.75    .5     76     1001
    i1     6.00    .5     76     1000
    i1     6.75    .5     76     1001
    i1     8.00    .5     76     1001
    i1     8.75    .5     76     1000
e


</CsScore>
</CsoundSynthesizer>
