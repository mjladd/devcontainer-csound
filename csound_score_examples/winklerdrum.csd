<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from winklerdrum.orc and winklerdrum.sco
; Original files preserved in same directory

     sr        =         44100
     kr        =         22050
     ksmps     =         2
     nchnls    =         1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;COPYRIGHT 1998 PAUL M. WINKLER, ZARMZARM@HOTMAIL.COM
;****++++
;**** LAST MODIFIED: WED JUL 21 07:05:31 1999
;****----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



                                                  ; ATTEMPTS AT SIMULATING ANALOG DRUM SYNTHS.


instr 1                                           ; DUMB DRUM 1 (KICK/TOM)
                                                  ; SELF-RESONATING LOWPASS FILTER
  idur         =         p3
  icutoff      =         p4
  ires         =         3                        ; SELF-RESONATES AT 1
  iscale       =         100000 / (ires)          ; NOT ACCURATE, BUT BALLPARK.
;  NOTE THAT LARGER RESONANCES MAKE SOUND LOUDER, RICHER, AND FATTER.
;  SUGGESTED RANGE: 1 TO 3 FOR DEEP STUFF, UP TO 200 FOR VERY SYNTHY.
;   TRY AS LOW AS .7 FOR SHORT-DECAY, NON-OSCILLATING THUDS, BUT THEN AMPLITUDE MUST
;   BE SERIOUSLY BOOSTED.
  asig         osciln         1, 1/idur, 1, 1
                                                  ; SHOULD USE A BETTER PULSE SIGNAL, IT'S TOO "TICKY".
  kcutoff      linseg         icutoff, idur, 0    ; ENV. FOR FILTER
  aout         moogvcf        asig, kcutoff, ires
               out            aout * iscale
endin


instr 2                                           ; DUMB DRUM 2 (kick/bass)

                                                  ; SINE OSCILLATOR
  idur         =              p3
  ipitch       =              p4
  iamp         =              p5
  kenv         linseg         iamp, idur, .01     ; CHANGE TO LINSEG TO GET
                                                  ; A TOTAL DRUM-N-BASS BASS SOUND.  WITH EXPSEG, DECAY OF AT LEAST
                                                  ; 0.5 IS NICE; WITH LINSEG, AS LOW AS .1
  asig         oscili         kenv, ipitch, 2
               out            asig

endin

</CsInstruments>
<CsScore>
;SCO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;COPYRIGHT 1998 PAUL M. WINKLER, ZARMZARM@HOTMAIL.COM
;****++++
;**** LAST MODIFIED: TUE AUG 24 14:39:34 1999
;****----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


f1      0       1024    2       1       0    ; IMPULSE... WORKS BUT SOUNDS BAD
f2      0       32769   10      1            ; SINE WAVE

t 0 80
i1      0       .25   100
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       >
i1      +       .       50

s
t 0 100
i2      2       .1     100 30000
i2      3       .       >       .
i2      4       .       >       .
i2      5       .       >       .
i2      6       .       >       .
i2      7       .       >       .
i2      8       .       >       .
i2      9       .       >       .
i2      10      .       >       .
i2      11      .       >       .
i2      12      .       30      .


</CsScore>
</CsoundSynthesizer>
