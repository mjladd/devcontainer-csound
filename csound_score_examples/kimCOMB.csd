<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from kimCOMB.ORC and kimCOMB.SCO
; Original files preserved in same directory

sr                  =         44100
kr                  =         4410
ksmps               =         10
nchnls              =         2

;HAEYON KIM 10:54AM  5/02/1989
;COMB TRUMPET ORCHESTRA
;***************************************************;
;P4=AMP P5=PCH P6=LOOP # PER SECOND P7=REVERB TIME  ;
;P8=LOOP DATA SPACE                                 ;
;***************************************************;


instr               5,6,7,8

        ilpt        =         1/p6
        irvt        =         p7
        istor       =         p8
        iamp        =         p4
        ifc1        =         cpspch(p5)
        ifc2        =         ifc1*6
        ifm         =         ifc1
        index1      =         2.66*ifm
        iratio      =         1.8/2.6

;VIBRATO AND PORTAMENTO

        kvbct       linen     1,.02,1,.01         ;VIBRATO
        kvib        oscili    kvbct*.007,7,1      ;VIBRATO GENERATOR
        kvib        =         1+kvib
        krand       randi     .007,125            ;RANDOM DEVIATION IN VIB WIDTH
        krand       =         1+krand
        kport       linen     .03,.01,1,.01       ;PORTAMENTO
        kport       =         1+kport
        kresult     =         kvib*krand*kport
perform:
        kamp        linseg    0,.03,index1,p3-0.3-.04,index1,0.05,0,1,0
        amod        oscili    kamp,ifm*kresult,6
        kamp        linseg    0,.0003,iamp,p3-0.3-.04,iamp,0.05,0,1,0
        acar1       oscili    kamp,amod+ifc1*kresult,6
        kamp        linseg    0,.0003,iamp*.2,p3-0.3-.04,iamp*.2,0.05,0,1,0
        acar2       oscili    kamp,(amod*iratio)+(ifc2*kresult),6
        asig1       =         acar1+acar2
continue:
        acomb       comb      asig1,irvt,ilpt,istor
        adelsig     delay     asig1,ilpt
        abal        balance   acomb,adelsig
                    ;display  adelsig,.005
                    ;display  acomb,.005
                    ;display  abal,.005
        kamp        linen     1,0.2,p3,0.05
        asig2       =         abal*kamp
                    outs      asig2,asig2
                    endin

</CsInstruments>
<CsScore>
;HAEYON KIM  10:57AM  5/02/1989
;COMB TRUMPET SCORE
;TEMPO = 60 BEATS/MIN
t00    60
; SIMPLE SINE FUNCTION
f01     0       512    10       1
;EXPONENTIAL RISE AND DECAY
f02     0       513     5       .0001    256     1       256     .0001
; TRIANGULAR WAVE
f06     0       512     10      1   0 .111   0  .04    0  .02    0  .012
; SAWTOOTH WAVE
f07     0       512     10      1  .9  .8   .7   .6   .5  .4   .3   .2   .1
; SQUARE WAVE
f08     0       512     10      1   0   .3   0   .2    0  .14    0 .111
; NARROW PULSE
f09     0       512     10      1 1  1   1 .7 .5 .3 .1
;====================================================================;
;                Comb Trumpet Instrument                             ;
;  p4=amp, p5=pch, p6=loop # per second, p7=reverb time, p8=lds      ;
;====================================================================;
;p1     p2      p3      p4      p5      p6      p7      p8

i05     0       1.1     1000    7.00    50      2       0
i05     0.1     1.0     2000    7.01    .       .       .
i05     0.2     .8      4000    7.02    .       .       .
i05     0.3     1.0     .       7.03    .       .       .
i05     0.4     .8      .       7.04    200     .       .
i05     0.5     .       .       7.05    .       1       .
i05     0.6     .       .       7.04    .       .       .
i05     0.7     .       .       7.03    .       .       .
i05     0.8     .       .       7.02    .       .       .
i05     0.9     .       .       7.01    1000    .       .
i05     1.0     .       .       7.00    .       .       .
e

</CsScore>
</CsoundSynthesizer>
