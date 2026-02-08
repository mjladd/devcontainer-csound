<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from BinauralBeats.orc and BinauralBeats.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2


;*************************************   BINAURAL BEATS   ****************************************
; AN IMPORTANT ISSUE IN THE STUDY OF SOUND LOCALIZATION CONCERNS THE EAR'S ABILITY TO PROCESS
; PHASE DIFFERENCES IN THE EARS. ONE WAY TO STUDY THIS PHENOMENON IS TO PRESENT TWO SINUSOIDS OF
; SLIGHTLY DIFFERENT FREQUENCIES, ONE TO EACH EAR. AT LOW FREQUENCIES THE SOUND MAY APPEAR TO
; FLUCTUATE OR BEAT SLOWLY AT A RATE EQUAL TO THE FREQUENCY DIFFERENCE BETWEEN THE TWO TONES.
; NOTE THAT THESE "BINAURAL BEATS" ARE QUITE UNLIKE THE PHYSICAL BEATS THAT CAN BE HEARD BY A SIN-
; GLE EAR. THERE, THE SMALL DIFFERENCE IN THE TWO FREQUENCIES CAUSES THE PHYSICAL STIMULUS TO WAX
; AND WANE IN INTENSITY; IF THIS FLUCTUATION IS SLOW ENOUGH, IT IS EXPERIENCED AS A BEATING SENSA-
; TION. WITH BINAURAL BEATS, HOWEVER, THE INTERACTION BETWEEN THE TWO TONES OCCURS BECAUSE OF
; SOME KIND OF INTERACTION IN THE NERVOUS SYSTEM OF THE INPUTS FROM EACH EAR.
; ONE MIGHT EXPECT THAT THESE BINAURAL BEATS WOULD OCCUR ONLY AT LOW FREQUENCIES, SINCE AT HIGHER
; FREQUENCIES IT IS DIFFICULT TO IMAGINE THAT THE NERVOUS SYSTEM CAN PRESERVE THE TEMPORAL STRUC-
; TURE OF THE WAVEFORM AT EACH EAR, A CONDITION THAT MUST BE MET FOR THEIR INTERACTION TO BE NOTICE-
; ABLE. THIS CONJECTURE IS SUPPORTED BY QUANTITATIVE MEASUREMENTS (LICKLIDER, WEBSTER, AND HEDLUN,
; 1950). THEY FOUND THAT THE BEST BINAURAL BEATS  OCCURED AT FREQUENCY SEPARATIONS OF ABOUT 30HZ NEAR
; 400HZ AND MUCH SMALLER FREQUENCY SEPARATIONS AT THE HIGHER FREQUENCIES. NO BINAURAL BEATS ARE EVI-
; DENT ABOVE 1500HZ. TOBIAS (1965) FOUND THAT MEN APPEAR TO PERCEIVE BINAURAL BEATS AT HIGHER FRE-
; QUENCY THAN WOMAN, BUT THIS NEEDS MORE EXPLORATION.
; IN THIS DEMONSTRATION A 250HZ TONE IS PRESENTED TO THE RIGHT EAR, WHILE 251HZ TONE IS PRESENTED TO
; THE LEFT EAR.
;*****************************************   HEADER   *************************************************




 instr         1

 iamp          =         ampdb(p4)                ;P4 = AMPLITUDE IN DB
 ifreq         =         p5                       ;P5 = FREQUENCY
                                                  ;P6 = PANNING FUNCTION FOR SIGNAL

 k1            linen     iamp,.05,p3,.05
 a1            oscili    k1,ifreq,1
 k2            oscili    1,p3,p6
 kleft         =         sqrt (k2)
 kright        =         sqrt (1-k2)
 aleft         =         a1 * kleft
 aright        =         a1 * kright
               outs      aleft,aright
 endin


</CsInstruments>
<CsScore>
f1 0 512 10 1
;    ALL RIGHT
f2 0 512 7 1 512 1
;    ALL LEFT
f3 0 512 7 0 512 0


;*****************************************   BINAURAL BEATS   *****************************************
;   p1      p2      p3     p4      p5        p6
;  inst    strt    dur    amp    ifreq     panfunc
    i1      1.0    30.0    80     250        2
    i1      4.0    23.0    80     251        3
    e


</CsScore>
</CsoundSynthesizer>
