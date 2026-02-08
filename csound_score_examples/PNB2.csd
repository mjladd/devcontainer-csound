<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from PNB2.ORC and PNB2.SCO
; Original files preserved in same directory

     sr             =         44100
     kr             =         44100
     ksmps          =         1
     nchnls         =         1

;*******************************************************;
;        PITCH CHANGING INSTRUMENT WITH PITCH BEND      ;
;                                                 ;
;    P4 = AMPLITUDE FACTOR                   ;
;    P5 = DESIRED STARTING PITCH IN PCH           ;
;    P6 = OLD PITCH IN PCH                   ;
;    P7 = FUNCTION NUMBER OF SOUNDIN FILE         ;
;    P8 = MAXIMUM AMOUNT OF PITCH BEND IN OCT     ;
;    P9 = FUNCTION NO. OF PITCH BEND              ;
;    P10 = SECONDS OF DELAY BEFORE PITCH BENDS    ;
;    N.B.  P9 MUST ALWAYS BE A RISING FUNCTION.   ;
; IF A DOWNWARD PITCH BEND IS DESIRED MAKE P8 NEGATIVE.     ;
;*******************************************************;
;
          instr     1
        ioctnew     =         octpch(p5)
        icpsold     =         cpspch(p6)
     ioldsr         =         20000
     kchng          oscil1i   p10, p8, p3, p9
     kcpsnew        =         cpsoct (ioctnew + kchng)
        kincr       =         ioldsr/sr * kcpsnew/icpsold
        kphase      init      0                                  ;INITIALIZE PHASE
        aphase      interp    kphase                             ;CONVERT TO ARATE
        asig        tablei    aphase,p7                          ;RESAMPLE THE SOUND
        kphase      =         kphase+kincr*ksmps                 ;UPDATE FOR NEXT K
     asignal        envlpx    asig*p4,.001,p3,(p3-.001),23,1,.1
                    out       asignal
                    endin


</CsInstruments>
<CsScore>
;*******************************************************;
;        PITCH CHANGING INSTRUMENT WITH PITCH BEND      ;
;                                                 ;
;    P4 = AMPLITUDE FACTOR                   ;
;    P5 = DESIRED STARTING PITCH IN PCH           ;
;    P6 = OLD PITCH IN PCH                   ;
;    P7 = FUNCTION NUMBER OF SOUNDIN FILE         ;
;    P8 = MAXIMUM AMOUNT OF PITCH BEND IN OCT     ;
;    P9 = FUNCTION NO. OF PITCH BEND              ;
;    P10 = SECONDS OF DELAY BEFORE PITCH BENDS    ;
;    N.B.  P9 MUST ALWAYS BE A RISING FUNCTION.   ;
;IF A DOWNWARD PITCH BEND IS DESIRED MAKE P8 NEGATIVE. ;
;*******************************************************;
f5    0   32768     -1     5            0                        ;CALLED BY P7
f23   0     513       7    0       512  1    1    1
f24   0     513      5     0.12             512   1    1    1
;    INSTRUMENT CARDS
i1     0.00      1.00         3.50    10.11  11.00    5      0.25            24  0.1
s
f0 1
s
i1     0.00      1.50         0.54    10.11  11.00     5   0.00       23  0.0
i1     0.50      1.50         0.56    12.08  12.00     5   0.00       23  0.0
i1     0.90      1.50         0.59    12.02  12.00     5   0.00       23  0.0
i1     1.25      1.50         0.62    11.01  11.00     5   0.00       23  0.0
i1     1.45      1.50         0.65    11.09  11.08     5   0.00       23  0.0
i1     1.65      1.50         0.68    10.07  10.08     5   0.00       23  0.0
i1     1.80      1.50         0.71    11.06  11.04     5   0.00       23  0.0
i1     2.00      2.90         0.74    10.05  10.04     5   0.00       23  0.0
i1     2.18      2.90         0.77     9.04   9.04     5   0.00       23  0.0
i1     2.38      2.90         0.79     9.10  10.00     5   0.00       23  0.0
i1     2.45      1.50         0.82     9.03   9.04     5  -0.08       24  0.0
i1     3.92      4.00         0.85     8.11   9.00     5   0.00       23  0.0
i1     4.18      2.90         0.88     9.05   9.04     5   0.00       23  0.0
i1     4.31      4.00         0.90     7.04   7.04     5   0.00       23  0.0
i1     4.39      1.00         0.89     8.00   8.00     5  -0.17       24  0.2
i1     5.27      4.00         0.88     7.09   7.08     5   0.00       23  0.0
i1     5.38      0.70         0.95     8.08   8.08     5  -0.08       24  0.1
i1     6.00      5.00         0.96     7.01   7.00     5   0.00       23  0.0
e

</CsScore>
</CsoundSynthesizer>
