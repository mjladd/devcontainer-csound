<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 15_01_2.orc and 15_01_2.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        15_01_2.ORC
; timbre:       plucked string
; synthesis:    Karplus-Strong algorithm(15)
;               PLUCK with imeth=1 (01)
;               EXPSEG envelope (3)
; coded:        jpg 8/92


instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifq   = p5   ; frequency
ibuf  = p6   ; buffer size
if1   = p7   ; various random number sources are called
imeth = 1    ; simple averaging

      kamp   expseg   iamp,8/10*idur,iamp, 2/10*idur,.0001
      a1     pluck    kamp, ifq, ibuf, if1, imeth
             out      a1
endin


</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     15_01_2.SCO
; coded:     jpg 8/92

; GEN functions **********************************************************

;       size GEN  inputfile             start
f71  0  1024  1   "Sflib/10_02_1.aiff"    .2    0  0         ; fqr = 10000
f72  0  1024  1   "Sflib/10_02_1.aiff"   1.2    0  0         ; fqr =  5000
f73  0  1024  1   "Sflib/10_02_1.aiff"   2.2    0  0         ; fqr =  2500
f74  0  1024  1   "Sflib/10_02_1.aiff"   3.2    0  0         ; fqr =  2000
f75  0  1024  1   "Sflib/10_02_1.aiff"   4.2    0  0         ; fqr =  1000
f76  0  1024  1   "Sflib/10_02_1.aiff"   5.2    0  0         ; fqr =   500
f77  0  1024  1   "Sflib/10_02_1.aiff"   6.2    0  0         ; fqr =   250
f78  0  1024  1   "Sflib/10_02_1.aiff"   7.2    0  0         ; fqr =   125
f79  0  1024  1   "Sflib/10_02_1.aiff"   8.2    0  0         ; fqr =    50
f80  0  1024  1   "Sflib/10_02_1.aiff"   9.2    0  0         ; fqr =    25

; score ******************************************************************
;            iamp    ifq   ibuf  if1
i1   0   1   8000    220   128    0      ; pluck-made random numbers
i1   2   2   .       .     .      0

s

; section 2
;            iamp    ifq   ibuf  if1
i1   1   1   8000    220   128   71      ; random numbers from audio file
i1   3   .   .       .     .     72
i1   5   .   .       .     .     73
i1   7   .   .       .     .     74
i1   9   .   .       .     .     75
i1  11   .   .       .     .     76
i1  13   .   .       .     .     77
i1  15   .   .       .     .     78
i1  17   .   .       .     .     79
i1  19   .   .       .     .     80

s

; section 3: changed ibuf to 1024
;            iamp    ifq   ibuf  if
i1   1   1   8000    220   1024  71
i1   3   .   .       .     .     72
i1   5   .   .       .     .     73
i1   7   .   .       .     .     74
i1   9   .   .       .     .     75
i1  11   .   .       .     .     76
i1  13   .   .       .     .     77
i1  15   .   .       .     .     78
i1  17   .   .       .     .     79
i1  19   .   .       .     .     80

e


</CsScore>
</CsoundSynthesizer>
