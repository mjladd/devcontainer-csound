<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Experiment2.orc and Experiment2.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*************************************   BINAURAL LATERIZATION   ************************************
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
; IN THE FIRST EXAMPLE, 2 MILLISECOND PULSE (HEARD AS A "CLICK" IS PRESENTED WITH AN INTERAURAL
; TIME DIFFERENCE THAT CYCLES , SO THAT THE SOUND SOURCE OF THE CLICK APPEARS TO MOVE BETWEEN LEFT
; AND RIGHT. THIS EXPERIMENT WILL TRY TO DEFINE THE THRESHOLD OF MOVEMENT BY VARYING THE TIME DIFFERENCE
; WITH VERY SMALL VALUES. LISTENER SHOULD WEAR HEADPHONES VS. USING A SPEAKER SYSTEM.
;*****************************************   HEADER   ********************************************

 instr         1

 iamp          =         ampdb(p4)                     ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                            ;P5 = FREQUENCY
 ifunc         =         p7                            ;P6 = PANNING FUNCTION FOR SIGNAL
 idur          =         p3                            ;P7 = FUNCTION

 k1            linen     iamp,0,p3,0
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

;*************************************   BINAURAL LATERIZATION   ***************************************

;***********************************  INTERAURAL TIME DIFFERENCE   ******************************************
;   p1      p2        p3    p4        p5         p6        p7
;  inst    strt      dur    amp      ifreq     panfunc   ifunc
    i1     1.0       .002    85       2000        2         1
    i1     1.00020   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50020   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00009   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50009   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00008   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50008   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00006   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50006   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00004   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50004   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00003   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50003   .002    85       2000        2         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.00002   .002    85       2000        3         1
    i1     1.5       .002    85       2000        2         1
    i1     1.5       .002    85       2000        3         1
    s
    i1     1.0       .002    85       2000        2         1
    i1     1.0       .002    85       2000        3         1
    i1     1.5       .002    85       2000        3         1
    i1     1.50002   .002    85       2000        2         1
    e


</CsScore>
</CsoundSynthesizer>
