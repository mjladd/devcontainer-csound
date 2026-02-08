<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FLARE.ORC and FLARE.SCO
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2

;7/25/89
;FLARE.ORC  LOW FM CLAR WITH DYNAMIC INDEX AND FILTER


ga1            init      0




instr          1                             ; A;TERNATE SOURCE WITH NEW AMPSEG,REVERB, AND PANNING

k1             expseg    p4*.001,p3*.05,p4,p3*.7,p4,p3*.2,p4*.05      ;AMPSEG
                                                                      ;P9=SCALING OF CRESC
k2             expseg    p7,p3*.1,p8,p3*.9,p8                         ;INDX SEG
k3             expseg    p5*1.03,p3*.05,p5,p3*.95,p5                  ;CARRIER SEG
k4             expseg    p6*1.02,p3*.05,p6,p3*.95,p6                  ;MOD SEG
k5             expseg    p5*1.05,p3*.05,p5*.95,p3*.85,p5,p3*.1,p5*5
k6             linseg    p9,p3,p9*.1                                  ;P9=KCF
k7             linseg    p10*.5,p3,p10*2                              ;P10=KBW
ga1            foscili   k1,1,p5,p6,k2,1,0
ga2            reson     ga1,k6,k7,0,0
endin

instr          2                             ;ALTERNATE GLOBAL REVERB  MUST BE TURNED ON FOR DURATION
ga3            reverb    ga2,.75             ;PAN INSTR SHOULD BE ONE LONG NOTE FOR DUR
endin


instr          3                             ;GLOBAL PAN  MUST BE TURNED ON FOR DURATION OF ALL PAN
k1             oscil     1,1/p3,2            ;PAN INSTR SHOULD BE ONE LONG NOTE FOR DUR
               outs1     ga3*k1
               outs2     ga3*(1-k1)
endin






</CsInstruments>
<CsScore>
f 1 0 512  9 1 1 0
f 2 0 512  7 0 256 1 256 0

i2  0 10.75
i3  0 10.75

i1   0     .1 25    300 200 1  20 300 500
i1 .15     .2 25     >   200 1  20 >  1000
i1 .3      .2 25     >   200 1  20 >   500
i1 .45   .2 25   >  200 1  20 >  1000

i1  .6   .2 25   >  200 1  20 >   500
i1  .75  .2 25   >  200 1  20 >  1000

i1  .9   .2  25  >  200 1  20 >   500
i1  1.05 .2  25  >  200 1  20 >  1000

i1  1.20 .2  25  >  200 1  20 >   500
i1  1.35 .2  25  >  200 1  20 >  1000

i1  1.5  .2  25  >  200 1  20 >   500
i1  1.65 .2  25  >  200 1  20 >  1000

i1  1.8  .2  25  >  200 1  20 >   500
i1  1.95 .2  25  >  200 1  20 >  1000

i1  2.1  .2  25  >  200 1  20 >   500
i1  2.25 .2  25  >  200 1  20 >  1000

i1  2.4  .2  25  >  200 1  20 >   500
i1  2.55 .2  25  >  200 1  20 >  1000

i1  2.7  .2  25  >  200 1  20 >   500
i1  2.85 .2  25  >  200 1  20 >  1000

i1  3    .2  25  >  200 1  20 >   500
i1  3.15 .2  25  >  200 1  20 >  1000

i1  3.3  .2  25  >  200 1  20 >   500
i1  3.45 .2  25  >  200 1  20 >  1000

i1  3.6  .2  25  >  200 1  20 >   500
i1  3.75 .2  25  >  200 1  20 >  1000

i1  3.9  .2  25  >  200 1  20 >   500
i1  4.05 .2  25  >  200 1  20 >  1000

i1  4.2  .2  25  >  200 1  20 >   500
i1  4.35 .2  25  >  200 1  20 >  1000

i1  4.5  .2  25  >  200 1  20 >   500
i1  4.65 .2  25 600 200 1  20 600  1000
e

i1  0  .5  25  300 200 4  12 1300   1500     ;P9 GOES P9 TO P9*.1
i1  1  .5  25  300 200 4  12 1300  1000      ;P10 GOES P10*.5 TO P10*2
i1  2  .5  25  75  50  4  12 1300   1300
i1  3  .5  25  100 75  4  12 1500  1600
s

i2  0 4.5
i3  0 4.5

i1  1  .5  25  300 200 1  20 300   500
i1  2  .5  25  300 200 1  20 300  1000
i1  3  .5  25  175 150 1  20 30   300
i1  4  .5  25  100 75  1  20 150  600
s

i2  0 4.5
i3  0 4.5

i1  1  .5  25  300 200 10  22 300   50
i1  2  .5  25  300 200 10  22 300  100
i1  3  .5  25  175 150  10 22 150  300
i1  4  .5  25  100 66  10  22 150  600
s

i2  0 4.5
i3  0 4.5

i1  1  .5  25  160 140  2  22 160  140
i1  2  .5  25  200 140  2  22 200  140
i1  3  .5  10  175 150  2  22 175  150
i1  4  .5  10  100  66  2  22 166  160
s
e
i2  0 23
i3  0 23

i1  0  5  25  300 200 4  12 1300   1500      ;P9 GOES P9 TO P9*.1
i1  6  5  25  300 200 4  12 1300  1000       ;P10 GOES P10*.5 TO P10*2
i1 12  5  25  75  50  4  12 1300   1300
i1 18  5  25  100 75  4  12 1500  1600
s

i2  0 23
i3  0 23

i1  0  5  25  300 200 1  20 300   500
i1  6  5  25  300 200 1  20 300  1000
i1 12  5  25  75  50  1  20 30   300
i1 18  5  25  100 75  1  20 150  600
s

i2  0 23
i3  0 23

i1  0  5  25  300 200 10  22 300   50
i1  6  5  25  300 200 10  22 300  100
i1 12  5  25  75  50  10  22 30   30
i1 18  5  25  100 66  10  22 150  60
s

i2  0 23
i3  0 23

i1  0  5  25  60   40  2  22 40   50
i1  6  5  25  200 140  2  22 140  100
i1 12  5  10  75   50  2  22 20   30
i1 18  5  10  100  66  2  22 66  60
s



e



</CsScore>
</CsoundSynthesizer>
