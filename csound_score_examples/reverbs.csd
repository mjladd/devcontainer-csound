<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from reverbs.orc and reverbs.sco
; Original files preserved in same directory

sr       =       44100
kr       =       44100
ksmps    =       1
nchnls   =       2

; Reverbs
; Coded by Hans Mikelson
; May 1999

         zakinit 50, 50

;----------------------------------------------------------------
; Click
;----------------------------------------------------------------
         instr   10

idur     =       p3           			; Duration
iamp     =       p4           			; Amplitude
ioutch   =       p5           			; Output Channel
ioamp    =       p6

aamp     linseg  0, .004, iamp, idur*.5-.004, 0, idur*.5, 0
asig     rand    aamp         			; Noise impulse

         zaw     asig, ioutch 			; Send to the channel
         outs    asig*ioamp, asig*ioamp

         endin

;----------------------------------------------------------------
; Audio
;----------------------------------------------------------------
         instr   11

idur     =       p3           			; Duration
iamp     =       p4           			; Amplitude
iinch    =       p5
ioutch   =       p6           			; Output Channel

asig     diskin iinch, 1      			; Read "soundin" file

         zaw     asig, ioutch 			; Send to the channel
         outs    asig, asig

         endin

;----------------------------------------------------------------
; Reverb
; 6 Delay
;----------------------------------------------------------------
         instr   50

idur     =       p3           			; Duration
iamp     =       p4           			; Amplitude
itime    =       p5           			; Decay time in milliseconds
idens    =       p6           			; Reverb density
iinch    =       p7           			; Input Channel
ioutch   =       p8           			; Output Channel
ifc      =       p9           			; Filter frequency
ipfco    =       p10          			; Pre filter
isa      =       p11          			; Signal Amplitude
iq       =       sqrt(.5)     			; Quality factor

a1       init    0            			; Initialize the six feedback channels
a2       init    0
a3       init    0
a4       init    0
a5       init    0
a6       init    0

itim1    =       rnd(itime*.75)+itime 	; Generate six random times based
itim2    =       rnd(itime*.75)+itime 	; on the input time.
itim3    =       rnd(itime*.75)+itime
itim4    =       rnd(itime*.75)+itime
itim5    =       rnd(itime*.75)+itime
itim6    =       rnd(itime*.75)+itime

at1      oscil   itim1*.05, .50, 1, .2 	; Low frequency oscillators
at2      oscil   itim2*.05, .56, 1, .4 	; for the variable delays
at3      oscil   itim3*.05, .54, 1, .6 	; are used to prevent "ringing"
at4      oscil   itim4*.05, .51, 1, .7 	; If these are set too fast
at5      oscil   itim5*.05, .53, 1, .9 	; or too deep there will be
at6      oscil   itim6*.05, .55, 1     	; flanging or pitch shifting.

atim1    =       itim1+at1+5           	; Add some offset to the delays
atim2    =       itim2+at2+5
atim3    =       itim3+at3+5
atim4    =       itim4+at4+5
atim5    =       itim5+at5+5
atim6    =       itim6+at6+5

ig11     =       .45*idens             	; Feedback matrix
ig12     =       .33*idens             	; just some random numbers
ig13     =      -.31*idens             	; an person could try experimenting
ig14     =      -.29*idens             	; with these.
ig15     =       .25*idens
ig16     =      -.23*idens

ig21     =      -.32*idens
ig22     =      -.35*idens
ig23     =       .36*idens
ig24     =       .26*idens
ig25     =      -.23*idens
ig26     =       .24*idens

ig31     =       .31*idens
ig32     =       .35*idens
ig33     =       .37*idens
ig34     =      -.32*idens
ig35     =      -.30*idens
ig36     =      -.29*idens

ig41     =      -.33*idens
ig42     =      -.32*idens
ig43     =      -.35*idens
ig44     =       .37*idens
ig45     =       .33*idens
ig46     =       .31*idens

ig51     =      -.33*idens
ig52     =       .32*idens
ig53     =      -.35*idens
ig54     =       .37*idens
ig55     =      -.33*idens
ig56     =       .31*idens

ig61     =       .33*idens
ig62     =      -.32*idens
ig63     =       .35*idens
ig64     =      -.37*idens
ig65     =       .33*idens
ig66     =      -.31*idens

iv1      =       .5          			; Level for the high shelf filter
iv2      =       .5          			; .5 means high cut mode
iv3      =       .5
iv4      =       .5
iv5      =       .5
iv6      =       .5

ifc1     =       5000*ifc    				; Frequency for the high shelf filter
ifc2     =       5200*ifc
ifc3     =       5400*ifc
ifc4     =       5300*ifc
ifc5     =       4800*ifc
ifc6     =       4900*ifc

asig1    zar     iinch         				; Read the zak channel
asig     butterlp asig1, ipfco 				; Pre filter the signal

; Variable delay matrix with multiple cross feedback, may need to increase max delay time
aa1      vdelay3 asig+ig11*a1+ig12*a2+ig13*a3+ig14*a4+ig15*a5+ig16*a6, atim1, 1000
aa2      vdelay3 asig+ig21*a1+ig22*a2+ig23*a3+ig24*a4+ig25*a5+ig26*a6, atim2, 1000
aa3      vdelay3 asig+ig31*a1+ig32*a2+ig33*a3+ig34*a4+ig35*a5+ig36*a6, atim3, 1000
aa4      vdelay3 asig+ig41*a1+ig42*a2+ig43*a3+ig44*a4+ig45*a5+ig46*a6, atim4, 1000
aa5      vdelay3 asig+ig51*a1+ig52*a2+ig53*a3+ig54*a4+ig55*a5+ig56*a6, atim5, 1000
aa6      vdelay3 asig+ig61*a1+ig62*a2+ig63*a3+ig64*a4+ig65*a5+ig66*a6, atim6, 1000

; pareq set to high shelf mode
a1      pareq   aa1, ifc1, iv1, iq, 2
a2      pareq   aa2, ifc2, iv2, iq, 2
a3      pareq   aa3, ifc3, iv3, iq, 2
a4      pareq   aa4, ifc4, iv4, iq, 2
a5      pareq   aa5, ifc5, iv5, iq, 2
a6      pareq   aa6, ifc6, iv6, iq, 2

aout     butterhp asig*isa+(a1+a2+a3+a4+a5+a6)*iamp, 20 ; Block the DC

         zaw    aout, ioutch 				; Write to the channel

         endin

;----------------------------------------------------------------
; Reverb
; 4 Delay type
;----------------------------------------------------------------
         instr   51

idur     =       p3           				; Duration
iamp     =       p4           				; Amplitude
itime    =       p5           				; Decay time
idens    =       p6           				; Reverb density
iinch    =       p7           				; Input Channel
ioutch   =       p8           				; Output Channel
ifc      =       p9          				; Filter frequency
ipfco    =       p10          				; Pre filter
isa      =       p11          				; Signal Amplitude
iq       =       sqrt(.5)     				; Quality factor

a1       init    0
a2       init    0
a3       init    0
a4       init    0

itim1    =       rnd(itime*.75)+itime
itim2    =       rnd(itime*.75)+itime
itim3    =       rnd(itime*.75)+itime
itim4    =       rnd(itime*.75)+itime

at1      oscil   itim1*.05, .50, 1, .9
at2      oscil   itim2*.05, .56, 1, .8
at3      oscil   itim3*.05, .54, 1, .3
at4      oscil   itim4*.05, .51, 1, .1

atim1    =       itim1+at1+20
atim2    =       itim2+at2+20
atim3    =       itim3+at3+20
atim4    =       itim4+at4+20

ig11     =       .45*idens
ig12     =       .33*idens
ig13     =      -.31*idens
ig14     =      -.29*idens

ig21     =      -.32*idens
ig22     =      -.35*idens
ig23     =       .36*idens
ig24     =       .26*idens

ig31     =       .31*idens
ig32     =       .35*idens
ig33     =       .37*idens
ig34     =      -.32*idens

ig41     =      -.33*idens
ig42     =      -.32*idens
ig43     =      -.35*idens
ig44     =       .37*idens

iv1      =       .5
iv2      =       .5
iv3      =       .5
iv4      =       .5

ifc1     =       5000*ifc
ifc2     =       5200*ifc
ifc3     =       5400*ifc
ifc4     =       5300*ifc

asig1    zar     iinch
asig     butterlp asig1, ipfco

aa1      vdelay3 asig+ig11*a1+ig12*a2+ig13*a3+ig14*a4, atim1, 1000
aa2      vdelay3 asig+ig21*a1+ig22*a2+ig23*a3+ig24*a4, atim2, 1000
aa3      vdelay3 asig+ig31*a1+ig32*a2+ig33*a3+ig34*a4, atim3, 1000
aa4      vdelay3 asig+ig41*a1+ig42*a2+ig43*a3+ig44*a4, atim4, 1000

a1      pareq   aa1, ifc1, iv1, iq, 2
a2      pareq   aa2, ifc2, iv2, iq, 2
a3      pareq   aa3, ifc3, iv3, iq, 2
a4      pareq   aa4, ifc4, iv4, iq, 2

aout     butterhp asig*isa+(a1+a2+a3+a4)*iamp, 20

         zaw    aout, ioutch

         endin

;----------------------------------------------------------------
; Reverb
; 3 Delay type
;----------------------------------------------------------------
         instr   52

idur     =       p3           ; Duration
iamp     =       p4           ; Amplitude
itime    =       p5           ; Decay time
idens    =       p6           ; Reverb density
iinch    =       p7           ; Input Channel
ioutch   =       p8           ; Output Channel
ifc      =       p9           ; Filter frequency
ipfco    =       p10          ; Pre filter
isa      =       p11          ; Signal Amplitude
iq       =       sqrt(.5)     ; Quality factor

a1       init    0
a2       init    0
a3       init    0

itim1    =       rnd(itime*.75)+itime
itim2    =       rnd(itime*.75)+itime
itim3    =       rnd(itime*.75)+itime

at1      oscil   itim1*.05, .30, 1, .1
at2      oscil   itim2*.05, .36, 1, .8
at3      oscil   itim3*.05, .34, 1, .2

atim1    =       itim1+at1+20
atim2    =       itim2+at2+20
atim3    =       itim3+at3+20

ig11     =       .45*idens
ig12     =       .33*idens
ig13     =      -.31*idens

ig21     =      -.32*idens
ig22     =      -.35*idens
ig23     =       .36*idens

ig31     =       .31*idens
ig32     =       .35*idens
ig33     =       .37*idens

iv1      =       .5
iv2      =       .5
iv3      =       .5

ifc1     =       5000*ifc
ifc2     =       5200*ifc
ifc3     =       5400*ifc

asig1    zar     iinch
asig     butterlp asig1, ipfco

aa1      vdelay3 asig+ig11*a1+ig12*a2+ig13*a3, atim1, 1000
aa2      vdelay3 asig+ig21*a1+ig22*a2+ig23*a3, atim2, 1000
aa3      vdelay3 asig+ig31*a1+ig32*a2+ig33*a3, atim3, 1000

a1      pareq   aa1, ifc1, iv1, iq, 2
a2      pareq   aa2, ifc2, iv2, iq, 2
a3      pareq   aa3, ifc3, iv3, iq, 2

aout     butterhp asig*isa+(a1+a2+a3)*iamp, 20

         zaw    aout, ioutch

         endin

;----------------------------------------------------------------
; Reverb
; 2 Delay type
;----------------------------------------------------------------
         instr   53

idur     =       p3           ; Duration
iamp     =       p4           ; Amplitude
itime    =       p5           ; Decay time
idens    =       p6           ; Reverb density
iinch    =       p7           ; Input Channel
ioutch   =       p8           ; Output Channel
ifc      =       p9           ; Filter frequency
ipfco    =       p10          ; Pre filter
isa      =       p11          ; Signal Amplitude
iq       =       sqrt(.5)     ; Quality factor

a1       init    0
a2       init    0

itim1    =       rnd(itime*.75)+itime
itim2    =       rnd(itime*.75)+itime

at1      oscil   itim1*.05, .20, 1, .1
at2      oscil   itim2*.05, .26, 1, .7

atim1    =       itim1+at1+20
atim2    =       itim2+at2+20

ig11     =       .45*idens
ig12     =      -.33*idens

ig21     =      -.32*idens
ig22     =       .35*idens

iv1      =       .5
iv2      =       .5

ifc1     =       5000*ifc
ifc2     =       5200*ifc

asig1    zar     iinch
asig     butterlp asig1, ipfco

aa1      vdelay3 asig+ig11*a1+ig12*a2, atim1, 1000
aa2      vdelay3 asig+ig21*a1+ig22*a2, atim2, 1000

a1      pareq   aa1, ifc1, iv1, iq, 2
a2      pareq   aa2, ifc2, iv2, iq, 2

aout     butterhp asig*isa+(a1+a2)*iamp, 20

         zaw    aout, ioutch

         endin

;----------------------------------------------------------------
; Mixer
;----------------------------------------------------------------
         instr   90

inch1    =       p4           ; Input 1
inch2    =       p5           ; Input 2
iamp     =       p6

asigl    zar     inch1
asigr    zar     inch2

         outs    asigl*iamp, asigr*iamp

         endin

         instr   99
         zacl    0, 49
         endin

</CsInstruments>
<CsScore>
;-----------------------------------------------------
; REVERB
; CODED BY HANS MIKELSON
; JULY 6, 1999
;-----------------------------------------------------
f1 0 65536 10 1

;-----------------------------------------------------
;a0 0 1
; SMALL DEAD ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .4   10    .41   1     2     .62  2000    0
i50  0    1    .4   11    .42   1     3     .63  2000    0

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    2      3     4
s

;-----------------------------------------------------
;a0 0 1
; MEDIUM DEAD ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .7   12    .41   1     2     .32  4000    0
i50  0    1    .4   33    .55   2     3     .53  2000    1
i50  0    1    .4   31    .54   2     4     .53  2000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    3      4     4
s

;-----------------------------------------------------
;a0 0 1
; LARGE DEAD ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .3   12    .41   1     2     .82  6000    0
i50  0    1    .5   33    .35   2     3     .43  5000    1
i50  0    1    .8   53    .65   3     4     .23  2000    1
i50  0    1    .8   51    .64   3     5     .23  2000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    4      5     4
s

;-----------------------------------------------------
;a0 0 1
; SMALL LIVE ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .4   9.5   .81   1     2     1.1  15000   0
i50  0    1    .4   9.7   .85   2     3     1.2  15000   1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    2      3     2
s

;-----------------------------------------------------
;a0 0 1
; MEDIUM LIVE ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .4   12    .81   1     2     .92  15000    0
i50  0    1    .4   33    .85   2     3     .93  8000    1
i50  0    1    .4   31    .84   2     4     .93  8000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    2      2     1.5
i90  0    1    3      4     2.0
s

;-----------------------------------------------------
;a0 0 1
; LARGE LIVE ROOM
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    1    .4   12    .51   1     2     .92  15000   0
i50  0    1    .5   33    .75   2     3     .83  10000   1
i50  0    1    .7   53    .85   3     4     .63  5000    1
i50  0    1    .7   51    .84   3     5     .63  5000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    1    3      3     2
i90  0    1    4      5     2
s

;-----------------------------------------------------
;a0 0 2
; SMALL BRIGHT HALL REVERB
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC  PREFCO  SIGAMP
i50  0    2    .5   8     .61   1     2     .8  17000   0
i50  0    2    .6   25    .72   2     3     .8  10000   1
i50  0    2    .7   40    .82   3     4     .7  8000    1
i51  0    2    .8   83    1.0   4     5     .6  4000    1
i51  0    2    .8   87    1.0   4     6     .6  4000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    2    2      2     1.0
i90  0    2    3      3     1.5
i90  0    2    5      6     1.0
s

;-----------------------------------------------------
;a0 0 2
; SMALL DARK HALL REVERB
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC  PREFCO  SIGAMP
i50  0    2    .5   8     .71   1     2     .8  15000   0
i50  0    2    .6   25    .82   2     3     .6  8000    1
i50  0    2    .7   40    .92   3     4     .4  6000    1
i51  0    2    .8   83    1.0   4     5     .3  3000    1
i51  0    2    .8   87    1.0   4     6     .3  3000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    2    2      2     1.0
i90  0    2    3      3     1.2
i90  0    2    5      6     1.8
s

;-----------------------------------------------------
;a0 0 2
; SMALL HALL REVERB DARKER STILL
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC  PREFCO  SIGAMP
i50  0    2    .5   8     .51   1     2     .6  12000   0
i50  0    2    .6   25    .62   2     3     .4  8000    1
i50  0    2    .7   40    .82   3     4     .3  3000    1
i51  0    2    .8   83    1.0   4     5     .2  2000    1
i51  0    2    .8   87    1.0   4     6     .2  2000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    2    2      2     0.5
i90  0    2    3      3     1.0
i90  0    2    5      6     2.5
s

;-----------------------------------------------------
;a0 0 3
; LARGE HALL REVERB
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC  PREFCO  SIGAMP
i50  0    3    .5   8     .61   1     2     .9  17000   0
i50  0    3    .7   25    .72   2     3     .8  10000   1
i50  0    3    .8   60    .82   3     4     .7  8000    1
i51  0    3    1    133   1.0   4     5     .6  4000    1
i51  0    3    1    137   1.0   4     6     .6  4000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    3    3      3     1
i90  0    3    4      4     1.5
i90  0    3    5      6     1
s

;-----------------------------------------------------
;a0 0 6
; LARGE TUNNEL REVERB
;    STA  DUR   AMP    OUTCH  OUTAMP
i10  0    .005  30000  1      1

;    STA  DUR  AMP  TIME  DENS  INCH  OUTCH FC   PREFCO  SIGAMP
i50  0    6    .1   8.5   .71   1     2     1.2  8000    0
i50  0    6    .4   25    .82   2     3     .83  6000    1
i50  0    6    .7   80    .98   3     4     .73  3000    1
i51  0    6    .8   153   1.2   4     5     .52  1000    1
i51  0    6    .8   157   1.2   4     6     .52  1000    1

;    STA  DUR  INCH1  INCH2 AMP
i90  0    6    3      3     8
i90  0    6    4      4     8.5
i90  0    6    5      6     8


</CsScore>
</CsoundSynthesizer>
