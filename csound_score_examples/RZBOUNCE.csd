<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RZBOUNCE.ORC and RZBOUNCE.SCO
; Original files preserved in same directory

sr        =         44100                    ; THESE INSTRUMENTS REQUIRE sr=kr
kr        =         4410
ksmps     =         10
nchnls    =         2


;-------------------------------------------------------------------------
; SAW-RAMP TRANSFORM REZZY SYNTH
;-------------------------------------------------------------------------
          instr 1

idur      init      p3
iamp      init      p4
ifqc      init      cpspch(p5)               ; CONVERT TO CYCLES/SECOND
irez      init      p7
aynm1     init      0                        ; INITIALIZE Yn-1
aynm2     init      0                        ; & Yn-2 TO ZERO.
kx        init      -p4
kdx       init      p4*4*ifqc/sr
kmax      init      p4

klfo      oscil     .9,1,1                   ; LOW FREQUENCY OSCILLATOR
klfo      =         klfo+1                   ; FOR TRIANGLE RAMP TRANSFORM.
kdx1      =         4*p4*ifqc/sr/klfo
kdx2      =         2*p4*ifqc/(sr-sr/2*klfo)

;-------------------------------------------------------------------------
kaenv     linseg    0,.01,1,p3-.02,1,.01,0   ; AMPLITUDE ENVELOPE
kfco      expseg    10,.2*p3,p6,.4*p3,.5*p6,.4*p3,.1*p6 ; FREQUENCY SWEEP

;-------------------------------------------------------------------------
ka1       =         100/irez/sqrt(kfco)-1    ; ADJUST Q AND Fco FOR
ka2       =         1000/kfco                ; COEFFICIENTS A1 & A2.

;-------------------------------------------------------------------------

; BOUNCING BALL ALGORITHM-A BALL BOUNCING BETWEEN TWO PARALLEL WALLS IE:PONG
;-------------------------------------------------------------------------
knewx     =         kx+kdx                   ; FIND NEXT POSITION

          if        (knewx<=kmax)  goto next1     ; IF NEXT IS BEYOND THE TOP WALL
knewx     =         kmax-kdx2*(kdx1-kmax+kx)/kdx1; THEN FIND THE BOUNCE POSITION
kdx       =         -kdx2                    ; AND DOWNWARD SLOPE.

next1:
          if        (knewx>=-kmax)      goto next2     ; IF NEXT IS BEYOND THE BOTTOM WALL
knewx     =         -kmax+kdx1*(kdx2-kmax-kx)/kdx2     ; THEN FIND THE BOUNCE POSITION
kdx       =         kdx1                      ; AND UPWARD SLOPE.

next2:
kx        =         knewx

axn       =         kx

;-------------------------------------------------------------------------
ayn       =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2) ; DIFFERENCE EQ. APP.
aynm2     =         aynm1                    ; OF DIFFERENTIAL EQ.
aynm1     =         ayn                      ; SAVE Yn-1 & Yn-2.

;-------------------------------------------------------------------------
aout      =         ayn*kaenv                ; SCALE AND OUTPUT
          outs      aout,axn

          endin


;-------------------------------------------------------------------------
; OSCILLATOR SYNC REZZY SYNTH
;-------------------------------------------------------------------------
       instr 2

idur      init      p3
iamp      init      p4
ifqc      init      cpspch(p5)                   ; CONVERT TO CYCLES/SECOND
ifqcs     init      cpspch(p5)*p8
irez      init      p7
aynm1     init      0                        ; INITIALIZE Yn-1
aynm2     init      0                   ; & Yn-2 TO ZERO.
kxn       init      -p4
kdx       init      p4*8*ifqc/sr
kmax      init      p4
ksyncm    init      -1
ksyncs    init      -1

;-------------------------------------------------------------------------
kaenv     linseg    0,.001,1,p3-.002,1,.001,0  ; AMPLITUDE ENVELOPE
kfco      expseg    10,.2*p3,p6,.4*p3,.5*p6,.4*p3,.1*p6  ; FREQUENCY SWEEP

;-------------------------------------------------------------------------
ka1       =         100/irez/sqrt(kfco)-1    ; ADJUST Q AND Fco FOR
ka2       =         1000/kfco           ; COEFFICIENTS A1 & A2.

;-------------------------------------------------------------------------
kxn            =    kxn+kdx             ; FIND NEXT POSITION

ksmprev   =         ksyncm              ; WATCH MASTER FOR TRANSITION
ksyncm    oscil     1,ifqc,2            ; FROM -1 TO 1 THEN RESET axn.
kxn  =              ((ksmprev=-1)&&(ksyncm=1) ? -kmax : kxn)

kssprev =           ksyncs              ; WATCH SLAVE FOR TRANSITION
ksyncs  oscil       1,ifqcs,2           ; FROM -1 TO 1 THEN RESET axn.
kxn  =              ((kssprev=-1)&&(ksyncs=1) ? -kmax : kxn)

axn       =         kxn
;-------------------------------------------------------------------------
ayn       =         ((ka1+2*ka2)*aynm1-ka2*aynm2+axn)/(1+ka1+ka2) ; DIFFERENCE EQ. APP.
aynm2     =         aynm1               ; OF DIFFERENTIAL EQ.
aynm1     =         ayn                 ; SAVE Yn-1 & Yn-2.

;-------------------------------------------------------------------------
aout      =         ayn*kaenv           ; SCALE AND OUTPUT
          outs      aout,axn

          endin

</CsInstruments>
<CsScore>
; Tables
;-----------------------------------------------------------
f1  0  1024  10  1                                 ;Sine
f2  0  256   7  -1  128  -1    0     1  128   1    ;Square
f3  0  256   7   1  256  -1                        ;Sawtooth
f4  0  256   7  -1  128   1    128  -1             ;Triangle
f5  0  1024  8 -.8  42   -.78  400  -.7 140 .7  400 .78 42   .8 ;Distortion

;-----------------------------------------------------------
; Score
;-----------------------------------------------------------
t 0 400


;-----------------------------------------------------------
; Saw Ramp Transform Sync
;-----------------------------------------------------------
;Ins  Sta Dur Amp    Pitch   Fco   Q
i1    0   4   12000  7.00    50    5
i1    +   2   12000  7.07    1000  100

;-----------------------------------------------------------
; Oscillator Sync
;-----------------------------------------------------------
;Ins  Sta Dur Amp   Pitch   Fco   Q  Ratio
i2    6   2  4000   8.03    100  10  1.5
i2    +   4  4000   8.00    100  10  2.01
i2    .   1  4000   8.07    80   10  1.23
i2    .   1  4000   8.05    70   10  1.20
i2    .   1  4000   8.07    60   10  1.15
i2    .   1  4000   8.05    50   10  1.1

</CsScore>
</CsoundSynthesizer>
