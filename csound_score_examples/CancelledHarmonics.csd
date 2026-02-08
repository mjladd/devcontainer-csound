<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from CancelledHarmonics.orc and CancelledHarmonics.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;************************************   CANCELLED HARMONICS   ***************************************

; THIS DEMONSTRATION ILLUSTRATES FOURIER ANALYSIS OF A COMPLEX TONE CONSISTING OF 20 HARMONICS OF A
; 200HZ FUNDAMENTAL. IT ALSO ILLUSTRATES HOW OUR AUDITORY SYSTEM, LIKE OUR OTHER SENSES, HAS THE ABI-
; LITY TO LISTEN TO COMPLEX SOUNDS IN DIFFERENT MODES. WHEN WE LISTEN "ANALYTICALLY OR IN AN ISOLATIVE
; WAY", WE HEAR THE DIFFERENT COMPONENTS SEPARATELY; WHEN WE LISTEN "HOLISTICALLY",WE FOCUS ON THE
; WHOLE SOUND AND PAY LITTLE ATTENTION TO THE COMPONENTS.
; A COMPEX TONE IS PRESENTED TO THE LISTENER(S), FOLLOWED BY SEVERAL CANCELLATIONS AND RESTORATIONS OF
; A PARTICULAR HARMONIC. THIS IS DONE FOR HARMONICS 1 THROUGH 10.

;***************************************   HEADER   **************************************************




 instr         1

 iamp          =         ampdb(p4)
 ifunc         =         p5


 a1            oscili    iamp,200,ifunc
               outs      a1,a1
 endin

</CsInstruments>
<CsScore>


 ;HARMONICS   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20

 f1 0 512 10 .5  .5  .5  .5  .5  .5  .5  .7  .7  .7  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f2 0 512 10  0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f3 0 512 10 .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f4 0 512 10 .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f5 0 512 10 .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f6 0 512 10 .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f7 0 512 10 .5  .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f8 0 512 10 .5  .5  .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
 f9 0 512 10 .5  .5  .5  .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
f10 0 512 10 .5  .5  .5  .5  .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5
f11 0 512 10 .5  .5  .5  .5  .5  .5  .5  .5  .5   0  .5  .5  .5  .5  .5  .5  .5  .5  .5  .5



;***********************************   CANCELLED HARMONICS   *****************************************
;   p1      p2      p3    p4       p5
;  inst    strt    dur    amp     ifunc
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        2
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        2
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        2
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        3
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        3
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        3
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        4
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        4
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        4
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        5
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        5
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        5
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        6
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        6
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        6
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        7
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        7
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        7
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        8
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        8
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        8
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76        9
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76        9
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76        9
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76       10
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76       10
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76       10
    i1     7.0     1.0    76        1
s
    i1     1.0     1.0    76        1
    i1     2.0     1.0    76       11
    i1     3.0     1.0    76        1
    i1     4.0     1.0    76       11
    i1     5.0     1.0    76        1
    i1     6.0     1.0    76       11
    i1     7.0     1.0    76        1
e

</CsScore>
</CsoundSynthesizer>
