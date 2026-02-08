<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from RhythmicGate.orc and RhythmicGate.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Rhythmic Gate / DJ 'Transformer'

ilevl    = p4   ; Output level
itabl1   = p5   ; Gate pattern table no.
itabl2   = p6   ; Gate shape table no.
itime    = 1/p3 ; Note length

ain      soundin  "Marimba.aif"

kind     phasor  itime                   ; 0 to 1 index
kgate1   table  kind, 1, itabl1          ; Read gate pattern
kgate    oscil  kgate1, 16*itime, itabl2 ; Read gate shape
kgate    port  kgate, .0001              ; Slew gate edges
out      ain*kgate                       ; Gate output

endin

</CsInstruments>
<CsScore>
;16th notes  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
f1 0 16 2    1  1  0  1  1  0  0  1  0  1  1  0  1  0  1  0 ; Gate pattern
f2 0 16 2    1  0  1  0  0  0  1  0  0  1  0  0  1  0  0  0 ; Gate pattern

; Gate shapes
f10 0 1024 -7 1 1024 1          ; 100% On
f11 0 1024 -7 1 512 1 0 0 512 0 ; 50% On
f12 0 1024 -7 1 1024 0          ; Linear decay
f13 0 1024 -5 1 1024 .0001      ; Exponential decay
f14 0 1024 -7 0 512 1 512 0     ; Linear fade in/out

;   Strt  Leng  Levl  Patt  Gate
i1  0.00  1.47  1.00  2     11
i1  2.00  .     .     .     13
i1  4.00  .     .     1     10
e

</CsScore>
</CsoundSynthesizer>
