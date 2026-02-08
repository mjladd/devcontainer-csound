<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from FlangerX.orc and FlangerX.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 2


instr    1 ; Dual Flanger with normal and cross feedback

ilevl    = p4       ; Output level
idelay   = p5/1000  ; Delay in ms
idepth   = p6/2000  ; LFO depth in ms
irate1   = p7       ; L LFO rate
irate2   = p8       ; R LFO rate
iphase   = p9/360   ; R LFO phase
iwave    = p10      ; LFO waveform
ifdbk1   = p11      ; L feedback
ifdbk2   = p12      ; R feedback
ixfdbk   = p13      ; X feedback
idry     = p14*.707 ; Dry output level
imax     = idepth + idelay + .1
adel1    init 0
adel2    init 0

ain      soundin  "Piano.aif"

asig1    = ain + ixfdbk*adel2
asig2    = ain + ixfdbk*adel1
alfo1    oscili  idepth, irate1, iwave
alfo1    = alfo1 + idepth
alfo2    oscili  idepth, irate2, iwave, iphase
alfo2    = alfo2 + idepth
aflange1 flanger  asig1, alfo1 + idelay, ifdbk1, imax
aflange2 flanger  asig2, alfo2 + idelay, ifdbk2, imax
outs1    (aflange1 + ain*idry)*ilevl
outs2    (aflange2 + ain*idry)*ilevl

endin

</CsInstruments>
<CsScore>
f1 0 8193 10 1                    ; Sine
f2 0 8193 7 -1 4096 1 4096 -1     ; Tri
f3 0 8193 10 1 0 0 0 0 0 0 0 0 .1 ; Slow and fast sines

;Depth and delay in ms. LFO Phase in degrees

;                           ------------LFOs------------  -----Feedback----
;   Strt  Leng  Levl  Delay Depth RateL rateR Phase Wave  Fdbk1 Fdbk2 XFdbk Dry
i1  0.00  1.47  1.00  0.25  3.75  0.68  0.68  090   3    -0.75 -0.75 +0.75  0.00
e

</CsScore>
</CsoundSynthesizer>
