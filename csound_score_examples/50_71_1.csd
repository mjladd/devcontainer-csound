<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 50_71_1.orc and 50_71_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps =100
nchnls = 1

; ************************************************************************
; ACCCI:     50_71_1.ORC
; synthesis: subtractive synthesis(50)
;            two fixed formant regions(71)
;            buzz pulse as source(1)
; coded:     jpg 11/93




instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = cpspch(p5)
inmh   = sr/2/ifqc

      asrc    buzz    iamp,ifqc,inmh,1             ; buzz source

      a1      reson   asrc,1000,100,0             ; formant regions
      a2      reson   a1,3000,500,0

      asig    balance a2,asrc                     ; in/out balance
      asig    linen   asig, .1, idur, .1          ; envelope
            out     asig*4
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     50_71_1.SCO
; coded:     jpg 11/93


; GEN functions **********************************************************
; sinus
f1  0   8193  10   1


; score ******************************************************************

t 0 300

;       idur  iamp   ipch
i1   0   2    8000   7.00
i1   +   1    .      7.02
i1   .   .    .      7.04
i1   .   .    .      7.05
i1   .   .    .      7.07
i1   .   .    .      7.09
i1   .   .    .      7.11
i1   .   2    .      8.00

s
t 0 60

i1   1   1    4000   7.00
i1   .   .    .      7.04
i1   .   .   12000   7.07
i1   .   .    4000   8.00

e




</CsScore>
</CsoundSynthesizer>
