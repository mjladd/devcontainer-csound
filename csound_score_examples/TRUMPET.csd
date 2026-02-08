<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from TRUMPET.ORC and TRUMPET.SCO
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1


          instr 1
irandev   =         .007
ifreqrand =         125
ivibatt   =         .6
ivibdec   =         .2
ivibwth   =         .007
ivibrate  =         7
iportdev  =         .03
iportatt  =         .06
iportdec  =         .01
iampfac   =         .833
ifund     =         cpspch(p4)
iafrmfac  =         1-iampfac
imax      =         2.66
iratio    =         1.8/imax
ifreqfrm  =         int(1500/ifund+.5)*ifund
ifreqmod  =         ifund
ifundatt  =         .03
ifunddec  =         .15
ifrmatt   =         .03
ifrmdec   =         .3
imodatt   =         .03
imoddec   =         .01

kphs      linen     ivibwth, ivibatt, p3, ivibdec
kvfac     tablei    kphs, 4, 1
kvibgate  =         kvfac*ivibwth
kport     envlpx    iportdev, iportatt, p3, iportdec, 5, 1, .01
krand     randi     irandev, ifreqrand, -1
kosc      oscil     kvibgate, ivibrate, 1
kvib      =         (krand+1)*(kosc+1)*(kport+1)

kgatemod  envlpx    imax*ifreqmod, imodatt, p3, imoddec, 3, 1.2, .01, .2
kgatefd   envlpx    iampfac, ifundatt, p3, ifunddec, 2, 1, .01
kgatefrm  envlpx    iafrmfac, ifrmatt, p3, ifrmdec, 2, 1, .01
amod      oscili    kgatemod, ifreqmod*kvib, 1
afund     oscili    kgatefd, ifund*kvib+amod, 1
afrm      oscili    kgatefrm, ifreqfrm*kvib+amod*iratio, 1
          out       (afund+afrm)*p5
          endin

</CsInstruments>
<CsScore>
f01     0       1024    10      1
f02     0       129     9       .35     1       0
f03     0       129     9       .4      1       0
f04     0       129     9       .25     1       0
f05     0       129     9       .3875   1.4142  0

i01     1       4       8.00    20000
i01     6       .25     8.00    5000
i01     6.25    .       8.02    6000
i01     6.50    .       8.04    7000
i01     6.75    .       8.05    8000
i01     7       .       8.07    9000
i01     7.25    .       8.09    10000
i01     7.50    .       8.10    11000
i01     7.75    .       9.00    12000
i01     8       .       9.02    13000
i01     8.25    .       9.03    14000
i01     8.5     .       9.05    15000
i01     8.75    .       9.07    16000
i01     9       .       9.08    17000
i01     9.25    .       9.10    18000
i01     9.5     4.5     10.00   19000

e

</CsScore>
</CsoundSynthesizer>
