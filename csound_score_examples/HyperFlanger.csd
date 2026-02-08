<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from HyperFlanger.orc and HyperFlanger.sco
; Original files preserved in same directory

sr       = 44100
kr       = 4410
ksmps    = 10
nchnls   = 1


instr    1 ; 'Hyperflanger': 4 flangers in series with staggered delays

ilevl    = p4*.09                         ; Output level
idely    = p5                             ; Manual delay (0 to 1)
idpth    = p6/2                           ; LFO depth (0 to 1)
irate    = p7                             ; LFO rate (Hz)
iwave    = p8                             ; LFO waveform

ain      soundin  "Sample1"

alfo     oscili  idpth, irate, iwave      ; Generate LFO
alfo     = alfo + idpth                   ; Make single ended
alfo     tablei  alfo + idely, 1, 1       ; Convert to exponential
alfo     = 1/alfo                         ; Convert to delay time
aflng1   flanger  ain, alfo, 0, 1         ; Delay 1
aflng1   = aflng1 + ain                   ; Sum with input
aflng2   flanger  aflng1, alfo*1.25, 0, 1 ; Delay 2
aflng2   = aflng2 + aflng1                ; Sum with input
aflng3   flanger  aflng2, alfo*1.50, 0, 1 ; Delay 3
aflng3   = aflng3 + aflng2                ; Sum with input
aflng4   flanger  aflng3, alfo*1.75, 0, 1 ; Delay 4
aflng4   = aflng4 + aflng3                ; Sum with input
out      aflng4*ilevl                     ; Level and output


endin
</CsInstruments>
<CsScore>
f01 0 8193 -5 100 8192 7500        ; Exponential convertor
f02 0 8193 10 1                    ; Sine
f03 0 8193 7 -1 4096 1 4096 -1     ; Triangle
f04 0 8193 10 1 0 0 0 0 0 0 0 0 .1 ; Fast and slow sines
f05 0 33 21 1                      ; Random

;Delay and Depth: 0 to 1

;     Strt  Leng  Levl  Delay Depth Rate  Wave
i01   0.00  1.50  1.00  0.25  0.50  0.67  03
i01   2.00  .     .     0.00  1.00  1.00  05
e
</CsScore>
</CsoundSynthesizer>
