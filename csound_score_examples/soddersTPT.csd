<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from soddersTPT.ORC and soddersTPT.SCO
; Original files preserved in same directory

        sr          =         44100
        kr          =         4410
        ksmps       =         10
        nchnls      =         1


;STEVEN SODDERS           DEXTER MORRILL TRUMPET            tpt.orc
;                          INSTRUMENT 1 BLOCK
                    instr     1
        ifc1        =         p4                                 ;CARRIER FRQ
        ifc2        =         p6                                 ;FORMANT FRQ
        ifm         =         ifc1                               ;CARFRQ:MODFRQ 1:1
        iamp        =         p5                                 ;AMPLITUDE
        iratio      =         1.8/2.66
        idur        =         p3

        kvibwth     envlpx    .006,.8,1,.3,5,1.7,.01,.7          ;VIBWIDTH=.007
        kport       oscil1i   0,.03,p3,4                         ;PORTDEV=.03
        avsig       oscil     kvibwth,5,1                        ;VIBRATE=7CPS
        kfrqdev     randi     .007,125                           ;RANDEV=.007,FRQ
        avib        =         (kfrqdev+1)*(avsig+1)*(kport+1)
        kindex      envlpx    2.66*ifm,.08,idur,.01,3,1.2,.7,.7  ;MAXINDEX = 2.66
        amodsig     oscil     kindex,ifm*avib,1
        kfgate      envlpx    iamp*.2,.03,idur,.3,2,1,.01        ;FORMANT GATE
        kpgate      envlpx    iamp,.03,idur,.15,2,1,.01          ;FUNDAMENTAL GATE
        aform       oscili    kfgate,((ifc2*avib)+(amodsig*iratio)),1
        apitch      oscili    kpgate,((ifc1*avib)+amodsig),1
        asig        =         apitch+aform
                    out       asig
                    endin





</CsInstruments>
<CsScore>

;  DEXTER MORRILL TRUMPET          tpt.sco
;SIMPLE SINE WAVE
f1  0.0  513  10  1
;AMPLITUDE ENVELOPE
f2  0.0  257  08  0  100 .8 78 1 78 .8
;INDEX ENVELOPE
f3  0.0  257  09  .4 1 0
;PORTAMENTO ENVELOPE
f4  0.0  513  06 -1  1 -.99  16 0 1 .001 8 .2 400 .05 86 0
;VIBRATO WIDTH ENVELOPE
f5  0.0  513  09 .27 1 0
i1  0.0  1.0  250  8000  1500
i1  1.5  1.0  500  8000  1500
e



</CsScore>
</CsoundSynthesizer>
