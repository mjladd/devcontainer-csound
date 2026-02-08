<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_12_1.orc and 01_12_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     01_12_1.ORC
; synthesis: simple(01), basic instrument + random amp variation(12)
; coded:     jpg 10/93


instr  1; ****************************************************************
idur  = p3
iamp  = p4
ifq1  = p5
if1   = p6
if2   = p7
iperc = p8  ; random amplitude in percent of iamp
ifqr  = p9  ; frequency of new random numbers

        a3   randi    (iamp/100)*iperc, ifqr  ; % of amplitude variation

        a2   oscili   a3+iamp, 1/idur, if2    ; envelope

        a1   oscili   a2, ifq1, if1           ; waveform
             out      a1
endin

</CsInstruments>
<CsScore>
; **********************************************************************
; ACCCI:     01_12_1.SCO
; coded:     jpg 10/93

; **********************************************************************
; GEN functions
; waveform
f1 0 2048 10 1 .4 .2 .1 .1 .05                   ; six harmonics

; envelopes
f31 0 512 7 0 1 0 49 .2 100 .6 50 .99 150 .2 162 0



; **********************************************************************
; score                                       RANDI
; instr 1  idur     iamp  ifq1 if1  if2    iperc  ifqr
i1  1      1.5      8000  1109  1    31      1     40
i1  4       .        .    .     .    .      50     .
i1  7       .        .    .     .    .      80     .
i1 10       .        .    .     .    .     200     .
i1 13       .        .    .     .    .     300     .

e


</CsScore>
</CsoundSynthesizer>
