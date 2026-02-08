<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from arnotFM.ORC and arnotFM.SCO
; Original files preserved in same directory

sr                  =              44100
kr                  =              4410
ksmps               =              10
nchnls              =              1

; BASIC CHOWNING FM INSTRUMENT
; JOHN M. ARNOTT II
; 2/16/90




; p3=duration   p4=fundamental  p5=amplitude p6=fn#1    p7=peakIndex
; p8=fn#2       p9=carrierfact p10=modfactor

                    instr          1

        ifc         =              p4*p9
        ifm         =              p4*p10
        kindex      oscil1i        0,p7,p3,p8
        kgate       oscil1i        0,p5,p3,p6
        amodsig     oscili         kindex*ifm, ifm, 1
        asig        oscili         kgate, ifc+amodsig, 1
                    out            asig
                    endin





</CsInstruments>
<CsScore>
; JOHN M. ARNOTT II
; FM TONES USING A SIMPLE FM ORCHESTRA AND SPECIFIC FCARDS.
; 1 BEAT/SECOND

t00     60

; SINE
f01     0       512     10       1
; EXPONENTIAL DECAY
f02     0       513     5       1       512     .001    1       .001
; ENVELOPE F1 FOR PART C
f03     0       512     6       .8      64      1       64      1      128
                                .5      128     .2      32      .13     32
                                .1      32      .05     32      0
; ENVELOPE F2 FOR PART C
f04     0       512     7       1       120     0
; ENVELOPE FOR PART D
f05     0       512     7       0       100     1       100     .7      220     .7      98      0


; FM
;p1      P2      P3      P4      P5      P6      P7      P8     P9      P10
;BELL
i01     0       8       263     10000   2       10      2       5       7
;WOOD DRUM
i01     8      0.2      .       .       3       25      4       1.45    1
;BRASS
i01     10     0.6      .       .       5       5       5       1       1
e

</CsScore>
</CsoundSynthesizer>
