<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from toot13.orc and toot13.sco
; Original files preserved in same directory

sr             =         44100
kr             =         4410
ksmps          =         10
nchnls         =         2

               instr 13
iamp           =         ampdb(p4) / 2       ;AMP SCALED FOR TWO SOURCES
ipluckamp      =         p6                  ;P6: % OF TOTAL AMPLITUDE, 1=DB AMP AS IN P4
ipluckdur      =         p7*p3               ;P7: % OF TOTAL DURATION, 1=ENTIRE NOTE DURATION
ipluckoff      =         p3 - ipluckdur

ifmamp         =         p8                  ;P8: % OF TOTAL AMPLITUDE, 1=DB AMP AS IN P4
ifmrise        =         p9*p3               ;P9: % OF TOTAL DURATION, 1=ENTIRE NOTE DURATION
ifmdec         =         p10*p3              ;P10: % OF TOTAL DURATION
ifmoff         =         p3 - (ifmrise + ifmdec)
index          =         p11
ivibdepth      =         p12
ivibrate       =         p13
iformantamp    =         p14                 ;P14: % OF TOTAL AMPLITUDE, 1=DB AMP AS IN P4
iformantrise   =         p15*p3              ;P15: % OF TOTAL DURATION, 1=ENTIRE NOTE DURATION
iformantdec    =         p3 - iformantrise

kpluck         linseg    ipluckamp, ipluckdur, 0, ipluckoff, 0
apluck1        pluck     iamp, p5, p5, 0, 1
apluck2        pluck     iamp, p5*1.003, p5*1.003, 0, 1
apluck         =         kpluck * (apluck1+apluck2)

kfm            linseg    0, ifmrise, ifmamp, ifmdec, 0, ifmoff, 0
kndx           =         kfm * index
afm1           foscil    iamp, p5, 1, 2, kndx, 1
afm2           foscil    iamp, p5*1.003, 1.003, 2.003, kndx, 1
afm            =         kfm * (afm1+afm2)

kformant       linseg     0, iformantrise, iformantamp, iformantdec, 0
kvib           oscil     ivibdepth, ivibrate, 1
afrmt1         fof       iamp, p5+kvib, 650, 0, 40, .003,.017,.007,4,1,2,p3
afrmt2         fof       iamp, (p5*1.001)+kvib*.009, 650, 0, 40, .003,.017,.007,10,1,2,p3
aformant       =         kformant * (afrmt1+afrmt2)

               outs      apluck + afm + aformant, apluck + afm + aformant
               endin

</CsInstruments>
<CsScore>
                                             ; TOOT13.SCO
f1  0  8192  10  1                           ; SINE WAVE
f2  0  2048  19  .5  1  270 1                ; SINE QUADRANT RISE

;  pluckamp = p6     -  % OF TOTAL AMPLITUDE, 1=DB AMP AS SPECIFIED IN P4
;  pluckdur = p7*p3  -  % OF TOTAL DURATION, 1=ENTIRE DURATION OF NOTE

;  fmamp =  p8       -  % OF TOTAL AMPLITUDE, 1=DB AMP AS SPECIFIED IN P4
;  fmrise = p9*p3    -  % OF TOTAL DURATION, 1=ENTIRE DURATION OF NOTE
;  fmdec = p10*p3    -  % OF TOTAL DURATION
;  index = p11       -  NUMBER OF SIGNIFICANT SIDEBANDS: P11 + 2
;  vibdepth = p12
;  vibrate = p13
;  formantamp = p14  -  % OF TOTAL AMPLITUDE, 1=DB AMP AS SPECIFIED IN P4
;  formantrise = p15*p3  - % OF TOTAL DURATION, 1=ENTIRE DURATION OF NOTE
 f0 1
 f0 2
 f0 3
 f0 4
 f0 6
 f0 7
 f0 8
 f0 9
 f0 10
 f0 11
 f0 12
 f0 14
 f0 15
 f0 16
 f0 17
 f0 18
 f0 19
 f0 20
 f0 21
 f0 22
 f0 23
 f0 24
 f0 25
;ins st dur   amp frq  plkmp    plkdr  fmmp  fmrs fmdc indx vbdp vbrt frmp fris
i13  0   5    80  200  .8      .3       .7   .2 .35    8     1      5      3     .5
i13  5   8    80  100  .        .4       .7  .35    .35    7     1      6      3     .7
i13 13  13    80   50   .        .3       .7     .2 .4      6     1     4      3     .6
 e

</CsScore>
</CsoundSynthesizer>
