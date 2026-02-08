<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BinauralLaterization.orc and BinauralLaterization.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;***********************************   BINAURAL LATERIZATION   ************************************
; THE MOST IMPORTANT BENEFIT WE DERIVE FROM BINAURAL HEARING IS THE SENSE OF LOCALIZTION OF THE SOUND
; SOURCE. ALTHOUGH SOME DEGREE OF LOCALIZATION IS POSSIBLE IN MONOAURAL LISTENING, BINAURAL LISTENING
; GREATLY ENHANCES OUR ABILITY TO SENSE THE DIRECTION OF THE SOUND SOURCE.
; ALTHOUGH LOCALIZATION ALSO INCLUDES UP-DOWN AND FRONT AND BACK DISCRIMINATION, MOST ATTENTION IS FO-=
; CUSED ON SIDE TO SIDE DISCRIMINATION OR "LATERIZATION". WHEN WE LISTEN WITH HEADPHONES , WE LOSE
; FRONT-BACK INFORMATION, SO THAT LATERIZATION BECOMES EXAGERATED; THE IMAGE OF THE SOUND SOURCE AP-
; PEARS TO SWITCH FROM ONE SIDE OF THE HEAD TO THE OTHER BY MOVING 'THROUGH THE HEAD', OR THE SOUND
; SOURCE APPERAS TO BE 'IN THE HEAD'.
; LORD RALIEGH (1907) WAS ONE OF THE FIRST TO RECOGNIZE THE IMPORTANCE OF TIME AND INTENSITY CUES AT
; LOW FREQUENCY AND HIGH FREQUENCY, RESPECTIVELY. LOW-FREQUENCY SOUNDS ARE LATERALIZED MAINLY ON THE
; BASIS OF INTERAURAL TIME DIFFERENCE, WHEREAS HIGH-FREQUENCY SOUNDS ARE LOCALIZED MAINLY ON THE BASIS
; OF INTERAURAL INTENSITY DIFFERENCES.
; IN THE FIRST EXAMPLE, TONES OF 500HZ AND THEN 2000HZ ARE HEARD WITH ALTERNATING INTERAURAL PHASES OF
; PLUS AND MINUS 45 DEGREES. AT 500HZ, THE IMAGE SWITCHES FROM SIDE TO SIDE AS THE PHASE CHANGES. AT
; 2000HZ, ON THE OTHER HAND, NO SUCH MOVEMENT IS PERCEIVED WITHOUT HEADPHONES. (THE INTERAURAL TIME
; DIFFERENCE VARIES FROM DELTA(T) = DELTA(ALPHA)/2PIF = 250 TO -250 MICROSECONDS IN THE FIRST CASE, BUT ONLY 62.5 TO
; ONLY 62.5 TO -62.5 MICROSECONDS AT 2000HZ).
; IN THE SECOND EXAMPLE, A 2 MILLISECOND PULSE (HEARD AS A "CLICK" IS PRESENTED WITH AN INTERAURAL
; TIME DIFFERENCE THAT CYCLES, SO THAT THE SOUND SOURCE OF THE CLICK APPEARS TO MOVE BETWEEN LEFT
; AND RIGHT.
; THE THIRD EXAMPLE USES TONES OF 250 AND 4000HZ TO ILLUSTRATE THE EFFECTS OF INTERAURAL INTENSITY
; DIFFERENCE AT LOW AND HIGH FREQUENCY. THE INTERAURAL INTENSITY CHANGES (IN 1.25S) FROM 32DB TO -32DB.
; IN THE BOTH CASES, THE IMAGE MOVES FROM SIDE TO SIDE. ALTHOUGH THE AUDITORY SYSTEM PROCESSES INTER-
; AURAL INTENSITY CUES AT BOTH LOW AND HIGH FREQUENCY, THE HEAD DOES NOT CAST MUCH OF AN ACOUSTIC
; SHADOW AT LOW FREQUENCY ( DUE TO DIFFRACTION), AND HENCE THERE IS LITTLE INTENSITY DIFFERENCE EVEN
; WHEN THE SOURCE IS LOCATED TO ONE SIDE OF THE HEAD.
;*****************************************   HEADER   ********************************************


 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
 ifunc         =         p7                       ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                       ;P7 = FUNCTION

 k1            linen     iamp,0,p3,0
 a1            oscili    k1,ifreq,ifunc
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin

 instr         2

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
 ifunc         =         p7                       ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                       ;P7 = FUNCTION

 k1            linen     iamp,.02,p3,.02
 a1            oscili    k1,ifreq,ifunc
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin

 instr         3

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
 ifunc         =         p7                       ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                       ;P7 = FUNCTION

 k1            linen     iamp,.02,p3,.02
 a1            oscili    k1,ifreq,ifunc
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin

 instr         4

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
 ifunc         =         p7                       ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                       ;P7 = FUNCTION

 k1            expseg    (iamp/2.8125),idur/10,iamp,idur/10,(iamp/2.81285),idur/10,iamp,idur/10,(iamp/2.8125),idur/10,iamp,idur/10,(iamp/2.8125),idur/10,iamp,idur/10,(iamp/2.8125),idur/10,iamp,idur/10,(iamp/2.8125)
 a1            oscili    k1,ifreq,ifunc
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin
 instr         5

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
 ifunc         =         p7                       ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                       ;P7 = FUNCTION

 k1            expseg    iamp,idur/10,(iamp/2.81285),idur/10,iamp,idur/10,(iamp/2.81285),idur/10,iamp,idur/10,(iamp/2.81285),idur/10,iamp,idur/10,(iamp/2.81285),idur/10,iamp,idur/10,(iamp/2.81285),idur/10,iamp
 a1            oscili    k1,ifreq,ifunc
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin


</CsInstruments>
<CsScore>
f1 0 512 10 1 .5 0 .2                                            ; SIMPLE TONE
f2 0 512 7 1 512 1                                               ; PANNED RIGHT
f3 0 512 7 0 512 0                                               ; PANNED LEFT
f4 0 512 10 1 0 .2                                               ; SIMPLE TONE B
f5 0 512 9 1 1 45 2 0 45 3 .2 45                                 ; SIMPLE TONE B 45 DEGREE SHIFT
f6 0 512 10 1                                                    ; SINE WAVE

;*************************************   BINAURAL LATERIZATION   ***************************************

;*********************************   INTERAURAL PHASE DIFFERENCE   ********************************
;   p1      p2      p3    p4     p5       p6         p7
;  inst    strt    dur    amp   ifreq   panfunc    ifunc
    i2     1.0     1.0     70     500       2         4
    i2     1.0     1.0     70     500       3         5
    i2     2.1     1.0     70     500       2         5
    i2     2.1     1.0     70     500       3         4
    i2     3.2     1.0     70     500       2         4
    i2     3.2     1.0     70     500       3         5
    i2     4.3     1.0     70     500       2         5
    i2     4.3     1.0     70     500       3         4
    i2     5.4     1.0     70     500       2         4
    i2     5.4     1.0     70     500       3         5
    i2     6.5     1.0     70     500       2         5
    i2     6.5     1.0     70     500       3         4
    i2     7.6     1.0     70     500       2         4
    i2     7.6     1.0     70     500       3         5
    i2     8.7     1.0     70     500       2         5
    i2     8.7     1.0     70     500       3         4
s
    i2     1.0     1.0     70    2000       2         4
    i2     1.0     1.0     70    2000       3         5
    i2     2.1     1.0     70    2000       2         5
    i2     2.1     1.0     70    2000       3         4
    i2     3.2     1.0     70    2000       2         4
    i2     3.2     1.0     70    2000       3         5
    i2     4.3     1.0     70    2000       2         5
    i2     4.3     1.0     70    2000       3         4
    i2     5.4     1.0     70    2000       2         4
    i2     5.4     1.0     70    2000       3         5
    i2     6.5     1.0     70    2000       2         5
    i2     6.5     1.0     70    2000       3         4
    i2     7.6     1.0     70    2000       2         4
    i2     7.6     1.0     70    2000       3         5
    i2     8.7     1.0     70    2000       2         5
    i2     8.7     1.0     70    2000       3         4
s
;***********************************  INTERAURAL TIME DIFFERENCE   ******************************************
;   p1      p2        p3    p4        p5         p6        p7
;  inst    strt      dur    amp      ifreq     panfunc   ifunc
    i1     1.0       .002    85       2000        2         1
    i1     1.001     .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5007    .002    85       2000        3         1
    i1     2.0       .002    85       2000        2         1
    i1     2.00055   .002    85       2000        3         1
    i1     2.5       .002    85       2000        2         1
    i1     2.5       .002    85       2000        3         1
    i1     3.0       .002    85       2000        3         1
    i1     3.00055   .002    85       2000        2         1
    i1     3.5       .002    85       2000        3         1
    i1     3.5007    .002    85       2000        2         1
    i1     4.0       .002    85       2000        3         1
    i1     4.001     .002    85       2000        2         1
    i1     4.5       .002    85       2000        3         1
    i1     4.5007    .002    85       2000        2         1
    i1     5.0       .002    85       2000        3         1
    i1     5.00055   .002    85       2000        2         1
    i1     5.5       .002    85       2000        3         1
    i1     5.5       .002    85       2000        2         1
    i1     6.0       .002    85       2000        2         1
    i1     6.00055   .002    85       2000        3         1
    i1     6.5       .002    85       2000        2         1
    i1     6.5007    .002    85       2000        3         1
    i1     7.0       .002    85       2000        2         1
    i1     7.001     .002    85       2000        3         1
    i1     7.5       .002    85       2000        2         1
    i1     7.5007    .002    85       2000        3         1
    i1     8.0       .002    85       2000        2         1
    i1     8.00055   .002    85       2000        3         1
    i1     8.5       .002    85       2000        2         1
    i1     8.5       .002    85       2000        3         1
    i1     9.0       .002    85       2000        3         1
    i1     9.00055   .002    85       2000        2         1
    i1     9.5       .002    85       2000        3         1
    i1     9.5007    .002    85       2000        2         1
    i1    10.0       .002    85       2000        3         1
    i1    10.001     .002    85       2000        2         1
    i1    10.5       .002    85       2000        3         1
    i1    10.5007    .002    85       2000        2         1
    i1    11.0       .002    85       2000        3         1
    i1    11.0055    .002    85       2000        2         1
    i1    11.5       .002    85       2000        3         1
    i1    11.5       .002    85       2000        2         1
    i1    12.0       .002    85       2000        2         1
    i1    12.00055   .002    85       2000        3         1
    i1    12.5       .002    85       2000        2         1
    i1    12.5007    .002    85       2000        3         1
    i1    13.0       .002    85       2000        2         1
    i1    13.001     .002    85       2000        3         1
    i1    13.5       .002    85       2000        2         1
    i1    13.5007    .002    85       2000        3         1
    i1    14.0       .002    85       2000        2         1
    i1    14.00055   .002    85       2000        3         1
    i1    14.5       .002    85       2000        2         1
    i1    14.5       .002    85       2000        3         1
    s
;***********************************  INTERAURAL INTENSITY DIFFERENCE   ******************************************

t 0 30

;   p1      p2      p3    p4     p5       p6         p7
;  inst    strt    dur    amp   ifreq   panfunc    ifunc
    i4     1.0    12.50   64     250      2          6
    i5     1.0    12.50   64     250      3          6
    s
t 0 30
    i4     1.0    12.50   64    4000      2          6
    i5     1.0    12.50   64    4000      3          6
e

</CsScore>
</CsoundSynthesizer>
