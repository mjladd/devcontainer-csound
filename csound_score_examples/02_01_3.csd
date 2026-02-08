<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 02_01_3.orc and 02_01_3.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 2

; ************************************************************************
; ACCCI:     02_01_3.ORC
; timbre:    gong
; synthesis: additive same units(02)
;            basic instrument(01)
; source:    #420  Gong-like Sounds, Risset(1969)
; coded:     jpg 8/93


instr 1; *****************************************************************
idur  = p3
ifq1  = p4
iamp  = p5

   a2    oscili  iamp, 1/idur, 51
   a1    oscili  a2, ifq1, 11
         outs     a1, a1
endin



</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     02_01_3.SCO
; source:    #420  Gong-like Sounds, Risset(1969)
; coded:     jpg 8/93


; GEN functions **********************************************************
; waveform
f11  0   512   9  1  1  0

; envelopes
f51  0   513   5  128 512 1



; score ******************************************************************
;  start  idur   ifq1     iamp

i1   0    10     240      3000         ; synchronous decay
i1   .     .     277      2500
i1   .     .     385      2000
i1   .     .     605      3000
i1   .     .     340      1000
i1   .     .     670         .
i1   .     .     812         .


i1  11    10     240      3000         ; non-synchronous decay
i1   .     9.6   277      2500
i1   .     8.8   385      2000
i1   .     1.6   605      3000
i1   .     8.0   340      1000
i1   .     5.2   670         .
i1   .     4.0   812         .


i1  22    8.0    242.5    3000         ; different frequencies
i1   .    7.6    307.5    2500         ; non-synchronous decay
i1   .    6.8    340.0    1000
i1   .    4.8    384.0    2000
i1   .    3.6    521.0    1000
i1   .    2.8    802.0    1500

i1  31    10     240      3000         ; 4 overlapping attacks
i1   .     9.6   277      2500         ; beats
i1   .     8.8   385      2000
i1   .     1.6   605      3000
i1   .     8.0   340      1000
i1   .     5.2   670         .
i1   .     4.0   812         .

i1 32.8    8.8   241.25   2000
i1   .     8.4   262.25   1500
i1   .     4.0   357.5    2500
i1   .     5.2   302.5    1000
i1   .     4.4   315         .
i1   .     7.6   385         .
i1   .     6.4   482.5       .

i1 33.2   11.6   242.5    3000
i1   .    10.8   307.5    2500
i1   .    10.4   340      1000
i1   .     6.4   384      2000
i1   .     4.8   512      1000
i1   .     4.4   820      1500

i1 38.8   13.6   240      1500
i1   .    12.8   277      1250
i1   .    12.0   385      1500
i1   .    8.4    605       500
i1   .    3.20   340      1000
i1   .    6.40   670       500
i1   .    4.40   812       500

e

</CsScore>
</CsoundSynthesizer>
