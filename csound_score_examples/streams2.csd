<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from streams2.orc and streams2.sco
; Original files preserved in same directory

sr        =    44100
kr        =    4410
ksmps     =    10
nchnls    =    1


instr 1

     p2             =         p2   +    p9
     amp            oscil     1, 1 / p3, p4
     adens          oscil     1, 1 / p3, p5
     alofr          oscil     1, 1 / p3, p6
     ahifr          oscil     1, 1 / p3, p7
     awind          oscil     amp, adens, p8
     afr            randi     ahifr, adens
     astream        oscil     awind, alofr + afr, 1

     gasig          =         astream / p10
     out gasig
endin

instr 2

     awet reverb gasig, p4
     out awet / p5
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 8 0 512 1 512 0
f3 0 1024 -7 1000 1024 1000
f4 0 1024 -7 0 100 400 100 1000 200 600 500 700 124 200
f5 0 1024 -7 200 1024 200
f6 0 1024 -7 0 224 30000 200 25000 500 25000 100 0

;              revtime   revlevel
;i2  0    10   2         2
;                   fampenv   fdens     flofr     fhifr     fwindow   offset    norm
i1   0    8         6         3         4         5         2         0         6
i1   0    8         .         .         .         .         .         .002 .
e

</CsScore>
</CsoundSynthesizer>
