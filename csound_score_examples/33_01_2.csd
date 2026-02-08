<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 33_01_2.orc and 33_01_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:     33_01_2.ORC
; timbre:    gong
; synthesis: Amplitude Modulation(33)
;            ring modulation, multiplier(01)
;            sinus and block(2)
; source:    #550  Ring-modulation Chord with Gong-like Resonance
;            Risset(1969)
; coded:     jpg 9/93


instr 1; *****************************************************************
idur  = p3            ; ring modulation chord
iamp  = p4
irise = p5
idec  = p6
ifqc  = p7
ifqm  = p8

   a1    envlpx   iamp, irise, 1/idur, idec, 51, 1, .01
   a1    oscili   a1, ifqc, 11                            ; sinus
   a2    oscili   1, ifqm, 31                             ; block
         out      a1*a2                                   ; ring
endin

instr 2; *****************************************************************
idur = p3             ; gong resonance
iamp = p4
ifq  = p5

   a1    oscili   iamp, 1/idur, 52
   a1    oscili   a1, ifq, 11
         out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:    33_01_2.SCO
; source:   550.sco  Ring-modulation Chord with Gong-like Resonance
;           Risset(1969)
; coded:    jpg 9/93

; GEN functions **********************************************************
f11  0  512  9  1 1 0
f31  0  512  7  0 42 1 172 1 84 -1 172 -1 42 0
f51  0  513  5  .01 512 1
f52  0  513  5  512 512 1 ; post-normalized

; score ******************************************************************
;               envlpx           osc1   osc2       difference
;  start  idur  iamp irise idec  ifqc   ifqm
i1    .5    .6  2000   .01   .6   424   1000    ; -576   +1424
i1    .6    .6    .    .     .    727     .     ; -273   +1727
i1    .9    .6    .    .     .   1542   2000    ; -458   +3542
i1   1.1    .6    .    .     .   1136     .     ; -864   +3136
i1   1.4    .6    .    .     .   1342     .     ; -658   +3342

i1    .9   3.6    .   2.3   1.2   424   1000    ; same frequencies,
i1   1     3.5    .   3.2    .    727     .     ; but longer durations
i1   1.3   3.2    .   1.9    .   1542   2000    ; and long, slow rise
i1   1.5   3      .   1.6    .   1136     .
i1   1.8   2.7    .   1.4    .   1342     .

;  start  idur   iamp   ifq
i2   4    10     4000   273   ; fundamental
i2   4     7.5   2000   455   ; 1.6667
i2   4     4.5   2000   576   ; 2.10989
i2   4     6.5   1500   648   ; 2.37363
i2   4     4     1501   864   ; 3.16484

e



</CsScore>
</CsoundSynthesizer>
