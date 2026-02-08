<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_41_1.orc and 01_41_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        01_41_1.ORC
; synthesis:    simple(01)
;               basic instrument with continuous pitch control function
;               (LFO) and RANDI instead of envelope(41)
; source:       #511  Glissandi with constant frequency differences
;               between voices, Risset(1969)
; coded:        jpg 9/93


instr 1; *****************************************************************
iampr   = p4
ifqr    = p5
iamp1   = p6 ; f33 and iamp1 point to instantaneous frequency
irate   = p7

   a1    randi    iampr, ifqr
   a2    oscili   iamp1, irate,  33   ;two octs down
   a2    oscili   a1,   a2,      11   ;sinus
         out      a2*10
endin
</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:      01_41_1.SCO
; source:     511.sco  Glissandi with constant frequency differences
;             between voices, Risset(1969)
; coded:      jpg 9/93

; GEN functions **********************************************************
; waveforms
f11 0  512  9  1 1 0                                                ; sine
f31 0  512  7  0 128 10 256 -10 128 0                           ; sawtooth
; continuous pitch control functions
f32 0  512  7  .999 50 .999 412 .85 50 .85                    ; third down
f33 0  512  7  .999 20 .999 472 .235 20 .235              ; ~two octs down
f34 0  512  7  .999 25 .999 462 .06  25 .06                   ; sixth down
f35 0  512  7  .25  30 .25  110 .5  60 .25 10 .25 60 .5 20 .75 222 .5

; score ******************************************************************
;                   RANDI             LFO
;                 amp control     pitch control
;instr 1  idur    iampr ifqr      iamp1  irate
i1  1     6.5     800   80       1000     3
i1  3     .       800  150        750     .

e

</CsScore>
</CsoundSynthesizer>
