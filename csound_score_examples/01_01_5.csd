<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
; Converted from 01_01_5.orc and 01_01_5.sco
; Original files preserved in same directory

sr = 44100
kr  =  441
ksmps= 100
nchnls = 1

; ************************************************************************
; ACCCI:      01_01_5.ORC
; synthesis:  simple(01)
;             basic instrument(01),
;             envelope through ENVLPX unit generator(5)
; coded:      jpg 10/93


instr 1; *****************************************************************
idur   = p3
iamp   = p4
ifq    = p5
if1    = p6
irise  = p7
idec   = p8
if2    = p9
iatss  = p10
iatdec = p11

   a2    envlpx   iamp, irise, idur, idec, if2, iatss, iatdec
   a1    oscili   a2, ifq, if1
         out      a1
endin
</CsInstruments>
<CsScore>
; ************************************************************************
; ACCCI:     01_01_5.SCO
; coded:     jpg 10/93

; GEN functions **********************************************************
; carrier
f1 0 512 10 1

; envelope for rise shape
f51 0  513   5    .00195  512  1 ;   exponential increase over 512 points


; score ******************************************************************

;  start  idur  iamp    ifq  if1    irise idec if2 iatss iatdec
i1   0     1    8000   440   1       .2   .3   51   1     .01
i1   2     4    .        .   .       .    .     .   1     .1
i1   7     .    .        .   .       .    .     .   1     .2  ; noisy cut
i1  12     .    .        .   .       .    .     .   1     1.5 ; noisy cut
i1  17     .    .        .   .       .    .     .   2     .01 ; good effect
i1  22     .    .        .   .       .    .     .  .9     .01

s
; section 2: idur = 2 sec
i1   5     1    8000   330   1       .2   .3   51   1     .01
i1   7     2    .        .   .       .    .     .   1     .1
i1  10     .    .        .   .       .    .     .   1     .2   ; noisy cut
i1  13     .    .        .   .       .    .     .   1     1.5  ; noisy cut
i1  16     .    .        .   .       .    .     .   2     .01  ; stress
i1  19     .    .        .   .       .    .     .  .9     .01

e

</CsScore>
</CsoundSynthesizer>
