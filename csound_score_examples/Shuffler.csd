<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from Shuffler.orc and Shuffler.sco
; Original files preserved in same directory

sr     = 44100
kr     = 44100
ksmps  = 1
nchnls = 1


instr    1 ; Divides Sample1 into equal slices then replays in random order

ilevl    = p4*32767                  ; Output level
irate    = p5                        ; Rate
istep    = p6/2                      ; Number of slices
ileng    = ftsr(1)/ftlen(1)          ; Sample1 length
iseed    = rnd(1)                    ; Generate random seed value

krnd     randh  istep, irate, iseed  ; Generate random steps
krnd     = int(krnd + istep)/istep*2 ; Quantise steps
kramp    oscili  1/irate, irate, 2   ; Generate index ramp
kenv     oscili  1, irate, 3         ; Generate envelope
kind     = (krnd + kramp)*ileng      ; Calculate and scale index
asamp    table3  kind, 1, 1, 0, 1    ; Index Sample1
out      asamp*kenv*ilevl            ; Level, envelope and output

endin

</CsInstruments>
<CsScore>
f1 0 32768 1 "Sample1" 0 4 0 ; Sample
f2 0 8193 -7 0 8192 1             ; Index ramp
f3 0 8193 -7 0 296 1 7600 1 296 0 ; Envelope trapezoid

;   Strt  Leng  Levl  Rate  Steps
i1  0.00  2.00  1.00  3.71  21.0
i1  2.00  .     .     45.7  1000
e


</CsScore>
</CsoundSynthesizer>
