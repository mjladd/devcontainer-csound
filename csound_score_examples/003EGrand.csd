<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 003EGrand.orc and 003EGrand.sco
; Original files preserved in same directory

sr             =              44100
kr             =              4410
ksmps          =              10
nchnls         =              1

;========================================================================;
;                 Yamaha DX7 Algorithm 16                                ;
;========================================================================;
               instr          1
ihold
idur           =              abs(p3)
inote          =              p4
ibase          =              (exp((inote/12) * log(2))/log(2.71828183)) * 2.04
iroct          =              octcps(p4)
irbase         =              octpch(4.09)
irrange        =              octpch(13.06)-irbase
iveloc         =              p5
iop1fn         =              p10
iop2fn         =              p11
iop3fn         =              p12
iop4fn         =              p13
iop5fn         =              p14
iop6fn         =              p15
iampfn         =              p16
ipkamp         =              p17
irsfn          =              p18
idevfn         =              p19
irisefn        =              p20
idecfn         =              p21
ivsfn          =              p22
ivelfn         =              p23
iveloc         table          iveloc,ivelfn
iveloc         =              iveloc * 1.10
ifeedfn        =              p24
ifeed          table          p25,ifeedfn
ifeed          =              ifeed/(2 * 3.14159)
idetfac        =              4
imap128        =              127/99
irscl          table          (iroct-irbase)/irrange*127,irsfn
irscl          =              irscl*6
iop            =              1
iopfn          =              iop1fn
loop:
;---------------------------------READ OPERATOR PARAMETERS
ilvl           table          0,iopfn
ivel           table          1,iopfn
iegr1          table          2,iopfn
iegr2          table          3,iopfn
iegr3          table          4,iopfn
iegr4          table          5,iopfn
iegl1          table          6,iopfn
iegl2          table          7,iopfn
iegl3          table          8,iopfn
iegl4          table          9,iopfn
iams           table          10,iopfn
imode          table          11,iopfn
ifreq          table          12,iopfn
idet           table          13,iopfn
irss           table          14,iopfn
;----------------------------------INITIALIZE OPERATOR
ihz            =              (imode > 0 ? ifreq : ibase * ifreq) + idet/idetfac
iamp           =              ilvl/99
ivfac          table          ivel,ivsfn

iegl1          =              iamp*iegl1
iegl2          =              iamp*iegl2
iegl3          =              iamp*iegl3
iegl4          =              iamp*iegl4

iegl1          =              iegl1*(1-ivfac)+iegl1*ivfac*iveloc
iegl2          =              iegl2*(1-ivfac)+iegl2*ivfac*iveloc
iegl3          =              iegl3*(1-ivfac)+iegl3*ivfac*iveloc
iegl4          =              iegl4*(1-ivfac)+iegl4*ivfac*iveloc

irs            =              irscl*irss
iegr1          =              (iegr1+irs > 99 ? 99 : iegr1+irs)
iegr2          =              (iegr2+irs > 99 ? 99 : iegr2+irs)
iegr3          =              (iegr3+irs > 99 ? 99 : iegr3+irs)
iegr4          =              (iegr4+irs > 99 ? 99 : iegr4+irs)

irfn           =              (iegl1 > iegl4 ? irisefn : idecfn)
iegd1          table          iegr1,irfn                                   ;CONVERT RATE->DUR
ipct1          table          iegl4,irfn+1                                 ;PCT FN IS NEXT ONE
ipct2          table          iegl1,irfn+1
iegd1          =              abs(iegd1*ipct1-iegd1*ipct2)
iegd1          =              (iegd1 == 0 ? .001 : iegd1)

irfn           =              (iegl2 > iegl1 ? irisefn : idecfn)
iegd2          table          iegr2,irfn
ipct1          table          iegl1,irfn+1
ipct2          table          iegl2,irfn+1
iegd2          =              abs(iegd2*ipct1-iegd2*ipct2)
iegd2          =              (iegd2 == 0 ? .001 : iegd2)

irfn           =              (iegl3 > iegl2 ? irisefn : idecfn)
iegd3          table          iegr3,irfn
ipct1          table          iegl2,irfn+1
ipct2          table          iegl3,irfn+1
iegd3          =              abs(iegd3*ipct1-iegd3*ipct2)
iegd3          =              (iegd3 == 0 ? .001 : iegd3)

iegd4          table          iegr4,idecfn
if      (iegl3 <= iegl4)      igoto continue
ipct1          table          iegl3,irfn+1
ipct2          table          iegl4,irfn+1
iegd4          =              abs(iegd4*ipct1-iegd4*ipct2)
iegd4          =              (iegd4 == 0 ? .001 : iegd4)

continue:
         if       (iop > 1)   igoto op2
op1:
i1egd1         =              iegd1
i1egd2         =              iegd2
i1egd3         =              iegd3
i1egd4         =              iegd4
i1egl1         =              iegl1
i1egl2         =              iegl2
i1egl3         =              iegl3
i1egl4         =              iegl4
i1ams          =              iams
i1hz           =              ihz
iop            =              iop + 1
iopfn          =              iop2fn
igoto          loop

op2:     if       (iop > 2)   igoto op3
i2egd1         =              iegd1
i2egd2         =              iegd2
i2egd3         =              iegd3
i2egd4         =              iegd4
i2egl1         =              iegl1
i2egl2         =              iegl2
i2egl3         =              iegl3
i2egl4         =              iegl4
i2ams          =              iams
i2hz           =              ihz
iop            =              iop + 1
iopfn          =              iop3fn
igoto          loop

op3:     if       (iop > 3)   igoto op4
i3egd1         =              iegd1
i3egd2         =              iegd2
i3egd3         =              iegd3
i3egd4         =              iegd4
i3egl1         =              iegl1
i3egl2         =              iegl2
i3egl3         =              iegl3
i3egl4         =              iegl4
i3ams          =              iams
i3hz           =              ihz
iop            =              iop + 1
iopfn          =              iop4fn
igoto          loop

op4:     if       (iop > 4)   igoto op5
i4egd1         =              iegd1
i4egd2         =              iegd2
i4egd3         =              iegd3
i4egd4         =              iegd4
i4egl1         =              iegl1
i4egl2         =              iegl2
i4egl3         =              iegl3
i4egl4         =              iegl4
i4ams          =              iams
i4hz           =              ihz
iop            =              iop + 1
iopfn          =              iop5fn
igoto          loop

op5:     if       (iop > 5)   igoto op6
i5egd1         =              iegd1
i5egd2         =              iegd2
i5egd3         =              iegd3
i5egd4         =              iegd4
i5egl1         =              iegl1
i5egl2         =              iegl2
i5egl3         =              iegl3
i5egl4         =              iegl4
i5ams          =              iams
i5hz           =              ihz
iop            =              iop + 1
iopfn          =              iop6fn
igoto          loop

op6:
i6egd1         =              iegd1
i6egd2         =              iegd2
i6egd3         =              iegd3
i6egd4         =              iegd4
i6egl1         =              iegl1
i6egl2         =              iegl2
i6egl3         =              iegl3
i6egl4         =              iegl4
i6ams          =              iams
i6hz           =              ihz
;============================================================

timout         idur,999,final                               ;SKIP DURING FINAL DECAY
k1sus          linseg         i1egl4,i1egd1,i1egl1,i1egd2,i1egl2,i1egd3,i1egl3,1,i1egl3
k2sus          linseg         i2egl4,i2egd1,i2egl1,i2egd2,i2egl2,i2egd3,i2egl3,1,i2egl3
k3sus          linseg         i3egl4,i3egd1,i3egl1,i3egd2,i3egl2,i3egd3,i3egl3,1,i3egl3
k4sus          linseg         i4egl4,i4egd1,i4egl1,i4egd2,i4egl2,i4egd3,i4egl3,1,i4egl3
k5sus          linseg         i5egl4,i5egd1,i5egl1,i5egd2,i5egl2,i5egd3,i5egl3,1,i5egl3
k6sus          linseg         i6egl4,i6egd1,i6egl1,i6egd2,i6egl2,i6egd3,i6egl3,1,i6egl3
k1phs          =              k1sus
k2phs          =              k2sus
k3phs          =              k3sus
k4phs          =              k4sus
k5phs          =              k5sus
k6phs          =              k6sus
kgoto          structure

final:
k1fin          linseg         1,i1egd4,0,1,0
k1phs          =              i1egl4+(k1sus-i1egl4)*k1fin
k2fin          linseg         1,i2egd4,0,1,0
k2phs          =              i2egl4+(k2sus-i2egl4)*k2fin
k3fin          linseg         1,i3egd4,0,1,0
k3phs          =              i3egl4+(k3sus-i3egl4)*k3fin
k4fin          linseg         1,i4egd4,0,1,0
k4phs          =              i4egl4+(k4sus-i4egl4)*k4fin
k5fin          linseg         1,i5egd4,0,1,0
k5phs          =              i5egl4+(k5sus-i5egl4)*k5fin
k6fin          linseg         1,i6egd4,0,1,0
k6phs          =              i6egl4+(k6sus-i6egl4)*k6fin
kgoto          carrier
;====================================================================
;DETERMINE ALGORITHM PATHWAY!!!!!!!!!!!!!!!!!!!!!!!!
;====================================================================
carrier: if  k1fin > 0        kgoto structure
               turnoff
;====================================================================
;STRUCTURE SECTION - TELLS OPS WHETHER THEY ARE CARRIERS OR MODULATORS.
;====================================================================
structure:
k1gate         tablei         k1phs,iampfn
k2gate         tablei         k2phs,idevfn
k3gate         tablei         k3phs,idevfn
k4gate         tablei         k4phs,idevfn
k5gate         tablei         k5phs,idevfn
k6gate         tablei         k6phs,idevfn

a6sig          init           0
a6phs          phasor         i6hz
a6sig          tablei         a6phs+a6sig*ifeed,1,1,0,1
a6sig          =              a6sig*k6gate

a5phs          phasor         i5hz
a5sig          tablei         a5phs+a6sig,1,1,0,1
a5sig          =              a5sig*k5gate

a4sig          oscili         k4gate,i4hz,1

a3phs          phasor         i3hz
a3sig          tablei         a3phs+a4sig,1,1,0,1
a3sig          =              a3sig*k3gate

a2sig          oscili         k2gate,i2hz,1

a1phs          phasor         i1hz
a1sig          tablei         a1phs+a2sig+a3sig+a5sig,1,1,0,1
a1sig          =              a1sig*k1gate

out            a1sig*ipkamp
endin

</CsInstruments>
<CsScore>
;============================================================================
; ACOUSTIC PIANO - ALGORITHM #16
;============================================================================
; SIMPLE SINE FUNCTION
f01     0       4096     10      1
; OPERATOR OUTPUT LEVEL TO AMP SCALE FUNCTION (DATA FROM CHOWNING/BRISTOW)
f02     0       128     7       0       10      .003    10      .013
        10      .031    10      .079    10      .188    10      .446
        5       .690    5       1.068   5       1.639   5       2.512
        5       3.894   5       6.029   5       9.263   4       13.119
        29      13.119
; RATE SCALING FUNCTION
f03     0       128     7       0       128     1
; EG RATE RISE FUNCTION FOR LVL CHANGE BETWEEN 0 AND 99 (DATA FROM OPCODE)
f04     0       128     -7      38      5       22.8    5       12      5
        7.5     5       4.8     5       2.7     5       1.8     5       1.3
        8       .737    3       .615    3       .505    3       .409    3
        .321    6       .080    6       .055    2       .032    3       .024
        3       .018    3       .014    3       .011    3       .008    3
        .008    3       .007    3       .005    3       .003    32      .003
; EG RATE RISE PERCENTAGE FUNCTION
f05     0       128     -7      .00001  31      .00001  4       .02     5
        .06     10      .14     10      .24     10      .35     10      .50
        10      .70     5       .86     4       1.0     29      1.0
; EG RATE DECAY FUNCTION FOR LVL CHANGE BETWEEN 0 AND 99
f06     0       128     -7      318     4       181     5       115     5
        63      5       39.7    5       20      5       11.2    5       7
        8       5.66    3       3.98    6       1.99    3       1.34    3
        .99     3       .71     5       .41     3       .15     3       .081
        3       .068    3       .047    3       .037    3       .025    3
        .02     3       .013    3       .008    36      .008
; EG RATE DECAY PERCENTAGE FUNCTION
f07     0       128     -7      .00001  10      .25     10      .35     10
        .43     10      .52     10      .59     10      .70     10      .77
        10      .84     10      .92     9       1.0     29      1.0
; EG LEVEL TO AMP FACTOR MAPPING FUNCTION (INDEX IN RADIANS = INDEX / 2PI)
;f08     0       128     6       .001    96      .5      32      1
;f08   0   128   -6    0   64   .0318   0   .0318   64   2.08795
f08     0       128     -7      0       10      .000477 10      .002
        10      .00493  10      .01257  10      .02992  10      .07098
        5       .10981  5       .16997  5       .260855 5       .39979
        5       .61974  5       .95954  5       1.47425 4       2.08795
        29      2.08795
; VELOCITY TO AMP FACTOR MAPPING FUNCTION (ROUGH GUESS)
f09     0       129     9       .25     1       0
; VELOCITY SENSITIVITY SCALING FUNCTION
f10     0       8       -7      0       8       1
; FEEDBACK SCALING FUNCTION
f11     0       8       -6      0       8       6
; OPERATOR 1 PARAMETERS:
f12     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 99       3        80     28     15     46     99     90     0      0
;AMS      FIXED?   FREQ   DET    RSS
 0        0        1      0      2

; OPERATOR 2 PARAMETERS
f13     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 91       2        75     73     44     86     99     53     7      0
;AMS      FIXED?   FREQ   DET    RSS
 0        1        19.6   0     1

; OPERATOR 3 PARAMETERS
f14     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 81       2        77     72     10     37     99     99     0      83
;AMS      FIXED?   FREQ   DET    RSS
 0        0        1      -1     2

; OPERATOR 4 PARAMETERS
f15     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 66       1        78     72     11     41     99     88     0      0
;AMS      FIXED?   FREQ   DET    RSS
 0        0        3      -3     2

; OPERATOR 5 PARAMETERS
f16     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 68      3         78     72     14     50     99     96     0      0
;AMS      FIXED?   FREQ   DET    RSS
 0        0        2      0      4

; OPERATOR 6 PARAMETERS
f17     0       32      -2
;OUTLVL   KEYVEL   EGR1   EGR2   EGR3   EGR4   EGL1   EGL2   EGL3   EGL4
 60       6        82     49     28     39     87     73     0      37
;AMS      FIXED?   FREQ   DET    RSS
 0        0        24.30  -6     5

;====================================================================;
;                       Yamaha DX7 Algorithm 16                      ;
;                                                                    ;
;    p02 = start     p03 = dur       p04 = pch       p05 = vel       ;
;    p06 = panfac    p07 = vibdel    p08 = vibwth    p09 = vibhz     ;
;    p10 = op1fn     p11 = op2fn     p12 = op3fn     p13 = op4fn     ;
;    p14 = op5fn     p15 = op6fn     p16 = ampfn     p17 = pkamp     ;
;    p18 = rsfn      p19 = devfn     p20 = erisfn    p21 = edecfn    ;
;    p22 = vsfn      p23 = velfn     p24 = feedfn    p25 = feedbk    ;
;                    p26 = Algorithm Number (Disabled)               ;
;====================================================================;

i1.01 0.000 2.350 63 68     0         0         0         0
        12    13    14      15    16      17      2       10000
        3     8     4       6     10      9       11      3       ;16

t 0.000 86.000
i1.02 0.250 0.271 67 47
i1.03 0.500 0.244 70 59
i1.04 0.744 0.283 75 64
i1.05 0.994 0.267 79 69
i1.06 1.244 0.383 75 59
i1.07 1.494 0.331 70 68
i1.08 1.744 0.229 67 59
i1.09 1.994 0.271 80 60
i1.10 2.244 0.262 67 55
i1.11 2.487 0.329 70 60
i1.12 2.737 0.279 75 74
i1.13 2.987 0.315 79 79
i1.14 2.987 0.354 63 54
i1.15 3.237 0.202 67 56
i1.16 3.487 0.267 77 70
i1.17 3.737 0.240 79 63
i1.18 3.987 0.879 62 67
i1.19 3.987 0.302 77 57
i1.20 4.238 0.279 68 75
i1.21 4.488 0.221 72 66
i1.22 4.738 0.531 77 72
i1.23 4.988 1.706 62 67
i1.24 5.238 0.248 68 65
i1.25 5.488 0.296 72 70
i1.26 5.738 0.269 77 73
i1.27 5.988 0.242 79 78
i1.28 6.238 0.256 68 62
i1.29 6.488 0.273 72 58
i1.30 6.738 0.162 77 57
i1.31 6.988 0.981 55 63
i1.32 6.988 0.223 75 61
i1.33 7.231 0.256 67 55
i1.34 7.481 0.219 74 67
i1.35 7.731 0.260 67 54
i1.36 7.981 0.298 75 86
i1.37 7.981 0.475 60 63
i1.38 8.231 0.256 67 63
i1.39 8.481 0.267 72 67
i1.40 8.731 0.485 75 66
i1.41 8.981 0.290 48 87
i1.42 9.231 0.290 67 60
i1.43 9.481 0.281 72 67
i1.44 9.731 0.279 75 66
i1.45 9.981 0.885 36 84
i1.46 9.981 0.231 77 87
i1.47 10.231 0.313 75 60
i1.48 10.481 0.221 72 69
i1.49 10.731 0.169 67 66
i1.50 10.981 0.260 63 75
i1.51 11.231 0.231 62 80
i1.52 11.481 0.242 60 61
i1.53 11.731 0.294 58 52
i1.54 11.981 1.225 32 77
i1.55 11.981 0.538 56 66
i1.56 11.981 0.919 44 76
i1.57 11.981 0.473 60 65
i1.58 11.981 0.283 51 83
i1.59 12.475 0.223 51 78
i1.60 12.719 0.554 56 78
i1.61 12.719 0.523 60 83
i1.62 12.719 0.246 51 25
i1.63 12.969 0.244 44 61
i1.64 13.219 0.206 51 72
i1.65 13.469 0.285 56 44
i1.66 13.719 0.771 58 64
i1.67 13.969 0.575 62 85
i1.68 13.969 0.827 46 75
i1.69 13.969 0.319 53 84
i1.70 13.969 1.194 34 67
i1.71 14.469 0.769 53 55
i1.72 14.719 0.294 63 65
i1.73 14.969 0.248 46 64
i1.74 15.462 0.225 62 79
i1.75 15.462 0.079 34 65
i1.76 15.962 2.790 63 70
i1.77 15.962 2.663 27 51
i1.78 15.962 2.698 55 66
i1.79 15.962 2.673 39 67
i1.80 15.962 2.681 53 76
i1.81 15.962 2.794 58 66
f0      20
e

</CsScore>
</CsoundSynthesizer>
