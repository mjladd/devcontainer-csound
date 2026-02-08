<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 15_01_1.orc and 15_01_1.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:        15_01_1.ORC
; timbre:       plucked string
; synthesis:    Karplus-Strong algorithm(15)
;               PLUCK with imeth = 1 (01)
;               pluck-made series(f0) versus
;               self-made random numbers(f77) (1)
; coded:        jpg 8/92


instr 1; *****************************************************************
iamp  = p4
ifq   = p5   ; frequency
ibuf  = 128  ; buffer size
if1   = 0    ; f0: PLUCK produces its own random numbers
imeth = 1    ; simple averaging

      a1     pluck    iamp, ifq, ibuf, if1, imeth
             out      a1
endin

instr 2; *****************************************************************
iamp  = p4
ifq   = p5   ; frequency
ibuf  = 128  ; buffer size
if1   = 77   ; f77 contains random numbers from a soundfile
imeth = 1    ; simple averaging

      a1     pluck    iamp, ifq, ibuf, if1, imeth
             out      a1
endin

</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     15_01_1.SCO
; coded:     jpg 8/92


; GEN functions **********************************************************
                                       ; "Sflib/10_02_1.aiff" should exist
f77 0 1024 1 "Sflib/10_02_1.aiff" .2 0 0 ; start reading at .2 sec


; score ******************************************************************

;         iamp    ifq
i1  0  1  8000    220
i1  2  .  .       440

i2  4  1  8000    220
i2  6  .  .       440

e

</CsScore>
</CsoundSynthesizer>
