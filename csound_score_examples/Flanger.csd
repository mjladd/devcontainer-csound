<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Flanger.orc and Flanger.sco
; Original files preserved in same directory

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2


instr    1 ; Flanger with stereo outputs

ilevl    = p4       ; Output level
idelay   = p5/1000  ; Delay in ms
idepth   = p6/2000  ; LFO depth in ms
irate1   = p7       ; L LFO rate
irate2   = p8       ; R LFO rate
iphse    = p9/360   ; R LFO phase
iwave    = p10      ; LFO waveform
ifdbk1   = p11      ; L feedback
ifdbk2   = p12      ; R feedback
idry     = p13*.707 ; Dry output level
imax     = idelay + idepth + .1

ain      soundin  "Piano.aif"

alfo1    oscili  idepth, irate1, iwave
alfo1    = alfo1 + idepth
alfo2    oscili  idepth, irate2, iwave, iphse
alfo2    = alfo2 + idepth
aflng1   flanger  ain, alfo1 + idelay, ifdbk1, imax
aflng2   flanger  ain, alfo2 + idelay, ifdbk2, imax
outs1    (ain*idry + aflng1)*ilevl
outs2    (ain*idry + aflng2)*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1                ; Sine
f2 0 8193 7 -1 4096 1 4096 -1 ; Triangle
f3 0 8193 10 1 0 0 0 0 0 .14  ; Fast and slow sines

;Delay and Depth in ms  Phase in degrees

;                           ------------LFOs------------
;   Strt  Leng  Levl  Delay Depth RateL RateR Phase Wave  FdbkL FdbkR Dry
i1  0.00  1.47  0.75  0.50  5.50  1.00  1.00  180   2    -0.75  0.75  0.00
e

</CsScore>
</CsoundSynthesizer>
