<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from cstil12.orc and cstil12.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         1

;CSTIL12.ORC DEFINED PITCH-SPACE FILLED WITH GLISSANDO TEXTURES
;USES 13 SCORE PARAMETERS AS FOLLOWS:
;P3 - DURATION
;P4 - AMPIITUDE
;P5 - 1ST PCH, UPPER PITCH TRACE
;P6 - 2ND PCH, UPPER PITCH TRACE
;P7 - 1ST PCH, LOWER PITCH TRACE
;P8 - 2ND PCH, LOWER PITCH TRACE
;P9 - NUMBER OF SWEEPS PER SECOND
;P10 - ENVELOPE RISE TIME
;P11 - ENVELOPE DECAY TIME
;P12 - POINTS TO HATCH TYPE 1 2 OR 3
;P13 - SWITCH FOR 1 (SINGLE) OR 2 (DOUBLE) SWEEP


instr     1
k1        line      cpspch(p5), p3, cpspch(p6)    ;UPPER GHOST LINE
k2        line      cpspch(p7), p3, cpspch(p8)    ;LOWER GHOST LINE
k3        oscili    k1-32, p9, p13,-1             ;P13: 1. IF SINGLESWEEP IS REQ'D
                                                  ;     2. IF DOUBLESWEEP IS REQ'D: 2 IF DOUBLE SWEEP IS REQ'D
k4        =         (k1-k2)-k3                    ;INVERSE (DOWN LINE)
k5        linen     p4, p10, p3, p11              ;ENVELOPE

if p12    = 1       goto uphatch
if p12    = 2       goto downhatch
if p12    = 3       goto mixhatch

uphatch:
a1        oscili    k5, k2+k3, 3, -1
goto      out

downhatch:
a1        oscili    k5, k2+k4, 3, -1
goto      out

mixhatch:
a1        oscili    k5/2, k2+k3, 3, -1
a2        oscili    k5/2, k2+k4, 3, -1
a1        = a1+a2

out:      out       a1
endin

</CsInstruments>
<CsScore>
f1 0 65 7 0 64 1
f2 0 129 7 0 64 1 64 0
f3 0 2048 10 1 .5 .6  0 .4
;PFIELDS
;1   2         3         4         5         6         7         8         9         10        11        12        13

i1   0         1         10000     8.03      8.03  8.00     8.00 4         .02       0         1         2
i1   1         1         10000     8.03      9.03  8.00     9.00 4         0         0         1         2
i1   2         2         10000     9.03      9.03  900 9.00 4         0         .02       1         2
i1   4         1         15000     11.00          8.00  5.00     7.09 12        .02       0         3         1
i1   5         1         15000     8.00      8.00  7.09     7.09 12        0         0         3         1
i1   6         .5        15000     10.00          8.03  6.00     8.00 9         0         0         3         1
i1   6.5         .5      15000     8.03      8.03  8.00     8.00 9         0         .02       3         1
i1   7         .5        20000     9.03      8.09  7.03     8.06 6         .02       0         3         1
i1   7.5       .5        20000     8.09      8.09  8.06     8.06 6         0         .02       3         1
i1   0         8         8000 11.00          7.00 10.00     6.00 1         0.5       0.5       2         1
e

</CsScore>
</CsoundSynthesizer>
