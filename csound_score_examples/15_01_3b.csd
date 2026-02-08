<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 15_01_3b.orc and 15_01_3b.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        15_01_3B.ORC
; timbre:       plucked string
; synthesis:    Karplus-Strong algorithm(15)
;               PLUCK (01)
;               varying duration and frequency on a single buffer (3B)
; coded:        jpg 8/92


instr 1; *****************************************************************
idur  = p3
iamp  = p4
ifq   = p5   ; frequency
ibuf  = p6   ; buffer size
if1   = p7   ; various random number sources are called
imeth = 1    ; simple averaging

      kamp   linseg   iamp,8/10*idur,iamp,2/10*idur,0
      a1     pluck    kamp, ifq, ibuf, if1, imeth
             out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     15_01_3B.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
; "Sflib/10_02_1.aiff" contains random noise with center frequency 'fqr'
; changing each second...

;       size GEN  inputfile            start
f73  0  1024  1   "Sflib/10_02_1.aiff"   2.2     0   0       ; fqr =  2500


; score ******************************************************************

;            iamp    ifq   ibuf  if1
i1   0   1   8000    220   1024  73
i1   1    .1  .     2490   .     .
i1   1.1  .1  .     2200   .     .
i1   1.2  .1  .      235   .     .
i1   2    .5  .     7800   .     .

e



</CsScore>
</CsoundSynthesizer>
