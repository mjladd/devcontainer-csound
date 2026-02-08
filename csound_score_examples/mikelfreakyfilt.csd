<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from mikelfreakyfilt.orc and mikelfreakyfilt.sco
; Original files preserved in same directory

sr      =        44100                      ; Sample rate
kr      =        44100                      ; Kontrol rate
ksmps   =        1                          ; Samples/Kontrol period
nchnls  =        2                          ; Normal stereo

; ORCHESTRA
;---------------------------------------------------------
; Runge-Kutta Filters
; Coded by Hans Mikelson June, 2000
;---------------------------------------------------------
         zakinit  50, 50

;------------------------------------------------------------
; Envelope (Knob twisting simulation)
;------------------------------------------------------------
        instr  1
idur   =      p3         ; Duration
iamp   =      p4         ; Amplitude
ilps   =      p5         ; Loops
iofst  =      p6         ; Offset
itabl  =      p7         ; Table
ioutch =      p8         ; Output channel
iphase =      p9         ; Phase

kout   oscili iamp, ilps/idur, itabl, iphase  ; Create the envelope
        zkw    kout+iofst, ioutch      ; Send out to the zak channel
       endin

;---------------------------------------------------------
; Runge-Kutta Freaky Filter
;---------------------------------------------------------
        instr  7

idur   =      p3            ; Duration
iamp   =      p4            ; Amplitude
kfco2  zkr    p5            ; Filter cutoff
kq1    zkr    p6            ; Q
ih     =      .001          ; Diff eq step size
ipanl  =      sqrt(p8)      ; Pan left
ipanr  =      sqrt(1-p8)    ; Pan right
ifqc   =      cpspch(p9)    ; Pitch to frequency
kpb    zkr    p10           ; Pentic bounce frequency
kpa    zkr    p11           ; Pentic bounce amount
kasym  zkr    p12           ; Q assymmetry amount
kasep  zkr    p13           ; Q asymmetry separation

kdclck linseg 0, .02, 1, idur-.04, 1, .02, 0 ; Declick envelope
kfco1  expseg 1, idur, .1
kfco   =      kfco1*kfco2
kq     =      kq1*kfco^1.2*.1
kfc    =      kfco/8/sr*44100

ay     init   0
ay1    init   0
ay2    init   0
ay3    init   0
axs    init   0
avxs   init   0
ax     vco   1, ifqc, 2, 1, 1, 1        ; Square wave

   ; R-K Section 1
   afdbk =      kq*ay/(1+exp(-ay*3*kasep)*kasym)   ; Only oscillate in
one direction
   ak11  =      ih*((ax-ay1)*kfc-afdbk)
   ak21  =      ih*((ax-(ay1+.5*ak11))*kfc-afdbk)
   ak31  =      ih*((ax-(ay1+.5*ak21))*kfc-afdbk)
   ak41  =      ih*((ax-(ay1+ak31))*kfc-afdbk)
   ay1   =      ay1+(ak11+2*ak21+2*ak31+ak41)/6

   ; R-K Section 2
   ak12  =      ih*((ay1-ay2)*kfc)
   ak22  =      ih*((ay1-(ay2+.5*ak12))*kfc)
   ak32  =      ih*((ay1-(ay2+.5*ak22))*kfc)
   ak42  =      ih*((ay1-(ay2+ak32))*kfc)
   ay2   =      ay2+(ak12+2*ak22+2*ak32+ak42)/6

   ; Pentic bounce equation
   ax3    =      -.1*ay*kpb
   aaxs   =      (ax3*ax3*ax3*ax3*ax3+ay2)*1000*kpa     ; Update acceleration

   ; R-K Section 3
   ak13  =      ih*((ay2-ay3)*kfc+aaxs)
   ak23  =      ih*((ay2-(ay3+.5*ak13))*kfc+aaxs)
   ak33  =      ih*((ay2-(ay3+.5*ak23))*kfc+aaxs)
   ak43  =      ih*((ay2-(ay3+ak33))*kfc+aaxs)
   ay3   =      ay3+(ak13+2*ak23+2*ak33+ak43)/6

   ; R-K Section 4
   ak14  =      ih*((ay3-ay)*kfc)
   ak24  =      ih*((ay3-(ay+.5*ak14))*kfc)
   ak34  =      ih*((ay3-(ay+.5*ak24))*kfc)
   ak44  =      ih*((ay3-(ay+ak34))*kfc)
   ay    =      ay+(ak14+2*ak24+2*ak34+ak44)/6

aout   =      ay*iamp*kdclck*.07 ; Apply amp envelope and declick

        outs   aout*ipanl, aout*ipanr  ; Output the sound

        endin

</CsInstruments>
<CsScore>
; SCORE
f1 0 65536 10 1
f2 0 1024  -7 1 1024 1 ; Constant

; Envelope
;   Sta   Dur  Amp   Loops  Offset  Table  OutCh  Phase
i1  0     10.7 4000  1      6000    1      1      .75    ; Fco
i1  0     .    1     .5     1.01    1      2      .      ; Q
i1  0     .    .2    .6     1       1      3      .      ; Bounce Fqc
i1  0     .    .2    .7     1       1      4      .      ; Bounce Amp
i1  0     .    .8    .8     1       1      5      .      ; Assym Amt
i1  0     .    .5    .9     1       1      6      .      ; Assym Sep

; Filter Number 7
;                                                      Penta-Bounce Assymetry
;    Sta     Dur  Amp    Fco   Q    h      Pan  Pitch  Fqc  Amp      Amt  Sep
i7   0.000   .2   30000  1     2    .001   .5   5.00   3    4        5    6
i.   +       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.07   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.07   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.07   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.07   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.07   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.01   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    7.06   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.06   .    .        .    .
i.   .       .    .      .     .    .      .    7.00   .    .        .    .
i.   .       .1   .      .     .    .      .    5.01   .    .        .    .
i.   .       .    .      .     .    .      .    5.06   .    .        .    .
i.   .       .    .      .     .    .      .    6.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.03   .    .        .    .
i.   .       .2   .      .     .    .      .    7.05   .    .        .    .
i.   .       .    .      .     .    .      .    6.00   .    .        .    .
i.   .       .    .      .     .    .      .    5.05   .    .        .    .
i.   .       .    .      .     .    .      .    5.10   .    .        .    .
i.   .       .    .      .     .    .      .    7.03   .    .        .    .
i.   .       .1   .      .     .    .      .    7.02   .    .        .    .
i.   .       .    .      .     .    .      .    5.00   .    .        .    .

</CsScore>
</CsoundSynthesizer>
