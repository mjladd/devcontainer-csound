<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_40_1.orc and 01_40_1.sco
; Original files preserved in same directory

sr = 44100
kr   = 441
ksmps =100
nchnls = 1

; ************************************************************************
; ACCCI:     01_40_1.ORC
; synthesis: simple(01),
;            basic instrument with continuous pitch control mechanism:
;            optional LFO modulation of frequency(40)
; coded:     jpg 10/93



instr  1; ****************************************************************
idur  = p3
if1   = p4            ; chooses waveform
iamp2 = p5        ; determines frequency of note event together with if2
irate = p6/idur   ; repetition rate of LFO
if2   = p7            ; chooses frequency control function
iamp3 = p8        ; amplitude of note
if3   = p9            ; chooses envelope shape

        a3   oscili  iamp3, 1/idur, if3         ; envelope
        a2   oscili  iamp2, irate, if2          ; LFO modulation of pitch
        a1   oscili  a3, a2, if1                ; waveform
             out     a1

endin

</CsInstruments>
<CsScore>
; **********************************************************************
; ACCCI:     01_40_1.SCO
; coded:     jpg 10/93

; **********************************************************************
; GEN functions
; waveforms
f1   0 2048 10  1 .4 .2 .1 .1 .05                  ; six harmonics
f2   0 1024 10  1                                  ; sinus
f41  0  512  7  0 128 10 256 -10 128 0             ; sawtooth

; envelope
f31  0 512 7 0 1 0 79 .5 60  .5 20 .99 120 .4 140 .6 92 0

; pitch control functions (LFO)
f32  0 512 7   .895  512   .99     ; gen07 line segments    10% rise
f33  0 512 7  1      512  1        ;                         0% rise
f34  0 512 7   .99   512   .99     ;                         0% rise
f35  0 512 7  1      512   .5      ;                        oct down
f36  0 512 7  1 102 1 102 .8 102 .85 102 .7 104 .2    ; more complex

f37 0  512  7  .999 50 .999 412 .85 50 .85              ; third down
f38 0  512  7  .999 20 .999 472 .235 20 .235         ; ~two octs down
f39 0  512  7  .999 25 .999 462 .06  25 .06              ; sixth down
f40 0  512  7  .25  30 .25  110 .5  60 .25 10 .25 60 .5 20 .75 222 .5

; **********************************************************************
; score
;                         freq LFO           amp
; instr 1            if1 iamp2 irate if2  iamp3 if3
i1   1  .5           1     988   1    32  8000  31
i1   2  .            .      .    .    33     .   .   ; pitch control is if2
i1   3  .            .      .    .    34     .   .
i1   4  3            .      .    .    35     .   .
i1   +  .            .      .    .    36     .   .

s
; section 2: carrier is sinus, LFO is f37 at 4 times a note
; instr 1            if1 iamp2 irate if2  iamp3 if3
i1   0 18             2   208    4    37   8000  31

s
; section 3: carrier sawtooth, LFO is f40 at 2.2 times a note
; instr 1            if1 iamp2 irate if2  iamp3 if3
i1   0 18            41   1864  2.2    40   8000  31

e
</CsScore>
</CsoundSynthesizer>
