<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 40_60_1.orc and 40_60_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      40_60_1.ORC
; timbre:
; synthesis:  waveshaping(40)
;             polynomial function table for transfer function(60)
;             general purpose waveshaper(1)
; coded:      jpg 11/93


; sinus and table waveshaper should be the same value
; amplitude input of waveshaping oscillator is int(table length/2)
; p6 'xamp' of GEN 13  is also int(table length/2)
; odd function, always odd harmonics.. check Chebychev function type

instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifqc  = cpspch(p5)
itf   = p6

        a1      oscili   4096, ifqc, 1              ; sinus
        a1      tablei   a1, itf                    ; transfer function
        ; now:  -1 < a1 < 1

        aenv    linen    iamp, .085, idur, .04      ; envelope
                out      a1*aenv
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:   40_60_1.SCO
; coded:   jpg 11/93


; GEN functions **********************************************************
; carrier
f 1   0 8193 10 1               ; sinus

; transfer function by GEN 13: use of Chebychev coefficients
;                  xamp    xint    h0 h1 h2  ..... hn
f 88  0  8193  13  4096     1      1  1
f 89  0  8193  13  4096     1      1  1 1 2
f 90  0  8193  13  4096     1      1  1 0 0 0 0 0 6 5 4

; score ******************************************************************

;           idur   iamp   ipch  itf
i1  0.000   0.750  8000   7.04   88
i1  0.750   0.250  .      7.07   .
i1  1.000   1.000  .      8.00   .
i1  2.000   0.200  .      8.02   89
i1  2.200   0.200  .      8.04   .
i1  2.400   0.200  .      8.05   .
i1  2.600   0.200  .      9.00   .
i1  2.800   0.200  .      9.04   .
i1  3.000   0.250  .      9.05   .
i1  3.250   0.250  .      9.00   .
i1  3.500   0.250  .      8.05   .
i1  3.750   0.250  .      8.00   .
i1  4.000   1.000  .      7.04   90
i1  5.000   0.125  .      7.07   .
i1  5.125   0.125  .      8.00   .
i1  5.250   0.125  .      8.02   .
i1  5.375   0.125  .      8.04   .
i1  5.500   0.125  .      8.05   .
i1  5.625   0.125  .      9.00   .
i1  5.750   0.125  .      9.04   .
i1  5.875   0.125  .      9.05   .

e

</CsScore>
</CsoundSynthesizer>
