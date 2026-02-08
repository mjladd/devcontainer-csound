<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Analytic_SyntheticPitch.orc and Analytic_SyntheticPitch.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*********************************   ANALYTIC VS. SYNTHETIC PITCH   ***********************************
; OUR AUDITORY SYSTEM HAS THE ABILITY TO LISTEN TO COMPLEX SOUNDS IN DIFFERENT MODES. WHEN WE LISTEN
; "ANALYTICALLY", WE HEAR THE DIFFERENT FREQUENCY COMPONENTS SEPARATELY; WHEN WE LISTEN "SYNTHETICALLY"
; OR HOLISTICALLY, WE FOCUS ON THE WHOLE SOUND AND PAY LITTLE ATTENTION TO ITS COMPONENTS.
; IN THIS DEMONSTRATION, WHICH WAS ORIGINALLY DESCRIBED BY SMOORENBURG (1970), A TWO-TONE COMPLEX OF
; 800 AND 1000HZ IS FOLLOWED BY ONE OF 750 AND 1000HZ. IF YOU LISTEN ANALYTICALLY, YOU WILL HEAR ONE
; PARTIAL GO DOWN ON PITCH; IF YOU LISTEN SYNTHETICALLY YOU WILL HEAR THE PITCH OF THE MISSING FUNDA-
; MENTAL GO UP IN PITCH (A MAJOR THIRD, FROM 200 TO 250HZ.)

;*****************************************   HEADER   *************************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY

 k1            linen     iamp,.01,p3,.01
 a1            oscili    k1,ifreq,1
               outs      a1,a1
 endin

 instr         2

 iamp          =         ampdb(p4)

 k1            linen     iamp,.01,p3,.01
 anoise        randi     k1, .998 * 10010         ; NOISE WITH A BANDWIDTH FROM 20 - 20KHZ
 a1            oscil     anoise,anoise,1
               outs      a1,a1
 endin

</CsInstruments>
<CsScore>
f1 0 512 10 1


;************************************   ANALYTIC VS. SYNTHETIC PITCH   *******************************

;   p1      p2      p3     p4      p5
;  inst    strt    dur    amp    ifreq
    i2      0      16.0    74
    i1      3        .5    76     800
    i1      3        .5    76    1000
    i1      4        .5    76     750
    i1      4        .5    76    1000
    i1      6        .5    76     800
    i1      6        .5    76    1000
    i1      7        .5    76     750
    i1      7        .5    76    1000
    i1      9        .5    76     800
    i1      9        .5    76    1000
    i1     10        .5    76     750
    i1     10        .5    76    1000
    i1     12        .5    76     800
    i1     12        .5    76    1000
    i1     13        .5    76     750
    i1     13        .5    76    1000
    e


</CsScore>
</CsoundSynthesizer>
