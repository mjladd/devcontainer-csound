<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_01_4.orc and 02_01_4.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ***********************************************************************
; ACCCI:     02_01_4.ORC
; timbre:    bell
; synthesis: additive same units(02)
;            basic instrument(01)
; source:    #410  Percussive Drum-like and Bell-like Sounds,
;            Risset(1969)
; coded:     jpg 8/93


instr 1; ****************************************************************
idur  = p3
iamp  = p4
ifq1  = p5 * p6

   a2    oscili  iamp, 1/idur, 51
   a1    oscili  a2, ifq1, 11
         out     a1
endin


</CsInstruments>
<CsScore>
; ***********************************************************************
; ACCCI:     02_01_4.SCO
; source:    #410 Percussive Drum-like and Bell-like Sounds, Risset(1969)
; coded:     jpg 8/93


; GEN functions *********************************************************
; waveform
f11  0   512   9  1  1  0

; envelopes
f51  0   513   5  256 512 1


; score *****************************************************************
;  start  idur   iamp  ifq1  irat
i1   1     3.0   2000   329   1.0              ; #410: section 3
i1   1     2.8      .     .   2.0
i1   1     2.7      .     .   2.4
i1   1     2.4      .     .   3.0
i1   1     2.2   3000     .   4.5
i1   1     1.5      .     .   5.33
i1   1     1.5      .     .   6

s2

i1   1     4.0   4000   329   1.0              ; #410: section 4
i1   1     3.5      .     .   2.0
i1   1     3.2      .     .   2.5
i1   1     2.9      .     .   3.36

e



</CsScore>
</CsoundSynthesizer>
