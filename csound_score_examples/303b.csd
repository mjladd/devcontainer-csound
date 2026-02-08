<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 303b.orc and 303b.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

; sr      =         22050
; kr      =         22050

          instr 1             ; TB-303 EMULATOR
; CODED BY Josep M» Comajuncosas

; INIT VARIABLES
ibpm      =         p14                      ; 4/4 BARS PER MINUTE
ieventdur =         15/ibpm
inotedur  =         ieventdur                ; OR SMALLER...
icount    init      0; sequence counter
idecaydur =         inotedur
imindecay =         (idecaydur<.2 ? .2 : idecaydur) ; SET MINIMUM DECAY TO .2 OR inotedur
imaxfreq  =         1000                     ; MAX.FILTER CUTOFF FREQ. WHEN ienvmod = 0
imaxsweep =         6500                     ; sr/2... MAX.FILTER FREQ. AT kenvmod & kaccent= 1
ipitch    table     0,4                      ; FIRST NOTE IN THE SEQUENCE
ipitch    =         cpspch(6 + ipitch/100)
ireson    =         3                        ; SCALE THE RESONANCE AS YOU LIKE (YOU CAN MAKE THE FILTER TO OSCILLATE...)
imaxamp   =         20000                    ; MAXIMUM AMPLITUDE
idist     =         .015                     ; 1 FOR ULTRA HARDCORE DISTORTION ;-)
; RAISING IDIST ALSO RAISES THE RESONANCE
kaccurve  init      0

; TWISTING THE KNOBS ...
kfco      line      p4, p3, p5
kres      line      p6, p3, p7
kenvmod   line      p8, p3, p9
kdecay    line      p10, p3, p11
kaccent   line      p12, p3, p13

; kfco    randh     .5, .9 , .65
; kfco    =         .5+kfco
; kfco    port      kfco, .5
; kres    randh     .5, .8, .32
; kres    =         .5+kres
; kres    port      kres, .5
; kenvmod randh     .45, 1, .79
; kenvmod =         .55 + kenvmod
; kenvmod port      kenvmod, .5
; kdecay  randh     .5, .5, .74
; kdecay  =         .5+kdecay
; kdecay  port      kdecay, .5
; kaccent randh     .5, .75, .31
; kaccent =         .5+kaccent
; kaccent port      kaccent, .5

start:
afdbk     init      0

;PITCH FROM THE SEQUENCE
ippitch   =         ipitch
ipitch    table     ftlen(4)*frac(icount/ftlen(4)),4
ipitch    =         cpspch(6 + ipitch/100)
iremaining =        icount*ieventdur/p3
          print     ipitch, iremaining

; SLIDE DETECTOR; CANNOT SLIDE FROM LAST NOTE TO THE FIRST ONE
;islide   table     ftlen(6)*frac(icount/ftlen(6)),6
;         if        islide == 1:
;islidedur
; ACCENT DETECTOR
iacc      table     ftlen(5)*frac(icount/ftlen(5)), 5
          if        iacc == 0 goto noaccent
ienvdecay =         0                        ; ACCENTED NOTES ARE THE SHORTEST ONES
iremacc   =         i(kaccurve)
kaccurve  oscil1i   0, 1, .4, 3
kaccurve  =         kaccurve+iremacc         ; SUCCESSIVE ACCENTS CAUSE HYSTERICAL RAISING CUTOFF

          goto      next

noaccent:
kaccurve  =         0                        ; NO ACCENT & "DISCHARGES" ACCENT CURVE
ienvdecay =         i(kdecay)

next:
; TWO ENVELOPES & PITCH WITH PORTAMENTO
kmeg      expseg    1, imindecay+((inotedur-imindecay)*ienvdecay),.1+.9*ienvdecay
kveg      linen     1, .03, inotedur, .016   ; ATTACK SHOULD BE 4 MS. BUT ...
kpitch    linseg    ippitch, .06, ipitch
;         reinit    code
          timout    0, ieventdur , contin
icount    =         icount + 1
          reinit    start

contin:

; AMPLITUDE ENVELOPE
kamp      =         .5*kveg*((1-i(kenvmod)) + kmeg*i(kenvmod)*(.5+.5*iacc*kaccent))

; FILTER ENVELOPE
ksweep    =         kveg * (imaxfreq + (.7*kmeg+.3*kaccurve*kaccent)*kenvmod*(imaxsweep-imaxfreq))
kfco      =         20 + kfco * ksweep       ; CUTOFF ALWAYS GREATER THAN 20 Hz ...
; kfco    =         (kfco > sr/2 ? sr/2 : kfco) ; COULD BE NECESSARY

; GENERATE BANDLIMITED SAWTOOTH WAVE
abuzz     buzz      kamp, kpitch, sr/(2*kpitch), 1 ,0 ; BANDLIMITED PULSE
asaw      integ     abuzz,0
asawdc    atone     asaw,1

; RESONANT 8-POLE LPF
ainpt     =         asawdc - afdbk
alpf      tone      ainpt,kfco
alpf      tone      alpf,kfco
alpf      tone      alpf,kfco
alpf1     tone      alpf,kfco
alpf      tone      alpf1,kfco
alpf      tone      alpf,kfco
alpf      tone      alpf,kfco
alpf2     tone      alpf,kfco

abal1     balance   alpf1,asawdc
abal2     balance   alpf2,asawdc

afdbk     =         abal1-abal2
afdbk     balance   afdbk,asawdc*idist
afdbk     tablei    afdbk*(.05+kres*ireson), 7, 1, .5 ; + RESONANCE -> + DISTORTION
aremovedc atone     afdbk,1
          out       imaxamp*aremovedc
          endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
f2  0 1025  19  .5  .5  270  .5
f4  0  16  -2  0 12 0 0 3 0 0 0 0 15 12 0 6 15 1 4; sequencer (pitches are 6.00 + p/100)
f5  0  16  -2  0  1 0 0 0 0 0 0 0  1  0 1 1  1 0 0; accent sequence
f3  0 8193   8  0 512 1 1024 1 512 .5 2048 .2 4096  0; accent curve
f7 0 1024   8 -.8 42 -.78  200 -.74 200 -.7 140 .7  200 .74 200 .78 42 .8
; f7 borrowed from H.Mikelson«s TB-303 emulator. Tnx!

;------------ KNOB POSITION : INITIAL AND FINAL VALUES FROM 0 TO 1--------------------
;   cutoff freq resonance envelope mod. decay       accent     bpm
;     0   -   1  0 ~ 1  ~ .1 - 1  0 - 1       0 - 1   40-300
;       start    end  st  end   st  end  st  end     st  end

i1   0 6  .01       .3      .2  .2   .1   .4   .05          .8      0   0       80
i1   7 6  .95     1       .1  1    .8   1    .1        .01     0      1       70
i1  14 6       0         1         .5  1    .1   1     1    .05     1   1       60
i1  21 6  .5      1       .95 1    1    .9   .01  0         1   1       80
i1  28 6       0         1         .5  1    .1   1     .05  0       .5  1       120

</CsScore>
</CsoundSynthesizer>
