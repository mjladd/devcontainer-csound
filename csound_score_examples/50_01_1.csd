<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 50_01_1.orc and 50_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:     50_01_1.ORC
; timbre:    bands of noise
; synthesis: subtractive synthesis(50)
;            basic design(01)
;            RAND source(1)
; coded:     jpg 11/93




instr 1; *****************************************************************
idur  = p3
iamp  = p4
icfq  = cpspch(p5)
ibw   = p6*icfq


   anoise  rand   iamp                        ; white noise
   a1      reson  anoise,  icfq, ibw, 2       ; filter
   a1      linen  a1, .1, idur, .1
           outs    a1, a1

endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     50_01_1.SCO
; coded:     jpg 11/93


; score ******************************************************************

;    start idur  iamp   ipch   iperc
i1    0     1    8000  11.00   .05
i1    1.1   .    .     10.00   .
i1    2.3   8    .      9.00   .
i1    3     2    4000  10.07   .
i1    3     2    5000   8.00   .
i1    3     2    3500  12.04   .
i1    6     .3   4000  14.07   .
i1    6     .    5000  13.00   .
i1    6     .    3500  13.04   .
i1    6.3   .4   4000  10.07   .
i1    6.3   .    5000   9.00   .
i1    6.3   .    3500  11.04   .
i1    8.1   1   10000  11.04   .

e

</CsScore>
</CsoundSynthesizer>
