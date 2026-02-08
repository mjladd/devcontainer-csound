<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from cubic3.orc and cubic3.sco
; Original files preserved in same directory

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2



;UNIFIED ORC/SCO FILE EXAMPLE WITH REALTIME FLAGS
; COMPARATION OF DIFFERENT TYPES OF INTERPOLATIONS


          instr     1

a1        oscil3    20000,p4,p5
a2        oscili    20000,p4,p6
          outs      a1,a2

          endin




















</CsInstruments>
<CsScore>
f1 0 4 10 1       ;SINE OF FOUR POINTS TO VIEW INTERPOLATION QUALITY.
f2 0 2 9 1 1 90   ;SINE OF TWO POINTS TO VIEW INTERPOLATION QUALITY.

; FOUR CICLES OF TWO-POINT SINE WITH CUBIC INTERPOLATION
f3 0 8192 8 0 512 1 1024 -1 1024 1 1024 -1 1024 1 1024 -1 1024 1 1024 -1 512 0
; FOUR CICLES OF TWO-POINT SINE WITH CUBIC SPLINE INTERPOLATION
f4 0 8192 8 0 512 1 1024 -1 1024 1 1024 -1 1024 1 1024 -1 1024 1 1024 -1 512 0

i1 0   1 440 1 1
i1 1.5 1 440 2 2
i1 3   1 30 2 3


e

</CsScore>
</CsoundSynthesizer>
